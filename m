Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC028A195
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgJJVsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731451AbgJJTXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 15:23:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA23C22365;
        Sat, 10 Oct 2020 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602347934;
        bh=49EtDC0f8LwP6BYJIv8036l4/kegw0KVNNCxs5tOkyA=;
        h=From:To:Cc:Subject:Date:From;
        b=jCfqssPCphNw1TWDRIqo7Wk8JSRKG0Or4jmvJ178Z3xTLNNpry/CZISljkDp3KX8t
         zRWeaovwq0eOa4VRbKgHwFFEnlQAv2B+df+GsGg705yxNnTNAOMAPdi9RFWu3PjN5I
         EWeCGuuvyIObLUtvi0w6jsSF+UVPIPyqJLszRnFY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kRHtT-001JIN-Tq; Sat, 10 Oct 2020 17:38:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Scull <ascull@google.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        kernel test robot <lkp@intel.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Xiaofei Tan <tanxiaofei@huawei.com>, kernel-team@android.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 updates for 5.10
Date:   Sat, 10 Oct 2020 17:38:37 +0100
Message-Id: <20201010163837.1409855-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, ascull@google.com, asteinhauser@google.com, dan.carpenter@oracle.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, lkp@intel.com, liushixin2@huawei.com, mchehab+huawei@kernel.org, qperret@google.com, steven.price@arm.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, tiantao6@hisilicon.com, will@kernel.org, tanxiaofei@huawei.com, kernel-team@android.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the (pretty large) set of KVM/arm64 updates for 5.10.

This time around, more of the work we're doing on the pKVM front: new
page table code, new EL2-private data structures, including a per-CPU
infrastructure. Also, we now have a way for userspace to decide which
PMU events get counted. Finally, a complete rework of the Spectre
mitigation, as the existing code had quickly become completely
unmaintainable.

A couple of notes:
- The Spectre stuff is a shared branch between the arm64 and the KVM,
  so both tries carry the whole thing

- The branch is based on -rc4, but would have (badly) conflicted with
  some of the fixes merged in -rc5. So I did the merge myself, solving
  the conflicts myself. This may explain why some of the patches have
  an air of "déjà vu" (the steal-time fixes, for example)...

