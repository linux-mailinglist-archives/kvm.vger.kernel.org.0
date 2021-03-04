Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9932CC34
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 06:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhCDF4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 00:56:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:42033 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234339AbhCDF4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 00:56:01 -0500
IronPort-SDR: fCF7//kvCZZIOHFYokHQcOKjsE5ZLLiGn33OsM59AzpFokmDEg9q/Gi8ZMUtdqFFk2KNPNVmny
 45PRe2kKdNFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="272348865"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="272348865"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 21:55:18 -0800
IronPort-SDR: pbxHjRuU74YxtVwbSBylO0NH0GClKDGdkLvRHSHUmvIlE9QVphltD6fF7ozb/QQS7TQY2X/1+M
 sxx/h4p9U5cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="407618090"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2021 21:55:16 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Date:   Thu,  4 Mar 2021 14:07:38 +0800
Message-Id: <20210304060740.11339-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210304060740.11339-1-weijiang.yang@intel.com>
References: <20210304060740.11339-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
read/write them and after they're changed. If CET guest entry-load bit is not
set by L1 guest, migrate them to L2 manaully.

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
index 9728efd529a1..24cace55e1f9 100644
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
@@ -3375,6 +3391,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported() &&
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cet_supported() &&
+		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
+		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
+		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
+		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+	}
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -4001,6 +4023,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_SSP:
+	case GUEST_INTR_SSP_TABLE:
+	case GUEST_S_CET:
 		return true;
 	default:
 		break;
@@ -4052,6 +4077,11 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cet_supported()) {
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

