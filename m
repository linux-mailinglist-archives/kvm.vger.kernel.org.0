Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DB2338A6E
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhCLKmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 05:42:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233286AbhCLKmD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 05:42:03 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CAXTwi171219
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=IjVrYqjyV1Ju9MXqPcBmI5GksYppG9Cn+B770KOPSag=;
 b=IokTLANq7P2dnQq6WtmxmXbw2cjL/Hie1jjc/ruzx0OeKmTqPXVC3yGta6UdVfoJByPe
 CBK01TGYQQmBilODmfXuGRuFpwo/wrKRb/w86YOGV7brLAG/gxiEExFX4kYL1Frki3r+
 0iX1VUpfw44qZYF1mRNLNzAi6FFYH0/LcydRl4Xtsx6jvRjO2nO5TX0xin+5IQAzMqiE
 iJoUecPHF/GdBAMo0mJq/mO1x3ojjmw0XF86BEK2dLqFopHyw0/Wou+LLdf1LlmtgzRf
 NPE13EYtjoDFIkT3VPThyObuT6m6OB+woP4uCH/e27GfaTlkD5qeKHa8T5PwwxVqz0XL ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 377yajanug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:02 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CAYJqx173555
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:01 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 377yajants-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 05:42:01 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CAb2M2018900;
        Fri, 12 Mar 2021 10:42:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3768mpsfpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 10:42:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CAffV137028228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 10:41:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54EAAAE053;
        Fri, 12 Mar 2021 10:41:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF355AE04D;
        Fri, 12 Mar 2021 10:41:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.32.251])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 10:41:56 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 4/6] s390x: css: implementing Set CHannel Monitor
Date:   Fri, 12 Mar 2021 11:41:52 +0100
Message-Id: <1615545714-13747-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120072
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
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h | 12 ++++++++++++
 s390x/css.c     | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7dddb42..7158423 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -309,6 +309,7 @@ struct chsc_scsc {
 	uint8_t reserved[9];
 	struct chsc_header res;
 	uint32_t res_fmt;
+#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
 	uint64_t general_char[255];
 	uint64_t chsc_char[254];
 };
@@ -359,6 +360,17 @@ bool chsc(void *p, uint16_t code, uint16_t len);
 #define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
 #define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
 
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
index a477833..af68266 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -141,6 +141,40 @@ static void css_init(void)
 	report(get_chsc_scsc(), "Store Channel Characteristics");
 }
 
+static void test_schm(void)
+{
+	if (css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK))
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
@@ -150,6 +184,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "measurement block (schm)", test_schm },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

