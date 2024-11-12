Return-Path: <kvm+bounces-31562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2BC9C4F8A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F534B2561D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C97C20B212;
	Tue, 12 Nov 2024 07:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lt915TTd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EFE20B7F2;
	Tue, 12 Nov 2024 07:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731396970; cv=none; b=kXd9X3KpKN9gnC+96ca+qRBiowEALyfXR/RrdSCufzjXCF263JuH5Z7toaG5GKnq2CQpvSzkneOmypgq7VRq6hl91cr1PwXxlBkjg7HbZKwPdZ/Dr4XHmEDAWwLHcKmkd6dgJoxJO4T45eR4Y3UWkhD2rLNpMN4awLRByZgaYtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731396970; c=relaxed/simple;
	bh=of7plpVte7XNPEMtrFY0wCx/BEfkhfecPCB6gu16mYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VHOlVWuypwLXGJSeAND79V8FSCMy1EKRNRqai+tglYAr5pEhW1CCbBP4ztH/K0HkHpjeLmyiiENEk35PDpTD+PuIcMBX1GLFrKvST8coA6EN4oD085JOc6rstNETn29gWVWPhpEMpKpNo9lFnqsSxfEO2sCG6h8s6WNh5/h62pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lt915TTd; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731396968; x=1762932968;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=of7plpVte7XNPEMtrFY0wCx/BEfkhfecPCB6gu16mYY=;
  b=Lt915TTdgHVcWebuMLlrVreQJ/O2TklGES/JjL0eH2cQ/PWNEmFedOzz
   jy86DR4HKCkX7w0iirM+Wa0r+qt35ClIoZqWHho8pb5AyFvdNQ0uUdcW8
   nHcMU4OWTIu7EaTxNxHnI7Sb4Su3GfybMmwMHMykZdazUcsPKZBZ3pP5I
   BY/pdtp1pdrWZMQa3s2AEJgrGMXZNLeGV0N51Ik+hnSnvO/2TGiZ/GDgx
   DlMmkYsL1KYufiU6N0mncPN6H05TTt3VNDWjE6/73uLyXKD/CQIzuC/kC
   sUQJFg44vwCW/DQbOGEO+bj0SR2ekV/uRPqGxkJh7bB1kql6fFDDOp7YO
   A==;
X-CSE-ConnectionGUID: O6qinUy+Q7myTdHrNFfYYQ==
X-CSE-MsgGUID: OfBCE2hlRJ685f4rtZ9oDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31090070"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31090070"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:36:08 -0800
X-CSE-ConnectionGUID: 2ZgE5tpDTS6kFB/P1WrCFw==
X-CSE-MsgGUID: qp17lVZFQOemsVj+GaKniQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92086370"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:36:04 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 00/24] TDX MMU Part 2
Date: Tue, 12 Nov 2024 15:33:27 +0800
Message-ID: <20241112073327.21979-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Here is v2 of the TDX “MMU part 2” series.
As discussed earlier, non-nit feedbacks from v1[0] have been applied.
- Among them, patch "KVM: TDX: MTRR: implement get_mt_mask() for TDX" was
  dropped. The feature self-snoop was not made a dependency for enabling
  TDX since checking for the feature self-snoop was not included in
  kvm_mmu_may_ignore_guest_pat() in the base code. So, strickly speaking,
  current code would incorrectly zap the mirrored root if non-coherent DMA
  devices were hot-plugged.

