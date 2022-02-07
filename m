Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F654AC6F7
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382759AbiBGROw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357832AbiBGRAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:00:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268B7C0401D9;
        Mon,  7 Feb 2022 09:00:08 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217GxZc2031217;
        Mon, 7 Feb 2022 17:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5AM5qa69io2/br3Nl95Nl/F7R/wwRSZ0C81l3n0Yr2M=;
 b=tL/4d9Y/58CarlfLAHxTa7SYUTjvI+yOnJgMmma6yZrn3M6TaOKX2Ql6+AaFczD/odr8
 i/VAjp+rJu19ji3ZyG+DaNBgRGn4K3RZCgfWOWkmLr6GdTZn9ywseIdYbI/k+oN1lOKi
 cMqqgIMnYPsMvSUcbGEkqK26wRpO3Lp3iDY24A1CLGJL+kxki7Hyc+7fRqZR8HV+2OJb
 FF3bNPuDKmH8w6A7ykJXuaOODkveFTV7rulAQ9zGPnrrEyGoKhA9r6+4BhypxMxzp0zv
 ZpmrCQ1bBjmTnxgjf7rkbprCQyQVU/2TIFcSbGy5inkWpcxvggZb5JGR89S1lAbe2gjr ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23ap16nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:07 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217H06vZ001765;
        Mon, 7 Feb 2022 17:00:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23ap16mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:06 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217GqDNI003223;
        Mon, 7 Feb 2022 17:00:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3e1gv960du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217H00vK42926590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 17:00:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F19DA405D;
        Mon,  7 Feb 2022 17:00:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12BB8A404D;
        Mon,  7 Feb 2022 17:00:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 17:00:00 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v2 02/11] KVM: s390: Honor storage keys when accessing guest memory
Date:   Mon,  7 Feb 2022 17:59:21 +0100
Message-Id: <20220207165930.1608621-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207165930.1608621-1-scgl@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0vSrTICKLwycduzmvTNmYsqwSF6xZ9Oi
X-Proofpoint-ORIG-GUID: pY7kJ8-04FPUA9dVXLIX2xHa1_yds08w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Storage key checking had not been implemented for instructions emulated
by KVM. Implement it by enhancing the functions used for guest access,
in particular those making use of access_guest which has been renamed
to access_guest_with_key.
Accesses via access_guest_real should not be key checked.

For actual accesses, key checking is done by
copy_from/to_user_key (which internally uses MVCOS/MVCP/MVCS).
In cases where accessibility is checked without an actual access,
this is performed by getting the storage key and checking if the access
key matches. In both cases, if applicable, storage and fetch protection
override are honored.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/ctl_reg.h |   2 +
 arch/s390/include/asm/page.h    |   2 +
 arch/s390/kvm/gaccess.c         | 187 ++++++++++++++++++++++++++++++--
 arch/s390/kvm/gaccess.h         |  77 +++++++++++--
 arch/s390/kvm/intercept.c       |  12 +-
 arch/s390/kvm/kvm-s390.c        |   4 +-
 6 files changed, 253 insertions(+), 31 deletions(-)

diff --git a/arch/s390/include/asm/ctl_reg.h b/arch/s390/include/asm/ctl_reg.h
index 04dc65f8901d..c800199a376b 100644
--- a/arch/s390/include/asm/ctl_reg.h
+++ b/arch/s390/include/asm/ctl_reg.h
@@ -12,6 +12,8 @@
 
 #define CR0_CLOCK_COMPARATOR_SIGN	BIT(63 - 10)
 #define CR0_LOW_ADDRESS_PROTECTION	BIT(63 - 35)
+#define CR0_FETCH_PROTECTION_OVERRIDE	BIT(63 - 38)
+#define CR0_STORAGE_PROTECTION_OVERRIDE	BIT(63 - 39)
 #define CR0_EMERGENCY_SIGNAL_SUBMASK	BIT(63 - 49)
 #define CR0_EXTERNAL_CALL_SUBMASK	BIT(63 - 50)
 #define CR0_CLOCK_COMPARATOR_SUBMASK	BIT(63 - 52)
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index d98d17a36c7b..cfc4d6fb2385 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -20,6 +20,8 @@
 #define PAGE_SIZE	_PAGE_SIZE
 #define PAGE_MASK	_PAGE_MASK
 #define PAGE_DEFAULT_ACC	0
