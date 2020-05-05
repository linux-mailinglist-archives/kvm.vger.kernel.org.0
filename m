Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5724E1C5569
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 14:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgEEM2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 08:28:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728879AbgEEM16 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 08:27:58 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045CRnnR187280;
        Tue, 5 May 2020 08:27:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v800y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:27:56 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 045CRs4Z187895;
        Tue, 5 May 2020 08:27:54 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v800wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:27:54 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045CQBgJ025404;
        Tue, 5 May 2020 12:27:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5py2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:27:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045CRj8l8585660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 12:27:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C24F6A4055;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7BFDA4040;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2597CE092D; Tue,  5 May 2020 14:27:45 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 6/8] vfio-ccw: Introduce a new CRW region
Date:   Tue,  5 May 2020 14:27:43 +0200
Message-Id: <20200505122745.53208-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505122745.53208-1-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_06:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=2 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

This region provides a mechanism to pass a Channel Report Word
that affect vfio-ccw devices, and needs to be passed to the guest
for its awareness and/or processing.

The base driver (see crw_collect_info()) provides space for two
CRWs, as a subchannel event may have two CRWs chained together
(one for the ssid, one for the subchannel).  As vfio-ccw will
deal with everything at the subchannel level, provide space
for a single CRW to be transferred in one shot.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---

Notes:
    v3->v4:
     - Move crw_trigger and CRW_IRQ from later patch to here [EF]
     - Cleanup descriptions of sizeof CRW region in doc, commentary,
       and commit description [CH]
     - Clear crw when finished [CH]
    
    v2->v3:
     - Remove "if list-empty" check, since there's no list yet [EF]
     - Reduce the CRW region to one fullword, instead of two [CH]
    
    v1->v2:
     - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
     - Add a block comment to struct ccw_crw_region [CH]
    
    v0->v1: [EF]
     - Clean up checkpatch (whitespace) errors
     - Add ret=-ENOMEM in error path for new region
     - Add io_mutex for region read (originally in last patch)
     - Change crw1/crw2 to crw0/crw1
     - Reorder cleanup of regions

 Documentation/s390/vfio-ccw.rst     | 19 ++++++++++
 drivers/s390/cio/vfio_ccw_chp.c     | 55 +++++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
 drivers/s390/cio/vfio_ccw_ops.c     |  8 +++++
 drivers/s390/cio/vfio_ccw_private.h |  4 +++
 include/uapi/linux/vfio.h           |  2 ++
 include/uapi/linux/vfio_ccw.h       |  8 +++++
 7 files changed, 116 insertions(+)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index 98832d95f395..da3a9e22663d 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -247,6 +247,25 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
 Reading this region triggers a STORE SUBCHANNEL to be issued to the
 associated hardware.
 
+vfio-ccw crw region
+---------------------
+
+The vfio-ccw crw region is used to return Channel Report Word (CRW)
+data to userspace::
+
+  struct ccw_crw_region {
+         __u32 crw;
+  } __packed;
+
+This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_CRW.
+
+Reading this region returns a CRW if one that is relevant for this
+subchannel (e.g. one reporting changes in channel path state) is
+pending, or all zeroes if not. If multiple CRWs are pending (including
+possibly chained CRWs), reading this region again will return the next
+one, until no more CRWs are pending and zeroes are returned. This is
+similar to how STORE CHANNEL REPORT WORD works.
+
 vfio-ccw operation details
 --------------------------
 
diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
index 18f3b3e873a9..37ea344a4d72 100644
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -74,3 +74,58 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private)
 					    VFIO_REGION_INFO_FLAG_READ,
 					    private->schib_region);
 }
