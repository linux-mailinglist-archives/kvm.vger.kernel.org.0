Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE09522E998
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 11:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgG0Jyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 05:54:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbgG0Jya (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 05:54:30 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06R9W9BW163640;
        Mon, 27 Jul 2020 05:54:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32hs8sx8uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 05:54:30 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06R9WIet164612;
        Mon, 27 Jul 2020 05:54:29 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32hs8sx8tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 05:54:29 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06R9kDIF015670;
        Mon, 27 Jul 2020 09:54:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 32gcqgj2mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 09:54:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06R9sODR54460854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 09:54:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 627E04C062;
        Mon, 27 Jul 2020 09:54:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A80EC4C052;
        Mon, 27 Jul 2020 09:54:23 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jul 2020 09:54:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/3] s390x: Add custom pgm cleanup function
Date:   Mon, 27 Jul 2020 05:54:13 -0400
Message-Id: <20200727095415.494318-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727095415.494318-1-frankja@linux.ibm.com>
References: <20200727095415.494318-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_06:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes we need to do cleanup which we don't necessarily want to add
to interrupt.c, so lets add a way to register a cleanup function.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/interrupt.h |  1 +
 lib/s390x/interrupt.c     | 10 ++++++++++
 2 files changed, 11 insertions(+)

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
index 243b9c2..51cc733 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -16,6 +16,7 @@
 
 static bool pgm_int_expected;
 static bool ext_int_expected;
+static void (*pgm_int_func)(void);
 static struct lowcore *lc;
 
 void expect_pgm_int(void)
@@ -51,6 +52,11 @@ void check_pgm_int_code(uint16_t code)
 	       lc->pgm_int_code);
 }
 
+void register_pgm_int_func(void (*f)(void))
+{
+	pgm_int_func = f;
+}
+
 static void fixup_pgm_int(void)
 {
 	switch (lc->pgm_int_code) {
@@ -115,6 +121,10 @@ void handle_pgm_int(void)
 	}
 
 	pgm_int_expected = false;
+
+	if (pgm_int_func)
+		return (*pgm_int_func)();
+
 	fixup_pgm_int();
 }
 
-- 
2.25.1

