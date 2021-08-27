Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF13F94BE
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244339AbhH0HEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:04:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:6107 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244307AbhH0HD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:03:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205045891"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="205045891"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:03:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495553038"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2021 00:03:07 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: VMX: Rename pt_desc.addr_range to pt_desc.nr_addr_range
Date:   Fri, 27 Aug 2021 15:02:45 +0800
Message-Id: <20210827070249.924633-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210827070249.924633-1-xiaoyao.li@intel.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To better self explain the meaning of this field.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96a2df65678f..c54b99cec0e6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1059,8 +1059,8 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
 		wrmsrl(MSR_IA32_RTIT_CTL, 0);
-		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
-		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
+		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.nr_addr_ranges);
+		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.nr_addr_ranges);
 	}
 }
 
@@ -1070,8 +1070,8 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 		return;
 
 	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
-		pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
-		pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
+		pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.nr_addr_ranges);
+		pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.nr_addr_ranges);
 	}
 
 	/*
@@ -1460,16 +1460,16 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	 * cause a #GP fault.
 	 */
 	value = (data & RTIT_CTL_ADDR0) >> RTIT_CTL_ADDR0_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 1)) || (value > 2))
+	if ((value && (vmx->pt_desc.nr_addr_ranges < 1)) || (value > 2))
 		return 1;
 	value = (data & RTIT_CTL_ADDR1) >> RTIT_CTL_ADDR1_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 2)) || (value > 2))
+	if ((value && (vmx->pt_desc.nr_addr_ranges < 2)) || (value > 2))
 		return 1;
 	value = (data & RTIT_CTL_ADDR2) >> RTIT_CTL_ADDR2_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 3)) || (value > 2))
+	if ((value && (vmx->pt_desc.nr_addr_ranges < 3)) || (value > 2))
 		return 1;
 	value = (data & RTIT_CTL_ADDR3) >> RTIT_CTL_ADDR3_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 4)) || (value > 2))
+	if ((value && (vmx->pt_desc.nr_addr_ranges < 4)) || (value > 2))
 		return 1;
 
 	return 0;
@@ -1889,7 +1889,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if (!vmx_pt_mode_is_host_guest() ||
-		    (index >= 2 * vmx->pt_desc.addr_range))
+		    (index >= 2 * vmx->pt_desc.nr_addr_ranges))
 			return 1;
 		if (index % 2)
 			msr_info->data = vmx->pt_desc.guest.addr_b[index / 2];
@@ -2204,7 +2204,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!pt_can_write_msr(vmx))
 			return 1;
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
-		if (index >= 2 * vmx->pt_desc.addr_range)
+		if (index >= 2 * vmx->pt_desc.nr_addr_ranges)
 			return 1;
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
@@ -3880,7 +3880,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_BASE, MSR_TYPE_RW, flag);
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_MASK, MSR_TYPE_RW, flag);
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_CR3_MATCH, MSR_TYPE_RW, flag);
-	for (i = 0; i < vmx->pt_desc.addr_range; i++) {
+	for (i = 0; i < vmx->pt_desc.nr_addr_ranges; i++) {
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
 	}
@@ -7113,7 +7113,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 	}
 
 	/* Get the number of configurable Address Ranges for filtering */
-	vmx->pt_desc.addr_range = intel_pt_validate_cap(vmx->pt_desc.caps,
+	vmx->pt_desc.nr_addr_ranges = intel_pt_validate_cap(vmx->pt_desc.caps,
 						PT_CAP_num_address_ranges);
 
 	/* Initialize and clear the no dependency bits */
@@ -7161,7 +7161,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~RTIT_CTL_FABRIC_EN;
 
 	/* unmask address range configure area */
-	for (i = 0; i < vmx->pt_desc.addr_range; i++)
+	for (i = 0; i < vmx->pt_desc.nr_addr_ranges; i++)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4858c5fd95f2..f48eafbbed0e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -62,7 +62,7 @@ struct pt_ctx {
 
 struct pt_desc {
 	u64 ctl_bitmask;
-	u32 addr_range;
+	u32 nr_addr_ranges;
 	u32 caps[PT_CPUID_REGS_NUM * PT_CPUID_LEAVES];
 	struct pt_ctx host;
 	struct pt_ctx guest;
-- 
2.27.0

