Return-Path: <kvm+bounces-3925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCD280A8BB
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEB3F1C208E3
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD2A38F91;
	Fri,  8 Dec 2023 16:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QBxTVyba"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2D2173F;
	Fri,  8 Dec 2023 08:23:08 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GID0j020666;
	Fri, 8 Dec 2023 16:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BrL9cLcoos8OUrrFviFcgpkOZczpwLcNVeseNGIUVoI=;
 b=QBxTVybaw8Csng1wsQyksoK7MAoNvGaZ181iAvZHRYdVGe7hXa1fGx6QkZ8ZzjrZc3mQ
 lnp8AU/FiOVF0f+8lWA1BZqo/mq0ejhmtbiaJ4drPgaA+mrcqYXV1rqJLiA+Yc1EQ1mU
 tSPe7SP4Euu436YWklO8W+nvY+Q7d0PspU23iM7MPdztOcHUN0fcdfJhSEsjTYSZ1CUL
 18Exen6SNaacDexAiQYxN7IlKDwo+zqezoLrIjQ7DVk/b9us8F+Q3zklMZZJhVJk+7ck
 kr3rZnamRd5BL3J2Ew2w7l2OZ4xpiIF6O36h3tQUrvS/W61PT1PAtvV5eMB7lLMbZuCe BA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv6htr6bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:06 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B8GIgJQ022621;
	Fri, 8 Dec 2023 16:23:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv6htr6b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:05 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GLjU1001561;
	Fri, 8 Dec 2023 16:23:04 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utav2tjf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:04 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B8GN3RI60686616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 16:23:03 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90F7058054;
	Fri,  8 Dec 2023 16:23:03 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AB7C5803F;
	Fri,  8 Dec 2023 16:23:02 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.47.9])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 Dec 2023 16:23:02 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: [PATCH v1 3/6] s390/vfio-ap: let 'on_scan_complete' callback filter matrix and update guest's APCB
Date: Fri,  8 Dec 2023 11:22:48 -0500
Message-ID: <20231208162256.10633-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231208162256.10633-1-akrowiak@linux.ibm.com>
References: <20231208162256.10633-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SfTKicTGCbIMKwWGabBkNUbRK9MIUwcR
X-Proofpoint-ORIG-GUID: qMPkzXcrSBIXq6dqE6c5cwqjdHUQark_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_11,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080135

When adapters and/or domains are added to the host's AP configuration, this
may result in multiple queue devices getting created and probed by the
vfio_ap device driver. For each queue device probed, the matrix of adapters
and domains assigned to a matrix mdev will be filtered to update the
guest's APCB. If any adapters or domains get added to or removed from the
APCB, the guest's AP configuration will be dynamically updated (i.e., hot
plug/unplug). To dynamically update the guest's configuration, its VCPUs
must be taken out of SIE for the period of time it takes to make the
update. This is disruptive to the guest's operation and if there are many
queues probed due to a change in the host's AP configuration, this could be
troublesome. The problem is exacerbated by the fact that the
'on_scan_complete' callback also filters the mdev's matrix and updates
the guest's AP configuration.

In order to reduce the potential amount of disruption to the guest that may
result from a change to the host's AP configuration, let's bypass the
filtering of the matrix and updating of the guest's AP configuration in the
probe callback - if due to a host config change - and defer it until the
'on_scan_complete' callback is invoked after the AP bus finishes its device
scan operation. This way the filtering and updating will be performed only
once regardless of the number of queues added.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 47232e19a50e..26bd4aca497a 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2083,9 +2083,22 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	if (matrix_mdev) {
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
 
+		/*
+		 * If we're in the process of handling the adding of adapters or
+		 * domains to the host's AP configuration, then let the
+		 * vfio_ap device driver's on_scan_complete callback filter the
+		 * matrix and update the guest's AP configuration after all of
+		 * the new queue devices are probed.
+		 */
+		if (!bitmap_empty(matrix_mdev->apm_add, AP_DEVICES) ||
+		    !bitmap_empty(matrix_mdev->aqm_add, AP_DOMAINS))
+			goto done;
+
 		if (vfio_ap_mdev_filter_matrix(matrix_mdev))
 			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 	}
+
+done:
 	dev_set_drvdata(&apdev->device, q);
 	release_update_locks_for_mdev(matrix_mdev);
 
-- 
2.43.0


