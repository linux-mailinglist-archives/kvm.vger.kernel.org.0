Return-Path: <kvm+bounces-1473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9C57E7CB7
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DF5C1C204BF
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F363B23750;
	Fri, 10 Nov 2023 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bzPhXB2b"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7F31DFFE
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:40 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA2F3821D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:39 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADquU5018748;
	Fri, 10 Nov 2023 13:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=cVf06QYK2Q9dGfJhMgTuIUAR0j/8x0C9cN7vYrng+WU=;
 b=bzPhXB2bnFXxatFkMMldNlIdK+qk48Amt5xaAR9kRmCQQvCoZCvq7yR0t6Z/WNC2Jhdx
 BFBdK+Pcygt/CNOvIA84p3nhX77gv3/sNsOXhDSO5YFK7stcWqbLqxDz9lsmaBWcJRvz
 EfNdyu961kWG70mrPoQCqyFOem8VvVMGZF0j4qqHWJf5RUU3d85PNs8t1v8i4wG64ZCf
 +AgtKaPrZw/epPNyfgUWSHz6cwWBZzGdxKRJ3xMOieMsEOJ8yC/cEEBW6IV+RGnxhPsz
 SMj/gnx5rQYclqTdV8KU1t2Dc7QIkHU7LmXPBjknSSYMlY3nDw8VCepnJPTYWh2+i2Tl 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nsjr1e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:36 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADsR3a022935;
	Fri, 10 Nov 2023 13:54:36 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nsjr1cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:36 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB7js2014325;
	Fri, 10 Nov 2023 13:54:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7x9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:34 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsVAJ19923592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA74920043;
	Fri, 10 Nov 2023 13:54:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1309C20040;
	Fri, 10 Nov 2023 13:54:30 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:29 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 14/26] s390x: topology: Refine stsi header test
Date: Fri, 10 Nov 2023 14:52:23 +0100
Message-ID: <20231110135348.245156-15-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o6QhvyQZc0An5SXuutfP2p0nsrWXL5DI
X-Proofpoint-ORIG-GUID: 7SzTE_m0wW4LP55g2hS0jrIZleQl-xEo
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Add checks for length field.
Also minor refactor.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20231030160349.458764-7-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/topology.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 03bc3d3..6a5f100 100644
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


