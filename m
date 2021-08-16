Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C913ED980
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhHPPIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:08:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232237AbhHPPID (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:08:03 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GF3L4t066280;
        Mon, 16 Aug 2021 11:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=idIoQptoum6bdzEt6k8sne2CNQA0syDdMm27KNu2Pqo=;
 b=fOFF2IC9mBQFLaMekSdTcTd24fchsCoJAD8QjPu1YnpSwOB761qTJfR3npsyVPbaYcro
 BWtvchdWe98eWs6kH9/g3g71fkBSIoIDYW9/StU1c6WnGOAB6c8J8O9tZH1Q5zGdnyjC
 SWKrpwIv5Rlf6HxC8IQJE02699KYsPXsW4eA+8HMoatW9WgBNls/Dc0JCPEYT/ADrOGo
 tYXpNSk4wYtzVwDhyLhvHRsWDlQbYIY0vtwHnRGVN0N30t3w9ve7G2orKIS49YHZ8mG2
 YnuavYBsCLEFVCShr4iQjYAi4BNF5Krq0J5xmPZ0koaXaX771GydWVMdilWKZOveDlwY kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeuf5at7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GF3P14066758;
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeuf5at7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GF4wrj030475;
        Mon, 16 Aug 2021 15:07:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53huf8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 15:07:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GF42jY61735346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 15:04:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1917F11C073;
        Mon, 16 Aug 2021 15:07:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0E7211C058;
        Mon, 16 Aug 2021 15:07:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 15:07:24 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     scgl@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: s390: gaccess: Refactor access address range check
Date:   Mon, 16 Aug 2021 17:07:17 +0200
Message-Id: <20210816150718.3063877-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210816150718.3063877-1-scgl@linux.ibm.com>
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ph3PIyCGjJi1BAiCM9LlFgthIG0LDG_2
X-Proofpoint-ORIG-GUID: om-axbRKKXqQhck5o2wgHntwvl3hfMRp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_05:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 mlxscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160096
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
 arch/s390/kvm/gaccess.c | 91 ++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 52 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index df83de0843de..e5a19d8b30e2 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -794,35 +794,45 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
-			    unsigned long *pages, unsigned long nr_pages,
-			    const union asce asce, enum gacc_mode mode)
+/* Stores the gpas for each page in a real/virtual range into @gpas
+ * Modifies the 'struct kvm_s390_pgm_info pgm' member of @vcpu in the same
+ * way read_guest/write_guest do, the meaning of the return value is likewise
+ * the same.
+ * If @gpas is NULL only the checks are performed.
+ */
+static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
+			       unsigned long *gpas, unsigned long len,
+			       const union asce asce, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
+	unsigned long gpa;
+	unsigned int seg;
+	unsigned int offset = offset_in_page(ga);
 	int lap_enabled, rc = 0;
 	enum prot_type prot;
 
 	lap_enabled = low_address_protection_enabled(vcpu, asce);
-	while (nr_pages) {
+	while ((seg = min(PAGE_SIZE - offset, len)) != 0) {
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
+		ga += seg;
+		len -= seg;
 	}
 	return 0;
 }
@@ -845,10 +855,10 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	unsigned long nr_pages, gpa, idx;
+	unsigned long nr_pages, idx;
 	unsigned int seg;
-	unsigned long pages_array[2];
-	unsigned long *pages;
+	unsigned long gpa_array[2];
+	unsigned long *gpas;
 	int need_ipte_lock;
 	union asce asce;
 	int rc;
@@ -860,27 +870,25 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
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
-		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
-		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
+		seg = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
+		rc = access_guest_frame(vcpu->kvm, mode, gpas[idx], data, seg);
 		len -= seg;
-		ga += seg;
 		data += seg;
 	}
 	if (need_ipte_lock)
 		ipte_unlock(vcpu);
-	if (nr_pages > ARRAY_SIZE(pages_array))
-		vfree(pages);
+	if (nr_pages > ARRAY_SIZE(gpa_array))
+		vfree(gpas);
 	return rc;
 }
 
@@ -914,8 +922,6 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 			    unsigned long *gpa, enum gacc_mode mode)
 {
-	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	enum prot_type prot;
 	union asce asce;
 	int rc;
 
@@ -923,23 +929,7 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
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
@@ -948,17 +938,14 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
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

