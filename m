Return-Path: <kvm+bounces-63890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA2FC7597E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 2BA4D2C195
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD9836C596;
	Thu, 20 Nov 2025 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lJgzQrBw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9622D4806;
	Thu, 20 Nov 2025 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658956; cv=none; b=bCV33Im+GiRvqlm1ZQbUlpY8x3rPDsnA0BSugrDHki/0DsNGPnTB9Qdp8JRYoG32vb7Dp+XjxkQ6MAHJQWPoirYNsTf56dXVlHcI1iXHjNbweE3BHcxbMD0TRkn2G8uhabmfzhZ0TUMlwxUB9nxbaf5d6wuDa34C0oxs2kcblvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658956; c=relaxed/simple;
	bh=l+UTDbiOy2IhTKHEhlTxvO6dJ+Eh6xvdhsadis7S7vA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MbvO2E5gKS3XojKKC4+LN+rC0doieFALkt3yYDcxMxRrLnX/MlNaJx6PxCWcppUzpWysKN4mvX/tJG02yRezH/6J5VTumqxhtuM2CJoMRlLNhHWk1imLRjl0xHm1l3TEegRGvhELxHT5MXhtsPNYwP2lCYPrzuqhIYR1Rz4ezL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lJgzQrBw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKCnSif028030;
	Thu, 20 Nov 2025 17:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=uCSgelylD1ZVN/Hk98wMuLsqb+U5FQbIUTxNwmc1e
	W0=; b=lJgzQrBwHj1N3kOkdI4FFzEGbrxDPb+kiFJHb3mDU18UvPZvMqxrh/iTH
	tnhPRunA545RDtKvyvnPFDIUkEzMHAHvJL1yxBTzEK8AW98RHV8ggiwJwnRK0Mtk
	7s3fPgZMYXwesLzO0l4cq0jTer0g8W0XMB+xWa/J7BLegt8liwZUZxzJIMr2zJL9
	2WmmA8PGOyiz+J3M9hpyki/zLwEQ9rnDj30cUVTqi9j2dyEv8uN9TpSKrFbtTYh4
	ExOOk4QTLtEpj8/7T7Awggen7LWQIYFxhxLQFzBVgEXH7j2NfV5DUyY7jP5tuofk
	NG+y3D42S3g92+6Iuwssn+KZ2mN4Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka7msm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:15:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKEENPu006967;
	Thu, 20 Nov 2025 17:15:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af62jqdgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:15:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHFkeP17826226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:15:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF6212004B;
	Thu, 20 Nov 2025 17:15:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16F3020040;
	Thu, 20 Nov 2025 17:15:45 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:15:44 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 00/23] KVM: s390: gmap rewrite, the real deal
Date: Thu, 20 Nov 2025 18:15:21 +0100
Message-ID: <20251120171544.96841-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: veHf4q5X4tNeFsThE4twLqI0zUkzmybI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX7Z/5+iMG0pJx
 +eVA4eiI/QSuChkHgUsP3g6P2xv1YWmww6z/asolQrK1ltsQlc+PSi/c1wMbyaqxzKwSyx1UolZ
 UDxQTag0qohI00YdCWO2hHNJniNQFqvaudmPFq68ZyIm9L0P+WuRO9jHQuh8stvIR4RK5vHKVBL
 poVt27YaFV9/XeP8Imc5W0FEeQKVe8XekvvKy39jkKtnuxcVBWKmFzFfMgN2LrOaFM5M3zij3/8
 pkx0rANuRKu/wR/3xIhMQMWuD9jnq2DPK7JwKixg4V0A2cnX4fPjDPFf8gbW2oYOFb8tdMv7H/g
 d2Dw/P4ofuGFgtK03zqG3VQkhauwyd7hqP9PeNy+JFXLlNU+GXqNZ6/QyuC9tThl1cDon22ijc/
 jMh3u4tm19iRxc70uIg0qtSFHsb5sQ==
X-Proofpoint-ORIG-GUID: veHf4q5X4tNeFsThE4twLqI0zUkzmybI
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691f4cc7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VqMf9zvxq0yzUyhZ9NsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

This series is the last big series of the gmap rewrite. It introduces
the new code and actually uses it. The old code is then removed.

The insertions/deletions balance is negative both for this series, and
for the whole rewrite, also considering all the preparatory patches.

KVM on s390 will now use the mmu_notifier, like most other
architectures. The gmap address space is now completely separate from
userspace; no level of the page tables is shared between guest mapping
and userspace.

One of the biggest advantages is that the page size of userspace is
completely independent of the page size used by the guest. Userspace
can mix normal pages, THPs, hugetlbfs, and more.

It's now possible to have nested guests and guests with huge pages
running on the same host. In fact, it's possible to have a nested
guest on a guest with huge pages. Transparent hugepages are also
possible.

Patches 1 to 6 are mostly preparations; introducing some new bits and
functions, and moving code around.

Patches 7 to 16 are the meat of the new gmap code; page table management
functions and gmap management. This is the code that will be used to
manage guest memory.

Patch 19 is unfortunately big; the existing code is converted to use
the new gmap and all references to the old gmap are removed. This needs
to be done all at once, unfortunately, hence the size of the patch.

Patch 20 and 21 remove all the now unused code.

Patch 22 and 23 allow for 1M pages to be used to back guests, and add
some more functions that are useful for testing.


v3->v4:
* dat_link() can now return -ENOMEM when appropriate
* fixed a few vSIE races that led to use-after-free or deadlocks
* split part of the previous patch 23 and move it after patch 17, merge
  the rest of the patch into patch 19
