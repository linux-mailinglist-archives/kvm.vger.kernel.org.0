Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D82354E11
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244353AbhDFHlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235408AbhDFHlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:12 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367X0oQ147229
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=sRc4CUmq3qBPPb7nJvUtuxHqfxFAdzHMTDhyhe8zaOM=;
 b=VxD6ckBJAgHyLgeBlmoau3b69fhPc3XEEjZwQjhUeZ2VW4Gk+NJAy8/GTIE1ynG7WcIj
 FVbDpFZAGL1uu0w/b5vBaLTI1qTP1HP/f5n6lynlGx2iamshZjrduxjWfUH7C14Dx3jZ
 QowBYcBdheqR6G+rre4h3rylB3nCGtI3isuOzqKG5LX6Fl1Pr7xcXDyt6H0lAaNme3g7
 biVXfNTvY7wJW7NmQi8/vuNvVKF+vumwn1aboBm/sA3oGlUCIntT8IaE2jrN/CI7C48I
 lhnMX4cZgTymZLxJMapbT3jNi8yhGmDdpCYWaCjNj7Sa+y9hDdyLgsLy3ut1iI6o4yfu Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5easpw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:05 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367X961001093
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:05 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5easpux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:04 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367XF8f024813;
        Tue, 6 Apr 2021 07:41:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 37q2nr90q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367exOK31785404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 724B24C050;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 313954C04E;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 13/16] s390x: css: checking for CSS extensions
Date:   Tue,  6 Apr 2021 09:40:50 +0200
Message-Id: <1617694853-6881-14-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _DfYdWem8jWDmdBkSCZM1k4e_shhBUqZ
X-Proofpoint-ORIG-GUID: b16zBZ6nwB_lPKaAMeq8Sc3pYZmx7dTn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We verify that these extensions are not install before running simple
tests.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h |  2 ++
 s390x/css.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index d824e34..08b2974 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -338,7 +338,9 @@ struct chsc_scsc {
 	uint8_t reserved[9];
 	struct chsc_header res;
 	uint32_t res_fmt;
+#define CSSC_ORB_EXTENSIONS		0
 #define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
+#define CSSC_FC_EXTENSIONS		88
 	uint64_t general_char[255];
 	uint64_t chsc_char[254];
 };
diff --git a/s390x/css.c b/s390x/css.c
index 26f5da6..f8c6688 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -229,6 +229,35 @@ static void ssch_orb_ctrl(void)
 	}
 }
 
+static void ssch_orb_extension(void)
+{
+	if (!css_test_general_feature(CSSC_ORB_EXTENSIONS)) {
+		report_skip("ORB extensions not installed");
+		return;
+	}
+	/* Place holder for checking ORB extensions */
+	report_info("ORB extensions installed but not tested");
+}
+
+static void ssch_orb_fcx(void)
+{
+	uint32_t tmp = orb->ctrl;
+
+	if (!css_test_general_feature(CSSC_FC_EXTENSIONS)) {
+		report_skip("Fibre-channel extensions not installed");
+		return;
+	}
+
+	report_prefix_push("Channel-Program Type Control");
+	orb->ctrl |= ORB_CTRL_CPTC;
+	expect_pgm_int();
+	ssch(test_device_sid, orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+
+	orb->ctrl = tmp;
+}
+
 static struct tests ssh_tests[] = {
 	{ "privilege", ssch_privilege },
 	{ "orb cpa zero", ssch_orb_cpa_zero },
@@ -238,6 +267,8 @@ static struct tests ssh_tests[] = {
 	{ "CCW in DMA31", ssch_ccw_dma31 },
 	{ "ORB MIDAW unsupported", ssch_orb_midaw },
 	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
+	{ "ORB extensions", ssch_orb_extension},
+	{ "FC extensions", ssch_orb_fcx},
 	{ NULL, NULL }
 };
 
-- 
2.17.1

