Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB544059EB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbhIIPCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239929AbhIIPBz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 11:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631199646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AFQ+PFFzuCsI2iNiDGJPyhOhhFIVbgjHojitNDzOvDA=;
        b=aXciQm1i7cNDdVEzxhTmSTgn7IWN3SSn/Aqa7h4AJsmV2gptKCQs20/hM5fGnHtNbFIubI
        Qfoh9V5fhwMvBsMm/IkVFddg5kj83HM2vnjpfi5aOfJa8JDmD+IrMdvVXSOX+BB17WvVUS
        dUpmDYpRTTgTCkbXezLfcjMLZQy+2Fo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-bR5dBWpKMIKV4m9D_tlJ8Q-1; Thu, 09 Sep 2021 11:00:42 -0400
X-MC-Unique: bR5dBWpKMIKV4m9D_tlJ8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A47FD8018A9;
        Thu,  9 Sep 2021 15:00:41 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C75D6F923;
        Thu,  9 Sep 2021 15:00:17 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before calling follow_pte()
Date:   Thu,  9 Sep 2021 16:59:42 +0200
Message-Id: <20210909145945.12192-7-david@redhat.com>
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

