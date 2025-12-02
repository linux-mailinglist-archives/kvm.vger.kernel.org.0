Return-Path: <kvm+bounces-65108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FCE5C9B842
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 13:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A13003A7786
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 12:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB57F3126BD;
	Tue,  2 Dec 2025 12:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XLGwtjBy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8A296BA5
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 12:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764679644; cv=none; b=h6OFn3nmfMC5/bfOcNx7YlbS65xOS/uf9In9S2ec2HbmyLoGEAL8xfX8dDtj0xgwRbJeBRJA2pCgnoABrBmDg0f2qpml9EVzbvIj3naDDWWovNWiOr/HcAoNxcE4IKzUpdSMBw8YsPjPl0Dxq4W9AFeqc0LpXNWyVWsKJTJSCe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764679644; c=relaxed/simple;
	bh=DT1ToHuDNVULFKa4vDr8BYgxYdyWZDASbxGuKFU70vE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sl/R/7WQP047eeQV2+RxzOK7y71mVY8L21vIhNJzPZufhGgD0LrFFLCkfO9q8gEwu42Se5fD9Hcnep29OYVtSSE/R/cMvo3yYnA+3gSrS5xwkkIcOm+dTOfNgiN0/D1QG+LgSbjWJrx5o7j1Zc36TPGbxuQcNZCrMerOAAbHl98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XLGwtjBy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B276Wqt003477;
	Tue, 2 Dec 2025 12:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Nca2PDXNMoThjVSDGpDenLhX9VKM+EG8idiA9366O
	3c=; b=XLGwtjByvRL4k9h1dIo721PzuiusWIgDHW5bVIudin+sJ/hUGpcZt8jKP
	D5yEFQ+0FZxzkG7EBYyDfcR/1JU61H/qZZIHC2LY1LSKhtBrIw49yYdC23elYSXD
	27hr54EyTnN6fAGbGk5/svSxPSsMfky7VPLrm3Jvfc87BA61EpP+wuKPILz18JNo
	eoj1CBhR4TZvl0S1vDMpEck0/sQihFYSxf07425+GwT+XpMcy0iAjcASttgBtgA+
	twDYU97aSX5XulwzrIUrNuxydCgTThWcgFaIHWyuR5BwA2hsyhOBRhE1rWxl+EiG
	owQuV420sgBbQaA5QqEuz5Lc2Oqnw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrj9myr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 12:47:12 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5B2CjZvj015003;
	Tue, 2 Dec 2025 12:47:12 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrj9myr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 12:47:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B2B2jIa008558;
	Tue, 2 Dec 2025 12:47:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4arc5mvbhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 12:47:11 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B2Cl72G16515534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Dec 2025 12:47:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AEBC20040;
	Tue,  2 Dec 2025 12:47:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B8EB2004B;
	Tue,  2 Dec 2025 12:47:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.43.70.76])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Dec 2025 12:47:03 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: npiggin@gmail.com, harshpb@linux.ibm.com, rathc@linux.ibm.com,
        pbonzini@redhat.com, sjitindarsingh@gmail.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH] target/ppc/kvm : Use macro names instead of hardcoded constants as return values
Date: Tue,  2 Dec 2025 18:16:52 +0530
Message-ID: <20251202124654.11481-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UCdXh0DoEy6l5r23AgGQehQLXOWuQkoP
X-Proofpoint-ORIG-GUID: gL-zHsFowwA5FiMpCnFNXBFbRWfuOXOI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyMCBTYWx0ZWRfX3EC8Vr/RSQwI
 H+/ZwmFSWh5eJMplLfqOGAalj7rEdmoHO93BGkX/W58ZUOvYeRQVH3Sna9FA9z6Y/l0IaEOIPeH
 fNreBhIklO+oDgYQL/483MPYoXdeIXPN/y6O7TBfwrXDrzU6FXGG8NFRunecrZMgxCsGpwTlSkP
 a8gIOKJrznBGyqIUIr+pRS41XB/4b7yDPT4zuxD7z6GF3dVHbSPXHtRcAOsj9QbtmPz6LRFp1No
 /7P0jbLGZYlOs7DbZtVgARGY2cswvAUMNd+Kk8YAbKsFsqn3+pQhrZ5C5YmZVf+hQ1BefiXsnyD
 mskMB//tAFBgmM4Rd9rqHG8/n8Fb2SlzdrmNrhLc0OTYVHBL8q41jDp+5RtxtIXAuUEHQsPXpDA
 0gGhDtOZx2FTH0jQ+Bn8UhyeROXpng==
X-Authority-Analysis: v=2.4 cv=dYGNHHXe c=1 sm=1 tr=0 ts=692edfd0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=TXOZxh5LdWKoDwPKVd0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511290020

In the parse_* functions used to parse the return values of
KVM_PPC_GET_CPU_CHAR ioctl, the return values are hardcoded as numbers.
Use the macro names for better readability. No functional change
intended.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 target/ppc/kvm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 43124bf1c7..464240d911 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2450,26 +2450,26 @@ static int parse_cap_ppc_safe_cache(struct kvm_ppc_cpu_char c)
     bool l1d_thread_priv_req = !kvmppc_power8_host();
 
     if (~c.behaviour & c.behaviour_mask & H_CPU_BEHAV_L1D_FLUSH_PR) {
-        return 2;
+        return SPAPR_CAP_FIXED;
     } else if ((!l1d_thread_priv_req ||
                 c.character & c.character_mask & H_CPU_CHAR_L1D_THREAD_PRIV) &&
                (c.character & c.character_mask
                 & (H_CPU_CHAR_L1D_FLUSH_ORI30 | H_CPU_CHAR_L1D_FLUSH_TRIG2))) {
-        return 1;
+        return SPAPR_CAP_WORKAROUND;
     }
 
-    return 0;
+    return SPAPR_CAP_BROKEN;
 }
 
 static int parse_cap_ppc_safe_bounds_check(struct kvm_ppc_cpu_char c)
 {
     if (~c.behaviour & c.behaviour_mask & H_CPU_BEHAV_BNDS_CHK_SPEC_BAR) {
-        return 2;
+        return SPAPR_CAP_FIXED;
     } else if (c.character & c.character_mask & H_CPU_CHAR_SPEC_BAR_ORI31) {
-        return 1;
+        return SPAPR_CAP_WORKAROUND;
     }
 
-    return 0;
+    return SPAPR_CAP_BROKEN;
 }
 
 static int parse_cap_ppc_safe_indirect_branch(struct kvm_ppc_cpu_char c)
@@ -2486,15 +2486,15 @@ static int parse_cap_ppc_safe_indirect_branch(struct kvm_ppc_cpu_char c)
         return SPAPR_CAP_FIXED_IBS;
     }
 
-    return 0;
+    return SPAPR_CAP_BROKEN;
 }
 
 static int parse_cap_ppc_count_cache_flush_assist(struct kvm_ppc_cpu_char c)
 {
     if (c.character & c.character_mask & H_CPU_CHAR_BCCTR_FLUSH_ASSIST) {
-        return 1;
+        return SPAPR_CAP_WORKAROUND;
     }
-    return 0;
+    return SPAPR_CAP_BROKEN;
 }
 
 bool kvmppc_has_cap_xive(void)
-- 
2.51.1


