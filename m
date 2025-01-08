Return-Path: <kvm+bounces-34824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC726A06429
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E88FA3A7294
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2EC20100D;
	Wed,  8 Jan 2025 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FOmBcg7H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3881201018;
	Wed,  8 Jan 2025 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360108; cv=none; b=lGLnHuCq0oqmiLzhNm/feI3iJCQK20e1p9rx0PKwL3jRDikAEm3GqQfV7LKSPLkRktvGh7Psku6BpbD5RdJT5mFw1SMWw+Vy8oHu3idl9f9H25nMtZp2H0qoPB+q05l2utFz7o4r8dadXfVHWk319nQyBazCWmjAAhRVSWqZB7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360108; c=relaxed/simple;
	bh=zfikpiNATITHfhBoEvCHFtCtxemdrHPDMZVskPiyqJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWFH4qEkCrqNaJOCDgrXJ/7ciiSdykl35KcxsdL86Ml3kfVxFzbH4Ph+uljdWhOaujoeT11OgGfBl1yIUDEkAM5DAbU3fb4Xtex4YC52/NcanjdSC1jhEFs0q5fRVfimOUdbDn9+3dLJhOj9GNrfwRykoKePh0MVFrHQJJe81EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FOmBcg7H; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508Ekt8R007143;
	Wed, 8 Jan 2025 18:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fIX7x3rrGrmBVE+1h
	jxVLNHB/GVSriKww92+AdmDddU=; b=FOmBcg7HEW0KQ2m/f7hPyTUvrI0o5+Vlr
	ltyXT5rZOfs9KC0z7Y07cLqbRDaVdzpmXAwYkGr5W9brJPm4ADv/7sr31Dmcmp8R
	yDxp4Hi7x0crmyURDGUgggVl3tm3lQi7uod+DM0abrl/KaBlF4XGTkjV7wzQ+3G+
	m3YADnrFMpi8kGNCkUP6lH24rzHmkCyfN3WCpOi23esepVx67XJW/ngxHtXZxPgl
	x/AjJ7m4t7sw48DaTUE0TMnWosyuBfxdW+IRO/GhO2A79TqUmHfIOhdMoel9hHoc
	Wi4fmi9oPA5L0GRM0jy9jHGcvgC+8W+mpgY6M2+62IdF2kgiDn0ig==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huputwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508HsRiq027976;
	Wed, 8 Jan 2025 18:14:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yhhk8vc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IErKs45679076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B46B20043;
	Wed,  8 Jan 2025 18:14:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CF992004D;
	Wed,  8 Jan 2025 18:14:53 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:53 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 05/13] KVM: s390: get rid of gmap_fault()
Date: Wed,  8 Jan 2025 19:14:43 +0100
Message-ID: <20250108181451.74383-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108181451.74383-1-imbrenda@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NCJ5IFeC_sxy0O4CsaV9F2AqGKrd5uWY
X-Proofpoint-GUID: NCJ5IFeC_sxy0O4CsaV9F2AqGKrd5uWY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=817
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

All gmap page faults are already handled in kvm by the function
kvm_s390_handle_dat_fault(); only few users of gmap_fault remained, all
within kvm.

Convert those calls to use kvm_s390_handle_dat_fault() instead.

Remove gmap_fault() entirely since it has no more users.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |   1 -
 arch/s390/kvm/intercept.c    |   4 +-
 arch/s390/kvm/kvm-s390.c     |  17 +++--
 arch/s390/kvm/kvm-s390.h     |   7 ++
 arch/s390/mm/gmap.c          | 124 -----------------------------------
 5 files changed, 22 insertions(+), 131 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 13f51a6a5bb1..3f4184be297f 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -113,7 +113,6 @@ int gmap_unmap_segment(struct gmap *gmap, unsigned long to, unsigned long len);
 unsigned long __gmap_translate(struct gmap *, unsigned long gaddr);
 unsigned long gmap_translate(struct gmap *, unsigned long gaddr);
 int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr);
-int gmap_fault(struct gmap *, unsigned long gaddr, unsigned int fault_flags);
 void gmap_discard(struct gmap *, unsigned long from, unsigned long to);
 void __gmap_zap(struct gmap *, unsigned long gaddr);
 void gmap_unlink(struct mm_struct *, unsigned long *table, unsigned long vmaddr);
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 92ae003cd215..83a4b0edf239 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -368,7 +368,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = gmap_fault(vcpu->arch.gmap, srcaddr, 0);
+	rc = kvm_s390_handle_dat_fault(vcpu, srcaddr, 0);
 	if (rc != 0)
 		return rc;
 
@@ -377,7 +377,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = gmap_fault(vcpu->arch.gmap, dstaddr, FAULT_FLAG_WRITE);
+	rc = kvm_s390_handle_dat_fault(vcpu, dstaddr, FOLL_WRITE);
 	if (rc != 0)
 		return rc;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bdbb143a75c9..d8c8e91356ca 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4795,8 +4795,17 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
 		current->thread.gmap_int_code, current->thread.gmap_teid.val);
 }
 
-static int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr,
-				     unsigned int flags)
+/*
+ * __kvm_s390_handle_dat_fault() - handle a dat fault for the gmap of a vcpu
+ * @vcpu: the vCPU whose gmap is to be fixed up
+ * @gfn: the guest frame number used for memslots (including fake memslots)
+ * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
+ * @flags: FOLL_* flags
+ *
+ * Return: 0 on success, < 0 in case or error.
+ * Context: The mm lock must not be held before calling.
+ */
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
 {
 	struct kvm_memory_slot *slot;
 	unsigned int fault_flags;
@@ -4925,7 +4934,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			}
 			gfn = gpa_to_gfn(gaddr_tmp);
 		}
