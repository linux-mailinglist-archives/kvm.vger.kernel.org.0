Return-Path: <kvm+bounces-45903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C647BAAFE4E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC5D1B2767A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FEF27B4E0;
	Thu,  8 May 2025 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jL+fxcWg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058A81DFE1
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716696; cv=none; b=YVOdPJhtNbkL9EAWV4JSQvNXbzAjPIEGL+zajion8grDuVlvx8l1kzHQYUTo/xuKqPnZBbt7bLwtAZE75OKgNi+AtFVYCTpIpie1qTswE9KxMFxQPjpvfr3pcyDnaZKrkE9UmmqIAHKVSH6k9v/9JOD0lQwyic2cIYlGXxisxW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716696; c=relaxed/simple;
	bh=bkw4Py6irLcip5aAViuEMT8U9DSXtLABWaXuQIhgQwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IkuRL14jbknBHKPALjphEG+8mTtFmj7KKUzJBE93JPWdDuh5nmYjqMtkAEXj9+YStoohbpCZH4YDe55rFOGfocO2Sz55PbF2ChipbkBLUBRcPZgnPYk56hzzKBWIyzVFhnYTxlmnSnih/5np0gn6ULgYGF9660kxtB4iHPde7Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jL+fxcWg; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716694; x=1778252694;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bkw4Py6irLcip5aAViuEMT8U9DSXtLABWaXuQIhgQwY=;
  b=jL+fxcWg2llvw5gb6F1kQoDY9C+RYi148qZw18WHxbPiQ4HfDHMehaAC
   Cd4sFJtQ6T+K+26wq2TSMeyoagPFcpBbhR3JaBYeE0ER92mwElgC8cwtA
   tUBsZnXw+mcPmtzbXoffUBZPp5ryyQIy1TsPAiu2HCvgRuDE4rGowBCSU
   swuCCAdSxohzMIn7jP17pji/cCx0xH3I99zET09ysb9QlixSvBPoKadst
   e+W2b+3HTniAa1V3S6yxlMSOVykUE/caozQ63QrAI7pZQf1CTFsbWYJ5h
   El0XiHyqoVCJR9stzP0IYDda3HtDrNBCMux7tixsPocFOWwaM/44s+zWD
   Q==;
X-CSE-ConnectionGUID: 4xa/+FeXQzW39U8Bkr+dCQ==
X-CSE-MsgGUID: HRHKXfvdT8KeI8jF+U3VAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73887960"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73887960"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:04:53 -0700
X-CSE-ConnectionGUID: 3hbi2tHARpKVF0Y9bC1Jsw==
X-CSE-MsgGUID: GhipiGHrQyquJBle8FYwhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439634"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:04:50 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 00/55] QEMU TDX support
Date: Thu,  8 May 2025 10:59:06 -0400
Message-ID: <20250508150002.689633-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the v9 series of TDX QEMU enabling. The series is also available
at github:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v9

Note, this series has a dependency on
https://lore.kernel.org/qemu-devel/20241217123932.948789-1-xiaoyao.li@intel.com/

=============
Changes in v9

Comparing to v8, no big change in v9.

V9 mainly collects Reviewed-by tags from Daniel and Zhao Liu (Thanks to
their review!) and v9 does some small change according to the review
feedback of them. Please see the individual patch for the detailed
change history.

===========
future work

- CPU model

  It now only supports booting TD VM with "-cpu host". It is the only
  case that is not supposed to hit any warning/error.

  When using named CPU model, even the same model as host, it likely
  hits warning like some feature not supported or some feature enforced
  on. It's a future work to decide if needs to introduce TDX specific
  named CPU models.

- Attestation support

  Atttestation support will be submitted separately since it depends on
  the GHCI clarification on the format of the `datai` filed of the
  shared buffer of <GetQuote>.[1]

- gdb support

  gdb support to debug a TD in off-debug mode is left as future work.

[1] https://lore.kernel.org/qemu-devel/f1b0c905-3804-4c34-bc17-e437a8ae86d6@intel.com/
  
=======
history

v8: https://lore.kernel.org/qemu-devel/20250401130205.2198253-1-xiaoyao.li@intel.com/

v7: https://lore.kernel.org/qemu-devel/20250124132048.3229049-1-xiaoyao.li@intel.com/

Chao Peng (1):
  i386/tdx: load TDVF for TD guest

Isaku Yamahata (5):
  i386/tdx: Make sept_ve_disable set by default
  i386/tdx: Support user configurable mrconfigid/mrowner/mrownerconfig
  i386/tdvf: Introduce function to parse TDVF metadata
  i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
  i386/tdx: Don't synchronize guest tsc for TDs

