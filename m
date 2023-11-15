Return-Path: <kvm+bounces-1727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 527B57EBD6B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD7701F2616B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977DE4427;
	Wed, 15 Nov 2023 07:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lWgZXUMY"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4A13D6C
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:15:33 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C2BE6
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032531; x=1731568531;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7JwhGredXHnD1RqBKzopE/TrkoHj5/xfg3Y85ow5Vzg=;
  b=lWgZXUMYobKvijElC3R6F1hSLBBY2TpWExaeu6YnN7m28bMwnA3luwfY
   T5LyTj4/602yXRstFuP+0y2TymgEq8pu3ax2kAxtmzbkI+YUl8enk9k9F
   EprAwkIwJEhFwzM3LpHx257Onouapkz6idg1o2jIFMvR+710DTYifJa4R
   8QB1WwGBXC9BitULZ40t03shU8sQr29boQbMkZCDhGpCyomMLP3WTY9C8
   Z2tKWyWYTqJ6KunfMYQWwJgKQVZQmfBxWyjXZLaKBOhizeL8vooyTPx0L
   pLxbqABtoHOb+039JO5FhAro/TYKbpbML32A4F8kmqO6eDN9I4wuCm/gc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390621995"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390621995"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:15:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714796701"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714796701"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:15:23 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 00/70] QEMU Guest memfd + QEMU TDX support
Date: Wed, 15 Nov 2023 02:14:09 -0500
Message-Id: <20231115071519.2864957-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This v3 series combines previous QEMU gmem series[1] and TDX QEMU series[2].
Because TDX is going to be the first user of gmem (guest memfd) in QEMU,
bombining them together can provide us a full picture of how they work.

KVM provides guest memfd, which cannot be mapped, read, or written by
userspace. It's designed to serve as private memory for confidential
VMs, like Intel TDX and AMD sev-snp.

Patches 1 - 11 add support of guest memfd into QEMU, associating it with
RAMBlock. For the VM types that require private memory (see
tdx_kvm_init() in patch 17), QEMU will automatically create guest memfd
for each RAM.

Follwoing patches 12 to 70, enables TDX support to allow creating and
booting a TD (TDX VM) with QEMU.

The whole series needs to work with KVM guest memfd series[3] and KVM v17
series[4].

This series is also available in github:
https://github.com/intel/qemu-tdx/tree/tdx-qemu-upstream-v3

It's based on several patches that haven't get merged:
https://lore.kernel.org/qemu-devel/20231007065819.27498-1-xiaoyao.li@intel.com/
https://lore.kernel.org/qemu-devel/20230613131929.720453-1-xiaoyao.li@intel.com/
https://lore.kernel.org/all/20220310122215.804233-1-xiaoyao.li@intel.com/

Luckily, the absence of them doesn't block applying this series nor
affecting the functionality.

Note, I leave new qapi introduced in this series with 'since 8.2'
because I don't know next version will be 8.3 or 9.0.


[1] https://lore.kernel.org/qemu-devel/20230914035117.3285885-1-xiaoyao.li@intel.com/
[2] https://lore.kernel.org/qemu-devel/20230818095041.1973309-1-xiaoyao.li@intel.com/
[3] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.com/
[4] https://lore.kernel.org/all/cover.1699368322.git.isaku.yamahata@intel.com/ 

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
Main changes in v3:
gmem memfd part: 
 - Since KVM side renamed gmem to guest_memfd in the uapi, this version
   renames it accordingly;
 - Drop the 'private' property of memory backend. (see comment[5])
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

[5] https://lore.kernel.org/qemu-devel/a1e34896-c46d-c87c-0fda-971bbf3dcfbd@redhat.com/

Chao Peng (3):
  kvm: Enable KVM_SET_USER_MEMORY_REGION2 for memslot
  kvm: handle KVM_EXIT_MEMORY_FAULT
  i386/tdx: register TDVF as private memory

Chenyi Qiang (1):
  i386/tdx: setup a timer for the qio channel

Isaku Yamahata (15):
  trace/kvm: Add trace for page convertion between shared and private
  i386/tdx: Make sept_ve_disable set by default
  i386/tdx: Allows mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
  kvm/tdx: Don't complain when converting vMMIO region to shared
  kvm/tdx: Ignore memory conversion to shared of unassigned region
  i386/tdvf: Introduce function to parse TDVF metadata
  i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
  i386/tdx: handle TDG.VP.VMCALL<SetupEventNotifyInterrupt>
  i386/tdx: handle TDG.VP.VMCALL<GetQuote>
  i386/tdx: handle TDG.VP.VMCALL<MapGPA> hypercall
  i386/tdx: Limit the range size for MapGPA
  pci-host/q35: Move PAM initialization above SMRAM initialization
  q35: Introduce smm_ranges property for q35-pci-host
  hw/i386: add option to forcibly report edge trigger in acpi tables
  i386/tdx: Don't synchronize guest tsc for TDs

Sean Christopherson (2):
  i386/kvm: Move architectural CPUID leaf generation to separate helper
  i386/tdx: Don't get/put guest state for TDX VMs

