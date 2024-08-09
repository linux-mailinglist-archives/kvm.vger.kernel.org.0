Return-Path: <kvm+bounces-23794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DFCC94D7AC
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1659B21106
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B851684B4;
	Fri,  9 Aug 2024 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UGmUI3G0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8921E19ADB9
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232659; cv=none; b=d03US/22YHagHvm8AWDUTkmJ5yen8dEgcrLG5gajfz2mcGpOYvDDOFhPUCrgqtX674zJp7ZHvt8dRxq7Uj+59an+yZiMgl3TZTIKq1j78+lqFLT/GDZIfJYbVujS2W4OaGJevmKltDe9jswH7SxFPfB8v9xqoBBeIhH0ii92I78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232659; c=relaxed/simple;
	bh=5rReX2g7eJHcUC+j0NjSl5Msvx0o5Y1O/Iq1eeDsNj4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IoF7pdMD+aHRrfFq8GqvHbE+SY/WG/EzWY+EVpeMZGXkQa34+J7a3Oio0XFblCDOUvXP/qTDOeyBpoaIctqrB0JJTWUOfE2ocpfo7fSspNzHVdTaqJAuMQKI7kUEuNx51RV+xGaLDtupD+I9Mj1N5wMWHnwFMHsI9hEUJ4oPF8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UGmUI3G0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6698f11853aso48179447b3.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232656; x=1723837456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kaQkfw19FaVNluamR3vKVuhloxrU0TCLWsyQPJoUOaw=;
        b=UGmUI3G0LPbglxhO0HahDxJaWVCfKe2K1LDPTW0hprlQiKr4n4ItnsaK7ttuAIOyGA
         WaLQW4G7HMbvnfb7XULss7ilkhWNYwz6IzwtmFz3r7HgIMG1a5tVIg6eYjOnOkjZZYpN
         CAdUTLn16zZSU3Vqr5pAdMsydj8qIIIMucciSlVE2WJw0xTB0DNwswId5yOFQen4yuFY
         LG36TKXU/sNFMv40d8rfgytSYowHforLdGojtETZxR3NNhTRDh+pxr0WZAQSeROrvi3+
         HCSDN2jtmUcgq/NipXxX69oynrW/s7DeKhLpyPB/sGu1pZzYDo/EcMF8dNLDJ3RKEg3f
         Sl4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232656; x=1723837456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kaQkfw19FaVNluamR3vKVuhloxrU0TCLWsyQPJoUOaw=;
        b=PQAEhMrB1omTGRxJxMwOj1FOEgYGHxpViBQyZ8ZCiFVT2l7AIE2MG6W+yiqD3ng2++
         O1Vfa4Wm0ToJdXJNF5O0LJGOYQ0YxYvxEA80Cztsqld+1UiN439tUh+uDiBC8qpFyNTj
         JwxcIRbBSdnlrJkHCszOiHlBfzWSheBJtagu2WewgYmD7RHaPNY2t6pL7jPOnwGHCdPG
         m6DgSD+/00/Xv7iD/QwSa28cMLlUON4UWmJymXjXi2bSGwhLaFutG+ulTroeLO26hUg2
         UPopfoDbNEM4Wf2h/iB1CRKvvrsAmJlqeFNUHSNsjeCNGh8d8VwDlwTjARdaaFcfVtmC
         GvhQ==
X-Gm-Message-State: AOJu0Yz+0JSSJXRJQCkkE7twFiD8Tgmx0VAMIU1zLcl+sMrTHlCiqFNt
	TRvmNGo5XNErRfNJdYZuWy9uWB6IfD63h5DqHzS8wdDDZ/SePk5If4drbs0pnilznuIxnMQrtDG
	tRQ==
X-Google-Smtp-Source: AGHT+IEBMWPkgI1k2a5Dd4JPhwd4nlairCp4gJ2z3JSwf2Dhnd/SN6RWtBOMd6oz6Ibb0/SIzT9/HBsYOT8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:e8e:0:b0:e0b:cce3:45c7 with SMTP id
 3f1490d57ef6-e0eb99ff70amr4436276.9.1723232656534; Fri, 09 Aug 2024 12:44:16
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:31 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-20-seanjc@google.com>
Subject: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking rmaps
 outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Steal another bit from rmap entries (which are word aligned pointers, i.e.
have 2 free bits on 32-bit KVM, and 3 free bits on 64-bit KVM), and use
the bit to implement a *very* rudimentary per-rmap spinlock.  The only
anticipated usage of the lock outside of mmu_lock is for aging gfns, and
collisions between aging and other MMU rmap operations are quite rare,
e.g. unless userspace is being silly and aging a tiny range over and over
in a tight loop, time between contention when aging an actively running VM
is O(seconds).  In short, a more sophisticated locking scheme shouldn't be
necessary.

