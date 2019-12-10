Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0BA119F50
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 00:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLJXYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 18:24:36 -0500
Received: from mga17.intel.com ([192.55.52.151]:23344 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfLJXYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 18:24:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 15:24:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="210583772"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 10 Dec 2019 15:24:35 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH 2/2] KVM: VMX: Add helper to consolidate up PT/RTIT WRMSR fault logic
Date:   Tue, 10 Dec 2019 15:24:33 -0800
Message-Id: <20191210232433.4071-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210232433.4071-1-sean.j.christopherson@intel.com>
References: <20191210232433.4071-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to consolidate the common checks for writing PT MSRs,
and opportunistically clean up the formatting of the affected code.

No functional change intended.

Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 55 ++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9aa2006dbe04..22e05e3fb0a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1057,6 +1057,12 @@ static unsigned long segment_base(u16 selector)
 }
 #endif
 
+static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
+{
+	return (pt_mode == PT_MODE_HOST_GUEST) &&
+	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
+}
+
 static inline void pt_load_msr(struct pt_ctx *ctx, u32 addr_range)
 {
 	u32 i;
@@ -2110,47 +2116,48 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		pt_update_intercept_for_msr(vmx);
 		break;
 	case MSR_IA32_RTIT_STATUS:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
-			(data & MSR_IA32_RTIT_STATUS_MASK))
+		if (!pt_can_write_msr(vmx))
+			return 1;
+		if (data & MSR_IA32_RTIT_STATUS_MASK)
 			return 1;
 		vmx->pt_desc.guest.status = data;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
-			!intel_pt_validate_cap(vmx->pt_desc.caps,
-						PT_CAP_cr3_filtering))
+		if (!pt_can_write_msr(vmx))
+			return 1;
+		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
+					   PT_CAP_cr3_filtering))
 			return 1;
 		vmx->pt_desc.guest.cr3_match = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
-			(!intel_pt_validate_cap(vmx->pt_desc.caps,
-					PT_CAP_topa_output) &&
-			 !intel_pt_validate_cap(vmx->pt_desc.caps,
-					PT_CAP_single_range_output)) ||
-			(data & MSR_IA32_RTIT_OUTPUT_BASE_MASK))
+		if (!pt_can_write_msr(vmx))
+			return 1;
+		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
+					   PT_CAP_topa_output) &&
+		    !intel_pt_validate_cap(vmx->pt_desc.caps,
+					   PT_CAP_single_range_output))
+			return 1;
+		if (data & MSR_IA32_RTIT_OUTPUT_BASE_MASK)
 			return 1;
 		vmx->pt_desc.guest.output_base = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
-			(!intel_pt_validate_cap(vmx->pt_desc.caps,
-					PT_CAP_topa_output) &&
-			 !intel_pt_validate_cap(vmx->pt_desc.caps,
-					PT_CAP_single_range_output)))
+		if (!pt_can_write_msr(vmx))
+			return 1;
+		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
+					   PT_CAP_topa_output) &&
+		    !intel_pt_validate_cap(vmx->pt_desc.caps,
+					   PT_CAP_single_range_output))
 			return 1;
 		vmx->pt_desc.guest.output_mask = data;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
+		if (!pt_can_write_msr(vmx))
+			return 1;
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
-			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
-					PT_CAP_num_address_ranges)))
+		if (index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
+						       PT_CAP_num_address_ranges))
 			return 1;
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
-- 
2.24.0

