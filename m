Return-Path: <kvm+bounces-46891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61714ABA549
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F42324A8269
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53207280CFF;
	Fri, 16 May 2025 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fxhgg+MY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A94280307
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431346; cv=none; b=tR4i9X+BxOavqlhtgti5/dJqfLNUZiaesgLfHJer/X6/ZuZ0KrSMhOnMBgwvgMDl0MjGoqlA+hlWduYzUSsYo+OnoS/uw/rw2cZhyUKENXvpamAWU+KIzRcyv49/V+QOLwJO6NeY9PVykVD8lKQX1VW/vLihJzQ6dcj7xGH1H7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431346; c=relaxed/simple;
	bh=TPssax79sxW9s4Uhhkr+BKlQZkVGnbippa0fsIPWqo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ar6BKIPhMtJWVkXvt1t4Ri6QC/rTzx41/O57rwHKrqFORAMQu0MPWq1vbLRBliVOZnBpsFu0yt4L63njFVdhlzx6cw6LZtakU8WTJ72bKZRCfjLu/+SFYjh0n0Fu2Y973GgEV5nMoJ1EyFJP1+3sdZri4N/whMGaKfpJvePgf3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fxhgg+MY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22e816139b8so21712355ad.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431344; x=1748036144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=32n3PJO9GBTARszoinMNB66MtnH1QTCvI0q5z3orUsw=;
        b=Fxhgg+MYRKX5u3T6BOnRhHghesd9cKMdhtf01T/Hh6CHbGYy9e2vNKfxoorrmO6lZr
         nclYniCFXiI0OaAvTofyKGSyP4y9CaR5JJKgv0eEcnxFQV94R0eXb3EYgq5uTuGdHnG3
         KRc/RvhajwMb/JWpeK6CfjyMLPcHdg4dsc1f999Lo7QRp+SpgGrKFyVKESr3B0W/xYuP
         QavTBXWxDHsHFQ2LxOLIJ5CPbN5Osk90Gc+TnyW/fMuhFfp+HqXjLZ7flHpq9+FNmZfz
         dqZPRgaSd53l/QectZLZ0HXHjUocg62OuYQfINagQBwY2tLtFIg/DMsrWi32Hh8k8tqF
         dwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431344; x=1748036144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32n3PJO9GBTARszoinMNB66MtnH1QTCvI0q5z3orUsw=;
        b=n42rJnqYSIXBmSZXzXZSHVNOx3wAr6Fc0zb9hzAIrV/uhe6ygeSRk+1+/q+iX/yWLZ
         dyuaGr6dWmwPK14bViZGkC0/1FO9t2UMKmBfGvk5wBJL0L+pvRMtIbF7dx453bT2Poqx
         zfoAPH9rssxyJH3BgnRyTAI3lq1UmVXvwJyn4gK465uQo5pL4M2quMS3LxXv8yW67Pok
         z1VqkEsWIjFyxnMv5Pv3sm2WGBEINKzVDrFin5/cn1JtpSHqy93FCOqSAWIK20gEGzbp
         tW4QpVH9vFiHq6OFCeAi6YQon/RLSIV6/ThrzdATgAI2sXd49gZjg/nvG5mweP0W37lb
         rdlQ==
X-Gm-Message-State: AOJu0YzK6IghJABt3moOfj+Y4P+UBxgD0Wqo0YDovOBwB0nFVRAP8Po5
	/XmUtrw/n1ahLV7YW2VYmU9Vyp/ROdzqBFQl/LG61PH5ifLOtQRVFskRhysHcFj8GY7gLbfdNvQ
	LsTs21Q==
X-Google-Smtp-Source: AGHT+IG5j10n9pBrXztcWjA8kxz2B2rfIvBK/g2w38KT4xlpjVSYu39IgoUnHrzq9k9yoHJvwCdr38hRT4s=
X-Received: from plht15.prod.google.com ([2002:a17:903:2f0f:b0:223:225b:3d83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e787:b0:224:26fd:82e5
 with SMTP id d9443c01a7336-231d455d9ddmr69825065ad.48.1747431344204; Fri, 16
 May 2025 14:35:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:35:35 -0700
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516213540.2546077-2-seanjc@google.com>
Subject: [PATCH v3 1/6] KVM: Bound the number of dirty ring entries in a
 single reset at INT_MAX
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Cap the number of ring entries that are reset in a single ioctl to INT_MAX
to ensure userspace isn't confused by a wrap into negative space, and so
that, in a truly pathological scenario, KVM doesn't miss a TLB flush due
to the count wrapping to zero.  While the size of the ring is fixed at
0x10000 entries and KVM (currently) supports at most 4096, userspace is
allowed to harvest entries from the ring while the reset is in-progress,
i.e. it's possible for the ring to always have harvested entries.

Opportunistically return an actual error code from the helper so that a
future fix to handle pending signals can gracefully return -EINTR.  Drop
the function comment now that the return code is a stanard 0/-errno (and
because a future commit will add a proper lockdep assertion).

Opportunistically drop a similarly stale comment for kvm_dirty_ring_push().

Cc: Peter Xu <peterx@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_dirty_ring.h | 18 +++++-------------
 virt/kvm/dirty_ring.c          | 10 +++++-----
 virt/kvm/kvm_main.c            |  9 ++++++---
 3 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index da4d9b5f58f1..eb10d87adf7d 100644
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
@@ -77,17 +78,8 @@ bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm);
 u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm);
 int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
 			 int index, u32 size);
-
-/*
- * called with kvm->slots_lock held, returns the number of
- * processed pages.
- */
-int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
-
-/*
- * returns =0: successfully pushed
- *         <0: unable to push, need to wait
- */
+int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
+			 int *nr_entries_reset);
 void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset);
 
 bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu);
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
index b24db92e98f3..571688507204 100644
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
2.49.0.1112.g889b7c5bd8-goog


