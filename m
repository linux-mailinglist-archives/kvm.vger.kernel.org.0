Return-Path: <kvm+bounces-64353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 27917C8049F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 46B2934345B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFC72FF66A;
	Mon, 24 Nov 2025 11:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Kj3faS6J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84C32EE263;
	Mon, 24 Nov 2025 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985368; cv=none; b=mfq6/2NVybrblkKxM+t48C7op+AmrIS3IcgPqOfUwtjxnm94tLubqCw6q7PQpSVhb9dgFye0G6nj2UJ0gqgAKllQWUFN4mlZPM+5dfdUQC6ckOvREiO3vjWObQTbssHj9WTbhru3AktgmSwdvvVIMhm/CA6Z8KK+iAwDp5EEfYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985368; c=relaxed/simple;
	bh=YmsVvnsMEUAHEALdCxVpa70Dgy98tYCSalUijbM3Cy4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sgfMCtmD/ytgkghKXK2g3oqJHQohhiGQl7HLTtOg9DXR0c9VYtBZ6wl5VbMJTOcJHi+xi6KTXmVWJlxMhmKD7KZUkTXaZS9e6INvoKp5kxN542RZC2EHWBpKDgjMnTQe5/lVrg+aLEiiVTKLywYShiF/wiDFx7xOc6+lNrX7y8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Kj3faS6J; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO5bbJ7006017;
	Mon, 24 Nov 2025 11:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=3csj4tL+vsKcTrND7cV62ojlFENzopnk/aWSX0z3N
	kA=; b=Kj3faS6JJJUxf9UcibVi5GYIgvpMrueXfwRDn4/nq3zrs01sSEchVGldJ
	aqgF6JYb6rfxvK1MTylRwnrGEbXeVCTjEEHU/YQ/OvrpuRrh5uoB5Du/ZFbnslqK
	dEDMYpHQdMVbX1Qo5U1toDsp6/I/nqRxP5hufyB6U6LGpayyUN7yl1lVNoyPY0aI
	bmZyURyaVbst594z/dyALw3RPAEo7729TfKQVl0YF7Cw+8AFL0y9xXUkoxW8nHsL
	Bl8W1mYwqwgOQsxGE781cy9fVNC8B7N90I+C2er8zYdPgk8wZ/25Nk6LGLt53D9K
	NSqbYQv9fKr4HtFEJcFAq5X0mtRlg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak3kjqgx0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOA8fU5000857;
	Mon, 24 Nov 2025 11:56:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvxnun5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:01 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBtvBZ35520934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:55:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 33E212004B;
	Mon, 24 Nov 2025 11:55:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6339220040;
	Mon, 24 Nov 2025 11:55:55 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:55:55 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 00/23] KVM: s390: gmap rewrite, the real deal
Date: Mon, 24 Nov 2025 12:55:31 +0100
Message-ID: <20251124115554.27049-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NiGmmg593hMdGIDtjVybib0BsXtuJ8NH
X-Authority-Analysis: v=2.4 cv=frbRpV4f c=1 sm=1 tr=0 ts=692447d2 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VqMf9zvxq0yzUyhZ9NsA:9
X-Proofpoint-ORIG-GUID: NiGmmg593hMdGIDtjVybib0BsXtuJ8NH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwOCBTYWx0ZWRfX+2aQlhseHBA1
 R9ca4hQmaqeMLw6As7N7a8Q4OIp3L+YJ7uUsCC6p2iVsj9oZqtkO0rOWZs4pzkCMRm+wTMPowlT
 QvD0t64TpWIch+OkCscqEOw7mM/FJdgZeR4aJpuW59pbkepDZwIFMb5Ni8Ikt4x2H0/RhFzxEP2
 XDEogNrA7HPRxDRYWFIaEFfZ3YFTWeVL7QE+bI5SFkz4XBNBFFjhf3u+dMpgwMQyidgu+vHxGTE
 uUaLhhm4icGtuKB8F4heiaeg1FBPK5SDe2RU011y11x0vqdXFugfJj12nl6fz4BtJz9nVDiz3bN
 +tWKtC8ZhsXUnNn1XY4box8SYYVyFi2+UeXq6WtQI1cmCnDtM+93QPjo2jSoFZ3Ybw1TPrewhdQ
 R/fi4ERSOIjZZ/E5GIAEjk/VH5tyCw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220008

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
 arch/s390/kvm/dat.c                  | 1368 ++++++++++++++
 arch/s390/kvm/dat.h                  |  965 ++++++++++
 arch/s390/kvm/diag.c                 |    2 +-
 arch/s390/kvm/faultin.c              |  148 ++
 arch/s390/kvm/faultin.h              |   92 +
 arch/s390/kvm/gaccess.c              |  943 +++++-----
 arch/s390/kvm/gaccess.h              |   20 +-
 arch/s390/kvm/gmap-vsie.c            |  141 --
 arch/s390/kvm/gmap.c                 | 1127 ++++++++++++
 arch/s390/kvm/gmap.h                 |  187 ++
 arch/s390/kvm/intercept.c            |   15 +-
 arch/s390/kvm/interrupt.c            |    2 +-
 arch/s390/kvm/kvm-s390.c             |  927 ++++------
 arch/s390/kvm/kvm-s390.h             |   28 +-
 arch/s390/kvm/priv.c                 |  213 +--
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
 44 files changed, 5190 insertions(+), 5316 deletions(-)
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


