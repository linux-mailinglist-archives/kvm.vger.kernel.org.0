Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ABA2EAF99
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 17:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbhAEQEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 11:04:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbhAEQEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 11:04:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105FtMF0137935;
        Tue, 5 Jan 2021 16:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Ap/ouEGpUYNvnLEDenrFGt8SjrbOaQOwLg59rXOkBvA=;
 b=VWUUz670qgUe7xAphxfKJ3kUsffFOsm0egDol2u5IxBJPippZWjkQzcT1h7EZlC47kyC
 cbLl676rQydW3y0Uw1ZgC9mkCgk7ioXfkfUMfQR52f/MkLDgeJIQphKDXHDwu8ONhesS
 7VwzWI/G61c+IxPU66jTLVKX7seE2kpv+FuTeOhYK1QB3AzSz7jAVDuObpNEhFrBLHEJ
 2Sbx8iuiGCR69qa86uR+3kp86+1plEtRglFMIAgmypjBcQXjN1zPHLUrwyIZZ/UxsJIT
 J+C2BeRbJIKa6RLy6xt0q/C8/VcMi4vW9GH07fCxRVUQkyR130/vzivEg0t3fjT9+7xu xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35tg8r1g6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 16:04:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105FtLPk176029;
        Tue, 5 Jan 2021 16:04:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35vct61n95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 16:03:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105G3wMw031362;
        Tue, 5 Jan 2021 16:03:58 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 16:03:58 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 3/5] vfio: detect closed container
Date:   Tue,  5 Jan 2021 07:36:51 -0800
Message-Id: <1609861013-129801-4-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a function that detects if an iommu_group has a valid container.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio.c  | 12 ++++++++++++
 include/linux/vfio.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 262ab0e..f89ab80 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -61,6 +61,7 @@ struct vfio_container {
 	struct vfio_iommu_driver	*iommu_driver;
 	void				*iommu_data;
 	bool				noiommu;
+	bool				closed;
 };
 
 struct vfio_unbound_dev {
@@ -1223,6 +1224,7 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
 
 	filep->private_data = NULL;
 
+	container->closed = true;
 	vfio_container_put(container);
 
 	return 0;
@@ -2216,6 +2218,16 @@ void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
 
+bool vfio_iommu_group_contained(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
+	bool ret = group && group->container && !group->container->closed;
+
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_iommu_group_contained);
+
 static int vfio_register_group_notifier(struct vfio_group *group,
 					unsigned long *events,
 					struct notifier_block *nb)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 38d3c6a..b2724e7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -148,6 +148,7 @@ extern int vfio_unregister_notifier(struct device *dev,
 
 struct kvm;
 extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
+extern bool vfio_iommu_group_contained(struct iommu_group *group);
 
 /*
  * Sub-module helpers
-- 
1.8.3.1

