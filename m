Return-Path: <kvm+bounces-60672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3C9BF707B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5991F18A3119
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 14:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510F4338926;
	Tue, 21 Oct 2025 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lxf/7M7Q"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E0523D2B8;
	Tue, 21 Oct 2025 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056506; cv=none; b=ryMWwv+QCQQlDJwxLel+n3Y4AJ6NaCeSD6LlepSLg8x/3Nxx3/R62DiniZrN+0EG+uoH7QtCYpRB6Jh1KzKwAlUrfg67sZtfgTMCkGY1++Vx0h6EQML5WwCnMQ6XJ+7hdsjDMUEbuR9SlT5Uc68+aYEn9oLRt/qqfTyfJbpDH5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056506; c=relaxed/simple;
	bh=zbf5X6xFgjcLKvQ//NfXqUxkpVqdnHgnddzIX/9P3i0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QM/OhYaIEoTafgQrnATcsvCfYfdGJbqkMI+Hhda2VY58O/xygOa2pko14DrnzJaZFt/43SEnz0s0jER9hVH6PxwzClsuHBPelg8n56KbqOiYWlm7wZDNEbv89cbD4uXo5es7DhrmZ3+LG8qdeSZjPyeE6cV1vr0NGTPeYJGGaEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lxf/7M7Q; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761056497; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=bcvGo8vZx1GTax8WxbQQMp+Ghln0kxNOs/BCW6mwRY4=;
	b=lxf/7M7QxySY7IP4CMnr3nMde1Jwv3vXRKjvVmSoQqCrnihsuspPI363MwxC+3Y+RtW8PkcxXVDzwL5aEFes6aMKghPsvFeiQx6mEYx2m1iNp1I6ZhjVyfBSI7rBuOZ84niWxvx8wJlAnU6ssGBaZO0iT8D2DpzGvQSvuleQwB0=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WqjBICH_1761056493 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Oct 2025 22:21:35 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	pbonzini@redhat.com,
	jiangyifei@huawei.com
Cc: guoren@kernel.org,
	dbarboza@ventanamicro.com,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v2] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
Date: Tue, 21 Oct 2025 22:21:31 +0800
Message-Id: <20251021142131.78796-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
regions. Using vma->vm_pgoff to derive the HPA here may therefore
produce incorrect mappings.

Instead, I/O mappings for such regions can be established on-demand
during g-stage page faults, making the upfront ioremap in this path
is unnecessary.

Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Tested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

---
Changes in v2:
- Fixed build warnings.
---
 arch/riscv/kvm/mmu.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 525fb5a330c0..58f5f3536ffd 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -171,7 +171,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	hva_t hva, reg_end, size;
-	gpa_t base_gpa;
 	bool writable;
 	int ret = 0;
 
@@ -190,15 +189,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva = new->userspace_addr;
 	size = new->npages << PAGE_SHIFT;
 	reg_end = hva + size;
-	base_gpa = new->base_gfn << PAGE_SHIFT;
 	writable = !(new->flags & KVM_MEM_READONLY);
 
 	mmap_read_lock(current->mm);
 
 	/*
 	 * A memory region could potentially cover multiple VMAs, and
-	 * any holes between them, so iterate over all of them to find
-	 * out if we can map any of them right now.
+	 * any holes between them, so iterate over all of them.
 	 *
 	 *     +--------------------------------------------+
 	 * +---------------+----------------+   +----------------+
@@ -209,7 +206,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 */
 	do {
 		struct vm_area_struct *vma;
-		hva_t vm_start, vm_end;
+		hva_t vm_end;
 
 		vma = find_vma_intersection(current->mm, hva, reg_end);
 		if (!vma)
@@ -225,36 +222,18 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		}
 
 		/* Take the intersection of this VMA with the memory region */
-		vm_start = max(hva, vma->vm_start);
 		vm_end = min(reg_end, vma->vm_end);
 
 		if (vma->vm_flags & VM_PFNMAP) {
-			gpa_t gpa = base_gpa + (vm_start - hva);
-			phys_addr_t pa;
-
-			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
-			pa += vm_start - vma->vm_start;
-
 			/* IO region dirty page logging not allowed */
 			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 				ret = -EINVAL;
 				goto out;
 			}
-
-			ret = kvm_riscv_mmu_ioremap(kvm, gpa, pa, vm_end - vm_start,
-						    writable, false);
-			if (ret)
-				break;
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
 
-	if (change == KVM_MR_FLAGS_ONLY)
-		goto out;
-
-	if (ret)
-		kvm_riscv_mmu_iounmap(kvm, base_gpa, size);
-
 out:
 	mmap_read_unlock(current->mm);
 	return ret;
-- 
2.50.1


