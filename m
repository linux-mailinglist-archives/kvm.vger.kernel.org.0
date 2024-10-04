Return-Path: <kvm+bounces-27992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9F5991018
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 22:17:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C29551F273FA
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 20:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2991E22FC;
	Fri,  4 Oct 2024 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4yG4Ff0s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72501E1C3B
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728071748; cv=none; b=UWQ6rg4sHvWz9oogF4sA7xEDmhFu3xZ1vo/+2jgffJ/lc9PI4KoJPb7H4LXVeP7lDIfqdg+nbMT4ET+iVzec66F7pp8bZ7D9/Wz9sQ+KVqakNHh3JdCbhlk4BxZrmzxAfDl63W0avRHYIPJG3OE17Sic0evIHRP4DYO4digSVKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728071748; c=relaxed/simple;
	bh=pxrOalPvNLDtJQpdCW/G4HAMuEe//eQGLVWKtOXkXEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IN75e7rQcyEo/FkEzCaSzZmUuLNfG9Gl0yetgD1CPlGQFGl4IPvM7d2WuaUXMPCnCgifgn5mfuDc2woml3HYg6X3HLQuoccmP/K5X4yG6nGZVyG8GoWEZqLME+tK2i8LOoJ6cdexdyZWtVIanEDHJdpANgZcLFnOAWY+kDNBioc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4yG4Ff0s; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e288a73e967so2812518276.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 12:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728071746; x=1728676546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hTtzmO1m4B2S+nZ7TcqJj3+RjDp8RGQCqP+9mB7XDF0=;
        b=4yG4Ff0s4xBv7dBQI/gP/p/8ZfX3okg+C7Wag62Jn+3fQ1RhDTh42BCbP20Q7bI2B6
         aDkTY+Zmia7NeRKArZHmLZeWk5MlUFX7Hb4u6EloWDUBZ7dOK8gvYQwwbciYGCGRdCMK
         7JI3k98zJ6TQ4rcW+dmHcgXv94V0YYsf6iMqW6glo7TYCDIEAsB28fm3pkdu/IFSmbbE
         m9XtUNCds6u/RtCdi+fNod76m0NA1VUvM6+YkhbvHKurxwLpXepFGsk2jKzqcTU+0fOA
         bWz8bmS7YUj39oSgsygSAsxoZ1vBW/IscDftGp0lCSnu19wEP0P4XplRR0hULk5mN+Vs
         nG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728071746; x=1728676546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hTtzmO1m4B2S+nZ7TcqJj3+RjDp8RGQCqP+9mB7XDF0=;
        b=JMQCPU9xJzuKRa557gzdRargle+WSxCqL5D3WQMCtJfmFj1zyNn3vIewJrTjTVLNKx
         uNVGGR9IPeOgboC4GYeQM//R2VHHhB3Ju+LrBb2JUBloLmD3P88GWM18seB3GfhuuFmG
         sWClZE8Z3++fScvNbyi7GesR2KrRSGEieVugA6lpGmr9Be53MuSvCqWdhrzaQQSvdIIk
         1jcizr/UgmuxHa5YgqQ41ERHdIR3tO0zEnBUdobloSnE/Lfr/5UMJqCFcBxPJXHxa22d
         Bq4UITGbmQm6HkUQtVsL3LkfKeNQAt40M9d9k6gF4tIvQWsVi7H8etHGd67HmfWLIdAv
         od0w==
X-Forwarded-Encrypted: i=1; AJvYcCW/4B139xumpE4GZEOmHvobz0C/uLfqZA+YomRjjIwsoBCiZr0nOWtX7K8VAdkyE+LSvfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhahoQeL26LXgHY8aIfXhPJ9TTvl+rVCP8dh31W5WpvfAu6aMS
	KWAVmSnACQDGz6YpyG+4UTKQkl95gImDn6M1epV/8J5vs7nCnwmi/R/ixxOzLALXlIAecZdGlu9
	9bwCStQ==
