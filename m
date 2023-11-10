Return-Path: <kvm+bounces-1467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4A77E7CB0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B7DB1C2099B
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E021DA45;
	Fri, 10 Nov 2023 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d+b19awo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BB81B290
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:33 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50B338221
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:31 -0800 (PST)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADnjfg014912;
	Fri, 10 Nov 2023 13:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=5re8vL1wcJ6n+39+kO8kJVf94EXNT2Pz6AA0pVTMI40=;
 b=d+b19awotB0cuQHQ8Fpe1NehHjFlkqjrvlP7RqIEUIKguUSrDabRNK7BY3jJDULPOo95
 zCYuOq81V+gM1m0O8yw9hwtrmJ01ltbIsdXdpzh7c2O4keNyP5NbIXh1RW30Zr5zrvGO
 lP/a/LlwfNlLXz64UXBMCPaDHscwSmO4bcZRUZtxYgEoOogrwwqYTWpQW9iI+lSLGs+8
 tERQ+9Gt4Iw8YAD4/SdE608Q5t06T5utabNbCZZgCvjAxJxZ19zDCPZvcAn2jPmgRYVF
 MZ4xRNQImtSY5aoBlvY/XGsgH95SrLFqPI/CUM/ZFpDOXvfEEFxVrFV53DXJ3EBY7+v1 sw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nrag5a7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:29 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADnja9014907;
	Fri, 10 Nov 2023 13:54:29 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nrag59g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:28 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB3vBG019224;
	Fri, 10 Nov 2023 13:54:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w24b6fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsPZm5112542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 369C420040;
	Fri, 10 Nov 2023 13:54:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 771C42004F;
	Fri, 10 Nov 2023 13:54:23 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:23 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 11/26] s390x: topology: Use function parameter in stsi_get_sysib
Date: Fri, 10 Nov 2023 14:52:20 +0100
Message-ID: <20231110135348.245156-12-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TOyXd3IjR-KZ3xp1CNVnxEzQH3Z-WnD8
X-Proofpoint-ORIG-GUID: 1LqiIp-CeOexL1mwedwSI1sKVLXaRKXP
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=805 phishscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Actually use the function parameter we're give instead of a hardcoded
access to the static variable pagebuf.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20231030160349.458764-4-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 1c4a86f..032e80d 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -324,7 +324,7 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 
 	report_prefix_pushf("SYSIB");
 
-	ret = stsi(pagebuf, 15, 1, sel2);
+	ret = stsi(info, 15, 1, sel2);
 
 	if (max_nested_lvl >= sel2) {
 		report(!ret, "Valid instruction");
-- 
2.41.0


