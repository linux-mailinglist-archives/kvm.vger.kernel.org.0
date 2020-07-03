Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BFC213289
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 06:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgGCEEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 00:04:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:9178 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgGCEE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 00:04:26 -0400
IronPort-SDR: Iuq7oc6dDYlnwGYknM/40ml2xolX0hmIpeM03w/zcq3JnmJo11Fh9tA46nH6wfLFGNpTXXjFL5
 vKQu0Z7Wkqcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="208604067"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="208604067"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 21:04:23 -0700
IronPort-SDR: Q/KdMvKOGpwTXRrxlJ2FH54DTG3o+9WXOLFVKg/WygCplSJHYImhvF234IWvHU/8PNoPS0Pbk1
 pDHQycIha25g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="387520215"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 02 Jul 2020 21:04:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: VMX: Use KVM_POSSIBLE_CR*_GUEST_BITS to initialize guest/host masks
Date:   Thu,  2 Jul 2020 21:04:22 -0700
Message-Id: <20200703040422.31536-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200703040422.31536-1-sean.j.christopherson@intel.com>
References: <20200703040422.31536-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the "common" KVM_POSSIBLE_CR*_GUEST_BITS defines to initialize the
CR0/CR4 guest host masks instead of duplicating most of the CR4 mask and
open coding the CR0 mask.  SVM doesn't utilize the masks, i.e. the masks
are effectively VMX specific even if they're not named as such.  This
avoids duplicate code, better documents the guest owned CR0 bit, and
eliminates the need for a build-time assertion to keep VMX and x86
synchronized.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  4 ++--
 arch/x86/kvm/vmx/vmx.c    | 15 +++++----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d1af20b050a8..b26655104d4a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4109,7 +4109,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
 	 * (KVM doesn't change it);
 	 */
-	vcpu->arch.cr0_guest_owned_bits = X86_CR0_TS;
+	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
 	vmx_set_cr0(vcpu, vmcs12->host_cr0);
 
 	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
@@ -4259,7 +4259,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 */
 	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
 
-	vcpu->arch.cr0_guest_owned_bits = X86_CR0_TS;
+	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
 	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
 
 	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7fc5ca9cb5a0..2a42c86746f7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -133,9 +133,6 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #define KVM_VM_CR0_ALWAYS_ON				\
 	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | 	\
 	 X86_CR0_WP | X86_CR0_PG | X86_CR0_PE)
-#define KVM_CR4_GUEST_OWNED_BITS				      \
-	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR      \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_TSD)
 
 #define KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR4_VMXE
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
@@ -4034,11 +4031,9 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 {
-	BUILD_BUG_ON(KVM_CR4_GUEST_OWNED_BITS & ~KVM_POSSIBLE_CR4_GUEST_BITS);
-
-	vmx->vcpu.arch.cr4_guest_owned_bits = KVM_CR4_GUEST_OWNED_BITS;
-	if (enable_ept)
-		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;
+	vmx->vcpu.arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS;
+	if (!enable_ept)
+		vmx->vcpu.arch.cr4_guest_owned_bits &= ~X86_CR4_PGE;
 	if (is_guest_mode(&vmx->vcpu))
 		vmx->vcpu.arch.cr4_guest_owned_bits &=
 			~get_vmcs12(&vmx->vcpu)->cr4_guest_host_mask;
@@ -4335,8 +4330,8 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
-	vmx->vcpu.arch.cr0_guest_owned_bits = X86_CR0_TS;
-	vmcs_writel(CR0_GUEST_HOST_MASK, ~X86_CR0_TS);
+	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
 
 	set_cr4_guest_host_mask(vmx);
 
-- 
2.26.0