+/* storage-protection override */
+#define PAGE_SPO_ACC		9
 #define PAGE_DEFAULT_KEY	(PAGE_DEFAULT_ACC << 4)
 
 #define HPAGE_SHIFT	20
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 4460808c3b9a..7fca0cff4c12 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -10,6 +10,7 @@
 #include <linux/mm_types.h>
 #include <linux/err.h>
 #include <linux/pgtable.h>
+#include <linux/bitfield.h>
 
 #include <asm/gmap.h>
 #include "kvm-s390.h"
@@ -794,6 +795,79 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static bool fetch_prot_override_applicable(struct kvm_vcpu *vcpu, enum gacc_mode mode,
+					   union asce asce)
+{
+	psw_t *psw = &vcpu->arch.sie_block->gpsw;
+	unsigned long override;
+
+	if (mode == GACC_FETCH || mode == GACC_IFETCH) {
+		/* check if fetch protection override enabled */
+		override = vcpu->arch.sie_block->gcr[0];
+		override &= CR0_FETCH_PROTECTION_OVERRIDE;
+		/* not applicable if subject to DAT && private space */
+		override = override && !(psw_bits(*psw).dat && asce.p);
+		return override;
+	}
+	return false;
+}
+
+static bool fetch_prot_override_applies(unsigned long ga, unsigned int len)
+{
+	return ga < 2048 && ga + len <= 2048;
+}
+
+static bool storage_prot_override_applicable(struct kvm_vcpu *vcpu)
+{
+	/* check if storage protection override enabled */
+	return vcpu->arch.sie_block->gcr[0] & CR0_STORAGE_PROTECTION_OVERRIDE;
+}
+
+static bool storage_prot_override_applies(u8 access_control)
+{
+	/* matches special storage protection override key (9) -> allow */
+	return access_control == PAGE_SPO_ACC;
+}
+
+static int vcpu_check_access_key(struct kvm_vcpu *vcpu, u8 access_key,
+				 enum gacc_mode mode, union asce asce, gpa_t gpa,
+				 unsigned long ga, unsigned int len)
+{
+	u8 storage_key, access_control;
+	unsigned long hva;
+	int r;
+
+	/* access key 0 matches any storage key -> allow */
+	if (access_key == 0)
+		return 0;
+	/*
+	 * caller needs to ensure that gfn is accessible, so we can
+	 * assume that this cannot fail
+	 */
+	hva = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gpa));
+	mmap_read_lock(current->mm);
+	r = get_guest_storage_key(current->mm, hva, &storage_key);
+	mmap_read_unlock(current->mm);
+	if (r)
+		return r;
+	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
+	/* access key matches storage key -> allow */
+	if (access_control == access_key)
+		return 0;
+	if (mode == GACC_FETCH || mode == GACC_IFETCH) {
+		/* it is a fetch and fetch protection is off -> allow */
+		if (!(storage_key & _PAGE_FP_BIT))
+			return 0;
+		if (fetch_prot_override_applicable(vcpu, mode, asce) &&
+		    fetch_prot_override_applies(ga, len))
+			return 0;
+	}
+	if (storage_prot_override_applicable(vcpu) &&
+	    storage_prot_override_applies(access_control))
+		return 0;
+	return PGM_PROTECTION;
+}
+
 /**
  * guest_range_to_gpas() - Calculate guest physical addresses of page fragments
  * covering a logical range
@@ -804,6 +878,7 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
  * @len: length of range in bytes
  * @asce: address-space-control element to use for translation
  * @mode: access mode
+ * @access_key: access key to mach the range's storage keys against
  *
  * Translate a logical range to a series of guest absolute addresses,
  * such that the concatenation of page fragments starting at each gpa make up
@@ -830,7 +905,8 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
  */
 static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			       unsigned long *gpas, unsigned long len,
