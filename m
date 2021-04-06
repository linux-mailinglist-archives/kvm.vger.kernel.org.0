Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB5D354E08
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244334AbhDFHlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235517AbhDFHlJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:09 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367X288151535
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=F/nj73HjbAAQP2hHV+V3UI3ZsmlODRhE3m+MXZPHefI=;
 b=lgPW7UHM/LI8doL2nBSXlZ55MBnK5cLXjVbFGp9LO/SuvuCqdAkSTfz4bqmY5Lr8Ys48
 rOFPzSQsHTXfWTThG9bjZ0cH6awHrhtEu7Ws3/0AT31V4LJLXLIwrzue6a0GT3dmegBv
 odtcLSvSWzr6PoHuyTSXzErhEO4Zg1FxEnmLC452Us2fzVl+2J+wv0NQVY5dFq/oJ2mQ
 aKfmXNzW9vVVyiv/UeqN4E9YwKLuAhmUCKCe9+HblbZkksTmzdRIraOMM9oFV4KaZ52g
 mpvWDsL9MUaxqi4pcKdXcs2/F7ef7OW6BTbbpAjPjeyTiDkidQrQ6wekcclymVJwM2Ra XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q595kg9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:02 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367YU2O158779
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:02 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q595kg8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:02 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367XF8e024813;
        Tue, 6 Apr 2021 07:40:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 37q2nr90q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:40:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367euFj46530926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C148D4C04A;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7450C4C058;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 05/16] s390x: lib: css: add SCSW ctrl expectations to check I/O completion
Date:   Tue,  6 Apr 2021 09:40:42 +0200
Message-Id: <1617694853-6881-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8TX5Sf_HoOiWwCxFZ_2ovBs1tywS7hdV
X-Proofpoint-ORIG-GUID: 7mT_A6jpsoB0TfxqIquVj3T239y-b2ys
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 suspectscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we check for the completion of an I/O, we may need to check
the cause of the interrupt depending on the test case.

Let's make it possible for the tests to check whether the last valid
IRB received indicates the expected functions after executing
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
index e81076a..97bf032 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -484,8 +484,9 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
 
 /* wait_and_check_io_completion:
  * @schid: the subchannel ID
+ * @ctrl : expected SCSW control flags
  */
-int wait_and_check_io_completion(int schid)
+int wait_and_check_io_completion(int schid, uint32_t ctrl)
 {
 	wait_for_interrupt(PSW_MASK_IO);
 
@@ -494,22 +495,32 @@ int wait_and_check_io_completion(int schid)
 		return -1;
 	}
 
-	return check_io_completion(schid);
+	return check_io_completion(schid, ctrl);
 }
 
 /* check_io_completion:
  * @schid: the subchannel ID
+ * @ctrl : expected SCSW control flags
  *
- * Makes the most common check to validate a successful I/O
- * completion.
+ * Perform some standard checks to validate a successful I/O completion.
+ * If the ctrl parameter is not zero, additionally verify that the
+ * specified bits are indicated in the IRB SCSW ctrl flags.
  * Only report failures.
  */
-int check_io_completion(int schid)
+int check_io_completion(int schid, uint32_t ctrl)
 {
 	int ret = -1;
 
 	report_prefix_push("check I/O completion");
 
+	if (ctrl) {
+		if (ctrl == irb.scsw.ctrl)
+			ret = 0;
+		else
+			report_info("extected %s != %s", dump_scsw_flags(irb.scsw.ctrl), dump_scsw_flags(ctrl));
+		goto end;
+	}
+
 	/* Verify that device status is valid */
 	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
 		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
diff --git a/s390x/css.c b/s390x/css.c
index 17a6e1d..f4b7af1 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -84,7 +84,7 @@ static void test_sense(void)
 		goto error;
 	}
 
-	if (wait_and_check_io_completion(test_device_sid) < 0)
+	if (wait_and_check_io_completion(test_device_sid, 0) < 0)
 		goto error;
 
 	/* Test transfer completion */
@@ -127,7 +127,7 @@ static void sense_id(void)
 {
 	assert(!start_ccw1_chain(test_device_sid, ccw));
 
-	assert(wait_and_check_io_completion(test_device_sid) >= 0);
+	assert(wait_and_check_io_completion(test_device_sid, 0) >= 0);
 }
 
 static void css_init(void)
-- 
2.17.1

