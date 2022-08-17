Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801995979D3
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 00:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238621AbiHQWwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 18:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239076AbiHQWww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 18:52:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143E5A1A52;
        Wed, 17 Aug 2022 15:52:51 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27HMjXMv031163;
        Wed, 17 Aug 2022 22:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kjqno1tiOP4N++s+bVyUcR9syL81bg+A/m/bow7sDfE=;
 b=Ggm3HvLMeDNedBcb28l4/9HEGkrPGqIRpBJXow1ohyNOORHwIceF540zHW55d4RpjdUa
 ayCokiMz3Sr8hNDgqiLMOER3JDbLVejenrq4kUVOqpx04GVs0ACmUgJutORoaXknHNxA
 aBGSwzuZkK1umnpRji7TMRZjBw9C6mwetUsXYmJoK0xPWZbMQvTNh+r8ILCHIN3DcqIa
 SSqNe1nGL4X7sUta1x3ha9fKJs2yCCa3FeQKvCsUgFL648l/iu2OcaW1T39d533ZLYvz
 G3kC3UCVxq6FwpFwZ6TL8Uq8fem6YTU8TeqtcqQXh2/3LNY4WbL4vS0l/34G3vR8IwAu Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j19dj04d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:48 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27HMn9oC011312;
        Wed, 17 Aug 2022 22:52:48 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j19dj04cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:48 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27HMq6xx005575;
        Wed, 17 Aug 2022 22:52:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3hx3kat0hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:47 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27HMqk2W25362762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Aug 2022 22:52:46 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 046EF6A04D;
        Wed, 17 Aug 2022 22:52:46 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C7D06A047;
        Wed, 17 Aug 2022 22:52:45 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.118.205])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 17 Aug 2022 22:52:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: [PATCH 1/2] s390/vfio-ap: fix hang during removal of mdev after duplicate assignment
Date:   Wed, 17 Aug 2022 18:52:41 -0400
Message-Id: <20220817225242.188805-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220817225242.188805-1-akrowiak@linux.ibm.com>
References: <20220817225242.188805-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _BncgllYvXHo8OmI5QqGmFwrXV62FB-1
X-Proofpoint-ORIG-GUID: KtqH4RbkwNFnh2CRffJjdjHDN-s67NV7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_15,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 adultscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208170084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the same adapter or domain is assigned more than one time prior to
removing the matrix mdev to which it is assigned, the remove operation
will hang. The reason is because the same vfio_ap_queue objects with an
APQN containing the APID of the adapter or APQI of the domain being
assigned will get added to the hashtable that holds them multiple times.
This results in the pprev and next pointers of the hlist_node (mdev_qnode
field in the vfio_ap_queue object) pointing to the queue object itself.
This causes an interminable loop when the mdev is removed and the queue
table is iterated to reset the queues.

To fix this problem, the assignment operation is bypassed when assigning
an adapter or domain if it is already assigned to the matrix mdev.

Since it is not necessary to assign a resource already assigned or to
unassign a resource that has not been assigned, this patch will bypass
all assignment/unassignment operations for an adapter, domain or
control domain under these circumstances.

Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6c8c41fac4e1..ee82207b4e60 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -984,6 +984,11 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto done;
 	}
 
+	if (test_bit_inv(apid, matrix_mdev->matrix.apm)) {
+		ret = count;
+		goto done;
+	}
+
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -1109,6 +1114,11 @@ static ssize_t unassign_adapter_store(struct device *dev,
 		goto done;
 	}
 
+	if (!test_bit_inv(apid, matrix_mdev->matrix.apm)) {
+		ret = count;
+		goto done;
+	}
+
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
 	ret = count;
@@ -1183,6 +1193,11 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
+		ret = count;
+		goto done;
+	}
+
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -1286,6 +1301,11 @@ static ssize_t unassign_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (!test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
+		ret = count;
+		goto done;
+	}
+
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
 	ret = count;
@@ -1329,6 +1349,11 @@ static ssize_t assign_control_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (test_bit_inv(id, matrix_mdev->matrix.adm)) {
+		ret = count;
+		goto done;
+	}
+
 	/* Set the bit in the ADM (bitmask) corresponding to the AP control
 	 * domain number (id). The bits in the mask, from most significant to
 	 * least significant, correspond to IDs 0 up to the one less than the
@@ -1378,6 +1403,11 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (!test_bit_inv(domid, matrix_mdev->matrix.adm)) {
+		ret = count;
+		goto done;
+	}
+
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
 
 	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
-- 
2.31.1

