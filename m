Return-Path: <kvm+bounces-39316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B995A468F8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78AC93B07E8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DDA23536F;
	Wed, 26 Feb 2025 18:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dGnsdQaP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3F123E23C;
	Wed, 26 Feb 2025 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593178; cv=none; b=HEUzoSs4oAridy7mrtmrKBFH5S6ar2RuJX4sM3Z5l8UwW+LfT2fTG/jXLpAfDMk8MCwZuWoHoYXIE1ZuCL5/cHavUM00oJro28gD7Exh1y232y6pNn+1XffIRofJYHXHKl+2kLubFBSt2NU7cgp6DJVBqXMQCL0W1f3QKnFVtfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593178; c=relaxed/simple;
	bh=E8Ecymq8CBrhz4/hOFJWe+WkF4M7ObE/VCe/8ADPU6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnX7eq7IAno21RF/yfROsXM3I9qAbU21uKrcJRBOciDRR9Xq7kcCTwsz9NOsDnd4AP4opN6Ijh6hKtCZaCq35KL7UJwlepHpcC4fiOxBVv171XAcvEwdyspA83wFxpnVAS+vLLg5LtcT2e8BF4832/UB5OVL3T1gQmOxQoXkYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dGnsdQaP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QBGEuZ027849;
	Wed, 26 Feb 2025 18:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=h6zpg6zC5z/rQVzpN
	2FehhGN502lUYMO052KpWM4Tjw=; b=dGnsdQaPH2q/esiRJelYW50b2CveRM4d0
	5ECq6+vtgrHTi8USndDV+Tf4mD1zk97/UumzqqZQQ4Nq+EjhTg+WWZSL/ZyTiOU0
	WqOmRysuEeUyncMg7wwhCVcY4qPz4avEHlLqD7rslvBnQWJxAI89mxiXxKnQVZ9F
	o47YguClcXRl8PIZ4PUzVaDtQEQONqv7dp0rqH7A0cUW0mw7CdDT4j37vlyckjv6
	6paGHCzRi2VSZ/J2PnS7k+i6RD787VcwIVUxhgWDKcs8h+racEBWae4S1mf/Jtc+
	laCUTbr/Sw7DWW/ZsVeno2v7rzZzA3xtp6Mph+NLSZwni6uDQB2bg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451q5jcx27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:06:11 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QFKW6j026269;
	Wed, 26 Feb 2025 18:06:10 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44yswnm53f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:06:09 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QI68ae30737044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 18:06:08 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5CF75805A;
	Wed, 26 Feb 2025 18:06:08 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA3D258056;
	Wed, 26 Feb 2025 18:06:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.248.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 18:06:07 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v3 2/2] s390/vfio-ap: Adding mdev remove notification
Date: Wed, 26 Feb 2025 13:06:05 -0500
Message-ID: <20250226180605.15810-3-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250226180605.15810-1-rreyes@linux.ibm.com>
References: <20250226180605.15810-1-rreyes@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ffL4sV97Vb7PfKd_zhlD1KQ9f-70t_7w
X-Proofpoint-ORIG-GUID: ffL4sV97Vb7PfKd_zhlD1KQ9f-70t_7w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260142

This patch is based on the s390/features branch.

The first patch, b26ed71f9647, was missing a
notification based on the process to remove a
mediated device from the AP configuration. In
the original patch, b26ed71f9647, the guest is
notified immediately for any AP configuration
changes that are queued during the following
processes:
- assign/unassign_adapter
- assign/unassign_domain
- bind/unbind

However, the original patch, b26ed71f9647, was
missing a notification for the process to remove
the entire mediated device.

This patch addresses the missing notification and
successfully notifies the guest when a mediated device
is removed.

Notes:
- Removed eventfd from vfio_ap_mdev_unset_kvm
- Update and release locks along with the eventfd added
to vfio_ap_mdev_request

Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9a6845064ff3..e0237ea27d7e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2056,6 +2056,14 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 
 	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
 
+	if (matrix_mdev->kvm) {
+		get_update_locks_for_kvm(matrix_mdev->kvm);
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		signal_guest_ap_cfg_changed(matrix_mdev);
+	} else {
+		mutex_lock(&matrix_dev->mdevs_lock);
+	}
+
 	if (matrix_mdev->req_trigger) {
 		if (!(count % 10))
 			dev_notice_ratelimited(dev,
@@ -2067,6 +2075,12 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 		dev_notice(dev,
 			   "No device request registered, blocked until released by user\n");
 	}
+
+	if (matrix_mdev->kvm)
+		release_update_locks_for_kvm(matrix_mdev->kvm);
+	else
+		mutex_unlock(&matrix_dev->mdevs_lock);
+
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
-- 
2.48.1


