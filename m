Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974AB3E9B49
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 01:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhHKXiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 19:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhHKXiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 19:38:19 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3BCC0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 16:37:55 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id q11-20020a05620a05abb02903ca17a8eef8so2411957qkq.10
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 16:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=q9ZqUbieFs6jgz1HVgOCJORtmP/p3K9isrfy6ssJbQU=;
        b=NrVORnJHJec5v/b4Be84ePI7bHT15bqjFJ7pjbVV8OAfKILjk0j0Rhnhoo6FYCymOp
         BL16GgpNb5a7BuNMKXTPdTj77zE+VwTbPGkWLq7Jwr7kB+d/oLxjjwnWwbLHMSTfQxgY
         JbrgfzRSvbr1drBIVCRObw2gKLo4u/P/w+2SGym0N8CUvoFfQU4nY2ip5GbQSukntfgI
         qLZxC1+i7E8pUYVXo5+hyqI7VGAEKTeLUlyn+G5kw2sWXA+ZoZL3ZZI032D608rZqGJY
         Vahy5q94w3YYfJKJvAxQPARWYDF92MY7hKy96dYl3fmy70Z0Yb1Z1TGpL+oHtdIDnmNV
         oYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=q9ZqUbieFs6jgz1HVgOCJORtmP/p3K9isrfy6ssJbQU=;
        b=ueRDivC121oUrjGNxZxPnrPnguAENsjHw959dArrS/LOsNa854YlL2M/nRwe21MGwV
         aG5MXw01S1Seb64H/KQhlUxNQz0TDJY/0vA15wQaXvVCaLTe1GR7Acv8akRlb57U2CmK
         dt+xNOlpNRnQwbGN8TIkTTVDfjQwfVGSUrevTy/WXbiYMZD12f5Xu/JMVInQyqqlo7K8
         J4ghpA7tFKfpIt2DG7Tr1/7AizsviH+dPeaHIGt4M5T6tWOwhnzSm2u60T+KMcS0Nq7R
         2SE6lyhPQk9qhfFOi+0nD9ptIA2UjQc3w8cFeXINTN7KdTPCg9+/QVtw/coH2QMXjY0p
         1tvA==
X-Gm-Message-State: AOAM5334Z953DmWmXn9u6+A1Dofn2wDCtURj+FAPLk6jqd0xBK1DSehr
        9uUg/Jq9jwpQyOJe8gG2LM5vwspXK2mVsnGsS4fgExGZEuFS8EXOeUJTtneIvZWiZnzOXPcLjND
        li2rQVe+BsuVvq50bO3mQLM2PgSxOoNW2THbpFRQeFrVVUqT2GdPtfMusZvC/3n4LT8cjdao=
X-Google-Smtp-Source: ABdhPJwyxoIvo+2FPWOanEn7WxLVK02DwPiAEzJqepYXmdWzSBu3XQCskwaTq/4nBXkx9LVfxUuf85ziRpwk91jxdw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:e62:: with SMTP id
 jz2mr1092945qvb.21.1628725074341; Wed, 11 Aug 2021 16:37:54 -0700 (PDT)
Date:   Wed, 11 Aug 2021 23:37:44 +0000
Message-Id: <20210811233744.1450962-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v1] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A per VM stat dirty_pages is added to record the number of dirtied pages
in the life cycle of a VM.
The growth rate of this stat is a good indicator during the process of
live migrations. The exact number of dirty pages at the moment doesn't
matter. That's why we define dirty_pages as a cumulative counter instead
of an instantaneous one.

Original-by: Peter Feiner <pfeiner@google.com>
Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/include/asm/kvm_book3s.h  |  3 ++-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 10 +++++++---
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  3 ++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    | 13 ++++++++-----
 include/linux/kvm_host.h               |  3 ++-
 include/linux/kvm_types.h              |  1 +
 virt/kvm/kvm_main.c                    |  2 ++
 7 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index caaa0f592d8e..cee4c7f23c8d 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -237,7 +237,8 @@ extern kvm_pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa,
 			bool writing, bool *writable);
 extern void kvmppc_add_revmap_chain(struct kvm *kvm, struct revmap_entry *rev,
 			unsigned long *rmap, long pte_index, int realmode);
