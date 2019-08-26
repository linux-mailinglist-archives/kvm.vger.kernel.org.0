Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5B49C94B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfHZGV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34059 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbfHZGV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so9960937pgc.1;
        Sun, 25 Aug 2019 23:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NVQi7oJSYjKJUDoGMdbuk46cTM/KB/4mD0cCawZGfLQ=;
        b=pq4ybqp+HvTG20knjV8yiAn6BN1mcWdNEM3iop+/O7SdN2cm37R87Q3y9w7TPKG7RX
         7Mnl5dUer0hD3+GpbHlyBIFo2DE19SRyUccWmzo2QyvPg6sTAYYpPDYBXIK7L8k3lp+B
         HH0RV5IjiHa+LmKlZ1Gub5FC6+j1Utk2iFhaAD/ddrfS/qDssUEZ5hb4A1Mxf6Vw1ZMh
         nz9Ed7Z/WuvyI5K+frLdNb2rUfgDx9tpyhLS3wcmHCM4krtjgla8Tna6H9IfW5aK0ej+
         4127Hx2mIqgipS7o3oYAsDNfeuoJcaa9OwjjEaKFmVrWbkU3uOybt4NEn+GMSG2ew9BE
         Q7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NVQi7oJSYjKJUDoGMdbuk46cTM/KB/4mD0cCawZGfLQ=;
        b=qO/xw1ItfSZ+TSlg3Z+D/wTSVlpZ8YYX3JMmg44mF8VUwNquOGDw3PLyzEfD2D69Lt
         ZIe7dZ27V0Mz2sC5ltBAUpFhgdzTsHN3WiqtAKIw8apQ3Es2S2ki8aAPNUnKIRRFoaWz
         3DwmtqzrDZx8UHeUjjOLrQ2Tuzo1alAVhBxV5oG0C1tqOmk9U0tucHjuaoguGTL4FxCD
         8YmXx96WsiR+0b6rnTbWVLP5SB/vuWkzAHb/r5rT+WyTq+mgDCFYvgYbpAA1mJBTWaNn
         Zh48n4x1H+gmESY1KaIpifuskmUiljomdipzXVTykMLZzHjN6OOr85qLe6BNsd50+qbY
         q2zg==
X-Gm-Message-State: APjAAAVG3iIuypzdx7dLjWgUrStuBScGL0fgN3lNZza2wZyLmFp+wve/
        xuuLGIbGVgs1eHJvfjqGnbCdIyz5tbU=
X-Google-Smtp-Source: APXvYqxuUEIgSg6MS2ywMISNVY6sfdzYo7ie4/Wb1dgS7Fjm1d2JTxLAAwVW8MDxXy7y5Pzve5njCQ==
X-Received: by 2002:a62:be0c:: with SMTP id l12mr18543273pff.224.1566800517367;
        Sun, 25 Aug 2019 23:21:57 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:56 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 17/23] KVM: PPC: Book3S HV: Nested: Rename kvmhv_xlate_addr_nested_radix
Date:   Mon, 26 Aug 2019 16:21:03 +1000
Message-Id: <20190826062109.7573-18-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename kvmhv_xlate_addr_nested() to kvmhv_xlate_addr_nested_radix() for
clarity since there will need to be a hash function added.

Additionally if we can't permit an access since a nested guest is
writing to a page which has the KVM_MEM_READONLY bit set in the memslot
then give the nested guest an interrupt, there's not much else which can
be done in this case. For now this is the only place where an interrupt
is injected directly to the nested guest by the L0 hypervisor without
involving the L1 guest hypervisor.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s.c           |  1 +
 arch/powerpc/kvm/book3s_hv_nested.c | 81 +++++++++++++++++++++++++++----------
 2 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 9524d92bc45d..ff6586f1ed6f 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -140,6 +140,7 @@ void kvmppc_inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 flags)
 	kvmppc_set_pc(vcpu, kvmppc_interrupt_offset(vcpu) + vec);
 	vcpu->arch.mmu.reset_msr(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvmppc_inject_interrupt);
 
 static int kvmppc_book3s_vec2irqprio(unsigned int vec)
 {
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 54d6ff0bee5b..8ed50d4bd9a6 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -258,6 +258,14 @@ static void kvmhv_nested_mmio_needed(struct kvm_vcpu *vcpu, u64 regs_ptr)
 	}
 }
 
