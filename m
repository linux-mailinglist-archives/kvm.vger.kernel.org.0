Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA6D5FB3A6
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiJKNsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 09:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJKNsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 09:48:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B89F9FD7
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 06:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665496079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ut543M5MM4j6DKo2OXC427AI7o1rBoooUtsTSCU7wDU=;
        b=SEEew4PrJ411zwmDhMAdVFkJMOKqzK1Ws1fJOQsRzsEYLpDxF64KfH4lP0ODSCkEJILfva
        XN1Q+eHyKD5cNMZHykOOg/+cF+c3cI5fhqrKLbdNtX11lwZnzhmBTxlA+6Fyb8/zeH/wMA
        r31P+/xaS+p2cYjDeduhcyOzSuqK0tU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-Di_HDJ0kOtC3syLS4Ws1BA-1; Tue, 11 Oct 2022 09:47:58 -0400
X-MC-Unique: Di_HDJ0kOtC3syLS4Ws1BA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB0FA87A9E5;
        Tue, 11 Oct 2022 13:47:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B60992166B26;
        Tue, 11 Oct 2022 13:47:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 6.1
Date:   Tue, 11 Oct 2022 09:47:57 -0400
Message-Id: <20221011134757.1074225-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 394265079b6c271fdc191ac31b1ebfbee3dd6d63:

  KVM: selftests: Compare insn opcodes directly in fix_hypercall_test (2022-09-30 06:38:02 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e18d6152ff0f41b7f01f9817372022df04e0d354:

  Merge tag 'kvm-riscv-6.1-1' of https://github.com/kvm-riscv/linux into HEAD (2022-10-03 15:33:43 -0400)

Main batch of ARM + RISC-V changes, and a few fixes and cleanups for x86 (PMU
virtualization and selftests).

There is a small conflict because the RISC-V pull request sorted isa_ext_arr
in alphabetical order, conflicting with Svinval support in this one.  Linux
itself does not yet use Svinval instructions, but KVM does.  The resolution
is after the diffstat for your reference.

----------------------------------------------------------------
ARM:

* Fixes for single-stepping in the presence of an async
  exception as well as the preservation of PSTATE.SS

* Better handling of AArch32 ID registers on AArch64-only
  systems

* Fixes for the dirty-ring API, allowing it to work on
  architectures with relaxed memory ordering

* Advertise the new kvmarm mailing list

* Various minor cleanups and spelling fixes

RISC-V:

* Improved instruction encoding infrastructure for
  instructions not yet supported by binutils

* Svinval support for both KVM Host and KVM Guest

* Zihintpause support for KVM Guest

* Zicbom support for KVM Guest

* Record number of signal exits as a VCPU stat

* Use generic guest entry infrastructure

x86:

* Misc PMU fixes and cleanups.

* selftests: fixes for Hyper-V hypercall

* selftests: fix nx_huge_pages_test on TDP-disabled hosts

* selftests: cleanups for fix_hypercall_test

----------------------------------------------------------------
Andrew Jones (7):
      riscv: Add X register names to gpr-nums
      riscv: Introduce support for defining instructions
      riscv: KVM: Apply insn-def to hfence encodings
      riscv: KVM: Apply insn-def to hlv encodings
      RISC-V: KVM: Make ISA ext mappings explicit
      RISC-V: KVM: Provide UAPI for Zicbom block size
      RISC-V: KVM: Expose Zicbom to the guest

Anup Patel (3):
      RISC-V: KVM: Change the SBI specification version to v1.0
      RISC-V: KVM: Use Svinval for local TLB maintenance when available
      RISC-V: KVM: Allow Guest use Svinval extension

David Matlack (3):
      KVM: selftests: Tell the compiler that code after TEST_FAIL() is unreachable
      KVM: selftests: Add helpers to read kvm_{intel,amd} boolean module parameters
      KVM: selftests: Fix nx_huge_pages_test on TDP-disabled hosts

Elliot Berman (1):
      KVM: arm64: Ignore kvm-arm.mode if !is_hyp_mode_available()

Gavin Shan (1):
      KVM: arm64: vgic: Remove duplicate check in update_affinity_collection()

Jisheng Zhang (3):
      RISC-V: KVM: Record number of signal exits as a vCPU stat
      RISC-V: KVM: Use generic guest entry infrastructure
      riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK

Like Xu (6):
      KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
      KVM: x86/pmu: Don't generate PEBS records for emulated instructions
      KVM: x86/pmu: Refactor PERF_GLOBAL_CTRL update helper for reuse by PEBS
      KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
      KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement amd_*_to_pmc()
      KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters scalability

Marc Zyngier (12):
      Merge branch kvm-arm64/aarch32-raz-idregs into kvmarm-master/next
      Merge remote-tracking branch 'arm64/for-next/sysreg' into kvmarm-master/next
      Merge branch kvm-arm64/single-step-async-exception into kvmarm-master/next
      KVM: Use acquire/release semantics when accessing dirty ring GFN state
      KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
      KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
      KVM: Document weakly ordered architecture requirements for dirty ring
      KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release semantics
      KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available
      KVM: arm64: Advertise new kvmarm mailing list
      Merge branch kvm-arm64/dirty-log-ordered into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.1 into kvmarm-master/next

Mayuresh Chitale (2):
      RISC-V: Probe Svinval extension form ISA string
      RISC-V: KVM: Allow Guest use Zihintpause extension

Oliver Upton (8):
      KVM: arm64: Use visibility hook to treat ID regs as RAZ
      KVM: arm64: Remove internal accessor helpers for id regs
      KVM: arm64: Drop raz parameter from read_id_reg()
      KVM: arm64: Spin off helper for calling visibility hook
      KVM: arm64: Add a visibility bit to ignore user writes
      KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
      KVM: selftests: Add test for AArch32 ID registers
      KVM: selftests: Update top-of-file comment in psci_test

Paolo Bonzini (3):
      Merge tag 'kvm-x86-6.1-2' of https://github.com/sean-jc/linux into HEAD
      Merge tag 'kvmarm-6.1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-6.1-1' of https://github.com/kvm-riscv/linux into HEAD

Peng Hao (2):
      kvm: mmu: fix typos in struct kvm_arch
      kvm: vmx: keep constant definition format consistent

Reiji Watanabe (4):
      KVM: arm64: Preserve PSTATE.SS for the guest while single-step is enabled
      KVM: arm64: Clear PSTATE.SS when the Software Step state was Active-pending
      KVM: arm64: selftests: Refactor debug-exceptions to make it amenable to new test cases
      KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP

Sean Christopherson (5):
      KVM: selftests: Remove unnecessary register shuffling in fix_hypercall_test
      KVM: selftests: Hardcode VMCALL/VMMCALL opcodes in "fix hypercall" test
      KVM: selftests: Explicitly verify KVM doesn't patch hypercall if quirk==off
      KVM: selftests: Dedup subtests of fix_hypercall_test
      Revert "KVM: selftests: Fix nested SVM tests when built with clang"

Vipin Sharma (2):
      KVM: selftests: Check result in hyperv_features for successful hypercalls
      KVM: selftests: Load RAX with -EFAULT before Hyper-V hypercall

Vitaly Kuznetsov (1):
      KVM: selftests: Don't set reserved bits for invalid Hyper-V hypercall number

Wei-Lin Chang (1):
      KVM: arm64: Fix comment typo in nvhe/switch.c

Xiu Jianfeng (1):
      RISC-V: KVM: add __init annotation to riscv_kvm_init()

 Documentation/virt/kvm/api.rst                |  17 +-
 MAINTAINERS                                   |   3 +-
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/arm.c                          |  15 +-
 arch/arm64/kvm/debug.c                        |  34 +++-
 arch/arm64/kvm/guest.c                        |   1 +
 arch/arm64/kvm/handle_exit.c                  |   8 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
 arch/arm64/kvm/sys_regs.c                     | 154 ++++++++--------
 arch/arm64/kvm/sys_regs.h                     |  24 ++-
 arch/arm64/kvm/vgic/vgic-its.c                |   2 +-
 arch/riscv/Kconfig                            |   4 +
 arch/riscv/include/asm/gpr-num.h              |   8 +
 arch/riscv/include/asm/hwcap.h                |   4 +
 arch/riscv/include/asm/insn-def.h             | 137 ++++++++++++++
 arch/riscv/include/asm/kvm_host.h             |   1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h         |   4 +-
 arch/riscv/include/uapi/asm/kvm.h             |   4 +
 arch/riscv/kernel/cpu.c                       |   1 +
 arch/riscv/kernel/cpufeature.c                |   1 +
 arch/riscv/kvm/Kconfig                        |   1 +
 arch/riscv/kvm/main.c                         |   2 +-
 arch/riscv/kvm/tlb.c                          | 155 +++++-----------
 arch/riscv/kvm/vcpu.c                         |  60 ++++---
 arch/riscv/kvm/vcpu_exit.c                    |  39 +---
 arch/riscv/mm/dma-noncoherent.c               |   2 +
 arch/x86/include/asm/kvm_host.h               |  12 +-
 arch/x86/include/asm/vmx.h                    |   2 +-
 arch/x86/kvm/Kconfig                          |   3 +-
 arch/x86/kvm/pmu.c                            |  20 ++-
 arch/x86/kvm/svm/pmu.c                        | 117 ++----------
 arch/x86/kvm/vmx/pmu_intel.c                  |  29 +--
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c   | 169 ++++++++++++++++++
 .../selftests/kvm/aarch64/debug-exceptions.c  | 149 ++++++++++++++-
 .../testing/selftests/kvm/aarch64/psci_test.c |  10 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   8 +-
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 .../testing/selftests/kvm/include/test_util.h |   6 +-
 .../selftests/kvm/include/x86_64/processor.h  |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  44 ++++-
 .../selftests/kvm/lib/x86_64/processor.c      |  40 +++--
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  14 +-
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 122 +++++--------
 .../selftests/kvm/x86_64/hyperv_features.c    |  13 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c |  19 +-
 virt/kvm/Kconfig                              |  14 ++
 virt/kvm/dirty_ring.c                         |   4 +-
 virt/kvm/kvm_main.c                           |   9 +-
 51 files changed, 991 insertions(+), 511 deletions(-)
 create mode 100644 arch/riscv/include/asm/insn-def.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c

diff --cc arch/riscv/kernel/cpu.c
index 87455d12970f,7d1cd653ca02..000000000000
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@@ -90,14 -90,15 +90,15 @@@ int riscv_of_parent_hartid(struct devic
   *    standard extensions. They must be separated from other multi-letter
   *    extensions by an underscore.
   */
  static struct riscv_isa_ext_data isa_ext_arr[] = {
  	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 +	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
++	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
  	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
  	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
  	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
 -	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 -	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
  	__RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
  };
  
  static void print_isa_ext(struct seq_file *f)
  {

