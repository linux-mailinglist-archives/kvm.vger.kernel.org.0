Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969F557CCE2
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiGUOID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiGUOH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D3E6714C
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:47 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDvQ4C009695
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=1WjhkwVh817dbDDR60Bg+3x0BuVHCL2c5vSEpG1EY0I=;
 b=eNWeg0S1gkdQ4UE7oQtn5vDue8e8dQpZGkOaOFf706ARlMtD/8RLHpqkU5R+X3GyYYMS
 34MeMIIhPHa+XuBAwPI+WJYCJUagY391lqqjMiv276UaplNoDfdOPf/ZKCdO2nYw+QUO
 O1knypvEdvOjOPpbCB5JIGXRTZkMp4lECTPC9zLoZpSeYZFT379cEs4ObTGOFMnMGmPV
 gnhMvY2fjcWLMK85nPQYv2/ct+iq6aPmoO5pUoxIzyHmzNjPha087a8IxNpXMfHyos5d
 7dLgfLUvCxJNAnYNuLTOYIKE4Ghr3LD7DEVTSNtW5KT3/zfuMewEHaD02X2LGVpzbS/T mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf84ygba4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:43 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE0bkQ021841
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf84ygatu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE75l6031146;
        Thu, 21 Jul 2022 14:07:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3hbmy8y6gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE76dY16777566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40A134C046;
        Thu, 21 Jul 2022 14:07:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01CF94C04E;
        Thu, 21 Jul 2022 14:07:06 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 12/12] s390x: intercept: make sure all output lines are unique
Date:   Thu, 21 Jul 2022 16:07:01 +0200
Message-Id: <20220721140701.146135-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yrPoLcKnE9Rh6XH3Z2PKcbyQOyZgzfX3
X-Proofpoint-ORIG-GUID: nzvrrwbqpfUGHsrZHQKGDnNIBe33VImV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220721133002.142897-3-imbrenda@linux.ibm.com
Message-Id: <20220721133002.142897-3-imbrenda@linux.ibm.com>
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

