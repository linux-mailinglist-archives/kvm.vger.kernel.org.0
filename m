Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8787D7770D
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfG0FwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfG0FwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568578"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 00/21] x86/sgx: KVM: Add SGX virtualization
Date:   Fri, 26 Jul 2019 22:51:53 -0700
Message-Id: <20190727055214.9282-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an "early" RFC series for adding SGX virtualization to KVM.  SGX
virtualization (more specifically, EPC virtualization) is dependent on the
not-yet-merged SGX enabling series and so cannot be considered for
inclusion any time soon.

The primary goal of this RFC is to get feedback on the overall approach,
e.g. code location, uAPI changes, functionality, etc...  My hope is to
sort out any major issues sooner rather than later, so that if/when the
base SGX enabling is merged, virtualization support can quickly follow
suit.

That being said, nitpicking and bikeshedding is more than welcome :-)

This code applies on top of a slightly modified version of v21 of the SGX
enabling series[1].  The modifications on top of the SGX series are a few
minor bug fixes that are not related to SGX virtualization, but affect
code that is moved/modified by this series.  The full source for the
modified version of v21 can be found at:

 https://github.com/sean-jc/linux.git

under the tag:

  sgx-v21-ish

A corresponding Qemu RFC will (hopefully) follow next week, the Qemu
patches need a bit more cleanup...

[1] https://lkml.kernel.org/r/20190713170804.2340-1-jarkko.sakkinen@linux.intel.com

Sean Christopherson (21):
  x86/sgx: Add defines for SGX device minor numbers
  x86/sgx: Move bus registration and device init to common code
  x86/sgx: Move provisioning device to common code
  x86/sgx: Add /dev/sgx/virt_epc device to allocate "raw" EPC for VMs
  x86/sgx: Expose SGX architectural definitions to the kernel
  KVM: x86: Add SGX sub-features leaf to reverse CPUID table
  KVM: x86: Add WARN_ON_ONCE(index!=0) in __do_cpuid_ent
  KVM: x86: Add kvm_x86_ops hook to short circuit emulation
  KVM: VMX: Add basic handling of VM-Exit from SGX enclave
  KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for VMX/SGX
  KVM: x86: Export kvm_propagate_fault (as kvm_propagate_page_fault)
  KVM: x86: Define new #PF SGX error code bit
  x86/sgx: Move the intermediate EINIT helper into the driver
  x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
  KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
  KVM: VMX: Edd emulation of SGX Launch Control LE hash MSRs
  KVM: VMX: Add handler for ENCLS[EINIT] to support SGX Launch Control
  KVM: x86: Invoke kvm_x86_ops->cpuid_update() after kvm_update_cpuid()
  KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
  x86/sgx: Export sgx_set_attribute() for use by KVM
  KVM: x86: Add capability to grant VM access to privileged SGX
    attribute

 Documentation/virtual/kvm/api.txt             |  20 ++
 arch/x86/Kconfig                              |  13 +
 arch/x86/include/asm/kvm_host.h               |   8 +-
 arch/x86/include/asm/sgx.h                    |  17 +
 .../cpu/sgx/arch.h => include/asm/sgx_arch.h} |   1 +
 arch/x86/include/asm/vmx.h                    |   1 +
 arch/x86/include/uapi/asm/vmx.h               |   1 +
 arch/x86/kernel/cpu/sgx/Makefile              |   1 +
 arch/x86/kernel/cpu/sgx/driver/driver.h       |   3 +-
 arch/x86/kernel/cpu/sgx/driver/ioctl.c        |  40 ++-
 arch/x86/kernel/cpu/sgx/driver/main.c         |  73 +----
 arch/x86/kernel/cpu/sgx/encl.c                |   2 +-
 arch/x86/kernel/cpu/sgx/encls.h               |   2 +-
 arch/x86/kernel/cpu/sgx/main.c                | 141 ++++++--
 arch/x86/kernel/cpu/sgx/sgx.h                 |  16 +-
 arch/x86/kernel/cpu/sgx/virt.c                | 308 ++++++++++++++++++
 arch/x86/kernel/cpu/sgx/virt.h                |  14 +
 arch/x86/kvm/Makefile                         |   2 +
 arch/x86/kvm/cpuid.c                          | 135 ++++++--
 arch/x86/kvm/cpuid.h                          |  20 ++
 arch/x86/kvm/emulate.c                        |   1 +
 arch/x86/kvm/mmu.c                            |  12 -
 arch/x86/kvm/svm.c                            |  19 +-
 arch/x86/kvm/vmx/nested.c                     |  21 +-
 arch/x86/kvm/vmx/nested.h                     |   5 +
 arch/x86/kvm/vmx/sgx.c                        | 247 ++++++++++++++
 arch/x86/kvm/vmx/sgx.h                        |  11 +
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                        | 251 +++++++++++++-
 arch/x86/kvm/vmx/vmx.h                        |   6 +
 arch/x86/kvm/x86.c                            |  40 ++-
 arch/x86/kvm/x86.h                            |   5 -
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/x86/sgx/defines.h     |   2 +-
 35 files changed, 1234 insertions(+), 210 deletions(-)
 create mode 100644 arch/x86/include/asm/sgx.h
 rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} (99%)
 create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
 create mode 100644 arch/x86/kernel/cpu/sgx/virt.h
 create mode 100644 arch/x86/kvm/vmx/sgx.c
 create mode 100644 arch/x86/kvm/vmx/sgx.h

-- 
2.22.0

