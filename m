Return-Path: <kvm+bounces-34813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C759A06410
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A022F3A5DBD
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DE720126C;
	Wed,  8 Jan 2025 18:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pT9rzWOC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0455B1FF7BE;
	Wed,  8 Jan 2025 18:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360099; cv=none; b=mC0UV5JVZnA1yXLmPoIvv8zcCoVl/amb30xxO+v9JPNLaGHKMhVszSSkcgU4+F+63mfbLlhpcXCKOPbH8QOYF7mqRMXRnnK22X1HzLG57ENbed07cHBEfX6JIX24cMXUkLq/kLL2gRh8nKEf4uTMdkPSwdZdU33+YCOMLWYxwlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360099; c=relaxed/simple;
	bh=ccFbCHIzf35bpWSvUDjqAoijtUomoZ+2jdiOVQymRoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuLuGxcqG4vdWv/GM4j/TcBkBcQaKaHKdRrbZDPLXno1jIUrduX6AwAqdmcKA3m94m35eGkGKaN6d0iNNjPhHCiK7pazMpEady17YNnN4L4Sux4iJop4q5wXvr3wo48bBmDv5Druazry1vKhCVDy0GyBnupTRMErR144CcudbgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pT9rzWOC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508DEC6C026955;
	Wed, 8 Jan 2025 18:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=g+rGGxEIPkszuYHy9
	Ulk51+d/8Rmh6+kQi7Pg+ThiPI=; b=pT9rzWOC8J3rmtQF2tIQmj+2SAnuUvY2K
	aRr0aIk1pZqjcSvuGf9BVOvsY7vzIrv2c9lJdGdEh/+eh0W9w2VA/A6NS89zCphI
	5FtSoaeJezIZhCcHDz9pYl1mGl539/2vGra6DZ4UW3TCjNqu8QdvQPfJ7M+enx5X
	36HBUkSiW5gqnHny/VfZGqSt02Jw41kV8SQ//Ha6H8Q56nF60smfy0/7bv5bgyfY
	eFW6ZQOr6lkvL23tgHpWIiFW7b2FdXtQ1tQdpxlNMD0/cNlP25Sq6U/dKhHx5HRw
	gNIoMYyjBzt0IXtwNL9G8ySIXJ2yIY7YbtDgxGcJ5Qr22F9RwzRwA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441e3b4d38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508Hf7tp027946;
	Wed, 8 Jan 2025 18:14:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yhhk8vc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IErpo45679072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E110E20040;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA5D62004D;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 03/13] KVM: s390: use __kvm_faultin_pfn()
Date: Wed,  8 Jan 2025 19:14:41 +0100
Message-ID: <20250108181451.74383-4-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: gvTU7bluCb5yDbAz3X8JP3f1H5mOsa35
X-Proofpoint-GUID: gvTU7bluCb5yDbAz3X8JP3f1H5mOsa35
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxlogscore=797 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

Refactor the existing page fault handling code to use __kvm_faultin_pfn().

This possible now that memslots are always present.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 92 +++++++++++++++++++++++++++++++---------
 arch/s390/mm/gmap.c      |  1 +
 2 files changed, 73 insertions(+), 20 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 797b8503c162..8e4e7e45238b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4794,11 +4794,66 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
 		current->thread.gmap_int_code, current->thread.gmap_teid.val);
 }
 
+static int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr,
+				     unsigned int flags)
+{
+	struct kvm_memory_slot *slot;
+	unsigned int fault_flags;
+	bool writable, unlocked;
+	unsigned long vmaddr;
+	struct page *page;
+	kvm_pfn_t pfn;
+	int rc;
+
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+		return vcpu_post_run_addressing_exception(vcpu);
+
+	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
+	if (vcpu->arch.gmap->pfault_enabled)
+		flags |= FOLL_NOWAIT;
+	vmaddr = __gfn_to_hva_memslot(slot, gfn);
+
+try_again:
+	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
+
+	/* Access outside memory, inject addressing exception */
+	if (is_noslot_pfn(pfn))
+		return vcpu_post_run_addressing_exception(vcpu);
+	/* Signal pending: try again */
+	if (pfn == KVM_PFN_ERR_SIGPENDING)
+		return -EAGAIN;
+
+	/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT) */
+	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
+		trace_kvm_s390_major_guest_pfault(vcpu);
+		if (kvm_arch_setup_async_pf(vcpu))
+			return 0;
+		vcpu->stat.pfault_sync++;
+		/* Could not setup async pfault, try again synchronously */
+		flags &= ~FOLL_NOWAIT;
+		goto try_again;
+	}
+	/* Any other error */
+	if (is_error_pfn(pfn))
+		return -EFAULT;
+
+	/* Success */
+	mmap_read_lock(vcpu->arch.gmap->mm);
+	/* Mark the userspace PTEs as young and/or dirty, to avoid page fault loops */
+	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
+	if (!rc)
+		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
+	kvm_release_faultin_page(vcpu->kvm, page, false, writable);
+	mmap_read_unlock(vcpu->arch.gmap->mm);
+	return rc;
+}
+
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
+	unsigned long gaddr, gaddr_tmp;
 	unsigned int flags = 0;
-	unsigned long gaddr;
-	int rc = 0;
+	gfn_t gfn;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
@@ -4850,29 +4905,26 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		if (vcpu->arch.gmap->pfault_enabled) {
-			rc = gmap_fault(vcpu->arch.gmap, gaddr, flags | FAULT_FLAG_RETRY_NOWAIT);
-			if (rc == -EFAULT)
-				return vcpu_post_run_addressing_exception(vcpu);
-			if (rc == -EAGAIN) {
-				trace_kvm_s390_major_guest_pfault(vcpu);
-				if (kvm_arch_setup_async_pf(vcpu))
-					return 0;
-				vcpu->stat.pfault_sync++;
-			} else {
-				return rc;
-			}
-		}
-		rc = gmap_fault(vcpu->arch.gmap, gaddr, flags);
-		if (rc == -EFAULT) {
-			if (kvm_is_ucontrol(vcpu->kvm)) {
+
+		gfn = gpa_to_gfn(gaddr);
+		if (kvm_is_ucontrol(vcpu->kvm)) {
+			/*
+			 * This translates the per-vCPU guest address into a
+			 * fake guest address, which can then be used with the
+			 * fake memslots that are identity mapping userspace.
+			 * This allows ucontrol VMs to use the normal fault
+			 * resolution path, like normal VMs.
+			 */
+			gaddr_tmp = gmap_translate(vcpu->arch.gmap, gaddr);
+			if (gaddr_tmp == -EFAULT) {
 				vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
 				vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
 				vcpu->run->s390_ucontrol.pgm_code = 0x10;
 				return -EREMOTE;
 			}
-			return vcpu_post_run_addressing_exception(vcpu);
+			gfn = gpa_to_gfn(gaddr_tmp);
 		}
+		return kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
 		break;
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
@@ -4880,7 +4932,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 		send_sig(SIGSEGV, current, 0);
 		break;
 	}
-	return rc;
+	return 0;
 }
 
 static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 16b8a36c56de..3aacef77c174 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -605,6 +605,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	radix_tree_preload_end();
 	return rc;
 }
+EXPORT_SYMBOL(__gmap_link);
 
 /**
  * fixup_user_fault_nowait - manually resolve a user page fault without waiting
-- 
2.47.1


