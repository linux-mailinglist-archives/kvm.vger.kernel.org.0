Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BE733ABFB
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 08:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhCOHGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 03:06:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:59702 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhCOHG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 03:06:26 -0400
IronPort-SDR: GPMsrYpQpKu7SdupJcctCf1X9yye/QBMA0jz8PSugieMOAAqJGkG+eEKwhsMbGT8R+ioMbAPAT
 pWS0jpskx3sQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="176640934"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="176640934"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:06:26 -0700
IronPort-SDR: dlQhWXWFZPiwXGCgMkwz8ZsmHCPlJGFFDhDvDzqL/61KHOTP7RGhNna7+P2zF6Qaja89WvSfDN
 5sb9D8so6A3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="604749544"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2021 00:06:24 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Date:   Mon, 15 Mar 2021 15:18:39 +0800
Message-Id: <20210315071841.7045-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210315071841.7045-1-weijiang.yang@intel.com>
References: <20210315071841.7045-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
read/write them and after they're changed. If CET guest entry-load bit is not
set by L1 guest, migrate them to L2 manaully.

Opportunistically remove one blank line and add minor fix for MPX.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c      |  1 -
 arch/x86/kvm/vmx/nested.c | 35 +++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 3 files changed, 36 insertions(+), 3 deletions(-)

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
index 9728efd529a1..57ecd8225568 100644
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
@@ -3373,8 +3389,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
-		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cet_supported() &&
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
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
@@ -4050,8 +4075,14 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
-	if (kvm_mpx_supported())
+	if (kvm_mpx_supported() && guest_cpuid_has(vcpu, X86_FEATURE_MPX))
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

