Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10A5191501
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgCXPj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:39:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:40198 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgCXPhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:09 -0400
IronPort-SDR: q0Nu+ay6Gnp2A1EGMtqJlCc2vU3iiYrlb512VlI65MQjA+vZTV0+l24tpK7t5xYaWMvTGQ7+OK
 VbOVmaOgkOag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 08:37:08 -0700
IronPort-SDR: i0KfPbMarrj8fNxr1Zrrv+OyGWx6fEUmJk4/fvNl2XBTgyXnHNCrp92he/waQswwyaXk/47/th
 rtv8Xlfyuxqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="393319675"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.39])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2020 08:37:04 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 1/8] x86/split_lock: Rework the initialization flow of split lock detection
Date:   Tue, 24 Mar 2020 23:18:52 +0800
Message-Id: <20200324151859.31068-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324151859.31068-1-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current initialization flow of split lock detection has following
issues:

1. It assumes the initial value of MSR_TEST_CTRL.SPLIT_LOCK_DETECT to be
   zero. However, it's possible that BIOS/firmware has set it.

2. X86_FEATURE_SPLIT_LOCK_DETECT flag is unconditionally set even if
   there is a virtualization flaw that FMS indicates the existence while
   it's actually not supported.

3. Because of #2, for nest virt, L1 KVM cannot rely on flag
   X86_FEATURE_SPLIT_LOCK_DETECT to check the existence of feature.

Rework the initialization flow to solve above issues. In detail,
explicitly set and clear split_lock_detect bit to verify MSR_TEST_CTRL
can be accessed, and rdmsr after wrmsr to ensure bit is set
successfully.

X86_FEATURE_SPLIT_LOCK_DETECT flag is set only when the feature does
exist and the feature is not disabled with kernel param
"split_lock_detect=off"

Originally-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 79 +++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index db3e745e5d47..a0a7d0ec170a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -44,7 +44,7 @@ enum split_lock_detect_state {
  * split_lock_setup() will switch this to sld_warn on systems that support
  * split lock detect, unless there is a command line override.
  */
-static enum split_lock_detect_state sld_state = sld_off;
+static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
 
 /*
  * Processors which have self-snooping capability can handle conflicting
@@ -984,78 +984,91 @@ static inline bool match_option(const char *arg, int arglen, const char *opt)
 	return len == arglen && !strncmp(arg, opt, len);
 }
 
+static bool __init split_lock_verify_msr(bool on)
+{
+	u64 ctrl, tmp;
+
+	if (rdmsrl_safe(MSR_TEST_CTRL, &ctrl))
+		return false;
+
+	if (on)
+		ctrl |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	else
+		ctrl &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+
+	if (wrmsrl_safe(MSR_TEST_CTRL, ctrl))
+		return false;
+
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
 	u64 test_ctrl_val;
 
-	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
-		return false;
+	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
 
 	if (on)
 		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
 	else
 		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
 
-	return !wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val);
+	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
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
@@ -1071,7 +1084,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 	 * progress and set TIF_SLD so the detection is re-enabled via
 	 * switch_to_sld() when the task is scheduled out.
 	 */
-	__sld_msr_set(false);
+	sld_update_msr(false);
 	set_tsk_thread_flag(current, TIF_SLD);
 	return true;
 }
@@ -1085,7 +1098,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
  */
 void switch_to_sld(unsigned long tifn)
 {
-	__sld_msr_set(!(tifn & _TIF_SLD));
+	sld_update_msr(!(tifn & _TIF_SLD));
 }
 
 #define SPLIT_LOCK_CPU(model) {X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY}
-- 
2.20.1

