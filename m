Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2472354E07
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244253AbhDFHlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5234 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235460AbhDFHlJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:09 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367X5tj109940
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=A31o2qkHum34StJxpHRf4hap1h7uEdlTdnwok4STApk=;
 b=bqAQ+pJFqjla2hp+jIcKSupVioAkPcoorrg1O+NGtMgNId23zAFgS8dMXM5rm75fuzTw
 H5AgxcYynRmlH4mXbD1gj/RKwzHyONG2+x/DrIx1Rc9I9c27VrAYR5PYGlc5dZyX+nCs
 ZXbqwHyQ+99g5P00QjarwuqwtU7IIjwNWsFJzRdzRE9HDEjwsc7ZJjCOSFZ+dBs2oeSt
 LTCBQijbjye+fcQ8xPxsjHnz9x03xDSeBdyO2qeMS+riZad6jiinjAvdXNFdCbx+OcHl
 wIXhFqMzVvs6aAPnbtdDaw0+wzaM4XmNNSwMWROYdwMuSPM+J08NSZD5/jDCL27jEAC6 ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5kxjr2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:01 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367XJVl110830
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5kxjr2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367Wqkt026270;
        Tue, 6 Apr 2021 07:40:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37q2y9hwt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:40:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367euJo47513880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6689F4C059;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1997B4C044;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 04/16] s390x: lib: css: separate wait for IRQ and check I/O completion
Date:   Tue,  6 Apr 2021 09:40:41 +0200
Message-Id: <1617694853-6881-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0SO1GbDwzuqksqHnFKa6guHt5U5uDwKi
X-Proofpoint-GUID: kQWgSocgsQzakn3_AwWutIar-DjHFl54
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will may want to check the result of an I/O without waiting
for an interrupt.
For example because we do not handle interrupt.
Let's separate waiting for interrupt and the I/O completion check.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c | 34 +++++++++++++++++++---------------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 0058355..5d1e1f0 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -317,6 +317,7 @@ int css_residual_count(unsigned int schid);
 
 void enable_io_isc(uint8_t isc);
 int wait_and_check_io_completion(int schid);
+int check_io_completion(int schid);
 
 /*
  * CHSC definitions
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 9711b0b..e81076a 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -483,55 +483,59 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
 }
 
 /* wait_and_check_io_completion:
+ * @schid: the subchannel ID
+ */
+int wait_and_check_io_completion(int schid)
+{
+	wait_for_interrupt(PSW_MASK_IO);
+
+	if (lowcore_ptr->io_int_param != schid) {
+		report(0, "interrupt parameter: expected %08x got %08x", schid, lowcore_ptr->io_int_param);
+		return -1;
+	}
+
+	return check_io_completion(schid);
+}
+
+/* check_io_completion:
  * @schid: the subchannel ID
  *
  * Makes the most common check to validate a successful I/O
  * completion.
  * Only report failures.
  */
-int wait_and_check_io_completion(int schid)
+int check_io_completion(int schid)
 {
-	int ret = 0;
-
-	wait_for_interrupt(PSW_MASK_IO);
+	int ret = -1;
 
 	report_prefix_push("check I/O completion");
 
-	if (lowcore_ptr->io_int_param != schid) {
-		report(0, "interrupt parameter: expected %08x got %08x",
-		       schid, lowcore_ptr->io_int_param);
-		ret = -1;
-		goto end;
-	}
-
 	/* Verify that device status is valid */
 	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
 		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
 		       irb.scsw.ctrl);
-		ret = -1;
 		goto end;
 	}
 
 	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
 		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
 		       irb.scsw.ctrl);
-		ret = -1;
 		goto end;
 	}
 
 	if (!(irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
 		report(0, "No device end or sch end. Dev. status: %02x",
 		       irb.scsw.dev_stat);
-		ret = -1;
 		goto end;
 	}
 
 	if (irb.scsw.sch_stat & ~SCSW_SCHS_IL) {
 		report_info("Unexpected Subch. status %02x", irb.scsw.sch_stat);
-		ret = -1;
 		goto end;
 	}
 
+	ret = 0;
+
 end:
 	report_prefix_pop();
 	return ret;
-- 
2.17.1