+static void kvmhv_update_intr_msr(struct kvm_vcpu *vcpu, unsigned long lpcr)
+{
+	if (lpcr & LPCR_ILE)
+		vcpu->arch.intr_msr |= MSR_LE;
+	else
+		vcpu->arch.intr_msr &= ~MSR_LE;
+}
+
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 {
 	long int err, r, ret = H_SUCCESS;
@@ -368,6 +376,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		LPCR_LPES | LPCR_MER | LPCR_HR | LPCR_GTSE | LPCR_UPRT |
 		LPCR_VPM1;
 	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
+	kvmhv_update_intr_msr(vcpu, lpcr);
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
 	if (!radix)
@@ -409,6 +418,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.shregs.msr |= MSR_TS_S;
 	vc->tb_offset = saved_l1_hv.tb_offset;
 	restore_hv_regs(vcpu, &saved_l1_hv);
+	kvmhv_update_intr_msr(vcpu, vc->lpcr);
 	if (!radix)
 		kvmhv_restore_guest_slb(vcpu, saved_l1_slb);
 	vcpu->arch.purr += delta_purr;
@@ -1480,13 +1490,38 @@ long kvmhv_do_nested_tlbie(struct kvm_vcpu *vcpu)
 	return H_SUCCESS;
 }
 
