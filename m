Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F018405AC3
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbhIIQY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:24:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52441 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237246AbhIIQYy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 12:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631204624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AFQ+PFFzuCsI2iNiDGJPyhOhhFIVbgjHojitNDzOvDA=;
        b=EBuSlW08TqrUNpcQZLxxDAebTp1OeppHJNI06LAkbAieFX6mMbIdDMbdk999mnbVHy4NqI
        aOqK1hNxRo9dDJGRWJ3V5weAs1LW6Q13zkykSLE+oygaeeDUPp4pDL5430wxbns3Qt3ex8
        tFWZl5QOyeE6+wnCqfDWlzVKi7LTQEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-iYujWlCINKeyttb0DHYyVA-1; Thu, 09 Sep 2021 12:23:43 -0400
X-MC-Unique: iYujWlCINKeyttb0DHYyVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FD91802CB5;
        Thu,  9 Sep 2021 16:23:14 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5712A18FD2;
        Thu,  9 Sep 2021 16:23:11 +0000 (UTC)
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
Subject: [PATCH resend RFC 6/9] s390/pci_mmio: fully validate the VMA before calling follow_pte()
Date:   Thu,  9 Sep 2021 18:22:45 +0200
Message-Id: <20210909162248.14969-7-david@redhat.com>
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
with read mmap_sem in munmap").

find_vma() does not check if the address is >= the VMA start address;
use vma_lookup() instead.

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/pci/pci_mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index ae683aa623ac..c5b35ea129cf 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 
 	mmap_read_lock(current->mm);
 	ret = -EINVAL;
-	vma = find_vma(current->mm, mmio_addr);
+	vma = vma_lookup(current->mm, mmio_addr);
 	if (!vma)
 		goto out_unlock_mmap;
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
@@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 
 	mmap_read_lock(current->mm);
 	ret = -EINVAL;
-	vma = find_vma(current->mm, mmio_addr);
+	vma = vma_lookup(current->mm, mmio_addr);
 	if (!vma)
 		goto out_unlock_mmap;
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-- 
2.31.1

