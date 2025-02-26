Return-Path: <kvm+bounces-39310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58915A468D6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 602123AEF2B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDA1233151;
	Wed, 26 Feb 2025 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V2RJRGdr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1120815C0;
	Wed, 26 Feb 2025 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593041; cv=none; b=lDpWKTN+odHji7P4drRNJ/DaVUC0bsou+3lBFzObCYgAcmUeaahT3xmPXQhjPn/Rlcgb3rW3ILLUKaXryb8dKKnbiwYQrVVmrId4kDXMNTu+fP1LxUZVQ6mG4LCb6ahX2tnjdOJ5KLiCGeXcooYuwnXHFh952tviv21+AVF3VbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593041; c=relaxed/simple;
	bh=lqRgiM8UKKa/qnLQeupFH5hkkFUg2xcJa1AOOU+0YZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IFz6EDNQDQcBzYxzmtGNmz8CPuwV1vWtZL9lc3ElkaFueLMWfsg+d1UMnbT6HZfba3ZWsQ225Nnf4X9Ewge0EMBOvPcxnL9lEF2i+RfA27aPKxD2ViwXJvWYbOxFeSjQkU7faw4Cv1YaQM8VsS9tu4SLZdrUm7/7aojs61FkqPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V2RJRGdr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QED371009585;
	Wed, 26 Feb 2025 18:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=LREirHOGGUHKPFwpdp5anEmPVt2NwJOT7yIWk7g11
	FY=; b=V2RJRGdrnJGgOL2T2/6jG5AseKY/WbjNHGvMj/hDpsoC5FZklb3ajuIMw
	7DeAfVX62m7AawA3ZOG37p2LUu4kJscGzUEf6NXEWeIzB78Ng/EHBdHFU/fR4tBB
	+UiZbmosBZNVeOYF2T/qxuOwZ4uNNUHeP7yuvpFr/nQ7XMr0tMZ/u12V1RGjLq9g
	KEjNJkxfATL5DQyUNkScPj/Tho7zojRXdmNfv5vadgP1tut4FsUWF5Z+bP81EYFO
	Mw60iV5BXw+n6QkBxClqBTHMMC/hA1mMZ4PyB1oYq5SOqJg+kCB6iVs1xPpx9xGC
	R/npgIGBCX+6rm79mDt0xzxGgJ3ww==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451ssym764-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:03:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QH7Y4v012465;
	Wed, 26 Feb 2025 18:03:56 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yrwsvcsb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:03:56 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QI3sDw31654466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 18:03:54 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59E065806C;
	Wed, 26 Feb 2025 18:03:54 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CE7658056;
	Wed, 26 Feb 2025 18:03:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.248.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 18:03:53 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v2 0/2] Eventfd signal on guest AP configuration change
Date: Wed, 26 Feb 2025 13:03:51 -0500
Message-ID: <20250226180353.15511-1-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hUit2PvjZ9jqHrU1zzL4QfomYysSIQ9r
X-Proofpoint-GUID: hUit2PvjZ9jqHrU1zzL4QfomYysSIQ9r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=730
 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260142

Changelog:

v2:
- Fixing remove notification for AP configuration

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
  s390/vfio-ap: Fixing mdev remove notification

 drivers/s390/crypto/vfio_ap_ops.c     | 65 ++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 include/uapi/linux/vfio.h             |  1 +
 3 files changed, 67 insertions(+), 1 deletion(-)

-- 
2.39.5 (Apple Git-154)


