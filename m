Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2A01C1FC3
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 23:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgEAVj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 17:39:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33707 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726762AbgEAVj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 17:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588369167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eckl6hH0AbgL49kEhmxA8Bwx9T7n/rxh8xbcvWxSc1I=;
        b=COeXvT7/wJdq0K5kZGtA9pOYN+23VcAm1cxUw732BAkgT8wfqNjbgkqR/FWgHgt+OvSC+F
        5b2ECtypDKq1PPkIlD9uvHk5KHxR25wF1YZD3iwyrADoPKs9H4h6TKOLE6NcUtYiFP3935
        Mrdlfz4oTaz3avHviaOYkGBKUej9yrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-VGPdlWLBMt22sw6NqGdmiw-1; Fri, 01 May 2020 17:39:15 -0400
X-MC-Unique: VGPdlWLBMt22sw6NqGdmiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 189B345F;
        Fri,  1 May 2020 21:39:14 +0000 (UTC)
Received: from gimli.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E9195D9CA;
        Fri,  1 May 2020 21:39:08 +0000 (UTC)
Subject: [PATCH 1/3] vfio/type1: Support faulting PFNMAP vmas
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com
Date:   Fri, 01 May 2020 15:39:08 -0600
Message-ID: <158836914801.8433.9711545991918184183.stgit@gimli.home>
In-Reply-To: <158836742096.8433.685478071796941103.stgit@gimli.home>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
the range being faulted into the vma.  Add support to manually provide
that, in the same way as done on KVM with hva_to_pfn_remapped().

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index cc1d64765ce7..4a4cb7cd86b2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
 	return 0;
 }
 
+static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
+			    unsigned long vaddr, unsigned long *pfn,
+			    bool write_fault)
+{
+	int ret;
+
+	ret = follow_pfn(vma, vaddr, pfn);
+	if (ret) {
+		bool unlocked = false;
+
+		ret = fixup_user_fault(NULL, mm, vaddr,
+				       FAULT_FLAG_REMOTE |
+				       (write_fault ?  FAULT_FLAG_WRITE : 0),
+				       &unlocked);
+		if (unlocked)
+			return -EAGAIN;
+
+		if (ret)
+			return ret;
+
+		ret = follow_pfn(vma, vaddr, pfn);
+	}
+
+	return ret;
+}
+
 static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 			 int prot, unsigned long *pfn)
 {
@@ -339,12 +365,16 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 
 	vaddr = untagged_addr(vaddr);
 
+retry:
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		if (!follow_pfn(vma, vaddr, pfn) &&
-		    is_invalid_reserved_pfn(*pfn))
-			ret = 0;
+		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
+		if (ret == -EAGAIN)
+			goto retry;
+
+		if (!ret && !is_invalid_reserved_pfn(*pfn))
+			ret = -EFAULT;
 	}
 done:
 	up_read(&mm->mmap_sem);

