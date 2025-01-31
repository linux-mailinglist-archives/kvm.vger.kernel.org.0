Return-Path: <kvm+bounces-36987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC558A23D11
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15A2B1883285
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095141F37CA;
	Fri, 31 Jan 2025 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K9glrJbD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C611F2C2F;
	Fri, 31 Jan 2025 11:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322734; cv=none; b=KoAWyLF3WFTkTeE1xOd2uZ/DvKUu79xjvluP+xKpBxNV2j9uD3scLi7lwcKHH1cSDMhJm2FS/VRf5rDD691hKijsarwvbXphJWppoj4ltExxYVQLZCOhzqmwIcGBmYLFl2VtP5/AtZaRJH2xDih8VrYOJBgeqDiZHO9Nykpt0uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322734; c=relaxed/simple;
	bh=e+EJnAzEqF03wQuepv9JpOFbPu+8v5xNwNHa8wD9X3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJYcQOtY4WtNGzz5h1sbxpjJLFbLWHgGbbHrxJ3CSyn0xipOK6e5PjvDT86HAtYwWwqNYv31swshZ/kDjfk29wEQqIvJvH4s6QCpMFsfmW3pgqlOmEms7lKYenlnSjfr2bVzp6VfpUtclf+JnmmiQJEBVx0Y26lt6Ca/PTUeF9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K9glrJbD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2OAvH021741;
	Fri, 31 Jan 2025 11:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EDcXJomgyWluQCRJ7
	435UJBuaqOxlmHjBqxqKYKNIXU=; b=K9glrJbDX9Rr7DQgKQPo7Dcea1D92zZxg
	uPAHjwTKEJ9gbCBaPiGOSRhH0u4Cp6Yi2v7zNqX2IOat9tlaaXp8BX9cnmdxBjKd
	A+hEf+8i+8P42SgKSS9zHj7UUkyrIevJ/0UxVYMTWBmMma96vYLYPJpbz71o+KEX
	n7zBCB0hvkW38l9/ansnbjB4e2hOVyyHdqxmdzVq3OJQXVbI74QXCnTiSfI4OWN0
	BlZcIx9ktIqVW/nMhw6DBpEfZ2FutGGEvZEjnMwQb4H/239O07UTiz2n6M6yD3u4
	bM3EN/cla7SzpvZZj0KurPstTHTWve1AfpY7sFhpGMJ7aZhuqPGqQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gnby9x0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8M9SB017200;
	Fri, 31 Jan 2025 11:25:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gfayb9fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPPG360162430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 374352012E;
	Fri, 31 Jan 2025 11:25:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0CB020131;
	Fri, 31 Jan 2025 11:25:24 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:24 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 12/20] KVM: s390: get rid of gmap_translate()
Date: Fri, 31 Jan 2025 12:25:02 +0100
Message-ID: <20250131112510.48531-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D30LzZ7TLrB6h94z8C2m-enMWIujck8u
X-Proofpoint-GUID: D30LzZ7TLrB6h94z8C2m-enMWIujck8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

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


