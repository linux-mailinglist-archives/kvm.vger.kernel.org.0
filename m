Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010B9153F2A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 08:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgBFHJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 02:09:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:56103 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgBFHJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 02:09:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 23:09:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="scan'208";a="231957208"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga003.jf.intel.com with ESMTP; 05 Feb 2020 23:09:23 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 2/8] x86/split_lock: Ensure X86_FEATURE_SPLIT_LOCK_DETECT means the existence of feature
Date:   Thu,  6 Feb 2020 15:04:06 +0800
Message-Id: <20200206070412.17400-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206070412.17400-1-xiaoyao.li@intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When flag X86_FEATURE_SPLIT_LOCK_DETECT is set, it should ensure the
existence of MSR_TEST_CTRL and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 41 +++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2b3874a96bd4..49535ed81c22 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -702,7 +702,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (tsx_ctrl_state == TSX_CTRL_DISABLE)
 		tsx_disable();
 
-	split_lock_init();
+	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		split_lock_init();
 }
 
 #ifdef CONFIG_X86_32
@@ -986,9 +987,26 @@ static inline bool match_option(const char *arg, int arglen, const char *opt)
 
 static void __init split_lock_setup(void)
 {
+	u64 test_ctrl_val;
 	char arg[20];
 	int i, ret;
 
+	/*
+	 * Use the "safe" versions of rdmsr/wrmsr here to ensure MSR_TEST_CTRL
+	 * and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit do exist. Because there may
+	 * be glitches in virtualization that leave a guest with an incorrect
+	 * view of real h/w capabilities.
+	 */
+	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
+		return;
+
+	if (wrmsrl_safe(MSR_TEST_CTRL,
+			test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
+		return;
+
+	if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val))
+		return;
+
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
 	sld_state = sld_warn;
 
@@ -1022,24 +1040,19 @@ static void __init split_lock_setup(void)
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
 
 static void split_lock_init(void)
@@ -1047,15 +1060,7 @@ static void split_lock_init(void)
 	if (sld_state == sld_off)
 		return;
 
-	if (__sld_msr_set(true))
-		return;
-
-	/*
-	 * If this is anything other than the boot-cpu, you've done
-	 * funny things and you get to keep whatever pieces.
-	 */
-	pr_warn("MSR fail -- disabled\n");
-	sld_state = sld_off;
+	__sld_msr_set(true);
 }
 
 bool handle_user_split_lock(unsigned long ip)
-- 
2.23.0

