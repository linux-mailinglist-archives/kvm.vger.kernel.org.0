Return-Path: <kvm+bounces-71165-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PjLEHyYlGlAFwIAu9opvQ
	(envelope-from <kvm+bounces-71165-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:34:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D370914E3DA
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0DD533019CA9
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F3B372B44;
	Tue, 17 Feb 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vJHBm6W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3464437106C
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345981; cv=none; b=byeh3BDfmIH+6MM3s0Qjkp615hV0PS8QomjGc+70UYxnSSAKu/yLlpcwrtPrYPZaUM4aMqZfyJ+9BGaUM5SWBq67esdzar3CmrkuYPjO4Ap/glQ8G3lrjvWfsKlTBpSoxk5IHfY/dCir78x/jJknwreQcPUSnw2ko70b9XIeN9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345981; c=relaxed/simple;
	bh=17clLGcYY45Z39yWNLAqxADhRzU/6E8ALUBNALKQrIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nvagVrSM87B+HSj6dqxAUUWczL49OUAxzffv3N0i00wab6QfDy1KRpYtO8DIHq6CuFYU1ia4vztNSgLGAUhAAzN91zdMvnyFrg+83JjauQG10f39FOtU5GYprWKdkzR7XbArOsSlESr4+wKsYfRNKmxgXZ21WmITFP9evDy9aoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4vJHBm6W; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-1270be4d176so18772571c88.1
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 08:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345978; x=1771950778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iaZ0FDTJwGlgc+6zx0Iu+po26eUYY+Uw/UyBjgMao2k=;
        b=4vJHBm6WR5umjOza9jA+sqjGvX1uYcOYGh4z9+aZ+6yZiz+rC7Xhp6KXmu+9bBT9Kd
         7F50BSlSIWF6OMhKI4JgHcTwhTtyJ+CJuttZ+s2xeWxQhtNqeJ3plxsSE7YyYcZwwZ+p
         NwelLIffGOvPHU27PYVa2CsV2quGLter27yTfo19mxPIVvYLddFYahHWCQZ48+uz9X27
         Eq8FMw7v7eY77UKuCICcaBLlD9kwyx4ANEcYzcfp1/bZeUNhH97Xt46e49pPUqsSmE4p
         8jeSd/OyrQ8uKdFDxRZPZJz2t2dhoTmcC6234HuFBFAFph1nfsAO+OSEVN0NX4eL6nA7
         tMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345978; x=1771950778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iaZ0FDTJwGlgc+6zx0Iu+po26eUYY+Uw/UyBjgMao2k=;
        b=Pf53kMV7Hfq5NTFHm5gT/DZtGFb2E1GuSCI8eKg40dNvA3x898fe11MCr7pGbS+NDS
         Stn1F8rbp0kKSCfQrYveVvgZbAhqwzRxb6LbRPn/OO2qmk30tlEZUK708/zspSvtd7mP
         xxkm2NEDN1CeBdbN8BTs+QgWprp/S+BF/pDE4GDsH68Pj2Js+nbbD9EzvA1bFvO07Pws
         u1Y1vQmYFb2EtAUMvNxgAh5M+olfnJy8YSIaqXEHls2MfvWi/2E3jo7faheh3JFv2BJZ
         BxVasuMnLB98wh6F1yrpf/q01ky3cqJa6AKUs8giTjbHNXCU2B8PTMLLQZyJFJHkreQL
         ZvTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGEOE3OPc1jzyeVrkQb2Ym4feBTH1i8Uh/vcmFS7jCxGpE/WXfv1DO4AWZaDdj/7jJP2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGVaDrw6PD3Qs/x/u+5fQ1ez0eAsI+OFopRrLd8gkq9WINSjUd
	gKY1N7jdmy5HdSGEulh2b+XU+dI6/vu2EsUSAnWexHi04oid8dUdUyeCaCT5UvaUrplTujGHfo2
	1gZ+Z0g==
X-Received: from dlbvg11.prod.google.com ([2002:a05:7022:7f0b:b0:127:bd1:76f0])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6897:b0:127:337e:3301
 with SMTP id a92af1059eb24-12741b6fd42mr4785616c88.12.1771345977912; Tue, 17
 Feb 2026 08:32:57 -0800 (PST)
Date: Tue, 17 Feb 2026 08:32:49 -0800
In-Reply-To: <20260217163250.2326001-1-surenb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217163250.2326001-3-surenb@google.com>
Subject: [PATCH v2 2/3] mm: replace vma_start_write() with vma_start_write_killable()
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
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71165-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D370914E3DA
X-Rspamd-Action: no action

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patch:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. process_vma_walk_lock(), which requires changes in its callers and
will be handled in the next patch.

3. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

4. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
---
 arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
 include/linux/mempolicy.h          |  5 +-
 mm/khugepaged.c                    |  5 +-
 mm/madvise.c                       |  4 +-
 mm/memory.c                        |  2 +
 mm/mempolicy.c                     | 23 ++++++--
 mm/mlock.c                         | 20 +++++--
 mm/mprotect.c                      |  4 +-
 mm/mremap.c                        |  4 +-
 mm/vma.c                           | 93 +++++++++++++++++++++---------
 mm/vma_exec.c                      |  6 +-
 11 files changed, 123 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 7cf9310de0ec..69750edcf8d5 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 			ret = H_STATE;
 			break;
 		}
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = H_STATE;
+			break;
+		}
 		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
 		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 0fe96f3ab3ef..762930edde5a 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -137,7 +137,7 @@ bool vma_policy_mof(struct vm_area_struct *vma);
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new);
-extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
+extern int mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 
 extern int huge_node(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
@@ -251,8 +251,9 @@ static inline void mpol_rebind_task(struct task_struct *tsk,
 {
 }
 
-static inline void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
+static inline int mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 {
+	return 0;
 }
 
 static inline int huge_node(struct vm_area_struct *vma,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c46..392dde66fa86 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1150,7 +1150,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
diff --git a/mm/madvise.c b/mm/madvise.c
index 8debb2d434aa..b41e64231c31 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -173,7 +173,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	madv_behavior->vma = vma;
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vm_flags_reset(vma, new_flags);
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
diff --git a/mm/memory.c b/mm/memory.c
index dc0e5da70cdc..29e12f063c7b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -379,6 +379,8 @@ void free_pgd_range(struct mmu_gather *tlb,
  * page tables that should be removed.  This can differ from the vma mappings on
  * some archs that may have mappings that need to be removed outside the vmas.
  * Note that the prev->vm_end and next->vm_start are often used.
+ * We don't use vma_start_write_killable() because page tables should be freed
+ * even if the task is being killed.
  *
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index dbd48502ac24..5f6302d227f5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -556,17 +556,25 @@ void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
  *
  * Call holding a reference to mm.  Takes mm->mmap_lock during call.
  */
-void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
+int mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 {
 	struct vm_area_struct *vma;
 	VMA_ITERATOR(vmi, mm, 0);
+	int ret = 0;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 
-	mmap_write_lock(mm);
 	for_each_vma(vmi, vma) {
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = -EINTR;
+			break;
+		}
 		mpol_rebind_policy(vma->vm_policy, new);
 	}
 	mmap_write_unlock(mm);
+
+	return ret;
 }
 
 static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
@@ -1785,9 +1793,15 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
+		if (vma_start_write_killable(vma)) {
+			err = -EINTR;
+			break;
+		}
+
 		/*
 		 * If any vma in the range got policy other than MPOL_BIND
 		 * or MPOL_PREFERRED_MANY we return error. We don't reset
@@ -1808,7 +1822,6 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 			break;
 		}
 
-		vma_start_write(vma);
 		new->home_node = home_node;
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..2885b858aa0f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -420,7 +420,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
  * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
  * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
  */
-static void mlock_vma_pages_range(struct vm_area_struct *vma,
+static int mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end, vm_flags_t newflags)
 {
 	static const struct mm_walk_ops mlock_walk_ops = {
@@ -441,7 +441,9 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	 */
 	if (newflags & VM_LOCKED)
 		newflags |= VM_IO;
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vm_flags_reset_once(vma, newflags);
 
 	lru_add_drain();
@@ -452,6 +454,7 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		newflags &= ~VM_IO;
 		vm_flags_reset_once(vma, newflags);
 	}
+	return 0;
 }
 
 /*
@@ -501,10 +504,12 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 */
 	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
 		/* No work to do, and mlocking twice would be wrong */
-		vma_start_write(vma);
+		ret = vma_start_write_killable(vma);
+		if (ret)
+			goto out;
 		vm_flags_reset(vma, newflags);
 	} else {
-		mlock_vma_pages_range(vma, start, end, newflags);
+		ret = mlock_vma_pages_range(vma, start, end, newflags);
 	}
 out:
 	*prev = vma;
@@ -733,9 +738,12 @@ static int apply_mlockall_flags(int flags)
 
 		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
 				    newflags);
-		/* Ignore errors, but prev needs fixing up. */
-		if (error)
+		/* Ignore errors except EINTR, but prev needs fixing up. */
+		if (error) {
+			if (error == -EINTR)
+				break;
 			prev = vma;
+		}
 		cond_resched();
 	}
 out:
diff --git a/mm/mprotect.c b/mm/mprotect.c
index c0571445bef7..49dbb7156936 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -765,7 +765,9 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
 	 */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error < 0)
+		goto fail;
 	vm_flags_reset_once(vma, newflags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0..aef1e5f373c7 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1286,7 +1286,9 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 		return -ENOMEM;
 
 	/* We don't want racing faults. */
-	vma_start_write(vrm->vma);
+	err = vma_start_write_killable(vrm->vma);
+	if (err)
+		return err;
 
 	/* Perform copy step. */
 	err = copy_vma_and_data(vrm, &new_vma);
diff --git a/mm/vma.c b/mm/vma.c
index bb4d0326fecb..1d21351282cf 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -530,6 +530,13 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (err)
 		goto out_free_vmi;
 
+	err = vma_start_write_killable(vma);
+	if (err)
+		goto out_free_mpol;
+	err = vma_start_write_killable(new);
+	if (err)
+		goto out_free_mpol;
+
 	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
 	if (err)
 		goto out_free_mpol;
@@ -540,9 +547,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
-	vma_start_write(new);
-
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
@@ -895,16 +899,22 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	}
 
 	/* No matter what happens, we will be adjusting middle. */
-	vma_start_write(middle);
+	err = vma_start_write_killable(middle);
+	if (err)
+		goto abort;
 
 	if (merge_right) {
-		vma_start_write(next);
+		err = vma_start_write_killable(next);
+		if (err)
+			goto abort;
 		vmg->target = next;
 		sticky_flags |= (next->vm_flags & VM_STICKY);
 	}
 
 	if (merge_left) {
-		vma_start_write(prev);
+		err = vma_start_write_killable(prev);
+		if (err)
+			goto abort;
 		vmg->target = prev;
 		sticky_flags |= (prev->vm_flags & VM_STICKY);
 	}
