Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB57D11F8
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 16:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377629AbjJTO6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 10:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377620AbjJTO6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 10:58:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106D7D46;
        Fri, 20 Oct 2023 07:58:20 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KEvF9K009684;
        Fri, 20 Oct 2023 14:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H1oIdVhw4GTc1pze6YXGuHLOiPcpY3V7hJUZ/hOL9G0=;
 b=JM0SQ14oxPp6MPfQNehVQaTiVQVj/e8QHIiuxkdOwppmCQWk1nnFZiHX3keCTgEgrDea
 XgUbRbWYn7Shwxb9xZoINHSZHGigj3MDIZL+eTc60NciSiiPAsbzrifY2+/pCefnGB4M
 DMRAwHdZq1xEyfLvSQQzyvcfg05yEfJB2ZnxXm03DPBtfCN5wtxDvWOTpgR3K841++Vv
 3YFlOhE6+o3L9LJQNpuwfRz3LT9w9U/uZqqItp4PbjgHyihBCREx3mQ2FNP36j+M+JNf
 zJJWOtp7VBKTsKvWXbgClNEy2tPZjgGAMgS7irMvpHUp1EcvDHyNBWV+YM63lmp8M5Z6 xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuus0g002-68
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:58:08 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KElltU006936;
        Fri, 20 Oct 2023 14:50:14 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuum787xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:50:12 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KC94sY032108;
        Fri, 20 Oct 2023 14:49:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tuc35n6gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn5rs16646850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA5B620040;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 810FF20043;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Shaoqin Huang <shahuang@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 06/10] s390x: topology: Refine stsi header test
Date:   Fri, 20 Oct 2023 16:48:56 +0200
Message-Id: <20231020144900.2213398-7-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i8FppOVT79tGnsHud1gkTWMDEHJZ2KAj
X-Proofpoint-ORIG-GUID: wQ5dn4RwMgIApBGIE77ZTim1U3Xb0viV
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

Add checks for length field.
Also minor refactor.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 03bc3d3b..6a5f100e 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -187,18 +187,23 @@ static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
 }
 
 /*
- * stsi_check_mag
+ * stsi_check_header
  * @info: Pointer to the stsi information
+ * @sel2: stsi selector 2 value
  *
  * MAG field should match the architecture defined containers
  * when MNEST as returned by SCLP matches MNEST of the SYSIB.
  */
-static void stsi_check_mag(struct sysinfo_15_1_x *info)
+static void stsi_check_header(struct sysinfo_15_1_x *info, int sel2)
 {
 	int i;
 
-	report_prefix_push("MAG");
+	report_prefix_push("Header");
 
+	/* Header is 16 bytes, each TLE 8 or 16, therefore alignment must be 8 at least */
+	report(IS_ALIGNED(info->length, 8), "Length %d multiple of 8", info->length);
+	report(info->length < PAGE_SIZE, "Length %d in bounds", info->length);
+	report(sel2 == info->mnest, "Valid mnest");
 	stsi_check_maxcpus(info);
 
 	/*
@@ -328,7 +333,6 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 
 	if (max_nested_lvl >= sel2) {
 		report(!ret, "Valid instruction");
-		report(sel2 == info->mnest, "Valid mnest");
 	} else {
 		report(ret, "Invalid instruction");
 	}
@@ -367,7 +371,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
 		goto vertical;
 	}
 
-	stsi_check_mag(info);
+	stsi_check_header(info, sel2);
 	stsi_check_tle_coherency(info);
 
 vertical:
@@ -380,7 +384,7 @@ vertical:
 		goto end;
 	}
 
-	stsi_check_mag(info);
+	stsi_check_header(info, sel2);
 	stsi_check_tle_coherency(info);
 	report_prefix_pop();
 
-- 
2.41.0

