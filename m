Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8218649232E
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiARJwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:52:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234380AbiARJwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:33 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8Vr4V030325;
        Tue, 18 Jan 2022 09:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3KT9nJZDGyglxojgRqw7KuzaPeJdOtkGkgNzbxG7RXc=;
 b=dPyV0PQQhVR7WXvHkGRnlh37d5XsQOiXxzYIKZNV/TsTeHE9wmRXuqJf6FX72tcYOQtU
 v4pXDnTnXexcWgji0XOLjX7haxEwCB3UWnOrbgEMx76JaBpbOyeLd4z5H3U/ChO+VP57
 szF2oLcIdWJRmY8MSg4RkgjYbTRbpEEANdzhJ4z7QCnPbSG93Wb+DAFczmos63NE6AcZ
 OAyN8KqQLQ4dzAPCl0VVp7L3U3RR6vZVtpMl7QMGNZZB1bSYa1ByMA9KcDrqCf10ezU0
 VmIk/anwiDUHEy/mEdoAmr6L8DuB7ShYygSXMjxJB47phKrFRnCftyEmY/yVzJegSNxN XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnt4dhf64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:32 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9Nx9l001544;
        Tue, 18 Jan 2022 09:52:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnt4dhf5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9fbZX017003;
        Tue, 18 Jan 2022 09:52:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3dknw92mty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9qP4h41222560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:52:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E77B8A4059;
        Tue, 18 Jan 2022 09:52:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 852ACA4051;
        Tue, 18 Jan 2022 09:52:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:24 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked guest absolute memory access
Date:   Tue, 18 Jan 2022 10:52:06 +0100
Message-Id: <20220118095210.1651483-7-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MvWMyQqQZK_qtRZn9TI4h-ELg6w_yiVw
X-Proofpoint-GUID: NTn5H92WuraVIvPztKTrcDbGGhMmgw5W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Channel I/O honors storage keys and is performed on absolute memory.
For I/O emulation user space therefore needs to be able to do key
checked accesses.
The vm IOCTL supports read/write accesses, as well as checking
if an access would succeed.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c  | 72 +++++++++++++++++++++++++++++++++++
 arch/s390/kvm/gaccess.h  |  6 +++
 arch/s390/kvm/kvm-s390.c | 81 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  2 +
 4 files changed, 161 insertions(+)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index efe33cda38b6..db1d9a494f77 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -795,6 +795,35 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static int vm_check_access_key(struct kvm *kvm, char access_key,
+			       enum gacc_mode mode, gpa_t gpa)
+{
+	unsigned long hva;
+	unsigned char storage_key, access_control;
+	bool fetch_protected;
+	int r;
+
+	if (access_key == 0)
+		return 0;
+
+	hva = gfn_to_hva(kvm, gpa_to_gfn(gpa));
+	if (kvm_is_error_hva(hva))
+		return PGM_ADDRESSING;
+
+	mmap_read_lock(current->mm);
+	r = get_guest_storage_key(current->mm, hva, &storage_key);
+	mmap_read_unlock(current->mm);
+	if (r)
+		return r;
+	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
+	if (access_control == access_key)
+		return 0;
+	fetch_protected = storage_key & _PAGE_FP_BIT;
+	if ((mode == GACC_FETCH || mode == GACC_IFETCH) && !fetch_protected)
+		return 0;
+	return PGM_PROTECTION;
+}
+
 static bool fetch_prot_override_applicable(struct kvm_vcpu *vcpu, enum gacc_mode mode,
 					   union asce asce)
 {
@@ -990,6 +1019,26 @@ access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	return 0;
 }
 
+int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
+			      unsigned long len, enum gacc_mode mode, char key)
+{
+	int offset = offset_in_page(gpa);
+	int fragment_len;
+	int rc;
+
+	while (min(PAGE_SIZE - offset, len) > 0) {
+		fragment_len = min(PAGE_SIZE - offset, len);
+		rc = access_guest_page_with_key(kvm, mode, gpa, data, fragment_len, key);
+		if (rc)
+			return rc;
+		offset = 0;
+		len -= fragment_len;
+		data += fragment_len;
+		gpa += fragment_len;
+	}
+	return 0;
+}
+
 int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			  void *data, unsigned long len, enum gacc_mode mode,
 			  char access_key)