-			       const union asce asce, enum gacc_mode mode)
+			       const union asce asce, enum gacc_mode mode,
+			       u8 access_key)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
 	unsigned int offset = offset_in_page(ga);
@@ -857,6 +933,10 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
+		rc = vcpu_check_access_key(vcpu, access_key, mode, asce, gpa, ga,
+					   fragment_len);
+		if (rc)
+			return trans_exc(vcpu, rc, ga, ar, mode, PROT_TYPE_KEYC);
 		if (gpas)
 			*gpas++ = gpa;
 		offset = 0;
@@ -880,16 +960,54 @@ static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	return rc;
 }
 
-int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
-		 unsigned long len, enum gacc_mode mode)
+static int
+access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+			   void *data, unsigned int len, u8 access_key)
+{
+	struct kvm_memory_slot *slot;
+	bool writable;
+	gfn_t gfn;
+	hva_t hva;
+	int rc;
+
+	gfn = gpa >> PAGE_SHIFT;
+	slot = gfn_to_memslot(kvm, gfn);
+	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
+
+	if (kvm_is_error_hva(hva))
+		return PGM_ADDRESSING;
+	/*
+	 * Check if it's a ro memslot, even tho that can't occur (they're unsupported).
+	 * Don't try to actually handle that case.
+	 */
+	if (!writable && mode == GACC_STORE)
+		return -EOPNOTSUPP;
+	hva += offset_in_page(gpa);
+	if (mode == GACC_STORE)
+		rc = copy_to_user_key((void __user *)hva, data, len, access_key);
+	else
+		rc = copy_from_user_key(data, (void __user *)hva, len, access_key);
+	if (rc)
+		return PGM_PROTECTION;
+	if (mode == GACC_STORE)
+		mark_page_dirty_in_slot(kvm, slot, gfn);
+	return 0;
+}
+
+int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
+			  void *data, unsigned long len, enum gacc_mode mode,
+			  u8 access_key)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
 	unsigned long nr_pages, idx;
 	unsigned long gpa_array[2];
 	unsigned int fragment_len;
 	unsigned long *gpas;
+	enum prot_type prot;
 	int need_ipte_lock;
 	union asce asce;
+	bool try_storage_prot_override;
+	bool try_fetch_prot_override;
 	int rc;
 
 	if (!len)
@@ -904,16 +1022,47 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		gpas = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
 	if (!gpas)
 		return -ENOMEM;
+	try_fetch_prot_override = fetch_prot_override_applicable(vcpu, mode, asce);
+	try_storage_prot_override = storage_prot_override_applicable(vcpu);
 	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
 	if (need_ipte_lock)
 		ipte_lock(vcpu);
-	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
-	for (idx = 0; idx < nr_pages && !rc; idx++) {
+	/*
+	 * Since we do the access further down ultimately via a move instruction
+	 * that does key checking and returns an error in case of a protection
+	 * violation, we don't need to do the check during address translation.
+	 * Skip it by passing access key 0, which matches any storage key,
+	 * obviating the need for any further checks. As a result the check is
+	 * handled entirely in hardware on access, we only need to take care to
+	 * forego key protection checking if fetch protection override applies or
+	 * retry with the special key 9 in case of storage protection override.
+	 */
+	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode, 0);
+	if (rc)
+		goto out_unlock;
+	for (idx = 0; idx < nr_pages; idx++) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
-		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
+		if (try_fetch_prot_override && fetch_prot_override_applies(ga, fragment_len)) {
+			rc = access_guest_page(vcpu->kvm, mode, gpas[idx],
+					       data, fragment_len);
+		} else {
+			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
+							data, fragment_len, access_key);
+		}
+		if (rc == PGM_PROTECTION && try_storage_prot_override)
+			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
+							data, fragment_len, PAGE_SPO_ACC);
+		if (rc == PGM_PROTECTION)
+			prot = PROT_TYPE_KEYC;
+		if (rc)
+			break;
 		len -= fragment_len;
 		data += fragment_len;
+		ga = kvm_s390_logical_to_effective(vcpu, ga + fragment_len);
 	}
