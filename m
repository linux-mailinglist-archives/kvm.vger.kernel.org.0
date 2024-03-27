Return-Path: <kvm+bounces-12889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF32B88EC5F
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C809B23A30
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9BE14EC59;
	Wed, 27 Mar 2024 17:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5Vdi+9+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594DF14E2F4
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559881; cv=none; b=bZ9cxoVjaGlBJAsXxTEgBx5hxtdC+SoF//vzBhhPVCtlfs0S/mbXkZ00tX46xHq4iMRAq3rIIiqczdOrvKefW8L6sOcvwnkqdNLGUR8YjGWY6upWOHLQ3Pgf39YvdT73iQH0vnZu+aN/9C3HBbk3iEVEg5wuBoOnEbw1yZNyLgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559881; c=relaxed/simple;
	bh=TO+a3CRav9u6K5CcRdvmKOufYvOgZZ2X438+yKM7+FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzOmDTbzRZdMgcoKv6onYiJKmesb5vRhyIXxz03Ec3iu1FZxH26/UZFVz2+jZ4wtfGLpCy0H1CnLxbEDuTyaTLch/tgGRH56dL2OmUsF/obyJzJh5RBPo3P3lyJiUrCZbOzdgfFUOarpdEoAbcCTWefrtHBYFmlCoGwbgS1bauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A5Vdi+9+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711559879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8ccLk4IwuzIQJFrPipCiLzVcTODVh2CvV2jxW3RkMc=;
	b=A5Vdi+9+MZy9ry6NF9BEmQMm25hpGtmIAm7aE+2hCbE7d+SdG4pAjnVr5ArqPclWmGUYog
	l0rXFsi391nl4pK22RwZ0pzI6NDdrcFM1zm6gU7hG8RHd/vjZYmSOC/wk9UvJ431EgvxiE
	0htvTle2V1kObRGLKBsQrXP5MKYVs30=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-UN5Oy67YMRqj2AlkFHDtAg-1; Wed,
 27 Mar 2024 13:17:53 -0400
X-MC-Unique: UN5Oy67YMRqj2AlkFHDtAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 050523C02B6C;
	Wed, 27 Mar 2024 17:17:52 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.208])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD695111E40C;
	Wed, 27 Mar 2024 17:17:48 +0000 (UTC)
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
Subject: [PATCH v2 1/2] mm/userfaultfd: don't place zeropages when zeropages are disallowed
Date: Wed, 27 Mar 2024 18:17:36 +0100
Message-ID: <20240327171737.919590-2-david@redhat.com>
In-Reply-To: <20240327171737.919590-1-david@redhat.com>
References: <20240327171737.919590-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

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
index 712160cd41ec..9d385696fb89 100644
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
 
+	if (mm_forbids_zeropage(dst_vma->mm))
+		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ret = -EAGAIN;
-- 
2.43.2


