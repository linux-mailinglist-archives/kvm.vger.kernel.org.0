Return-Path: <kvm+bounces-28670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB50299B1BE
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 09:40:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20660B2360C
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 07:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFE813C661;
	Sat, 12 Oct 2024 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lplOeCl3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0876B139CE9;
	Sat, 12 Oct 2024 07:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728718816; cv=none; b=UHIxqfO4CFpElcXZCTbogg8bZTZImGuAjr9ukOjDU1QVUoL89dN2yi+IqkVBYB5/g4gp1JyWf2PKFYKOVYqaRGtLLzz7CdOI32B8gIX8h5RCyVr7O2P5tZRqwVteuGUys1B6lMlJ/0gD/K7F22W2LvfJlrtFJwCz+dX2ZOvTxEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728718816; c=relaxed/simple;
	bh=jgp+G04S25gy4PbJl/vjIicZbOHEh9P90HMpb2PjBPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BLRufkDo5hpzVQ1jx1zoabQSoSSUAYG/GJLopvr/alkPp44FLZmwp41Y/QTYCLQJFhpryrLAFJNkRM3nLlPLAK7DVsycGG8vRUViKWWA+9f3C5Mj+8wPTYUieJBQ5vEHF5Eic4nt6czCfAsg1aniaGo3jKn1xOeYRnqDrDSPVL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lplOeCl3; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728718815; x=1760254815;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jgp+G04S25gy4PbJl/vjIicZbOHEh9P90HMpb2PjBPg=;
  b=lplOeCl3NhCdb21Nn+QhnF3eIsxT+DAbvBTV9wxwFfuJDxWQOWirBQ/U
   8p9Knr2ZjJ0uQDXmq5dQJGzWSEKTkZcL46OkKFVu93yRomAMo1rK7DEn6
   lKzGq1H8TXeXlS51qNZx2USjOC0OhjKWT9OkIwAmjbqHRDQ+QDWbnKdBC
   G1h2SiLPYAF1YjMj/qEhWvLS7Fqb05rsrlFSWPeRc+C7Hg10yqKpnExXi
   HXjZG833LnPqGCvKTLN/QsMMTa5RzEaErBMB/p6qaoDdmoo5C0p2XEU/g
   zOJYeBvMDz/dWyzvp71sCfaE0Un2eK1KEeiwtCBUocureIzoUugFb1lYR
   w==;
X-CSE-ConnectionGUID: MYcoiao8QPe+wHJlIGeTxw==
X-CSE-MsgGUID: 9939s+56TOuufHTcPiR+ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28221673"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="28221673"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:40:15 -0700
X-CSE-ConnectionGUID: zgYYXWG0Ryu5t1bkzYtBfA==
X-CSE-MsgGUID: 9eC+jjToQEmx0Lju7YlC1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="77930913"
Received: from ls.amr.corp.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:40:14 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: Sean Christopherson <seanjc@google.com>,
	sagis@google.com,
	chao.gao@intel.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com
Subject: [PATCH v2 0/2] KVM: x86/tdp_mmu: Trigger the callback only when an interesting change
Date: Sat, 12 Oct 2024 00:39:54 -0700
Message-ID: <cover.1728718232.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is for kvm-coco-queue.   Invoke the leaf spte change hook only when
non-present => present change.

Patches:
1: Add WARN_ON_ONCE()
2: Bug fix

v2:
- Split out WARN_ON_ONCE() into an independent patch
- Removed pr_debug()

v1: https://lore.kernel.org/kvm/6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com/

As the test requires the base TDX KVM patch series and the TDX KVM kselftesets,
this patch series doesn't include it.  [1] suggested to require the AD bits
supports for TDX.  Don't include the following chage because this patch series
is for kvm-coco-queue.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 109a7440aa68..5499edb80b9a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3275,7 +3275,7 @@ static int __init __tdx_bringup(void)
        const struct tdx_sys_info_td_conf *td_conf;
        int r, i;
 
