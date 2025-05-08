Return-Path: <kvm+bounces-45892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F09AAFC73
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71FEF16F1DC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2225E263F49;
	Thu,  8 May 2025 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uVQEdqAh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE0F25394E
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713420; cv=none; b=iT/S3N9WHigt2qFAFqchgsS6c1QxZa+oIPBpKt/7a3t9IPETtyxyM5GT0qK5wKh6MfO6X5M2n+x94NCdqokOrrIHJdK9ZGNwGCkAMTvq1vZb5kyDYc00d83JT5gt9M9B+6TbYtllYqF8H33FlfXAKkhaubL6g3dXuYZd7gLEwjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713420; c=relaxed/simple;
	bh=G4MulOxIAWodwoabJCbtlh+WMIsmZESdSAC65RXZU30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tVJSh/d1g6BcNzur7Kk7qL9HSta4H9UkJ5HNa3djlRSCai0Z92IRq0ek+Jb2YRAMMWas5Olaos1sBCn+9GAraZpSnWssPemc3kIoeRxBeJncV3dY/Br8Dse15SBv67aWa9H2fdO6rJuNYVb0fO5fE3WLAtxUaH5DN+l9rSUG3dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uVQEdqAh; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1fdf8f67e6so673699a12.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746713417; x=1747318217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=r0z8Ayy/An5FIdcoS5gnzj4EHpvTo5w/T7c83ie1jKg=;
        b=uVQEdqAh+T5JiTz9GotyZ73+vQhKxxPi8KSIAk8wybD1+0g06OtcgNvjV+3hoburEx
         6JLNAvRVlQCW2k36SML/XgcYYbkXpevzHlCrlla1o3VrHFcGN1HV1/UAPzib9AVF3JS/
         tpH9OEQcB79yzvo5oBbsTKoPYKk4knpWx79Zjvv2i2tNuABjSNliXw2allmr1ZSIHasz
         7LpyLhSrbzRy7nldDvSArOrMo0gr7lCTaI0KDQedLcYdE5gJvbvTpw1fZVz3kLGOlWi9
         X6NDKaq1GJ3YTaHm7Hk1KUicD899x9uwCbAMnT7e0HR9CMuHDnrRl27X1/3jaE51lycq
         pfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713417; x=1747318217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0z8Ayy/An5FIdcoS5gnzj4EHpvTo5w/T7c83ie1jKg=;
        b=C7FQsY8uOYGYKCpY7FUwjZ5U8wJxP7WYZ2pFUxSYfewsCW0OmDhoqHuVlMY+H65lmX
         wBriBWVmB8l2HzoUiqTfhAdfujLbxFJLVAjgRfUa7LvXI0kHstRXrcm+r4K4EqH0FehC
         054uatiXbFGQm+927dXPcoYzgSSuX92VKQ1mcm31sbrsu5/qGbSzkP4cxPehFtr/Q5KM
         Q6mrPyPCXQhN5h5VLQRUSqptd2DqIIFX83J8+Geo1zzEHCwD6LWoGVHr/N1T3Y7BxHMw
         LtwAmufKJo5ethTV0KyCu8lmb/QoO/hd4zSug3WqB8+7cCbp9Yc+wBX1tf57t2HtkBBF
         6zEA==
X-Gm-Message-State: AOJu0YzxHRle6PgkgfRYzboXdDLWGjkyk4+KIeMl8h/FgtrNfExagthw
	Mx9njJwKWx5CbLBQQgPwkCeEf9hTApbmaI0nc+aTyEKU1Lypxrhj3Vln47c0QY7mv8lxLGx9CN9
	tag==
X-Google-Smtp-Source: AGHT+IEtwm0yhtMPGtbie+qGTsHKAvlMoQCo2CofB6XzmclxdV1LwoF+6M5dpkArbOuyw8zzgEGn1qZQuNk=
X-Received: from pjtd8.prod.google.com ([2002:a17:90b:48:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b87:b0:2ee:90a1:5d42
 with SMTP id 98e67ed59e1d1-30aac097e49mr13855976a91.0.1746713417034; Thu, 08
 May 2025 07:10:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 May 2025 07:10:08 -0700
In-Reply-To: <20250508141012.1411952-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508141012.1411952-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508141012.1411952-2-seanjc@google.com>
Subject: [PATCH v2 1/5] KVM: Bound the number of dirty ring entries in a
 single reset at INT_MAX
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
i.e. it's possible for the ring to always have harvested entries.

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
index da4d9b5f58f1..ee61ff6c3fe4 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -49,9 +49,10 @@ static inline int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *r
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
@@ -82,7 +83,8 @@ int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
  * called with kvm->slots_lock held, returns the number of
  * processed pages.
  */
-int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
+int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
+			 int *nr_entries_reset);
 
 /*
  * returns =0: successfully pushed
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index d14ffc7513ee..77986f34eff8 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -105,19 +105,19 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
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
@@ -130,7 +130,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 		kvm_dirty_gfn_set_invalid(entry);
 
 		ring->reset_index++;
-		count++;
+		(*nr_entries_reset)++;
 		/*
 		 * Try to coalesce the reset operations when the guest is
 		 * scanning pages in the same slot.
@@ -167,7 +167,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 
 	trace_kvm_dirty_ring_reset(ring);
 
-	return count;
+	return 0;
 }
 
 void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 16fe54cf2808..f9de2c8b9c1e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4903,15 +4903,18 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
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
2.49.0.1015.ga840276032-goog


