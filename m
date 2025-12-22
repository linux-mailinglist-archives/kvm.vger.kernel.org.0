Return-Path: <kvm+bounces-66503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C94CD6C2B
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF2E830DB30A
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD20347BB4;
	Mon, 22 Dec 2025 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xk2BL67p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E20346A05;
	Mon, 22 Dec 2025 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422275; cv=none; b=AO6N+VpotwyejdCWR4XKJnIeVMvaVXpCQxIRC650yocvJlZMkG0bYgWoCSqXk5rAFpyiBaZXfmT5AJvn6KZ5LSQ9IC8UjCRVi2PbY1cCbmErIDle1aMJE+/64KI91cga6tGtDPo0D+8A1Xc62ccppSuquFyHqASCO6fgT5RNmng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422275; c=relaxed/simple;
	bh=M+czOadzoFvgMv1Fx4fUfJMtXLjRcRowuKOqyGcoe0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9wifWUwDzeLiNJp722C6UDsARhZKtJ3MOS527yfEKNNg4AJF6u75ggnBl/Nx46aZgPI6/4zNj9gPIWAS4fp47qjw/nHUs5ZzHJlQZeWA7g7tH+4JVfQG9cuDDX6B556DxoQ+zsNdcSACF2QFpa852Xj7WcwdO42UdJL9b8y8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xk2BL67p; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDwHW1007191;
	Mon, 22 Dec 2025 16:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fxj3oYfd0W1KwfxP2
	KNSUi1hqNZHvPqvToB0azzAAk4=; b=Xk2BL67pjwzhyEUBGak6aj5Ccsku+jUkr
	SSWmSTDd6do3XsJGAtGCpUmbcinBxTJ3xqymo/gfWcqurEfgHWOKHLAkrYrZM3Pv
	pANbO0esbTVMz+rUit3MkqldRhhRsxX03I3udU+kIVrNtDghrsQ3O41CotbwTpIS
	wGFJl4bZmxMXkQMJoLO2s+JyJH2h3XRp9Ym+6QDIfcIW8FyanEAjTqhPTrBCPp2o
	lVxyDOfQRDz6bqGtBfLTMJWR8RRZZ7U4hJLaq2XFU7IrdHzWNUv/gvyi8BJjFNLy
	k8BZu7jW6aT/DL5u02gCafwf1pJjyVgjaGJqmCWoe7xJ9P0pxx0UA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kfq16y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDcXZE005286;
	Mon, 22 Dec 2025 16:51:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b67mjy3k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGp52Z50987440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:51:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0B7420040;
	Mon, 22 Dec 2025 16:51:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A942120043;
	Mon, 22 Dec 2025 16:51:04 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:51:04 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 23/28] KVM: s390: Storage key functions refactoring
Date: Mon, 22 Dec 2025 17:50:28 +0100
Message-ID: <20251222165033.162329-24-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=carfb3DM c=1 sm=1 tr=0 ts=694976ff cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=pIs5vcIGI8bcUft9BRQA:9
X-Proofpoint-ORIG-GUID: GFeOCg1ZIvjAOzFz3utUctV-DwVwmeF9
X-Proofpoint-GUID: GFeOCg1ZIvjAOzFz3utUctV-DwVwmeF9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX2WxjFGwdHMtP
 WbAsVszdn8wFvaTFKfYYVhLdWJuPKBIVByQ3Ik836G582gUJTa1cBMDiCILrdGqOjmGfgKYsznf
 R7Ov0mYkdlI7Z1KWPSMHOXHGiGdWX4EzVOBKhzOd7mVvQaO6H76ficyBK56x15PJViuWVsc00+Y
 iX6v/MG7aCB8bev+lgrtFfK1WE3awQXVlZZ4ctH88EUVvZy/8SuTj3Oqb9XgaKa47BBunlmASl6
 Fl1osDJKOdWfeqO9eCXtjN3BYpV8Mgg4qxeK+PZhATTCWQBJa42L07ChlJavDZflygFtnkTl7Gt
 ek59Dh2KAVetjX5HGwFArJfpraTK367zNAAvBj46aba1gnVn9SmTw/hUObsDPw0p7dbHFX/uAAh
 FLHQhbs46EL2aT1TTaDiwRDYeJMR/OBQHSIjv1SfcKo5ZJ++Bau5AGy10aureEhqM9DCvfGlgzM
 qVcTIFz1UNgGa2lJx+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

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
index 9df868bddf9a..1d0725f3951a 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -974,9 +974,8 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
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
@@ -1008,41 +1007,42 @@ int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len,
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
index 2b5ecdc3814e..f5411e093fb5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2900,9 +2900,9 @@ static int mem_op_validate_common(struct kvm_s390_mem_op *mop, u64 supported_fla
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
@@ -2915,52 +2915,36 @@ static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
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
@@ -2972,25 +2956,21 @@ static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *m
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
index 9ce71c8433a1..c44c52266e26 100644
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
2.52.0


