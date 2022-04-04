Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4938D4F1F7E
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbiDDWyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiDDWxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46B34B42D;
        Mon,  4 Apr 2022 15:11:58 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234IeCJJ025482;
        Mon, 4 Apr 2022 22:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ws6CrmWi87N6LqNCzoGXGvdA6PqsLWDTk52hzu/qUJc=;
 b=eniPLgAHDLLvFrE4wvU8P+1TywJWcGVVBorBBR+P+0RcR3YHZFQeVFSQNVDLWYtqpFTE
 Mkt6HqfBP6b9nRXYuMHVB3y4/fX1dQ2aKNyLj5OVg0mfbYiuIXfmDaLGW+yZMtqBfLBp
 jdvFhDU6kCV9ajkuHXiFKisvdXD1JyVUUIP+1lLxIsm/Lv3xNRvN94kX7FwLWToCFpVo
 v3t73ixISMlIDl/wLusi9JubfW1iY4EUDsGYJbq+tLjJ7u8YyO3wHHqbvMtVrArzdLQa
 Vrp6PZCtk9qyX0BexF0twDJHNCPAdrQE6lUmBGmnXoV+hsK4+RD3tDN2qQ6pmKifRYow jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy1d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234LqjET006636;
        Mon, 4 Apr 2022 22:11:56 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy1cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:56 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lqxeg020771;
        Mon, 4 Apr 2022 22:11:55 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3f6e49f92b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:55 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBsk529819150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6581E7805F;
        Mon,  4 Apr 2022 22:11:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BC937805C;
        Mon,  4 Apr 2022 22:11:53 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:53 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 08/20] s390/vfio-ap: introduce new mutex to control access to the KVM pointer
Date:   Mon,  4 Apr 2022 18:10:27 -0400
Message-Id: <20220404221039.1272245-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fPUp2ST58Xzgew448yH0IYsGTIkNPvyY
X-Proofpoint-ORIG-GUID: 2iv715rQWlP4nseeEk3iJeQ3w6mf54Cm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 drivers/s390/crypto/vfio_ap_drv.c     | 1 +
 drivers/s390/crypto/vfio_ap_private.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 0a5acd151a9b..c258e5f7fdfc 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -161,6 +161,7 @@ static int vfio_ap_matrix_dev_create(void)
 
 	mutex_init(&matrix_dev->mdevs_lock);
 	INIT_LIST_HEAD(&matrix_dev->mdev_list);
+	mutex_init(&matrix_dev->guests_lock);
 
 	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
 	matrix_dev->device.parent = root_device;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 5262e02192a4..ec926f2f2930 100644
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
2.31.1

