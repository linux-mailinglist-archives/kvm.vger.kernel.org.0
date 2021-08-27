Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FFA3F94C5
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244385AbhH0HEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:04:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:6124 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244360AbhH0HER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:04:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205045908"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="205045908"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:03:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495553108"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2021 00:03:13 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: VMX: Disallow PT MSRs accessing if PT is not exposed to guest
Date:   Fri, 27 Aug 2021 15:02:47 +0800
Message-Id: <20210827070249.924633-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210827070249.924633-1-xiaoyao.li@intel.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per SDM, it triggers #GP for all the accessing of PT MSRs, if
X86_FEATURE_INTEL_PT is not available.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v2:
 - allow userspace/host access regradless of PT bit, (Sean)
---
 arch/x86/kvm/vmx/vmx.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b9d640029c40..394ef4732838 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1007,10 +1007,21 @@ static unsigned long segment_base(u16 selector)
 }
 #endif
 
-static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
+static inline bool pt_can_write_msr(struct vcpu_vmx *vmx,
+				    struct msr_data *msr_info)
 {
 	return vmx_pt_mode_is_host_guest() &&
-	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
+	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) &&
+	       (msr_info->host_initiated ||
+		guest_cpuid_has(&vmx->vcpu, X86_FEATURE_INTEL_PT));
+}
+
+static inline bool pt_can_read_msr(struct kvm_vcpu *vcpu,
+				   struct msr_data *msr_info)
+{
+	return vmx_pt_mode_is_host_guest() &&
+	       (msr_info->host_initiated ||
+		guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT));
 }
 
 static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
@@ -1852,24 +1863,24 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 							&msr_info->data);
 		break;
 	case MSR_IA32_RTIT_CTL:
-		if (!vmx_pt_mode_is_host_guest())
+		if (!pt_can_read_msr(vcpu, msr_info))
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.ctl;
 		break;
 	case MSR_IA32_RTIT_STATUS:
-		if (!vmx_pt_mode_is_host_guest())
+		if (!pt_can_read_msr(vcpu, msr_info))
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.status;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu, msr_info) ||
 			!intel_pt_validate_cap(vmx->pt_desc.caps,
 						PT_CAP_cr3_filtering))
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.cr3_match;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu, msr_info) ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
@@ -1878,7 +1889,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vmx->pt_desc.guest.output_base;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu, msr_info) ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
@@ -1888,7 +1899,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
-		if (!vmx_pt_mode_is_host_guest() ||
+		if (!pt_can_read_msr(vcpu, msr_info) ||
 		    (index >= 2 * vmx->pt_desc.nr_addr_ranges))
 			return 1;
 		if (index % 2)
@@ -2156,6 +2167,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest() ||
+		    !guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT) ||
 			vmx_rtit_ctl_check(vcpu, data) ||
 			vmx->nested.vmxon)
 			return 1;
@@ -2164,14 +2176,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		pt_update_intercept_for_msr(vcpu);
 		break;
 	case MSR_IA32_RTIT_STATUS:
-		if (!pt_can_write_msr(vmx))
+		if (!pt_can_write_msr(vmx, msr_info))
 			return 1;
 		if (data & MSR_IA32_RTIT_STATUS_MASK)
 			return 1;
 		vmx->pt_desc.guest.status = data;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
-		if (!pt_can_write_msr(vmx))
+		if (!pt_can_write_msr(vmx, msr_info))
 			return 1;
 		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_cr3_filtering))
@@ -2179,7 +2191,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->pt_desc.guest.cr3_match = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
-		if (!pt_can_write_msr(vmx))
+		if (!pt_can_write_msr(vmx, msr_info))
 			return 1;
 		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_topa_output) &&
@@ -2191,7 +2203,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->pt_desc.guest.output_base = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
-		if (!pt_can_write_msr(vmx))
+		if (!pt_can_write_msr(vmx, msr_info))
 			return 1;
 		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_topa_output) &&
@@ -2201,7 +2213,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->pt_desc.guest.output_mask = data;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
-		if (!pt_can_write_msr(vmx))
+		if (!pt_can_write_msr(vmx, msr_info))
 			return 1;
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if (index >= 2 * vmx->pt_desc.nr_addr_ranges)
-- 
2.27.0

