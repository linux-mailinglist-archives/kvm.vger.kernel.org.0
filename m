Return-Path: <kvm+bounces-15798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB91C8B07EC
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94534282A0A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F9A15B120;
	Wed, 24 Apr 2024 11:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j546LZtw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC8B15AD9A
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956400; cv=none; b=XAIHjDZobyuLkKjyjf0Ymr+hOQ0sXlY6C3tW69RdTfkNIcsVpdM2qyAxD+Nudj6k8hv51upaV5ppXOEFBUQXhJYNZ/26bzAMpKBGNhz4a6T3LV/gRW1LFi3mGOgB2+NyITYFAYhIrgXNlJKGYjJRhrYRrbImdOo/tTVphdxuA+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956400; c=relaxed/simple;
	bh=kV1zftkpWzbcO50ElhQAkWmlhWyzdOjfJ4qMUwnwIJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrY+crYu4WqyME2EBwgxnTdBqhulFFiiy7QoO3s3bHcfidTQL0KijMX09spp7qr7NhVtigexW9sx9PKhKUVjUQ1LQevpvTyVqyCM8rH046rp5QNLaz151/5zU/ho0KkR5R94wSBW2ET1z/j3I/911zHapHkH935MjLedsOEdZMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j546LZtw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43O9lwRc023541;
	Wed, 24 Apr 2024 10:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=clEy1tkFZtScIaqxbPYYXhokhY2wP6SeMOsd+QJN2wM=;
 b=j546LZtwPNSI9yGniZEs66scDhrCA/CY2Y9E7DGYQAqHuScOBwD2Fboqo4938Hhov17L
 dZTco0AgRTexa8+i8RQZ+2uBwU0JXSDXEaLKJNStflHLJN2ytcYKJLWQvumufgmYFmHT
 INtVqCzqXKtTBrpmiafOUSj9AbTykTPGfmoMTVMsdT+F0lZoY4anvVXrppGviX7ornch
 eJTsRcoM0Y/T09gb3CZ47n9rAQVpxRJd/K8unpWQL0zN1rx+7DO5vfUcUSxj5vx3rhOP
 pKSYO0U7A1Yar/SWbLwhanGs4VB/oDltJokdJ1UKs5KhjlluoWu/NlayELQqEcppt2JV 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpyry842s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxjmT031240;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpyry842p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O80l10023043;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1p36ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxd3131326964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5326E2004B;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F5602005A;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 04/13] lib: s390x: css: Dirty CC before css instructions
Date: Wed, 24 Apr 2024 12:59:23 +0200
Message-ID: <20240424105935.184138-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pkm_wP3Vjx-iEJySQYpMre_w1PD6hng8
X-Proofpoint-ORIG-GUID: AVDiSsWJzYfXZE7k-3iIqdjE_sJTTmy6
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=848 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404240045

From: Janosch Frank <frankja@linux.ibm.com>

Dirtying the CC allows us to find missing CC changes when css
instructions are emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240131074427.70871-4-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/css.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 0a19324b..504b3f14 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -147,14 +147,16 @@ static inline int ssch(unsigned long schid, struct orb *addr)
 static inline int stsch(unsigned long schid, struct schib *addr)
 {
 	register unsigned long reg1 asm ("1") = schid;
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	stsch	0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr)
+		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
@@ -177,14 +179,16 @@ static inline int msch(unsigned long schid, struct schib *addr)
 static inline int tsch(unsigned long schid, struct irb *addr)
 {
 	register unsigned long reg1 asm ("1") = schid;
+	uint64_t bogus_cc = 2;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	tsch	0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr)
+		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
@@ -252,28 +256,32 @@ static inline int rsch(unsigned long schid)
 static inline int rchp(unsigned long chpid)
 {
 	register unsigned long reg1 asm("1") = chpid;
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	rchp\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc)
-		: "d" (reg1)
+		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
 
 static inline int stcrw(uint32_t *crw)
 {
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	stcrw	%[crw]\n"
 		"	ipm	%[cc]\n"
 		"	srl	%[cc],28"
 		: [cc] "=d" (cc)
-		: [crw] "Q" (*crw)
+		: [crw] "Q" (*crw), [bogus_cc] "d" (bogus_cc)
 		: "cc", "memory");
 	return cc;
 }
-- 
2.44.0


