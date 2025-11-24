Return-Path: <kvm+bounces-64355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 341A7C804AC
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3A21A3438BF
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91D33002C2;
	Mon, 24 Nov 2025 11:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JlG7Z/Fb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A78B2FF66D;
	Mon, 24 Nov 2025 11:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985370; cv=none; b=YyFM1kHyoeVicbTObFoFqucs4v6PuoRAZ1YqLXQ67MD3gwxMS2WqS27lmhn3achpRafX/c7noWZTWk+5VaYdwf8UfidUcMchPumCNJwVL/aLU4HJ1PW/Wxb0SnpJVPs8Ut9uJRGmUwg8DVERmI5kaf63dU/JK9PojYdWaFtnMnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985370; c=relaxed/simple;
	bh=846wY4Q8kTWTl8iKvy1sofJTTFCBr+FU6VG6wOY7w/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsjcOkdyj3426JdsPlKW3y+YRO9/mbPMjnc3Y6BwdAXibKAGXstbVAd26fiOIgQ151saRithq/3qnNGzDs/Mww+qET5TC3MOE7ImcQbksLnT8wZwQvOAPBANwjbk89tebKE8WikZVWzL2WiXx6N0fyqXoLJwCrQZP+zqh+wbUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JlG7Z/Fb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANNh4rl014484;
	Mon, 24 Nov 2025 11:56:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xxJY71CB/uj5Sfn/v
	ACUN6MRJImbmEMWRyLBDS5bT1s=; b=JlG7Z/FbZPNOQoDueRLmkz9g8KOaccyhv
	vPti1vdtLuEiJHkx79Se/ccI/uSYzM3orojFXc7c+cZHwByvzxCS+59d+i2pgwgy
	/be9KvOHrDBL1sZtV/vYytfh1tDz+xNB43MkLgrP9N9uOEDsrX9k0wh023pkWacP
	B78AvlwF1Ivfg0MmhLHCIlnXFFJDvnuc2DoMY6DIyGt8yPH8Am3BNvJnDcO2NCeK
	BFkt0Rj+FWvwUgaaYFauuC2dnM+oR/wdRoR6F5NIcMvY7hTAjlj4Q1jRUKTM7BqW
	dJ9ifDMRgi6wX1e4q5Wt8RNFIU4QQq77IL1q2sWqfnhBNwnbFBziA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4phqxnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOB6bI4016409;
	Mon, 24 Nov 2025 11:56:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aks0jwn0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBu1U829753848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 155B420043;
	Mon, 24 Nov 2025 11:56:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8085220040;
	Mon, 24 Nov 2025 11:55:59 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:55:59 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 02/23] KVM: s390: add P bit in table entry bitfields, move union vaddress
Date: Mon, 24 Nov 2025 12:55:33 +0100
Message-ID: <20251124115554.27049-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAxNiBTYWx0ZWRfX824N8wnKrHTy
 g+7Plz7CJS9Ad/OaIOqxOrCkrMnY/g8UH+MWmh35TKat1EeeEV+469ZC5wEMvMkEfPJzq/hWeVr
 nGgOl/hbVMR6a229dMJPNsXHxjbJ6vzK1NeckgoBEV69YdD0HbqUk3qJjBGshwOAWPU6lNtndm4
 ACrahnzwDqrWnpilIULYCIW2jqIY60aSO2l6eMXo6KDxm7abAN434uYx6EZprei9SG57RuR++Zw
 TG9xZbqw4+PuqHts17K4UeYkBRQ66S5OKIFyTtJLX8qhUw08EGmiosRZuwO+ywnQUQR3CL753D7
 08vq75Vr1hrisAkFcGRA8SmKoFtrlemeAokGiE9IrfPvErrbEnN795IhXU4PqH7e0epIxIngtCQ
 8Z0AzfTBqediG09xJzI4jqym5KDjcg==
X-Proofpoint-ORIG-GUID: E9r2Pyguf3EtmNYF-u6TJ9HNoEMXkUCy
X-Authority-Analysis: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=692447d6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=ejxT3_R5mcMXAYFV490A:9
X-Proofpoint-GUID: E9r2Pyguf3EtmNYF-u6TJ9HNoEMXkUCy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220016

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