X-Google-Smtp-Source: AGHT+IEEsD5A0BwWtlIz55ngwUefLRO7WKaELLKBP0aGBOdeR0m0uLwRikmx58xSNYxITBmsz09MGuwHQ3J3
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a25:adc2:0:b0:e24:9584:52d3 with SMTP id
 3f1490d57ef6-e28936b99bamr6758276.2.1728071745774; Fri, 04 Oct 2024 12:55:45
 -0700 (PDT)
Date: Fri,  4 Oct 2024 12:55:38 -0700
In-Reply-To: <20241004195540.210396-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241004195540.210396-1-vipinsh@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241004195540.210396-2-vipinsh@google.com>
Subject: [PATCH v2 1/3] KVM: x86/mmu: Change KVM mmu shrinker to no-op
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove global kvm_total_used_mmu_pages and page zapping flow from MMU
shrinker. Keep shrinker infrastructure in place to reuse in future
commits for freeing KVM page caches. Remove zapped_obsolete_pages list
from struct kvm_arch{} and use local list in kvm_zap_obsolete_pages()
since MMU shrinker is not using it anymore.

mmu_shrink_scan() is very disruptive to VMs. It picks the first VM in
the vm_list, zaps the oldest page which is most likely an upper level
SPTEs and most like to be reused. Prior to TDP MMU, this is even more
disruptive in nested VMs case, considering L1 SPTEs will be the oldest
even though most of the entries are for L2 SPTEs.

As discussed in
https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/ shrinker logic
has not be very useful in actually keeping VMs performant and reducing
memory usage.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 92 +++------------------------------
 2 files changed, 8 insertions(+), 85 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b0c0bc0ed813f..cbfe31bac6cf6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1309,7 +1309,6 @@ struct kvm_arch {
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
-	struct list_head zapped_obsolete_pages;
 	/*
 	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
 	 * replaced by an NX huge page.  A shadow page is on this list if its
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d25c2b395116e..213e46b55dda2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -179,7 +179,6 @@ struct kvm_shadow_walk_iterator {
 
 static struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
-static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 
@@ -1651,27 +1650,15 @@ static void kvm_mmu_check_sptes_at_free(struct kvm_mmu_page *sp)
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
 
@@ -6338,6 +6325,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
+	LIST_HEAD(invalid_list);
 	bool unstable;
 
 restart:
@@ -6371,7 +6359,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		}
 
 		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
-				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
+				&invalid_list, &nr_zapped);
 		batch += nr_zapped;
 
 		if (unstable)
@@ -6387,7 +6375,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 	 * kvm_mmu_load()), and the reload in the caller ensure no vCPUs are
 	 * running with an obsolete MMU.
 	 */
-	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 }
 
 /*
@@ -6450,16 +6438,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
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
 
@@ -7015,65 +6997,13 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 				     struct shrink_control *sc)
 {
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
+	return SHRINK_STOP;
 }
 
 static unsigned long mmu_shrink_count(struct shrinker *shrink,
 				      struct shrink_control *sc)
 {
-	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
+	return SHRINK_EMPTY;
 }
 
 static struct shrinker *mmu_shrinker;
@@ -7204,12 +7134,9 @@ int kvm_mmu_vendor_module_init(void)
 	if (!mmu_page_header_cache)
 		goto out;
 
-	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
-		goto out;
-
 	mmu_shrinker = shrinker_alloc(0, "x86-mmu");
 	if (!mmu_shrinker)
-		goto out_shrinker;
+		goto out;
 
 	mmu_shrinker->count_objects = mmu_shrink_count;
 	mmu_shrinker->scan_objects = mmu_shrink_scan;
@@ -7219,8 +7146,6 @@ int kvm_mmu_vendor_module_init(void)
 
 	return 0;
 
-out_shrinker:
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 out:
 	mmu_destroy_caches();
 	return ret;
@@ -7237,7 +7162,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 	shrinker_free(mmu_shrinker);
 }
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog


