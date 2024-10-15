Return-Path: <kvm+bounces-28912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F7199F2F5
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2E0A1C21F22
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5745A1F9EAD;
	Tue, 15 Oct 2024 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iyi+Ok0n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4E71F76A3;
	Tue, 15 Oct 2024 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010614; cv=none; b=Cjwom35J8MC0rNe91sGZeszYGG8NYNYDKbGNU3fOuOARsQvSSKFRz5I0IKd5EVLllvxS4uBUfnWlnozvGFQRoRchi1Sb7mOuoAjSA0pLxZ6aAgn8mxebYFlR9DmZ2adx9eK0DBvu10KJ3r7tmctVeO2AMwM9aqF5EWdBNSFdOIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010614; c=relaxed/simple;
	bh=tP3rXaozqoNu3tDhXn0iby1XH6Rz+GI82mf7FfVJBvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qw6OMljSwg+jCTNt8lqpJoGrz/nQm9OIXzvigDWlYaJgjEDyyeSmbw6R84Vr/Wx5dtnq06MqUPcAuWIm7sKSEoofKNA5kXP10vRtoLIX9kwVCaSlJmSVTC6gJQjGC+GXq/UtHFuivfJDICrVBlwQVyXGyn6CTVbEvY2B/4iEyvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iyi+Ok0n; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FFpdsX000819;
	Tue, 15 Oct 2024 16:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=/k/6xQu7g3mfBYnfLuMOXyxmLgPOpChPnjVW+A18B
	9w=; b=iyi+Ok0nnQic+PATviri5zwIO3ac9+nS4hxps6hDGYAzQyfzc/ivI6JG9
	OqRHssmwEleRw3b6JgvSWyiF3ofJt4K+lpN2C3GUlsYhF/CUZEmsrtoKti5dgjsv
	y9FfvUgvN9YzMO3Z7+ue8lKBUkusr5qmty69cEIsIloivRkO4Tfjy/QKAK4ZG9wn
	7p9shIVAnQzZDzNHbF3nFCb/4EDZeykuQbSYCq+3JZpxy28TOZltHBRNWL/aLRwl
	jaDEUmvKZtSJ8slecd7uri4wz4fKOCIKfvQuzJCJ3WOrsujWkoVaSrYuTcMs1meQ
	MLPtn9A0iDrKMOTOECJOjDTXARjEQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429ucwg8ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FFiZxi005906;
	Tue, 15 Oct 2024 16:43:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650vjh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhQTB25690862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA71720040;
	Tue, 15 Oct 2024 16:43:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0B462004B;
	Tue, 15 Oct 2024 16:43:26 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 16:43:26 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 00/11] s390/kvm: Handle guest-related program interrupts in KVM
Date: Tue, 15 Oct 2024 18:43:15 +0200
Message-ID: <20241015164326.124987-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Vu_RAR4zheI4bCcJgPFC9fXJ7ICC5S-c
X-Proofpoint-GUID: Vu_RAR4zheI4bCcJgPFC9fXJ7ICC5S-c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=468 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

This patchseries moves the handling of host program interrupts that
happen while a KVM guest is running into KVM itself.

All program interrupts that happen in the host while a KVM guest is
running are due to DAT exceptions. It is cleaner and more maintainable
to have KVM handle those.

As a side effect, some more cleanups is also possible.

Moreover, this series serves as a foundation for an upcoming series
that will further move as much s390 KVM memory managament as possible
into KVM itself, and away from the rest of the kernel.

Version 1 and 2 of this series were sent privately, which is also where
the various reviews and acks come from.

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
 arch/s390/include/asm/kvm_host.h  |   3 +
 arch/s390/include/asm/lowcore.h   |   3 +-
 arch/s390/include/asm/processor.h |   5 +-
 arch/s390/include/asm/ptrace.h    |   2 +
 arch/s390/kernel/asm-offsets.c    |   3 -
 arch/s390/kernel/entry.S          |  44 ++-----
 arch/s390/kernel/traps.c          |  23 +++-
 arch/s390/kvm/intercept.c         |   4 +-
 arch/s390/kvm/kvm-s390.c          | 139 ++++++++++++++-------
 arch/s390/kvm/kvm-s390.h          |   8 +-
 arch/s390/kvm/vsie.c              |  17 ++-
 arch/s390/mm/fault.c              | 195 +++++-------------------------
 arch/s390/mm/gmap.c               | 151 +++++++++++++++--------
 15 files changed, 278 insertions(+), 323 deletions(-)

-- 
2.47.0


