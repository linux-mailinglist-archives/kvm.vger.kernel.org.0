Return-Path: <kvm+bounces-10355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E22086C0BF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:37:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 320D21C20882
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA193C697;
	Thu, 29 Feb 2024 06:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOXX5w2k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1875D2E84E
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188657; cv=none; b=No//lGmmgwB2cZEv2xRWGR6vlpZKoqtdqiU9gU+Qtv7+xzOjsUwJQtuBi6uALXu3ACW4vYNbhtaD222QbynHbp3kWKc6CJKrzaGkfLPmFQx2Renzl2cn1IEiQ9rAiwJx0FmaIMPAujmE8p66IjzbzoAOnh5MgD0h/W/FXwaQfW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188657; c=relaxed/simple;
	bh=ikAJGpbf5wNCdn54EKoZXY6PoNsvhEt8WBXwv6zzn7o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=L17+rsUfmMssjdOhWeHQoDF1nOJ/xA8mxq/tvJyOd5SMrXmIfCv6qrkGjRvEh4s5oVn/4rELtVdR9KWW8/GIHrWFj3dP8wYwJOIV/zpkHfRa/pE7xuTPrsSaiYg9mIgO5DZ/5xkUDOYtu2/qejJhS3Tx7bRZozfvDrYNQ8YEBZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOXX5w2k; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188655; x=1740724655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ikAJGpbf5wNCdn54EKoZXY6PoNsvhEt8WBXwv6zzn7o=;
  b=kOXX5w2kSmRVBePhxw5BlCFvRrn3O8z7O9tZS3wvznxLfpE+SRIHZgzA
   OHZDbeMCrFmCJGreTjmGI/YPksP6mA5Rugldn9EFvKYXKf7FRhh4xIT6D
   gjwnaHdt/Ps91fmFVy8QEFGXtKlYoT3sBIOoY/ha5smeksCWq2UOnq8tR
   hu+offtu3M44vl5091vDrDoXnu1oodLmSO1wnnkB9ofFWve1uuim4LM3r
   7LKLWWAEJPulbIYUbudY0xMT66Ak1v6itsuoF9DsxsyYTKu8V40tR55B+
   /d+hbhE58bSMTspaAQW88y4ErbsNk39vJ3zKCCAC93+wfkgMoVE37lVWB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802430"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802430"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:37:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8074465"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:37:28 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 00/65] QEMU Guest memfd + QEMU TDX support
Date: Thu, 29 Feb 2024 01:36:21 -0500
Message-Id: <20240229063726.610065-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This v5 series matches with latest KVM v19 series:
https://lore.kernel.org/all/cover.1708933498.git.isaku.yamahata@intel.com/

This series is also available in github:
https://github.com/intel/qemu-tdx/tree/tdx-qemu-upstream-v5

It's based on one series that refacotrs cgs specific KVM functions:
https://lore.kernel.org/qemu-devel/20240229060038.606591-1-xiaoyao.li@intel.com/

===
Patches 1 - 10 add support of guest memfd into QEMU, associating it with
RAMBlock. For the VM types that require private memory (see
tdx_kvm_init() in patch 14), QEMU will automatically create guest memfd
for each RAM backend.

Follwoing patches 11 to 65, enables TDX support to allow creating and
booting a TD (TDX VM) with QEMU.

== Limitation and future work ==
- Readonly memslot

  TDX only support readonly (write protection) memslot for shared memory, but
  not for private memory. For simplicity, just mark readonly memslot not
  supported entirely for TDX.

- CPU model

  We cannot create a TD with arbitrary CPU model like what for non-TDX VMs,
  because only a subset of features can be configured for TD.

  - It's recommended to use '-cpu host' to create TD;
  - '+feature/-feature' might not work as expected;

  future work: To introduce specific CPU model for TDs and enhance ±features
               for TDs.

- gdb suppport

  gdb support to debug a TD of off-debug mode is future work.

