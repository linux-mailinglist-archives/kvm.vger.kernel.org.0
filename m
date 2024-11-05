Return-Path: <kvm+bounces-30634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F579BC576
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3E121C21548
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246761DC074;
	Tue,  5 Nov 2024 06:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HbvkdkVr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C6C1F16B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788584; cv=none; b=eMkRwG7HYRJsjS6Vpw/jvNSU9/tNMx3ZydbOpBCPhT03cbfMz4jMh9ATUUkAwkjQEiO1ynqx1bwrVQSj+W+f+xLMMOHZyqO5TumBIGW7V78OSSJJGtGy+LRe9QqEdlPrA5QS9SA1q+uJS9vAcjzoV9+UXppvKNoX+OLxHC5bml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788584; c=relaxed/simple;
	bh=uwPme6DhVbJbciZbENF5tory5ziwKMfNkooa8T+wyes=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NKryq7K112cQKDnXH63kNFOHqLczgbzI1BvfQll8gP2sZdXMC076iuAuPdu+ZHQVoWB2hGdF/AG1hDWXE0e/cvEWmOmgsKyAJGsfxvKQ4j4nhODLUbtWYC5S2XNhIr4MGD3/JeVVV2KSwyCOHuMFoLlkO9jwvrH8kw3a4cPGgQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HbvkdkVr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788582; x=1762324582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uwPme6DhVbJbciZbENF5tory5ziwKMfNkooa8T+wyes=;
  b=HbvkdkVrrBKYfa+Gs5JquoN1CuUC7SPOes2cKjqQlpAFsa9/rcylEiT2
   3u7gUiS7aldSnHy83Ya9WqGfWtHrRqG6ULDxWpDb5kNogO/o/vCpbM/0z
   6XCPCclk9nLssXU9GpjW6DdduqkqDfbdCi+L9CCzWwAPC7yCYIHmi1WMp
   FlVV8smtgTCjsryCfWN10VbT/K/ba0FxHde8yWx9EPiufQVBgy8JMe2Ob
   xXOhdwe7/y1M7C4vNd6o6RWTEnTi70mJQ42uEutJk25/g59gYqNM6ZGF7
   M76efP1bYjs8iLO+1fK/+lBGsUPIy1/tTT6BktewxJLY+9qOQhJC296VF
   A==;
X-CSE-ConnectionGUID: 9rt7qpJKS0Wa9N9Ojpc+hQ==
X-CSE-MsgGUID: kyqkvWChR0iaoLNJDqIfZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689204"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689204"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:36:22 -0800
X-CSE-ConnectionGUID: Uz/eKMZwS4+quOehhpn1TQ==
X-CSE-MsgGUID: pq/qFX1JQ0KCTysNWX4HUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988532"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:36:17 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 00/60] QEMU TDX support
Date: Tue,  5 Nov 2024 01:23:08 -0500
Message-Id: <20241105062408.3533704-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v6 series of TDX QEMU enabling. The matching KVM is
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-10-30

This series is also available in github:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v6.1

Note, to boot a TD, it requires 1)TDX module 1.5.06.00.0744[0], or later.
This is due to removal of the workarounds for the lack of NO_RBP_MOD in
KVM. 2) OVMF with commit 3a3b12cbdae2 "UefiCpuPkg/MtrrLib:
MtrrLibIsMtrrSupported always return FALSE in TD-Guest" because KVM
drops the MTRR related MSR emulation.

Patches 52 to 59 are new added in this version. They are aimed to check
and guarantee the CPU model determined by user input can be satisfied.

=== future work ===
- CPU model

  It now only supports booting TD VM with "-cpu host". It is the only
  case that not supposed to hit any warning/error.

  When using named CPU model, even the same model as host, it likely
  hits warning like some feature not supported or some feature enforced
  on. It's a future work to decide if needs to introduce TDX specific
  named CPU models.

- Attestation support

  Attestation support is dropped in this version becuase KVM side remove
  the support of the related user exit. Atttestation support will be
  submitted separately when KVM regain the support.

- gdb support

  gdb support to debug a TD in off-debug mode is left as future work.

[0] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

===
Changes in v6:
 - Remove the guest memfd patches and some i386 patches because they are
   already merged;
 - Drop the attestation support since current KVM doesn't support it;
 - Update to use the latest TDX API of KVM;
 - Change to use adjust_cpuid_features() to adjust the supported CPUID
   features for TDX;
 - Introduce x86_confidential_guest_check_features() to do additinoal
   feature check;

v5:
https://lore.kernel.org/qemu-devel/20240229063726.610065-1-xiaoyao.li@intel.com/

Chao Peng (1):
  i386/tdx: load TDVF for TD guest

Isaku Yamahata (6):
  i386/tdx: Make sept_ve_disable set by default
  i386/tdx: Support user configurable mrconfigid/mrowner/mrownerconfig
  i386/tdvf: Introduce function to parse TDVF metadata
  i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
  hw/i386: add option to forcibly report edge trigger in acpi tables
  i386/tdx: Don't synchronize guest tsc for TDs

