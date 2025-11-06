Return-Path: <kvm+bounces-62189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A34C3C584
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D0A7621DF4
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F0834E746;
	Thu,  6 Nov 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rh7O/Q/c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D1234C830;
	Thu,  6 Nov 2025 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445488; cv=none; b=eHFqEqtCFJsDdpmhuslTGxpugKYNYyyY//KG3fcbXLIZosj6OZxQSBYDoqoKFij4YHSYAor60XWDN/BgjzeyClGW2HSedCG6BId3Z3gasAFkgzohcNHwCEAAWZJAIPZY2eTe88vqY5FA0NfJCFE4Y0IKP0oG4Wvq3Pz2kmZzbAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445488; c=relaxed/simple;
	bh=846wY4Q8kTWTl8iKvy1sofJTTFCBr+FU6VG6wOY7w/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJNTPCpwHTEddRX3DzK3Vfn281Anxb0zeDIElklgP5irad9S6HvnYt0vMcZhwImxib/HXanX3zB04njRkq/hTFD4E1ZGy7fw+ZT/uWDxaln0FMap1vWppQ3H1wvSPr5Y1dptF/xabbA1BiS7Z8mSNHCMZu0YWPD2B6/rKQN/Rnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rh7O/Q/c; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6AKZXG028475;
	Thu, 6 Nov 2025 16:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xxJY71CB/uj5Sfn/v
	ACUN6MRJImbmEMWRyLBDS5bT1s=; b=rh7O/Q/cEWg/uNyQ6xY7Ig2oIIqo/Vr78
	VY/KBR6hMcZhCsvjQMwVCi91fYnpgvZqj7uuAoNdexR+4dTLvdga1gpeCZGCNvAc
	IxHqquEujW42QQb3UuoAwVg6uZ9giDUplOK9wvK4zPrqLsxxViyCTaDxgpNfA3qS
	Vv+2rVT7K9SrvH4viMQvUe1FUv8D+M7/3cROS/D+mNM46OkFEzO51JesXRESL0DE
	jPhDFolvfaFaE12JPP67Jt6kPzfHJzReZHpSMlp4zoBhSwsMo2ieABTPq5nG3NwD
	jl72dLoE67MD/HJZ1Yvv/wb+SI94fWo9P9Ms3gZgiSCH0DUyB75ig==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a58mm79kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6FSEuZ009863;
	Thu, 6 Nov 2025 16:11:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5x1kp935-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBJpO43712844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3EEF20040;
	Thu,  6 Nov 2025 16:11:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EF9020043;
	Thu,  6 Nov 2025 16:11:18 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:18 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 02/23] KVM: s390: add P bit in table entry bitfields, move union vaddress
Date: Thu,  6 Nov 2025 17:10:56 +0100
Message-ID: <20251106161117.350395-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106161117.350395-1-imbrenda@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6dVCLh7LdAbxQW94ob54ZPTSY7P_1sEp
X-Proofpoint-GUID: 6dVCLh7LdAbxQW94ob54ZPTSY7P_1sEp
X-Authority-Analysis: v=2.4 cv=SqidKfO0 c=1 sm=1 tr=0 ts=690cc8ab cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=ejxT3_R5mcMXAYFV490A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwOSBTYWx0ZWRfX06av6gNRKwzQ
 q+J/HLCQ4i3hl9TwVZudyL1bbUZSLE+XiRj2/i1qq+w4zkbo+TscI5XP1OQv3QaWPOM0vzIoBnl
 a4XxtzELV+278nCsb6Nga+C8dpf3mMuWNJHAv6kRedDE96kjFwgExACv9CUEh/qHzfu961M4s4u
 YGx1AFm7gF1k6okE7ahV3D9YQrtIrUrmw+U2XCtr1iY4SSHqShmVED0zmWg+UqPMBjkPRyYWEjo
 jmukudY62RIKWg/p0z639K4Ngv880KnrgIVbh4hZVD8hm1p+uOGA/E6U6lsTFxAmBbeXT5Pxauv
 2Gh2RmdnEsAJ80qxAVfewUhEuFct5BA4w+mk9ucDPpJ3Nkdbrq7Br+agwYSzOsg/Shw3ele6sbf
 ckxdmuP/9hyBlqk+F5/N1ELrtgOUXQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010009

