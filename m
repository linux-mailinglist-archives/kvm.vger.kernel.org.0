Return-Path: <kvm+bounces-35855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79875A157DB
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:10:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0D8F3A87EF
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A40C1AA786;
	Fri, 17 Jan 2025 19:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ip0iFiKe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C951A8413;
	Fri, 17 Jan 2025 19:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140992; cv=none; b=LNcypKwfDpI6kKp9FOEsl3mn46bn31+pgXShXoj8eNkUpPBKgRRhYSZ8zve8dssYSXeRqn+NaONJyqLKpXO7cFzaV/PmqFzbl4jYlPDPGOpfd0yeO1jRm15dh1UBrwvPXCrYzGJHnWHh7sTOrC6eCfaT2JpO0b676qdBv9hpeJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140992; c=relaxed/simple;
	bh=wwY3b8dVHnnDzcPQYn1bowZYDUrsmUvlPvqr26aKHiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyMCjS6tJuOVIrSWHVj/ByObrlKLJjSR/clMym0HkLD0xUXt8rrxZTbW7Nk/Qz/jZU562Mjpr8dnGkJXlgZKEISXDeiMtzLXMufoObk+xhi2BYiIKWiPZz7Galj1d/KAyS5hgvdoND6Cdsau6rr7xVXrG8aMTPxNZ3IxrEXxtQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ip0iFiKe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HBkAQP018842;
	Fri, 17 Jan 2025 19:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=rss9DluEU787asMmc
	GG/0wyAVyrj9EQPoiz5RenstZI=; b=Ip0iFiKeBJj1WpFUQSdsEstFq/icMeuJb
	SVvR4ODxvCDl5geIXriF+k1CdniDom5R32Hb1xoasF2bSm2PwtDGr7KNCMjt1485
	XpJp4fDwye1xTWUX9wSwYhIOt5In2GUHxlJpPAFIIJ1pr4Cy5hODE4+pJSZxtvVC
	t1DzlKwbOqlMCJpXmP1dnOdmXkjjFVBe7Whqmzd8ErQGRgiMfJj0Y2oDcNZf6jMb
	9hj9rCkmngbIdEI5cC6oVyLXpKD7xI2jPuFNbUDpwm6O08aVnqn7K5zYLNG3hr2l
	hg7GlU2CNU8umjthNbC0YGZlZ6/l6NGvTWiprhUqFdR1vyOb6pdcA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb4r52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:46 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ7rrX029568;
	Fri, 17 Jan 2025 19:09:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb4r4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIMpmv007462;
	Fri, 17 Jan 2025 19:09:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443ynmbnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9fEf56820062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 179C720043;
	Fri, 17 Jan 2025 19:09:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7F842004D;
	Fri, 17 Jan 2025 19:09:40 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:40 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 08/15] KVM: s390: get rid of gmap_translate()
Date: Fri, 17 Jan 2025 20:09:31 +0100
Message-ID: <20250117190938.93793-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250117190938.93793-1-imbrenda@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nv561BCCAlCdr9Ioia6euJZqbuf0Oh60
X-Proofpoint-GUID: mWSE4D8c73YvcH25S_1sekM09xiSHNmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170149

Add gpa_to_hva(), which uses memslots, and use it to replace all uses
of gmap_translate().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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


