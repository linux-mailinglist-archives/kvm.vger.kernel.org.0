Return-Path: <kvm+bounces-76-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACB47DBD63
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16DFAB20E9B
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF1018C23;
	Mon, 30 Oct 2023 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JEQHlPPw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E941C8D2
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:03 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C375FDB;
	Mon, 30 Oct 2023 09:04:01 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFWgc0000937;
	Mon, 30 Oct 2023 16:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=T7bKmjCxT/flSwqFMf476Xcj0BMGu3w3JNB8reTFC8w=;
 b=JEQHlPPwxqn+laAgDPRhpoCKdr5fBD7e4RX4E3NPo4JfJCRbtwb3ayB5chs3JZV/QkEC
 GbOGUIHphrP2mqjxFGEOeqd9GswQuwpy5uePValkPuI/lbyYkXn1Gon7Os3ucTCOtsd0
 AT1iDdhmAJQcgbuz6rxqv6EGuU7/uCwYnOIBWQSxr7jr/irmTbwpXyrwy2N/4l08LGZ/
 EokeRR6lf0lkAqHMy4VetGJewVxXEt2QuBA/M5AGRhiwgUTGiNF9v0SloxshsLuoPGqS
 ywLNseZwAKNgWmm5F+dPWt1LJKwBBz0B77LXkJMKgvejm7MKHqWJ87isbVkMspb2feUe Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2f7dh6q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:56 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UG01M9032036;
	Mon, 30 Oct 2023 16:03:55 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2f7dh6ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:55 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFsvag011280;
	Mon, 30 Oct 2023 16:03:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eujsryb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3pt126411444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D59F520040;
	Mon, 30 Oct 2023 16:03:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AAC032004B;
	Mon, 30 Oct 2023 16:03:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:51 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 01/10] s390x: topology: Introduce enums for polarization & cpu type
Date: Mon, 30 Oct 2023 17:03:40 +0100
Message-Id: <20231030160349.458764-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231030160349.458764-1-nsg@linux.ibm.com>
References: <20231030160349.458764-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CYkGpUKabxzfDWanoMdCkM34_UlSfoAg
X-Proofpoint-ORIG-GUID: NFvWbr8-Wbwr7UOqkGEIJCRoNg_CKVEv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300124

Thereby get rid of magic values.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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


