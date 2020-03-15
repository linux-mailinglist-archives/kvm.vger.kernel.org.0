Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C84185A2E
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 06:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgCOFW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 01:22:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:47872 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgCOFWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Mar 2020 01:22:55 -0400
IronPort-SDR: JcdQ7hEigbK7k7y2UMeM4ge9xNObCXa6QFBvUuwy5J9fjrtYUXD/eT4NlyamLpxfzaSud34sMW
 4KIyYqFPwLfg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 22:22:54 -0700
IronPort-SDR: 5ZZBy/ze+bNVXCPSicXdAZR15vF4VahmFUoNh2WCQiNTZLac3pcO/zbZG7pkJW+Zejf3TM8hP5
 192nc8WwOmYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,555,1574150400"; 
   d="scan'208";a="267194204"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2020 22:22:51 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of split lock detection
Date:   Sun, 15 Mar 2020 13:05:09 +0800
Message-Id: <20200315050517.127446-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200315050517.127446-1-xiaoyao.li@intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current initialization flow of split lock detection has following issues:
1. It assumes the initial value of MSR_TEST_CTRL.SPLIT_LOCK_DETECT to be
   zero. However, it's possible that BIOS/firmware has set it.

2. X86_FEATURE_SPLIT_LOCK_DETECT flag is unconditionally set even if
   there is a virtualization flaw that FMS indicates the existence while
   it's actually not supported.

3. Because of #2, KVM cannot rely on X86_FEATURE_SPLIT_LOCK_DETECT flag
   to check verify if feature does exist, so cannot expose it to guest.

To solve these issues, introducing a new sld_state, "sld_not_exist", as
the default value. It will be switched to other value if CORE_CAPABILITIES
or FMS enumerate split lock detection.

Only when sld_state != sld_not_exist, it goes to initialization flow.

In initialization flow, it explicitly accesses MSR_TEST_CTRL and
SPLIT_LOCK_DETECT bit to ensure there is no virtualization flaw, i.e.,
feature split lock detection does supported. In detail,
 1. sld_off,   verify SPLIT_LOCK_DETECT bit can be cleared, and clear it;
 2. sld_warn,  verify SPLIT_LOCK_DETECT bit can be cleared and set,
               and set it;
 3. sld_fatal, verify SPLIT_LOCK_DETECT bit can be set, and set it;

Only when no MSR aceessing failure, can X86_FEATURE_SPLIT_LOCK_DETECT be
set. So kvm can use X86_FEATURE_SPLIT_LOCK_DETECT to check the existence
of feature.

Also, since MSR and bit are checked when split_lock_init(), there
is no need to use safe version RDMSR/WRMSR at runtime.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 64 +++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index db3e745e5d47..064ba12defc8 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -34,17 +34,17 @@
 #endif
 
 enum split_lock_detect_state {
-	sld_off = 0,
+	sld_not_exist = 0,
+	sld_off,
 	sld_warn,
 	sld_fatal,
 };
 
 /*
- * Default to sld_off because most systems do not support split lock detection
  * split_lock_setup() will switch this to sld_warn on systems that support
  * split lock detect, unless there is a command line override.
  */
-static enum split_lock_detect_state sld_state = sld_off;
+static enum split_lock_detect_state sld_state = sld_not_exist;
 
 /*
  * Processors which have self-snooping capability can handle conflicting
@@ -585,7 +585,7 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
-static void split_lock_init(void);
+static void split_lock_init(struct cpuinfo_x86 *c);
 
 static void init_intel(struct cpuinfo_x86 *c)
 {
@@ -702,7 +702,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (tsx_ctrl_state == TSX_CTRL_DISABLE)
 		tsx_disable();
 
-	split_lock_init();
+	if (sld_state != sld_not_exist)
+		split_lock_init(c);
 }
 
 #ifdef CONFIG_X86_32
@@ -989,7 +990,6 @@ static void __init split_lock_setup(void)
 	char arg[20];
 	int i, ret;
 
-	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
 	sld_state = sld_warn;
 
 	ret = cmdline_find_option(boot_command_line, "split_lock_detect",
@@ -1015,6 +1015,8 @@ static void __init split_lock_setup(void)
 	case sld_fatal:
 		pr_info("sending SIGBUS on user-space split_locks\n");
 		break;
+	default:
+		break;
 	}
 }
 
@@ -1022,39 +1024,61 @@ static void __init split_lock_setup(void)
  * Locking is not required at the moment because only bit 29 of this
  * MSR is implemented and locking would not prevent that the operation
  * of one thread is immediately undone by the sibling thread.
- * Use the "safe" versions of rdmsr/wrmsr here because although code
- * checks CPUID and MSR bits to make sure the TEST_CTRL MSR should
- * exist, there may be glitches in virtualization that leave a guest
- * with an incorrect view of real h/w capabilities.
  */
-static bool __sld_msr_set(bool on)
+static void __sld_msr_set(bool on)
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
 
-static void split_lock_init(void)
+/*
+ * Use the "safe" versions of rdmsr/wrmsr here because although code
+ * checks CPUID and MSR bits to make sure the TEST_CTRL MSR should
+ * exist, there may be glitches in virtualization that leave a guest
+ * with an incorrect view of real h/w capabilities.
+ * If not msr_broken, then it needn't use "safe" version at runtime.
+ */
+static void split_lock_init(struct cpuinfo_x86 *c)
 {
-	if (sld_state == sld_off)
-		return;
+	u64 test_ctrl_val;
 
-	if (__sld_msr_set(true))
-		return;
+	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
+		goto msr_broken;
+
+	switch (sld_state) {
+	case sld_off:
+		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
+			goto msr_broken;
+		break;
+	case sld_warn:
+		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
+			goto msr_broken;
+		fallthrough;
+	case sld_fatal:
+		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
+			goto msr_broken;
+		break;
+	default:
+		break;
+	}
+
+	set_cpu_cap(c, X86_FEATURE_SPLIT_LOCK_DETECT);
+	return;
 
+msr_broken:
 	/*
 	 * If this is anything other than the boot-cpu, you've done
 	 * funny things and you get to keep whatever pieces.
 	 */
-	pr_warn("MSR fail -- disabled\n");
+	pr_warn_once("MSR fail -- disabled\n");
 	sld_state = sld_off;
 }
 
-- 
2.20.1

