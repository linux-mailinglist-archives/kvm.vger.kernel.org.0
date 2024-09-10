Return-Path: <kvm+bounces-26313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C66973D59
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C54F71F26C81
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F3B1A2C12;
	Tue, 10 Sep 2024 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="VMiYY4fW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AFD1A2C00;
	Tue, 10 Sep 2024 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985917; cv=none; b=AiISTcV+QVmhfu6G0kO1ljPcYYor7FYZlLEF9+qBtExDt1J1IIvODEzxp3dtfTNUup4kxTES6vcqqjy72MVsq0e4ZuHgcbcTfQJJMdkDkmyKi8qjTfrDlMZDKN3bcsy4V4Zal6/KmVx1+Tf4ZY5BNXdb8ESi3Ia7CzS2T0x/PAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985917; c=relaxed/simple;
	bh=27p9BHXqytoKqNPVT9HlrnpL6ztRh/qfZoFZTXZfoIs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8zjoxg0V5591bBQiOxB1yaklOvNPDcEkxDjvt9axvJ8DD3FisvXzYyzSNqnqS/CjELPzghUCALUuz68YwJkxMD8qoVWiok+JzxIuw0j605No2Tfjq01AVIFx30kjJ3cboOQ1TCDZ5Jv/fGhHYRnCLROdY/iJ19kIG4zITZhUFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=VMiYY4fW; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985916; x=1757521916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pdVStUC4kefwy9z9Wrcp9pHN8EBxQ7DScGA7ZKdZ8CE=;
  b=VMiYY4fW4xneP5aEmkvkJoX756W8chjkU1Ag7Vfh1ggnmwuG3f0cJi0Z
   aZlzJEyQSUkbfF4WSt24ebz1BIWkgfbolXx86qvSYTSFO9N6IRxUuYEea
   Qd7yJfEmGWT/Rbh8v72swE9uJ/bPbrJ0sJEzDOZXhLOthe0YaJPfI+hNi
   E=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="329560108"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:47 +0000
Received: from EX19MTAUEB002.ant.amazon.com [10.0.44.209:47995]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.10.99:2525] with esmtp (Farcaster)
 id 07908219-420c-4de5-b1ea-5205007e9ec1; Tue, 10 Sep 2024 16:31:44 +0000 (UTC)
