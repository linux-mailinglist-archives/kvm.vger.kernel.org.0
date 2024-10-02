Return-Path: <kvm+bounces-27803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A86B398DA78
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C50351C20F84
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BE81D2225;
	Wed,  2 Oct 2024 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qj9+D1Pu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F631D0F6C;
	Wed,  2 Oct 2024 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878584; cv=none; b=f+l9DQMQkpPt5VW7XdyjizQobr4QEXcAhijIEEbnDVdNBM+k9FyeumO5GjGq+r+qfvRUzhklaiPEr297dk5s8LZQg8YF58vijs1KU5Ui+hFx/1MTnIMfJLosQCECeM2SR7OAYZtsR8dymveRg4IhtA6a04edNpibSOW6faZOcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878584; c=relaxed/simple;
	bh=l5Y6tdghlscucT5yuSsYYur0cvfFH8YuZf/Himd1Xp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J0Kac1dsWEZQeHh80TsOAVQ5rGWMdW2/v5l8LKYjZATxpMGdcQErKE2TlBAkabUOSXmVDvUH375+8xocIgFZaLm+9A1RxVUur0F8+S0KAI/jp3dV9XWArdN1+NQSFFyasc1ICI0gt7P7zKe12epoZB0LjgstMTYhZ8TIaGJWBaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qj9+D1Pu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492DnhmH005331;
	Wed, 2 Oct 2024 14:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=MHsBfUfY0Nefrq2MiAkXJtyaEH5C37LQp2fTIE7
	bbpM=; b=qj9+D1Pu7RWddWj37qnU4cXbKgXENW6+RsN5rx8UiWtJFwTjiWF1TsO
	gc1QcbCVRfCOsZNPGoxJkQDj8NVIxLsxlzRt3T9p74ANu1H3uF2mUbHGXwUZc+UU
	M1taL5CWMVfA3MYs5p2LgN+c6P8YD0o6wYXjD8xwqlzy0YgnRhYL1eOIGTW+vcyD
	q6l/rF4XSunVt9tTkxAqQuA6PRZHzH5kJ7Tm9Ox1GlzfwWFmvFGTUtMx6YAJ0TwG
	1CKlPCrHbGZ/RlRQg5dM5ANSUsoA+UX9SziTn32bYAC4s9CNH9/tgM8cWMItsWLp
	gjt5vlagTLeJ69vlZkEcBDnjnOgRQ7Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217da053b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:16:21 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492EDLuo007200;
	Wed, 2 Oct 2024 14:16:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217da0536-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:16:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492EF0d9013017;
	Wed, 2 Oct 2024 14:16:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 41xxbjjgfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:16:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492EGGRS44171632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 14:16:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F8F22004B;
	Wed,  2 Oct 2024 14:16:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D76E20040;
	Wed,  2 Oct 2024 14:16:16 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 14:16:16 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/2] s390x: add tests for diag258
Date: Wed,  2 Oct 2024 16:15:53 +0200
Message-ID: <20241002141616.357618-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FeRVhhgBaMmYbwQD9iBm87_q2OX1pUa-
X-Proofpoint-ORIG-GUID: S_mHnbwuyEVIbro3pKs7UFJFfdoHVq5d
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_14,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0 mlxlogscore=590
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2410020103

v3:
---
* reverse christmas tree (thanks Claudio)
* test invalid refcodes first since other test rely on it (thanks Claudio)
* use an invalid refbk to detect whether diag is available

v2:
---
* do not run test under TCG

Add tests for diag258 handling on s390x.

There recently was a bugfix in the kernel:
https://lore.kernel.org/r/20240917151904.74314-2-nrb@linux.ibm.com

This adds tests for it.

Nico Boehr (2):
  s390x: edat: move LC_SIZE to arch_def.h
  s390x: add test for diag258

 lib/s390x/asm/arch_def.h |   1 +
 s390x/Makefile           |   1 +
 s390x/diag258.c          | 259 +++++++++++++++++++++++++++++++++++++++
 s390x/edat.c             |   1 -
 s390x/unittests.cfg      |   3 +
 5 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 s390x/diag258.c

-- 
2.46.2


