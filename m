Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFF6588E1A
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiHCN7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237730AbiHCN7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:59:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5739EE8C
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:59:18 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273CgwUu028189
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 13:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UcH3h3n2H8UEZMrH6EhA5TeyW5dH2VrdbGJHlK4nZjk=;
 b=QeOtgelD5LFr7PBsH98rtpoMhZIhNafDLZwqWyJz+Wv0TYtp0pOkyjNBayO3nV6HoqL6
 v7qWbSdWX5G6RlCZJv9lHHbRU9W0SWjrh3yx26Bz3bVLMa5LUs2y93sRSfEgoX00/qMm
 PjLY3qzldXXzcyipyAn/WfM+d3cDIIU/LWutUF4aLme/+60+GqUT7aWcdgUhQluHMRVi
 Rje2qLtLPdvbfbyHCwUyLoKvGJhrtR85tUbHTUpCbwf69DHmuZVoLT/Z+S2ZBBEUF5ZC
 BbdTViWShFJeF3zmELpbviHMgurH6y+g5nBT6c6irFOCxTusbY61FUwkqDqFnAxTAk8g bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqs91jj89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 13:59:17 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 273DqN73006830
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 13:59:16 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqs91jj7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 13:59:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273Dq6G2012727;
        Wed, 3 Aug 2022 13:59:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3hmuwhw0sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 13:59:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273Dwpu625821682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 13:58:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD51D4203F;
        Wed,  3 Aug 2022 13:58:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A64342042;
        Wed,  3 Aug 2022 13:58:51 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 13:58:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/1] s390x: verify EQBS/SQBS is unavailable
Date:   Wed,  3 Aug 2022 15:58:51 +0200
Message-Id: <20220803135851.384805-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220803135851.384805-1-nrb@linux.ibm.com>
References: <20220803135851.384805-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yUoeiMLOBBVZg9rdpVXpNIGETywJON-w
X-Proofpoint-GUID: xdUf2lok5SWYCE5UAcLqZ-EaN0abDJpH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=971
 suspectscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU doesn't provide EQBS/SQBS instructions, so we should check they
result in an exception.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/intercept.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 9e826b6c79ad..48eb2d22a2cc 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -197,6 +197,34 @@ static void test_diag318(void)
 
 }
 
+static void test_qbs(void)
+{
+	report_prefix_push("qbs");
+	if (!host_is_qemu()) {
+		report_skip("QEMU-only test");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("sqbs");
+	expect_pgm_int();
+	asm volatile(
+		"	.insn   rsy,0xeb000000008a,0,0,0(0)\n"
+		: : : "memory", "cc");
+	check_pgm_int_code(PGM_INT_CODE_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_push("eqbs");
+	expect_pgm_int();
+	asm volatile(
+		"	.insn   rrf,0xb99c0000,0,0,0,0\n"
+		: : : "memory", "cc");
+	check_pgm_int_code(PGM_INT_CODE_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 struct {
 	const char *name;
 	void (*func)(void);
@@ -208,6 +236,7 @@ struct {
 	{ "stidp", test_stidp, false },
 	{ "testblock", test_testblock, false },
 	{ "diag318", test_diag318, false },
+	{ "qbs", test_qbs, false },
 	{ NULL, NULL, false }
 };
 
-- 
2.36.1

