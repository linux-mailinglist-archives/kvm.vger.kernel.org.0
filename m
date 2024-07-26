Return-Path: <kvm+bounces-22345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8632293D8AE
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34E8E2889DB
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55CF1527B4;
	Fri, 26 Jul 2024 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJjixFpi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32412433DF
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722019934; cv=none; b=siOBzInfYWLpYfYLgdogawX1GGwkkLjmjDIFJg6wOm5lXs/4LglGsi+Ren3TOpAgKnETMVCV70mQKoqePS0ArSbXcL0jUpSNfvnCtfcxDH9UVvOC6zWbAoN3tQZwlJ4PDxn3vCEycapBc/5yMnNZahtuABQp9G2gL+0jT8ARBs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722019934; c=relaxed/simple;
	bh=/0sKHZPgYzNq0hyes5yHbqRWSCr6Vw0yDsXxhYlzH08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMPmAEnpBr6Onr0X+RRLGByN31MLhp2N9ANoPqhivF4OJ5woesyMRx5HXyMXYBX8et6Z4gBCinMroAbUon2JkT4iM6kTIRpH9Z9Paux16FvcKGaL3tnQJowzuO3C0qhlBenZgl/0CI258lNbXghKP7SHyigFL30mGDxPpNbGUCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJjixFpi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722019931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QGWFg9ZVhjL4mdKgfZYcs3I+NfLf4BvmOKKsaWtAvBw=;
	b=DJjixFpisrdR69EjvrmqH7n+TEyI3qxTQx3I88BdkQ9KvphKZ2xkDnxooKsNXfICZZ6K6d
	mM5/qOoSuOY+i8vc7acC2PwYR7vQk6vJN5nuIm991dbTMvxSGwgEu50lyIhcLdDhFMflaX
	iPH1hzRYoA3SY3x7IzIAxxJrbR7GP3Y=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-OJo7LKmTNt-aFQocPXB9Hg-1; Fri,
 26 Jul 2024 14:52:05 -0400
X-MC-Unique: OJo7LKmTNt-aFQocPXB9Hg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B274E1955D44;
	Fri, 26 Jul 2024 18:52:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0902C3000194;
	Fri, 26 Jul 2024 18:52:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH v2 07/14] KVM: guest_memfd: delay kvm_gmem_prepare_folio() until the memory is passed to the guest
Date: Fri, 26 Jul 2024 14:51:50 -0400
Message-ID: <20240726185157.72821-8-pbonzini@redhat.com>
In-Reply-To: <20240726185157.72821-1-pbonzini@redhat.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Initializing the contents of the folio on fallocate() is unnecessarily
restrictive.  It means that the page is registered with the firmware and
then it cannot be touched anymore.  In particular, this loses the
possibility of using fallocate() to pre-allocate the page for SEV-SNP
guests, because kvm_arch_gmem_prepare() then fails.

It's only when the guest actually accesses the page (and therefore
kvm_gmem_get_pfn() is called) that the page must be cleared from any
stale host data and registered with the firmware.  The up-to-date flag
is clear if this has to be done (i.e. it is the first access and
kvm_gmem_populate() has not been called).

All in all, there are enough differences between kvm_gmem_get_pfn() and
kvm_gmem_populate(), that it's better to separate the two flows completely.
Extract the bulk of kvm_gmem_get_folio(), which take a folio and end up
setting its up-to-date flag, to a new function kvm_gmem_prepare_folio();
these are now done only by the non-__-prefixed kvm_gmem_get_pfn().
As a bonus, __kvm_gmem_get_pfn() loses its ugly "bool prepare" argument.

One difference is that fallocate(PUNCH_HOLE) can now race with a
page fault.  Potentially this causes a page to be prepared and into the
filemap even after fallocate(PUNCH_HOLE).  This is harmless, as it can be
fixed by another hole punching operation, and can be avoided by clearing
the private-page attribute prior to invoking fallocate(PUNCH_HOLE).
This way, the page fault will cause an exit to user space.

The previous semantics, where fallocate() could be used to prepare
the pages in advance of running the guest, can be accessed with
KVM_PRE_FAULT_MEMORY.

For now, accessing a page in one VM will attempt to call
kvm_arch_gmem_prepare() in all of those that have bound the guest_memfd.
Cleaning this up is left to a separate patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 110 ++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 44 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9271aba9b7b3..5af278c7adba 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -25,7 +25,7 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
 }
 
-static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
+static int __kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
 {
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
@@ -59,49 +59,63 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 	return 0;
 }
 
