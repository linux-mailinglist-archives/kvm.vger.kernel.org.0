Return-Path: <kvm+bounces-46894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 657A5ABA554
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8280C189EFF5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82C6283689;
	Fri, 16 May 2025 21:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rATP7kcH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C84D2820B3
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431351; cv=none; b=Z3q9bRjNKRt3ghqfyGlIGnuUQj9Pnfx9iI/osO6gTEfL2fcDm25COp+Aa4/mc4FTS00vm0c4wSkWYbCY3eJvVVQAuhp5xS7qTmMIdF/ppkMyQPhTxJU88k9+2Ndp+KHkxe3TNPybT8pMHeS+vLqsAFSmdVk7wGU2b6lL3uq8cn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431351; c=relaxed/simple;
	bh=2v2dN1X+dAAa77UFU6vIKHEWb426YHGfzeCeOi2cJvE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=adE++EhrPKyHQCfVvCVEsvxeOhaqx+otuVjBCZB6mo27DsTBk/Yv5MQh1EWXUEW/iIgOR0vmxiq9RYFQbdFUO4EOLBgn+e8pgFfYn55nqVw9KV+LWaq/0yjX8pDxmll7VJvl1JToU49JmoyuzbY2T4yXMVtVmhivU7norFAGlGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rATP7kcH; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742b6705a52so611693b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431349; x=1748036149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vyBzQMKQxB1kwhDGECpLCE1qA4Bs8m5spdH0C7ry2ZU=;
        b=rATP7kcHZS7G5C95YqpEoqIR93Pue+DuwiKr6amQ47po1xRYYJxzz6mDTwQlfl8WQl
         xihAcBdA5QZgGx7ljHpTdzVVu4SgHAJXVtXYwFLQmXI8uueldwtnh25mnbcbvsESnq0D
         HLjFiBaO/SlbDMaEWTq/xSu1F/MkSQoxT7y71SsE3xDa48hbgsw9CsuNhqPeyYS62sLu
         wwCWJ62mhyAqhmP2D6TvBlLY2R0b+lA0NC7I3Kjp1ozuvqOx18x8CQK+mwLEkhm4CuYV
         Gc2AVpSUuGhWkJUqMke6iBHUUlELIYXyfETVdR4b7S1oDDZs8JKhahdUQiDcWh3vh43o
         8OGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431349; x=1748036149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vyBzQMKQxB1kwhDGECpLCE1qA4Bs8m5spdH0C7ry2ZU=;
        b=ChRgJCgd71hLMlG1z9iaBm9BXV56aIuASUuiO3jbYxmkWjNNVMZUjGnQsq7Gitl6XT
         XKVRtnsVKjUF0qm/D3X+u9Rxc2o9YKjAYadQCS/REfhFDlhAu3rKaNVJVYB2D4q/+INE
         n0ucN9jqwoL3L17zUJ6qOievd/DnTQgTL0pV+wECCHLAOVN0S2IMiR8WQU13e0d0fWAc
         G/Obby/9t9Le7pEov9wLLjt3aDzj4bnDFJdcSXg2u3NOb6l0+4p5Lq8dejbuW9gOj8xY
         qm3B1T2ZZfgkiWUuUSrH0i3HqDXXN5rcr8A7Ss6xhDGQcA06wUZ7xvvXeqHnxoluQTkb
         XAkA==
X-Gm-Message-State: AOJu0Yy8WM6jH6yCO2AK0BZwkZj99vAwWUFsDnjpKD0e8u+mW010+TJl
	xzyd7GtQbPXt1ZKSXhpQFomD4ANiKcLAsc8TeECWoGtlFX+90h+Rxhxl1H4WHEo3xzUYaVNDxAc
	8EgiAiw==
