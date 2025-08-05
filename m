Return-Path: <kvm+bounces-54015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E17AB1B638
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E72D1885945
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3646F27932F;
	Tue,  5 Aug 2025 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="di8EyC7N"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF3B23BD05;
	Tue,  5 Aug 2025 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403477; cv=none; b=tolTgXONcHRfBnjfVhSsEP6qLs0D8Gb+JssAzbQjfdR/szFXGZxg9ziCkP424rR95cyShY9dbSwMzYa4N0DeRx7NarAluVJqTq856QdAf7LR6MOxZjZpnnNTCTtw14agskb1vU9bXo89iiBg+kuL54gnA9YyocNFUEEGbOMmGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403477; c=relaxed/simple;
	bh=piZnBNEM/R//M5vy4jYcotPOmhS390dGzblYwQ6hg84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tySU8YHnWnrOeEBC+DYO3MzL3pDWvRl6yM3doiFLzZZaX/ULPmEeHn4YrJ3dvsgSM3Y8GkNVwSmwG4w1VXy1j87gb6wX21fg2dZXBxhXhwkZvF15LiS9H+AUO0PN3CEtFAj1cu18Xc/l+efWOLs6FhKI/ae5LzXE3N9+M6EkBV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=di8EyC7N; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575AnqfH029445;
	Tue, 5 Aug 2025 14:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ff4YZ039FAgn/a7t1
	w0gh3+zrdnFeiTSnEIXfI8L6eE=; b=di8EyC7NrdD1ddALrEw9HeoXyoAXvzPE7
	Hsho2G5awkjxhmMAonRYu8yN5vyy1CJlbHsCUeUiHsMhh9O+NdEQJbecr66NoEGI
	ohCGc2sdDTVYxF85jmLqfSuuT3+gdPhpYefKHRHsKi+rHgntSTjeQhHmUJDtkPjU
	L2sc1QKS3GsbPHhLFPP/Wlc3tAcP066nA+liiAaLDZWyJKXRjfmbIFcHKvP1gWWN
	7poAQfiiOkWvgO10wpnK+eaGgxJtfvf/gO51tM1ussoy9eILDPDjiGTiIxov4Stw
	Z7aM1FxdhObBLPieR55QNO6jvLQ41/ECwp5ggMi9YADYAnOR8gueA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ac0xwem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:17:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 575Dc2rP009594;
	Tue, 5 Aug 2025 14:17:51 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489x0p2r9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:17:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575EHlMR19923422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 14:17:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4865C2004B;
	Tue,  5 Aug 2025 14:17:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1ABB32004F;
	Tue,  5 Aug 2025 14:17:47 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 14:17:47 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v2 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
Date: Tue,  5 Aug 2025 16:17:46 +0200
Message-ID: <20250805141746.71267-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805141746.71267-1-imbrenda@linux.ibm.com>
References: <20250805141746.71267-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wztfLUSPPZJ996zhUy2QyYz0KOeDceIs
X-Proofpoint-ORIG-GUID: wztfLUSPPZJ996zhUy2QyYz0KOeDceIs
X-Authority-Analysis: v=2.4 cv=GNoIEvNK c=1 sm=1 tr=0 ts=68921290 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=hH8_rHouDUwXcPhP104A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDEwMSBTYWx0ZWRfX1DH2YaOy6o5z
 4pbv4vPbXsxDnEURn3aHi57hCpnzFwPYFcefUzQXjHf4tROrBIrG5UMRzpFmkUVWuddNfIWn0Ty
 zjp8hXLDiafkAqspZIV2WwmZkEh9xGemLoKrYaQHsuxmfht+l5s2bRGG4tZXSP9kk7sy0NsusQc
 810rq77HlDOL0TADHaKN85rTTEhbnVcrSHpPlKBlvKuANLcHMEFeHqOUNI9+JS3Y69ertdmr5lx
 AbwWLDvnElciGYP/l5wyk9uLyPhjYwEjetKApaqr8s1MGSit+ITwniC4myzvAO5o9x/klR4/QTR
 vs6osrDPAgOw7fjqw8vKaw5z1iHoLI4iH5mPFmEuvN0KCpr6m/67wnJrTZPq+48vnNFfUjhEqmp
 lYs/uYwGim/UpgfzCiQqUK4t/hF7AXeXIQYvMW0915ZPhk1PJNNk120GTkeRInpvi6/v84h2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508050101

Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
instead.

This still works because they happen to have the same integer value,
but it's a mistake, thus the fix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d5ad10791c25..4280b25b6b04 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4863,12 +4863,12 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
  * @vcpu: the vCPU whose gmap is to be fixed up
  * @gfn: the guest frame number used for memslots (including fake memslots)
  * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
- * @flags: FOLL_* flags
+ * @foll: FOLL_* flags
  *
  * Return: 0 on success, < 0 in case of error.
  * Context: The mm lock must not be held before calling. May sleep.
  */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int foll)
 {
 	struct kvm_memory_slot *slot;
 	unsigned int fault_flags;
@@ -4882,13 +4882,13 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return vcpu_post_run_addressing_exception(vcpu);
 
-	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
+	fault_flags = foll & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
 	if (vcpu->arch.gmap->pfault_enabled)
-		flags |= FOLL_NOWAIT;
+		foll |= FOLL_NOWAIT;
 	vmaddr = __gfn_to_hva_memslot(slot, gfn);
 
 try_again:
-	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
+	pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
 
 	/* Access outside memory, inject addressing exception */
 	if (is_noslot_pfn(pfn))
@@ -4904,7 +4904,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 			return 0;
 		vcpu->stat.pfault_sync++;
 		/* Could not setup async pfault, try again synchronously */
-		flags &= ~FOLL_NOWAIT;
+		foll &= ~FOLL_NOWAIT;
 		goto try_again;
 	}
 	/* Any other error */
@@ -4924,7 +4924,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	return rc;
 }
 
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int foll)
 {
 	unsigned long gaddr_tmp;
 	gfn_t gfn;
@@ -4949,18 +4949,18 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
 		}
 		gfn = gpa_to_gfn(gaddr_tmp);
 	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
+	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, foll);
 }
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
-	unsigned int flags = 0;
+	unsigned int foll = 0;
 	unsigned long gaddr;
 	int rc;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 
 	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
 	case 0:
@@ -5002,7 +5002,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		if (rc != -ENXIO)
 			break;
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
@@ -5012,7 +5012,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
+		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
-- 
2.50.1