The following changes since commit f4d51dffc6c01a9e94650d95ce0104964f8ae822:

  Linux 5.9-rc4 (2020-09-06 17:11:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.10

for you to fetch changes up to 4e5dc64c43192b4fd4c96ac150a8f013065f5f5b:

  Merge branches 'kvm-arm64/pt-new' and 'kvm-arm64/pmu-5.9' into kvmarm-master/next (2020-10-02 09:25:55 +0100)

----------------------------------------------------------------
KVM/arm64 updates for Linux 5.10

- New page table code for both hypervisor and guest stage-2
- Introduction of a new EL2-private host context
- Allow EL2 to have its own private per-CPU variables
- Support of PMU event filtering
- Complete rework of the Spectre mitigation

----------------------------------------------------------------
Alexandru Elisei (5):
      KVM: arm64: Update page shift if stage 2 block mapping not supported
      KVM: arm64: Try PMD block mappings if PUD mappings are not supported
      KVM: arm64: Do not flush memslot if FWB is supported
      KVM: arm64: Add undocumented return values for PMU device control group
      KVM: arm64: Match PMU error code descriptions with error conditions

Andrew Jones (6):
      KVM: arm64: pvtime: steal-time is only supported when configured
      KVM: arm64: pvtime: Fix potential loss of stolen time
      KVM: arm64: Drop type input from kvm_put_guest
      KVM: arm64: pvtime: Fix stolen time accounting across migration
      KVM: Documentation: Minor fixups
      arm64/x86: KVM: Introduce steal-time cap

Andrew Scull (19):
      KVM: arm64: Remove __activate_vm wrapper
      KVM: arm64: Remove hyp_panic arguments
      KVM: arm64: Remove kvm_host_data_t typedef
      KVM: arm64: Choose hyp symbol based on context
      KVM: arm64: Save chosen hyp vector to a percpu variable
      KVM: arm64: nVHE: Use separate vector for the host
      KVM: arm64: nVHE: Don't consume host SErrors with ESB
      KVM: arm64: Introduce hyp context
      KVM: arm64: Update context references from host to hyp
      KVM: arm64: Restore hyp when panicking in guest context
      KVM: arm64: Share context save and restore macros
      KVM: arm64: nVHE: Switch to hyp context for EL2
      KVM: arm64: nVHE: Handle hyp panics
      KVM: arm64: nVHE: Pass pointers consistently to hyp-init
      smccc: Define vendor hyp owned service call region
      smccc: Use separate variables for args and results
      KVM: arm64: nVHE: Migrate hyp interface to SMCCC
      KVM: arm64: nVHE: Migrate hyp-init to SMCCC
      KVM: arm64: nVHE: Fix pointers during SMCCC convertion

David Brazdil (10):
      kvm: arm64: Partially link nVHE hyp code, simplify HYPCOPY
      kvm: arm64: Move nVHE hyp namespace macros to hyp_image.h
      kvm: arm64: Only define __kvm_ex_table for CONFIG_KVM
      kvm: arm64: Remove __hyp_this_cpu_read
      kvm: arm64: Remove hyp_adr/ldr_this_cpu
      kvm: arm64: Add helpers for accessing nVHE hyp per-cpu vars
      kvm: arm64: Duplicate arm64_ssbd_callback_required for nVHE hyp
      kvm: arm64: Create separate instances of kvm_host_data for VHE/nVHE
      kvm: arm64: Set up hyp percpu data for nVHE
      kvm: arm64: Remove unnecessary hyp mappings

Liu Shixin (1):
      KVM: arm64: vgic-debug: Convert to use DEFINE_SEQ_ATTRIBUTE macro

Marc Zyngier (23):
      KVM: arm64: Do not try to map PUDs when they are folded into PMD
      KVM: arm64: Fix address truncation in traces
      Merge branch 'kvm-arm64/pt-new' into kvmarm-master/next
      Merge branch 'kvm-arm64/nvhe-hyp-context' into kvmarm-master/next
      Merge branch 'kvm-arm64/pt-new' into kvmarm-master/next
      Merge branch 'kvm-arm64/misc-5.10' into kvmarm-master/next
      arm64: Make use of ARCH_WORKAROUND_1 even when KVM is not enabled
      arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs
      KVM: arm64: Refactor PMU attribute error handling
      KVM: arm64: Use event mask matching architecture revision
      KVM: arm64: Add PMU event filtering infrastructure
      KVM: arm64: Mask out filtered events in PCMEID{0,1}_EL1
      KVM: arm64: Document PMU filtering API
      Merge branch 'kvm-arm64/pmu-5.9' into kvmarm-master/next
      arm64: Run ARCH_WORKAROUND_2 enabling code on all CPUs
      KVM: arm64: Set CSV2 for guests on hardware unaffected by Spectre-v2
      KVM: arm64: Simplify handling of ARCH_WORKAROUND_2
      KVM: arm64: Get rid of kvm_arm_have_ssbd()
      KVM: arm64: Convert ARCH_WORKAROUND_2 to arm64_get_spectre_v4_state()
      arm64: Get rid of arm64_ssbd_state
      Merge remote-tracking branch 'arm64/for-next/ghostbusters' into kvm-arm64/hyp-pcpu
      Merge branch 'kvm-arm64/hyp-pcpu' into kvmarm-master/next
      Merge branches 'kvm-arm64/pt-new' and 'kvm-arm64/pmu-5.9' into kvmarm-master/next

Mauro Carvalho Chehab (1):
      KVM: arm64: Fix some documentation build warnings

Quentin Perret (4):
      KVM: arm64: Add support for stage-2 write-protect in generic page-table
      KVM: arm64: Convert write-protect operation to generic page-table API
      KVM: arm64: Add support for stage-2 cache flushing in generic page-table
      KVM: arm64: Convert memslot cache-flushing code to generic page-table API

Tian Tao (1):
      KVM: arm64: Fix inject_fault.c kernel-doc warnings

Will Deacon (33):
      KVM: arm64: Remove kvm_mmu_free_memory_caches()
      KVM: arm64: Add stand-alone page-table walker infrastructure
      KVM: arm64: Add support for creating kernel-agnostic stage-1 page tables
      KVM: arm64: Use generic allocator for hyp stage-1 page-tables
      KVM: arm64: Add support for creating kernel-agnostic stage-2 page tables
      KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table
      KVM: arm64: Convert kvm_phys_addr_ioremap() to generic page-table API
      KVM: arm64: Convert kvm_set_spte_hva() to generic page-table API
      KVM: arm64: Convert unmap_stage2_range() to generic page-table API
      KVM: arm64: Add support for stage-2 page-aging in generic page-table
      KVM: arm64: Convert page-aging and access faults to generic page-table API
      KVM: arm64: Add support for relaxing stage-2 perms in generic page-table code
      KVM: arm64: Convert user_mem_abort() to generic page-table API
      KVM: arm64: Check the pgt instead of the pgd when modifying page-table
      KVM: arm64: Remove unused page-table code
      KVM: arm64: Remove unused 'pgd' field from 'struct kvm_s2_mmu'
      KVM: arm64: Don't constrain maximum IPA size based on host configuration
      arm64: Remove Spectre-related CONFIG_* options
      KVM: arm64: Replace CONFIG_KVM_INDIRECT_VECTORS with CONFIG_RANDOMIZE_BASE
      KVM: arm64: Simplify install_bp_hardening_cb()
      arm64: Rename ARM64_HARDEN_BRANCH_PREDICTOR to ARM64_SPECTRE_V2
      arm64: Introduce separate file for spectre mitigations and reporting
      arm64: Rewrite Spectre-v2 mitigation code
      arm64: Group start_thread() functions together
      arm64: Treat SSBS as a non-strict system feature
      arm64: Rename ARM64_SSBD to ARM64_SPECTRE_V4
      arm64: Move SSBD prctl() handler alongside other spectre mitigation code
      arm64: Rewrite Spectre-v4 mitigation code
      KVM: arm64: Allow patching EL2 vectors even with KASLR is not enabled
      arm64: Pull in task_stack_page() to Spectre-v4 mitigation code
      arm64: Add support for PR_SPEC_DISABLE_NOEXEC prctl() option
      KVM: arm64: Pass level hint to TLBI during stage-2 permission fault
      KVM: arm64: Ensure user_mem_abort() return value is initialised

Xiaofei Tan (1):
      KVM: arm64: Fix doc warnings in mmu code

 Documentation/virt/kvm/api.rst            |   22 +-
 Documentation/virt/kvm/devices/vcpu.rst   |   57 +-
 arch/arm64/Kconfig                        |   26 -
 arch/arm64/include/asm/assembler.h        |   29 +-
 arch/arm64/include/asm/cpucaps.h          |    4 +-
 arch/arm64/include/asm/cpufeature.h       |   24 -
 arch/arm64/include/asm/hyp_image.h        |   36 +
 arch/arm64/include/asm/kvm_asm.h          |  192 +++-
 arch/arm64/include/asm/kvm_emulate.h      |   14 -
 arch/arm64/include/asm/kvm_host.h         |   77 +-
 arch/arm64/include/asm/kvm_hyp.h          |    9 +-
 arch/arm64/include/asm/kvm_mmu.h          |  341 +-----
 arch/arm64/include/asm/kvm_pgtable.h      |  309 +++++
 arch/arm64/include/asm/kvm_ptrauth.h      |    6 +-
 arch/arm64/include/asm/mmu.h              |   11 +-
 arch/arm64/include/asm/percpu.h           |   28 +-
 arch/arm64/include/asm/pgtable-hwdef.h    |   24 -
 arch/arm64/include/asm/pgtable-prot.h     |   19 -
 arch/arm64/include/asm/processor.h        |   44 +-
 arch/arm64/include/asm/spectre.h          |   32 +
 arch/arm64/include/asm/stage2_pgtable.h   |  215 ----
 arch/arm64/include/uapi/asm/kvm.h         |   25 +
 arch/arm64/kernel/Makefile                |    3 +-
 arch/arm64/kernel/cpu_errata.c            |  487 +-------
 arch/arm64/kernel/cpufeature.c            |   51 +-
 arch/arm64/kernel/entry.S                 |   10 +-
 arch/arm64/kernel/hibernate.c             |    6 +-
 arch/arm64/kernel/image-vars.h            |    5 -
 arch/arm64/kernel/process.c               |   23 +-
 arch/arm64/kernel/proton-pack.c           |  792 +++++++++++++
 arch/arm64/kernel/ssbd.c                  |  129 ---
 arch/arm64/kernel/suspend.c               |    3 +-
 arch/arm64/kernel/vmlinux.lds.S           |   13 +
 arch/arm64/kvm/Kconfig                    |    3 -
 arch/arm64/kvm/Makefile                   |    2 +-
 arch/arm64/kvm/arm.c                      |  113 +-
 arch/arm64/kvm/hyp.S                      |   34 -
 arch/arm64/kvm/hyp/Makefile               |    3 +-
 arch/arm64/kvm/hyp/entry.S                |   95 +-
 arch/arm64/kvm/hyp/hyp-entry.S            |  107 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |    4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |   48 +-
 arch/arm64/kvm/hyp/nvhe/.gitignore        |    2 +
 arch/arm64/kvm/hyp/nvhe/Makefile          |   62 +-
 arch/arm64/kvm/hyp/nvhe/host.S            |  187 +++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S        |   67 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c        |  117 ++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S         |   19 +
 arch/arm64/kvm/hyp/nvhe/switch.c          |   52 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c             |    2 -
 arch/arm64/kvm/hyp/pgtable.c              |  892 +++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c           |   35 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |    4 +-
 arch/arm64/kvm/hypercalls.c               |   33 +-
 arch/arm64/kvm/inject_fault.c             |    1 +
 arch/arm64/kvm/mmu.c                      | 1759 +++++------------------------
 arch/arm64/kvm/pmu-emul.c                 |  195 +++-
 arch/arm64/kvm/pmu.c                      |   13 +-
 arch/arm64/kvm/psci.c                     |   74 +-
 arch/arm64/kvm/pvtime.c                   |   29 +-
 arch/arm64/kvm/reset.c                    |   44 +-
 arch/arm64/kvm/sys_regs.c                 |    8 +-
 arch/arm64/kvm/trace_arm.h                |   16 +-
 arch/arm64/kvm/trace_handle_exit.h        |    6 +-
 arch/arm64/kvm/vgic/vgic-debug.c          |   24 +-
 arch/arm64/kvm/vgic/vgic-v3.c             |    4 +-
 arch/x86/kvm/x86.c                        |    3 +
 include/kvm/arm_pmu.h                     |    5 +
 include/linux/arm-smccc.h                 |   74 +-
 include/linux/kvm_host.h                  |   31 +-
 include/uapi/linux/kvm.h                  |    1 +
 71 files changed, 3658 insertions(+), 3576 deletions(-)
 create mode 100644 arch/arm64/include/asm/hyp_image.h
 create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
 create mode 100644 arch/arm64/include/asm/spectre.h
 create mode 100644 arch/arm64/kernel/proton-pack.c
 delete mode 100644 arch/arm64/kernel/ssbd.c
 delete mode 100644 arch/arm64/kvm/hyp.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/.gitignore
 create mode 100644 arch/arm64/kvm/hyp/nvhe/host.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S
 create mode 100644 arch/arm64/kvm/hyp/pgtable.c
