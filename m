Return-Path: <kvm+bounces-47449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91BC1AC18EA
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 02:13:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2350316FA08
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 00:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB7A3D984;
	Fri, 23 May 2025 00:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LJKcaoi6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E433A24DD0D
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747959111; cv=none; b=HNyR8nj3xDtFV44OfOw1Iquf8e778fyMM1vOpUfv1uiZ2zyccY2zEcmE14voXHmUNEcQmtuIJyOgjKSBS04ecjmccNvvw1eT81TDBupkEGMV3gE/eAlx4vhnM+gPZrj8PcF2ZkakHURVR9BNeg1CdXTxqXx4WGB/fNaGpXfypsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747959111; c=relaxed/simple;
	bh=B12X3JWhxznlcRgHh2qi4Ak58CALHcWct2odIF6qY+E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mNtYr/tQ9DJ5EblnMMb+WWpUrQwDTT69DOc5Lza6Q7yV9w+XUlRekmiryoq1t8jV56V+i9PBygaqKujxb+MwcyksDknzAs77yB9ZVZWrQpr0Bg4XfjbxViKA84rT1i3KtwSit7lNlXZNQamfRb138LjCOKyss0lPKH9i5WOSkEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LJKcaoi6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e7f19c8cfso9509006a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747959108; x=1748563908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ICBtionEpcInnEHm0R5wGA1N61VckpDnHwHr/zSAgpU=;
        b=LJKcaoi6iqLYwBANDxnMPqiyIjZ96kLA7ipV2whMLREDkbf61+I4FYJZfLLmu2ZpVn
         453G+8V+Yhx1DSUEHCX3uEC5y4mNV80JcZm+V6pmLGYRoEp6LA1Wh9QM6eEVbyC5J6W0
         vDS0QQy4x7NHUxIzkZ3sipBqQOrS4m0zNqVGkuxXoge0y5uuSBDuHvyB3vly/TQOP7Va
         TQ6f6hrMGvkYUIaDU5AnNHDj60N2ahzlB2EERXvNEFB0pq4Fy8SWDe3dxUvmfaEObdMs
         Pup12kA0glPlClfF90UwTJJlFUSe2dSqyCbg+worb26giFbCrUG8knZXDPPz+tVPCKDF
         ESKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747959108; x=1748563908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ICBtionEpcInnEHm0R5wGA1N61VckpDnHwHr/zSAgpU=;
        b=PHYRWRmILsE1EDVlRMh4KGoU7Xx+y1EbV0mjuAs7Z6iyQiUVErkWu/FFfetvUZApU2
         NLwuSiP0skgthJYyY2ufq0pSFV5uiXkSg7AouZMhG8Kyu6VYG7P+E/stO+f1oeM1nW2t
         FMU5YlA7fERm4aLPMc5ZstPVhdlqkEBYytVU/EqDIbJcBAtdECtoBLX+fkh1Vj9oYnGb
         80MjluZpoCEILB9KF7LCX5gk6Br4YPuqVui+x00je40y0yE164ZD/h1GAL3hZfkoW/F9
         /waoNKJ2/SjBIzvu+SISo9SZM0cuV8AyaspQBXcj07VK/Wo5kD9JE6Y3saBhgSQ/MCaI
         Ozcw==
X-Gm-Message-State: AOJu0Ywk8XXMEDaknh5T518bjzHB0TY/JUSnsXpGRVwon/8FgEQzpfxB
	IFB3hXU3PtsjrQnxPYNtkkkk6ztcge5fAAO9+FN/LJQTqyz7Pv/YCAggPnhtba5J6yLZsdwh239
	Ozg+pwA==
