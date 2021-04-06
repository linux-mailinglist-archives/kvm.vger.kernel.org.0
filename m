Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584FB354E15
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244408AbhDFHlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235371AbhDFHlP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:15 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367YMKL109519
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=nHCdLQSjVfiBBy3gLhZEK4tFGLwM0PebniyjDJlU2os=;
 b=tJwOzKJNjxCW48tfAc3sLxN+5FA0ROqQjM0x2MOfOYGwFG92sa0SX+fiQTDqUkPqg9Qt
 fVr7PNcu7/R/0zKwd+BdKIwrS+zS4sE7aMg1vEULzwIwl7kp9Uj5P59bdJ+1nas+hfmy
 Y44lDhKHCGr/WmuEWQ6qnbGvTSi0USORXijkqXBbU/l9CHBYxst2LIIILsfGQj/rH8Jr
 i42yi6dgGJfqAa8aFh4zbgSPBWe78j3586S5/vF8Q5q6Xwez/JadIGV7zpN0UPMOAAhU
 pSUScj/dqkCDAVi+YaMzK76dFxtMrEGKAqgbBNI3HzXyF4Qgtvvwae/DywMdArJV+jov PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q60521ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:07 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367YUd8110188
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q60521tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367Wngb026263;
        Tue, 6 Apr 2021 07:41:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 37q2y9hwtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367ex1p52625738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:41:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7865C4C040;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35E9D4C052;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 10/16] s390x: css: ssch checking addressing errors
Date:   Tue,  6 Apr 2021 09:40:47 +0200
Message-Id: <1617694853-6881-11-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EiOc456LpBeH7tgDJV73ZvcwQAsukCvF
X-Proofpoint-GUID: 9fppu50rsJGLGcBJrHHOs1C_yTtPslmj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=898
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We check ORB CPA and CCW address for being inside limits
and existing.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  8 +++--
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index 47452ba..f8f91cf 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -16,6 +16,7 @@
 #include <asm/arch_def.h>
 #include <alloc_page.h>
 #include <alloc.h>
+#include <sclp.h>
 
 #include <malloc_io.h>
 #include <css.h>
@@ -34,6 +35,12 @@ static struct senseid *senseid;
 struct ccw1 *ccw;
 struct orb *orb;
 
+phys_addr_t ram_size;
+#define ADDR_1G		0x40000000
+#define ADDR_1_5G	0x60000000
+#define ADDR_3G		0xc0000000
+
+
 static void test_enumerate(void)
 {
 	test_device_sid = css_enumerate();
@@ -123,10 +130,80 @@ static void ssch_orb_alignment(void)
 	free_pages(p - 2);
 }
 
+static void ssch_data_access(void)
+{
+	uint32_t tmp;
+
+	if (ram_size > ADDR_1G) {
+		report_skip("Test with more than 1G available memory");
+		return;
+	}
+
+	tmp = ccw->data_address;
+	ccw->data_address = ADDR_1_5G;
+
+	ssch(test_device_sid, orb);
+	tsch(test_device_sid, &irb);
+	report(check_io_errors(test_device_sid, 0, SCSW_SCHS_PRG_CHK), "expecting Program check");
+
+	ccw->data_address = tmp;
+}
+
+static void ssch_ccw_access(void)
+{
+	uint32_t tmp;
+
+	if (ram_size > ADDR_1G) {
+		report_skip("Test with more than 1G available memory");
+		return;
+	}
+
+	tmp = orb->cpa;
+	orb->cpa = ADDR_1_5G;
+
+	ssch(test_device_sid, orb);
+	tsch(test_device_sid, &irb);
+	report(check_io_errors(test_device_sid, 0, SCSW_SCHS_PRG_CHK), "expecting Program check");
+
+	orb->cpa = tmp;
+}
+
+static void ssch_ccw_dma31(void)
+{
+	uint32_t tmp;
+	struct ccw1 *ccw_high;
+
+	if (ram_size < ADDR_3G) {
+		report_skip("Test with less than 3G available memory");
+		return;
+	}
+
+	ccw_high = alloc_pages_flags(0, AREA_NORMAL);
+	assert(ccw_high);
+	ccw_high->code = CCW_CMD_SENSE_ID;
+	ccw_high->flags = CCW_F_SLI;
+	ccw_high->count = sizeof(*senseid);
+	ccw_high->data_address = (long)senseid;
+
+	tmp = orb->cpa;
+	report_info("ccw_high: %p", ccw_high);
+	orb->cpa = (long)ccw_high;
+
+	expect_pgm_int();
+	ssch(test_device_sid, orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+	orb->cpa = tmp;
+	free_pages(ccw_high);
+}
+
 static struct tests ssh_tests[] = {
 	{ "privilege", ssch_privilege },
 	{ "orb cpa zero", ssch_orb_cpa_zero },
 	{ "orb alignment", ssch_orb_alignment },
+	{ "data access", ssch_data_access },
+	{ "CCW access", ssch_ccw_access },
+	{ "CCW in DMA31", ssch_ccw_dma31 },
 	{ NULL, NULL }
 };
 
@@ -136,6 +213,7 @@ static void test_ssch(void)
 
 	orb_alloc();
 	assert(css_enable(test_device_sid, 0) == 0);
+	ram_size = get_ram_size();
 
 	for (i = 0; ssh_tests[i].name; i++) {
 		report_prefix_push(ssh_tests[i].name);
@@ -144,6 +222,7 @@ static void test_ssch(void)
 	}
 
 	orb_free();
+	css_enable(test_device_sid, 0);
 }
 
 /*
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9f81a60..45569dc 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -86,9 +86,13 @@ extra_params = -m 1G
 file = sclp.elf
 extra_params = -m 3G
 
-[css]
+[css-1g]
 file = css.elf
-extra_params = -device virtio-net-ccw
+extra_params = -m 1G -device virtio-net-ccw
+
+[css-3g]
+file = css.elf
+extra_params = -m 3G -device virtio-net-ccw
 
 [skrf]
 file = skrf.elf
-- 
2.17.1

