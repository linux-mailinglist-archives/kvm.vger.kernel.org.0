Return-Path: <kvm+bounces-1359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 693BE7E6FE6
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 18:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA60BB20F45
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 17:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7770F21A12;
	Thu,  9 Nov 2023 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mppCgzg8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503D82032E
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 17:11:46 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987AB30D0;
	Thu,  9 Nov 2023 09:11:45 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9HB1We032505;
	Thu, 9 Nov 2023 17:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nrvFh2fd1vzzeix+pUFKXs76rwQENYotxEwliyOjHjs=;
 b=mppCgzg83eQqwNqBiPisYmeng6Rd5Ip0c9BpiJKQ6bDZjAhW2W7csW1bNBhltBI17phj
 oWnpHCyj8sBgsSRaPg+gRg8IFbqIQpK8Dn78npBRy9TpmC+bPIanqNTY29/4uozcrBoI
 BDSsnoM37UpOIRknqe+pLdBOfCfBSHsWCPGccPej/MuZi4vWPdN7C9ws0zfbmz1LKdqP
 6skQv/8nJfqgb2wzjULi77Gz8opQgvH4ZEQro/TRbwv+YO9D5AZmnDmJqThU25eOVWKP
 VG3EeGXWdUvN1ptUIGifJchIl3KG2WtiKg4uP6C8+u7JpNZlcxofWDijyE3i2uiXXecR Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u93kh00hu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 17:11:44 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A9GlaFI003039;
	Thu, 9 Nov 2023 17:04:21 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u937fgjs1-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 17:04:21 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9GedSi019261;
	Thu, 9 Nov 2023 16:44:50 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w2450s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:44:50 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A9Gin1O57737590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Nov 2023 16:44:49 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 707D858056;
	Thu,  9 Nov 2023 16:44:49 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7A4C58052;
	Thu,  9 Nov 2023 16:44:41 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.74.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Nov 2023 16:44:41 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        Anthony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/3] s390/vfio-ap: unpin pages on gisc registration failure
Date: Thu,  9 Nov 2023 11:44:20 -0500
Message-ID: <20231109164427.460493-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231109164427.460493-1-akrowiak@linux.ibm.com>
References: <20231109164427.460493-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OfAmeZntrcJGE9U2PyCJyHushi2tsG0K
X-Proofpoint-GUID: iZzwxLJnwPbe6dLupgpxAUiVeOrS-imM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_14,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090130

From: Anthony Krowiak <akrowiak@linux.ibm.com>

In the vfio_ap_irq_enable function, after the page containing the
notification indicator byte (NIB) is pinned, the function attempts
to register the guest ISC. If registration fails, the function sets the
status response code and returns without unpinning the page containing
the NIB. In order to avoid a memory leak, the NIB should be unpinned before
returning from the vfio_ap_irq_enable function.

Co-developed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
Cc: <stable@vger.kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4db538a55192..9cb28978c186 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
 				 __func__, nisc, isc, q->apqn);
 
+		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
 		status.response_code = AP_RESPONSE_INVALID_GISA;
 		return status;
 	}
-- 
2.41.0


