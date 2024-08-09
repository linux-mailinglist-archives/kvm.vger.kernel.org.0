Return-Path: <kvm+bounces-23795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9092194D7AD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C4D01F23024
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587FA19CCE8;
	Fri,  9 Aug 2024 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MCNWDJlp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1364B19B3E1
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232660; cv=none; b=bZP4ztqMJaCx7We3UuUOQRWKb7irleGhDrBJvuI6yzyycH1c13FbYR11IPv2ANoYnTE+A656P4A9tIF1L1Hj6+VFs125MBdPjQqG+O0M4VWC3Alp+m5qxObdBipLjO5Rmv7FsH61lqdk7a3gIWeOSKB7XxBSTDsJ59QdqmJOQvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232660; c=relaxed/simple;
	bh=UJIPN/Wqw44nvsetoo32cIAvD96dImRh3JnAszJC0xg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PBlGDHw1oYonVMDWQ4UZsRxby32UvEY1EJsg6QUwixhw9iTIkghwtcxoZ64x8F2YIFyTeUguUyu+Bg3GVSSL85kSsx0kaKzF29CdfKeJhJwAmxRCCLR1jMXwtCl2XuvcnsBh39xmzLL4FFVKxUaqk1pxClzw+lOFGgEf9Vja+Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MCNWDJlp; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc53227f21so28240305ad.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232658; x=1723837458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/UfIOuTzGEIV2Af0nH4NhXy855i+DLQnfbOw4mjIiPM=;
        b=MCNWDJlp/eBX60WFUNv999DoOKjZAIiTfD6dX5B43XmFxdoJXe86Ng0oE9uaGtAyXw
         YpZMW6YKqMduUVt8xbcv3RpfviAG2X7QYOyEFcTTXuyB/vcrJFU6d/LCaff5jcJukoo4
         tpUb6cA8QoWSW4OJoUYHzQ9q604cURYqDIHex99DHuhsS2A9Y1G7yH2DWztDGkXSzvsp
         Ne14ArelML/Pc/yDL0h+Mw58YNmOJ53KIL5M7tsU9X8UK2HiFEhb42qx1uoLcBp0vp9E
         RiVWZLs+jOnGp4SwYcq3nnh5zaZBjIhCrRp+YSyfi00OZM4f3uoYfdoeScgXId6olF56
         lR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232658; x=1723837458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/UfIOuTzGEIV2Af0nH4NhXy855i+DLQnfbOw4mjIiPM=;
        b=a8VphWN46FWhFentXY+zugTQA3bQPV6Fm+libnHjhbaEJyQHSbY1Ft6vtysR/2rDsf
         rI1A4AokzTxXqAQfuG+THRLTj3L+0w61VsV999hdeTpY94IFioQTt3NGC2g2Lt+5bEPs
         G0FgbW7pQdMjTrud2I5iualzq2m37ExFpzlQVFJcle3BlOBDad8sr1qNqXGHUOob6bO4
         ne5nkc0eeOF+YGZI2S8e/ams2RHsj/r+gwdpBeE4el8v52VHig/3IQ0nbuSKLwsvAV7U
         WAMxl6ER1AVDWyzz93QfwWaNd2/700VFoarsmPf/bkGYOUpTGpZRXBjJepK671/mcD/5
         jQwg==
X-Gm-Message-State: AOJu0Yzh/QEUx+OBEuWK4E/EE/s6M+W0RQdr7KMb8/u6a3LNqDDohDHV
	SKtcucdt0KilnUjwDCz8XMXMijFtRDOn42qrp1xpdWF8QCrID8tMM5DK0p4shKFiQ8eXf4o7MD0
	jLQ==
X-Google-Smtp-Source: AGHT+IGIFyto8PfbQoPuRgcHzc8y0pWxF/kkpM1SeNnq1V1bACAA4fUhirUzmNwmEGbz15VyaKrug3Yf37Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74e:b0:1ff:39d7:a1a4 with SMTP id
 d9443c01a7336-200ae5d8a1cmr1519355ad.12.1723232658496; Fri, 09 Aug 2024
 12:44:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:32 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-21-seanjc@google.com>
Subject: [PATCH 20/22] KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a lockless version of for_each_rmap_spte(), which is pretty much the
same as the normal version, except that it doesn't BUG() the host if a
non-present SPTE is encountered.  When mmu_lock is held, it should be
impossible for a different task to zap a SPTE, _and_ zapped SPTEs must
be removed from their rmap chain prior to dropping mmu_lock.  Thus, the
normal walker BUG()s if a non-present SPTE is encountered as something is
wildly broken.

