Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B013E83925
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfHFS52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:40914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbfHFS5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:56:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715062"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 06 Aug 2019 11:56:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 00/20] i386: Add support for Intel SGX
Date:   Tue,  6 Aug 2019 11:56:29 -0700
Message-Id: <20190806185649.2476-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables exposing Intel Software Guard Extensions (SGX) to KVM
guests.  This series is firmly RFC due to SGX support not yet being
accepted into the Linux kernel, let alone KVM.

The primary goal of this RFC is to get feedback on the overall approach,
especially with respect to Enclave Page Cache (EPC) handling, but any
feedback whatsoever would be greatly appreciated.  Please don't hesitate
to ask for more details and/or clarification.

The code is based on 'https://github.com/ehabkost/qemu.git x86-next',
which currently points at commit:

  ff656fcd33 ("i386: Fix Snowridge CPU model name and features")


Brief arch blurb (providing useful documentation in a cover letter is
impractical due to scope of SGX):

  SGX is a set of instructions and mechanisms that enable ring 3
  applications to set aside private regions of code and data for the
  purpose of establishing and running enclaves.  An enclave is a secure
  entity whose private memory can only be accessed by code running within
  the enclave.  Accesses from outside the enclave, including software
  running at a higher privilege level and other enclaves, are disallowed
  by hardware.

Overviews and details:

  SGX arch kernel doc - https://patchwork.kernel.org/patch/11043125/

  SGX arch overview   - https://www.youtube.com/watch?v=mPT_vJrlHlg

Gory details on SGX are also available in all recent versions of Intel's
SDM, e.g. chapters 37-42 in Vol. 3 of the May 2019 version of the SDM.


Linux kernel and KVM enabling:

  SGX kernel enabling - https://lkml.kernel.org/r/20190713170804.2340-1-jarkko.sakkinen@linux.intel.com

  SGX KVM enabling    - https://lkml.kernel.org/r/20190727055214.9282-1-sean.j.christopherson@intel.com


QEMU points of interest:

Basics - SGX is exposed the guest if and only if KVM is enabled and
         supports virtualization of SGX, and the kernel provides access
         to "raw" EPC.  Because SGX uses a hardware-based root of trust,
         the attestation aspects of SGX cannot be emulated in software,
         i.e. ultimately emulation will fail as software cannot generate
         a valid quote/report.  The complexity of partially emulating SGX
         in Qemu far outweighs the value added, e.g. an SGX specific
         simulator for userspace applications can emulate SGX for
         development and testing purposes.

EPC - Because of its unique requirements, the kernel manages EPC separately
      from normal memory.  Similar to memfd, the device /dev/sgx/virt_epc
      can be opened to obtain a file descriptor which can in turn be used
      to mmap() EPC memory.

      The notable quirk with EPC from QEMU's perspective is that EPC is
      enumerated via CPUID, which complicates realizing EPC as a normal
      device due to vCPU creation depending on the location/size of EPC
      sections.

Migration - Physical EPC is encrypted with an ephemeral key that is
            (re)generated at CPU reset, i.e. is platform specific.  Thus,
            migrating EPC contents between physical platforms is
            infeasible.  However, live migration is not blocked by SGX as
            kernels and applications are conditioned to gracefully handle
            EPC invalidation due to the EPC being zapped on power state
            transitions that power down the CPU, e.g. S3.  I.e. from the
            guest's perspective, live migration appears and is handled
            like an unannounced suspend/resume cycle.

NUMA - How EPC NUMA affinity will be enumerated to the kernel is not yet
       defined (initial hardware support for SGX was limited to single
       socket systems).

Sean Christopherson (20):
  hostmem: Add hostmem-epc as a backend for SGX EPC
  i386: Add 'sgx-epc' device to expose EPC sections to guest
  vl: Add "sgx-epc" option to expose SGX EPC sections to guest
  i386: Add primary SGX CPUID and MSR defines
  i386: Add SGX CPUID leaf FEAT_SGX_12_0_EAX
  i386: Add SGX CPUID leaf FEAT_SGX_12_1_EAX
  i386: Add SGX CPUID leaf FEAT_SGX_12_1_EBX
  i386: Add get/set/migrate support for SGX LE public key hash MSRs
  i386: Add feature control MSR dependency when SGX is enabled
  i386: Update SGX CPUID info according to hardware/KVM/user input
  linux-headers: Add temporary placeholder for KVM_CAP_SGX_ATTRIBUTE
  i386: kvm: Add support for exposing PROVISIONKEY to guest
  i386: Propagate SGX CPUID sub-leafs to KVM
  i386: Adjust min CPUID level to 0x12 when SGX is enabled
  hw/i386/pc: Set SGX bits in feature control fw_cfg accordingly
  hw/i386/pc: Account for SGX EPC sections when calculating device
    memory
  i386/pc: Add e820 entry for SGX EPC section(s)
  i386: acpi: Add SGX EPC entry to ACPI tables
  q35: Add support for SGX EPC
  i440fx: Add support for SGX EPC

 backends/Makefile.objs    |   1 +
 backends/hostmem-epc.c    |  91 ++++++++++++
 hw/i386/Makefile.objs     |   1 +
 hw/i386/acpi-build.c      |  22 +++
 hw/i386/pc.c              |  23 ++-
 hw/i386/pc_piix.c         |   3 +
 hw/i386/pc_q35.c          |   2 +
 hw/i386/sgx-epc.c         | 291 ++++++++++++++++++++++++++++++++++++++
 include/hw/i386/pc.h      |   3 +
 include/hw/i386/sgx-epc.h |  75 ++++++++++
 linux-headers/linux/kvm.h |   1 +
 qapi/misc.json            |  32 ++++-
 qemu-options.hx           |  12 ++
 target/i386/cpu.c         | 148 ++++++++++++++++++-
 target/i386/cpu.h         |  14 ++
 target/i386/kvm-stub.c    |   5 +
 target/i386/kvm.c         |  70 +++++++++
 target/i386/kvm_i386.h    |   3 +
 target/i386/machine.c     |  20 +++
 vl.c                      |   9 ++
 20 files changed, 820 insertions(+), 6 deletions(-)
 create mode 100644 backends/hostmem-epc.c
 create mode 100644 hw/i386/sgx-epc.c
 create mode 100644 include/hw/i386/sgx-epc.h

-- 
2.22.0