+	if (rc > 0)
+		rc = trans_exc(vcpu, rc, ga, ar, mode, prot);
+out_unlock:
 	if (need_ipte_lock)
 		ipte_unlock(vcpu);
 	if (nr_pages > ARRAY_SIZE(gpa_array))
@@ -940,12 +1089,13 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 }
 
 /**
- * guest_translate_address - translate guest logical into guest absolute address
+ * guest_translate_address_with_key - translate guest logical into guest absolute address
  * @vcpu: virtual cpu
  * @gva: Guest virtual address
  * @ar: Access register
  * @gpa: Guest physical address
  * @mode: Translation access mode
+ * @access_key: access key to mach the storage key with
  *
  * Parameter semantics are the same as the ones from guest_translate.
  * The memory contents at the guest address are not changed.
@@ -953,8 +1103,9 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  * Note: The IPTE lock is not taken during this function, so the caller
  * has to take care of this.
  */
-int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
-			    unsigned long *gpa, enum gacc_mode mode)
+int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
+				     unsigned long *gpa, enum gacc_mode mode,
+				     u8 access_key)
 {
 	union asce asce;
 	int rc;
@@ -963,7 +1114,17 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
 	if (rc)
 		return rc;
-	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode);
+	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode,
+				   access_key);
+}
+
+int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
+			    unsigned long *gpa, enum gacc_mode mode)
+{
+	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
+
+	return guest_translate_address_with_key(vcpu, gva, ar, gpa, mode,
+						access_key);
 }
 
 /**
@@ -973,9 +1134,10 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
  * @ar: Access register
  * @length: Length of test range
  * @mode: Translation access mode
+ * @access_key: access key to mach the storage keys with
  */
 int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
-		    unsigned long length, enum gacc_mode mode)
+		    unsigned long length, enum gacc_mode mode, u8 access_key)
 {
 	union asce asce;
 	int rc = 0;
@@ -984,7 +1146,8 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 	if (rc)
 		return rc;
 	ipte_lock(vcpu);
-	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode);
+	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode,
+				 access_key);
 	ipte_unlock(vcpu);
 
 	return rc;
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 7c72a5e3449f..e5b2f56e7962 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -186,24 +186,31 @@ enum gacc_mode {
 	GACC_IFETCH,
 };
 
+int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
+				     unsigned long *gpa, enum gacc_mode mode,
+				     u8 access_key);
+
 int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva,
 			    u8 ar, unsigned long *gpa, enum gacc_mode mode);
+
 int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
-		    unsigned long length, enum gacc_mode mode);
+		    unsigned long length, enum gacc_mode mode, u8 access_key);
 
-int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
-		 unsigned long len, enum gacc_mode mode);
+int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
+			  void *data, unsigned long len, enum gacc_mode mode,
+			  u8 access_key);
 
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode);
 
 /**
- * write_guest - copy data from kernel space to guest space
+ * write_guest_with_key - copy data from kernel space to guest space
  * @vcpu: virtual cpu
  * @ga: guest address
  * @ar: access register
  * @data: source address in kernel space
  * @len: number of bytes to copy
+ * @access_key: access key the storage key needs to match
  *
  * Copy @len bytes from @data (kernel space) to @ga (guest address).
  * In order to copy data to guest space the PSW of the vcpu is inspected:
@@ -214,8 +221,8 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  * The addressing mode of the PSW is also inspected, so that address wrap
  * around is taken into account for 24-, 31- and 64-bit addressing mode,
  * if the to be copied data crosses page boundaries in guest address space.
- * In addition also low address and DAT protection are inspected before
- * copying any data (key protection is currently not implemented).
+ * In addition low address, DAT and key protection checks are performed before
+ * copying any data.
  *
  * This function modifies the 'struct kvm_s390_pgm_info pgm' member of @vcpu.
  * In case of an access exception (e.g. protection exception) pgm will contain
@@ -243,10 +250,53 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  *	 if data has been changed in guest space in case of an exception.
  */
 static inline __must_check
