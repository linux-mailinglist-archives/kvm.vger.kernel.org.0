Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A273E8618
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 00:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhHJWdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 18:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhHJWdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 18:33:14 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC8EC0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:32:51 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q72-20020a17090a1b4eb0290177884285a6so151451pjq.2
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=00ZMQWWrPnTtriCG8SBJuuMaQXJlszZtdg67sPgdI/k=;
        b=b4TEoEHibgtArcgU5tE6LTnUNCXRWt5oXS8XInj6uvzhOXp+5IMvJTiNnanSwrNxzZ
         JNa5WuA3g9KnlvPXV3dwANwBo+kdSXoix7+rwxcoHSdwrldY6RHEwkKROoLTM0j/6upk
         OfNJAeK8V7pr9uUzRtIzJvzveXP7eQYd1MOTojjKfO/BlMnin7FntnqDkt2mqevhSOtv
         vXspXWtp3hjB6lTmUqtieh25LZ8pHGSL6kfb7QoItz4ALgfPIFNMH1Pao6vyf9qIvHsy
         ZCEjRNzLKwQpEYomb1niFadN/X77nM6xFGZ7lVaoqqxAp8WpP57eBoBxPE89dAMOqXRx
         ROmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=00ZMQWWrPnTtriCG8SBJuuMaQXJlszZtdg67sPgdI/k=;
        b=NmHqxHyYxBBJjGmNZQ0HdhdHxbae85DDw6v1AzeyS1f4QZ4aZU5FcmKGNJswDwpNxN
         VX9EyVnVN6mvTGIuP33ciSmS3mg6V/38Kd0E3iMpvBgvnCYdI2WboHjPWaZ9FuJ/KfvL
         rkI/DO4A6Qlbsvj0gMF/yj1FJACFsm8CUZ7sS9+CaQK7Pr9UB16g6nDDi+K2zqg0YOIL
         eSNskGo7q3fcd38uwYYpn1q/1vQmUznYeNt5IjcU7CtAWZeCgd7h3hRPplv1TdgMFFOw
         4BxoPeeYMoEbFBTO2tdc3el5sDkXdfL2tEFJuFYW+naf+XdCHsnJk9xIB1YPyi3qjhVD
         B0Ew==
X-Gm-Message-State: AOAM5336ekhyVuA0j/Z5Zc/xLhd5eU/8s71V7QTt0+69yjJy2CKGlGT0
        G5lhoHvzfP2Die3OESuSZ51+p5Emls7aVizyy8Bd8TBYOv4yftUq2KK2KJYcpVIiNE21q2rWkMo
        d7lqjHrWN0D0SW90TK9wG9UgTDHfE2O0K+cjxxrLiLu5gueskJu8+J+o7FKetq68lunsljV4=
X-Google-Smtp-Source: ABdhPJydalLA/jRgj6Nhgmv8xUc+XGDGljHpp00AVmtDKGoywQiAjnc3hfU6gAH1vq4eXTiUpFlIk6rXV98LOIqVhw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:8148:0:b029:31b:10b4:f391 with
 SMTP id d8-20020aa781480000b029031b10b4f391mr24985012pfn.69.1628634770190;
 Tue, 10 Aug 2021 15:32:50 -0700 (PDT)
Date:   Tue, 10 Aug 2021 22:32:38 +0000
Message-Id: <20210810223238.979194-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of dirty pages
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

Add a generic VM stats dirty_pages to record the number of dirty pages
reflected in dirty_bitmap at the moment.

Original-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  8 ++++++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  1 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    |  1 +
 include/linux/kvm_host.h               |  3 ++-
 include/linux/kvm_types.h              |  1 +
 virt/kvm/kvm_main.c                    | 26 +++++++++++++++++++++++---
 6 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index c63e263312a4..e4aafa10efa1 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
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
index b5905ae4377c..3a6cb3854a44 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1150,6 +1150,7 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 		j = i + 1;
 		if (npages) {
 			set_dirty_bits(map, i, npages);
+			kvm->stat.generic.dirty_pages += npages;
 			j = i + npages;
 		}
 	}
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 632b2545072b..16806bc473fa 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -109,6 +109,7 @@ void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
 	npages = (psize + PAGE_SIZE - 1) / PAGE_SIZE;
 	gfn -= memslot->base_gfn;
 	set_dirty_bits_atomic(memslot->dirty_bitmap, gfn, npages);
+	kvm->stat.generic.dirty_pages += npages;
 }
 EXPORT_SYMBOL_GPL(kvmppc_update_dirty_map);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f50bfcf225f0..1e8e66fb915b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1421,7 +1421,8 @@ struct _kvm_stats_desc {
 		KVM_STATS_BASE_POW10, -9)
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
+	STATS_DESC_COUNTER(VM_GENERIC, dirty_pages)
 
 #define KVM_GENERIC_VCPU_STATS()					       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ed6a985c5680..6c05df00aebf 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -78,6 +78,7 @@ struct kvm_mmu_memory_cache {
 
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
+	u64 dirty_pages;
 };
 
 struct kvm_vcpu_stat_generic {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a438a7a3774a..93f0ca2ea326 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1228,6 +1228,19 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
+static inline unsigned long hweight_dirty_bitmap(
+						struct kvm_memory_slot *memslot)
+{
+	unsigned long i;
+	unsigned long count = 0;
+	unsigned long n = kvm_dirty_bitmap_bytes(memslot);
+
+	for (i = 0; i < n / sizeof(long); ++i)
+		count += hweight_long(memslot->dirty_bitmap[i]);
+
+	return count;
+}
+
 /*
  * Delete a memslot by decrementing the number of used slots and shifting all
  * other entries in the array forward one spot.
@@ -1612,6 +1625,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	if (r)
 		return r;
 
+	kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(old);
 	kvm_free_memslot(kvm, old);
 	return 0;
 }
@@ -1733,8 +1747,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_bitmap;
 
-	if (old.dirty_bitmap && !new.dirty_bitmap)
+	if (old.dirty_bitmap && !new.dirty_bitmap) {
+		kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(&old);
 		kvm_destroy_dirty_bitmap(&old);
+	}
 	return 0;
 
 out_bitmap:
@@ -1895,6 +1911,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 			offset = i * BITS_PER_LONG;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
+			kvm->stat.generic.dirty_pages -= hweight_long(mask);
 		}
 		KVM_MMU_UNLOCK(kvm);
 	}
@@ -2012,6 +2029,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 			flush = true;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
+			kvm->stat.generic.dirty_pages -= hweight_long(mask);
 		}
 	}
 	KVM_MMU_UNLOCK(kvm);
@@ -3062,11 +3080,13 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-		if (kvm->dirty_ring_size)
+		if (kvm->dirty_ring_size) {
 			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
 					    slot, rel_gfn);
-		else
+		} else {
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+			++kvm->stat.generic.dirty_pages;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);

base-commit: d0732b0f8884d9cc0eca0082bbaef043f3fef7fb
-- 
2.32.0.605.g8dce9f2422-goog

