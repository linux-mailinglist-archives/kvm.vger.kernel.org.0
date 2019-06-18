Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CB34AE2A
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbfFRWvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:51:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:48878 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730953AbfFRWvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009381"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:12 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 13/17] x86/split_lock: Disable split lock detection by kernel parameter "nosplit_lock_detect"
Date:   Tue, 18 Jun 2019 15:41:15 -0700
Message-Id: <1560897679-228028-14-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To work around or debug split lock issues, the kernel parameter
"nosplit_lock_detect" is introduced to disable the feature during boot
time.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  2 ++
 arch/x86/kernel/cpu/intel.c                   | 22 ++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 138f6664b2e2..bcf578a1bc77 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3086,6 +3086,8 @@
 
 	nosoftlockup	[KNL] Disable the soft-lockup detector.
 
+	nosplit_lock_detect	[X86] Disable split lock detection
+
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	nowatchdog	[KNL] Disable both lockup detectors, i.e.
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 4ccd890a45b0..4a854f051cf4 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -19,6 +19,7 @@
 #include <asm/microcode_intel.h>
 #include <asm/hwcap2.h>
 #include <asm/elf.h>
+#include <asm/cmdline.h>
 
 #ifdef CONFIG_X86_64
 #include <linux/topology.h>
@@ -34,6 +35,8 @@
 DEFINE_PER_CPU(u64, msr_test_ctl_cached);
 EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cached);
 
+static bool split_lock_detect_enabled;
+
 /*
  * Just in case our CPU detection goes bad, or you have a weird system,
  * allow a way to override the automatic disabling of MPX.
@@ -629,8 +632,13 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 
 static void split_lock_update_msr(void)
 {
-	/* Enable split lock detection */
-	this_cpu_or(msr_test_ctl_cached, MSR_TEST_CTL_SPLIT_LOCK_DETECT);
+	if (split_lock_detect_enabled) {
+		/* Enable split lock detection */
+		this_cpu_or(msr_test_ctl_cached, MSR_TEST_CTL_SPLIT_LOCK_DETECT);
+	} else {
+		/* Disable split lock detection */
+		this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
+	}
 	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
 }
 
@@ -1027,7 +1035,15 @@ cpu_dev_register(intel_cpu_dev);
 static void __init split_lock_setup(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
-	pr_info("enabled\n");
+
+	if (cmdline_find_option_bool(boot_command_line,
+				     "nosplit_lock_detect")) {
+		split_lock_detect_enabled = false;
+		pr_info("disabled\n");
+	} else {
+		split_lock_detect_enabled = true;
+		pr_info("enabled\n");
+	}
 }
 
 void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
-- 
2.19.1

