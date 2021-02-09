Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF6C3150F0
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 14:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBINxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 08:53:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231846AbhBINve (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 08:51:34 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119DZs3n018691;
        Tue, 9 Feb 2021 08:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ffN4dtclYl3195sk0gn9Qn9wjyD/yV2GyFtw3X7TPMA=;
 b=YdYog6dKblkz+Targ7w5iX/9cEZNsEAXiofGoIkc0gKQVbSQkWmq3E7U7bhdnkIuCBAk
 L2Gwub+0i5ma/8nWYSkY4m4+eYJ8oTZPLCHwdPcsz8q1MP6D33Ddwu27OTCF4N1kozPz
 enLuW9CBad+qx8AFf2l5z3nTOpa/XzoV9KA3rMAU8EqYx3awGA/ZdjKe7nivrHAg/b8m
 X2fzc8/S9tx7hC+X9BHOjjg+MP9BnVvrY7rMLhX3+f1aNOzfH48/ZoVIIN3nqGbwU9sN
 WiEXFJOocdRrTLfNP9NtfYBhYaHIRVk7/7nVom5SNGasKXn2JjH4tah1Ghvy0b0I7isG og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ku628rf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:52 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119DjUDh058313;
        Tue, 9 Feb 2021 08:50:51 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ku628re1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:51 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119DTVFo011235;
        Tue, 9 Feb 2021 13:50:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 36hjr81r9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:50:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119DokuE42598908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 13:50:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5237DA4051;
        Tue,  9 Feb 2021 13:50:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E6F1A4040;
        Tue,  9 Feb 2021 13:50:45 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 13:50:45 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        pmorel@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 6/8] s390x: Print more information on program exceptions
Date:   Tue,  9 Feb 2021 08:49:23 -0500
Message-Id: <20210209134925.22248-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209134925.22248-1-frankja@linux.ibm.com>
References: <20210209134925.22248-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090068
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
index 49f98759..1686551a 100644
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

