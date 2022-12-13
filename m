Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AEC64B8E1
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiLMPpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiLMPpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:45:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E0620BF6;
        Tue, 13 Dec 2022 07:44:51 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDE94u7024712;
        Tue, 13 Dec 2022 15:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dYhjc5kWligafOgB8GuVnFGfTxaEiO4j/8IIwD5XiyY=;
 b=kRFtQSZVJXvCGvpxfXK0gZgaEBMy625C0R0wvE+6K/UckxoFkOfyz5jkf5kZ6KDi0N4l
 x80IMvjEdX6W1od2vTYwF6WVMvKgdVYwtwD9X1gxrWkUFWmW9zcKcWqKS2F9lxe1N4CO
 ks7MnPBor2ffacjvN5QsdXXZWlqehVPqm3Wx9zb1ZKY2klH2BKNoc9tCuuuYqHIgpddv
 ohPEiL5fhK3IyT/rymossDtQfDsJ7GJNX3hBE8vtrpgiDcaoE8OD2jLerfa8YkGVXWtY
 j/lNkluZW/4oPWXS0pMdUvrrd8yagGYADL2xZhwLZAx2uMOSeyKklH2f8tk//yC4PFIZ GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merrwx62t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDE9Ita025290;
        Tue, 13 Dec 2022 15:44:47 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merrwx62g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:47 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDF0AV9014246;
        Tue, 13 Dec 2022 15:44:47 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mchr71ark-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:47 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFijPL12386904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:45 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E66E458062;
        Tue, 13 Dec 2022 15:44:44 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1756A58061;
        Tue, 13 Dec 2022 15:44:44 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:43 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 7/7] s390/vfio_ap: always clean up IRQ resources
Date:   Tue, 13 Dec 2022 10:44:37 -0500
Message-Id: <20221213154437.15480-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0bc9XSk5zSCN7iKKkVrxs2D9oINrkIKo
X-Proofpoint-GUID: jtn6kGRV9ID3adBZ7aPC5x3iDqPs2fcn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 phishscore=0 mlxscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up IRQ resources even when a PQAP(ZAPQ) function fails with an error
not handled by a case statement.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e80c5a6b91be..2dd8db9ddb39 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1676,7 +1676,7 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
 		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
 		     status.response_code);
-		return -EIO;
+		break;
 	}
 
 	vfio_ap_free_aqic_resources(q);
-- 
2.31.1

