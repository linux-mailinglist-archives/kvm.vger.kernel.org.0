Return-Path: <kvm+bounces-46945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9CBABB364
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 04:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7C3E1884034
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 02:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ADA1DFDA1;
	Mon, 19 May 2025 02:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MISiFI/S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695D11A23A4;
	Mon, 19 May 2025 02:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747622306; cv=none; b=X4JU15Bdh9544zhii0nG/Nygwc+itO9Sk2w00TaJ6Y9csv0QI4VNe4wpudD+XzKijrqdA/ZEDWD/WXsXbXwVAsJR95v3FnzSadL9KNVdllnEfKYx6LO5yBHaRAYzawGCpKejdte3knQXDOCgjzpgEAr8eKWkFQaGsvtnA8YMtmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747622306; c=relaxed/simple;
	bh=S+EwngaJ/wTFsSt9cu73XDgfNv+N0N2M4GNiDVjv4AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sL4M9X+7adH2XIaK4Cj0ZGYFRVJJ7Eeb8XRqzE6hGYIiA5rL2yrTLNxaQc721zMcEZHAgZ7F4l39oRiH9Qex0VrWJynK+tEMIX9GZzKqaJM28EnDZIvt8I1X/3XpqjXVzsHAD1eUvsCEtxyWbyKsS/DhWFyaYi5/BVbmgASWD3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MISiFI/S; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747622304; x=1779158304;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S+EwngaJ/wTFsSt9cu73XDgfNv+N0N2M4GNiDVjv4AQ=;
  b=MISiFI/SZsmXiaGAOpZ6IHcjpEHjbV4LVLsQl8roXLuRElRwVasNL8Sp
   y/E2CuGbjwLNrW19nsk/l3GvrzcB9IZ9DJqnywXw0/AKhZDQ94zr+j0Io
   QzAOsa0oMN8+eNvcs1wLEGkcGYQys01tcmXSUJDqYcYg0rQ8ThHhIfIyu
   nN0KWGPk0+Ae36SZzXhgtr7SpJCdCYuxe0MS52u9vWkYuYmrCklqKC4Fc
   gmwQlEDIIvb8VL46OHgOH/QuE2ewidDLuPFKbgLn3WGGAiPhp/vCexPGT
   FGltjETutP352K8M+IQaNTZtyx8PxzwLt7zdUfDutvMqZutNA+F35G3Hg
   A==;
X-CSE-ConnectionGUID: B4LDd7jOSzy7Mco/Z+t1pg==
X-CSE-MsgGUID: +iGoqxd7TbeGhmOspgnLQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="53183498"
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="53183498"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 19:38:24 -0700
X-CSE-ConnectionGUID: grYo3CdnR96DCodZPSA8SA==
X-CSE-MsgGUID: CdoO+yrXQOKMhPBTEkzEhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="139732712"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 19:38:22 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: reinette.chatre@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/2] Introduce RET_PF_RETRY_INVALID_SLOT
Date: Mon, 19 May 2025 10:36:13 +0800
Message-ID: <20250519023613.30329-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new return value RET_PF_RETRY_INVALID_SLOT to inform callers of
kvm_mmu_do_page_fault() that a fault retry is caused by an invalid memslot.
This helps prevent deadlock when a memslot is removed during pre-faulting
or local retry of faulting private pages in TDX.

Take pre-faulting as an example. Removing a memslot during the ioctl
KVM_PRE_FAULT_MEMORY on x86 can lead to a kernel deadlock.

"slot deleting" thread                    "pre-fault" thread
-----------------------------             ----------------------
                                          srcu_read_lock();
(A)
invalid_slot->flags |= KVM_MEMSLOT_INVALID
rcu_assign_pointer();

                                          kvm_tdp_map_page();
                                          (B)
                                            do {
                                               r = kvm_mmu_do_page_fault();

(C) synchronize_srcu_expedited();

                                            } while (r == RET_PF_RETRY);

                                         (D) srcu_read_unlock();
    
 
The deadlock occurs because (C) is waiting for (D) to complete, but (B)
repeatedly encounters an invalid slot and retries before (C) can finish,
thus preventing (D) from being executed.
(If the srcu_read_lock() in the pre-fault thread is invoked after (A)
and before (C), deadlock can also occur).

The local retry code in TDX's EPT violation handler faces a similar issue,
where deadlock can occur if an invalid slot is found when faulting a
private GFN.

To resolve the deadlock, modify kvm_mmu_do_page_fault() to return
RET_PF_RETRY_INVALID_SLOT instead of RET_PF_RETRY when encountering an
invalid memslot. This change enables the pre-fault thread or TDX's EPT
violation handler to exit the loop and release the srcu lock.

There're some alternative solutions to address the deadlock.
1) Return -EAGAIN for an invalid slot.
   Cons: This approach involves an uAPI change, requiring userspace to
         ignore error -EAGAIN and re-run the vCPU. While QEMU already
         ignores -EAGAIN, selftests may need updates.

2) Call kvm_mmu_prepare_memory_fault_exit() and return -EFAULT for an
   invalid slot.
   Cons: - kvm_mmu_prepare_memory_fault_exit() is not recognized by
           userspace for normal VMs.
         - Returning -EFAULT when a memslot is still invalid (i.e., not
           completely removed) may confuse userspace.

3) Release the srcu lock before cond_resched() and re-acquire it afterward
   in kvm_tdp_map_page() and tdx_handle_ept_violation():
   Cons: - It allows each kvm_vcpu_pre_fault_memory() to pre-fault memory
           with different memslot layouts.
         - It requires tdx_gmem_post_populate() to acquire the srcu lock
           before invoking kvm_tdp_map_page(), which is redundant since
           tdx_gmem_post_populate() already holds the kvm->slots_lock.


Patch 1 opts to introduce RET_PF_RETRY_INVALID_SLOT, which prevents endless
retries in kvm_tdp_map_page() and tdx_handle_ept_violation() while avoiding
exiting to userspace.

Patch 2 provides a selftest to reproduce the deadlock when patch 1 is
absent and verifies the pre-fault can correctly completes when the faulting
range is in a removing memslot.

Note: The selftest pre_fault_memory_test relies on commit 20a6cff3b283
("KVM: x86/mmu: Check and free obsolete roots in kvm_mmu_reload()") to run
the second ioctl KVM_PRE_FAULT_MEMORY successfully after a memory slot is
removed during the first ioctl KVM_PRE_FAULT_MEMORY.
Base commit:
kvm-x86/next or
kvm/next + commit 20a6cff3b283 ("KVM: x86/mmu: Check and free obsolete
roots in kvm_mmu_reload()") 

Yan Zhao (2):
  KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault retry on invalid
    slot
  KVM: selftests: Test prefault memory with concurrent memslot removal

 arch/x86/kvm/mmu/mmu.c                        |  3 +-
 arch/x86/kvm/mmu/mmu_internal.h               |  3 +
 .../selftests/kvm/pre_fault_memory_test.c     | 82 +++++++++++++++----
 3 files changed, 72 insertions(+), 16 deletions(-)


base-commit: e59ae112a7c2e0f58d9f5905de299fe206f84af0
-- 
2.43.2


