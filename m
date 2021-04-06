Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C85354E09
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244337AbhDFHlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53456 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235602AbhDFHlK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:10 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367WwOA119631
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=FGDjWN/APoDnty6WtU4PBFFFAnSYz0v2lTF67eNDGEg=;
 b=CRqrwH/dK8PTpcE/1FibMDcgiV479e0YVb2qB04iSzttaAFB+go/WicOKFUHzTQ2Vv9G
 sOMMG3dbi8KY6orIuw4Zqs6GdfOXZS7kRKPdkrdELXzjRh/w8aiUS7KjRJphAE+FejAf
 vDrMWUTu7ToOLzuSg3f441ndscRdSHDQoc/4akutrgeAgR6fqAsOW3a+bT7itL3Qbxde
 ejUCz2u283zd1RDXXNSvbpHgUmAuXPvbdPRFN9n2feykUpm95bvByVIjCE++UASwb0W4
 KTU3ECxI3YKgSOPFWFYKYsHmQRkFsW0ldV1R+xyCzT0Oqza30QwdmBxgdNtdvNZETcFq Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5x8kp1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:02 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367XE0C121862
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5x8kp13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367WvnC016052;
        Tue, 6 Apr 2021 07:41:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 37q2n2sx81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367evRr40108414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F0304C052;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33E314C059;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 07/16] s390x: css: testing ssch errors
Date:   Tue,  6 Apr 2021 09:40:44 +0200
Message-Id: <1617694853-6881-8-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k_CEZxC8iBKTUWHbRaUsYCI3gZ1pF616
X-Proofpoint-GUID: aMUkPbCwBC2pM8yLsgJWkjgj9DFCjb96
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 mlxlogscore=919
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Setup testing environment and check privilege.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index f4b7af1..da21ccc 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -15,17 +15,24 @@
 #include <interrupt.h>
 #include <asm/arch_def.h>
 #include <alloc_page.h>
+#include <alloc.h>
 
 #include <malloc_io.h>
 #include <css.h>
 #include <asm/barrier.h>
 
+struct tests {
+	const char *name;
+	void (*func)(void);
+};
+
 #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
 static unsigned long cu_type = DEFAULT_CU_TYPE;
 
 static int test_device_sid;
 static struct senseid *senseid;
 struct ccw1 *ccw;
+struct orb *orb;
 
 static void test_enumerate(void)
 {
@@ -46,6 +53,65 @@ static void test_enable(void)
 	report(cc == 0, "Enable subchannel %08x", test_device_sid);
 }
 
+/* orb_alloc
+ *
+ * We allocate and initialize for all tests:
+ * - the ORB on a global pointer without memory restrictions.
+ * - A CCW and the senseid structures in I/O memory.
+ * Every subtest is responsible to have them modified for their purpose.
+ */
+static void orb_alloc(void)
+{
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+
+	orb = malloc(sizeof(*orb));
+	assert(orb);
+
+	orb->intparm = test_device_sid;
+	orb->ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT;
+	orb->cpa = (long)ccw;
+}
+
+static void orb_free(void)
+{
+	free_io_mem(senseid, sizeof(*senseid));
+	free_io_mem(ccw, sizeof(struct ccw1));
+	free(orb);
+}
+
+static void ssch_privilege(void)
+{
+	enter_pstate();
+	expect_pgm_int();
+	ssch(test_device_sid, orb);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+}
+
+static struct tests ssh_tests[] = {
+	{ "privilege", ssch_privilege },
+	{ NULL, NULL }
+};
+
+static void test_ssch(void)
+{
+	int i;
+
+	orb_alloc();
+	assert(css_enable(test_device_sid, 0) == 0);
+
+	for (i = 0; ssh_tests[i].name; i++) {
+		report_prefix_push(ssh_tests[i].name);
+		ssh_tests[i].func();
+		report_prefix_pop();
+	}
+
+	orb_free();
+}
+
 /*
  * test_sense
  * Pre-requisites:
@@ -311,12 +377,10 @@ static void test_schm_fmt1(void)
 	free_io_mem(mb1, sizeof(struct measurement_block_format1));
 }
 
-static struct {
-	const char *name;
-	void (*func)(void);
-} tests[] = {
+static struct tests tests[] = {
 	/* The css_init test is needed to initialize the CSS Characteristics */
 	{ "enable (msch)", test_enable },
+	{ "start subchannel", test_ssch },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
-- 
2.17.1

