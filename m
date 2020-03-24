Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC70A190AF9
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCXK3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:29:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44335 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgCXK3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:29:35 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGgoE-0001ho-Az; Tue, 24 Mar 2020 11:29:22 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 95A0F100292; Tue, 24 Mar 2020 11:29:21 +0100 (CET)
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
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of split lock detection
In-Reply-To: <beb9ab5c-a50d-2ec6-1c23-e426508cdf4e@intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com> <20200315050517.127446-2-xiaoyao.li@intel.com> <87zhc7ovhj.fsf@nanos.tec.linutronix.de> <87lfnqq0oo.fsf@nanos.tec.linutronix.de> <beb9ab5c-a50d-2ec6-1c23-e426508cdf4e@intel.com>
Date:   Tue, 24 Mar 2020 11:29:21 +0100
Message-ID: <87tv2edp1a.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:
> On 3/24/2020 4:24 AM, Thomas Gleixner wrote:
>> --- a/arch/x86/kernel/cpu/intel.c
>> +++ b/arch/x86/kernel/cpu/intel.c
>> @@ -45,6 +45,7 @@ enum split_lock_detect_state {
>>    * split lock detect, unless there is a command line override.
>>    */
>>   static enum split_lock_detect_state sld_state = sld_off;
>> +static DEFINE_PER_CPU(u64, msr_test_ctrl_cache);
>
> I used percpu cache in v3, but people prefer Tony's cache for reserved 
> bits[1].
>
> If you prefer percpu cache, I'll use it in next version.

I'm fine with the single variable.

>>   static void __init split_lock_setup(void)
>>   {
>>   	char arg[20];
>>   	int i, ret;
>>   
>> +	if (!split_lock_verify_msr(true) || !split_lock_verify_msr(false)) {
>> +		pr_info("MSR access failed: Disabled\n");
>> +		return;
>> +	}
>> +
>
> I did similar thing like this in my v3, however Sean raised concern that 
> toggling MSR bit before parsing kernel param is bad behavior. [2]

That's trivial enough to fix.

Thanks,

        tglx

8<---------------
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -44,7 +44,8 @@ enum split_lock_detect_state {
  * split_lock_setup() will switch this to sld_warn on systems that support
  * split lock detect, unless there is a command line override.
  */
-static enum split_lock_detect_state sld_state = sld_off;
+static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
+static u64 msr_test_ctrl_cache __ro_after_init;
 
 /*
  * Processors which have self-snooping capability can handle conflicting
@@ -984,78 +985,85 @@ static inline bool match_option(const ch
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
+	enum split_lock_detect_state state = sld_warn;
 	char arg[20];
 	int i, ret;
 
-	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
-	sld_state = sld_warn;
+	if (!split_lock_verify_msr(false)) {
+		pr_info("MSR access failed: Disabled\n");
+		return;
+	}
 
 	ret = cmdline_find_option(boot_command_line, "split_lock_detect",
 				  arg, sizeof(arg));
 	if (ret >= 0) {
 		for (i = 0; i < ARRAY_SIZE(sld_options); i++) {
 			if (match_option(arg, ret, sld_options[i].option)) {
-				sld_state = sld_options[i].state;
+				state = sld_options[i].state;
 				break;
 			}
 		}
 	}
 
-	switch (sld_state) {
+	switch (state) {
 	case sld_off:
 		pr_info("disabled\n");
-		break;
-
+		return;
 	case sld_warn:
 		pr_info("warning about user-space split_locks\n");
 		break;
-
 	case sld_fatal:
 		pr_info("sending SIGBUS on user-space split_locks\n");
 		break;
 	}
+
+	rdmsrl(MSR_TEST_CTRL, msr_test_ctrl_cache);
+
+	if (!split_lock_verify_msr(true)) {
+		pr_info("MSR access failed: Disabled\n");
+		return;
+	}
+
+	sld_state = state;
+	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
 }
 
 /*
- * Locking is not required at the moment because only bit 29 of this
- * MSR is implemented and locking would not prevent that the operation
- * of one thread is immediately undone by the sibling thread.
- * Use the "safe" versions of rdmsr/wrmsr here because although code
- * checks CPUID and MSR bits to make sure the TEST_CTRL MSR should
- * exist, there may be glitches in virtualization that leave a guest
- * with an incorrect view of real h/w capabilities.
+ * MSR_TEST_CTRL is per core, but we treat it like a per CPU MSR. Locking
+ * is not implemented as one thread could undo the setting of the other
+ * thread immediately after dropping the lock anyway.
  */
-static bool __sld_msr_set(bool on)
+static void sld_update_msr(bool on)
 {
-	u64 test_ctrl_val;
-
-	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
-		return false;
+	u64 ctrl = msr_test_ctrl_cache;
 
 	if (on)
-		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
-	else
-		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
-
-	return !wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val);
+		ctrl |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	wrmsrl(MSR_TEST_CTRL, ctrl);
 }
 
 static void split_lock_init(void)
 {
-	if (sld_state == sld_off)
-		return;
-
-	if (__sld_msr_set(true))
-		return;
-
-	/*
-	 * If this is anything other than the boot-cpu, you've done
-	 * funny things and you get to keep whatever pieces.
-	 */
-	pr_warn("MSR fail -- disabled\n");
-	sld_state = sld_off;
+	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		sld_update_msr(sld_state != sld_off);
 }
 
 bool handle_user_split_lock(struct pt_regs *regs, long error_code)
@@ -1071,7 +1079,7 @@ bool handle_user_split_lock(struct pt_re
 	 * progress and set TIF_SLD so the detection is re-enabled via
 	 * switch_to_sld() when the task is scheduled out.
 	 */
-	__sld_msr_set(false);
+	sld_update_msr(false);
 	set_tsk_thread_flag(current, TIF_SLD);
 	return true;
 }
@@ -1085,7 +1093,7 @@ bool handle_user_split_lock(struct pt_re
  */
 void switch_to_sld(unsigned long tifn)
 {
-	__sld_msr_set(!(tifn & _TIF_SLD));
+	sld_update_msr(!(tifn & _TIF_SLD));
 }
 
 #define SPLIT_LOCK_CPU(model) {X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY}
