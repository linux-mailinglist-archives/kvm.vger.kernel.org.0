Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303F24C79B7
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiB1UHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiB1UGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:06:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847CBE020
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mMqhNJ8eqrnUj8pyV8m6QTYWL7erEC2BbHbBfDE2Xbk=; b=PIvO59he1vcAVw6PVvXsrT1Lnu
        v/mvvpdvxRbCLyQ1JhjudikoUvxsq1tu17aqsxHn6iSwkiDrwpKjpIb8jTmdpYKgOlW2gZqEdx40E
        1DiG8Sa3b1cgxXebvLN8V7FI1lwkNUIPy14z999aG/eeh+jiXBHbnOefmzPnXKXrBZEitk1gmYSXe
        H2kmb4oN+YD+S5X1N6UzpYtE0LniZwYzt5/ZdcThGe0jLgAi0/5n5cWFyFDFmh5LWB1bgsSN3RFc/
        gSxB0AG/CznhU17dUE4XoAUhMMBzbgqEJoo3JV88rYWwE1ZqTLxYJGWkojerprpAQNY2H+tT49t/f
        LLyQbY8A==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHK-008rno-KF; Mon, 28 Feb 2022 20:05:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHJ-000d9G-Rq; Mon, 28 Feb 2022 20:05:53 +0000
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
Subject: [PATCH v2 01/17] KVM: Use enum to track if cached PFN will be used in guest and/or host
Date:   Mon, 28 Feb 2022 20:05:36 +0000
Message-Id: <20220228200552.150406-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220228200552.150406-1-dwmw2@infradead.org>
References: <20220228200552.150406-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Replace the guest_uses_pa and kernel_map booleans in the PFN cache code
with a unified enum/bitmask. Using explicit names makes it easier to
review and audit call sites.

Opportunistically add a WARN to prevent passing garbage; instantating a
cache without declaring its usage is either buggy or pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c        |  2 +-
 include/linux/kvm_host.h  | 11 +++++------
 include/linux/kvm_types.h | 10 ++++++++--
 virt/kvm/pfncache.c       | 14 +++++++-------
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4aa0f2b31665..5be1c9227105 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -39,7 +39,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	}
 
 	do {
-		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, false, true,
+		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, KVM_HOST_USES_PFN,
 						gpa, PAGE_SIZE, false);
 		if (ret)
 			goto out;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..d044e328046a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1222,9 +1222,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @vcpu:	   vCPU to be used for marking pages dirty and to be woken on
  *		   invalidation.
- * @guest_uses_pa: indicates that the resulting host physical PFN is used while
- *		   @vcpu is IN_GUEST_MODE so invalidations should wake it.
- * @kernel_map:    requests a kernel virtual mapping (kmap / memremap).
+ * @usage:	   indicates if the resulting host physical PFN is used while
+ *		   the @vcpu is IN_GUEST_MODE and/or if the PFN used directly
+ *		   by KVM (and thus needs a kernel virtual mapping).
  * @gpa:	   guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
  * @dirty:         mark the cache dirty immediately.
@@ -1240,9 +1240,8 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * to ensure that the cache is valid before accessing the target page.
  */
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, bool guest_uses_pa,
-			      bool kernel_map, gpa_t gpa, unsigned long len,
-			      bool dirty);
+			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+			      gpa_t gpa, unsigned long len, bool dirty);
 
 /**
  * kvm_gfn_to_pfn_cache_check - check validity of a gfn_to_pfn_cache.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index dceac12c1ce5..784f37cbf33e 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -18,6 +18,7 @@ struct kvm_memslots;
 
 enum kvm_mr_change;
 
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/spinlock_types.h>
 
@@ -46,6 +47,12 @@ typedef u64            hfn_t;
 
 typedef hfn_t kvm_pfn_t;
 
+enum pfn_cache_usage {
+	KVM_GUEST_USES_PFN = BIT(0),
+	KVM_HOST_USES_PFN  = BIT(1),
+	KVM_GUEST_AND_HOST_USE_PFN = KVM_GUEST_USES_PFN | KVM_HOST_USES_PFN,
+};
+
 struct gfn_to_hva_cache {
 	u64 generation;
 	gpa_t gpa;
@@ -64,11 +71,10 @@ struct gfn_to_pfn_cache {
 	rwlock_t lock;
 	void *khva;
 	kvm_pfn_t pfn;
+	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
 	bool dirty;
-	bool kernel_map;
-	bool guest_uses_pa;
 };
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index ce878f4be4da..9b3a192cb18c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -42,7 +42,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 			 * If a guest vCPU could be using the physical address,
 			 * it needs to be woken.
 			 */
-			if (gpc->guest_uses_pa) {
+			if (gpc->usage & KVM_GUEST_USES_PFN) {
 				if (!wake_vcpus) {
 					wake_vcpus = true;
 					bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
@@ -219,7 +219,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			goto map_done;
 		}
 
-		if (gpc->kernel_map) {
+		if (gpc->usage & KVM_HOST_USES_PFN) {
 			if (new_pfn == old_pfn) {
 				new_khva = old_khva;
 				old_pfn = KVM_PFN_ERR_FAULT;
@@ -299,10 +299,11 @@ EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 
 
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, bool guest_uses_pa,
-			      bool kernel_map, gpa_t gpa, unsigned long len,
-			      bool dirty)
+			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+			      gpa_t gpa, unsigned long len, bool dirty)
 {
+	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
+
 	if (!gpc->active) {
 		rwlock_init(&gpc->lock);
 
@@ -310,8 +311,7 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->uhva = KVM_HVA_ERR_BAD;
 		gpc->vcpu = vcpu;
-		gpc->kernel_map = kernel_map;
-		gpc->guest_uses_pa = guest_uses_pa;
+		gpc->usage = usage;
 		gpc->valid = false;
 		gpc->active = true;
 
-- 
2.33.1

