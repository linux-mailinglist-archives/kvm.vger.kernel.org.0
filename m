Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E7B442075
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 20:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhKATHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 15:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhKATHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 15:07:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E22EC061766
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 12:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XXpK/O7mxe7bPJOZ2W3aH8suDsUkiTEs8cwvqRXfbz8=; b=l12F87/F4QE3AZI4dvYJsh3fVF
        VI5eceg7RWuUS5pQQFmmZ0mZhKQn3dxDR5S6pIo+utsi9NFxvf1PyG1qP4KejBL2J60/sPAXsi1MJ
        8tZu0hvmTAHYdzWUhVQuDDpZl7+hisKNzLDYg+wyrb/RrCnsEvTpO3HNiDBqNcXr0Dn4lvgWW2iXt
        j1MgGJ8FmUjUvwWneBzqLG8IQ0BRjBF+ehNe8243bXrCplLKMNeeTLNLznkAUdcrVsUOnAvRmmH8y
        7UYKdkgRLchtbSVIEaOv4WBgR8gEyeJDz3CcS1Q7f0zjULIsZbCmEv2TPpIoFWEcpycP2K5uoxv1i
        eFTeUQRg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-003xXd-Us; Mon, 01 Nov 2021 19:03:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-0004hd-GK; Mon, 01 Nov 2021 19:03:16 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        KarimAllah Raslan <karahmed@amazon.com>
Subject: [PATCH v2 5/6] KVM: x86/xen: Maintain valid mapping of Xen shared_info page
Date:   Mon,  1 Nov 2021 19:03:13 +0000
Message-Id: <20211101190314.17954-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101190314.17954-1-dwmw2@infradead.org>
References: <20211101190314.17954-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In order to allow for event channel delivery, we would like to have a
kernel mapping of the shared_info page which can be accessed in atomic
context in the common case.

The gfn_to_pfn_cache only automatically handles invalidation when the
KVM memslots change; it doesn't handle a change in the userspace HVA
to host PFN mappings. So hook into the MMU notifiers to invalidate the
shared_info pointer on demand.

The shared_info can be accessed while holding the shinfo_lock, with a
slow path which takes the kvm->lock mutex to refresh the mapping.
I'd like to use RCU for the invalidation but I don't think we can
always sleep in the invalidate_range notifier. Having a true kernel
mapping of the page means that our access to it can be atomic anyway,
so holding a spinlock is OK.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  4 ++
 arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++++
 arch/x86/kvm/xen.c              | 65 +++++++++++++++++++++++++++------
 include/linux/kvm_host.h        | 26 -------------
 include/linux/kvm_types.h       | 27 ++++++++++++++
 5 files changed, 107 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 750f74da9793..ec58e41a69c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1017,6 +1017,10 @@ struct kvm_xen {
 	bool long_mode;
 	u8 upcall_vector;
 	gfn_t shinfo_gfn;
+	rwlock_t shinfo_lock;
+	void *shared_info;
+	struct kvm_host_map shinfo_map;
+	struct gfn_to_pfn_cache shinfo_cache;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0cc58901bf7a..429a4860d67a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -25,6 +25,7 @@
 #include "kvm_emulate.h"
 #include "cpuid.h"
 #include "spte.h"
+#include "xen.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -1588,6 +1589,28 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
 
+	if (static_branch_unlikely(&kvm_xen_enabled.key)) {
+		write_lock(&kvm->arch.xen.shinfo_lock);
+
+		if (kvm->arch.xen.shared_info &&
+		    kvm->arch.xen.shinfo_gfn >= range->start &&
+		    kvm->arch.xen.shinfo_cache.gfn < range->end) {
+			/*
+			 * If kvm_xen_shared_info_init() had *finished* mapping the
+			 * page and assigned the pointer for real, then mark the page
+			 * dirty now instead of via the eventual cache teardown.
+			 */
+			if (kvm->arch.xen.shared_info != KVM_UNMAPPED_PAGE) {
+				kvm_set_pfn_dirty(kvm->arch.xen.shinfo_cache.pfn);
+				kvm->arch.xen.shinfo_cache.dirty = false;
+			}
+
+			kvm->arch.xen.shared_info = NULL;
+		}
+
+		write_unlock(&kvm->arch.xen.shinfo_lock);
+	}
+
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 565da9c3853b..9d143bc7d769 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -21,18 +21,59 @@
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
-static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+static void kvm_xen_shared_info_unmap(struct kvm *kvm)
+{
+	bool was_valid = false;
+
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	if (kvm->arch.xen.shared_info)
+		was_valid = true;
+	kvm->arch.xen.shared_info = NULL;
+	kvm->arch.xen.shinfo_gfn = GPA_INVALID;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	if (kvm_vcpu_mapped(&kvm->arch.xen.shinfo_map)) {
+		kvm_unmap_gfn(kvm, &kvm->arch.xen.shinfo_map,
+			      &kvm->arch.xen.shinfo_cache, was_valid, false);
+
+		/* If the MMU notifier invalidated it, the gfn_to_pfn_cache
+		 * may be invalid. Force it to notice */
+		if (!was_valid)
+			kvm->arch.xen.shinfo_cache.generation = -1;
+	}
+}
+
+static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn, bool update_clock)
 {
 	gpa_t gpa = gfn_to_gpa(gfn);
 	int wc_ofs, sec_hi_ofs;
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if (kvm_is_error_hva(gfn_to_hva(kvm, gfn))) {
-		ret = -EFAULT;
+	kvm_xen_shared_info_unmap(kvm);
+
+	if (gfn == GPA_INVALID)
 		goto out;
-	}
+
+	/* Let the MMU notifier know that we are in the process of mapping it */
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	kvm->arch.xen.shared_info = KVM_UNMAPPED_PAGE;
 	kvm->arch.xen.shinfo_gfn = gfn;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	ret = kvm_map_gfn(kvm, gfn, &kvm->arch.xen.shinfo_map,
+			  &kvm->arch.xen.shinfo_cache, false);
+	if (ret)
+		goto out;
+
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	/* Unless the MMU notifier already invalidated it */
+	if (kvm->arch.xen.shared_info == KVM_UNMAPPED_PAGE)
+		kvm->arch.xen.shared_info = kvm->arch.xen.shinfo_map.hva;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	if (!update_clock)
+		goto out;
 
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
@@ -260,15 +301,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		if (data->u.shared_info.gfn == GPA_INVALID) {
-			kvm->arch.xen.shinfo_gfn = GPA_INVALID;
-			r = 0;
-			break;
-		}
-		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
+		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn, true);
 		break;
 
