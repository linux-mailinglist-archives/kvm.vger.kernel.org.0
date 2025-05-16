Return-Path: <kvm+bounces-46901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E830EABA59A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC2E61C0258F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA23281502;
	Fri, 16 May 2025 21:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L3Lyj6Ww"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070A128032E
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747432487; cv=none; b=FOy19djHUmRZNS80ZiIhtOPjTjicK1TpRGoJAiilabudwfAeBtVLvUJQhyofrJMF9tfoVmSVVBpLipiPzetjkxZsl9kwxc2JZmSbsZEoIAcdgXqdHIy0jezjug2bd6Ohs+6rHNy579akRqiGcwVfGursmz40Pyl/XIdJtKc9UrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747432487; c=relaxed/simple;
	bh=vG4MilI6ZPjsxWzTTmJYBAXAtBz2ENQvYI2HlBYevYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N6HcmQ9imS4f/h+FX8H/SWyOhegLrv4m9NHHAM4DwMpzWq0fBiMqnD1G6Thu2GfabhPnZLjr3WEJVgfGgqRzvPgT3hiT0q6pSIYVhaby0M3XH9LN2VeFQTVPKH2IM0uWKp1/85TpZwWzsyGrrliHIPON8W+O9tg374ApCpISccI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L3Lyj6Ww; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e86c46eadso952399a91.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747432485; x=1748037285; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NSUjHZohehNysHCDxTu74aE3HD7zo4nmAA1APckiJz0=;
        b=L3Lyj6WwfYTHirB6zsGpMhRY+u0b1vYrhN02zNFFCMAxIXMnmxbUmy1TnKvn28vjSl
         wMHnS6fa9lEJQonZHYUt7XDRoV7VX1Uchjk4soHyZ+GxpGjzPHdZNU6GXHtLMVdNNjNa
         3kNTgACuu812GI9UcXEfvj0tXOfIxvU/194v9kmT7BJgnhoSW3zCfUh8BwapsbKM8jRx
         dWuRzKJ1TCqWeh+L3pQSxpvnGzDqDv83fSKMgLo/815zNJAPFX87HN/j0z0hgPUaV1QT
         sPspIowQeG9zC9F3jj0njtAZxY3bpX4YFGTFGlCoTqFOaQlhLN1QqA4GUEHhSfKaTBpL
         JkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747432485; x=1748037285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NSUjHZohehNysHCDxTu74aE3HD7zo4nmAA1APckiJz0=;
        b=vTwXSO4cb2WVRoMWSGZaNh8R9ct5emnFZB54iHKViyKKU5EwwYCBtamyakT+EB6WPL
         B221gSGlVRcBESYAdmxwtFpxQeO0n+7lJSZEIFvKYMw/6IIDGbdhNl8sOIyOq9TIQ5Xx
         pnK2oC9sbrdl6DiJp7mOrz97MLZKEyT9BHSLbyQKXbYjDAVxqEM3OnaX6npbmWuSYG3X
         +AoV6QCkSA93mihcqF3KgxR0hIDYUYv0Ds1orveZ0eebflkMlwBX7ezxtEgKO2Ju3cL7
         8PCLYTnRNLsi0rC4YRjPG2HozUwSlIXKYKS1aJffgvaKdhuuVApyGbnTIDuFIoaUq2kw
         fUGg==
X-Gm-Message-State: AOJu0YweNDAwqU0dAeUPCbGjS+nWMZSwApQl7Wmeqrhhr9rirbPzGXPx
	gccD1pM/ZsTO7Xy+cqgLJQcy1nuOQsKl4fJ+suKA2AIQ/nJY5I43tU6uSUg+eqnSQtDl7Y8+cNK
	eCi419w==
X-Google-Smtp-Source: AGHT+IHkQzjmHcULUBiBU5Hpt5ez1mbp/7xSjtX/QxCL0i4ISdp33Z6ODZCSemjhL/36/EZTOC8neh15Vdo=
X-Received: from pjbqi17.prod.google.com ([2002:a17:90b:2751:b0:30a:9720:ea33])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a04:b0:30e:9349:2da2
 with SMTP id 98e67ed59e1d1-30e934931eemr3640734a91.4.1747432485576; Fri, 16
 May 2025 14:54:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:54:22 -0700
In-Reply-To: <20250516215422.2550669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516215422.2550669-4-seanjc@google.com>
Subject: [PATCH v3 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's hashed
 page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
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

Use {WRITE/READ}_ONCE to set/get the list when mmu_lock isn't held for
write, out of an abundance of paranoia; no sane compiler should tear the
store or load, but it's technically possible.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 60 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 41da2cb1e3f1..edb4ecff9917 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1983,14 +1983,33 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 	return true;
 }
 
+static __ro_after_init HLIST_HEAD(empty_page_hash);
+
+static struct hlist_head *kvm_get_mmu_page_hash(struct kvm *kvm, gfn_t gfn)
+{
+	/*
+	 * Load mmu_page_hash from memory exactly once, as it's set at runtime
+	 * outside of mmu_lock when the TDP MMU is enabled, i.e. when the hash
+	 * table of shadow pages isn't needed unless KVM needs to shadow L1's
+	 * TDP for an L2 guest.
+	 */
+	struct hlist_head *page_hash = READ_ONCE(kvm->arch.mmu_page_hash);
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
@@ -2358,6 +2377,12 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
+	/*
+	 * No need for READ_ONCE(), unlike in kvm_get_mmu_page_hash(), because
+	 * mmu_page_hash must be set prior to creating the first shadow root,
+	 * i.e. reaching this point is fully serialized by slots_arch_lock.
+	 */
+	BUG_ON(!kvm->arch.mmu_page_hash);
 	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 
 	sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
@@ -3886,11 +3911,21 @@ static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
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
+	 * Write mmu_page_hash exactly once as there may be concurrent readers,
+	 * e.g. to check for shadowed PTEs in mmu_try_to_unsync_pages().  Note,
+	 * mmu_lock must be held for write to add (or remove) shadow pages, and
+	 * so readers are guaranteed to see an empty list for their current
+	 * mmu_lock critical section.
+	 */
+	WRITE_ONCE(kvm->arch.mmu_page_hash, h);
 	return 0;
 }
 
@@ -3913,9 +3948,13 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
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
@@ -6696,12 +6735,13 @@ int kvm_mmu_init_vm(struct kvm *kvm)
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
2.49.0.1112.g889b7c5bd8-goog


