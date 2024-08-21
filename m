Return-Path: <kvm+bounces-24797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 444A295A5DD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 22:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3419B23B8A
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 20:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB34017A924;
	Wed, 21 Aug 2024 20:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g5wT2Tcm"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8321170855;
	Wed, 21 Aug 2024 20:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272115; cv=none; b=HTHqtNrd7RLI7ERwNdG8A+2Vm9VqjQs80moz6Bx098iKO6Sy+qaIJLcQR00qrbQn1iDMdgHAUcrfA5hTW5NureBZu7eLAIswMurUGd1jCY1WJl/kQp1DCeccUirDZ3eYRBQJbArpTMGWi6PTsKMEPI6ANI53grn5vq/3nffd9PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272115; c=relaxed/simple;
	bh=5BtWl8Dnsbx+8f6UULFm5mZrQFd7xASkSWGtVqAHZKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyT/F7bw8FZBgmzIGgP8niThJJe1YHyweg3H2uOQmfOMBrx8bi8ffLQ1NoCgs5tzhiIJ0e8WLmazZma+WoC1P6+vmjjCQAbnYANUiBQPaN1ZMKJ4r5Q7bznWp5z1Hmgpbm8HajgsJ6EZfZ3hL56BZnExlBxsAtXJPZNmBEpI0u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g5wT2Tcm; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/rsvtto93wObnUsrzWtdVKXZIg/7tPJ25PmzaGy0YOM=; b=g5wT2TcmA96hRMh5YOIQsXkCej
	RU7JmXAectihWxotMoN4OucuX4qeoU96iSs/1mtRFIRwT1ChT1Uql5XPdQvUL4idDu0R1ylAxveZt
	pXvMHOI+wbOq3J3vjNv/pTMzNwBuERdQI4mGeBYB3xBzaJQImO1v6Y77++HEfUchbW4hi5VYb+q1N
	XizaNKYEVRY7w2WYZ6CVgUdFsiWyMnr4yBxhmZRSjmOzo3rUUk7B8mRn7Go/EcFLt1HpDIgkd+KtB
	Pwkcbd/sZ/+uJYhDTWpkEjfxBx1GlcPVQ5TGG+UymS9f5G/ddMzGjf/4CTVlgIdhtn9zv0T2RIgdi
	4DJ1pdzg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwG-00000009hcm-1f6U;
	Wed, 21 Aug 2024 20:28:17 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwE-00000002z8v-0oEl;
	Wed, 21 Aug 2024 21:28:14 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Hussain, Mushahid" <hmushi@amazon.co.uk>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mingwei Zhang <mizhang@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 3/5] KVM: pfncache: Wait for pending invalidations instead of spinning
Date: Wed, 21 Aug 2024 21:28:11 +0100
Message-ID: <20240821202814.711673-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240821202814.711673-1-dwmw2@infradead.org>
References: <20240821202814.711673-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The busy loop in hva_to_pfn_retry() is worse than a normal page fault
retry loop because it spins even while it's waiting for the invalidation
to complete. It isn't just that a page might get faulted out again before
it's actually accessed.

Introduce a wait queue to be woken when kvm->mn_active_invalidate_count
reaches zero, and wait on it if there is any pending invalidation which
affects the GPC being refreshed.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  5 ++++-
 virt/kvm/pfncache.c      | 32 ++++++++++++++++++++++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1bfe2e8d52cd..a0739c343da5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -772,6 +772,7 @@ struct kvm {
 	struct list_head gpc_list;
 	u64 mmu_gpc_invalidate_range_start;
 	u64 mmu_gpc_invalidate_range_end;
+	wait_queue_head_t gpc_invalidate_wq;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84eb1ebb6f47..e04eb700448b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -871,8 +871,10 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	 * There can only be one waiter, since the wait happens under
 	 * slots_lock.
 	 */
-	if (wake)
+	if (wake) {
+		wake_up(&kvm->gpc_invalidate_wq);
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
+	}
 }
 
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
@@ -1182,6 +1184,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
+	init_waitqueue_head(&kvm->gpc_invalidate_wq);
 	kvm->mmu_gpc_invalidate_range_start = KVM_HVA_ERR_BAD;
 	kvm->mmu_gpc_invalidate_range_end = KVM_HVA_ERR_BAD;
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index eeb9bf43c04a..fa494eb3d924 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -135,13 +135,38 @@ static bool gpc_invalidations_pending(struct gfn_to_pfn_cache *gpc)
 	 * No need for locking on GPC here because these fields are protected
 	 * by gpc->refresh_lock.
 	 */
-	guard(spinlock)(&gpc->kvm->mn_invalidate_lock);
-
 	return unlikely(gpc->kvm->mn_active_invalidate_count) &&
 		(gpc->kvm->mmu_gpc_invalidate_range_start <= gpc->uhva) &&
 		(gpc->kvm->mmu_gpc_invalidate_range_end > gpc->uhva);
 }
 
+static bool gpc_wait_for_invalidations(struct gfn_to_pfn_cache *gpc)
+{
+	bool waited = false;
+
+	spin_lock(&gpc->kvm->mn_invalidate_lock);
+	if (gpc_invalidations_pending(gpc)) {
+		DEFINE_WAIT(wait);
+
+		waited = true;
+		for (;;) {
+			prepare_to_wait(&gpc->kvm->gpc_invalidate_wq, &wait,
+					TASK_UNINTERRUPTIBLE);
+
+			if (!gpc_invalidations_pending(gpc))
+				break;
+
+			spin_unlock(&gpc->kvm->mn_invalidate_lock);
+			schedule();
+			spin_lock(&gpc->kvm->mn_invalidate_lock);
+		}
+		finish_wait(&gpc->kvm->gpc_invalidate_wq, &wait);
+	}
+	spin_unlock(&gpc->kvm->mn_invalidate_lock);
+	return waited;
+}
+
+
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
@@ -191,8 +216,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * to have been changted already, so hva_to_pfn() won't return
 		 * a stale mapping in that case anyway.
 		 */
-		while (gpc_invalidations_pending(gpc)) {
-			cond_resched();
+		if (gpc_wait_for_invalidations(gpc)) {
 			write_lock_irq(&gpc->lock);
 			continue;
 		}
-- 
2.44.0