-       if (!tdp_mmu_enabled || !enable_mmio_caching)
+       if (!tdp_mmu_enabled || !enable_mmio_caching || !enable_ept_ad_bits)
                return -EOPNOTSUPP;
 
        if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {


Observation of the issue
------------------------
An issue was reported on an out-of-tree kernel with an older version of TDX
support, but that uses similar code to the current existing mirror/external
MMU support.  It can't be triggered without future patches.  In the out of
tree kernel it appears as a KVM_BUG_ON() getting hit in TDX code when
set_external_spte() was called on a PTE that was already present.
Investigation turned up that:

 1. It was due to the AD state machine trying to update the dirty bit
 2. A problem in the currently queued mirror/external PTE, but that can't be
    hit until more TDX support is added.

In more detail, the spotted issue was caused by two vcpus simultaneously
faulting for same GFN:

vcpu0                                   vcpu1
-----                                   -----
ept violation for GFN                   ept violation for GFN
encounter !present mirror PTE
set_external_spte()
re-enter TD, and accept GFN
                                        encounter present mirror PTE
                                        trigger AD state machine transition
                                        see old/new PTEs are different
                                        call set_external_spte() again

The TDX external TDP backend couldn't handle the second call to
set_external_spte().  In recent TDX development branches, the
TDH.MEM.PAGE.AUG() SEAMCALL() hook would fail unexpectedly with
TDX_EPT_ENTRY_STATE_INCORRECT + SPTE PENDING or PRESENT.  However, the
callback assumes that it's called only when non-present => present leaf
SPTE change.  It shows as a triggering a KVM_BUG_ON() with a stacktrace
like:

  WARNING: CPU: 4 PID: 3700 at tdx_mem_page_aug+0x16d/0x560 [kvm_intel]
  IP: 0010:tdx_mem_page_aug+0x16d/0x560 [kvm_intel]

  Call Trace:
  set_external_spte_present+0x244/0x7e0
  tdp_mmu_map_handle_target_level+0x460/0xd60
  kvm_tdp_mmu_map+0x9c6/0xdc0
  kvm_tdp_mmu_page_fault+0x32b/0x3e0
  kvm_mmu_do_page_fault+0x4e5/0x6a0
  kvm_mmu_page_fault+0x1a0/0x5e0
  vcpu_enter_guest+0x1f5f/0x3900
  vcpu_run+0x133/0xb60
  kvm_arch_vcpu_ioctl_run+0x8ef/0x1650
  kvm_vcpu_ioctl+0x4f9/0xb70
  __x64_sys_ioctl+0x132/0x1a0
  do_syscall_64+0xc1/0x1d0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Design of MMU mirror/external
-----------------------------
In current mirror/external MMU support, the set_external_spte() allows
external PTEs to be set as present, but doesn't allow configuration of any
other PTE bits.  remove_external_spte() allows external PTEs to be zapped.

Based on the fact that external PTE callbacks are exposed to essentially
configure two PTE states (present or not present), and that mirror PTEs
record whether the external PTE is present or not, future patches were
planned to introduce a TDX backend for mirror/external page tables to not
expect set_external_spte() calls on already present external PTEs.  To
accommodate this future code, steps were taken in the mirror/external
support in the core MMU to prevent permission bits changing on such PTEs.

However, the AD state machine scenario was missed.  When the multiple vCPUs
fault in the same GFN simultaneously, the hook is called multiple times
with some bits changed while both old/new SPTEs have the present bits.  The
leaf SPTE is a complex state machine in general, and the value can change
with software available bits and hardware bits.

Solution
--------
There are several options to address this:
- Tame the SPTE state machine so that SPTE change won't happen for mirrored
  page table.
  PRO: It's conceptually natural to disable D bit support because mirrored
       page table doesn't support AD bits.
  CON: Not only D bit but also other bits can be modified.
       setting strict kvm_page_table.role.ad_disabled = true doesn't work.
       It requires to change the SPTE more deeply.

- Add a check to the TDP MMU so that it won't call the hook unnecessarily
  PRO: Direct fix that shares set_external_spte() expectations in core
       MMU code.
  CON: Hard code in the TDP MMU when the hook is needed.

- Pass old and new SPTE values to the hooks, add a check to the backend
  PRO: The backend can determine whether the callback is needed.
  CON: The KVM MMU implementation details leak to the backend because
       The SPTE encoding is specific to the KVM MMU implementation.
       And it's subject to change in the future.
       For example, is_shadow_present_pte() needs to be exported from the
       KVM MMU to the backend.

The first choice is out because it doesn't easily handle the problem.
Choose the second option over the third choice because the current
interesting change is only non-present => present because we don't support
dirty page tracking by write protect and large page yet by TDX KVM for now.
(TDX supports them.) They're future work for TDX KVM.

Care only about the leaf SPTE because non-leaf doesn't have a state
machine.

[1] https://lore.kernel.org/kvm/ZuOCXarfAwPjYj19@google.com/

Isaku Yamahata (2):
  KVM: x86/tdp_mmu: Add WARN_ON_ONCE() in
    tdp_mmu_map_handle_target_level()
  KVM: x86/tdp_mmu: Trigger the callback only when an interesting change

 arch/x86/kvm/mmu/spte.h    | 11 +++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 24 ++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)


base-commit: 909f9d422f59f863d7b6e4e2c6e57abb97a27d4d
-- 
2.45.2