-extern void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
+extern void kvmppc_update_dirty_map(struct kvm *kvm,
+			const struct kvm_memory_slot *memslot,
 			unsigned long gfn, unsigned long psize);
 extern void kvmppc_invalidate_hpte(struct kvm *kvm, __be64 *hptep,
 			unsigned long pte_index);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index c63e263312a4..08194aacd2a6 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -787,7 +787,7 @@ static void kvmppc_unmap_hpte(struct kvm *kvm, unsigned long i,
 		rcbits = be64_to_cpu(hptep[1]) & (HPTE_R_R | HPTE_R_C);
 		*rmapp |= rcbits << KVMPPC_RMAP_RC_SHIFT;
 		if ((rcbits & HPTE_R_C) && memslot->dirty_bitmap)
-			kvmppc_update_dirty_map(memslot, gfn, psize);
+			kvmppc_update_dirty_map(kvm, memslot, gfn, psize);
 		if (rcbits & ~rev[i].guest_rpte) {
 			rev[i].guest_rpte = ptel | rcbits;
 			note_hpte_modification(kvm, &rev[i]);
@@ -1122,8 +1122,10 @@ long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
 		 * since we always put huge-page HPTEs in the rmap chain
 		 * corresponding to their page base address.
 		 */
-		if (npages)
+		if (npages) {
 			set_dirty_bits(map, i, npages);
+			kvm->stat.generic.dirty_pages += npages;
+		}
 		++rmapp;
 	}
 	preempt_enable();
@@ -1178,8 +1180,10 @@ void kvmppc_unpin_guest_page(struct kvm *kvm, void *va, unsigned long gpa,
 	gfn = gpa >> PAGE_SHIFT;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	memslot = gfn_to_memslot(kvm, gfn);
-	if (memslot && memslot->dirty_bitmap)
+	if (memslot && memslot->dirty_bitmap) {
 		set_bit_le(gfn - memslot->base_gfn, memslot->dirty_bitmap);
+		++kvm->stat.generic.dirty_pages;
+	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index b5905ae4377c..dc3fb027020a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -442,7 +442,7 @@ void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
 	kvmhv_remove_nest_rmap_range(kvm, memslot, gpa, hpa, page_size);
 
 	if ((old & _PAGE_DIRTY) && memslot->dirty_bitmap)
-		kvmppc_update_dirty_map(memslot, gfn, page_size);
+		kvmppc_update_dirty_map(kvm, memslot, gfn, page_size);
 }
 
 /*
@@ -1150,6 +1150,7 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 		j = i + 1;
 		if (npages) {
 			set_dirty_bits(map, i, npages);
+			kvm->stat.generic.dirty_pages += npages;
 			j = i + npages;
 		}
 	}
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 632b2545072b..f168ffb0a32b 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -99,7 +99,8 @@ void kvmppc_add_revmap_chain(struct kvm *kvm, struct revmap_entry *rev,
 EXPORT_SYMBOL_GPL(kvmppc_add_revmap_chain);
 
 /* Update the dirty bitmap of a memslot */
-void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
+void kvmppc_update_dirty_map(struct kvm *kvm,
+			     const struct kvm_memory_slot *memslot,
 			     unsigned long gfn, unsigned long psize)
 {
 	unsigned long npages;
@@ -109,6 +110,7 @@ void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
 	npages = (psize + PAGE_SIZE - 1) / PAGE_SIZE;
 	gfn -= memslot->base_gfn;
 	set_dirty_bits_atomic(memslot->dirty_bitmap, gfn, npages);
+	kvm->stat.generic.dirty_pages += npages;
 }
 EXPORT_SYMBOL_GPL(kvmppc_update_dirty_map);
 
@@ -123,7 +125,7 @@ static void kvmppc_set_dirty_from_hpte(struct kvm *kvm,
 	gfn = hpte_rpn(hpte_gr, psize);
 	memslot = __gfn_to_memslot(kvm_memslots_raw(kvm), gfn);
 	if (memslot && memslot->dirty_bitmap)
-		kvmppc_update_dirty_map(memslot, gfn, psize);
+		kvmppc_update_dirty_map(kvm, memslot, gfn, psize);
 }
 
 /* Returns a pointer to the revmap entry for the page mapped by a HPTE */
@@ -182,7 +184,7 @@ static void remove_revmap_chain(struct kvm *kvm, long pte_index,
 	}
 	*rmap |= rcbits << KVMPPC_RMAP_RC_SHIFT;
 	if (rcbits & HPTE_R_C)
-		kvmppc_update_dirty_map(memslot, gfn,
+		kvmppc_update_dirty_map(kvm, memslot, gfn,
 					kvmppc_actual_pgsz(hpte_v, hpte_r));
 	unlock_rmap(rmap);
 }
@@ -941,7 +943,7 @@ static long kvmppc_do_h_page_init_zero(struct kvm_vcpu *vcpu,
 	/* Zero the page */
 	for (i = 0; i < SZ_4K; i += L1_CACHE_BYTES, pa += L1_CACHE_BYTES)
 		dcbz((void *)pa);
-	kvmppc_update_dirty_map(memslot, dest >> PAGE_SHIFT, PAGE_SIZE);
+	kvmppc_update_dirty_map(kvm, memslot, dest >> PAGE_SHIFT, PAGE_SIZE);
 
 out_unlock:
 	arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
@@ -972,7 +974,8 @@ static long kvmppc_do_h_page_init_copy(struct kvm_vcpu *vcpu,
 	/* Copy the page */
 	memcpy((void *)dest_pa, (void *)src_pa, SZ_4K);
 
-	kvmppc_update_dirty_map(dest_memslot, dest >> PAGE_SHIFT, PAGE_SIZE);
+	kvmppc_update_dirty_map(kvm, dest_memslot,
+				dest >> PAGE_SHIFT, PAGE_SIZE);
 
 out_unlock:
 	arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d447b21cdd73..1229a7dd83e3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1444,7 +1444,8 @@ struct _kvm_stats_desc {
 		KVM_STATS_BASE_POW10, -9, sz)
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
+	STATS_DESC_COUNTER(VM_GENERIC, dirty_pages)
 
 #define KVM_GENERIC_VCPU_STATS()					       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index de7fb5f364d8..ff811bac851a 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -80,6 +80,7 @@ struct kvm_mmu_memory_cache {
 
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
+	u64 dirty_pages;
 };
 
 struct kvm_vcpu_stat_generic {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..b99ade3fd2b4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3084,6 +3084,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 					    slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+
+		++kvm->stat.generic.dirty_pages;
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);

base-commit: a3e0b8bd99ab098514bde2434301fa6fde040da2
-- 
2.32.0.605.g8dce9f2422-goog

