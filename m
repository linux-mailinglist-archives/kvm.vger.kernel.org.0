Return-Path: <kvm+bounces-71978-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6B99G9RUoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71978-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:12:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 175A31A7477
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ADBE13099503
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CF53D413F;
	Thu, 26 Feb 2026 13:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="OaP8ULDW"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEFF3A1CE9
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114039; cv=none; b=SW9EMqIrfEFPs9ZsdfgzfbJHFPLdlieeLXtXhiYcnFP8ip+xZyTfbBVAJ8mG3caNepY3FbTwcPxVlj1lMNqsQCN4vksN4oJC925RbDgPG5metpBy4mY/dQttUvNu3vyZAmOS2HK0hDOMzIDjypQKBGHZNOboHgDAl0uMTuvDaa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114039; c=relaxed/simple;
	bh=xj3qgDWInBgv1HJcvkKFcepxCu05tbNibn0I720DAkA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P3w7wixheothTKqeCQF9w7kwu0svXy2KRb5ZccTzt6BpMU3b5ZVDE2fvP6mjuSZwwD6N4QVrecgwDB/L3dK1fCsPZUno7QgGV4Srkolv/PHE0Zc75elLJFdRADihjRfWbDLyDXToibGB85R5jOy9tXjbdxSg2E1xc7dQe5yNtNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=OaP8ULDW; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772114037; x=1803650037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J7pTz0PmY3QTdoqUUtt5ne7seI7sXQNeObLfa2F6Ul4=;
  b=OaP8ULDWAmgGE/gAicU+tZJOpzTIOGbLf5wEVYHy/EDe4bXbYkD0bYCm
   ZpsDlhdP1soidTSO/w0oF5JCP90WmcIJG+7amwUbcyczxpThE+BX0HiiQ
   u6hWnt4PGdgI4LQaev0XjJVCllyxuUU0OPoQRI6pyFPh1ZL8e1qgJgDAp
   6ciTL2ayUr1KZErvgRU24Ie0e0WBVRSIXHKfn/CTfLrrtPihIiijJo/F4
   DtjwvmbG/YRKyrQj0xXc5Dy7lBuDJzs4wblQ1kDsR2LBPNWNB1nJnJF1Z
   NLJIVIryU/1ys8UH23At1KlTjPOHCHjxVHQ4vpeoEzcdwKTadchxJdYdr
   g==;
X-CSE-ConnectionGUID: 64UtDR2aTo2cynN8WXPXzw==
X-CSE-MsgGUID: lmEC6B2WRDub2LUOZDsj3g==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13734754"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:53:54 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:27984]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.108:2525] with esmtp (Farcaster)
 id 333d3f7e-c31a-4637-aa65-47878ad9d29b; Thu, 26 Feb 2026 13:53:54 +0000 (UTC)
X-Farcaster-Flow-ID: 333d3f7e-c31a-4637-aa65-47878ad9d29b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:54 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:52 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 6/7] KVM: Rename mn_* invalidate-related fields to generic ones
Date: Thu, 26 Feb 2026 13:53:07 +0000
Message-ID: <20260226135309.29493-7-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226135309.29493-1-itazur@amazon.com>
References: <20260226135309.29493-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWC003.ant.amazon.com (10.13.139.240) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-71978-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 175A31A7477
X-Rspamd-Action: no action

The addition of guest_memfd support to pfncaches introduces additional
sources of pfncache invalidation beyond the MMU notifier path.  The
existing mn_* naming implies that they are only relevant to MMU
notifiers, which is no longer true.

No functional changes intended.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 Documentation/virt/kvm/locking.rst |  8 +++---
 include/linux/kvm_host.h           | 11 ++++---
 virt/kvm/kvm_main.c                | 46 +++++++++++++++---------------
 virt/kvm/pfncache.c                | 28 +++++++++---------
 4 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/lo=
cking.rst
index ae8bce7fecbe..73679044ce44 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -20,7 +20,7 @@ The acquisition orders for mutexes are as follows:
 - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
   them together is quite rare.
=20
-- kvm->mn_active_invalidate_count ensures that pairs of
+- kvm->active_invalidate_count ensures that pairs of MMU notifier's
   invalidate_range_start() and invalidate_range_end() callbacks
   use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lock
   are taken on the waiting side when modifying memslots, so MMU notifiers
