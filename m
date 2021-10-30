Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974F8440B88
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhJ3TtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Oct 2021 15:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhJ3TtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Oct 2021 15:49:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD1EC061570
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 12:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=UEmjHzlaSw/Bk9cSeKR1RCrm9Xy11sNaMiRUcfJsH9E=; b=iG9F0jt0rf+g2uAKo/mBlAVpVr
        dZbJlpHJRorNR40TEbQZO31DPq3C+tf2V82D3abPTbpwWrxydz/t1lNVZ8gJUDeGsRBdR9uOl8sVB
        rxYNZE6dwKviwB8I6nF1CJguFyyz8mRVqSNv8dqpKaSBPMrVtfwS9m6AuZj0wndxsMtvP5QKOHlKj
        GToqPVO3mEbsodWzpnGt2zdWO7rOas+SWpIu4pGva7kFSYMwoN/5UyK3ZUx9/BPpeWh0ClQefVUoO
        vD+oK8CpIHpbESQSy/U1yJZpDjnfRqlzy/Cj+xhMQbNDQHzeSu71tEic7jvE2W2UyOLUvPJTJs9nG
        a4ugm+/A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHF-002cmO-BS; Sat, 30 Oct 2021 19:45:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHE-00066I-SJ; Sat, 30 Oct 2021 20:44:28 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Cc:     "jmattson @ google . com" <jmattson@google.com>,
        "pbonzini @ redhat . com" <pbonzini@redhat.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.com
Subject: [PATCH 4/5] KVM: x86/xen: Reinstate mapping of Xen shared_info page
Date:   Sat, 30 Oct 2021 20:44:27 +0100
Message-Id: <20211030194428.23395-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030194428.23395-1-dwmw2@infradead.org>
References: <20211030194428.23395-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Allegedly, keeping a page mapped is frowned upon because it *pins* the
page and causes issues for memory unplug, error handling and migration.

But as far as I can tell, it isn't the *mapping* per se which is pinning
the pages; the gfn_to_pfn_cache *alone* is doing that, all the while the
PFN is cached. So doing the map/unmap dance every time we want to touch
the page (as the steal time recording does) appears to be somewhat
pointless.

Furthermore, the gfn_to_pfn_cache doesn't appear to be invalidated when
the PFN *changes* due to userspace unmapping or remapping the HVA in
question. Pinning the page, although we shouldn't be doing it anyway,
may help avoid it just being paged out — but it doesn't stop various
other failure modes where it goes away or changes. We really need to
hook up the MMU notifiers to invalidate the gfn_to_pfn_cache when
necessary. And then we resolve the pinning problem anyway.

So, having reduced all that to a previously *unsolved* problem, I'll
just go ahead and use it anyway, and promise to fix it later.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  6 +++-
 arch/x86/kvm/xen.c              | 55 +++++++++++++++++++++++++--------
 include/linux/kvm_host.h        | 37 +++++++++++-----------
 3 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70771376e246..e264301f71d7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1014,8 +1014,12 @@ struct msr_bitmap_range {
 /* Xen emulation context */
 struct kvm_xen {
 	bool long_mode;
+	bool shinfo_set;
 	u8 upcall_vector;
-	gfn_t shinfo_gfn;
+	rwlock_t shinfo_lock;
+	void *shared_info;
+	struct kvm_host_map shinfo_map;
+	struct gfn_to_pfn_cache shinfo_cache;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c4bca001a7c9..75bb033c9613 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -21,18 +21,44 @@
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
-static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+static void kvm_xen_shared_info_unmap(struct kvm *kvm)
+{
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	kvm->arch.xen.shared_info = NULL;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	if (kvm_vcpu_mapped(&kvm->arch.xen.shinfo_map))
+		kvm_unmap_gfn(kvm, &kvm->arch.xen.shinfo_map,
+			      &kvm->arch.xen.shinfo_cache, true, false);
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
+	if (gfn == GPA_INVALID) {
+		kvm->arch.xen.shinfo_set = false;
 		goto out;
 	}
-	kvm->arch.xen.shinfo_gfn = gfn;
+
+	ret = kvm_map_gfn(kvm, gfn, &kvm->arch.xen.shinfo_map,
+			  &kvm->arch.xen.shinfo_cache, false);
+	if (ret)
+		goto out;
+
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	kvm->arch.xen.shared_info = kvm->arch.xen.shinfo_map.hva;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	kvm->arch.xen.shinfo_set = true;
+
+	if (!update_clock)
+		goto out;
 
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
@@ -277,15 +303,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
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
@@ -316,7 +336,10 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_gfn);
+		if (kvm->arch.xen.shinfo_set)
+			data->u.shared_info.gfn = kvm->arch.xen.shinfo_cache.gfn;
+		else
+			data->u.shared_info.gfn = GPA_INVALID;
 		r = 0;
 		break;
 
@@ -696,11 +719,17 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 
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
index 749cdc77fc4e..9dab85a55e19 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -36,9 +36,27 @@
 
 #include <linux/kvm_types.h>
 
-#include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
 
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
+#include <asm/kvm_host.h>
+
 #ifndef KVM_MAX_VCPU_ID
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
 #endif
@@ -251,23 +269,6 @@ enum {
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
 /*
  * Used to check if the mapping is valid or not. Never use 'kvm_host_map'
  * directly to check for that.
-- 
2.31.1