Add P bit in hardware definition of region 3 and segment table entries.

Move union vaddress from kvm/gaccess.c to asm/dat_bits.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/dat-bits.h | 32 ++++++++++++++++++++++++++++++--
 arch/s390/kvm/gaccess.c          | 26 --------------------------
 2 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/s390/include/asm/dat-bits.h b/arch/s390/include/asm/dat-bits.h
index 8d65eec2f124..c40874e0e426 100644
--- a/arch/s390/include/asm/dat-bits.h
+++ b/arch/s390/include/asm/dat-bits.h
@@ -9,6 +9,32 @@
 #ifndef _S390_DAT_BITS_H
 #define _S390_DAT_BITS_H
 
+/*
+ * vaddress union in order to easily decode a virtual address into its
+ * region first index, region second index etc. parts.
+ */
+union vaddress {
+	unsigned long addr;
+	struct {
+		unsigned long rfx : 11;
+		unsigned long rsx : 11;
+		unsigned long rtx : 11;
+		unsigned long sx  : 11;
+		unsigned long px  : 8;
+		unsigned long bx  : 12;
+	};
+	struct {
+		unsigned long rfx01 : 2;
+		unsigned long	    : 9;
+		unsigned long rsx01 : 2;
+		unsigned long	    : 9;
+		unsigned long rtx01 : 2;
+		unsigned long	    : 9;
+		unsigned long sx01  : 2;
+		unsigned long	    : 29;
+	};
+};
+
 union asce {
 	unsigned long val;
 	struct {
@@ -98,7 +124,8 @@ union region3_table_entry {
 	struct {
 		unsigned long	: 53;
 		unsigned long fc: 1; /* Format-Control */
-		unsigned long	: 4;
+		unsigned long p : 1; /* DAT-Protection Bit */
+		unsigned long	: 3;
 		unsigned long i : 1; /* Region-Invalid Bit */
 		unsigned long cr: 1; /* Common-Region Bit */
 		unsigned long tt: 2; /* Table-Type Bits */
@@ -140,7 +167,8 @@ union segment_table_entry {
 	struct {
 		unsigned long	: 53;
 		unsigned long fc: 1; /* Format-Control */
-		unsigned long	: 4;
+		unsigned long p : 1; /* DAT-Protection Bit */
+		unsigned long	: 3;
 		unsigned long i : 1; /* Segment-Invalid Bit */
 		unsigned long cs: 1; /* Common-Segment Bit */
 		unsigned long tt: 2; /* Table-Type Bits */
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 21c2e61fece4..d691fac1cc12 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -20,32 +20,6 @@
 
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
-/*
- * vaddress union in order to easily decode a virtual address into its
- * region first index, region second index etc. parts.
- */
-union vaddress {
-	unsigned long addr;
-	struct {
-		unsigned long rfx : 11;
-		unsigned long rsx : 11;
-		unsigned long rtx : 11;
-		unsigned long sx  : 11;
-		unsigned long px  : 8;
-		unsigned long bx  : 12;
-	};
-	struct {
-		unsigned long rfx01 : 2;
-		unsigned long	    : 9;
-		unsigned long rsx01 : 2;
-		unsigned long	    : 9;
-		unsigned long rtx01 : 2;
-		unsigned long	    : 9;
-		unsigned long sx01  : 2;
-		unsigned long	    : 29;
-	};
-};
-
 /*
  * raddress union which will contain the result (real or absolute address)
  * after a page table walk. The rfaa, sfaa and pfra members are used to
-- 
2.51.1


