Return-Path: <kvm+bounces-36753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A83A20839
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 11:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96AFB1882F1C
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 10:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE6719CC05;
	Tue, 28 Jan 2025 10:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mJx0kOxS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B294219A288;
	Tue, 28 Jan 2025 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738058816; cv=none; b=qai92RbJl5RCCyRSalGrhgkQ07Ln957IntZKLWRbb7P/xAwtZRuUX/aKefU2U5Hzs8hfeY3oRoJagL8uVWABkvdfatdXGZ5/NIINP8CWutRh/ih1as0cK/Lwyn1JX8XAZ/Y8mda1Cb82AgQ37s2qW0rlb4FBdzRWwPfM78iUlRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738058816; c=relaxed/simple;
	bh=Epytm/lqWqdy8hzxzua+fD2SPqaViPOHRDgWA82OIHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPxHBxBD3YgCHp3Exk9WGRXe7L4nGC3FfuxsuyHTK3FYwl+xjegrxDwR8dkBjVVvCPVv5/UuloLlGkb0RURjLCJ5krnGeDfhXubldod90XglmiiSJMULOGiV10q1HiDg3IjgffbZ5NPY/3/VMJ1/3UVCKON42MUii//zQ5gziVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mJx0kOxS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50S19g71012318;
	Tue, 28 Jan 2025 10:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qHZqb4SEAt53yb/Ct
	4AmujpEmAmBXqTvAJG5MeQk3EQ=; b=mJx0kOxS3/58YZorR10kNEvxsOre5E8si
	sjKL1QkONiZot4EAb+wPm/HtyjmUTq/QiCfYL7sejuMkQzddriCvPVaTD9+vQsX4
	8Q5gVnK3Vp1XrJEGqoa4xhxAYiMHS4ZPZdz40siWNBuweftBR0vukL0vJgli1RCX
	7nyT5pFLhu0SFjcqYwN/K7ialc5ADB3LxpLFtstvg9qheYEb/y2ce0oJk+dOddDn
	JrCOWwwlltZTYM3f09auqe+3WvioN2a8NVwxWfgyZwnzeQa4rlYyK+GpbNCJ4nPm
	XCWYqJKLpj8MEt8NUkfxgM8CSTCAw0kQNXiygV1cB88wb/NinOw6A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44ena9t2x0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:06:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50S9YFZj019210;
	Tue, 28 Jan 2025 10:06:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44db9mtpww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:06:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50SA6jWk42664396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 10:06:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D28920237;
	Tue, 28 Jan 2025 10:06:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD5F920239;
	Tue, 28 Jan 2025 10:06:44 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.179.13.59])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jan 2025 10:06:44 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v1 1/2] s390x/Makefile: Make sure the linker script is generated in the build directory
Date: Tue, 28 Jan 2025 11:06:38 +0100
Message-ID: <20250128100639.41779-2-mhartmay@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: BVmKcX6zOhUs1ohiuHPI3FhPcrjVNFkd
X-Proofpoint-GUID: BVmKcX6zOhUs1ohiuHPI3FhPcrjVNFkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501280077

This change makes sure that the 'flat.lds' linker script is actually generated
in the build directory and not source directory - this makes a difference in
case of an out-of-source build.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64f44..71bfa787fe59 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -182,8 +182,8 @@ lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 .SECONDEXPANSION:
-%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
-	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
+%.elf: $(FLATLIBS) $(asmlib) s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
+	@$(CC) $(LDFLAGS) -o $@ -T s390x/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
 		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
 	@chmod a-x $@
-- 
2.48.1


