Return-Path: <kvm+bounces-47170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8777DABE2A0
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D91B73BCA66
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D56280307;
	Tue, 20 May 2025 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DH/iDcsV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E653125B1D8;
	Tue, 20 May 2025 18:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747765608; cv=none; b=pY4d2H9x1pc05ZFatR58uPOLgoPSpVXDatJpvKvyaSBevNhppzjFSN46r+SGHJOvs3w9Z2J5zD4D9pOiLI1AXlm3moGBccbj1MApJhY7gf70a/dYop9CbPp0qa68PV5ZLmkQ0EaUvqkc6Aek8cCJUVYZK8slnVGl/1mfZ2nLx7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747765608; c=relaxed/simple;
	bh=/XMRb0MfNw+5jvWrA/WH2pCZnhsBz7UzCZ+thJhOXbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TA+A2ceQ7o3+S/bYf4KSNl4qCfwD4XrSMGWSzT98yE2jbcbZX6eyVXxFwU1IeAI3pQRqKFNxQXTV2O8NajrXzNasEe4Bq6YxR3fnoZcVJZ7ObZ/ymcA2hEHjaaPiViOW3saLowWTJ7uEO8EolTDhpMWgbdrZtAb0HISIiM0PqFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DH/iDcsV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KH6wEi024358;
	Tue, 20 May 2025 18:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=EtHUHKCdAsIPdASzEbSSUmdfCC1lGRJkNGp8uAkKu
	8I=; b=DH/iDcsVisSDNnnTsfp1JMENgRQx0LwboW+hjFgqDB3Lqw0X8pqMYjxE7
	qqBL1tuDXWobd3cHElixQIf2ElIFESOzbHjd0CdjcNX7OhuFuGAK9ScmInGBN6/p
	q9PXJZ7kZ1ZuVCn0102IRmRDwm67b83KzT/r0zf3o75y0Tt0FBA7B4b5/y7HyATh
	1hWLdlZ1cod2B7qdJJAwfaSm4ofXDFQ4TF/yas5nMMWyJyhquV49ZXhNmVt2KkXv
	5mFVofEleQ+uiNpd1QQq1PcMhVUxWk4NHDGcOLcBWA7pKrOpqoY6GAdm2Se5V4nH
	AyKB0GqIfXsi6Srw98keu8x0SUayQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rwut8c1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KGrfmY010613;
	Tue, 20 May 2025 18:26:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwnm8cx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:43 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KIQdvc52232508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 18:26:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A65312004B;
	Tue, 20 May 2025 18:26:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B53220040;
	Tue, 20 May 2025 18:26:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 18:26:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v2 0/5] KVM: s390: some cleanup and small fixes
Date: Tue, 20 May 2025 20:26:34 +0200
Message-ID: <20250520182639.80013-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AdbBCgQXuU4_Jc-DDrR3DrwAbm_6v8t_
X-Proofpoint-GUID: AdbBCgQXuU4_Jc-DDrR3DrwAbm_6v8t_
X-Authority-Analysis: v=2.4 cv=MMRgmNZl c=1 sm=1 tr=0 ts=682cc964 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=dt9VzEwgFbYA:10 a=mc03PJ0X8kF70Z1LeTwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDE1MCBTYWx0ZWRfX3gyaczXTjBBI fCCXZYGBhQo73knj+SWqW8mTpNDTRTTCiy93FWudQNm5zaCBAUHFCt1A5x6WCCSS2CVdL307Omi 9JAvV3IOdkYG6ich1Q/mqvrVrfc/53G27Uor4uuL5lwRbDy1o77lkE7qyIs+jIYfjFbQxn0xioZ
 w/ixzzWvoMoHQnL9+9tWA1PZM2FE+XfA+bb58JiJJ/QJc21FslEoRdNNRwA2nh6rt+c9T79GG4I Co7zqWUon9F58opS+FYg8hXyUM1xe/6n6WlJHGmxUyNG5l0kHjX2OVjeUpqgI0IKsM0Ft5SvT36 FQfGSyFuLNEnPzKoMc/V/++b+ULVzSB9L2XqKgQjFxOSCVEX3I7ctVOoD3LbIL2qB2/Gi7KSCiZ
 nt9kHkKFOpP3M8LzCL9nAi/XsquIDCfG4cbsa63IBZYlXhaaw5BcxHGnRlJKCDbOQTbQv2BB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_08,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=786 impostorscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505200150

This series has some cleanups and small fixes in preparation of the
upcoming series that will finally completely move all guest page table
handling into kvm. The cleaups and fixes in this series are good enough
on their own, hence why they are being sent now.

v1->v2
* remove uneeded "gmap.h" include from gaccess.c (thanks Christph)
* use a custom helper instead of u64_replace_bits() (thanks Nina)
* new helper functions in priv.c to increase readability (thanks Nina)
* add lockdep assertion in handle_essa() (thanks Nina)
* gmap_helper_disable_cow_sharing() will not take the mmap lock, and
  must now be called while already holding the mmap lock in write mode

Claudio Imbrenda (5):
  s390: remove unneeded includes
  KVM: s390: remove unneeded srcu lock
  KVM: s390: refactor some functions in priv.c
  KVM: s390: refactor and split some gmap helpers
  KVM: s390: simplify and move pv code

 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap_helpers.h |  18 ++
 arch/s390/include/asm/tlb.h          |   1 +
 arch/s390/include/asm/uv.h           |   1 -
 arch/s390/kernel/uv.c                |  12 +-
 arch/s390/kvm/Makefile               |   2 +-
 arch/s390/kvm/diag.c                 |  11 +-
 arch/s390/kvm/gaccess.c              |   3 +-
 arch/s390/kvm/gmap-vsie.c            |   1 -
 arch/s390/kvm/gmap.c                 | 121 -----------
 arch/s390/kvm/gmap.h                 |  39 ----
 arch/s390/kvm/intercept.c            |   9 +-
 arch/s390/kvm/kvm-s390.c             |  10 +-
 arch/s390/kvm/kvm-s390.h             |  57 ++++++
 arch/s390/kvm/priv.c                 | 287 +++++++++++++--------------
 arch/s390/kvm/pv.c                   |  61 +++++-
 arch/s390/kvm/vsie.c                 |  19 +-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/fault.c                 |   1 -
 arch/s390/mm/gmap.c                  |  47 +----
 arch/s390/mm/gmap_helpers.c          | 259 ++++++++++++++++++++++++
 arch/s390/mm/init.c                  |   1 -
 arch/s390/mm/pgalloc.c               |   2 -
 arch/s390/mm/pgtable.c               |   1 -
 24 files changed, 591 insertions(+), 376 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h
 create mode 100644 arch/s390/mm/gmap_helpers.c

-- 
2.49.0


