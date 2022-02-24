Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C474C3019
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbiBXPod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiBXPoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:44:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A9422EDD7;
        Thu, 24 Feb 2022 07:43:46 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFF1t0032488;
        Thu, 24 Feb 2022 15:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=qYtgWQcwa8QFGJCi7XF69gpulRYSrqQWOfPruFoLYz8=;
 b=X0O5noMi9f6iYci9/b3lC3S5tP/tiW4/LWwZuvZrYoMlWKgcH8lcTVOLvSFfDKIidPV6
 FVITHKEVSu5HSyeJnBNQgspQ59vGKr/r+ww1h9lKqpeFND+cFjGFRQc/do9OddkXFuMN
 8pLjB9GHsN1QXfBcYMPfm0Q+W6p0MZYrEc/pukqmTaeUO6Elb+I/gBOkXphcBVUCeuKt
 Wc42319eWsjqmehSSge/ol2bm0NrkochmJ8/ziJ3HINjgB8G2BZs1GXZ13CsEDY2i4/D
 V4Anu5ISeZtJEL5jWAHEOpSp4gNOwQJOk4Zz6NBpE7BZgBAccnuVxQtH4OrK/8SO16v5 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edwxu2q5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:45 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OFaeIv015311;
        Thu, 24 Feb 2022 15:43:45 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edwxu2q5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:45 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OFb0Q6028923;
        Thu, 24 Feb 2022 15:43:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtk0um1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OFhckc59245038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:43:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8207842045;
        Thu, 24 Feb 2022 15:43:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41E3B42052;
        Thu, 24 Feb 2022 15:43:38 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 15:43:38 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v4 6/8] s390x: Add more tests for STSCH
Date:   Thu, 24 Feb 2022 16:43:34 +0100
Message-Id: <20220224154336.3459839-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220224154336.3459839-1-nrb@linux.ibm.com>
References: <20220224154336.3459839-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cKABAUjr1baXMl0CLSiGNYCr4ml_P3Yn
X-Proofpoint-GUID: BAlDl4L1e2FCH11wXnUBCVDEr_yybQNN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 s390x/css.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 7fe5283c41d0..dd84e670ce99 100644
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
2.31.1

