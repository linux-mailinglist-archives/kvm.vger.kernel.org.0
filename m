Return-Path: <kvm+bounces-66482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF54CD6B78
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F12DB309F698
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 16:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BAF8333447;
	Mon, 22 Dec 2025 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jqxqFXuy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E9723D7EA;
	Mon, 22 Dec 2025 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422244; cv=none; b=CdE4fKIO1CAXSfrZaXtbHwY/Q1c8Czz+mHoD/cW3R1+HiCWReF+IaHjrYDvx+YF0l8LWm5d19kUUwkAqM8swMR6irCCgtzXtab/3ZfviBszxaR0Q6Kle/kp/cRQc6xDPg9RcoO9lgRPYKAkj6SyVKRc4CPD6eMmzJfjtA7gF8CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422244; c=relaxed/simple;
	bh=4nZaaiBzoex6ZCqMsLRnfztZhDJvIiQOKKqaimwpmhU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jxsjUnpuD8ZV0PA5cA3ztMdjUl78lg20TJrjx4+wldnPM7rbKhrThODZnn2d8+yRUWojY/t79GT8pMe7YcFyxZkSjYsSmYGJN717zAQ0mdJwJHzA9CqyMqIVBqpuiafQCRiyaHXTMcJxnxFlecQ/q+XIWGVrB3GCk/tWOduB+0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jqxqFXuy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BME1LGh008674;
	Mon, 22 Dec 2025 16:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=g29bmrQZN24i5i+PwQ3Wyal5uN7B4O12LOspH8OHl
	PM=; b=jqxqFXuyr3VXGgWINmodzOUhFXxcW0FnUyiBcqjBeUfIP8GhD9zYklV+X
	LTnvqhKyBWmGgU492Nwxk/7OIzgrGoeDBPhE6zCOXx216GO2skHb8C+RAgIZ/K9k
	3w77DyC989/OZQKBxhp+A3mnDXgzib9sG7ifQIY0A41XG8i0YWsOEdS1/zE2YUNL
	GwGyo4MAlnybsOJDCi3kAkhf5N1qeErxfIXatVOAcR3oxqWeuUMruwuXE0rYN1Ym
	YLh53eFOVWefTTf8N8qH5wjrwc9R+LTZAQL4BAzQQMpw7ISXhZnWgLQoLwgj3CJI
	63Mbl0xNdGwE0iXVdUA3gnSfm8Ueg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ketrta6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGQH89004630;
	Mon, 22 Dec 2025 16:50:39 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b674mq57n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGoY5o50266470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE0F320043;
	Mon, 22 Dec 2025 16:50:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77F1620040;
	Mon, 22 Dec 2025 16:50:33 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:33 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 00/28] KVM: s390: gmap rewrite, the real deal
Date: Mon, 22 Dec 2025 17:50:05 +0100
Message-ID: <20251222165033.162329-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hoUdDPexgZEsCqHANz0RVXR828n4_IKO
X-Authority-Analysis: v=2.4 cv=Qdxrf8bv c=1 sm=1 tr=0 ts=694976df cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=jBwfuLSKq9w8FxJ4gGMA:9
X-Proofpoint-ORIG-GUID: hoUdDPexgZEsCqHANz0RVXR828n4_IKO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfXyJJ+YSF7isSR
 fdtb6r5RHbxGn91IE0OqveDmI8RvAOYeo8z3tkNZkhOGFFQyl5XaWMMMtWf93TulBym7x7Il4GA
 5DDZaId4OJKgXD9d2Ha1jqpkVtWtebmiNJS18jzxGc1W+ig/3e0Z/KvM1vl41ArixAqUQySWdot
 1qF+bwnzjnov1cdawla6jMVSxmAfZlzLr42bHUslnPfkhMiyd4erjVHJtwNkFDVRKSsMU3Ovz2e
 R8CxROl4NHafn3wU3TFQCewKCTpI/xtmXHEj+ZIU6TgSHQQkUqY53SSBC2nHoiZnDfjfaDt4dC6
 8nI5hELtFckQ3dsGzN0ZR08H1wv4lKbv7btBxVaHhVrrKS6Ew9OoqXvPfZAImNKkbK8H6CRjjJ/
 OvEd/5Rk9ZkXzACioYNjex4R2VHYfIB79O3r3dpZ/g5a8juPttpUntqFcXN6W/Pozqlkqp2IHP9
 l0Ionm7AZIdtC57O9iQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

This series is the last big series of the gmap rewrite. It introduces
the new code and actually uses it. The old code is then removed.

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