Xiaoyao Li (49):
  *** HACK *** linux-headers: Update headers to pull in gmem APIs
  RAMBlock: Add support of KVM private guest memfd
  RAMBlock/guest_memfd: Enable KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
  HostMem: Add mechanism to opt in kvm guest memfd via MachineState
  kvm: Introduce support for memory_attributes
  physmem: Relax the alignment check of host_startaddr in
    ram_block_discard_range()
  physmem: replace function name with __func__ in
    ram_block_discard_range()
  physmem: Introduce ram_block_convert_range() for page conversion
  *** HACK *** linux-headers: Update headers to pull in TDX API changes
  i386: Introduce tdx-guest object
  target/i386: Implement mc->kvm_type() to get VM type
  target/i386: Parse TDX vm type
  target/i386: Introduce kvm_confidential_guest_init()
  i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
  i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
  i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
  i386/tdx: Adjust the supported CPUID based on TDX restrictions
  i386/tdx: Update tdx_cpuid_lookup[].tdx_fixed0/1 by
    tdx_caps.cpuid_config[]
  i386/tdx: Integrate tdx_caps->xfam_fixed0/1 into tdx_cpuid_lookup
  i386/tdx: Integrate tdx_caps->attrs_fixed0/1 to tdx_cpuid_lookup
  kvm: Introduce kvm_arch_pre_create_vcpu()
  i386/tdx: Initialize TDX before creating TD vcpus
  i386/tdx: Add property sept-ve-disable for tdx-guest object
  i386/tdx: Wire CPU features up with attributes of TD guest
  i386/tdx: Validate TD attributes
  i386/tdx: Implement user specified tsc frequency
  i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
  kvm/memory: Introduce the infrastructure to set the default
    shared/private value
  i386/tdx: Make memory type private by default
  i386/tdx: Parse TDVF metadata for TDX VM
  i386/tdx: Skip BIOS shadowing setup
  i386/tdx: Don't initialize pc.rom for TDX VMs
  i386/tdx: Track mem_ptr for each firmware entry of TDVF
  i386/tdx: Track RAM entries for TDX VM
  headers: Add definitions from UEFI spec for volumes, resources, etc...
  i386/tdx: Setup the TD HOB list
  memory: Introduce memory_region_init_ram_guest_memfd()
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

 accel/kvm/kvm-all.c                        |  255 +++-
 accel/kvm/trace-events                     |    4 +-
 backends/hostmem-file.c                    |    1 +
 backends/hostmem-memfd.c                   |    1 +
 backends/hostmem-ram.c                     |    1 +
 backends/hostmem.c                         |    1 +
 configs/devices/i386-softmmu/default.mak   |    1 +
 docs/system/confidential-guest-support.rst |    1 +
 docs/system/i386/tdx.rst                   |  113 ++
 docs/system/target-i386.rst                |    1 +
 hw/core/machine.c                          |    5 +
 hw/i386/Kconfig                            |    6 +
 hw/i386/acpi-build.c                       |   99 +-
 hw/i386/acpi-common.c                      |   50 +-
 hw/i386/meson.build                        |    1 +
 hw/i386/pc.c                               |   21 +-
 hw/i386/pc_q35.c                           |    2 +
 hw/i386/pc_sysfw.c                         |    7 +
 hw/i386/tdvf-hob.c                         |  147 ++
 hw/i386/tdvf-hob.h                         |   24 +
 hw/i386/tdvf.c                             |  200 +++
 hw/i386/x86.c                              |   51 +-
 hw/pci-host/q35.c                          |   61 +-
 include/exec/cpu-common.h                  |    2 +
 include/exec/memory.h                      |   26 +
 include/exec/ramblock.h                    |    1 +
 include/hw/boards.h                        |    2 +
 include/hw/i386/pc.h                       |    1 +
 include/hw/i386/tdvf.h                     |   58 +
 include/hw/i386/x86.h                      |    2 +
 include/hw/pci-host/q35.h                  |    1 +
 include/standard-headers/uefi/uefi.h       |  198 +++
 include/sysemu/hostmem.h                   |    1 +
 include/sysemu/kvm.h                       |    8 +
 include/sysemu/kvm_int.h                   |    2 +
 linux-headers/asm-x86/kvm.h                |   94 ++
 linux-headers/linux/kvm.h                  |  140 ++
 qapi/qom.json                              |   29 +
 qapi/run-state.json                        |   27 +-
 system/memory.c                            |   45 +
 system/physmem.c                           |  151 +-
 system/runstate.c                          |   54 +
 target/i386/cpu-internal.h                 |    9 +
 target/i386/cpu.c                          |   12 -
 target/i386/cpu.h                          |   21 +
 target/i386/kvm/kvm-cpu.c                  |    5 +
 target/i386/kvm/kvm.c                      |  608 ++++----
 target/i386/kvm/kvm_i386.h                 |    6 +
 target/i386/kvm/meson.build                |    2 +
 target/i386/kvm/tdx-stub.c                 |   23 +
 target/i386/kvm/tdx.c                      | 1612 ++++++++++++++++++++
 target/i386/kvm/tdx.h                      |   72 +
 target/i386/sev.c                          |    1 -
 target/i386/sev.h                          |    2 +
 54 files changed, 3861 insertions(+), 407 deletions(-)
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


