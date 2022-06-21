Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB815536C4
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353260AbiFUPwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353206AbiFUPvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510C82D1D7;
        Tue, 21 Jun 2022 08:51:49 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFg7q3017028;
        Tue, 21 Jun 2022 15:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Qs/icYNSEvBwc72t0DlitIIcfdya+heLo2MKmCeudZc=;
 b=shMgFimlh16gji4SNPTBuP9EbMZpqSRoO8FqymSZB5W45n/bc78ep3QKIKgB5NmMIKZi
 kvPhe5gvAVhL+vDtHF7UCONy0WbnEAr+wAXlfOXUCSf7+AvCt+OBd6Qaji5g2MPPF3w8
 J0vUI8/Ut11Bb/ND7oplDAMQldSJDk1600Qx338/SSkKa8ckAfiMmhBargbEDz+tf4U4
 unvDxKvC8DTK56WW9b339/M4lEJXpke5d0Y1DF4glS2xn3A+UEm2Lw8vURIxku7xpMPe
 R40EbiyUOEPvzfrVyHIVBZ0E63OyEl2TWRNN/+2zTVV5KBIpK8BhnX0U9oCcnwwTPCUB pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugusr8s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:48 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFhXHk030589;
        Tue, 21 Jun 2022 15:51:47 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugusr8rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:47 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZDYI021706;
        Tue, 21 Jun 2022 15:51:46 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3gs6b9cvr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:46 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpjvs26345858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:45 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BE9713605E;
        Tue, 21 Jun 2022 15:51:45 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 350BD136051;
        Tue, 21 Jun 2022 15:51:44 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 08/20] s390/vfio-ap: introduce new mutex to control access to the KVM pointer
Date:   Tue, 21 Jun 2022 11:51:22 -0400
Message-Id: <20220621155134.1932383-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZUdcupa91zMhnyHrBCQ8XQgs0i3gCJwi
X-Proofpoint-ORIG-GUID: my7gpmwJH8MU2XX4jHWzh7j12XF7AX4g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_ap device driver registers for notification when the pointer to
the KVM object for a guest is set. Recall that the KVM lock (kvm->lock)
mutex must be taken outside of the matrix_dev->lock mutex to prevent the
reporting by lockdep of a circular locking dependency (a.k.a., a lockdep
splat):

* see commit 0cc00c8d4050 ("Fix circular lockdep when setting/clearing
  crypto masks")

* see commit 86956e70761b ("replace open coded locks for
  VFIO_GROUP_NOTIFY_SET_KVM notification")

With the introduction of support for hot plugging/unplugging AP devices
passed through to a KVM guest, a new guests_lock mutex is introduced to
ensure the proper locking order is maintained:

struct ap_matrix_dev {
        ...
        struct mutex guests_lock;
       ...
}

The matrix_dev->guests_lock controls access to the matrix_mdev instances
that hold the state for AP devices that have been passed through to a
KVM guest. This lock must be held to control access to the KVM pointer
(matrix_mdev->kvm) while the vfio_ap device driver is using it to
plug/unplug AP devices passed through to the KVM guest.

Keep in mind, the proper locking order must be maintained whenever
dynamically updating a KVM guest's APCB to plug/unplug adapters, domains
and control domains:

    1. matrix_dev->guests_lock: required to use the KVM pointer - stored in
       a struct ap_matrix_mdev instance - to update a KVM guest's APCB

    2. matrix_mdev->kvm->lock: required to update a guest's APCB

    3. matrix_dev->mdevs_lock: required to access data stored in a
       struct ap_matrix_mdev instance.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 1 +
 drivers/s390/crypto/vfio_ap_private.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index ed162732b139..db8ca7bb3696 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -100,6 +100,7 @@ static int vfio_ap_matrix_dev_create(void)
 
 	mutex_init(&matrix_dev->mdevs_lock);
 	INIT_LIST_HEAD(&matrix_dev->mdev_list);
+	mutex_init(&matrix_dev->guests_lock);
 
 	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
 	matrix_dev->device.parent = root_device;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 22278d85a801..82ac74e83e13 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -39,6 +39,11 @@
  *		single ap_matrix_mdev device. It's quite coarse but we don't
  *		expect much contention.
  * @vfio_ap_drv: the vfio_ap device driver
+ * @guests_lock: mutex for controlling access to a guest that is using AP
+ *		 devices passed through by the vfio_ap device driver. This lock
+ *		 will be taken when the AP devices are plugged into or unplugged
+ *		 from a guest, and when an ap_matrix_mdev device is added to or
+ *		 removed from @mdev_list or the list is iterated.
  */
 struct ap_matrix_dev {
 	struct device device;
@@ -47,6 +52,7 @@ struct ap_matrix_dev {
 	struct list_head mdev_list;
 	struct mutex mdevs_lock;
 	struct ap_driver  *vfio_ap_drv;
+	struct mutex guests_lock;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
-- 
2.35.3

