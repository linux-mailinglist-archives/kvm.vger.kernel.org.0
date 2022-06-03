Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7261A53CC6F
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245600AbiFCPkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245591AbiFCPkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:40:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871AD4ECEB;
        Fri,  3 Jun 2022 08:40:45 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253E0xgI018207;
        Fri, 3 Jun 2022 15:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xmUh/pJg//vim7uApb3IC5UNDtvBCtkHhCvO9Xglk88=;
 b=fbRQk9hvrLIla7fQmbL7CB/zjT7AWIFPiUR1ZLiE6SBzBH5gONX1JqS/f7/6MyoQF/Qx
 fPJBvmQ9QsBrNzJ1VfzCeVk1aiMB3wTix3VUsHMbt8Xa9NyRW92KVldvPG+4mX4evXIx
 DZAwfta9VR9xHQUnTYOvQUhfCEh3ERPhPzQUk0AfjkPP4B7fWSeNVjCJCIQ8yYopC6Qz
 JN0oOAqA3g6XLe4GvWRJRhxSHki1KbEXQozX6gkzfp80df1B1PqmpOPpcDKjIapNHOAm
 GYFyARuqZo6txaWn1OnqeGdbZ5ozv2MnUSquavZ+Sex0rG+m6ibn47o+B53j8JStT7L+ FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfhftcqkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:45 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253Fd16L008811;
        Fri, 3 Jun 2022 15:40:44 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfhftcqjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:44 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253FbncB009631;
        Fri, 3 Jun 2022 15:40:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3gbc97xjrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253Fecfi21496260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 15:40:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3060A4040;
        Fri,  3 Jun 2022 15:40:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 909BEA4053;
        Fri,  3 Jun 2022 15:40:38 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 15:40:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, pmorel@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt checks
Date:   Fri,  3 Jun 2022 17:40:37 +0200
Message-Id: <20220603154037.103733-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603154037.103733-1-imbrenda@linux.ibm.com>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NaVwaCnqrV1Q8nnjsC_tku4amHTAmxMU
X-Proofpoint-ORIG-GUID: SCpsUPIbGMHd71a8N7e-Vev7UJnueLbs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=651 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use per-CPU flags and callbacks for Program, Extern, and I/O interrupts
instead of global variables.

This allows for more accurate error handling; a CPU waiting for an
interrupt will not have it "stolen" by a different CPU that was not
supposed to wait for one, and now two CPUs can wait for interrupts at
the same time.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  7 ++++++-
 lib/s390x/interrupt.c    | 38 ++++++++++++++++----------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 72553819..3a0d9c43 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -124,7 +124,12 @@ struct lowcore {
 	uint8_t		pad_0x0280[0x0308 - 0x0280];	/* 0x0280 */
 	uint64_t	sw_int_crs[16];			/* 0x0308 */
 	struct psw	sw_int_psw;			/* 0x0388 */
-	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
+	uint32_t	pgm_int_expected;		/* 0x0398 */
+	uint32_t	ext_int_expected;		/* 0x039c */
+	void		(*pgm_cleanup_func)(void);	/* 0x03a0 */
+	void		(*ext_cleanup_func)(void);	/* 0x03a8 */
+	void		(*io_int_func)(void);		/* 0x03b0 */
+	uint8_t		pad_0x03b8[0x11b0 - 0x03b8];	/* 0x03b8 */
 	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
 	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
 	uint64_t	fprs_sa[16];			/* 0x1200 */
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 27d3b767..e57946f0 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -15,14 +15,11 @@
 #include <fault.h>
 #include <asm/page.h>
 
-static bool pgm_int_expected;
-static bool ext_int_expected;
-static void (*pgm_cleanup_func)(void);
 static struct lowcore *lc;
 
 void expect_pgm_int(void)
 {
-	pgm_int_expected = true;
+	lc->pgm_int_expected = 1;
 	lc->pgm_int_code = 0;
 	lc->trans_exc_id = 0;
 	mb();
@@ -30,7 +27,7 @@ void expect_pgm_int(void)
 
 void expect_ext_int(void)
 {
-	ext_int_expected = true;
+	lc->ext_int_expected = 1;
 	lc->ext_int_code = 0;
 	mb();
 }
@@ -43,7 +40,7 @@ uint16_t clear_pgm_int(void)
 	code = lc->pgm_int_code;
 	lc->pgm_int_code = 0;
 	lc->trans_exc_id = 0;
-	pgm_int_expected = false;
+	lc->pgm_int_expected = 0;
 	return code;
 }
 
@@ -57,7 +54,7 @@ void check_pgm_int_code(uint16_t code)
 
 void register_pgm_cleanup_func(void (*f)(void))
 {
-	pgm_cleanup_func = f;
+	lc->pgm_cleanup_func = f;
 }
 
 static void fixup_pgm_int(struct stack_frame_int *stack)
@@ -184,24 +181,23 @@ static void print_pgm_info(struct stack_frame_int *stack)
 
 void handle_pgm_int(struct stack_frame_int *stack)
 {
-	if (!pgm_int_expected) {
+	if (!lc->pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
 		print_pgm_info(stack);
 	}
 
-	pgm_int_expected = false;
+	lc->pgm_int_expected = 0;
 
-	if (pgm_cleanup_func)
-		(*pgm_cleanup_func)();
+	if (lc->pgm_cleanup_func)
+		(*lc->pgm_cleanup_func)();
 	else
 		fixup_pgm_int(stack);
 }
 
 void handle_ext_int(struct stack_frame_int *stack)
 {
-	if (!ext_int_expected &&
-	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
+	if (!lc->ext_int_expected && lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
 		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
 			     lc->ext_int_code, stap(), lc->ext_old_psw.addr);
 		return;
@@ -211,7 +207,7 @@ void handle_ext_int(struct stack_frame_int *stack)
 		stack->crs[0] &= ~(1UL << 9);
 		sclp_handle_ext();
 	} else {
-		ext_int_expected = false;
+		lc->ext_int_expected = 0;
 	}
 
 	if (!(stack->crs[0] & CR0_EXTM_MASK))
@@ -224,12 +220,10 @@ void handle_mcck_int(void)
 		     stap(), lc->mcck_old_psw.addr);
 }
 
-static void (*io_int_func)(void);
-
 void handle_io_int(void)
 {
-	if (io_int_func)
-		return io_int_func();
+	if (lc->io_int_func)
+		return lc->io_int_func();
 
 	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
 		     stap(), lc->io_old_psw.addr);
@@ -237,17 +231,17 @@ void handle_io_int(void)
 
 int register_io_int_func(void (*f)(void))
 {
-	if (io_int_func)
+	if (lc->io_int_func)
 		return -1;
-	io_int_func = f;
+	lc->io_int_func = f;
 	return 0;
 }
 
 int unregister_io_int_func(void (*f)(void))
 {
-	if (io_int_func != f)
+	if (lc->io_int_func != f)
 		return -1;
-	io_int_func = NULL;
+	lc->io_int_func = NULL;
 	return 0;
 }
 
-- 
2.36.1

