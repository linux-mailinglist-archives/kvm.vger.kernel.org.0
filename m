Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAEC338A6B
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhCLKmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 05:42:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232988AbhCLKmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 05:42:02 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CAWvm1173108
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=1Kg072U2s1o8UXNvR+hjpC6LwL5yeTNbwooihYMf9Bw=;
 b=Cgprlpvqvdcx7RTTzzpAxX7uLvbyc4Y1HiqvBtEWHcRvQDV63WCSI4/3NhQQAJ95MotL
 TyKHk3zNAY1ccrHQDcFlL53OW9jLn8Gqlzijue8qGnt8Aqz1RoiatnytGesHpdg3fT+X
 sDRje5YVtZ/svfGyL6zhACOShrMEWyGeBhQJIbHgoyw5ofVwY6mr3Ku2lTe/4hmtoJc1
 ClQsKYI24iS1X92EHB9bmI1nmpnK+UbR5GlzAuE/VFNF9EbAAXDXD3fZrl80Lx6e2w7J
 rd5gTrqQLqTLMJDiignO1gNamlaLoAgFus7lzA4wizhovwy9JHA/+qDZpWEo0X1IPDY4 /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774mfe6f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:01 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CAXFwh173949
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:01 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774mfe6da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 05:42:01 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CAcRYf019528;
        Fri, 12 Mar 2021 10:41:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3768mpsfpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 10:41:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CAfuLR13697302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 10:41:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17A87AE045;
        Fri, 12 Mar 2021 10:41:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B07E3AE051;
        Fri, 12 Mar 2021 10:41:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.32.251])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 10:41:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 1/6] s390x: css: Store CSS Characteristics
Date:   Fri, 12 Mar 2021 11:41:49 +0100
Message-Id: <1615545714-13747-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CSS characteristics exposes the features of the Channel SubSystem.
Let's use Store Channel Subsystem Characteristics to retrieve
the features of the CSS.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h     | 66 ++++++++++++++++++++++++++++++++
 lib/s390x/css_lib.c | 93 ++++++++++++++++++++++++++++++++++++++++++++-
 s390x/css.c         |  8 ++++
 3 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 3e57445..3dc2f31 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -288,4 +288,70 @@ int css_residual_count(unsigned int schid);
 void enable_io_isc(uint8_t isc);
 int wait_and_check_io_completion(int schid);
 
+/*
+ * CHSC definitions
+ */
+struct chsc_header {
+	uint16_t len;
+	uint16_t code;
+};
+
+/* Store Channel Subsystem Characteristics */
+struct chsc_scsc {
+	struct chsc_header req;
+	uint16_t req_fmt;
+	uint8_t cssid;
+	uint8_t reserved[9];
+	struct chsc_header res;
+	uint32_t res_fmt;
+	uint64_t general_char[255];
+	uint64_t chsc_char[254];
+};
+
+extern struct chsc_scsc *chsc_scsc;
+#define CHSC_SCSC	0x0010
+#define CHSC_SCSC_LEN	0x0010
+
+bool get_chsc_scsc(void);
+
+#define CSS_GENERAL_FEAT_BITLEN	(255 * 64)
+#define CSS_CHSC_FEAT_BITLEN	(254 * 64)
+
+#define CHSC_SCSC	0x0010
+#define CHSC_SCSC_LEN	0x0010
+
+#define CHSC_ERROR	0x0000
+#define CHSC_RSP_OK	0x0001
+#define CHSC_RSP_INVAL	0x0002
+#define CHSC_RSP_REQERR	0x0003
+#define CHSC_RSP_ENOCMD	0x0004
+#define CHSC_RSP_NODATA	0x0005
+#define CHSC_RSP_SUP31B	0x0006
+#define CHSC_RSP_EFRMT	0x0007
+#define CHSC_RSP_ECSSID	0x0008
+#define CHSC_RSP_ERFRMT	0x0009
+#define CHSC_RSP_ESSID	0x000A
+#define CHSC_RSP_EBUSY	0x000B
+#define CHSC_RSP_MAX	0x000B
+
+static inline int _chsc(void *p)
+{
+	int cc;
+
+	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
+		     " ipm     %0\n"
+		     " srl     %0,28\n"
+		     : "=d" (cc), "=m" (p)
+		     : "d" (p), "m" (p)
+		     : "cc");
+
+	return cc;
+}
+
+bool chsc(void *p, uint16_t code, uint16_t len);
+
+#include <bitops.h>
+#define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
+#define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 3c24480..3c1acbf 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -15,11 +15,102 @@
 #include <asm/arch_def.h>
 #include <asm/time.h>
 #include <asm/arch_def.h>