@@ -249,12 +249,12 @@ time it will be set using the Dirty tracking mechanis=
m described above.
 :Comment:	Exists to allow taking cpus_read_lock() while kvm_usage_count is
 		protected, which simplifies the virtualization enabling logic.
=20
-``kvm->mn_invalidate_lock``
-^^^^^^^^^^^^^^^^^^^^^^^^^^^
+``kvm->invalidate_lock``
+^^^^^^^^^^^^^^^^^^^^^^^^
=20
 :Type:          spinlock_t
 :Arch:          any
-:Protects:      mn_active_invalidate_count, mn_memslots_update_rcuwait
+:Protects:      active_invalidate_count, memslots_update_rcuwait
=20
 ``kvm_arch::tsc_write_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 618a71894ed1..7faa83d3d306 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -814,10 +814,13 @@ struct kvm {
 	 */
 	atomic_t nr_memslots_dirty_logging;
=20
-	/* Used to wait for completion of MMU notifiers.  */
-	spinlock_t mn_invalidate_lock;
-	unsigned long mn_active_invalidate_count;
-	struct rcuwait mn_memslots_update_rcuwait;
+	/*
+	 * Used by active memslots swap and pfncache refresh to wait for
+	 * invalidation to complete.
+	 */
+	spinlock_t invalidate_lock;
+	unsigned long active_invalidate_count;
+	struct rcuwait memslots_update_rcuwait;
=20
 	/* For management / invalidation of gfn_to_pfn_caches */
 	spinlock_t gpc_lock;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d64e70f8e8e3..f51056e971d0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -749,9 +749,9 @@ static int kvm_mmu_notifier_invalidate_range_start(stru=
ct mmu_notifier *mn,
 	 *
 	 * Pairs with the decrement in range_end().
 	 */
-	spin_lock(&kvm->mn_invalidate_lock);
-	kvm->mn_active_invalidate_count++;
-	spin_unlock(&kvm->mn_invalidate_lock);
+	spin_lock(&kvm->invalidate_lock);
+	kvm->active_invalidate_count++;
+	spin_unlock(&kvm->invalidate_lock);
=20
 	/*
 	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
@@ -760,7 +760,7 @@ static int kvm_mmu_notifier_invalidate_range_start(stru=
ct mmu_notifier *mn,
 	 * any given time, and the caches themselves can check for hva overlap,
 	 * i.e. don't need to rely on memslot overlap checks for performance.
 	 * Because this runs without holding mmu_lock, the pfn caches must use
-	 * mn_active_invalidate_count (see above) instead of
+	 * active_invalidate_count (see above) instead of
 	 * mmu_invalidate_in_progress.
 	 */
 	gpc_invalidate_hva_range_start(kvm, range->start, range->end);
@@ -819,18 +819,18 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
 	kvm_handle_hva_range(kvm, &hva_range);
=20
 	/* Pairs with the increment in range_start(). */
-	spin_lock(&kvm->mn_invalidate_lock);
-	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
-		--kvm->mn_active_invalidate_count;
-	wake =3D !kvm->mn_active_invalidate_count;
-	spin_unlock(&kvm->mn_invalidate_lock);
+	spin_lock(&kvm->invalidate_lock);
+	if (!WARN_ON_ONCE(!kvm->active_invalidate_count))
+		--kvm->active_invalidate_count;
+	wake =3D !kvm->active_invalidate_count;
+	spin_unlock(&kvm->invalidate_lock);
=20
 	/*
 	 * There can only be one waiter, since the wait happens under
 	 * slots_lock.
 	 */
 	if (wake)
-		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
+		rcuwait_wake_up(&kvm->memslots_update_rcuwait);
 }
=20
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
@@ -1131,8 +1131,8 @@ static struct kvm *kvm_create_vm(unsigned long type, =
const char *fdname)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	mutex_init(&kvm->slots_arch_lock);
-	spin_lock_init(&kvm->mn_invalidate_lock);
-	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
+	spin_lock_init(&kvm->invalidate_lock);
+	rcuwait_init(&kvm->memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	xa_init(&kvm->mem_attr_array);
@@ -1299,7 +1299,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	/*
 	 * At this point, pending calls to invalidate_range_start()
 	 * have completed but no more MMU notifiers will run, so
-	 * mn_active_invalidate_count may remain unbalanced.
+	 * active_invalidate_count may remain unbalanced.
 	 * No threads can be waiting in kvm_swap_active_memslots() as the
 	 * last reference on KVM has been dropped, but freeing
 	 * memslots would deadlock without this manual intervention.
@@ -1308,9 +1308,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	 * notifier between a start() and end(), then there shouldn't be any
 	 * in-progress invalidations.
 	 */
-	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
-	if (kvm->mn_active_invalidate_count)
-		kvm->mn_active_invalidate_count =3D 0;
+	WARN_ON(rcuwait_active(&kvm->memslots_update_rcuwait));
+	if (kvm->active_invalidate_count)
+		kvm->active_invalidate_count =3D 0;
 	else
 		WARN_ON(kvm->mmu_invalidate_in_progress);
 #else
@@ -1640,17 +1640,17 @@ static void kvm_swap_active_memslots(struct kvm *kv=
m, int as_id)
 	 * progress, otherwise the locking in invalidate_range_start and
 	 * invalidate_range_end will be unbalanced.
 	 */
-	spin_lock(&kvm->mn_invalidate_lock);
-	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
-	while (kvm->mn_active_invalidate_count) {
+	spin_lock(&kvm->invalidate_lock);
+	prepare_to_rcuwait(&kvm->memslots_update_rcuwait);
+	while (kvm->active_invalidate_count) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&kvm->mn_invalidate_lock);
+		spin_unlock(&kvm->invalidate_lock);
 		schedule();
-		spin_lock(&kvm->mn_invalidate_lock);
+		spin_lock(&kvm->invalidate_lock);
 	}
-	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
+	finish_rcuwait(&kvm->memslots_update_rcuwait);
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
-	spin_unlock(&kvm->mn_invalidate_lock);
+	spin_unlock(&kvm->invalidate_lock);
=20
 	/*
 	 * Acquired in kvm_set_memslot. Must be released before synchronize
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 3ff8251727e2..2880a36257c2 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -147,26 +147,24 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long=
 mmu_seq)
 {
 	/*
-	 * mn_active_invalidate_count acts for all intents and purposes
-	 * like mmu_invalidate_in_progress here; but the latter cannot
-	 * be used here because the invalidation of caches in the
-	 * mmu_notifier event occurs _before_ mmu_invalidate_in_progress
-	 * is elevated.
+	 * active_invalidate_count acts for all intents and purposes like
+	 * mmu_invalidate_in_progress here; but the latter cannot be used here
+	 * because the invalidation of caches in the mmu_notifier event occurs
+	 * _before_ mmu_invalidate_in_progress is elevated.
 	 *
-	 * Note, it does not matter that mn_active_invalidate_count
-	 * is not protected by gpc->lock.  It is guaranteed to
-	 * be elevated before the mmu_notifier acquires gpc->lock, and
-	 * isn't dropped until after mmu_invalidate_seq is updated.
+	 * Note, it does not matter that active_invalidate_count is not
+	 * protected by gpc->lock.  It is guaranteed to be elevated before the
+	 * mmu_notifier acquires gpc->lock, and isn't dropped until after
+	 * mmu_invalidate_seq is updated.
 	 */
-	if (kvm->mn_active_invalidate_count)
+	if (kvm->active_invalidate_count)
 		return true;
=20
 	/*
-	 * Ensure mn_active_invalidate_count is read before
-	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
-	 * mmu_notifier_invalidate_range_end() to guarantee either the
-	 * old (non-zero) value of mn_active_invalidate_count or the
-	 * new (incremented) value of mmu_invalidate_seq is observed.
+	 * Ensure active_invalidate_count is read before mmu_invalidate_seq.
+	 * This pairs with the smp_wmb() in kvm_mmu_invalidate_end() to
+	 * guarantee either the old (non-zero) value of active_invalidate_count
+	 * or the new (incremented) value of mmu_invalidate_seq is observed.
 	 */
 	smp_rmb();
 	return kvm->mmu_invalidate_seq !=3D mmu_seq;
--=20
2.50.1


