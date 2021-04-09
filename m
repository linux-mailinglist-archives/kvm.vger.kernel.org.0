Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CF0359584
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 08:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhDIGcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 02:32:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:32004 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231540AbhDIGcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 02:32:14 -0400
IronPort-SDR: hP7gFGqUVH58SYo4ZY3hC5BPX0H9QN8TPVTykCvQK8VEGLqHwyD87cP1dQRh4uLGJEtUDuMhE1
 CwJ9R8cH0PUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="173178633"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="173178633"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 23:31:28 -0700
IronPort-SDR: P626zOnQb/jlEwz9PPcruxNNAnXgmuZhIMZMa1mZ7OmwtLuQREleq5Tetr4nWPIqDlijoENy4p
 mAWMoGjVHLPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="380538728"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by orsmga003.jf.intel.com with ESMTP; 08 Apr 2021 23:31:26 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Date:   Fri,  9 Apr 2021 14:43:43 +0800
Message-Id: <20210409064345.31497-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210409064345.31497-1-weijiang.yang@intel.com>
References: <20210409064345.31497-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
read/write them and after they're changed. If CET guest entry-load bit is not
set by L1 guest, migrate them to L2 manaully.

Opportunistically remove one blank line in previous patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c      |  1 -
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d191de769093..8692f53b8cd0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -143,7 +143,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		}
 		vcpu->arch.guest_supported_xss =
 			(((u64)best->edx << 32) | best->ecx) & supported_xss;
-
 	} else {
 		vcpu->arch.guest_supported_xss = 0;
 	}
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9728efd529a1..87beb1c034e1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2516,6 +2516,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
 	set_cr4_guest_host_mask(vmx);
+
+	if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
+	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
+		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
+		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
+	}
 }
 
 /*
@@ -2556,6 +2563,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
+
+	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))) {
+		vmcs_writel(GUEST_SSP, vmx->nested.vmcs01_guest_ssp);
+		vmcs_writel(GUEST_S_CET, vmx->nested.vmcs01_guest_s_cet);
+		vmcs_writel(GUEST_INTR_SSP_TABLE,
+			    vmx->nested.vmcs01_guest_ssp_tbl);
+	}
+
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
@@ -3375,6 +3391,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported() &&
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cet_supported() && !vmx->nested.nested_run_pending) {
+		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
+		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
+		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+	}
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -4001,6 +4022,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_SSP:
+	case GUEST_INTR_SSP_TABLE:
+	case GUEST_S_CET:
 		return true;
 	default:
 		break;
@@ -4052,6 +4076,12 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cet_supported() && (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))) {
+		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
+		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
+		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+	}
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d3a557949ac..36dc4fdb0909 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -155,6 +155,9 @@ struct nested_vmx {
 	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
 	u64 vmcs01_debugctl;
 	u64 vmcs01_guest_bndcfgs;
+	u64 vmcs01_guest_ssp;
+	u64 vmcs01_guest_s_cet;
+	u64 vmcs01_guest_ssp_tbl;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.26.2

