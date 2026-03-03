Return-Path: <kvm+bounces-72569-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UM8TOz4xp2kjfwAAu9opvQ
	(envelope-from <kvm+bounces-72569-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:06:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE1C1F5A4E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CC8C31214E1
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA2F47DFA2;
	Tue,  3 Mar 2026 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2I5fSgZN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0B54921A1
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564627; cv=none; b=QbDDoLpiIn/iojH7aVe9I/AcDLWjFXoZ2zerHMTyS4kKV+jbwdhCfJA+hy1sYZOrXzaTZ7eHqmPNvnkYDZ6LcsGTdMc3tpecsqrPhoo7Raf99EgRyJBjAgvjfmSWh3XdJjxU+1DtbgsboMFMvFBUmjFCuuH/yy4eqy7eGlV3x+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564627; c=relaxed/simple;
	bh=JO+cq/Bz4llSo+/NA9YKyRFMOPe0oAzVAp9Gb1fMqpY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BDpvhYlwokp6zkqepPrisFJTOvxvvuJEFZgQ0nl0ucO3osPUQhNovrBn7JHgbYNx89dir0x44n1GlAy4lMD4yPDiJ39dBWLaowldKW2s94UTvIStY18sfftSD99bTM2flraZsKMDd1mFEuhiZasiAgTXw3ZFyPKpTbra8zNfSBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2I5fSgZN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae66ee7354so3497875ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772564626; x=1773169426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=99DC7OhlXTRR+D72sFLb9VSn0W5lbhfdlhpUdwYerhc=;
        b=2I5fSgZN289jv/g7RRgk0Hbh1itbqI8BULXkl9EuqQJgEHUffe7T0LnhTYjLZmvv61
         6+MNsfqxun+4j3YNPxUiGSDBDkAbNUPWiqVXpITNZ6+2b1aJaOnLvEaFX0IEyopwP2Vl
         UB1iS7yytDbmoDn2GZNOVBe7ji8NO4UJh22tAKIjicISZhlMa+7Ji/xsq7o6IhzalkdR
         /VM7p1k+1VXmHBEgiBplIVzMA/u/a66zJYutzwmHnzNaVffzAYoSjDsJbezrpuuzZa4W
         O1AgQlKbM13KSMnuOkJCzK+/RhlWbKdZt3+m2Ps34rXgJuQGhpj6N4vBeSQzBvExzbth
         bhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564626; x=1773169426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99DC7OhlXTRR+D72sFLb9VSn0W5lbhfdlhpUdwYerhc=;
        b=F9u3NO86ut91aT+OZdPkFPt+Tr0FVWJUv5ZtQuBAKfreyGPil1ZMOKo74Pad6sH7xn
         E66/QEAAz2pPL9A/QviNk+DlXifM+00R+7VUF8BpZKKhRmEByYRhZ5vO+qYygIGRhTHz
         KKTP6yJvaE3MlIL+pjh2dNrJ0S+hQBE+BugoQ2F8Z7PQj6yMzQqnBnW8vZ4JX3VGsEzJ
         OL+NHrGZmsGPej2NAg9mxG9QoLXe1zdNVZWKk+N/Oyk2bl0SqpA6JlEt4hFXNs9wfUUi
         eUCoGXW39cUQdAqSshd7uk+eYY/IZM4hm+cvw8KxAOzlXg8DhvSNVf0dIuO05IRHmgHH
         P5+w==
X-Forwarded-Encrypted: i=1; AJvYcCVXAK4YPVHScRWEhR+85vTrltvrL9CWFPzfxuWlqLGSi8v7lrJyF3dAgCtG1wAF7g7zzPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLYINwEuOFQ2BkHJrLfjFyQ+ultfkkFkTf4sqH24ZKtq0JXMRi
	oIU2Jbg2NMPPWfxvSYMrFMAVWf93PMANrAS+6t+kT+RwUObYBLv/9OTR2FXpZ3z6b8XAmA3loMY
	P0qVfww==
X-Received: from plkz9.prod.google.com ([2002:a17:902:7089:b0:2ae:3bca:37a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f705:b0:2ae:6887:5c2c
 with SMTP id d9443c01a7336-2ae68876411mr2958095ad.50.1772564625724; Tue, 03
 Mar 2026 11:03:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 11:03:39 -0800
In-Reply-To: <20260303190339.974325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303190339.974325-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303190339.974325-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: PPC: e500: Rip out "struct tlbe_ref"
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4DE1C1F5A4E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72569-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Complete the ~13 year journey started by commit 47bf379742bf
("kvm/ppc/e500: eliminate tlb_refs"), and actually remove "struct
tlbe_ref".

No functional change intended (verified disassembly of e500_mmu.o and
e500_mmu_host.o is identical before and after).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/e500.h          |  6 +--
 arch/powerpc/kvm/e500_mmu_host.c | 91 +++++++++++++++-----------------
 2 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/kvm/e500.h b/arch/powerpc/kvm/e500.h
index f9acf866c709..e4469ad73a2e 100644
--- a/arch/powerpc/kvm/e500.h
+++ b/arch/powerpc/kvm/e500.h
@@ -39,15 +39,11 @@ enum vcpu_ftr {
 /* bits [6-5] MAS2_X1 and MAS2_X0 and [4-0] bits for WIMGE */
 #define E500_TLB_MAS2_ATTR	(0x7f)
 
-struct tlbe_ref {
+struct tlbe_priv {
 	kvm_pfn_t pfn;		/* valid only for TLB0, except briefly */
 	unsigned int flags;	/* E500_TLB_* */
 };
 
-struct tlbe_priv {
-	struct tlbe_ref ref;
-};
-
 #ifdef CONFIG_KVM_E500V2
 struct vcpu_id_table;
 #endif
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 06caf8bbbe2b..37e0d3d9e244 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -189,16 +189,16 @@ void inval_gtlbe_on_host(struct kvmppc_vcpu_e500 *vcpu_e500, int tlbsel,
 {
 	struct kvm_book3e_206_tlb_entry *gtlbe =
 		get_entry(vcpu_e500, tlbsel, esel);
-	struct tlbe_ref *ref = &vcpu_e500->gtlb_priv[tlbsel][esel].ref;
+	struct tlbe_priv *tlbe = &vcpu_e500->gtlb_priv[tlbsel][esel];
 
 	/* Don't bother with unmapped entries */
-	if (!(ref->flags & E500_TLB_VALID)) {
-		WARN(ref->flags & (E500_TLB_BITMAP | E500_TLB_TLB0),
-		     "%s: flags %x\n", __func__, ref->flags);
+	if (!(tlbe->flags & E500_TLB_VALID)) {
+		WARN(tlbe->flags & (E500_TLB_BITMAP | E500_TLB_TLB0),
+		     "%s: flags %x\n", __func__, tlbe->flags);
 		WARN_ON(tlbsel == 1 && vcpu_e500->g2h_tlb1_map[esel]);
 	}
 
-	if (tlbsel == 1 && ref->flags & E500_TLB_BITMAP) {
+	if (tlbsel == 1 && tlbe->flags & E500_TLB_BITMAP) {
 		u64 tmp = vcpu_e500->g2h_tlb1_map[esel];
 		int hw_tlb_indx;
 		unsigned long flags;
@@ -216,28 +216,28 @@ void inval_gtlbe_on_host(struct kvmppc_vcpu_e500 *vcpu_e500, int tlbsel,
 		}
 		mb();
 		vcpu_e500->g2h_tlb1_map[esel] = 0;
-		ref->flags &= ~(E500_TLB_BITMAP | E500_TLB_VALID);
+		tlbe->flags &= ~(E500_TLB_BITMAP | E500_TLB_VALID);
 		local_irq_restore(flags);
 	}
 
-	if (tlbsel == 1 && ref->flags & E500_TLB_TLB0) {
+	if (tlbsel == 1 && tlbe->flags & E500_TLB_TLB0) {
 		/*
 		 * TLB1 entry is backed by 4k pages. This should happen
 		 * rarely and is not worth optimizing. Invalidate everything.
 		 */
 		kvmppc_e500_tlbil_all(vcpu_e500);
-		ref->flags &= ~(E500_TLB_TLB0 | E500_TLB_VALID);
+		tlbe->flags &= ~(E500_TLB_TLB0 | E500_TLB_VALID);
 	}
 
 	/*
 	 * If TLB entry is still valid then it's a TLB0 entry, and thus
 	 * backed by at most one host tlbe per shadow pid
 	 */
-	if (ref->flags & E500_TLB_VALID)
+	if (tlbe->flags & E500_TLB_VALID)
 		kvmppc_e500_tlbil_one(vcpu_e500, gtlbe);
 
 	/* Mark the TLB as not backed by the host anymore */
-	ref->flags = 0;
+	tlbe->flags = 0;
 }
 
 static inline int tlbe_is_writable(struct kvm_book3e_206_tlb_entry *tlbe)
@@ -245,26 +245,26 @@ static inline int tlbe_is_writable(struct kvm_book3e_206_tlb_entry *tlbe)
 	return tlbe->mas7_3 & (MAS3_SW|MAS3_UW);
 }
 
-static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
-					 struct kvm_book3e_206_tlb_entry *gtlbe,
-					 kvm_pfn_t pfn, unsigned int wimg,
-					 bool writable)
+static inline void kvmppc_e500_tlbe_setup(struct tlbe_priv *tlbe,
+					  struct kvm_book3e_206_tlb_entry *gtlbe,
+					  kvm_pfn_t pfn, unsigned int wimg,
+					  bool writable)
 {
-	ref->pfn = pfn;
-	ref->flags = E500_TLB_VALID;
+	tlbe->pfn = pfn;
+	tlbe->flags = E500_TLB_VALID;
 	if (writable)
-		ref->flags |= E500_TLB_WRITABLE;
+		tlbe->flags |= E500_TLB_WRITABLE;
 
 	/* Use guest supplied MAS2_G and MAS2_E */
-	ref->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
+	tlbe->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
 }
 
-static inline void kvmppc_e500_ref_release(struct tlbe_ref *ref)
+static inline void kvmppc_e500_tlbe_release(struct tlbe_priv *tlbe)
 {
-	if (ref->flags & E500_TLB_VALID) {
+	if (tlbe->flags & E500_TLB_VALID) {
 		/* FIXME: don't log bogus pfn for TLB1 */
-		trace_kvm_booke206_ref_release(ref->pfn, ref->flags);
-		ref->flags = 0;
+		trace_kvm_booke206_ref_release(tlbe->pfn, tlbe->flags);
+		tlbe->flags = 0;
 	}
 }
 
@@ -284,11 +284,8 @@ static void clear_tlb_privs(struct kvmppc_vcpu_e500 *vcpu_e500)
 	int i;
 
 	for (tlbsel = 0; tlbsel <= 1; tlbsel++) {
-		for (i = 0; i < vcpu_e500->gtlb_params[tlbsel].entries; i++) {
-			struct tlbe_ref *ref =
-				&vcpu_e500->gtlb_priv[tlbsel][i].ref;
-			kvmppc_e500_ref_release(ref);
-		}
+		for (i = 0; i < vcpu_e500->gtlb_params[tlbsel].entries; i++)
+			kvmppc_e500_tlbe_release(&vcpu_e500->gtlb_priv[tlbsel][i]);
 	}
 }
 
@@ -304,18 +301,18 @@ void kvmppc_core_flush_tlb(struct kvm_vcpu *vcpu)
 static void kvmppc_e500_setup_stlbe(
 	struct kvm_vcpu *vcpu,
 	struct kvm_book3e_206_tlb_entry *gtlbe,
-	int tsize, struct tlbe_ref *ref, u64 gvaddr,
+	int tsize, struct tlbe_priv *tlbe, u64 gvaddr,
 	struct kvm_book3e_206_tlb_entry *stlbe)
 {
-	kvm_pfn_t pfn = ref->pfn;
+	kvm_pfn_t pfn = tlbe->pfn;
 	u32 pr = vcpu->arch.shared->msr & MSR_PR;
-	bool writable = !!(ref->flags & E500_TLB_WRITABLE);
+	bool writable = !!(tlbe->flags & E500_TLB_WRITABLE);
 
-	BUG_ON(!(ref->flags & E500_TLB_VALID));
+	BUG_ON(!(tlbe->flags & E500_TLB_VALID));
 
 	/* Force IPROT=0 for all guest mappings. */
 	stlbe->mas1 = MAS1_TSIZE(tsize) | get_tlb_sts(gtlbe) | MAS1_VALID;
-	stlbe->mas2 = (gvaddr & MAS2_EPN) | (ref->flags & E500_TLB_MAS2_ATTR);
+	stlbe->mas2 = (gvaddr & MAS2_EPN) | (tlbe->flags & E500_TLB_MAS2_ATTR);
 	stlbe->mas7_3 = ((u64)pfn << PAGE_SHIFT) |
 			e500_shadow_mas3_attrib(gtlbe->mas7_3, writable, pr);
 }
@@ -323,7 +320,7 @@ static void kvmppc_e500_setup_stlbe(
 static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	u64 gvaddr, gfn_t gfn, struct kvm_book3e_206_tlb_entry *gtlbe,
 	int tlbsel, struct kvm_book3e_206_tlb_entry *stlbe,
-	struct tlbe_ref *ref)
+	struct tlbe_priv *tlbe)
 {
 	struct kvm_memory_slot *slot;
 	unsigned int psize;
@@ -455,9 +452,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		}
 	}
 
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, writable);
+	kvmppc_e500_tlbe_setup(tlbe, gtlbe, pfn, wimg, writable);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
-				ref, gvaddr, stlbe);
+				tlbe, gvaddr, stlbe);
 	writable = tlbe_is_writable(stlbe);
 
 	/* Clear i-cache for new pages */
@@ -474,17 +471,17 @@ static int kvmppc_e500_tlb0_map(struct kvmppc_vcpu_e500 *vcpu_e500, int esel,
 				struct kvm_book3e_206_tlb_entry *stlbe)
 {
 	struct kvm_book3e_206_tlb_entry *gtlbe;
-	struct tlbe_ref *ref;
+	struct tlbe_priv *tlbe;
 	int stlbsel = 0;
 	int sesel = 0;
 	int r;
 
 	gtlbe = get_entry(vcpu_e500, 0, esel);
-	ref = &vcpu_e500->gtlb_priv[0][esel].ref;
+	tlbe = &vcpu_e500->gtlb_priv[0][esel];
 
 	r = kvmppc_e500_shadow_map(vcpu_e500, get_tlb_eaddr(gtlbe),
 			get_tlb_raddr(gtlbe) >> PAGE_SHIFT,
-			gtlbe, 0, stlbe, ref);
+			gtlbe, 0, stlbe, tlbe);
 	if (r)
 		return r;
 
@@ -494,7 +491,7 @@ static int kvmppc_e500_tlb0_map(struct kvmppc_vcpu_e500 *vcpu_e500, int esel,
 }
 
 static int kvmppc_e500_tlb1_map_tlb1(struct kvmppc_vcpu_e500 *vcpu_e500,
-				     struct tlbe_ref *ref,
+				     struct tlbe_priv *tlbe,
 				     int esel)
 {
 	unsigned int sesel = vcpu_e500->host_tlb1_nv++;
@@ -507,10 +504,10 @@ static int kvmppc_e500_tlb1_map_tlb1(struct kvmppc_vcpu_e500 *vcpu_e500,
 		vcpu_e500->g2h_tlb1_map[idx] &= ~(1ULL << sesel);
 	}
 
-	vcpu_e500->gtlb_priv[1][esel].ref.flags |= E500_TLB_BITMAP;
+	vcpu_e500->gtlb_priv[1][esel].flags |= E500_TLB_BITMAP;
 	vcpu_e500->g2h_tlb1_map[esel] |= (u64)1 << sesel;
 	vcpu_e500->h2g_tlb1_rmap[sesel] = esel + 1;
-	WARN_ON(!(ref->flags & E500_TLB_VALID));
+	WARN_ON(!(tlbe->flags & E500_TLB_VALID));
 
 	return sesel;
 }
@@ -522,24 +519,24 @@ static int kvmppc_e500_tlb1_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		u64 gvaddr, gfn_t gfn, struct kvm_book3e_206_tlb_entry *gtlbe,
 		struct kvm_book3e_206_tlb_entry *stlbe, int esel)
 {
-	struct tlbe_ref *ref = &vcpu_e500->gtlb_priv[1][esel].ref;
+	struct tlbe_priv *tlbe = &vcpu_e500->gtlb_priv[1][esel];
 	int sesel;
 	int r;
 
 	r = kvmppc_e500_shadow_map(vcpu_e500, gvaddr, gfn, gtlbe, 1, stlbe,
-				   ref);
+				   tlbe);
 	if (r)
 		return r;
 
 	/* Use TLB0 when we can only map a page with 4k */
 	if (get_tlb_tsize(stlbe) == BOOK3E_PAGESZ_4K) {
-		vcpu_e500->gtlb_priv[1][esel].ref.flags |= E500_TLB_TLB0;
+		vcpu_e500->gtlb_priv[1][esel].flags |= E500_TLB_TLB0;
 		write_stlbe(vcpu_e500, gtlbe, stlbe, 0, 0);
 		return 0;
 	}
 
 	/* Otherwise map into TLB1 */
-	sesel = kvmppc_e500_tlb1_map_tlb1(vcpu_e500, ref, esel);
+	sesel = kvmppc_e500_tlb1_map_tlb1(vcpu_e500, tlbe, esel);
 	write_stlbe(vcpu_e500, gtlbe, stlbe, 1, sesel);
 
 	return 0;
@@ -561,11 +558,11 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 eaddr, gpa_t gpaddr,
 		priv = &vcpu_e500->gtlb_priv[tlbsel][esel];
 
 		/* Triggers after clear_tlb_privs or on initial mapping */
-		if (!(priv->ref.flags & E500_TLB_VALID)) {
+		if (!(priv->flags & E500_TLB_VALID)) {
 			kvmppc_e500_tlb0_map(vcpu_e500, esel, &stlbe);
 		} else {
 			kvmppc_e500_setup_stlbe(vcpu, gtlbe, BOOK3E_PAGESZ_4K,
-						&priv->ref, eaddr, &stlbe);
+						priv, eaddr, &stlbe);
 			write_stlbe(vcpu_e500, gtlbe, &stlbe, 0, 0);
 		}
 		break;
-- 
2.53.0.473.g4a7958ca14-goog


