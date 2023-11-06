Return-Path: <kvm+bounces-744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5995C7E2274
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14DD32815E3
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF9E250EA;
	Mon,  6 Nov 2023 12:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XRz8u/8a"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952201F958
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:54:10 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAF0F3;
	Mon,  6 Nov 2023 04:54:07 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CfH3f019581;
	Mon, 6 Nov 2023 12:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cdzPZkW7H6NXLhB/1Qdd4i+I2012ISpdbuUldHqIMhU=;
 b=XRz8u/8aLbIEUp1BYzCiPwf9rZRp+QR6qsinfusivgpIkJZlBhM2ddCsdAQQ1+gEXJNA
 mAxVCMgFUROP2bgdzT2NglEG1S27nhyEgeSrof1vyZyvm3JscO36lDULhrqzBIzDZgij
 ykg20bsbWHxeq34G0O7PezwQxFyvQR9+M7nA3sn27IKR6YDr2/RKT0Q8eDYZXF6O0CTG
 uchfF39f5YSDhWhWYj5abmIy6oYZ0gNCh5tU40/Abn8YHgEb/wAtLbQmHKYVHXKnO3D9
 zPnpg1BpW6APkq/PLpxZHeHMnyiTQUKIktJxRQdWhiuaa6qkTE5l4cTbuPUuTYqCQQeJ HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u70c1gccc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:59 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6CgWqw023900;
	Mon, 6 Nov 2023 12:53:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u70c1gcc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:59 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6AtubC007961;
	Mon, 6 Nov 2023 12:53:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u60ny9eba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6CrsTe7013036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 12:53:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D205E20040;
	Mon,  6 Nov 2023 12:53:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AE9E2004B;
	Mon,  6 Nov 2023 12:53:54 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 12:53:54 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev,
        lvivier@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 08/10] s390x: gs: turn off formatter for inline assembly
Date: Mon,  6 Nov 2023 13:51:04 +0100
Message-ID: <20231106125352.859992-9-nrb@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: bZx_3nho5yWGdp2ZCnAadXmoBCV0oDBd
X-Proofpoint-GUID: 0XhHdFJQ4i9QnmOCQdH5S_dbzsgurskE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_11,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=908 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060104

clang-format does not properly understand the code and aligns the first
opening quote on consecutive lines with the last opening quote on the
previous line like so:

" some string " CONCATED_WITH_MACRO " continues here "
                                    " weird indent for some reason"

Disable clang-format for this block of code and properly align the
indented asm with the opening parenthesis.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/gs.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/s390x/gs.c b/s390x/gs.c
index 9ae893eaf89a..7e08c2a78d32 100644
--- a/s390x/gs.c
+++ b/s390x/gs.c
@@ -35,28 +35,30 @@ static inline unsigned long load_guarded(unsigned long *p)
 }
 
 /* guarded-storage event handler and finally it calls gs_handler */
+/* clang-format off */
 extern void gs_handler_asm(void);
-	asm (          ".macro	STGSC	args:vararg\n"
-		"	.insn	rxy,0xe30000000049,\\args\n"
-		"	.endm\n"
-		"	.globl	gs_handler_asm\n"
-		"gs_handler_asm:\n"
-		"	lgr	%r14,%r15\n"				/* Save current stack address in r14 */
-		".Lgs_handler_frame = 16*8+32+" xstr(STACK_FRAME_SIZE) "\n"
-		"	aghi	%r15,-(.Lgs_handler_frame)\n"		/* Allocate stack frame */
-		"	stmg	%r0,%r13,192(%r15)\n"			/* Store regs to save area */
-		"	stg	%r14,312(%r15)\n"
-		"	la	%r2," xstr(STACK_FRAME_SIZE) "(%r15)\n"	/* Store gscb address in this_cb */
-		"	STGSC	%r0," xstr(STACK_FRAME_SIZE) "(%r15)\n"
-		"	lg	%r14,24(%r2)\n"				/* Get GSEPLA from GSCB*/
-		"	lg	%r14,40(%r14)\n"			/* Get GSERA from GSEPL*/
-		"	stg	%r14,304(%r15)\n"			/* Store GSERA in r14 of reg save area */
-		"	brasl	%r14,gs_handler\n"			/* Jump to gs_handler */
-		"	lmg	%r0,%r15,192(%r15)\n"			/* Restore regs */
-		"	aghi	%r14, 6\n"				/* Add lgg instr len to GSERA */
-		"	br	%r14\n"					/* Jump to next instruction after lgg */
-		".size gs_handler_asm,.-gs_handler_asm\n"
-	);
+asm (".macro	STGSC	args:vararg\n"
+     "	.insn	rxy,0xe30000000049,\\args\n"
+     "	.endm\n"
+     "	.globl	gs_handler_asm\n"
+     "gs_handler_asm:\n"
+     "	lgr	%r14,%r15\n"				/* Save current stack address in r14 */
+     ".Lgs_handler_frame = 16*8+32+" xstr(STACK_FRAME_SIZE) "\n"
+     "	aghi	%r15,-(.Lgs_handler_frame)\n"		/* Allocate stack frame */
+     "	stmg	%r0,%r13,192(%r15)\n"			/* Store regs to save area */
+     "	stg	%r14,312(%r15)\n"
+     "	la	%r2," xstr(STACK_FRAME_SIZE) "(%r15)\n"	/* Store gscb address in this_cb */
+     "	STGSC	%r0," xstr(STACK_FRAME_SIZE) "(%r15)\n"
+     "	lg	%r14,24(%r2)\n"				/* Get GSEPLA from GSCB*/
+     "	lg	%r14,40(%r14)\n"			/* Get GSERA from GSEPL*/
+     "	stg	%r14,304(%r15)\n"			/* Store GSERA in r14 of reg save area */
+     "	brasl	%r14,gs_handler\n"			/* Jump to gs_handler */
+     "	lmg	%r0,%r15,192(%r15)\n"			/* Restore regs */
+     "	aghi	%r14, 6\n"				/* Add lgg instr len to GSERA */
+     "	br	%r14\n"					/* Jump to next instruction after lgg */
+     ".size gs_handler_asm,.-gs_handler_asm\n"
+);
+/* clang-format on */
 
 void gs_handler(struct gs_cb *this_cb)
 {
-- 
2.41.0


