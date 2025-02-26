Return-Path: <kvm+bounces-39314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF4DA468F0
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:08:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4785A3B025A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5697B233723;
	Wed, 26 Feb 2025 18:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C9gUKM+M"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DE7237A3C;
	Wed, 26 Feb 2025 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593172; cv=none; b=JuHeJWPaXsVFvwudIPeQRzXtyO0vYlum/mLpXeSJsiZHB0UlkOPm61tak73KFUxl/YmRWp7bqLggbkKxRN2Xu1/IFCY6ad6p+m/Lg6kwj61JxgP2nH/XtTEmdGnvq4PMXD3KM+EgQ6Zqlh5GFwzZFuslqMgTQPROhRcIxKtR18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593172; c=relaxed/simple;
	bh=M2GCDMYXKPzt4/PvhKj/HcIFWZLwVtUlCbkxo1QG6DM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=inwmi9Jk4PV+ruYVez06KdpzcRXy+NW7AtrCW0+JaDZKSD68bJbhrnPH0Ea58N/PIMjNq1+LvTeCJICT5CQGJ0sK0RBtJtxItmi6kPKgmUNW74DilorKTIFw/Bt2okqvTcdDOf1ppbjTldF1/1KHMHn4NfqAWN8YBUOUTJzKIv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C9gUKM+M; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QFLekO006009;
	Wed, 26 Feb 2025 18:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=45xki2fgtNR5LipFcaj+LgyMGswOAgaJe1VLNBDG1
	YY=; b=C9gUKM+MlmZgHhOhgRf21EQkGKo7gncmaVukLipGJ+OptbgjuRkEMmn+O
	w/HRDaRqPynS+wtc/6RkysGqlmOwfrjCoea73egGgzEJMSVWgcfxEziVInkQi57v
	D68Zkel6sKUwbgjHlsRybNV6K1Gi6SOX22G7mkIMszGNbEKi9BC0deUpakBnQIhM
	gTwng99pkQpAb6RJxmB2jw7Ekp+LnT1BAXLKRyoWh921S+fGDEqU/8zTUSQphkHZ
	2jLB3Tu9peY3x3AV3kc0wCK9x6r0KfhhkPiiMhX04bL7REFqFCoRTCulGAKCiWJ0
	t85KHYvgQCamlNEgkeaymdSoYLhxA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451xnp32dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:06:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QG0E2X027390;
	Wed, 26 Feb 2025 18:06:08 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ytdkm21y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:06:07 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QI66Pe23790292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 18:06:07 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDAF85803F;
	Wed, 26 Feb 2025 18:06:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2872C58061;
	Wed, 26 Feb 2025 18:06:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.248.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 18:06:06 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v3 0/2] Eventfd signal on guest AP configuration change
Date: Wed, 26 Feb 2025 13:06:03 -0500
Message-ID: <20250226180605.15810-1-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eavvfycujSBJpvXB4jnygOtEBBJ0BrYY
X-Proofpoint-GUID: eavvfycujSBJpvXB4jnygOtEBBJ0BrYY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=865 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260142

Changelog:

v2:
- Fixing remove notification for AP configuration

v3:
- rebased the first commit b26ed71f9647 ("s390/vfio-ap: Signal eventfd when
guest AP configuration is changed") since I moved 
signal_guest_ap_cfg_changed(matrix_mdev); to function vfio_ap_mdev_request
- Fixed commit message to give details regarding my changes for commit
76cd7c4edebf ("s390/vfio-ap: Adding mdev remove notification")

--------------------------------------------------------------------------

The purpose of this patch is to provide immediate notification of changes
made to a guest's AP configuration by the vfio_ap driver. This will enable
the guest to take immediate action rather than relying on polling or some
other inefficient mechanism to detect changes to its AP configuration.

Note that there are corresponding QEMU patches that will be shipped along
with this patch (see vfio-ap: Report vfio-ap configuration changes) that
will pick up the eventfd signal.

Rorie Reyes (2):
  s390/vfio-ap: Signal eventfd when guest AP configuration is changed
  s390/vfio-ap: Adding mdev remove notification

 drivers/s390/crypto/vfio_ap_ops.c     | 65 ++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 include/uapi/linux/vfio.h             |  1 +
 3 files changed, 67 insertions(+), 1 deletion(-)

-- 
2.48.1


