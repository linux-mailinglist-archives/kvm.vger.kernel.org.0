Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756911676D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfEGQGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:42085 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbfEGQGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 09:06:44 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2019 09:06:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 15/15] KVM: nVMX: Copy PDPTRs to/from vmcs12 only when necessary
Date:   Tue,  7 May 2019 09:06:40 -0700
Message-Id: <20190507160640.4812-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel's SDM:

  ... the logical processor uses PAE paging if CR0.PG=1, CR4.PAE=1 and
  IA32_EFER.LME=0.  A VM entry to a guest that uses PAE paging loads the
  PDPTEs into internal, non-architectural registers based on the setting
  of the "enable EPT" VM-execution control.

and:

  [GUEST_PDPTR] values are saved into the four PDPTE fields as follows:

    - If the "enable EPT" VM-execution control is 0 or the logical
      processor was not using PAE paging at the time of the VM exit,
      the values saved are undefined.

In other words, if EPT is disabled or the guest isn't using PAE paging,
then the PDPTRS aren't consumed by hardware on VM-Entry and are loaded
with junk on VM-Exit.  From a nesting perspective, all of the above hold
true, i.e. KVM can effectively ignore the VMCS PDPTRs.  E.g. KVM already
loads the PDPTRs from memory when nested EPT is disabled (see
nested_vmx_load_cr3()).

Because KVM intercepts setting CR4.PAE, there is no danger of consuming
a stale value or crushing L1's VMWRITEs regardless of whether L1
intercepts CR4.PAE. The vmcs12's values are unchanged up until the
VM-Exit where L2 sets CR4.PAE, i.e. L0 will see the new PAE state on the
subsequent VM-Entry and propagate the PDPTRs from vmcs12 to vmcs02.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cfdc04fde8eb..b8bd446b2c8b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2184,17 +2184,6 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_SYSENTER_ESP, vmcs12->guest_sysenter_esp);
 		vmcs_writel(GUEST_SYSENTER_EIP, vmcs12->guest_sysenter_eip);
 
-		/*
-		 * L1 may access the L2's PDPTR, so save them to construct
-		 * vmcs12
-		 */
-		if (enable_ept) {
-			vmcs_write64(GUEST_PDPTR0, vmcs12->guest_pdptr0);
-			vmcs_write64(GUEST_PDPTR1, vmcs12->guest_pdptr1);
-			vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
-			vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
-		}
-
 		if (vmx->nested.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 			vmcs_write64(GUEST_IA32_DEBUGCTL,
@@ -2256,10 +2245,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
+	bool load_guest_pdptrs_vmcs12 = false;
 
 	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
 		prepare_vmcs02_full(vmx, vmcs12);
 		vmx->nested.dirty_vmcs12 = false;
+
+		load_guest_pdptrs_vmcs12 = !vmx->nested.hv_evmcs ||
+			!(vmx->nested.hv_evmcs->hv_clean_fields &
+			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
 	/*
@@ -2366,6 +2360,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		return -EINVAL;
 	}
 
+	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
+	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
+	    !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
+		vmcs_write64(GUEST_PDPTR0, vmcs12->guest_pdptr0);
+		vmcs_write64(GUEST_PDPTR1, vmcs12->guest_pdptr1);
+		vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
+		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
+	}
+
 	/* Shadow page tables on either EPT or shadow page tables. */
 	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
 				entry_failure_code))
@@ -3467,10 +3470,13 @@ static void sync_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	 */
 	if (enable_ept) {
 		vmcs12->guest_cr3 = vmcs_readl(GUEST_CR3);
-		vmcs12->guest_pdptr0 = vmcs_read64(GUEST_PDPTR0);
-		vmcs12->guest_pdptr1 = vmcs_read64(GUEST_PDPTR1);
-		vmcs12->guest_pdptr2 = vmcs_read64(GUEST_PDPTR2);
-		vmcs12->guest_pdptr3 = vmcs_read64(GUEST_PDPTR3);
+		if (nested_cpu_has_ept(vmcs12) && !is_long_mode(vcpu) &&
+		    is_pae(vcpu) && is_paging(vcpu)) {
+			vmcs12->guest_pdptr0 = vmcs_read64(GUEST_PDPTR0);
+			vmcs12->guest_pdptr1 = vmcs_read64(GUEST_PDPTR1);
+			vmcs12->guest_pdptr2 = vmcs_read64(GUEST_PDPTR2);
+			vmcs12->guest_pdptr3 = vmcs_read64(GUEST_PDPTR3);
+		}
 	}
 
 	vmcs12->guest_linear_address = vmcs_readl(GUEST_LINEAR_ADDRESS);
-- 
2.21.0

