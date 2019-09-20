Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E2BB8C47
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 10:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437737AbfITIE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 04:04:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437738AbfITIEZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 04:04:25 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8K7c2rS155594
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 04:04:24 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v4t211ttp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 04:04:23 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 20 Sep 2019 09:04:22 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Sep 2019 09:04:19 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8K84IH433882180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 08:04:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B47F342041;
        Fri, 20 Sep 2019 08:04:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D0942042;
        Fri, 20 Sep 2019 08:04:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.207])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 08:04:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 5/6] s390x: Prepare for external calls
Date:   Fri, 20 Sep 2019 10:03:55 +0200
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190920080356.1948-1-frankja@linux.ibm.com>
References: <20190920080356.1948-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19092008-0012-0000-0000-0000034E73D4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092008-0013-0000-0000-00002188F85E
Message-Id: <20190920080356.1948-6-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=858 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With SMP we also get new external interrupts like external call and
emergency call. Let's make them known.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h  |  5 +++++
 lib/s390x/asm/interrupt.h |  3 +++
 lib/s390x/interrupt.c     | 23 +++++++++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index d5a7f51..96cca2e 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -19,6 +19,11 @@ struct psw {
 #define PSW_MASK_DAT			0x0400000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 
+#define CR0_EXTM_SCLP			0X0000000000000200UL
+#define CR0_EXTM_EXTC			0X0000000000002000UL
+#define CR0_EXTM_EMGC			0X0000000000004000UL
+#define CR0_EXTM_MASK			0X0000000000006200UL
+
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index f485e96..4cfade9 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -11,6 +11,8 @@
 #define _ASMS390X_IRQ_H_
 #include <asm/arch_def.h>
 
+#define EXT_IRQ_EMERGENCY_SIG	0x1201
+#define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
 void handle_pgm_int(void);
@@ -19,6 +21,7 @@ void handle_mcck_int(void);
 void handle_io_int(void);
 void handle_svc_int(void);
 void expect_pgm_int(void);
+void expect_ext_int(void);
 uint16_t clear_pgm_int(void);
 void check_pgm_int_code(uint16_t code);
 
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 7832711..5cade23 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -15,6 +15,7 @@
 #include <sclp.h>
 
 static bool pgm_int_expected;
+static bool ext_int_expected;
 static struct lowcore *lc;
 
 void expect_pgm_int(void)
@@ -24,6 +25,13 @@ void expect_pgm_int(void)
 	mb();
 }
 
+void expect_ext_int(void)
+{
+	ext_int_expected = true;
+	lc->ext_int_code = 0;
+	mb();
+}
+
 uint16_t clear_pgm_int(void)
 {
 	uint16_t code;
@@ -108,15 +116,22 @@ void handle_pgm_int(void)
 
 void handle_ext_int(void)
 {
-	if (lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
+	if (!ext_int_expected &&
+	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
 		report_abort("Unexpected external call interrupt: at %#lx",
 			     lc->ext_old_psw.addr);
-	} else {
-		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
+		return;
+	}
+
+	if (lc->ext_int_code == EXT_IRQ_SERVICE_SIG) {
 		lc->sw_int_cr0 &= ~(1UL << 9);
 		sclp_handle_ext();
-		lc->ext_int_code = 0;
+	} else {
+		ext_int_expected = false;
 	}
+
+	if (!(lc->sw_int_cr0 & CR0_EXTM_MASK))
+		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
 }
 
 void handle_mcck_int(void)
-- 
2.17.2