-/* Used to convert a nested guest real address to a L1 guest real address */
-static int kvmhv_translate_addr_nested(struct kvm_vcpu *vcpu,
-				       struct kvm_nested_guest *gp,
-				       unsigned long n_gpa, unsigned long dsisr,
-				       struct kvmppc_pte *gpte_p)
+/*
+ * Inject a storage interrupt (instruction or data) to the nested guest.
+ *
+ * Normally don't inject interrupts to the nested guest directly but
+ * instead let it's guest hypervisor handle injecting interrupts. However
+ * there are cases where the guest hypervisor is providing access to a page
+ * but the level 0 hypervisor is not, and in this case we need to inject an
+ * interrupt directly.
+ */
+static void kvmhv_inject_nested_storage_int(struct kvm_vcpu *vcpu, bool data,
+					    bool writing, u64 addr, u64 flags)
 {
-	u64 fault_addr, flags = dsisr & DSISR_ISSTORE;
+	int vec = BOOK3S_INTERRUPT_INST_STORAGE;
+
+	if (writing)
+		flags |= DSISR_ISSTORE;
+	if (data) {
+		vec = BOOK3S_INTERRUPT_DATA_STORAGE;
+		kvmppc_set_dar(vcpu, addr);
+		kvmppc_set_dsisr(vcpu, flags);
+	}
+	kvmppc_inject_interrupt(vcpu, vec, flags);
+}
+
+/* Used to convert a radix nested guest real addr to a L1 guest real address */
+static int kvmhv_xlate_addr_nested_radix(struct kvm_vcpu *vcpu,
+					 struct kvm_nested_guest *gp,
+					 unsigned long n_gpa, bool data,
+					 bool writing,
+					 struct kvmppc_pte *gpte_p)
+{
+	u64 fault_addr, flags = writing ? DSISR_ISSTORE : 0ULL;
 	int ret;
 
 	ret = kvmppc_mmu_walk_radix_tree(vcpu, n_gpa, gpte_p, gp->l1_gr_to_hr,
@@ -1511,13 +1546,13 @@ static int kvmhv_translate_addr_nested(struct kvm_vcpu *vcpu,
 		goto forward_to_l1;
 	} else {
 		/* We found a pte -> check permissions */
-		if (dsisr & DSISR_ISSTORE) {
+		if (writing) {
 			/* Can we write? */
 			if (!gpte_p->may_write) {
 				flags |= DSISR_PROTFAULT;
 				goto forward_to_l1;
 			}
-		} else if (vcpu->arch.trap == BOOK3S_INTERRUPT_H_INST_STORAGE) {
+		} else if (!data) {
 			/* Can we execute? */
 			if (!gpte_p->may_execute) {
 				flags |= SRR1_ISI_N_OR_G;
@@ -1536,18 +1571,18 @@ static int kvmhv_translate_addr_nested(struct kvm_vcpu *vcpu,
 
 forward_to_l1:
 	vcpu->arch.fault_dsisr = flags;
-	if (vcpu->arch.trap == BOOK3S_INTERRUPT_H_INST_STORAGE) {
+	if (!data) {
 		vcpu->arch.shregs.msr &= ~0x783f0000ul;
-		vcpu->arch.shregs.msr |= flags;
+		vcpu->arch.shregs.msr |= (flags & 0x783f0000ul);
 	}
 	return RESUME_HOST;
 }
 
-static long kvmhv_handle_nested_set_rc(struct kvm_vcpu *vcpu,
-				       struct kvm_nested_guest *gp,
-				       unsigned long n_gpa,
-				       struct kvmppc_pte gpte,
-				       unsigned long dsisr)
+static long kvmhv_handle_nested_set_rc_radix(struct kvm_vcpu *vcpu,
+					     struct kvm_nested_guest *gp,
+					     unsigned long n_gpa,
+					     struct kvmppc_pte gpte,
+					     unsigned long dsisr)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool writing = !!(dsisr & DSISR_ISSTORE);
@@ -1623,7 +1658,8 @@ static long int __kvmhv_nested_page_fault_radix(struct kvm_run *run,
 	unsigned long *rmapp;
 	unsigned long n_gpa, gpa, gfn, perm = 0UL;
 	unsigned int shift, l1_shift, level;
-	bool writing = !!(dsisr & DSISR_ISSTORE);
+	bool data = vcpu->arch.trap == BOOK3S_INTERRUPT_H_DATA_STORAGE;
+	bool writing = data && (dsisr & DSISR_ISSTORE);
 	bool kvm_ro = false;
 	long int ret;
 
@@ -1638,7 +1674,8 @@ static long int __kvmhv_nested_page_fault_radix(struct kvm_run *run,
 	n_gpa = vcpu->arch.fault_gpa & ~0xF000000000000FFFULL;
 	if (!(dsisr & DSISR_PRTABLE_FAULT))
 		n_gpa |= ea & 0xFFF;
-	ret = kvmhv_translate_addr_nested(vcpu, gp, n_gpa, dsisr, &gpte);
+	ret = kvmhv_xlate_addr_nested_radix(vcpu, gp, n_gpa, data, writing,
+					    &gpte);
 
 	/*
 	 * If the hardware found a translation but we don't now have a usable
@@ -1654,7 +1691,8 @@ static long int __kvmhv_nested_page_fault_radix(struct kvm_run *run,
 
 	/* Failed to set the reference/change bits */
 	if (dsisr & DSISR_SET_RC) {
-		ret = kvmhv_handle_nested_set_rc(vcpu, gp, n_gpa, gpte, dsisr);
+		ret = kvmhv_handle_nested_set_rc_radix(vcpu, gp, n_gpa, gpte,
+						       dsisr);
 		if (ret == RESUME_HOST)
 			return ret;
 		if (ret)
@@ -1687,7 +1725,8 @@ static long int __kvmhv_nested_page_fault_radix(struct kvm_run *run,
 	if (!memslot || (memslot->flags & KVM_MEMSLOT_INVALID)) {
 		if (dsisr & (DSISR_PRTABLE_FAULT | DSISR_BADACCESS)) {
 			/* unusual error -> reflect to the guest as a DSI */
-			kvmppc_core_queue_data_storage(vcpu, ea, dsisr);
+			kvmhv_inject_nested_storage_int(vcpu, data, writing, ea,
+							dsisr);
 			return RESUME_GUEST;
 		}
 
@@ -1697,8 +1736,8 @@ static long int __kvmhv_nested_page_fault_radix(struct kvm_run *run,
 	if (memslot->flags & KVM_MEM_READONLY) {
 		if (writing) {
 			/* Give the guest a DSI */
-			kvmppc_core_queue_data_storage(vcpu, ea,
-					DSISR_ISSTORE | DSISR_PROTFAULT);
+			kvmhv_inject_nested_storage_int(vcpu, data, writing, ea,
+							DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
 		kvm_ro = true;
-- 
2.13.6

