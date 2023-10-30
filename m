Return-Path: <kvm+bounces-85-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BD67DBD70
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03FA7B20F94
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BC5199DD;
	Mon, 30 Oct 2023 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FcfPYZkh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD85D19457
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:12 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FB8DF;
	Mon, 30 Oct 2023 09:04:09 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFGK1j028262;
	Mon, 30 Oct 2023 16:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Kaz1ZAB6nK3IbptVY/pEWTU37xKrHWxpq8e63wCzV4I=;
 b=FcfPYZkhDvNo2T8ZxJuZcY5gjRd20JYZvRiOzBmwLhAO0zf3SEOjQbTQVruc0XRItvNa
 hovVnVMae2HTHTeCE22pginJQYTJOdTM2YqrHlJ30hrOq1FrX6vhs/5HJag6k3q7ZNO7
 kweW6sc/zKaxGaLLqkI2Sl9m0gND8jnqbHFWN3Nmc3zGb2WlIuNYP8DeCa6UTh6EY54E
 k9TWVSzkv9zrilr/6pUtdf3faYq9e+aSY7HJOaQaHoBCHSUBrcxf3IWH77/BBd4ZQKZQ
 7esHy472q0tJIIGNIiPws4rrlxR4ubuUcQ3sfbYvky2lMKPp3X1uBjz7WchXxlFX34Te iw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2escsv1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:59 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFgdfR031699;
	Mon, 30 Oct 2023 16:03:58 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2escsv01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:58 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UEWUq3007734;
	Mon, 30 Oct 2023 16:03:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1dmna5gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3re124642150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7621620040;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 428F420043;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>, linux-s390@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v3 07/10] s390x: topology: Rename topology_core to topology_cpu
Date: Mon, 30 Oct 2023 17:03:46 +0100
Message-Id: <20231030160349.458764-8-nsg@linux.ibm.com>
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
X-Proofpoint-GUID: TR_5AZP8Ds-NAdMe-yGRbVNxamE4x0GW
X-Proofpoint-ORIG-GUID: y6Rw0E7K0R4Flf8McS_pRR0B81ZrW_79
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300124

This is more in line with the nomenclature in the PoP.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/stsi.h | 4 ++--
 s390x/topology.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 2f6182c1..1e9d0958 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -30,7 +30,7 @@ struct sysinfo_3_2_2 {
 };
 
 #define CPUS_TLE_RES_BITS 0x00fffffff8000000UL
-struct topology_core {
+struct topology_cpu {
 	uint8_t nl;
 	uint8_t reserved1[3];
 	uint8_t reserved4:5;
@@ -61,7 +61,7 @@ struct topology_container {
 
 union topology_entry {
 	uint8_t nl;
-	struct topology_core cpu;
+	struct topology_cpu cpu;
 	struct topology_container container;
 };
 
diff --git a/s390x/topology.c b/s390x/topology.c
index 6a5f100e..df158aef 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -247,7 +247,7 @@ done:
 static uint8_t *check_tle(void *tc)
 {
 	struct topology_container *container = tc;
-	struct topology_core *cpus;
+	struct topology_cpu *cpus;
 	int n;
 
 	if (container->nl) {
-- 
2.41.0