-/* Returns a locked folio on success.  */
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
+/*
+ * Process @folio, which contains @gfn, so that the guest can use it.
+ * The folio must be locked and the gfn must be contained in @slot.
+ * On successful return the guest sees a zero page so as to avoid
+ * leaking host data and the up-to-date flag is set.
+ */
+static int kvm_gmem_prepare_folio(struct file *file, struct kvm_memory_slot *slot,
+				  gfn_t gfn, struct folio *folio)
 {
-	struct folio *folio;
+	unsigned long nr_pages, i;
+	pgoff_t index;
+	int r;
 
-	/* TODO: Support huge pages. */
-	folio = filemap_grab_folio(inode->i_mapping, index);
-	if (IS_ERR(folio))
-		return folio;
+	if (folio_test_uptodate(folio))
+		return 0;
+
+	nr_pages = folio_nr_pages(folio);
+	for (i = 0; i < nr_pages; i++)
+		clear_highpage(folio_page(folio, i));
 
 	/*
-	 * Use the up-to-date flag to track whether or not the memory has been
-	 * zeroed before being handed off to the guest.  There is no backing
-	 * storage for the memory, so the folio will remain up-to-date until
-	 * it's removed.
+	 * Preparing huge folios should always be safe, since it should
+	 * be possible to split them later if needed.
 	 *
-	 * TODO: Skip clearing pages when trusted firmware will do it when
-	 * assigning memory to the guest.
+	 * Right now the folio order is always going to be zero, but the
+	 * code is ready for huge folios.  The only assumption is that
+	 * the base pgoff of memslots is naturally aligned with the
+	 * requested page order, ensuring that huge folios can also use
+	 * huge page table entries for GPA->HPA mapping.
+	 *
+	 * The order will be passed when creating the guest_memfd, and
+	 * checked when creating memslots.
 	 */
-	if (!folio_test_uptodate(folio)) {
-		unsigned long nr_pages = folio_nr_pages(folio);
-		unsigned long i;
-
-		for (i = 0; i < nr_pages; i++)
-			clear_highpage(folio_page(folio, i));
-	}
-
-	if (prepare) {
-		int r =	kvm_gmem_prepare_folio(inode, index, folio);
-		if (r < 0) {
-			folio_unlock(folio);
-			folio_put(folio);
-			return ERR_PTR(r);
-		}
+	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
+	index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	index = ALIGN_DOWN(index, 1 << folio_order(folio));
 
+	r = __kvm_gmem_prepare_folio(file_inode(file), index, folio);
+	if (!r)
 		folio_mark_uptodate(folio);
-	}
 
-	/*
-	 * Ignore accessed, referenced, and dirty flags.  The memory is
-	 * unevictable and there is no storage to write back to.
-	 */
-	return folio;
+	return r;
+}
+
+/*
+ * Returns a locked folio on success.  The caller is responsible for
+ * setting the up-to-date flag before the memory is mapped into the guest.
+ * There is no backing storage for the memory, so the folio will remain
+ * up-to-date until it's removed.
+ *
+ * Ignore accessed, referenced, and dirty flags.  The memory is
+ * unevictable and there is no storage to write back to.
+ */
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+{
+	/* TODO: Support huge pages. */
+	return filemap_grab_folio(inode->i_mapping, index);
 }
 
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
@@ -201,7 +215,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		folio = kvm_gmem_get_folio(inode, index, true);
+		folio = kvm_gmem_get_folio(inode, index);
 		if (IS_ERR(folio)) {
 			r = PTR_ERR(folio);
 			break;
@@ -555,7 +569,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 /* Returns a locked folio on success.  */
 static struct folio *
 __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		   gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
+		   gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
@@ -572,7 +586,7 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		return ERR_PTR(-EIO);
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
+	folio = kvm_gmem_get_folio(file_inode(file), index);
 	if (IS_ERR(folio))
 		return folio;
 
@@ -594,17 +608,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	struct file *file = kvm_gmem_get_file(slot);
 	struct folio *folio;
+	int r = 0;
 
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
-	fput(file);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order);
+	if (IS_ERR(folio)) {
+		r = PTR_ERR(folio);
+		goto out;
+	}
 
+	r = kvm_gmem_prepare_folio(file, slot, gfn, folio);
 	folio_unlock(folio);
-	return 0;
+	if (r < 0)
+		folio_put(folio);
+
+out:
+	fput(file);
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
@@ -643,7 +665,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
+		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
-- 
2.43.0