-
+#include <alloc_page.h>
 #include <malloc_io.h>
 #include <css.h>
 
 static struct schib schib;
+struct chsc_scsc *chsc_scsc;
+
+static const char * const chsc_rsp_description[] = {
+	"CHSC unknown error",
+	"Command executed",
+	"Invalid command",
+	"Request-block error",
+	"Command not installed",
+	"Data not available",
+	"Absolute address of channel-subsystem communication block exceeds 2G - 1.",
+	"Invalid command format",
+	"Invalid channel-subsystem identification (CSSID)",
+	"The command-request block specified an invalid format for the command response block.",
+	"Invalid subchannel-set identification (SSID)",
+	"A busy condition precludes execution.",
+};
+
+static bool check_response(void *p)
+{
+	struct chsc_header *h = p;
+
+	if (h->code == CHSC_RSP_OK)
+		return true;
+
+	if (h->code > CHSC_RSP_MAX)
+		h->code = 0;
+
+	report_abort("Response code %04x: %s", h->code,
+		      chsc_rsp_description[h->code]);
+	return false;
+}
+
+bool chsc(void *p, uint16_t code, uint16_t len)
+{
+	struct chsc_header *h = p;
+
+	h->code = code;
+	h->len = len;
+
+	switch (_chsc(p)) {
+	case 3:
+		report_abort("Subchannel invalid or not enabled.");
+		break;
+	case 2:
+		report_abort("CHSC subchannel busy.");
+		break;
+	case 1:
+		report_abort("Subchannel invalid or not enabled.");
+		break;
+	case 0:
+		return check_response(p + len);
+	}
+	return false;
+}
+
+bool get_chsc_scsc(void)
+{
+	int i, n;
+	char buffer[510];
+	char *p;
+
+	if (chsc_scsc) /* chsc_scsc already initialized */
+		return true;
+
+	chsc_scsc = alloc_page();
+	if (!chsc_scsc) {
+		report_abort("could not allocate chsc_scsc page!");
+		return false;
+	}
+
+	if (!chsc(chsc_scsc, CHSC_SCSC, CHSC_SCSC_LEN))
+		return false;
+
+	for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++) {
+		if (css_test_general_feature(i)) {
+			n = snprintf(p, sizeof(buffer), "%d,", i);
+			p += n;
+		}
+	}
+	report_info("General features: %s", buffer);
+
+	for (i = 0, p = buffer; i < CSS_CHSC_FEAT_BITLEN; i++) {
+		if (css_test_chsc_feature(i)) {
+			n = snprintf(p, sizeof(buffer), "%d,", i);
+			p += n;
+		}
+	}
+	report_info("CHSC features: %s", buffer);
+
+	return true;
+}
 
 /*
  * css_enumerate:
diff --git a/s390x/css.c b/s390x/css.c
index 1a61a5c..12036b3 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -14,6 +14,7 @@
 #include <string.h>
 #include <interrupt.h>
 #include <asm/arch_def.h>
+#include <alloc_page.h>
 
 #include <malloc_io.h>
 #include <css.h>
@@ -140,10 +141,17 @@ error_senseid:
 	unregister_io_int_func(css_irq_io);
 }
 
+static void css_init(void)
+{
+	report(get_chsc_scsc(), "Store Channel Characteristics");
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
 } tests[] = {
+	/* The css_init test is needed to initialize the CSS Characteristics */
+	{ "initialize CSS (chsc)", css_init },
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
-- 
2.17.1

