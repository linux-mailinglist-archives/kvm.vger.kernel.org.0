Return-Path: <kvm+bounces-4666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B10281670A
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E82A1F21597
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD5D79E2;
	Mon, 18 Dec 2023 07:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZkDEERji"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3224B79C3
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883399; x=1734419399;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ya3VO47RtD2JQPYoFH9haTvVjWHFK3RcrqW/y+DxG8U=;
  b=ZkDEERjiMTrzhpd/wMfpLe1e5sZFlu6/uUa+g8zSztqzFr5nmeXwIcY3
   g0o7D5wvlGk0/XL4AAOkGt/WPI21ijPJTqPkuAXBk9g7/aMmIzthYSK6c
   hG6tenh3irMHF7kHrzUjb1JifgXp124Zvd0Wlc3hVGsG1YrVOfjGmnM3O
   NzczUH02ZyjJ/OafzfCizDr4qvcgvrB2Rp0pIS96vYKBhGtMBU53C40So
   JLJVRZzXOFDaax01I1HfhNsyeimOviwcyfYGaLByb3+fqYRmANWBy4s4l
   zZw/0reGjrMFtwyqkeWcUiWf80f/7cdiz+iBgViLwEcREQjI9/RNrLR0F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667789"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667789"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:09:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824603"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824603"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:09:54 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 00/18] X86: TDX framework support
Date: Mon, 18 Dec 2023 15:22:29 +0800
Message-Id: <20231218072247.2573516-1-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

* What's TDX?
TDX stands for Trust Domain Extensions which isolates VMs from the virtual
machine manager (VMM)/hypervisor and any other software on the platform.

To support TDX, multiple software components, not only KVM but also QEMU,
guest kernel, and virtual bios, need to be updated. For more details,
please check link[1], there are TDX spec and public repository links at
github for each software component.

* What do we add?
This patch set adds a basic framework to support running existing and
future test cases in TDX-protected environments to verify the function of
the *TDX 1.5* software stack. Appreciate any comments and suggestions.

This framework depends on UEFI support.

The supported test cases are marked in a "tdx" test group. Most of the
unsupported test cases are due to testing features not supported by TDX, a
few are due to their special design being unsuitable for running in UEFI.

This series is also available on github:
https://github.com/intel/kvm-unit-tests-tdx/tree/tdx

To run a test case in TDX:
    EFI_TDX=y [EFI_UEFI=/path/to/TDVF.fd] [QEMU=/path/to/qemu-tdx]
./x86/efi/run x86/msr.efi
To run all the tdx-supported test cases:
    EFI_TDX=y [EFI_UEFI=/path/to/TDVF.fd] [QEMU=/path/to/qemu-tdx]
./run_tests.sh -g tdx

[EFI_UEFI=/path/to/TDVF.fd] [QEMU=/path/to/qemu-tdx] customization can be
removed after released packages of OVMF and qemu have TDX support. The
current OVMF upstream code has TDX support, but its package doesn't have
full TDX features.

* Patch organization
patch  1-8: add initial support for TDX, some simple test cases could run
            with them.
patch    9: TDVF supports accepting part of the whole memory and this patch
            adds support for accepting remaining memory.
patch10-12: add multiprocessor support.
patch13-14: enable the lvl5 page table as TDVF uses it.
patch15-16: bypass and modify unsupported sub-test to be compatible with
            TDX.
patch   17: TDX-specific test case, may add more sub-tests in the future.
patch   18: enable all the TDX-supported test cases to run in a batch with
            run_tests.sh

TODO:
1. add more TDX specific sub-test
2. add mmio simulation in #VE handler

[1] "KVM TDX basic feature support"
https://lwn.net/ml/linux-kernel/cover.1699368322.git.isaku.yamahata@intel.com/

---
Changes RFC v1 -> RFC v2:
  - rebase to the latest kvm-unit-tests repo.
  - modify the TDCALL helper using one micro TDX_MODULE_CALL as the TD
    guest kernel does. And split patch1 of RFC v1 into two patches: guest
    code porting and TDX framework setup.
  - using printf instead of tdx_printf, as TDVF provides default #VE
    handler before unit test setup. (patch 2)
  - change the return of each handler in #VE. (patch 3)
  - change implementation of private memory acceptance, i.e.,
    tdx_accept_memory_regions. (patch 9)
  - move the content of lib/x86/acpi.c to lib/acpi.c. (patch 10)
  - refine AP bring-up process and integrate TDX MP to existing UEFI MP.
    (patch 11)
  - drop patch 16 of RFC v1 "x86 UEFI: Add support for parameter passing"
    as code base already has support.
  - add checks for the fixed value of virtualized CPUID. (patch 17)
  - some order adjustments and fixes.

RFC v1:
https://lore.kernel.org/all/20220303071907.650203-1-zhenzhong.duan@intel.com/

Zhenzhong Duan (18):
  x86 TDX: Port tdx basic functions from TDX guest code
  x86 TDX: Add support functions for TDX framework
  x86 TDX: Add #VE handler
  x86 TDX: Bypass APIC and enable x2APIC directly
  x86 TDX: Add exception table support
  x86 TDX: Bypass wrmsr simulation on some specific MSRs
  x86 TDX: Simulate single step on #VE handled instruction
  x86 TDX: Extend EFI run script to support TDX
  x86 TDX: Add support for memory accept
  acpi: Add MADT table parse code
  x86 TDX: Add multi processor support
  x86 TDX: Add a formal IPI handler
  x86 TDX: Enable lvl5 boot page table
  x86 TDX: Add lvl5 page table support to virtual memory
  x86 TDX: bypass unsupported syscall TF for TDX
  x86 TDX: Modify the MSR test to be compatible with TDX
  x86 TDX: Add TDX specific test case
  x86 TDX: Make run_tests.sh work with TDX

 README.md              |   6 +
 lib/acpi.c             | 160 +++++++++++
 lib/acpi.h             |  59 +++-
 lib/asm-generic/page.h |   7 +-
 lib/linux/efi.h        |  23 +-
 lib/x86/apic.c         |   4 +
 lib/x86/asm/page.h     |  19 ++
 lib/x86/asm/setup.h    |   1 +
 lib/x86/desc.c         |  18 +-
 lib/x86/desc.h         |  11 +
 lib/x86/setup.c        |  67 ++++-
 lib/x86/smp.c          |  44 ++-
 lib/x86/smp.h          |   2 +
 lib/x86/tdcall.S       |  66 +++++
 lib/x86/tdx.c          | 637 +++++++++++++++++++++++++++++++++++++++++
 lib/x86/tdx.h          | 167 +++++++++++
 lib/x86/tdxcall.S      | 249 ++++++++++++++++
 lib/x86/vm.c           |  15 +-
 x86/Makefile.common    |   3 +
 x86/Makefile.x86_64    |   1 +
 x86/efi/README.md      |   6 +
 x86/efi/efistart64.S   |  51 ++++
 x86/efi/run            |  19 ++
 x86/intel_tdx.c        | 326 +++++++++++++++++++++
 x86/msr.c              |  46 ++-
 x86/syscall.c          |   3 +-
 x86/unittests.cfg      |  21 +-
 27 files changed, 1984 insertions(+), 47 deletions(-)
 create mode 100644 lib/x86/tdcall.S
 create mode 100644 lib/x86/tdx.c
 create mode 100644 lib/x86/tdx.h
 create mode 100644 lib/x86/tdxcall.S
 create mode 100644 x86/intel_tdx.c

base-commit: 6b31aa76a038bb56b144825f55301b2ab64c02e9
-- 
2.25.1


