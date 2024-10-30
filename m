Return-Path: <kvm+bounces-30078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDF29B6C88
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:02:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F5721F2208C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD13213142;
	Wed, 30 Oct 2024 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WidplNMh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87571EBA1B;
	Wed, 30 Oct 2024 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314858; cv=none; b=unfjIQVtWL9J8tvEoz53n9R4BXeJu3YkEDUEVEYc7l3HmZ+CROECs2U079d9vVnO5PQd5QoMGRxJlJj2FFZrA2RYm26ExpX69pFH60fKbaQpNIevEUqivY+Hf9EELhaPUM4pqHFnOl88+rZ4q+FagROGJBz7VfkrrVt5HIBTZ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314858; c=relaxed/simple;
	bh=AY1/Rppbee7AnlhxD2jI8cIuRKIcJyJaZ6EUiXdGcPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZEgKOjuuLNnmL1TB269aKShCbvtoiM1tX4totQ2PPuyjTKcWRiyTXAO+eYwJipdmfnmDXrY4+jkay3uMIeBStC6b1QLvkkxAUCB8uqlzdaSuFtqYySwIBl2fLFsKmNe6Ft3Xwn4ZyuhiKx5LOij7aO8BGpJMLZybGAus39y2q/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WidplNMh; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314856; x=1761850856;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AY1/Rppbee7AnlhxD2jI8cIuRKIcJyJaZ6EUiXdGcPc=;
  b=WidplNMhflT6xvwgMR2mENY2Jvubl05KM+5aEZpZUPd7XXX/VjbclbL0
   3dBf1a44IRzOi5CtlPZsLSMaZBHiSYtptiXE65o4JJYbykZeHa3FQicjg
   mkeeqiRHy/us+E/IxOUtfnbSLdQUdPlmybRMGUu8qehb6ykq9s2LEwYWe
   kl+h1LfTHIj/eBpw8HnWtbTC9596zeHkBpJvYYngYZ6ZPaZnsDtk883O/
   YFClcfrapoQuvLM4SF0q0mpDqehvGw/ByLyM7Doybp3b56GQ8T9JzkDK7
   ofj2L9ZJfbuD4V4SVrFMfnxEUKnD7w45beOICle/npYTo/sqqd6S4Nym/
   Q==;
X-CSE-ConnectionGUID: TqmC91flREGspTd5YDNC4w==
X-CSE-MsgGUID: j0cWVMtORkKF2sYq59XpXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678699"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678699"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:54 -0700
X-CSE-ConnectionGUID: EFFmBkfdSRmlFaScFzuQMQ==
X-CSE-MsgGUID: fayvFIkYSh6UVChb55b80g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499294"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:53 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: [PATCH v2 00/25] TDX vCPU/VM creation
Date: Wed, 30 Oct 2024 12:00:13 -0700
Message-ID: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Here is v2 of TDX VM/vCPU creation series. As discussed earlier, non-nits 
from v1[0] have been applied and it’s ready to hand off to Paolo. A few 
items remain that may be worth further discussion:
 - Disable CET/PT in tdx_get_supported_xfam(), as these features haven’t 
   been been tested.
 - The Retry loop around tdh_phymem_page_reclaim() in “KVM: TDX: 
   create/destroy VM structure” likely can be dropped.
 - Drop support for TDX Module’s that don’t support
   MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM. [1]
 - Type-safety in to_vmx()/to_tdx(). [2]

This series has 9 commits intended to collect acks from x86 maintainers. 
The first group of commits is for reading TDX static metadata for KVM to 
use:
	x86/virt/tdx: Share the global metadata structure for KVM to use
	x86/virt/tdx: Read essential global metadata for KVM

The second group is for exporting a TDX keyid allocator for KVM to use:
	x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free
	  TDX guest KeyID

The third group is for exporting various SEAMCALLs needed by KVM for this 
series. SEAMCALL patches for the later TDX sections will come with those 
series’:
	x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
	x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
	x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
	x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
	x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
	x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations

