Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235D04BDCAA
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358572AbiBUNIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 08:08:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358549AbiBUNIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 08:08:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44261EC52;
        Mon, 21 Feb 2022 05:07:55 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LCgIGq023270;
        Mon, 21 Feb 2022 13:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ILNYyHhfWX4IBhBTXyc9j6Dahg2hHrYhKGqQRtMnia4=;
 b=CZR/NQqHwzlVTm6jENRtSqnly01j6EQz767yiJV5NG4sfGq+469WfEIz/hoYFnwnQCUt
 jFm1IQwbbBn6hDmIPBw3YdaHjt2tsaVqtnsW52jY0R6p4EP+vnTAWhCTN/RghWiK9Ef3
 A1ROQzWmdI3fM9IOtYaKBIrk0B7AV69OY2c4Dl7DTc/98LQpwv4ZzQQIQtT8sG7THHPV
 69T3LnXRlLiFaLRoN8nTlYJ2dZ/qC+PeG/HARb+AdbARHquDnb3S1kmNxBP90GmXdWzY
 J+73nBHzdL0Z3nDONMEJobqNEwcth9YFB2r4yr1MKtBSaEBzZClsVJNJZaYvhqSZDK27 Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecayg8gcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:55 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LCtES0022050;
        Mon, 21 Feb 2022 13:07:54 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecayg8gc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:54 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LCwlrq019562;
        Mon, 21 Feb 2022 13:07:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3ear691t6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LD7nFb57344294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 13:07:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 110694C040;
        Mon, 21 Feb 2022 13:07:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2BD44C04E;
        Mon, 21 Feb 2022 13:07:48 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 13:07:48 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 5/8] s390x: Add more tests for SSCH
Date:   Mon, 21 Feb 2022 14:07:43 +0100
Message-Id: <20220221130746.1754410-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221130746.1754410-1-nrb@linux.ibm.com>
References: <20220221130746.1754410-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R2XyDNKm4bre1SlokP22vDey5lmG9HIy
X-Proofpoint-ORIG-GUID: BToPuQPvFMzTuW9bcw-3EdJslEcLdF1K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_06,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

