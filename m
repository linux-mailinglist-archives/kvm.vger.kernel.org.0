Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C01F3406D9
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhCRN1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:27:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230348AbhCRN0i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:26:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IDEAwb125945
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=MZ4DR6oeT4sXGVn9kIfZ8TRc0S8BcevcGQbi1Le+46k=;
 b=UHACFJKDeCUdvz5jm4X9ZeDj2O/dZeA1Fx3PZ7ndn++swqFMRGokDSS+Qg30DwSXlN4s
 zLaAR4GkAET2md0UuNuCR8gN764U37arpsw47y1zCGHErVyazH9aWjVU4TCDEfgzXmei
 TreYQvuLaciRlOm9ow24MtXmcGZmWyxvpv+bY/qTkbvNQJZQ2EI5dlB7DgGfVLjxI+f1
 TvlIWn26rFqAdKSoFe8/BatuEt4kfLcKuKW3uoJZKBwn8wzHANc6osFgqLxictwe1st0
 cE62Qb3HYBmyz33Fi78LYsEtyYupNn6oG7Cngt/iyqBKMbJaKEl+CpdxtF+2krmmeXlK WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c78qh1ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:37 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ID4S8n074636
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:37 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c78qh1du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 09:26:37 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IDNEpp030193;
        Thu, 18 Mar 2021 13:26:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 378mnhahsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 13:26:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IDQWR852101626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:26:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F60F4C052;
        Thu, 18 Mar 2021 13:26:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C814A4C040;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 13:26:31 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 6/6] s390x: css: testing clear and halt subchannel
Date:   Thu, 18 Mar 2021 14:26:28 +0100
Message-Id: <1616073988-10381-7-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxlogscore=789 spamscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

checking return values for CSCH and HSCH for various configurations.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 172 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 171 insertions(+), 1 deletion(-)

diff --git a/s390x/css.c b/s390x/css.c
index 1c891f8..ee02cdd 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -51,6 +51,175 @@ static void test_enable(void)
 	report(cc == 0, "Enable subchannel %08x", test_device_sid);
 }
 
+static void dummy_irq(void)
+{
+}
+
+static int check_io_completion(int sid, uint32_t expected)
+{
+	struct irb irb;
+	int ret;
+
+	report_prefix_push("IRQ flags");
+
+	ret = tsch(sid, &irb);
+	if (ret)
+		goto end;
+
+	if (!expected)
+		goto end;
+
+	if (!(expected & irb.scsw.ctrl)) {
+		report_info("expect: %s got: %s",
+			    dump_scsw_flags(expected),
+			    dump_scsw_flags(irb.scsw.ctrl));
+		ret = -1;
+	}
+
+end:
+	report(!ret, "expectations");
+	report_prefix_pop();
+	return ret;
+}
+
+static void test_csch(void)
+{
+	struct orb orb = {
+		.intparm = test_device_sid,
+		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
+	};
+	struct ccw1 *ccw;
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+	orb.cpa = (uint64_t)ccw;
+
+	/* 1- Basic check for CSCH */
+	report_prefix_push("CSCH on a quiet subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	report(csch(test_device_sid) == 0, "subchannel clear");
+
+	/* now we check the flags */
+	report_prefix_push("IRQ flags");
+	report(wait_and_check_io_completion(test_device_sid, SCSW_FC_CLEAR) == 0, "expected");
+	report_prefix_pop();
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* For the following checks we need to execute tsch synchronously */
+	assert(unregister_io_int_func(css_irq_io) == 0);
+	assert(register_io_int_func(dummy_irq) == 0);
+
+	/* 2- We want to check if the IRQ flags of SSCH are erased by clear */
+	report_prefix_push("CSCH on SSCH status pending subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(ssch(test_device_sid, &orb) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	check_io_completion(test_device_sid, SCSW_FC_CLEAR);
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* 3- Checking CSCH after HSCH */
+	report_prefix_push("CSCH on a halted subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(hsch(test_device_sid) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	check_io_completion(test_device_sid, SCSW_FC_CLEAR);
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* 4- Checking CSCH after CSCH */
+	report_prefix_push("CSCH on a cleared subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(csch(test_device_sid) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	check_io_completion(test_device_sid, SCSW_FC_CLEAR);
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* Reset the IRQ handler */
+	assert(unregister_io_int_func(dummy_irq) == 0);
+	assert(register_io_int_func(css_irq_io) == 0);
+
+	free_io_mem(senseid, sizeof(*senseid));
+	free_io_mem(ccw, sizeof(*ccw));
+}
+
+static void test_hsch(void)
+{
+	struct orb orb = {
+		.intparm = test_device_sid,
+		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
+	};
+	struct ccw1 *ccw;
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+	orb.cpa = (uint64_t)ccw;
+
+	/* 1- Basic HSCH */
+	report_prefix_push("HSCH on a quiet subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	report(hsch(test_device_sid) == 0, "subchannel halted");
+
+	/* now we check the flags */
+	report_prefix_push("IRQ flags");
+	report(wait_and_check_io_completion(test_device_sid, SCSW_FC_HALT) == 0, "expected");
+	report_prefix_pop();
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* For the following checks we need to execute tsch synchronously */
+	assert(unregister_io_int_func(css_irq_io) == 0);
+	assert(register_io_int_func(dummy_irq) == 0);
+
+	/* 2- Check HSCH after SSCH */
+	report_prefix_push("HSCH on status pending subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(ssch(test_device_sid, &orb) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	check_io_completion(test_device_sid, SCSW_FC_START);
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* 3- Check HSCH after CSCH */
+	report_prefix_push("HSCH on busy on CSCH subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(csch(test_device_sid) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	check_io_completion(test_device_sid, SCSW_FC_CLEAR);
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* 4- Check HSCH after HSCH */
+	report_prefix_push("HSCH on busy on HSCH subchannel");
+	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
+	assert(hsch(test_device_sid) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	check_io_completion(test_device_sid, SCSW_FC_HALT);
+
+	assert(css_disable(test_device_sid) == 0);
+	report_prefix_pop();
+
+	/* Reset the IRQ handler */
+	assert(unregister_io_int_func(dummy_irq) == 0);
+	assert(register_io_int_func(css_irq_io) == 0);
+
+	free_io_mem(senseid, sizeof(*senseid));
+	free_io_mem(ccw, sizeof(*ccw));
+}
+
 static void test_ssch(void)
 {
 	struct orb orb = {
@@ -61,7 +230,6 @@ static void test_ssch(void)
 	phys_addr_t base, top;
 
 	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
-	assert(register_io_int_func(css_irq_io) == 0);
 
 	/* ORB address should be aligned on 32 bits */
 	report_prefix_push("ORB alignment");
@@ -441,6 +609,8 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "start subchannel", test_ssch },
+	{ "halt subchannel", test_hsch },
+	{ "clear subchannel", test_csch },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
-- 
2.17.1

