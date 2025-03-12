Return-Path: <kvm+bounces-40851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C22A5E3DF
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 19:49:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A62977AAE14
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB393259C80;
	Wed, 12 Mar 2025 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Iz6+lo7F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A7B256C9E;
	Wed, 12 Mar 2025 18:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741805365; cv=none; b=ff11xeAMgg0ljw4g22FhoEbJSl6JMqrSMya/CmH3q79EXz8ZQ7/fLLKuiM+kZuYrg7jrnN/UbG6antFE3MehvowkDEbNuSWVSY9I5eIrv9SkU9KijV+DWsJDIEf5nDpkS1PmYyiUhuu58XLCQkflv2vZ+/lqmAcbxPrup6IZAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741805365; c=relaxed/simple;
	bh=GT7Ur/fHVJ/5kHo1xkE/Nzq5Zr8FHdgFHRbUJ+8Z2S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VkELIl1U0tMQzMWryYxUBgM5awPpW9ted2nlelXxMWfrM7cTSvEi8O9g7NsCKpP3+GgtxlqM7IQIl4dxLlxQ9GYQCkrON4N7o/u+6joGkD3iYurnxoEBdE6g+KBBD+ZSWDvMM+cn/haSIF2zc3xsYFWcYAuGg9PMxGQd7vzMd3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Iz6+lo7F; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52CE3Cuo023053;
	Wed, 12 Mar 2025 18:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=eJv6CMZTeAWiqTEj5pHxA1za2DHaIFt/JjPA1zTS0
	70=; b=Iz6+lo7F7Sbe4x88L2Ha1Rt0tZXjepNmJ26cky38bI+MkMdmJqVcj0SnZ
	AD7ZkyrlaTc4O5j4K1XPB/X4Kzkigck1uutfBW9+GPh6NkEHAkLL2rH1Z/fB9pS6
	rrO+Erv7rym9qUdhfsVRFuujTlgm0IxkHu9gkky4lEO2byZUJK3fwfFfYt7fs15k
	KiQPLI55p7SO/mXrYW/PHVQBFRvuvkgqCGPfbWly31A+G65aMoSmRExptScBsuDy
	QVDSGkzTXwmpOHwtdz5doRPvDW9LiTzOReUk2vJig8VOvxHCE8nHSwAW6u6uBBaH
	tU93RJASP1WXg+Cu+k9EkARHjYVxg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45bbppshwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Mar 2025 18:49:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52CHR49c012246;
	Wed, 12 Mar 2025 18:49:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45atsrdpdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Mar 2025 18:49:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52CInD6L44827056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 18:49:13 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C91320043;
	Wed, 12 Mar 2025 18:49:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E4E620040;
	Wed, 12 Mar 2025 18:49:13 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Mar 2025 18:49:13 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v5 0/1] KVM: s390: fix a newly introduced bug
Date: Wed, 12 Mar 2025 19:49:11 +0100
Message-ID: <20250312184912.269414-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FNJpQTEvTuBVrQ3_EDWFyGoz2BuH3M7q
X-Proofpoint-GUID: FNJpQTEvTuBVrQ3_EDWFyGoz2BuH3M7q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-12_06,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 adultscore=0 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=632 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503120128

Fix race when making a page secure (hold pte lock again)

This should fix the issues I have seen, which I think/hope are also the same
issues that David found.

v4->v5:
* fixed kerneldoc for s390_wiggle_split_folio()
* remove get_locked_valid_pte() and replace it with folio_walk_start()
  [thanks David]

v3->v4:
* move and rename s390_wiggle_split_folio() to fix a compile issue when
  KVM is not selected
* removed obsolete reference to __() from comments

v2->v3:
* added check for pte_write() in make_hva_secure() [thanks David]

v1->v2:
* major refactoring
* walk the page tables only once
* when importing, manually fault in pages if needed

Claudio Imbrenda (1):
  KVM: s390: pv: fix race when making a page secure

 arch/s390/include/asm/gmap.h |   1 -
 arch/s390/include/asm/uv.h   |   2 +-
 arch/s390/kernel/uv.c        | 136 +++++++++++++++++++++++++++++++++--
 arch/s390/kvm/gmap.c         | 103 ++------------------------
 arch/s390/kvm/kvm-s390.c     |  25 ++++---
 arch/s390/mm/gmap.c          |  28 --------
 6 files changed, 151 insertions(+), 144 deletions(-)

-- 
2.48.1