+
+static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
+					char __user *buf, size_t count,
+					loff_t *ppos)
+{
+	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
+	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
+	struct ccw_crw_region *region;
+	int ret;
+
+	if (pos + count > sizeof(*region))
+		return -EINVAL;
+
+	mutex_lock(&private->io_mutex);
+	region = private->region[i].data;
+
+	if (copy_to_user(buf, (void *)region + pos, count))
+		ret = -EFAULT;
+	else
+		ret = count;
+
+	region->crw = 0;
+
+	mutex_unlock(&private->io_mutex);
+	return ret;
+}
+
+static ssize_t vfio_ccw_crw_region_write(struct vfio_ccw_private *private,
+					 const char __user *buf, size_t count,
+					 loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+static void vfio_ccw_crw_region_release(struct vfio_ccw_private *private,
+					struct vfio_ccw_region *region)
+{
+
+}
+
+const struct vfio_ccw_regops vfio_ccw_crw_region_ops = {
+	.read = vfio_ccw_crw_region_read,
+	.write = vfio_ccw_crw_region_write,
+	.release = vfio_ccw_crw_region_release,
+};
+
+int vfio_ccw_register_crw_dev_regions(struct vfio_ccw_private *private)
+{
+	return vfio_ccw_register_dev_region(private,
+					    VFIO_REGION_SUBTYPE_CCW_CRW,
+					    &vfio_ccw_crw_region_ops,
+					    sizeof(struct ccw_crw_region),
+					    VFIO_REGION_INFO_FLAG_READ,
+					    private->crw_region);
+}
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 7aeff42f370d..e4deae6fd525 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -28,6 +28,7 @@ struct workqueue_struct *vfio_ccw_work_q;
 static struct kmem_cache *vfio_ccw_io_region;
 static struct kmem_cache *vfio_ccw_cmd_region;
 static struct kmem_cache *vfio_ccw_schib_region;
+static struct kmem_cache *vfio_ccw_crw_region;
 
 debug_info_t *vfio_ccw_debug_msg_id;
 debug_info_t *vfio_ccw_debug_trace_id;
@@ -120,6 +121,8 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 
 static void vfio_ccw_free_regions(struct vfio_ccw_private *private)
 {
+	if (private->crw_region)
+		kmem_cache_free(vfio_ccw_crw_region, private->crw_region);
 	if (private->schib_region)
 		kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
 	if (private->cmd_region)
@@ -165,6 +168,12 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (!private->schib_region)
 		goto out_free;
 
+	private->crw_region = kmem_cache_zalloc(vfio_ccw_crw_region,
+						GFP_KERNEL | GFP_DMA);
+
+	if (!private->crw_region)
+		goto out_free;
+
 	private->sch = sch;
 	dev_set_drvdata(&sch->dev, private);
 	mutex_init(&private->io_mutex);
@@ -366,6 +375,7 @@ static void vfio_ccw_debug_exit(void)
 
 static void vfio_ccw_destroy_regions(void)
 {
+	kmem_cache_destroy(vfio_ccw_crw_region);
 	kmem_cache_destroy(vfio_ccw_schib_region);
 	kmem_cache_destroy(vfio_ccw_cmd_region);
 	kmem_cache_destroy(vfio_ccw_io_region);
@@ -413,6 +423,16 @@ static int __init vfio_ccw_sch_init(void)
 		goto out_err;
 	}
 
+	vfio_ccw_crw_region = kmem_cache_create_usercopy("vfio_ccw_crw_region",
+					sizeof(struct ccw_crw_region), 0,
+					SLAB_ACCOUNT, 0,
+					sizeof(struct ccw_crw_region), NULL);
+
+	if (!vfio_ccw_crw_region) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
 	isc_register(VFIO_CCW_ISC);
 	ret = css_driver_register(&vfio_ccw_sch_driver);
 	if (ret) {
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index c3a74ab7bb86..8b3ed5b45277 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -178,6 +178,10 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
 	if (ret)
 		goto out_unregister;
 
+	ret = vfio_ccw_register_crw_dev_regions(private);
+	if (ret)
+		goto out_unregister;
+
 	return ret;
 
 out_unregister:
@@ -389,6 +393,7 @@ static int vfio_ccw_mdev_get_irq_info(struct vfio_irq_info *info)
 {
 	switch (info->index) {
 	case VFIO_CCW_IO_IRQ_INDEX:
+	case VFIO_CCW_CRW_IRQ_INDEX:
 		info->count = 1;
 		info->flags = VFIO_IRQ_INFO_EVENTFD;
 		break;
@@ -416,6 +421,9 @@ static int vfio_ccw_mdev_set_irqs(struct mdev_device *mdev,
 	case VFIO_CCW_IO_IRQ_INDEX:
 		ctx = &private->io_trigger;
 		break;
+	case VFIO_CCW_CRW_IRQ_INDEX:
+		ctx = &private->crw_trigger;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index d6601a8adf13..97131b4df0b9 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -57,6 +57,7 @@ void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private);
 
 int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
 int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private);
+int vfio_ccw_register_crw_dev_regions(struct vfio_ccw_private *private);
 
 /**
  * struct vfio_ccw_private
@@ -71,6 +72,7 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private);
  * @region: additional regions for other subchannel operations
  * @cmd_region: MMIO region for asynchronous I/O commands other than START
  * @schib_region: MMIO region for SCHIB information
+ * @crw_region: MMIO region for getting channel report words
  * @num_regions: number of additional regions
  * @cp: channel program for the current I/O operation
  * @irb: irb info received from interrupt
@@ -90,6 +92,7 @@ struct vfio_ccw_private {
 	struct vfio_ccw_region *region;
 	struct ccw_cmd_region	*cmd_region;
 	struct ccw_schib_region *schib_region;
+	struct ccw_crw_region	*crw_region;
 	int num_regions;
 
 	struct channel_program	cp;
@@ -97,6 +100,7 @@ struct vfio_ccw_private {
 	union scsw		scsw;
 
 	struct eventfd_ctx	*io_trigger;
+	struct eventfd_ctx	*crw_trigger;
 	struct work_struct	io_work;
 } __aligned(8);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 7a1abbd889bd..907758cf6d60 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -379,6 +379,7 @@ struct vfio_region_gfx_edid {
 /* sub-types for VFIO_REGION_TYPE_CCW */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
 #define VFIO_REGION_SUBTYPE_CCW_SCHIB		(2)
+#define VFIO_REGION_SUBTYPE_CCW_CRW		(3)
 
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
@@ -578,6 +579,7 @@ enum {
 
 enum {
 	VFIO_CCW_IO_IRQ_INDEX,
+	VFIO_CCW_CRW_IRQ_INDEX,
 	VFIO_CCW_NUM_IRQS
 };
 
diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
index 758bf214898d..cff5076586df 100644
--- a/include/uapi/linux/vfio_ccw.h
+++ b/include/uapi/linux/vfio_ccw.h
@@ -44,4 +44,12 @@ struct ccw_schib_region {
 	__u8 schib_area[SCHIB_AREA_SIZE];
 } __packed;
 
+/*
+ * Used for returning a Channel Report Word to userspace.
+ * Note: this is controlled by a capability
+ */
+struct ccw_crw_region {
+	__u32 crw;
+} __packed;
+
 #endif
-- 
2.17.1

