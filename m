Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F259C935
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbfHZGVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39782 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbfHZGVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so9524856pln.6;
        Sun, 25 Aug 2019 23:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5og80usUGlzfJfxk3JEqwx+18Kjq4HcRb0jjHedCZVY=;
        b=A1yT1heO/R8jfub6rIaIQR82asc7O5vrIIuUMwY1NNlCDhPMLFOvQ03DrbzY0KoYiE
         7p2MLvsWlLtf0VhEaszodh19P1R5ajjKYWRoqZeYeAl4ewCYjXQpyyWyOCljqVcjkZyG
         ImIvelD9V7yF/iIx0o5PTwpaQXpljkFiwmCvLYf0bW1AkxsNir103GhSYnm5l8wtsL/t
         ckmaH2ZVjCm3aWEhY8MF8AuNhJbBno5jV8M4sGpAMAEXOVZjoGfuuOFrLuojnz9MoVaq
         cKh3WzPNWCcljX4cj2TN0oZUqZkTQs2SE22AoDZeTYK7GbBk+q3Jhcm1sWEPX2mYe+GV
         LRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5og80usUGlzfJfxk3JEqwx+18Kjq4HcRb0jjHedCZVY=;
        b=POqaEDkE7KbaXEzeHi20F2H7HPR01ST/bymtoJHgWS9YeEZzbAJSNIE7kbKILWFiCY
         UP9viU08fwI2j2e1nw/LtH/sTHaUcDCD/Wxq2wqzROmU+GSMur+7N2d5DGi5izzK227D
         dGfdmuXxq7Jgvl6MxJWtcu8gWArfPsa0IWP/iAOMf4sE/77ue/bQR8Gq1DhpIIT+jXn/
         wI0At9bn/8uIWl8cjna+hEDaJwavsTrg/ZOJmZnTVqjgQBeGsbxuRWo9AaAPEpN5ERd4
         47Q9XRp5OQCF5i2JgoCAV4PRrQXS4JZOEvde9kl31MVCzJOvBhzBAgi6j32gGp9qS7sy
         i2Cg==
X-Gm-Message-State: APjAAAUwLt6VYPuad+efyLxx1a7gCUQs1py2IHt81p6aY/U3I9pvxjv0
        jpSHbtIi5unaMuO+xGnt2iC3xoyov00=
X-Google-Smtp-Source: APXvYqyaAFcT+t+drixAK2uBrZKuWWBGzgaeaFyzEqPAPusPOxjJFOUNoqpfHnA8isSTumPCWJLkQA==
X-Received: by 2002:a17:902:566:: with SMTP id 93mr17576740plf.172.1566800490092;
        Sun, 25 Aug 2019 23:21:30 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:29 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 06/23] KVM: PPC: Book3S HV: Allow hpt manipulation hcalls to be called in virtual mode
Date:   Mon, 26 Aug 2019 16:20:52 +1000
Message-Id: <20190826062109.7573-7-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hcalls H_ENTER, H_REMOVE, H_READ, H_CLEAR_MOD, H_CLEAR_READ,
H_PROTECT and H_BULK_REMOVE are used by a guest to call into the
hypervisor in order to control manipulation of it's hpt (hash page table)
by the hypervisor on it'the guest's behalf.

Currently the functions which handle these hcalls are only called in
real mode from the kvm exit path in book3s_hv_rmhandlers.c.

Modify the functions which handle these hcalls so that they can be
called in real mode and call them from the virtual mode hcall handling
function kvmppc_pseries_do_hcall() if we're a pseries machine. There is
no need to call these functions again on powernv as they were already
called from real mode.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |  16 ++++-
 arch/powerpc/kvm/book3s_64_mmu_hv.c   |  10 +---
 arch/powerpc/kvm/book3s_hv.c          |  60 +++++++++++++++++++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   | 107 +++++++++++++++++++++++++---------
 4 files changed, 159 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 506e4df2d730..6d0bb22dc637 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -252,9 +252,23 @@ extern void kvmppc_unpin_guest_page(struct kvm *kvm, void *addr,
 extern long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 			long pte_index, unsigned long pteh, unsigned long ptel,
 			pgd_t *pgdir, bool realmode, unsigned long *idx_ret);
