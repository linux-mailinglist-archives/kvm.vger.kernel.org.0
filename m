Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E213EE9E3
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 11:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbhHQJcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 05:32:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:49582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhHQJcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 05:32:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238111510"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238111510"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:31:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="449200712"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2021 02:31:33 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v1 2/5] KVM: x86: nVMX: Update VMCS12 fields existence when nVMX MSRs are set
Date:   Tue, 17 Aug 2021 17:31:10 +0800
Message-Id: <1629192673-9911-3-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 125b94dc3cf1..b8121f8f6d96 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1262,6 +1262,34 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 
 	*lowp = data;
 	*highp = data >> 32;
+
+	switch (msr_index) {
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
+		vmcs12_field_update_by_pinbased_ctrl(*highp,
+				data >> 32,
+				vmx->nested.vmcs12_field_existence_bitmap);
+		break;
+	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
+		vmcs12_field_update_by_procbased_ctrl(*highp,
+				data >> 32,
+				vmx->nested.vmcs12_field_existence_bitmap);
+		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS2:
+		vmcs12_field_update_by_procbased_ctrl2(*highp,
+				data >> 32,
+				vmx->nested.vmcs12_field_existence_bitmap);
+		break;
+	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
+		vmcs12_field_update_by_vmexit_ctrl(vmx->nested.msrs.entry_ctls_high,
+				*highp, data >> 32,
+				vmx->nested.vmcs12_field_existence_bitmap);
+		break;
+	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
+		vmcs12_field_update_by_vmentry_ctrl(vmx->nested.msrs.exit_ctls_high,
+				*highp, data >> 32,
+				vmx->nested.vmcs12_field_existence_bitmap);
+		break;
+	}
 	return 0;
 }
 
@@ -1403,6 +1431,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_VMFUNC:
 		if (data & ~vmx->nested.msrs.vmfunc_controls)
 			return -EINVAL;
+		vmcs12_field_update_by_vm_func(vmx->nested.msrs.vmfunc_controls,
+				data, vmx->nested.vmcs12_field_existence_bitmap);
 		vmx->nested.msrs.vmfunc_controls = data;
 		return 0;
 	default:
-- 
2.27.0

