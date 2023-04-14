Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBABE6E1C99
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 08:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjDNG1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 02:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDNG1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 02:27:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6F66A59;
        Thu, 13 Apr 2023 23:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681453639; x=1712989639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8sK+0MDZYXGtoHWYbzHrAKJFEM49kp0e7HluyJtG+4w=;
  b=Ir+rypxLbEwRCZHLfXnC1yZzW42Z36jWtSyyUM0yKJjPRLiz0BuMjSgg
   lAFOkSoGF9bsoqhg304VrbUuAGb8rkQZDtp3SBXbVB6kJ7Ym15Pc0VPfT
   p3tvGHxORqzbKKkZX3w1JzizH6CxIjG7iLtB0QnP0dxm4G/gGANsP/98Z
   lA6bfjFzZw0Hj9U62cRn7JNqJ4thiadNsF7JEZrZzcRvauGgkQb7sb8x9
   Pm2UF/h6zWKHp34CcKeKvZdacPak1cYITPueBU2tNKc3KPLnChoCN7oDV
   iJmh1RSB7n1Pfa6R8Er0p4VYAly0gey2zLcxXb2giFyU581DlcPtf/6NJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341892780"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341892780"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="935885911"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="935885911"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:22 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Babu Moger <babu.moger@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 05/11] x86/bugs: Use Virtual MSRs to request hardware mitigations
Date:   Fri, 14 Apr 2023 14:25:26 +0800
Message-Id: <20230414062545.270178-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414062545.270178-1-chao.gao@intel.com>
References: <20230414062545.270178-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Guests that have different family/model than the host may not be aware
of hardware mitigations(such as RRSBA_DIS_S) available on host. This is
particularly true when guests migrate. To solve this problem Intel
processors have added a virtual MSR interface through which guests can
report their mitigation status and request VMM to deploy relevant
hardware mitigations.

Use this virtualized MSR interface to request relevant hardware controls
for retpoline mitigation.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Co-developed-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Jiaan Lu <jiaan.lu@intel.com>
---
 arch/x86/include/asm/msr-index.h | 25 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/bugs.c       | 25 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 60b25d87b82c..aec213f0c6fc 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -166,6 +166,7 @@
 						 * IA32_XAPIC_DISABLE_STATUS MSR
 						 * supported
 						 */
+#define ARCH_CAP_VIRTUAL_ENUM		BIT_ULL(63) /* MSR_VIRTUAL_ENUMERATION supported */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
@@ -1103,6 +1104,30 @@
 #define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
 #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
 #define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
+
+/* Intel virtual MSRs */
+#define MSR_VIRTUAL_ENUMERATION			0x50000000
+#define VIRT_ENUM_MITIGATION_CTRL_SUPPORT	BIT(0)	/*
+							 * Mitigation ctrl via virtual
+							 * MSRs supported
+							 */
+
+#define MSR_VIRTUAL_MITIGATION_ENUM		0x50000001
+#define MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT	BIT(0)	/* VMM supports BHI_DIS_S */
+#define MITI_ENUM_RETPOLINE_S_SUPPORT		BIT(1)	/* VMM supports RRSBA_DIS_S */
+
+#define MSR_VIRTUAL_MITIGATION_CTRL		0x50000002
+#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT	0	/*
+							 * Request VMM to deploy
+							 * BHI_DIS_S mitigation
+							 */
+#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED		BIT(MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT)
+#define MITI_CTRL_RETPOLINE_S_USED_BIT		1	/*
+							 * Request VMM to deploy
+							 * RRSBA_DIS_S mitigation
+							 */
+#define MITI_CTRL_RETPOLINE_S_USED		BIT(MITI_CTRL_RETPOLINE_S_USED_BIT)
+
 /* AMD-V MSRs */
 
 #define MSR_VM_CR                       0xc0010114
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index f9d060e71c3e..5326c03d9d5e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1435,6 +1435,27 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	dump_stack();
 }
 
+/* Speculation control using virtualized MSRs */
+static void spec_ctrl_setup_virtualized_msr(void)
+{
+	u64 msr_virt_enum, msr_mitigation_enum;
+
+	/* When retpoline is being used, request relevant hardware controls */
+	if (!boot_cpu_has(X86_FEATURE_RETPOLINE))
+		return;
+
+	if (!(x86_read_arch_cap_msr() & ARCH_CAP_VIRTUAL_ENUM))
+		return;
+
+	rdmsrl(MSR_VIRTUAL_ENUMERATION, msr_virt_enum);
+	if (!(msr_virt_enum & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+		return;
+
+	rdmsrl(MSR_VIRTUAL_MITIGATION_ENUM, msr_mitigation_enum);
+	if (msr_mitigation_enum & MITI_ENUM_RETPOLINE_S_SUPPORT)
+		msr_set_bit(MSR_VIRTUAL_MITIGATION_CTRL, MITI_CTRL_RETPOLINE_S_USED_BIT);
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1546,6 +1567,8 @@ static void __init spectre_v2_select_mitigation(void)
 	    mode == SPECTRE_V2_RETPOLINE)
 		spec_ctrl_disable_kernel_rrsba();
 
+	spec_ctrl_setup_virtualized_msr();
+
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
@@ -2115,6 +2138,8 @@ void x86_spec_ctrl_setup_ap(void)
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
+
+	spec_ctrl_setup_virtualized_msr();
 }
 
 bool itlb_multihit_kvm_mitigation;
-- 
2.40.0

