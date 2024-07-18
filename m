Return-Path: <kvm+bounces-21882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3427B9352EF
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 595DF281DF5
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85CAE145B26;
	Thu, 18 Jul 2024 21:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UXXN2XFl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B007711F;
	Thu, 18 Jul 2024 21:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337161; cv=none; b=mvKsfvWHKg4j9UHzcSx8Xl3aFsdJ6H1nIozeBfownFeRc/GT+3p2HazpK85F67/wHteOWzrEGOxBTUmlMPQD/IlmwwHYkbm3AcTfgSIf1Sw8xZ9lOY+KtGQoGr1Plqg73LEjPYt1CNmLs/VTrg/BVeiPMFtYC36Njj+Gnx91/ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337161; c=relaxed/simple;
	bh=G8q+marLB4P520Df0G10xFxQcI6jZmxusr9GGRHBzDk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=TmhKzLFO/X6fVHo15gPrI6ua+cLMnTn70I7z6LRhWWHjzfy+9jutlH1YCyqzdLVhbVk0vb66ktDC7wjT+Z70vpSKzdwo/hrihEC4ADQT5i7xs7mZEnoc+vvXiVUiwXD4dMrwDZFd6x8MZE9oE/h8gXUQnQGopYEWhN9E881/B4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UXXN2XFl; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337160; x=1752873160;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G8q+marLB4P520Df0G10xFxQcI6jZmxusr9GGRHBzDk=;
  b=UXXN2XFlX2X/UVZ4MZvf0KJl+Ir4DRWbKWdxFBsnmljC3okzp1nzxgct
   iUE6vFB3KgXD0Ibjmxmmb67jhNRCuPzBCx8vJgxZc3GXNykE3CB0Aec8M
   RKjmhWJjA0OYtDTI/w4pwWpP4d52sUhPr4qMS9S/AZyz3zye3XNhhCnyj
   b0nKQ3gK0jYEgshYxe3VEfbOsQGm0NDHgzpe8/gZHYWdUzWJgVk/FbuGT
   KcYfitei7Pm0/bQDShLO/UPa1+hQN2bl4RyY/wrs0lZhLD0oESYKQKL2s
   8oF+3mGYsqv8sTa/QV3QR10YMBQxr8VP1bjLybe6mZwvXBx0GMKOzlHeg
   A==;
X-CSE-ConnectionGUID: DIVok8ZGTcuQpBgABb3igQ==
X-CSE-MsgGUID: f2P/Ve17S76Q+HPRLfei1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697383"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697383"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:39 -0700
X-CSE-ConnectionGUID: gzzatN5GRdy5mmvXOwlDuQ==
X-CSE-MsgGUID: FGiWZGCtQpmiQiz2BFSHRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760364"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:39 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v4 00/18] TDX MMU prep series part 1
Date: Thu, 18 Jul 2024 14:12:12 -0700
Message-Id: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is v4 of the TDX MMU prep series, split out of the giant 130 patch 
TDX base enabling series [0]. It is focusing on the changes to the x86 MMU 
to support TDX’s separation of private/shared EPT into separate roots. A 
future breakout series will include the changes to actually interact with 
the TDX module to actually map private memory.

There is a larger team working on TDX KVM base enabling. The patches were 
originally authored by Sean Christopherson and Isaku Yamahata, but 
otherwise it especially represents the work of Isaku and Yan Y Zhao and 
myself.

The series has been tested as part of a development branch for the TDX base
series [1]. The testing of this series consists TDX kvm-unit-tests [2],
regular KVM and TDX selftests, and booting a Linux TD.

Updates from v3
===============
For v4, we have a smattering of cosmetic changes and two issues worth
elaborated on found by Yan.

1. Private memory was zapped as part of the MMU notifier release callback
   during VM destruction. This was previously rejected as a solution for a
   this cleanup for a couple of reasons. While the actual S-EPT cleanup is
   implemented in later latches, part of it is setup in "KVM: x86/tdp_mmu:
   Take root types for kvm_tdp_mmu_invalidate_all_roots()". So the MMU
   notifier release patch is updated to not touch the valid mirror roots in
   this path.
2. A case was found where the memslot generation number could roll around
   and end up zapping the mirrored EPT. There actually was protection for
   this in v19 and it was thought to be not needed. So we added it back in
   mmu_alloc_direct_roots().
   
Also, some changes following the conversation in this max GFN thread [3]
1. Zap whole EPT GFN range in __tdp_mmu_zap_root()
2. Add patch for preventing memslots and fault with alias bits

This series is on top of the commit in kvm-coco-queue commit where it was
previously applied (9a6ddc3e2e1e selftests: KVM: SEV-SNP test for
KVM_SEV_INIT2).

Here is v3:
https://lore.kernel.org/kvm/20240619223614.290657-1-rick.p.edgecombe@intel.com/

[0] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com/
[1] https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-07-18
[2] https://lore.kernel.org/kvm/20231218072247.2573516-1-qian.wen@intel.com/
[3] https://lore.kernel.org/kvm/ZpbKqG_ZhCWxl-Fc@google.com/

Isaku Yamahata (13):
  KVM: Add member to struct kvm_gfn_range for target alias
  KVM: x86/mmu: Add an external pointer to struct kvm_mmu_page
  KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
  KVM: x86/tdp_mmu: Take struct kvm in iter loops
  KVM: x86/mmu: Support GFN direct bits
  KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
  KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table
    type
  KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
  KVM: x86/tdp_mmu: Support mirror root for TDP MMU
  KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks
  KVM: x86/tdp_mmu: Propagate building mirror page tables
  KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
  KVM: x86/tdp_mmu: Take root types for
    kvm_tdp_mmu_invalidate_all_roots()

Rick Edgecombe (5):
  KVM: x86/mmu: Zap invalid roots with mmu_lock holding for write at
    uninit
  KVM: x86: Add a VM type define for TDX
  KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
  KVM: x86/tdp_mmu: Don't zap valid mirror roots in
    kvm_tdp_mmu_zap_all()
  KVM: x86/mmu: Prevent aliased memslot GFNs

 arch/x86/include/asm/kvm-x86-ops.h |   4 +
 arch/x86/include/asm/kvm_host.h    |  26 ++-
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/mmu.h                 |  31 +++
 arch/x86/kvm/mmu/mmu.c             |  50 ++++-
 arch/x86/kvm/mmu/mmu_internal.h    |  64 +++++-
 arch/x86/kvm/mmu/spte.h            |   5 +
 arch/x86/kvm/mmu/tdp_iter.c        |  10 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  21 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 323 ++++++++++++++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h         |  51 ++++-
 arch/x86/kvm/x86.c                 |   3 +
 include/linux/kvm_host.h           |   6 +
 virt/kvm/guest_memfd.c             |   2 +
 virt/kvm/kvm_main.c                |  14 ++
 15 files changed, 506 insertions(+), 105 deletions(-)

base-commit: 9a6ddc3e2e1ebe37181c5fe9714d3a3590e3a792
-- 
2.34.1