Patches 1 to 11 are mostly preparations; introducing some new bits and
functions, and moving code around.

Patches 12 to 21 are the meat of the new gmap code; page table management
functions and gmap management. This is the code that will be used to
manage guest memory.

Patch 24 is unfortunately big; the existing code is converted to use
the new gmap and all references to the old gmap are removed. This needs
to be done all at once, unfortunately, hence the size of the patch.

Patch 25 and 26 remove all the now unused code.

Patch 27 and 28 allow for 1M pages to be used to back guests, and add
some more functions that are useful for testing.

v5->v6:
* Added a mutex to avoid races during import-like operations in
  protected guests
* The functions uv_convert_from_secure_folio() and uv_destroy_folio()
  now work on the whole folio, and not just its first page
* Added warnings if uv_convert_from_secure_pte() fails in ptep_*()
* Changed the way shadow gmaps do reference counting
* Use a bitmap for gmap flags, instead of individual bool variables
* Rework the make_secure logic to work on gmap only, and not on
  userspace addresses
* Some refactorings
* Rebased onto 6.19-rc2
* Added more comments
* Minor style fixes

v4->v5:
* fix some locking issues
* fix comments and documentation


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


Claudio Imbrenda (28):
  KVM: s390: Refactor pgste lock and unlock functions
  KVM: s390: add P bit in table entry bitfields, move union vaddress
  s390: Make UV folio operations work on whole folio
  s390: Move sske_frame() to a header
  KVM: s390: Add gmap_helper_set_unused()
  KVM: s390: Introduce import_lock
  KVM: s390: Export two functions
  s390/mm: Warn if uv_convert_from_secure_pte() fails
  KVM: s390: vsie: Pass gmap explicitly as parameter
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
 arch/s390/include/asm/hugetlb.h      |    6 -
 arch/s390/include/asm/kvm_host.h     |    7 +
 arch/s390/include/asm/mmu.h          |   13 -
 arch/s390/include/asm/mmu_context.h  |    6 +-
 arch/s390/include/asm/page.h         |    4 -
 arch/s390/include/asm/pgalloc.h      |    4 -
 arch/s390/include/asm/pgtable.h      |  171 +-
 arch/s390/include/asm/tlb.h          |    3 -
 arch/s390/include/asm/uaccess.h      |   70 +-
 arch/s390/include/asm/uv.h           |    3 +-
 arch/s390/kernel/uv.c                |  142 +-
 arch/s390/kvm/Kconfig                |    2 +
 arch/s390/kvm/Makefile               |    3 +-
 arch/s390/kvm/dat.c                  | 1368 +++++++++++++++
 arch/s390/kvm/dat.h                  |  965 ++++++++++
 arch/s390/kvm/diag.c                 |    2 +-
 arch/s390/kvm/faultin.c              |  148 ++
 arch/s390/kvm/faultin.h              |   92 +
 arch/s390/kvm/gaccess.c              |  940 +++++-----
 arch/s390/kvm/gaccess.h              |   20 +-
 arch/s390/kvm/gmap-vsie.c            |  141 --
 arch/s390/kvm/gmap.c                 | 1151 ++++++++++++
 arch/s390/kvm/gmap.h                 |  240 +++
 arch/s390/kvm/intercept.c            |   15 +-
 arch/s390/kvm/interrupt.c            |    6 +-
 arch/s390/kvm/kvm-s390.c             |  939 ++++------
 arch/s390/kvm/kvm-s390.h             |   27 +-
 arch/s390/kvm/priv.c                 |  213 +--
 arch/s390/kvm/pv.c                   |  177 +-
 arch/s390/kvm/vsie.c                 |  193 +-
 arch/s390/lib/uaccess.c              |  184 +-
 arch/s390/mm/Makefile                |    1 -
 arch/s390/mm/fault.c                 |    4 +-
 arch/s390/mm/gmap.c                  | 2436 --------------------------
 arch/s390/mm/gmap_helpers.c          |   96 +-
 arch/s390/mm/hugetlbpage.c           |   24 -
 arch/s390/mm/page-states.c           |    1 +
 arch/s390/mm/pageattr.c              |    7 -
 arch/s390/mm/pgalloc.c               |   24 -
 arch/s390/mm/pgtable.c               |  814 +--------
 include/uapi/linux/kvm.h             |   10 +
 mm/khugepaged.c                      |    9 -
 47 files changed, 5415 insertions(+), 5478 deletions(-)
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
2.52.0


