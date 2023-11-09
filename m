Return-Path: <kvm+bounces-1358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 570777E6F94
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 17:45:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC282B21126
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5862923769;
	Thu,  9 Nov 2023 16:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ciNyRMfz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC0C225B2
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:45:09 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548E646A3;
	Thu,  9 Nov 2023 08:45:08 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9GgNhl026895;
	Thu, 9 Nov 2023 16:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+EpOuQfInHbEJvdxDuaqHuhXP08YQJRjuL00fRbmA0E=;
 b=ciNyRMfzNWmpb6FS67GB6/FbGXWhJHdGXApllhAPcx820jaLH1YijIFUVPBqCkC5cBCk
 2JLct8s9+BTx4/7TIGyOaGU8fPUsmliWfoitwyR+RNRpTbbSgmIHwqbPkhq96Uv6vM6v
 cCVdOggwOvr/rzFsljaCyhOS5L7kPNtfjtg6CfsdOm1e0U/Kb8MHBV6rdd2RIe7sSXx4
 u+CdqWexgbcAu1nJjq+CFi49X6NWmEXVZzWW4hQf9uPmosKQAeQPyoOZZc36QJql55Cp
 XAL/cvVnBMyiqoPXUuSCUgP3IxJ0gW584ZBCmxYs6RTh7HRGeVu+v6amhEVJvGQ4BAfc Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u936783wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:45:07 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A9Ggex6027435;
	Thu, 9 Nov 2023 16:45:00 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u936783vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:45:00 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9ESBsV000667;
	Thu, 9 Nov 2023 16:44:59 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w2351pd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:44:59 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A9Giwxi18678442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Nov 2023 16:44:58 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17D4158065;
	Thu,  9 Nov 2023 16:44:58 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B2715805D;
	Thu,  9 Nov 2023 16:44:50 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.74.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Nov 2023 16:44:49 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        Anthony Krowiak <akrowiak@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH v3 2/3] s390/vfio-ap: set status response code to 06 on gisc registration failure
Date: Thu,  9 Nov 2023 11:44:21 -0500
Message-ID: <20231109164427.460493-3-akrowiak@linux.ibm.com>
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
X-Proofpoint-GUID: wWIYxg1GivBg2FdOSLH41TO4ox4wffPI
X-Proofpoint-ORIG-GUID: kdASUf4BX-yP1q27xfaVezqnTp9xrG9L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_14,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311090127

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


