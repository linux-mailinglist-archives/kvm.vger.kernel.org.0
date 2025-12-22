Return-Path: <kvm+bounces-66489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D3BFCCD6D3C
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54FA33086CBF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F014533B971;
	Mon, 22 Dec 2025 16:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eTEZXbNO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F6F339844;
	Mon, 22 Dec 2025 16:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422253; cv=none; b=IKw4+8c1GcP5xJrUIY9bfsHIHbqR2dLflbAYgKerF/nm2aDktD/biyZ4jBzw1K53cwiiBh/KY19O0nw5uW/0bMcWsM4BNxrqCjMcgDUsNQZx4sW6Hc85YvByxYbrEAIF+f1aC4O2RWBbmPxXpxfgUi5GAnJGHrbVAgffVpZkwCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422253; c=relaxed/simple;
	bh=9YJhYzyxGQsOEJpcFJeaFUho+YsLDtwkF+hgJBjHvhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AN6t0Xi+pXLnYI09VXV6iFbXi1YjbXyLDzElzvfwiGDI66Shgpg7Cij49AgGRoB+SyYncbhumYmC9+9a6/GDMsoERZFm1IVf2i1n4VMaDysm5e4sd0IcJnxffc4uLs60k8R6XpbwyyGGdWAV4FxwDogc2NfgAo0oRhEoCzpVvyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eTEZXbNO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDTEed009176;
	Mon, 22 Dec 2025 16:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=z1DOOgHqufta6Fg5x
	p6jSQBL+c+NsNMwlN8dukx9jZs=; b=eTEZXbNOm7D8ee4j1UhrsjsugraJWOws+
	rHYO8u2lewHLqowLtPAoI+WhgB6fkaNhvPtX5CGymH4q4VZLkxT3VY+vCuC7kBMz
	fQfBEQr5y77JaC54XgmxxwmCkk7B8wnmm3+ElQyYyr3sm3Ps/55yDZjqGkF/mtds
	vyB+e6tNMNaqdtURhjaR0OYyao/MYzqzk6T/wT7cbumZaXthnry5o3i4+sTWy1zn
	aw3NK+MvtKWKQTY/VtRW/6PLfCyQvnI9343ItaMhaJmRmxnSjKV9k0GflEZbK7Qh
	uAdMF8KrumcC7rzCcEupf2hGMBbDlAjMArA9jHVqiZkym9A8EHnmA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ketrtb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:49 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGDAo1030207;
	Mon, 22 Dec 2025 16:50:49 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b66gxq962-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGoi6g50856242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9757320043;
	Mon, 22 Dec 2025 16:50:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59E5420040;
	Mon, 22 Dec 2025 16:50:43 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:43 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 07/28] KVM: s390: Export two functions
Date: Mon, 22 Dec 2025 17:50:12 +0100
Message-ID: <20251222165033.162329-8-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: zhEf1smeKqzv5QU8L8fvvzDQR18Ni035
X-Authority-Analysis: v=2.4 cv=Qdxrf8bv c=1 sm=1 tr=0 ts=694976e9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=kE4rddDq9Ks6am3DDGoA:9
X-Proofpoint-ORIG-GUID: zhEf1smeKqzv5QU8L8fvvzDQR18Ni035
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfXyp1QyhyAVzMh
 SrlB2ycFYANhtxyLPaYiLFQQTMtathEHM2QiDZFQnUW58VAg9PYWatkxQ53YLgVYRudJhQIIo2x
 FM09x7e+wQ8mDfL81FcO7Clmoo1/2ZXRw1XiGlr4OcZBcX5gmh1sIsxfMgmLKsNUtKcmww5IGq4
 NDfrgX/S8XpSfQdpfFap7XOS7K7GQeDfFQF/8f2kILjdfE2fhp8bn4LfPxatFQIBiMgJDon4HDL
 UkrFCCHd6aXCw2sliTBta8lW9V+WUKOwEyWK8B/xb73etc4fwkMfJYSCac9xHc3pJon6VZySMcp
 sOWMaGhQ6m25I46SG+zl4GrrB29crX0AoLY3iJQegXZoctATP2k3Sr3w5rIWP9PDChlNVdvIQ4d
 Z2069orXORVd4ZqciRwwE2o0bA8aXfCgxssQIF56IsasG5jTjPDK2D2aCsSlgJQuvevzNje7vNI
 fikSOQorKjRm5oLcDvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

Export __make_folio_secure() and s390_wiggle_split_folio(), as they will
be needed to be used by KVM.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 2 ++
 arch/s390/kernel/uv.c      | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 8018549a1ad2..0744874ca6df 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -632,6 +632,8 @@ int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
+int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio);
+int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_from_secure_folio(struct folio *folio);
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index ca0849008c0d..cb4e8089fbca 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -281,7 +281,7 @@ static int expected_folio_refs(struct folio *folio)
  *          (it's the same logic as split_folio()), and the folio must be
  *          locked.
  */
-static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
+int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 {
 	int expected, cc = 0;
 
@@ -311,6 +311,7 @@ static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 		return -EAGAIN;
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
+EXPORT_SYMBOL(__make_folio_secure);
 
 static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct uv_cb_header *uvcb)
 {
@@ -339,7 +340,7 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
  *		   but another attempt can be made;
  *	   -EINVAL in case of other folio splitting errors. See split_folio().
  */
-static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
+int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 {
 	int rc, tried_splits;
 
@@ -411,6 +412,7 @@ static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 	}
 	return -EAGAIN;
 }
+EXPORT_SYMBOL_GPL(s390_wiggle_split_folio);
 
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
 {
-- 
2.52.0


