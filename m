Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD28FD320
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 04:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfKODG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 22:06:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbfKODG4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 22:06:56 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF350RS024239
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 22:06:55 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w9jtv5bk2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 22:06:52 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 15 Nov 2019 02:56:26 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 02:56:22 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAF2uLnS39846016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 02:56:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28C7BA405F;
        Fri, 15 Nov 2019 02:56:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B47CA405B;
        Fri, 15 Nov 2019 02:56:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 15 Nov 2019 02:56:21 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 58275E0248; Fri, 15 Nov 2019 03:56:20 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 05/10] vfio-ccw: Introduce a new schib region
Date:   Fri, 15 Nov 2019 03:56:15 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115025620.19593-1-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111502-0008-0000-0000-0000032F245C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111502-0009-0000-0000-00004A4E34FF
Message-Id: <20191115025620.19593-6-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=2
 adultscore=0 clxscore=1011 impostorscore=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=790
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150026
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

The schib region can be used by userspace to get the SCHIB for the
passthrough subchannel. This can be useful to get information such
as channel path information via the SCHIB.PMCW.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---

Notes:
    v0->v1: [EF]
     - Clean up checkpatch (#include, whitespace) errors
     - Remove unnecessary includes from vfio_ccw_chp.c
     - Add ret=-ENOMEM in error path for new region
     - Add call to vfio_ccw_unregister_dev_regions() during error exit
       path of vfio_ccw_mdev_open()
     - New info on the module prologue
     - Reorder cleanup of regions

 drivers/s390/cio/Makefile           |  2 +-
 drivers/s390/cio/vfio_ccw_chp.c     | 75 +++++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++
 drivers/s390/cio/vfio_ccw_ops.c     | 14 +++++-
 drivers/s390/cio/vfio_ccw_private.h |  3 ++
 include/uapi/linux/vfio.h           |  1 +
 include/uapi/linux/vfio_ccw.h       |  5 ++
 7 files changed, 117 insertions(+), 3 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_chp.c

diff --git a/drivers/s390/cio/Makefile b/drivers/s390/cio/Makefile
index 23eae4188876..a9235f111e79 100644
--- a/drivers/s390/cio/Makefile
+++ b/drivers/s390/cio/Makefile
@@ -21,5 +21,5 @@ qdio-objs := qdio_main.o qdio_thinint.o qdio_debug.o qdio_setup.o
 obj-$(CONFIG_QDIO) += qdio.o
 
 vfio_ccw-objs += vfio_ccw_drv.o vfio_ccw_cp.o vfio_ccw_ops.o vfio_ccw_fsm.o \
-	vfio_ccw_async.o vfio_ccw_trace.o
+	vfio_ccw_async.o vfio_ccw_trace.o vfio_ccw_chp.o
 obj-$(CONFIG_VFIO_CCW) += vfio_ccw.o
diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
new file mode 100644
index 000000000000..826d08379fe3
--- /dev/null
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Channel path related status regions for vfio_ccw
+ *
+ * Copyright IBM Corp. 2019
+ *
+ * Author(s): Farhan Ali <alifm@linux.ibm.com>
+ */
+
+#include <linux/vfio.h>
+#include "vfio_ccw_private.h"
+
+static ssize_t vfio_ccw_schib_region_read(struct vfio_ccw_private *private,
+					  char __user *buf, size_t count,
+					  loff_t *ppos)
+{
+	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
+	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
+	struct ccw_schib_region *region;
+	int ret;
+
+	if (pos + count > sizeof(*region))
+		return -EINVAL;
+
+	mutex_lock(&private->io_mutex);
+	region = private->region[i].data;
+
+	if (cio_update_schib(private->sch)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	memcpy(region, &private->sch->schib, sizeof(*region));
+
+	if (copy_to_user(buf, (void *)region + pos, count)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = count;
+
+out:
+	mutex_unlock(&private->io_mutex);
+	return ret;
+}
+
+static ssize_t vfio_ccw_schib_region_write(struct vfio_ccw_private *private,
+					   const char __user *buf, size_t count,
+					   loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+
+static void vfio_ccw_schib_region_release(struct vfio_ccw_private *private,
+					  struct vfio_ccw_region *region)
+{
+
+}
+
+const struct vfio_ccw_regops vfio_ccw_schib_region_ops = {
+	.read = vfio_ccw_schib_region_read,
+	.write = vfio_ccw_schib_region_write,
+	.release = vfio_ccw_schib_region_release,
+};
+
+int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private)
+{
+	return vfio_ccw_register_dev_region(private,
+					    VFIO_REGION_SUBTYPE_CCW_SCHIB,
+					    &vfio_ccw_schib_region_ops,
+					    sizeof(struct ccw_schib_region),
+					    VFIO_REGION_INFO_FLAG_READ,
+					    private->schib_region);
+}
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 05da1facee60..de3a09d79ae1 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -27,6 +27,7 @@
 struct workqueue_struct *vfio_ccw_work_q;
 static struct kmem_cache *vfio_ccw_io_region;
 static struct kmem_cache *vfio_ccw_cmd_region;
+static struct kmem_cache *vfio_ccw_schib_region;
 
 debug_info_t *vfio_ccw_debug_msg_id;
 debug_info_t *vfio_ccw_debug_trace_id;
@@ -119,6 +120,8 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 
 static void vfio_ccw_free_regions(struct vfio_ccw_private *private)
 {
+	if (private->schib_region)
+		kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
 	if (private->cmd_region)
 		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
 	if (private->io_region)
@@ -156,6 +159,12 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (!private->cmd_region)
 		goto out_free;
 
+	private->schib_region = kmem_cache_zalloc(vfio_ccw_schib_region,
+						  GFP_KERNEL | GFP_DMA);
+
+	if (!private->schib_region)
+		goto out_free;
+
 	private->sch = sch;
 	dev_set_drvdata(&sch->dev, private);
 	mutex_init(&private->io_mutex);
@@ -349,6 +358,7 @@ static void vfio_ccw_debug_exit(void)
 
 static void vfio_ccw_destroy_regions(void)
 {
+	kmem_cache_destroy(vfio_ccw_schib_region);
 	kmem_cache_destroy(vfio_ccw_cmd_region);
 	kmem_cache_destroy(vfio_ccw_io_region);
 }
@@ -385,6 +395,16 @@ static int __init vfio_ccw_sch_init(void)
 		goto out_err;
 	}
 
+	vfio_ccw_schib_region = kmem_cache_create_usercopy("vfio_ccw_schib_region",
+					sizeof(struct ccw_schib_region), 0,
+					SLAB_ACCOUNT, 0,
+					sizeof(struct ccw_schib_region), NULL);
+
+	if (!vfio_ccw_schib_region) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
 	isc_register(VFIO_CCW_ISC);
 	ret = css_driver_register(&vfio_ccw_sch_driver);
 	if (ret) {
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index d4fc84b8867f..22988d67b6bb 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -172,8 +172,18 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
 
 	ret = vfio_ccw_register_async_dev_regions(private);
 	if (ret)
-		vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
-					 &private->nb);
+		goto out_unregister;
+
+	ret = vfio_ccw_register_schib_dev_regions(private);
+	if (ret)
+		goto out_unregister;
+
+	return ret;
+
+out_unregister:
+	vfio_ccw_unregister_dev_regions(private);
+	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+				 &private->nb);
 	return ret;
 }
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index ce3834159d98..d6601a8adf13 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -56,6 +56,7 @@ int vfio_ccw_register_dev_region(struct vfio_ccw_private *private,
 void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private);
 
 int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
+int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private);
 
 /**
  * struct vfio_ccw_private
@@ -69,6 +70,7 @@ int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
  * @io_mutex: protect against concurrent update of I/O regions
  * @region: additional regions for other subchannel operations
  * @cmd_region: MMIO region for asynchronous I/O commands other than START
+ * @schib_region: MMIO region for SCHIB information
  * @num_regions: number of additional regions
  * @cp: channel program for the current I/O operation
  * @irb: irb info received from interrupt
@@ -87,6 +89,7 @@ struct vfio_ccw_private {
 	struct mutex		io_mutex;
 	struct vfio_ccw_region *region;
 	struct ccw_cmd_region	*cmd_region;
+	struct ccw_schib_region *schib_region;
 	int num_regions;
 
 	struct channel_program	cp;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..b108e2795ea3 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -378,6 +378,7 @@ struct vfio_region_gfx_edid {
 
 /* sub-types for VFIO_REGION_TYPE_CCW */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
+#define VFIO_REGION_SUBTYPE_CCW_SCHIB		(2)
 
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
index cbecbf0cd54f..7c0a834e5d7a 100644
--- a/include/uapi/linux/vfio_ccw.h
+++ b/include/uapi/linux/vfio_ccw.h
@@ -34,4 +34,9 @@ struct ccw_cmd_region {
 	__u32 ret_code;
 } __packed;
 
+struct ccw_schib_region {
+#define SCHIB_AREA_SIZE 52
+	__u8 schib_area[SCHIB_AREA_SIZE];
+} __packed;
+
 #endif
-- 
2.17.1

