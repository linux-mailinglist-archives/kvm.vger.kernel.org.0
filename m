Return-Path: <kvm+bounces-21820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA62D934BFE
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83BCEB22AD1
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 10:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D9713A272;
	Thu, 18 Jul 2024 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eKxLQSsb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB5F13664E;
	Thu, 18 Jul 2024 10:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721299995; cv=none; b=BwpnRS7HZwHk8Oxys4orDORX3VJf9b0xILQKeFbOVPSdCZNujvouLvBOLFgI4XoSUH7lcpF0Py8e/P6kiFJCF2RDFeut3WqX+wnXEcZdq448edYD2fXlDet0wMKfS1vi5c7Mh2jP2yyDITKXjk7CC/Nuj9psrC2FQMjlKv3KgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721299995; c=relaxed/simple;
	bh=60+B1/mq9deLP/oFM985bbm7amwZe/UqFNPpA3rGGPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SffowNZsM6IXb/unukv2x8ynhqMxd0QG0S5nvJTA1AnMd94l/bdfRHDxGh8pnd/+Jw2QGNSyBrx+La7PfGvTb0Nyxyff5NvLS4RJgSOAgFTyHFd3TIr/662hdTOLDtrhWg7WRrW/ZWVGRPUig8aSNCQUIWN77Vu0Il+4BVRe2pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eKxLQSsb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46I9uUHZ032742;
	Thu, 18 Jul 2024 10:53:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=KY7PSxvyIrVJK
	HO4JmPdTJRIMI8kXoXW4fYHWPZOhtI=; b=eKxLQSsbIWoXw8vkSV6s+Z7S49eky
	518/I8+yytUFPh/Aha1vHHcLQdZIey3SnfZKRlE3WvexI2c0MSfFvuNn4MW/O4NP
	qHYTldLLZycHygLRtc9X8YQm68GpdpSKzyv4PzF3TJezFo92NfXDkXLPeqOhvWVu
	l1wiu1WS0XbGUVNX3I8z2wsdBWvHQ+qmIbL6KaC0qsx6f/u3DrvDbKJ0nGH6Tdr1
	pyEshd/PjOUI2omDV6fvPMRZBdSU9OyqQuBPmfRCYHJvV4orCkNzWQwiBkIH2Uyf
	u44Yb6KYX/+yzj7rEi796roLv/S60157alrPAtZlmw4y/YrmnFwwNPDjw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40eyjp89tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:53:09 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46IAr822016254;
	Thu, 18 Jul 2024 10:53:08 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40eyjp89s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:53:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46I9Cp40009574;
	Thu, 18 Jul 2024 10:52:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40dwkms7nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:52:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46IAqOP534144856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 10:52:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E7BC2004B;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CDBC2004D;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        npiggin@gmail.com, nsg@linux.ibm.com, mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/4] s390x/Makefile: Add more comments
Date: Thu, 18 Jul 2024 10:50:17 +0000
Message-ID: <20240718105104.34154-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240718105104.34154-1-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YiyxRus8YjRnBY_3VFxuKaZhJlfRg7SB
X-Proofpoint-ORIG-GUID: MPPs9rbONlGcKqcflq3kH4IVnwGpYv_h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_07,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2407180072

More comments in Makefiles can only make them more approachable.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/Makefile b/s390x/Makefile
index 2933b452..457b8455 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -50,12 +50,15 @@ pv-tests += $(TEST_DIR)/pv-icptcode.elf
 pv-tests += $(TEST_DIR)/pv-ipl.elf
 pv-tests += $(TEST_DIR)/pv-edat1.elf
 
+# Add PV host tests if we're able to generate them
+# The host key document and a tool to generate SE headers are the prerequisite
 ifneq ($(HOST_KEY_DOCUMENT),)
 ifneq ($(GEN_SE_HEADER),)
 tests += $(pv-tests)
 endif
 endif
 
+# Add binary flat images for use in non-KVM hypervisors
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
 tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
@@ -142,6 +145,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timin
 $(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
 $(TEST_DIR)/pv-edat1.elf: pv-snippets += $(SNIPPET_DIR)/c/pv-memhog.gbin
 
+# Add PV tests and snippets if GEN_SE_HEADER is set
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
 tests += $(pv-tests)
@@ -150,6 +154,7 @@ else
 snippet-hdr-obj =
 endif
 
+# Generate loader script
 lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 %.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
-- 
2.43.0


