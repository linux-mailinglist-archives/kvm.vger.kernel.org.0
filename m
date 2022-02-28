Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D326D4C79AA
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiB1UHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiB1UGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:06:55 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34232C671
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=55v/vzrVYXXmjtPgoBoQbJeRxn7s7qdsIy38HbtRnOI=; b=QNTUewRMCBebDKcBDOLQrRlQ5L
        dEVmFlryqDSbWH+Io+9WUckZutfGLiKFnCbbQdox7wRujb3Cdl44Sy8+w+f2hlDugZ47BpygK0N2m
        3Mh8WKPiXpjjk0bP6MG4RynQZSX8WyYFi/DhtRKYg3lRt7I1DfWuj9TRux6gOsE8mYVZEs9Eqpc3F
        J/W2rX7aKe/KFudRToZwVGkjn9onT+K2Z/AiEe0CCRQCNurKoEZOyhzeIk3U94JqK2rKWjtr/GXd1
        d0F2/SrzcwBJItipkAVYa5wMfWwTw1m/Br6NPwNlotANyXYsUHirCXGqn7rrlYnUpBUr60bDA7fYp
        22MWUrPA==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHK-00DzoB-Bk; Mon, 28 Feb 2022 20:05:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHJ-000d9J-Sh; Mon, 28 Feb 2022 20:05:53 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v2 02/17] KVM: Remove dirty handling from gfn_to_pfn_cache completely
Date:   Mon, 28 Feb 2022 20:05:37 +0000
Message-Id: <20220228200552.150406-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220228200552.150406-1-dwmw2@infradead.org>
References: <20220228200552.150406-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

It isn't OK to cache the dirty status of a page in internal structures
for an indefinite period of time.

Any time a vCPU exits the run loop to userspace might be its last; the
VMM might do its final check of the dirty log, flush the last remaining
dirty pages to the destination and complete a live migration. If we
have internal 'dirty' state which doesn't get flushed until the vCPU
is finally destroyed on the source after migration is complete, then
we have lost data because that will escape the final copy.

This problem already exists with the use of kvm_vcpu_unmap() to mark
pages dirty in e.g. VMX nesting.

Note that the actual Linux MM already considers the page to be dirty
since we have a writeable mapping of it. This is just about the KVM
dirty logging.

Make the PV clock mark the page dirty immediately (which is fine as
it's happening in vCPU context). Document the Xen shinfo/vcpu_info
case more completely as being exempt, because we might dirty those
from interrupt context as we deliver event channels.

For the nesting-style use cases (KVM_GUEST_USES_PFN) we will need to
track which gfn_to_pfn_caches have been used and explicitly mark the
corresponding pages dirty before returning to userspace. But we would
have needed external tracking of that anyway, rather than walking the
full list of GPCs to find those belonging to this vCPU which are dirty.

So let's rely *solely* on that external tracking, and keep it simple
rather than laying a tempting trap for callers to fall into.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst |  4 ++++
 arch/x86/kvm/xen.c             |  5 ++---
 include/linux/kvm_host.h       | 14 +++++-------
 include/linux/kvm_types.h      |  1 -
 virt/kvm/pfncache.c            | 41 +++++++---------------------------
 5 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f5d011351016..f9b32efc8b4a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5293,6 +5293,10 @@ type values:
 
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
   Sets the guest physical address of the vcpu_info for a given vCPU.
+  As with the shared_info page for the VM, the corresponding page may be
+  dirtied at any time if event channel interrupt delivery is enabled, so
+  userspace should always assume that the page is dirty without relying
+  on dirty logging.
 
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 5be1c9227105..bf6cc25eee76 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -40,7 +40,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 
 	do {
 		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, KVM_HOST_USES_PFN,
-						gpa, PAGE_SIZE, false);
+						gpa, PAGE_SIZE);
 		if (ret)
 			goto out;
 
@@ -1025,8 +1025,7 @@ static int evtchn_set_fn(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpc->gpa,
-						  PAGE_SIZE, false);
+		rc = kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d044e328046a..0d3bda6f14c0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1227,7 +1227,6 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  *		   by KVM (and thus needs a kernel virtual mapping).
  * @gpa:	   guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
