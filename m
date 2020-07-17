Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E74223EEA
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 16:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgGQO63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:58:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726755AbgGQO62 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 10:58:28 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HEUxx3031437;
        Fri, 17 Jul 2020 10:58:27 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32b61knv3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:58:27 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06HEVESE032683;
        Fri, 17 Jul 2020 10:58:27 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32b61knv32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:58:27 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06HEpZVZ018424;
        Fri, 17 Jul 2020 14:58:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 327q2y34a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 14:58:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06HEwM8r52363336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:58:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CBE142049;
        Fri, 17 Jul 2020 14:58:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 892D842041;
        Fri, 17 Jul 2020 14:58:21 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 14:58:21 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/3] s390x: Add custom pgm cleanup function
Date:   Fri, 17 Jul 2020 10:58:11 -0400
Message-Id: <20200717145813.62573-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200717145813.62573-1-frankja@linux.ibm.com>
References: <20200717145813.62573-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 clxscore=1015 suspectscore=1 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes we need to do cleanup which we don't necessarily want to add
to interrupt.c, so lets add a way to register a cleanup function.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 1 +
 lib/s390x/interrupt.c     | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 4cfade9..b2a7c83 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -15,6 +15,7 @@
 #define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
+void register_pgm_int_func(void (*f)(void));
 void handle_pgm_int(void);
 void handle_ext_int(void);
 void handle_mcck_int(void);
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 243b9c2..36ba720 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -16,6 +16,7 @@
 
 static bool pgm_int_expected;
 static bool ext_int_expected;
+static void (*pgm_int_func)(void);
 static struct lowcore *lc;
 
 void expect_pgm_int(void)
@@ -51,8 +52,16 @@ void check_pgm_int_code(uint16_t code)
 	       lc->pgm_int_code);
 }
 
+void register_pgm_int_func(void (*f)(void))
+{
+	pgm_int_func = f;
+}
+
 static void fixup_pgm_int(void)
 {
+	if (pgm_int_func)
+		return (*pgm_int_func)();
+
 	switch (lc->pgm_int_code) {
 	case PGM_INT_CODE_PRIVILEGED_OPERATION:
 		/* Normal operation is in supervisor state, so this exception
-- 
2.25.1

