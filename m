Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755C33F5CDE
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbhHXLJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:09:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:3711 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236759AbhHXLJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:09:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204423855"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204423855"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 04:08:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="493501681"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2021 04:08:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: VMX: Disallow PT MSRs accessing if PT is not exposed to guest
Date:   Tue, 24 Aug 2021 19:07:42 +0800
Message-Id: <20210824110743.531127-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210824110743.531127-1-xiaoyao.li@intel.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per SDM, it triggers #GP for all the accessing of PT MSRs, if
X86_FEATURE_INTEL_PT is not available.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4a70a6d2f442..1bbc4d84c623 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1010,9 +1010,16 @@ static unsigned long segment_base(u16 selector)
 static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
 {
 	return vmx_pt_mode_is_host_guest() &&
+	       guest_cpuid_has(&vmx->vcpu, X86_FEATURE_INTEL_PT) &&
 	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
 }
 
+static inline bool pt_can_read_msr(struct kvm_vcpu *vcpu)
+{
+	return vmx_pt_mode_is_host_guest() &&
+	       guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT);
+}
+
 static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
 {
 	/* The base must be 128-byte aligned and a legal physical address. */
@@ -1849,24 +1856,24 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 							&msr_info->data);
 		break;
 	case MSR_IA32_RTIT_CTL:
-		if (!vmx_pt_mode_is_host_guest())
+		if (!pt_can_read_msr(vcpu))
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.ctl;
 		break;
 	case MSR_IA32_RTIT_STATUS:
-		if (!vmx_pt_mode_is_host_guest())
+		if (!pt_can_read_msr(vcpu))
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.status;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu) ||
 			!intel_pt_validate_cap(vmx->pt_desc.caps,
 						PT_CAP_cr3_filtering))
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.cr3_match;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu) ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
@@ -1875,7 +1882,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vmx->pt_desc.guest.output_base;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu) ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
@@ -1885,7 +1892,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu) ||
 			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_num_address_ranges)))
 			return 1;
@@ -2154,6 +2161,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest() ||
+		    !guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT) ||
 			vmx_rtit_ctl_check(vcpu, data) ||
 			vmx->nested.vmxon)
 			return 1;
-- 
2.27.0

