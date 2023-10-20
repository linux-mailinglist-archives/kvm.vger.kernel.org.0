Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2F97D11CD
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 16:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377554AbjJTOtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 10:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377239AbjJTOtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 10:49:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868B6CF;
        Fri, 20 Oct 2023 07:49:20 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KEiUKN017421;
        Fri, 20 Oct 2023 14:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FBU0jEH+CVW+vsZZRGYN0d0LaP3FyhG2Nym9IxQsdNU=;
 b=j1AxkgxV0op6c1g2lRDkzTba6oYgouy/4CkDXmYpTUPyOCwAOeAuoJm0LpzwfrNOmz1i
 ZbOg7W+N4vU5j7+mEN1654XlXceptuzLMLo6x+qr9C1/qFjXi8kc+26tM2ahp9BCbwi3
 2tYxgfJSEZaD1HYNz0MpGA4op3LbIgVR9vOctMpm5KucKV0fE7df6Vib92fS5jKeNjXF
 rTEs+m1fOheb4SV3xotMojHl1rlg0CgIR6OV9axU06XpuIG0+HpUvYk5ph61JLvXl7T5
 7ICMp3IdUU2dm6h3TN3qE1X06HucGIZz6y1Xq6+j2ILUGqR4p3hL5wLNET1EoHzdzeND Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuuk086n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:08 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KEixD1019370;
        Fri, 20 Oct 2023 14:49:08 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuuk086mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:08 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KCLSNB029895;
        Fri, 20 Oct 2023 14:49:07 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tuc47n67e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:07 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn47Y25494154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13E9320040;
        Fri, 20 Oct 2023 14:49:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD3A720043;
        Fri, 20 Oct 2023 14:49:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:03 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        linux-s390@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 01/10] s390x: topology: Introduce enums for polarization & cpu type
Date:   Fri, 20 Oct 2023 16:48:51 +0200
Message-Id: <20231020144900.2213398-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UBY9aPhk0Ju7FnjBelXIEmat90q1AOCK
X-Proofpoint-ORIG-GUID: 6zk7NlwVBMCK-YxdXD85tnbentjUakDn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thereby get rid of magic values.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/stsi.h | 11 +++++++++++
 s390x/topology.c |  6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 1351a6f3..2f6182c1 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -41,6 +41,17 @@ struct topology_core {
 	uint64_t mask;
 };
 
+enum topology_polarization {
+	POLARIZATION_HORIZONTAL = 0,
+	POLARIZATION_VERTICAL_LOW = 1,
+	POLARIZATION_VERTICAL_MEDIUM = 2,
+	POLARIZATION_VERTICAL_HIGH = 3,
+};
+
+enum cpu_type {
+	CPU_TYPE_IFL = 3,
+};
+
 #define CONTAINER_TLE_RES_BITS 0x00ffffffffffff00UL
 struct topology_container {
 	uint8_t nl;
diff --git a/s390x/topology.c b/s390x/topology.c
index 69558236..6ab8c8d4 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -261,7 +261,7 @@ static uint8_t *check_tle(void *tc)
 	report(!(*(uint64_t *)tc & CPUS_TLE_RES_BITS), "reserved bits %016lx",
 	       *(uint64_t *)tc & CPUS_TLE_RES_BITS);
 
-	report(cpus->type == 0x03, "type IFL");
+	report(cpus->type == CPU_TYPE_IFL, "type IFL");
 
 	report_info("origin: %d", cpus->origin);
 	report_info("mask: %016lx", cpus->mask);
@@ -275,7 +275,9 @@ static uint8_t *check_tle(void *tc)
 	if (!cpus->d)
 		report_skip("Not dedicated");
 	else
-		report(cpus->pp == 3 || cpus->pp == 0, "Dedicated CPUs are either vertically polarized or have high entitlement");
+		report(cpus->pp == POLARIZATION_VERTICAL_HIGH ||
+		       cpus->pp == POLARIZATION_HORIZONTAL,
+		       "Dedicated CPUs are either vertically polarized or have high entitlement");
 
 	return tc + sizeof(*cpus);
 }
-- 
2.41.0

