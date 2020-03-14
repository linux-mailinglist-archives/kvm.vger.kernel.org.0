Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45C3185898
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgCOCNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:13:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:41895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbgCOCNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:38 -0400
IronPort-SDR: O/d525jcUaqxMiDOAY5ir7Zg2qZJBWPKz2sXqbkhieS17Y5e+Y455nnbMBFvQDK8nzXrEV+/Th
 w9yh+JhL0bVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:51:51 -0700
IronPort-SDR: gsLoapCDm/VkIs7QUR8QRXIruDq/iLRJeTJMWr7AV+UhI/AJ8c4tU46gimiHbGp5eAkTEqYfPm
 v5Vfsz8hconA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537529"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:51:47 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 01/10] x86/split_lock: Rework the initialization flow of split lock detection
Date:   Sat, 14 Mar 2020 15:34:05 +0800
Message-Id: <20200314073414.184213-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200314073414.184213-1-xiaoyao.li@intel.com>
References: <20200314073414.184213-1-xiaoyao.li@intel.com>
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

Introducing a new sld_state, "sld_not_exist", which is set as the
default value. Only when sld_state != sld_not_exist, it goes to
initialization flow.

In initialization flow, it explicitly accesses MSR_TEST_CTRL and
SPLIT_LOCK_DETECT bit to ensure there is no virtualization flaw.
In detail,
 1. sld_off,   verify SPLIT_LOCK_DETECT bit can be cleared, and clear it;
 2. sld_warn,  verify SPLIT_LOCK_DETECT bit can be cleared and set,
               and set it;
 3. sld_fatal, verify SPLIT_LOCK_DETECT bit can be set, and set it;

Only when no MSR aceessing failure, can X86_FEATURE_SPLIT_LOCK_DETECT be
set. Also, this can avoid using safe version RDMSR/WRMSR at runtime.

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

