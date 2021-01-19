Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CBC2FBEC9
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392354AbhASSTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:19:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49872 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391577AbhASSQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAUI9079539;
        Tue, 19 Jan 2021 18:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yoj6YQuG0VBSGSyaOHs+kxnFo72nuLeRKNuS0JpziyA=;
 b=FJxqnOtFShGirJfngW9BYTW6HjJ3hJf+PG9/mTg8EPWdKgTgw/TatFjecmXDQxyLj7AF
 7A4Ic4VGXDWn70C6Zkxbgw63a37fmsRnAND8XuJB5nisZGqTtwnc7s4QNtusTkqiphX1
 FVNNpvM+wRE0nZV+skyp/8aQ0osN5TNt3tNH13bJInrWXNUt7QxXIF+JeRdkvkvKr3JL
 pno5ORkId/X2V8x/E45mNxE7nsTu53GRO9PxAnVuTfVC/IBTuaCpDcuuDNyFGe0AuZ5E
 8UWHum3n3WTR82pkj3TWQFd1eZbRfYBJSnzbFq+b7rO7cL0+ZfzomotDX1AzdnsERb5N tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 363nnajjqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAZng063647;
        Tue, 19 Jan 2021 18:16:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3649qppmmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JIG2dA018693;
        Tue, 19 Jan 2021 18:16:02 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:16:02 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 7/9] vfio: iommu driver notify callback
Date:   Tue, 19 Jan 2021 09:48:27 -0800
Message-Id: <1611078509-181959-8-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
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

