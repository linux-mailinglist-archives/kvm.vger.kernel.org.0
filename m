Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1FE4C1427
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbiBWNaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240912AbiBWNaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:30:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7FEAA2C6;
        Wed, 23 Feb 2022 05:29:48 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NDCclX008847;
        Wed, 23 Feb 2022 13:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ILNYyHhfWX4IBhBTXyc9j6Dahg2hHrYhKGqQRtMnia4=;
 b=hg7ZhKsEzAm1havizbgrazexMbqXPh64mlmz6iUpqk3o/AmA1MRBb2iZd/7a5GNT3BIo
 oMY0XPwIszCBeujA5MYUc9XPTffSSin2qLHws8/PtrGt4xyUGhTgSUiH3ajpqNGsYJby
 7anRKiaE99M8ndqnlkGJrVbFL08wmKQyBSHOmZlBAAqmKkA+tFdfPR4+7/qe9FRrpxBa
 tP9qkoO4+yqmCMwuIs7hhJo5ALXQoq47AKKfyEl7hzORKEkWTIgHoKkPcf3OEBsT9Cxm
 n6mAaP40DQ5pKlqVODiU4YfE008VYrYwr9mB2iFlevVL6XxzC5gBIBdV6oOmHSSliwcw eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ednks0ax7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:47 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NDRdaw010148;
        Wed, 23 Feb 2022 13:29:47 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ednks0awq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:47 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NDOYnR025381;
        Wed, 23 Feb 2022 13:29:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ear69a8t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NDTgoV39715252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 13:29:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89B47A406B;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45FA6A4069;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v3 5/8] s390x: Add more tests for SSCH
Date:   Wed, 23 Feb 2022 14:29:37 +0100
Message-Id: <20220223132940.2765217-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223132940.2765217-1-nrb@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C00-GbuSfIikGF6Bco-VgWU7N5jWPohq
X-Proofpoint-ORIG-GUID: zFQtRR7UEitvXYSe7fulteygaQuHQRkO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have some coverage of SSCH due to its use in
start_ccw1_chain() in css_lib, but two more cases deserve our
attention:

- unaligned operand address. We check for misalignment by 1 and 2 bytes.
- an invalid ORB structure.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 6a2db79c8097..a90a0cd64e2b 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -464,6 +464,38 @@ static void test_stcrw(void)
 	report_prefix_pop();
 }
 
+static void test_ssch(void)
+{
+	const int align_to = 4;
+	struct orb orb;
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
+		ssch(test_device_sid, (struct orb *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid ORB");
+
+	memset(&orb, 0xff, sizeof(orb));
+	expect_pgm_int();
+	ssch(test_device_sid, &orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -478,6 +510,7 @@ static struct {
 	{ "measurement block format1", test_schm_fmt1 },
 	{ "msch", test_msch },
 	{ "stcrw", test_stcrw },
+	{ "ssch", test_ssch },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

