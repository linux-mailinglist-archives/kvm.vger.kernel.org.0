Return-Path: <kvm+bounces-36752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB1AA20838
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 11:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D11A77A33D1
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 10:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F380719D06A;
	Tue, 28 Jan 2025 10:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NGFkyoFS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29A019CC05;
	Tue, 28 Jan 2025 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738058815; cv=none; b=LMdKkkP50JO6m/gpnqBdrTey+az8LRN9kMY4k2bKnSXjP4xJBsp2yG0fswfWgygQlKx5qGsAuqO5P7zs6G7HEsAdXXajzJnvfnUc+XjTeERggfh3N+gcWJilMR/2tD5/WmBy7kBGzEIWyu/DSERGHCjuEK7Jl6l2mfi8/ZogCsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738058815; c=relaxed/simple;
	bh=xCn4hQyEdO13ftjGfxCW3to2bs1ywBttw+4nSCDGgcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2UP47W2MFt3nTiOzDfF3TYpoZiFTv7VA/QzEYTeuf3KRpLSqs7EdZpHz6aoMHtuQIFSdNvseCi+EKxTo5k9OJo8rXCfYR0PNpcZC2zN3mvVHvrOTy/5rwstK+sMf8DH02vJA+5Pa6shL5ORJKPTTPVT69TOtYRbG/CoZaR1Sqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NGFkyoFS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50S18I8q010240;
	Tue, 28 Jan 2025 10:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/or7ppnjKCAUvjHlG
	yu1lQgw/5KA1hJEHDYrpm5gi/Y=; b=NGFkyoFS4AL+Vug7b270XpfZSAKZHEIFa
	JE9wJ4GWoO0g2jWulXXZ916ZBS+4VUFnhAuJK/DvfBoksRIOemok0oE2ryftmPUa
	Ea2gzDHulqWDk2Wu45ymIqjdWipvTu8WCBnJNXMBNsdgYfN5XmVX7J0wo/N/BDQJ
	RInAtVYEd0DEBuDMupAbxnJ/7SNnw2wNvBtAQ6jbDbZQIUmUYdutVgez4kNDjA2f
	jgglJMj0uOSXiKSSowiErHjFmOZ1Ni0BU5mgliXvDnmLDW+yUwkXSEAZNMUhfu0W
	BtT80rMzfRPFQ8XRDh5DnvvNLUZx8XEugA1447l8FIAsasLtdDA2Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44ena9t2x1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:06:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50S6e4RO022229;
	Tue, 28 Jan 2025 10:06:49 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dcgjje1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:06:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50SA6j1f49349012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 10:06:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80FCF20234;
	Tue, 28 Jan 2025 10:06:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E94C20236;
	Tue, 28 Jan 2025 10:06:45 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.179.13.59])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jan 2025 10:06:45 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v1 2/2] s390x/Makefile: Add auxinfo.o to cflatobjs
Date: Tue, 28 Jan 2025 11:06:39 +0100
Message-ID: <20250128100639.41779-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250128100639.41779-1-mhartmay@linux.ibm.com>
References: <20250128100639.41779-1-mhartmay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3sSgOTE_2qFLnLT8b1Hwa1NEuPOefata
X-Proofpoint-GUID: 3sSgOTE_2qFLnLT8b1Hwa1NEuPOefata
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=976 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501280077

This makes sure that the file is removed in case of `make clean` as the top
Makefile cleans all objects defined in 'cflagsobjs'.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
--
Note: AFAICT, the computed sh256sum values of the generated .elf and .bin files
      did not change.
---
 s390x/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/s390x/Makefile b/s390x/Makefile
index 71bfa787fe59..1b0e9d63de13 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -90,6 +90,7 @@ LDFLAGS += -Wl,--build-id=none
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
+cflatobjs += lib/auxinfo.o
 cflatobjs += lib/util.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/alloc_phys.o
-- 
2.48.1


