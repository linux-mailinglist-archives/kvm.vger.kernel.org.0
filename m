Return-Path: <kvm+bounces-30378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5519B9943
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 21:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A999B21D2E
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CA91E2610;
	Fri,  1 Nov 2024 20:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oOBmhYPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B031D4177
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 20:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492086; cv=none; b=MPD9caNSG7fiOZS0j7/EUVc33AFuecjge0lgZyEy7HduWDZeQ1XQ9ZVqA2NGfpkSb1w2BwhAzyWYQG0/EKV2CaIIowlE1YRdYeQbWjsTYDipw1XPnV6/n6sNluS38SKBB8F+8LPA5rp2I9YSK6LkxxujEzDeStZfOJk14hweXNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492086; c=relaxed/simple;
	bh=lDsHgz9pKSuRuH9kBOLZEhY3s9XaiF7nBz45LFRJ5bU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VfNWCs5i4VCoi92yDNN5lB+N1XYSN2ULKITLZRWAN2xFopIQftUJnjKGagHiszqLWnbfFRV27JImlqKZRl5It7GfZuBUUU6r1fRcFVE1gWlDjj9QR91PMUFAdEIw5w+Dk8U3PccPBy/QejNS7HormNpmq8HQy5AH+Vp/zeiq41k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oOBmhYPJ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e355f1ff4bso46934727b3.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 13:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730492082; x=1731096882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uM4FywoyCqYZ46XNt51PzJLHMBFC4neHJbEku/Dteqg=;
        b=oOBmhYPJidcyaxhwai/lIqLuLELZeUObsCXLs1UfEbfgpXb1ev+UmV7K7J5rPOboHI
         knqYXmMMqzFPWIY2+lmahukFxT8IMakTTWjEcHUofPtNjB91oLgpJWglwmubcpaMCcSy
         QMpyFy/JRTTQuVwczXQ/v5CyMwbsIV8jngXqQGXz27qMnYjD9TjlDRbZ6jpJ28KEKOWp
         L9G+ESTNG9bIsaOdvb2yxftxWtfkISlqOmhY8lfb2dypGm6aS/WkTsmTAiw27EQSaUsn
         ACF7qQOWqtnCImJLPYdyMocqtktwVgTMly/pfQBKWd73EpKIsSKNd27C9L0HT6SdZlIf
         TFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730492082; x=1731096882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uM4FywoyCqYZ46XNt51PzJLHMBFC4neHJbEku/Dteqg=;
        b=kKtHpBNoEajWmW17cAmniUYWv0RyUD2UQnVl9AIYhT00QyPCYGPkcxCSq4PYO47ydT
         Bgwc+NwX+gNuEDrYl5689NAOMVHBYcqJb00OGoiE9u6WOlX46LW5xF+PyElUoEfHG2xW
         r1OgNP/cE5/hs9pF/tg6foY+sQl3+lmi5SqHB6YAOotRC9BJHPEIVFKjSjT2/WogcCeZ
         wUcgTaX2kWyomVJ/659YKma8IcPJQ7As/G4cqV56TtuPyvodOs85ZnRcgbe0kbYblsVM
         t0guG0p4GDG0Flju0AFhcgyZ01kcYnwDVUSk9Nswb2pniCl1vNnQgkZOD+bjAYrgZTBm
         +eXA==
X-Forwarded-Encrypted: i=1; AJvYcCWQsvoZBAOIJ7jF9DpoihPH/0FE1niKvT7Svu/MfUpAv8H0IS8JLYQmR2CHFoHx7Sm/jiE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ZnPLK/MzZCapGbwRNw59AktgYAcQoac+CTJL1RwKc0+/wIjd
	6oCkFC4WhY8sH+ND+o7go+zd27gDv0SMLa2JCOssxYCkaaYHW6Zgm857lVm1XzO4OlvK6Cdo8/g
	lzd4Eug==
X-Google-Smtp-Source: AGHT+IHkvayqxPvPT+OuRHcrPJUNO7XXBhe+H8g8uC50jF7qEsqHqllJM8vn54LRySZYAYTqMYHSANY+ziLx
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a25:3602:0:b0:e22:3aea:6eb5 with SMTP id
 3f1490d57ef6-e3302686c15mr5066276.7.1730492082565; Fri, 01 Nov 2024 13:14:42
 -0700 (PDT)
Date: Fri,  1 Nov 2024 13:14:37 -0700
In-Reply-To: <20241101201437.1604321-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101201437.1604321-1-vipinsh@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101201437.1604321-2-vipinsh@google.com>
Subject: [PATCH v3 1/1] KVM: x86/mmu: Remove KVM mmu shrinker
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove KVM MMU shrinker and all its related code. Remove global
kvm_total_used_mmu_pages and page zapping flow from MMU shrinker.
Remove zapped_obsolete_pages list from struct kvm_arch{} and use local
list in kvm_zap_obsolete_pages() since MMU shrinker is not using it
anymore.

Current flow of KVM MMU shrinker is very disruptive to VMs. It picks the
first VM in the vm_list, zaps the oldest page which is most likely an
upper level SPTEs and most like to be reused. Prior to TDP MMU, this is
even more disruptive in nested VMs case, considering L1 SPTEs will be
the oldest even though most of the entries are for L2 SPTEs.

As discussed in [1] shrinker logic has not be very useful in actually
keeping VMs performant and reducing memory usage.

