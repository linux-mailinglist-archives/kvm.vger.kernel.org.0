Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3904C1430
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbiBWNaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240922AbiBWNaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:30:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB5AAB465;
        Wed, 23 Feb 2022 05:29:50 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ND1nO4028381;
        Wed, 23 Feb 2022 13:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EZbL3x6R1FugjcHfkRqvQ0Rqsgvz6qMdmHRUKz2rBmo=;
 b=qJxsn2Itd7jTv5s2WzNtJionxjjbnrDrNMyhonhJnpjICRug9Bk7nl2K4lmX4SK+u6r1
 rxwLaGSuxFu9XzEau1yKAyRPnVlvr/xxZxjs5Edlln0NhLzwjpw0j2iTKUyFgRf53LM1
 kdVXFZop7dEd5Bqh6X8JfDd+ktmK+45Jr0rrJ7UNiXzMcpvPczyo4rnS1L4U98uFXkAh
 Jp28IwqldKZPm4/mQJveEG82TJbWdmVYaCcKQUCIhEEDtuqaFL4sinXLnMIZnXjGdyRp
 nhIRTLI6vkqqKVHDlFtVmqs2omt5FKXNNv+EXi4JZy16csM36ebKvHB72+NaaBp48Oqg gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edfeh00pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:49 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NClEpJ008795;
        Wed, 23 Feb 2022 13:29:48 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edfeh00p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:48 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NDOhTM017501;
        Wed, 23 Feb 2022 13:29:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqtjaa19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NDThx855247194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 13:29:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BF7DA405B;
        Wed, 23 Feb 2022 13:29:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF7C3A4057;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v3 7/8] s390x: Add tests for TSCH
Date:   Wed, 23 Feb 2022 14:29:39 +0100
Message-Id: <20220223132940.2765217-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223132940.2765217-1-nrb@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OS9NqVDD2QtUqh-DNSL2Dh29hHRYjptU
X-Proofpoint-ORIG-GUID: vFPnTERMG8YnW3y4zJFr0JPH7Gdga0Ah
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TSCH has two special cases which need to be tested:

- unaligned address. We test for misalignment by 1 and 2 bytes.
- channel not operational
- bit 47 in SID not set

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 021eb12573c0..b2e027c99848 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -568,6 +568,41 @@ static void test_pmcw_bit5(void)
 	report_prefix_pop();
 }
 
+static void test_tsch(void)
+{
+	const int align_to = 4;
+	struct irb irb;
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
+		tsch(test_device_sid, (struct irb *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid subchannel number");
+	cc = tsch(0x0001ffff, &irb);
+	report(cc == 3, "Channel not operational");
+	report_prefix_pop();
+
+	report_prefix_push("Bit 47 in SID is zero");
+	expect_pgm_int();
+	tsch(0x0000ffff, &irb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -585,6 +620,7 @@ static struct {
 	{ "ssch", test_ssch },
 	{ "stsch", test_stsch },
 	{ "pmcw bit 5 ignored", test_pmcw_bit5 },
+	{ "tsch", test_tsch },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

