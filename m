Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26B9241CE
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 22:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfETUKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 16:10:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:23437 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfETUKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 16:10:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 13:10:30 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 20 May 2019 13:10:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on nested entry w/o EPT
Date:   Mon, 20 May 2019 13:10:28 -0700
Message-Id: <20190520201029.7126-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520201029.7126-1-sean.j.christopherson@intel.com>
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM does not have 100% coverage of VMX consistency checks, i.e. some
checks that cause VM-Fail may only be detected by hardware during a
nested VM-Entry.  In such a case, KVM must restore L1's state to the
pre-VM-Enter state as L2's state has already been loaded into KVM's
software model.

L1's CR3 and PDPTRs in particular are loaded from vmcs01.GUEST_*.  But
when EPT is disabled, the associated fields hold KVM's shadow values,
not L1's "real" values.  Fortunately, when EPT is disabled the PDPTRs
come from memory, i.e. are not cached in the VMCS.  Which leaves CR3
as the sole anomaly.  Handle CR3 by overwriting vmcs01.GUEST_CR3 with
L1's CR3 during the nested VM-Entry when EPT is disabled *and* nested
early checks are disabled, so that nested_vmx_restore_host_state() will
naturally restore the correct vcpu->arch.cr3 from vmcs01.GUEST_CR3.

Note, these shenanigans work because nested_vmx_restore_host_state()
does a full kvm_mmu_reset_context(), i.e. unloads the current MMU,
which guarantees vmcs01.GUEST_CR3 will be rewritten with a new shadow
CR3 prior to re-entering L1.  Writing vmcs01.GUEST_CR3 is done if and
only if nested early checks are disabled as "late" VM-Fail should never
happen in that case (KVM WARNs), and the conditional write avoids the
need to restore the correct GUEST_CR3 when nested_vmx_check_vmentry_hw()
fails.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: bd18bffca353 ("KVM: nVMX: restore host state in nested_vmx_vmexit for VMFail")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1032f068f0b9..92117092f6e9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2963,6 +2963,8 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	if (kvm_mpx_supported() &&
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (!enable_ept && !nested_early_check)
+		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
 
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
 
@@ -3794,7 +3796,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 * VMFail, like everything else we just need to ensure our
 	 * software model is up-to-date.
 	 */
-	ept_save_pdptrs(vcpu);
+	if (enable_ept)
+		ept_save_pdptrs(vcpu);
 
 	kvm_mmu_reset_context(vcpu);
 
-- 
2.21.0

