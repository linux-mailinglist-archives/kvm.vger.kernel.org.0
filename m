Return-Path: <kvm+bounces-1470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C077E7CB4
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 647DE1C20A71
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963C51DFEC;
	Fri, 10 Nov 2023 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PAf030SX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923511CA81
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:36 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7BA3821D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:35 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADTsTk004571;
	Fri, 10 Nov 2023 13:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Ee0kq4Fg66iJ+E+cgrX/gBFJdLxh+UhfN0n4sX9tr7M=;
 b=PAf030SX2xjeMM9tGmyuUVj1LKVsrdCh34nGq0GzoDpWC2yr7IUDSHzAS9TQGrF/kZC0
 AOYX7/sz9qAc5gwLrnEwogcHAAiZksYuZSgIM38+O0T4T0rRiSmwtMeNhO/TO/I9hqF8
 m9f8cXD0cMZk5TnMTKmY0B3NchK31ftoULfrSbSDZbD+Eo7FhFdMj8nSCPpQYVlbBq+V
 6qHTCz1MNfxyGbdgg6SVk9tDQfPTTYB8zwzgHlQowFvCpSy8mwUGrFeJx9nDzYMYd1Wz
 OUYvGAIpgAb7pdh5ZA5BshK4eOu9kBRdkYiwbovhVCj79ljdfvpzmQRwmzFfKLwlFIQi bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9md2308y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:26 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADUGlT006756;
	Fri, 10 Nov 2023 13:54:25 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9md2308k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:25 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB0C4I028363;
	Fri, 10 Nov 2023 13:54:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22u741-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsKkt15467208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0CBE20043;
	Fri, 10 Nov 2023 13:54:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 007F92004B;
	Fri, 10 Nov 2023 13:54:19 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:18 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 08/26] s390x: mvpg-sie: fix virtual-physical address confusion
Date: Fri, 10 Nov 2023 14:52:17 +0100
Message-ID: <20231110135348.245156-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: isCumLuA_iBnWGjtr6JlXMLKtRnJtJBJ
X-Proofpoint-GUID: 1g5uAzaAsDCcwnsvHH-wxJedR46bZBMl
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

The addresses reported for the partial execution of mvpg instruction are
physical addresses. Now that MSO is a virtual address, we can't simply
compare the PEI fields in the sie block with MSO, but need to do an
additional translation step.

Add the necessary virtual-physical translations.

Link: https://lore.kernel.org/r/20231106170849.1184162-4-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/mvpg-sie.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 99f4859..d182b49 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -12,6 +12,7 @@
 #include <asm-generic/barrier.h>
 #include <asm/pgtable.h>
 #include <mmu.h>
+#include <vmalloc.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
@@ -23,7 +24,9 @@
 static struct vm vm;
 
 static uint8_t *src;
+static phys_addr_t src_phys;
 static uint8_t *dst;
+static phys_addr_t dst_phys;
 static uint8_t *cmp;
 
 static void test_mvpg_pei(void)
@@ -38,8 +41,8 @@ static void test_mvpg_pei(void)
 	protect_page(src, PAGE_ENTRY_I);
 	sie(&vm);
 	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
-	report((uintptr_t)**pei_src == (uintptr_t)src + PAGE_ENTRY_I, "PEI_SRC correct");
-	report((uintptr_t)**pei_dst == (uintptr_t)dst, "PEI_DST correct");
+	report((uintptr_t)**pei_src == (uintptr_t)src_phys + PAGE_ENTRY_I, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == (uintptr_t)dst_phys, "PEI_DST correct");
 	unprotect_page(src, PAGE_ENTRY_I);
 	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
 	/*
@@ -60,8 +63,8 @@ static void test_mvpg_pei(void)
 	protect_page(dst, PAGE_ENTRY_I);
 	sie(&vm);
 	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
-	report((uintptr_t)**pei_src == (uintptr_t)src, "PEI_SRC correct");
-	report((uintptr_t)**pei_dst == (uintptr_t)dst + PAGE_ENTRY_I, "PEI_DST correct");
+	report((uintptr_t)**pei_src == (uintptr_t)src_phys, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == (uintptr_t)dst_phys + PAGE_ENTRY_I, "PEI_DST correct");
 	/* Needed for the memcmp and general cleanup */
 	unprotect_page(dst, PAGE_ENTRY_I);
 	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
@@ -82,8 +85,10 @@ static void setup_guest(void)
 {
 	extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
 	extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
+	pgd_t *root;
 
 	setup_vm();
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
 
 	snippet_setup_guest(&vm, false);
 	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
@@ -94,6 +99,9 @@ static void setup_guest(void)
 
 	src = (uint8_t *) vm.sblk->mso + PAGE_SIZE * 6;
 	dst = (uint8_t *) vm.sblk->mso + PAGE_SIZE * 5;
+	src_phys = virt_to_pte_phys(root, src);
+	dst_phys = virt_to_pte_phys(root, dst);
+
 	cmp = alloc_page();
 	memset(cmp, 0, PAGE_SIZE);
 }
-- 
2.41.0


