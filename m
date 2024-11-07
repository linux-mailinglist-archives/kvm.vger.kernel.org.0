Return-Path: <kvm+bounces-31132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 177A69C0A02
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3D601F24EB2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF1321442C;
	Thu,  7 Nov 2024 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="suzxc8UT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04E9212F05;
	Thu,  7 Nov 2024 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993022; cv=none; b=qFtEKM/oHNftYw50f0rYbiHlBeJPcVs2A5U0Nnd0KM/zuuZ32TOGQxWe+Qg+tAmArP6Srw6Zdwt1XRev3MqDOvJ+PsBf4Meom2r1SAjMRKJaUBKAlje2JjMea6RJQs7y7a5vfiz4FVJoni4VG/WPm52PZcRxkm3XFRc9NO+R29w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993022; c=relaxed/simple;
	bh=FKu9032jL3r4/jDRiXUTc/dDnWWJMs3FR1idxnjGxis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLpZWb0AzAuoqDQgcPxXGAvm1jDHoUyog+CivvA4aEV5Q9AMbHIKKYZ6fSB8MoxNU2UAORF8nNvT7Z17MhjTc11+gJN8SmhDzht4jMD+YigVeOJ2/RxUl3jBiH937ulhjvbPjXD61fWH5g99yvz31XEsjba/1fENXCaFY2qBCEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=suzxc8UT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7EeIR0027775;
	Thu, 7 Nov 2024 15:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=UxuAAutmpCp5YJxt37n+4R828bFO9y5Na6Ji2s5UF
	wc=; b=suzxc8UTF88Ay1PZ7EDGXysAfJuolyYmWc/NijCIJSByU6nVFkQqsBqaH
	ValOeNL8sEBj99dF5U/sVAFSgvD+ZegJGNJQqkfVHdnHeb7+M4CYtWPv7dmhZl4v
	z7VT2C42ZL29X5RBjT6lJUZsi3IcPozfbY7FC67bYfGUFL8jRRMQICfSxg+Vg2Co
	DNb21AF4xRutb+gOAKsYdZJPex4sSO0McDfu4pQZbrd7pU2HqBKvNIiojjRrT2/G
	/yMI3GMA3wZcWSGnr3o5keLFd5CxdjE026yLrCDTo7JV0ockPYwC+GFub0hbseOs
	uCxGEcvpCHaNXju5C4X/C0oiByMow==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42rygs883g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7Dm3Ud008433;
	Thu, 7 Nov 2024 15:23:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nywm7gk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:36 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A7FNXvF45089250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Nov 2024 15:23:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F234320049;
	Thu,  7 Nov 2024 15:23:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA18720040;
	Thu,  7 Nov 2024 15:23:32 +0000 (GMT)
Received: from vela.boeblingen.de.ibm.com (unknown [9.155.210.79])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Nov 2024 15:23:32 +0000 (GMT)
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH 0/4] KVM: s390: CPU model for gen17
Date: Thu,  7 Nov 2024 16:23:15 +0100
Message-ID: <20241107152319.77816-1-brueckner@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uWfJAuR1X79HpTRWBmtdkcIBUZ6TCGKQ
X-Proofpoint-GUID: uWfJAuR1X79HpTRWBmtdkcIBUZ6TCGKQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=928 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2411070114


Adding gen17 features to the CPU model for features that are
(partially) handled or indicated by KVM.  Those comprises of:

- Concurrent-function facility with subcodes
- More vector extensions
- Ineffective-nonconstrained-transaction facility
- Even more msa crypto extensions

Feedback and review is always welcome.  Thanks a lot!


Hendrik Brueckner (4):
  KVM: s390: add concurrent-function facility to cpu model
  KVM: s390: add msa11 to cpu model
  KVM: s390: add gen17 facilities to CPU model
  KVM: s390: selftests: Add regression tests for PFCR subfunctions

 arch/s390/include/asm/kvm_host.h              |  1 +
 arch/s390/include/uapi/asm/kvm.h              |  3 +-
 arch/s390/kvm/kvm-s390.c                      | 43 ++++++++++++++++++-
 arch/s390/kvm/vsie.c                          |  3 +-
 arch/s390/tools/gen_facilities.c              |  2 +
 tools/arch/s390/include/uapi/asm/kvm.h        |  3 +-
 .../kvm/s390x/cpumodel_subfuncs_test.c        | 15 +++++++
 7 files changed, 65 insertions(+), 5 deletions(-)

-- 
2.43.5


