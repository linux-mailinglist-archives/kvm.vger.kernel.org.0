Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE70162F215
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 11:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbiKRKEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 05:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiKRKEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 05:04:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C983DCE2D;
        Fri, 18 Nov 2022 02:04:36 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI8PSNu011084;
        Fri, 18 Nov 2022 10:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QxKdtcxPvRSoRIcsXpSEVgrRz/pQqipIs/LnErBKEKg=;
 b=JVRYUISQf1jnuVvLZM83jFvP/zrmil0a8GljEl1ltCg0BrZPgaxvVwKsF42R/vufI/yO
 JoUDS5gvoh8uIncd7JSthqsfBkfWTTaf9d73RCi0MN5Xb7PvIj5swW2JC5zDuxztaS2G
 jQmGJhEAgXMKll+4C5OYXre8tRY/4FvkoLAui5u87oYMk7ASCe1I5KYMo6nLRhKWeAkj
 P1CdzsNOL9XqDfvJP5Fy9zVGVKflvNtZo0teuHFxVimpMOwJ76wlLmAKbgkwuyp6DXBy
 DuIiFkWYjFc32rIiCyriTkmBCRYTQZHFtBRe+NdIRqY8fRiVCesm1nJzPBArgCZqmFpo 6A== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kx6hd243h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 10:04:35 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AI9og75005190;
        Fri, 18 Nov 2022 10:04:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kwu4ygra2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 10:04:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AI9wQuZ14746056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 09:58:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 851E5A4040;
        Fri, 18 Nov 2022 10:04:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FF44A404D;
        Fri, 18 Nov 2022 10:04:30 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Nov 2022 10:04:30 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     pasic@linux.ibm.com, akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v2] s390/vfio-ap: GISA: sort out physical vs virtual pointers usage
Date:   Fri, 18 Nov 2022 11:04:29 +0100
Message-Id: <20221118100429.70453-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AzEArjAWd49AaHKPuV1V51kRze2D6lXi
X-Proofpoint-ORIG-GUID: AzEArjAWd49AaHKPuV1V51kRze2D6lXi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211180057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix virtual vs physical address confusion (which currently are the same)
for the GISA when enabling the IRQ.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
v1->v2:
* remove useless cast

 drivers/s390/crypto/vfio_ap_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0b4cc8c597ae..205a00105858 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -429,7 +429,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 
 	aqic_gisa.isc = nisc;
 	aqic_gisa.ir = 1;
-	aqic_gisa.gisa = (uint64_t)gisa >> 4;
+	aqic_gisa.gisa = virt_to_phys(gisa) >> 4;
 
 	status = ap_aqic(q->apqn, aqic_gisa, h_nib);
 	switch (status.response_code) {
-- 
2.37.3

