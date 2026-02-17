Return-Path: <kvm+bounces-71166-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0MRCD82YlGkoFwIAu9opvQ
	(envelope-from <kvm+bounces-71166-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:35:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 619AE14E46B
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D57EA300B8ED
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB133372B3A;
	Tue, 17 Feb 2026 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LkBa/Te+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C18E372B3F
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345984; cv=none; b=H+rMNoBL26do8mxx3A3jWE24WeXmTh/y6lSNO7B3ZA8EjBb6jJQ2jTEOLXB/GOeTTZm4nwAjejB2XzqJMsQLgYdBi/fbAFu+HIIz7uIrX0jStf6kd0kF1goQ1Orm9Ui+BSb7RAkQ0cezsPmYCME7Pd1ExvWUSRX1OEBQf8Ry0VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345984; c=relaxed/simple;
	bh=6DUqg/j7MJoyMnUAkNIXLh7vawHaggQP3JXWAMjbmEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hbTeZlLLL7Xa6U4SysWybLs4jD1G9P0n4DUHESVCtbiBKow1kjHE6eIBVxcWHFUlqBUGMZ/CMW5uklUodzuFdT4ab2WceDRhUAiBEkpWqZFpfxJCSiI4MMoivw1m3XkGhsWJmrRfL/x4MjGu8tSb+hkxeiDrw4s1BxPkKoMX928=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LkBa/Te+; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12721cd1a2aso3728667c88.1
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 08:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345981; x=1771950781; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9Ark9R30Qkzih8r6uy5tMYPv262iFz804WfSXpH0hs=;
        b=LkBa/Te+ITMyX7l2HgESECJxX2XpGj8KGIcSDtushZJxX1h0FeX9b66MBEa5/tGCU+
         EgoNIAdXpgdXyG1Kt0iXitpD1WIov8Oa2okJcyC5zjPYaCBH7+tcWtGpmU2rsD0yZfgG
         0RhfvYa3QeKTasOAZ+OskCA/U0UpZ904HN6oJVzWYHtGc9J4vJ7wLZP/zOMQ1gA30uHX
         oW81SuWGjpWHK66Oz1IbqGmFp9wL/972QWCwO6pL1eA+OuPih7MNGhyQ+P6FfrtQLgqB
         BEePKxH6GebGJiZsOaltBFUKfLlO/oU5129WNXJD6CffyTD4Oee9eInYhxpHNKt2/329
         Kdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345981; x=1771950781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9Ark9R30Qkzih8r6uy5tMYPv262iFz804WfSXpH0hs=;
        b=MTlha3fBB0qB+FeHawwv5pmnTLjxtIFUrEz2ZNqfitZovEFx3yQ1ASMnYVtKeQ7/wi
         n6gjTjQK1SqNmLvZTnHtTcrPyB6bnZu4Rn8A8HDflair+3aeyAD44wHkrxDwjkquARHo
         dFhasuCkoYYkziJsdThh5zN4D35rRMFds5SZSMGwmEOOLy3MvndRbDqxTAVz8ghnJZog
         g8GcqNkCBoO9N+PJLjzRKNGWg69y++7AHRj/6VosEwu72nXOD0CpKo44/T4ELI83HTM4
         IQnF5ptygNCHbH8t15H+pqibCBsHIX+wycPG3jwMlBWE+5QJdeD3ClLc+RW556xmDw4a
         a3CA==
X-Forwarded-Encrypted: i=1; AJvYcCVBbCXLSw+sT42XzsncrXkrXxO/Y+5PCH9S9tJSFa8gNNLaQ42gX/R4XBaZNbkZz1pXfBw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2k4PYBHq8Nc2NmOy8C0LkDy5Ii89SGnE8LrZsByWI7RfRtDIh
	TFqLp98naYSka7OLoiqHnnisvHfD2PeEMFk8wKTPDQ7DVtyQ2V5CLnm9U9a9aasKWo/ubEoRNUw
	DwAwI1A==
X-Received: from dlbvt13.prod.google.com ([2002:a05:7022:3f8d:b0:119:49ca:6bae])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:250e:b0:11d:f440:b743
 with SMTP id a92af1059eb24-1273adf34c5mr6016405c88.7.1771345980160; Tue, 17
 Feb 2026 08:33:00 -0800 (PST)
Date: Tue, 17 Feb 2026 08:32:50 -0800
In-Reply-To: <20260217163250.2326001-1-surenb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217163250.2326001-4-surenb@google.com>
Subject: [PATCH v2 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71166-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 619AE14E46B
X-Rspamd-Action: no action

Replace vma_start_write() with vma_start_write_killable() when
process_vma_walk_lock() is used with PGWALK_WRLOCK option.
Adjust its direct and indirect users to check for a possible error
and handle it.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 arch/s390/kvm/kvm-s390.c |  5 +++--
 arch/s390/mm/gmap.c      | 13 ++++++++++---
 fs/proc/task_mmu.c       |  7 ++++++-
 mm/pagewalk.c            | 20 ++++++++++++++------
 4 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 56a50524b3ee..75aef9c66e03 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -958,6 +958,7 @@ static int kvm_s390_get_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
+	int err;
 	unsigned int idx;
 	switch (attr->attr) {
 	case KVM_S390_VM_MEM_ENABLE_CMMA:
@@ -990,10 +991,10 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		VM_EVENT(kvm, 3, "%s", "RESET: CMMA states");
 		mutex_lock(&kvm->lock);
 		idx = srcu_read_lock(&kvm->srcu);
-		s390_reset_cmma(kvm->arch.gmap->mm);
+		err = s390_reset_cmma(kvm->arch.gmap->mm);
 		srcu_read_unlock(&kvm->srcu, idx);
 		mutex_unlock(&kvm->lock);
-		ret = 0;
+		ret = (err < 0) ? err : 0;
 		break;
 	case KVM_S390_VM_MEM_LIMIT_SIZE: {
 		unsigned long new_limit;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index dd85bcca817d..96054b124db5 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2271,6 +2271,7 @@ int s390_enable_skey(void)
 {
 	struct mm_struct *mm = current->mm;
 	int rc = 0;
+	int err;
 
 	mmap_write_lock(mm);
 	if (mm_uses_skeys(mm))
@@ -2282,7 +2283,9 @@ int s390_enable_skey(void)
 		mm->context.uses_skeys = 0;
 		goto out_up;
 	}
-	walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
+	err = walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
+	if (err < 0)
+		rc = err;
 
 out_up:
 	mmap_write_unlock(mm);
@@ -2305,11 +2308,15 @@ static const struct mm_walk_ops reset_cmma_walk_ops = {
 	.walk_lock		= PGWALK_WRLOCK,
 };
 
-void s390_reset_cmma(struct mm_struct *mm)
+int s390_reset_cmma(struct mm_struct *mm)
 {
+	int err;
+
 	mmap_write_lock(mm);
-	walk_page_range(mm, 0, TASK_SIZE, &reset_cmma_walk_ops, NULL);
+	err = walk_page_range(mm, 0, TASK_SIZE, &reset_cmma_walk_ops, NULL);
 	mmap_write_unlock(mm);
+
+	return (err < 0) ? err : 0;
 }
 EXPORT_SYMBOL_GPL(s390_reset_cmma);
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d7d52e259055..91e806d65bd9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		struct clear_refs_private cp = {
 			.type = type,
 		};
+		int err;
 
 		if (mmap_write_lock_killable(mm)) {
 			count = -EINTR;
@@ -1824,7 +1825,11 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 						0, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+		if (err < 0) {
+			count = err;
+			goto out_unlock;
+		}
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
 			flush_tlb_mm(mm);
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab2cf..dc9f7a7709c6 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
 		mmap_assert_write_locked(mm);
 }
 
-static inline void process_vma_walk_lock(struct vm_area_struct *vma,
+static inline int process_vma_walk_lock(struct vm_area_struct *vma,
 					 enum page_walk_lock walk_lock)
 {
 #ifdef CONFIG_PER_VMA_LOCK
 	switch (walk_lock) {
 	case PGWALK_WRLOCK:
-		vma_start_write(vma);
-		break;
+		return vma_start_write_killable(vma);
 	case PGWALK_WRLOCK_VERIFY:
 		vma_assert_write_locked(vma);
 		break;
@@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 		break;
 	}
 #endif
+	return 0;
 }
 
 /*
@@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 			if (ops->pte_hole)
 				err = ops->pte_hole(start, next, -1, &walk);
 		} else { /* inside vma */
-			process_vma_walk_lock(vma, ops->walk_lock);
+			err = process_vma_walk_lock(vma, ops->walk_lock);
+			if (err)
+				break;
 			walk.vma = vma;
 			next = min(end, vma->vm_end);
 			vma = find_vma(mm, vma->vm_end);
@@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (start >= end || !walk.mm)
 		return -EINVAL;
@@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(start, end, &walk);
 }
 
@@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (!walk.mm)
 		return -EINVAL;
@@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
 }
 
-- 
2.53.0.273.g2a3d683680-goog