X-Google-Smtp-Source: AGHT+IHHYxG9CcZuEmSk4Nb2ra5RfhcDZNkQLE2VxWWyhLXKCZHL145tN4rfUIK1hwi4Tnf2i/3YCUPh+L8=
X-Received: from pjtu7.prod.google.com ([2002:a17:90a:c887:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57ec:b0:30c:52c5:3dc4
 with SMTP id 98e67ed59e1d1-310e972bb26mr1890088a91.24.1747959108208; Thu, 22
 May 2025 17:11:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:11:38 -0700
In-Reply-To: <20250523001138.3182794-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523001138.3182794-5-seanjc@google.com>
Subject: [PATCH v4 4/4] KVM: x86/mmu: Defer allocation of shadow MMU's hashed
 page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

When the TDP MMU is enabled, i.e. when the shadow MMU isn't used until a
nested TDP VM is run, defer allocation of the array of hashed lists used
to track shadow MMU pages until the first shadow root is allocated.

Setting the list outside of mmu_lock is safe, as concurrent readers must
hold mmu_lock in some capacity, shadow pages can only be added (or removed)
from the list when mmu_lock is held for write, and tasks that are creating
a shadow root are serialized by slots_arch_lock.  I.e. it's impossible for
the list to become non-empty until all readers go away, and so readers are
guaranteed to see an empty list even if they make multiple calls to
kvm_get_mmu_page_hash() in a single mmu_lock critical section.

Use smp_store_release() and smp_load_acquire() to access the hash table
pointer to ensure the stores to zero the lists are retired before readers
start to walk the list.  E.g. if the compiler hoisted the store before the
zeroing of memory, for_each_gfn_valid_sp_with_gptes() could consume stale
kernel data.

Cc: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 62 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 41da2cb1e3f1..173f7fdfba21 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1983,14 +1983,35 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 	return true;
 }
 
+static __ro_after_init HLIST_HEAD(empty_page_hash);
+
+static struct hlist_head *kvm_get_mmu_page_hash(struct kvm *kvm, gfn_t gfn)
+{
+	/*
+	 * Ensure the load of the hash table pointer itself is ordered before
+	 * loads to walk the table.  The pointer is set at runtime outside of
+	 * mmu_lock when the TDP MMU is enabled, i.e. when the hash table of
+	 * shadow pages becomes necessary only when KVM needs to shadow L1's
+	 * TDP for an L2 guest.  Pairs with the smp_store_release() in
+	 * kvm_mmu_alloc_page_hash().
+	 */
+	struct hlist_head *page_hash = smp_load_acquire(&kvm->arch.mmu_page_hash);
+
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (!page_hash)
+		return &empty_page_hash;
+
+	return &page_hash[kvm_page_table_hashfn(gfn)];
+}
+
 #define for_each_valid_sp(_kvm, _sp, _list)				\
 	hlist_for_each_entry(_sp, _list, hash_link)			\
 		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
 #define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
-	for_each_valid_sp(_kvm, _sp,					\
-	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
+	for_each_valid_sp(_kvm, _sp, kvm_get_mmu_page_hash(_kvm, _gfn))	\
 		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
 
 static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
@@ -2358,6 +2379,12 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
+	/*
+	 * No need for memory barriers, unlike in kvm_get_mmu_page_hash(), as
+	 * mmu_page_hash must be set prior to creating the first shadow root,
+	 * i.e. reaching this point is fully serialized by slots_arch_lock.
+	 */
+	BUG_ON(!kvm->arch.mmu_page_hash);
 	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 
 	sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
@@ -3886,11 +3913,21 @@ static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
 {
 	typeof(kvm->arch.mmu_page_hash) h;
 
+	if (kvm->arch.mmu_page_hash)
+		return 0;
+
 	h = kvcalloc(KVM_NUM_MMU_PAGES, sizeof(*h), GFP_KERNEL_ACCOUNT);
 	if (!h)
 		return -ENOMEM;
 
-	kvm->arch.mmu_page_hash = h;
+	/*
+	 * Ensure the hash table pointer is set only after all stores to zero
+	 * the memory are retired.  Pairs with the smp_load_acquire() in
+	 * kvm_get_mmu_page_hash().  Note, mmu_lock must be held for write to
+	 * add (or remove) shadow pages, and so readers are guaranteed to see
+	 * an empty list for their current mmu_lock critical section.
+	 */
+	smp_store_release(&kvm->arch.mmu_page_hash, h);
 	return 0;
 }
 
@@ -3913,9 +3950,13 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 	if (kvm_shadow_root_allocated(kvm))
 		goto out_unlock;
 
+	r = kvm_mmu_alloc_page_hash(kvm);
+	if (r)
+		goto out_unlock;
+
 	/*
-	 * Check if anything actually needs to be allocated, e.g. all metadata
-	 * will be allocated upfront if TDP is disabled.
+	 * Check if memslot metadata actually needs to be allocated, e.g. all
+	 * metadata will be allocated upfront if TDP is disabled.
 	 */
 	if (kvm_memslots_have_rmaps(kvm) &&
 	    kvm_page_track_write_tracking_enabled(kvm))
@@ -6696,12 +6737,13 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
-	r = kvm_mmu_alloc_page_hash(kvm);
-	if (r)
-		return r;
-
-	if (tdp_mmu_enabled)
+	if (tdp_mmu_enabled) {
 		kvm_mmu_init_tdp_mmu(kvm);
+	} else {
+		r = kvm_mmu_alloc_page_hash(kvm);
+		if (r)
+			return r;
+	}
 
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
 	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
-- 
2.49.0.1151.ga128411c76-goog


