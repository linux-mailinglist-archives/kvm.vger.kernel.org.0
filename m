Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3A77D8865
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjJZSee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 14:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjJZSec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 14:34:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A4410A;
        Thu, 26 Oct 2023 11:34:30 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QIFPS4016599;
        Thu, 26 Oct 2023 18:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gQ2tRQf+68bvSbGEJ8gu3v6Z8ALX4GNpA2mskZujjWU=;
 b=EgVUcjX9gi5iKuUPgzZMJ956/81pwB9PdPSavzxkHS42FGQbSWRFPyDuuoMMum0bghbb
 Sa5oHo06guwl7qQvyH3F+kJCZdDbMwGm28wpSyTOvh8OqoWiw3k1gDXloRli1gNhbtjP
 dYagM/5NI/eK+GSx0TXWra9OCxRFOHyx+OZsyDjfRBqPg5NAB6v6b3jkcyvvrfUuGk12
 ZtuGS8JU19rNw1cKan3uJ2KWadvv78ybiLo1K8YbdOr6V68isGqGKwMx0qxyZPFsiIZS
 7sk8DomBKNbYFVQOA8uAQkub7HZB1EfxSSNHbogf+NiTh4PJ+H0GnVCoywtwn3BtT16+ 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyw7krgse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:34:29 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39QIT3Ic025190;
        Thu, 26 Oct 2023 18:34:28 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyw7krg80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:34:28 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QIFMTx024368;
        Thu, 26 Oct 2023 18:32:56 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvu6kfs1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:32:56 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QIWtlL17039888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 18:32:55 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 907BC5805D;
        Thu, 26 Oct 2023 18:32:55 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADEAD58052;
        Thu, 26 Oct 2023 18:32:54 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.161.121])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Oct 2023 18:32:54 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 3/3] s390/vfio-ap: improve reaction to response code 07 from PQAP(AQIC) command
Date:   Thu, 26 Oct 2023 14:32:45 -0400
Message-ID: <20231026183250.254432-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231026183250.254432-1-akrowiak@linux.ibm.com>
References: <20231026183250.254432-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TJipFceDFR5kCmyg1yT6h1FStixvQRRh
X-Proofpoint-ORIG-GUID: 739f-32r0wmHfLB-1r0tH6qa8w9zbLEw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_17,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260160
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's improve the vfio_ap driver's reaction to reception of response code
07 from the PQAP(AQIC) command when enabling interrupts on behalf of a
guest:

* Unregister the guest's ISC before the pages containing the notification
  indicator bytes are unpinned.

* Capture the return code from the kvm_s390_gisc_unregister function and
  log a DBF warning if it fails.

Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 25d7ce2094f8..4e80c211ba47 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -476,8 +476,11 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		break;
 	case AP_RESPONSE_OTHERWISE_CHANGED:
 		/* We could not modify IRQ settings: clear new configuration */
+		ret = kvm_s390_gisc_unregister(kvm, isc);
+		if (ret)
+			VFIO_AP_DBF_WARN("%s: kvm_s390_gisc_unregister: rc=%d isc=%d, apqn=%#04x\n",
+					 __func__, ret, isc, q->apqn);
 		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
-		kvm_s390_gisc_unregister(kvm, isc);
 		break;
 	default:
 		pr_warn("%s: apqn %04x: response: %02x\n", __func__, q->apqn,
-- 
2.41.0

