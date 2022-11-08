Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B5B62182F
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 16:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiKHP0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 10:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiKHP0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 10:26:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12DC57B79;
        Tue,  8 Nov 2022 07:26:16 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8Ex2dL025033;
        Tue, 8 Nov 2022 15:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=x4CSTJH9YDq37OlmIz3PGFvoLcdYEX75rfOsXVHSS6Q=;
 b=CkX+NVTch4eEv4K8QF3i/NfYJW+VzgONmvrF9O+sfAApqGgvISGQ12K1zWHNZulVF8gk
 eNcIgzwM2a0WQEMa5/wwWybXelLT71FzrpIVTPxKgXP/GtS5X338N3vzP+4xc363+JAM
 h45kPVTUWpuYPwnpNQc/ThwAp0j1EOTQAD5BAP3SThwrY0QKA4F8cy8pYavO698A8BVv
 nAWQPbiEMjt2eQWV7Y2+84+KzoSbP2tONPgfi9K9KuKhbkcz71/qVJpVHZmRDLLC9qxl
 VJveWUoZYsI3WlO/2v5UDXZAihsSIDwVVPBBz1/6GzcTL689yI/0k3hcxWsU6n6xE+3W vw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqsbk12f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 15:26:15 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8FJbO9000389;
        Tue, 8 Nov 2022 15:26:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3kngs4k574-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 15:26:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8FQBj31114736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 15:26:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0779AA4051;
        Tue,  8 Nov 2022 15:26:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A43E5A404D;
        Tue,  8 Nov 2022 15:26:10 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 15:26:10 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     pasic@linux.ibm.com, akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v1] s390/vfio-ap: GISA: sort out physical vs virtual pointers usage
Date:   Tue,  8 Nov 2022 16:26:10 +0100
Message-Id: <20221108152610.735205-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d1qFnAv8TjXXTd05m2MxXavnB7exorB1
X-Proofpoint-ORIG-GUID: d1qFnAv8TjXXTd05m2MxXavnB7exorB1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 spamscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080092
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
---
 drivers/s390/crypto/vfio_ap_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0b4cc8c597ae..20859cabbced 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -429,7 +429,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 
 	aqic_gisa.isc = nisc;
 	aqic_gisa.ir = 1;
-	aqic_gisa.gisa = (uint64_t)gisa >> 4;
+	aqic_gisa.gisa = (uint64_t)virt_to_phys(gisa) >> 4;
 
 	status = ap_aqic(q->apqn, aqic_gisa, h_nib);
 	switch (status.response_code) {
-- 
2.37.3