@@ -1131,6 +1180,29 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 	return rc;
 }
 
+/**
+ * check_gpa_range - test a range of guest physical addresses for accessibility
+ * @kvm: virtual machine instance
+ * @gpa: guest physical address
+ * @length: length of test range
+ * @mode: access mode to test, relevant for storage keys
+ * @access_key: access key to mach the storage keys with
+ */
+int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
+		    enum gacc_mode mode, char access_key)
+{
+	unsigned int fragment_len;
+	int rc = 0;
+
+	while (length && !rc) {
+		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), length);
+		rc = vm_check_access_key(kvm, access_key, mode, gpa);
+		length -= fragment_len;
+		gpa += fragment_len;
+	}
+	return rc;
+}
+
 /**
  * kvm_s390_check_low_addr_prot_real - check for low-address protection
  * @vcpu: virtual cpu
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 0d4416178bb6..d89178b92d51 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -194,6 +194,12 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 		    unsigned long length, enum gacc_mode mode,
 		    char access_key);
 
+int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
+		    enum gacc_mode mode, char access_key);
+
+int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
+			      unsigned long len, enum gacc_mode mode, char key);
+
 int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			  void *data, unsigned long len, enum gacc_mode mode,
 			  char access_key);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c4acdb025ff1..8dab956f84a6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2390,6 +2390,78 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 	return r;
 }
 
+static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
+{
+	static const __u8 zeros[sizeof(mop->reserved)] = {0};
+	void __user *uaddr = (void __user *)mop->buf;
+	u64 supported_flags;
+	void *tmpbuf = NULL;
+	char access_key;
+	int r, srcu_idx;
+
+	access_key = FIELD_GET(KVM_S390_MEMOP_F_SKEYS_ACC, mop->flags);
+	supported_flags = KVM_S390_MEMOP_F_SKEYS_ACC
+			  | KVM_S390_MEMOP_F_CHECK_ONLY;
+	if (mop->flags & ~supported_flags)
+		return -EINVAL;
+	if (mop->size > MEM_OP_MAX_SIZE)
+		return -E2BIG;
+	if (kvm_s390_pv_is_protected(kvm))
+		return -EINVAL;
+	if (memcmp(mop->reserved, zeros, sizeof(zeros)) != 0)
+		return -EINVAL;
+
+	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
+		tmpbuf = vmalloc(mop->size);
+		if (!tmpbuf)
+			return -ENOMEM;
+	}
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	if (kvm_is_error_gpa(kvm, mop->gaddr)) {
+		r = PGM_ADDRESSING;
+		goto out_unlock;
+	}
+
+	switch (mop->op) {
+	case KVM_S390_MEMOP_ABSOLUTE_READ: {
+		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
+			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_FETCH, access_key);
+		} else {
+			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
+						      mop->size, GACC_FETCH, access_key);
+			if (r == 0) {
+				if (copy_to_user(uaddr, tmpbuf, mop->size))
+					r = -EFAULT;
+			}
+		}
+		break;
+	}
+	case KVM_S390_MEMOP_ABSOLUTE_WRITE: {
+		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
+			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_STORE, access_key);
+		} else {
+			if (copy_from_user(tmpbuf, uaddr, mop->size)) {
+				r = -EFAULT;
+				break;
+			}
+			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
+						      mop->size, GACC_STORE, access_key);
+		}
+		break;
+	}
+	default:
+		r = -EINVAL;
+	}
+
+out_unlock:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	vfree(tmpbuf);
+	return r;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -2514,6 +2586,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		}
 		break;
 	}
+	case KVM_S390_MEM_OP: {
+		struct kvm_s390_mem_op mem_op;
+
+		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
+			r = kvm_s390_vm_mem_op(kvm, &mem_op);
+		else
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e3f450b2f346..dd04170287fd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -572,6 +572,8 @@ struct kvm_s390_mem_op {
 #define KVM_S390_MEMOP_LOGICAL_WRITE	1
 #define KVM_S390_MEMOP_SIDA_READ	2
 #define KVM_S390_MEMOP_SIDA_WRITE	3
+#define KVM_S390_MEMOP_ABSOLUTE_READ	4
+#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
-- 
2.32.0

