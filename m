Return-Path: <kvm+bounces-15791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76BDD8B07E5
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7AB5B22921
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A63A315B10A;
	Wed, 24 Apr 2024 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QpaMxKBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6449315ADA1
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956396; cv=none; b=VeT8LLZi65i187KOcdZ5ZJqqfFH1iCJaSZPWeQdRSMvvbMldyiBg+KGOg14UX/PqwaUDm0QfrXUZtkUyFrRcMaGf/mZ4mgwBNKgdWbYA6M6MIBRsxIAE40/Ltr9xGez/OhSJfv+OkWerHzfI5GDR4w4nyk5APRR3CvoN1Bqhgt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956396; c=relaxed/simple;
	bh=T3hQ0pGUWp3LDj20ElSQ/2wDS0WW7VisEfwk7hZF/n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aixbmkEY2tYZz+JScx77NYZuqSTYW5jTD4D6EM6t7RZKtO3erjC4iNuS8n58jlVY6WIibOLNPeru7ntAQApa46J9dPdXXkfhL/4eOOGNOR1l0razF+4T1kiHpYxLyY7t2OabUT5fvY//n8ffvmCYVTShuqiPMyI1LHenB17dWKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QpaMxKBQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAvVJF029601;
	Wed, 24 Apr 2024 10:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=BIfjPSRUxMpVWmZtTX/JTXU6O5SAvTg1IKtvtbnNhzs=;
 b=QpaMxKBQMnHa6sK3lhUIrzRPzr5Sk75rMADa8SEYYLJ057W6uTHO9ZXd4AaXBT/w6wfJ
 KHVy3jB2XpzKLwNI/+1vJzgNlW+aqy+ap0TkKRPSuzMwS1XRZjP0BJYIzEhREYhomplb
 gE92JAT7y4WHnUSOf6AW0HReDXFlp7NY6aM3q6ZVzwud+Q1vNnMm0v23wNPNJpuXe7wO
 R+WIyFfM/Wv78A8x/wfanqux8d13+ZilUZW7UXHQKkuUb7SrTeARLbFk+9Yl+vH8NQF4
 HuLXek9VKB7QWJ9ZAp1sWEmC8z0xOGQIdKQVf6SXE2KtDaGguk5pXyCtg9rNssvSxjY2 cA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0sb004f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxkNb000461;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0sb004a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O9jsXw005736;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmx3chxwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxdLi32637536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C103020063;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92A5220065;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 06/13] s390x: sclp: Dirty CC before sclp execution
Date: Wed, 24 Apr 2024 12:59:25 +0200
Message-ID: <20240424105935.184138-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2HjqeO839CWlBOxVN5O8jIkA6vMYk8I3
X-Proofpoint-ORIG-GUID: 4Awi9KOK5HEDoVPBn_6FnArGFxlfCBq-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Janosch Frank <frankja@linux.ibm.com>

Dirtying the CC allows us to find missing CC changes when sclp is
emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240131074427.70871-6-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/sclp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/s390x/sclp.c b/s390x/sclp.c
index ccbaa913..53fce0cf 100644
--- a/s390x/sclp.c
+++ b/s390x/sclp.c
@@ -399,6 +399,7 @@ out:
 static void test_instbits(void)
 {
 	SCCBHeader *h = (SCCBHeader *)pagebuf;
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	sclp_mark_busy();
@@ -406,10 +407,12 @@ static void test_instbits(void)
 	sclp_setup_int();
 
 	asm volatile(
+		"	tmll	%[bogus_cc],3\n"
 		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
 		"       ipm     %0\n"
 		"       srl     %0,28"
-		: "=&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
+		: "=&d" (cc)
+		: "d" (valid_code), "a" (__pa(pagebuf)), [bogus_cc] "d" (bogus_cc)
 		: "cc", "memory");
 	/* No exception, but also no command accepted, so no interrupt is
 	 * expected. We need to clear the flag manually otherwise we will
-- 
2.44.0


