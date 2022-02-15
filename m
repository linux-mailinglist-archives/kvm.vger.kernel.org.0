Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A364B5F5C
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiBOAvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiBOAu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:50:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0912813C38D;
        Mon, 14 Feb 2022 16:50:51 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EMA37r022475;
        Tue, 15 Feb 2022 00:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ym3XK5kZu0Ml9DMpBvPE27Y3gXhBSeUfuWDBhs2QCgY=;
 b=CgIimVZzwz/8LoVU6g6igUQ7vbG1LT3+jFbddw+nWgG7VP2C/mefGjbvJJvD5iHAMkVR
 w87RjvYxMpSgp9Mk8Ros0Uk3oVyuX4Do+PclOl/IKXxtWJP4dQioQLnD4cGMG2SWALxi
 ElAB3vlf7EyzwjcE9rKRK80sTBexdxisSa5dHbKDV8Ch+COY+VXOocrLh2BY45cbc6P8
 mU4s3jR8iFg32x+ieISMcKTCB0QcXAIk06lDa2hEI7k+gNv57EZItq6b2VT/kG5H5zEg
 uL7ddn46eLoBx5NS+oIxqkowp2SPgr9TSjTxfDhCBttO8nSgBAitf3SEu246Vx1zE9l5 Rg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e78m10kby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:50 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0g6mt026439;
        Tue, 15 Feb 2022 00:50:49 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 3e64hacpjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:49 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0onNN34341312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:49 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4292124052;
        Tue, 15 Feb 2022 00:50:48 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C891124054;
        Tue, 15 Feb 2022 00:50:48 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:48 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 06/18] s390/vfio-ap: introduce shadow APCB
Date:   Mon, 14 Feb 2022 19:50:28 -0500
Message-Id: <20220215005040.52697-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6AV0YrigNiLOoOQEavf3CQ96NMLHIuep
X-Proofpoint-ORIG-GUID: 6AV0YrigNiLOoOQEavf3CQ96NMLHIuep
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150001
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The APCB is a field within the CRYCB that provides the AP configuration
to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
maintain it for the lifespan of the guest.

The shadow APCB serves the following purposes:

1. The shadow APCB can be maintained even when the mediated device is not
   currently in use by a KVM guest. Since the mediated device's AP
   configuration is filtered to ensure that no AP queues are passed through
   to the KVM guest that are not bound to the vfio_ap device driver or
   available to the host, the mediated device's AP configuration may differ
   from the guest's. Having a shadow of a guest's APCB allows us to provide
   a sysfs interface to view the guest's APCB even if the mediated device
   is not currently passed through to a KVM guest. This can aid in
   problem determination when the guest is unexpectedly missing AP
   resources.

2. If filtering was done in-place for the real APCB, the guest could pick
   up a transient state. Doing the filtering on a shadow and transferring
   the AP configuration to the real APCB after the guest is started or when
   AP resources are assigned to or unassigned from the mediated device, or
   when the host configuration changes, the guest's AP configuration will
   never be in a transient state.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 10 ++++++----
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index aa838ed47406..4b676a55f203 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -336,6 +336,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	matrix_mdev->pqap_hook = handle_pqap;
+	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	mutex_lock(&matrix_dev->lock);
@@ -1185,10 +1186,11 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
-		kvm_arch_crypto_set_masks(kvm,
-					  matrix_mdev->matrix.apm,
-					  matrix_mdev->matrix.aqm,
-					  matrix_mdev->matrix.adm);
+		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
+		       sizeof(struct ap_matrix));
+		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
+					  matrix_mdev->shadow_apcb.aqm,
+					  matrix_mdev->shadow_apcb.adm);
 
 		mutex_unlock(&kvm->lock);
 		mutex_unlock(&matrix_dev->lock);
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index aea6a8b854b3..fa11a7e91e24 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -91,6 +91,7 @@ struct ap_queue_table {
  * @node:	allows the ap_matrix_mdev struct to be added to a list
  * @matrix:	the adapters, usage domains and control domains assigned to the
  *		mediated matrix device.
+ * @shadow_apcb:    the shadow copy of the APCB field of the KVM guest's CRYCB
  * @group_notifier: notifier block used for specifying callback function for
  *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
  * @iommu_notifier: notifier block used for specifying callback function for
@@ -105,6 +106,7 @@ struct ap_matrix_mdev {
 	struct vfio_device vdev;
 	struct list_head node;
 	struct ap_matrix matrix;
+	struct ap_matrix shadow_apcb;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
 	struct kvm *kvm;
-- 
2.31.1