+int write_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
+			 void *data, unsigned long len, u8 access_key)
+{
+	return access_guest_with_key(vcpu, ga, ar, data, len, GACC_STORE,
+				     access_key);
+}
+
+/**
+ * write_guest - copy data from kernel space to guest space
+ * @vcpu: virtual cpu
+ * @ga: guest address
+ * @ar: access register
+ * @data: source address in kernel space
+ * @len: number of bytes to copy
+ *
+ * The behaviour of write_guest is identical to write_guest_with_key, except
+ * that the PSW access key is used instead of an explicit argument.
+ */
+static inline __must_check
 int write_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		unsigned long len)
 {
-	return access_guest(vcpu, ga, ar, data, len, GACC_STORE);
+	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
+
+	return write_guest_with_key(vcpu, ga, ar, data, len, access_key);
+}
+
+/**
+ * read_guest_with_key - copy data from guest space to kernel space
+ * @vcpu: virtual cpu
+ * @ga: guest address
+ * @ar: access register
+ * @data: destination address in kernel space
+ * @len: number of bytes to copy
+ * @access_key: access key the storage key needs to match
+ *
+ * Copy @len bytes from @ga (guest address) to @data (kernel space).
+ *
+ * The behaviour of read_guest_with_key is identical to write_guest_with_key,
+ * except that data will be copied from guest space to kernel space.
+ */
+static inline __must_check
+int read_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
+			void *data, unsigned long len, u8 access_key)
+{
+	return access_guest_with_key(vcpu, ga, ar, data, len, GACC_FETCH,
+				     access_key);
 }
 
 /**
@@ -259,14 +309,16 @@ int write_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
  *
  * Copy @len bytes from @ga (guest address) to @data (kernel space).
  *
- * The behaviour of read_guest is identical to write_guest, except that
- * data will be copied from guest space to kernel space.
+ * The behaviour of read_guest is identical to read_guest_with_key, except
+ * that the PSW access key is used instead of an explicit argument.
  */
 static inline __must_check
 int read_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 	       unsigned long len)
 {
-	return access_guest(vcpu, ga, ar, data, len, GACC_FETCH);
+	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
+
+	return read_guest_with_key(vcpu, ga, ar, data, len, access_key);
 }
 
 /**
@@ -287,7 +339,10 @@ static inline __must_check
 int read_guest_instr(struct kvm_vcpu *vcpu, unsigned long ga, void *data,
 		     unsigned long len)
 {
-	return access_guest(vcpu, ga, 0, data, len, GACC_IFETCH);
+	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
+
+	return access_guest_with_key(vcpu, ga, 0, data, len, GACC_IFETCH,
+				     access_key);
 }
 
 /**
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index d07ff646d844..8bd42a20d924 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -331,18 +331,18 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
-	/* Make sure that the source is paged-in */
-	rc = guest_translate_address(vcpu, vcpu->run->s.regs.gprs[reg2],
-				     reg2, &srcaddr, GACC_FETCH);
+	/* Ensure that the source is paged-in, no actual access -> no key checking */
+	rc = guest_translate_address_with_key(vcpu, vcpu->run->s.regs.gprs[reg2],
+					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 	rc = kvm_arch_fault_in_page(vcpu, srcaddr, 0);
 	if (rc != 0)
 		return rc;
 
-	/* Make sure that the destination is paged-in */
-	rc = guest_translate_address(vcpu, vcpu->run->s.regs.gprs[reg1],
-				     reg1, &dstaddr, GACC_STORE);
+	/* Ensure that the source is paged-in, no actual access -> no key checking */
+	rc = guest_translate_address_with_key(vcpu, vcpu->run->s.regs.gprs[reg1],
+					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 	rc = kvm_arch_fault_in_page(vcpu, dstaddr, 1);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 577f1ead6a51..cf347e1a4f17 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4711,7 +4711,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	case KVM_S390_MEMOP_LOGICAL_READ:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_FETCH);
+					    mop->size, GACC_FETCH, 0);
 			break;
 		}
 		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
@@ -4723,7 +4723,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_STORE);
+					    mop->size, GACC_STORE, 0);
 			break;
 		}
 		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
-- 
2.32.0

