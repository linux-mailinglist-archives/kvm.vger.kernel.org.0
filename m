Return-Path: <kvm+bounces-31628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F839C5D1B
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D4D6282E7A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF50205AB8;
	Tue, 12 Nov 2024 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZGxRD7Il"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D223205159;
	Tue, 12 Nov 2024 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428774; cv=none; b=fshuEk4KXayim6sxQBtTfE1P7eJsyE9nk2MDvt4KDJFLr+vRDQQzfNrWrWf7DkbEh+YPIAyB6LW2hYmTnYT2sxHVTjOfdrv05avcIjz78Mn0irNdQEse5pdfWQKnJrbhx3vIVuy4EgNBLjLX4A7IcY95U9nFss1t4fTVugzAjuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428774; c=relaxed/simple;
	bh=JZuoCG6oijnRFAblPSH10XOy0kaiWYPSoXObHqqLypA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uhzflSfD9c8gUDHlHHjjiOUqsgwP0c/zq2iZvIrBmL/DkEgtTREIfaJcjnW3Cni2lb8rwq1bgbXJ0rWEH50vGnSyaaNjP31dP4bpMSgRxY1C43PZqxb/5vvWExZ/WJzexxML1ugwwygl4hlvp7Pqa/aWfzvmpc7DVzKQ9UFetmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZGxRD7Il; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACBeXLD027224;
	Tue, 12 Nov 2024 16:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=DRGzSLNJfbck7ghy6TWGkkbHBMLDpt/neVeAdLpoO
	wU=; b=ZGxRD7IlgOQrlPwmUoRnpmazei5FdsKEl2pvNgh8pHeBUqsdGGDhh6i+h
	2c4LNGQ1NR0PmEZba74OHqZMyg4uIhfr97bl4Zwvo0zh23ZGkQ5xbABl3HXWvMSj
	WB2d9pzEKekNV/r0/IrveS1MOxZpW/yeitU1ItkyJLvgDl6bHSNTtFnqC0abYj1S
	/2RrCTS02f975lx8Dp+UMqpxzqH8pEzX7E9g8vDCHWvJLhYBQDlv+8dgWuHgeGl3
	0y1scD/r4tg0TPP58McVWBUeKfL2C3okJyuTALsTDnd1M+MHWkOTZvU3F6BcNjHI
	ut+ay1lTo58m5TxHSwRjn9NZtsQpQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v6beh7t2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:10 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC95p7v002886;
	Tue, 12 Nov 2024 16:26:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tm9jcen6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:09 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQ6v449086918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EE0920049;
	Tue, 12 Nov 2024 16:26:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C273620040;
	Tue, 12 Nov 2024 16:26:05 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:05 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com
Subject: [GIT PULL 00/14] KVM: s390: pull requests for 6.13
Date: Tue, 12 Nov 2024 17:23:14 +0100
Message-ID: <20241112162536.144980-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: z8qVzIq1IysZHnm7ecvafPkHpc6lSlTd
X-Proofpoint-GUID: z8qVzIq1IysZHnm7ecvafPkHpc6lSlTd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2411120128

Paolo,

here's the second and final tranche of ucontrol tests together with
cpumodel sanity tests and the gen 17 cpumodel changes.

Heiko and I decided to move the uvdevice patches through the s390
kernel tree since a set of crypto changes depend on them and we didn't
feel like creating a topic branch.

Please pull.


The following changes since commit 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b:

  Linux 6.12-rc2 (2024-10-06 15:32:27 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.13-1

for you to fetch changes up to 7a1f3143377adb655a3912b8dea714949f819fa3:

  KVM: s390: selftests: Add regression tests for PFCR subfunctions (2024-11-11 12:15:44 +0000)

----------------------------------------------------------------
- second part of the ucontrol selftest
- cpumodel sanity check selftest
- gen17 cpumodel changes
----------------------------------------------------------------

Christoph Schlameuss (5):
  KVM: s390: selftests: Add uc_map_unmap VM test case
  KVM: s390: selftests: Add uc_skey VM test case
  KVM: s390: selftests: Verify reject memory region operations for
    ucontrol VMs
  KVM: s390: selftests: Fix whitespace confusion in ucontrol test
  KVM: s390: selftests: correct IP.b length in uc_handle_sieic debug
    output

Hariharan Mari (5):
  KVM: s390: selftests: Add regression tests for SORTL and DFLTCC CPU
    subfunctions
  KVM: s390: selftests: Add regression tests for PRNO, KDSA and KMA
    crypto subfunctions
  KVM: s390: selftests: Add regression tests for KMCTR, KMF, KMO and PCC
    crypto subfunctions
  KVM: s390: selftests: Add regression tests for KMAC, KMC, KM, KIMD and
    KLMD crypto subfunctions
  KVM: s390: selftests: Add regression tests for PLO subfunctions

Hendrik Brueckner (4):
  KVM: s390: add concurrent-function facility to cpu model
  KVM: s390: add msa11 to cpu model
  KVM: s390: add gen17 facilities to CPU model
  KVM: s390: selftests: Add regression tests for PFCR subfunctions

 arch/s390/include/asm/kvm_host.h              |   1 +
 arch/s390/include/uapi/asm/kvm.h              |   3 +-
 arch/s390/kvm/kvm-s390.c                      |  43 ++-
 arch/s390/kvm/vsie.c                          |   3 +-
 arch/s390/tools/gen_facilities.c              |   2 +
 tools/arch/s390/include/uapi/asm/kvm.h        |   3 +-
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/s390x/facility.h    |  50 +++
 .../selftests/kvm/include/s390x/processor.h   |   6 +
 .../selftests/kvm/lib/s390x/facility.c        |  14 +
 .../kvm/s390x/cpumodel_subfuncs_test.c        | 301 ++++++++++++++++
 .../selftests/kvm/s390x/ucontrol_test.c       | 322 +++++++++++++++++-
 12 files changed, 737 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/facility.h
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/facility.c
 create mode 100644 tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c

-- 
2.47.0


