Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E65638A7C
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiKYMna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiKYMnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA841B1D3;
        Fri, 25 Nov 2022 04:43:12 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APBsW2t011432;
        Fri, 25 Nov 2022 12:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=2CqgAaLh3fYGzHXPsebYmCTiXSfXycfzn/cC3hiy7ws=;
 b=ix9FdMKigEWmFxQxXP6+gxwM13UCVjUoPiPOli80tzqnUf70Dk0gyXtjE6a27o/AHpjt
 iHeSnWZxWHDSCL/j415jTRRJbchyE4PCvAQGj9cRvn6vE/HyfnZxdtak7pdoIGO6wY5Y
 viuYCBEDQqfuEjdcz1DI/XsVseXif/9wAd1Edxu9qFCAweSKIWQ3XcxxI7cgRZfS1djG
 ZoDqoLIsBINToHjwEkiRRK3iZr6Zylp0HNq+u9y1vKdc+eYinTqkpwWea+177wMjYCgv
 Hy1pIpUq6pYgCf8QM+mY4MyRMnF09YXNbFzUtnlAa9bAaW8nHEXZ/VwPjocudXrHf64P dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2w7ys24u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:11 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCcIM9006515;
        Fri, 25 Nov 2022 12:43:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2w7ys23k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCaVhx014323;
        Fri, 25 Nov 2022 12:43:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj6xap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCh3f73736202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:43:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14FE4C046;
        Fri, 25 Nov 2022 12:43:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 484674C044;
        Fri, 25 Nov 2022 12:43:03 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:43:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: [GIT PULL 14/15] s390/vfio-ap: GISA: sort out physical vs virtual pointers usage
Date:   Fri, 25 Nov 2022 13:39:46 +0100
Message-Id: <20221125123947.31047-15-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6MqvOSi40gnfEYziSdjs6rAw5VeFhqno
X-Proofpoint-GUID: lo7wQ860--gRQbIxyvFgr3fVMNoTvm86
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Fix virtual vs physical address confusion (which currently are the same)
for the GISA when enabling the IRQ.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20221118100429.70453-1-nrb@linux.ibm.com
Message-Id: <20221118100429.70453-1-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
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
2.38.1

