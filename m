Return-Path: <kvm+bounces-13600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49965898E4C
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C92FC1F2532B
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D94E131BB9;
	Thu,  4 Apr 2024 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCHC+Uw0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5321613249E
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256643; cv=none; b=TvGD6oDhwfRF0lasW1mu0EAmQRYUvhsgnG7RcpzjiX+GC3DHY11rV/Wol9KIS0u0BkKeAWLBhzzJ1kcslqKDczmqzCN6dqBDEpxDcrIcHWGZm1DK8NurAIXqZhjIScn57krbDCnOb75AfLGw4lVM9WTp+tL7dypPjj757LWe4PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256643; c=relaxed/simple;
	bh=sZo1i1kLk+XztE3tIXuKTUlt1pxUJrHw1JJ1hwkgtC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a65wS4O+IRMmazrdrPewo0JVyvKF/pCwTQ6s4C7rjjpYSCgqN9gB5Dt9WLDTlQRDghK2DITR8pubIYFrp55dJeuVBB8W3qZrYUp9YWQSKvZbWjlFRJT+rVfeW/T34plGvwrAfO5o1AAw4Jas+x1wEaGpmK+1Ysg07yA3WBXisd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCHC+Uw0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FvyoR/T19B7DHISxWoVI2byScY2P/MdC/oqveCWAOaQ=;
	b=eCHC+Uw0Ut4RSaxCJf8OpoSVy0TgFezIghDO8uE2u5KAbFBIEySHbCHEUMAZbLW7U03poE
	FMj9w9XaLBdUWKLSxyYxHK3xuFTLsDuYJRq/4VFQrRgR8pKvp00Db5OhKn4n7bDP0tMH+H
	gkoNddSunTI+7ICY1wY5pQINI42gzWU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-Au_eUc0kONmIKNzTOgtqwA-1; Thu,
 04 Apr 2024 14:50:36 -0400
X-MC-Unique: Au_eUc0kONmIKNzTOgtqwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91C4B3C0F192;
	Thu,  4 Apr 2024 18:50:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A9E11C060A4;
	Thu,  4 Apr 2024 18:50:36 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem pages with user data
Date: Thu,  4 Apr 2024 14:50:31 -0400
Message-ID: <20240404185034.3184582-10-pbonzini@redhat.com>
In-Reply-To: <20240404185034.3184582-1-pbonzini@redhat.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
prepare newly-allocated gmem pages prior to mapping them into the guest.
In the case of SEV-SNP, this mainly involves setting the pages to
private in the RMP table.

However, for the GPA ranges comprising the initial guest payload, which
are encrypted/measured prior to starting the guest, the gmem pages need
to be accessed prior to setting them to private in the RMP table so they
can be initialized with the userspace-provided data. Additionally, an
SNP firmware call is needed afterward to encrypt them in-place and
measure the contents into the guest's launch digest.

While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
this handling can be done in an open-coded/vendor-specific manner, this
may expose more gmem-internal state/dependencies to external callers
than necessary. Try to avoid this by implementing an interface that
tries to handle as much of the common functionality inside gmem as
possible, while also making it generic enough to potentially be
usable/extensible for TDX as well.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h | 26 ++++++++++++++
 virt/kvm/guest_memfd.c   | 78 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 33ed3b884a6b..97d57ec59789 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2450,4 +2450,30 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
 bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
 #endif
 
+/**
+ * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
+ *
+ * @kvm: KVM instance
+ * @gfn: starting GFN to be populated
+ * @src: userspace-provided buffer containing data to copy into GFN range
+ *       (passed to @post_populate, and incremented on each iteration
+ *       if not NULL)
+ * @npages: number of pages to copy from userspace-buffer
+ * @post_populate: callback to issue for each gmem page that backs the GPA
+ *                 range
+ * @opaque: opaque data to pass to @post_populate callback
+ *
+ * This is primarily intended for cases where a gmem-backed GPA range needs
+ * to be initialized with userspace-provided data prior to being mapped into
+ * the guest as a private page. This should be called with the slots->lock
+ * held so that caller-enforced invariants regarding the expected memory
+ * attributes of the GPA range do not race with KVM_SET_MEMORY_ATTRIBUTES.
+ *
+ * Returns the number of pages that were populated.
+ */
+long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
+		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+					    void __user *src, int order, void *opaque),
+		       void *opaque);
+
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 51c99667690a..e7de97382a67 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -602,3 +602,81 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
+
+static int kvm_gmem_undo_get_pfn(struct file *file, struct kvm_memory_slot *slot,
+				 gfn_t gfn, int order)
+{
+	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	struct kvm_gmem *gmem = file->private_data;
+
+	/*
+	 * Races with kvm_gmem_unbind() must have been detected by
+	 * __kvm_gmem_get_gfn(), because the invalidate_lock is
+	 * taken between __kvm_gmem_get_gfn() and kvm_gmem_undo_get_pfn().
+	 */
+	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot))
+		return -EIO;
+
+	return __kvm_gmem_punch_hole(file_inode(file), index << PAGE_SHIFT, PAGE_SIZE << order);
+}
+
+long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
+		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+					    void __user *src, int order, void *opaque),
+		       void *opaque)
+{
+	struct file *file;
+	struct kvm_memory_slot *slot;
+
+	int ret = 0, max_order;
+	long i;
+
+	lockdep_assert_held(&kvm->slots_lock);
+	if (npages < 0)
+		return -EINVAL;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot))
+		return -EINVAL;
+
+	file = kvm_gmem_get_file(slot);
+	if (!file)
+		return -EFAULT;
+
+	filemap_invalidate_lock(file->f_mapping);
+
+	npages = min_t(ulong, slot->npages - (gfn - slot->base_gfn), npages);
+	for (i = 0; i < npages; i += (1 << max_order)) {
+		gfn_t this_gfn = gfn + i;
+		kvm_pfn_t pfn;
+
+		ret = __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &max_order, false);
+		if (ret)
+			break;
+
+		if (!IS_ALIGNED(this_gfn, (1 << max_order)) ||
+		    (npages - i) < (1 << max_order))
+			max_order = 0;
+
+		if (post_populate) {
+			void __user *p = src ? src + i * PAGE_SIZE : NULL;
+			ret = post_populate(kvm, this_gfn, pfn, p, max_order, opaque);
+		}
+
+		put_page(pfn_to_page(pfn));
+		if (ret) {
+			/*
+			 * Punch a hole so that FGP_CREAT_ONLY can succeed
+			 * again.
+			 */
+			kvm_gmem_undo_get_pfn(file, slot, this_gfn, max_order);
+			break;
+		}
+	}
+
+	filemap_invalidate_unlock(file->f_mapping);
+
+	fput(file);
+	return ret && !i ? ret : i;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_populate);
-- 
2.43.0