-		return kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
+		return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
 		break;
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
@@ -5818,7 +5827,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_S390_VCPU_FAULT: {
-		r = gmap_fault(vcpu->arch.gmap, arg, 0);
+		r = kvm_s390_handle_dat_fault(vcpu, arg, 0);
 		break;
 	}
 	case KVM_ENABLE_CAP:
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 597d7a71deeb..7f4b5ef80a6f 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -408,6 +408,13 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
 int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
+
+static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
+{
+	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
+}
+
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 3aacef77c174..8da4f7438511 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -607,130 +607,6 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 }
 EXPORT_SYMBOL(__gmap_link);
 
-/**
- * fixup_user_fault_nowait - manually resolve a user page fault without waiting
- * @mm:		mm_struct of target mm
- * @address:	user address
- * @fault_flags:flags to pass down to handle_mm_fault()
- * @unlocked:	did we unlock the mmap_lock while retrying
- *
- * This function behaves similarly to fixup_user_fault(), but it guarantees
- * that the fault will be resolved without waiting. The function might drop
- * and re-acquire the mm lock, in which case @unlocked will be set to true.
- *
- * The guarantee is that the fault is handled without waiting, but the
- * function itself might sleep, due to the lock.
- *
- * Context: Needs to be called with mm->mmap_lock held in read mode, and will
- * return with the lock held in read mode; @unlocked will indicate whether
- * the lock has been dropped and re-acquired. This is the same behaviour as
- * fixup_user_fault().
- *
- * Return: 0 on success, -EAGAIN if the fault cannot be resolved without
- * waiting, -EFAULT if the fault cannot be resolved, -ENOMEM if out of
- * memory.
- */
-static int fixup_user_fault_nowait(struct mm_struct *mm, unsigned long address,
-				   unsigned int fault_flags, bool *unlocked)
-{
-	struct vm_area_struct *vma;
-	unsigned int test_flags;
-	vm_fault_t fault;
-	int rc;
-
-	fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
-	test_flags = fault_flags & FAULT_FLAG_WRITE ? VM_WRITE : VM_READ;
-
-	vma = find_vma(mm, address);
-	if (unlikely(!vma || address < vma->vm_start))
-		return -EFAULT;
-	if (unlikely(!(vma->vm_flags & test_flags)))
-		return -EFAULT;
-
-	fault = handle_mm_fault(vma, address, fault_flags, NULL);
-	/* the mm lock has been dropped, take it again */
-	if (fault & VM_FAULT_COMPLETED) {
-		*unlocked = true;
-		mmap_read_lock(mm);
-		return 0;
-	}
-	/* the mm lock has not been dropped */
-	if (fault & VM_FAULT_ERROR) {
-		rc = vm_fault_to_errno(fault, 0);
-		BUG_ON(!rc);
-		return rc;
-	}
-	/* the mm lock has not been dropped because of FAULT_FLAG_RETRY_NOWAIT */
-	if (fault & VM_FAULT_RETRY)
-		return -EAGAIN;
-	/* nothing needed to be done and the mm lock has not been dropped */
-	return 0;
-}
-
-/**
- * __gmap_fault - resolve a fault on a guest address
- * @gmap: pointer to guest mapping meta data structure
- * @gaddr: guest address
- * @fault_flags: flags to pass down to handle_mm_fault()
- *
- * Context: Needs to be called with mm->mmap_lock held in read mode. Might
- * drop and re-acquire the lock. Will always return with the lock held.
- */
-static int __gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fault_flags)
-{
-	unsigned long vmaddr;
-	bool unlocked;
-	int rc = 0;
-
-retry:
-	unlocked = false;
-
-	vmaddr = __gmap_translate(gmap, gaddr);
-	if (IS_ERR_VALUE(vmaddr))
-		return vmaddr;
-
-	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT)
-		rc = fixup_user_fault_nowait(gmap->mm, vmaddr, fault_flags, &unlocked);
-	else
-		rc = fixup_user_fault(gmap->mm, vmaddr, fault_flags, &unlocked);
-	if (rc)
-		return rc;
-	/*
-	 * In the case that fixup_user_fault unlocked the mmap_lock during
-	 * fault-in, redo __gmap_translate() to avoid racing with a
-	 * map/unmap_segment.
-	 * In particular, __gmap_translate(), fixup_user_fault{,_nowait}(),
-	 * and __gmap_link() must all be called atomically in one go; if the
-	 * lock had been dropped in between, a retry is needed.
-	 */
-	if (unlocked)
-		goto retry;
-
-	return __gmap_link(gmap, gaddr, vmaddr);
-}
-
-/**
- * gmap_fault - resolve a fault on a guest address
- * @gmap: pointer to guest mapping meta data structure
- * @gaddr: guest address
- * @fault_flags: flags to pass down to handle_mm_fault()
- *
- * Returns 0 on success, -ENOMEM for out of memory conditions, -EFAULT if the
- * vm address is already mapped to a different guest segment, and -EAGAIN if
- * FAULT_FLAG_RETRY_NOWAIT was specified and the fault could not be processed
- * immediately.
- */
-int gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fault_flags)
-{
-	int rc;
-
-	mmap_read_lock(gmap->mm);
-	rc = __gmap_fault(gmap, gaddr, fault_flags);
-	mmap_read_unlock(gmap->mm);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(gmap_fault);
-
 /*
  * this function is assumed to be called with mmap_lock held
  */
-- 
2.47.1