* fix -ENOMEM handling in handle_pfmf() and handle_sske()


v2->v3:
* Add lots of small comments and cosmetic fixes
* Rename some functions to improve clarity
* Remove unused helper functions and macros
* Rename inline asm constraints labels to make them more understandable
* Refactor the code to pre-allocate the page tables (using custom
  caches) when sleeping is allowed, use the cached pages when holding
  spinlocks and handle gracefully allocation failures (i.e. retry
  instead of killing the guest)
* Refactor the code for fault handling; it's now in a separate file,
  and it takes a callback that can be optionally called when all the
  relevant locks are still held
* Use assembler mnemonics instead of manually specifying the opcode
  where appropriate
* Remove the LEVEL_* enum, and use TABLE_TYPE_* macros instead;
  introduce new TABLE_TYPE_PAGE_TABLE
* Remove usage of cpu_has_idte() since it is being removed from the
  kernel
* Improve storage key handling and PGSTE locking
* Introduce struct guest_fault to represent the state of a guest fault
  that is being resolved
* Minor CMMA fixes

Claudio Imbrenda (23):
  KVM: s390: Refactor pgste lock and unlock functions
  KVM: s390: add P bit in table entry bitfields, move union vaddress
  s390: Move sske_frame() to a header
  KVM: s390: Add gmap_helper_set_unused()
  KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
  KVM: s390: Rename some functions in gaccess.c
  KVM: s390: KVM-specific bitfields and helper functions
  KVM: s390: KVM page table management functions: allocation
  KVM: s390: KVM page table management functions: clear and replace
  KVM: s390: KVM page table management functions: walks
  KVM: s390: KVM page table management functions: storage keys
  KVM: s390: KVM page table management functions: lifecycle management
  KVM: s390: KVM page table management functions: CMMA
  KVM: s390: New gmap code
  KVM: s390: Add helper functions for fault handling
  KVM: s390: Add some helper functions needed for vSIE
  KVM: s390: Stop using CONFIG_PGSTE
  KVM: s390: Storage key functions refactoring
  KVM: s390: Switch to new gmap
  KVM: s390: Remove gmap from s390/mm
  KVM: S390: Remove PGSTE code from linux/s390 mm
  KVM: s390: Enable 1M pages for gmap
  KVM: s390: Storage key manipulation IOCTL

 MAINTAINERS                          |    2 -
 arch/s390/Kconfig                    |    3 -
 arch/s390/include/asm/dat-bits.h     |   32 +-
 arch/s390/include/asm/gmap.h         |  174 --
 arch/s390/include/asm/gmap_helpers.h |    1 +
 arch/s390/include/asm/kvm_host.h     |    5 +
 arch/s390/include/asm/mmu.h          |   13 -
 arch/s390/include/asm/mmu_context.h  |    6 +-
 arch/s390/include/asm/page.h         |    4 -
 arch/s390/include/asm/pgalloc.h      |    4 -
 arch/s390/include/asm/pgtable.h      |  163 +-
 arch/s390/include/asm/tlb.h          |    3 -
 arch/s390/include/asm/uaccess.h      |   70 +-
 arch/s390/kvm/Kconfig                |    3 +-
 arch/s390/kvm/Makefile               |    3 +-
 arch/s390/kvm/dat.c                  | 1364 ++++++++++++++
 arch/s390/kvm/dat.h                  |  965 ++++++++++
 arch/s390/kvm/diag.c                 |    2 +-
 arch/s390/kvm/faultin.c              |  148 ++
 arch/s390/kvm/faultin.h              |   92 +
 arch/s390/kvm/gaccess.c              |  937 +++++-----
 arch/s390/kvm/gaccess.h              |   20 +-
 arch/s390/kvm/gmap-vsie.c            |  141 --
 arch/s390/kvm/gmap.c                 | 1131 ++++++++++++
 arch/s390/kvm/gmap.h                 |  165 ++
 arch/s390/kvm/intercept.c            |   15 +-
 arch/s390/kvm/interrupt.c            |    2 +-
 arch/s390/kvm/kvm-s390.c             |  927 ++++------
 arch/s390/kvm/kvm-s390.h             |   28 +-
 arch/s390/kvm/priv.c                 |  211 +--
 arch/s390/kvm/pv.c                   |   67 +-
 arch/s390/kvm/vsie.c                 |  153 +-
 arch/s390/lib/uaccess.c              |  184 +-
 arch/s390/mm/Makefile                |    1 -
 arch/s390/mm/fault.c                 |    4 +-
 arch/s390/mm/gmap.c                  | 2453 --------------------------
 arch/s390/mm/gmap_helpers.c          |   87 +-
 arch/s390/mm/hugetlbpage.c           |   24 -
 arch/s390/mm/page-states.c           |    1 +
 arch/s390/mm/pageattr.c              |    7 -
 arch/s390/mm/pgalloc.c               |   24 -
 arch/s390/mm/pgtable.c               |  818 +--------
 include/uapi/linux/kvm.h             |   10 +
 mm/khugepaged.c                      |    9 -
 44 files changed, 5162 insertions(+), 5314 deletions(-)
 delete mode 100644 arch/s390/include/asm/gmap.h
 create mode 100644 arch/s390/kvm/dat.c
 create mode 100644 arch/s390/kvm/dat.h
 create mode 100644 arch/s390/kvm/faultin.c
 create mode 100644 arch/s390/kvm/faultin.h
 delete mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h
 delete mode 100644 arch/s390/mm/gmap.c

-- 
2.51.1


