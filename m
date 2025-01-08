Return-Path: <kvm+bounces-34814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4379A06415
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:15:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87BE37A2612
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66B7202C41;
	Wed,  8 Jan 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AOhZO20d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B66202C27;
	Wed,  8 Jan 2025 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360105; cv=none; b=Bym1ovzsdZVigVswv0gK0oOgCdK9aG+uveM6+8IYXl0+ONqevXT8kFu+lQ3/B4QifE/U1Us49jHXi5vVdyH4H53OB4IVccsNgA40CvFm5EVy+Fi8/j35NJpV6b7K+huiR/h1iBExYcaJjfTHB0a8z08s6kJ955qxpqLT4TvhsAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360105; c=relaxed/simple;
	bh=GWXar28+YYPiNLMkIniUKk80XmcQgtLsjC7/TR4Ildc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXJFvISmOrPn9e1sf0EVR0/x2wrOUA8PW0RQSPPtjUQ3hF2FKSoHL/qWhf0DOrs/x08+nXJTgXEuzGNbIlAZRp/ZJh+58nbISnqT5N7Ct64vbxeZUTkLlbVR3ClATYuLdaNwZZbwk+SIKAJCksGwgvfvVwOUi/Fr6F+UiCd1Gpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AOhZO20d; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508IBfQo021826;
	Wed, 8 Jan 2025 18:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZTdtPTdV0QhHNHzTe
	hxaFEUT26hHjCX6jCarAbkKQ8s=; b=AOhZO20d9Wwgbww4sXYbCPZ6nqqfveAe8
	Je1OdPd6D3QnAE3HsRiD95rnuhj9s8lWzBcBwx1dmpQ0MccyZzIbXS74h/jT3qVV
	QDcV/DSRlTOw7t71N6yz/tz1HQ3fhtzWGr4V1AGyWx6Z2TjG+845V6Lt9jn63g4o
	euQ6uscJBzdZuca+tPXvE+9VKWrnPKpgz33Q6VPmBO82wnTyJan3QOZujCb7rF7l
	bbQK9rG7r781Ce+eXRQlFUhXe/GpKvPWlwMwc8XX+Mj70Y8d12JXaj9aTSQRS7ph
	eTZK0qgY9gNSz8O0kYUUVfukmzUzVz8AB26y9oqA2feVVw7fD2zWA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441nj3aqbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508IBEs3026179;
	Wed, 8 Jan 2025 18:14:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj128t1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEr4445679078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87BBA20040;
	Wed,  8 Jan 2025 18:14:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60CDD2004B;
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
Subject: [PATCH v1 06/13] KVM: s390: get rid of gmap_translate()
Date: Wed,  8 Jan 2025 19:14:44 +0100
Message-ID: <20250108181451.74383-7-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: cqyjY3PZIeF-fBr3xOwbNV4eGuuP5Ctn
X-Proofpoint-GUID: cqyjY3PZIeF-fBr3xOwbNV4eGuuP5Ctn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

Add gpa_to_hva(), which uses memslots, and use it to replace all uses
of gmap_translate() except one.

Open code __gmap_translate() for the only remaining user of
gmap_translate().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  1 -
 arch/s390/kvm/interrupt.c    | 19 +++++++++++--------
 arch/s390/kvm/kvm-s390.c     |  4 +++-
 arch/s390/kvm/kvm-s390.h     |  9 +++++++++
 arch/s390/mm/gmap.c          | 20 --------------------
 5 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 3f4184be297f..3652d8523e1f 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -111,7 +111,6 @@ int gmap_map_segment(struct gmap *gmap, unsigned long from,
 		     unsigned long to, unsigned long len);
 int gmap_unmap_segment(struct gmap *gmap, unsigned long to, unsigned long len);
 unsigned long __gmap_translate(struct gmap *, unsigned long gaddr);
-unsigned long gmap_translate(struct gmap *, unsigned long gaddr);
 int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr);
 void gmap_discard(struct gmap *, unsigned long from, unsigned long to);
 void __gmap_zap(struct gmap *, unsigned long gaddr);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ea8dce299954..c1526149700e 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2889,20 +2889,23 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
-	u64 uaddr;
+	u64 uaddr_s, uaddr_i;
+	int idx;
 
 	switch (ue->type) {
 	/* we store the userspace addresses instead of the guest addresses */
 	case KVM_IRQ_ROUTING_S390_ADAPTER:
 		e->set = set_adapter_int;
-		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.summary_addr);
-		if (uaddr == -EFAULT)
-			return -EFAULT;
-		e->adapter.summary_addr = uaddr;
-		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.ind_addr);
-		if (uaddr == -EFAULT)
+
+		idx = srcu_read_lock(&kvm->srcu);
+		uaddr_s = gpa_to_hva(kvm, ue->u.adapter.summary_addr);
+		uaddr_i = gpa_to_hva(kvm, ue->u.adapter.ind_addr);
+		srcu_read_unlock(&kvm->srcu, idx);
+
+		if (kvm_is_error_hva(uaddr_s) || kvm_is_error_hva(uaddr_i))
 			return -EFAULT;
-		e->adapter.ind_addr = uaddr;
+		e->adapter.summary_addr = uaddr_s;
+		e->adapter.ind_addr = uaddr_i;
 		e->adapter.summary_offset = ue->u.adapter.summary_offset;
 		e->adapter.ind_offset = ue->u.adapter.ind_offset;
 		e->adapter.adapter_id = ue->u.adapter.adapter_id;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d8c8e91356ca..574a9e43f97a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4925,7 +4925,9 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			 * This allows ucontrol VMs to use the normal fault
 			 * resolution path, like normal VMs.
 			 */
-			gaddr_tmp = gmap_translate(vcpu->arch.gmap, gaddr);
+			mmap_read_lock(vcpu->arch.gmap->mm);
+			gaddr_tmp = __gmap_translate(vcpu->arch.gmap, gaddr);
+			mmap_read_unlock(vcpu->arch.gmap->mm);
 			if (gaddr_tmp == -EFAULT) {
 				vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
 				vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 7f4b5ef80a6f..37c9ab52ecaa 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -279,6 +279,15 @@ static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
 	return gd;
 }
 
+static inline hva_t gpa_to_hva(struct kvm *kvm, gpa_t gpa)
+{
+	hva_t hva = gfn_to_hva(kvm, gpa_to_gfn(gpa));
+
+	if (!kvm_is_error_hva(hva))
+		hva |= offset_in_page(gpa);
+	return hva;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 8da4f7438511..ae6ccf034378 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -463,26 +463,6 @@ unsigned long __gmap_translate(struct gmap *gmap, unsigned long gaddr)
 }
 EXPORT_SYMBOL_GPL(__gmap_translate);
 
-/**
- * gmap_translate - translate a guest address to a user space address
- * @gmap: pointer to guest mapping meta data structure
- * @gaddr: guest address
- *
- * Returns user space address which corresponds to the guest address or
- * -EFAULT if no such mapping exists.
- * This function does not establish potentially missing page table entries.
- */
-unsigned long gmap_translate(struct gmap *gmap, unsigned long gaddr)
-{
-	unsigned long rc;
-
-	mmap_read_lock(gmap->mm);
-	rc = __gmap_translate(gmap, gaddr);
-	mmap_read_unlock(gmap->mm);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(gmap_translate);
-
 /**
  * gmap_unlink - disconnect a page table from the gmap shadow tables
  * @mm: pointer to the parent mm_struct
-- 
2.47.1