X-Farcaster-Flow-ID: 07908219-420c-4de5-b1ea-5205007e9ec1
Received: from EX19D008UEC004.ant.amazon.com (10.252.135.170) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:37 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEC004.ant.amazon.com (10.252.135.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:36 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:31:32 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <quic_eberman@quicinc.com>,
	<dwmw@amazon.com>, <david@redhat.com>, <tabba@google.com>, <rppt@kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <graf@amazon.com>,
	<jgowans@amazon.com>, <derekmn@amazon.com>, <kalyazin@amazon.com>,
	<xmarcalx@amazon.com>
Subject: [RFC PATCH v2 09/10] kvm: pfncache: hook up to gmem invalidation
Date: Tue, 10 Sep 2024 17:30:35 +0100
Message-ID: <20240910163038.1298452-10-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910163038.1298452-1-roypat@amazon.co.uk>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Invalidate gfn_to_pfn_caches that hold gmem pfns whenever gmem
invalidations occur (fallocate(FALLOC_FL_PUNCH_HOLE),
error_remove_folio)..

gmem invalidations are difficult to handle for gpcs. The unmap path for
gmem pfns in gpc tries to decrement the sharing ref count, and
potentially modifies the direct map. However, these are not operations
we can do after the gmem folio that used to sit in the pfn has been
freed (and after we drop gpc->lock in
gfn_to_pfn_cache_invalidate_gfns_start we are racing against the freeing
of the folio, and we cannot do direct map manipulations before dropping
the lock). Thus, in these cases (punch hole and error_remove_folio), we
must "leak" the sharing reference (which is fine because either the
folio has already been freed, or it is about to be freed by
->invalidate_folio, which only reinserts into the direct map. So if the
folio already is in the direct map, no harm is done). So in these cases,
we simply store a flag that tells gpc to skip unmapping of these pfns
when the time comes to refresh the cache.

A slightly different case are if just the memory attributes on a memslot
change. If we switch from private to shared, the gmem pfn will still be
there, it will simply no longer be mapped into the guest. In this
scenario, we must unmap to decrement the sharing count, and reinsert
into the direct map. Otherwise, if for example the gpc gets deactivated
while the gfn is set to shared, and after that the gfn is flipped to
private, something else might use the pfn, but it is still present in
the direct map (which violates the security goal of direct map removal).

However, there is one edge case we need to deal with: It could happen
that a gpc gets invalidated by a memory attribute change (e.g.
gpc->needs_unmap = true), then refreshed, and after the refresh loop has
exited and the gpc->lock is dropped, but before we get to gpc_unmap, the
gmem folio that occupies the invalidated pfn of the cache is fallocated
away. Now needs_unmap will be true, but we are once again racing against
the freeing of the folio. For this case, take a reference to the folio
before we drop the gpc->lock, and only drop the reference after
gpc_unmap returned, to avoid the folio being freed.

For similar reasons, gfn_to_pfn_cache_invalidate_gfns_start needs to not
ignore already invalidated caches, as a cache that was invalidated due
to a memory attribute change will have needs_unmap=true. If a
fallocate(FALLOC_FL_PUNCH_HOLE) operation happens on the same range,
this will need to get updated to needs_unmap=false, even if the cache is
already invalidated.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/kvm_host.h  |  3 +++
 include/linux/kvm_types.h |  1 +
 virt/kvm/guest_memfd.c    | 19 +++++++++++++++-
 virt/kvm/kvm_main.c       |  5 ++++-
 virt/kvm/kvm_mm.h         |  6 +++--
 virt/kvm/pfncache.c       | 46 +++++++++++++++++++++++++++++++++------
 6 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7d36164a2cee5..62e45a4ab810e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -843,6 +843,9 @@ struct kvm {
 	bool attribute_change_in_progress;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+#ifdef CONFIG_KVM_PRIVATE_MEM
+	atomic_t gmem_active_invalidate_count;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 8903b8f46cf6c..a2df9623b17ce 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -71,6 +71,7 @@ struct gfn_to_pfn_cache {
 	bool active;
 	bool valid;
 	bool private;
+	bool needs_unmap;
 };
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 742eba36d2371..ac502f9b220c3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -231,6 +231,15 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 	struct kvm *kvm = gmem->kvm;
 	unsigned long index;
 
+	atomic_inc(&kvm->gmem_active_invalidate_count);
+
+	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+		pgoff_t pgoff = slot->gmem.pgoff;
+
+		gfn_to_pfn_cache_invalidate_gfns_start(kvm, slot->base_gfn + start - pgoff,
+						       slot->base_gfn + end - pgoff, true);
+	}
+
 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
 		pgoff_t pgoff = slot->gmem.pgoff;
 
@@ -268,6 +277,8 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 		kvm_mmu_invalidate_end(kvm);
 		KVM_MMU_UNLOCK(kvm);
 	}
+
+	atomic_dec(&kvm->gmem_active_invalidate_count);
 }
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
@@ -478,7 +489,13 @@ static void kvm_gmem_invalidate_folio(struct folio *folio, size_t start, size_t
 	if (start == 0 && end == folio_size(folio)) {
 		refcount_t *sharing_count = folio_get_private(folio);
 
-		kvm_gmem_folio_clear_private(folio);
+		/*
+		 * gfn_to_pfn_caches do not decrement the refcount if they
+		 * get invalidated due to the gmem pfn going away (fallocate,
+		 * or error_remove_folio)
+		 */
+		if (refcount_read(sharing_count) == 1)
+			kvm_gmem_folio_clear_private(folio);
 		kfree(sharing_count);
 	}
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 183f7ce57a428..6d0818c723d73 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1161,6 +1161,9 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	xa_init(&kvm->mem_attr_array);
 #endif
+#ifdef CONFIG_KVM_PRIVATE_MEM
+	atomic_set(&kvm->gmem_active_invalidate_count, 0);
+#endif
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
@@ -2549,7 +2552,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	}
 
 	kvm->attribute_change_in_progress = true;
-	gfn_to_pfn_cache_invalidate_gfns_start(kvm, start, end);
+	gfn_to_pfn_cache_invalidate_gfns_start(kvm, start, end, false);
 
 	kvm_handle_gfn_range(kvm, &pre_set_range);
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 5a53d888e4b18..f4d0ced4a8f57 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -30,7 +30,8 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 
 void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm,
 					    gfn_t start,
