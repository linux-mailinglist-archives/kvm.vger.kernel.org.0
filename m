Return-Path: <kvm+bounces-63892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A71C7598A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id DD0C62B9FC
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF840371DFC;
	Thu, 20 Nov 2025 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oBDI95Zb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D167C36CE19;
	Thu, 20 Nov 2025 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658959; cv=none; b=f9uGEXmZc6YjrrdwlFNrvRWGocAZtQujO8KcO8f/2lovr1rwLJn293DAiykIorvDr3MpxMvznR4wElUYIsFDCtHfq/Qs85XoG9NXQdbgIeWNFghpmLjvZ043UV6tmk6hwCQCZZS8swiWIeOLjVBRwEpikeymiZUUF5c4F2Vx16g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658959; c=relaxed/simple;
	bh=846wY4Q8kTWTl8iKvy1sofJTTFCBr+FU6VG6wOY7w/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/3SVLTm5mJG88iFBA6cNs1Ksk/hmBQ0vye6MXMPRPJmYKbvy2E41rXrKDtrUjLdc+pq09G2+RnhyqmNjwvYEuH2/KNi/jR2PNOqzUZtIW54Y8t8jrVsqvQKvTxzfEUKvVYgjIrKcivmk/jQgiv0cfep/tKyw4QI6OidfdZ1YIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oBDI95Zb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKCm0lo013647;
	Thu, 20 Nov 2025 17:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xxJY71CB/uj5Sfn/v
	ACUN6MRJImbmEMWRyLBDS5bT1s=; b=oBDI95ZbP39Lkk9l68apnH/KAaQeRjXSe
	B4ibCRuOrhPns3k1dymyJGuEP9ke+/PlnB8dexdj4OOTKycD/qRmf5s3x+8EgzTC
	HaTbL5Kckrxd9y1Roi2baZLMdldQAI9deeUg9XuTzt2nhNY3LSN9LQest8+mxfjL
	9hhjvFYJMJS96fxPjPEASAP7DhV7WjaWH03C1lxrBCnBoPP4huGPLWQ3m/GdWxp6
	Y43rhs+0vHYhLFd/1uwO3OddaKFqbjo08ZlQvcxWQe2r1PyNSSJg6f3MIcgLiUU2
	hou/OVni45w7Ixp8M5kPCYB6PY07+36jaxd0E3AqOKik96jqE+mXA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejgx6ad1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:15:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKGjtDm005244;
	Thu, 20 Nov 2025 17:15:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af5bkfkxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:15:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHFogA27525774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:15:50 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EA5F2004D;
	Thu, 20 Nov 2025 17:15:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D530220040;
	Thu, 20 Nov 2025 17:15:48 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:15:48 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 02/23] KVM: s390: add P bit in table entry bitfields, move union vaddress
Date: Thu, 20 Nov 2025 18:15:23 +0100
Message-ID: <20251120171544.96841-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120171544.96841-1-imbrenda@linux.ibm.com>
References: <20251120171544.96841-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DhXffliTtskZ7e_H-dazibWHTOPnAdZ8
X-Authority-Analysis: v=2.4 cv=YqwChoYX c=1 sm=1 tr=0 ts=691f4ccb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=ejxT3_R5mcMXAYFV490A:9
X-Proofpoint-ORIG-GUID: DhXffliTtskZ7e_H-dazibWHTOPnAdZ8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2ayGRuLEK+mh
 37ZDof5q7fhuIILTI2DJQTmEFH+UKB8pcHOss73UCvmUNS5OEn3W21TNRKCoDXtf7kpWMqdWnnU
 LvL8fNYsWVnMn8IgRN50DtbVRDwq+0seZV+Dm62EeG6MYXvsnaPOIQyIAR7TYmQEfJt390meJKs
 lLJwjHpg/qrRSqFhQN90eVsc1+gmdFXGksdd0XbXKmX3PGEQk16QgiHyNqew3lKXTLy+dc9coCH
 +3VqsPk/moL3ZxIdBC/ADURVQNvV+KrMOvuUIs5+fHOlc9dwMnECAMYtnUcSQfa9wzyTOTqw/q2
 YU9ZUKXiOKjDu+9KdnZDfohfUUrhyjOLk4nyaaU/GM0aNCKFGHBcAXX9Q8d9YSRWSDZ7fXse00O
 iIMfoI4LZ0y82ctJYiOwRRxMA1cXfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

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


