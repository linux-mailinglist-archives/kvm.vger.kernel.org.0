Return-Path: <kvm+bounces-35185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1721FA09FCF
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CAF03AA907
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 796FD374F1;
	Sat, 11 Jan 2025 01:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SLqjOoSr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACA61C27
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736557455; cv=none; b=ProfQ5jP7NzhehbiFJnmTx01/vtO7w4HrtEBcSolfPpFvThVyDGDAs1obbMfgEezPpLRkZe51UJGlV/iZPUOSOX69VoVWr+HqCxrbTxQxvNTaKNBVZQL8ms6KXPPEMU+BFk57UKUavz8ZhpULpqidZ+cWCpfD8IpYCzx529buLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736557455; c=relaxed/simple;
	bh=Y87IV5Xpnh+jgd2FxKTBjhTRZsxpUL28iWLdqHeOOJE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oKNCu60ePVUhKwB8vf4GWHvDAaoUzQ3BjQmTBS73diEKUVFYba1MBO4zXG3x1BqG6XiulYo1UuCQ7oDp2+ZI6BuFkjLGKcNfNlbkafgX6xQ3wPFudzhS2nYGxbe6LJxlNiv+sv3EKPbDGsUZZAGOb+4jMcWwKsDLG9Ayie4bJ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SLqjOoSr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so7429444a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736557453; x=1737162253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Cy2pnqQ2fSzBgMiJrF6O6bTMaX9oe7O9BUSjAJGBR+0=;
        b=SLqjOoSryRv1XsjDEu9pvYFmixZ+y5ks07rjgwvUxIAntrzq17skWikXjZE7jSr3rE
         7KJAobL/YPvRbgXyjcVI1S9LG9eaOpITDpC2HEwB0N27EHMW7o8Fj8QVLKoUizjcxKpL
         hc4EXRWI9BDwFyW0IXJGVF7lACrfncT6xOJN7iuMHnBm/nBMTHtXpxqQEkfFQV3lHxyS
         qD6k7ENdlurjmXlEotNJA9SGISGvAcSGSO4D0C0rOFvY1H2vohHxbVp56gW87UbDsiF0
         zom9usmNp3OnXkTAe8aAV9UfKFut00bcYUBRqrgOC3tMlZ/I/UDFOWG7I2rgBpWGOWTz
         NVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736557453; x=1737162253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cy2pnqQ2fSzBgMiJrF6O6bTMaX9oe7O9BUSjAJGBR+0=;
        b=few5auy4VbYwhSB9xYXyJDNiGJ3eQs2rXU3ucathUIKD25sEK0zUwQnKeet4RM77TQ
         Jcty9ME6ZVl0HnXC/+Ef3Xo0PozoL6/RERAlmqiDP4isNQyUk0/eJASBEJr2aLKep7K3
         uCtwDtTe603NNSx96qbv1oZXonwa6rXV2b+f+N7NIqIO/pyJH6fajXn0QjfbX2nseBDR
         Hj2yuSONja6+kKXGbOtf0gkwzImSvzRMnbpm+p+Zjx0E9qrfCG0LXu0sEVVRutZZSP5z
         J7UQnjN5ZopGBnhy0kM9yCL/CKLF9TpZm1d5vK6t3aAju7OwP4sOXLaDfyyadohHBh/u
         zkHg==
X-Gm-Message-State: AOJu0YwI3Mhf7yyDfsy2fZhbV1dZvBj9gFJljM9MKpXyMEEMiVLRNFPw
	Grt91DgUeGTw60E0uiGZuAJyCBR1NbzMMRu9w1JyBOOUMVvNysdlBuDhWjalX/1Gfme560ULMLY
	Ukw==
X-Google-Smtp-Source: AGHT+IEiLT8u+IwJHWKAAuUTYAyOIXDxsf9AxyDDoSlDQKImRmj4TEJpD11oowKHMJ/OBwLbI6iHkHS2p5s=
X-Received: from pfbln9.prod.google.com ([2002:a05:6a00:3cc9:b0:72a:f9c7:a2ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:408e:b0:725:9dc7:4f8b
 with SMTP id d2e1a72fcca58-72d21f562c6mr17589432b3a.15.1736557453546; Fri, 10
 Jan 2025 17:04:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:04:05 -0800
In-Reply-To: <20250111010409.1252942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111010409.1252942-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: Bound the number of dirty ring entries in a single
 reset at INT_MAX
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Cap the number of ring entries that are reset in a single ioctl to INT_MAX
to ensure userspace isn't confused by a wrap into negative space, and so
that, in a truly pathological scenario, KVM doesn't miss a TLB flush due
to the count wrapping to zero.  While the size of the ring is fixed at
0x10000 entries and KVM (currently) supports at most 4096, userspace is
allowed to harvest entries from the ring while the reset is in-progress,
i.e. it's possible for the ring to always harvested entries.

Opportunistically return an actual error code from the helper so that a
future fix to handle pending signals can gracefully return -EINTR.

Cc: Peter Xu <peterx@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_dirty_ring.h |  8 +++++---
 virt/kvm/dirty_ring.c          | 10 +++++-----
 virt/kvm/kvm_main.c            |  9 ++++++---
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 4862c98d80d3..82829243029d 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -49,9 +49,10 @@ static inline int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
 }
 
 static inline int kvm_dirty_ring_reset(struct kvm *kvm,
-				       struct kvm_dirty_ring *ring)
+				       struct kvm_dirty_ring *ring,
+				       int *nr_entries_reset)
 {
-	return 0;
+	return -ENOENT;
 }
 
 static inline void kvm_dirty_ring_push(struct kvm_vcpu *vcpu,
@@ -81,7 +82,8 @@ int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
  * called with kvm->slots_lock held, returns the number of
  * processed pages.
  */
-int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
+int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
+			 int *nr_entries_reset);
 
 /*
  * returns =0: successfully pushed
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 7bc74969a819..2faf894dec5a 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -104,19 +104,19 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
 }
 
-int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
+int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
+			 int *nr_entries_reset)
 {
 	u32 cur_slot, next_slot;
 	u64 cur_offset, next_offset;
 	unsigned long mask;
-	int count = 0;
 	struct kvm_dirty_gfn *entry;
 	bool first_round = true;
 
 	/* This is only needed to make compilers happy */
 	cur_slot = cur_offset = mask = 0;
 
-	while (true) {
+	while (likely((*nr_entries_reset) < INT_MAX)) {
 		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
 
 		if (!kvm_dirty_gfn_harvested(entry))
@@ -129,7 +129,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 		kvm_dirty_gfn_set_invalid(entry);
 
 		ring->reset_index++;
-		count++;
+		(*nr_entries_reset)++;
 		/*
 		 * Try to coalesce the reset operations when the guest is
 		 * scanning pages in the same slot.
@@ -166,7 +166,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 
 	trace_kvm_dirty_ring_reset(ring);
 
-	return count;
+	return 0;
 }
 
 void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9d54473d18e3..2d63b4d46ccb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4877,15 +4877,18 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 {
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
-	int cleared = 0;
+	int cleared = 0, r;
 
 	if (!kvm->dirty_ring_size)
 		return -EINVAL;
 
 	mutex_lock(&kvm->slots_lock);
 
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		r = kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring, &cleared);
+		if (r)
+			break;
+	}
 
 	mutex_unlock(&kvm->slots_lock);
 
-- 
2.47.1.613.gc27f4b7a9f-goog


