Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A685EC0D8A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 23:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfI0Vp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 17:45:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:45951 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfI0Vp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 17:45:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 14:45:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="196852063"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 14:45:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 3/8] KVM: VMX: Consolidate to_vmx() usage in RFLAGS accessors
Date:   Fri, 27 Sep 2019 14:45:18 -0700
Message-Id: <20190927214523.3376-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190927214523.3376-1-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture struct vcpu_vmx in a local variable to improve the readability
of vmx_{g,s}et_rflags().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0b8dd9c315f8..83fe8b02b732 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1407,35 +1407,37 @@ static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
 
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long rflags, save_rflags;
 
 	if (!test_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail)) {
 		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
 		rflags = vmcs_readl(GUEST_RFLAGS);
-		if (to_vmx(vcpu)->rmode.vm86_active) {
+		if (vmx->rmode.vm86_active) {
 			rflags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
-			save_rflags = to_vmx(vcpu)->rmode.save_rflags;
+			save_rflags = vmx->rmode.save_rflags;
 			rflags |= save_rflags & ~RMODE_GUEST_OWNED_EFLAGS_BITS;
 		}
-		to_vmx(vcpu)->rflags = rflags;
+		vmx->rflags = rflags;
 	}
-	return to_vmx(vcpu)->rflags;
+	return vmx->rflags;
 }
 
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long old_rflags = vmx_get_rflags(vcpu);
 
 	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
-	to_vmx(vcpu)->rflags = rflags;
-	if (to_vmx(vcpu)->rmode.vm86_active) {
-		to_vmx(vcpu)->rmode.save_rflags = rflags;
+	vmx->rflags = rflags;
+	if (vmx->rmode.vm86_active) {
+		vmx->rmode.save_rflags = rflags;
 		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
 	}
 	vmcs_writel(GUEST_RFLAGS, rflags);
 
-	if ((old_rflags ^ to_vmx(vcpu)->rflags) & X86_EFLAGS_VM)
-		to_vmx(vcpu)->emulation_required = emulation_required(vcpu);
+	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
+		vmx->emulation_required = emulation_required(vcpu);
 }
 
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
-- 
2.22.0