This series is based off of a kvm-coco-queue commit and some pre-req
series:
1. d659088d46df "KVM: x86/mmu: Prevent aliased memslot GFNs" (in
   kvm-coco-queue).
2. v6 of “TDX host: metadata reading tweaks, bug fix and info dump”
3. “KVM: VMX: Initialize TDX when loading KVM module” re-ordered from 
   the commits in kvm-coco-queue

It requires TDX module 1.5.06.00.0744[3], or later. This is due to removal
of the workarounds for the lack of NO_RBP_MOD. Now NO_RBP_MOD is enabled,
and this particular version of the TDX module has a NO_RBP_MOD related bug
fix.

The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-10-30

Matching QEMU:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-wip-2024-10-11

[0] https://lore.kernel.org/kvm/20240812224820.34826-1-rick.p.edgecombe@intel.com/
[1] https://lore.kernel.org/kvm/d71540ab13e728d1326baae92e8ea82d00c08abe.camel@intel.com/
[2] https://lore.kernel.org/kvm/89657f96-0ed1-4543-9074-f13f62cc4694@redhat.com/
[3] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

Isaku Yamahata (19):
  x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX
    guest KeyID
  x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
  x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations
  KVM: TDX: Add placeholders for TDX VM/vCPU structures
  KVM: TDX: Define TDX architectural definitions
  KVM: TDX: Add helper functions to print TDX SEAMCALL error
  KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
  KVM: TDX: Get system-wide info about TDX module on initialization
  KVM: TDX: create/destroy VM structure
  KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS extension check
  KVM: TDX: initialize VM with TDX specific parameters
  KVM: TDX: Make pmu_intel.c ignore guest TD case
  KVM: TDX: Don't offline the last cpu of one package when there's TDX
    guest
  KVM: TDX: create/free TDX vcpu structure
  KVM: TDX: Do TDX specific vcpu initialization

Kai Huang (3):
  x86/virt/tdx: Share the global metadata structure for KVM to use
  KVM: TDX: Get TDX global information
  x86/virt/tdx: Read essential global metadata for KVM

Sean Christopherson (1):
  KVM: TDX: Add TDX "architectural" error codes

Xiaoyao Li (2):
  KVM: x86: Introduce KVM_TDX_GET_CPUID
  KVM: x86/mmu: Taking guest pa into consideration when calculate tdp
    level

 arch/x86/include/asm/kvm-x86-ops.h            |    4 +-
 arch/x86/include/asm/kvm_host.h               |    2 +
 arch/x86/include/asm/shared/tdx.h             |    7 +-
 arch/x86/include/asm/tdx.h                    |   25 +
 .../tdx => include/asm}/tdx_global_metadata.h |   19 +
 arch/x86/include/uapi/asm/kvm.h               |   59 +
 arch/x86/kvm/Kconfig                          |    2 +
 arch/x86/kvm/cpuid.c                          |   21 +
 arch/x86/kvm/cpuid.h                          |    3 +
 arch/x86/kvm/mmu/mmu.c                        |    9 +-
 arch/x86/kvm/vmx/main.c                       |  143 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |   50 +-
 arch/x86/kvm/vmx/pmu_intel.h                  |   28 +
 arch/x86/kvm/vmx/tdx.c                        | 1369 ++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                        |   92 ++
 arch/x86/kvm/vmx/tdx_arch.h                   |  165 ++
 arch/x86/kvm/vmx/tdx_errno.h                  |   37 +
 arch/x86/kvm/vmx/vmx.h                        |   34 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   24 +
 arch/x86/kvm/x86.c                            |   15 +-
 arch/x86/virt/vmx/tdx/tdx.c                   |  264 +++-
 arch/x86/virt/vmx/tdx/tdx.h                   |   39 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c   |   46 +
 23 files changed, 2391 insertions(+), 66 deletions(-)
 rename arch/x86/{virt/vmx/tdx => include/asm}/tdx_global_metadata.h (68%)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

-- 
2.47.0


