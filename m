Return-Path: <kvm+bounces-1475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A75FE7E7CBA
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11305B212FC
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558E9347DF;
	Fri, 10 Nov 2023 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RLP1sgvT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D6C208D0
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:41 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C689D3821E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:40 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADHk9x018462;
	Fri, 10 Nov 2023 13:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=1Xj4xbcc3bKIui5x+xGz3QgQlvzMDuYX7Kap45pl74M=;
 b=RLP1sgvTiBjViXMcUKOO2mGj+yZbmjBdWVyQXkVCA9pbJ5Jf/pvJvq5VO0/RZJ8UClXL
 O149zOCzACltDbXrArfGU111KmHUZT2VQCAyB024zS2U5y4gzUBsuWmK1OqHrfLZ9tf5
 bwVYhRwMGVmQ7tEVxF1QLxu98fuA1l1gTLJkeKqdUOL/3JYt5YsWGtAJDSQYKRYaL3qb
 wN/t+WPbCj6u+rWMsVwQCJ5oKyxJFg4XuFkg5hswjmSNCHxMJraeJN9TAbH4mxoIE0ur
 1bpsdHVdov7KqUcql4sZQUF79lgeKb22MzwssIDVV3u/ENE7Z1ouakxUm7uCU4ODlWTg Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n97s77v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:38 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADJmph028350;
	Fri, 10 Nov 2023 13:54:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n97s778-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:37 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AABGMkw004144;
	Fri, 10 Nov 2023 13:54:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w21b79q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsYUH13107758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32B3B20043;
	Fri, 10 Nov 2023 13:54:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4363A20040;
	Fri, 10 Nov 2023 13:54:32 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:32 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 15/26] s390x: topology: Rename topology_core to topology_cpu
Date: Fri, 10 Nov 2023 14:52:24 +0100
Message-ID: <20231110135348.245156-16-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lRG_7G9AeOu9JdCpNlZhXNxvw3Prjnh1
X-Proofpoint-GUID: xOutU8eRiOIheaEp6_1xLZoGS4wB5fLI
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 spamscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

This is more in line with the nomenclature in the PoP.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20231030160349.458764-8-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/stsi.h | 4 ++--
 s390x/topology.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 2f6182c..1e9d095 100644
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
index 6a5f100..df158ae 100644
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


