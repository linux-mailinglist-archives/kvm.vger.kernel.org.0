Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98A34BDE77
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358580AbiBUNI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 08:08:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358557AbiBUNIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 08:08:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D70B1EC4B;
        Mon, 21 Feb 2022 05:07:58 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LBgja8020649;
        Mon, 21 Feb 2022 13:07:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=iplXjZQPCjA5Vn+ln7KCTNZdpLgHFNCce96hooYxNPc=;
 b=P6H4tstrEoCY+alD9/t3n5X2NV3EC4SxmAgpiMfz7p0Y5OCEKcqnH3Q5+AnlsCm7YWUB
 2dSELlegUKf6rEsZBLWnJRHobnks9jgMt5i3X3mMciA8B0z5vhgjf6GVfaQ5CedElgXA
 lVJFaOzNe22u+sTohjzDxm03g4Kq7AGJHb4uL+iahgvkQbHtUzA54zD0Lgm4UI/dZSGl
 srp9LII8W3KGD4+vVK27i/D8P+dtO7vyy460Ok/biPlsuBI2A3mFPCfnUzlw0J/cRatM
 di+s1cmlV+KxRngfn2Vx8SkEKvXmYpP/56va+QOHKLjmRKbn7GaJ2xEoHVa94XQU97eZ bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eca3shq1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:57 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LD0taj028532;
        Mon, 21 Feb 2022 13:07:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eca3shq1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LCwp1G006874;
        Mon, 21 Feb 2022 13:07:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear68tm6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LD7n2W51315194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 13:07:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FA774C040;
        Mon, 21 Feb 2022 13:07:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CF604C04A;
        Mon, 21 Feb 2022 13:07:49 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 13:07:49 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 6/8] s390x: Add more tests for STSCH
Date:   Mon, 21 Feb 2022 14:07:44 +0100
Message-Id: <20220221130746.1754410-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221130746.1754410-1-nrb@linux.ibm.com>
References: <20220221130746.1754410-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pa2GNRc5S_bRsd4RSGg5cBM6Jm8UPdDg
X-Proofpoint-ORIG-GUID: 9hmCKYeO8cE8ZQ33ZVuCletW0NMqQqaI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_06,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210078
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

  Currently, QEMU requires this bit to always be zero on msch, which is
  why this test currently fails. A fix was posted upstream
  ("[PATCH qemu] s390x/css: fix PMCW invalid mask").

Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/css.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index a90a0cd64e2b..021eb12573c0 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -496,6 +496,78 @@ static void test_ssch(void)
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
+	report_prefix_push("Bit 47 in SID is zero");
+	expect_pgm_int();
+	stsch(0x0000ffff, &schib);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+}
+
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
@@ -511,6 +583,8 @@ static struct {
 	{ "msch", test_msch },
 	{ "stcrw", test_stcrw },
 	{ "ssch", test_ssch },
+	{ "stsch", test_stsch },
+	{ "pmcw bit 5 ignored", test_pmcw_bit5 },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

