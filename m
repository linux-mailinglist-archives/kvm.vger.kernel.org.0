Return-Path: <kvm+bounces-743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D31AD7E2273
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:54:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F0442815B9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7DAF249F6;
	Mon,  6 Nov 2023 12:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KTs5zYFC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F401EB5B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:54:09 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9FBBF;
	Mon,  6 Nov 2023 04:54:07 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6BPVvd022636;
	Mon, 6 Nov 2023 12:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7Uz9haZ58UVDseh373zDYI99VkSmztPsmzmkMTKbauo=;
 b=KTs5zYFCeQ8pJ7IsHFlJeIwYpuOrLk/vdoK3akmWGrGv3ICd0eMEDi8vRcWiWIbsVCT3
 Bd79Y/BpxnbfYiu7sLhYI9Fmx3Kq3mAal98IRVN4Py6qgXxUmQjjxPPQN7T5/3Fyrcxt
 G+QZ6lfU2WONCJUyLlvMFnaYy0VibjUT4lILqgk4M2sYmmIOJV7qTfwl7Bj+G+gBr6YZ
 x1PECnznAAYoo5QXJ5og7ZcXLBitdziP2rKkkR1ymNcHpO0ozVRkxRG0VHCttHyntrD1
 tl7G9VcxsD+47Eq3kSDnSFwcAaPmiJsdubvKzUyg1CT7pzxYwdTC741+lz5jo2Gf13+g Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6uj0t0hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:58 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6Cik6p008097;
	Mon, 6 Nov 2023 12:53:57 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6uj0t0h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:57 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6C28gh028329;
	Mon, 6 Nov 2023 12:53:56 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u62gjrx25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6Crru141616106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 12:53:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C26C620040;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B83720049;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev,
        lvivier@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 04/10] s390x: properly format non-kernel-doc comments
Date: Mon,  6 Nov 2023 13:51:00 +0100
Message-ID: <20231106125352.859992-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106125352.859992-1-nrb@linux.ibm.com>
References: <20231106125352.859992-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PVs_SF_NOtE-50wwnEvm9g06gYMdo9gD
X-Proofpoint-GUID: fWXZWP6WHRfCiodIxqJYpljJL_yp6hdz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_11,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060104

These comments do not follow the kernel-doc style, hence they should not
start with /**.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/sclp.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/s390x/sclp.c b/s390x/sclp.c
index 1abb9029f984..ccbaa9136fdb 100644
--- a/s390x/sclp.c
+++ b/s390x/sclp.c
@@ -32,7 +32,7 @@ static union {
 } sccb_template;
 static uint32_t valid_code;						/* valid command code for READ SCP INFO */
 
-/**
+/*
  * Perform one service call, handling exceptions and interrupts.
  */
 static int sclp_service_call_test(unsigned int command, void *sccb)
@@ -51,7 +51,7 @@ static int sclp_service_call_test(unsigned int command, void *sccb)
 	return cc;
 }
 
-/**
+/*
  * Perform one test at the given address, optionally using the SCCB template,
  * checking for the expected program interrupts and return codes.
  *
@@ -96,7 +96,7 @@ static bool test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t buf_len, uint64_
 	return true;
 }
 
-/**
+/*
  * Wrapper for test_one_sccb to be used when the template should not be
  * copied and the memory address should not be touched.
  */
@@ -105,7 +105,7 @@ static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_pgm, uint16_t
 	return test_one_sccb(cmd, addr, 0, exp_pgm, exp_rc);
 }
 
-/**
+/*
  * Wrapper for test_one_sccb to set up a simple SCCB template.
  *
  * The parameter sccb_len indicates the value that will be saved in the SCCB
@@ -124,7 +124,7 @@ static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
 	return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
 }
 
-/**
+/*
  * Test SCCB lengths < 8.
  */
 static void test_sccb_too_short(void)
@@ -138,7 +138,7 @@ static void test_sccb_too_short(void)
 	report(len == 8, "SCCB too short");
 }
 
-/**
+/*
  * Test SCCBs that are not 64-bit aligned.
  */
 static void test_sccb_unaligned(void)
@@ -151,7 +151,7 @@ static void test_sccb_unaligned(void)
 	report(offset == 8, "SCCB unaligned");
 }
 
-/**
+/*
  * Test SCCBs whose address is in the lowcore or prefix area.
  */
 static void test_sccb_prefix(void)
@@ -202,7 +202,7 @@ static void test_sccb_prefix(void)
 	set_prefix(prefix);
 }
 
-/**
+/*
  * Test SCCBs that are above 2GB. If outside of memory, an addressing
  * exception is also allowed.
  */
@@ -245,7 +245,7 @@ static void test_sccb_high(void)
 	report(i == len, "SCCB high addresses");
 }
 
-/**
+/*
  * Test invalid commands, both invalid command detail codes and valid
  * ones with invalid command class code.
  */
@@ -275,7 +275,7 @@ static void test_inval(void)
 }
 
 
-/**
+/*
  * Test short SCCBs (but larger than 8).
  */
 static void test_short(void)
@@ -294,7 +294,7 @@ static void test_short(void)
 	report(len == 40, "Insufficient SCCB length (Read CPU info)");
 }
 
-/**
+/*
  * Test SCCB page boundary violations.
  */
 static void test_boundary(void)
@@ -318,7 +318,7 @@ out:
 	report(len > 4096 && offset == 4096, "SCCB page boundary violation");
 }
 
-/**
+/*
  * Test excessively long SCCBs.
  */
 static void test_toolong(void)
@@ -338,7 +338,7 @@ static void test_toolong(void)
 	report(len == 8192, "SCCB bigger than 4k");
 }
 
-/**
+/*
  * Test privileged operation.
  */
 static void test_priv(void)
@@ -354,7 +354,7 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
-/**
+/*
  * Test addressing exceptions. We need to test SCCB addresses between the
  * end of available memory and 2GB, because after 2GB a specification
  * exception is also allowed.
@@ -393,7 +393,7 @@ out:
 	report(i + maxram >= 0x80000000, "Invalid SCCB address");
 }
 
-/**
+/*
  * Test some bits in the instruction format that are specified to be ignored.
  */
 static void test_instbits(void)
@@ -422,7 +422,7 @@ static void test_instbits(void)
 	report(cc == 0, "Instruction format ignored bits");
 }
 
-/**
+/*
  * Find a valid READ INFO command code; not all codes are always allowed, and
  * probing should be performed in the right order.
  */
-- 
2.41.0


