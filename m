Return-Path: <kvm+bounces-29387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5489AA1BA
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F6F9283AF8
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E241A19D8AC;
	Tue, 22 Oct 2024 12:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="buiYH2y8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D35B19D097;
	Tue, 22 Oct 2024 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598772; cv=none; b=Hfcnc9/WZ4ezdI97EN4onTYkNDVbmSYnv6T/ZSJlH91MwD21vGWfV1L84EwAnfvfIfoHg4UtqbNsy0atj7uWIwLbLN7eFTalSrXlmS7PhQcUQ242yYZSmAYsJ9A21T6/yXosShso6/LP/VwaXj2b/OJDmlYxea/lkq/CgjFuVxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598772; c=relaxed/simple;
	bh=r/Q462VXgRCMsAMAdvuuyCcpqHiwqOBdNlJgLv/L26M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZDC3C98SSGhSlgGDoEtzjo1TiItmCi5+Y1bxUYoKW3aRJ2I/vTIh0cCx35hnyqH0S+yzZGpIhZwzc1JxaM5y4bKeW2py45Jr4iRXDP64do4latqbXQs8UWkdEp2Y14ZRMjMeOyU7Bd1IpWav+z3C4+WXhy4n+6X5xUpT7JAK+Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=buiYH2y8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HkPp023799;
	Tue, 22 Oct 2024 12:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=PCOFGNBpImMiPTSTFk3sc6w+6MuPJjF2VtGlxuQJw
	8E=; b=buiYH2y8EybdC5yltxohibOckqncGhtXXoyIuw65a+YM2kRnHn9d5PEmg
	43x3L4RtGkmcHYx9PMLrmgICljOFbnhLTEqA07gjC0wu0y7sKEKhYMJpZLycYG5o
	AHdzblreruXkYlo/hbD/VEA4HNM2pTpS9OpahBzfjYJ4atOo2yci61uEwJy0Vzsn
	VrTmSO8mLiU2Ny/ZB13SQBY2T1x5B6R4Ysig1VjG2wddoEUmXQkcwAj6x7Riw90g
	31xR/8Up/Kjls1/a5DIV4x72FMQzGPtrvldiBisAKQABZwz7cjm782HXN+Em3asF
	CWbAK9J+oBJ2pBQURJ2mhfL8LvKtA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5h36chw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:07 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49M90l4O028879;
	Tue, 22 Oct 2024 12:06:06 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42cqfxk764-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC622R29950266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94A3720043;
	Tue, 22 Oct 2024 12:06:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 771E820040;
	Tue, 22 Oct 2024 12:06:01 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:01 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 00/11] s390/kvm: Handle guest-related program interrupts in KVM
Date: Tue, 22 Oct 2024 14:05:50 +0200
Message-ID: <20241022120601.167009-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hULiXhbtx108RH0gg2u2ng-7gZf4p3oI
X-Proofpoint-ORIG-GUID: hULiXhbtx108RH0gg2u2ng-7gZf4p3oI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=479
 adultscore=0 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

This patchseries moves the handling of host program interrupts that
happen while a KVM guest is running into KVM itself.

All program interrupts that happen in the host while a KVM guest is
running are due to DAT exceptions. It is cleaner and more maintainable
to have KVM handle those.

As a side effect, some more cleanups is also possible.

Moreover, this series serves as a foundation for an upcoming series
that will further move as much s390 KVM memory managament as possible
into KVM itself, and away from the rest of the kernel.


v3->v4:
* patch 5: move check for primary ASCE from the interrupt handler to
  the handlers of the specific faults where we expect the ASCE
  indication to be meaningful.
* patch 6: remove enabled_gmap from struct kvm_cpu_arch, since it is
  now unused.
* picked up some R-Bs from Heiko

Claudio Imbrenda (8):
  s390/entry: Remove __GMAP_ASCE and use _PIF_GUEST_FAULT again
  s390/kvm: Remove kvm_arch_fault_in_page()
  s390/mm/gmap: Refactor gmap_fault() and add support for pfault
  s390/mm/gmap: Fix __gmap_fault() return code
  s390/mm/fault: Handle guest-related program interrupts in KVM
  s390/kvm: Stop using gmap_{en,dis}able()
  s390/mm/gmap: Remove gmap_{en,dis}able()
  s390: Remove gmap pointer from lowcore

Heiko Carstens (3):
  s390/mm: Simplify get_fault_type()
  s390/mm: Get rid of fault type switch statements
  s390/mm: Convert to LOCK_MM_AND_FIND_VMA

 arch/s390/Kconfig                 |   1 +
 arch/s390/include/asm/gmap.h      |   3 -
 arch/s390/include/asm/kvm_host.h  |   5 +-
 arch/s390/include/asm/lowcore.h   |   3 +-
 arch/s390/include/asm/processor.h |   5 +-
 arch/s390/include/asm/ptrace.h    |   2 +
 arch/s390/kernel/asm-offsets.c    |   3 -
 arch/s390/kernel/entry.S          |  44 ++-----
 arch/s390/kernel/traps.c          |  23 +++-
 arch/s390/kvm/intercept.c         |   4 +-
 arch/s390/kvm/kvm-s390.c          | 142 +++++++++++++++-------
 arch/s390/kvm/kvm-s390.h          |   8 +-
 arch/s390/kvm/vsie.c              |  17 ++-
 arch/s390/mm/fault.c              | 195 +++++-------------------------
 arch/s390/mm/gmap.c               | 151 +++++++++++++++--------
 15 files changed, 281 insertions(+), 325 deletions(-)

-- 
2.47.0


