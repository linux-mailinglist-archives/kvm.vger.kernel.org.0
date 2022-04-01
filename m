Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BF64EEC2F
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345459AbiDALSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345395AbiDALS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C7B185453
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:37 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2318LFxJ011048
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=BcmswbvSfgcn217kMBVri6pVGTwuYR9Mo+GTrMYy8SE=;
 b=tgx8+i4wXAP7hfL142UUUG9DmcYjsL6rNpQdkb22Fsdilvrpoc2P8Ezhb/udzOQhaHMQ
 P53OKwvL4ZiW6zaAudnk5qL8t5AT4AREoVD/tb0wYF7LfIznTNPbyTN4X+4beCNUU+sr
 Qcu2xsyVpwoSw00Bm8EKnh4IgNTmz7vbiJuC/NPBIp2C8INq70XYD2CakRiya67EyUho
 X3Js6mOcQ9l/pXtR4A9CG4hP800hm3FhaLYg3NT4Rdqb6EeWp2lKEJgQjNJVRqwbqSvn
 UuqQ6KukLexYhEBy/SV3CH+50VGhddALjirtsXf6JVMrhg87jkiNLlhFDMybpcmXBPCH ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556u9q1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:37 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231Aq0vH015729
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:36 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556u9q13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B8qCx014328;
        Fri, 1 Apr 2022 11:16:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3f1tf92vds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGbbu35127624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD2194C05E;
        Fri,  1 Apr 2022 11:16:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DA894C063;
        Fri,  1 Apr 2022 11:16:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 12/27] s390x: Add more tests for STSCH
Date:   Fri,  1 Apr 2022 13:16:05 +0200
Message-Id: <20220401111620.366435-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Bt-LvjHh59_ZAW3k1oCb9aPgvPQUr2i
X-Proofpoint-ORIG-GUID: AJ0gmYSOIRS-LAFz5uj8f7NMx4omXrDe
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

css_lib extensively uses STSCH, but two more cases deserve their own
tests:

- unaligned address for SCHIB. We check for misalignment by 1 and 2
  bytes.
- channel not operational
- bit 47 in SID not set
- bit 5 of PMCW flags.
  As per the principles of operation, bit 5 of the PMCW flags shall be
  ignored by msch and always stored as zero by stsch.

  Older QEMU versions require this bit to always be zero on msch,
  which is why this test may fail. A fix is available in QEMU master
  commit 2df59b73e086 ("s390x/css: fix PMCW invalid mask").

Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/css.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 7fe5283c..dd84e670 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -501,6 +501,86 @@ static void test_ssch(void)
 	report_prefix_pop();
 }
 
+static void test_stsch(void)
+{
+	const int align_to = 4;
+	struct schib schib;
+	int cc;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	report_prefix_push("Unaligned");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+
+		expect_pgm_int();
+		stsch(test_device_sid, (struct schib *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid subchannel number");
+	cc = stsch(0x0001ffff, &schib);
+	report(cc == 3, "Channel not operational");
+	report_prefix_pop();
+
+	/*
+	 * No matter if multiple-subchannel-set facility is installed, bit 47
+	 * always needs to be 1.
+	 */
+	report_prefix_push("Bit 47 in SID is zero");
+	expect_pgm_int();
+	stsch(0x0000ffff, &schib);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+}
+
+/*
+ * According to architecture MSCH does ignore bit 5 of the second word
+ * but STSCH will store bit 5 as zero.
+ */
+static void test_pmcw_bit5(void)
+{
+	int cc;
+	uint16_t old_pmcw_flags;
+
+	cc = stsch(test_device_sid, &schib);
+	if (cc) {
+		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
+		return;
+	}
+	old_pmcw_flags = schib.pmcw.flags;
+
+	report_prefix_push("Bit 5 set");
+
+	schib.pmcw.flags = old_pmcw_flags | BIT(15 - 5);
+	cc = msch(test_device_sid, &schib);
+	report(!cc, "MSCH cc == 0");
+
+	cc = stsch(test_device_sid, &schib);
+	report(!cc, "STSCH cc == 0");
+	report(!(schib.pmcw.flags & BIT(15 - 5)), "STSCH PMCW Bit 5 is clear");
+
+	report_prefix_pop();
+
+	report_prefix_push("Bit 5 clear");
+
+	schib.pmcw.flags = old_pmcw_flags & ~BIT(15 - 5);
+	cc = msch(test_device_sid, &schib);
+	report(!cc, "MSCH cc == 0");
+
+	cc = stsch(test_device_sid, &schib);
+	report(!cc, "STSCH cc == 0");
+	report(!(schib.pmcw.flags & BIT(15 - 5)), "STSCH PMCW Bit 5 is clear");
+
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -516,6 +596,8 @@ static struct {
 	{ "msch", test_msch },
 	{ "stcrw", test_stcrw },
 	{ "ssch", test_ssch },
+	{ "stsch", test_stsch },
+	{ "pmcw bit 5 ignored", test_pmcw_bit5 },
 	{ NULL, NULL }
 };
 
-- 
2.34.1