@@ -1155,10 +1165,12 @@ int vma_expand(struct vma_merge_struct *vmg)
 	struct vm_area_struct *next = vmg->next;
 	bool remove_next = false;
 	vm_flags_t sticky_flags;
-	int ret = 0;
+	int ret;
 
 	mmap_assert_write_locked(vmg->mm);
-	vma_start_write(target);
+	ret = vma_start_write_killable(target);
+	if (ret)
+		return ret;
 
 	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
@@ -1187,6 +1199,9 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
 	if (remove_next) {
+		ret = vma_start_write_killable(next);
+		if (ret)
+			return ret;
 		ret = dup_anon_vma(target, next, &anon_dup);
 		if (ret)
 			return ret;
@@ -1197,10 +1212,8 @@ int vma_expand(struct vma_merge_struct *vmg)
 			return ret;
 	}
 
-	if (remove_next) {
-		vma_start_write(next);
+	if (remove_next)
 		vmg->__remove_next = true;
-	}
 	if (commit_merge(vmg))
 		goto nomem;
 
@@ -1233,6 +1246,7 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff)
 {
 	struct vma_prepare vp;
+	int err;
 
 	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
 
@@ -1244,7 +1258,11 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
-	vma_start_write(vma);
+	err = vma_start_write_killable(vma);
+	if (err) {
+		vma_iter_free(vmi);
+		return err;
+	}
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
@@ -1434,7 +1452,9 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 			if (error)
 				goto end_split_failed;
 		}
-		vma_start_write(next);
+		error = vma_start_write_killable(next);
+		if (error)
+			goto munmap_gather_failed;
 		mas_set(mas_detach, vms->vma_count++);
 		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
 		if (error)
@@ -1828,12 +1848,17 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
+	int err;
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	vma_start_write(vma);
+	err = vma_start_write_killable(vma);
+	if (err) {
+		vma_iter_free(&vmi);
+		return err;
+	}
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma, /* hold_rmap_lock= */false);
 	mm->map_count++;
@@ -2215,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (signal_pending(current) || vma_start_write_killable(vma))
 			goto out_unlock;
-		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
@@ -2532,6 +2556,11 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 		goto free_vma;
 	}
 
+	/* Lock the VMA since it is modified after insertion into VMA tree */
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free_iter_vma;
+
 	if (map->file)
 		error = __mmap_new_file_vma(map, vma);
 	else if (map->vm_flags & VM_SHARED)
@@ -2552,8 +2581,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
 #endif
 
-	/* Lock the VMA since it is modified after insertion into VMA tree */
-	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
 	vma_link_file(vma, map->hold_file_rmap_lock);
@@ -2864,6 +2891,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		 unsigned long addr, unsigned long len, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
+	int err = -ENOMEM;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2908,7 +2936,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
 	vm_flags_init(vma, vm_flags);
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		err = -EINTR;
+		goto mas_store_fail;
+	}
 	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
@@ -2928,7 +2959,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vm_area_free(vma);
 unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
-	return -ENOMEM;
+	return err;
 }
 
 /**
@@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next;
 	unsigned long gap_addr;
-	int error = 0;
+	int error;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSUP))
@@ -3126,12 +3157,14 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto free;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3160,6 +3193,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
+free:
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
@@ -3174,7 +3208,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
-	int error = 0;
+	int error;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSDOWN))
@@ -3205,12 +3239,14 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto free;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3240,6 +3276,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
+free:
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 8134e1afca68..a4addc2a8480 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -40,6 +40,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+	int err;
 
 	BUG_ON(new_start > new_end);
 
@@ -55,8 +56,9 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	 * cover the whole range: [new_start, old_end)
 	 */
 	vmg.target = vma;
-	if (vma_expand(&vmg))
-		return -ENOMEM;
+	err = vma_expand(&vmg);
+	if (err)
+		return err;
 
 	/*
 	 * move the page tables downwards, on failure we rely on
-- 
2.53.0.273.g2a3d683680-goog


