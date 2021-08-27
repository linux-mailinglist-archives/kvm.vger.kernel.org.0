Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF3A3F94C8
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbhH0HE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:04:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:6132 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244378AbhH0HEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:04:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205045925"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="205045925"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:03:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495553148"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2021 00:03:18 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] KVM: VMX: Only context switch some PT MSRs when they exist
Date:   Fri, 27 Aug 2021 15:02:49 +0800
Message-Id: <20210827070249.924633-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210827070249.924633-1-xiaoyao.li@intel.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The enumeration of Intel PT feature doesn't guarantee the existence of
MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK and
MSR_IA32_RTIT_CR3_MATCH. They need to be detected from CPUID 0x14 PT
leaves.

Detect the existence of them in hardware_setup() and only context switch
them when they exist. Otherwise it will cause #GP when access them.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 394ef4732838..6819fc470072 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -204,6 +204,9 @@ module_param(ple_window_max, uint, 0444);
 int __read_mostly pt_mode = PT_MODE_SYSTEM;
 module_param(pt_mode, int, S_IRUGO);
 
+static bool has_msr_rtit_cr3_match;
+static bool has_msr_rtit_output_x;
+
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
 static DEFINE_MUTEX(vmx_l1d_flush_mutex);
@@ -1035,9 +1038,12 @@ static inline void pt_load_msr(struct pt_ctx *ctx, u32 addr_range)
 	u32 i;
 
 	wrmsrl(MSR_IA32_RTIT_STATUS, ctx->status);
-	wrmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
-	wrmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
-	wrmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
+	if (has_msr_rtit_output_x) {
+		wrmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
+		wrmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
+	}
+	if (has_msr_rtit_cr3_match)
+		wrmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
 	for (i = 0; i < addr_range; i++) {
 		wrmsrl(MSR_IA32_RTIT_ADDR0_A + i * 2, ctx->addr_a[i]);
 		wrmsrl(MSR_IA32_RTIT_ADDR0_B + i * 2, ctx->addr_b[i]);
@@ -1049,9 +1055,12 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
 	u32 i;
 
 	rdmsrl(MSR_IA32_RTIT_STATUS, ctx->status);
-	rdmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
-	rdmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
-	rdmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
+	if (has_msr_rtit_output_x) {
+		rdmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
+		rdmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
+	}
+	if (has_msr_rtit_cr3_match)
+		rdmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
 	for (i = 0; i < addr_range; i++) {
 		rdmsrl(MSR_IA32_RTIT_ADDR0_A + i * 2, ctx->addr_a[i]);
 		rdmsrl(MSR_IA32_RTIT_ADDR0_B + i * 2, ctx->addr_b[i]);
@@ -7883,8 +7892,13 @@ static __init int hardware_setup(void)
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
 		return -EINVAL;
-	if (!enable_ept || !cpu_has_vmx_intel_pt())
+	if (!enable_ept || !cpu_has_vmx_intel_pt()) {
 		pt_mode = PT_MODE_SYSTEM;
+	} else if (boot_cpu_has(X86_FEATURE_INTEL_PT)) {
+		has_msr_rtit_cr3_match = intel_pt_validate_hw_cap(PT_CAP_cr3_filtering);
+		has_msr_rtit_output_x = intel_pt_validate_hw_cap(PT_CAP_topa_output) ||
+					intel_pt_validate_hw_cap(PT_CAP_single_range_output);
+	}
 
 	setup_default_sgx_lepubkeyhash();
 
-- 
2.27.0

