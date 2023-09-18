Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFA57A4E46
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjIRQKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjIRQJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:09:48 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C441718;
        Mon, 18 Sep 2023 09:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=dozmN/ao3yu6ELwEpDJlaWpAf1h+h4oBUyHu8TvVQHM=; b=UlFwc4IVH+jDvXOJI2aep3HJrY
        S6OZUu+Qh1jUeJqtqTdT4Vqcmv1Xhms4GNbizNdY317T1EXTu98CoA/kQP/ixCRsxsaku0OnYKk6S
        HcfofUuqyupt4PX6WqwvmvuL9kXnkK80fgh6np1crg35QJdocBFpHGwOKziZfBksj7wM=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRB-0003QQ-Se; Mon, 18 Sep 2023 14:41:21 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRB-0006IJ-LH; Mon, 18 Sep 2023 14:41:21 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v3 05/13] KVM: pfncache: allow a cache to be activated with a fixed (userspace) HVA
Date:   Mon, 18 Sep 2023 14:41:03 +0000
Message-Id: <20230918144111.641369-6-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230918144111.641369-1-paul@xen.org>
References: <20230918144111.641369-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

Some cached pages may actually be overlays on guest memory that have a
fixed HVA within the VMM. It's pointless to invalidate such cached
mappings if the overlay is moved so allow a cache to be activated directly
with the HVA to cater for such cases. A subsequent patch will make use
of this facility.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 include/linux/kvm_host.h  | 29 ++++++++++++++++
 include/linux/kvm_types.h |  3 +-
 virt/kvm/pfncache.c       | 73 ++++++++++++++++++++++++++++-----------
 3 files changed, 84 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d8027fe9928..6823bae5c66c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1321,6 +1321,22 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
  */
 int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len);
 
+/**
+ * kvm_gpc_activate_hva - prepare a cached kernel mapping and HPA for a given HVA.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ * @hva:	   userspace virtual address to map.
+ * @len:	   sanity check; the range being access must fit a single page.
+ *
+ * @return:	   0 for success.
+ *		   -EINVAL for a mapping which would cross a page boundary.
+ *		   -EFAULT for an untranslatable guest physical address.
+ *
+ * The semantics of this function are the same as those of kvm_gpc_activate(). It
+ * merely bypasses a layer of address translation.
+ */
+int kvm_gpc_activate_hva(struct gfn_to_pfn_cache *gpc, unsigned long hva, unsigned long len);
+
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
@@ -1378,9 +1394,22 @@ void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc);
  * kvm_gpc_gpa - retrieve the guest physical address of a cached mapping
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
+ *
+ * @return:	   If the cache was activated with a fixed HVA then INVALID_GPA
+ *		   will be returned.
  */
 gpa_t kvm_gpc_gpa(struct gfn_to_pfn_cache *gpc);
 
