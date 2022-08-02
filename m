Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B160587830
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbiHBHsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbiHBHsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:48:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DB6313B9
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426478; x=1690962478;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UHg0+kp79zAoHoW4GRjZc81otxnlvqTxkM53jHoEK5U=;
  b=mpJqQ43K0qlZuWvCik63baz2uAkbymzZhRTmB8hU1SLtNP6YaeZZUcrj
   +cp7yeCOJT6MWyBl5YQ3zsxwHy6YEOaZOTBCuNqSyPsgVvQ8zjv4dC+Fy
   b/UU98UDbYS8eKJaoGpYSZ0KrMSOFe4hh4wUWuDCrYZ2yLx5pI6cZWg3p
   EZQKXfQC3FzgjtOnlyzWzHrkl5BsCp+6lXnR9v/qCDiY0KIev1NYKhrXg
   lGyX4dehDlumWF0RiHrix+ELaLp3nbJZBgcrmZwXUm9TCJDYpuq1QuEHt
   u117RRzXyuxgzX9oakllyxMAcXP5AwGyH0H6wJEcW1jCNMcaGtsCiCsBP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="288105446"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="288105446"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:47:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630603766"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:47:51 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [PATCH v1 00/40] TDX QEMU support
Date:   Tue,  2 Aug 2022 15:47:10 +0800
Message-Id: <20220802074750.2581308-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the first version that removes RFC tag since last RFC gots
several acked-by. Hope more people and reviewers can help review it.


This patch series aims to enable TDX support to allow creating and booting a
TD (TDX VM) with QEMU. It needs to work with corresponding KVM patch [1].
TDX related documents can be found in [2].

this series is also available in github:

https://github.com/intel/qemu-tdx/tree/tdx-qemu-upstream-v1

To boot a TDX VM, it requires several changes/additional steps in the flow:

 1. specify the vm type KVM_X86_TDX_VM when creating VM with
    IOCTL(KVM_CREATE_VM);
 2. initialize VM scope configuration before creating any VCPU;
 3. initialize VCPU scope configuration;
 4. initialize virtual firmware (TDVF) in guest private memory before
    vcpu running;

Besides, TDX VM needs to boot with TDVF (TDX virtual firmware) and currently
upstream OVMF can serve as TDVF. This series adds the support of parsing TDVF,
loading TDVF into guest's private memory and preparing TD HOB info for TDVF.

[1] KVM TDX basic feature support v7
https://lore.kernel.org/all/cover.1656366337.git.isaku.yamahata@intel.com/

[2] https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html

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

  future work: To introduce specific CPU model for TDs and enhance +/-features
               for TDs.

- gdb suppport

  gdb support to debug a TD of off-debug mode is future work.

== Patch organization ==
1           Manually fetch Linux UAPI changes for TDX;
2-19,29-30  Basic TDX support that parses vm-type and invoke TDX
            specific IOCTLs
20-28       Load, parse and initialize TDVF for TDX VM;
31-35       Disable unsupported functions for TDX VM;
36-39       Avoid errors due to KVM's requirement on TDX;
40          Add documentation of TDX;

== Change history ==
Changes from RFC v4:
[RFC v4] https://lore.kernel.org/qemu-devel/20220512031803.3315890-1-xiaoyao.li@intel.com/

- Add 3 more patches(9, 10, 11) to improve the tdx_get_supported_cpuid();
- make attributes of object tdx-guest not settable by user;
- improve get_tdx_capabilities() by using a known starting value and
  limiting the loop with a known size;
- clarify why isa.bios needs to be skipped;
- remove the MMIO hob setup since OVMF sets them up itself;

Changes from RFC v3:
[RFC v3] https://lore.kernel.org/qemu-devel/20220317135913.2166202-1-xiaoyao.li@intel.com/

- Load TDVF with -bios interface;
- Adapt to KVM API changes;
	- KVM_TDX_CAPABILITIES changes back to KVM-scope;
	- struct kvm_tdx_init_vm changes;
- Define TDX_SUPPORTED_KVM_FEATURES;
- Drop the patch of introducing property sept-ve-disable since it's not
  public yet;
- some misc cleanups


Changes from RFC v2:
[RFC v2] https://lore.kernel.org/qemu-devel/cover.1625704980.git.isaku.yamahata@intel.com/

- Get vm-type from confidential-guest-support object type;
- Drop machine_init_done_late_notifiers;
- Refactor tdx_ioctl implementation;
- re-use existing pflash interface to load TDVF (i.e., OVMF binaries);
- introduce new date structure to track memory type instead of changing
  e820 table;
- Force smm to off for TDX VM;
- Drop the patches that suppress level-trigger/SMI/INIT/SIPI since KVM
  will ingore them;
