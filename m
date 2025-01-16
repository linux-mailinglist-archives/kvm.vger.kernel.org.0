Return-Path: <kvm+bounces-35645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 102A1A13918
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4732A1889633
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A434F1DE8A0;
	Thu, 16 Jan 2025 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G5RZ6k6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041451DE2C1;
	Thu, 16 Jan 2025 11:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027250; cv=none; b=e+E8V+l9FGxfdciaxt+0YN2G+ugnXcDZZCwi2DOcSPq3eLSGDhJw0n0qUEBGmeGgt3WRZnjuCpQ3hWkwEBJ98Y0Q4dg/UwwQuCsyRPqk5APWkgNtFGw7FhyVg3uJzqQFFnrdZQFGJN7YS84zSh+JtlfuEYjDxLNi/cf4UM29kQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027250; c=relaxed/simple;
	bh=OErz+Yc7X8IvkNAktDvVXp4amkOg6YDJ3yXQMojy3bM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B7i7C98U4IF424m9KGELCuxxN5Sklx56ILWrM/LOY2WuMbXVmufFu/18RsAkAyhnb6mLYZuuLSCLqtUvDmRsAwFFf0gmxxk091Vo2ErxwSG3svCmUi6KUUhlgxIvCspvA9dFUedsmVTkiYRirOKO+zFXxJze4WB4hAzsPHe/ghI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G5RZ6k6Z; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GAbZus028334;
	Thu, 16 Jan 2025 11:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=41PQ9133Lwye4kDGV+wmnYpVTkLk4J720cwpQZVqQ
	Go=; b=G5RZ6k6Zo28Q8nMmBYFf5gIZl8gCagBZRBmH7qT6Fsy6Ns+/pyjN4arg1
	4upE01mX+KGUoECE5KtHr14KIF3vq+1FMDBdK6k+2ntFmydBcqBX+lbSjwBdsovM
	/NQjJCa0EdipNjpGmAAI/BBICulIvC2LBLogAlJrs2G69fw1vtvgGUrRi9x4C3UE
	hmRAN6ZSm8lC7yuo8+UyINIYJ5HrbMfLnjzY+FTeFDdkmbREh3XrV04uNDyKngg+
	+M+Pw5lcE9kNeKDaKaOuipq2vyx/YVPuvLDHfCVsXwl8ZybYM3+T7iLx02xKo078
	LbM3LUwg6yfiGO+Cz1aY7gzYYjiVQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446q5htrec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:01 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBUPq5003824;
	Thu, 16 Jan 2025 11:34:01 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446q5htre8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GA349U016991;
	Thu, 16 Jan 2025 11:34:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkdgbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:33:59 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBXulG18481630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:33:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E42720049;
	Thu, 16 Jan 2025 11:33:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D097D20040;
	Thu, 16 Jan 2025 11:33:55 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:55 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 00/15] KVM: s390: Stop using page->index and other things
Date: Thu, 16 Jan 2025 12:33:40 +0100
Message-ID: <20250116113355.32184-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vgddnESI2sGPRdotuetuJa74TP7Yn-UY
X-Proofpoint-GUID: La-pCZNLzymj6Q1sF73yM9anEkfyR1Ot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=540 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160086

This patchseries starts moving some of the gmap logic into KVM itself,
going towards the final goal of completely removing gmap from the
non-kvm memory management code. Aside from just moving some code from
mm/gmap into kvm, this series also starts using __kvm_faultin_pfn() to
fault-in pages as needed.

But more importantly, this series removes almost all uses of
page->index (and all uses of page->lru) from the s390 KVM code.
The only remaining use is for the vsie pages, but that has already been
taken care of by David in another series.

Unfortunately the mix of hastiness and holidays means that this series
is a little bit all over the place, and not as complete as I would have
liked to.

I'm posting it now so to try to speed up the removal of page->index,
hopefully I will be able to post another short series before the
upcoming merge window closes.


v1->v2:
* moved some code around between patches to improve readability and shuffle
  the order of some patches
* rebase on Sean's patchseries
* add Sean's patch to remove size limitations for internal memslots
* use Sean's new API for internal memslots to place one huge internal
  memslot instead of many 4T ones for UCONTROL guests
* create new kvm/gmap-vsie.c file for VSIE code, instead of dumping
  everything in the existing files, which are already too large
* improve comments and patch descriptions
* minor style and cosmetic fixes


Claudio Imbrenda (14):
  KVM: s390: wrapper for KVM_BUG
  KVM: s390: move pv gmap functions into kvm
  KVM: s390: fake memslot for ucontrol VMs
  KVM: s390: selftests: fix ucontrol memory region test
  KVM: s390: use __kvm_faultin_pfn()
  KVM: s390: get rid of gmap_fault()
  KVM: s390: get rid of gmap_translate()
  KVM: s390: move some gmap shadowing functions away from mm/gmap.c
  KVM: s390: stop using page->index for non-shadow gmaps
  KVM: s390: stop using lists to keep track of used dat tables
  KVM: s390: move gmap_shadow_pgt_lookup() into kvm
  KVM: s390: remove useless page->index usage
  KVM: s390: move PGSTE softbits
  KVM: s390: remove the last user of page->index

Sean Christopherson (1):
  KVM: Do not restrict the size of KVM-internal memory regions

 arch/s390/include/asm/gmap.h                  |  17 +-
 arch/s390/include/asm/kvm_host.h              |   2 +
 arch/s390/include/asm/pgtable.h               |  21 +-
 arch/s390/include/asm/uv.h                    |   7 +-
 arch/s390/kernel/uv.c                         | 293 ++------
 arch/s390/kvm/Makefile                        |   2 +-
 arch/s390/kvm/gaccess.c                       |  42 ++
 arch/s390/kvm/gmap-vsie.c                     | 142 ++++
 arch/s390/kvm/gmap.c                          | 196 ++++++
 arch/s390/kvm/gmap.h                          |  39 ++
 arch/s390/kvm/intercept.c                     |   5 +-
 arch/s390/kvm/interrupt.c                     |  19 +-
 arch/s390/kvm/kvm-s390.c                      | 219 ++++--
 arch/s390/kvm/kvm-s390.h                      |  19 +
 arch/s390/kvm/pv.c                            |   1 +
 arch/s390/kvm/vsie.c                          |   2 +
 arch/s390/mm/gmap.c                           | 638 +++---------------
 .../selftests/kvm/s390x/ucontrol_test.c       |   6 +-
 virt/kvm/kvm_main.c                           |  10 +-
 19 files changed, 828 insertions(+), 852 deletions(-)
 create mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

-- 
2.47.1


