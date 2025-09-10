Return-Path: <kvm+bounces-57221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A862B51FC5
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16B24483CFC
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A697433CE91;
	Wed, 10 Sep 2025 18:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="avN46TDh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B1D27979F;
	Wed, 10 Sep 2025 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527675; cv=none; b=rhLbBxq5JMHCmlQDCK8gdlAbEh27KptVnsI2AuydhsVAez6dqXkKHl+i5Pwvr4NM3DCZWTOlmJPNtOA9CJBD7gfgi8v2Kwom/xjN6M6fe2WDnWPESZ20F0TbBQuO3rYvr1ra8MGk1sb5nxcZxKssLFtJohWIqDtaH8mw7pIocdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527675; c=relaxed/simple;
	bh=DebIkUhKxAETYO7rwR211uy6DUuq9/VZKcZhX+ytIsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2eL4kHeSAfmcuX0anQ/WoziJY9GCpffLQitrlqmj/AcBdpVTGUSVJjFIvFpIthXu3uWNdhv1162SoZ6XO3XN9dajZFeujYG8IS+lW9jTh5NvPondyNp2SV39woqLYkO0LWOriY90BRpImBIg8MytWHa389PWHqix6VbklJ2YUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=avN46TDh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AETHRc021177;
	Wed, 10 Sep 2025 18:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2wuwKokoxT59iDKNO
	yDHX46waZYSXROT60xa8dd+jAc=; b=avN46TDhUsP+CJTY/gAnk35iK66s/uMv7
	sJRbaxQ6MXOecLRPE1UAOFXgQAXP9PueBcj2Fdb9qwUbOFgOpf11GDAsca3UjTZQ
	eeX0I3qgurZPEeXcKWhtV6UQ+MygL0Y5N05/78ow0jGM24p/JvO1kzvPf1+Kk1xz
	52XibD9/RrwQio3zdCIPgwv9aFbtEfDr9PtqSotry2fqIyHNDptSrX/3IlZCiEG7
	50kpMhGWx/Nz3EeAb/P+v+9xSu4+S/W645on7sXeUWmKEim91SiDtiMTYcbKTWr5
	HAPH2/fEeWyNfFF+xFDSOYFa0wyfgh19trcxS6gV00PjET170jKag==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsyge5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGIvTp011434;
	Wed, 10 Sep 2025 18:07:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9uj3u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7lTX23134668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08DBD20040;
	Wed, 10 Sep 2025 18:07:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C72492004D;
	Wed, 10 Sep 2025 18:07:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 01/20] KVM: s390: add P bit in table entry bitfields, move union vaddress
Date: Wed, 10 Sep 2025 20:07:27 +0200
Message-ID: <20250910180746.125776-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910180746.125776-1-imbrenda@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfXw1q42Bvc8+Ek
 FrI9KCBkWphVk0grJxvU46NeqvArY+mvquH2/vCDA2kcKGRfxsmPQykOlr9EtjCxMz35gA2P6C4
 EamPdq6qJoWhjkOp56LlJHfjQQV7QPFSZnmsMHWx+1id/XyY/WtOPoqoji4kaPUyrt7HZhsHkfR
 2HrbZnRwumedxETa51+iElnl7BJa8xX8Jhv6XhxHZvXd6l1A35iM6Gv3SlTueq2Qumnt027mxL4
 WsFLZPxH2O84cD81ROfxAW8gfVewUGK1zJ0Fh1UWQKJDqNLf18LB3GU6K45zRoxRsGyhdOZeyDK
 PpyG2p8mj3EDg1uP8MU56PWJAmbffsfV9x6UHn5kz17X14iwnxG+f4QiFgwKQj1CAqw5DqVO2Y5
 h/0Ou/Ri
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c1be77 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=ejxT3_R5mcMXAYFV490A:9
X-Proofpoint-GUID: bjm6M6zQs0nL4PVtL1cfN6uBLIq7Y8SE
X-Proofpoint-ORIG-GUID: bjm6M6zQs0nL4PVtL1cfN6uBLIq7Y8SE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

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
2.51.0


