Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3C450A1F
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhKOQyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhKOQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A577C061204
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=mKOAyBHzPsAHyE7Ui7C8Ad7ONf2dk4C/Am8DmRjBLFs=; b=gdQLo9U29tn1dFgiYa+Z+T8qj5
        vFOEJFYhPtNchNenBSk9CzHkRE4XBRWvEHTaXP1m7DgnnoiLYPEgBm9clrz1O/PdKI2qODhKzpsE7
        udpmGY//M4eXYWIh2YzjUN+jQiBVd0CnfAAOal4Tz49V1yPd8j2fLoz1n6HYYDN+ZHN2poiHG6NsS
        JLn2c9sHiqU6JZqtIVlJ26NO3fN2Q0uosLFk0ZOih+9YmxroarukYoNHi9HdvGtMUjHGNbAgwA6PD
        Y0kqNkzJcKQQ7B0dt1jmqE32IXkK/+0VstjDm27HQNE8AzJD6Z3j5V6P69iGkYpFJJPXMATaVQlYg
        avpE2ptA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBf-00GAgF-9y; Mon, 15 Nov 2021 16:50:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-0001wu-VG; Mon, 15 Nov 2021 16:50:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com
Subject: [PATCH 08/11] KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache
Date:   Mon, 15 Nov 2021 16:50:27 +0000
Message-Id: <20211115165030.7422-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115165030.7422-1-dwmw2@infradead.org>
References: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <20211115165030.7422-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time /
preempted status") I removed the only user of these functions because
it was basically impossible to use them safely.

There are two stages to the GFN → PFN mapping; first through the KVM
memslots to a userspace HVA and then through the page tables to
translate that HVA to an underlying PFN. Invalidations of the former
were being handled correctly, but no attempt was made to use the MMU
notifiers to invalidate the cache when the HVA→GFN mapping changed.

As a prelude to reinventing the gfn_to_pfn_cache with more usable
semantics, rip it out entirely and untangle the implementation of
the unsafe kvm_vcpu_map()/kvm_vcpu_unmap() functions from it.

All current users of kvm_vcpu_map() also look broken right now, and
will be dealt with separately. They broadly fall into two classes:

 • Those which map, access the data and immediately unmap. This is
   mostly gratuitous and could just as well use the existing user
   HVA, and could probably benefit from a gfn_to_hva_cache as they
   do so.

 • Those which keep the mapping around for a longer time, perhaps
   even using the PFN directly from the guest. These will need to
   be converted to the new gfn_to_pfn_cache and then kvm_vcpu_map()
   can be removed too.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_host.h  |   6 +--
 include/linux/kvm_types.h |   7 ---
 virt/kvm/kvm_main.c       | 100 +++++---------------------------------
 3 files changed, 12 insertions(+), 101 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9e0667e3723e..c310648cc8f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -874,7 +874,7 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
+void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
@@ -950,12 +950,8 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
-int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
-		struct gfn_to_pfn_cache *cache, bool atomic);
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
-		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2237abb93ccd..234eab059839 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -53,13 +53,6 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
 
-struct gfn_to_pfn_cache {
-	u64 generation;
-	gfn_t gfn;
-	kvm_pfn_t pfn;
-	bool dirty;
-};
-
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 /*
  * Memory caches are used to preallocate memory ahead of various MMU flows,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d31724500501..9646bb9112c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2548,72 +2548,36 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache)
+void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
 {
 	if (pfn == 0)
 		return;
 
-	if (cache)
-		cache->pfn = cache->gfn = 0;
-
 	if (dirty)
 		kvm_release_pfn_dirty(pfn);
 	else
 		kvm_release_pfn_clean(pfn);
 }
 
-static void kvm_cache_gfn_to_pfn(struct kvm_memory_slot *slot, gfn_t gfn,
-				 struct gfn_to_pfn_cache *cache, u64 gen)
-{
-	kvm_release_pfn(cache->pfn, cache->dirty, cache);
-
-	cache->pfn = gfn_to_pfn_memslot(slot, gfn);
-	cache->gfn = gfn;
-	cache->dirty = false;
-	cache->generation = gen;
-}
-
-static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
-			 struct kvm_host_map *map,
-			 struct gfn_to_pfn_cache *cache,
-			 bool atomic)
+int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
 	kvm_pfn_t pfn;
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
-	struct kvm_memory_slot *slot = __gfn_to_memslot(slots, gfn);
-	u64 gen = slots->generation;
 
 	if (!map)
 		return -EINVAL;
 
-	if (cache) {
-		if (!cache->pfn || cache->gfn != gfn ||
-			cache->generation != gen) {
-			if (atomic)
-				return -EAGAIN;
-			kvm_cache_gfn_to_pfn(slot, gfn, cache, gen);
-		}
-		pfn = cache->pfn;
-	} else {
-		if (atomic)
-			return -EAGAIN;
-		pfn = gfn_to_pfn_memslot(slot, gfn);
-	}
+	pfn = gfn_to_pfn(vcpu->kvm, gfn);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
 	if (pfn_valid(pfn)) {
 		page = pfn_to_page(pfn);
-		if (atomic)
-			hva = kmap_atomic(page);
-		else
-			hva = kmap(page);
+		hva = kmap(page);
 #ifdef CONFIG_HAS_IOMEM
-	} else if (!atomic) {
-		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
 	} else {
-		return -EINVAL;
+		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
 #endif
 	}
 
@@ -2627,27 +2591,9 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 
 	return 0;
 }
-
-int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
-		struct gfn_to_pfn_cache *cache, bool atomic)
-{
-	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map,
-			cache, atomic);
-}
-EXPORT_SYMBOL_GPL(kvm_map_gfn);
-
-int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
-{
-	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map,
-		NULL, false);
-}
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
 
-static void __kvm_unmap_gfn(struct kvm *kvm,
-			struct kvm_memory_slot *memslot,
-			struct kvm_host_map *map,
-			struct gfn_to_pfn_cache *cache,
-			bool dirty, bool atomic)
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 {
 	if (!map)
 		return;
@@ -2655,45 +2601,21 @@ static void __kvm_unmap_gfn(struct kvm *kvm,
 	if (!map->hva)
 		return;
 
-	if (map->page != KVM_UNMAPPED_PAGE) {
-		if (atomic)
-			kunmap_atomic(map->hva);
-		else
-			kunmap(map->page);
-	}
+	if (map->page != KVM_UNMAPPED_PAGE)
+		kunmap(map->page);
 #ifdef CONFIG_HAS_IOMEM
-	else if (!atomic)
-		memunmap(map->hva);
 	else
-		WARN_ONCE(1, "Unexpected unmapping in atomic context");
+		memunmap(map->hva);
 #endif
 
 	if (dirty)
-		mark_page_dirty_in_slot(kvm, memslot, map->gfn);
+		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
 
-	if (cache)
-		cache->dirty |= dirty;
-	else
-		kvm_release_pfn(map->pfn, dirty, NULL);
+	kvm_release_pfn(map->pfn, dirty);
 
 	map->hva = NULL;
 	map->page = NULL;
 }
-
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, 
-		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic)
-{
-	__kvm_unmap_gfn(vcpu->kvm, gfn_to_memslot(vcpu->kvm, map->gfn), map,
-			cache, dirty, atomic);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(kvm_unmap_gfn);
-
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
-{
-	__kvm_unmap_gfn(vcpu->kvm, kvm_vcpu_gfn_to_memslot(vcpu, map->gfn),
-			map, NULL, dirty, false);
-}
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
-- 
2.31.1

