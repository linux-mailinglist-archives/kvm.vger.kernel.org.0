Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72357241D0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 22:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfETUKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 16:10:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:23437 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfETUKb (ORCPT <rfc822;kvm@vger.kernel.org>);
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
Subject: [PATCH 2/2] Revert "KVM: nVMX: always use early vmcs check when EPT is disabled"
Date:   Mon, 20 May 2019 13:10:29 -0700
Message-Id: <20190520201029.7126-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520201029.7126-1-sean.j.christopherson@intel.com>
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM stuffs vmc01.GUEST_CR3 prior to nested VM-Entry, there is
no need to avoid nested_vmx_restore_host_state() when EPT is disabled
as refreshing vcpu->arch.cr3 from vmcs01.GUEST_CR3 will automagically
obtain the correct value.

This reverts commit 2b27924bb1d48e3775f432b70bdad5e6dd4e7798.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/vmx.h |  1 -
 arch/x86/kvm/vmx/nested.c       | 22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index d213ec5c3766..f0b0c90dd398 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -146,7 +146,6 @@
 
 #define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
 #define VMX_ABORT_LOAD_HOST_PDPTE_FAIL       2
-#define VMX_ABORT_VMCS_CORRUPTED             3
 #define VMX_ABORT_LOAD_HOST_MSR_FAIL         4
 
 #endif /* _UAPIVMX_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 92117092f6e9..c17fbe3cc2fb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3777,18 +3777,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	vmx_set_cr4(vcpu, vmcs_readl(CR4_READ_SHADOW));
 
 	nested_ept_uninit_mmu_context(vcpu);
-
-	/*
-	 * This is only valid if EPT is in use, otherwise the vmcs01 GUEST_CR3
-	 * points to shadow pages!  Fortunately we only get here after a WARN_ON
-	 * if EPT is disabled, so a VMabort is perfectly fine.
-	 */
-	if (enable_ept) {
-		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-		__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
-	} else {
-		nested_vmx_abort(vcpu, VMX_ABORT_VMCS_CORRUPTED);
-	}
+	vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
 
 	/*
 	 * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
@@ -5729,14 +5719,6 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 {
 	int i;
 
-	/*
-	 * Without EPT it is not possible to restore L1's CR3 and PDPTR on
-	 * VMfail, because they are not available in vmcs01.  Just always
-	 * use hardware checks.
-	 */
-	if (!enable_ept)
-		nested_early_check = 1;
-
 	if (!cpu_has_vmx_shadow_vmcs())
 		enable_shadow_vmcs = 0;
 	if (enable_shadow_vmcs) {
-- 
2.21.0

