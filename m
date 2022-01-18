Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33670492325
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiARJwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:52:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14594 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234287AbiARJw3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:29 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8k6LZ004175;
        Tue, 18 Jan 2022 09:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5jnnRocybQwud1+JWWBzraM1tg2NmecDq0ayPT6xZ2M=;
 b=ozoyZJpjIo01IYfMYjF10D/8Y0dzDv5HJPiyHEk1kjrsUZ9fCqE5tRgg/tGl7lryk9g0
 3Jj2xSU+D2z6tbs+fj+hTFd5oQWsxzYInce5nyRbdFoIlMd4VnsIVOplDTX0fafuQ3xF
 JWzkyX9mEsG6eony6VuZNkynHPknfX6Xwf2dcKALlQBfPU5pUe7XKIMX92CW81isRZK6
 wgsTirSun3uzcMQ4uk4woy2SZe8mgKFEXG3+FgW1hK2KQ2deYaSy951uuqzU6a1VQCgT
 d3xS0I0FhUgG+8eEfJa2DrzSOsfVVGDdgJylMlLZoFvTxd1E2KoTcjT/rimkp1JEogAV Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnqdwdmjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:28 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I8oCQX017409;
        Tue, 18 Jan 2022 09:52:28 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnqdwdmht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:28 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9lMm3000745;
        Tue, 18 Jan 2022 09:52:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3dknhj1k7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9qLtN38928828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:52:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75379A405F;
        Tue, 18 Jan 2022 09:52:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D6B4A4059;
        Tue, 18 Jan 2022 09:52:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:21 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 03/10] KVM: s390: handle_tprot: Honor storage keys
Date:   Tue, 18 Jan 2022 10:52:03 +0100
Message-Id: <20220118095210.1651483-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4MtchkQpCUZ3ba72f4NUoEmpUiendRfU
X-Proofpoint-GUID: s0JHzV2DFWGrk5HROngH64EfyC-7GDgI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the access key operand to check for key protection when
translating guest addresses.
Since the translation code checks for accessing exceptions/error hvas,
we can remove the check here and simplify the control flow.
Keep checking if the memory is read-only even if such memslots are
currently not supported.

handle_tprot was the last user of guest_translate_address,
so remove it.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c |  9 ------
 arch/s390/kvm/gaccess.h |  3 --
 arch/s390/kvm/priv.c    | 66 ++++++++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 92ab96d55504..efe33cda38b6 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1104,15 +1104,6 @@ int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
 				 access_key);
 }
 
-int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
-			    unsigned long *gpa, enum gacc_mode mode)
-{
-	char access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
-
-	return guest_translate_address_with_key(vcpu, gva, ar, gpa, mode,
-						access_key);
-}
-
 /**
  * check_gva_range - test a range of guest virtual addresses for accessibility
  * @vcpu: virtual cpu
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 3df432702cd6..0d4416178bb6 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -190,9 +190,6 @@ int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
 				     unsigned long *gpa, enum gacc_mode mode,
 				     char access_key);
 
-int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva,
-			    u8 ar, unsigned long *gpa, enum gacc_mode mode);
-
 int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 		    unsigned long length, enum gacc_mode mode,
 		    char access_key);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 417154b314a6..7c68f893545c 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -1443,10 +1443,11 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
 
 static int handle_tprot(struct kvm_vcpu *vcpu)
 {
-	u64 address1, address2;
-	unsigned long hva, gpa;
-	int ret = 0, cc = 0;
+	u64 address, operand2;
+	unsigned long gpa;
+	char access_key;
 	bool writable;
+	int ret, cc;
 	u8 ar;
 
 	vcpu->stat.instruction_tprot++;
@@ -1454,43 +1455,46 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	kvm_s390_get_base_disp_sse(vcpu, &address1, &address2, &ar, NULL);
+	kvm_s390_get_base_disp_sse(vcpu, &address, &operand2, &ar, NULL);
+	access_key = (operand2 & 0xf0) >> 4;
 
-	/* we only handle the Linux memory detection case:
-	 * access key == 0
-	 * everything else goes to userspace. */
-	if (address2 & 0xf0)
-		return -EOPNOTSUPP;
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
 		ipte_lock(vcpu);
-	ret = guest_translate_address(vcpu, address1, ar, &gpa, GACC_STORE);
-	if (ret == PGM_PROTECTION) {
+
+	ret = guest_translate_address_with_key(vcpu, address, ar, &gpa,
+					       GACC_STORE, access_key);
+	if (ret == 0) {
+		gfn_to_hva_prot(vcpu->kvm, gpa_to_gfn(gpa), &writable);
+	} else if (ret == PGM_PROTECTION) {
+		writable = false;
 		/* Write protected? Try again with read-only... */
-		cc = 1;
-		ret = guest_translate_address(vcpu, address1, ar, &gpa,
-					      GACC_FETCH);
+		ret = guest_translate_address_with_key(vcpu, address, ar, &gpa,
+						       GACC_FETCH, access_key);
 	}
-	if (ret) {
-		if (ret == PGM_ADDRESSING || ret == PGM_TRANSLATION_SPEC) {
-			ret = kvm_s390_inject_program_int(vcpu, ret);
-		} else if (ret > 0) {
-			/* Translation not available */
-			kvm_s390_set_psw_cc(vcpu, 3);
+	if (ret >= 0) {
+		cc = -1;
+
+		/* Fetching permitted; storing permitted */
+		if (ret == 0 && writable)
+			cc = 0;
+		/* Fetching permitted; storing not permitted */
+		else if (ret == 0 && !writable)
+			cc = 1;
+		/* Fetching not permitted; storing not permitted */
+		else if (ret == PGM_PROTECTION)
+			cc = 2;
+		/* Translation not available */
+		else if (ret != PGM_ADDRESSING && ret != PGM_TRANSLATION_SPEC)
+			cc = 3;
+
+		if (cc != -1) {
+			kvm_s390_set_psw_cc(vcpu, cc);
 			ret = 0;
+		} else {
+			ret = kvm_s390_inject_program_int(vcpu, ret);
 		}
-		goto out_unlock;
 	}
 
-	hva = gfn_to_hva_prot(vcpu->kvm, gpa_to_gfn(gpa), &writable);
-	if (kvm_is_error_hva(hva)) {
-		ret = kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-	} else {
-		if (!writable)
-			cc = 1;		/* Write not permitted ==> read-only */
-		kvm_s390_set_psw_cc(vcpu, cc);
-		/* Note: CC2 only occurs for storage keys (not supported yet) */
-	}
-out_unlock:
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
 		ipte_unlock(vcpu);
 	return ret;
-- 
2.32.0

