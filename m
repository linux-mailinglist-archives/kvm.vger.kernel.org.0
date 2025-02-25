Return-Path: <kvm+bounces-39172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E574CA44C1C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 284EA177740
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27E820E71E;
	Tue, 25 Feb 2025 20:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ch7kuwyJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432FE20DD79;
	Tue, 25 Feb 2025 20:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514337; cv=none; b=E3Pv9++9TXTfwP4+1gHlmMrCGfByZTLMekH+tPJoco7wJRGNSG5nOfB2xkF2PUfOoybG39QDRNhHi03pjALfV7ALrr90DSMpBI29YWEgOstdOu/C7EeV+DqAfvmqh7m7IjjQrqAq+rULFvk9GK+FYFGajpUlhlAtz+vvVbt3/0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514337; c=relaxed/simple;
	bh=lqRgiM8UKKa/qnLQeupFH5hkkFUg2xcJa1AOOU+0YZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PXCDBtqQcyHVOFWXoXQ9G+u1y3g5SCJhxlUNViZcp+6+kmzja7pEwcxd4MgceanaNefmrbTz74Fsgo2/aEEqGBxQkjN/HRqfmPovVbl6ALLI2ASowRAm1+J7NrIEMrk3UIWfn7fmQIcxo6Zwabx6EYJClgkSDUqKKsHMW2VIBF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ch7kuwyJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PDjZ29022645;
	Tue, 25 Feb 2025 20:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=LREirHOGGUHKPFwpdp5anEmPVt2NwJOT7yIWk7g11
	FY=; b=ch7kuwyJtirBH1TFXypnApPjEl9lSelj/oMJEvYCl7L6H7py4zLqEKcKr
	h7P49SebqsAvy8t0LUmo0lvQNCXEQrQQdrjg4i2RxQPnBK+kNgdBtYEsxrhylhS0
	zEGMM3iNjdKfE89wOMjz4z7esMHIZIsNIq2It/XSVwfEtH4WPK7VQGtM9gLwGlWY
	p1xAlB7e0jP7p2EkyKnQA3F7qDBk48cY8eDdUfBRIv0ehFBgXOsGZ+wk3dkHv9Nx
	E2GyuiWJrvLa1uAN4fAv8KP3lTXW1wAiTISc5iVf/qT7/ooBypWerziebAMfE3h0
	lutL6PMioRs1qZL7YsHBbGUdlmWiQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4511wadnub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 20:12:12 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51PIjngd027333;
	Tue, 25 Feb 2025 20:12:11 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yum1xf2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 20:12:11 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51PKC9HV21758670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 20:12:10 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C368058052;
	Tue, 25 Feb 2025 20:12:09 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F282358056;
	Tue, 25 Feb 2025 20:12:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.252.67])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Feb 2025 20:12:08 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v2 0/2] Eventfd signal on guest AP configuration change
Date: Tue, 25 Feb 2025 15:12:06 -0500
Message-ID: <20250225201208.45998-1-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QA3rBfCXyNOsWXfF6j-mMiWX2Lt0kuVE
X-Proofpoint-ORIG-GUID: QA3rBfCXyNOsWXfF6j-mMiWX2Lt0kuVE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_06,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=730 mlxscore=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502250120

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


