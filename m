Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8434F107AF8
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfKVW6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:58:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:15520 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfKVW6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:58:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:58:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="382219002"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Nov 2019 14:58:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Move gpa_val and gpa_available into the emulator context
Date:   Fri, 22 Nov 2019 14:58:31 -0800
Message-Id: <20191122225832.26684-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122225832.26684-1-sean.j.christopherson@intel.com>
References: <20191122225832.26684-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the GPA tracking into the emulator context to prevent it from being
abused in the standard page fault flow.  All paths into the emulator go
through init_emulate_ctxt(), so there's no need to clear gpa_available
after every VM-Exit.  The only partial exception is EMULTYPE_NO_DECODE,
but in that case the emulator is simply being re-entered, i.e. retaining
gpa_available is correct and consistent with current behavior.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h |  4 ++++
 arch/x86/include/asm/kvm_host.h    |  4 ----
 arch/x86/kvm/x86.c                 | 13 ++++++-------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 77cf6c11f66b..e81658a4ab9d 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -307,6 +307,10 @@ struct x86_emulate_ctxt {
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
index 6311fffbc2f0..e434f4cfecd1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -791,10 +791,6 @@ struct kvm_vcpu_arch {
 	int pending_ioapic_eoi;
 	int pending_external_vector;
 
-	/* GPA available */
-	bool gpa_available;
-	gpa_t gpa_val;
-
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 848e4ec21c5e..9a8adfdf1e0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5664,10 +5664,9 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
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
@@ -6318,6 +6317,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
+	ctxt->gpa_available = false;
 	ctxt->eflags = kvm_get_rflags(vcpu);
 	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
 
@@ -6750,8 +6750,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
 		if (vcpu->arch.mmu->direct_map) {
-			vcpu->arch.gpa_available = true;
-			vcpu->arch.gpa_val = cr2;
+			ctxt->gpa_available = true;
+			ctxt->gpa_val = cr2;
 		}
 	} else {
 		/* Sanitize the address out of an abundance of paranoia. */
@@ -8306,7 +8306,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.apic_attention)
 		kvm_lapic_sync_from_vapic(vcpu);
 
-	vcpu->arch.gpa_available = false;
 	r = kvm_x86_ops->handle_exit(vcpu);
 	return r;
 
-- 
2.24.0

