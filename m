Return-Path: <kvm+bounces-31288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F9F9C211A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57DC828650A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2AC21B441;
	Fri,  8 Nov 2024 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SxTWXzbO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8966621F4AC
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731081076; cv=none; b=EOL/1x6ZKIbSCTvQcRYxpNOZnwwxD2cHXSS09i7KUTihcrFA3mN0+N+rHyGhYqhkGmzW1ugieN5WRDKdrXL1xsM2WvrIMrLNnsqKMQjOuCQCknaqfWIE27Da/hlRUNRyCMbXLCGyq3YhmjdR5/6ElTJWIMzZ+PjoqzMRa4vmtVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731081076; c=relaxed/simple;
	bh=wss1YTUGIt5QGo6tSV9djIgAdvk1YIPYCs+TInKCU54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gD12B1oM5DgEm5At0Ts/ZJd57oI8i7ps0eBeVoum/x/Bs5NVAx4CdjTW60aSL550bUzYa3a1NA043CVhuEakFrEcRBpXEQHK/Jap2V9djetw1lCacwEqYTvqeoTUe5Uy8dz+63LM89LzB8J2f9nDzofJvBlPiu+jX73gdbm9lXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SxTWXzbO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731081073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+bBieyHX2d1zYDc3Erl++MDH1EG7vt2Iio6NE6nW7HE=;
	b=SxTWXzbOHzryeIOTAg9Y7nSY2kTafyvVOaJqKYUD5fA/FpCpG1YTtnwUU9ruVyeabbBWZx
	lK8ygCADKd6WMBgGfO2YuJtxA+GBXuNTLqc+pP0UvXEkOrTcF6l1wYlITNl5FNmzr+t5qt
	Uwz/uV/vbcgZyC2803oPJe3fmgHIKoc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-z2_nwBsXMMmZ3Q4pqaaPwA-1; Fri,
 08 Nov 2024 10:51:07 -0500
X-MC-Unique: z2_nwBsXMMmZ3Q4pqaaPwA-1
X-Mimecast-MFC-AGG-ID: z2_nwBsXMMmZ3Q4pqaaPwA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01C4819560B0;
	Fri,  8 Nov 2024 15:51:06 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47440300019E;
	Fri,  8 Nov 2024 15:51:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	seanjc@google.com
Subject: [PATCH 3/3] KVM: gmem: track preparedness a page at a time
Date: Fri,  8 Nov 2024 10:50:56 -0500
Message-ID: <20241108155056.332412-4-pbonzini@redhat.com>
In-Reply-To: <20241108155056.332412-1-pbonzini@redhat.com>
References: <20241108155056.332412-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

With support for large pages in gmem, it may happen that part of the gmem
is mapped with large pages and part with 4k pages.  For example, if a
conversion happens on a small region within a large page, the large
page has to be smashed into small pages even if backed by a large folio.
Each of the small pages will have its own state of preparedness,
which makes it harder to use the uptodate flag for preparedness.

Just switch to a bitmap in the inode's i_private data.  This is
a bit gnarly because ordinary bitmap operations in Linux are not
atomic, but otherwise not too hard.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 103 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 100 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 416e02a00cae..e08503dfdd8a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -68,8 +68,13 @@ static struct file *kvm_gmem_create_file(const char *name, const struct file_ope
 }
 
 