Sean Christopherson (1):
  i386/tdx: Don't get/put guest state for TDX VMs

Xiaoyao Li (52):
  *** HACK *** linux-headers: Update headers to pull in TDX API changes
  i386: Introduce tdx-guest object
  i386/tdx: Implement tdx_kvm_type() for TDX
  i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
  i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
  i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
  kvm: Introduce kvm_arch_pre_create_vcpu()
  i386/kvm: Export cpuid_entry_get_reg() and cpuid_find_entry()
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
  i386/cpu: introduce x86_confidential_guest_cpu_instance_init()
  i386/tdx: implement tdx_cpu_instance_init()
  i386/cpu: introduce x86_confidenetial_guest_cpu_realizefn()
  i386/tdx: implement tdx_cpu_realizefn()
  i386/cpu: Introduce enable_cpuid_0x1f to force exposing CPUID 0x1f
  i386/tdx: Force exposing CPUID 0x1f
  i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
  i386/tdx: Disable SMM for TDX VMs
  i386/tdx: Disable PIC for TDX VMs
  hw/i386: add eoi_intercept_unsupported member to X86MachineState
  i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
  i386/tdx: Skip kvm_put_apicbase() for TDs
  i386/cgs: Rename *mask_cpuid_features() to *adjust_cpuid_features()
  i386/tdx: Implement adjust_cpuid_features() for TDX
  i386/tdx: Apply TDX fixed0 and fixed1 information to supported CPUIDs
  i386/tdx: Mask off CPUID bits by unsupported TD Attributes
  i386/cpu: Move CPUID_XSTATE_XSS_MASK to header file and introduce
    CPUID_XSTATE_MASK
  i386/tdx: Mask off CPUID bits by unsupported XFAM
  i386/cpu: Expose mark_unavailable_features() for TDX
  i386/cpu: introduce mark_forced_on_features()
  i386/cgs: Introduce x86_confidential_guest_check_features()
  i386/tdx: Fetch and validate CPUID of TD guest
  i386/tdx: Don't treat SYSCALL as unavailable
  i386/tdx: Make invtsc default on
  cpu: Introduce qemu_early_init_vcpu()
  i386/cpu: Set up CPUID_HT in x86_cpu_realizefn() instead of
    cpu_x86_cpuid()
  docs: Add TDX documentation

 accel/kvm/kvm-all.c                        |   18 +
 accel/tcg/user-exec-stub.c                 |    4 +
 configs/devices/i386-softmmu/default.mak   |    1 +
 docs/system/confidential-guest-support.rst |    1 +
 docs/system/i386/tdx.rst                   |  155 +++
 docs/system/target-i386.rst                |    1 +
 hw/i386/Kconfig                            |    6 +
 hw/i386/acpi-build.c                       |   99 +-
 hw/i386/acpi-common.c                      |   45 +-
 hw/i386/meson.build                        |    1 +
 hw/i386/pc.c                               |   29 +-
 hw/i386/pc_sysfw.c                         |    7 +
 hw/i386/tdvf-hob.c                         |  147 +++
 hw/i386/tdvf-hob.h                         |   24 +
 hw/i386/tdvf.c                             |  201 ++++
 hw/i386/x86-common.c                       |    6 +-
 hw/i386/x86.c                              |    1 +
 include/hw/core/cpu.h                      |    8 +
 include/hw/i386/tdvf.h                     |   58 +
 include/hw/i386/x86.h                      |    1 +
 include/standard-headers/uefi/uefi.h       |  198 ++++
 include/sysemu/kvm.h                       |    1 +
 linux-headers/asm-x86/kvm.h                |   70 ++
 linux-headers/linux/kvm.h                  |    1 +
 qapi/qom.json                              |   35 +
 qapi/run-state.json                        |   31 +-
 system/cpus.c                              |    8 +
 system/runstate.c                          |   58 +
 target/i386/confidential-guest.h           |   56 +-
 target/i386/cpu.c                          |   74 +-
 target/i386/cpu.h                          |   27 +
 target/i386/host-cpu.c                     |    2 +-
 target/i386/host-cpu.h                     |    1 +
 target/i386/kvm/kvm.c                      |  130 ++-
 target/i386/kvm/kvm_i386.h                 |   15 +
 target/i386/kvm/meson.build                |    2 +
 target/i386/kvm/tdx-stub.c                 |   18 +
 target/i386/kvm/tdx.c                      | 1113 ++++++++++++++++++++
 target/i386/kvm/tdx.h                      |   63 ++
 target/i386/sev.c                          |    9 +-
 40 files changed, 2596 insertions(+), 129 deletions(-)
 create mode 100644 docs/system/i386/tdx.rst
 create mode 100644 hw/i386/tdvf-hob.c
 create mode 100644 hw/i386/tdvf-hob.h
 create mode 100644 hw/i386/tdvf.c
 create mode 100644 include/hw/i386/tdvf.h
 create mode 100644 include/standard-headers/uefi/uefi.h
 create mode 100644 target/i386/kvm/tdx-stub.c
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h

-- 
2.34.1


