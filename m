Return-Path: <kvm+bounces-35189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 276EBA09FD6
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD639188F005
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C0B1537D4;
	Sat, 11 Jan 2025 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A6ZI9l3A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BD01487D5
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736557462; cv=none; b=Zn2Mh9tZP6nQbMZC7PBH/h6zGg3AqO4xcXZerhdjawTWcpLe9LjQMh1Gok3ncaPcdU27aBfMClnF9qE+GEemuIAhglM2lOnl6rUAiLaNfezvL38zeKvJYZStXZxsdnunTVxy+AqCYxhORz0va8RXolbMYqWRCzCRU6Wo2x4VS28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736557462; c=relaxed/simple;
	bh=GuHaUoJc3kSQRY79m3B6lcu5nI5McGM/FGvOckPh/E4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wrvl06nqcjBD/nuko6+m9+LhAxeAoJzixGHm5V49hwzz4eplC0lbJ1/KLa2oiF0F5UIiNFCy5oO7cBcEQc0iaxthB8sutE/96laQtdY43lJM7qFjGbb0Vpbxj1WfDHG2lyn8kk5XBD8MS0oHjeiceA+rM2TNgFODG+6CnsJHu9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A6ZI9l3A; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eeeb5b7022so4804483a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736557460; x=1737162260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tVYbCX2RqPz2ig5eCEENys/M+ZhhahZJXVbEX0SbPgo=;
        b=A6ZI9l3AManGIewequpKdftymqIyiAKM8gSb7o4oxl+z8KJ5jPV3Pn3YUM6CTJejSW
         zizpj1S01JQnas30amkG2ucciGB2wdF5Vcb3YwlCDE+m3aAPjzVqpO/8NEnmGVDfLs98
         m+sKTIl82YnGSpYwFKBbA7xmTtPVGO7XTpVV5TwThk90I5ie3oOCNOV5VqAbXmZJOHyI
         1u0ytJZLS1flfT7YwzwJHXvD9EQKn/EZyUQqx+pVJ8lEYlOibV0nzNXqHmwrplY8g7IB
         GUUmpZ0mPLE30uAya38B/FngIOH9e+Jq7PaZi1ZQnCUghwkZP15kOfwkZpE5Z+gK5kD1
         0DHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736557460; x=1737162260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tVYbCX2RqPz2ig5eCEENys/M+ZhhahZJXVbEX0SbPgo=;
        b=I8O3QmUsxtEmRCMx6YQ8wz6JX9/DFt1GMwaQ7S8zYSM7EVSArESg4zYNGD97g0ynyj
         jqyDaJ+y3jS/dLCyl6OUUU29qa+PKtmVln8QTr1cVjfs0xwaWf9FgcOyUIvtov3KTvdX
         o+PKG/2CfO7xR2MIfc55Lj4u25SiZW1BiLf7UMqlzHtM0zjwocL+6eFAIdVMst/rXhCr
         0R5nsOfDglp2nsYV7SjUgvigWmkMsBIu79LPWerrHWjqPCEMlz6X92u4dbIfg5avE8Ow
         F0g1qlTWvTCXvHMjG7IODv2r7x5ZsIn37Abder95jGtDcwC8ZS0fuCXzAo9MGqR9sU0E
         5NdQ==
X-Gm-Message-State: AOJu0Ywa6CtnVSVUd9V0/Q7WdsVZYLITemXyXQmRB0iOjU+P/ifbnWQv
	Ryv9r7UIMLKp0sex7XgbPa2a7U3T+9XmJhK+4HY2Bx3PkyrzLDWleEovLiNCffsdqkJuJnoRAA7
	FSg==
X-Google-Smtp-Source: AGHT+IFuOLVPsL+7D49WGbUBlqnRDugnmoXi0Idkmj5v+pibXtrs67/9IO5GA1O0JQ4pwUp/7WG4rrkB8Ok=
X-Received: from pjbsw3.prod.google.com ([2002:a17:90b:2c83:b0:2f4:3ea1:9033])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2c7:b0:2ee:e518:c1d8
 with SMTP id 98e67ed59e1d1-2f548f1c3f0mr18718339a91.30.1736557460283; Fri, 10
 Jan 2025 17:04:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:04:09 -0800
In-Reply-To: <20250111010409.1252942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111010409.1252942-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: Use mask of harvested dirty ring entries to coalesce
 dirty ring resets
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use "mask" instead of a dedicated boolean to track whether or not there
is at least one to-be-reset entry for the current slot+offset.  In the
body of the loop, mask is zero only on the first iteration, i.e. !mask is
equivalent to first_round.

Opportunstically combine the adjacent "if (mask)" statements into a single
if-statement.

No function change intended.

Cc: Peter Xu <peterx@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 60 +++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 95ab0e3cf9da..9b23f86ff7b6 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -108,7 +108,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 	u64 cur_offset, next_offset;
 	unsigned long mask = 0;
 	struct kvm_dirty_gfn *entry;
-	bool first_round = true;
 
 	while (likely((*nr_entries_reset) < INT_MAX)) {
 		if (signal_pending(current))
@@ -128,42 +127,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 		ring->reset_index++;
 		(*nr_entries_reset)++;
 
-		/*
-		 * While the size of each ring is fixed, it's possible for the
-		 * ring to be constantly re-dirtied/harvested while the reset
-		 * is in-progress (the hard limit exists only to guard against
-		 * wrapping the count into negative space).
-		 */
-		if (!first_round)
+		if (mask) {
+			/*
+			 * While the size of each ring is fixed, it's possible
+			 * for the ring to be constantly re-dirtied/harvested
+			 * while the reset is in-progress (the hard limit exists
+			 * only to guard against the count becoming negative).
+			 */
 			cond_resched();
 
-		/*
-		 * Try to coalesce the reset operations when the guest is
-		 * scanning pages in the same slot.
-		 */
-		if (!first_round && next_slot == cur_slot) {
-			s64 delta = next_offset - cur_offset;
+			/*
+			 * Try to coalesce the reset operations when the guest
+			 * is scanning pages in the same slot.
+			 */
+			if (next_slot == cur_slot) {
+				s64 delta = next_offset - cur_offset;
 
-			if (delta >= 0 && delta < BITS_PER_LONG) {
-				mask |= 1ull << delta;
-				continue;
-			}
+				if (delta >= 0 && delta < BITS_PER_LONG) {
+					mask |= 1ull << delta;
+					continue;
+				}
 
-			/* Backwards visit, careful about overflows!  */
-			if (delta > -BITS_PER_LONG && delta < 0 &&
-			    (mask << -delta >> -delta) == mask) {
-				cur_offset = next_offset;
-				mask = (mask << -delta) | 1;
-				continue;
+				/* Backwards visit, careful about overflows! */
+				if (delta > -BITS_PER_LONG && delta < 0 &&
+				(mask << -delta >> -delta) == mask) {
+					cur_offset = next_offset;
+					mask = (mask << -delta) | 1;
+					continue;
+				}
 			}
-		}
 
-		/*
-		 * Reset the slot for all the harvested entries that have been
-		 * gathered, but not yet fully processed.
-		 */
-		if (mask)
+			/*
+			 * Reset the slot for all the harvested entries that
+			 * have been gathered, but not yet fully processed.
+			 */
 			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+		}
 
 		/*
 		 * The current slot was reset or this is the first harvested
@@ -172,7 +171,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 		cur_slot = next_slot;
 		cur_offset = next_offset;
 		mask = 1;
-		first_round = false;
 	}
 
 	/*
-- 
2.47.1.613.gc27f4b7a9f-goog