When walking rmaps without holding mmu_lock, the SPTEs pointed at by the
rmap chain can be zapped/dropped, and so a lockless walk can observe a
non-present SPTE if it runs concurrently with a different operation that
is zapping SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 86 +++++++++++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a683b5fc4026..48e8608c2738 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -932,10 +932,16 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
  */
 #define KVM_RMAP_LOCKED	BIT(1)
 
-static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+static unsigned long __kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
 {
 	unsigned long old_val, new_val;
 
+	/*
+	 * Elide the lock if the rmap is empty, as lockless walkers (read-only
+	 * mode) don't need to (and can't) walk an empty rmap, nor can they add
+	 * entries to the rmap.  I.e. the only paths that process empty rmaps
+	 * do so while holding mmu_lock for write, and are mutually exclusive.
+	 */
 	old_val = READ_ONCE(rmap_head->val);
 	if (!old_val)
 		return 0;
@@ -960,17 +966,53 @@ static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
 		new_val = old_val | KVM_RMAP_LOCKED;
 	} while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));
 
-	/* Return the old value, i.e. _without_ the LOCKED bit set. */
+	/*
+	 * Return the old value, i.e. _without_ the LOCKED bit set.  It's
+	 * impossible for the return value to be 0 (see above), i.e. the read-
+	 * only unlock flow can't get a false positive and fail to unlock.
+	 */
 	return old_val;
 }
 
+static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+{
+	/*
+	 * TODO: Plumb in @kvm and add a lockdep assertion that mmu_lock is
+	 *       held for write.
+	 */
+	return __kvm_rmap_lock(rmap_head);
+}
+
 static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
 			    unsigned long new_val)
 {
-	WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
+	KVM_MMU_WARN_ON(new_val & KVM_RMAP_LOCKED);
 	WRITE_ONCE(rmap_head->val, new_val);
 }
 
+/*
+ * If mmu_lock isn't held, rmaps can only locked in read-only mode.  The actual
+ * locking is the same, but the caller is disallowed from modifying the rmap,
+ * and so the unlock flow is a nop if the rmap is/was empty.
+ */
+__maybe_unused
+static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_head)
+{
+	return __kvm_rmap_lock(rmap_head);
+}
+
+__maybe_unused
+static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
+				     unsigned long old_val)
+{
+	if (!old_val)
+		return;
+
+	KVM_MMU_WARN_ON(old_val != (rmap_head->val & ~KVM_RMAP_LOCKED));
+	WRITE_ONCE(rmap_head->val, old_val);
+}
+
+
 static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
 {
 	return READ_ONCE(rmap_head->val) & ~KVM_RMAP_LOCKED;
@@ -1202,23 +1244,18 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
 	unsigned long rmap_val = kvm_rmap_get(rmap_head);
-	u64 *sptep;
 
 	if (!rmap_val)
 		return NULL;
 
 	if (!(rmap_val & KVM_RMAP_MANY)) {
 		iter->desc = NULL;
-		sptep = (u64 *)rmap_val;
-		goto out;
+		return (u64 *)rmap_val;
 	}
 
 	iter->desc = (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 	iter->pos = 0;
-	sptep = iter->desc->sptes[iter->pos];
-out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
-	return sptep;
+	return iter->desc->sptes[iter->pos];
 }
 
 /*
@@ -1228,14 +1265,11 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
  */
 static u64 *rmap_get_next(struct rmap_iterator *iter)
 {
-	u64 *sptep;
-
 	if (iter->desc) {
 		if (iter->pos < PTE_LIST_EXT - 1) {
 			++iter->pos;
-			sptep = iter->desc->sptes[iter->pos];
-			if (sptep)
-				goto out;
+			if (iter->desc->sptes[iter->pos])
+				return iter->desc->sptes[iter->pos];
 		}
 
 		iter->desc = iter->desc->more;
@@ -1243,20 +1277,26 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 		if (iter->desc) {
 			iter->pos = 0;
 			/* desc->sptes[0] cannot be NULL */
-			sptep = iter->desc->sptes[iter->pos];
-			goto out;
+			return iter->desc->sptes[iter->pos];
 		}
 	}
 
 	return NULL;
-out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
-	return sptep;
 }
 
-#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
-	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
-	     _spte_; _spte_ = rmap_get_next(_iter_))
+#define __for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)	\
+	for (_sptep_ = rmap_get_first(_rmap_head_, _iter_);	\
+	     _sptep_; _sptep_ = rmap_get_next(_iter_))
+
+#define for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)	\
+	__for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)	\
+		if (!is_shadow_present_pte(*(_sptep_)))		\
+			BUG();					\
+		else
+
+#define for_each_rmap_spte_lockless(_rmap_head_, _iter_, _sptep_, _spte_)	\
+	__for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)			\
+		if (is_shadow_present_pte(_spte_ = mmu_spte_get_lockless(sptep)))
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-- 
2.46.0.76.ge559c4bf1a-goog


