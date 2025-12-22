Return-Path: <kvm+bounces-66493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3812CCD6BDF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:02:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CFB7301F8E7
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00E033F36D;
	Mon, 22 Dec 2025 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="As2BtLOa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CF633D4F3;
	Mon, 22 Dec 2025 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422259; cv=none; b=f4UAUJ8stOuoZXN1fbI3+FNqzFrZqjaXG636l1pe/5MJJ02RMRzoEyw13H9BtBD+aF/H8s8+NB6yztFUBmnZqDrN5xwuQmGq166stjdEw1ccISaVZIoj0QtZYw/aoCD9n06+TR9bSoGACz9+nIkktm8a2nz0GfbhoNa17nEWSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422259; c=relaxed/simple;
	bh=gvAnFdHT/XMjCR1zs+fqNo8NXhkPFU1ciyQBZIXGeAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ds5/JBMNLTHlMAFCAxxMHoBE9TIwztOpxW/zm9hrNv4nQdDTGCZprbwxj5l7s40JpFozx8fsFhp7WC45RvJf6MWE/9s+oXpUxsTPPj+WTqSwGcBh4sFeQIj8i7RNEFWNHoiQeu8LnuEw7jB5yIzBZ35MQR+ti8I0WcOoLuSwiXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=As2BtLOa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM98BRG006456;
	Mon, 22 Dec 2025 16:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JtFCSxrF9CLU3LvfT
	rCfyoeTzzbfLQKkoH4wpG6bzTA=; b=As2BtLOaQnTj9VnDUzi309on7nUIDo1ys
	xK/tGuT3l7QTYNB5ukFiFx8f9+seaeFwgv2v/2Sa4KiRocwxJEQ1cvWUvYOMeQ3t
	YPnNd7YixPfiqMrPVTCMjhdkWq/ahk45PeRW7ajerIxWK4yinmUURrG9r9+pDebO
	Q3jUR/i2/NeuI2L6dqua2HBf/RAQuTEdyAKEXir2yxP9C95/a1FZ7fOvh8pdhDP4
	x+GeqTaBnNa3ENTuxaWxxALwjx4g0/UN2z2FjxugLwv3mWtQ/9TmyGiKuQX9Ds9G
	DrPaaTUAPd4VuFDPLE46Gx9vDkMiDBR/FLHzZRDhWYlqWT60YkKdg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ka399fk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGJQkw005081;
	Mon, 22 Dec 2025 16:50:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b674mq594-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGoogs30867750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:50 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E383920043;
	Mon, 22 Dec 2025 16:50:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B95F820040;
	Mon, 22 Dec 2025 16:50:48 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:48 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 11/28] KVM: s390: Rename some functions in gaccess.c
Date: Mon, 22 Dec 2025 17:50:16 +0100
Message-ID: <20251222165033.162329-12-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: rrLLpt03bAYDQLi4t1WDVC-UlZZ16wYQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX9p3wcmZFzSUk
 UsoJA3pf3MWuFG+T0enCEt31+Ic1hijs9odYAsjo9q++5NUuf12ApPwMoQeRu6GgLmPBxLjqAR9
 cgg4VvV5lMgU8lsM1kAvooBD/fWh8Mc1MMGQDexS57KxGSy++dm6bt4Tzky/NtuVzqoV3Hjk7Hb
 E0vHp3Rw9rHVMoHVSENQRJB0xE4rrI798ExdVMgKrgrkZSl4Jg2VVi0ZINZ0dxdyRIkIF+44Z50
 Z+yuSnqidgEgzSz99kdh1iuccXtnaanVIqMfe3OR9ahhvCw/VDVZXQeqQB2mcpbiVNp4gCgu3VK
 JcMv3+zobdTUPtdK7uLkJI9Syxit5HQi3l0BGvorSGwPfpcO2ob61xa/KeSUGV/xwREt8946TqC
 ZAdzq9MCChNqBo8oTupSV9A8NlVAv/al3HNbIy+foqXvZaOJFOCTcis34LaiDnAw4MJBFBuYADh
 h58jDqlrAvFI8XtnVaQ==
