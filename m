Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CED31EE56
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhBRScJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:32:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234310AbhBRR1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:27:52 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNJ1s051303
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=SmA7GmM+JsirRHcOppzM9qIOpTDSWolWbC0Cd4xoys4=;
 b=J87q7aFetccG1FWsFzDGoNVpcy8voIUJLYTSNUS7dlicOMGOe1z61W8wAmYewkLw2XDd
 NkSapP307jVrLBNAFf+bgqOf0ks4IYhY8stCCK+PwhguCd4DiRcGhhJ3mReJPfxOYoDH
 lQE/1uTC3sN31aGOBMrlLwXwyXx/PONx+4sHby56yuvVePBWL5WKd5nPUMabBZPIp6QB
 QwbUGhohb2uL31qeKLiz2xDNeEWFfiAOORPNs/+MwTU5S4QjqbooPRtTCL9r7f8EWMi5
 MWsQFy7aGmsYzIGDOsZNlgP3H/2B2ilzS+qe/W546gSaP1LmIHfJd7lmoQ9xUxCaiZKy yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36svke83q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IHP5sA068118
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36svke83p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 12:26:52 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IHPFja012496;
        Thu, 18 Feb 2021 17:26:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 36p61hajet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 17:26:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IHQlga62718268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:26:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 536F2A4051;
        Thu, 18 Feb 2021 17:26:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00EBDA404D;
        Thu, 18 Feb 2021 17:26:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.94.58])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 17:26:46 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 3/5] s390x: css: implementing Set CHannel Monitor
Date:   Thu, 18 Feb 2021 18:26:42 +0100
Message-Id: <1613669204-6464-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_07:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 bulkscore=0 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement the call of the Set CHannel Monitor instruction,
starting the monitoring of the all Channel Sub System, and
initializing channel subsystem monitoring.

Initial tests report the presence of the extended measurement block
feature, and verify the error reporting of the hypervisor for SCHM.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  21 +++++++++-
 lib/s390x/css_lib.c | 100 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/css.c         |  35 ++++++++++++++++
 3 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 794321d..17b917f 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -82,6 +82,8 @@ struct pmcw {
 	uint32_t intparm;
 #define PMCW_DNV	0x0001
 #define PMCW_ENABLE	0x0080
+#define PMCW_MBUE	0x0010
+#define PMCW_DCTME	0x0008
 #define PMCW_ISC_MASK	0x3800
 #define PMCW_ISC_SHIFT	11
 	uint16_t flags;
@@ -94,6 +96,7 @@ struct pmcw {
 	uint8_t  pom;
 	uint8_t  pam;
 	uint8_t  chpid[8];
+#define PMCW_MBF1	0x0004
 	uint32_t flags2;
 };
 #define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
@@ -101,7 +104,8 @@ struct pmcw {
 struct schib {
 	struct pmcw pmcw;
 	struct scsw scsw;
-	uint8_t  md[12];
+	uint64_t mbo;
+	uint8_t  md[4];
 } __attribute__ ((aligned(4)));
 
 struct irb {
@@ -306,6 +310,7 @@ struct chsc_scsc {
 	u32 res_04[2];
 	struct chsc_header res;
 	u32 res_fmt;
+#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
 	u64 general_char[255];
 	u64 chsc_char[254];
 };
@@ -356,4 +361,18 @@ int chsc(void *p, uint16_t code, uint16_t len);
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
+bool css_disable_mb(int schid);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 65b58ff..4c8a6ae 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -265,6 +265,106 @@ retry:
 	return -1;
 }
 
+/*
+ * schib_update_mb: update the subchannel Mesurement Block
+ * @schid: Subchannel Identifier
+ * @mb   : 64bit address of the measurement block
+ * @mbi : the measurement block offset
+ * @flags : PMCW_MBUE to enable measurement block update
+ *	    PMCW_DCTME to enable device connect time
+ *	    0 to disable measurement
+ * @format1: set if format 1 is to be used
+ */
+static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
+			    uint16_t flags, bool format1)
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
+	if (flags) {
+		pmcw->flags |= flags;
+
+		if (format1)
+			pmcw->flags2 |= PMCW_MBF1;
+		else
+			pmcw->flags2 &= ~PMCW_MBF1;
+
+		pmcw->mbi = mbi;
+		schib.mbo = mb;
+	} else {
+		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
+	}
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
+	 * Read the SCHIB again
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
+ */
+bool css_enable_mb(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
+		   bool format1)
+{
+	int retry_count = MAX_ENABLE_RETRIES;
+	struct pmcw *pmcw = &schib.pmcw;
+
+	while (retry_count-- &&
+	       !schib_update_mb(schid, mb, mbi, flags, format1))
+		mdelay(10); /* the hardware was not ready, give it some time */
+
+	return schib.mbo == mb && pmcw->mbi == mbi;
+}
+
+/*
+ * css_disable_mb: enable the subchannel Mesurement Block
+ * @schid: Subchannel Identifier
+ */
+bool css_disable_mb(int schid)
+{
+	int retry_count = MAX_ENABLE_RETRIES;
+
+	while (retry_count-- &&
+	       !schib_update_mb(schid, 0, 0, 0, 0))
+		mdelay(10); /* the hardware was not ready, give it some time */
+
+	return retry_count > 0;
+}
+
 static struct irb irb;
 
 void css_irq_io(void)
diff --git a/s390x/css.c b/s390x/css.c
index d4b3cc8..fc693f3 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -157,6 +157,40 @@ static void css_init(void)
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
+	/* bits 36-61 of register 1 (flags) must be 0 */
+	report_prefix_push("Bad flags");
+	expect_pgm_int();
+	schm(NULL, 0xfffffffc);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+
+	/* SCHM is a privilege operation */
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
+	report(1, "SCHM call without address");
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -166,6 +200,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "measurement block (schm)", test_schm },
 	{ NULL, NULL }
 };
 
-- 
2.25.1

