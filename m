Return-Path: <kvm+bounces-63909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 773E0C75ABC
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B4E554EA1D7
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872CB36FDD9;
	Thu, 20 Nov 2025 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l1Wu2pkz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8738D371A23;
	Thu, 20 Nov 2025 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659007; cv=none; b=AiKocTeAggn3MJgBVpCkfwAluYNkw0doRAbL5viMxK0tG/Pv7qyRzXi77fSKU5dRaJYj1k0s21G4q7B2+A3ZnCK3niSLqUgvNilNfpGaPdPL6dx/A1FJSFOvHY95s1sKcGEi/cYUqpFzkBe6GVRbn0oCQ4zEVLmEYxRIEwkbTfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659007; c=relaxed/simple;
	bh=MFTcp4Qqv8NBZAXQszOFf4DmX/Tj/WHhjFpHFi8o7yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmxwIBIAkmknE3gr0lIG+MH5ZilaOvPuJsEgERw4TqSbU0KIfJ4e0vMK4nrL6xtYSDuBrm4l8J7ikbBfP4CQdfLhecsYl0vjwB2pWXl+mIbG/PnxzWh2s7fMTd0YRX4sjcpmWo5TjaFd8O+QSRsH+O/sDtdJaIpBIOUKKsR/1zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l1Wu2pkz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKCnSiq028030;
	Thu, 20 Nov 2025 17:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mapCAmNqgXwN/Ykkw
	7AUF8CI6YMEvexdgSKLBhw1bsk=; b=l1Wu2pkzlx8gVTJhnnwFkKMxWPQAXMkiG
	wy0pjuOFyxB1bvqWrspzWK1YhdbZupW78FbKKId8ta8WA78wjZGXYuVyBg5VXxHZ
	bExdGo7oB5MT9kENluCh7O0JBB9i/Wke5bThJYy/kdXUf4HK2LCbgH8S8ogRzEzx
	TPF7j6yVK9sWuILCc6T1cmeU2kjOFibeIINcv0hyCfuAW0w5R+R/1HXFb1JXVHWG
	Kw9xKby/zrNY8yGGnqNu1+1t8c4I212G8py1zBibExxRfZ6DRP1obug8Lv9ayD/w
	WJ9Q5UotWnDQoSbHxakp5ZCafQPSP9fBDiYTZb0Y5aMRR53vy/v/Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka7n0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKEPsnu022340;
	Thu, 20 Nov 2025 17:16:24 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un7mg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:24 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHGKfB58392908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:16:20 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C251D2004B;
	Thu, 20 Nov 2025 17:16:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 196E620040;
	Thu, 20 Nov 2025 17:16:19 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:16:18 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 18/23] KVM: s390: Storage key functions refactoring
Date: Thu, 20 Nov 2025 18:15:39 +0100
Message-ID: <20251120171544.96841-19-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: AMA_UjHXxCBLtCfXw2M1iej-VCMNHOBv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXxNLu0bQgATqV
 yOjISkbjJU9HHj8Drd5UnGF5pnQqeVfeIFf44hZOq5rKCi64NLkzEqKRq9J5UtU5CF/c+cVRz1h
 VJc6viPh3Tyo93LQ39c4Y500k1x9ypzPEW3WAsfYW5vK5Bm/6PI5/9EnFEu1bXid8A65mRlMcZf
 KFDNQKDgdxXKaZjydSds/3Q3ZJotIrIKV18kVOZA2FW0qJh2mcp+RtJTafwB8jGk6mkrsfCG/OJ
 Iawr7cdQUphzFdc/+rgiQKCHyQshMNmEjuvASjgqsVqgqy6TOKsrW9yj/H4X+dOGIFjqf/l2gYy
 v2PX+vCuikwedSV1U1gNC6YRRmq2MYN4162s0/v5/6Ispg4wYsDanU5nEpFkXncuZCUJMm7I/e1
 Y9H080FtVMBMxYcElYO+dwFw+plvJQ==
X-Proofpoint-ORIG-GUID: AMA_UjHXxCBLtCfXw2M1iej-VCMNHOBv
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691f4cfa cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=g1xfaEJ1DM-V_6iQr0UA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

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


