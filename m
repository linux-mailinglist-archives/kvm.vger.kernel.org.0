Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20693BD6A5
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGFMlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241587AbhGFMUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:20:48 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166CEXH9073338;
        Tue, 6 Jul 2021 08:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hg2MQeyk3YxkSazYhVm2zMzeKJ3PpQ9VxCRtUBwht1Y=;
 b=loSZnSqpEnGulVCJZcip8C7oRqk8cGggwy6piloFwrnj2kasV+dAkqXZEPj9gOcB6ILj
 Q+ewYN+lBNU9o43+m8hO/4zPbrVDMrcNJkC/wcJy9q5XWRzxz0KL60xQkRKeRMIioAuz
 bOyavoOeKhGGlI8JlhWJucg1EW45zmNwEwn7td3sufEQkOPG+QLyGAMsFUd8RQsGRAb+
 kV0I/gKMnBra8SN6IGjBAQK6JT/Ee9uSHhz3votMbQDB8gC4ppoJUULj1YdRT7Z3GdMp
 2FbckW4teiBZ1rEELqkMdhFF/ALD7X7cJPaKkv8C2sVfx2Tvrdd3fATuSNMgwHeyVmOF iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mq0h043e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:09 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166CFhQq078959;
        Tue, 6 Jul 2021 08:18:09 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mq0h041v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166C3tMD026686;
        Tue, 6 Jul 2021 12:18:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 39jfh8s87b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 12:18:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166CI4Ub27459882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:18:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE5342052;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C1CC4205E;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/5] lib: s390x: Print if a pgm happened while in SIE
Date:   Tue,  6 Jul 2021 12:17:56 +0000
Message-Id: <20210706121757.24070-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706121757.24070-1-frankja@linux.ibm.com>
References: <20210706121757.24070-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W3gw_donNfZy4lqljiT7UAKtbbJpbius
X-Proofpoint-ORIG-GUID: SB_ehzJtbX_KA1dGG_mEqDtaRSMMI2WA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For debugging it helps if you know if the PGM happened while being in
SIE or not.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index b627942..109f290 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -141,10 +141,15 @@ static void print_int_regs(struct stack_frame_int *stack)
 static void print_pgm_info(struct stack_frame_int *stack)
 
 {
+	bool in_sie;
+
+	in_sie = (lc->pgm_old_psw.addr >= (uintptr_t)sie_entry &&
+		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
+
 	printf("\n");
-	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
-	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
-	       lc->pgm_int_id);
+	printf("Unexpected program interrupt %s: %d on cpu %d at %#lx, ilen %d\n",
+	       in_sie ? "in SIE" : "",
+	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
 	print_int_regs(stack);
 	dump_stack();
 	report_summary();
-- 
2.30.2