- Add documentation;


Changes from RFC v1:
[RFC v1] https://lore.kernel.org/qemu-devel/cover.1613188118.git.isaku.yamahata@intel.com/

- suppress level trigger/SMI/INIT/SIPI related to IOAPIC.
- add VM attribute sha384 to TD measurement.
- guest TSC Hz specification


Isaku Yamahata (4):
  i386/tdvf: Introduce function to parse TDVF metadata
  i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
  hw/i386: add option to forcibly report edge trigger in acpi tables
  i386/tdx: Don't synchronize guest tsc for TDs

Sean Christopherson (2):
  i386/kvm: Move architectural CPUID leaf generation to separate helper
  i386/tdx: Don't get/put guest state for TDX VMs

Xiaoyao Li (34):
  *** HACK *** linux-headers: Update headers to pull in TDX API changes
  i386: Introduce tdx-guest object
  target/i386: Implement mc->kvm_type() to get VM type
  target/i386: Introduce kvm_confidential_guest_init()
  i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
  i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
  i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
  i386/tdx: Adjust the supported CPUID based on TDX restrictions
  i386/tdx: Update tdx_fixed0/1 bits by tdx_caps.cpuid_config[]
  i386/tdx: Integrate tdx_caps->xfam_fixed0/1 into tdx_cpuid_lookup
  i386/tdx: Integrate tdx_caps->attrs_fixed0/1 to tdx_cpuid_lookup
  KVM: Introduce kvm_arch_pre_create_vcpu()
  i386/tdx: Initialize TDX before creating TD vcpus
  i386/tdx: Add property sept-ve-disable for tdx-guest object
  i386/tdx: Wire CPU features up with attributes of TD guest
  i386/tdx: Validate TD attributes
  i386/tdx: Implement user specified tsc frequency
  i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
  i386/tdx: Parse TDVF metadata for TDX VM
  i386/tdx: Skip BIOS shadowing setup
  i386/tdx: Don't initialize pc.rom for TDX VMs
  i386/tdx: Track mem_ptr for each firmware entry of TDVF
  i386/tdx: Track RAM entries for TDX VM
  headers: Add definitions from UEFI spec for volumes, resources, etc...
  i386/tdx: Setup the TD HOB list
  i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
  i386/tdx: Finalize TDX VM
  i386/tdx: Disable SMM for TDX VMs
  i386/tdx: Disable PIC for TDX VMs
  i386/tdx: Don't allow system reset for TDX VMs
  hw/i386: add eoi_intercept_unsupported member to X86MachineState
  i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
  i386/tdx: Skip kvm_put_apicbase() for TDs
  docs: Add TDX documentation

 accel/kvm/kvm-all.c                        |  21 +-
 configs/devices/i386-softmmu/default.mak   |   1 +
 docs/system/confidential-guest-support.rst |   1 +
 docs/system/i386/tdx.rst                   | 105 +++
 docs/system/target-i386.rst                |   1 +
 hw/i386/Kconfig                            |   6 +
 hw/i386/acpi-build.c                       |  99 ++-
 hw/i386/acpi-common.c                      |  50 +-
 hw/i386/meson.build                        |   1 +
 hw/i386/pc.c                               |  21 +-
 hw/i386/pc_sysfw.c                         |   7 +
 hw/i386/tdvf-hob.c                         | 146 ++++
 hw/i386/tdvf-hob.h                         |  24 +
 hw/i386/tdvf.c                             | 198 +++++
 hw/i386/x86.c                              |  35 +-
 include/hw/i386/tdvf.h                     |  58 ++
 include/hw/i386/x86.h                      |   1 +
 include/standard-headers/uefi/uefi.h       | 198 +++++
 include/sysemu/kvm.h                       |   1 +
 linux-headers/asm-x86/kvm.h                |  95 +++
 linux-headers/linux/kvm.h                  |   2 +
 qapi/qom.json                              |  14 +
 target/i386/cpu-internal.h                 |   9 +
 target/i386/cpu.c                          |  12 -
 target/i386/cpu.h                          |  21 +
 target/i386/kvm/kvm.c                      | 363 +++++----
 target/i386/kvm/kvm_i386.h                 |   6 +
 target/i386/kvm/meson.build                |   2 +
 target/i386/kvm/tdx-stub.c                 |  19 +
 target/i386/kvm/tdx.c                      | 838 +++++++++++++++++++++
 target/i386/kvm/tdx.h                      |  55 ++
 target/i386/sev.c                          |   1 -
 target/i386/sev.h                          |   2 +
 33 files changed, 2193 insertions(+), 220 deletions(-)
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
2.27.0