Xiaoyao Li (49):
  *** HACK *** linux-headers: Update headers to pull in TDX API changes
  i386: Introduce tdx-guest object
  i386/tdx: Implement tdx_kvm_type() for TDX
  i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
  i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
  i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
  kvm: Introduce kvm_arch_pre_create_vcpu()
  i386/tdx: Initialize TDX before creating TD vcpus
  i386/tdx: Add property sept-ve-disable for tdx-guest object
  i386/tdx: Wire CPU features up with attributes of TD guest
  i386/tdx: Validate TD attributes
  i386/tdx: Set APIC bus rate to match with what TDX module enforces
  i386/tdx: Implement user specified tsc frequency
  i386/tdx: Parse TDVF metadata for TDX VM
  i386/tdx: Don't initialize pc.rom for TDX VMs
  i386/tdx: Track mem_ptr for each firmware entry of TDVF
  i386/tdx: Track RAM entries for TDX VM
  headers: Add definitions from UEFI spec for volumes, resources, etc...
  i386/tdx: Setup the TD HOB list
  i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
  i386/tdx: Finalize TDX VM
  i386/tdx: Enable user exit on KVM_HC_MAP_GPA_RANGE
  i386/tdx: Handle KVM_SYSTEM_EVENT_TDX_FATAL
  i386/tdx: Wire TDX_REPORT_FATAL_ERROR with GuestPanic facility
  kvm: Check KVM_CAP_MAX_VCPUS at vm level
  i386/cpu: introduce x86_confidential_guest_cpu_instance_init()
  i386/tdx: implement tdx_cpu_instance_init()
  i386/cpu: Introduce enable_cpuid_0x1f to force exposing CPUID 0x1f
  i386/tdx: Force exposing CPUID 0x1f
  i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
  i386/tdx: Disable SMM for TDX VMs
  i386/tdx: Disable PIC for TDX VMs
  i386/tdx: Set and check kernel_irqchip mode for TDX
  i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
  i386/apic: Skip kvm_apic_put() for TDX
  cpu: Don't set vcpu_dirty when guest_state_protected
  i386/cgs: Rename *mask_cpuid_features() to *adjust_cpuid_features()
  i386/tdx: Implement adjust_cpuid_features() for TDX
  i386/tdx: Add TDX fixed1 bits to supported CPUIDs
  i386/tdx: Add supported CPUID bits related to TD Attributes
  i386/tdx: Add supported CPUID bits relates to XFAM
  i386/tdx: Add XFD to supported bit of TDX
  i386/tdx: Define supported KVM features for TDX
  i386/cgs: Introduce x86_confidential_guest_check_features()
  i386/tdx: Fetch and validate CPUID of TD guest
  i386/tdx: Don't treat SYSCALL as unavailable
  i386/tdx: Make invtsc default on
  i386/tdx: Validate phys_bits against host value
  docs: Add TDX documentation

 accel/kvm/kvm-all.c                        |   11 +-
 configs/devices/i386-softmmu/default.mak   |    1 +
 docs/system/confidential-guest-support.rst |    1 +
 docs/system/i386/tdx.rst                   |  161 +++
 docs/system/target-i386.rst                |    1 +
 hw/i386/Kconfig                            |    6 +
 hw/i386/kvm/apic.c                         |    5 +
 hw/i386/meson.build                        |    1 +
 hw/i386/pc.c                               |   29 +-
 hw/i386/pc_sysfw.c                         |    7 +
 hw/i386/tdvf-hob.c                         |  130 ++
 hw/i386/tdvf-hob.h                         |   26 +
 hw/i386/tdvf.c                             |  188 +++
 hw/i386/x86-common.c                       |    6 +-
 include/hw/i386/tdvf.h                     |   45 +
 include/standard-headers/uefi/uefi.h       |  187 +++
 include/system/kvm.h                       |    1 +
 linux-headers/asm-x86/kvm.h                |   69 ++
 linux-headers/linux/kvm.h                  |    1 +
 qapi/qom.json                              |   35 +
 qapi/run-state.json                        |   31 +-
 system/runstate.c                          |   65 +
 target/arm/kvm.c                           |    5 +
 target/i386/confidential-guest.h           |   44 +-
 target/i386/cpu.c                          |   69 +-
 target/i386/cpu.h                          |   40 +
 target/i386/host-cpu.c                     |    2 +-
 target/i386/host-cpu.h                     |    1 +
 target/i386/kvm/kvm.c                      |  114 +-
 target/i386/kvm/kvm_i386.h                 |   15 +
 target/i386/kvm/meson.build                |    2 +
 target/i386/kvm/tdx-stub.c                 |   20 +
 target/i386/kvm/tdx.c                      | 1296 ++++++++++++++++++++
 target/i386/kvm/tdx.h                      |   65 +
 target/i386/sev.c                          |   12 +-
 target/loongarch/kvm/kvm.c                 |    4 +
 target/mips/kvm.c                          |    5 +
 target/ppc/kvm.c                           |    5 +
 target/riscv/kvm/kvm-cpu.c                 |    5 +
 target/s390x/kvm/kvm.c                     |    5 +
 40 files changed, 2620 insertions(+), 96 deletions(-)
 create mode 100644 docs/system/i386/tdx.rst
 create mode 100644 hw/i386/tdvf-hob.c
 create mode 100644 hw/i386/tdvf-hob.h
 create mode 100644 hw/i386/tdvf.c
 create mode 100644 include/hw/i386/tdvf.h
 create mode 100644 include/standard-headers/uefi/uefi.h
 create mode 100644 target/i386/kvm/tdx-stub.c
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h


base-commit: 7c949c53e936aa3a658d84ab53bae5cadaa5d59c
-- 
2.43.0


