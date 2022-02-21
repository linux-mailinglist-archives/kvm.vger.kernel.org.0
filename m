Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DFE4BDE0D
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358573AbiBUNIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 08:08:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358550AbiBUNIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 08:08:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433961EC58;
        Mon, 21 Feb 2022 05:07:56 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LCCIJj020242;
        Mon, 21 Feb 2022 13:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=/AqcVq6wO3aHnWv7O34YabrPeV0tcX8DhvifMiBXhlw=;
 b=g/pYHwKOJndEuigCwTI7J/PlzCbp4X+uUEftLRzuG2fg6FOV/YJakT+dLjOb9+9MAqrp
 aTYqmoDsw/edD4ckgm7gJjXIopTmkn0Fnm/X6dJo0SYsXRbackNIes8HrP7X9jrJUTP7
 4FK9OYxv+GTEbHbFvrB0nmiyQDYtRTMxj+RMe5HL+7uthZ7/h7K4KkqzdZpBZsk9R+Sp
 2T+MaSyuEy3aYiYXZ1o4/PcDXt6uoEd0oykksNUAeGegmQ+CsAn2slVrtmRdP0x5zahi
 fKpyAjzdHU+7CgMvAwlMXHeXWncdfGh0YWBNi6rEvKun/ZzdSX3wQpcQ7XVhmpbcZkGA 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecahjh3wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:55 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LCO6RC031407;
        Mon, 21 Feb 2022 13:07:55 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecahjh3vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:55 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LCwo0V007241;
        Mon, 21 Feb 2022 13:07:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ear68std3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LD7lDT54132992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 13:07:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE06D4C04E;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BE364C05C;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/8] s390x: Add more tests for MSCH
Date:   Mon, 21 Feb 2022 14:07:39 +0100
Message-Id: <20220221130746.1754410-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221130746.1754410-1-nrb@linux.ibm.com>
References: <20220221130746.1754410-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3NDcuLZRSGUJEiBNbBqIWDkmrc2pMFlr
X-Proofpoint-ORIG-GUID: 1EeY5nKqRZK9-iEjGr4pa0fEQXJlMwBW
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_06,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 mlxscore=0 clxscore=1015 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/css.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 881206ba1cef..932daf69bb36 100644
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
@@ -331,6 +333,56 @@ static void test_schm_fmt1(void)
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
+
+	schib.pmcw.flags = old_pmcw_flags;
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -343,6 +395,7 @@ static struct {
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
 	{ "measurement block format1", test_schm_fmt1 },
+	{ "msch", test_msch },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

