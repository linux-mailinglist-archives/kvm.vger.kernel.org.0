Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0DB374CEC
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhEFBlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:41:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:23042 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhEFBln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:41:43 -0400
IronPort-SDR: xb+9QEEzCv4VccF6ESe+8/bOZfaLMxfjv7XTHLdn7Bpdd+5577oe7WWdOfM8pWtyN8QdZqeO7r
 xN8CD/m67R4w==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="178579116"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="178579116"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:40:46 -0700
IronPort-SDR: zQ7EbdqEJwrBw+4OMqt9VyMttbWhq7tYPmxvfMikKcLBu9QuvwYJtGo5L8CSQLzE7xehyIKi0b
 /X6YY9A5P1nQ==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220276"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:40:42 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 00/10] Enable encrypted guest memory access in QEMU
Date:   Thu,  6 May 2021 09:40:27 +0800
Message-Id: <20210506014037.11982-1-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

This RFC series introduces the basic framework and a common
implementation on x86 to handle encrypted guest memory
reading/writing, to support QEMU's built-in guest debugging
features, like the monitor command xp and gdbstub.

The encrypted guest which its memory and/or register context
is encrypted by vendor specific technology(AMD SEV/INTEL TDX),
is able to resist the attack from malicious VMM or other
privileged components in host side, however, this ability also
breaks down the QEMU's built-in guest debugging features,
because it prohibits the direct guest memory accessing
(memcpy() with HVA) from QEMU which is the base of these
debugging features.

The framework part based on the previous patche set from
AMD[1] and some discussion result in community[2]. The main
idea is, introduce some new debug interfaces to handle the
encrypted guest physical memory accessing, also introduce
new interfaces in MemoryRegion to handle the actual accessing
there with KVM, don't bother the exist memory access logic or
callbacks as far as possible. 

[1] https://lore.kernel.org/qemu-devel/
    cover.1605316268.git.ashish.kalra@amd.com/
[2] https://lore.kernel.org/qemu-devel/
    20200922201124.GA6606@ashkalra_ubuntu_server/

 - The difference part in this patch series:
   - We introduce another new vm level ioctl focus on the encrypted
     guest memory accessing:

     KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY

     struct kvm_rw_memory rw;
     rw.addr = gpa_OR_hva;
     rw.buf = (__u64)src;
     rw.len = len;
     kvm_vm_ioctl(kvm_state,
                  KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY,
                  &rw);

     This new ioctl has more neutral and general name for its
     purpose, the debugging support of AMD SEV and INTEL TDX
     can be covered by a unify QEMU implementation on x86 with this
     ioctl. Although only INTEL TD guest is supported in this series,
     AMD SEV could be also supported with implementation of this
     ioctl in KVM, plus small modifications in QEMU to enable the
     unify part.

   - The MemoryRegion interface introduced by AMD before now has
     addtional GPA parameter(only HVA before).
     This is for INTEL TDX which uses GPA to do guest memory
     accessing. This change won't impact AMD SEV which is using
     HVA to access the guest memory.

 - New APIs in QEMU:
   - Physical memory accessing:
     - cpu_physical_memory_rw_debug().
     - cpu_physical_memory_read_debug().
     - cpu_physical_memory_write_debug().
     - x86_ldl_phys_debug().
     - x86_ldq_phys_debug().
   - Access from address_space:
     - address_space_read_debug().
     - address_space_write_rom_debug().
   - Virtual memory accessing and page table walking:
     - cpu_memory_rw_debug().
     - x86_cpu_get_phys_page_attrs_encrypted_debug().

 - New intrfaces in QEMU:
   - MemoryDebugOps *physical_memory_debug_op
     - For normal guest:
       Just call the old exist memory RW functions.
     - For encrypted guest:
       Forward the request to MemoryRegion->ram_debug_ops

   - MemoryRegionRAMReadWriteOps MemoryRegion::*ram_debug_ops
     - For normal guest:
       NULL and nobody use it.
     - For encrypted guest:
       Forward the request to common/vendor specific implementation.

 - The relationship diagram of the APIs and interfaces:

                 +---------------------------------------------+
                 |x86_cpu_get_phys_page_attrs_encrypted_debug()|
                 +----------------------------------+----------+
                                                    |
          +---------------------------------+       |
          |cpu_physical_memory_rw_debug()   |       |
          |cpu_physical_memory_read_debug() |       |
          |cpu_physical_memory_write_debug()|       |
          +----------------------+----------+       |
                                 |                  |
   +---------------------+       |        +---------v----------+
   |cpu_memory_rw_debug()|       |        |x86_ldl_phys_debug()|
   +-------------------+-+       |        |x86_ldq_phys_debug()|
                       |         |        +-------+------------+
                       |         |                |
                       |         |                |
  +--------------------v---------v----------------v------------+
  |         MemoryDebugOps *physical_memory_debug_op           |
  +----------------------+--------------------------+----------+
                         |                          |
                         |Encrypted guest           |Normal guest
                         |                          |
    +--------------------v-----------------------+  |
    |address_space_encrypted_memory_read_debug() |  |
    |address_space_encrypted_rom_write_debug()   |  |
    +--------------------+-----------------------+  |
                         |                          | 
                         |          +---------------v----------+
                         |          |address_space_read()      |
                         |          |address_space_write_rom() |
                         |          +--------------------------+
                         |
        +----------------v----------------+
        | address_space_read_debug()      |
        | address_space_write_rom_debug() |
        +----------------+----------------+
                         |
                         |
                         |
        +----------------v----------------+
        |  MemoryRegionRAMReadWriteOps    |
        |  MemoryRegion::*ram_debug_ops   |
        +--------+--------------+---------+
                 |              |
                 |              |Normal guest
                 |              |
  Encrypted guest|          +---v-------------------+
                 |          | NULL(nobody using it) |
                 |          +-----------------------+
                 |
       +---------v----------------------------+
       |  kvm_encrypted_guest_read_memory()   |
       |  kvm_encrypted_guest_write_memory()  |
       +--------------------------------------+

