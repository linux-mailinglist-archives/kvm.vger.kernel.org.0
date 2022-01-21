Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FA54961CA
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381499AbiAUPJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:09:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1381496AbiAUPJk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:09:40 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LEpKBb028509;
        Fri, 21 Jan 2022 15:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=KYJgJgwi1WEqe1PNP0k21SaRASOQabpeL4XRV7dLKyQ=;
 b=P7pZLRN9ZTBH7Mr/G59a8MPhov/PJ1cXl6XGofrcIPssAJrZw84d8zka2MP3j8AriQ7k
 sXciqYVvfSzHa8HFuVwUUwHSBp5JXWqn1sxn/KaMnNvNOGg1ihprpQDMYIOU1V+WWd6l
 QC2U9kUVxSgH5A6WVRZTuUluIm/0jh+03VEXgIy/Jlk2is7Tzwent8YSTMCmPJTvuOhZ
 7jeKAveJ+XvoJ/7dIohzjxsazLlOto2cHEj2CxqqUKXpK8+Vvazl9Aiw/vDF7mCvMZUC
 7JbrP767vDmQVTyPsPycVTM20xil4HMyXYUfMiOjH+BesbR4en24sIfJ06GOYy514ImQ aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqv6748w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:39 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LF4SoF021806;
        Fri, 21 Jan 2022 15:09:38 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqv6748vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:38 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LF2MiP032343;
        Fri, 21 Jan 2022 15:09:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3dqjr55g1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LF9WeI34472236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:09:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70C764203F;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 344F742041;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [PATCH kvm-unit-tests v1 1/8] s390x: Add more tests for MSCH
Date:   Fri, 21 Jan 2022 16:09:24 +0100
Message-Id: <20220121150931.371720-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121150931.371720-1-nrb@linux.ibm.com>
References: <20220121150931.371720-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zz8o8xBYV7OwKx47ismDCHTC1tLMBXTz
X-Proofpoint-ORIG-GUID: oJttNPBaMDArzY2NEXTLD4zlnFZ7cAQ5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have some coverage for MSCH, but there are more cases to test
for:

- invalid SCHIB structure. We cover that by setting reserved bits 0, 1,
  6 and 7 in the flags of the PMCW.
  This test currently fails because of a QEMU bug, a fix
  is available (see "[PATCH qemu] s390x/css: fix PMCW invalid mask")
- a pointer to an unaligned SCHIB. We cover misalignment by 1
  and 2 bytes. Using pointer to valid memory avoids messing up
  random memory in case of test failures.

Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/css.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 881206ba1cef..afe1f71bb576 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -27,6 +27,8 @@ static int test_device_sid;
 static struct senseid *senseid;
 struct ccw1 *ccw;
 
+char alignment_test_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
 static void test_enumerate(void)
 {
 	test_device_sid = css_enumerate();
@@ -331,6 +333,54 @@ static void test_schm_fmt1(void)
 	free_io_mem(mb1, sizeof(struct measurement_block_format1));
 }
 
+static void test_msch(void)
+{
+	const int align_to = 4;
+	int cc;
+	int invalid_pmcw_flags[] = {0, 1, 6, 7};
+	int invalid_flag;
+	uint16_t old_pmcw_flags;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	cc = stsch(test_device_sid, &schib);
+	if (cc) {
+		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
+		return;
+	}
+
+	report_prefix_push("Unaligned");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+
+		expect_pgm_int();
+		msch(test_device_sid, (struct schib *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid SCHIB");
+	old_pmcw_flags = schib.pmcw.flags;
+	for (int i = 0; i < ARRAY_SIZE(invalid_pmcw_flags); i++) {
+		invalid_flag = invalid_pmcw_flags[i];
+
+		report_prefix_pushf("PMCW flag bit %d set", invalid_flag);
+
+		schib.pmcw.flags = old_pmcw_flags | BIT(15 - invalid_flag);
+		expect_pgm_int();
+		msch(test_device_sid, &schib);
+		check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -343,6 +393,7 @@ static struct {
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
 	{ "measurement block format1", test_schm_fmt1 },
+	{ "msch", test_msch },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

