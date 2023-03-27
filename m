Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF68C6C9D8B
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjC0IVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjC0IV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:21:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2303E2D6B;
        Mon, 27 Mar 2023 01:21:26 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32R8Jrev019876;
        Mon, 27 Mar 2023 08:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Nu2vmP304KYlYB7OsbUwR46x3wWsyvpZuGgqCP3TdyI=;
 b=nbE2HXVcUA/TsYJNzBITqDSuyNpaIUFGrxErrWyLkaBf4hMeHx7u6PmA0zTSh5avTwt7
 uhp1nI0ZSBv7pfuNvSKgR3eCXYAiIqL3ojUkEabKFOpOeB6LJ6fj7AXF5B8gITuWDmZC
 riA/nGuey35tk6N61lPvCi7i91q1ahDyCExJCoTR85USm70hiJ+D4Ex4Kl0MnNNgOGN6
 JYfRdYODTwhsAUQRP+ukretioAyeKLhHZC9yFqTMrMg/Gxzu+saOgaq3U9ZQxeqL38zh
 ZDB8LdoyWf6PzCAbCkL+pBIlB/2aIIa9rsU8L7gXk/6FsqleCYXIyDz8RUlNOu+Q2bdF Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjahs9sd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:25 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32R8LO0W005947;
        Mon, 27 Mar 2023 08:21:24 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjahs9sck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:24 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32QH1Hg4019202;
        Mon, 27 Mar 2023 08:21:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6jgt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32R8LJbi46006686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 08:21:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66CC72004D;
        Mon, 27 Mar 2023 08:21:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 472D42004E;
        Mon, 27 Mar 2023 08:21:19 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Mar 2023 08:21:19 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 3/4] s390x: lib: sie: don't reenter SIE on pgm int
Date:   Mon, 27 Mar 2023 10:21:17 +0200
Message-Id: <20230327082118.2177-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230327082118.2177-1-nrb@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 13XIcrQu9_gwWhv4cazIZI397esK2lp4
X-Proofpoint-ORIG-GUID: LsKibp6gkhwIK4F4jgOVs6ewzU9YxtPg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=995 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270065
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, when a PGM int occurs while in SIE, we will just reenter
SIE after the interrupt handler was called.

This is because sie() has a loop which checks icptcode and re-enters SIE
if it is zero.

However, this behaviour is quite undesirable for SIE tests, since it
doesn't give the host the chance to assert on the PGM int. Instead, we
will just re-enter SIE, on nullifing conditions even causing the
exception again.

Add a flag PROG_PGM_IN_SIE set by the pgm int fixup which indicates a
program interrupt has occured in SIE. Check for the flag in sie() and if
it's set return from sie() to give the host the ability to react on the
exception. The host may check if a PGM int has occured in the guest
using the new function sie_had_pgm_int().

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/interrupt.c |  6 ++++++
 lib/s390x/sie.c       | 10 +++++++++-
 lib/s390x/sie.h       |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index eb3d6a9b701d..9baf7a003f52 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -106,10 +106,16 @@ void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
 
 static void fixup_pgm_int(struct stack_frame_int *stack)
 {
+	struct kvm_s390_sie_block *sblk;
+
 	/* If we have an error on SIE we directly move to sie_exit */
 	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
 	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
 		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
+
+		/* set a marker in sie_block that a PGM int occured */
+		sblk = *((struct kvm_s390_sie_block **)(stack->grs0[13] + __SF_SIE_CONTROL));
+		sblk->prog0c |= PROG_PGM_IN_SIE;
 		return;
 	}
 
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 22141ded1a90..5e9ae7115c47 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -44,6 +44,11 @@ void sie_handle_validity(struct vm *vm)
 	vm->validity_expected = false;
 }
 
+bool sie_had_pgm_int(struct vm *vm)
+{
+	return vm->sblk->prog0c & PROG_PGM_IN_SIE;
+}
+
 void sie(struct vm *vm)
 {
 	uint64_t old_cr13;
@@ -68,7 +73,10 @@ void sie(struct vm *vm)
 	lowcore.io_new_psw.mask |= PSW_MASK_DAT_HOME;
 	mb();
 
-	while (vm->sblk->icptcode == 0) {
+	/* clear PGM int marker, which might still be set */
+	vm->sblk->prog0c &= ~PROG_PGM_IN_SIE;
+
+	while (vm->sblk->icptcode == 0 && !sie_had_pgm_int(vm)) {
 		sie64a(vm->sblk, &vm->save_area);
 		sie_handle_validity(vm);
 	}
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 0b00fb709776..8ab755dc9456 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -37,6 +37,7 @@ struct kvm_s390_sie_block {
 	uint32_t 	ibc : 12;
 	uint8_t		reserved08[4];		/* 0x0008 */
 #define PROG_IN_SIE (1<<0)
+#define PROG_PGM_IN_SIE (1<<1)
 	uint32_t	prog0c;			/* 0x000c */
 union {
 		uint8_t	reserved10[16];		/* 0x0010 */
-- 
2.39.1

