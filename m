Return-Path: <kvm+bounces-35188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B00AA09FD5
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C45D188F90F
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E73F1531E9;
	Sat, 11 Jan 2025 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SS4Dk6LS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8E614830F
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736557462; cv=none; b=IX9a/qTLFmv/1+Z1sK8qmJjlTY9+CeejsBY7Z4HzUymzghWMTRm15+V7yiQl+u7R7S1hB3Pz/iyb8omVUsf4YkPn1qr4ftDbrvSHpDxYyBzdf5oumXQovW+pJcE5ufyj97I+eN3t32/aCAyttSvsW+h9j98piVYFK+UGUqahnf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736557462; c=relaxed/simple;
	bh=4AOojhK7RgZpfHVFyZZg/F1b+66In+n0W7FklHWokKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PqpOQRIPps2YbsoKfwBCLd33VoM6bc/MCR0YFwxQ9Cbzk83h2MI/R6K5GUXH98I9FVqiIECWSmPCQJbCNrbaoV1fGMNtu11+e00XBm5NLn5EhPNGsTV0rmiIqojCkDQrM7LRxx8kiNoVKOyg+Vh6SjpUr6f4cbUbETAZb7wFeKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SS4Dk6LS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so6710519a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736557458; x=1737162258; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oGi7slrEyYAnwuVNpr6ZrhtkCDMVeK/CUwkbMoeq/cE=;
        b=SS4Dk6LSfD/sZVtJuIMAVMzMhrSGOGVePoGpUZYs9dQbksms/LORsyTEjwcBrCiPsm
         Zx7QTXq1sVxb/+vcWoutAybzoOisOCfZ9MnwaZYq7SP6twNqXyf522SM4BIbVdZ4z3MN
         zf3yj1qjBK4Z60Fv/IoxZNu1gzAzsK6Z4AilPcbZV58NKEHEZD4j284X7kW1wcRw1Ttt
         6Wb4NMMzHwag04ebjlaDTguwP/Vn4VYkMM90SojZYjHg12YeMX40p5/zAlwK3rPyFxqy
         rC8f3Jsl5EbxgU+E/U03ZGZcvwyyz7W09BBQCIG4+Q9r8CPciGEpcPS0lzKsPbCWK1fe
         E7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736557458; x=1737162258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGi7slrEyYAnwuVNpr6ZrhtkCDMVeK/CUwkbMoeq/cE=;
        b=m8ZOfqODANiRgxq32bO87+CMG+qvZdD7mpL6h1FHa6MghWyFD3mV13tWseEw+1y+Uz
         PxQvAWTNDcfjVYQJgJdTS039SBy36PNZiA2hZI1YWUMVgf16Iw4/koqmMyhe1QvQmDuT
         VgBfxaghdOjpZ2tEFnr1aMBqy0/4nB2B9o0ae0TaC5OaXvbQD7vEAYRc5+9s4iMbsdF8
         +sOJY7v7+uhOb7+ehI6XwUT9PbcQQpYYd/JSlgblXf96MznImTZ8HprIRAqHENCTMlvG
         jJfES5d4WvLRpcLOzhL7o7UBYDBPGNiifiutu+JJOlvOQsSrrR5vPj6sg/G/b+BPALnx
         iPjg==
X-Gm-Message-State: AOJu0YzME1FuFhC87Uvu8/xZcnIpJS6eIsA0RnSsYMFVKTSRvShkRYBr
	BIHOoInn9oqx4GFacdkng/hlxAyGJqJg00Rh94EtvN4PctU8JMZi8D/0OrCCX7TuIQk30NW5fZN
	fQA==
X-Google-Smtp-Source: AGHT+IEU0JMvjhrXcRzpNyyxrvcQqODJ1wZPu5PG2qjeWRbJZlS0/3S5feFaFOwVGoqKiMB61Iex5Pfl42k=
X-Received: from pfwz22.prod.google.com ([2002:a05:6a00:1d96:b0:725:e37e:7451])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e13:b0:725:eacf:cfda
 with SMTP id d2e1a72fcca58-72d21fe0263mr18801122b3a.17.1736557458526; Fri, 10
 Jan 2025 17:04:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:04:08 -0800
In-Reply-To: <20250111010409.1252942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111010409.1252942-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: Check for empty mask of harvested dirty ring entries
 in caller
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
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

Opportunisticaly drop the zero-initialization of cur_slot and cur_offset.
If a bug were introduced where either the slot or offset was consumed
before mask is set to a non-zero value, then it is highly desirable for
the compiler (or some other sanitizer) to yell.

Cc: Peter Xu <peterx@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 37eb2b7142bd..95ab0e3cf9da 100644
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
 
@@ -109,13 +106,10 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 {
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
@@ -163,14 +157,31 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
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
+	 * been processed. The loop only performs a reset when an entry can't
+	 * be coalesced, i.e. always leaves at least one entry pending.
+	 */
+	if (mask)
+		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 
 	/*
 	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
-- 
2.47.1.613.gc27f4b7a9f-goog


