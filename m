Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66A213EFE9
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 19:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392755AbgAPSSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 13:18:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391646AbgAPSSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 13:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579198685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=niuGWb81Q8zr23FXcglCGpZUWD+TFqFFh4zn2anjs0s=;
        b=b2hJqLWeO4Od0oZHkg9fqdKheEF5YGfL2XwSqf0pqawmWqHpy961NLtKVY8V7g5aYLNmz7
        rylkERsO83yAut8OeFjLuY9jYKjU3ULjvQvz1DtivYoe8vDu9lT3eKnQZ+4pQzadyE/0rm
        /SDTfl7UyCSfs9VyCGN0jQd3YSf3U/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-2pz5OV7JOFemg2VndDEo1Q-1; Thu, 16 Jan 2020 13:18:01 -0500
X-MC-Unique: 2pz5OV7JOFemg2VndDEo1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06B7800D5C;
        Thu, 16 Jan 2020 18:18:00 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 496AF80617;
        Thu, 16 Jan 2020 18:17:57 +0000 (UTC)
Subject: [RFC PATCH 1/3] vfio/type1: Convert vfio_iommu.lock from mutex to
 rwsem
From:   Alex Williamson <alex.williamson@redhat.com>
To:     yan.y.zhao@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 16 Jan 2020 11:17:57 -0700
Message-ID: <157919867745.21002.3239982207630090516.stgit@gimli.home>
In-Reply-To: <157919849533.21002.4782774695733669879.stgit@gimli.home>
References: <157919849533.21002.4782774695733669879.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a first step reducing lock contention, maintain the same locking
granularity using a rwsem rather than a mutex.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   51 ++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ada8e6cdb88..7ae58350af5b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/rbtree.h>
+#include <linux/rwsem.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
@@ -64,7 +65,7 @@ struct vfio_iommu {
 	struct list_head	domain_list;
 	struct list_head	iova_list;
 	struct vfio_domain	*external_domain; /* domain for external user */
-	struct mutex		lock;
+	struct rw_semaphore	lock;
 	struct rb_root		dma_list;
 	struct blocking_notifier_head notifier;
 	unsigned int		dma_avail;
@@ -538,7 +539,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	if (!iommu->v2)
 		return -EACCES;
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 
 	/* Fail if notifier list is empty */
 	if (!iommu->notifier.head) {
@@ -602,7 +603,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		phys_pfn[j] = 0;
 	}
 pin_done:
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 	return ret;
 }
 
@@ -621,7 +622,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 	if (!iommu->v2)
 		return -EACCES;
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 
 	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
 	for (i = 0; i < npage; i++) {
@@ -636,7 +637,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 	}
 
 unpin_exit:
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 	return i > npage ? npage : (i > 0 ? i : -EINVAL);
 }
 
@@ -829,10 +830,10 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 	struct vfio_domain *domain;
 	unsigned long bitmap = ULONG_MAX;
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next)
 		bitmap &= domain->domain->pgsize_bitmap;
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 
 	/*
 	 * In case the IOMMU supports page sizes smaller than PAGE_SIZE
@@ -870,7 +871,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 	WARN_ON(mask & PAGE_MASK);
 again:
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 
 	/*
 	 * vfio-iommu-type1 (v1) - User mappings were coalesced together to
@@ -945,7 +946,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			 * Vendor drivers MUST unpin pages in response to an
 			 * invalidation.
 			 */
-			mutex_unlock(&iommu->lock);
+			up_write(&iommu->lock);
 			blocking_notifier_call_chain(&iommu->notifier,
 						    VFIO_IOMMU_NOTIFY_DMA_UNMAP,
 						    &nb_unmap);
@@ -956,7 +957,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 unlock:
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 
 	/* Report how much was unmapped */
 	unmap->size = unmapped;
@@ -1081,7 +1082,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr)
 		return -EINVAL;
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 
 	if (vfio_find_dma(iommu, iova, size)) {
 		ret = -EEXIST;
@@ -1150,7 +1151,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		ret = vfio_pin_map_dma(iommu, dma, size);
 
 out_unlock:
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 	return ret;
 }
 
@@ -1645,18 +1646,18 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (find_iommu_group(d, iommu_group)) {
-			mutex_unlock(&iommu->lock);
+			up_write(&iommu->lock);
 			return -EINVAL;
 		}
 	}
 
 	if (iommu->external_domain) {
 		if (find_iommu_group(iommu->external_domain, iommu_group)) {
-			mutex_unlock(&iommu->lock);
+			up_write(&iommu->lock);
 			return -EINVAL;
 		}
 	}
@@ -1693,7 +1694,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 			list_add(&group->next,
 				 &iommu->external_domain->group_list);
-			mutex_unlock(&iommu->lock);
+			up_write(&iommu->lock);
 
 			return 0;
 		}
@@ -1815,7 +1816,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 done:
 	/* Delete the old one and insert new iova list */
 	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 	vfio_iommu_resv_free(&group_resv_regions);
 
 	return 0;
@@ -1829,7 +1830,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 out_free:
 	kfree(domain);
 	kfree(group);
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 	return ret;
 }
 
@@ -1969,7 +1970,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	struct vfio_group *group;
 	LIST_HEAD(iova_copy);
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 
 	if (iommu->external_domain) {
 		group = find_iommu_group(iommu->external_domain, iommu_group);
@@ -2033,7 +2034,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		vfio_iommu_iova_free(&iova_copy);
 
 detach_group_done:
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 }
 
 static void *vfio_iommu_type1_open(unsigned long arg)
@@ -2062,7 +2063,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
-	mutex_init(&iommu->lock);
+	init_rwsem(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
 
 	return iommu;
@@ -2114,14 +2115,14 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	struct vfio_domain *domain;
 	int ret = 1;
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next) {
 		if (!(domain->prot & IOMMU_CACHE)) {
 			ret = 0;
 			break;
 		}
 	}
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 
 	return ret;
 }
@@ -2155,7 +2156,7 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	size_t size;
 	int iovas = 0, i = 0, ret;
 
-	mutex_lock(&iommu->lock);
+	down_write(&iommu->lock);
 
 	list_for_each_entry(iova, &iommu->iova_list, list)
 		iovas++;
@@ -2189,7 +2190,7 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 
 	kfree(cap_iovas);
 out_unlock:
-	mutex_unlock(&iommu->lock);
+	up_write(&iommu->lock);
 	return ret;
 }
 

