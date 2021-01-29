Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D61E308B73
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhA2RXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:23:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43238 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhA2RXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:23:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH9Tdh083802;
        Fri, 29 Jan 2021 17:22:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yoj6YQuG0VBSGSyaOHs+kxnFo72nuLeRKNuS0JpziyA=;
 b=AqWkBamQ3y6IL2usN+/HU5fuwKQxM6Wv9rTprZ4ijALShmI8TolzMDBLd+uQKrPsGRXr
 Ls5+5djDSSM88OQPguKeG17E7aKTLFWP+U0T2Q81tXMo1hs9ynlK2r4FDcluQ3dcQ1mp
 YcbZuVA63CXTk6HlilQkV4M1Abqf8MM1cTyFyQlPk/DQfVmMTWOelTmKE6ZhVA3dkC3K
 GsvjXU+OfwY1lnJNCMB6b4oB5qro86yE7N8LauqXE0r2xifK9GfEponxPgyQhPcklzrF
 kplRAbCocZ4zjZNdgRB9MXBdYq/dU7q2ACnXFA8BMDsagRTKtst1ZqUeabCiX4phFcnh mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689ab2kfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH5uEe049749;
        Fri, 29 Jan 2021 17:22:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 36ceugxqj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10THML94023184;
        Fri, 29 Jan 2021 17:22:22 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Jan 2021 09:22:21 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 7/9] vfio: iommu driver notify callback
Date:   Fri, 29 Jan 2021 08:54:10 -0800
Message-Id: <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290084
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a vfio_iommu_driver_ops notify callback, for sending events to
the driver.  Drivers are not required to provide the callback, and
may ignore any events.  The handling of events is driver specific.

Define the CONTAINER_CLOSE event, called when the container's file
descriptor is closed.  This event signifies that no further state changes
will occur via container ioctl's.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio.c  | 5 +++++
 include/linux/vfio.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 262ab0e..99458fc 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1220,6 +1220,11 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 static int vfio_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_container *container = filep->private_data;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+
+	if (driver && driver->ops->notify)
+		driver->ops->notify(container->iommu_data,
+				    VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE, NULL);
 
 	filep->private_data = NULL;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 38d3c6a..9642579 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -57,6 +57,9 @@ extern int vfio_add_group_dev(struct device *dev,
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
 
+/* events for the backend driver notify callback */
+#define VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE	1
+
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
  */
@@ -90,6 +93,8 @@ struct vfio_iommu_driver_ops {
 					       struct notifier_block *nb);
 	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
 				  void *data, size_t count, bool write);
+	void		(*notify)(void *iommu_data, unsigned int event,
+				  void *data);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
-- 
1.8.3.1

