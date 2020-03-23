Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6999E18FF42
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 21:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgCWUY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 16:24:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42768 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgCWUY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 16:24:57 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGTcm-0006Yi-2v; Mon, 23 Mar 2020 21:24:40 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 2D0391040AA; Mon, 23 Mar 2020 21:24:39 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of split lock detection
In-Reply-To: <87zhc7ovhj.fsf@nanos.tec.linutronix.de>
References: <20200315050517.127446-1-xiaoyao.li@intel.com> <20200315050517.127446-2-xiaoyao.li@intel.com> <87zhc7ovhj.fsf@nanos.tec.linutronix.de>
Date:   Mon, 23 Mar 2020 21:24:39 +0100
Message-ID: <87lfnqq0oo.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>
>> Current initialization flow of split lock detection has following issues:
>> 1. It assumes the initial value of MSR_TEST_CTRL.SPLIT_LOCK_DETECT to be
>>    zero. However, it's possible that BIOS/firmware has set it.
>
> Ok.
>
>> 2. X86_FEATURE_SPLIT_LOCK_DETECT flag is unconditionally set even if
>>    there is a virtualization flaw that FMS indicates the existence while
>>    it's actually not supported.
>>
>> 3. Because of #2, KVM cannot rely on X86_FEATURE_SPLIT_LOCK_DETECT flag
>>    to check verify if feature does exist, so cannot expose it to
>>    guest.
>
> Sorry this does not make anny sense. KVM is the hypervisor, so it better
> can rely on the detect flag. Unless you talk about nested virt and a
> broken L1 hypervisor.
>
>> To solve these issues, introducing a new sld_state, "sld_not_exist",
>> as
>
> The usual naming convention is sld_not_supported.

But this extra state is not needed at all, it already exists:

    X86_FEATURE_SPLIT_LOCK_DETECT

You just need to make split_lock_setup() a bit smarter. Soemthing like
the below. It just wants to be split into separate patches.

Thanks,

        tglx
---
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -45,6 +45,7 @@ enum split_lock_detect_state {
  * split lock detect, unless there is a command line override.
  */
 static enum split_lock_detect_state sld_state = sld_off;
+static DEFINE_PER_CPU(u64, msr_test_ctrl_cache);
 
 /*
  * Processors which have self-snooping capability can handle conflicting
@@ -984,11 +985,32 @@ static inline bool match_option(const ch
 	return len == arglen && !strncmp(arg, opt, len);
 }
 
+static bool __init split_lock_verify_msr(bool on)
+{
+	u64 ctrl, tmp;
+
+	if (rdmsrl_safe(MSR_TEST_CTRL, &ctrl))
+		return false;
+	if (on)
+		ctrl |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	else
+		ctrl &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	if (wrmsrl_safe(MSR_TEST_CTRL, ctrl))
+		return false;
+	rdmsrl(MSR_TEST_CTRL, tmp);
+	return ctrl == tmp;
+}
+
 static void __init split_lock_setup(void)
 {
 	char arg[20];
 	int i, ret;
 
+	if (!split_lock_verify_msr(true) || !split_lock_verify_msr(false)) {
+		pr_info("MSR access failed: Disabled\n");
+		return;
+	}
+
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
 	sld_state = sld_warn;
 
@@ -1007,7 +1029,6 @@ static void __init split_lock_setup(void
 	case sld_off:
 		pr_info("disabled\n");
 		break;
-
 	case sld_warn:
 		pr_info("warning about user-space split_locks\n");
 		break;
@@ -1018,44 +1039,40 @@ static void __init split_lock_setup(void
 	}
 }
 
-/*
- * Locking is not required at the moment because only bit 29 of this
- * MSR is implemented and locking would not prevent that the operation
- * of one thread is immediately undone by the sibling thread.
- * Use the "safe" versions of rdmsr/wrmsr here because although code
- * checks CPUID and MSR bits to make sure the TEST_CTRL MSR should
- * exist, there may be glitches in virtualization that leave a guest
- * with an incorrect view of real h/w capabilities.
- */
-static bool __sld_msr_set(bool on)
+static void split_lock_init(void)
 {
-	u64 test_ctrl_val;
+	u64 ctrl;
 
-	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
-		return false;
+	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		return;
 
-	if (on)
-		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	rdmsrl(MSR_TEST_CTRL, ctrl);
+	if (sld_state == sld_off)
+		ctrl &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
 	else
-		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
-
-	return !wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val);
+		ctrl |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	wrmsrl(MSR_TEST_CTRL, ctrl);
+	this_cpu_write(msr_test_ctrl_cache, ctrl);
 }
 
-static void split_lock_init(void)
+/*
+ * MSR_TEST_CTRL is per core, but we treat it like a per CPU MSR. Locking
+ * is not implemented as one thread could undo the setting of the other
+ * thread immediately after dropping the lock anyway.
+ */
+static void msr_test_ctrl_update(bool on, u64 mask)
 {
-	if (sld_state == sld_off)
-		return;
+	u64 tmp, ctrl = this_cpu_read(msr_test_ctrl_cache);
 
-	if (__sld_msr_set(true))
-		return;
+	if (on)
+		tmp = ctrl | mask;
+	else
+		tmp = ctrl & ~mask;
 
-	/*
-	 * If this is anything other than the boot-cpu, you've done
-	 * funny things and you get to keep whatever pieces.
-	 */
-	pr_warn("MSR fail -- disabled\n");
-	sld_state = sld_off;
+	if (tmp != ctrl) {
+		wrmsrl(MSR_TEST_CTRL, ctrl);
+		this_cpu_write(msr_test_ctrl_cache, ctrl);
+	}
 }
 
 bool handle_user_split_lock(struct pt_regs *regs, long error_code)
@@ -1071,7 +1088,7 @@ bool handle_user_split_lock(struct pt_re
 	 * progress and set TIF_SLD so the detection is re-enabled via
 	 * switch_to_sld() when the task is scheduled out.
 	 */
-	__sld_msr_set(false);
+	msr_test_ctrl_update(false, MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
 	set_tsk_thread_flag(current, TIF_SLD);
 	return true;
 }
@@ -1085,7 +1102,7 @@ bool handle_user_split_lock(struct pt_re
  */
 void switch_to_sld(unsigned long tifn)
 {
-	__sld_msr_set(!(tifn & _TIF_SLD));
+	msr_test_ctrl_update(!(tifn & _TIF_SLD), MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
 }
 
 #define SPLIT_LOCK_CPU(model) {X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY}


