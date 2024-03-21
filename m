Return-Path: <kvm+bounces-12439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B838862D1
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:00:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11197284550
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884F0136986;
	Thu, 21 Mar 2024 22:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHciWKnG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D299C133998
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 22:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711058423; cv=none; b=siq5S80nsPlAYQqF+No4iUzvlW7RQ3AFXFojLy/+C3VPrqZcnpY64vRlOUsuFSuht6OSG3YOV0jD7jIuNDktuzSMGVLILi0hZ6a7JOLToETjhckDd+U3RpGEM9c9iHQ4+i1h3DwtuelminTrPKCgv0D0mP46a59tlQfxoUFQjNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711058423; c=relaxed/simple;
	bh=eLxkom/FL+0mjm5qC1owyEPEq3OFeYOTi1SX2LAANCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEAEuOEpqzl/BV8CO8uDKWHT9KwWYj1oR9vL2F6SGgkmsb8QXiT+dXTucmW4XYntLTire0Ew1oRFqH+A6qlV9X1He59bC+7eTB+Bi6/bUszndL3wDDSV4ytD0PBP2QIAL1yrFpzgjbE2QdxkHhJYKqgN7TxjGPrUWKferAk14Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHciWKnG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711058420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I/TUj8l6v7W+3WhwmC9vyikgxzfujRZI8v2Khs5cepE=;
	b=NHciWKnGHwfX8d498EXrArLbF9nluFSzrTy4ARW3gyoQAM5rGNLCtzUvbjeR+nknXUheit
	U1IgyUEJ5u/bJoMkc7FX4uh32Z8oiN6npegRllphPf9ZWqZaFAPQANhD0Q0CluUPorFFGp
	h8NLooa1+qJH5yZZy5u1ZCCRGwVY0bk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-jcbu2gX6Mr6wqRm3UnAAQA-1; Thu, 21 Mar 2024 18:00:15 -0400
X-MC-Unique: jcbu2gX6Mr6wqRm3UnAAQA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32BB3803F6A;
	Thu, 21 Mar 2024 22:00:14 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.192.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 887341C060CE;
	Thu, 21 Mar 2024 22:00:06 +0000 (UTC)
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
Subject: [PATCH v1 1/2] mm/userfaultfd: don't place zeropages when zeropages are disallowed
Date: Thu, 21 Mar 2024 22:59:53 +0100
Message-ID: <20240321215954.177730-2-david@redhat.com>
In-Reply-To: <20240321215954.177730-1-david@redhat.com>
References: <20240321215954.177730-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

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
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/userfaultfd.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 712160cd41eca..1d1061ccd1dea 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -316,6 +316,38 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 	goto out;
 }
 
+static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
+		 struct vm_area_struct *dst_vma, unsigned long dst_addr)
+{
+	struct folio *folio;
+	int ret;
+
+	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
+	if (!folio)
+		return -ENOMEM;
+
+	ret = -ENOMEM;
+	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
+		goto out_put;
+
+	/*
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
+	 * preceding stores to the page contents become visible before
+	 * the set_pte_at() write.
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
@@ -324,6 +356,9 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
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


