Return-Path: <kvm+bounces-62188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A64C2C3C58A
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1B3862014D
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4ED34E747;
	Thu,  6 Nov 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lJxWjUIS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAF734CFA0;
	Thu,  6 Nov 2025 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445487; cv=none; b=fe62FqEuxEZ7Hp3/MCO94CBueV54XYOvWZkzZcSoTUtElC8ysog6DvCWl83Bk/Mc6/prJIlIc51X8DfpXDROsxaVcy4Klz4FFPdoQl0itmwFPFeUHC/xyLIclSmRlkNjWWnG5ncW+0D+CBnu4/nQBYC6EQDH5GG6Ry0R42joVUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445487; c=relaxed/simple;
	bh=XH4+lwyFACHHtvind3oO7V+qFasFasS+jBGUmEuxkjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ex+ffBHrxTUOu/b1cBmpFL9VHlo77nxsKLRCcSuC9s1AIdfNGkWhz1sIxuiayKPD5DK1mIXBJOVnNhWDwXjNWaDSX0y1LL5XeMdupTKxkbKhEXDq3dYL5ZsjFQnQMD7mUjxGNmEb7yYiwdAm9rmvlfS+I6c29swZCZJwV5iP8xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lJxWjUIS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6EdmAQ026450;
	Thu, 6 Nov 2025 16:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Q2UksBgU4B1EFbaighN3qMLZUxtLWsrE6SLEVvNVy
	c0=; b=lJxWjUISW8aVA5jS/ymmv3DvPCAYofdm2w0OLeSLPfteS3BJFXAVTtEC1
	tcI6Cqx2PQA5knP5Ee0O6HbRnfRS4JzgJHS8SGqeWifjPF3KZOBdhiXlR03Jvyvu
	2I0g6FAra8p8Eiz3F4PZFb2kbp3KD+wyYIP2JsPrhdVGjPbfYMP1klWmiDBWrmUB
	cNPfITRItvHvBKFijuKwDn7pJuuWx3JKVu2neeaj33DFLUN300Dbeqqhgt3AYt9C
	CVVi1TXWExB8CBoMumAuLjyz8G7MBIbVx04G5dQ0kz4EQgI2BDO/2j/SU8G7Xmf+
	Vjcu9bA0PiuRhXB8/+7c8k3kvfXmw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59q9876c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6FSEuY009863;
	Thu, 6 Nov 2025 16:11:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5x1kp933-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:21 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBIdu16384402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F38BA20043;
	Thu,  6 Nov 2025 16:11:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BE9320040;
	Thu,  6 Nov 2025 16:11:17 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:17 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 00/23] KVM: s390: gmap rewrite, the real deal
Date: Thu,  6 Nov 2025 17:10:54 +0100
Message-ID: <20251106161117.350395-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=StmdKfO0 c=1 sm=1 tr=0 ts=690cc8ab cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=KiohzL8Nbn7Py9lwjSIA:9
X-Proofpoint-ORIG-GUID: bOJ5VDC4VVzbOXZPI-c9m6nlY5xlhPUq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAxOCBTYWx0ZWRfX32h5ryJwgnDN
 5fzQvVwI9BxVe0tOK5hPWHbPtGo077DzrXE2E2XXrDm5jyisRyTu97LX6+MSem9p0RHBWHYtDEV
 vnSCCweopSKua7rk079uiPORSGK7CvSa7kxqSoo4fOWoOd0AZ8uMIxb/XdDw/pK4y9wCIlblZwM
 aj+7cmyNtImResk145Nmy/4Az+Ssjk4XJZOCSC6J4BDaEfVn514a+/K3tz10eVePa9rJ29vKOcM
 BWnSfqZvDte+cJN4SzcJ+3nO5mu0pGcqaNE87tvMEtIumdDosQMCIVBMrqSO04ducbw37gv7vJ4
 Tb4z/HS3HYBF9qFcqFXb0xbVgJQTKx9RMythu0F02GK+iuPHkG7/rMA/tlYdBQ0wlrs0UklmIss
 CzK+6dMkOEAamFQuZzIQ3i4RwKSncA==
X-Proofpoint-GUID: bOJ5VDC4VVzbOXZPI-c9m6nlY5xlhPUq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010018

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

Patches 1 to 6 are mostly preparations; introducing some new bits and
functions, and moving code around.

Patch 7 to 16 is the meat of the new gmap code; page table management
functions and gmap management. This is the code that will be used to
manage guest memory.

Patch 18 is unfortunately big; the existing code is converted to use
the new gmap and all references to the old gmap are removed. This needs
to be done all at once, unfortunately, hence the size of the patch.

Patch 19 and 20 remove all the now unused code.

Patch 21 and 22 allow for 1M pages to be used to back guests, and add
some more functions that are useful for testing.

Patch 23 fixes storage key manipulation functions, which would
otherwise be broken by the new code.


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
  KVM: s390: Switch to new gmap
  KVM: s390: Remove gmap from s390/mm
  KVM: S390: Remove PGSTE code from linux/s390 mm
  KVM: s390: Enable 1M pages for gmap
  KVM: s390: Storage key manipulation IOCTL
  KVM: s390: Fix storage key memop IOCTLs

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
 arch/s390/kvm/dat.c                  | 1362 ++++++++++++++
 arch/s390/kvm/dat.h                  |  971 ++++++++++
 arch/s390/kvm/diag.c                 |    2 +-
 arch/s390/kvm/faultin.c              |  148 ++
 arch/s390/kvm/faultin.h              |   92 +
 arch/s390/kvm/gaccess.c              |  929 +++++-----
 arch/s390/kvm/gaccess.h              |   20 +-
 arch/s390/kvm/gmap-vsie.c            |  141 --
 arch/s390/kvm/gmap.c                 | 1125 ++++++++++++
 arch/s390/kvm/gmap.h                 |  159 ++
 arch/s390/kvm/intercept.c            |   15 +-
 arch/s390/kvm/interrupt.c            |    2 +-
 arch/s390/kvm/kvm-s390.c             |  926 ++++------
 arch/s390/kvm/kvm-s390.h             |   28 +-
 arch/s390/kvm/priv.c                 |  207 +--
 arch/s390/kvm/pv.c                   |   67 +-
 arch/s390/kvm/vsie.c                 |  117 +-
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
 44 files changed, 5116 insertions(+), 5303 deletions(-)
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