+/**
+ * kvm_gpc_hva - retrieve the fixed host physical address of a cached mapping
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ *
+ * @return:	   If the cache was activated with a guest physical address then
+ *		   0 will be returned.
+ */
+unsigned long kvm_gpc_hva(struct gfn_to_pfn_cache *gpc);
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 6f4737d5046a..d49946ee7ae3 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -64,7 +64,7 @@ struct gfn_to_hva_cache {
 
 struct gfn_to_pfn_cache {
 	u64 generation;
-	gpa_t gpa;
+	u64 addr;
 	unsigned long uhva;
 	struct kvm_memory_slot *memslot;
 	struct kvm *kvm;
@@ -77,6 +77,7 @@ struct gfn_to_pfn_cache {
 	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
+	bool addr_is_gpa;
 };
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 37bcb4399780..b3e3f7e38410 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -83,7 +83,7 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	if (!gpc->active)
 		return false;
 
-	if (gpc->generation != slots->generation)
+	if (gpc->addr_is_gpa && gpc->generation != slots->generation)
 		return false;
 
 	if (kvm_is_error_hva(gpc->uhva))
@@ -229,7 +229,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
-	gpc->khva = new_khva + (gpc->gpa & ~PAGE_MASK);
+	gpc->khva = new_khva + (gpc->addr & ~PAGE_MASK);
 
 	/*
 	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
@@ -246,11 +246,11 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-			     unsigned long len)
+static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, u64 addr,
+			     unsigned long len, bool addr_is_gpa)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
-	unsigned long page_offset = gpa & ~PAGE_MASK;
+	unsigned long page_offset = addr & ~PAGE_MASK;
 	bool unmap_old = false;
 	unsigned long old_uhva;
 	kvm_pfn_t old_pfn;
@@ -282,22 +282,34 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
 
-	/* If the userspace HVA is invalid, refresh that first */
-	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
+	/*
+	 * If the address has changed, switched from guest to host (or vice
+	 * versa), or it's a guest address and the memory slots have been
+	 * updated, we need to refresh the userspace HVA.
+	 */
+	if (gpc->addr != addr ||
+	    gpc->addr_is_gpa != addr_is_gpa ||
+	    (addr_is_gpa && gpc->generation != slots->generation) ||
 	    kvm_is_error_hva(gpc->uhva)) {
-		gfn_t gfn = gpa_to_gfn(gpa);
+		gpc->addr = addr;
+		gpc->addr_is_gpa = addr_is_gpa;
 
-		gpc->gpa = gpa;
-		gpc->generation = slots->generation;
-		gpc->memslot = __gfn_to_memslot(slots, gfn);
-		gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
+		if (addr_is_gpa) {
+			gfn_t gfn = gpa_to_gfn(addr);
 
-		if (kvm_is_error_hva(gpc->uhva)) {
-			ret = -EFAULT;
-			goto out;
+			gpc->generation = slots->generation;
+			gpc->memslot = __gfn_to_memslot(slots, gfn);
+			gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
+		} else {
+			gpc->uhva = addr & PAGE_MASK;
 		}
 	}
 
+	if (kvm_is_error_hva(gpc->uhva)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
 	/*
 	 * If the userspace HVA changed or the PFN was already invalid,
 	 * drop the lock and do the HVA to PFN lookup again.
@@ -343,7 +355,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 
 int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 {
-	return __kvm_gpc_refresh(gpc, gpc->gpa, len);
+	return __kvm_gpc_refresh(gpc, gpc->addr, len, gpc->addr_is_gpa);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
@@ -364,7 +376,8 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
-int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
+static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, u64 addr, unsigned long len,
+			      bool addr_is_gpa)
 {
 	struct kvm *kvm = gpc->kvm;
 
@@ -385,19 +398,39 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return __kvm_gpc_refresh(gpc, gpa, len);
+	return __kvm_gpc_refresh(gpc, addr, len, addr_is_gpa);
+}
+
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
+{
+	return __kvm_gpc_activate(gpc, gpa, len, true);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
 gpa_t kvm_gpc_gpa(struct gfn_to_pfn_cache *gpc)
 {
-	return gpc->gpa;
+	return gpc->addr_is_gpa ? gpc->addr : INVALID_GPA;
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_gpa);
 
+int kvm_gpc_activate_hva(struct gfn_to_pfn_cache *gpc, unsigned long hva, unsigned long len)
+{
+	return __kvm_gpc_activate(gpc, hva, len, false);
+}
+EXPORT_SYMBOL_GPL(kvm_gpc_activate_hva);
+
+unsigned long kvm_gpc_hva(struct gfn_to_pfn_cache *gpc)
+{
+	return !gpc->addr_is_gpa ? gpc->addr : 0;
+}
+EXPORT_SYMBOL_GPL(kvm_gpc_hva);
+
 void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
 {
-	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+	if (!gpc->addr_is_gpa)
+		return;
+
+	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->addr >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_mark_dirty);
 
-- 
2.39.2

