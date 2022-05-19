Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D723F52D451
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiESNmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiESNm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:42:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CE13ED17
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B96BB80EA7
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3C3C34100;
        Thu, 19 May 2022 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967744;
        bh=tRBfSiYXEQcDgtQZM+v57r8nmGaT0ygF9nae7i8MiIo=;
        h=From:To:Cc:Subject:Date:From;
        b=RgAMQe3uYZtwZsMYyeQlORfloASH/IzMrWotTa6eVhW2fszVYH30GDFzAbCFZFGyx
         ohcaBeeaDh9/9jzuenD3l0yDKK3UZHQ07UNhrrUooJHgYKacVqj77K9ymvbuIM2cof
         EJgXW0/wDXozgIaiLWvanNV+TaCANco2uwn5qhn3NYWAtZgZY/J+hLCsUWh31dqMg/
         hWG3P4VnPR40jkeQlqxNXjd23TVpzgXE75HyIlEXHrZlxVOY4UdC0oFqVhsnW8S7YC
         KUXdfq1nX96j+gM0hA0KDYLFfVELNuW4llAyWlsGRUz0x7l5o1MesJW/D5aIK5qQKo
         SB9vNlU6+PdHg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 00/89] KVM: arm64: Base support for the pKVM hypervisor at EL2
Date:   Thu, 19 May 2022 14:40:35 +0100
Message-Id: <20220519134204.5379-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This rather large series (based on -rc2) builds on top of the limited
pKVM support available upstream and gets us to a point where the
hypervisor code at EL2 is capable of running guests in both
non-protected and protected mode on the same system. For more background
information about pKVM, the following (slightly dated) LWN article may
be informative:

  https://lwn.net/Articles/836693/

The structure of this series is roughly as follows:

  * Patches 01-06 :
    - Some small cleanups and minor fixes.

  * Patches 07-12 :
    - Memory management changes at EL2 to allow the donation of memory
      from the host to the hypervisor and the "pinning" of shared memory
      at EL2.

  * Patches 13-16 :
    - Introduction of shadow VM and vCPU state at EL2 so that the
      hypervisor can manage guest state using its own private data
      structures, initially populated from the host structures.

  * Patches 17-33 :
    - Further memory management changes at EL2 to allow the allocation
      and reclaim of guest memory by the host. This then allows us to
      manage guest stage-2 page-tables entirely at EL2, with the host
      issuing hypercalls to map guest pages in response to faults.

  * Patches 34-78 :
    - Gradual reduction of EL2 trust in host data; rather than copy
      blindly between the host and shadow structures, we instead
      selectively sync/flush between them and reduce the amount of host
      data that is accessed directly by EL2.

  * Patches 79-81 :
    - Inject an abort into the host if it tries to access a guest page
      for which it does not have permission. This will then deliver a
      SEGV if the access originated from userspace.

  * Patches 82-87 :
    - Expose hypercalls to protected guests for sharing memory back with
      the host

  * Patches 88-89 :
    - Introduce the new machine type and add some documentation.

We considered splitting this into multiple series, but decided to keep
everything together initially so that reviewers can more easily get an
idea of what we're trying to do and also take it for a spin. The patches
are also available in our git tree here:

  https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-base-v1

It's worth pointing out that, although we've been tracking the fd-based
proposal around KVM private memory [1], for now the approach taken here
interacts directly with anonymous pages using a longterm GUP pin. We're
expecting to prototype an fd-based implementation once the discussion at
[2] has converged. In the meantime, we hope to progress the non-protected
VM support.

Finally, there are still some features that we have not included in this
posting and will come later on:

  - Support for read-only memslots and dirty logging for non-protected
    VMs. We currently document that this doesn't work (setting the
    memslot flags will fail), but we're working to enable this.

  - Support for IOMMU configuration to protect guest memory from DMA
    attacks by the host.

  - Support for optional loading of the guest's initial firmware by the
    hypervisor.

  - Proxying of host interactions with Trustzone, intercepting and
    validating FF-A [3] calls at EL2.

  - Support for restricted MMIO exits to only regions designated as
    MMIO by the guest. An earlier version of this work was previously
    posted at [4].

  - Hardware debug and PMU support for non-protected guests -- this
    builds on the separate series posted at [5] and which is now queued
    for 5.19.

  - Guest-side changes to issue the new pKVM hypercalls, for example
    sharing back the SWIOTLB buffer with the host for virtio traffic.

Please enjoy,

Will, Quentin, Fuad and Marc

