Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B589348D2C
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCYJjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230081AbhCYJjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:16 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9YAiv025490
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=GAxdfBBTTceM+FvbXUdMfoaRMOi218R96kJZ81Hknug=;
 b=Jy8meh/oZbJWYR6+bBdLe2/svRJ1uXF77bx31hT9Gq3EmQiPozZFJOu4m1lsROIgBKUi
 PorwzbZgd7zwh5s8vY0GtdUFbbhLZ7RUOy0Bv3OJxDm5CW7tOB7Uhs6mHDHjHmkJeaHA
 LWUMEjkUbF+BUeD+kn6AnHFfC/6A2FCU0LxhYE3JjlbYfqnWm+ZmJ0szB5XzdMZfBX6v
 zATwEx909A7OFPTv9WH1JkK3Xvl33KD2+QQ2aTx40GlUSmAAFDpfteEj+ewOGucFfQg2
 7HmajatpUmVkpbuKVupYUwkForVYbRNefyUxffbdicIJdE/Gg7N7ilDkP4rpBGFU3kLz CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gpjv2gm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9bciI039094
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gpjv2gke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:15 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9RO24018323;
        Thu, 25 Mar 2021 09:39:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 37d9d8tqqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9dAEk62914974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D70B11C050;
        Thu, 25 Mar 2021 09:39:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42E4511C058;
        Thu, 25 Mar 2021 09:39:10 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/8] s390x: lib: css: add SCSW ctrl expectations to check I/O completion
Date:   Thu, 25 Mar 2021 10:39:04 +0100
Message-Id: <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When checking for an I/O completion may need to check the cause of
the interrupt depending on the test case.

Let's provide the tests the possibility to check if the last
valid IRQ received is for the function expected after executing
an instruction or sequence of instructions and if all ctrl flags
of the SCSW are set as expected.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  4 ++--
 lib/s390x/css_lib.c | 21 ++++++++++++++++-----
 s390x/css.c         |  4 ++--
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 5d1e1f0..1603781 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -316,8 +316,8 @@ void css_irq_io(void);
 int css_residual_count(unsigned int schid);
 
 void enable_io_isc(uint8_t isc);
-int wait_and_check_io_completion(int schid);
-int check_io_completion(int schid);
+int wait_and_check_io_completion(int schid, uint32_t ctrl);
+int check_io_completion(int schid, uint32_t ctrl);
 
 /*
  * CHSC definitions
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 1e5c409..55e70e6 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -488,21 +488,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
 
 /* wait_and_check_io_completion:
  * @schid: the subchannel ID
+ * @ctrl : expected SCSW control flags
  */
-int wait_and_check_io_completion(int schid)
+int wait_and_check_io_completion(int schid, uint32_t ctrl)
 {
 	wait_for_interrupt(PSW_MASK_IO);
-	return check_io_completion(schid);
+	return check_io_completion(schid, ctrl);
 }
 
 /* check_io_completion:
  * @schid: the subchannel ID
+ * @ctrl : expected SCSW control flags
  *
- * Makes the most common check to validate a successful I/O
- * completion.
+ * If the ctrl parameter is not null check the IRB SCSW ctrl
+ * against the ctrl parameter.
+ * Otherwise, makes the most common check to validate a successful
+ * I/O completion.
  * Only report failures.
  */
-int check_io_completion(int schid)
+int check_io_completion(int schid, uint32_t ctrl)
 {
 	int ret = 0;
 
@@ -515,6 +519,13 @@ int check_io_completion(int schid)
 		goto end;
 	}
 
+	if (ctrl && (ctrl ^ irb.scsw.ctrl)) {
+		report_info("%08x : %s", schid, dump_scsw_flags(irb.scsw.ctrl));
+		report_info("expected : %s", dump_scsw_flags(ctrl));
+		ret = -1;
+		goto end;
+	}
+
 	/* Verify that device status is valid */
 	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
 		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
diff --git a/s390x/css.c b/s390x/css.c
index 16723f6..57dc340 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -95,7 +95,7 @@ static void test_sense(void)
 		goto error;
 	}
 
-	if (wait_and_check_io_completion(test_device_sid) < 0)
+	if (wait_and_check_io_completion(test_device_sid, 0) < 0)
 		goto error;
 
 	/* Test transfer completion */
@@ -138,7 +138,7 @@ static void sense_id(void)
 {
 	assert(!start_ccw1_chain(test_device_sid, ccw));
 
-	assert(wait_and_check_io_completion(test_device_sid) >= 0);
+	assert(wait_and_check_io_completion(test_device_sid, 0) >= 0);
 }
 
 static void css_init(void)
-- 
2.17.1