Ashish Kalra (2):
  Introduce new MemoryDebugOps which hook into guest virtual and
    physical memory debug interfaces such as cpu_memory_rw_debug, to
    allow vendor specific assist/hooks for debugging and delegating
    accessing the guest memory. This is required for example in case of
    AMD SEV platform where the guest memory is encrypted and a SEV
    specific debug assist/hook will be required to access the guest
    memory.
  Add new address_space_read and address_space_write debug helper
    interfaces which can be invoked by vendor specific guest memory
    debug assist/hooks to do guest RAM memory accesses using the added
    MemoryRegion callbacks.

Brijesh Singh (2):
  Extend the MemTxAttrs to include a 'debug' flag. The flag can be used
    as general indicator that operation was triggered by the debugger.
  Currently, guest memory access for debugging purposes is performed
    using memcpy(). Extend the 'struct MemoryRegion' to include new
    callbacks that can be used to override the use of memcpy() with
    something else.

Yuan Yao (6):
  Introduce new interface KVMState::set_mr_debug_ops and its wrapper
  Implements the common MemoryRegion::ram_debug_ops for encrypted guests
  Set the RAM's MemoryRegion::debug_ops for INTEL TD guests
  Introduce debug version of physical memory read/write API
  Change the monitor and other commands and gdbstub to use the debug API
  Introduce new CPUClass::get_phys_page_attrs_debug implementation for
    encrypted guests

 accel/kvm/kvm-all.c       |  17 +++++
 accel/stubs/kvm-stub.c    |  11 +++
 dump/dump.c               |   2 +-
 gdbstub.c                 |   4 +-
 hw/i386/pc.c              |   4 +
 include/exec/cpu-common.h |  14 ++++
 include/exec/memattrs.h   |   4 +
 include/exec/memory.h     |  54 +++++++++++++
 include/sysemu/kvm.h      |   5 ++
 include/sysemu/tdx.h      |   3 +
 monitor/misc.c            |  12 ++-
 softmmu/cpus.c            |   2 +-
 softmmu/physmem.c         | 154 +++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h         |   4 +
 target/i386/helper.c      |  64 +++++++++++++---
 target/i386/kvm/kvm.c     |  68 +++++++++++++++++
 target/i386/kvm/tdx.c     |  21 ++++++
 target/i386/monitor.c     |  52 ++++++-------
 18 files changed, 447 insertions(+), 48 deletions(-)

-- 
2.20.1

