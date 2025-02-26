Return-Path: <kvm+bounces-39282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6363BA45F69
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 13:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC18E163CA0
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B71215769;
	Wed, 26 Feb 2025 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ew36xsyY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9924A1A;
	Wed, 26 Feb 2025 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740573460; cv=none; b=TjU3afSGTay8R9AKvdyEDM7kPAYHEHgH0t/Qusw9iIa8aWMlRKKBXjQxQSD1SAJbC5urJrABcPqgm69okQLvcglyjP+9dt53atHVrAACCiUUhscTNgpssx1HvPhydtzCovVheVCZg2LLziUiBs77MYzWUuKoLPwRkshZd6/BaHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740573460; c=relaxed/simple;
	bh=wjihz5ryhB1yxliRxDQrqDO/f8RE+0I9cRKbMRnExhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o2YMUrjRORzCs2cXMJV26uC2SrFAOu73ITuJ7u+MqQOOBJtw9IqtfK2hxaCTenDiH8+YqgNfEQQoQUuHVkzqk2wXbG588j3bBbGzKpyURaWkyvjBjwddS7/txI2G2mLuBmhbF7NN+Erldxut+w9J1L3QkVGpEt+xZQunXTvfSCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ew36xsyY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q5P5pl022451;
	Wed, 26 Feb 2025 12:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=1HKSWJ4Bb7geszpCBSKYgDKOA2igEXL7mSgG2w7qW
	ko=; b=Ew36xsyYsgZ31XNPeEM6WiVr0QdpapSRelTKvYeslEEWmywa25wSjAJ7y
	4Td35kKHAyemTQsEdg2EQbgjfQ671RulGDyRtlxmTohhIxfRaBVROJarqVOl6tvN
	5XJZXiXfGntorgDm1HPFuZY8decMXlKq4ri/WEO3w3Sm205KudWmhWlN+quKpLIJ
	MJnLnf4+trsOv1443OGMM/BzJk3WvwiuDqqb8ksnG+rX1oZhLX519PlNKf6Mmb0X
	h0h1e/9mSMxzmMdavzdJ8lXyMU3Ab0Gz/6L88yTwW+Dg1PbbqpqBrV8dAOHzipAl
	MC6OqBukVfJIEsS3GWh1EO31CZOLQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451vs81sw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:37:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QB0NKo012522;
	Wed, 26 Feb 2025 12:37:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9yjtk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:37:34 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QCbVv735128004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 12:37:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C76D2004B;
	Wed, 26 Feb 2025 12:37:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 877B520040;
	Wed, 26 Feb 2025 12:37:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.9.246])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 12:37:30 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v2 0/1] KVM: s390: fix a newly introduced bug
Date: Wed, 26 Feb 2025 13:37:24 +0100
Message-ID: <20250226123725.247578-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vPjSk5_Hxs50e_ZvfDSEHbRgreR-yc7V
X-Proofpoint-GUID: vPjSk5_Hxs50e_ZvfDSEHbRgreR-yc7V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_02,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxlogscore=505 spamscore=0 mlxscore=0 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260100

Fix race when making a page secure (hold pte lock again)

This should fix the issues I have seen, which I think/hope are also the same
issues that David found.


v1->v2:
* major refactoring
* walk the page tables only once
* when importing, manually fault in pages if needed

Claudio Imbrenda (1):
  KVM: s390: pv: fix race when making a page secure

 arch/s390/include/asm/uv.h |   2 +-
 arch/s390/kernel/uv.c      | 105 ++++++++++++++++++++++++++++++++++---
 arch/s390/kvm/gmap.c       |  99 +++-------------------------------
 arch/s390/kvm/kvm-s390.c   |  25 +++++----
 4 files changed, 121 insertions(+), 110 deletions(-)

-- 
2.48.1


