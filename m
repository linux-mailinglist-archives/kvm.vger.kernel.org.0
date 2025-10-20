Return-Path: <kvm+bounces-60522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD3BBF1714
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8B20834CB15
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E21F3126B1;
	Mon, 20 Oct 2025 13:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Zwsji4yH"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C722E1494C3;
	Mon, 20 Oct 2025 13:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760965700; cv=none; b=Exsfz9armODEkL6bRUtE+k7wHfwclTxBCP1MMCjHso68DC2/lYoYZ2CNSC/cw8jEPwZxUGD6H2skZYm4AtlI9qu07ESX9yxVG9iOzIhmt31D5AXZbt3APfMmhiMac/N39pi49cvr4Uk3SuKBcmxacYOCf/XI6y/JmKoMeyMVU1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760965700; c=relaxed/simple;
	bh=//8I0dVPfl3/ugxAvErXNaziF9i3d9ZAbRKxDdDYIb4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oWt/Wkk7hNpZ2dmlIA3CEt2tj8IoBjwOlck5ZigG3YoBBooCjm94addnVqe9Gf47p6zFGtQQEVA01M/pZJ6HbIx7GxWcHrKMQ0rVqdxTilHAeR63Hln2+Qg+gtSJX5KFJPXpsFpdLPji3ArIUeSMy1NEqHxCLpF0NPM/tShZFoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Zwsji4yH; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760965687; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=VqNvlk/xz73z1KmMrkOxoHo6m+80ptyKkYHpzu2di2U=;
	b=Zwsji4yHWSRTx48z27eJlvfIuf7DRxUlsxxHhXOXpMiUbce67yhmMNy1GnKiCO9TXIrHk6PrNA44UQJRHTrBHLVsm1aqyexDTyF/2i/Fy47l8B3sH3UVitekX3DLgUwVxYu40V+L8hyoW0LJVLXWeKGjBcT0c13UDBRTcuZzcbI=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WqchCgl_1760965684 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Oct 2025 21:08:06 +0800
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
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
Date: Mon, 20 Oct 2025 21:08:01 +0800
Message-Id: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
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
---
 arch/riscv/kvm/mmu.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 525fb5a330c0..84c04c8f0892 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -197,8 +197,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	/*
 	 * A memory region could potentially cover multiple VMAs, and
-	 * any holes between them, so iterate over all of them to find
-	 * out if we can map any of them right now.
+	 * any holes between them, so iterate over all of them.
 	 *
 	 *     +--------------------------------------------+
 	 * +---------------+----------------+   +----------------+
@@ -229,32 +228,15 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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


