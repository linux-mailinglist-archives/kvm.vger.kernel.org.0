Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E733DA4AC
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbhG2Nse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:48:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30380 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237818AbhG2Ns1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:48:27 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TDXWr7110586;
        Thu, 29 Jul 2021 09:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EsHZ+QhPTBgzuJAraXcHOD2mzedOEH+3TReHC3vWe8g=;
 b=fVZ02OcTSfGGsUkb7Cc4A88K5waU5GxJvoNa8l3OefZGGXy0371wVymLhFEHJTyksoUC
 3CKzI35/jILnnh/93BlfLuhlNUWl0wlPwEk6Xhcd2nThn6Gv8yxD8QEckNxY+49U3eIf
 xXUC7zUq2Xw2pGmLE/BUy3yhkwP4cdQJIzWyhCroR2e0T4W9SqaFA/CafF992u0QyU1Y
 VI+2+P/iuUYa9guVc+e1VHtI3Le/JRZyKLnXf+tqoYso7k+blDuK5GQOltQMPRnfWxih
 uPP4Q+HngOgQu57Se2ciRzaekja8EFsy2HDC11PloBv/Lg1/0CoDwL1K4AKEYBNEzFOo 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3tw7nmeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:16 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TDXbJm111183;
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3tw7nmdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDZOwk028272;
        Thu, 29 Jul 2021 13:48:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235khra8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:48:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDjRlh33816962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:45:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 729EA4C0B1;
        Thu, 29 Jul 2021 13:48:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3553B4C073;
        Thu, 29 Jul 2021 13:48:11 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:48:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 3/4] s390x: lib: sie: Add struct vm (de)initialization functions
Date:   Thu, 29 Jul 2021 13:48:02 +0000
Message-Id: <20210729134803.183358-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729134803.183358-1-frankja@linux.ibm.com>
References: <20210729134803.183358-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JUQzhY8FXsnxSy-1tVSKuVOv3OKwdZiQ
X-Proofpoint-GUID: dIE9ASDvUbklDQBC4B5OnvzE-CmM7Cev
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before I start copying the same code over and over lets move this into
the library.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.c  | 30 ++++++++++++++++++++++++++++++
 lib/s390x/sie.h  |  3 +++
 s390x/mvpg-sie.c | 18 ++----------------
 s390x/sie.c      | 19 +++----------------
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 9107519f..ec0c4867 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -11,6 +11,9 @@
 #include <asm/barrier.h>
 #include <libcflat.h>
 #include <sie.h>
+#include <asm/page.h>
+#include <libcflat.h>
+#include <alloc_page.h>
 
 static bool validity_expected;
 static uint16_t vir;
@@ -39,3 +42,30 @@ void sie_handle_validity(struct vm *vm)
 		report_abort("VALIDITY: %x", vir);
 	validity_expected = false;
 }
+
+/* Initializes the struct vm members like the SIE control block. */
+void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
+{
+	vm->sblk = alloc_page();
+	memset(vm->sblk, 0, PAGE_SIZE);
+	vm->sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
+	vm->sblk->ihcpu = 0xffff;
+	vm->sblk->prefix = 0;
+
+	/* Guest memory chunks are always 1MB */
+	assert(!(guest_mem_len & ~HPAGE_MASK));
+	/* Currently MSO/MSL is the easiest option */
+	vm->sblk->mso = (uint64_t)guest_mem;
+	vm->sblk->msl = (uint64_t)guest_mem + ((guest_mem_len - 1) & HPAGE_MASK);
+
+	/* CRYCB needs to be in the first 2GB */
+	vm->crycb = alloc_pages_flags(0, AREA_DMA31);
+	vm->sblk->crycbd = (uint32_t)(uintptr_t)vm->crycb;
+}
+
+/* Frees the memory that was gathered on initialization */
+void sie_guest_destroy(struct vm *vm)
+{
+	free_page(vm->crycb);
+	free_page(vm->sblk);
+}
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 7ff98d2d..946bd164 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -190,6 +190,7 @@ struct vm_save_area {
 struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
+	uint8_t *crycb;				/* Crypto Control Block */
 	/* Ptr to first guest page */
 	uint8_t *guest_mem;
 };
@@ -200,5 +201,7 @@ extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_ar
 void sie_expect_validity(void);
 void sie_check_validity(uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
+void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
+void sie_guest_destroy(struct vm *vm);
 
 #endif /* _S390X_SIE_H_ */
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 2ac91eec..71ae4f88 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -110,22 +110,7 @@ static void setup_guest(void)
 	/* The first two pages are the lowcore */
 	guest_instr = guest + PAGE_SIZE * 2;
 
-	vm.sblk = alloc_page();
-
-	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
-	vm.sblk->prefix = 0;
-	/*
-	 * Pageable guest with the same ASCE as the test programm, but
-	 * the guest memory 0x0 is offset to start at the allocated
-	 * guest pages and end after 1MB.
-	 *
-	 * It's not pretty but faster and easier than managing guest ASCEs.
-	 */
-	vm.sblk->mso = (u64)guest;
-	vm.sblk->msl = (u64)guest;
-	vm.sblk->ihcpu = 0xffff;
-
-	vm.sblk->crycbd = (uint64_t)alloc_page();
+	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 
 	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
 	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
@@ -150,6 +135,7 @@ int main(void)
 	setup_guest();
 	test_mvpg();
 	test_mvpg_pei();
+	sie_guest_destroy(&vm);
 
 done:
 	report_prefix_pop();
diff --git a/s390x/sie.c b/s390x/sie.c
index 5c798a9e..9cb9b055 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -84,22 +84,7 @@ static void setup_guest(void)
 	/* The first two pages are the lowcore */
 	guest_instr = guest + PAGE_SIZE * 2;
 
-	vm.sblk = alloc_page();
-
-	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
-	vm.sblk->prefix = 0;
-	/*
-	 * Pageable guest with the same ASCE as the test programm, but
-	 * the guest memory 0x0 is offset to start at the allocated
-	 * guest pages and end after 1MB.
-	 *
-	 * It's not pretty but faster and easier than managing guest ASCEs.
-	 */
-	vm.sblk->mso = (u64)guest;
-	vm.sblk->msl = (u64)guest;
-	vm.sblk->ihcpu = 0xffff;
-
-	vm.sblk->crycbd = (uint64_t)alloc_page();
+	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 }
 
 int main(void)
@@ -112,6 +97,8 @@ int main(void)
 
 	setup_guest();
 	test_diags();
+	sie_guest_destroy(&vm);
+
 done:
 	report_prefix_pop();
 	return report_summary();
-- 
2.30.2