X-Google-Smtp-Source: AGHT+IGZ+89bx1MUQlOhDsp5hIxSmp3YXUWmvmkzMbfls2oWeAVq98kQbFTVLLPqo6+CMxFMWOoQeQWQ40o=
X-Received: from pfoi17.prod.google.com ([2002:aa7:87d1:0:b0:736:86e0:8dee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:94a7:b0:740:91eb:c66
 with SMTP id d2e1a72fcca58-742acc906b0mr5995225b3a.3.1747431349536; Fri, 16
 May 2025 14:35:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:35:38 -0700
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516213540.2546077-5-seanjc@google.com>
Subject: [PATCH v3 4/6] KVM: Check for empty mask of harvested dirty ring
 entries in caller
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

When resetting a dirty ring, explicitly check that there is work to be
done before calling kvm_reset_dirty_gfn(), e.g. if no harvested entries
are found and/or on the loop's first iteration, and delete the extremely
misleading comment "This is only needed to make compilers happy".  KVM
absolutely relies on mask to be zero-initialized, i.e. the comment is an
outright lie.  Furthermore, the compiler is right to complain that KVM is
calling a function with uninitialized data, as there are no guarantees
the implementation details of kvm_reset_dirty_gfn() will be visible to
kvm_dirty_ring_reset().

While the flaw could be fixed by simply deleting (or rewording) the
comment, and duplicating the check is unfortunate, checking mask in the
caller will allow for additional cleanups.

Opportunistically drop the zero-initialization of cur_slot and cur_offset.
If a bug were introduced where either the slot or offset was consumed
before mask is set to a non-zero value, then it is highly desirable for
the compiler (or some other sanitizer) to yell.

Cc: Peter Xu <peterx@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 44 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 97cca0c02fd1..84c75483a089 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -55,9 +55,6 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 	struct kvm_memory_slot *memslot;
 	int as_id, id;
 
-	if (!mask)
-		return;
-
 	as_id = slot >> 16;
 	id = (u16)slot;
 
@@ -108,15 +105,24 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 			 int *nr_entries_reset)
 {
+	/*
+	 * To minimize mmu_lock contention, batch resets for harvested entries
+	 * whose gfns are in the same slot, and are within N frame numbers of
+	 * each other, where N is the number of bits in an unsigned long.  For
+	 * simplicity, process the current set of entries when the next entry
+	 * can't be included in the batch.
+	 *
+	 * Track the current batch slot, the gfn offset into the slot for the
+	 * batch, and the bitmask of gfns that need to be reset (relative to
+	 * offset).  Note, the offset may be adjusted backwards, e.g. so that
+	 * a sequence of gfns X, X-1, ... X-N can be batched.
+	 */
 	u32 cur_slot, next_slot;
 	u64 cur_offset, next_offset;
-	unsigned long mask;
+	unsigned long mask = 0;
 	struct kvm_dirty_gfn *entry;
 	bool first_round = true;
 
-	/* This is only needed to make compilers happy */
-	cur_slot = cur_offset = mask = 0;
-
 	while (likely((*nr_entries_reset) < INT_MAX)) {
 		if (signal_pending(current))
 			return -EINTR;
@@ -164,14 +170,34 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 				continue;
 			}
 		}
-		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+
+		/*
+		 * Reset the slot for all the harvested entries that have been
+		 * gathered, but not yet fully processed.
+		 */
+		if (mask)
+			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+
+		/*
+		 * The current slot was reset or this is the first harvested
+		 * entry, (re)initialize the metadata.
+		 */
 		cur_slot = next_slot;
 		cur_offset = next_offset;
 		mask = 1;
 		first_round = false;
 	}
 
-	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+	/*
+	 * Perform a final reset if there are harvested entries that haven't
+	 * been processed, which is guaranteed if at least one harvested was
+	 * found.  The loop only performs a reset when the "next" entry can't
+	 * be batched with the "current" entry(s), and that reset processes the
+	 * _current_ entry(s); i.e. the last harvested entry, a.k.a. next, will
+	 * always be left pending.
+	 */
+	if (mask)
+		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 
 	/*
 	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
-- 
2.49.0.1112.g889b7c5bd8-goog


