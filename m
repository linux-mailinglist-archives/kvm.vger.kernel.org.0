Return-Path: <kvm+bounces-66484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 973D6CD6B8A
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:53:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C7D730B1158
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 16:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF48333448;
	Mon, 22 Dec 2025 16:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eoFTcz4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A67332ECD;
	Mon, 22 Dec 2025 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422246; cv=none; b=I2si0Hjnvdix/g3G1LaP+jeRcUFwL443KUJnEBsZT0X/oTxPKMUZ5ZUCuneoSq1+/B3YrAz4/SMlnBdqUnrgKOVYn5U7QSDG8MU+EhlQX/MzLpUYRMRBRI1RcOHCqNHN/DmOobPiGheeGdfufewE6XxbjKjj0YWgY/CjsOA+vak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422246; c=relaxed/simple;
	bh=8V0RsbJjbg+C2CRylv9rHMgahDcLKD21enufdKYElYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xchjt/e0ZGoGysz2RNUEWhpgQGXrEYrKnUnSgD3SZZ0Z5YUvQyfxzzMONzeSmHzA7aaib4R5IGsg6tUY6/j5ePmDoZjQxOA8dEcIHzjCFmW62j8Xv3wCWa90EZrxzUbpKUxqWDNmm3tvsivXfaFmJ+ItMzHrjUVXLCEBUPoqcBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eoFTcz4Z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMCpBbw017912;
	Mon, 22 Dec 2025 16:50:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+5QN9fBrz8NVdvPYx
	1QvWxk2hn6Rv7kUyS/mMpg6ITQ=; b=eoFTcz4ZvtJ0+fU5Q84mQYxKmZ0FV9T2K
	kou4hZRNha4uZ0Q7xMWYIwwByddVEaEwoP6aouWGvgca4hxC2ydPXWw0HvSwY9dY
	39YWInD2B6wHEClnG0ELzHE0c4lH8zeP4gkrH+Vw+lT6mx8d4mTMz3oYOCU1G9PP
	EFMBCrkix18KGDxaZgFqLRUUoIZEG37ZdDH/4pqqVyujhl2tseHOIF/t62rwcV/y
	NHoOOHBq+xZz6zLfRA6lituTtilz/LsxXZqZUue0NMs8Ib9BgY65RAA0Efryl3At
	dlYaJq7FSkB+b5CQZPVd1NIwcewNfPxHhIzmvo9bqQvi6+75HbqQw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ketrtac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGKH7s004272;
	Mon, 22 Dec 2025 16:50:41 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b674mq582-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGobQw50856198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E70E20043;
	Mon, 22 Dec 2025 16:50:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C1A520040;
	Mon, 22 Dec 2025 16:50:36 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:36 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 02/28] KVM: s390: add P bit in table entry bitfields, move union vaddress
Date: Mon, 22 Dec 2025 17:50:07 +0100
Message-ID: <20251222165033.162329-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uE34NIIOU3eTeik5C15RuIg0jwrPHKyT
X-Authority-Analysis: v=2.4 cv=Qdxrf8bv c=1 sm=1 tr=0 ts=694976e2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=ejxT3_R5mcMXAYFV490A:9
X-Proofpoint-ORIG-GUID: uE34NIIOU3eTeik5C15RuIg0jwrPHKyT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfXyg9Ft+hTY2Cz
 hoJe0kzvM4O95S8mPM9VxDBIrHxZAHVvJ/oJKQKRvF/5OsOMjOh55zMpITmpeym7Kv7uaX1ETUx
 Yvzmn2AEOOseDeeeif1i6EilH+CO0JzO3DVBy9HCPVV96OSjiVazv94OS7gveq6/+VcCtHiBz4Y
 NxF1EyZotvUviIm7kKfnvtkLSUp1qF1YVHLPWmGWd3HHIDd/SRa33EoqKuKxkwXEx1CztHAOJRy
 I01JLuoTYbWtAC7RQycOyrorVJssCo0Gwlk03E714EJMJGL/O5x5B+f8Kqj4Lvj0qNDJsCf7sF0
 LCiZ0bKX8VxsEvecYIebJ01RGt5P2DK8IVK0/NRPlNWqaoLwRZ+cdfX2XYRMpW5NY3OGa/lfuIs
 WdJKYeGvu78XDrMs9TPSrY9F8a6DkjaoXKQWUDfJ2ayL/HnVtT9CYw0JLJHnYgz8rtGBMZTXfYP
 Rv1GwRPaVgBdOpoprqg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

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
index 41ca6b0ee7a9..d8347f7cbe51 100644
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
2.52.0


