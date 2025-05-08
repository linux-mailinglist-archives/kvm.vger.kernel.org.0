Return-Path: <kvm+bounces-45895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFFB8AAFC77
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74FA91C23704
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65B4265611;
	Thu,  8 May 2025 14:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JkkAsPuL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541A0266EF1
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713425; cv=none; b=qa5VKq6pRKBbVkGTMbmQHzGHrRWrJQVLD177/NjjAxlrIlDj3QZ2hcSriCCbKkSC5ifHdjt5SYqyknDaR6yj87GhAjAphx8/yCVAbxPJqGsKMmLFzo4UFe18MKzvdLpcZ3u9cb5kuNFRpCPn0g6S91PvCr3IXKaE5SgMDibXv7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713425; c=relaxed/simple;
	bh=awSJS8WConudI9j96iI1tSZciOtqzk/WMv+Azjyuw5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jiVzEBnXGKSiG9TJYlfANUfcWkH6J0YNnrzhSVpspOtukdnm+8EvgHASnn1/4P/5Z4FykEf1Ii89GyRAsTptNTz2f8UviUNRJMVuihQIXf3KvHQ1cdU8ISfGbJW34oHCD7mKBOTMuT3QKtEMPsBUufkgH6DtRL+qEB3UJOUZlBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JkkAsPuL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7395d07a3dcso786017b3a.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746713423; x=1747318223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ickIymo1Jt+rHn8phqijkm5gyPMPS3XGUhpL5W5szxc=;
        b=JkkAsPuLfXVqfoTGbXl996mYyAQa5A2IVn1pgWLhb3oB3Of9WQXA5TOJV8oO42N4G3
         EGQzQB2SCUstHYbetR0vHko+tauX4E3RHMO2G3aQGYQIvoRmanHZY5nmAcxMusFVQEIJ
         Z7TIYSVOH8GrHzAUXpjKles2P2v8mLOjRP/ZikR0iUnN0Lw0yhjpjHPaGeqP3NB7GULL
         u/A7pZ0h6nxRBcGoBfY7DmLbB5oK38f3PXOqRHcio3LNgAf7F5oDY3BP37gtza+0wU8N
         I29evWZCKHLnaHx1rcRXaHA0AksnonIv8j134C4r/TCZXbIXay1n9xN6RaRrCUNAjNZv
         Poog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713423; x=1747318223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ickIymo1Jt+rHn8phqijkm5gyPMPS3XGUhpL5W5szxc=;
        b=jyHBI2Ja4xFJ7v3iT99Sl65UUZoVZJcJZ/8Hc9C62Ueh+FuPR4zwE2aX2K/V+b7lOY
         gxnKw0p6ybnnP89KBxeZkzNAkvx1wZFLtv/RVJyeYzQr7wCHdHe8c+TAXMA0GjklPdRo
         Wt+khaWbtqddIgAJaJklmEoSAfmqs5CmMnJlawsCEFOXY2wI0AZZ1QVoUmnO392q2lVu
         tp1QwmZsGJ8fLvXudx1CFfIWGjqt8nWTH3H9QKnWe9+DmZC+XF2faO+FdCCd43bT6Dsb
         fyG8dvW0U6/ORTWPDIJNFWhC5rH3MrzDOShRMOHU4fKdGKHx6LhSuFMJ7TIcgqsBdwTs
         tFzg==
X-Gm-Message-State: AOJu0YxEJt7TAI1qIqGjCJgOPWX2PnYDDQO8PrnR2rJhR/OGiyCC/Ek0
	q8i4/x2Yfv/svWMPT2ydAZnkr8q1tWbdVGnZAJQYbd6T656BJRK71dWqanUzlEveNEraubvvhii
	/Kg==
X-Google-Smtp-Source: AGHT+IHLiymXHmxCwlVp1XiwMzwsV4UPdVj2tb8haL51LmOJpuCCiwihi6XjLonfWdsyG+RYO6/C9IKGO2I=
X-Received: from pfbgs18.prod.google.com ([2002:a05:6a00:4d92:b0:739:45ba:a49a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:35cd:b0:732:2923:b70f
 with SMTP id d2e1a72fcca58-740a99c4bd6mr4703644b3a.11.1746713422488; Thu, 08
 May 2025 07:10:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 May 2025 07:10:11 -0700
In-Reply-To: <20250508141012.1411952-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508141012.1411952-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508141012.1411952-5-seanjc@google.com>
Subject: [PATCH v2 4/5] KVM: Check for empty mask of harvested dirty ring
 entries in caller
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
 virt/kvm/dirty_ring.c | 44 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 97cca0c02fd1..a3434be8f00d 100644
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
+	 * be batched with "current" the entry(s), and that reset processes the
+	 * _current_ entry(s), i.e. the last harvested entry, a.k.a. next, will
+	 * always be left pending.
+	 */
+	if (mask)
+		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 
 	/*
 	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
-- 
2.49.0.1015.ga840276032-goog


