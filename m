Return-Path: <kvm+bounces-36977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCB8A23CF9
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6ED3AA96D
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3EC1E98FD;
	Fri, 31 Jan 2025 11:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sOf/ii5K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF221EC016;
	Fri, 31 Jan 2025 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322724; cv=none; b=T5w3vPQrDJJY07Qvj2+gW4IMbsjkPFfWa81icTJMCTZOlx5K4DgrqkESfiwmGC8u3NoNt2itvTCctzewkywBTTAtF3Jx1aLCGHtn+MIAP57XM/WZ3fEjh3+J+fLFWFrC2uayIaEQAJgmN7b27ADymX1tyDtTYw+mEH0Cte+dD8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322724; c=relaxed/simple;
	bh=FWTDP1rk8DhN4KiP/c62NuMgHbTEIYOMQ9gSclJYTf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PhdmtH5UbRgSxa0l6gbHTY9emqKaledTvhN1ko7qJh1MiEYPC3Pi/g/qIO06RfRoDU0DBfkrVCgSVcgEK9bVL4/HUBJUB8FWN87haT0iPLlooBvykUiL/ZS/6bwOnR03YGppfgHpeWnv1HM5bJr6qrcTXw6NOy9MRcGgMrt7EfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sOf/ii5K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V7Wqbd009647;
	Fri, 31 Jan 2025 11:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=QdZ7+INnoGa6djL8g+i1n3RTdyMfjnw8D3kNVHAT8
	rg=; b=sOf/ii5KCmAn36pB2udvrplnJobrkbpToAfmwck4yv1qx/eO/bACr0pw4
	/WfIho/JKanma6Y6xVnXQmZSpeWPH9ErOhsXr3eFS1GO4d9J3I6lIhTkgKphOY94
	pELpbhJIdu+gVcOJ6dqv1cguOPsHaKV+bjDGuzh2gOMT44L84b/lc9RrOgfRX/RV
	Jf8nA0X5j9UsLJ3Fev7D55AdeAsvH4Q3lGN1gZOJxvc1gSlA0DpSnPZP51gHQXeL
	7BIgymAZM1dHa0/1VFfqAoNMjHMmu61hylE1+01oUMQP6SYOrSsR3K6T1ePWBtJS
	95gihteeRiCAGm8E4AdOFCst85M2g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gt7n8v2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8MOpt017346;
	Fri, 31 Jan 2025 11:25:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gfaxb8jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:19 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPFBh56820006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18B952013A;
	Fri, 31 Jan 2025 11:25:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6585220132;
	Fri, 31 Jan 2025 11:25:10 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:10 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 00/20] KVM: s390: some non-trivial fixes and cleanups for 6.14
Date: Fri, 31 Jan 2025 12:24:50 +0100
Message-ID: <20250131112510.48531-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OIDRb8r_C0OQ5VB7rQVG2Iruzpg2B439
X-Proofpoint-ORIG-GUID: OIDRb8r_C0OQ5VB7rQVG2Iruzpg2B439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=635
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

Ciao Paolo,

please pull the following changes:

- some selftest fixes
- move some kvm-related functions from mm into kvm
- remove all usage of page->index and page->lru from kvm
- fixes and cleanups for vsie


and this time I did not forget any Signed-off-by: tags! *facepalm*
sorry for the noise


The following changes since commit 72deda0abee6e705ae71a93f69f55e33be5bca5c:

  Merge tag 'soundwire-6.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/soundwire (2025-01-29 14:38:19 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.14-2

for you to fetch changes up to 32239066776a27287837a193b37c6e55259e5c10:

  KVM: s390: selftests: Streamline uc_skey test to issue iske after sske (2025-01-31 12:03:53 +0100)

----------------------------------------------------------------
- some selftest fixes
- move some kvm-related functions from mm into kvm
- remove all usage of page->index and page->lru from kvm
- fixes and cleanups for vsie

----------------------------------------------------------------
Christoph Schlameuss (1):
      KVM: s390: selftests: Streamline uc_skey test to issue iske after sske

Claudio Imbrenda (14):
      KVM: s390: wrapper for KVM_BUG
      KVM: s390: fake memslot for ucontrol VMs
      KVM: s390: selftests: fix ucontrol memory region test
      KVM: s390: move pv gmap functions into kvm
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

David Hildenbrand (4):
      KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
      KVM: s390: vsie: stop using page->index
      KVM: s390: vsie: stop messing with page refcount
      KVM: s390: vsie: stop using "struct page" for vsie page

Sean Christopherson (1):
      KVM: Do not restrict the size of KVM-internal memory regions

 Documentation/virt/kvm/api.rst                   |   2 +-
 arch/s390/include/asm/gmap.h                     |  20 +-
 arch/s390/include/asm/kvm_host.h                 |   6 +-
 arch/s390/include/asm/pgtable.h                  |  21 +-
 arch/s390/include/asm/uv.h                       |   6 +-
 arch/s390/kernel/uv.c                            | 292 +---------
 arch/s390/kvm/Makefile                           |   2 +-
 arch/s390/kvm/gaccess.c                          |  44 +-
 arch/s390/kvm/gmap-vsie.c                        | 142 +++++
 arch/s390/kvm/gmap.c                             | 212 +++++++
 arch/s390/kvm/gmap.h                             |  39 ++
 arch/s390/kvm/intercept.c                        |   7 +-
 arch/s390/kvm/interrupt.c                        |  19 +-
 arch/s390/kvm/kvm-s390.c                         | 237 ++++++--
 arch/s390/kvm/kvm-s390.h                         |  19 +
 arch/s390/kvm/pv.c                               |  21 +
 arch/s390/kvm/vsie.c                             | 106 ++--
 arch/s390/mm/gmap.c                              | 681 +++++------------------
 arch/s390/mm/pgalloc.c                           |   2 -
 tools/testing/selftests/kvm/s390/ucontrol_test.c |  32 +-
 virt/kvm/kvm_main.c                              |  10 +-
 21 files changed, 990 insertions(+), 930 deletions(-)
 create mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

