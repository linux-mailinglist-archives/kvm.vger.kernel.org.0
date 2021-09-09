Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8C54059D2
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhIIPBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:01:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232656AbhIIPBG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 11:01:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631199596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vy4AapnQMIXuIP4+oB7VDWAdrTQvAAS99Uj1TpIfDfo=;
        b=JfaPeAiH2lgbLinp4qR5vvan4nts9sfffkBP2qjs7gKsesdijeb0DE1v4lHK+hDPhCr+Ro
        cPWrMkyh4vIsUcoH5O4Ex67DCgNKukMOwr/3YxLQC6nfarArpzEdUfG1gFoD0BIo/NsKYu
        a0xK4fxx1dA/psNp7vILSDLZVIqd7Nc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-qWG1Yqm1OjiYOek_gEs4uw-1; Thu, 09 Sep 2021 10:59:55 -0400
X-MC-Unique: qWG1Yqm1OjiYOek_gEs4uw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A97DC1006AA2;
        Thu,  9 Sep 2021 14:59:54 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DF9C53E08;
        Thu,  9 Sep 2021 14:59:53 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH RFC 1/9] s390/gmap: validate VMA in __gmap_zap()
Date:   Thu,  9 Sep 2021 16:59:37 +0200
Message-Id: <20210909145945.12192-2-david@redhat.com>
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

