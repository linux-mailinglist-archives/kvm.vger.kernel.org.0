Return-Path: <kvm+bounces-27055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD33F97B236
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 17:48:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31926B26D28
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 15:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2A7191F75;
	Tue, 17 Sep 2024 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QzgulnpJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6031917F6;
	Tue, 17 Sep 2024 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726587381; cv=none; b=T3CBltAJlFxy3w8BR/3HyaN6mC3qUMDK7oXNINxplZjO61HzJgb/QgpMiE/wehx1DcBDCNFuK7gYF4SEwdJScIk9QqtVIbX+j+JkPQU3dZ3yrx4s28hdMDWnV07zsf19BVGf2XlFMleZWPsWVzuARbGMQco4oDiwaxroHNu4XAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726587381; c=relaxed/simple;
	bh=VkLQXGrOdh9zmmUjWiX2LE0tIVCtfyXvRWM/QVu+pLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q2PyrfRPKs+eXb7WIj9ww4YTPiLRf0jeMo52ccC1SvarSEZczxudcv8Zf0VgBK5KOMcdgEUmLvD02oWTPe2AMITbzUdKUzK6jGJqKV6EqEkzPNcLEGm+aGga5KOU6tdHD0nftwyCbccwlenjdeQD2KJnkBDBjBUqYvLe2N5i/eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QzgulnpJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48HBAF7R030231;
	Tue, 17 Sep 2024 15:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=HceYoFJBVVqddHmwvcPFKTvXHcDU5H+TwSxuzdA
	KMdc=; b=QzgulnpJ8rZWGibJNM8pvm+G9KWsl4spzb8kjnOqG+55mufr4IoBPi5
	9D6pUz6LnDgbUK0kMCtCB8HDgZ4PgTX/VEngauj4NAOXc5DEAeJlqaUE6a8iCDSn
	ovjCcBw5J0DJVNRVJfgobJt5MdRwOVfb1rg7eUBImceMNLsxGg3Wnz1gScIPGd/Z
	CcsS3f4/zcp7V1yZN/Rf2JLSekuNRTBbyIfem0eYNxwMt3ugxKzIlE3oDmx82MN2
	U3enZuu9iUgidc35Lsug+X74uHliAbMiptrEuP3a0WT7vALx8wQNWD13gTxzVvSv
	jGS53nxmJLcL6zzJe2ucbRmLSk33uCQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41pht8fym3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:16 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48HFUXo5005041;
	Tue, 17 Sep 2024 15:36:16 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41pht8fym2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48HDAKr9030631;
	Tue, 17 Sep 2024 15:36:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41npan5w4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48HFaBio35913998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Sep 2024 15:36:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7823C2004D;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 522082004B;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: add tests for diag258
Date: Tue, 17 Sep 2024 17:35:33 +0200
Message-ID: <20240917153611.138883-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JHaYov-xn5Ab4lSkupgwMXJq8vLLdWEy
X-Proofpoint-ORIG-GUID: NACBYt-6Llrj-tF-Q4JFIGutfu7W6Fm9
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-17_07,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=431 mlxscore=0 clxscore=1015 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409170108

Add tests for diag258 handling on s390x.

There recently was a bugfix in the kernel:
https://lore.kernel.org/r/20240917151904.74314-2-nrb@linux.ibm.com

This adds tests for it.

Nico Boehr (2):
  s390x: add test for diag258
  s390x: edat: move LC_SIZE to arch_def.h

 lib/s390x/asm/arch_def.h |   1 +
 s390x/Makefile           |   1 +
 s390x/diag258.c          | 250 +++++++++++++++++++++++++++++++++++++++
 s390x/edat.c             |   1 -
 s390x/unittests.cfg      |   3 +
 5 files changed, 255 insertions(+), 1 deletion(-)
 create mode 100644 s390x/diag258.c

-- 
2.46.0


