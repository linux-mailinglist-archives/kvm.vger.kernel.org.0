Return-Path: <kvm+bounces-2214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B91EF7F358E
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 19:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4842BB21C96
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99DD22079;
	Tue, 21 Nov 2023 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="L73KD4ZO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1AC1A3;
	Tue, 21 Nov 2023 10:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=R5zu2fbmulZSBUoYOg07PimInxmf93FIm2KI5QqK+5Y=; b=L73KD4ZOAS321GpuHdbrdTbAPv
	h6dIj+mpWJeULW3G/hxZOgY+VvQEgUk/FkcjdawCgytojXZKYqc4Ql8fBFxx/gnqX80w5DK74uEzN
	2PmajqnBUyDiWXF3nmG/R9hO5aywrw4hskmYBVm2GLNlkCKzXRPtQKU0lfsn5gBhAcag=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5h-00085e-PA; Tue, 21 Nov 2023 18:03:17 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5h-0004Z3-GW; Tue, 21 Nov 2023 18:03:17 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 08/15] KVM: pfncache: allow a cache to be activated with a fixed (userspace) HVA
Date: Tue, 21 Nov 2023 18:02:16 +0000
Message-Id: <20231121180223.12484-9-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231121180223.12484-1-paul@xen.org>
References: <20231121180223.12484-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

Some pfncache pages may actually be overlays on guest memory that have a
fixed HVA within the VMM. It's pointless to invalidate such cached
mappings if the overlay is moved so allow a cache to be activated directly
with the HVA to cater for such cases. A subsequent patch will make use
of this facility.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v8:
 - Re-worked to avoid messing with struct gfn_to_pfn_cache.
---
 include/linux/kvm_host.h | 19 +++++++++++++++++-
 virt/kvm/pfncache.c      | 43 ++++++++++++++++++++++++++++++----------
 2 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b1dc2e5a64f3..484c587e8290 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1312,6 +1312,22 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm);
  */
 int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len);
 
+/**
+ * kvm_gpc_activate_hva - prepare a cached kernel mapping and HPA for a given HVA.
+ *
+ * @gpc:          struct gfn_to_pfn_cache object.
+ * @hva:          userspace virtual address to map.
+ * @len:          sanity check; the range being access must fit a single page.
+ *
+ * @return:       0 for success.
+ *                -EINVAL for a mapping which would cross a page boundary.
+ *                -EFAULT for an untranslatable guest physical address.
+ *
+ * The semantics of this function are the same as those of kvm_gpc_activate(). It
+ * merely bypasses a layer of address translation.
+ */
+int kvm_gpc_activate_hva(struct gfn_to_pfn_cache *gpc, unsigned long hva, unsigned long len);
+
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
@@ -1365,7 +1381,8 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
  */
 static inline void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
 {
-	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+	if (gpc->gpa != KVM_XEN_INVALID_GPA)
+		mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index c545f6246501..ed700afeec49 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -209,11 +209,11 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, u64 addr, bool addr_is_gpa,
 			     unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
-	unsigned long page_offset = offset_in_page(gpa);
+	unsigned long page_offset = offset_in_page(addr);
 	bool unmap_old = false;
 	kvm_pfn_t old_pfn;
 	bool hva_change = false;
@@ -244,12 +244,21 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	old_pfn = gpc->pfn;
 	old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 
-	/* If the userspace HVA is invalid, refresh that first */
-	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
-	    kvm_is_error_hva(gpc->uhva)) {
-		gfn_t gfn = gpa_to_gfn(gpa);
+	if (!addr_is_gpa) {
+		gpc->gpa = KVM_XEN_INVALID_GPA;
+		gpc->uhva = PAGE_ALIGN_DOWN(gpc->uhva);
+		addr = PAGE_ALIGN_DOWN(addr);
+
+		if (gpc->uhva != addr) {
+			gpc->uhva = addr;
+			hva_change = true;
+		}
+	} else if (gpc->gpa != addr ||
+		   gpc->generation != slots->generation ||
+		   kvm_is_error_hva(gpc->uhva)) {
+		gfn_t gfn = gpa_to_gfn(addr);
 
-		gpc->gpa = gpa;
+		gpc->gpa = addr;
 		gpc->generation = slots->generation;
 		gpc->memslot = __gfn_to_memslot(slots, gfn);
 		gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
@@ -317,7 +326,10 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 
 int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 {
-	return __kvm_gpc_refresh(gpc, gpc->gpa, len);
+	if (gpc->gpa != KVM_XEN_INVALID_GPA)
+		return __kvm_gpc_refresh(gpc, gpc->gpa, true, len);
+
+	return __kvm_gpc_refresh(gpc, gpc->uhva, false, len);
 }
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
@@ -330,7 +342,8 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
 	gpc->uhva = KVM_HVA_ERR_BAD;
 }
 
-int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
+static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, u64 addr, bool addr_is_gpa,
+			      unsigned long len)
 {
 	struct kvm *kvm = gpc->kvm;
 
@@ -351,7 +364,17 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return __kvm_gpc_refresh(gpc, gpa, len);
+	return __kvm_gpc_refresh(gpc, addr, addr_is_gpa, len);
+}
+
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
+{
+	return __kvm_gpc_activate(gpc, gpa, true, len);
+}
+
+int kvm_gpc_activate_hva(struct gfn_to_pfn_cache *gpc, unsigned long hva, unsigned long len)
+{
+	return __kvm_gpc_activate(gpc, hva, false, len);
 }
 
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
-- 
2.39.2


