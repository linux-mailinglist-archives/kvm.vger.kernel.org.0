Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7603A57CBEC
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiGUNaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGUNaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:30:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4F8B7D9;
        Thu, 21 Jul 2022 06:30:12 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDNRrb011259;
        Thu, 21 Jul 2022 13:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ehT3NFrAx4djY+7cv7E4I/mq04xD1+cBLYEFXxPtgfo=;
 b=lxqgdfzTzO5QrK9QxAl+bwojDEYcIxPlb1PXfDqqlVDzlVRRItl0oZ7sHPjFrqblpJAK
 ugpvfLsbtkz1WNue+RdsLgcp95b8l3TrTFcfE0prHSSmEWXuSzrLObWdGDNLZiDH/oST
 hj3zRo/Jyju4+YakU3U8MfKaqaMI8Q2YR+Bo3bQcueyXTY46lHKYFMP7mYPhRI/iwdSi
 10LirSHluUlQLf67j82yvYjKYY6Yor8WhEtgecES34KKV6xJLZCXNA86Z54AHH44QDnV
 VY1G7DCLKP3pqeKPSxsiEkBN3Pjh4yLf+mLsvibrzpPrgQ0LuMo7U95QeKp7jeBItn3q FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7my06b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:09 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDOtFc018724;
        Thu, 21 Jul 2022 13:30:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7my069v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDOxH0000804;
        Thu, 21 Jul 2022 13:30:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3hbmy8xyrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDU3D013566220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:30:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2A2D42041;
        Thu, 21 Jul 2022 13:30:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AEA14203F;
        Thu, 21 Jul 2022 13:30:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 13:30:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 2/2] s390x: intercept: make sure all output lines are unique
Date:   Thu, 21 Jul 2022 15:30:02 +0200
Message-Id: <20220721133002.142897-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721133002.142897-1-imbrenda@linux.ibm.com>
References: <20220721133002.142897-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yNx827pVarih_Ll1-jUDrGkS8iSnSyfn
X-Proofpoint-ORIG-GUID: AtQMlvsgXbQKqninW8MynEwHoZ7vG4Xh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_17,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The intercept test has the same output line twice for two different
testcases.

Fix this by adding report_prefix_push() as appropriate.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/intercept.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 656b8adb..9e826b6c 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -68,14 +68,19 @@ static void test_spx(void)
 	set_prefix(old_prefix);
 	report(pagebuf[GEN_LC_STFL] != 0, "stfl to new prefix");
 
+	report_prefix_push("operand not word aligned");
 	expect_pgm_int();
 	asm volatile(" spx 0(%0) " : : "r"(1));
 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
 
+	report_prefix_push("operand outside memory");
 	expect_pgm_int();
 	asm volatile(" spx 0(%0) " : : "r"(-8L));
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
 
+	report_prefix_push("new prefix outside memory");
 	new_prefix = get_ram_size() & 0x7fffe000;
 	/* TODO: Remove host_is_tcg() checks once CIs are using QEMU >= 7.1 */
 	if (!host_is_tcg() && (get_ram_size() - new_prefix < 2 * PAGE_SIZE)) {
@@ -95,6 +100,7 @@ static void test_spx(void)
 		else
 			report_skip("inaccessible prefix area");
 	}
+	report_prefix_pop();
 }
 
 /* Test the STORE CPU ADDRESS instruction */
-- 
2.36.1

