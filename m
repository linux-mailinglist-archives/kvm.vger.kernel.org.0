Return-Path: <kvm+bounces-46895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7064ABA557
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:38:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 065147B16C2
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A44B283FC0;
	Fri, 16 May 2025 21:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f1UEsmk6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5E4247295
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431353; cv=none; b=kxVstNgl4iVtpyEhn5muBCnmq4wiUrNaIXzfgn8tBnWQQpEBla8X+kZpb9Y9RooP7rnOQ8mJPWWU6c7kPIVcKV0SWVWwIuK593BZoAtd0svjkGjwHmF8MgvL6cnChGz4ujD5Av7J4lWzePy/GGdMp04cRBHOwV0UONYi30gUbCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431353; c=relaxed/simple;
	bh=it/UrIDf2OFvaNHNDtjuW+PbzU1ouQngBb1IuFpC9X4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BuQL4zxRn7VEswqMn9ZsMlS5VQvA+csKuMA5ab8XokRL8J6x5ffznbTY9zA4AgrAtBBipGbrpWDelLjJ+t1+KS9tUYEskMpClPD6WUVgMc3ZJD3jEFYNDKQ8kfzz0CEaW0FNWT0J8btJNYWda3bb5Yn+sG4lKFuomma/7D7HMBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f1UEsmk6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1fdf8f67e6so1635978a12.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431351; x=1748036151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oH92jyyUzDF22FMyCs7nXQd1z4bypvI1sQANzrXDq1I=;
        b=f1UEsmk6U/aXewlUVnu06jrHYnYAdgeFZL+/RncLDQTi8ZDQj58lSxHS+JqR+lFdYq
         rWwSks1DxzPxNINp7VulAvlcUhrW68jfZkAFv46x13tcOp1LAihrPc1Gm0kdrMw9e6lT
         uiFQcOhAukYELpUs/SOj7ARBxS0cD2562p7Ynd0VVAzkwM+U1euMQM98eGnKfOT8hnnb
         FtUQOGcQi2Mxhy3nFrQmnJb2pIezE2x2Xqoz+n66VdS0kCfAuB45yA8XJUWYYaIBrMsl
         TO/AIiXXPDJW5heI/2dKNP9cSimzpk9PDr6GFL5kKt5Rx8CST3ybC4RvI6fbsE1WOZnY
         nMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431351; x=1748036151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oH92jyyUzDF22FMyCs7nXQd1z4bypvI1sQANzrXDq1I=;
        b=p92Sypu2uiSpZlIoizW27HDCadmIsjJyZRPDG4IDXd8CVZVEkJiDv+P1xiAijnEXbs
         djQ4AmD/Y5N/zT21Tr4iMq9UycazGtgLqiKdpezXTKozqfbOkYFSulyF1qPSelXjlWSU
         ukEPuTwWPAhUbqFYMt0f9kMinz++IdkxK5IcBCkXDGHejbzNjqPQGHUkeMKm2YuazT88
         P3DblrlzJw3xctk1Euj6ihyAuTnYmJZ/3gokpQyvBHU3YxNbCU/Cuxiay49rXPj3tlK4
         9B2RwWrZp92eAdpEJRjyABiQJJa1lCi9jcy2DTdI6iquJR3nYmE4wZO1D8nS3YQa0qRp
         Homw==
X-Gm-Message-State: AOJu0YxnQ1iGMlInBtTeCDBtmVab1GRrNfK0K7gJt5e2lxyDq+Hnt+Sr
	Rl5H26o6cNesF4bgLJmF2jcTk2euA5OgoTAkK1g2EXlg5k0Qof3QhEwsHZrFaQxTA0Lx3Be3s5f
	KPXyJ1Q==
X-Google-Smtp-Source: AGHT+IG2XVhlAOS9mgw1KfyR0RdP6DuXNaKfftHf9CchOumLAZ3MSmb/leSlBEVbaGW23ke+ZRQXGORc/mY=
X-Received: from plkb7.prod.google.com ([2002:a17:903:fa7:b0:22e:50c9:c04b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:320e:b0:22f:b69f:e7fc
 with SMTP id d9443c01a7336-231d45c1151mr65220685ad.49.1747431351295; Fri, 16
 May 2025 14:35:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:35:39 -0700
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516213540.2546077-6-seanjc@google.com>
Subject: [PATCH v3 5/6] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Use "mask" instead of a dedicated boolean to track whether or not there
is at least one to-be-reset entry for the current slot+offset.  In the
body of the loop, mask is zero only on the first iteration, i.e. !mask is
equivalent to first_round.

Opportunistically combine the adjacent "if (mask)" statements into a single
if-statement.

No functional change intended.

Cc: Peter Xu <peterx@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 60 +++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 84c75483a089..54734025658a 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -121,7 +121,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 	u64 cur_offset, next_offset;
 	unsigned long mask = 0;
 	struct kvm_dirty_gfn *entry;
-	bool first_round = true;
 
 	while (likely((*nr_entries_reset) < INT_MAX)) {
 		if (signal_pending(current))
@@ -141,42 +140,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
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
@@ -185,7 +184,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 		cur_slot = next_slot;
 		cur_offset = next_offset;
 		mask = 1;
-		first_round = false;
 	}
 
 	/*
-- 
2.49.0.1112.g889b7c5bd8-goog


