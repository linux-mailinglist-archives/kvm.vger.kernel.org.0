Return-Path: <kvm+bounces-1471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 231BA7E7CB5
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8D44B216F0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B80208A8;
	Fri, 10 Nov 2023 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DdO3zGJI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E961DFC3
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:38 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC87B3821F
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:36 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADcTDX019708;
	Fri, 10 Nov 2023 13:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=BCJuUFFmK7x5BcRlcu6r5h3eAUfECslHDot8LF1fDmY=;
 b=DdO3zGJIWc0I1dVJQWX0+mLUr4fcRDfwLQeubUiLMtXSRVNGSDZWRmEokc4sW07WxIvs
 YR8OdKzWHUtpwReHZ4cp5tv8FIFWlNlifaNCJqx3foC+CRfdIXLFfl9XO5aucafSNWBp
 lG65jfU7E4CaN07fTGSxqzQT2ACTDe2ADBoeDCgl5uPjPk0t7FeHfVWJXJfsWf90Ls+8
 7r3dEZzg5/ODkhVcbkYz+Q84/98sQZPHoq5R22eEiK0hm0t3Ud+L9BU7OPbA5LhcbPRb
 XXaWQo0vPF9fRWI6+k5CiuV/l/i3V+MWqgdRJBPToqgIHG+FJq+fRFsaiqVYY1YEs1La 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n9790n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:34 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADI4VI009469;
	Fri, 10 Nov 2023 13:54:34 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n9790mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:33 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADcWJJ004183;
	Fri, 10 Nov 2023 13:54:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w21b79b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsTEg21627402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADFBF2004B;
	Fri, 10 Nov 2023 13:54:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A59A920043;
	Fri, 10 Nov 2023 13:54:27 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:27 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 13/26] s390x: topology: Make some report messages unique
Date: Fri, 10 Nov 2023 14:52:22 +0100
Message-ID: <20231110135348.245156-14-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6Y6hpORStfHPIATp_GDffyJ3vam9FQsG
X-Proofpoint-ORIG-GUID: LoOfp7OPaqNBZml_Kndl7OyLSD0SyNV9
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

When we test something, i.e. do a report() we want unique messages,
otherwise, from the test output, it will appear as if the same test was
run multiple times, possible with different PASS/FAIL values.

Convert some reports that don't actually test anything topology specific
into asserts.
Refine the report message for others.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20231030160349.458764-6-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/topology.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index c8ad4bc..03bc3d3 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -114,7 +114,7 @@ static void check_polarization_change(void)
 	report_prefix_push("Polarization change");
 
 	/* We expect a clean state through reset */
-	report(diag308_load_reset(1), "load normal reset done");
+	assert(diag308_load_reset(1));
 
 	/*
 	 * Set vertical polarization to verify that RESET sets
@@ -123,7 +123,7 @@ static void check_polarization_change(void)
 	cc = ptf(PTF_REQ_VERTICAL, &rc);
 	report(cc == 0, "Set vertical polarization.");
 
-	report(diag308_load_reset(1), "load normal reset done");
+	assert(diag308_load_reset(1));
 
 	cc = ptf(PTF_CHECK, &rc);
 	report(cc == 0, "Reset should clear topology report");
@@ -137,25 +137,25 @@ static void check_polarization_change(void)
 	report(cc == 0, "Change to vertical");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 1, "Should report");
+	report(cc == 1, "Should report change after horizontal -> vertical");
 
 	cc = ptf(PTF_REQ_VERTICAL, &rc);
 	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to vertical");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 0, "Should not report");
+	report(cc == 0, "Should not report change after vertical -> vertical");
 
 	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
 	report(cc == 0, "Change to horizontal");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 1, "Should Report");
+	report(cc == 1, "Should report change after vertical -> horizontal");
 
 	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
 	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to horizontal");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 0, "Should not report");
+	report(cc == 0, "Should not report change after horizontal -> horizontal");
 
 	report_prefix_pop();
 }
-- 
2.41.0


