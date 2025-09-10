Return-Path: <kvm+bounces-57220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39ABBB51FC4
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7461A16778A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5C933CE8F;
	Wed, 10 Sep 2025 18:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mWfFdecB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D1823F42D;
	Wed, 10 Sep 2025 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527675; cv=none; b=GRvfePsH1JhUXeOABtC1XFh8htVdvhlLPqdfZnnz42Hlido6r2tfa3UQ/jk151rSZduz/D053Qnm3EsGIUV+HiUqcsAvmyHCiuGLpUNBbUgwo+nUVjp0E9Qjcmsip/jIZfLaQ0OBiI1AROjZSa1YUJEiKTgPb2Pc/dggRLYSEEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527675; c=relaxed/simple;
	bh=gXmpDI0Up644NP5A0uI5tt11UmSwOjNcAmIMZCr7Wd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KQf407aAcUX2mAaSqR0EPYN7J1NUIj7c6ypnVlxf103PM2gznVC76UqBFOToGzK3zNZk14aTf+kywyV5jh9qZcrBGfrEjJyckYjYBJjwBFizlkhIjcHOv+wILt5Ina7HDkzS/zIr98k3TH4GKXC01nxPjM/ATWNMsyEM1eS2Brc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mWfFdecB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AE2gkB004387;
	Wed, 10 Sep 2025 18:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=dpmSJFxeKox1M0iHXtV9+FDpAECGPTXf9FpUrSzof
	iw=; b=mWfFdecBGtUpdQNajUH6B+B30vLzlRpWJ8AKNaXDRPhoTCTh6Wf19jy6Q
	vs5bA36vCHieEn1sdcBF0oMH64JhuQz25JtUF3FicvUD1QeuUcGlObw6FE7BlaZj
	cm29XQJvT0uoJWU/5ESXScrNbrjnGEAlqK7cA35GXA974uHOk7gPwuprDqncsa97
	Ms8q3R95UKPvrT0yHYc/5AXGmnTtJdpGIFS28BzxmBn7VBinxUtHO1/rNFuThqCG
	+lijKcmpophuyq8sNQHhvij1l+TVwKibsvrwLHFSaTq9MWtU6eCw36eOytyodSMa
	5kOru4Jb5646kMkxixazojDd8xsvg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsyge4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AFskoP011447;
	Wed, 10 Sep 2025 18:07:50 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9uj3u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7kf157016594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C07792004B;
	Wed, 10 Sep 2025 18:07:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87A9C20049;
	Wed, 10 Sep 2025 18:07:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 00/20] KVM: s390: gmap rewrite, the real deal
Date: Wed, 10 Sep 2025 20:07:26 +0200
Message-ID: <20250910180746.125776-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX6m1CtEU5tJlS
 T860RBjNxOBgxyYr9Z3iivypQJYBExBlLxB/hE3swM+GXqMNDVA9DjwRM9AHW0U6G11/NrIjZ20
 WLAfKg/OiXR1k8YhrNf7pInly0IwsExiBIrkQZD3Bilbp/SgGxPifeVe5xyZUAev17eejbzlzwO
 GSk/quduPH/oYN2MnUJtITT7bet4g/aZNZmOvP5uaYxfEHNAlVim3lS0DPQyfn43WishqfYArYE
 bCb/HPuNJaKAoE6kCO+Zsie1AmoJ81EoyjQ7wXQwcoqlesZtBGETF20Fvp7QBpwekNSzx6FiURJ
 UreOKdJg/Idick3lO+ems6TNVcI+ars/ZHhDB4rVwZZQvkTVZwEVOm79+nPGJdTwUArqivClnoL
 ShkfXXgu
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c1be77 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=iDv8STmvC8ZgVg2ABJcA:9
X-Proofpoint-GUID: 6urVWTW1YovNsoWbl6xyKLmdDtLYtgVc
X-Proofpoint-ORIG-GUID: 6urVWTW1YovNsoWbl6xyKLmdDtLYtgVc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

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