There was an alternative suggested [2] to repurpose shrinker for
shrinking vCPU caches. But considering that in all of the KVM MMU
shrinker history it hasn't been used/needed/complained, and there has
not been any conversation regarding KVM using lots of page tables, it
might be better to just not have shrinker. If the need arise [2] can be
revisited.

[1] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/
[2] https://lore.kernel.org/kvm/20241004195540.210396-3-vipinsh@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |   1 -
 arch/x86/kvm/mmu/mmu.c          | 111 ++------------------------------
 2 files changed, 5 insertions(+), 107 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70c7ed0ef1847..3e8afc82ae2fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1306,7 +1306,6 @@ struct kvm_arch {
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
-	struct list_head zapped_obsolete_pages;
 	/*
 	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
 	 * replaced by an NX huge page.  A shadow page is on this list if its
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 443845bb2e011..3116c4c31d87c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -179,7 +179,6 @@ struct kvm_shadow_walk_iterator {
 
 static struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
-static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 
@@ -1622,27 +1621,15 @@ static void kvm_mmu_check_sptes_at_free(struct kvm_mmu_page *sp)
 #endif
 }
 
-/*
- * This value is the sum of all of the kvm instances's
- * kvm->arch.n_used_mmu_pages values.  We need a global,
- * aggregate version in order to make the slab shrinker
- * faster
- */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
-{
-	kvm->arch.n_used_mmu_pages += nr;
-	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
-}
-
 static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm->arch.n_used_mmu_pages++;
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
 }
 
 static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	kvm_mod_used_mmu_pages(kvm, -1);
+	kvm->arch.n_used_mmu_pages--;
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
 }
 
@@ -6380,6 +6367,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
+	LIST_HEAD(invalid_list);
 	bool unstable;
 
 restart:
@@ -6413,7 +6401,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		}
 
 		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
-				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
+				&invalid_list, &nr_zapped);
 		batch += nr_zapped;
 
 		if (unstable)
@@ -6429,7 +6417,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 	 * kvm_mmu_load()), and the reload in the caller ensure no vCPUs are
 	 * running with an obsolete MMU.
 	 */
-	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 }
 
 /*
@@ -6492,16 +6480,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
-static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
-{
-	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
-}
-
 void kvm_mmu_init_vm(struct kvm *kvm)
 {
 	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
-	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
@@ -7112,72 +7094,6 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
-static unsigned long mmu_shrink_scan(struct shrinker *shrink,
-				     struct shrink_control *sc)
-{
-	struct kvm *kvm;
-	int nr_to_scan = sc->nr_to_scan;
-	unsigned long freed = 0;
-
-	mutex_lock(&kvm_lock);
-
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int idx;
-
-		/*
-		 * Never scan more than sc->nr_to_scan VM instances.
-		 * Will not hit this condition practically since we do not try
-		 * to shrink more than one VM and it is very unlikely to see
-		 * !n_used_mmu_pages so many times.
-		 */
-		if (!nr_to_scan--)
-			break;
-		/*
-		 * n_used_mmu_pages is accessed without holding kvm->mmu_lock
-		 * here. We may skip a VM instance errorneosly, but we do not
-		 * want to shrink a VM that only started to populate its MMU
-		 * anyway.
-		 */
-		if (!kvm->arch.n_used_mmu_pages &&
-		    !kvm_has_zapped_obsolete_pages(kvm))
-			continue;
-
-		idx = srcu_read_lock(&kvm->srcu);
-		write_lock(&kvm->mmu_lock);
-
-		if (kvm_has_zapped_obsolete_pages(kvm)) {
-			kvm_mmu_commit_zap_page(kvm,
-			      &kvm->arch.zapped_obsolete_pages);
-			goto unlock;
-		}
-
-		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
-
-unlock:
-		write_unlock(&kvm->mmu_lock);
-		srcu_read_unlock(&kvm->srcu, idx);
-
-		/*
-		 * unfair on small ones
-		 * per-vm shrinkers cry out
-		 * sadness comes quickly
-		 */
-		list_move_tail(&kvm->vm_list, &vm_list);
-		break;
-	}
-
-	mutex_unlock(&kvm_lock);
-	return freed;
-}
-
-static unsigned long mmu_shrink_count(struct shrinker *shrink,
-				      struct shrink_control *sc)
-{
-	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
-}
-
-static struct shrinker *mmu_shrinker;
-
 static void mmu_destroy_caches(void)
 {
 	kmem_cache_destroy(pte_list_desc_cache);
@@ -7304,23 +7220,8 @@ int kvm_mmu_vendor_module_init(void)
 	if (!mmu_page_header_cache)
 		goto out;
 
-	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
-		goto out;
-
-	mmu_shrinker = shrinker_alloc(0, "x86-mmu");
-	if (!mmu_shrinker)
-		goto out_shrinker;
-
-	mmu_shrinker->count_objects = mmu_shrink_count;
-	mmu_shrinker->scan_objects = mmu_shrink_scan;
-	mmu_shrinker->seeks = DEFAULT_SEEKS * 10;
-
-	shrinker_register(mmu_shrinker);
-
 	return 0;
 
-out_shrinker:
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 out:
 	mmu_destroy_caches();
 	return ret;
@@ -7337,8 +7238,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
-	shrinker_free(mmu_shrinker);
 }
 
 /*
-- 
2.47.0.163.g1226f6d8fa-goog


