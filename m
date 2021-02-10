Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D5A3167E9
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 14:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhBJNWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 08:22:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231208AbhBJNVO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 08:21:14 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AD3n5I036087;
        Wed, 10 Feb 2021 08:20:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=446qmvsGr9gOVHGtq7ve8cUesW5T+1JkaHCgElu/rb8=;
 b=oBTqtTupoHStmMd7fIysi3fxz4Nc3doKz5sJeLI9qOMSto2NQyt9YzKfyHL844Nb0VNx
 hWCHCZ6+CNPer2b9edmvB2gKLc/IFDINcq6f+jykAZXQck2JEPw4mQTzZyQ8vyOoGp9G
 NVNqJljh8dvCPh5BB8lAdM14shxIFlDShpEqtBsdInb+y6pTl+UxuCa4461im9SNyn8M
 0GAZxsgB4oDgz1413DyqeOvrTL8VKQtipnYIry1lEB5hmCixN4KCksxk41KmpeZMB88k
 1QTu8Vl6gR6xmhwPma5Ge3ynvH0wfPNmnD7++P1/uP2KanEefZRm7snv6ZBIhVHVhN48 mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfejsqmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AD42Ce037268;
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfejsqkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ADH9He012098;
        Wed, 10 Feb 2021 13:20:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wm1uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 13:20:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ADK7Jw24510854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 13:20:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A3384C050;
        Wed, 10 Feb 2021 13:20:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7DB84C040;
        Wed, 10 Feb 2021 13:20:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.174.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 13:20:16 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/5] s390x: css: implementing Set CHannel Monitor
Date:   Wed, 10 Feb 2021 14:20:12 +0100
Message-Id: <1612963214-30397-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102100126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement the call of the Set CHannel Monitor instruction,
starting the monitoring of the all Channel Sub System, and
initializing channel subsystem monitoring.

An initial test reports the presence of the extended measurement
block feature.

Several tests on SCHM verify the error reporting of the hypervisor.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     | 19 +++++++++++-
 lib/s390x/css_lib.c | 74 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/css.c         | 36 ++++++++++++++++++++++
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index fa8775f..0e3254a 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -82,6 +82,7 @@ struct pmcw {
 	uint32_t intparm;
 #define PMCW_DNV	0x0001
 #define PMCW_ENABLE	0x0080
+#define PMCW_MBUE	0x0010
 #define PMCW_ISC_MASK	0x3800
 #define PMCW_ISC_SHIFT	11
 	uint16_t flags;
@@ -94,6 +95,7 @@ struct pmcw {
 	uint8_t  pom;
 	uint8_t  pam;
 	uint8_t  chpid[8];
+#define PMCW_MBF1	0x0004
 	uint32_t flags2;
 };
 #define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
@@ -101,7 +103,8 @@ struct pmcw {
 struct schib {
 	struct pmcw pmcw;
 	struct scsw scsw;
-	uint8_t  md[12];
+	uint64_t mbo;
+	uint8_t  md[4];
 } __attribute__ ((aligned(4)));
 
 struct irb {
@@ -306,6 +309,7 @@ struct chsc_scsc {
 	u32 res_04[2];
 	struct chsc_header res;
 	u32 res_fmt;
+#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
 	u64 general_char[255];
 	u64 chsc_char[254];
 };
@@ -358,4 +362,17 @@ int chsc(void *p, uint16_t code, uint16_t len);
 #define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
 #define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
 
+#define SCHM_DCTM	1 /* activate Device Connection TiMe */
+#define SCHM_MBU	2 /* activate Measurement Block Update */
+
+static inline void schm(void *mbo, unsigned int flags)
+{
+	register void *__gpr2 asm("2") = mbo;
+	register long __gpr1 asm("1") = flags;
+
+	asm("schm" : : "d" (__gpr2), "d" (__gpr1));
+}
+
+bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 5426a6b..355881d 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -267,6 +267,80 @@ retry:
 	return -1;
 }
 
+static bool schib_update(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
+		  bool format1)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
+		return false;
+	}
+
+	/* Update the SCHIB to enable the measurement block */
+	pmcw->flags |= flags;
+
+	if (format1)
+		pmcw->flags2 |= PMCW_MBF1;
+	else
+		pmcw->flags2 &= ~PMCW_MBF1;
+
+	pmcw->mbi = mbi;
+	schib.mbo = mb;
+
+	/* Tell the CSS we want to modify the subchannel */
+	cc = msch(schid, &schib);
+	if (cc) {
+		/*
+		 * If the subchannel is status pending or
+		 * if a function is in progress,
+		 * we consider both cases as errors.
+		 */
+		report_info("msch: sch %08x failed with cc=%d", schid, cc);
+		return false;
+	}
+
+	/*
+	 * Read the SCHIB again to verify the measurement block origin
+	 */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: updating sch %08x failed with cc=%d",
+			    schid, cc);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * css_enable_mb: enable the subchannel Mesurement Block
+ * @schid: Subchannel Identifier
+ * @mb   : 64bit address of the measurement block
+ * @format1: set if format 1 is to be used
+ * @mbi : the measurement block offset
+ * @flags : PMCW_MBUE to enable measurement block update
+ *	    PMCW_DCTME to enable device connect time
+ * Return value:
+ *   On success: 0
+ *   On error the CC of the faulty instruction
+ *      or -1 if the retry count is exceeded.
+ */
+bool css_enable_mb(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
+		   bool format1)
+{
+	int retry_count = MAX_ENABLE_RETRIES;
+	struct pmcw *pmcw = &schib.pmcw;
+
+	while (retry_count-- && !schib_update(schid, mb, mbi, flags, format1))
+		mdelay(10); /* the hardware was not ready, give it some time */
+
+	return schib.mbo == mb && pmcw->mbi == mbi;
+}
+
 static struct irb irb;
 
 void css_irq_io(void)
diff --git a/s390x/css.c b/s390x/css.c
index d4b3cc8..a382235 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -157,6 +157,41 @@ static void css_init(void)
 	report(1, "CSS initialized");
 }
 
+static void test_schm(void)
+{
+	if (css_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK))
+		report_info("Extended measurement block available");
+
+	/* bits 59-63 of MB address must be 0  if MBU is defined */
+	report_prefix_push("Unaligned operand");
+	expect_pgm_int();
+	schm((void *)0x01, SCHM_MBU);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+
+	/* bits 36-61 flags must be 0 */
+	report_prefix_push("Bad flags");
+	expect_pgm_int();
+	schm(NULL, 0x04);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+
+	/* bits 36-61 flags must be 0 */
+	report_prefix_push("Privilege");
+	enter_pstate();
+	expect_pgm_int();
+	schm(NULL, SCHM_MBU);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	/* Normal operation */
+	report_prefix_push("Normal operation");
+	schm(NULL, SCHM_MBU);
+	report(1,"SCHM call without address");
+	report_prefix_pop();
+
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -166,6 +201,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "measurement block (schm)", test_schm },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