+#define KVM_GMEM_INODE_SIZE(size)			\
+	struct_size_t(struct kvm_gmem_inode, prepared,	\
+		      DIV_ROUND_UP(size, PAGE_SIZE * BITS_PER_LONG))
+
 struct kvm_gmem_inode {
 	unsigned long flags;
+	unsigned long prepared[];
 };
 
 struct kvm_gmem {
@@ -107,18 +112,110 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
+/*
+ * The bitmap of prepared pages has to be accessed atomically, because
+ * preparation is not protected by any guest.  This unfortunately means
+ * that we cannot use regular bitmap operations.
+ *
+ * The logic becomes a bit simpler for set and test, which operate a
+ * folio at a time and therefore can assume that the range is naturally
+ * aligned (meaning that either it is smaller than a word, or it is does
+ * not include fractions of a word).  For punch-hole operations however
+ * there is all the complexity.
+ */
+
+static void bitmap_set_atomic_word(unsigned long *p, unsigned long start, unsigned long len)
+{
+	unsigned long mask_to_set =
+		BITMAP_FIRST_WORD_MASK(start) & BITMAP_LAST_WORD_MASK(start + len);
+
+	atomic_long_or(mask_to_set, (atomic_long_t *)p);
+}
+
+static void bitmap_clear_atomic_word(unsigned long *p, unsigned long start, unsigned long len)
+{
+	unsigned long mask_to_set =
+		BITMAP_FIRST_WORD_MASK(start) & BITMAP_LAST_WORD_MASK(start + len);
+
+	atomic_long_andnot(mask_to_set, (atomic_long_t *)p);
+}
+
+static bool bitmap_test_allset_word(unsigned long *p, unsigned long start, unsigned long len)
+{
+	unsigned long mask_to_set =
+		BITMAP_FIRST_WORD_MASK(start) & BITMAP_LAST_WORD_MASK(start + len);
+
+	return (*p & mask_to_set) == mask_to_set;
+}
+
 static void kvm_gmem_mark_prepared(struct file *file, pgoff_t index, struct folio *folio)
 {
-	folio_mark_uptodate(folio);
+	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)file->f_inode->i_private;
+	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
+	unsigned long npages = folio_nr_pages(folio);
+
+	/* Folios must be naturally aligned */
+	WARN_ON_ONCE(index & (npages - 1));
+	index &= ~(npages - 1);
+
+	/* Clear page before updating bitmap.  */
+	smp_wmb();
+
+	if (npages < BITS_PER_LONG) {
+		bitmap_set_atomic_word(p, index, npages);
+	} else {
+		BUILD_BUG_ON(BITS_PER_LONG != 64);
+		memset64((u64 *)p, ~0, BITS_TO_LONGS(npages));
+	}
 }
 
 static void kvm_gmem_mark_range_unprepared(struct inode *inode, pgoff_t index, pgoff_t npages)
 {
+	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)inode->i_private;
+	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
+
+	index &= BITS_PER_LONG - 1;
+	if (index) {
+		int first_word_count = min(npages, BITS_PER_LONG - index);
+		bitmap_clear_atomic_word(p, index, first_word_count);
+		npages -= first_word_count;
+		p++;
+	}
+
+	if (npages > BITS_PER_LONG) {
+		BUILD_BUG_ON(BITS_PER_LONG != 64);
+		memset64((u64 *)p, 0, BITS_TO_LONGS(npages));
+		p += BIT_WORD(npages);
+		npages &= BITS_PER_LONG - 1;
+	}
+
+	if (npages)
+		bitmap_clear_atomic_word(p++, 0, npages);
 }
 
 static bool kvm_gmem_is_prepared(struct file *file, pgoff_t index, struct folio *folio)
 {
-	return folio_test_uptodate(folio);
+	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)file->f_inode->i_private;
+	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
+	unsigned long npages = folio_nr_pages(folio);
+	bool ret;
+
+	/* Folios must be naturally aligned */
+	WARN_ON_ONCE(index & (npages - 1));
+	index &= ~(npages - 1);
+
+	if (npages < BITS_PER_LONG) {
+		ret = bitmap_test_allset_word(p, index, npages);
+	} else {
+		for (; npages > 0; npages -= BITS_PER_LONG)
+			if (*p++ != ~0)
+				break;
+		ret = (npages == 0);
+	}
+
+	/* Synchronize with kvm_gmem_mark_prepared().  */
+	smp_rmb();
+	return ret;
 }
 
 /*
@@ -499,7 +596,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	struct file *file;
 	int fd, err;
 
-	i_gmem = kvzalloc(sizeof(struct kvm_gmem_inode), GFP_KERNEL);
+	i_gmem = kvzalloc(KVM_GMEM_INODE_SIZE(size), GFP_KERNEL);
 	if (!i_gmem)
 		return -ENOMEM;
 	i_gmem->flags = flags;
-- 
2.43.5


