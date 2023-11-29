Return-Path: <kvm+bounces-2766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E41FA7FD98C
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BD74B2161F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6B831A8C;
	Wed, 29 Nov 2023 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nUXwUblM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDFD19A;
	Wed, 29 Nov 2023 06:35:35 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATEX1M4007854;
	Wed, 29 Nov 2023 14:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=84dgAyyjWyetZQdS5ITnDLJAcSc79AlusTv7kFI15mM=;
 b=nUXwUblM1WYfj7+b8+vyi4NgclDC522CYawTZvmpBQ3jEGYKiXbhur8GrRMRDJF6Mj2s
 /RWFr/XoN35c4w2kJmgKkcMHBC9LSLNSqyCWDnLsyY+HX2izduQ6jc4EplXL4SnyI79d
 1GG1L1YQR5/JaEREne5pRRZ3wM7RWcMkAO0SyxPj8om8NYkGPoqlpHd7XhGt40KWU5w8
 /KZ6RYmzm0+eyxJ/YzNDpyQSB9M4vK5AKv34Oa3h0rFhRYZDzXobpbd1q19UF3OoO2xY
 4vYA9Awbb0354S7M9+RaXtSQSO+bJHBq4W5LJ5Xds28v8VjtW4VlzqbXcTxQgfR4U9ek wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up75k03tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:35:33 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ATEXOvf009646;
	Wed, 29 Nov 2023 14:35:32 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up75k03t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:35:32 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATE6Qe0004403;
	Wed, 29 Nov 2023 14:35:31 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ukwy1y71q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:35:31 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ATEZV1523397088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 14:35:31 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B48C5805F;
	Wed, 29 Nov 2023 14:35:31 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3971558051;
	Wed, 29 Nov 2023 14:35:30 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.149.198])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Nov 2023 14:35:30 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com, kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Subject: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Date: Wed, 29 Nov 2023 09:35:24 -0500
Message-ID: <20231129143529.260264-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Wh_sxyqNi8eoxitQQ6JunvZBuky1cP6p
X-Proofpoint-GUID: 47QYZ6reoqUfJKHJWdjE3qAOhmpsEUSD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-29_12,2023-11-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311290110

In the current implementation, response code 01 (AP queue number not valid)
is handled as a default case along with other response codes returned from
a queue reset operation that are not handled specifically. Barring a bug,
response code 01 will occur only when a queue has been externally removed
from the host's AP configuration; nn this case, the queue must
be reset by the machine in order to avoid leaking crypto data if/when the
queue is returned to the host's configuration. The response code 01 case
will be handled specifically by logging a WARN message followed by cleaning
up the IRQ resources.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4db538a55192..91d6334574d8 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1652,6 +1652,21 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 		 * a value indicating a reset needs to be performed again.
 		 */
 		return -EAGAIN;
+	case AP_RESPONSE_Q_NOT_AVAIL:
+		/*
+		 * This response code indicates the queue is not available.
+		 * Barring a bug, response code 01 will occur only when a queue
+		 * has been externally removed from the host's AP configuration;
+		 * in which case, the queue must be reset by the machine in
+		 * order to avoid leaking crypto data if/when the queue is
+		 * returned to the host's configuration. In this case, let's go
+		 * ahead and log a warning message and return 0 so the AQIC
+		 * resources get cleaned up by the caller.
+		 */
+		WARN(true,
+		     "Unable to reset queue %02x.%04x: not in host AP configuration\n",
+		     AP_QID_CARD(apqn), AP_QID_QUEUE(apqn));
+			return 0;
 	default:
 		WARN(true,
 		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
@@ -1736,6 +1751,22 @@ static void vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		q->reset_status.response_code = 0;
 		vfio_ap_free_aqic_resources(q);
 		break;
+	case AP_RESPONSE_Q_NOT_AVAIL:
+		/*
+		 * This response code indicates the queue is not available.
+		 * Barring a bug, response code 01 will occur only when a queue
+		 * has been externally removed from the host's AP configuration;
+		 * in which case, the queue must be reset by the machine in
+		 * order to avoid leaking crypto data if/when the queue is
+		 * returned to the host's configuration. In this case, let's go
+		 * ahead and log a warning message then clean up the AQIC
+		 * resources.
+		 */
+		WARN(true,
+		     "Unable to reset queue %02x.%04x: not in host AP configuration\n",
+		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
+		vfio_ap_free_aqic_resources(q);
+		break;
 	default:
 		WARN(true,
 		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
-- 
2.41.0


