Return-Path: <kvm+bounces-64371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F51C805F8
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CE7A94E4DE3
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3C6304BA3;
	Mon, 24 Nov 2025 11:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iXRZItCH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D793064AE;
	Mon, 24 Nov 2025 11:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985399; cv=none; b=M1ggyH8M8MADvQftVWAZU4k5UwCBMiV7Qdr/aRPOPz9+k1w2bZGowEwtvLhJtkVSUlfU4CivS3nWZ/ZaNlelp7pNCdHFwlZ5HlDuG4sKZ2FN0IQ1nICZh9aNQcBqxIrDSy0HBKXi01YyJsn/Q7o7ykgCZ+kaIKCiPCuYF7M2L8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985399; c=relaxed/simple;
	bh=MFTcp4Qqv8NBZAXQszOFf4DmX/Tj/WHhjFpHFi8o7yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5w3rzbt8ERnb/gn6Wascoaswpwtwr+vkPXU5SVdPi5rPxffsvBk0mdHhyV6IqBAWpKE3BOxwnQAjgAhplbckmfX7QylQUpiwfKs2ZVOOeHaeB+/hUe6n0Sgd4pGQfVCCndiXNclAMeXbNPfHiIxNtUrjHefpOXIee4vTdaMAjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iXRZItCH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO7OjJD018679;
	Mon, 24 Nov 2025 11:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mapCAmNqgXwN/Ykkw
	7AUF8CI6YMEvexdgSKLBhw1bsk=; b=iXRZItCH2MSP0Jz8JmhqOcMUHP+kJkFfJ
	MAFpKPiUBD9OpEWTsIl2WMiPrdILQa27BkBYEH94Lh9hdFQivr2RHSs7ToDE7RGF
	UZumdKmJPrLVw00VyQCT5FdUMPo52zaKctuD3AgnfLz3XFkaPpwABB0E4bdpZNKe
	tPl71ylqP7MD2uysjllIvdUBw+HvH/D0OPbNGf3/UMZsPF6QART2K2faeq5KG8Wl
	HijBwZB1caKK+JPPGIrW3XhLvHurXyXIjpt5SRyCaPdGpRVVM0Q0l+70rtdto82M
	wR25JmbVt8o9tLPXrFjADpNtETN9bXFiHIHnf9u9+XuvNS4X28Ltg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpqnsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO9uwZu030768;
	Mon, 24 Nov 2025 11:56:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgs5w8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBuUFj44827026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10FAD2004B;
	Mon, 24 Nov 2025 11:56:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1759520040;
	Mon, 24 Nov 2025 11:56:28 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:27 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 18/23] KVM: s390: Storage key functions refactoring
Date: Mon, 24 Nov 2025 12:55:49 +0100
Message-ID: <20251124115554.27049-19-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfX7n5o7Rx+CcAD
 +GoQGzLCmZ0YH2mOKMwlfWfQfcxbjUjzZ7CUJ4ZAGq5h3kko2QR7Vlnt05+GBF9F7ni/1Bks+xQ
 2xUUjxKmLU0snfSsxnQrGZ5peW0BeJPNiLgVHLQ4vkqE6s/0+ulvWvuPVXr1WdkxXuKHfLJPVka
 F8YsSiI4jJL/VXrZ5Bg9L5AlLlt1/1W2KeNvVMXpV+pygLbMdBRR6zk8wpqyfVPBQIsd1fi3m9p
 J4VKn5AbkYc5xXOOWomP0tHCku0bSPtJ8qBz6i6YWmd2m6ZZx6prK+Ad3Q2qXpokpulSF+DLM2H
 PIUCxoueoDXyH0z5rBCIVlNs8vvFpXQ94UTJEAzc185n/JKyUUjedqrRB4prAWldbDldc/ri4f3
 pIp8qU2WMq5lp00w7eBgajVw/bUv/A==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=692447f2 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=g1xfaEJ1DM-V_6iQr0UA:9
X-Proofpoint-GUID: xTsAnIL9iBwVZcxaQw2CPZ1713nvxj2n
X-Proofpoint-ORIG-GUID: xTsAnIL9iBwVZcxaQw2CPZ1713nvxj2n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

Refactor some storage key functions to improve readability.