[1] https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com/
[2] https://lore.kernel.org/r/20220422105612.GB61987@chaop.bj.intel.com
[3] https://developer.arm.com/documentation/den0077/latest
[4] https://lore.kernel.org/all/20211004174849.2831548-1-maz@kernel.org/
[5] https://lore.kernel.org/all/20220510095710.148178-1-tabba@google.com/

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Marc Zyngier <maz@kernel.org>

Cc: kernel-team@android.com
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org

--->8

Fuad Tabba (23):
  KVM: arm64: Add hyp_spinlock_t static initializer
  KVM: arm64: Introduce shadow VM state at EL2
  KVM: arm64: Instantiate VM shadow data from EL1
  KVM: arm64: Do not allow memslot changes after first VM run under pKVM
  KVM: arm64: Add hyp per_cpu variable to track current physical cpu
    number
  KVM: arm64: Ensure that TLBs and I-cache are private to each vcpu
  KVM: arm64: Do not pass the vcpu to __pkvm_host_map_guest()
  KVM: arm64: Check directly whether the vcpu is protected
  KVM: arm64: Trap debug break and watch from guest
  KVM: arm64: Restrict protected VM capabilities
  KVM: arm64: Do not support MTE for protected VMs
  KVM: arm64: Refactor reset_mpidr to extract its computation
  KVM: arm64: Reset sysregs for protected VMs
  KVM: arm64: Move pkvm_vcpu_init_traps to shadow vcpu init
  KVM: arm64: Fix initializing traps in protected mode
  KVM: arm64: Add EL2 entry/exit handlers for pKVM guests
  KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
  KVM: arm64: Initialize shadow vm state at hyp
  KVM: arm64: Add HVC handling for protected guests at EL2
  KVM: arm64: Move pstate reset values to kvm_arm.h
  KVM: arm64: Move some kvm_psci functions to a shared header
  KVM: arm64: Factor out vcpu_reset code for core registers and PSCI
  KVM: arm64: Handle PSCI for protected VMs in EL2

Marc Zyngier (20):
  KVM: arm64: Handle all ID registers trapped for a protected VM
  KVM: arm64: Drop stale comment
  KVM: arm64: Check for PTE validity when checking for
    executable/cacheable
  KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
  KVM: arm64: Simplify vgic-v3 hypercalls
  KVM: arm64: Add the {flush,sync}_vgic_state() primitives
  KVM: arm64: Introduce predicates to check for protected state
  KVM: arm64: Add the {flush,sync}_timer_state() primitives
  KVM: arm64: Introduce the pkvm_vcpu_{load,put} hypercalls
  KVM: arm64: Add current vcpu and shadow_state lookup primitive
  KVM: arm64: Skip __kvm_adjust_pc() for protected vcpus
  KVM: arm64: Introduce per-EC entry/exit handlers
  KVM: arm64: Introduce lazy-ish state sync for non-protected VMs
  KVM: arm64: Lazy host FP save/restore
  KVM: arm64: Reduce host/shadow vcpu state copying
  KVM: arm64: Force injection of a data abort on NISV MMIO exit
  KVM: arm64: Donate memory to protected guests
  KVM: arm64: Move vgic state between host and shadow vcpu structures
  KVM: arm64: Do not update virtual timer state for protected VMs
  KVM: arm64: Track the SVE state in the shadow vcpu

Quentin Perret (22):
  KVM: arm64: Move hyp refcount manipulation helpers
  KVM: arm64: Back hyp_vmemmap for all of memory
  KVM: arm64: Implement do_donate() helper for donating memory
  KVM: arm64: Prevent the donation of no-map pages
  KVM: arm64: Add helpers to pin memory shared with hyp
  KVM: arm64: Make hyp stage-1 refcnt correct on the whole range
  KVM: arm64: Factor out private range VA allocation
  KVM: arm64: Add pcpu fixmap infrastructure at EL2
  KVM: arm64: Allow non-coallescable pages in a hyp_pool
  KVM: arm64: Add generic hyp_memcache helpers
  KVM: arm64: Instantiate guest stage-2 page-tables at EL2
  KVM: arm64: Return guest memory from EL2 via dedicated teardown
    memcache
  KVM: arm64: Add flags to struct hyp_page
  KVM: arm64: Consolidate stage-2 init in one function
  KVM: arm64: Disallow dirty logging and RO memslots with pKVM
  KVM: arm64: Don't access kvm_arm_hyp_percpu_base at EL1
  KVM: arm64: Unmap kvm_arm_hyp_percpu_base from the host
  KVM: arm64: Explicitly map kvm_vgic_global_state at EL2
  KVM: arm64: Don't map host sections in pkvm
  KVM: arm64: Add is_pkvm_initialized() helper
  KVM: arm64: Refactor enter_exception64()
  KVM: arm64: Inject SIGSEGV on illegal accesses