+extern long kvmppc_virtmode_do_h_enter(struct kvm *kvm, unsigned long flags,
+				       long pte_index, unsigned long pteh,
+				       unsigned long ptel,
+				       unsigned long *pte_idx_ret);
 extern long kvmppc_do_h_remove(struct kvm *kvm, unsigned long flags,
 			unsigned long pte_index, unsigned long avpn,
-			unsigned long *hpret);
+			bool realmode, unsigned long *hpret);
+extern long kvmppc_do_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
+			     unsigned long pte_index, bool realmode);
+extern long kvmppc_do_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
+				  unsigned long pte_index, bool realmode);
+extern long kvmppc_do_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
+				  unsigned long pte_index, bool realmode);
+extern long kvmppc_do_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
+				unsigned long pte_index, unsigned long avpn,
+				unsigned long va, bool realmode);
+extern long kvmppc_do_h_bulk_remove(struct kvm_vcpu *vcpu, bool realmode);
 extern long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
 			struct kvm_memory_slot *memslot, unsigned long *map);
 extern void kvmppc_harvest_vpa_dirty(struct kvmppc_vpa *vpa,
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index a485bb018193..ab97b6bcf226 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -42,10 +42,6 @@
 	do { } while (0)
 #endif
 
-static long kvmppc_virtmode_do_h_enter(struct kvm *kvm, unsigned long flags,
-				long pte_index, unsigned long pteh,
-				unsigned long ptel, unsigned long *pte_idx_ret);
-
 struct kvm_resize_hpt {
 	/* These fields read-only after init */
 	struct kvm *kvm;
@@ -287,7 +283,7 @@ static void kvmppc_mmu_book3s_64_hv_reset_msr(struct kvm_vcpu *vcpu)
 	kvmppc_set_msr(vcpu, msr);
 }
 
-static long kvmppc_virtmode_do_h_enter(struct kvm *kvm, unsigned long flags,
+long kvmppc_virtmode_do_h_enter(struct kvm *kvm, unsigned long flags,
 				long pte_index, unsigned long pteh,
 				unsigned long ptel, unsigned long *pte_idx_ret)
 {
@@ -1907,7 +1903,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 			nb += HPTE_SIZE;
 
 			if (be64_to_cpu(hptp[0]) & (HPTE_V_VALID | HPTE_V_ABSENT))
-				kvmppc_do_h_remove(kvm, 0, i, 0, tmp);
+				kvmppc_do_h_remove(kvm, 0, i, 0, false, tmp);
 			err = -EIO;
 			ret = kvmppc_virtmode_do_h_enter(kvm, H_EXACT, i, v, r,
 							 tmp);
@@ -1937,7 +1933,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 
 		for (j = 0; j < hdr.n_invalid; ++j) {
 			if (be64_to_cpu(hptp[0]) & (HPTE_V_VALID | HPTE_V_ABSENT))
-				kvmppc_do_h_remove(kvm, 0, i, 0, tmp);
+				kvmppc_do_h_remove(kvm, 0, i, 0, false, tmp);
 			++i;
 			hptp += 2;
 		}
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4901738a3c31..67e242214191 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -916,6 +916,66 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		return RESUME_HOST;
 
 	switch (req) {
+	/*
+	 * The following hpt manipulation hcalls
+	 * (H_REMOVE/H_ENTER/H_READ/H_CLEAR_[MOD/REF]/H_PROTECT/H_BULK_REMOVE)
+	 * are normally handled in real mode in book3s_hv_rmhandlers.S for a
+	 * baremetal (powernv) hypervisor. For a pseries (nested) hypervisor we
+	 * didn't use that entry path, so we have to try handle them here before
+	 * punting them to userspace.
+	 * NOTE: There's not point trying to call the handlers again for
+	 *       !pseries since the only way we got here is if we couldn't
+	 *       handle them.
+	 */
+	case H_REMOVE:
+		if (!kvmhv_on_pseries())
+			return RESUME_HOST;
+		ret = kvmppc_do_h_remove(vcpu->kvm, kvmppc_get_gpr(vcpu, 4),
+					 kvmppc_get_gpr(vcpu, 5),
+					 kvmppc_get_gpr(vcpu, 6), false,
+					 &vcpu->arch.regs.gpr[4]);
+		break;
+	case H_ENTER:
+		if (!kvmhv_on_pseries())
+			return RESUME_HOST;
+		ret = kvmppc_virtmode_do_h_enter(vcpu->kvm,
+						 kvmppc_get_gpr(vcpu, 4),
+						 kvmppc_get_gpr(vcpu, 5),
+						 kvmppc_get_gpr(vcpu, 6),
+						 kvmppc_get_gpr(vcpu, 7),
+						 &vcpu->arch.regs.gpr[4]);
+		break;
+	case H_READ:
+		if (!kvmhv_on_pseries())
+			return RESUME_HOST;
+		ret = kvmppc_do_h_read(vcpu, kvmppc_get_gpr(vcpu, 4),
+				       kvmppc_get_gpr(vcpu, 5), false);
+		break;
+	case H_CLEAR_MOD:
+		if (!kvmhv_on_pseries())
+			return RESUME_HOST;
+		ret = kvmppc_do_h_clear_mod(vcpu, kvmppc_get_gpr(vcpu, 4),
+					    kvmppc_get_gpr(vcpu, 5), false);
+		break;
+	case H_CLEAR_REF:
+		if (!kvmhv_on_pseries())
+			return RESUME_HOST;
+		ret = kvmppc_do_h_clear_ref(vcpu, kvmppc_get_gpr(vcpu, 4),
+					    kvmppc_get_gpr(vcpu, 5), false);
+		break;
+	case H_PROTECT:
+		if (!kvmhv_on_pseries())
+			return RESUME_HOST;
+		ret = kvmppc_do_h_protect(vcpu, kvmppc_get_gpr(vcpu, 4),
+					  kvmppc_get_gpr(vcpu, 5),
+					  kvmppc_get_gpr(vcpu, 6),
+					  0UL, false);
+		break;
+	case H_BULK_REMOVE:
+		if (!kvmhv_on_pseries())
+			return RESUME_HOST;
+		ret = kvmppc_do_h_bulk_remove(vcpu, false);
+		break;
 	case H_CEDE:
 		break;
 	case H_PROD:
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 9f7ad4eaa528..bd31d36332a8 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -137,7 +137,7 @@ static void kvmppc_set_dirty_from_hpte(struct kvm *kvm,
 static unsigned long *revmap_for_hpte(struct kvm *kvm, unsigned long hpte_v,
 				      unsigned long hpte_gr,
 				      struct kvm_memory_slot **memslotp,
-				      unsigned long *gfnp)
+				      unsigned long *gfnp, bool realmode)
 {
 	struct kvm_memory_slot *memslot;
 	unsigned long *rmap;
@@ -152,14 +152,17 @@ static unsigned long *revmap_for_hpte(struct kvm *kvm, unsigned long hpte_v,
 	if (!memslot)
 		return NULL;
 
-	rmap = real_vmalloc_addr(&memslot->arch.rmap[gfn - memslot->base_gfn]);
+	rmap = &memslot->arch.rmap[gfn - memslot->base_gfn];
+	if (realmode)
+		rmap = real_vmalloc_addr(rmap);
 	return rmap;
 }
 
 /* Remove this HPTE from the chain for a real page */
 static void remove_revmap_chain(struct kvm *kvm, long pte_index,
 				struct revmap_entry *rev,
-				unsigned long hpte_v, unsigned long hpte_r)
+				unsigned long hpte_v, unsigned long hpte_r,
+				bool realmode)
 {
 	struct revmap_entry *next, *prev;
 	unsigned long ptel, head;
@@ -170,14 +173,18 @@ static void remove_revmap_chain(struct kvm *kvm, long pte_index,
 
 	rcbits = hpte_r & (HPTE_R_R | HPTE_R_C);
 	ptel = rev->guest_rpte |= rcbits;
-	rmap = revmap_for_hpte(kvm, hpte_v, ptel, &memslot, &gfn);
+	rmap = revmap_for_hpte(kvm, hpte_v, ptel, &memslot, &gfn, realmode);
 	if (!rmap)
 		return;
 	lock_rmap(rmap);
 
 	head = *rmap & KVMPPC_RMAP_INDEX;
-	next = real_vmalloc_addr(&kvm->arch.hpt.rev[rev->forw]);
-	prev = real_vmalloc_addr(&kvm->arch.hpt.rev[rev->back]);
+	next = &kvm->arch.hpt.rev[rev->forw];
+	if (realmode)
+		next = real_vmalloc_addr(next);
+	prev = &kvm->arch.hpt.rev[rev->back];
+	if (realmode)
+		prev = real_vmalloc_addr(prev);
 	next->back = rev->back;
 	prev->forw = rev->forw;
 	if (head == pte_index) {
@@ -475,7 +482,7 @@ static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 
 long kvmppc_do_h_remove(struct kvm *kvm, unsigned long flags,
 			unsigned long pte_index, unsigned long avpn,
-			unsigned long *hpret)
+			bool realmode, unsigned long *hpret)
 {
 	__be64 *hpte;
 	unsigned long v, r, rb;
@@ -502,7 +509,9 @@ long kvmppc_do_h_remove(struct kvm *kvm, unsigned long flags,
 		return H_NOT_FOUND;
 	}
 
-	rev = real_vmalloc_addr(&kvm->arch.hpt.rev[pte_index]);
+	rev = &kvm->arch.hpt.rev[pte_index];
+	if (realmode)
+		rev = real_vmalloc_addr(rev);
 	v = pte & ~HPTE_V_HVLOCK;
 	if (v & HPTE_V_VALID) {
 		hpte[0] &= ~cpu_to_be64(HPTE_V_VALID);
@@ -518,7 +527,7 @@ long kvmppc_do_h_remove(struct kvm *kvm, unsigned long flags,
 		 * obtain reliable values of R and C.
 		 */
 		remove_revmap_chain(kvm, pte_index, rev, v,
-				    be64_to_cpu(hpte[1]));
+				    be64_to_cpu(hpte[1]), realmode);
 	}
 	r = rev->guest_rpte & ~HPTE_GR_RESERVED;
 	note_hpte_modification(kvm, rev);
@@ -538,11 +547,11 @@ EXPORT_SYMBOL_GPL(kvmppc_do_h_remove);
 long kvmppc_h_remove(struct kvm_vcpu *vcpu, unsigned long flags,
 		     unsigned long pte_index, unsigned long avpn)
 {
-	return kvmppc_do_h_remove(vcpu->kvm, flags, pte_index, avpn,
+	return kvmppc_do_h_remove(vcpu->kvm, flags, pte_index, avpn, true,
 				  &vcpu->arch.regs.gpr[4]);
 }
 
-long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
+long kvmppc_do_h_bulk_remove(struct kvm_vcpu *vcpu, bool realmode)
 {
 	struct kvm *kvm = vcpu->kvm;
 	unsigned long *args = &vcpu->arch.regs.gpr[4];
@@ -615,7 +624,9 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
 			}
 
 			args[j] = ((0x80 | flags) << 56) + pte_index;
-			rev = real_vmalloc_addr(&kvm->arch.hpt.rev[pte_index]);
+			rev = &kvm->arch.hpt.rev[pte_index];
+			if (realmode)
+				rev = real_vmalloc_addr(rev);
 			note_hpte_modification(kvm, rev);
 
 			if (!(hp0 & HPTE_V_VALID)) {
@@ -650,7 +661,7 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
 			hp = hptes[k];
 			rev = revs[k];
 			remove_revmap_chain(kvm, pte_index, rev,
-				be64_to_cpu(hp[0]), be64_to_cpu(hp[1]));
+				be64_to_cpu(hp[0]), be64_to_cpu(hp[1]), true);
 			rcbits = rev->guest_rpte & (HPTE_R_R|HPTE_R_C);
 			args[j] |= rcbits << (56 - 5);
 			__unlock_hpte(hp, 0);
@@ -659,10 +670,16 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvmppc_do_h_bulk_remove);
 
-long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
-		      unsigned long pte_index, unsigned long avpn,
-		      unsigned long va)
+long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
+{
+	return kvmppc_do_h_bulk_remove(vcpu, true);
+}
+
+long kvmppc_do_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
+			 unsigned long pte_index, unsigned long avpn,
+			 unsigned long va, bool realmode)
 {
 	struct kvm *kvm = vcpu->kvm;
 	__be64 *hpte;
@@ -695,7 +712,9 @@ long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
 	/* Update guest view of 2nd HPTE dword */
 	mask = HPTE_R_PP0 | HPTE_R_PP | HPTE_R_N |
 		HPTE_R_KEY_HI | HPTE_R_KEY_LO;
-	rev = real_vmalloc_addr(&kvm->arch.hpt.rev[pte_index]);
+	rev = &kvm->arch.hpt.rev[pte_index];
+	if (realmode)
+		rev = real_vmalloc_addr(rev);
 	if (rev) {
 		r = (rev->guest_rpte & ~mask) | bits;
 		rev->guest_rpte = r;
@@ -730,9 +749,17 @@ long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
 
 	return H_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(kvmppc_do_h_protect);
 
-long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
-		   unsigned long pte_index)
+long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
+		      unsigned long pte_index, unsigned long avpn,
+		      unsigned long va)
+{
+	return kvmppc_do_h_protect(vcpu, flags, pte_index, avpn, va, true);
+}
+
+long kvmppc_do_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
+		      unsigned long pte_index, bool realmode)
 {
 	struct kvm *kvm = vcpu->kvm;
 	__be64 *hpte;
@@ -748,7 +775,9 @@ long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
 		pte_index &= ~3;
 		n = 4;
 	}
-	rev = real_vmalloc_addr(&kvm->arch.hpt.rev[pte_index]);
+	rev = &kvm->arch.hpt.rev[pte_index];
+	if (realmode)
+		rev = real_vmalloc_addr(rev);
 	for (i = 0; i < n; ++i, ++pte_index) {
 		hpte = (__be64 *)(kvm->arch.hpt.virt + (pte_index << 4));
 		v = be64_to_cpu(hpte[0]) & ~HPTE_V_HVLOCK;
@@ -770,9 +799,16 @@ long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
 	}
 	return H_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(kvmppc_do_h_read);
 
-long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
-			unsigned long pte_index)
+long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
+		   unsigned long pte_index)
+{
+	return kvmppc_do_h_read(vcpu, flags, pte_index, true);
+}
+
+long kvmppc_do_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
+			   unsigned long pte_index, bool realmode)
 {
 	struct kvm *kvm = vcpu->kvm;
 	__be64 *hpte;
@@ -786,7 +822,9 @@ long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
 	if (pte_index >= kvmppc_hpt_npte(&kvm->arch.hpt))
 		return H_PARAMETER;
 
-	rev = real_vmalloc_addr(&kvm->arch.hpt.rev[pte_index]);
+	rev = &kvm->arch.hpt.rev[pte_index];
+	if (realmode)
+		rev = real_vmalloc_addr(rev);
 	hpte = (__be64 *)(kvm->arch.hpt.virt + (pte_index << 4));
 	while (!try_lock_hpte(hpte, HPTE_V_HVLOCK))
 		cpu_relax();
@@ -804,7 +842,8 @@ long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
 		gr |= r & (HPTE_R_R | HPTE_R_C);
 		if (r & HPTE_R_R) {
 			kvmppc_clear_ref_hpte(kvm, hpte, pte_index);
-			rmap = revmap_for_hpte(kvm, v, gr, NULL, NULL);
+			rmap = revmap_for_hpte(kvm, v, gr, NULL, NULL,
+					       realmode);
 			if (rmap) {
 				lock_rmap(rmap);
 				*rmap |= KVMPPC_RMAP_REFERENCED;
@@ -818,10 +857,17 @@ long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
 	unlock_hpte(hpte, v & ~HPTE_V_HVLOCK);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvmppc_do_h_clear_ref);
 
-long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
+long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
 			unsigned long pte_index)
 {
+	return kvmppc_do_h_clear_ref(vcpu, flags, pte_index, true);
+}
+
+long kvmppc_do_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
+			   unsigned long pte_index, bool realmode)
+{
 	struct kvm *kvm = vcpu->kvm;
 	__be64 *hpte;
 	unsigned long v, r, gr;
@@ -833,7 +879,9 @@ long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 	if (pte_index >= kvmppc_hpt_npte(&kvm->arch.hpt))
 		return H_PARAMETER;
 
-	rev = real_vmalloc_addr(&kvm->arch.hpt.rev[pte_index]);
+	rev = &kvm->arch.hpt.rev[pte_index];
+	if (realmode)
+		rev = real_vmalloc_addr(rev);
 	hpte = (__be64 *)(kvm->arch.hpt.virt + (pte_index << 4));
 	while (!try_lock_hpte(hpte, HPTE_V_HVLOCK))
 		cpu_relax();
@@ -865,6 +913,13 @@ long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 	unlock_hpte(hpte, v & ~HPTE_V_HVLOCK);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvmppc_do_h_clear_mod);
+
+long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
+			unsigned long pte_index)
+{
+	return kvmppc_do_h_clear_mod(vcpu, flags, pte_index, true);
+}
 
 static int kvmppc_get_hpa(struct kvm_vcpu *vcpu, unsigned long gpa,
 			  int writing, unsigned long *hpa,
-- 
2.13.6

