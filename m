Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904285816BB
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239120AbiGZPrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbiGZPrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:47:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A010113B;
        Tue, 26 Jul 2022 08:47:16 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QFHCFJ002791;
        Tue, 26 Jul 2022 15:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eEFqDNqG8KdMyw95MUHX0tp8ilxMqIueBv9vsA4vMQw=;
 b=namml8tv4AMoIj/+TWkn8Uu+gsbaRwZqkPUurCIJeCE0nxJJPBXh7T7LrKGpBazpyY3O
 itxYKfJcxYaGSCbaFEEizBYxWGd4Paqc3dq+nrkmkkDLdpN/1Izz4mBpdYfebLRoj9ya
 LASOY3zh5Nh8k0On925y3pCX5JEz+7K5fvS357qE/39kUY04B5Kx7McDbJ9NFeVor7Ok
 u0LB1qzmz9oaibaIY+vwTLOFXop+IgIdYyqMEMYOQm2o3C7X+cwmjlBbe3dddH2cvl3I
 /5SabtsF+c7XmeTQ/732B3/s6fmGYXivYDoyt8I6FU2TNbWHmTRThZ2HMfdP9msx+piE Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjjscs37k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 15:47:01 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26QFHB1v002679;
        Tue, 26 Jul 2022 15:47:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjjscs361-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 15:47:00 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26QFLKiA011893;
        Tue, 26 Jul 2022 15:46:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3hh6eujnp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 15:46:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QFktrH20840868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 15:46:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61503AE051;
        Tue, 26 Jul 2022 15:46:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ECEEAE04D;
        Tue, 26 Jul 2022 15:46:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 15:46:55 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 5F0E1E01BC; Tue, 26 Jul 2022 17:37:28 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     hch@lst.de
Cc:     akrowiak@linux.ibm.com, alex.williamson@redhat.com,
        farman@linux.ibm.com, intel-gvt-dev@lists.freedesktop.org,
        jgg@nvidia.com, jjherne@linux.ibm.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-s390@vger.kernel.org,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com
Subject: [RFC PATCH] vfio/ccw: Move mdev stuff out of struct subchannel
Date:   Tue, 26 Jul 2022 17:37:25 +0200
Message-Id: <20220726153725.2573294-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220720050629.GA6076@lst.de>
References: <20220720050629.GA6076@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O-In2i8Pjnqj4-M6oiIC4skYEZWP6SPn
X-Proofpoint-GUID: WjuuW-99nV0C11RcYEYWTNmF_tfFcINp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=638 clxscore=1015 spamscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's my swipe at a cleanup patch that can be folded in
to this series, to get the mdev stuff in a more proper
location for vfio-ccw.

As previously described, the subchannel is a device-agnostic
structure that does/should not need to know about specific
nuances such as mediated devices. This is why things like
struct vfio_ccw_private exist, so move these details there.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/cio.h              |  3 ---
 drivers/s390/cio/vfio_ccw_drv.c     | 13 +++++++------
 drivers/s390/cio/vfio_ccw_private.h |  4 ++++
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index 1da45307a186..2ad8833653e9 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -109,9 +109,6 @@ struct subchannel {
 	 * frees it.  Use driver_set_override() to set or clear it.
 	 */
 	const char *driver_override;
-	struct mdev_parent parent;
-	struct mdev_type mdev_type;
-	struct mdev_type *mdev_types[1];
 } __attribute__ ((aligned(8)));
 
 DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 6605b4239f88..bdf76805d175 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -142,6 +142,10 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
 
+	private->mdev_type.sysfs_name = "io";
+	private->mdev_type.pretty_name = "I/O subchannel (Non-QDIO)";
+	private->mdev_types[0] = &private->mdev_type;
+
 	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
 				       GFP_KERNEL);
 	if (!private->cp.guest_cp)
@@ -219,12 +223,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, private);
 
-	sch->mdev_type.sysfs_name = "io";
-	sch->mdev_type.pretty_name = "I/O subchannel (Non-QDIO)";
-	sch->mdev_types[0] = &sch->mdev_type;
-	ret = mdev_register_parent(&sch->parent, &sch->dev,
+	ret = mdev_register_parent(&private->parent, &sch->dev,
 				   &vfio_ccw_mdev_driver,
-				   sch->mdev_types, 1);
+				   private->mdev_types, 1);
 	if (ret)
 		goto out_free;
 
@@ -244,7 +245,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
-	mdev_unregister_parent(&sch->parent);
+	mdev_unregister_parent(&private->parent);
 
 	dev_set_drvdata(&sch->dev, NULL);
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 4aa806530974..358996897efc 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -111,6 +111,10 @@ struct vfio_ccw_private {
 	struct eventfd_ctx	*req_trigger;
 	struct work_struct	io_work;
 	struct work_struct	crw_work;
+
+	struct mdev_parent	parent;
+	struct mdev_type	mdev_type;
+	struct mdev_type	*mdev_types[1];
 } __aligned(8);
 
 int vfio_ccw_sch_quiesce(struct subchannel *sch);
-- 
2.31.1

