Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C0113EFEE
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 19:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395376AbgAPSSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 13:18:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35641 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391584AbgAPSSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 13:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579198699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k1/NMdNWn1AdZcspQctzd5y5I9ng1wPTgP3J0ukiT7Q=;
        b=JoknkQfT5ucMH2NQa0ZhWlA2mndVIttjue4/80/K3AzROjMwMHYP5GWsIiAIHG2QReeYAc
        uXlwftRIX48VeeLeAOoNUtF4blbvTdtU6iBQsdzXDeDfdmUqGi7ll0r5Cp+02QPcfs0bf7
        yyFB/HsDPCuZI0LfxbUTR92BIS0tB8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-LCMC3GR5MASKg19CERzZTw-1; Thu, 16 Jan 2020 13:18:15 -0500
X-MC-Unique: LCMC3GR5MASKg19CERzZTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A6DD800D48;
        Thu, 16 Jan 2020 18:18:14 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 444755D9C9;
        Thu, 16 Jan 2020 18:18:14 +0000 (UTC)
Subject: [RFC PATCH 3/3] vfio/type1: Introduce pfn_list mutex
From:   Alex Williamson <alex.williamson@redhat.com>
To:     yan.y.zhao@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 16 Jan 2020 11:18:13 -0700
Message-ID: <157919869385.21002.5744246004583751102.stgit@gimli.home>
In-Reply-To: <157919849533.21002.4782774695733669879.stgit@gimli.home>
References: <157919849533.21002.4782774695733669879.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can promote external page {un}pinning to a reader lock, allowing
concurrency since these don't change the vfio_iommu state.  We do need
to protect the vpfn list per vfio_dma in place of that serialization
though.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e78067cc74b3..ea63306c16f7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -90,6 +90,7 @@ struct vfio_dma {
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	struct task_struct	*task;
+	struct mutex		pfn_list_lock;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 };
 
@@ -539,7 +540,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	if (!iommu->v2)
 		return -EACCES;
 
-	down_write(&iommu->lock);
+	down_read(&iommu->lock);
 
 	/* Fail if notifier list is empty */
 	if (!iommu->notifier.head) {
@@ -570,8 +571,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			goto pin_unwind;
 		}
 
+		mutex_lock(&dma->pfn_list_lock);
+
 		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
 		if (vpfn) {
+			mutex_unlock(&dma->pfn_list_lock);
 			phys_pfn[i] = vpfn->pfn;
 			continue;
 		}
@@ -579,14 +583,19 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		remote_vaddr = dma->vaddr + iova - dma->iova;
 		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
 					     do_accounting);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&dma->pfn_list_lock);
 			goto pin_unwind;
+		}
 
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
 		if (ret) {
 			vfio_unpin_page_external(dma, iova, do_accounting);
+			mutex_unlock(&dma->pfn_list_lock);
 			goto pin_unwind;
 		}
+
+		mutex_unlock(&dma->pfn_list_lock);
 	}
 
 	ret = i;
@@ -599,11 +608,13 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 		iova = user_pfn[j] << PAGE_SHIFT;
 		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
+		mutex_lock(&dma->pfn_list_lock);
 		vfio_unpin_page_external(dma, iova, do_accounting);
+		mutex_unlock(&dma->pfn_list_lock);
 		phys_pfn[j] = 0;
 	}
 pin_done:
-	up_write(&iommu->lock);
+	up_read(&iommu->lock);
 	return ret;
 }
 
@@ -622,7 +633,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 	if (!iommu->v2)
 		return -EACCES;
 
-	down_write(&iommu->lock);
+	down_read(&iommu->lock);
 
 	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
 	for (i = 0; i < npage; i++) {
@@ -633,11 +644,13 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
 		if (!dma)
 			goto unpin_exit;
+		mutex_lock(&dma->pfn_list_lock);
 		vfio_unpin_page_external(dma, iova, do_accounting);
+		mutex_unlock(&dma->pfn_list_lock);
 	}
 
 unpin_exit:
-	up_write(&iommu->lock);
+	up_read(&iommu->lock);
 	return i > npage ? npage : (i > 0 ? i : -EINVAL);
 }
 
@@ -1109,6 +1122,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	dma->iova = iova;
 	dma->vaddr = vaddr;
 	dma->prot = prot;
+	mutex_init(&dma->pfn_list_lock);
 
 	/*
 	 * We need to be able to both add to a task's locked memory and test

