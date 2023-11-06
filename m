Return-Path: <kvm+bounces-808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A647E2AAB
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 18:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E65EB1C20C4F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6611829D00;
	Mon,  6 Nov 2023 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LKLSM3HX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E04C29CEC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 17:08:57 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CE4D69;
	Mon,  6 Nov 2023 09:08:55 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6H7PhC019098;
	Mon, 6 Nov 2023 17:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Sa1TzCCdrWoaPYUfKYlrmmmq1cZIX1x4l/fdVnFG/bc=;
 b=LKLSM3HXrCqo3v6W2IT6r6xkF1rOAnaSyp2MsV1XT0bkthoLIGbe/YzrNap9u7fQXXt/
 mUnYKPzMEwra7xhuH37zILXDquGn/A8imYAG7OCsxTeqEYUC0TUkt0ijUi58+yIMcND0
 VSU7C4jQN51yy7qfhIVreTyMi3yc4jQYVX5KUHw5JBc8qGd5KEqYRRneOHrHCg+REAaF
 hPoydTFHw5bhuiQHHGeCNMcc/D59EaUlyA3Q4LVMUmX108ui2RQDh4BqfmdDiru7GG8U
 9xQmXsAPdBBaSVtiUszElbXKc6ODwHgWBnbaCM5aUcSeLblRpSTDLj8OdKX6D8YZYLIT UA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u748vr1wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:08:55 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6H8ssu024597;
	Mon, 6 Nov 2023 17:08:54 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u748vr1vx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:08:54 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6FcKMR012842;
	Mon, 6 Nov 2023 17:08:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u609sk37h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:08:53 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6H8pYP17564184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 17:08:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3838E20040;
	Mon,  6 Nov 2023 17:08:51 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1074F2004B;
	Mon,  6 Nov 2023 17:08:51 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 17:08:51 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/3] s390x: mvpg-sie: fix virtual-physical address confusion
Date: Mon,  6 Nov 2023 18:08:02 +0100
Message-ID: <20231106170849.1184162-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106170849.1184162-1-nrb@linux.ibm.com>
References: <20231106170849.1184162-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5W2aR5FvNiCK6InVPtC31mT8p46xCy08
X-Proofpoint-ORIG-GUID: O7nAhcxdf4Y20i5ll3bFgxireS31Qoga
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060139

The addresses reported for the partial execution of mvpg instruction are
physical addresses. Now that MSO is a virtual address, we can't simply
compare the PEI fields in the sie block with MSO, but need to do an
additional translation step.

Add the necessary virtual-physical translations and expose the
virt_to_pte_phys() function in mmu.h which is useful for this kind of
translation.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/mmu.h  |  2 ++
 s390x/mvpg-sie.c | 15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index dadc2e600f9a..e9e837236603 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -95,4 +95,6 @@ static inline void unprotect_page(void *vaddr, unsigned long prot)
 
 void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level);
 
+phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *vaddr);
+
 #endif /* _ASMS390X_MMU_H_ */
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 99f4859bc2df..effb5eab2c0e 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -23,7 +23,9 @@
 static struct vm vm;
 
 static uint8_t *src;
+static phys_addr_t src_phys;
 static uint8_t *dst;
+static phys_addr_t dst_phys;
 static uint8_t *cmp;
 
 static void test_mvpg_pei(void)
@@ -38,8 +40,8 @@ static void test_mvpg_pei(void)
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
@@ -60,8 +62,8 @@ static void test_mvpg_pei(void)
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
@@ -82,8 +84,10 @@ static void setup_guest(void)
 {
 	extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
 	extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
+	pgd_t *root;
 
 	setup_vm();
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
 
 	snippet_setup_guest(&vm, false);
 	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
@@ -94,6 +98,9 @@ static void setup_guest(void)
 
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


