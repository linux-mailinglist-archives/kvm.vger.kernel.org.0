Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD83587E63
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 16:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiHBOvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 10:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiHBOvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 10:51:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C298DE4A
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 07:51:09 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272EW7Ag010036
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 14:51:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Lpt0HUhQJCBIBGCBjdWDSSAeaKwytgpHQ86dmHEkkiU=;
 b=izLRmGjNh/kLML9OiEfJVkjXT3bz1ltgoUdifBaBsHyLJhbOyxiMwwY3ZbEWefaWAk6N
 F1ors/YilcAPLbOQER0QPDCxYx2egqUYYmQZg1s8KzHYa5oEhVtig6lxY0M1Vytd4Wed
 BPpe+yZ6uKc8mrn/PJ9AyqKOJdEm+Rny+C7nVLRGdMPajIDfRX7kaICxr3eUBh/eB+7Y
 OCtb+HycSdewAwL7PQMs+uAkC8+DMABaFPL91qcc+CKr2SMjWo5VQ6+94YckzQx4xe2z
 7pSrItvtkfyTkwnt4LmJg974wtKAp420TDLpJXbZVTioh+CFNGtSsVxy14+c1UJjLegK iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq5s80n52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 14:51:09 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 272Eck4E008377
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 14:51:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq5s80n3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 14:51:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 272ElcIx027811;
        Tue, 2 Aug 2022 14:51:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3hmuwhuuvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 14:51:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 272Ep3dN31261014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 14:51:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 306894C044;
        Tue,  2 Aug 2022 14:51:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F144A4C040;
        Tue,  2 Aug 2022 14:51:02 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 14:51:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1] s390x: verify EQBS/SQBS is unavailable
Date:   Tue,  2 Aug 2022 16:51:02 +0200
Message-Id: <20220802145102.128841-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XewprCRQcdllg8uMSeGnfcW0eFMt0NmI
X-Proofpoint-ORIG-GUID: 8n2Xp_4F_HEoSMKUSeakDijUlNFF3Z-s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_08,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=733
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020067
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
 s390x/intercept.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 9e826b6c79ad..73b06b5fc6e8 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -197,6 +197,55 @@ static void test_diag318(void)
 
 }
 
+static inline int sqbs(u64 token)
+{
+	unsigned long _token = token;
+	int cc;
+
+	asm volatile(
+		"	lgr 1,%[token]\n"
+		"	.insn   rsy,0xeb000000008a,0,0,0(0)\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=&d" (cc)
+		: [token] "d" (_token)
+		: "memory", "cc", "1");
+
+	return cc;
+}
+
+static inline int eqbs(u64 token)
+{
+	unsigned long _token = token;
+	int cc;
+
+	asm volatile(
+		"	lgr 1,%[token]\n"
+		"	.insn   rrf,0xb99c0000,0,0,0,0\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=&d" (cc)
+		: [token] "d" (_token)
+		: "memory", "cc", "1");
+
+	return cc;
+}
+
+static void test_qbs(void)
+{
+	report_prefix_push("sqbs");
+	expect_pgm_int();
+	sqbs(0xffffffdeadbeefULL);
+	check_pgm_int_code(PGM_INT_CODE_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_push("eqbs");
+	expect_pgm_int();
+	eqbs(0xffffffdeadbeefULL);
+	check_pgm_int_code(PGM_INT_CODE_OPERATION);
+	report_prefix_pop();
+}
+
 struct {
 	const char *name;
 	void (*func)(void);
@@ -208,6 +257,7 @@ struct {
 	{ "stidp", test_stidp, false },
 	{ "testblock", test_testblock, false },
 	{ "diag318", test_diag318, false },
+	{ "qbs", test_qbs, false },
 	{ NULL, NULL, false }
 };
 
-- 
2.36.1

