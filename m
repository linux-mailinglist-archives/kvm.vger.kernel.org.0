Return-Path: <kvm+bounces-14273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5118D8A1CF6
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74EEBB2AE23
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E140C15DBD6;
	Thu, 11 Apr 2024 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TX28sJsi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7E482899
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712852100; cv=none; b=iKWxLOBLj0AJC8z8UoezAw+8PqXcWngvfwS6zIz5pkZKDkxZL20JFbq5Ezu+J+zQDqUyrdtPoOT1If+9cseKFYVgA+B6/q+xr/vi8gAKBHc5X/0MfV2gwJgVCsSEBL6HUc/wHAmofUeiDoUfh0QMSrJ45d6kRSL8CJWpsDGtZSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712852100; c=relaxed/simple;
	bh=EffdTTq97YcuRZ8vDwF+UAMXSPioZwk+HMzUFS3/S+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FImr5Xlik8B3W22VPuMy6DlozGfDQC3r/Wy6jUY9cIqLvFF0L4wqLuZmWqCs/Fv4O5sDUd7lwli9L/gI8RPWTRm3Q6shH8xdkM+MRgsvG3zSziES51UXj1V9s7x4nISFL6R9Z7994u/U94d8nSLEaf/uswvwdswAZkOzp4W6tsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TX28sJsi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712852096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Gc5EzQD4KCJRDKgqgJn1MWb8b3Qcq3MV0Fega+6Dww=;
	b=TX28sJsibedXshQKYRPFB2Bu6D18FcYwB3V4BOzTLaqQ+BmJLEb4+OFJoKXtItZ+FD73+5
	/fi+jZPr81JQbuHwbOLDhz+j9pHlaAKqIQ33fw8sE/sR0PvDocYT3HEUYO/VPjLMU/n1Op
	3oP7ifmSilQyStpGfPHGOSUMFhscz+U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-AyIYVHnbPImCEUVwQUyQAA-1; Thu, 11 Apr 2024 12:14:55 -0400
X-MC-Unique: AyIYVHnbPImCEUVwQUyQAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 926B71887313;
	Thu, 11 Apr 2024 16:14:54 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.194.173])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FC1D1074E;
	Thu, 11 Apr 2024 16:14:50 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH v3 1/2] mm/userfaultfd: don't place zeropages when zeropages are disallowed
Date: Thu, 11 Apr 2024 18:14:40 +0200
Message-ID: <20240411161441.910170-2-david@redhat.com>
In-Reply-To: <20240411161441.910170-1-david@redhat.com>
References: <20240411161441.910170-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

s390x must disable shared zeropages for processes running VMs, because
the VMs could end up making use of "storage keys" or protected
virtualization, which are incompatible with shared zeropages.

Yet, with userfaultfd it is possible to insert shared zeropages into
such processes. Let's fallback to simply allocating a fresh zeroed
anonymous folio and insert that instead.

mm_forbids_zeropage() was introduced in commit 593befa6ab74 ("mm: introduce
mm_forbids_zeropage function"), briefly before userfaultfd went
upstream.

Note that we don't want to fail the UFFDIO_ZEROPAGE request like we do
for hugetlb, it would be rather unexpected. Further, we also
cannot really indicated "not supported" to user space ahead of time: it
could be that the MM disallows zeropages after userfaultfd was already
registered.

Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/userfaultfd.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3c3539c573e7..7eb3dd0f8a49 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -316,6 +316,37 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 	goto out;
 }
 
+static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
+		 struct vm_area_struct *dst_vma, unsigned long dst_addr)
+{
+	struct folio *folio;
+	int ret = -ENOMEM;
+
+	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
+	if (!folio)
+		return ret;
+
+	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
+		goto out_put;
+
+	/*
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
+	 * zeroing out the folio become visible before mapping the page
+	 * using set_pte_at(). See do_anonymous_page().
+	 */
+	__folio_mark_uptodate(folio);
+
+	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+				       &folio->page, true, 0);
+	if (ret)
+		goto out_put;
+
+	return 0;
+out_put:
+	folio_put(folio);
+	return ret;
+}
+
 static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 				     struct vm_area_struct *dst_vma,
 				     unsigned long dst_addr)
@@ -324,6 +355,9 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 	spinlock_t *ptl;
 	int ret;
 
+	if (mm_forbids_zeropage(dst_vma->vm_mm))
+		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ret = -EAGAIN;
-- 
2.44.0