Will Deacon (24):
  KVM: arm64: Remove redundant hyp_assert_lock_held() assertions
  KVM: arm64: Return error from kvm_arch_init_vm() on allocation failure
  KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
  KVM: arm64: Extend comment in has_vhe()
  KVM: arm64: Unify identifiers used to distinguish host and hypervisor
  KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
  KVM: arm64: Provide I-cache invalidation by VA at EL2
  KVM: arm64: Provide a hypercall for the host to reclaim guest memory
  KVM: arm64: Extend memory sharing to allow host-to-guest transitions
  KVM: arm64: Use the shadow vCPU structure in handle___kvm_vcpu_run()
  KVM: arm64: Handle guest stage-2 page-tables entirely at EL2
  KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
  KVM: arm64: Extend memory donation to allow host-to-guest transitions
  KVM: arm64: Split up nvhe/fixed_config.h
  KVM: arm64: Advertise GICv3 sysreg interface to protected guests
  KVM: arm64: Don't expose TLBI hypercalls after de-privilege
  KVM: arm64: Support TLB invalidation in guest context
  KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
  KVM: arm64: Extend memory sharing to allow guest-to-host transitions
  KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
  KVM: arm64: Reformat/beautify PTP hypercall documentation
  KVM: arm64: Expose memory sharing hypercalls to protected guests
  KVM: arm64: Introduce KVM_VM_TYPE_ARM_PROTECTED machine type for PVMs
  Documentation: KVM: Add some documentation for Protected KVM on arm64

 .../admin-guide/kernel-parameters.txt         |    5 +-
 Documentation/virt/kvm/api.rst                |    7 +
 Documentation/virt/kvm/arm/hypercalls.rst     |  118 ++
 Documentation/virt/kvm/arm/index.rst          |    2 +
 Documentation/virt/kvm/arm/pkvm.rst           |   96 ++
 Documentation/virt/kvm/arm/ptp_kvm.rst        |   38 +-
 arch/arm64/include/asm/kvm_arm.h              |   11 +-
 arch/arm64/include/asm/kvm_asm.h              |   28 +-
 arch/arm64/include/asm/kvm_emulate.h          |   92 ++
 arch/arm64/include/asm/kvm_host.h             |  123 +-
 arch/arm64/include/asm/kvm_hyp.h              |   10 +-
 arch/arm64/include/asm/kvm_mmu.h              |    2 +-
 arch/arm64/include/asm/kvm_pgtable.h          |    8 +
 arch/arm64/include/asm/kvm_pkvm.h             |  257 ++++
 arch/arm64/include/asm/virt.h                 |   15 +-
 arch/arm64/kernel/cpufeature.c                |   10 +-
 arch/arm64/kernel/image-vars.h                |   15 -
 arch/arm64/kvm/arch_timer.c                   |    7 +-
 arch/arm64/kvm/arm.c                          |  194 ++-
 arch/arm64/kvm/handle_exit.c                  |   22 +
 arch/arm64/kvm/hyp/exception.c                |   89 +-
 arch/arm64/kvm/hyp/hyp-constants.c            |    3 +
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  205 ---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |    6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   33 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  119 ++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |   10 +-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |    2 -
 arch/arm64/kvm/hyp/nvhe/cache.S               |   11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  937 +++++++++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |    4 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 1035 +++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  177 ++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |   42 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 1095 ++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   97 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |    9 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  139 ++-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |   96 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   31 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |   27 +-
 arch/arm64/kvm/mmio.c                         |    9 +
 arch/arm64/kvm/mmu.c                          |  202 ++-
 arch/arm64/kvm/pkvm.c                         |  156 ++-
 arch/arm64/kvm/pmu.c                          |   16 +-
 arch/arm64/kvm/psci.c                         |   28 -
 arch/arm64/kvm/reset.c                        |   99 +-
 arch/arm64/kvm/sys_regs.c                     |   34 +-
 arch/arm64/kvm/sys_regs.h                     |   19 +
 arch/arm64/kvm/vgic/vgic-v2.c                 |    9 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   28 +-
 arch/arm64/kvm/vgic/vgic.c                    |   17 +-
 arch/arm64/kvm/vgic/vgic.h                    |    6 +-
 arch/arm64/mm/fault.c                         |   22 +
 include/kvm/arm_vgic.h                        |    3 +-
 include/linux/arm-smccc.h                     |   21 +
 include/uapi/linux/kvm.h                      |    6 +
 59 files changed, 5128 insertions(+), 817 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

-- 
2.36.1.124.g0e6072fb45-goog

