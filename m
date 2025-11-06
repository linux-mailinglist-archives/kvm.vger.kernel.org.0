Return-Path: <kvm+bounces-62193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D03BC3C4D5
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDE4B188CC23
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E553B34F47E;
	Thu,  6 Nov 2025 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F+GCnZNP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83A134CFBF;
	Thu,  6 Nov 2025 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445490; cv=none; b=dN+JFZxyL8co3X/pgBDsnwtk61SIV6EQ/8qaRo/eZVa6bU6JFDD4b98/n31qiUi4sbgy9vTuIU/m7JNKCDM0qiep0CJccTuA2sHqW+pLCRRFlOTL0jHA3wkZjWuPV1LVQ714+jHNbB4w+p3gvWnEKSS7qPZnu2jK77xSeae2y+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445490; c=relaxed/simple;
	bh=fFNONRMsuBYR1R7MHaX77vIe287m9E4zL+7ELSWk6Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnSwzvYAnntOrly7phdcWfjlkUkDSiS8FSEInF5w0xEF3pUY8YZ4w3hS8SU2HuS7IV4Nh8HwQLkMooxHq5Bn9W1HS85T3rHZZChcCLEJNZ0LBG5aizpHsK6YVxpKv1cEENmrYkm55n14YW4YyUXunNXBMLUDL5XlhHRnaOuBlno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F+GCnZNP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A66vTML015815;
	Thu, 6 Nov 2025 16:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2QKzOwx3MkgE6froU
	qdt/y9hq9i1ZJcOo10RBAloerU=; b=F+GCnZNPKyWWmxl6vH8cmnNpVzZPg+s25
	Gkr15pjZk5dSl2tMjNov6wHmtuQTZs70kmR27yO4b9ndE4F9qqreMVUb+O+PSmvl
	x37NPABG81tqcp6E/hT073Je+tDW7jD2Lc2AFqyu08NhQ+XpbS69BP1zZR1rptHo
	s5o1227wZ3dDHwi2RSpZMM8odgd4cSUdtaXZc45BMVIubJv2lYmr8GfMXTboU9Ig
	bIeZYA6sStP5uWhhiUXy/F1Jeks3vZSTtmN/SWSVK7DrNi1KvXL1DPgpcSMlFNhD
	iSCF585e8QYcR5M4fQxrPZUHarT6t+4wA7o+XeQekF8ADsDEpFq9w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a58mm79kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6G1c5C012875;
	Thu, 6 Nov 2025 16:11:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5y8262ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBKog52494742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C473220040;
	Thu,  6 Nov 2025 16:11:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EFC420043;
	Thu,  6 Nov 2025 16:11:20 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:20 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 06/23] KVM: s390: Rename some functions in gaccess.c
Date: Thu,  6 Nov 2025 17:11:00 +0100
Message-ID: <20251106161117.350395-7-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: wfr6AW2RrJhj_P8OaYM4ANywaIFcS_30
X-Proofpoint-GUID: wfr6AW2RrJhj_P8OaYM4ANywaIFcS_30
X-Authority-Analysis: v=2.4 cv=SqidKfO0 c=1 sm=1 tr=0 ts=690cc8ad cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=daTLW1200KpnZZ0VTdgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwOSBTYWx0ZWRfXzvuPMBS1IbTv
 y3D+DHHXFbpDCsCX3Y8Aqs0MgqHPuD+iKKEudPyWxqsahwnGRsABTvhyGzLkAnWybZt0C29F4HS
 hHpe2inEhQkOrMznUiBz3ZLtoR7cUmwnrSuSq4vzIdHzC41rtiUE6HKOBj4LLSrhn/41QUisWZB
 W5ZA4I+8s2GMbBDbupkPIFJApfe3wJx22jncKr0KU7APHV3fDTmC4guo8lfGzltcA5F/+Ylo2uP
 RmdDgC3S3Z8HBy2vNQKozxsP72vrXTSG4LLvLEqBwftSLcTYClMyQZIBpU2bkFlN/w4EkVbiGRc
 47tJURWHuCHcklNPQhBENOJ7skr8kePAk1dC549HBOFYkVKJTbH4rEy3v/h02jucikeHBPezH0/
 f7S54Oq0Utq112hoC5ucB26D2g6YBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010009

Rename some functions in gaccess.c to add a _gva or _gpa suffix to
indicate whether the function accepts a virtual or a guest-absolute
address.

This makes it easier to understand the code.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 51 +++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index d691fac1cc12..05fd3ee4b20d 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -412,7 +412,7 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
 }
 
 /**
- * guest_translate - translate a guest virtual into a guest absolute address
+ * guest_translate_gva() - translate a guest virtual into a guest absolute address
  * @vcpu: virtual cpu
  * @gva: guest virtual address
  * @gpa: points to where guest physical (absolute) address should be stored
@@ -432,9 +432,9 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
  *	      the returned value is the program interruption code as defined
  *	      by the architecture
  */