Note, the lock only protects the rmap structure itself, SPTEs that are
pointed at by a locked rmap can still be modified and zapped by another
task (KVM drops/zaps SPTEs before deleting the rmap entries)

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 80 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8ca7f51c2da3..a683b5fc4026 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -909,11 +909,73 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
  * About rmap_head encoding:
  *
  * If the bit zero of rmap_head->val is clear, then it points to the only spte
- * in this rmap chain. Otherwise, (rmap_head->val & ~1) points to a struct
+ * in this rmap chain. Otherwise, (rmap_head->val & ~3) points to a struct
  * pte_list_desc containing more mappings.
  */
 #define KVM_RMAP_MANY	BIT(0)
 
+/*
+ * rmaps and PTE lists are mostly protected by mmu_lock (the shadow MMU always
+ * operates with mmu_lock held for write), but rmaps can be walked without
+ * holding mmu_lock so long as the caller can tolerate SPTEs in the rmap chain
+ * being zapped/dropped _while the rmap is locked_.
+ *
+ * Other than the KVM_RMAP_LOCKED flag, modifications to rmap entries must be
+ * done while holding mmu_lock for write.  This allows a task walking rmaps
+ * without holding mmu_lock to concurrently walk the same entries as a task
+ * that is holding mmu_lock but _not_ the rmap lock.  Neither task will modify
+ * the rmaps, thus the walks are stable.
+ *
+ * As alluded to above, SPTEs in rmaps are _not_ protected by KVM_RMAP_LOCKED,
+ * only the rmap chains themselves are protected.  E.g. holding an rmap's lock
+ * ensures all "struct pte_list_desc" fields are stable.
+ */
+#define KVM_RMAP_LOCKED	BIT(1)
+
+static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+{
+	unsigned long old_val, new_val;
+
+	old_val = READ_ONCE(rmap_head->val);
+	if (!old_val)
+		return 0;
+
+	do {
+		/*
+		 * If the rmap is locked, wait for it to be unlocked before
+		 * trying acquire the lock, e.g. to bounce the cache line.
+		 */
+		while (old_val & KVM_RMAP_LOCKED) {
+			old_val = READ_ONCE(rmap_head->val);
+			cpu_relax();
+		}
+
+		/*
+		 * Recheck for an empty rmap, it may have been purged by the
+		 * task that held the lock.
+		 */
+		if (!old_val)
+			return 0;
+
+		new_val = old_val | KVM_RMAP_LOCKED;
+	} while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));
+
+	/* Return the old value, i.e. _without_ the LOCKED bit set. */
+	return old_val;
+}
+
+static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
+			    unsigned long new_val)
+{
+	WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
+	WRITE_ONCE(rmap_head->val, new_val);
+}
+
+static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
+{
+	return READ_ONCE(rmap_head->val) & ~KVM_RMAP_LOCKED;
+}
+
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
@@ -924,7 +986,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	struct pte_list_desc *desc;
 	int count = 0;
 
-	old_val = rmap_head->val;
+	old_val = kvm_rmap_lock(rmap_head);
 
 	if (!old_val) {
 		new_val = (unsigned long)spte;
@@ -956,7 +1018,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		desc->sptes[desc->spte_count++] = spte;
 	}
 
-	rmap_head->val = new_val;
+	kvm_rmap_unlock(rmap_head, new_val);
 
 	return count;
 }
@@ -1004,7 +1066,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
 		goto out;
 
@@ -1030,7 +1092,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	}
 
 out:
-	rmap_head->val = rmap_val;
+	kvm_rmap_unlock(rmap_head, rmap_val);
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -1048,7 +1110,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (!rmap_val)
 		return false;
 
@@ -1067,13 +1129,13 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	}
 out:
 	/* rmap_head is meaningless now, remember to reset it */
-	rmap_head->val = 0;
+	kvm_rmap_unlock(rmap_head, 0);
 	return true;
 }
 
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
-	unsigned long rmap_val = rmap_head->val;
+	unsigned long rmap_val = kvm_rmap_get(rmap_head);
 	struct pte_list_desc *desc;
 
 	if (!rmap_val)
@@ -1139,7 +1201,7 @@ struct rmap_iterator {
 static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
-	unsigned long rmap_val = rmap_head->val;
+	unsigned long rmap_val = kvm_rmap_get(rmap_head);
 	u64 *sptep;
 
 	if (!rmap_val)
-- 
2.46.0.76.ge559c4bf1a-goog


