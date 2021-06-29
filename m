Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46383B7347
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhF2NgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:36:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63380 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233926AbhF2NgE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:36:04 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TDXHDZ150696;
        Tue, 29 Jun 2021 09:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xMYjNGIeVlFTQB1mk7gVaEiIcxTvIUgjfAYnIHgxc+Y=;
 b=IGpDbV8k9jvbo/IJJ4fAXIF9xyLVcjeVguzfJ8Tj6wee7NLPLo2rS/pXHfIw9D53E6yn
 LfL/Sqk5uHMTcWIicm9G/OLPQZxFuRTBu2YfU8TeBbic6Sza2gxNs3rfbOt0O935r3NS
 SFZD2hbtQrBrZKbo5+HFpw9UpYY8d6/vK+VltBLFRE8MHUesaej0VeTN2FU/y1Al8h1v
 95o4zLEvyywTppOkeRsuYx5O44z4r0DFAhWxmcLyKLnz61XysqMbcy49bIOyVqyZAOQO
 TaoTgaszIy9AlG5u/8avpW4ZP8yymZyc7Aep27yicICiP7KvO6b7lcFRAte8LYTGxl4A 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g2k4kmsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:37 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TDXI1D150914;
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g2k4kms2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDT7Ak024538;
        Tue, 29 Jun 2021 13:33:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 39ft8er4k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:33:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDVxEW29491620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:31:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A5C9A40D8;
        Tue, 29 Jun 2021 13:33:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 212AEA40F4;
        Tue, 29 Jun 2021 13:33:32 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:33:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 5/5] lib: s390x: Print if a pgm happened while in SIE
Date:   Tue, 29 Jun 2021 13:33:22 +0000
Message-Id: <20210629133322.19193-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629133322.19193-1-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C8mtNVqDCsa0V_GEjS6XbKbtsNW1FgEV
X-Proofpoint-ORIG-GUID: bdLZTa7ILanCJvs8MO50YwBEsazyLk39
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For debugging it helps if you know if the PGM happened while being in
SIE or not.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index b627942..76015b1 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -141,10 +141,21 @@ static void print_int_regs(struct stack_frame_int *stack)
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
+	if (!in_sie)
+		printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
+		       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
+		       lc->pgm_int_id);
+	else
+		printf("Unexpected program interrupt in SIE: %d on cpu %d at %#lx, ilen %d\n",
+		       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
+		       lc->pgm_int_id);
+
 	print_int_regs(stack);
 	dump_stack();
 	report_summary();
-- 
2.30.2

