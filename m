Return-Path: <kvm+bounces-36755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DCBA208C1
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 11:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38141166BDE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 10:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1125E19E98D;
	Tue, 28 Jan 2025 10:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sr7Nle84"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAAE199EB2
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738060929; cv=none; b=GoejLIepgKT+10Pt3MkhqBA+THIVUBAz0o5TeojGJT9imr3ZCZpevzkucChJDt1VZQVGnX08HvUAzkyoXfvMGTBwiP8D9CC7dlgnodWPaYYQeZz1/jf8Xl8MeVdv27OF9ZYb9rv4F3aJa3NulEPQYyoJA+RSsMn2rsQnlydynlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738060929; c=relaxed/simple;
	bh=JksWI3D6StHU+bT772T7lqwjVpOsejUNxpCOSa+Gsec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k6TLBhzROcPrxeVSJeJti5iBYi+UqTt/JitmVj8YQAL8iryPTpRyjyoG9kB7DeMAPYlrGPXGnv2KWuIsO0JrYz5P3n4xatHw3GDWzcHBhqNB+/Asn+O2kyMq6KNu27OKC90BZgHMHfT9F6I/4BZ6PwLHTLeKs2FnixFl5XFZ6EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sr7Nle84; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50S20sHP006934;
	Tue, 28 Jan 2025 10:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=MxeXqbSBiQBNA4lMygnpAcPjiostVu1B/67bZGXTU
	Go=; b=Sr7Nle845+KNEkmuV7cxQzvKC+DZKsUX2cvej1zDbSCNdCk6cYC4OigI5
	T2IrAeIoEXa+Nh9OUuSJS/w/+XK3fir1c7yXa8sTmOXGGwO3w2evptabvH3K2CqE
	2O3VLQScjW833Nzejq/m8oudvoa6Cb2yLRDsufDDYPg7MNxxuJwaYRv8iNUWS2si
	8KWAxst+5FAxnuTwJeqjnMq2MasXn4RstTBpHRpEwQMDSRrZpTSX7ZsrN54i4iAG
	PgAFwr2wPv4Vkrq3AWaMDAA4kXQb3Y1xJFGjmvqbsavIMSi9QnCvYa2FbVZ6kr4q
	gfU7UI2p3GeJjL3EVQgwavnt9+5Ww==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44ep2yhujf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:41:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50S9afKx019213;
	Tue, 28 Jan 2025 10:41:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44db9mttr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:41:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50SAfrv257344444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 10:41:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FEEB20040;
	Tue, 28 Jan 2025 10:41:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7E022004B;
	Tue, 28 Jan 2025 10:41:52 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.179.13.59])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jan 2025 10:41:52 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC kvm-unit-tests PATCH v1] Makefile: Use 'vpath' for out-of-source builds and not 'VPATH'
Date: Tue, 28 Jan 2025 11:41:41 +0100
Message-ID: <20250128104141.58693-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7hJPbmmXH7qxgXwhhJCwmrNfQZSdDT41
X-Proofpoint-GUID: 7hJPbmmXH7qxgXwhhJCwmrNfQZSdDT41
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501280077

If VPATH is used, object files are also looked up in the source directory [1],
and this has some disadvantages like a simultaneous in-source build and
out-of-source build is not possible:

  $ cd "$KUT" && ./configure && make -j
  # This command fails
  $ mkdir ../build && cd ../build && "../$KUT/configure" && make -j

Use 'vpath' [2] only for *.c, *.s, and *.S files and not for *.lds files, as
this is not necessary as all *.lds prerequisites already use $(SRCDIR)/*.lds.

[1] https://www.gnu.org/software/make/manual/html_node/General-Search.html
[2] https://www.gnu.org/software/make/manual/html_node/Selective-Search.html

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
--
Note: IMO, in the long run we should try to get rid of vpath completely and use
      OBJDIR/BUILDDIR and SRCDIR instead.
---
 Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7471f7285b78..78352fced9d4 100644
--- a/Makefile
+++ b/Makefile
@@ -6,8 +6,10 @@ endif
 
 include config.mak
 
-# Set search path for all sources
-VPATH = $(SRCDIR)
+# Set search path for %.c %.s and %.S files
+vpath %.c $(SRCDIR)
+vpath %.s $(SRCDIR)
+vpath %.S $(SRCDIR)
 
 libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
 ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR)) $(call libdirs-get,$(TEST_DIR))

base-commit: 0ed2cdf3c80ee803b9150898e687e77e4d6f5db2
-- 
2.48.1


