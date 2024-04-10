Return-Path: <kvm+bounces-14140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AC989FC3E
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AEC21F23D3F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 15:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6761791E6;
	Wed, 10 Apr 2024 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dkZh4oMv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AE5178CE9
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712764571; cv=none; b=DEWNW8+5KCLH3uomAYZZvpSnMs48ngm6X29Coc43lzTFoWQLhas1e40YBGa/JVzIW2qlGnfrHIOiPcGKdVXBp4FYbyjcdSLkZa8JThYPZHhPE7cnfvAwdIXnE/p7lsq7pT3MdhvrASD6rVLixadaxiw9vHfD9OMGSS2BjUCn6xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712764571; c=relaxed/simple;
	bh=ib/Czh9TMd/11JWLM99RkSfUuaLTcKgI+kz9vZpIItQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0i43GF9SYIsk6ZXbKTr2rrXii+0XDzRzC4UnvRjZfcwxozg1R1+XaWGDMrZCkie1oQtqcRPGGVtibbftwdFfKmXHKPkxNB8vygQgIFMIvlSO/c8sRvlddCCCGyCCu9ZRCpNNwVider7DFmBLrQ3PagQN6g33lpKrLdYqpylL10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dkZh4oMv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712764568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8ZsNI89NzeHBwo5bvI1yofxYUq5jUxcvm+li/FE14A=;
	b=dkZh4oMv/vf3Q67wIKopWjS53RoA1TvxsQ2Km3Ap7CUM1LOl2sYjFVljHCKGfaCyAdcY4I
	iVK7VSDSa16G9eckvhz8aIBcWUqBrgbomQeP83gZzQ/OkSKx/Wf8xoRPYxQlvu+dEN4bS5
	a1w0sz3zLtG+xo5/N21k3bBhXkKGYk0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-sePtCS1xOjyfrSAEA2ASBA-1; Wed, 10 Apr 2024 11:56:04 -0400
X-MC-Unique: sePtCS1xOjyfrSAEA2ASBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8930C8007BA;
	Wed, 10 Apr 2024 15:56:03 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.162])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82C97920;
	Wed, 10 Apr 2024 15:56:00 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yonghua Huang <yonghua.huang@intel.com>,
	Fei Li <fei1.li@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v1 3/3] mm: follow_pte() improvements
Date: Wed, 10 Apr 2024 17:55:27 +0200
Message-ID: <20240410155527.474777-4-david@redhat.com>
In-Reply-To: <20240410155527.474777-1-david@redhat.com>
References: <20240410155527.474777-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

follow_pte() is now our main function to lookup PTEs in VM_PFNMAP/VM_IO
VMAs. Let's perform some more sanity checks to make this exported function
harder to abuse.

Further, extend the doc a bit, it still focuses on the KVM use case with
MMU notifiers. Drop the KVM+follow_pfn() comment, follow_pfn() is no more,
and we have other users nowadays.

Also extend the doc regarding refcounted pages and the interaction with MMU
notifiers.

KVM is one example that uses MMU notifiers and can deal with refcounted
pages properly. VFIO is one example that doesn't use MMU notifiers, and
to prevent use-after-free, rejects refcounted pages:
pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)). Protection changes are
less of a concern for users like VFIO: the behavior is similar to
longterm-pinning a page, and getting the PTE protection changed afterwards.

The primary concern with refcounted pages is use-after-free, which
callers should be aware of.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ab01fb69dc72..535ef2686f95 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5935,15 +5935,21 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
  *
  * On a successful return, the pointer to the PTE is stored in @ptepp;
  * the corresponding lock is taken and its location is stored in @ptlp.
- * The contents of the PTE are only stable until @ptlp is released;
- * any further use, if any, must be protected against invalidation
- * with MMU notifiers.
+ *
+ * The contents of the PTE are only stable until @ptlp is released using
+ * pte_unmap_unlock(). This function will fail if the PTE is non-present.
+ * Present PTEs may include PTEs that map refcounted pages, such as
+ * anonymous folios in COW mappings.
+ *
+ * Callers must be careful when relying on PTE content after
+ * pte_unmap_unlock(). Especially if the PTE maps a refcounted page,
+ * callers must protect against invalidation with MMU notifiers; otherwise
+ * access to the PFN at a later point in time can trigger use-after-free.
  *
  * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
  * should be taken for read.
  *
- * KVM uses this function.  While it is arguably less bad than the historic
- * ``follow_pfn``, it is not a good general-purpose API.
+ * This function must not be used to modify PTE content.
  *
  * Return: zero on success, -ve otherwise.
  */
@@ -5957,6 +5963,10 @@ int follow_pte(struct vm_area_struct *vma, unsigned long address,
 	pmd_t *pmd;
 	pte_t *ptep;
 
+	mmap_assert_locked(mm);
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+		goto out;
+
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
-- 
2.44.0


