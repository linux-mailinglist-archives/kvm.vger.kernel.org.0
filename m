Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A8D1AD489
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 04:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgDQCfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 22:35:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728364AbgDQCfb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 22:35:31 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03H2YZtQ117683
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:35:30 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f3gk0cfy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:35:29 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 17 Apr 2020 03:29:46 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Apr 2020 03:29:44 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03H2U27O50528386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 02:30:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 406004C046;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25D084C040;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id B8922E0378; Fri, 17 Apr 2020 04:30:01 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 4/8] vfio-ccw: Introduce a new schib region
Date:   Fri, 17 Apr 2020 04:29:57 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417023001.65006-1-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20041702-0012-0000-0000-000003A5E6CD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041702-0013-0000-0000-000021E32912
Message-Id: <20200417023001.65006-5-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_10:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=2 bulkscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170014
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

The schib region can be used by userspace to get the subchannel-
information block (SCHIB) for the passthrough subchannel.
This can be useful to get information such as channel path
information via the SCHIB.PMCW fields.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---

Notes:
    v2->v3:
     - Updated Copyright year and Authors [CH]
     - Mention that schib region triggers a STSCH [CH]
    
    v1->v2:
     - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
     - Add a block comment to struct ccw_schib_region [CH]
    
    v0->v1: [EF]
     - Clean up checkpatch (#include, whitespace) errors
     - Remove unnecessary includes from vfio_ccw_chp.c
     - Add ret=-ENOMEM in error path for new region
     - Add call to vfio_ccw_unregister_dev_regions() during error exit
       path of vfio_ccw_mdev_open()
     - New info on the module prologue
     - Reorder cleanup of regions

 Documentation/s390/vfio-ccw.rst     | 19 +++++++-
 drivers/s390/cio/Makefile           |  2 +-
 drivers/s390/cio/vfio_ccw_chp.c     | 76 +++++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++
 drivers/s390/cio/vfio_ccw_ops.c     | 14 +++++-
 drivers/s390/cio/vfio_ccw_private.h |  3 ++
 include/uapi/linux/vfio.h           |  1 +
 include/uapi/linux/vfio_ccw.h       | 10 ++++
 8 files changed, 141 insertions(+), 4 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_chp.c

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index fca9c4f5bd9c..98832d95f395 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -231,6 +231,22 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
 
 Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
 
+vfio-ccw schib region
+---------------------
+
+The vfio-ccw schib region is used to return Subchannel-Information
+Block (SCHIB) data to userspace::
+
+  struct ccw_schib_region {
+  #define SCHIB_AREA_SIZE 52
+         __u8 schib_area[SCHIB_AREA_SIZE];
+  } __packed;
+
+This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
+
+Reading this region triggers a STORE SUBCHANNEL to be issued to the
+associated hardware.
+
 vfio-ccw operation details
 --------------------------
 
@@ -333,7 +349,8 @@ through DASD/ECKD device online in a guest now and use it as a block
 device.
 
 The current code allows the guest to start channel programs via
-START SUBCHANNEL, and to issue HALT SUBCHANNEL and CLEAR SUBCHANNEL.
+START SUBCHANNEL, and to issue HALT SUBCHANNEL, CLEAR SUBCHANNEL,
+and STORE SUBCHANNEL.
 
 vfio-ccw supports classic (command mode) channel I/O only. Transport
 mode (HPF) is not supported.
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
index 000000000000..18f3b3e873a9
--- /dev/null
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Channel path related status regions for vfio_ccw
+ *
+ * Copyright IBM Corp. 2020
+ *
+ * Author(s): Farhan Ali <alifm@linux.ibm.com>
+ *            Eric Farman <farman@linux.ibm.com>
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
index e48967c475e7..8e05ed611c10 100644
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
@@ -355,6 +364,7 @@ static void vfio_ccw_debug_exit(void)
 
 static void vfio_ccw_destroy_regions(void)
 {
+	kmem_cache_destroy(vfio_ccw_schib_region);
 	kmem_cache_destroy(vfio_ccw_cmd_region);
 	kmem_cache_destroy(vfio_ccw_io_region);
 }
@@ -391,6 +401,16 @@ static int __init vfio_ccw_sch_init(void)
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
index 015516bcfaa3..7a1abbd889bd 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -378,6 +378,7 @@ struct vfio_region_gfx_edid {
 
 /* sub-types for VFIO_REGION_TYPE_CCW */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
+#define VFIO_REGION_SUBTYPE_CCW_SCHIB		(2)
 
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
index cbecbf0cd54f..758bf214898d 100644
--- a/include/uapi/linux/vfio_ccw.h
+++ b/include/uapi/linux/vfio_ccw.h
@@ -34,4 +34,14 @@ struct ccw_cmd_region {
 	__u32 ret_code;
 } __packed;
 
+/*
+ * Used for processing commands that read the subchannel-information block
+ * Reading this region triggers a stsch() to hardware
+ * Note: this is controlled by a capability
+ */
+struct ccw_schib_region {
+#define SCHIB_AREA_SIZE 52
+	__u8 schib_area[SCHIB_AREA_SIZE];
+} __packed;
+
 #endif
-- 
2.17.1

