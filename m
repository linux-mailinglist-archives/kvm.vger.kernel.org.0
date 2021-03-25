Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526C7348D33
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhCYJj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62880 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhCYJjR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:17 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9XBSL039240
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=YToj26Tr9Ph1F33MdkZzPV8n691lmmoU3nN7BSeoZk4=;
 b=Xqr+hEGJ92wRqzDcBEFbGX4UnwvzEpnKXtvYwk++frczRfkiLSMO74vIWWaoRUFFoo8H
 GqwA+65sjIIy2e93GLrwEpJ3Ox5m1eIZRQqKjepA3lUVETjNQgzp41klz3T+zoR2cfYr
 R4yJnvNccw94R+G1KO0seX6nBDxH129hNXn1keHwrS3V+hrSmkC8fDbdGKGLb2nHa1r4
 6EL7O7tOO5FkIFUKGEBYssP7ZF9BcoMNVDqvm1hyvCGoyBEKbnIVPtGVb1TPZKiNksXA
 bMTbMWxrVrbv8VN0xuIDZBhQYs6lfdgaUbFf/QIaY850KPM18qRrEmwSp6B34eG+vM9i 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gka6q7v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:16 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9Xf2n041411
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:16 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gka6q7ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9R52A007111;
        Thu, 25 Mar 2021 09:39:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 37d99rd6y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9dBfP18481446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9830811C054;
        Thu, 25 Mar 2021 09:39:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D83A11C050;
        Thu, 25 Mar 2021 09:39:11 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 8/8] s390x: css: testing clear subchannel
Date:   Thu, 25 Mar 2021 10:39:07 +0100
Message-Id: <1616665147-32084-9-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=907
 lowpriorityscore=0 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking return values for CSCH for various configurations.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index ffc067e..d5b7b00 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -56,6 +56,63 @@ static void test_enable(void)
 	report(cc == 0, "Enable subchannel %08x", test_device_sid);
 }
 
+static void test_csch(void)
+{
+	struct orb orb = {
+		.intparm = test_device_sid,
+		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
+	};
+	struct ccw1 *ccw;
+
+	NODEV_SKIP(test_device_sid);
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+	orb.cpa = (uint64_t)ccw;
+
+	/* 1- Basic check for CSCH */
+	report_prefix_push("CSCH on a quiet subchannel");
+	assert(css_enable(test_device_sid, 0) == 0);
+	report(csch(test_device_sid) == 0, "subchannel clear");
+	report_prefix_pop();
+
+	/* now we check the flags */
+	report_prefix_push("IRQ flags");
+	assert(tsch(test_device_sid, &irb) == 0);
+	report(check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED) == 0, "expected");
+	report_prefix_pop();
+
+	/* 2- We want to check if the IRQ flags of SSCH are erased by clear */
+	report_prefix_push("CSCH on SSCH status pending subchannel");
+	assert(ssch(test_device_sid, &orb) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED |
+			    SCSW_SC_SECONDARY | SCSW_SC_PRIMARY);
+	report_prefix_pop();
+
+	/* 3- Checking CSCH after HSCH */
+	report_prefix_push("CSCH on a halted subchannel");
+	assert(hsch(test_device_sid) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED);
+	report_prefix_pop();
+
+	/* 4- Checking CSCH after CSCH */
+	report_prefix_push("CSCH on a cleared subchannel");
+	assert(csch(test_device_sid) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED);
+	report_prefix_pop();
+
+	free_io_mem(senseid, sizeof(*senseid));
+	free_io_mem(ccw, sizeof(*ccw));
+}
+
 static void test_hsch(void)
 {
 	struct orb orb = {
@@ -496,6 +553,7 @@ static struct {
 	{ "enable (msch)", test_enable },
 	{ "start subchannel", test_ssch },
 	{ "halt subchannel", test_hsch },
+	{ "clear subchannel", test_csch },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
-- 
2.17.1