===
Changes in v5:
guest memfd part:
- remove RAM_DEFAULT_PRIVATE that RAM_GUEST_MEMFD can serve its purpose.
  just make all the RAM that has guest memfd backend private by default;
- collect Reviewed-by from David;

TDX part:
- switch to use KVM_MEMORY_MAPPING to initialize TDVF into its private
  memory; (required by KVM v19 series);
- Add patch (28) to disable PMU for TD guest;
- various QAPI doc comment refine; (Thanks to Markus!)
- update Documentation to add section TD atttestation;

v4:
https://lore.kernel.org/qemu-devel/20240125032328.2522472-1-xiaoyao.li@intel.com/

Main changes in v4:
guest memfd part:
 - Drop the patch that supports KVM_GUEST_MEMFD_ALLOW_HUGEPAGE flag
   because KVM side leaves it as future work;
 - send patch "physmem: replace function name with __func__ in
   ram_block_discard_range()" separately;
 - drop ram_block_convert_range() and open code it instead.
 - move the supported attribute bit check into
   kvm_set_memory_attributes() (per request from Wei)
 - Clarify more for the desgin consideration in the commit messages

TDX part:
 - Re-implement get-quote support by introduing TdxQuoteGenerator object
   and make the socket communication non-blocking; (per Daniel)
 - Various code and doc refinement;

v3:
https://lore.kernel.org/qemu-devel/20231115071519.2864957-1-xiaoyao.li@intel.com/

Main changes in v3:
gmem memfd part: 
 - Since KVM side renamed gmem to guest_memfd in the uapi, this version
   renames it accordingly;
 - Drop the 'private' property of memory backend. (see comment[1])
   Now QEMU decides whether need to create guest memfd based on specific
   vm type (or specific VM implementation, please see patch *X* and *Y*);
 - Drop sw_protected_vm implementation;

TDX part:
 - improve the error report in various patches by utilizing 'errp';
 - drop the vm-type interface;
 - rename __tdx_ioctl() to tdx_ioctl_internal();
 - refine the description of 'sept-ve-disable' in qom.json;
 - use base64 for mrconfigif/mrowner/mrownerconfig instread of hex-string;
 - use type SocketAddress for quote-generation-service;

[1] https://lore.kernel.org/qemu-devel/a1e34896-c46d-c87c-0fda-971bbf3dcfbd@redhat.com/

Chao Peng (3):
  kvm: Enable KVM_SET_USER_MEMORY_REGION2 for memslot
  kvm: handle KVM_EXIT_MEMORY_FAULT
  i386/tdx: load TDVF for TD guest

Isaku Yamahata (14):
  trace/kvm: Add trace for page convertion between shared and private
  i386/tdx: Make sept_ve_disable set by default
  i386/tdx: Support user configurable mrconfigid/mrowner/mrownerconfig
  kvm/tdx: Don't complain when converting vMMIO region to shared
  kvm/tdx: Ignore memory conversion to shared of unassigned region
  i386/tdvf: Introduce function to parse TDVF metadata
  i386/tdx: Populate TDVF private memory via KVM_MEMORY_MAPPING
  i386/tdx: handle TDG.VP.VMCALL<SetupEventNotifyInterrupt>
  i386/tdx: handle TDG.VP.VMCALL<GetQuote>
  i386/tdx: handle TDG.VP.VMCALL<MapGPA> hypercall
  pci-host/q35: Move PAM initialization above SMRAM initialization
  q35: Introduce smm_ranges property for q35-pci-host
  hw/i386: add option to forcibly report edge trigger in acpi tables
  i386/tdx: Don't synchronize guest tsc for TDs

Sean Christopherson (2):
  i386/kvm: Move architectural CPUID leaf generation to separate helper
  i386/tdx: Don't get/put guest state for TDX VMs

