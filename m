Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6A03319A7
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhCHVt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232040AbhCHVtl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DwxsuPh0j1VQRJi9ua3SibuYU7hsOwQfBMk4pAEkux0=;
        b=g+ZsXd67gGYJ9dr8QzwFaUXDhvkvBYccfk5QWqS+oLtphMTcmNRBMKvEYbmECq8AHb5N7k
        JpRbgHEvjlvuC0/wLii2+qCM/3KQyuHGESOhS46rJNzlwXDzxhNaHriXzKXUPKoNbIWLl3
        6mpN+6DzlP44eczSOEdw2mBu/NbvGDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-ixWHP2wOPI-VRk60yA7fGg-1; Mon, 08 Mar 2021 16:49:38 -0500
X-MC-Unique: ixWHP2wOPI-VRk60yA7fGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB922814313;
        Mon,  8 Mar 2021 21:49:37 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49AAC1A878;
        Mon,  8 Mar 2021 21:49:31 +0000 (UTC)
Subject: [PATCH v1 12/14] vfio/type1: Support batching of device mappings
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:49:31 -0700
Message-ID: <161524017090.3480.6508004360325488879.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Populate the page array to the extent available to enable batching.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e89f11141dee..d499bccfbe3f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -628,6 +628,8 @@ static int vaddr_get_pfns(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
+		unsigned long count, i;
+
 		if ((dma->prot & IOMMU_WRITE && !(vma->vm_flags & VM_WRITE)) ||
 		    (dma->prot & IOMMU_READ && !(vma->vm_flags & VM_READ))) {
 			ret = -EFAULT;
@@ -678,7 +680,13 @@ static int vaddr_get_pfns(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) +
 							dma->pfnmap->base_pfn;
-		ret = 1;
+		count = min_t(long,
+			      (vma->vm_end - vaddr) >> PAGE_SHIFT, npages);
+
+		for (i = 0; i < count; i++)
+			pages[i] = pfn_to_page(*pfn + i);
+
+		ret = count;
 	}
 done:
 	mmap_read_unlock(mm);

