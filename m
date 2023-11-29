Return-Path: <kvm+bounces-2779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E4227FDA7F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCF55B21874
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3438037142;
	Wed, 29 Nov 2023 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GqmhVTuN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DC7D63;
	Wed, 29 Nov 2023 06:54:15 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATEqY1q016228;
	Wed, 29 Nov 2023 14:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+EpOuQfInHbEJvdxDuaqHuhXP08YQJRjuL00fRbmA0E=;
 b=GqmhVTuNhOeiIQt2V0vpUMwZrvalvlRW0pqOehMbJ6/9nCUynubK4ej27jo1iEhMNGKx
 B3m+nddrbvskF5cESljw3zMkh5zZ2LcukpEpf3FHVW0y328gtSjkbTKWPLVKlUaZ7r6f
 qS+QjINdGQpZ0FQideTF442qUKGgARBttULnIUcryF7Gj0a2Qudl3F/QoLbe9XRbn5xK
 UycL6OjpIpp975aCv2nkf7BLKGHQl7Y+cHGaWhetKBSJ/OyZ/nVbq1sXLzXNj4g0VR3e
 j58BTD1eIQEZfeCqLXgnfAgPQpFFjiIk25Ie11dhUmRjWaHUGd8OweQkV0Mc5VVC/Dk1 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up7ekr33q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:54:13 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ATEqokl017256;
	Wed, 29 Nov 2023 14:54:13 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up7ekr31x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:54:13 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATEGmdk001601;
	Wed, 29 Nov 2023 14:54:11 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukvrkqpsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:54:11 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ATEsA9E7144036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 14:54:10 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60BD75805B;
	Wed, 29 Nov 2023 14:54:10 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E04BC58058;
	Wed, 29 Nov 2023 14:54:08 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.149.198])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Nov 2023 14:54:08 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com, kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Anthony Krowiak <akrowiak@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH v4 2/3] s390/vfio-ap: set status response code to 06 on gisc registration failure
Date: Wed, 29 Nov 2023 09:54:00 -0500
Message-ID: <20231129145404.263764-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129145404.263764-1-akrowiak@linux.ibm.com>
References: <20231129145404.263764-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dhI5mwr8kUFyWoWLQWXYiL_WS4tDiQ-0
X-Proofpoint-ORIG-GUID: _nCNU8Oatca5MMW-6pr43PRL2zaVCh8G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-29_12,2023-11-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311290113

From: Anthony Krowiak <akrowiak@linux.ibm.com>

The interception handler for the PQAP(AQIC) command calls the
kvm_s390_gisc_register function to register the guest ISC with the channel
subsystem. If that call fails, the status response code 08 - indicating
Invalid ZONE/GISA designation - is returned to the guest. This response
code is not valid because setting the ZONE/GISA values is the
responsibility of the hypervisor controlling the guest and there is nothing
that can be done from the guest perspective to correct that problem.

The likelihood of GISC registration failure is nil and there is no status
response code to indicate an invalid ISC value, so let's set the response
code to 06 indicating 'Invalid address of AP-queue notification byte'.
While this is not entirely accurate, it is better than setting a response
code which makes no sense for the guest.

Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9cb28978c186..25d7ce2094f8 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -393,8 +393,8 @@ static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
  * Register the guest ISC to GIB interface and retrieve the
  * host ISC to issue the host side PQAP/AQIC
  *
- * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case the
- * vfio_pin_pages failed.
+ * status.response_code may be set to AP_RESPONSE_INVALID_ADDRESS in case the
+ * vfio_pin_pages or kvm_s390_gisc_register failed.
  *
  * Otherwise return the ap_queue_status returned by the ap_aqic(),
  * all retry handling will be done by the guest.
@@ -458,7 +458,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 				 __func__, nisc, isc, q->apqn);
 
 		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
-		status.response_code = AP_RESPONSE_INVALID_GISA;
+		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
 		return status;
 	}
 
-- 
2.41.0


