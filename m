Return-Path: <kvm+bounces-47581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BC5AC235A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 15:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04C92A40583
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E144618C03D;
	Fri, 23 May 2025 13:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rG//iVox"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B06D155C88;
	Fri, 23 May 2025 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748005438; cv=none; b=qubJr1nC2G+AQ8G1M2pyaThPELx5cCX5Y7RbNaRlfdBgEH4bgE6AZhV3AmTKSfRH211QK66mXxUeiRHBP6xjwwAgEsKA2d4IP2aZ0+vkvY+FPIasoLp4khgx7plsclaRzUa9I/ZSws98p1AMZJ6z6eYGzUc3k2FTx6teefvQAjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748005438; c=relaxed/simple;
	bh=0zSq4fWRgRO6hnZPy+gwnjOr0jfAYOIAROJ8L7Lxjfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HdMZVnyfDyuN21q+2FRmgz9Fn/2GljNdfm+R4PZ2H3HlTYxQPP/9Rc8isIKnQjLsDZzzwkv/6Y4jUQfgqlKg/oqC2CmkaYBvNfdk3Fn8xHkMgVMo2P4Iy8t7HihBrspx6EGh5i27tcIi+u/Ty2n6pfHN+4a6/SdgUD6HH0s73Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rG//iVox; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NBeikn009197;
	Fri, 23 May 2025 13:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=bD0F4R81TtBIcuipJEl/B87JuiKQthCz8AWdILdeA
	aU=; b=rG//iVoxAFJXnzeLE8h1Mvj7JQA4v5jreXmdZWa1SRQRkbKIknuEnC5EN
	a8O8WUD7Qzxl+hWrXpA+lSBH4gtjtZTsEBMuc9gmQIM9rYdsWAjxjZDqiV8FcPjN
	TkOCdIS1xPnXcdBQbX0kL3Aak8j0B3LS0CYJRPul7ChENp+uxPhCimr/GUepbdqU
	LElK5bqf01X45+vXiG+56sKu5Usk2RKm4d5dKMIl+1SX/kHfIEqfifGNUbv56QZb
	LsgpnN4ClVXYli7wvqYYpI/nEf7pFGVZ7lQV6+ZxXPpPKoOwFo90j8dhlBgqGhSP
	LUbxZv8uzQneD39bJqFkHmQrxz/2w==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t5535mct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NAi0cv024711;
	Fri, 23 May 2025 13:03:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkren12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54ND3ncE45351190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 13:03:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 447142004B;
	Fri, 23 May 2025 13:03:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D12A820043;
	Fri, 23 May 2025 13:03:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 13:03:48 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v4 0/4] KVM: s390: some cleanup and small fixes
Date: Fri, 23 May 2025 15:03:44 +0200
Message-ID: <20250523130348.247446-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ll6WVQqF9rDZ1FHToOX3KjjPMfgdEVqz
X-Proofpoint-ORIG-GUID: ll6WVQqF9rDZ1FHToOX3KjjPMfgdEVqz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDExNSBTYWx0ZWRfXz1SJbpmcqrZ+ sT+IbqelthAQhwej7Swj2bY1z+f5W5mAkXO3B7Dj5+uA06pfispRt+aHhhOl7E/X3FnwpLZpO9p mOr8sCzwUqqeZ3a/c31OmPyWOPJ3RmF0oiTc9UFt62omiYotL7oWo5o/s0CHoju/egVwO0HWzwI
 bcjkFyg0zoXubEN5eXU5d59vSYaKKH3U1iYLydB/oEx0cZ77f1qIeMcEPCETJTpnp9A+KRMpuVn sA4ALMF5TaIMjpXcWBkok1Zt/RnkdZpvGXNL8RwYngHMNM3aEMDmYiQ3ep7SONKFue5bS5SIh15 R/zvU3kotVtVmZjUl9u7txfZshxykwk8y+JGs68f07A7QgaJniBA55+hwTi0roaj4oloXm5vowl
 t8YmcRwKm0we9VBvDZpiwpvqdXtw02aJYkMnWmW4Ml+ddCNXhbLZ1Czo+GwOUF1V/jVH4Uur
X-Authority-Analysis: v=2.4 cv=BOmzrEQG c=1 sm=1 tr=0 ts=68307239 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=dt9VzEwgFbYA:10 a=gRRxI3zbkkyk7srOQjYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_03,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=580
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230115

This series has some cleanups and small fixes in preparation of the
upcoming series that will finally completely move all guest page table
handling into kvm. The cleaups and fixes in this series are good enough
on their own, hence why they are being sent now.

v3->v4
* remove orphaned find_zeropage_ops and find_zeropage_pte_entry() from
  mm/gmap.c (thanks kernel test robot)
* add missing #include <linux/swapops.h> to mm/gmap_helpers.c (thanks
  kernel test robot)

v2->v3  (mainly addresses Nina's and Heiko's comments)
* drop patch 3 - it was just an attempt to clean up the code a little
  and make it more readable, but there were too many issues to address
* remove all dead code from s390/mm/gmap.c that is being replaced by
  code in s390/mm/gmap_helpers.c
* remove a couple of unused functions from s390/mm/gmap_helpers.c, some
  of them will be introduced again in a later series when they are
  actually needed
* added documentation to the functions in s390/mm/gmap_helpers.c
* general readability improvements

v1->v2
* remove uneeded "gmap.h" include from gaccess.c (thanks Christph)
* use a custom helper instead of u64_replace_bits() (thanks Nina)
* new helper functions in priv.c to increase readability (thanks Nina)
* add lockdep assertion in handle_essa() (thanks Nina)
* gmap_helper_disable_cow_sharing() will not take the mmap lock, and
  must now be called while already holding the mmap lock in write mode

Claudio Imbrenda (4):
  s390: remove unneeded includes
  KVM: s390: remove unneeded srcu lock
  KVM: s390: refactor and split some gmap helpers
  KVM: s390: simplify and move pv code

 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap.h         |   2 -
 arch/s390/include/asm/gmap_helpers.h |  15 ++
 arch/s390/include/asm/tlb.h          |   1 +
 arch/s390/include/asm/uv.h           |   1 -
 arch/s390/kernel/uv.c                |  12 +-
 arch/s390/kvm/Makefile               |   2 +-
 arch/s390/kvm/diag.c                 |  13 +-
 arch/s390/kvm/gaccess.c              |   3 +-
 arch/s390/kvm/gmap-vsie.c            |   1 -
 arch/s390/kvm/gmap.c                 | 121 ---------------
 arch/s390/kvm/gmap.h                 |  39 -----
 arch/s390/kvm/intercept.c            |   9 +-
 arch/s390/kvm/kvm-s390.c             |  10 +-
 arch/s390/kvm/kvm-s390.h             |  42 +++++
 arch/s390/kvm/priv.c                 |   6 +-
 arch/s390/kvm/pv.c                   |  61 +++++++-
 arch/s390/kvm/vsie.c                 |  19 ++-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/fault.c                 |   1 -
 arch/s390/mm/gmap.c                  | 185 +---------------------
 arch/s390/mm/gmap_helpers.c          | 224 +++++++++++++++++++++++++++
 arch/s390/mm/init.c                  |   1 -
 arch/s390/mm/pgalloc.c               |   2 -
 arch/s390/mm/pgtable.c               |   1 -
 25 files changed, 396 insertions(+), 379 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h
 create mode 100644 arch/s390/mm/gmap_helpers.c

-- 
2.49.0


