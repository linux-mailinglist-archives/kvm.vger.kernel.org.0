Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9C56D1F10
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 13:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjCaLcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 07:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjCaLcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 07:32:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE6A1EFD7
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 04:31:27 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VADT5R013192;
        Fri, 31 Mar 2023 11:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=xFE5QZFk6ul6HVx9P7Kafn+pt20xSCSZ1axo1spcuF8=;
 b=g85nVgF/7H5WLvaaN6ysNhGzWKnLRg7lMXu2rLVX/8qJ5omCtYVGsruwELCrEBU+rUF0
 C6owacw9ukiqAxm7v4Lrn3yJ0duT3NJMgjH/SKMVQTzXF4F64wd0ORi+IuqmMRDoEd6G
 hG/tkW/MdWKkkt1eGM+y2zTL3QXkHObXq7WfQ+kVVrUsbIkXmts2PWF+7EQ9+VJdeGnN
 QvRI9H/jtT1/Qe8pkrhdKjYctZgpvRw2yHD8/Z//7Lmb6Wq56NRsVnVbt16Zd97+tBVh
 LQWlc30GLWGMH0eZhmr2ASb5ntDzfP+r61owvfbSnjsCLbVBHfGvdX2PeRdsQf4RV+YW mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnu3nws9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VBU41Q028007;
        Fri, 31 Mar 2023 11:30:58 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnu3nws8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UNUper013396;
        Fri, 31 Mar 2023 11:30:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3phrk6wefa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32VBUrKM45875776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 11:30:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 145EF2004D;
        Fri, 31 Mar 2023 11:30:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C762F20040;
        Fri, 31 Mar 2023 11:30:51 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.9.190])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 11:30:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 08/14] s390x/spec_ex: Use PSW macro
Date:   Fri, 31 Mar 2023 13:30:22 +0200
Message-Id: <20230331113028.621828-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331113028.621828-1-nrb@linux.ibm.com>
References: <20230331113028.621828-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gYazr1EAozJuK5QQoEa-cJfJsugjPphM
X-Proofpoint-GUID: q1bllldOzKxkGzggVIXMGc9ocNAynTZG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_06,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310091
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Replace explicit psw definition by PSW macro.
No functional change intended.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20230317133253.965010-2-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 42ecaed..2adc599 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -105,10 +105,7 @@ static int check_invalid_psw(void)
 /* For normal PSWs bit 12 has to be 0 to be a valid PSW*/
 static int psw_bit_12_is_1(void)
 {
-	struct psw invalid = {
-		.mask = BIT(63 - 12),
-		.addr = 0x00000000deadbeee
-	};
+	struct psw invalid = PSW(BIT(63 - 12), 0x00000000deadbeee);
 
 	expect_invalid_psw(invalid);
 	load_psw(invalid);
@@ -118,10 +115,7 @@ static int psw_bit_12_is_1(void)
 /* A short PSW needs to have bit 12 set to be valid. */
 static int short_psw_bit_12_is_0(void)
 {
-	struct psw invalid = {
-		.mask = BIT(63 - 12),
-		.addr = 0x00000000deadbeee
-	};
+	struct psw invalid = PSW(BIT(63 - 12), 0x00000000deadbeee);
 	struct short_psw short_invalid = {
 		.mask = 0x0,
 		.addr = 0xdeadbeee
-- 
2.39.2

