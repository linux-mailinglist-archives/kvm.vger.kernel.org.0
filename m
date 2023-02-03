Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8625C68A4EB
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 22:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjBCVup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 16:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjBCVun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 16:50:43 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C311A976;
        Fri,  3 Feb 2023 13:50:42 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313Ln85P005631;
        Fri, 3 Feb 2023 21:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FBB8Cn7y9DuJ6A81j72Fv4lk9fW6BPvwNv7dAe4ZXSo=;
 b=HpRfWI5u5oEcQWJnQ9mA/kC4EDkGrB/68Qnvol74sV57N2fn9AlX+lFCqJ4XpYQD30mn
 YmwJjsWoRsHgkrOGqyt+0LE7ksHHfe6FE0I6Qxl3zZFgEzMhscixCsuVzQMCuYc3bRJH
 SDIyiAcJHJmSpnmkvCqpuaN3f8Hom+XoqP/JGPHR4Q4R/ttLmh8kTPfKC7kHl0XDPgc/
 FOW8ojspELat74sw97BWFk/2XYTVLmrttH1MXCsxDTikyxieOD4M2pcZeu7IgBZnbj2F
 BtLd3CZLC/o/IhLTvzI1VVBijSBdh/GWzwh7JcHrV3852fMT5zdjBfty0vsdRBk1WmrJ eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nhah4r102-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 21:50:36 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313LoMDp011813;
        Fri, 3 Feb 2023 21:50:36 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nhah4r0yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 21:50:36 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 313KAB2H025419;
        Fri, 3 Feb 2023 21:50:35 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3ncvtsbjr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 21:50:35 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313LoY5A43844128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 21:50:34 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CDE658056;
        Fri,  3 Feb 2023 21:50:34 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3337058052;
        Fri,  3 Feb 2023 21:50:32 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.65.253.123])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 21:50:32 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, pbonzini@redhat.com,
        yi.l.liu@intel.com, jgg@nvidia.com
Cc:     cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        kevin.tian@intel.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] vfio: no need to pass kvm pointer during device open
Date:   Fri,  3 Feb 2023 16:50:27 -0500
Message-Id: <20230203215027.151988-3-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203215027.151988-1-mjrosato@linux.ibm.com>
References: <20230203215027.151988-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CpOA_XrigkE-sXNCkcn5Q5Ubbwsh3eQy
X-Proofpoint-GUID: Tx3h4YY7YrqjINEvIMVPstC5jZjJvS4Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_19,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030194
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing uses this value during vfio_device_open anymore so it's safe
to remove it.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/group.c     | 2 +-
 drivers/vfio/vfio.h      | 3 +--
 drivers/vfio/vfio_main.c | 7 +++----
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 98621ac082f0..0e9036e2b9c4 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -187,7 +187,7 @@ static int vfio_device_group_open(struct vfio_device *device)
 	if (device->open_count == 0)
 		vfio_device_group_get_kvm_safe(device);
 
-	ret = vfio_device_open(device, device->group->iommufd, device->kvm);
+	ret = vfio_device_open(device, device->group->iommufd);
 
 	if (device->open_count == 0)
 		vfio_device_put_kvm(device);
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 24d6cd285945..4f39ab549a80 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,8 +18,7 @@ struct vfio_container;
 
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
-int vfio_device_open(struct vfio_device *device,
-		     struct iommufd_ctx *iommufd, struct kvm *kvm);
+int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd);
 void vfio_device_close(struct vfio_device *device,
 		       struct iommufd_ctx *iommufd);
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 28c47cd6a6b5..3a597e799918 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -397,7 +397,7 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 }
 
 static int vfio_device_first_open(struct vfio_device *device,
-				  struct iommufd_ctx *iommufd, struct kvm *kvm)
+				  struct iommufd_ctx *iommufd)
 {
 	int ret;
 
@@ -444,8 +444,7 @@ static void vfio_device_last_close(struct vfio_device *device,
 	module_put(device->dev->driver->owner);
 }
 
-int vfio_device_open(struct vfio_device *device,
-		     struct iommufd_ctx *iommufd, struct kvm *kvm)
+int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
 {
 	int ret = 0;
 
@@ -453,7 +452,7 @@ int vfio_device_open(struct vfio_device *device,
 
 	device->open_count++;
 	if (device->open_count == 1) {
-		ret = vfio_device_first_open(device, iommufd, kvm);
+		ret = vfio_device_first_open(device, iommufd);
 		if (ret)
 			device->open_count--;
 	}
-- 
2.39.1

