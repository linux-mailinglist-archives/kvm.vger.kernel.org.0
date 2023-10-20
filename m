Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE9A7D11F4
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377605AbjJTO5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 10:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377598AbjJTO5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 10:57:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E777D66;
        Fri, 20 Oct 2023 07:57:36 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KEvF88009684;
        Fri, 20 Oct 2023 14:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dttwXisVRQW6VzItWqEiNWuRVXRaQhE+f7ItKyxseDU=;
 b=Z2PlJBgL247MDuApmoIeMNI1p/pHQEEFeR6E7yWdfl/wRGZnQ1vDjovu1JE4mkAzBSxf
 3fMKPzzIX3NurceLy5ThdmD7cUE+j6YwJ8LKhqEGNEV8i/e5K1uxseqndAiuF7s+2zDu
 nd0j/zRKGbgjouVWPNMLq5VKPFvVRFg8wUWRoVztmo6PGFywrjXdE8zTMAvuyUvekxMD
 NoZB3dZ3g0dmvv08GwSEVHKTalb0FEKvt6JcE6kz3T/+3bDWXFvvdHy9wpGuVv6pwsDo
 y9obfRzsFKVG8OQ4EAo5aaFgEUNK+bAtFMAOPaoibvkbpMo5Y4csUxFa4LOI98fDwYui FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuus0g002-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:57:25 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KElltR006936;
        Fri, 20 Oct 2023 14:50:11 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuum787wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:50:05 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KC8YGj029813;
        Fri, 20 Oct 2023 14:49:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tuc47n67f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn5b416646848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E70C20040;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 355CA20043;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH 05/10] s390x: topology: Make some report messages unique
Date:   Fri, 20 Oct 2023 16:48:55 +0200
Message-Id: <20231020144900.2213398-6-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J0a7Z3LHGNVHhkIF9cZ_9LjfADaoea4Y
X-Proofpoint-ORIG-GUID: OKakRvNBPpQ_lDIL4XUzboBuwLTV6ywa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index c8ad4bcb..03bc3d3b 100644
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

