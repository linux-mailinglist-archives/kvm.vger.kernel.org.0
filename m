Return-Path: <kvm+bounces-22347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 247D393D8B2
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF0B5288A0C
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C604149E1E;
	Fri, 26 Jul 2024 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YVkNT42d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D362A1534EC
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722019936; cv=none; b=mG67+taGZN/WEYc0/GPh9Gj9q7LBtOUk7+fpuJ3MhSaX9FGyBrxubcKhdsIdPriH83BcF3vDOrfqi0OuyRYQmLjmAjVGchZc+O0KfEC9uakuEjsYB2ci7sVPJLddCotvz7bCX3yEiI5E2A51fU+eJDAvAX8+UJNvLEwW4h+kIOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722019936; c=relaxed/simple;
	bh=rpFr9pOsEObgXhoyiV5dWdSXS+JT4JKinIpjYSGWly8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsSbd/1CJPtdib51WkNp4dkZpH29SE4u0y0YfnIM4aXCsQFaCcgpi83/sdCrMb3d8ODHb9ZZ7cljl0w1x1rDN7Ifp7FKdjyv2dORWpHQw36tszbrJI0st1sw0/GFWMJvUWF2HU2ikg/3NMIf3QP6dRzhdq9hg0Bfx3ADDedjJuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YVkNT42d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722019934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=US3dKgYZQqAWMx0OaAPv4mPkaQxRte3t+Kl9UzGuOsI=;
	b=YVkNT42dSuxFfqXdZLGxNNLFHCkZYmeqD1roYSchFXBnqe8Ug4rOqUJXqiZgQtmicvh8fG
	6e2RIabAe7ZauNFtSFosl0RAQ7cgbJsDLmbIt1HRFt3ALdui6wtVVTQ2Hb3Gp1dspALjKO
	gU1r0Bmm8K/KYzJ/IfXMzJ4yh5CzAF4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-6EogCyumMt2baG8bGGnDaw-1; Fri,
 26 Jul 2024 14:52:12 -0400
X-MC-Unique: 6EogCyumMt2baG8bGGnDaw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BC6519560BF;
	Fri, 26 Jul 2024 18:52:11 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 75FF81955D45;
	Fri, 26 Jul 2024 18:52:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH v2 14/14] KVM: guest_memfd: abstract how prepared folios are recorded
Date: Fri, 26 Jul 2024 14:51:57 -0400
Message-ID: <20240726185157.72821-15-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Right now, large folios are not supported in guest_memfd, and therefore the order
used by kvm_gmem_populate() is always 0.  In this scenario, using the up-to-date
bit to track prepared-ness is nice and easy because we have one bit available
per page.

In the future, however, we might have large pages that are partially populated;
for example, in the case of SEV-SNP, if a large page has both shared and private
areas inside, it is necessary to populate it at a granularity that is smaller
than that of the guest_memfd's backing store.  In that case we will have
to track preparedness at a 4K level, probably as a bitmap.

In preparation for that, do not use explicitly folio_test_uptodate() and
folio_mark_uptodate().  Return the state of the page directly from
__kvm_gmem_get_pfn(), so that it is expected to apply to 2^N pages
with N=*max_order.  The function to mark a range as prepared for now
takes just a folio, but is expected to take also an index and order
(or something like that) when large pages are introduced.

Thanks to Michael Roth for pointing out the issue with large pages.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 95e338a29910..f4fa5e040fd1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -42,6 +42,11 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
+static inline void kvm_gmem_mark_prepared(struct folio *folio)
+{
+	folio_mark_uptodate(folio);
+}
+
 /*
  * Process @folio, which contains @gfn, so that the guest can use it.
  * The folio must be locked and the gfn must be contained in @slot.
@@ -55,9 +60,6 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	pgoff_t index;
 	int r;
 
-	if (folio_test_uptodate(folio))
-		return 0;
-
 	nr_pages = folio_nr_pages(folio);
 	for (i = 0; i < nr_pages; i++)
 		clear_highpage(folio_page(folio, i));
@@ -80,7 +82,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	index = ALIGN_DOWN(index, 1 << folio_order(folio));
 	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 	if (!r)
-		folio_mark_uptodate(folio);
+		kvm_gmem_mark_prepared(folio);
 
 	return r;
 }
@@ -551,7 +553,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 /* Returns a locked folio on success.  */
 static struct folio *
 __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		   gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+		   gfn_t gfn, kvm_pfn_t *pfn, bool *is_prepared,
+		   int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
@@ -582,6 +585,7 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	if (max_order)
 		*max_order = 0;
 
+	*is_prepared = folio_test_uptodate(folio);
 	return folio;
 }
 
@@ -590,18 +594,21 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	struct file *file = kvm_gmem_get_file(slot);
 	struct folio *folio;
+	bool is_prepared = false;
 	int r = 0;
 
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, &is_prepared, max_order);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
 	}
 
-	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (!is_prepared)
+		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+
 	folio_unlock(folio);
 	if (r < 0)
 		folio_put(folio);
@@ -641,6 +648,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	for (i = 0; i < npages; i += (1 << max_order)) {
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
+		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -648,13 +656,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &is_prepared, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (folio_test_uptodate(folio)) {
+		if (is_prepared) {
 			folio_unlock(folio);
 			folio_put(folio);
 			ret = -EEXIST;
@@ -662,9 +670,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		}
 
 		folio_unlock(folio);
-		if (!IS_ALIGNED(gfn, (1 << max_order)) ||
-		    (npages - i) < (1 << max_order))
-			max_order = 0;
+		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
+			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
 		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
@@ -678,7 +684,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
 		if (!ret)
-			folio_mark_uptodate(folio);
+			kvm_gmem_mark_prepared(folio);
 
 put_folio_and_exit:
 		folio_put(folio);
-- 
2.43.0