Introduce helper functions that will be used in the next patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c  | 36 +++++++++---------
 arch/s390/kvm/gaccess.h  |  4 +-
 arch/s390/kvm/kvm-s390.c | 80 +++++++++++++++-------------------------
 arch/s390/kvm/kvm-s390.h |  8 ++++
 4 files changed, 58 insertions(+), 70 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 05fd3ee4b20d..a054de80a5cc 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -989,9 +989,8 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  *         * -EAGAIN: transient failure (len 1 or 2)
  *         * -EOPNOTSUPP: read-only memslot (should never occur)
  */
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len,
-			       __uint128_t *old_addr, __uint128_t new,
-			       u8 access_key, bool *success)
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old_addr,
+			       union kvm_s390_quad new, u8 acc, bool *success)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
@@ -1023,41 +1022,42 @@ int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len,
 	case 1: {
 		u8 old;
 
-		ret = cmpxchg_user_key((u8 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u8 __user *)hva, &old, old_addr->one, new.one, acc);
+		*success = !ret && old == old_addr->one;
+		old_addr->one = old;
 		break;
 	}
 	case 2: {
 		u16 old;
 
-		ret = cmpxchg_user_key((u16 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u16 __user *)hva, &old, old_addr->two, new.two, acc);
+		*success = !ret && old == old_addr->two;
+		old_addr->two = old;
 		break;
 	}
 	case 4: {
 		u32 old;
 
-		ret = cmpxchg_user_key((u32 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u32 __user *)hva, &old, old_addr->four, new.four, acc);
+		*success = !ret && old == old_addr->four;
+		old_addr->four = old;
 		break;
 	}
 	case 8: {
 		u64 old;
 
-		ret = cmpxchg_user_key((u64 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u64 __user *)hva, &old, old_addr->eight, new.eight, acc);
+		*success = !ret && old == old_addr->eight;
+		old_addr->eight = old;
 		break;
 	}
 	case 16: {
 		__uint128_t old;
 
-		ret = cmpxchg_user_key((__uint128_t __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((__uint128_t __user *)hva, &old, old_addr->sixteen,
+				       new.sixteen, acc);
+		*success = !ret && old == old_addr->sixteen;
+		old_addr->sixteen = old;
 		break;
 	}
 	default:
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 3fde45a151f2..774cdf19998f 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -206,8 +206,8 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode);
 
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, __uint128_t *old,
-			       __uint128_t new, u8 access_key, bool *success);
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old_addr,
+			       union kvm_s390_quad new, u8 access_key, bool *success);
 
 /**
  * write_guest_with_key - copy data from kernel space to guest space
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d7eff75a53d0..ab69c9fd7926 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2905,9 +2905,9 @@ static int mem_op_validate_common(struct kvm_s390_mem_op *mop, u64 supported_fla
 static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	void *tmpbuf __free(kvfree) = NULL;
 	enum gacc_mode acc_mode;
-	void *tmpbuf = NULL;
-	int r, srcu_idx;
+	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_SKEY_PROTECTION |
 					KVM_S390_MEMOP_F_CHECK_ONLY);
@@ -2920,52 +2920,36 @@ static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 			return -ENOMEM;
 	}
 
-	srcu_idx = srcu_read_lock(&kvm->srcu);
+	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
 
-	if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr)) {
-		r = PGM_ADDRESSING;
-		goto out_unlock;
-	}
+	scoped_guard(srcu, &kvm->srcu) {
+		if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr))
+			return PGM_ADDRESSING;
 
-	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
-	if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-		r = check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
-		goto out_unlock;
-	}
-	if (acc_mode == GACC_FETCH) {
+		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)
+			return check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
+
+		if (acc_mode == GACC_STORE && copy_from_user(tmpbuf, uaddr, mop->size))
+			return -EFAULT;
 		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-					      mop->size, GACC_FETCH, mop->key);
+					      mop->size, acc_mode, mop->key);
 		if (r)
-			goto out_unlock;
-		if (copy_to_user(uaddr, tmpbuf, mop->size))
-			r = -EFAULT;
-	} else {
-		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
-			r = -EFAULT;
-			goto out_unlock;
-		}
-		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-					      mop->size, GACC_STORE, mop->key);
+			return r;
+		if (acc_mode != GACC_STORE && copy_to_user(uaddr, tmpbuf, mop->size))
+			return -EFAULT;
 	}
 
-out_unlock:
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-
-	vfree(tmpbuf);
-	return r;
+	return 0;
 }
 
 static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void __user *old_addr = (void __user *)mop->old_addr;
-	union {
-		__uint128_t quad;
-		char raw[sizeof(__uint128_t)];
-	} old = { .quad = 0}, new = { .quad = 0 };
-	unsigned int off_in_quad = sizeof(new) - mop->size;
-	int r, srcu_idx;
-	bool success;
+	union kvm_s390_quad old = { .sixteen = 0 };
+	union kvm_s390_quad new = { .sixteen = 0 };
+	bool success = false;
+	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_SKEY_PROTECTION);
 	if (r)
@@ -2977,25 +2961,21 @@ static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *m
 	 */
 	if (mop->size > sizeof(new))
 		return -EINVAL;
-	if (copy_from_user(&new.raw[off_in_quad], uaddr, mop->size))
+	if (copy_from_user(&new, uaddr, mop->size))
 		return -EFAULT;
-	if (copy_from_user(&old.raw[off_in_quad], old_addr, mop->size))
+	if (copy_from_user(&old, old_addr, mop->size))
 		return -EFAULT;
 
-	srcu_idx = srcu_read_lock(&kvm->srcu);
+	scoped_guard(srcu, &kvm->srcu) {
+		if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr))
+			return PGM_ADDRESSING;
 
-	if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr)) {
-		r = PGM_ADDRESSING;
-		goto out_unlock;
-	}
-
-	r = cmpxchg_guest_abs_with_key(kvm, mop->gaddr, mop->size, &old.quad,
-				       new.quad, mop->key, &success);
-	if (!success && copy_to_user(old_addr, &old.raw[off_in_quad], mop->size))
-		r = -EFAULT;
+		r = cmpxchg_guest_abs_with_key(kvm, mop->gaddr, mop->size, &old, new,
+					       mop->key, &success);
 
-out_unlock:
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
+		if (!success && copy_to_user(old_addr, &old, mop->size))
+			return -EFAULT;
+	}
 	return r;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f89f9f698df5..495ee9caaa30 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -22,6 +22,14 @@
 
 #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
 
+union kvm_s390_quad {
+	__uint128_t sixteen;
+	unsigned long eight;
+	unsigned int four;
+	unsigned short two;
+	unsigned char one;
+};
+
 static inline void kvm_s390_fpu_store(struct kvm_run *run)
 {
 	fpu_stfpc(&run->s.regs.fpc);
-- 
2.51.1


