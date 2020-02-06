Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEBB154E0D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 22:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgBFVie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 16:38:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727517AbgBFVie (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 16:38:34 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016Lbtxf096407
        for <kvm@vger.kernel.org>; Thu, 6 Feb 2020 16:38:32 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhmjpwxk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 16:38:32 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Feb 2020 21:38:30 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 21:38:28 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016LcQOB38207696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 21:38:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A607D42041;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89AC242047;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id B1FA3E027F; Thu,  6 Feb 2020 22:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH v2 5/9] vfio-ccw: Introduce a new CRW region
Date:   Thu,  6 Feb 2020 22:38:21 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200206213825.11444-1-farman@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20020621-0016-0000-0000-000002E46484
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020621-0017-0000-0000-000033474C07
Message-Id: <20200206213825.11444-6-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_04:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 mlxlogscore=955 suspectscore=2 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002060157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

This region provides a mechanism to pass Channel Report Word(s)
that affect vfio-ccw devices, and need to be passed to the guest
for its awareness and/or processing.

The base driver (see crw_collect_info()) provides space for two
CRWs, as a subchannel event may have two CRWs chained together
(one for the ssid, one for the subcahnnel).  All other CRWs will
only occupy the first one.  Even though this support will also
only utilize the first one, we'll provide space for two also.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---

Notes:
    v1-v2:
     - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
     - Add a block comment to struct ccw_crw_region [CH]
    
    v0->v1: [EF]
     - Clean up checkpatch (whitespace) errors
     - Add ret=-ENOMEM in error path for new region
     - Add io_mutex for region read (originally in last patch)
     - Change crw1/crw2 to crw0/crw1
     - Reorder cleanup of regions

 Documentation/s390/vfio-ccw.rst     | 15 ++++++++
 drivers/s390/cio/vfio_ccw_chp.c     | 56 +++++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
 drivers/s390/cio/vfio_ccw_ops.c     |  4 +++
 drivers/s390/cio/vfio_ccw_private.h |  3 ++
 include/uapi/linux/vfio.h           |  1 +
 include/uapi/linux/vfio_ccw.h       |  9 +++++
 7 files changed, 108 insertions(+)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index b805dc995fc8..b8e4b10e9988 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -244,6 +244,21 @@ Block (SCHIB) data to userspace::
 
 This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
 
+vfio-ccw crw region
+---------------------
+
+The vfio-ccw crw region is used to return Channel Report Word (CRW)
+data to userspace::
+
+  struct ccw_crw_region {
+         __u32 crw[2];
+  } __packed;
+
+This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_CRW.
+
+Currently, space is provided for two CRWs, as hardware may chain
+two together for subchannel events even if vfio-ccw does not today.
+
 vfio-ccw operation details
 --------------------------
 
diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
index 826d08379fe3..8fde94552149 100644
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -73,3 +73,59 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private)
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
+	if (list_empty(&private->crw))
+		return 0;
+
+	mutex_lock(&private->io_mutex);
+	region = private->region[i].data;
+
+	if (copy_to_user(buf, (void *)region + pos, count))
+		ret = -EFAULT;
+	else
+		ret = count;
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
index 3023a366ad47..1e1360af1b34 100644
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
@@ -358,6 +367,7 @@ static void vfio_ccw_debug_exit(void)
 
 static void vfio_ccw_destroy_regions(void)
 {
+	kmem_cache_destroy(vfio_ccw_crw_region);
 	kmem_cache_destroy(vfio_ccw_schib_region);
 	kmem_cache_destroy(vfio_ccw_cmd_region);
 	kmem_cache_destroy(vfio_ccw_io_region);
@@ -405,6 +415,16 @@ static int __init vfio_ccw_sch_init(void)
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
index 22988d67b6bb..edec0fb7ace8 100644
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
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index d6601a8adf13..8289b6850e59 100644
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
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index b108e2795ea3..5024636d7615 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -379,6 +379,7 @@ struct vfio_region_gfx_edid {
 /* sub-types for VFIO_REGION_TYPE_CCW */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
 #define VFIO_REGION_SUBTYPE_CCW_SCHIB		(2)
+#define VFIO_REGION_SUBTYPE_CCW_CRW		(3)
 
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
index 758bf214898d..3a98bc4c80b6 100644
--- a/include/uapi/linux/vfio_ccw.h
+++ b/include/uapi/linux/vfio_ccw.h
@@ -44,4 +44,13 @@ struct ccw_schib_region {
 	__u8 schib_area[SCHIB_AREA_SIZE];
 } __packed;
 
+/*
+ * Used for returning Channel Report Word(s) to userspace.
+ * Note: this is controlled by a capability
+ */
+struct ccw_crw_region {
+	__u32 crw0;
+	__u32 crw1;
+} __packed;
+
 #endif
-- 
2.17.1

