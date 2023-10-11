Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8597C4DC3
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345615AbjJKI47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjJKI45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:56:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C5AA7;
        Wed, 11 Oct 2023 01:56:56 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8npxW020773;
        Wed, 11 Oct 2023 08:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iQkY72E/ULAP0jO9xOJa81ucrv5Bd02sKU6uZ8jdksY=;
 b=CDzrbLqqHLpNYM138wZz/l1KUXHFC+rzTJCXj2IGnk8iVeTGu2E3rKfrjOEylukNbA2H
 78aiI+U9uOhrLJxVRevG39c8WuIvNDbm6HYcesAWhoNI6Uk0/yU1CRKYdbdvC4gMXDcY
 sKahwOwX+VDrC4vtRinaaqxWEzuC0Q9t6vo9B+YPn5ZPZwzfnBD9HJKSuOe3+mA33MAS
 geViWi29EjpziyCKEptMuIdd0KQsra8DOj0h+Fe9tUaSv8HHZO+IW7PKzaXlrw5FjUzD
 xskJjXLuURCrYxMMs9HwsUXdFeovNKIBiniUCRMGBY1oLCAFKbthKfUBHEU5t0BVMswn 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrhng9k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:45 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39B8oZWQ022907;
        Wed, 11 Oct 2023 08:56:45 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrhng9jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:45 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B7InYJ024465;
        Wed, 11 Oct 2023 08:56:44 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkhnsq6pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39B8ufnK11928126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 08:56:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A489F20043;
        Wed, 11 Oct 2023 08:56:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DAC820040;
        Wed, 11 Oct 2023 08:56:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 08:56:41 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Subject: [kvm-unit-tests PATCH 4/9] s390x: topology: Don't use non unique message
Date:   Wed, 11 Oct 2023 10:56:27 +0200
Message-Id: <20231011085635.1996346-5-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231011085635.1996346-1-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bMfkiFZNjYYr4hOviTJblzPuK-9Yoraf
X-Proofpoint-GUID: uCv95cGAf0i4oTwCE6WwleAi1j-StHnz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_06,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we test something, i.e. do a report() we want unique messages,
otherwise, from the test output, it will appear as if the same test was
run multiple times, possible with different PASS/FAIL values.

Convert some reports that don't actually test anything topology specific
into asserts.
Refine the report message for others.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 49d6dfeb..5374582f 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -114,7 +114,7 @@ static void check_polarization_change(void)
 	report_prefix_push("Polarization change");
 
 	/* We expect a clean state through reset */
-	report(diag308_load_reset(1), "load normal reset done");
+	assert(diag308_load_reset(1));
 
 	/*
 	 * Set vertical polarization to verify that RESET sets
@@ -123,7 +123,7 @@ static void check_polarization_change(void)
 	cc = ptf(PTF_REQ_VERTICAL, &rc);
 	report(cc == 0, "Set vertical polarization.");
 
-	report(diag308_load_reset(1), "load normal reset done");
+	assert(diag308_load_reset(1));
 
 	cc = ptf(PTF_CHECK, &rc);
 	report(cc == 0, "Reset should clear topology report");
@@ -137,25 +137,25 @@ static void check_polarization_change(void)
 	report(cc == 0, "Change to vertical");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 1, "Should report");
+	report(cc == 1, "Should report change after horizontal -> vertical");
 
 	cc = ptf(PTF_REQ_VERTICAL, &rc);
 	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to vertical");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 0, "Should not report");
+	report(cc == 0, "Should not report change after vertical -> vertical");
 
 	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
 	report(cc == 0, "Change to horizontal");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 1, "Should Report");
+	report(cc == 1, "Should report change after vertical -> horizontal");
 
 	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
 	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to horizontal");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 0, "Should not report");
+	report(cc == 0, "Should not report change after horizontal -> horizontal");
 
 	report_prefix_pop();
 }
-- 
2.41.0