-					    gfn_t end);
+					    gfn_t end,
+					    bool needs_unmap);
 #else
 static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 						     unsigned long start,
@@ -40,7 +41,8 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 
 static inline void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm,
 							  gfn_t start,
-							  gfn_t end)
+							  gfn_t end,
+							  bool needs_unmap)
 {
 }
 #endif /* HAVE_KVM_PFNCACHE */
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index a4f935e80f545..828ba8ad8f20d 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -61,8 +61,15 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 /*
  * Identical to `gfn_to_pfn_cache_invalidate_start`, except based on gfns
  * instead of uhvas.
+ *
+ * needs_unmap indicates whether this invalidation is because a gmem range went
+ * away (fallocate(FALLOC_FL_PUNCH_HOLE), error_remove_folio), in which case
+ * we must not call kvm_gmem_put_shared_pfn for it, or because of a memory
+ * attribute change, in which case the gmem pfn still exists, but simply
+ * is no longer mapped into the guest.
  */
-void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm, gfn_t start, gfn_t end)
+void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm, gfn_t start, gfn_t end,
+					    bool needs_unmap)
 {
 	struct gfn_to_pfn_cache *gpc;
 
@@ -78,14 +85,16 @@ void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm, gfn_t start, gfn_t
 			continue;
 		}
 
-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		if (!is_error_noslot_pfn(gpc->pfn) &&
 		    gpa_to_gfn(gpc->gpa) >= start && gpa_to_gfn(gpc->gpa) < end) {
 			read_unlock_irq(&gpc->lock);
 
 			write_lock_irq(&gpc->lock);
-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpa_to_gfn(gpc->gpa) >= start && gpa_to_gfn(gpc->gpa) < end)
+			if (!is_error_noslot_pfn(gpc->pfn) &&
+			    gpa_to_gfn(gpc->gpa) >= start && gpa_to_gfn(gpc->gpa) < end) {
 				gpc->valid = false;
+				gpc->needs_unmap = needs_unmap && gpc->private;
+			}
 			write_unlock_irq(&gpc->lock);
 			continue;
 		}
@@ -194,6 +203,9 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	 */
 	if (kvm->attribute_change_in_progress)
 		return true;
+
+	if (atomic_read_acquire(&kvm->gmem_active_invalidate_count))
+		return true;
 	/*
 	 * Ensure mn_active_invalidate_count is read before
 	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
@@ -425,20 +437,28 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	 * Some/all of the uhva, gpa, and memslot generation info may still be
 	 * valid, leave it as is.
 	 */
+	unmap_old = gpc->needs_unmap;
 	if (ret) {
 		gpc->valid = false;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->khva = NULL;
+		gpc->needs_unmap = false;
+	} else {
+		gpc->needs_unmap = true;
 	}
 
 	/* Detect a pfn change before dropping the lock! */
-	unmap_old = (old_pfn != gpc->pfn);
+	unmap_old &= (old_pfn != gpc->pfn);
 
 out_unlock:
+	if (unmap_old)
+		folio_get(pfn_folio(old_pfn));
 	write_unlock_irq(&gpc->lock);
 
-	if (unmap_old)
+	if (unmap_old) {
 		gpc_unmap(old_pfn, old_khva, old_private);
+		folio_put(pfn_folio(old_pfn));
+	}
 
 	return ret;
 }
@@ -530,6 +550,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t old_pfn;
 	void *old_khva;
 	bool old_private;
+	bool old_needs_unmap;
 
 	guard(mutex)(&gpc->refresh_lock);
 
@@ -555,14 +576,25 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		old_private = gpc->private;
 		gpc->private = false;
 
+		old_needs_unmap = gpc->needs_unmap;
+		gpc->needs_unmap = false;
+
 		old_pfn = gpc->pfn;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
+
+		if (old_needs_unmap && old_private)
+			folio_get(pfn_folio(old_pfn));
+
 		write_unlock_irq(&gpc->lock);
 
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
-		gpc_unmap(old_pfn, old_khva, old_private);
+		if (old_needs_unmap) {
+			gpc_unmap(old_pfn, old_khva, old_private);
+			if (old_private)
+				folio_put(pfn_folio(old_pfn));
+		}
 	}
 }
-- 
2.46.0


