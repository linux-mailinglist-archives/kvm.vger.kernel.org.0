Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34A32EAF9C
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbhAEQEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 11:04:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45698 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbhAEQEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 11:04:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105Fu1f0139639;
        Tue, 5 Jan 2021 16:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RKOrHkYm9qF1Xiebh709uEbj8RGTJ9WzcPbpIiekVWU=;
 b=DLQYUGpn+pzDoPebRXgcHNGolavWXcThn9H9/xlchtr0Ww0D6txS0lUI69J/m0NvdDx6
 KD68F8SC30VWJ2qKTjMSAaeAIQ+p9ZQQVtwaU3tfNHMg4klYXCqDYTAU0lkhtjiApkgB
 fYf7S3+256CAkk90+pMdgPHHuzqzJrQXmktgveAO8294ZarbJ9Tn+vyI7/azC/zmqbGy
 kfNl+S+8hV/2yR4u4J1EAudWsqCakysUzsbsxM/tw0lgxdN3+L9d4BXd+qzU1pS8rBnw
 TeBAohMPfgMTtL+/rLuRPz13miMX1IZWGnKOWMch0oGjfpsbybyEnSYp2Sj+2+Zs8Ljl Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35tg8r1g6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 16:04:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105FuRY7026699;
        Tue, 5 Jan 2021 16:04:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35v4rbj5yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 16:04:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105G3x1S017635;
        Tue, 5 Jan 2021 16:03:59 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 16:03:59 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 5/5] vfio: block during VA suspend
Date:   Tue,  5 Jan 2021 07:36:53 -0800
Message-Id: <1609861013-129801-6-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Block translation of host virtual address while an iova range is suspended.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 48 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2c164a6..8035b9a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -31,6 +31,8 @@
 #include <linux/rbtree.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
@@ -484,6 +486,34 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 	return ret;
 }
 
+static bool vfio_iommu_contained(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *domain = iommu->external_domain;
+	struct vfio_group *group;
+
+	if (!domain)
+		domain = list_first_entry(&iommu->domain_list,
+					  struct vfio_domain, next);
+
+	group = list_first_entry(&domain->group_list, struct vfio_group, next);
+	return vfio_iommu_group_contained(group->iommu_group);
+}
+
+
+bool vfio_vaddr_valid(struct vfio_iommu *iommu, struct vfio_dma *dma)
+{
+	while (dma->suspended) {
+		mutex_unlock(&iommu->lock);
+		msleep_interruptible(10);
+		mutex_lock(&iommu->lock);
+		if (kthread_should_stop() || !vfio_iommu_contained(iommu) ||
+		    fatal_signal_pending(current)) {
+			return false;
+		}
+	}
+	return true;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -690,6 +720,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			continue;
 		}
 
+		if (!vfio_vaddr_valid(iommu, dma)) {
+			ret = -EFAULT;
+			goto pin_unwind;
+		}
+
 		remote_vaddr = dma->vaddr + (iova - dma->iova);
 		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
 					     do_accounting);
@@ -1514,12 +1549,16 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 					i += PAGE_SIZE;
 				}
 			} else {
-				unsigned long pfn;
-				unsigned long vaddr = dma->vaddr +
-						     (iova - dma->iova);
+				unsigned long pfn, vaddr;
 				size_t n = dma->iova + dma->size - iova;
 				long npage;
 
+				if (!vfio_vaddr_valid(iommu, dma)) {
+					ret = -EFAULT;
+					goto unwind;
+				}
+				vaddr = dma->vaddr + (iova - dma->iova);
+
 				npage = vfio_pin_pages_remote(dma, vaddr,
 							      n >> PAGE_SHIFT,
 							      &pfn, limit);
@@ -2965,6 +3004,9 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 	if (count > dma->size - offset)
 		count = dma->size - offset;
 
+	if (!vfio_vaddr_valid(iommu, dma))
+		goto out;
+
 	vaddr = dma->vaddr + offset;
 
 	if (write) {
-- 
1.8.3.1

