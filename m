Return-Path: <kvm+bounces-31287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 696029C2115
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20C961F2167F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39E921C17D;
	Fri,  8 Nov 2024 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TqUnSSqy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658F221B423
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731081072; cv=none; b=mIlzZlEhJERdo8vjp091ermjkSdSq/ItmughpeRd/dcPBbthcRT2HKtsJAmYxj/XjsalrbUJOyYcYpiEDJz1URzACpndqDckAV2ma1RyfRnsiIyfYxToN+cvBATP8jLy17klkWggsWkGqmYWSgvuy1M6BIsJaGdZtw6WJXnMZbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731081072; c=relaxed/simple;
	bh=/AZjLPqPEaywOa4BXgZaIJNjugO2+x5GxR4rgGGfGhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1UBePeKquCD5nt5wmCybNTRyGnYOd9TkQY5k7WPlF8r5mwVgmCNktXNbjIjetwQpvb1h6KY7IpBWdRzFdBQeEKFy9wD0NK2D6rVzJnMJJFFchWVu0h4TdBkkwpTRKr3qOVRIWueconCrt8YcvtdxW3dN5xw2mAxXhyVgD18Jig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TqUnSSqy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731081069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=clr/KAgDBcdG6y4j8m/K4hUntnUnW17taVZTjfs/x9U=;
	b=TqUnSSqyWopQjEycglCurmMTRE71clsMYA7v4hBhVbi707Q9XXLoaW0XzdMVcAELJJmd4x
	4ZP8zhxG3rzQIoCdAXFh6UBdg35RoiU/cO8FC3DpHqnBQYn/V9R3wKM/zz85aCRiMPbAen
	cNaOXyHrs5hDzCLUnIdiyR81OZAFgmE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-GS94pOM3PfaBu3GK_iLKcw-1; Fri,
 08 Nov 2024 10:51:06 -0500
X-MC-Unique: GS94pOM3PfaBu3GK_iLKcw-1
X-Mimecast-MFC-AGG-ID: GS94pOM3PfaBu3GK_iLKcw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 135911956083;
	Fri,  8 Nov 2024 15:51:05 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58D27300019E;
	Fri,  8 Nov 2024 15:51:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	seanjc@google.com
Subject: [PATCH 2/3] KVM: gmem: add a complete set of functions to query page preparedness
Date: Fri,  8 Nov 2024 10:50:55 -0500
Message-ID: <20241108155056.332412-3-pbonzini@redhat.com>
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

In preparation for moving preparedness out of the folio flags, pass
the struct file* or struct inode* down to kvm_gmem_mark_prepared,
as well as the offset within the gmem file.  Introduce new functions
to unprepare page on punch-hole, and to query the state.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3ea5a7597fd4..416e02a00cae 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -107,18 +107,28 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
-static inline void kvm_gmem_mark_prepared(struct folio *folio)
+static void kvm_gmem_mark_prepared(struct file *file, pgoff_t index, struct folio *folio)
 {
 	folio_mark_uptodate(folio);
 }
 
+static void kvm_gmem_mark_range_unprepared(struct inode *inode, pgoff_t index, pgoff_t npages)
+{
+}
+
+static bool kvm_gmem_is_prepared(struct file *file, pgoff_t index, struct folio *folio)
+{
+	return folio_test_uptodate(folio);
+}
+
 /*
  * Process @folio, which contains @gfn, so that the guest can use it.
  * The folio must be locked and the gfn must be contained in @slot.
  * On successful return the guest sees a zero page so as to avoid
  * leaking host data and the up-to-date flag is set.
  */
-static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
+static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
+				  struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
 	unsigned long nr_pages, i;
@@ -147,7 +157,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	index = ALIGN_DOWN(index, 1 << folio_order(folio));
 	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 	if (!r)
-		kvm_gmem_mark_prepared(folio);
+		kvm_gmem_mark_prepared(file, index, folio);
 
 	return r;
 }
@@ -231,6 +241,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		kvm_gmem_invalidate_begin(gmem, start, end);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	kvm_gmem_mark_range_unprepared(inode, start, end - start);
 
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_end(gmem, start, end);
@@ -682,7 +693,7 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = folio_test_uptodate(folio);
+	*is_prepared = kvm_gmem_is_prepared(file, index, folio);
 	return folio;
 }
 
@@ -704,7 +715,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	if (!is_prepared)
-		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio);
 
 	folio_unlock(folio);
 	if (r < 0)
@@ -781,8 +792,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
-		if (!ret)
-			kvm_gmem_mark_prepared(folio);
+		if (!ret) {
+			pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
+			kvm_gmem_mark_prepared(file, index, folio);
+		}
 
 put_folio_and_exit:
 		folio_put(folio);
-- 
2.43.5



