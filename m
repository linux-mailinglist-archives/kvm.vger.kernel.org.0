Return-Path: <kvm+bounces-1357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 498487E6F93
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 17:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 037CC281156
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABC8225D2;
	Thu,  9 Nov 2023 16:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iLfPKHv3"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485BB20306
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:45:04 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EF844A0;
	Thu,  9 Nov 2023 08:45:03 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9GZZ38012040;
	Thu, 9 Nov 2023 16:45:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gQ2tRQf+68bvSbGEJ8gu3v6Z8ALX4GNpA2mskZujjWU=;
 b=iLfPKHv3wmf7T/KHpuJA5hYZRJh00B/cQrxalHydO+9+5LooeDYYQ81bnIz/W3fydtS/
 KJDaNOm7SDEC00uDmzVkGHKVJykgpmlWEvLT+o2MvLflaYGTd/c9qJGTYyepYyTsI1E9
 Wk4rLJ3p2tLurIK8GuQbo7Y08vFX4HcrV78djqWuiShFIeKU0b72+m3KIVFflMxsc3Zj
 6sLRAQAK0vbwv2geRaoiUmWXtU8oyZmc0QYyZsKiRUQt4zCJ81xg4phi1SiAOOgXCCz0
 De5prVAm2c+pyp58uPR/DmCYMdZbCsoyWd5cqQSeyRVL+UPyZvv8vWMZDyEmvhrP7UlL jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9332gcku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:45:02 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A9GaJf2015609;
	Thu, 9 Nov 2023 16:45:01 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9332gck8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:45:01 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9EMDGt019231;
	Thu, 9 Nov 2023 16:45:01 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w2450t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:45:01 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A9Gj0gQ11665926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Nov 2023 16:45:00 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87F6D58056;
	Thu,  9 Nov 2023 16:45:00 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18EF758052;
	Thu,  9 Nov 2023 16:44:59 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.74.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Nov 2023 16:44:58 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH v3 3/3] s390/vfio-ap: improve reaction to response code 07 from PQAP(AQIC) command
Date: Thu,  9 Nov 2023 11:44:22 -0500
Message-ID: <20231109164427.460493-4-akrowiak@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: XZ8uLpD6hwxVgKkN7MZYFWq_TLcpGXCr
X-Proofpoint-GUID: sUA7RPTBNSLoafyFgIiTZlVhD6pmQIi7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_14,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090127

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


