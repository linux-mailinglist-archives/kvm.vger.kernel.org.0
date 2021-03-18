Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187F23406D8
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCRN1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:27:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230305AbhCRN0h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:26:37 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ID398g158279
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=5aYjvPrPRtE5Jz4ifeBji0Grqkm1aFAX39SteY+rSe0=;
 b=I/8cr9BvKKbq8AGAlxGtJntaV5UMUTJjGd2DJWyvfj9TMq8BPQdIaB1wGWKZ9ZuqMd+e
 T/PiuPsieCQAhJxvNHJT6CeUqEWktpmbO3ffWwSjPP49lFpiAmPDNkzj+t9tTsB+9pUj
 SEeSGYkkZLLb1lON9D3On4TM9Zyd70oUXwQ/HAVrLQhNOMbyBfNP/drsV7G7k4Ez/VQy
 7ZIr20smeTsK2rM+dxiT7CZ8d+sweWUZp2Iu9bEjDcNQhm4jJ4TW0SEelR5yyDSuIOYg
 Qpmy0Un1SkYJm8NkfXhWemnH4F6Q/bqJkPCJVWqGF6c9Q7tWBZPPWNDeCf7jHDRsE9si 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37byr3dkjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:36 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ID3bk8160435
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:36 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37byr3dkhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 09:26:36 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IDNWeE030235;
        Thu, 18 Mar 2021 13:26:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 378mnhahsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 13:26:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IDQVGw30802268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:26:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BCE94C058;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17C394C059;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 4/6] s390x: lib: css: add expectations to wait for interrupt
Date:   Thu, 18 Mar 2021 14:26:26 +0100
Message-Id: <1616073988-10381-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=801
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When waiting for an interrupt we may need to check the cause of
the interrupt depending on the test case.

Let's provide the tests the possibility to check if the last valid
IRQ received is for the expected instruction.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  2 +-
 lib/s390x/css_lib.c | 11 ++++++++++-
 s390x/css.c         |  4 ++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 65fc335..add3b4e 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -316,7 +316,7 @@ void css_irq_io(void);
 int css_residual_count(unsigned int schid);
 
 void enable_io_isc(uint8_t isc);
-int wait_and_check_io_completion(int schid);
+int wait_and_check_io_completion(int schid, uint32_t pending);
 
 /*
  * CHSC definitions
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 211c73c..4cdd7ad 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -537,7 +537,7 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
  * completion.
  * Only report failures.
  */
-int wait_and_check_io_completion(int schid)
+int wait_and_check_io_completion(int schid, uint32_t pending)
 {
 	int ret = 0;
 	struct irq_entry *irq = NULL;
@@ -569,6 +569,15 @@ int wait_and_check_io_completion(int schid)
 		goto end;
 	}
 
+	if (pending) {
+		if (!(pending & irq->irb.scsw.ctrl)) {
+			report_info("%08x : %s", schid, dump_scsw_flags(irq->irb.scsw.ctrl));
+			report_info("expect   : %s", dump_scsw_flags(pending));
+			ret = -1;
+			goto end;
+		}
+	}
+
 	/* clear and halt pending are valid even without secondary or primary status */
 	if (irq->irb.scsw.ctrl & (SCSW_FC_CLEAR | SCSW_FC_HALT)) {
 		ret = 0;
diff --git a/s390x/css.c b/s390x/css.c
index c340c53..a6a9773 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -94,7 +94,7 @@ static void test_sense(void)
 		goto error;
 	}
 
-	if (wait_and_check_io_completion(test_device_sid) < 0)
+	if (wait_and_check_io_completion(test_device_sid, SCSW_FC_START) < 0)
 		goto error;
 
 	/* Test transfer completion */
@@ -137,7 +137,7 @@ static void sense_id(void)
 {
 	assert(!start_ccw1_chain(test_device_sid, ccw));
 
-	assert(wait_and_check_io_completion(test_device_sid) >= 0);
+	assert(wait_and_check_io_completion(test_device_sid, SCSW_FC_START) >= 0);
 }
 
 static void css_init(void)
-- 
2.17.1

