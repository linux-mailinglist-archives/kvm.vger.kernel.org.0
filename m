Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD9D3213DB
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 11:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhBVKMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 05:12:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231150AbhBVKKd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 05:10:33 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MA3hTf024998;
        Mon, 22 Feb 2021 05:09:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=T4PV5y8Jn2Wqk9Zc6NHSyw1I7XFgC4nrxdIIvhzNCxk=;
 b=fNSrcyljYGklbUMCPrnsZY+cpgnwk1rFlM1dgt+LN/SR8SbeovKQZ4kXk6nbIgJ7504E
 QJKFaistPDzEVKYz91nDq9DFnytfkFJJQD/GARwBiMAMIKcEuN32U+b3xyo+tvqAwaiT
 /AcmDoa2SY2LfsdBpuG9a5bkhrIZeMY5U0O3heWDLIPk3aXtPdKY/CXAtHv0yVUAUFPS
 ppIZNOHCV0KKjJCLS+U1yp7rJ8WQmzqT2wzzILL2kP6lHl+RC5hY61pGSYYqczSUkU1Q
 /0rIitBcagBSSIHo9yaH2mSV2Fwwi5JQsa652hBZ6VBNmoIb9LQpokOz7UBR/ZFvJIA9 RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vah9rdbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 05:09:52 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11MA3rBW025977;
        Mon, 22 Feb 2021 05:07:07 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vah9r659-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 05:07:07 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M8wPZ2022166;
        Mon, 22 Feb 2021 08:59:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph1f12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:59:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M8xCSd42860868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 08:59:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5B23AE055;
        Mon, 22 Feb 2021 08:59:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25D1FAE053;
        Mon, 22 Feb 2021 08:59:12 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 08:59:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 5/7] s390x: Print more information on program exceptions
Date:   Mon, 22 Feb 2021 03:57:54 -0500
Message-Id: <20210222085756.14396-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222085756.14396-1-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-18,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently we only get a single line of output if a test runs in a
unexpected program exception. Let's also print the general registers
to give soem more context.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/interrupt.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index a59df80e..22649d04 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -115,11 +115,40 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	/* suppressed/terminated/completed point already at the next address */
 }
 
+static void print_int_regs(struct stack_frame_int *stack)
+{
+	printf("\n");
+	printf("GPRS:\n");
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs1[0], stack->grs1[1], stack->grs0[0], stack->grs0[1]);
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs0[2], stack->grs0[3], stack->grs0[4], stack->grs0[5]);
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs0[6], stack->grs0[7], stack->grs0[8], stack->grs0[9]);
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs0[10], stack->grs0[11], stack->grs0[12], stack->grs0[13]);
+	printf("\n");
+}
+
+static void print_pgm_info(struct stack_frame_int *stack)
+
+{
+	printf("\n");
+	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
+	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
+	       lc->pgm_int_id);
+	print_int_regs(stack);
+	dump_stack();
+	report_summary();
+	abort();
+}
+
 void handle_pgm_int(struct stack_frame_int *stack)
 {
 	if (!pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
+		print_pgm_info(stack);
 		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
 			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
 			     lc->pgm_int_id);
-- 
2.25.1

