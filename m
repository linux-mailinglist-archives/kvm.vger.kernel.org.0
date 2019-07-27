Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF09776FF
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfG0FxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728303AbfG0FwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568611"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 11/21] KVM: x86: Export kvm_propagate_fault (as kvm_propagate_page_fault)
Date:   Fri, 26 Jul 2019 22:52:04 -0700
Message-Id: <20190727055214.9282-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support for SGX Launch Control requires KVM to trap and execute
ENCLS[EINIT] on behalf of the guest.  Interception of ENCLS leafs
occurs immediately after CPL0 checks, i.e. before any processing
of the leaf-specific operands.  As such, it's possible that KVM
could intercept an EINIT from L2 and encounter an EPT fault while
walking L1's EPT tables.  Rather than force EINIT through the
generic emulator, export kvm_propagate_fault() so that the EINIT
handler can inject the proper page fault.  Rename the function to
kvm_propagate_page_fault() to clarify that it is only for page
faults, and WARN if it is invoked with an exception other than
PF_VECTOR.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1341d8390ebe..397d755bb353 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1357,6 +1357,7 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
+bool kvm_propagate_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gfn_t gfn, void *data, int offset, int len,
 			    u32 access);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b64bb854571..ec92c5534336 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -587,8 +587,10 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
-static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+bool kvm_propagate_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
+	WARN_ON(fault->vector != PF_VECTOR);
+
 	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
 		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
 	else
@@ -596,6 +598,7 @@ static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fau
 
 	return fault->nested_page_fault;
 }
+EXPORT_SYMBOL_GPL(kvm_propagate_page_fault);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
@@ -6089,7 +6092,7 @@ static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	if (ctxt->exception.vector == PF_VECTOR)
-		return kvm_propagate_fault(vcpu, &ctxt->exception);
+		return kvm_propagate_page_fault(vcpu, &ctxt->exception);
 
 	if (ctxt->exception.error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
-- 
2.22.0

