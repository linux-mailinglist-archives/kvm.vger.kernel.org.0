Return-Path: <kvm+bounces-21443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E052392F1DF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F7681C229FD
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8E01A0AF1;
	Thu, 11 Jul 2024 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UyQLX5AV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F731A01DF
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736885; cv=none; b=fpxCHbBhoHe7HbeRh5n5ysWFX6p4oGpqDdaSQaLbKnQ1VU6QgjnVaBLsr33Q2bXnHu1gCkatAsOtF64efvT+6mpFTpyKCadWm94Jal2BN6gcCuqo1fHHoc/refopsWfBcgtxU4nZf75bVfQ/zw0YbM/S79HTm2kCBI0X0QeIh08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736885; c=relaxed/simple;
	bh=/T1IyEuC1afzaDJ38A39rp6xkEAxRpEAD+ybHaS4NhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIa3hiDtpoHI0nAb55BKf92Y6ElQckfKXQKnwwII54Oa4sbgdAfixjOb7LvKN3YHrkj4yGhCTIcoQeLgGI9u2jJewqWBsAlhTM78lWHWyl+9ytac1VuaYPK33sU2Htk6x99Q7+9hhlKz2KFNnM+KgfXUVJn1CJkMbR4tAQeEKhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UyQLX5AV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eZWyZhV9VRSNjrziIQxjP5twHaew9jzbSXjMU0sQXfw=;
	b=UyQLX5AV/+MurTqcyrppDDZ5StNcDxHlCElh/Cx3w00gEWisdWbqC+sd01cJjPtXzEOjVN
	DvBgYtzYETYryqRESOC2ExpF6/tO+dfno7IYYlDiL2ZXIzfMGoDfIG0HXZdZXJRXY9g65M
	Te7Gm/Bko423KtgtBM1wPWrUnj36P2Y=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-boVmNKkaMxqwNxg5j4Qe9w-1; Thu,
 11 Jul 2024 18:27:58 -0400
X-MC-Unique: boVmNKkaMxqwNxg5j4Qe9w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD06119560BF;
	Thu, 11 Jul 2024 22:27:57 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B96E31956046;
	Thu, 11 Jul 2024 22:27:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 01/12] KVM: guest_memfd: return folio from __kvm_gmem_get_pfn()
Date: Thu, 11 Jul 2024 18:27:44 -0400
Message-ID: <20240711222755.57476-2-pbonzini@redhat.com>
In-Reply-To: <20240711222755.57476-1-pbonzini@redhat.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Right now this is simply more consistent and avoids use of pfn_to_page()
and put_page().  It will be put to more use in upcoming patches, to
ensure that the up-to-date flag is set at the very end of both the
kvm_gmem_get_pfn() and kvm_gmem_populate() flows.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1c509c351261..522e1b28e7ae 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -541,34 +541,34 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
+static struct folio *
+__kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
+		   gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
 	struct page *page;
-	int r;
 
 	if (file != slot->gmem.file) {
 		WARN_ON_ONCE(slot->gmem.file);
-		return -EFAULT;
+		return ERR_PTR(-EFAULT);
 	}
 
 	gmem = file->private_data;
 	if (xa_load(&gmem->bindings, index) != slot) {
 		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
-		return -EIO;
+		return ERR_PTR(-EIO);
 	}
 
 	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
 	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+		return folio;
 
 	if (folio_test_hwpoison(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
-		return -EHWPOISON;
+		return ERR_PTR(-EHWPOISON);
 	}
 
 	page = folio_file_page(folio, index);
@@ -577,25 +577,25 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	if (max_order)
 		*max_order = 0;
 
-	r = 0;
-
 	folio_unlock(folio);
-
-	return r;
+	return folio;
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	struct file *file = kvm_gmem_get_file(slot);
-	int r;
+	struct folio *folio;
 
 	if (!file)
 		return -EFAULT;
 
-	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
+	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
 	fput(file);
-	return r;
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
@@ -625,6 +625,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
 	for (i = 0; i < npages; i += (1 << max_order)) {
+		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		kvm_pfn_t pfn;
 
@@ -633,9 +634,11 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		ret = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
-		if (ret)
+		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
+		if (IS_ERR(folio)) {
+			ret = PTR_ERR(folio);
 			break;
+		}
 
 		if (!IS_ALIGNED(gfn, (1 << max_order)) ||
 		    (npages - i) < (1 << max_order))
@@ -644,7 +647,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
 
-		put_page(pfn_to_page(pfn));
+		folio_put(folio);
 		if (ret)
 			break;
 	}
-- 
2.43.0