- * @dirty:         mark the cache dirty immediately.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
@@ -1241,7 +1240,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  */
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len, bool dirty);
+			      gpa_t gpa, unsigned long len);
 
 /**
  * kvm_gfn_to_pfn_cache_check - check validity of a gfn_to_pfn_cache.
@@ -1250,7 +1249,6 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   current guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
- * @dirty:         mark the cache dirty immediately.
  *
  * @return:	   %true if the cache is still valid and the address matches.
  *		   %false if the cache is not valid.
@@ -1272,7 +1270,6 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   updated guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
- * @dirty:         mark the cache dirty immediately.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
@@ -1285,7 +1282,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  * with the lock still held to permit access.
  */
 int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-				 gpa_t gpa, unsigned long len, bool dirty);
+				 gpa_t gpa, unsigned long len);
 
 /**
  * kvm_gfn_to_pfn_cache_unmap - temporarily unmap a gfn_to_pfn_cache.
@@ -1293,10 +1290,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  *
- * This unmaps the referenced page and marks it dirty, if appropriate. The
- * cache is left in the invalid state but at least the mapping from GPA to
- * userspace HVA will remain cached and can be reused on a subsequent
- * refresh.
+ * This unmaps the referenced page. The cache is left in the invalid state
+ * but at least the mapping from GPA to userspace HVA will remain cached
+ * and can be reused on a subsequent refresh.
  */
 void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 784f37cbf33e..ac1ebb37a0ff 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -74,7 +74,6 @@ struct gfn_to_pfn_cache {
 	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
-	bool dirty;
 };
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 9b3a192cb18c..d789f2705e5e 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -49,19 +49,6 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 				}
 				__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
 			}
-
-			/*
-			 * We cannot call mark_page_dirty() from here because
-			 * this physical CPU might not have an active vCPU
-			 * with which to do the KVM dirty tracking.
-			 *
-			 * Neither is there any point in telling the kernel MM
-			 * that the underlying page is dirty. A vCPU in guest
-			 * mode might still be writing to it up to the point
-			 * where we wake them a few lines further down anyway.
-			 *
-			 * So all the dirty marking happens on the unmap.
-			 */
 		}
 		write_unlock_irq(&gpc->lock);
 	}
@@ -104,8 +91,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
 
-static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva,
-			  gpa_t gpa, bool dirty)
+static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva, gpa_t gpa)
 {
 	/* Unmap the old page if it was mapped before, and release it */
 	if (!is_error_noslot_pfn(pfn)) {
@@ -118,9 +104,7 @@ static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva,
 #endif
 		}
 
-		kvm_release_pfn(pfn, dirty);
-		if (dirty)
-			mark_page_dirty(kvm, gpa);
+		kvm_release_pfn(pfn, false);
 	}
 }
 
@@ -152,7 +136,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
 }
 
 int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-				 gpa_t gpa, unsigned long len, bool dirty)
+				 gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
@@ -160,7 +144,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	unsigned long old_uhva;
 	gpa_t old_gpa;
 	void *old_khva;
-	bool old_valid, old_dirty;
+	bool old_valid;
 	int ret = 0;
 
 	/*
@@ -177,14 +161,12 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
 	old_valid = gpc->valid;
-	old_dirty = gpc->dirty;
 
 	/* If the userspace HVA is invalid, refresh that first */
 	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
 	    kvm_is_error_hva(gpc->uhva)) {
 		gfn_t gfn = gpa_to_gfn(gpa);
 
-		gpc->dirty = false;
 		gpc->gpa = gpa;
 		gpc->generation = slots->generation;
 		gpc->memslot = __gfn_to_memslot(slots, gfn);
@@ -255,14 +237,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	}
 
  out:
-	if (ret)
-		gpc->dirty = false;
-	else
-		gpc->dirty = dirty;
-
 	write_unlock_irq(&gpc->lock);
 
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa, old_dirty);
+	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
 
 	return ret;
 }
@@ -272,7 +249,6 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	void *old_khva;
 	kvm_pfn_t old_pfn;
-	bool old_dirty;
 	gpa_t old_gpa;
 
 	write_lock_irq(&gpc->lock);
@@ -280,7 +256,6 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	gpc->valid = false;
 
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
-	old_dirty = gpc->dirty;
 	old_gpa = gpc->gpa;
 	old_pfn = gpc->pfn;
 
@@ -293,14 +268,14 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 
 	write_unlock_irq(&gpc->lock);
 
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa, old_dirty);
+	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 
 
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len, bool dirty)
+			      gpa_t gpa, unsigned long len)
 {
 	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
 
@@ -319,7 +294,7 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		list_add(&gpc->list, &kvm->gpc_list);
 		spin_unlock(&kvm->gpc_lock);
 	}
-	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len, dirty);
+	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_init);
 
-- 
2.33.1

