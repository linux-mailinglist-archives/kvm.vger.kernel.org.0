Return-Path: <kvm+bounces-1466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A5B7E7CB1
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4FF4B214F4
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6B41D54F;
	Fri, 10 Nov 2023 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gx+se9Zj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070731B27B
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:33 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A99038222
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:32 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADgJE9019290;
	Fri, 10 Nov 2023 13:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=W4FXWD14CBCeGz7nGDTtjhDRtlyr08DItxOsiaLHaAA=;
 b=Gx+se9Zj3/0YHtXckLG7EEvmaGMf/WFDwLfLTugV+BJBn9w9V6rbVn33zgBrcB0SYfTl
 jzgEfNzM8+72QeGj/Jq5Yc3tkf19xJah0fOeO2hHBLEScSdBaZAyqcRwiEic6O5JVfQX
 PHK0HxewoxkkUswRLs9H8VJnfYwUfmcTrm9rOcZnRIyIRwffdKtukgwctBJ0JYT/8gLx
 HOt7NCfgk6Pn4msq5NOktUCwqnPNviap6iwpvkfiYSTIe7ZrsAP0hNHDFEReMw4c8Jsu
 dxYXN6OlYeZyhejYQDZD+cZPdIf0Iu8cuNtvp+WsoqwtWMhFFQK7sp2dnz1nEB1OUywf KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9rmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:28 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADj2ls003358;
	Fri, 10 Nov 2023 13:54:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9rkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:27 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AABJBIw000675;
	Fri, 10 Nov 2023 13:54:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w23b7dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:26 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsMfD16319136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D29C02004B;
	Fri, 10 Nov 2023 13:54:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E6B220043;
	Fri, 10 Nov 2023 13:54:21 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:20 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 09/26] s390x: topology: Introduce enums for polarization & cpu type
Date: Fri, 10 Nov 2023 14:52:18 +0100
Message-ID: <20231110135348.245156-10-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x0YeYKKP_vhp_gvBDBkmG5WzTrNvQazH
X-Proofpoint-GUID: lcEtxpsG6wdYo5NbGGYdGjdk8P-w5CE_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Thereby get rid of magic values.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20231030160349.458764-2-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/stsi.h | 11 +++++++++++
 s390x/topology.c |  6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 1351a6f..2f6182c 100644
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
index 6955823..6ab8c8d 100644
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