There were also a few minor issues noticed by me and fixed without internal
discussion (noted in each patch's version log).

It’s now ready to hand off to Paolo/kvm-coco-queue.


One remaining item that requires further discussion is "How to handle
the TDX module lock contention (i.e. SEAMCALL retry replacements)".
The basis for future discussions includes:
(1) TDH.MEM.TRACK can contend with TDH.VP.ENTER on the TD epoch lock.
(2) TDH.VP.ENTER contends with TDH.MEM* on S-EPT tree lock when 0-stepping
    mitigation is triggered.
    - The threshold of zero-step mitigation is counted per-vCPU when the
      TDX module finds that EPT violations are caused by the same RIP as
      in the last TDH.VP.ENTER for 6 consecutive times.
      The threshold value 6 is explained as 
      "There can be at most 2 mapping faults on instruction fetch
       (x86 macro-instructions length is at most 15 bytes) when the
       instruction crosses page boundary; then there can be at most 2
       mapping faults for each memory operand, when the operand crosses
       page boundary. For most of x86 macro-instructions, there are up to 2
       memory operands and each one of them is small, which brings us to
       maximum 2+2*2 = 6 legal mapping faults."
    - If the EPT violations received by KVM are caused by
      TDG.MEM.PAGE.ACCEPT, they will not trigger 0-stepping mitigation.
      Since a TD is required to call TDG.MEM.PAGE.ACCEPT before accessing a
      private memory when configured with pending_ve_disable=Y, 0-stepping
      mitigation is not expected to occur in such a TD.
(3) TDG.MEM.PAGE.ACCEPT can contend with SEAMCALLs TDH.MEM*.
    (Actually, TDG.MEM.PAGE.ATTR.RD or TDG.MEM.PAGE.ATTR.WR can also
     contend with SEAMCALLs TDH.MEM*. Although we don't need to consider
     these two TDCALLs when enabling basic TDX, they are allowed by the
     TDX module, and we can't control whether a TD invokes a TDCALL or
     not).

The "KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT" is 
still in place in this series (at the tail), but we should drop it when we
finalize on the real solution.


This series has 5 commits intended to collect Acks from x86 maintainers.
These commits introduce and export SEAMCALL wrappers to allow KVM to manage
the S-EPT (the EPT that maps private memory and is protected by the TDX
module):

  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT
    pages
  x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
  x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
  x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
  x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial
    contents
 
This series is based off of a kvm-coco-queue commit and some pre-req
series:
1. commit ee69eb746754 ("KVM: x86/mmu: Prevent aliased memslot GFNs") (in
   kvm-coco-queue).
2. v7 of "TDX host: metadata reading tweaks, bug fix and info dump" [1].
3. v1 of "KVM: VMX: Initialize TDX when loading KVM module" [2], with some
   new feedback from Sean.
4. v2 of “TDX vCPU/VM creation” [3]
 
It requires TDX module 1.5.06.00.0744[4], or later. This is due to removal
of the workarounds for the lack of the NO_RBP_MOD feature required by the
kernel. Now NO_RBP_MOD is enabled (in VM/vCPU creation patches), and this
particular version of the TDX module has a required NO_RBP_MOD related bug
fix.
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").

 
The series has been tested as part of the development branch for the TDX
base series. The testing consisted of TDX kvm-unit-tests and booting a
Linux TD, and TDX enhanced KVM selftests.

The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-11.3

Matching QEMU:
https://github.com/intel-staging/qemu-tdx/commits/tdx-qemu-upstream-v6.1/

[0] https://lore.kernel.org/kvm/20240904030751.117579-1-rick.p.edgecombe@intel.com/
[1] https://lore.kernel.org/kvm/cover.1731318868.git.kai.huang@intel.com/#t
[2] https://lore.kernel.org/kvm/cover.1730120881.git.kai.huang@intel.com/
[3] https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@intel.com/
[4] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06


Isaku Yamahata (17):
  KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
  KVM: TDX: Add accessors VMX VMCS helpers
  KVM: TDX: Set gfn_direct_bits to shared bit
  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT
    pages
  x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
  x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
  x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
  x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial
    contents
  KVM: TDX: Require TDP MMU and mmio caching for TDX
  KVM: x86/mmu: Add setter for shadow_mmio_value
  KVM: TDX: Set per-VM shadow_mmio_value to 0
  KVM: TDX: Handle TLB tracking for TDX
  KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page
    table
  KVM: TDX: Implement hook to get max mapping level of private pages
  KVM: TDX: Add an ioctl to create initial guest memory
  KVM: TDX: Finalize VM initialization
  KVM: TDX: Handle vCPU dissociation

Rick Edgecombe (3):
  KVM: x86/mmu: Implement memslot deletion for TDX
  KVM: VMX: Teach EPT violation helper about private mem
  KVM: x86/mmu: Export kvm_tdp_map_page()

Sean Christopherson (2):
  KVM: VMX: Split out guts of EPT violation to common/exposed function
  KVM: TDX: Add load_mmu_pgd method for TDX

Yan Zhao (1):
  KVM: x86/mmu: Do not enable page track for TD guest

Yuan Yao (1):
  [HACK] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand
    SEPT

 arch/x86/include/asm/tdx.h      |   9 +
 arch/x86/include/asm/vmx.h      |   1 +
 arch/x86/include/uapi/asm/kvm.h |  10 +
 arch/x86/kvm/mmu.h              |   4 +
 arch/x86/kvm/mmu/mmu.c          |   7 +-
 arch/x86/kvm/mmu/page_track.c   |   3 +
 arch/x86/kvm/mmu/spte.c         |   8 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  37 +-
 arch/x86/kvm/vmx/common.h       |  43 ++
 arch/x86/kvm/vmx/main.c         | 104 ++++-
 arch/x86/kvm/vmx/tdx.c          | 727 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h          |  93 ++++
 arch/x86/kvm/vmx/tdx_arch.h     |  23 +
 arch/x86/kvm/vmx/vmx.c          |  25 +-
 arch/x86/kvm/vmx/x86_ops.h      |  51 +++
 arch/x86/virt/vmx/tdx/tdx.c     | 176 ++++++++
 arch/x86/virt/vmx/tdx/tdx.h     |   8 +
 virt/kvm/kvm_main.c             |   1 +
 18 files changed, 1278 insertions(+), 52 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/common.h

-- 
2.43.2


