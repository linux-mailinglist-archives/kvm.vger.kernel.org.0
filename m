Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB3D31C552
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBPCPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:15:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:40350 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhBPCPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:15:36 -0500
IronPort-SDR: 7LVho8WCiGPzBmUWNyhY+tRCzqY5XNHlLtlmR7mcHHEEkifp6V5tDbpahJbl0qYwSOpaaa1zXV
 exCadvwdTbtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="179288239"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="179288239"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:50 -0800
IronPort-SDR: opA2wsoGwXlexia1iVVZwIznZPh9F6pNgF1W/EYzonAX8H6+m8Nu1OZiufhfN1SNrqI6MjFz1L
 UivLAWaCPPSQ==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="399305134"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:49 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH 00/23] [RFC PATCH 00/24] TDX support
Date:   Mon, 15 Feb 2021 18:12:56 -0800
Message-Id: <cover.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is to enable TDX support.
This needs corresponding KVM patch for TDX[] and more patches are needed
that addresses generic corner cases, e.g. ACPI related stuff, are needed.
So This patch series is RFC.
More emulated devices and their behavior needs to be adjusted as some
operations are disallowed.

Patch series is organized as follows
 1- 5 code refactoring and simple hooks that will be used later
 6- 9 introduce kvm type and tdx type. disallow non-usable operations
10-15 wire up necessary TDX kvm ioctl to initialize TD guest
16-21 load TDVF and setup necessary info for TDVF
22-23 force x2apic and disable PIC

Isaku Yamahata (12):
  kvm: Switch KVM_CAP_READONLY_MEM to a per-VM ioctl()
  KVM: i386: use VM capability check for KVM_CAP_X86_SMM
  vl: Introduce machine_init_done_late notifier
  i386/kvm: Skip KVM_X86_SETUP_MCE for TDX guests
  target/i386: kvm: don't synchronize guest tsc for TD guest
  i386/tdx: Frame in the call for KVM_TDX_INIT_VCPU
  hw/i386: Add definitions from UEFI spec for volumes, resources, etc...
  i386/tdx: Add definitions for TDVF metadata
  i386/tdx: Parse tdvf metadata and store the result into TdxGuest
  i386/tdx: Create the TD HOB list upon machine init done
  i386/tdx: Add TDVF memory via INIT_MEM_REGION
  i386/tdx: Use KVM_TDX_INIT_VCPU to pass HOB to TDVF

Sean Christopherson (7):
  target/i386: Expose x86_cpu_get_supported_feature_word() for TDX
  i386/kvm: Move architectural CPUID leaf generation to separarte helper
  i386/kvm: Squash getting/putting guest state for TDX VMs
  i386/tdx: Frame in tdx_get_supported_cpuid with KVM_TDX_CAPABILITIES
  i386/tdx: Add hook to require generic device loader
  i386/tdx: Force x2apic mode and routing for TDs
  target/i386: Add machine option to disable PIC/8259

Xiaoyao Li (4):
  hw/i386: Introduce kvm-type for TDX guest
  linux-headers: Update headers to pull in TDX API changes
  hw/i386: Initialize TDX via KVM ioctl() when kvm_type is TDX
  target/i386/tdx: Finalize the TD's measurement when machine is done

 accel/kvm/kvm-all.c                      |   4 +-
 default-configs/devices/i386-softmmu.mak |   1 +
 hw/core/generic-loader.c                 |   5 +
 hw/core/machine.c                        |  26 ++
 hw/core/meson.build                      |   3 +
 hw/core/tdvf-stub.c                      |   6 +
 hw/i386/Kconfig                          |   5 +
 hw/i386/meson.build                      |   1 +
 hw/i386/pc.c                             |  18 +
 hw/i386/pc_piix.c                        |   4 +-
 hw/i386/pc_q35.c                         |   4 +-
 hw/i386/pc_sysfw.c                       |   6 +
 hw/i386/tdvf-hob.c                       | 226 +++++++++++
 hw/i386/tdvf-hob.h                       |  25 ++
 hw/i386/tdvf.c                           | 305 ++++++++++++++
 hw/i386/uefi.h                           | 496 +++++++++++++++++++++++
 hw/i386/x86.c                            |  46 +++
 hw/intc/apic_common.c                    |  12 +
 include/hw/i386/apic.h                   |   1 +
 include/hw/i386/apic_internal.h          |   1 +
 include/hw/i386/pc.h                     |   2 +
 include/hw/i386/tdvf.h                   |  55 +++
 include/hw/i386/x86.h                    |   1 +
 include/sysemu/sysemu.h                  |   2 +
 include/sysemu/tdvf.h                    |   6 +
 include/sysemu/tdx.h                     |  15 +
 linux-headers/asm-x86/kvm.h              |  55 +++
 linux-headers/linux/kvm.h                |   2 +
 target/i386/cpu.c                        |   4 +-
 target/i386/cpu.h                        |   3 +
 target/i386/kvm/kvm-stub.c               |   5 +
 target/i386/kvm/kvm.c                    | 227 +++++++----
 target/i386/kvm/kvm_i386.h               |   5 +
 target/i386/kvm/meson.build              |   1 +
 target/i386/kvm/tdx-stub.c               |  23 ++
 target/i386/kvm/tdx.c                    | 329 +++++++++++++++
 target/i386/kvm/tdx.h                    |  55 +++
 37 files changed, 1893 insertions(+), 92 deletions(-)
 create mode 100644 hw/core/tdvf-stub.c
 create mode 100644 hw/i386/tdvf-hob.c
 create mode 100644 hw/i386/tdvf-hob.h
 create mode 100644 hw/i386/tdvf.c
 create mode 100644 hw/i386/uefi.h
 create mode 100644 include/hw/i386/tdvf.h
 create mode 100644 include/sysemu/tdvf.h
 create mode 100644 include/sysemu/tdx.h
 create mode 100644 target/i386/kvm/tdx-stub.c
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h

-- 
2.17.1

