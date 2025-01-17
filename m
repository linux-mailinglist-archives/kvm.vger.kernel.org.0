Return-Path: <kvm+bounces-35851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D231A157D4
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 882C31881488
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AC11A9B5C;
	Fri, 17 Jan 2025 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Q/dk60A1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD95D1A83E4;
	Fri, 17 Jan 2025 19:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140990; cv=none; b=e+vsTNrLZK8o4y4CBkVMtfftiRg3V4dyvqgXom6TXJcOeXkv4pW5kR+tnxdM4Tg5WpHoY/0FK2eoQCZuH10yzC4YdlLQ0+L/0sneR1fUdfpVATZY/rT7Tu/Bv4FwKPE/KpQx0h6RcKqVYkgoGYgAvvXmdN2iBTV9zaM/wNv6+sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140990; c=relaxed/simple;
	bh=1rhkKN6yVUMro8cr5+/x4h7CR9pzZVCmfgXsFG+oDaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qLuokQwVj6+wWbrcYvHb4Pe+rQPPBHUSptr4An8yLJZLlC/4abWlFT6BAXHPaAdIz6Gun2/tmTN7xB6/IUmMNmSjyT8GSenDdOyDLIAAJ+dYSDG4LRUWFVUTN8BByebZQhdLe7OnQoWLiVZzUyA/Z7JME2MfrX0Ryz9Va/CZMLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Q/dk60A1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HEkrQL015094;
	Fri, 17 Jan 2025 19:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=o4h9hJqbOdh+6Zjq+Fcwapr/Kn6LQtscO3Sk2enTf
	e4=; b=Q/dk60A1ZiPAJJx1yoYiasxUWRydqBUGKIKZs0eWx5IckcsOQMI0cHCrY
	Fng2a2DJPuY/Zz9t/XIwhaska2kugA6ncc6AenkZ/h/g/wpjlm85G8WpU0W0a/6q
	rKSzHqUrbQtYQKWqbWBjvdGvQTKv9L4vcVedZNEr01zlaitkkMb7oWCMe3ijN9tq
	lOJfzH3xA3XYaXmpiu9GBdHBL76h4MkGVbiMDAZuWf2kJAyOXc3dYqkdxvdAiFlX
	ED5l5YBa6/QjFJf17v7/AqW7uIlg20nmmCFj0aYptIn0yehs+45ofhVlp/0QMrkN
	sRx+RDPEDIDU0GngNewPfNsvIv09Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpuc1yj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ9isq009160;
	Fri, 17 Jan 2025 19:09:44 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpuc1yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIXXYA017359;
	Fri, 17 Jan 2025 19:09:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkma8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9daJ55116112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CCFD20043;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA17220040;
	Fri, 17 Jan 2025 19:09:38 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:38 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 00/15] KVM: s390: Stop using page->index and other things
Date: Fri, 17 Jan 2025 20:09:23 +0100
Message-ID: <20250117190938.93793-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r_bwIuLHishf0mOVybAis-CRLkDFtzZ-
X-Proofpoint-ORIG-GUID: iFJU1rLk-9-JBUz0lPTAX-Tp_BV_m2px
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=692
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170149

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
 arch/s390/include/asm/gmap.h                  |  18 +-
 arch/s390/include/asm/kvm_host.h              |   2 +
 arch/s390/include/asm/pgtable.h               |  21 +-
 arch/s390/include/asm/uv.h                    |   6 +-
 arch/s390/kernel/uv.c                         | 292 +-------
 arch/s390/kvm/Makefile                        |   2 +-
 arch/s390/kvm/gaccess.c                       |  42 ++
 arch/s390/kvm/gmap-vsie.c                     | 142 ++++
 arch/s390/kvm/gmap.c                          | 206 ++++++
 arch/s390/kvm/gmap.h                          |  39 +
 arch/s390/kvm/intercept.c                     |   5 +-
 arch/s390/kvm/interrupt.c                     |  19 +-
 arch/s390/kvm/kvm-s390.c                      | 219 +++++-
 arch/s390/kvm/kvm-s390.h                      |  19 +
 arch/s390/kvm/pv.c                            |   1 +
 arch/s390/kvm/vsie.c                          |   2 +
 arch/s390/mm/gmap.c                           | 681 ++++--------------
 .../selftests/kvm/s390x/ucontrol_test.c       |   6 +-
 virt/kvm/kvm_main.c                           |  10 +-
 20 files changed, 867 insertions(+), 867 deletions(-)
 create mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

-- 
2.48.1


