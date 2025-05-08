Return-Path: <kvm+bounces-45896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94526AAFC7E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A9441C23B36
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E96267736;
	Thu,  8 May 2025 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QDI6i43V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555E8266F0F
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713427; cv=none; b=mrb+By4CskMuHq4imfeje7o1Yl9pHfjsqecxH3oNqFP07Nhho+nI6by0BjsRb7jPJn77rUrThzu6js/cQmMENO8B1+XWDqB23XhVT5Nx2W2LLQ6WOdqcuhD0AXytL3prVW3A8l8MDYzIZLbrFABXs23FmNRZCJPV6T8R4BujwnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713427; c=relaxed/simple;
	bh=RaCWxBRdYBPrhmSkEzciipjWTledXPE2JsIOwJIPUVc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rRy/MvWRD3ajGu53sCWUaD87mRXc2Y3n08y34i/kb2e6Tu2CWGyBuXFrujKR3m0ulCapzshj9fEWISgZ8i2CK1zfkTAd2p6oetJ0x+MISyV7RYCrtZDZEqJEXIl7Y9k3u43HX0t7AqfnJxgae3+VfyeMFL/w2Q/M1kC9RoPN13k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QDI6i43V; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ad109bc89so1288045a91.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746713425; x=1747318225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4KGvQ+Q6heMHcK36CVSIx+UJlHy7CJTk2MzDhPy5Mfw=;
        b=QDI6i43Vy/TKdQgzyIHXEngulWNLc8swjDSmohQmH4KiDjobOStg4pwWY8qHJ1I7eK
         zylfHqArpSfkdSuspiPCpNU71V3KoCdlH2pshWoyS8ekNOw4Z5BMzQcEs1IfWwkLiHRg
         QbwRm3MOFIbYdgvIVV9H0IYV+SqUOxYhULgjwqOrU8ohWiFYPciihKjthNkjD4rzAWiq
         3HDouEl3zLvm42eYixTWR+HXdx78zxDhnbj8LA/UlWfJvbOK/vfwihKaRV9m+Ggavcqr
         S1M0dAcP1Zi5m64LNAfocQIbYND4Jo9qL/MHB59uT1+p2hP2cjdaA3RN+LoHzu0Po+2d
         pg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713425; x=1747318225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KGvQ+Q6heMHcK36CVSIx+UJlHy7CJTk2MzDhPy5Mfw=;
        b=tH2/XywJCvNFq3l5W/ZxBXMWgpdpekRkVbQ/juJEPECLrlE7O+c91VblVC92cwINwZ
         40ueIAow8iXGp1cL86em1c40yaSnZ8C3ZJa4wjwlWWNeQ+omTQTk5GTP++aTxGorkz5W
         8Gdh6ck+X4hVx6UlbcO6VcYpuFl1JmHoWkPT6leBMgpxMAZWhnrab6Y9fvtHOVYVyxKW
         RIAdH5O9ryTsn6XpeAMsdU6W+ixMmitQHv2BXCgzJPm8fXDiQ6Qq+FRoqpj8Y51R3z7q
         icecBvZSOYieVqs5cMmcq8eenReBCkIl+34br/LusFewpTUQCm4mm+WmCTWur9mlwVve
         2e/w==
X-Gm-Message-State: AOJu0Yw0L4b6ruZ+Vqam8AoE4KwAPaKJrVTf4VD4dMZ+aovjKytFPB5n
	ZFhvkMJ/n5LIISBvGu08ro0jDvjLDdUFvbKS3DbLwEa+QvhbMI8duGIB20Jh/BIjBQ+ePT/+Avp
	Zuw==
X-Google-Smtp-Source: AGHT+IEtWJ3nmgNRQEmk4BVb5RHnwtUoCyvuNs/Epm6J06x22EncYKPdDDsnMCNUw8J0F0H1iuL5jdh5x00=
X-Received: from pjuu13.prod.google.com ([2002:a17:90b:586d:b0:2fa:1481:81f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d86:b0:2f7:4cce:ae37
 with SMTP id 98e67ed59e1d1-30aac1b3f9emr12785433a91.18.1746713424759; Thu, 08
 May 2025 07:10:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 May 2025 07:10:12 -0700
In-Reply-To: <20250508141012.1411952-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508141012.1411952-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508141012.1411952-6-seanjc@google.com>
Subject: [PATCH v2 5/5] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
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
index a3434be8f00d..934828d729e5 100644
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
2.49.0.1015.ga840276032-goog


