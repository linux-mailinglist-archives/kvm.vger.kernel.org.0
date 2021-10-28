Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B452C43E2CB
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 15:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhJ1N7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 09:59:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30220 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230340AbhJ1N7S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 09:59:18 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SDlSYM006329;
        Thu, 28 Oct 2021 13:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fFraQQdkI0wkheqceR5580xfnKYM3FeeWyG1u7ys9FQ=;
 b=hvny3ymObSfNr5gViutblsaeM68GJTt5J569x5Z796LVr+OlrnL7h32n22RElftJ0vz3
 qHXxAdYoQRAieyTPo1qmzKheC0jiSpAfCOuF4OF/K17tW4weZzR7WkEwslBiqOZuWJQF
 +I+gKRi2lOra61+jo4sTBWCaDeUiYFm8NokGe8N4KBJbp4VByDni2UZd6qH5uQa3Ftzz
 kN/o3l44ri3AKV2ju/FUV2iDfQytNmlXfNPHBfgw06ClIJ2+cI84vmBlfp3mtmPvlOPw
 Z1W5X5bzJ75N2daopUBfHr4srDPPmnPN8C7JX8v+/FW4Dk6p2TKh/2fZHUodkP1AVD6c 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byw29859r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SDmWDR008382;
        Thu, 28 Oct 2021 13:56:50 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byw298598-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:50 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SDrQr6029609;
        Thu, 28 Oct 2021 13:56:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3bx4f60cru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SDujJq61800910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 13:56:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1385DA4060;
        Thu, 28 Oct 2021 13:56:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABBEFA405B;
        Thu, 28 Oct 2021 13:56:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 13:56:44 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: s390: gaccess: Refactor access address range check
Date:   Thu, 28 Oct 2021 15:55:55 +0200
Message-Id: <20211028135556.1793063-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028135556.1793063-1-scgl@linux.ibm.com>
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RjR4v4gw0Ef8xI-8RBBwCkiufGw9Rhvl
X-Proofpoint-GUID: AUiqt7xacZLN6qHyVpP4vatCepGEhamY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not round down the first address to the page boundary, just translate
it normally, which gives the value we care about in the first place.
Given this, translating a single address is just the special case of
translating a range spanning a single page.

Make the output optional, so the function can be used to just check a
range.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 122 +++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 53 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 0d11cea92603..7725dd7566ed 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -794,35 +794,74 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
-			    unsigned long *pages, unsigned long nr_pages,
-			    const union asce asce, enum gacc_mode mode)
+/**
+ * guest_range_to_gpas() - Calculate guest physical addresses of page fragments
+ * covering a logical range
+ * @vcpu: virtual cpu
+ * @ga: guest address, start of range
+ * @ar: access register
+ * @gpas: output argument, may be NULL
+ * @len: length of range in bytes
+ * @asce: address-space-control element to use for translation
+ * @mode: access mode
+ *
+ * Translate a logical range to a series of guest absolute addresses,
+ * such that the concatenation of page fragments starting at each gpa make up
+ * the whole range.
+ * The translation is performed as if done by the cpu for the given @asce, @ar,
+ * @mode and state of the @vcpu.
+ * If the translation causes an exception, its program interruption code is
+ * returned and the &struct kvm_s390_pgm_info pgm member of @vcpu is modified
+ * such that a subsequent call to kvm_s390_inject_prog_vcpu() will inject
+ * a correct exception into the guest.
+ * The resulting gpas are stored into @gpas, unless it is NULL.
+ *
+ * Note: All gpas except the first one start at the beginning of a page.
+ *       When deriving the boundaries of a fragment from a gpa, all but the last
+ *       fragment end at the end of the page.
+ *
+ * Return:
+ * * 0		- success
+ * * <0		- translation could not be performed, for example if  guest
+ *		  memory could not be accessed
+ * * >0		- an access exception occurred. In this case the returned value
+ *		  is the program interruption code and the contents of pgm may
+ *		  be used to inject an exception into the guest.
+ */
+static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
+			       unsigned long *gpas, unsigned long len,
+			       const union asce asce, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
+	unsigned int offset = offset_in_page(ga);
+	unsigned int fragment_len;
 	int lap_enabled, rc = 0;
 	enum prot_type prot;
+	unsigned long gpa;
 
 	lap_enabled = low_address_protection_enabled(vcpu, asce);
