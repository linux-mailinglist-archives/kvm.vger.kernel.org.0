Return-Path: <kvm+bounces-36904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41605A22AC3
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83C2D166C7E
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DE81BEF97;
	Thu, 30 Jan 2025 09:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rkE4KpQl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F052F1B85D2;
	Thu, 30 Jan 2025 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230690; cv=none; b=i1HRjQnEqoyL1e8WQ5S2d0d9UAUwhGbT3MPbPIrwMoclar2GYKfFvUMdWOuqW2+TJ748QsWeuw1/At53hYu+Z+Xvhyot9ioqffs1zzd1Nkduk6chc3cOy/eYwYqLRSnB75+DX8O+U5Cw8gE9LYGAXPDTe/DdNd/8kql3OLmddvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230690; c=relaxed/simple;
	bh=e+EJnAzEqF03wQuepv9JpOFbPu+8v5xNwNHa8wD9X3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFYhH238dMLNodKOkL/Tjp2H9bLIWxiO4qo9OHelEL6j85dlxFgh+LqyH0Qn8V9vYvmcRz0uO+3LMDiTfdvm4o5vzWh46dA+cSslg6lRGIfrYsczfOxG8Fd90wRkJotsPyqleW9uIGeYvJ5eAbgV/6lQoSKrhkDHm7EDh23cI+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rkE4KpQl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50TNa8uv024142;
	Thu, 30 Jan 2025 09:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EDcXJomgyWluQCRJ7
	435UJBuaqOxlmHjBqxqKYKNIXU=; b=rkE4KpQl//mXrhfJ9KRAz+UA77wc64bts
	k5ExXW8FuFcpeLh6pN/FOi1uucAoBOTQBKWVZ6a7a9zubGcfoST80iDjl2IxJqIM
	iHyEyC0yCA6yyyWd0BvG2qoWbTvwRYIoN+KrVMXw3cd/+SWl8TgaQjavFJRpC857
	I6G1KSIMHt1WSUiW8sW/UWuwX2Zc5WYNwLTmkyCYQ16nW4eY567dB0LULiXxYh0l
	pV3QW4jZ109dyY+hjxEeKvbNtfqsaOfrFcxYcqjuBUjxjOWRm0HbSCNZ9isFHdGn
	wD7U43tDcsaEF+987GuvzIXznqsz39Sc1XJtQZ/C4LP2dTPEsH0ZA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44fpm1mska-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:26 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U9WG2x018882;
	Thu, 30 Jan 2025 09:51:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dd01n51m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:25 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pLkH42402226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 957532013D;
	Thu, 30 Jan 2025 09:51:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E1F220141;
	Thu, 30 Jan 2025 09:51:21 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:21 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 12/20] KVM: s390: get rid of gmap_translate()
Date: Thu, 30 Jan 2025 10:51:05 +0100
Message-ID: <20250130095113.166876-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130095113.166876-1-imbrenda@linux.ibm.com>
References: <20250130095113.166876-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QRFfL1j5Xv_UdTrfYFjF61EHKHC96MSm
X-Proofpoint-GUID: QRFfL1j5Xv_UdTrfYFjF61EHKHC96MSm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300073

Add gpa_to_hva(), which uses memslots, and use it to replace all uses
of gmap_translate().

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-9-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-9-imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  1 -
 arch/s390/kvm/interrupt.c    | 19 +++++++++++--------
 arch/s390/kvm/kvm-s390.h     |  9 +++++++++
 arch/s390/mm/gmap.c          | 20 --------------------
 4 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index d4572729269f..74b48f2e608a 100644
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
index d4f031e086fc..07ff0e10cb7f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2893,7 +2893,8 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
-	u64 uaddr;
+	u64 uaddr_s, uaddr_i;
+	int idx;
 
 	switch (ue->type) {
 	/* we store the userspace addresses instead of the guest addresses */
@@ -2901,14 +2902,16 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		if (kvm_is_ucontrol(kvm))
 			return -EINVAL;
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
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 3be5291723c8..61e8544924b3 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -281,6 +281,15 @@ static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
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
index e124fca14737..7fd298732d1e 100644
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
2.48.1


