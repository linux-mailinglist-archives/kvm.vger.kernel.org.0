Return-Path: <kvm+bounces-34816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC5BA06416
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F7453A6153
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523D2202C51;
	Wed,  8 Jan 2025 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gqn5WWor"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F23E201002;
	Wed,  8 Jan 2025 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360106; cv=none; b=iyQaxF+Y8Xom3+f/h8EUAWBr2soyWhgIcguZWPMMewWQQ3dBINTTDB6wmegSunFpbqEsJZHjIPWNjiqggaByT03Az/M2uu2/41onSXpP6ySKME0pDL48NfPZkZrMZTaHYqTwZcWeZaiz7cyjOl5LQ5JKKN/Vpx0fEMC4DVvhCns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360106; c=relaxed/simple;
	bh=qoCea1jcd5aT1+rcSyosqTQ7pq2LW3Xd1JAXvG7Ij1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sPzrC30QCxEHPn6pCak3NqG10wq/KLH9VKpy2rM4Ii0GJ+eiWqP7KbvEyKcaF446gzt30bENhUtt5jbTlGvDaEQvDlzYWXsscdYha+Pg6/Q3d0ExWnI6avZyuo8eNN5AD8F92Oq3+1MKMjaOLsDBhJiXkPG/ppxSt0DlARgLZQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gqn5WWor; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508BdQuC027187;
	Wed, 8 Jan 2025 18:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=z/UnLXAdk7gCH/X1bdXUOQWHPRdlGMsMtg/TjUhBA
	zQ=; b=Gqn5WWorIdeDs5zckOECWwac1UiZ0dwTVXIiFhGi5ZFWkBRZxOycrt4Lz
	wuFKj3vm0YHcH1mI2TYMHvm4T6PsJQRgXFttNUXdxZTx9pSwWhcFlWQqFvZM1u5m
	q2OKfncZxaqI3NE6vgWeizMVjF1HIi16C19oNXH6a4yliLtZx35dtp0FbwgbHMOf
	2lVLuHeS8w5UyRlKCRdCn6Xxw5zF16QsPIei5H9gynsJ84jGoLpvx1ZNAlUJ1iZT
	NJeL2SfVqqEpsyUw9dgXSvJ71Ti2Wc9OpK0CyJmgOwCgtL9aOQVwtHutTC+w07LE
	r3lJO+AXS/KztPFaxgk23u1R35WvA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441e3b4d39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508FbBCM003601;
	Wed, 8 Jan 2025 18:14:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yfat99mx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEqqO59376052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FAD920043;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3800920040;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 00/13] KVM: s390: Stop using page->index and other things
Date: Wed,  8 Jan 2025 19:14:38 +0100
Message-ID: <20250108181451.74383-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d3KuYmufYOYMUqcKnDuasFvSwBDFmFdk
X-Proofpoint-GUID: d3KuYmufYOYMUqcKnDuasFvSwBDFmFdk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxlogscore=447 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

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

Claudio Imbrenda (13):
  KVM: s390: wrapper for KVM_BUG
  KVM: s390: fake memslots for ucontrol VMs
  KVM: s390: use __kvm_faultin_pfn()
  KVM: s390: move pv gmap functions into kvm
  KVM: s390: get rid of gmap_fault()
  KVM: s390: get rid of gmap_translate()
  KVM: s390: move some gmap shadowing functions away from mm/gmap.c
  KVM: s390: stop using page->index for non-shadow gmaps
  KVM: s390: stop using lists to keep track of used dat tables
  KVM: s390: move gmap_shadow_pgt_lookup() into kvm
  KVM: s390: remove useless page->index usage
  KVM: s390: move PGSTE softbits
  KVM: s390: remove the last user of page->index

 arch/s390/include/asm/gmap.h    |  16 +-
 arch/s390/include/asm/pgtable.h |  21 +-
 arch/s390/include/asm/uv.h      |   7 +-
 arch/s390/kernel/uv.c           | 293 +++------------
 arch/s390/kvm/Makefile          |   2 +-
 arch/s390/kvm/gaccess.c         |  42 +++
 arch/s390/kvm/gmap.c            | 183 ++++++++++
 arch/s390/kvm/gmap.h            |  19 +
 arch/s390/kvm/intercept.c       |   5 +-
 arch/s390/kvm/interrupt.c       |  19 +-
 arch/s390/kvm/kvm-s390.c        | 229 ++++++++++--
 arch/s390/kvm/kvm-s390.h        |  18 +
 arch/s390/kvm/pv.c              |   1 +
 arch/s390/kvm/vsie.c            | 137 +++++++
 arch/s390/mm/gmap.c             | 630 ++++++--------------------------
 15 files changed, 786 insertions(+), 836 deletions(-)
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

-- 
2.47.1