-static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
-				     unsigned long *gpa, const union asce asce,
-				     enum gacc_mode mode, enum prot_type *prot)
+static unsigned long guest_translate_gva(struct kvm_vcpu *vcpu, unsigned long gva,
+					 unsigned long *gpa, const union asce asce,
+					 enum gacc_mode mode, enum prot_type *prot)
 {
 	union vaddress vaddr = {.addr = gva};
 	union raddress raddr = {.addr = gva};
@@ -615,8 +615,8 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static int vm_check_access_key(struct kvm *kvm, u8 access_key,
-			       enum gacc_mode mode, gpa_t gpa)
+static int vm_check_access_key_gpa(struct kvm *kvm, u8 access_key,
+				   enum gacc_mode mode, gpa_t gpa)
 {
 	u8 storage_key, access_control;
 	bool fetch_protected;
@@ -678,9 +678,9 @@ static bool storage_prot_override_applies(u8 access_control)
 	return access_control == PAGE_SPO_ACC;
 }
 
-static int vcpu_check_access_key(struct kvm_vcpu *vcpu, u8 access_key,
-				 enum gacc_mode mode, union asce asce, gpa_t gpa,
-				 unsigned long ga, unsigned int len)
+static int vcpu_check_access_key_gpa(struct kvm_vcpu *vcpu, u8 access_key,
+				     enum gacc_mode mode, union asce asce, gpa_t gpa,
+				     unsigned long ga, unsigned int len)
 {
 	u8 storage_key, access_control;
 	unsigned long hva;
@@ -772,7 +772,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			return trans_exc(vcpu, PGM_PROTECTION, ga, ar, mode,
 					 PROT_TYPE_LA);
 		if (psw_bits(*psw).dat) {
-			rc = guest_translate(vcpu, ga, &gpa, asce, mode, &prot);
+			rc = guest_translate_gva(vcpu, ga, &gpa, asce, mode, &prot);
 			if (rc < 0)
 				return rc;
 		} else {
@@ -784,8 +784,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
-		rc = vcpu_check_access_key(vcpu, access_key, mode, asce, gpa, ga,
-					   fragment_len);
+		rc = vcpu_check_access_key_gpa(vcpu, access_key, mode, asce, gpa, ga, fragment_len);
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, PROT_TYPE_KEYC);
 		if (gpas)
@@ -797,8 +796,8 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	return 0;
 }
 
-static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
-			     void *data, unsigned int len)
+static int access_guest_page_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+				 void *data, unsigned int len)
 {
 	const unsigned int offset = offset_in_page(gpa);
 	const gfn_t gfn = gpa_to_gfn(gpa);
@@ -813,9 +812,8 @@ static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	return rc;
 }
 
-static int
-access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
-			   void *data, unsigned int len, u8 access_key)
+static int access_guest_page_with_key_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+					  void *data, unsigned int len, u8 access_key)
 {
 	struct kvm_memory_slot *slot;
 	bool writable;
@@ -823,7 +821,7 @@ access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	hva_t hva;
 	int rc;
 
-	gfn = gpa >> PAGE_SHIFT;
+	gfn = gpa_to_gfn(gpa);
 	slot = gfn_to_memslot(kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
 
@@ -856,7 +854,7 @@ int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
 
 	while (min(PAGE_SIZE - offset, len) > 0) {
 		fragment_len = min(PAGE_SIZE - offset, len);
-		rc = access_guest_page_with_key(kvm, mode, gpa, data, fragment_len, access_key);
+		rc = access_guest_page_with_key_gpa(kvm, mode, gpa, data, fragment_len, access_key);
 		if (rc)
 			return rc;
 		offset = 0;
@@ -916,15 +914,14 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	for (idx = 0; idx < nr_pages; idx++) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
 		if (try_fetch_prot_override && fetch_prot_override_applies(ga, fragment_len)) {
-			rc = access_guest_page(vcpu->kvm, mode, gpas[idx],
-					       data, fragment_len);
+			rc = access_guest_page_gpa(vcpu->kvm, mode, gpas[idx], data, fragment_len);
 		} else {
-			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
-							data, fragment_len, access_key);
+			rc = access_guest_page_with_key_gpa(vcpu->kvm, mode, gpas[idx],
+							    data, fragment_len, access_key);
 		}
 		if (rc == PGM_PROTECTION && try_storage_prot_override)
-			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
-							data, fragment_len, PAGE_SPO_ACC);
+			rc = access_guest_page_with_key_gpa(vcpu->kvm, mode, gpas[idx],
+							    data, fragment_len, PAGE_SPO_ACC);
 		if (rc)
 			break;
 		len -= fragment_len;
@@ -958,7 +955,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 	while (len && !rc) {
 		gpa = kvm_s390_real_to_abs(vcpu, gra);
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
-		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
+		rc = access_guest_page_gpa(vcpu->kvm, mode, gpa, data, fragment_len);
 		len -= fragment_len;
 		gra += fragment_len;
 		data += fragment_len;
@@ -1149,7 +1146,7 @@ int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
 
 	while (length && !rc) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), length);
-		rc = vm_check_access_key(kvm, access_key, mode, gpa);
+		rc = vm_check_access_key_gpa(kvm, access_key, mode, gpa);
 		length -= fragment_len;
 		gpa += fragment_len;
 	}
-- 
2.51.1