X-Proofpoint-ORIG-GUID: rrLLpt03bAYDQLi4t1WDVC-UlZZ16wYQ
X-Authority-Analysis: v=2.4 cv=dqHWylg4 c=1 sm=1 tr=0 ts=694976ef cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=daTLW1200KpnZZ0VTdgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

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
index d8347f7cbe51..9df868bddf9a 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -397,7 +397,7 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
 }
 
 /**
- * guest_translate - translate a guest virtual into a guest absolute address
+ * guest_translate_gva() - translate a guest virtual into a guest absolute address
  * @vcpu: virtual cpu
  * @gva: guest virtual address
  * @gpa: points to where guest physical (absolute) address should be stored
@@ -417,9 +417,9 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
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
@@ -600,8 +600,8 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static int vm_check_access_key(struct kvm *kvm, u8 access_key,
-			       enum gacc_mode mode, gpa_t gpa)
+static int vm_check_access_key_gpa(struct kvm *kvm, u8 access_key,
+				   enum gacc_mode mode, gpa_t gpa)
 {
 	u8 storage_key, access_control;
 	bool fetch_protected;
@@ -663,9 +663,9 @@ static bool storage_prot_override_applies(u8 access_control)
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
@@ -757,7 +757,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			return trans_exc(vcpu, PGM_PROTECTION, ga, ar, mode,
 					 PROT_TYPE_LA);
 		if (psw_bits(*psw).dat) {
-			rc = guest_translate(vcpu, ga, &gpa, asce, mode, &prot);
+			rc = guest_translate_gva(vcpu, ga, &gpa, asce, mode, &prot);
 			if (rc < 0)
 				return rc;
 		} else {
@@ -769,8 +769,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
-		rc = vcpu_check_access_key(vcpu, access_key, mode, asce, gpa, ga,
-					   fragment_len);
+		rc = vcpu_check_access_key_gpa(vcpu, access_key, mode, asce, gpa, ga, fragment_len);
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, PROT_TYPE_KEYC);
 		if (gpas)
@@ -782,8 +781,8 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	return 0;
 }
 
-static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
-			     void *data, unsigned int len)
+static int access_guest_page_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+				 void *data, unsigned int len)
 {
 	const unsigned int offset = offset_in_page(gpa);
 	const gfn_t gfn = gpa_to_gfn(gpa);
@@ -798,9 +797,8 @@ static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
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
@@ -808,7 +806,7 @@ access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	hva_t hva;
 	int rc;
 
-	gfn = gpa >> PAGE_SHIFT;
+	gfn = gpa_to_gfn(gpa);
 	slot = gfn_to_memslot(kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
 
@@ -841,7 +839,7 @@ int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
 
 	while (min(PAGE_SIZE - offset, len) > 0) {
 		fragment_len = min(PAGE_SIZE - offset, len);
-		rc = access_guest_page_with_key(kvm, mode, gpa, data, fragment_len, access_key);
+		rc = access_guest_page_with_key_gpa(kvm, mode, gpa, data, fragment_len, access_key);
 		if (rc)
 			return rc;
 		offset = 0;
@@ -901,15 +899,14 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
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
@@ -943,7 +940,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 	while (len && !rc) {
 		gpa = kvm_s390_real_to_abs(vcpu, gra);
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
-		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
+		rc = access_guest_page_gpa(vcpu->kvm, mode, gpa, data, fragment_len);
 		len -= fragment_len;
 		gra += fragment_len;
 		data += fragment_len;
@@ -1134,7 +1131,7 @@ int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
 
 	while (length && !rc) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), length);
-		rc = vm_check_access_key(kvm, access_key, mode, gpa);
+		rc = vm_check_access_key_gpa(kvm, access_key, mode, gpa);
 		length -= fragment_len;
 		gpa += fragment_len;
 	}
-- 
2.52.0


