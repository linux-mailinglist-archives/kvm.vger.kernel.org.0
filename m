Return-Path: <kvm+bounces-31636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2AA9C5D2C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12CBA1F25756
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABF020696C;
	Tue, 12 Nov 2024 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="trW+gQKM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D320515D;
	Tue, 12 Nov 2024 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428780; cv=none; b=l/Dzna+o+1lt9FkugZHaaV9VC1MS08mQva7/Gwa/cxanZjRSvshikLKUlSaDxwNmbJuBfn74f6U5UmBXXH8qKgwdbqM7Ic/IVG7pwIfL6UbNF6HkJAIGzMMyPIMuascKtjFjs6FD9EHSpLWoD6xdxAqRE1HvUv8BItpoJHKpTIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428780; c=relaxed/simple;
	bh=5YSZcyRo6A9nT4aL6YYQ9kUh85khRC0Aj4XEgEQb3hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rayh4F2eSKMFgYzuU2tIStzwx2MP+yFKWhfceDZ/8306HI3T8DjoQvGHam3YcVtK+iEJqyhX0vr4myU66AN0MctoWa62dWj0RWvQ/0nqAQnSXW04DUSRa7k3bNpFC8CPez+kqFb0yWJMFEc6kqFYrOdlX/VcT8sP+1zuQ2U501I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=trW+gQKM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACGC6Bm023253;
	Tue, 12 Nov 2024 16:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/K2ibp6cyPvaOHZX4
	qH1J1yvbN6SGScWoBgXbM3tsdQ=; b=trW+gQKM5n/N0iceD+bK7piwcsc6ZESwY
	cPT4ShXq9LItgtlIO5ZM+KxT70YpO8hWttI+ouR5Z7VpHZC/ucvoINvojrrqHAfQ
	E20hOPGcWjCwxaCSuRzNoMcdmm395Jjq0ZDaIoNjE9U53TNrDfty8JGDS2+dbsV7
	y0M8gDw07vrMB/a+diwf+L4ybcY6yql3Hk3Oo9ExcmZn38s+nH/k/7/9nhw96HfN
	DPWFmNCv0KpEU9olFu5TBF0ZkTtFMU99UDn4H8iJ0GVnBeGIyBdu1E2HiZdvs3Oc
	IVC363lxL1rqtc+6FSdiwivYbWf2uJkSNfFU0qEEMqh1M9161AJKg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9dv0amh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC7PQ7M004153;
	Tue, 12 Nov 2024 16:26:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tms14dgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQBIm35390028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9431420040;
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2400020049;
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 10/14] KVM: s390: selftests: correct IP.b length in uc_handle_sieic debug output
Date: Tue, 12 Nov 2024 17:23:24 +0100
Message-ID: <20241112162536.144980-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CfsZ53ERMTzD2wHPjwng_7r6il20n76-
X-Proofpoint-ORIG-GUID: CfsZ53ERMTzD2wHPjwng_7r6il20n76-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=657 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411120128

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

The length of the interrupt parameters (IP) are:
a: 2 bytes
b: 4 bytes

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20241107141024.238916-6-schlameuss@linux.ibm.com
[frankja@linux.ibm.com: Fixed patch prefix]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241107141024.238916-6-schlameuss@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/ucontrol_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index 690077f2c41d..0c112319dab1 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -376,7 +376,7 @@ static bool uc_handle_sieic(FIXTURE_DATA(uc_kvm) *self)
 	struct kvm_run *run = self->run;
 
 	/* check SIE interception code */
-	pr_info("sieic: 0x%.2x 0x%.4x 0x%.4x\n",
+	pr_info("sieic: 0x%.2x 0x%.4x 0x%.8x\n",
 		run->s390_sieic.icptcode,
 		run->s390_sieic.ipa,
 		run->s390_sieic.ipb);
-- 
2.47.0


