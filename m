Return-Path: <kvm+bounces-46946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B9CABB367
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 04:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62D891886417
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 02:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9821E1DE2DF;
	Mon, 19 May 2025 02:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="byEwZOmm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EEC1DB92A;
	Mon, 19 May 2025 02:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747622411; cv=none; b=NyQNEPue0nqOdpoUlz/BguSGL2nZ2BYWEUd2tYZGyQMMaqXZx9O1Ppo7tRuRyWWcHEfZCNkFivrplOdfAFNMKdTY02oLjs7tv2AWRqk/sg2v6qHoTMVt1QpQNgMRiyq0W9msYKVubYIJuetxK4sm7kWH6z1fufW6Rrp42fxMeQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747622411; c=relaxed/simple;
	bh=Y0wCnSUnurFZRnLN+azAHQiKHmOTcZPUOPN5z+D56wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3gGAUhOKlZzHEELApLSZT/uf2XJAkDAYflpi7RLnNV1hNeB8pdopDYRJplC8f2/xWE5LQIA5o3qFfkx35ITTiURztIlFY4c7NaM0o3WQ9VSqkYfHwqkDz/4BnlqLgmQ9Z4neXFx5WiylsZhL1xsZRwPw0sVMntbpX9D7bdhu5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=byEwZOmm; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747622410; x=1779158410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y0wCnSUnurFZRnLN+azAHQiKHmOTcZPUOPN5z+D56wM=;
  b=byEwZOmmZ4aqbNqdR5wdv/Fswv/XHVLXlVqpTbxQBEjWQlRQgWuwd8Hy
   54+zJeAMAxVNzBsnB067yQULki5s2D7x14BhB/ukBrDfAEj5tyZ9wHZqB
   eUswV4haFFEE8BvBmUl6pNdt8L5i2aPsjqGKymdVXkKppAsbPZMcvvbL+
   /XEWsOjWG19sZewpe5ZUY7nTtN4Et9/0Eb4lyLFjFy77Y2ZjvrLa7/vMg
   bZRun1VEMqgjA2JglD9IWCFSz4XKH62KAG51N0qqFeltlUVXMoS35DLwJ
   Kyx6KPoZ3NLukgICjUoH6Cdz/Y39IxG2FqcLcn73I4fvOKJh/G/uFK3lq
   g==;
X-CSE-ConnectionGUID: Mv62kRrNQNqv875sL4Qqkw==
X-CSE-MsgGUID: I7A+tZOqR968rL8tJeo2Xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="53183544"
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="53183544"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 19:40:09 -0700
X-CSE-ConnectionGUID: GcY27bRZTw6HMoXu0YxNSQ==
X-CSE-MsgGUID: l70NrZo/R9O4EHg7KzghrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="139732958"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 19:40:07 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: reinette.chatre@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault retry on invalid slot
Date: Mon, 19 May 2025 10:37:37 +0800
Message-ID: <20250519023737.30360-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250519023613.30329-1-yan.y.zhao@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new return value RET_PF_RETRY_INVALID_SLOT to inform callers of
kvm_mmu_do_page_fault() that a fault retry is due to an invalid memslot.
This helps prevent deadlocks when a memslot is removed during pre-faulting
GPAs in the memslot or local retry of faulting private pages in TDX.

Take pre-faulting as an example.

During ioctl KVM_PRE_FAULT_MEMORY, kvm->srcu is acquired around the
pre-faulting of the entire range. For x86, kvm_arch_vcpu_pre_fault_memory()
further invokes kvm_tdp_map_page(), which retries kvm_mmu_do_page_fault()
if the return value is RET_PF_RETRY.

If a memslot is deleted during the ioctl KVM_PRE_FAULT_MEMORY, after
kvm_invalidate_memslot() marks a slot as invalid and makes it visible via
rcu_assign_pointer() in kvm_swap_active_memslots(), kvm_mmu_do_page_fault()
may encounter an invalid slot and return RET_PF_RETRY. Consequently,
kvm_tdp_map_page() will then retry without releasing the srcu lock.
Meanwhile, synchronize_srcu_expedited() in kvm_swap_active_memslots() is
blocked, waiting for kvm_vcpu_pre_fault_memory() to release the srcu lock,
leading to a deadlock.

"slot deleting" thread                   "prefault" thread
-----------------------------            ----------------------
                                         srcu_read_lock();
(A)
invalid_slot->flags |= KVM_MEMSLOT_INVALID;
rcu_assign_pointer();

                                         kvm_tdp_map_page();
                                         (B)
                                            do {
                                               r = kvm_mmu_do_page_fault();

(C) synchronize_srcu_expedited();

                                            } while (r == RET_PF_RETRY);

                                         (D) srcu_read_unlock();

As shown in diagram, (C) is waiting for (D). However, (B) continuously
finds an invalid slot before (C) completes, causing (B) to retry and
preventing (D) from being invoked.

The local retry code in TDX's EPT violation handler faces a similar issue,
where a deadlock can occur when faulting a private GFN in a slot that is
concurrently being removed.

To resolve the deadlock, introduce a new return value
RET_PF_RETRY_INVALID_SLOT and modify kvm_mmu_do_page_fault() to return
RET_PF_RETRY_INVALID_SLOT instead of RET_PF_RETRY when encountering an
invalid memslot. This prevents endless retries in kvm_tdp_map_page() or
tdx_handle_ept_violation(), allowing the srcu to be released and enabling
slot removal to proceed.

As all callers of kvm_tdp_map_page(), i.e.,
kvm_arch_vcpu_pre_fault_memory() or tdx_gmem_post_populate(), are in
pre-fault path, treat RET_PF_RETRY_INVALID_SLOT the same as RET_PF_EMULATE
to return -ENOENT in kvm_tdp_map_page() to enable userspace to be aware of
the slot removal.

Returning RET_PF_RETRY_INVALID_SLOT in kvm_mmu_do_page_fault() does not
affect kvm_mmu_page_fault() and kvm_arch_async_page_ready(), as their
callers either only check if the return value > 0 to re-enter vCPU for
retry or do not check return value.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 ++-
 arch/x86/kvm/mmu/mmu_internal.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..3331e1e1aa69 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4599,7 +4599,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
 	 */
 	if (slot->flags & KVM_MEMSLOT_INVALID)
-		return RET_PF_RETRY;
+		return RET_PF_RETRY_INVALID_SLOT;
 
 	if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
 		/*
@@ -4879,6 +4879,7 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return 0;
 
 	case RET_PF_EMULATE:
+	case RET_PF_RETRY_INVALID_SLOT:
 		return -ENOENT;
 
 	case RET_PF_RETRY:
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de62..1aa14a32225e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -311,6 +311,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
  * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
+ * RET_PF_RETRY_INVALID_SLOT: Let CPU fault again on the address due to slot
+ *                            with flag KVM_MEMSLOT_INVALID.
  *
  * Any names added to this enum should be exported to userspace for use in
  * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
@@ -326,6 +328,7 @@ enum {
 	RET_PF_INVALID,
 	RET_PF_FIXED,
 	RET_PF_SPURIOUS,
+	RET_PF_RETRY_INVALID_SLOT,
 };
 
 /*
-- 
2.43.2


