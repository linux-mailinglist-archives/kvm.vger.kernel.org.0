Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230DC7C4E34
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 11:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjJKJIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 05:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjJKJIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 05:08:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89577113;
        Wed, 11 Oct 2023 02:01:59 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8lRQi026639;
        Wed, 11 Oct 2023 08:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BJiQMTRGCzVtbvem4GS+Xox6z6I4L2SDaYeys7zuxzk=;
 b=n8CDk3WgDleoj69vSN/CL9lbTukost/DsW5pJFNl+2TjKX8BMJ4969vXfL7PgLP52ZUI
 IF2Qkc66cvbu4JTyvb1138RyAmiBAVL990cvn31G/s/rQ+EATLOJBA6ytUVksD0oUr5O
 M5LWON4hQL4BgZbegPvBbfkadYVWmilh9Bg1KI5uVOpQveI5AmxBaiLLEmOWicjpaY/m
 F5BJN9LqF4pR6W+Beqa20xKqHUl464w++gORBBUSghGxkrI3xEsjRrmSuRRO7kQ5DpSj
 Dq9x6KB1DzVrYQe1x2X0OkmkTX/Yf6Y3qg0lUMfRJVL5K2x1zM+7H+ghMb9KuEdojaeo 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrgg0ac2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:47 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39B8mMO4030164;
        Wed, 11 Oct 2023 08:56:47 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrgg0aba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:47 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8jGmn000693;
        Wed, 11 Oct 2023 08:56:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkk5kpp4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39B8ug3222020616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 08:56:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 460E42004B;
        Wed, 11 Oct 2023 08:56:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F31D20043;
        Wed, 11 Oct 2023 08:56:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 08:56:42 +0000 (GMT)
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
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [kvm-unit-tests PATCH 5/9] s390x: topology: Refine stsi header test
Date:   Wed, 11 Oct 2023 10:56:28 +0200
Message-Id: <20231011085635.1996346-6-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231011085635.1996346-1-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gX_Hf3xWkwJ4uunxh_Vfze3Bujgj5Xw2
X-Proofpoint-GUID: r29D9RcrQjsfS3Ou3-Mzw7rgtpdw_TOI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_06,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add checks for length field.
Also minor refactor.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 5374582f..0ba57986 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -187,18 +187,22 @@ static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
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
 
+	report(IS_ALIGNED(info->length, 8), "Length %d multiple of 8", info->length);
+	report(info->length < PAGE_SIZE, "Length %d in bounds", info->length);
+	report(sel2 == info->mnest, "Valid mnest");
 	stsi_check_maxcpus(info);
 
 	/*
@@ -326,7 +330,6 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 
 	if (max_nested_lvl >= sel2) {
 		report(!ret, "Valid instruction");
-		report(sel2 == info->mnest, "Valid mnest");
 	} else {
 		report(ret, "Invalid instruction");
 	}
@@ -365,7 +368,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
 		goto vertical;
 	}
 
-	stsi_check_mag(info);
+	stsi_check_header(info, sel2);
 	stsi_check_tle_coherency(info);
 
 vertical:
@@ -378,7 +381,7 @@ vertical:
 		goto end;
 	}
 
-	stsi_check_mag(info);
+	stsi_check_header(info, sel2);
 	stsi_check_tle_coherency(info);
 	report_prefix_pop();
 
-- 
2.41.0

