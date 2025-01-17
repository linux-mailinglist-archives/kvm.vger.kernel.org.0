Return-Path: <kvm+bounces-35859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B5AA157E5
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B687188C118
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE7C1AA1DB;
	Fri, 17 Jan 2025 19:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N7q0v4ZP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3BA1AA1EC;
	Fri, 17 Jan 2025 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140993; cv=none; b=Af3BPL36NP2RO0Jc4F4emhTX1vakei76AIbOZdMlHRC6yJpJjIDxD8KZheAM9raP/0o4e8K4UG88cBxMytF395IPsrcRmIdDcMvOpZcFxtn5JPOqR0fL6DKyOHTsB7kECtFs9wVgURVK10kT1zKrJkK0tghW6pGVYIIMiDM8WXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140993; c=relaxed/simple;
	bh=XULtzBnvOzbLlGq3iy0tAI7saDfBgVPqnLrfy0WCKJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU5laFeMIBUzra8l+9CgHTFfaoLaftpdPCdKOFMALx4kpfF24YJlzxFnrO4Li9Tj7LFlHji8/0jiLOhk3/EpSfAbAl8sdlN5Q1d6N3yrW6ZUw0XPy2JEhgw0UK8bphtgzu2WLcRAUdGGe719GuoCXSj5NPVztv5o2IbJ/CuC0jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N7q0v4ZP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HDwEid025351;
	Fri, 17 Jan 2025 19:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6VfGO0WEvqUrtONix
	jVuvBDeLHYtXh7oke6NxFEcWws=; b=N7q0v4ZP1D8nnLXTeB9GIHmON17cRf06B
	2zJB/O4HYgMnVE4A7cV9045H2g2O5jrt3MuPQqz1pi7A5fPMwwguO8CqhTN9ExJk
	900OJ03aAOdwpJTSdGDVihPiK/23gCHOPso/+iNomOBJXhhxHCnXvaUOnPR7KGEB
	APUw3WnHUMrhW7BLlT2nMLMThB/0AqqdBnGlH5yPGPcBVN+nzZK5PKL/+ou3NnVn
	FA8lMGldTAM+ajbERdXloS3RoT9LvpAB+xlfxZpI71bsQVdRphSn5gX4kKMz2eOP
	dHfhLM/peKEURV4QE5sHlF15PmkZFmMAB+T1D0PcVOL0gizCJfxwA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpcc1gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:46 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ9joM019665;
	Fri, 17 Jan 2025 19:09:45 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpcc1gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIlJtZ017003;
	Fri, 17 Jan 2025 19:09:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkma8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9ecn34734368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9762A2005A;
	Fri, 17 Jan 2025 19:09:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 635B32004D;
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
Subject: [PATCH v3 06/15] KVM: s390: use __kvm_faultin_pfn()
Date: Fri, 17 Jan 2025 20:09:29 +0100
Message-ID: <20250117190938.93793-7-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 4Wnwj_3euweX4OX4FLSQkhM6QiGpAanK
X-Proofpoint-GUID: r-G-V-4_1Bz0F-PNXYEn8hgWr1k5Ms8N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=955 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170149

Refactor the existing page fault handling code to use __kvm_faultin_pfn().

This possible now that memslots are always present.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 122 ++++++++++++++++++++++++++++++---------
 arch/s390/kvm/kvm-s390.h |   6 ++
 arch/s390/mm/gmap.c      |   1 +
 3 files changed, 102 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c9496d23470c..b626c87480ed 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4784,11 +4784,102 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
 		current->thread.gmap_int_code, current->thread.gmap_teid.val);
 }
 
+/*
+ * __kvm_s390_handle_dat_fault() - handle a dat fault for the gmap of a vcpu
+ * @vcpu: the vCPU whose gmap is to be fixed up
+ * @gfn: the guest frame number used for memslots (including fake memslots)
+ * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
+ * @flags: FOLL_* flags
+ *
+ * Return: 0 on success, < 0 in case of error.
+ * Context: The mm lock must not be held before calling.
+ */
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
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
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
+{
+	unsigned long gaddr_tmp;
+	gfn_t gfn;
+
+	gfn = gpa_to_gfn(gaddr);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		/*
+		 * This translates the per-vCPU guest address into a
+		 * fake guest address, which can then be used with the
+		 * fake memslots that are identity mapping userspace.
+		 * This allows ucontrol VMs to use the normal fault
+		 * resolution path, like normal VMs.
+		 */
+		mmap_read_lock(vcpu->arch.gmap->mm);
+		gaddr_tmp = __gmap_translate(vcpu->arch.gmap, gaddr);
+		mmap_read_unlock(vcpu->arch.gmap->mm);
+		if (gaddr_tmp == -EFAULT) {
+			vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
+			vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
+			vcpu->run->s390_ucontrol.pgm_code = PGM_SEGMENT_TRANSLATION;
+			return -EREMOTE;
+		}
+		gfn = gpa_to_gfn(gaddr_tmp);
+	}
+	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
+}
+
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned int flags = 0;
 	unsigned long gaddr;
-	int rc = 0;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
@@ -4840,37 +4931,14 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
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
-				vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
-				vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
-				vcpu->run->s390_ucontrol.pgm_code = 0x10;
-				return -EREMOTE;
-			}
-			return vcpu_post_run_addressing_exception(vcpu);
-		}
-		break;
+		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
 		send_sig(SIGSEGV, current, 0);
 		break;
 	}
-	return rc;
+	return 0;
 }
 
 static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
@@ -5749,7 +5817,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_S390_VCPU_FAULT: {
-		r = gmap_fault(vcpu->arch.gmap, arg, 0);
+		r = vcpu_dat_fault_handler(vcpu, arg, 0);
 		break;
 	}
 	case KVM_ENABLE_CAP:
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 30736ac16f84..3be5291723c8 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -410,6 +410,12 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
 int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
+
+static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
+{
+	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
+}
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 3e6e25119a96..bfaba7733306 100644
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
2.48.1


