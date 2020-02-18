Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162181636B5
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgBRXDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:03:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:57150 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbgBRXDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:03:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:03:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="239504573"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 18 Feb 2020 15:03:10 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: x86: Move gpa_val and gpa_available into the emulator context
Date:   Tue, 18 Feb 2020 15:03:09 -0800
Message-Id: <20200218230310.29410-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218230310.29410-1-sean.j.christopherson@intel.com>
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the GPA tracking into the emulator context now that the context is
guaranteed to be initialized via __init_emulate_ctxt() prior to
dereferencing gpa_{available,val}, i.e. now that seeing a stale
gpa_available will also trigger a WARN due to an invalid context.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h |  4 ++++
 arch/x86/include/asm/kvm_host.h    |  4 ----
 arch/x86/kvm/x86.c                 | 13 ++++++-------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 03946eb3e2b9..a4ef19a6e612 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -311,6 +311,10 @@ struct x86_emulate_ctxt {
 	bool have_exception;
 	struct x86_exception exception;
 
+	/* GPA available */
+	bool gpa_available;
+	gpa_t gpa_val;
+
 	/*
 	 * decode cache
 	 */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 10c1e8f472b6..9c79c41eb5f6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -798,10 +798,6 @@ struct kvm_vcpu_arch {
 	int pending_ioapic_eoi;
 	int pending_external_vector;
 
-	/* GPA available */
-	bool gpa_available;
-	gpa_t gpa_val;
-
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92af6c5a69e3..f88b72932c35 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5736,10 +5736,9 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	 * operation using rep will only have the initial GPA from the NPF
 	 * occurred.
 	 */
-	if (vcpu->arch.gpa_available &&
-	    emulator_can_use_gpa(ctxt) &&
-	    (addr & ~PAGE_MASK) == (vcpu->arch.gpa_val & ~PAGE_MASK)) {
-		gpa = vcpu->arch.gpa_val;
+	if (ctxt->gpa_available && emulator_can_use_gpa(ctxt) &&
+	    (addr & ~PAGE_MASK) == (ctxt->gpa_val & ~PAGE_MASK)) {
+		gpa = ctxt->gpa_val;
 		ret = vcpu_is_mmio_gpa(vcpu, addr, gpa, write);
 	} else {
 		ret = vcpu_mmio_gva_to_gpa(vcpu, addr, &gpa, exception, write);
@@ -6408,6 +6407,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
+	ctxt->gpa_available = false;
 	ctxt->eflags = kvm_get_rflags(vcpu);
 	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
 
@@ -6838,8 +6838,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
 		if (vcpu->arch.mmu->direct_map) {
-			vcpu->arch.gpa_available = true;
-			vcpu->arch.gpa_val = cr2_or_gpa;
+			ctxt->gpa_available = true;
+			ctxt->gpa_val = cr2_or_gpa;
 		}
 	} else {
 		/* Sanitize the address out of an abundance of paranoia. */
@@ -8443,7 +8443,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.apic_attention)
 		kvm_lapic_sync_from_vapic(vcpu);
 
-	vcpu->arch.gpa_available = false;
 	r = kvm_x86_ops->handle_exit(vcpu, exit_fastpath);
 	return r;
 
-- 
2.24.1