-	while (nr_pages) {
+	while (min(PAGE_SIZE - offset, len) > 0) {
+		fragment_len = min(PAGE_SIZE - offset, len);
 		ga = kvm_s390_logical_to_effective(vcpu, ga);
 		if (mode == GACC_STORE && lap_enabled && is_low_address(ga))
 			return trans_exc(vcpu, PGM_PROTECTION, ga, ar, mode,
 					 PROT_TYPE_LA);
-		ga &= PAGE_MASK;
 		if (psw_bits(*psw).dat) {
-			rc = guest_translate(vcpu, ga, pages, asce, mode, &prot);
+			rc = guest_translate(vcpu, ga, &gpa, asce, mode, &prot);
 			if (rc < 0)
 				return rc;
 		} else {
-			*pages = kvm_s390_real_to_abs(vcpu, ga);
-			if (kvm_is_error_gpa(vcpu->kvm, *pages))
+			gpa = kvm_s390_real_to_abs(vcpu, ga);
+			if (kvm_is_error_gpa(vcpu->kvm, gpa))
 				rc = PGM_ADDRESSING;
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
-		ga += PAGE_SIZE;
-		pages++;
-		nr_pages--;
+		if (gpas)
+			*gpas++ = gpa;
+		offset = 0;
+		ga += fragment_len;
+		len -= fragment_len;
 	}
 	return 0;
 }
@@ -831,10 +870,10 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	unsigned long nr_pages, gpa, idx;
+	unsigned long nr_pages, idx;
 	unsigned int fragment_len;
-	unsigned long pages_array[2];
-	unsigned long *pages;
+	unsigned long gpa_array[2];
+	unsigned long *gpas;
 	int need_ipte_lock;
 	union asce asce;
 	int rc;
@@ -846,30 +885,28 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 	if (rc)
 		return rc;
 	nr_pages = (((ga & ~PAGE_MASK) + len - 1) >> PAGE_SHIFT) + 1;
-	pages = pages_array;
-	if (nr_pages > ARRAY_SIZE(pages_array))
-		pages = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
-	if (!pages)
+	gpas = gpa_array;
+	if (nr_pages > ARRAY_SIZE(gpa_array))
+		gpas = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
+	if (!gpas)
 		return -ENOMEM;
 	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
 	if (need_ipte_lock)
 		ipte_lock(vcpu);
-	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
+	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
 	for (idx = 0; idx < nr_pages && !rc; idx++) {
-		gpa = pages[idx] + offset_in_page(ga);
-		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
+		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
 		if (mode == GACC_STORE)
-			rc = kvm_write_guest(vcpu->kvm, gpa, data, fragment_len);
+			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
 		else
-			rc = kvm_read_guest(vcpu->kvm, gpa, data, fragment_len);
+			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
 		len -= fragment_len;
-		ga += fragment_len;
 		data += fragment_len;
 	}
 	if (need_ipte_lock)
 		ipte_unlock(vcpu);
-	if (nr_pages > ARRAY_SIZE(pages_array))
-		vfree(pages);
+	if (nr_pages > ARRAY_SIZE(gpa_array))
+		vfree(gpas);
 	return rc;
 }
 
@@ -911,8 +948,6 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 			    unsigned long *gpa, enum gacc_mode mode)
 {
-	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	enum prot_type prot;
 	union asce asce;
 	int rc;
 
@@ -920,23 +955,7 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
 	if (rc)
 		return rc;
-	if (is_low_address(gva) && low_address_protection_enabled(vcpu, asce)) {
-		if (mode == GACC_STORE)
-			return trans_exc(vcpu, PGM_PROTECTION, gva, 0,
-					 mode, PROT_TYPE_LA);
-	}
-
-	if (psw_bits(*psw).dat && !asce.r) {	/* Use DAT? */
-		rc = guest_translate(vcpu, gva, gpa, asce, mode, &prot);
-		if (rc > 0)
-			return trans_exc(vcpu, rc, gva, 0, mode, prot);
-	} else {
-		*gpa = kvm_s390_real_to_abs(vcpu, gva);
-		if (kvm_is_error_gpa(vcpu->kvm, *gpa))
-			return trans_exc(vcpu, rc, gva, PGM_ADDRESSING, mode, 0);
-	}
-
-	return rc;
+	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode);
 }
 
 /**
@@ -950,17 +969,14 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 		    unsigned long length, enum gacc_mode mode)
 {
-	unsigned long gpa;
-	unsigned long currlen;
+	union asce asce;
 	int rc = 0;
 
+	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
+	if (rc)
+		return rc;
 	ipte_lock(vcpu);
-	while (length > 0 && !rc) {
-		currlen = min(length, PAGE_SIZE - (gva % PAGE_SIZE));
-		rc = guest_translate_address(vcpu, gva, ar, &gpa, mode);
-		gva += currlen;
-		length -= currlen;
-	}
+	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode);
 	ipte_unlock(vcpu);
 
 	return rc;
-- 
2.25.1

