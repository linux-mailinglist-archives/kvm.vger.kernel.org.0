Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6758C4059DE
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhIIPBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:01:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236597AbhIIPBL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 11:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631199602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JN1gh/b5OY5DLuaHK7ojF2josCVOG87yIDqVi/iwvJY=;
        b=K6A3cZQEwsID8UOW3F7HWNy25bAatiSgbs/bz5WBKoXAPcevcwsuySB9sKEzzsIMOYCbLt
        oxh+7+dq10Ww82a/xCyeuotUawW6xFCsMlplf6p3N+IealkCOBB3MCY8o5BPNADNBMnvgC
        O4SPvXx+wLQ6olh0yrmrRMHFjtpnb7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-GtdegVJlP9CLy8G8xzHU-g-1; Thu, 09 Sep 2021 11:00:01 -0400
X-MC-Unique: GtdegVJlP9CLy8G8xzHU-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F32DA1023F4E;
        Thu,  9 Sep 2021 14:59:59 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E0626F7EF;
        Thu,  9 Sep 2021 14:59:56 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH RFC 3/9] s390/mm: validate VMA in PGSTE manipulation functions
Date:   Thu,  9 Sep 2021 16:59:39 +0200
Message-Id: <20210909145945.12192-4-david@redhat.com>
In-Reply-To: <20210909145945.12192-1-david@redhat.com>
References: <20210909145945.12192-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap"). gfn_to_hva() will only translate using
KVM memory regions, but won't validate the VMA.

Further, we should not allocate page tables outside of VMA boundaries: if
evil user space decides to map hugetlbfs to these ranges, bad things will
happen because we suddenly have PTE or PMD page tables where we
shouldn't have them.

Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
calling get_locked_pte().

Fixes: 2d42f9477320 ("s390/kvm: Add PGSTE manipulation functions")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/pgtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index eec3a9d7176e..54969e0f3a94 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -988,6 +988,7 @@ EXPORT_SYMBOL(get_guest_storage_key);
 int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
 			unsigned long *oldpte, unsigned long *oldpgste)
 {
+	struct vm_area_struct *vma;
 	unsigned long pgstev;
 	spinlock_t *ptl;
 	pgste_t pgste;
@@ -997,6 +998,10 @@ int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
 	WARN_ON_ONCE(orc > ESSA_MAX);
 	if (unlikely(orc > ESSA_MAX))
 		return -EINVAL;
+
+	vma = vma_lookup(mm, hva);
+	if (!vma || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
@@ -1089,10 +1094,14 @@ EXPORT_SYMBOL(pgste_perform_essa);
 int set_pgste_bits(struct mm_struct *mm, unsigned long hva,
 			unsigned long bits, unsigned long value)
 {
+	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 	pgste_t new;
 	pte_t *ptep;
 
+	vma = vma_lookup(mm, hva);
+	if (!vma || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
@@ -1117,9 +1126,13 @@ EXPORT_SYMBOL(set_pgste_bits);
  */
 int get_pgste(struct mm_struct *mm, unsigned long hva, unsigned long *pgstep)
 {
+	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
+	vma = vma_lookup(mm, hva);
+	if (!vma || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
-- 
2.31.1

