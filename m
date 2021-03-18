Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E9A3406DA
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhCRN1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:27:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29518 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230318AbhCRN0h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:26:37 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ID3j1V082602
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=tWnXqxqaoqMQz43RYzpZH3QHV9Cc1g7x7rRtodZqNVg=;
 b=bRgsLQ08Sy4+R4sYN5ZEju3+FLG52QO0SFqfxQe2a/0dZyVYTM+kij0Frms+/D+Ftl7H
 xf/l9rjV8AyvFdX+3agBNv6Uw4CEcxPD57fltLE6eBVQcin4jCPdvXliySEudihP8pk5
 38X6hy9ItXvzo+m2vlIYcKF/A+NihReQ2MN+UBoyCwZqK6y/sDLwh80YOax9wQwbOgAd
 Dj7j6USqDebEqBX5WMt9fG/bk10bZtPExz8NZjhiz/zlXU8+pa7psK0TElADjRmBtt3j
 4KxI03isEvS4kWgzc0zOUwjjX8qPVMw1s5uAjlyCO9j0kjIapfU+dbPftqA6iZpB00mC bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c30214vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:37 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ID4Ndl085803
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:37 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c30214v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 09:26:37 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IDN3Q4024645;
        Thu, 18 Mar 2021 13:26:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 378n18ahm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 13:26:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IDQV1h27918644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:26:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B006C4C04E;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D9C4C044;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 5/6] s390x: css: testing ssch error response
Date:   Thu, 18 Mar 2021 14:26:27 +0100
Message-Id: <1616073988-10381-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking error response on various eroneous SSCH instructions:
- ORB alignment
- ORB above 2G
- CCW above 2G
- bad ORB flags

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index a6a9773..1c891f8 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -51,6 +51,107 @@ static void test_enable(void)
 	report(cc == 0, "Enable subchannel %08x", test_device_sid);
 }
 
+static void test_ssch(void)
+{
+	struct orb orb = {
+		.intparm = test_device_sid,
+		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
+	};
+	int i;
+	phys_addr_t base, top;
+
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(register_io_int_func(css_irq_io) == 0);
+
+	/* ORB address should be aligned on 32 bits */
+	report_prefix_push("ORB alignment");
+	expect_pgm_int();
+	ssch(test_device_sid, (void *)0x110002);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	/* ORB address should be lower than 2G */
+	report_prefix_push("ORB Address above 2G");
+	expect_pgm_int();
+	ssch(test_device_sid, (void *)0x80000000);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	phys_alloc_get_unused(&base, &top);
+	report_info("base %08lx, top %08lx", base, top);
+
+	/* ORB address should be available we check 1G*/
+	report_prefix_push("ORB Address must be available");
+	if (top < 0x40000000) {
+		expect_pgm_int();
+		ssch(test_device_sid, (void *)0x40000000);
+		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	} else {
+		report_skip("guest started with more than 1G memory");
+	}
+	report_prefix_pop();
+
+	report_prefix_push("CCW address above 2G");
+	orb.cpa = 0x80000000;
+	expect_pgm_int();
+	ssch(test_device_sid, &orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+	orb.cpa = (uint64_t)ccw_alloc(CCW_CMD_SENSE_ID, senseid,
+				      sizeof(*senseid), CCW_F_SLI);
+	assert(orb.cpa);
+
+	report_prefix_push("Disabled subchannel");
+	assert(css_disable(test_device_sid) == 0);
+	report(ssch(test_device_sid, &orb) == 3, "CC = 3");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	report_prefix_pop();
+
+	/*
+	 * Check sending a second SSCH before clearing the status with TSCH
+	 * the subchannel is left disabled.
+	 */
+	report_prefix_push("SSCH on channel with status pending");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(ssch(test_device_sid, &orb) == 0);
+	report(ssch(test_device_sid, &orb) == 1, "CC = 1");
+	/* now we clear the status */
+	assert(wait_and_check_io_completion(test_device_sid, SCSW_FC_START) == 0);
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	report_prefix_push("ORB MIDAW unsupported");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	orb.ctrl |= ORB_CTRL_MIDAW;
+	expect_pgm_int();
+	ssch(test_device_sid, &orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+	orb.ctrl = 0;
+
+	for (i = 0; i < 5; i++) {
+		char buffer[30];
+
+		orb.ctrl = (0x02 << i);
+		snprintf(buffer, 30, "ORB reserved ctrl flags %02x", orb.ctrl);
+		report_prefix_push(buffer);
+		expect_pgm_int();
+		ssch(test_device_sid, &orb);
+		check_pgm_int_code(PGM_INT_CODE_OPERAND);
+		report_prefix_pop();
+	}
+
+	report_prefix_push("ORB wrong ctrl flags");
+	orb.ctrl |= 0x040000;
+	expect_pgm_int();
+	ssch(test_device_sid, &orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+}
+
 /*
  * test_sense
  * Pre-requisites:
@@ -339,6 +440,7 @@ static struct {
 	{ "initialize CSS (chsc)", css_init },
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
+	{ "start subchannel", test_ssch },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
-- 
2.17.1

