Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C56405ACC
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbhIIQZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:25:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237830AbhIIQZA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 12:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631204630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vy4AapnQMIXuIP4+oB7VDWAdrTQvAAS99Uj1TpIfDfo=;
        b=awbT2nxUK9lTtl+YtMicJ5f8ZDf7FvxB0djpO/+X/GpYPTOfnJMll+s8V16x+TGwxnqklb
        HkYWuN2/68j9BngbQPsrFlkIaKUIl2uasu+5frcFiiJuZyQvE2tu3CslqDM5Pby13aFtKm
        mDhx1R4auwH5w5w+DMwFiESaOlSHRxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-ioilyjDyOoyG3YriGikekw-1; Thu, 09 Sep 2021 12:23:49 -0400
X-MC-Unique: ioilyjDyOoyG3YriGikekw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 999D01006AA6;
        Thu,  9 Sep 2021 16:22:56 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8560777718;
        Thu,  9 Sep 2021 16:22:53 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: [PATCH resend RFC 1/9] s390/gmap: validate VMA in __gmap_zap()
Date:   Thu,  9 Sep 2021 18:22:40 +0200
Message-Id: <20210909162248.14969-2-david@redhat.com>
In-Reply-To: <20210909162248.14969-1-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap"). The pure prescence in our guest_to_host
radix tree does not imply that there is a VMA.

Further, we should not allocate page tables (via get_locked_pte()) outside
of VMA boundaries: if evil user space decides to map hugetlbfs to these
ranges, bad things will happen because we suddenly have PTE or PMD page
tables where we shouldn't have them.

Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
calling get_locked_pte().

Note that gmap_discard() is different:
zap_page_range()->unmap_single_vma() makes sure to stay within VMA
boundaries.

Fixes: b31288fa83b2 ("s390/kvm: support collaborative memory management")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/gmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 9bb2c7512cd5..b6b56cd4ca64 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -673,6 +673,7 @@ EXPORT_SYMBOL_GPL(gmap_fault);
  */
 void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 {
+	struct vm_area_struct *vma;
 	unsigned long vmaddr;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -682,6 +683,11 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 						   gaddr >> PMD_SHIFT);
 	if (vmaddr) {
 		vmaddr |= gaddr & ~PMD_MASK;
+
+		vma = vma_lookup(gmap->mm, vmaddr);
+		if (!vma || is_vm_hugetlb_page(vma))
+			return;
+
 		/* Get pointer to the page table entry */
 		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
 		if (likely(ptep))
-- 
2.31.1