Xiaoyao Li (46):
  linux-headers: Update to Linux v6.8-rc5
  RAMBlock: Add support of KVM private guest memfd
  HostMem: Add mechanism to opt in kvm guest memfd via MachineState
  trace/kvm: Split address space and slot id in
    trace_kvm_set_user_memory()
  kvm: Introduce support for memory_attributes
  physmem: Introduce ram_block_discard_guest_memfd_range()
  kvm/memory: Make memory type private by default if it has guest memfd
    backend
  *** HACK *** linux-headers: Update headers to pull in TDX API changes
  i386: Introduce tdx-guest object
  target/i386: Implement mc->kvm_type() to get VM type
  i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
  i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
  i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
  i386/tdx: Adjust the supported CPUID based on TDX restrictions
  i386/tdx: Make Intel-PT unsupported for TD guest
  i386/tdx: Update tdx_cpuid_lookup[].tdx_fixed0/1 by
    tdx_caps.cpuid_config[]
  i386/tdx: Integrate tdx_caps->xfam_fixed0/1 into tdx_cpuid_lookup
  i386/tdx: Integrate tdx_caps->attrs_fixed0/1 to tdx_cpuid_lookup
  kvm: Introduce kvm_arch_pre_create_vcpu()
  i386/tdx: Initialize TDX before creating TD vcpus
  i386/tdx: Add property sept-ve-disable for tdx-guest object
  i386/tdx: Wire CPU features up with attributes of TD guest
  i386/tdx: Disable pmu for TD guest
  i386/tdx: Validate TD attributes
  i386/tdx: Implement user specified tsc frequency
  i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
  memory: Introduce memory_region_init_ram_guest_memfd()
  i386/tdx: Parse TDVF metadata for TDX VM
  i386/tdx: Skip BIOS shadowing setup
  i386/tdx: Don't initialize pc.rom for TDX VMs
  i386/tdx: Track mem_ptr for each firmware entry of TDVF
  i386/tdx: Track RAM entries for TDX VM
  headers: Add definitions from UEFI spec for volumes, resources, etc...
  i386/tdx: Setup the TD HOB list
  i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
  i386/tdx: Finalize TDX VM
  i386/tdx: Handle TDG.VP.VMCALL<REPORT_FATAL_ERROR>
  i386/tdx: Wire TDX_REPORT_FATAL_ERROR with GuestPanic facility
  i386/tdx: Disable SMM for TDX VMs
  i386/tdx: Disable PIC for TDX VMs
  i386/tdx: Don't allow system reset for TDX VMs
  i386/tdx: LMCE is not supported for TDX
  hw/i386: add eoi_intercept_unsupported member to X86MachineState
  i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
  i386/tdx: Skip kvm_put_apicbase() for TDs
  docs: Add TDX documentation

 accel/kvm/kvm-all.c                           |  278 +++-
 accel/kvm/trace-events                        |    3 +-
 accel/stubs/kvm-stub.c                        |    5 +
 backends/hostmem-file.c                       |    1 +
 backends/hostmem-memfd.c                      |    1 +
 backends/hostmem-ram.c                        |    1 +
 backends/hostmem.c                            |    1 +
 configs/devices/i386-softmmu/default.mak      |    1 +
 docs/system/confidential-guest-support.rst    |    1 +
 docs/system/i386/tdx.rst                      |  143 ++
 docs/system/target-i386.rst                   |    1 +
 hw/core/machine.c                             |    5 +
 hw/i386/Kconfig                               |    6 +
 hw/i386/acpi-build.c                          |   99 +-
 hw/i386/acpi-common.c                         |   45 +-
 hw/i386/meson.build                           |    1 +
 hw/i386/pc.c                                  |   21 +-
 hw/i386/pc_q35.c                              |    2 +
 hw/i386/pc_sysfw.c                            |    7 +
 hw/i386/tdvf-hob.c                            |  147 ++
 hw/i386/tdvf-hob.h                            |   24 +
 hw/i386/tdvf.c                                |  200 +++
 hw/i386/x86.c                                 |   51 +-
 hw/pci-host/q35.c                             |   61 +-
 include/exec/cpu-common.h                     |    2 +
 include/exec/memory.h                         |   26 +-
 include/exec/ram_addr.h                       |    2 +-
 include/exec/ramblock.h                       |    1 +
 include/hw/boards.h                           |    2 +
 include/hw/i386/pc.h                          |    1 +
 include/hw/i386/tdvf.h                        |   58 +
 include/hw/i386/x86.h                         |    2 +
 include/hw/pci-host/q35.h                     |    1 +
 include/standard-headers/drm/drm_fourcc.h     |   10 +-
 include/standard-headers/linux/ethtool.h      |   41 +-
 .../standard-headers/linux/virtio_config.h    |    8 +-
 include/standard-headers/linux/virtio_pci.h   |   68 +
 include/standard-headers/linux/virtio_pmem.h  |    7 +
 include/standard-headers/uefi/uefi.h          |  198 +++
 include/sysemu/hostmem.h                      |    1 +
 include/sysemu/kvm.h                          |    8 +
 include/sysemu/kvm_int.h                      |    2 +
 linux-headers/asm-generic/unistd.h            |   15 +-
 linux-headers/asm-mips/mman.h                 |    2 +-
 linux-headers/asm-mips/unistd_n32.h           |    5 +
 linux-headers/asm-mips/unistd_n64.h           |    5 +
 linux-headers/asm-mips/unistd_o32.h           |    5 +
 linux-headers/asm-powerpc/unistd_32.h         |    5 +
 linux-headers/asm-powerpc/unistd_64.h         |    5 +
 linux-headers/asm-riscv/kvm.h                 |   40 +
 linux-headers/asm-s390/unistd_32.h            |    5 +
 linux-headers/asm-s390/unistd_64.h            |    5 +
 linux-headers/asm-x86/kvm.h                   |   89 ++
 linux-headers/asm-x86/unistd_32.h             |    5 +
 linux-headers/asm-x86/unistd_64.h             |    5 +
 linux-headers/asm-x86/unistd_x32.h            |    5 +
 linux-headers/linux/iommufd.h                 |   79 +
 linux-headers/linux/kvm.h                     |  240 +--
 linux-headers/linux/userfaultfd.h             |   29 +-
 linux-headers/linux/vfio.h                    |    1 +
 qapi/qom.json                                 |   38 +
 qapi/run-state.json                           |   31 +-
 system/memory.c                               |   30 +
 system/physmem.c                              |   47 +-
 system/runstate.c                             |   58 +
 target/i386/cpu-internal.h                    |    9 +
 target/i386/cpu.c                             |   12 -
 target/i386/cpu.h                             |   21 +
 target/i386/kvm/kvm-cpu.c                     |    5 +
 target/i386/kvm/kvm.c                         |  596 ++++---
 target/i386/kvm/kvm_i386.h                    |    6 +
 target/i386/kvm/meson.build                   |    2 +
 target/i386/kvm/tdx-quote-generator.c         |  170 ++
 target/i386/kvm/tdx-quote-generator.h         |   95 ++
 target/i386/kvm/tdx-stub.c                    |   18 +
 target/i386/kvm/tdx.c                         | 1371 +++++++++++++++++
 target/i386/kvm/tdx.h                         |   81 +
 77 files changed, 4180 insertions(+), 498 deletions(-)
 create mode 100644 docs/system/i386/tdx.rst
 create mode 100644 hw/i386/tdvf-hob.c
 create mode 100644 hw/i386/tdvf-hob.h
 create mode 100644 hw/i386/tdvf.c
 create mode 100644 include/hw/i386/tdvf.h
 create mode 100644 include/standard-headers/uefi/uefi.h
 create mode 100644 target/i386/kvm/tdx-quote-generator.c
 create mode 100644 target/i386/kvm/tdx-quote-generator.h
 create mode 100644 target/i386/kvm/tdx-stub.c
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h

-- 
2.34.1


