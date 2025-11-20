Return-Path: <kvm+bounces-63903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E811C75A4D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 2751E32577
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCDF43242DB;
	Thu, 20 Nov 2025 17:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PTrWx6nX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CD93AA1AB;
	Thu, 20 Nov 2025 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658986; cv=none; b=BF6kdt9EOH8+uldkCXudxY23IgaY8QYq2/4GINKke8pEXlybIee7IGppMUep7pH9mrdLszlOGNGMy9argoKEF09xzQrtTH/LL0o5NEy68218F1AwrNLuiEpCM/5tsmSoYyRi1AgFUv3o9T9BkqqO4SsO/eo82saGjtkycmVwGyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658986; c=relaxed/simple;
	bh=74ZdDL1jnsu+M2FxjBvlQ+NadbP94tyzu5dJbp2ffD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjQ4wN1ji55hj4r/KNhBx2i5U4rgLbiXUavdrrixVGPPSaF3jZrPR33UACKl2a/Nf7NQPPLRFuRc7doAB6DDVEXNbL6rY+kPXnAiS+XxufdEjQRAQUUBOTkJmpGoM7dGrO7vGh4NLNLKv419tNw0tWdlZvqPIzawiMRz0rnhnF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PTrWx6nX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKDFimw002726;
	Thu, 20 Nov 2025 17:16:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=44dD3G8F384Ce6uPP
	kI4G1C2kToYhDz6X/+mFIzO52A=; b=PTrWx6nXnq8AkDOz4EVvwJ3gqT+KqIzCc
	6DZfAWQdxvtNfhVeSSvW4ofamHzyzFCF9yKwRFHA9ac/nFEi/Tk7KNy4bP0AtN0z
	J5nz+doj3yS8Q2RyxqGSRA4EqVxXzJN95Ylz+DaqQrx2CbNch9FcRc8h4k/1iIVq
	Zu9MRoeMFI46E5A2ArQCqPtaECwNbEr4ANrWYyICcmxurLKuQxeZQuk7VVFMpqal
	kGjQfSeR2Jb4N23Nz6V3KK36N7lq/s6l4B0lg6IJnc6INrTdwqdSSnRcm7Jg9BJz
	uOr0VhKwdFOeIHcH/uHGxGLbqcN+uX8rHPPkHrxofMx/ccSgnINZw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejju686v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:19 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKH2ZBB022386;
	Thu, 20 Nov 2025 17:16:19 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un7mfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:19 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHGFcH43188700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:16:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF1E82004B;
	Thu, 20 Nov 2025 17:16:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4818820040;
	Thu, 20 Nov 2025 17:16:13 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:16:13 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 15/23] KVM: s390: Add helper functions for fault handling
Date: Thu, 20 Nov 2025 18:15:36 +0100
Message-ID: <20251120171544.96841-16-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: 320DJ9Ym09h21urR6qePX9U4sGkVj49d
X-Proofpoint-ORIG-GUID: 320DJ9Ym09h21urR6qePX9U4sGkVj49d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXxZ6btkaVbhGd
 0R0QqqnVNAFFbfQsVk/bTa4yt38zLFpizwnjzILl3vNqYSlBneDYp+DZz3wGcW5uBsM+vmxFsQc
 JTjdwAt8q7RrqE2sDblcVqYab7heaT+LvM1OCFeZeWgftNtW9XkzVBLYUG4PwRzod7pfwzscLEo
 AY27S4sjppJdXr8MrJ/TttbT0+MxPWoI2SufkN9tvlkxb+JZISXJW53Nu7K9kbMMwGBVmgEuCAj
 Dfk4zcTRFhtESM49gN0NtYEy+3HqBKBeJz/KLtLLwKWFIGUIbcn9rB9uMV61U7/6jUI6V4kWkkZ
 U376+gBZPiEjWUo9UxqIslABwHlZimOExEOp1FBkAa8ypAHvzNyK26Os82vzCcR+uCdpgbKyxf8
 /Ff8cngEcT5lzx5MlWUn1R5EOGVAWQ==
X-Authority-Analysis: v=2.4 cv=SvOdKfO0 c=1 sm=1 tr=0 ts=691f4ce3 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=A4J1138ORUdiv7jBIEgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

Add some helper functions for handling multiple guest faults at the
same time.

