Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2DF3EB19D
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239519AbhHMHiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239500AbhHMHiD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:03 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7Wugp010824;
        Fri, 13 Aug 2021 03:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1xgwdT55J9MdPF5mjrNWsmq7f6mDR+p/lf+LhvMQ/N0=;
 b=UBu7XOH8RS9G3ssXgG5X5N8FPrV3QDAyaNOYuZM+n7/Fx7Dzobm/t4GLTG7j3oG6fE4T
 p0MHGBM2ayw5Zv7V8nXayxID19G7/A9E/rOtySfCpGFHhFRtlCVp0hYp9Qkvc3BA0fYQ
 wXgJhniB/ijeZFw2wGPiXxwNx9YIKWrFCXwOploUQrlffLM7S3CDPW+igZzNvRfN2+dZ
 v+nOaMwVVVvJN2DyV6Br2dgu7PBLMpfs0Nm8JDJ4mstzPtroaRBtK2GD9z3MIMJJK4+E
 lOht69OpypJKgiaZ8vED5Q61GYWA5Kf6vcuRpjhYI0UFYYMrYScwszC53hTX5Xwz0xx2 Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstpk5dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7YX2f016357;
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstpk5cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7N7kK025212;
        Fri, 13 Aug 2021 07:37:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3ad4kqh5h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bV9u56492542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64D9842047;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 206E14203F;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 3/8] lib: s390x: Print addressing related exception information
Date:   Fri, 13 Aug 2021 07:36:10 +0000
Message-Id: <20210813073615.32837-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZUSBVxdHH9z9yMmT0ZddPJMXwQ9q-xZK
X-Proofpoint-ORIG-GUID: qGr_Ohpyt3q7npcA_muHr23PYfZ7fl1q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we only get told the kind of program exception as well as
the PSW at the point where it happened.

For addressing exceptions the PSW is not always enough so let's print
the TEID which contains the failing address and flags that tell us
more about the kind of address exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  4 +++
 lib/s390x/interrupt.c    | 72 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 4ca02c1d..39c5ba99 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -41,6 +41,10 @@ struct psw {
 	uint64_t	addr;
 };
 
+/* Let's ignore spaces we don't expect to use for now. */
+#define AS_PRIM				0
+#define AS_HOME				3
+
 #define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_IO			0x0200000000000000UL
 #define PSW_MASK_DAT			0x0400000000000000UL
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 01ded49d..1248bceb 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -12,6 +12,7 @@
 #include <sclp.h>
 #include <interrupt.h>
 #include <sie.h>
+#include <asm/page.h>
 
 static bool pgm_int_expected;
 static bool ext_int_expected;
@@ -126,6 +127,73 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	/* suppressed/terminated/completed point already at the next address */
 }
 
+static void decode_pgm_prot(uint64_t teid)
+{
+	/* Low-address protection exception, 100 */
+	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid)) {
+		printf("Type: LAP\n");
+		return;
+	}
+
+	/* Instruction execution prevention, i.e. no-execute, 101 */
+	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid)) {
+		printf("Type: IEP\n");
+		return;
+	}
+
+	/* Standard DAT exception, 001 */
+	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid)) {
+		printf("Type: DAT\n");
+		return;
+	}
+}
+
+static void decode_teid(uint64_t teid)
+{
+	int asce_id = lc->trans_exc_id & 3;
+	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
+
+	printf("Memory exception information:\n");
+	printf("TEID: %lx\n", teid);
+	printf("DAT: %s\n", dat ? "on" : "off");
+	printf("AS: %s\n", asce_id == AS_PRIM ? "Primary" : "Home");
+
+	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
+		decode_pgm_prot(teid);
+
+	/*
+	 * If teid bit 61 is off for these two exception the reported
+	 * address is unpredictable.
+	 */
+	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
+	     lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
+	    !test_bit_inv(61, &teid)) {
+		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
+		return;
+	}
+	printf("Address: %lx\n\n", teid & PAGE_MASK);
+}
+
+static void print_storage_exception_information(void)
+{
+	switch (lc->pgm_int_code) {
+	case PGM_INT_CODE_PROTECTION:
+	case PGM_INT_CODE_PAGE_TRANSLATION:
+	case PGM_INT_CODE_SEGMENT_TRANSLATION:
+	case PGM_INT_CODE_ASCE_TYPE:
+	case PGM_INT_CODE_REGION_FIRST_TRANS:
+	case PGM_INT_CODE_REGION_SECOND_TRANS:
+	case PGM_INT_CODE_REGION_THIRD_TRANS:
+	case PGM_INT_CODE_SECURE_STOR_ACCESS:
+	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
+	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
+		decode_teid(lc->trans_exc_id);
+		break;
+	default:
+		return;
+	}
+}
+
 static void print_int_regs(struct stack_frame_int *stack)
 {
 	printf("\n");
@@ -155,6 +223,10 @@ static void print_pgm_info(struct stack_frame_int *stack)
 	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
 	print_int_regs(stack);
 	dump_stack();
+
+	/* Dump stack doesn't end with a \n so we add it here instead */
+	printf("\n");
+	print_storage_exception_information();
 	report_summary();
 	abort();
 }
-- 
2.30.2

