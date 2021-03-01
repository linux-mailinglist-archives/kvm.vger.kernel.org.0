Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCEE327D85
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhCALs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:48:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234205AbhCALr5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 06:47:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121BX0sW026355
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7SwerKTgwsFrIxi/y5WBqeX5YphlWY4HIa3ExWODyLQ=;
 b=MITEXZlqh6kEv/Ia8Wpq7Oxpjc57gzHtD6jN47/gXpfD6iPwM9bgZ42hl9R4yw1zjLIE
 Y2+V+wZWA/K0/ktLijEu7/EhCy8QEioF9xmI72c0b9eGaey/Wpmwb9bu60jMj1PlFroQ
 KDFn5WNpx0QoOthPAnC3v4qsXyrpAHwIaSnbSJ4q3f9Z10b9VszAfXIFsc5Bmt5Qet7s
 FQSrrno6GGQ2ryE3fW2U3SDRtArGEnKHAhngzNfVH6f8KO0Uh6TvBslonRT6CuroMiJ7
 prxSA8iPPDX3PUAKNCz4tNvVLPH2Ot7T7xClhke7yByB9A/HeIru9UZ44ttFl86oBMOM Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370y778xmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 06:47:14 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121BY8LS032185
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:13 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370y778xkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 06:47:13 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121Bh4ka015732;
        Mon, 1 Mar 2021 11:47:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 36ydq8hu22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 11:47:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121BksIW34603468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 11:46:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E7DFAE04D;
        Mon,  1 Mar 2021 11:47:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43717AE045;
        Mon,  1 Mar 2021 11:47:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.52.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 11:47:08 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 4/6] s390x: css: implementing Set CHannel Monitor
Date:   Mon,  1 Mar 2021 12:47:03 +0100
Message-Id: <1614599225-17734-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_05:2021-02-26,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement the call of the Set CHannel Monitor instruction,
starting the monitoring of the all Channel Sub System, and
initializing channel subsystem monitoring.

Initial tests report the presence of the extended measurement block
feature, and verify the error reporting of the hypervisor for SCHM.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/css.h | 12 ++++++++++++
 s390x/css.c     | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 1cb3de2..b8ac363 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -310,6 +310,7 @@ struct chsc_scsc {
 	uint32_t res_04[2];
 	struct chsc_header res;
 	uint32_t res_fmt;
+#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
 	uint64_t general_char[255];
 	uint64_t chsc_char[254];
 };
@@ -360,6 +361,17 @@ bool chsc(void *p, uint16_t code, uint16_t len);
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
 bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
 bool css_disable_mb(int schid);
 
diff --git a/s390x/css.c b/s390x/css.c
index c9e4903..e8f96f3 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -150,6 +150,40 @@ static void css_init(void)
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
@@ -159,6 +193,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "measurement block (schm)", test_schm },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