This will be needed for VSIE, where a nested guest access also needs to
access all the page tables that map it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   1 +
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/faultin.c          | 148 +++++++++++++++++++++++++++++++
 arch/s390/kvm/faultin.h          |  92 +++++++++++++++++++
 arch/s390/kvm/kvm-s390.c         |   2 +-
 arch/s390/kvm/kvm-s390.h         |   2 +
 6 files changed, 245 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/kvm/faultin.c
 create mode 100644 arch/s390/kvm/faultin.h

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index f5f87dae0dd9..958a3b8c32d1 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -441,6 +441,7 @@ struct kvm_vcpu_arch {
 	bool acrs_loaded;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
+	void *mc; /* Placeholder */
 };
 
 struct kvm_vm_stat {
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 21088265402c..1e2dcd3e2436 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,7 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
-kvm-y += dat.o gmap.o
+kvm-y += dat.o gmap.o faultin.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/faultin.c b/arch/s390/kvm/faultin.c
new file mode 100644
index 000000000000..9795ed429097
--- /dev/null
+++ b/arch/s390/kvm/faultin.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  KVM guest fault handling.
+ *
+ *    Copyright IBM Corp. 2025
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+#include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
+
+#include "gmap.h"
+#include "trace.h"
+#include "faultin.h"
+
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu);
+
+/*
+ * kvm_s390_faultin_gfn() - handle a dat fault.
+ * @vcpu: the vCPU whose gmap is to be fixed up, or NULL if operating on the VM.
+ * @kvm: the VM whose gmap is to be fixed up, or NULL if operating on a vCPU.
+ * @f: the guest fault that needs to be resolved.
+ *
+ * Return:
+ * * 0 on success
+ * * < 0 in case of error
+ * * > 0 in case of guest exceptions
+ *
+ * Context:
+ * * The mm lock must not be held before calling
+ * * kvm->srcu must be held
+ * * may sleep
+ */
+int kvm_s390_faultin_gfn(struct kvm_vcpu *vcpu, struct kvm *kvm, struct guest_fault *f)
+{
+	struct kvm_s390_mmu_cache *local_mc __free(kvm_s390_mmu_cache) = NULL;
+	struct kvm_s390_mmu_cache *mc = NULL;
+	struct kvm_memory_slot *slot;
+	unsigned long inv_seq;
+	int foll, rc = 0;
+
+	foll = f->write_attempt ? FOLL_WRITE : 0;
+	foll |= f->attempt_pfault ? FOLL_NOWAIT : 0;
+
+	if (vcpu) {
+		kvm = vcpu->kvm;
+		mc = vcpu->arch.mc;
+	}
+
+	lockdep_assert_held(&kvm->srcu);
+
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (gmap_try_fixup_minor(kvm->arch.gmap, f) == 0)
+			return 0;
+	}
+
+	while (1) {
+		f->valid = false;
+		inv_seq = kvm->mmu_invalidate_seq;
+		/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+		smp_rmb();
+
+		if (vcpu)
+			slot = kvm_vcpu_gfn_to_memslot(vcpu, f->gfn);
+		else
+			slot = gfn_to_memslot(kvm, f->gfn);
+		f->pfn = __kvm_faultin_pfn(slot, f->gfn, foll, &f->writable, &f->page);
+
+		/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT) */
+		if (f->pfn == KVM_PFN_ERR_NEEDS_IO) {
+			if (unlikely(!f->attempt_pfault))
+				return -EAGAIN;
+			if (unlikely(!vcpu))
+				return -EINVAL;
+			trace_kvm_s390_major_guest_pfault(vcpu);
+			if (kvm_arch_setup_async_pf(vcpu))
+				return 0;
+			vcpu->stat.pfault_sync++;
+			/* Could not setup async pfault, try again synchronously */
+			foll &= ~FOLL_NOWAIT;
+			f->pfn = __kvm_faultin_pfn(slot, f->gfn, foll, &f->writable, &f->page);
+		}
+
+		/* Access outside memory, addressing exception */
+		if (is_noslot_pfn(f->pfn))
+			return PGM_ADDRESSING;
+		/* Signal pending: try again */
+		if (f->pfn == KVM_PFN_ERR_SIGPENDING)
+			return -EAGAIN;
+		/* Check if it's read-only memory; don't try to actually handle that case. */
+		if (f->pfn == KVM_PFN_ERR_RO_FAULT)
+			return -EOPNOTSUPP;
+		/* Any other error */
+		if (is_error_pfn(f->pfn))
+			return -EFAULT;
+
+		if (!mc) {
+			local_mc = kvm_s390_new_mmu_cache();
+			if (!local_mc)
+				return -ENOMEM;
+			mc = local_mc;
+		}
+
+		/* Loop, will automatically release the faulted page */
+		if (mmu_invalidate_retry_gfn_unsafe(kvm, inv_seq, f->gfn)) {
+			kvm_release_faultin_page(kvm, f->page, true, false);
+			continue;
+		}
+
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			if (!mmu_invalidate_retry_gfn(kvm, inv_seq, f->gfn)) {
+				f->valid = true;
+				rc = gmap_link(mc, kvm->arch.gmap, f);
+				kvm_release_faultin_page(kvm, f->page, !!rc, f->write_attempt);
+				f->page = NULL;
+			}
+		}
+		kvm_release_faultin_page(kvm, f->page, true, false);
+
+		if (rc == -ENOMEM) {
+			rc = kvm_s390_mmu_cache_topup(mc);
+			if (rc)
+				return rc;
+		} else if (rc != -EAGAIN) {
+			return rc;
+		}
+	}
+}
+
+int kvm_s390_get_guest_page(struct kvm *kvm, struct guest_fault *f, gfn_t gfn, bool w)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	int foll = w ? FOLL_WRITE : 0;
+
+	f->write_attempt = w;
+	f->gfn = gfn;
+	f->pfn = __kvm_faultin_pfn(slot, gfn, foll, &f->writable, &f->page);
+	if (is_noslot_pfn(f->pfn))
+		return PGM_ADDRESSING;
+	if (is_sigpending_pfn(f->pfn))
+		return -EINTR;
+	if (f->pfn == KVM_PFN_ERR_NEEDS_IO)
+		return -EAGAIN;
+	if (is_error_pfn(f->pfn))
+		return -EFAULT;
+
+	f->valid = true;
+	return 0;
+}
diff --git a/arch/s390/kvm/faultin.h b/arch/s390/kvm/faultin.h
new file mode 100644
index 000000000000..f86176d2769c
--- /dev/null
+++ b/arch/s390/kvm/faultin.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  KVM guest fault handling.
+ *
+ *    Copyright IBM Corp. 2025
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef __KVM_S390_FAULTIN_H
+#define __KVM_S390_FAULTIN_H
+
+#include <linux/kvm_host.h>
+
+#include "dat.h"
+
+int kvm_s390_faultin_gfn(struct kvm_vcpu *vcpu, struct kvm *kvm, struct guest_fault *f);
+int kvm_s390_get_guest_page(struct kvm *kvm, struct guest_fault *f, gfn_t gfn, bool w);
+
+static inline int kvm_s390_faultin_gfn_simple(struct kvm_vcpu *vcpu, struct kvm *kvm,
+					      gfn_t gfn, bool wr)
+{
+	struct guest_fault f = { .gfn = gfn, .write_attempt = wr, };
+
+	return kvm_s390_faultin_gfn(vcpu, kvm, &f);
+}
+
+static inline int kvm_s390_get_guest_page_and_read_gpa(struct kvm *kvm, struct guest_fault *f,
+						       gpa_t gaddr, unsigned long *val)
+{
+	int rc;
+
+	rc = kvm_s390_get_guest_page(kvm, f, gpa_to_gfn(gaddr), false);
+	if (rc)
+		return rc;
+
+	*val = *(unsigned long *)phys_to_virt(pfn_to_phys(f->pfn) | offset_in_page(gaddr));
+
+	return 0;
+}
+
+static inline void kvm_s390_release_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
+					     int n, bool ignore)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
+					 guest_faults[i].write_attempt);
+		guest_faults[i].page = NULL;
+	}
+}
+
+static inline bool kvm_s390_multiple_faults_need_retry(struct kvm *kvm, unsigned long seq,
+						       struct guest_fault *guest_faults, int n,
+						       bool unsafe)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		if (!guest_faults[i].valid)
+			continue;
+		if (unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[i].gfn))
+			return true;
+		if (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn))
+			return true;
+	}
+	return false;
+}
+
+static inline int kvm_s390_get_guest_pages(struct kvm *kvm, struct guest_fault *guest_faults,
+					   gfn_t start, int n_pages, bool write_attempt)
+{
+	int i, rc;
+
+	for (i = 0; i < n_pages; i++) {
+		rc = kvm_s390_get_guest_page(kvm, guest_faults + i, start + i, write_attempt);
+		if (rc)
+			break;
+	}
+	return rc;
+}
+
+#define kvm_s390_release_faultin_array(kvm, array, ignore) \
+	kvm_s390_release_multiple(kvm, array, ARRAY_SIZE(array), ignore)
+
+#define kvm_s390_array_needs_retry_unsafe(kvm, seq, array) \
+	kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array), true)
+
+#define kvm_s390_array_needs_retry_safe(kvm, seq, array) \
+	kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array), false)
+
+#endif /* __KVM_S390_FAULTIN_H */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2e34f993e3c5..d7eff75a53d0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4747,7 +4747,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
 {
 	hva_t hva;
 	struct kvm_arch_async_pf arch;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c44fe0c3a097..f89f9f698df5 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -470,6 +470,8 @@ static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr,
 	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
 }
 
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu);
+
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
 
-- 
2.51.1


