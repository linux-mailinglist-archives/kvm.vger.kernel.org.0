Return-Path: <kvm+bounces-36371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1F5A1A5F5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81B323AC647
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F064212B1F;
	Thu, 23 Jan 2025 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aB+bvbFt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F4320FAB7;
	Thu, 23 Jan 2025 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643600; cv=none; b=XQu+0xNOGuuWs42QTYFS2oYx9LwSfHnePeI7q6zf7Uh4bl1v/cXyw5X4L/OYjhw3x+7z9sVqp9bnwE+rTkCPefBcsyrsSaTftgSZF7FIwleRNjr1+fSsABivg+VxWa+NCudCLqbi4iZBklmfWET9g+Y+7T1kzhwb72NiE7jK0UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643600; c=relaxed/simple;
	bh=flG8xHwEAOebiyCLqg9AvS6ucl75kjEJvaBKU1pLsKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hxFZWcXiBaD8fSsKnIRQL8n7oflN7s6eX3fgUSjY9ivZV2z0MDSLfEks9F7NjZqhdio/skSW9WmwyM3Dv5PKXmsMg+sJtHgXkv5c8F5+hf/zy5JBPyhUUU15N5M5tYnaoVjkbfZYyA8Yza4TstbrpRG6zMmO0QmFWYkUeqIPiOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aB+bvbFt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50NB7WaR027270;
	Thu, 23 Jan 2025 14:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=R/xudS8a6TFMcGxck2rfPQc2Kn1TBu32wIAt7r8Zn
	Mk=; b=aB+bvbFtX3AEjAVgKfYx/Hef02yf1Vv4IfCYHgRYre7v2FAKHguDi1aKq
	0uwYBrdvelWyil8vi/3blZWFB0SbYtaBsUGfnzDZgOwuCwCTzPv1swvxyus9m83h
	/+FjW0KnpRwUXGlGNmQCkHI0aUGuMaWUR5dNqJ9wsi3BifMoSj2zNmPH+n92fX+L
	kwKQr//Z5sfvzzM/F1xVpIEVmo2lHJ66noB27BPomIbLM0F9dwTjdtwGJGNtRJPz
	WRNSghAq0xRyVLoHiuL5x4r2PWsO2fTvEr/VfdYr0lW5IVCLRH/le0Jk/oVITZEM
	K8GhVW7w2yJHxNyE4/7F5PR4KlrvQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b2xyp497-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NEkXuK001980;
	Thu, 23 Jan 2025 14:46:33 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b2xyp493-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NDnRrB019223;
	Thu, 23 Jan 2025 14:46:32 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 448pmsp5g0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkSfN60424662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD75420043;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74DD720040;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 00/15] KVM: s390: Stop using page->index and other things
Date: Thu, 23 Jan 2025 15:46:12 +0100
Message-ID: <20250123144627.312456-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WWNjs4fWtmV4AURfDGWbtYoBL9NTVunn
X-Proofpoint-ORIG-GUID: yy3sEad6JtKDH_VVu0t8NK0XZSrOEc5n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 mlxlogscore=748 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501230108

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

v2->v3
* moved patch 5 back to its place
* moved uv_wiggle_folio() to mm/gmap.c and renamed it to
  kvm_s390_wiggle_split_folio()
* fixed some typos
* added some lockdep asserts
* minor style fixes
* added some comments
* fixed documentation

v3->v4
* fixed some missing locks
* minor style fixes
* remove useless pt_list initialization
* fix comments
* rename gmap_shadow_pgt_lookup to shadow_pgt_lookup sinec it's static
* rename gmap_pgste_{g,s}et_index() to gmap_pgste_{g,s}et_pgt_addr()

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

Sean Christopherson (1):
  KVM: Do not restrict the size of KVM-internal memory regions

 Documentation/virt/kvm/api.rst                |   2 +-
 arch/s390/include/asm/gmap.h                  |  20 +-
 arch/s390/include/asm/kvm_host.h              |   2 +
 arch/s390/include/asm/pgtable.h               |  21 +-
 arch/s390/include/asm/uv.h                    |   6 +-
 arch/s390/kernel/uv.c                         | 292 +-------
 arch/s390/kvm/Makefile                        |   2 +-
 arch/s390/kvm/gaccess.c                       |  44 +-
 arch/s390/kvm/gmap-vsie.c                     | 139 ++++
 arch/s390/kvm/gmap.c                          | 209 ++++++
 arch/s390/kvm/gmap.h                          |  39 +
 arch/s390/kvm/intercept.c                     |   5 +-
 arch/s390/kvm/interrupt.c                     |  19 +-
 arch/s390/kvm/kvm-s390.c                      | 224 +++++-
 arch/s390/kvm/kvm-s390.h                      |  19 +
 arch/s390/kvm/pv.c                            |   1 +
 arch/s390/kvm/vsie.c                          |   2 +
 arch/s390/mm/gmap.c                           | 681 ++++--------------
 arch/s390/mm/pgalloc.c                        |   2 -
 .../selftests/kvm/s390x/ucontrol_test.c       |   8 +-
 virt/kvm/kvm_main.c                           |  10 +-
 21 files changed, 875 insertions(+), 872 deletions(-)
 create mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

-- 
2.48.1


