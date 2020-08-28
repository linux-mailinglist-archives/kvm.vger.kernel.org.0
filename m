Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8872556F4
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgH1IzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:55:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:49191 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgH1IyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 04:54:21 -0400
IronPort-SDR: XJjZ/IAD0YSSErSMaVHvXfuKY5L+Qrok7171A1nJvolnFX+Zk5KcdUpPf2NxJUrur13qtya8Ke
 Sp/zcK2dnLGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136697508"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="136697508"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:54:20 -0700
IronPort-SDR: dj1I0Fccu511nN12IEgtnl2d/YmRfCVGonFWeUxYx2KUfgzOAKNgFLoHUwDEt9PI+PdpctKBHX
 P0o9RQvJSvZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="332483501"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2020 01:54:17 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: nVMX: Verify the VMX controls MSRs with the global capability when setting VMX MSRs
Date:   Fri, 28 Aug 2020 16:56:19 +0800
Message-Id: <20200828085622.8365-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828085622.8365-1-chenyi.qiang@intel.com>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When setting the nested VMX MSRs, verify it with the values in
vmcs_config.nested_vmx_msrs, which reflects the global capability of
VMX controls MSRs.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 71 ++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6e0e71f4d45f..47bee53e235a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1234,7 +1234,7 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
 		/* reserved */
 		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
-	u64 vmx_basic = vmx->nested.msrs.basic;
+	u64 vmx_basic = vmcs_config.nested.basic;
 
 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
 		return -EINVAL;
@@ -1265,24 +1265,24 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 
 	switch (msr_index) {
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
-		lowp = &vmx->nested.msrs.pinbased_ctls_low;
-		highp = &vmx->nested.msrs.pinbased_ctls_high;
+		lowp = &vmcs_config.nested.pinbased_ctls_low;
+		highp = &vmcs_config.nested.pinbased_ctls_high;
 		break;
 	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
-		lowp = &vmx->nested.msrs.procbased_ctls_low;
-		highp = &vmx->nested.msrs.procbased_ctls_high;
+		lowp = &vmcs_config.nested.procbased_ctls_low;
+		highp = &vmcs_config.nested.procbased_ctls_high;
 		break;
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		lowp = &vmx->nested.msrs.exit_ctls_low;
-		highp = &vmx->nested.msrs.exit_ctls_high;
+		lowp = &vmcs_config.nested.exit_ctls_low;
+		highp = &vmcs_config.nested.exit_ctls_high;
 		break;
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		lowp = &vmx->nested.msrs.entry_ctls_low;
-		highp = &vmx->nested.msrs.entry_ctls_high;
+		lowp = &vmcs_config.nested.entry_ctls_low;
+		highp = &vmcs_config.nested.entry_ctls_high;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		lowp = &vmx->nested.msrs.secondary_ctls_low;
-		highp = &vmx->nested.msrs.secondary_ctls_high;
+		lowp = &vmcs_config.nested.secondary_ctls_low;
+		highp = &vmcs_config.nested.secondary_ctls_high;
 		break;
 	default:
 		BUG();
@@ -1298,8 +1298,30 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
 		return -EINVAL;
 
-	*lowp = data;
-	*highp = data >> 32;
+	switch (msr_index) {
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
+		vmx->nested.msrs.pinbased_ctls_low = data;
+		vmx->nested.msrs.pinbased_ctls_high = data >> 32;
+		break;
+	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
+		vmx->nested.msrs.procbased_ctls_low = data;
+		vmx->nested.msrs.procbased_ctls_high = data >> 32;
+		break;
+	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
+		vmx->nested.msrs.exit_ctls_low = data;
+		vmx->nested.msrs.exit_ctls_high = data >> 32;
+		break;
+	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
+		vmx->nested.msrs.entry_ctls_low = data;
+		vmx->nested.msrs.entry_ctls_high = data >> 32;
+		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS2:
+		vmx->nested.msrs.secondary_ctls_low = data;
+		vmx->nested.msrs.secondary_ctls_high = data >> 32;
+		break;
+	default:
+		BUG();
+	}
 	return 0;
 }
 
@@ -1313,8 +1335,8 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 		GENMASK_ULL(13, 9) | BIT_ULL(31);
 	u64 vmx_misc;
 
-	vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
-				   vmx->nested.msrs.misc_high);
+	vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
+				   vmcs_config.nested.misc_high);
 
 	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
 		return -EINVAL;
@@ -1344,8 +1366,8 @@ static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
 {
 	u64 vmx_ept_vpid_cap;
 
-	vmx_ept_vpid_cap = vmx_control_msr(vmx->nested.msrs.ept_caps,
-					   vmx->nested.msrs.vpid_caps);
+	vmx_ept_vpid_cap = vmx_control_msr(vmcs_config.nested.ept_caps,
+					   vmcs_config.nested.vpid_caps);
 
 	/* Every bit is either reserved or a feature bit. */
 	if (!is_bitwise_subset(vmx_ept_vpid_cap, data, -1ULL))
@@ -1362,10 +1384,10 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 
 	switch (msr_index) {
 	case MSR_IA32_VMX_CR0_FIXED0:
-		msr = &vmx->nested.msrs.cr0_fixed0;
+		msr = &vmcs_config.nested.cr0_fixed0;
 		break;
 	case MSR_IA32_VMX_CR4_FIXED0:
-		msr = &vmx->nested.msrs.cr4_fixed0;
+		msr = &vmcs_config.nested.cr4_fixed0;
 		break;
 	default:
 		BUG();
@@ -1378,7 +1400,16 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	if (!is_bitwise_subset(data, *msr, -1ULL))
 		return -EINVAL;
 
-	*msr = data;
+	switch (msr_index) {
+	case MSR_IA32_VMX_CR0_FIXED0:
+		vmx->nested.msrs.cr0_fixed0 = data;
+		break;
+	case MSR_IA32_VMX_CR4_FIXED0:
+		vmx->nested.msrs.cr4_fixed0 = data;
+		break;
+	default:
+		BUG();
+	}
 	return 0;
 }
 
-- 
2.17.1

