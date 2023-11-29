Return-Path: <kvm+bounces-2780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4EE27FDA80
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:54:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 215A61C20BFE
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBC437151;
	Wed, 29 Nov 2023 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nfYlBzi8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ECDD71;
	Wed, 29 Nov 2023 06:54:17 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATEX54f008058;
	Wed, 29 Nov 2023 14:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gQ2tRQf+68bvSbGEJ8gu3v6Z8ALX4GNpA2mskZujjWU=;
 b=nfYlBzi8bAXkRCwvs9vFflyH1ujTSl/JFYIWSR1wtKVZmCf00QgPXtgxvwBhKoJE1XrO
 VHewXDivXK8LHIUvgoqIyszkmEV4G0i9s5C85W/86UPOII6d6MnKJZ2JzTNhRQ9t+LPP
 T5acEDvqcjyu3dEKtJmVDe4IY+hJnuAh6bcr/LVCjZtt3MDLWJOoTCz4E/zqxZmGY/N6
 9A2NIv8s+qGgeOVW2qalwdNx+bjsFjM2zIl6YI0+/EBG1lvmxKmpRO3IblMezmmADe81
 uK2j+RxfM/7rgowdwrrUQUcRwZHT3gKNM8hAzpB9y6JL2Va8Xo3McPwlobxIQZjzm7mq yA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up75k0t8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:54:16 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ATEX8qJ008266;
	Wed, 29 Nov 2023 14:54:15 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up75k0t6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:54:15 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATEA4Mc001570;
	Wed, 29 Nov 2023 14:54:13 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukvrkqpt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 14:54:13 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ATEsC9k60490188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 14:54:12 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E32BB58059;
	Wed, 29 Nov 2023 14:54:11 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E5295805F;
	Wed, 29 Nov 2023 14:54:10 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.149.198])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Nov 2023 14:54:10 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com, kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH v4 3/3] s390/vfio-ap: improve reaction to response code 07 from PQAP(AQIC) command
Date: Wed, 29 Nov 2023 09:54:01 -0500
Message-ID: <20231129145404.263764-4-akrowiak@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 3PA_vC7PtRSxkly3Ne-XRzauRAhKhgj0
X-Proofpoint-GUID: uAbvgehF6t-bRiDExcW8kfCdpRrcFuKC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-29_12,2023-11-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311290113

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


