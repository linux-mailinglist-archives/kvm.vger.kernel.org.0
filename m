Return-Path: <kvm+bounces-63896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED0EC75A45
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AB0B3363980
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36BA3A8D40;
	Thu, 20 Nov 2025 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dwShJ1P4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018D63A5E84;
	Thu, 20 Nov 2025 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658966; cv=none; b=cmBsrNkL5ZKvoV1ELqhfsPzCCWIoDfvCZNR0wmeyKB0MisPu3Ch5deGch+9R2odyqF2B61bXbSsiZEx70K0g4Dpu70JJYvJQ1rYECWGO3+CLW1rXRzSkBczTxUV/94UOrAQ0v27aHII1XY0cNTskB6SF5LVIglOKsic1z9QLrqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658966; c=relaxed/simple;
	bh=BRFD/zr2t1m4wmmkXvg3kWx5+uDIcFNShRaNjbFWQjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E92ZWY6wTEaWpF4oTY2+phNKwmP8U4mcuqlKZGNLpBcS1ihz4Gm3h7xEY07vHdpb/uzUK70B9h+8AMLmxuINPciHdeXUpSsdlOp6IAbWzm9StuQojVeyQZ57XmlLRzuM5lKHY0vdQ7wD8Up1/HCsxuI3mku7+fiXKBrm+qlS4Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dwShJ1P4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKClWS9007023;
	Thu, 20 Nov 2025 17:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4193Vdur/PnFHaaOF
	pWYmwatyRrvxD+5sPgR3d8oH5s=; b=dwShJ1P4G9RhlQ5r8dSLYQMDWNcAxgTuG
	0LCQEC7tRXWQiick9VGEFzaSvB1Z14HNMAIwlsh3Cth7pwimx41nNPQmjByiCK2z
	uvbgyVgcYj123tJjXqJSZBhVvTsYHQ7txADc80DKqoPBRoIekFVvqyGhjGvO/Lqz
	y6Rk42UMUGbrMREBdbYPcqRUGWZ/jpQUqxc3q2IsTSHPa4RfIQxngrHY5HJYO77p
	KOJlSff6iCpYNbix5Ha+ka4Fac3CgMdv4OA1nro7Y9sO4qg+yLjUZKLi4XD5xwjI
	sj0qszE8kJUsTDogws6VCenaxZemjVOlsEslSMP3um55IcOKaMvqw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmsxbkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKEPsnf022340;
	Thu, 20 Nov 2025 17:16:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un7mbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHFv4g10748344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:15:58 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D07F72004D;
	Thu, 20 Nov 2025 17:15:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 432FF20040;
	Thu, 20 Nov 2025 17:15:56 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:15:56 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 06/23] KVM: s390: Rename some functions in gaccess.c
Date: Thu, 20 Nov 2025 18:15:27 +0100
Message-ID: <20251120171544.96841-7-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: ByQg66IaKb4s2XU6wQtk6gifjrqH9rR8
X-Authority-Analysis: v=2.4 cv=Rv3I7SmK c=1 sm=1 tr=0 ts=691f4cd2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=daTLW1200KpnZZ0VTdgA:9
X-Proofpoint-GUID: ByQg66IaKb4s2XU6wQtk6gifjrqH9rR8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2Wjs9r/ZEOT+
 SizaKSzmFg/0Sp0B5Q2pNmvJVA0xMa3BMUgzCyKW7TWE9fohQwPhpzPum1fzpO4ccg+oKlSZFug
 sK/cGmGMgfHB65531sUdE7jXheTyD31LQBgMj5WAyiD2tRkt4iJQLSAUAMWOxIJuhK0o6JnENaI
 DqnRmU0FEQvVW6gheGhI25nmKkJAaDq74FHCgKZfoQshAsfen81QUtmNMHdvsjbNt95JSWzUgqa
 HPSy4LIZEk+g8fIP1ZhLyJigByv8SmS8AQVloxRF7xJt0lHcRAdSrvJfzzjA6Lm3Hdm6L78jwVd
 9qxv73Dgy1r1Qe2kRIxsdQMk4evC7yUfFZ4iGxPqG9IwAnOp2pPV3emf/V5vR2x2SVCl0YtlKNZ
 s0j80jJkEnnmO1/veh9Tv5QJ789hMw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

Rename some functions in gaccess.c to add a _gva or _gpa suffix to
indicate whether the function accepts a virtual or a guest-absolute
address.

This makes it easier to understand the code.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
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


