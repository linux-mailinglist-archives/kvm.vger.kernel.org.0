Return-Path: <kvm+bounces-64996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 011C5C9767D
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C1D64E8270
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AC8313297;
	Mon,  1 Dec 2025 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RBAHVGHn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE8D312819;
	Mon,  1 Dec 2025 12:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593118; cv=none; b=rh1fBWBhkK4X/sQtuiJYyYIlU5QNHXTdbmmxEiykLoWSOYWd8E2LY/URg5e0b54LOrv0eOkj849Te0dDpV6HriJVGpNLbV/rBLKougA6P36BKZN+NNvuPwcskIs/+OLJCC9BbkMkBZyotf50egW+ViPTKB5lpHpxEaBiwtg1PR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593118; c=relaxed/simple;
	bh=ucg+hH/U3M60XXW/V6lE+Z9CZIdDXyOABO3v0iUBp3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bYFprUVTzD7NwLn8D+OhSMGmUamk6p2+c46P2ZmKyEOtgIc5gPgr0UxLtHwy1NWTtncth0T9hT8jwaohs4easYQ8LUGiOohK6odzBWZmyllG2s3JlpLpz3uOXtX55NOGH+Y7BAGpHthMTV65DUShBLmJhQylNH41v1ypIFjWp/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RBAHVGHn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1BuiB0010934;
	Mon, 1 Dec 2025 12:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=/xJpoFLLYBYOq+l3ncAyQdio4HBk5rEyIGxPy9S/Y
	N8=; b=RBAHVGHnBbdzl7chhn2zvaRs2w0WlWsa3bBrYGtzxiI6UkZlXK8Ujp7BM
	Ubs7S/rMcKbm8ElrbWfywbyTgja0HfS4gDUPy8HfYY+dYvZlE7nYiwb4XnSYZzji
	SuSN17AisZVIP1yId0jRQXP0LD0rPN7akxUfT/CGAoa5K8LxRdYkt8dqyItRKtHU
	ze8/N+udaC+04vtJMmCTACpEn/T5AiRe/UcKJkFQwIAZw497QAhxWE3IIUKi67Ti
	mZoq5m3HyqxNxRa4A4YFPtc3XcJbahMlEItucsfBx21i6ELfB84LTti4vQOscvz0
	3pDe4XIfMmEW3LkTyWSz5k3n1AJqw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrj9f3sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B19lgUl010284;
	Mon, 1 Dec 2025 12:45:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4arcnjxa8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:11 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1Cj8kc54395164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EFB520043;
	Mon,  1 Dec 2025 12:45:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE42420040;
	Mon,  1 Dec 2025 12:45:07 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:07 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com
Subject: [GIT PULL 00/10] KVM: s390: Changes for v6.19
Date: Mon,  1 Dec 2025 13:33:42 +0100
Message-ID: <20251201124334.110483-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nr0UszBXQDwk81LIPrfzl5zG5h2HKLRi
X-Proofpoint-ORIG-GUID: nr0UszBXQDwk81LIPrfzl5zG5h2HKLRi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyMCBTYWx0ZWRfXxmq4XdSW1YCe
 m5y1/ecE1TVG20vWSXZaumURqXepDb1k2Q3Rk54cZNU7v6vO1ojEef/p5qfmfwZgUHxb0dTw4iZ
 S/cFL61A/RfX0kwktuD0W1V/JBpwfAR0iPXtwuMZFIxORUVKgFG4v1LZg5yFhNwnrA6fQ5Jldq2
 wHbsxTphlH7b7kipbbNIw3gTN7sEcGTTXZOKfMDA72bZc10s8M0AmLlej58vICcnyMRZnKzxJVy
 kc717KnC7Jmb35IEdtleG6wA59hXax8siwjAbRFvyWaDoIepda40TZgqfJbw7H5jCYzAoNVEgcw
 U2rYW2FG7foE7ks9PpIj0qq8rHnaekbM8BzmRhhDuNERHM/3lC7OWCwztfREPo/A+uyMbShgV2X
 GiF3js537auuXt+odG5Hb49mjXQlJA==
X-Authority-Analysis: v=2.4 cv=dYGNHHXe c=1 sm=1 tr=0 ts=692d8dd9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=ZejKs9g8C-3ACH4PFbQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511290020

Hi Paolo,

here are the s390 changes for 6.19:
- SCA rework
- VIRT_XFER_TO_GUEST_WORK support
- Operation exception forwarding support
- Cleanups


The operation exception forward patch had a conflict because of
capability numbering. The VIRT_XFER_TO_GUEST_WORK may or may not have
a conflict with the s390 repo because the kvm-s390.c imports are
changed in close proximity. Both conflicts are trivial and the
resolution for the capability numbering is already in next.


Please pull.

Cheers,
Janosch

The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.19-1

for you to fetch changes up to 2bd1337a1295e012e60008ee21a64375e5234e12:

  KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK functions (2025-11-28 10:11:14 +0100)

----------------------------------------------------------------
- SCA rework
- VIRT_XFER_TO_GUEST_WORK support
- Operation exception forwarding support
- Cleanups
----------------------------------------------------------------
Andrew Donnellan (2):
      KVM: s390: Add signal_exits counter
      KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK functions

Christoph Schlameuss (2):
      KVM: s390: Use ESCA instead of BSCA at VM init
      KVM: S390: Remove sca_lock

Eric Farman (1):
      KVM: s390: vsie: Check alignment of BSCA header

Heiko Carstens (1):
      KVM: s390: Enable and disable interrupts in entry code

Janosch Frank (2):
      Documentation: kvm: Fix ordering
      KVM: s390: Add capability that forwards operation exceptions

Josephine Pfeiffer (1):
      KVM: s390: Replace sprintf with snprintf for buffer safety

Thorsten Blum (1):
      KVM: s390: Remove unused return variable in kvm_arch_vcpu_ioctl_set_fpu

 Documentation/virt/kvm/api.rst                   |  19 ++++++++-
 arch/s390/include/asm/kvm_host.h                 |   8 ++--
 arch/s390/include/asm/stacktrace.h               |   1 +
 arch/s390/kernel/asm-offsets.c                   |   1 +
 arch/s390/kernel/entry.S                         |   2 +
 arch/s390/kvm/Kconfig                            |   1 +
 arch/s390/kvm/gaccess.c                          |  27 +++---------
 arch/s390/kvm/intercept.c                        |   3 ++
 arch/s390/kvm/interrupt.c                        |  80 ++++++++---------------------------
 arch/s390/kvm/kvm-s390.c                         | 229 +++++++++++++++++++++++++++------------------------------------------------------------------------
 arch/s390/kvm/kvm-s390.h                         |   9 +---
 arch/s390/kvm/vsie.c                             |  20 ++++++---
 include/uapi/linux/kvm.h                         |   1 +
 tools/testing/selftests/kvm/Makefile.kvm         |   1 +
 tools/testing/selftests/kvm/s390/user_operexec.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 15 files changed, 271 insertions(+), 271 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390/user_operexec.c

-- 
2.52.0


