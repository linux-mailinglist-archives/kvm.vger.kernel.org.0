Return-Path: <kvm+bounces-23630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A97AD94C077
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB2631C25F04
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9DD18F2CA;
	Thu,  8 Aug 2024 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M1lmXShS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EBB18C321;
	Thu,  8 Aug 2024 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723129307; cv=none; b=Qa++gqQXYAwtkeRtbdLPhqV+nQQprwtNXYLA1BW5jdtmB+Lf4G94Z5lQSqCxd4w2yvTRQYI+NEPILKZx9e//FYXMJLf00vZ8Qwunp9Xtz/fJGY11sqUA4DLQFegA9qPe+nYJcFZ2UAvrksBcCrBT5RxkurBuvNeNiQdUPGSeZbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723129307; c=relaxed/simple;
	bh=9e4wjzp0e1e7SRkcMRAhZaNNaTtr1K3WnMN4766ZiFc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NmPXDG8diXvCnR0o06XYJAmPlnTcNtiMV0kiRRIAk0o4hXzJ/4cls9KpA9F7ADl8HYXxLYoe7nVQRd5VzPoAFVeEXb93uueKT2AuygmoWv8k0TLXtfO5gPw9IKAzpSmcfvyrSuyduitkN/O5J1T//FVyLAVVlrDGXZwZrT6LcPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M1lmXShS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478CaRgc007476;
	Thu, 8 Aug 2024 15:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=hqYZ71vgm59bmStqe+W7m9vOR1J+RaoL268X2LS
	X3Lg=; b=M1lmXShScKnILxJEq5Zf96tCK+jXuj6wo6/HJNAgqHD5LE5IWyxQSPy
	EMTiQcV7NLYoH5EXRJ+oLDX0Ju6YbYm20WKvOqkmRpAQZExiTh0TvHk6+8Royr6T
	Obve83NLdyKSWOVRHbrDRtpe6M3FzW436WdRJ7F69kU7Q49T/94y8yAYdiF+qc5e
	7EiJUNIuBeYDuM1Yu4IcmC2+cQ94o4mZXDZFXrKgZ8yyfWH/mIuSoXpCnzJfiIms
	pnndP1uJeKMOPeKTCfobHRlOgJMsGY1CUdRaETSf7ZNxGirwy0TS14NI1H25owNf
	pKIdK4/1P3D7roVD/KRPP3fHxbxXKvw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40vwkbrdn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:36 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 478F1ZsL031565;
	Thu, 8 Aug 2024 15:01:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40vwkbrdn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 478EQjs5018618;
	Thu, 8 Aug 2024 15:01:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40sxvuf3r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:34 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 478F1T2B50987370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Aug 2024 15:01:31 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62A2720040;
	Thu,  8 Aug 2024 15:01:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5F1F20075;
	Thu,  8 Aug 2024 15:01:28 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.38.33])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Aug 2024 15:01:28 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/2] KVM: s390: Fixes for 6.11
Date: Thu,  8 Aug 2024 16:52:11 +0200
Message-ID: <20240808150026.11404-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y9SnwOJ6ZAO5nwvk-CZocBydsnUMF6Vm
X-Proofpoint-ORIG-GUID: A73dzeWco_NmcDYCAYa7UYhDSyWOZLEZ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_15,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=709 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408080103

Paolo,
two fixes for s390.

Turning gisa off was making us write an uninitialized value into the
SIE control block due to the V!=R changes.

Errors when (un)sharing SE memory which were previously unchecked are
now resulting in panics since there's nothing that the guest can do to
fix the situation.

Please pull.

The following changes since commit de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed:

  Linux 6.11-rc2 (2024-08-04 13:50:53 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.11-1

for you to fetch changes up to cff59d8631e1409ffdd22d9d717e15810181b32c:

  s390/uv: Panic for set and remove shared access UVC errors (2024-08-07 11:04:43 +0000)

----------------------------------------------------------------
Fix invalid gisa designation value when gisa is not in use.
Panic if (un)share fails to maintain security.
----------------------------------------------------------------


Claudio Imbrenda (1):
  s390/uv: Panic for set and remove shared access UVC errors

Michael Mueller (1):
  KVM: s390: fix validity interception issue when gisa is switched off

 arch/s390/include/asm/uv.h | 5 ++++-
 arch/s390/kvm/kvm-s390.h   | 7 ++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.46.0


