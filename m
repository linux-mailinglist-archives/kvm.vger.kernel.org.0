Return-Path: <kvm+bounces-26872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0E5978AC3
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 23:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B08021C22EAC
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 21:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A656417838B;
	Fri, 13 Sep 2024 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0A1E734x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64542156F42
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726263816; cv=none; b=VUGpfpLSsf+HvV0r8cPjNrcwkWixLS8vve6aMbUS+pfMdgB2nFLbeMOeCyNson2cWu8kxv/ZmLWb4rtRJEq6iTgVGCgn9Dz4f0yW/c05+SUWuX0pVc32XEGMUtY6TokYubPbOluZGEIWaNs5EIz4uFuVpD4xK5lqC2Z5yeLWiBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726263816; c=relaxed/simple;
	bh=UMiplNhFL6iRve/RCx2+nrhTmwdADEoqJXCu7JE67gg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YcHZa4TytV9iz0ubB2fnzdzDIKBeqMnvysN+zB2nXxgz8VYsx0C9MpXMhGlm5Xx2+w54aqr12oAll6xoWFyVzH/f+lM/qbbKYKlnaPoiRibLPdtOZd2lwlqe16z8cT2EW8a6LPRJ/QwpZx55om/lrj4p/T+ABm4Fdz6rSokb8k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0A1E734x; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1a892d8438so5411753276.3
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 14:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726263813; x=1726868613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yuLmcJ0VPggadsG42JSJp0FcaxWRbL9ObfSMBg0lrpM=;
        b=0A1E734xO9bGhH4+TcjlcokFjHTdTtnwCui3JzVFAC6brwm7nKj/wFMsJqdzYYvtNR
         Rh/eBEU332gawFujnJqpi5NQd9VmxF7JtLvyCmJ6jArpXv+yLFlRxJLngpA5bpggpFB0
         fi1jz73H9otrXih20t38B3XMvZWKb+txZYlUzIK4hTr13DefCzAOj0H4roebJkN0dV5L
         yiOfwnnEEGEfcHF1Osy3WHJWpATn/uawF0MjROkGaYj0Od6VOq5xvT9BZJhekQwnGGxz
         Ks4og9EJx4t+MEPUJ1cshfUt4ngMCOZXFfy4PhIDT6EVyMwSk7y0sU+3a0Dq9nT2xseJ
         lTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726263813; x=1726868613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuLmcJ0VPggadsG42JSJp0FcaxWRbL9ObfSMBg0lrpM=;
        b=GK6JmF5TSfzgTq9ZkvyBG15eDBDHoeaBAaHs5pr9i+OcONkMQKyrp/zVpAzRzCxPuQ
         1WB4zlkEOsN7r2CWTj8spWwHdxTwPnmbjkOQC7AgaUrST7Uw187o4CrT+dkaXw/hVgGS
         MjpPpDoujpEpXjJSvsYc1jcYrCAksYwfe9NEo5o4QXV0sTLoIWQ5TbnJBanGOz3dsdL+
         ItBZ7Dmg7HsVvXjrBnioySSESXc5Px6FXPR3muo7vwPhJQwqQN+b4nIbZlXcskVXxZNy
         fIHXLXwxbLa2hTYjGP/5yXz7yNGRMW2EGQ4YWo02fJgqxszQQvgq+2dghSXjWYCI0MY0
         vbkg==
X-Forwarded-Encrypted: i=1; AJvYcCULDRLGhe5a35Jb55N7Exm1hU016QL6SSFGQwF21kiBNerSBX/T1y2KdLinB7nFYqghcY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxgUU/D1h3idTe+xMN3ZxUU4RHL8RehkpaBCj137VDFusOnImu
	vV/mA8HLxTh5yJQmOqOANqlgKtVT7dl/lkqrKdarK1C6jHkFw9zHn8Av8vWBJpOpovjwkHUcpWW
	cdI12Bw==
X-Google-Smtp-Source: AGHT+IGX/dvSv1nSclsnhDLH0n2e313lz6ilvvqaLMgpXSFuFsdOkTz+aBp4eiHwnfZ/LU9uQnB8Fiw5eT9V
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a05:6902:1743:b0:e03:3cfa:1aa7 with SMTP id
 3f1490d57ef6-e1d9db9e1b8mr10067276.1.1726263813201; Fri, 13 Sep 2024 14:43:33
 -0700 (PDT)
Date: Fri, 13 Sep 2024 14:43:15 -0700
In-Reply-To: <20240913214316.1945951-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240913214316.1945951-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240913214316.1945951-2-vipinsh@google.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Change KVM mmu shrinker to no-op
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: dmatlack@google.com, zhi.wang.linux@gmail.com, weijiang.yang@intel.com, 
	mizhang@google.com, liangchen.linux@gmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 92 +++------------------------------
 2 files changed, 8 insertions(+), 85 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b0c0bc0ed813..cbfe31bac6cf 100644
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
index d25c2b395116..213e46b55dda 100644
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
2.46.0.662.g92d0881bb0-goog


