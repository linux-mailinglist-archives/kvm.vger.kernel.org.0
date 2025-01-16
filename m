Return-Path: <kvm+bounces-35642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3D02A1390C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED872168983
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC431DE4DD;
	Thu, 16 Jan 2025 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KFOUxNAk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68BC1DDC10;
	Thu, 16 Jan 2025 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027249; cv=none; b=j8xVGpVF31+JSQw3EhDZRi/S8lrwDmm8dqKkUOFOCjn41lv/jMkioHOr4ipDdoN+4Ubk2EQF+2iNNw4LOYoqkNhZ6KGdf62lcX+A+LylWyGDOR4FuNFt8/rFmDVw3iRCvmmjDs/oa0doMD9lrGsoNdiKrDhGN4FGetY5EOhcn1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027249; c=relaxed/simple;
	bh=7QgDTnET3z5JOpgH4LtGByvsDPUYO1tLJ+W6KwkMF+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaWkLKFdla4H36rsK1xDajl/kPs6W0kPyXTrwm/gL7v651GlD5vXwjOUhHoCgVckAgeu4m0rbxn/NFEhDTF7PZ3zDfdhfNDtA45H4vRDR9vFTkj8BEO53Tx8Hi4NnI2inZINakr4pIaTJ17sJVsKmFiR7cgIsUnTEwVLD0vuSHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KFOUxNAk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G3qkUD004570;
	Thu, 16 Jan 2025 11:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KdWLHcvtPmeviIVif
	MEQdZdcCMZKo9u5PdvHySGiyfY=; b=KFOUxNAkk5Vfnx3hpI6TvTsu+pc/x3ONJ
	74xlnki2+Se8qmL8QIshJIodV/hPnyY1jvh6BehlTehtEyqyf8XWqhEilZRQOFgf
	jhRT9PObl/9n5hKt1GVTqPGguOOBwSjQW3HVCIQ9AMEOquRUXMV79Olln3qOPFC6
	8SKDMmzywyHFjlLgUrsr84kalvEjpWC/xl/hB3de/ofhu+dIuTQL9kET/cMHM+Ha
	CWqKlRFE/QMuz1ze4jFosVKH5dSZh4ofTxi9sFYrKnEqeQq3Nxx9HeDD/MuL86Y0
	T529sOsBGwui+23ajgUQCmsxFSQ73EWdiT7Z/ofq/2GgkRn5ooO9g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkha0r4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBUJHg019054;
	Thu, 16 Jan 2025 11:34:03 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkha0qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:03 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GA8rq4017359;
	Thu, 16 Jan 2025 11:34:02 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkdgbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBXwH27274946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:33:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8219D20049;
	Thu, 16 Jan 2025 11:33:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 443322004D;
	Thu, 16 Jan 2025 11:33:58 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:58 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 08/15] KVM: s390: get rid of gmap_translate()
Date: Thu, 16 Jan 2025 12:33:48 +0100
Message-ID: <20250116113355.32184-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250116113355.32184-1-imbrenda@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4FheqilDc2orRT60YlD_aekJCmaHaf-p
X-Proofpoint-ORIG-GUID: 90Xbr12BONVXF249ZwLlSLIDQQaiXyUc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160086

Add gpa_to_hva(), which uses memslots, and use it to replace all uses
of gmap_translate().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  1 -
 arch/s390/kvm/interrupt.c    | 19 +++++++++++--------
 arch/s390/kvm/kvm-s390.h     |  9 +++++++++
 arch/s390/mm/gmap.c          | 20 --------------------
 4 files changed, 20 insertions(+), 29 deletions(-)

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