-
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		if (data->u.vector && data->u.vector < 0x10)
 			r = -EINVAL;
@@ -661,11 +696,17 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 
 void kvm_xen_init_vm(struct kvm *kvm)
 {
-	kvm->arch.xen.shinfo_gfn = GPA_INVALID;
+	rwlock_init(&kvm->arch.xen.shinfo_lock);
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
 {
+	struct gfn_to_pfn_cache *cache = &kvm->arch.xen.shinfo_cache;
+
+	kvm_xen_shared_info_unmap(kvm);
+
+	kvm_release_pfn(cache->pfn, cache->dirty, cache);
+
 	if (kvm->arch.xen_hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 749cdc77fc4e..f0012d128aa5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -251,32 +251,6 @@ enum {
 	READING_SHADOW_PAGE_TABLES,
 };
 
-#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
-
-struct kvm_host_map {
-	/*
-	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
-	 * a 'struct page' for it. When using mem= kernel parameter some memory
-	 * can be used as guest memory but they are not managed by host
-	 * kernel).
-	 * If 'pfn' is not managed by the host kernel, this field is
-	 * initialized to KVM_UNMAPPED_PAGE.
-	 */
-	struct page *page;
-	void *hva;
-	kvm_pfn_t pfn;
-	kvm_pfn_t gfn;
-};
-
-/*
- * Used to check if the mapping is valid or not. Never use 'kvm_host_map'
- * directly to check for that.
- */
-static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
-{
-	return !!map->hva;
-}
-
 static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
 {
 	return single_task_running() && !need_resched() && ktime_before(cur, stop);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2237abb93ccd..2092f4ca156b 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -60,6 +60,33 @@ struct gfn_to_pfn_cache {
 	bool dirty;
 };
 
+#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
+
+struct kvm_host_map {
+	/*
+	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
+	 * a 'struct page' for it. When using mem= kernel parameter some memory
+	 * can be used as guest memory but they are not managed by host
+	 * kernel).
+	 * If 'pfn' is not managed by the host kernel, this field is
+	 * initialized to KVM_UNMAPPED_PAGE.
+	 */
+	struct page *page;
+	void *hva;
+	kvm_pfn_t pfn;
+	kvm_pfn_t gfn;
+};
+
+/*
+ * Used to check if the mapping is valid or not. Never use 'kvm_host_map'
+ * directly to check for that.
+ */
+static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
+{
+	return !!map->hva;
+}
+
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 /*
  * Memory caches are used to preallocate memory ahead of various MMU flows,
-- 
2.31.1

