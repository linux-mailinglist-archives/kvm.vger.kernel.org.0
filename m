Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070EB31DBAB
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhBQOnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:43:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233569AbhBQOnM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:43:12 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HEY3OK178130;
        Wed, 17 Feb 2021 09:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3ShbFWu6f8UzsZWvNtF64Wai9EJqj/fuvr+3TkfPSHo=;
 b=gz+cSxh3ETZvXItoaKfmcrseh34MdU5e9W9kNzU1GlhQJ3fHeMdeyb/S6JY3f1fQcDhK
 rMMU/8onyI2HmfhCACcc0rYGdaqBzWdDDTCgYERQG25xOP3IfLEe198fcUdcu6qEUeJ3
 /AT9F9LQfN1j6Pyq/NlOrdKw0bG4dgm4PwMr5AY3N4dJ8QBovQEgxLpntIDifER7JgcB
 +DccM3mJVVxZB3WsHoRvkOALBG+gAlFNK+HQkAsnWdfa8BSD3oa1N8DitiztCCfGBCjG
 DGfNaTgeEJYgFKqkeYKcP695ZVTkalTwM9+YPbOb82gKR35IdgurGfHvpOXufl1oR4DE eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s4w9gnaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:31 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HEYW4m182164;
        Wed, 17 Feb 2021 09:42:30 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s4w9gn8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:30 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HEfWem014562;
        Wed, 17 Feb 2021 14:42:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 36rw3u8d1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 14:42:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HEgO7s42336736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:42:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0E4F11C052;
        Wed, 17 Feb 2021 14:42:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED23B11C050;
        Wed, 17 Feb 2021 14:42:23 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 14:42:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 6/8] s390x: Print more information on program exceptions
Date:   Wed, 17 Feb 2021 09:41:14 -0500
Message-Id: <20210217144116.3368-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217144116.3368-1-frankja@linux.ibm.com>
References: <20210217144116.3368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_12:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170113
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
 lib/s390x/interrupt.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 23ad922c..22649d04 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -115,6 +115,21 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
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
 static void print_pgm_info(struct stack_frame_int *stack)
 
 {
@@ -122,6 +137,7 @@ static void print_pgm_info(struct stack_frame_int *stack)
 	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
 	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
 	       lc->pgm_int_id);
+	print_int_regs(stack);
 	dump_stack();
 	report_summary();
 	abort();
@@ -132,6 +148,7 @@ void handle_pgm_int(struct stack_frame_int *stack)
 	if (!pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
+		print_pgm_info(stack);
 		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
 			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
 			     lc->pgm_int_id);
-- 
2.25.1

