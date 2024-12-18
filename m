Return-Path: <kvm+bounces-34046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB949F67B2
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 14:52:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 143F27A270C
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 13:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE2C1BEF66;
	Wed, 18 Dec 2024 13:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s0XgHY9U"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47261B0408;
	Wed, 18 Dec 2024 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734529912; cv=none; b=m80XKVxAC5ZtDfKQ0icwDxZ4Yy7pBg+J0L3JjPdfH6Vwza6dx6HwBn9fft+UNp927chteBJIdADuUROnGDeMcfJE9xsPJpfvHzauRdtlfCwa7GLCO6Oow6Lb1BW5oQ8XamY/UAWjnvTxdVkGLcAdY0llwAlmRy9Ct7S24YgnebI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734529912; c=relaxed/simple;
	bh=8nZlZhXZMcE+dlJS0vR8/pEIQxn3379OwTShsij28Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T3lwvoQ8O/iZNYguIjYGNLEDEhWASxOLLyffHkgKGeXynP/To5YX83TWeUiTJx83GhMr4Gd0B9y1NOWJ+CCApvmqHaC77EPOg4c7YRm9bD+WNbBCw7GvvW4qqI/a9VtIY5AuPJfUt31GMnjsOQePZzJfznqhxGIr610y/EhH75g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s0XgHY9U; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI3qxU3029128;
	Wed, 18 Dec 2024 13:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ri7ODhVN5ItPeV2cmTaBCjlaE58znwK2DHYYAiBYE
	WI=; b=s0XgHY9UN5a2VRO5LN2RupeGtQ/bLv5CU03iMesnkxH0f1L2H8bSCLrK9
	G7SNbsYx5WTxFTUk3cQmcGv2ycJfklOnJRMVV7v+/csPyz1NQDmdZJK220ustLKO
	SjwNTxnEkLSIArI9Dq/0+pHgzmSMDlFF4LDNYJUMVrFmo6ZUp0YwLphAp9CoOmFs
	PGmWZ2uPzZLtZQDcQexRFr/ZTPEskmw5y0gK6zFhfSNP4Z3Ragr6TBdVnzdRDUwd
	/FUn0k1Ru2osGq0z7VvWYb2kD18y+MEXE3g2rh306xymYjSYz0kXSq33XA85vfBi
	wBrSYjFCuGCbAafJ/qEzfoe//1J4g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43kpvgtgd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 13:51:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIAVYjn014378;
	Wed, 18 Dec 2024 13:51:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hq21qr0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 13:51:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BIDpdbv40632750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 13:51:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FF8C20049;
	Wed, 18 Dec 2024 13:51:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E60F420040;
	Wed, 18 Dec 2024 13:51:38 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Dec 2024 13:51:38 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        thuth@redhat.com, david@redhat.com, schlameuss@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/3] s390x: pv: Add test for large host pages backing
Date: Wed, 18 Dec 2024 14:51:35 +0100
Message-ID: <20241218135138.51348-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2i6NGRSSGFdm2pk4vPdCAi1EYtBeTH3J
X-Proofpoint-ORIG-GUID: 2i6NGRSSGFdm2pk4vPdCAi1EYtBeTH3J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=742 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412180106

Add a new test to check that the host can use 1M large pages to back
protected guests when the corresponding feature is present.

v2->v3
* remove pointless timing measurements
* add two missing patches (oops!)
* minor fixes (thanks Christoph)

Claudio Imbrenda (3):
  lib: s390: add ptlb wrapper
  lib: s390x: add function to test available UV features
  s390x: pv: Add test for large host pages backing

 s390x/Makefile               |   2 +
 lib/s390x/asm/arch_def.h     |   1 +
 lib/s390x/asm/pgtable.h      |   5 +
 lib/s390x/asm/uv.h           |  18 ++
 lib/s390x/uv.h               |   1 +
 lib/s390x/uv.c               |   9 +
 s390x/pv-edat1.c             | 387 +++++++++++++++++++++++++++++++++++
 s390x/snippets/c/pv-memhog.c |  59 ++++++
 8 files changed, 482 insertions(+)
 create mode 100644 s390x/pv-edat1.c
 create mode 100644 s390x/snippets/c/pv-memhog.c

-- 
2.47.1