Patch 7 to 14 is the meat of the new gmap code; page table management
functions and gmap management. This is the code that will be used to
manage guest memory.

Patch 16 is unfortunately big; the existing code is converted to use
the new gmap and all references to the old gmap are removed. This needs
to be done all at once, unfortunately, hence the size of the patch.

Patch 17 and 18 remove all the now unused code.

Patch 19 and 20 allow for 1M pages to be used to back guests, and add
some more functions that are useful for testing.


If you are not in the CC list, you probably have not received v1, as
it was not sent out publicly; you did not miss it :)
That's also where the various R-Bs come from.


Claudio Imbrenda (20):
  KVM: s390: add P bit in table entry bitfields, move union vaddress
  s390: Move sske_frame() to a header
  KVM: s390: Add gmap_helper_set_unused()
  KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
  KVM: s390: Add helper functions for fault handling
  KVM: s390: Rename some functions in gaccess.c
  KVM: s390: KVM-specific bitfields and helper functions
  KVM: s390: KVM page table management functions: allocation
  KVM: s390: KVM page table management functions: clear and replace
  KVM: s390: KVM page table management functions: walks
  KVM: s390: KVM page table management functions: storage keys
  KVM: s390: KVM page table management functions: lifecycle management
  KVM: s390: KVM page table management functions: CMMA
  KVM: s390: New gmap code
  KVM: s390: Stop using CONFIG_PGSTE
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
 arch/s390/include/asm/kvm_host.h     |    1 +
 arch/s390/include/asm/mmu.h          |   13 -
 arch/s390/include/asm/mmu_context.h  |    6 +-
 arch/s390/include/asm/page.h         |    4 -
 arch/s390/include/asm/pgalloc.h      |    2 -
 arch/s390/include/asm/pgtable.h      |  119 +-
 arch/s390/include/asm/tlb.h          |    3 -
 arch/s390/kvm/Kconfig                |    3 +-
 arch/s390/kvm/Makefile               |    3 +-
 arch/s390/kvm/dat.c                  | 1260 +++++++++++++
 arch/s390/kvm/dat.h                  |  843 +++++++++
 arch/s390/kvm/diag.c                 |    2 +-
 arch/s390/kvm/gaccess.c              |  599 ++++---
 arch/s390/kvm/gaccess.h              |   30 +-
 arch/s390/kvm/gmap-vsie.c            |  141 --
 arch/s390/kvm/gmap.c                 | 1066 +++++++++++
 arch/s390/kvm/gmap.h                 |  178 ++
 arch/s390/kvm/intercept.c            |    8 +-
 arch/s390/kvm/interrupt.c            |    2 +-
 arch/s390/kvm/kvm-s390.c             |  808 ++++-----
 arch/s390/kvm/kvm-s390.h             |   75 +-
 arch/s390/kvm/priv.c                 |  206 +--
 arch/s390/kvm/pv.c                   |   87 +-
 arch/s390/kvm/vsie.c                 |  116 +-
 arch/s390/mm/Makefile                |    1 -
 arch/s390/mm/fault.c                 |    4 +-
 arch/s390/mm/gmap.c                  | 2452 --------------------------
 arch/s390/mm/gmap_helpers.c          |   64 +
 arch/s390/mm/hugetlbpage.c           |   24 -
 arch/s390/mm/page-states.c           |    1 +
 arch/s390/mm/pageattr.c              |    7 -
 arch/s390/mm/pgalloc.c               |   29 -
 arch/s390/mm/pgtable.c               |  837 +--------
 include/uapi/linux/kvm.h             |   10 +
 mm/khugepaged.c                      |    9 -
 40 files changed, 4380 insertions(+), 4845 deletions(-)
 delete mode 100644 arch/s390/include/asm/gmap.h
 create mode 100644 arch/s390/kvm/dat.c
 create mode 100644 arch/s390/kvm/dat.h
 delete mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h
 delete mode 100644 arch/s390/mm/gmap.c

-- 
2.51.0


