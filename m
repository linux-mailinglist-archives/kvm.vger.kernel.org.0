Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27684197F5
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbhI0Pb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:31:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234158AbhI0Pb3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 11:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632756591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mENHZjQ+BALjyt1DdN0jTcrXlMqP2xXYUM+xHN7USJE=;
        b=Vq2RJwsokchTKOiS9jcXkbS1KGcu8O22ecfs6m0FGmYbm3Tqqx5SErYAJcGjwCl3Ff65f+
        6hUeO2WYQ0psUIzE1+zwDfIKFEHwzrtbsz0MISPoU83/rMUHh1Qv0uILoOaxTP2IEarTma
        7BmkxXlGnsYjFvK5qZfTJCOTRsUhmc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-cmZ11cD5MK61XX14reloTA-1; Mon, 27 Sep 2021 11:29:49 -0400
X-MC-Unique: cmZ11cD5MK61XX14reloTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 790EC180830E;
        Mon, 27 Sep 2021 15:29:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 293B05C261;
        Mon, 27 Sep 2021 15:29:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] (Many) KVM fixes for 5.15-rc4
Date:   Mon, 27 Sep 2021 11:29:47 -0400
Message-Id: <20210927152947.532485-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 2da4a23599c263bd4a7658c2fe561cb3a73ea6ae:

  KVM: selftests: Remove __NR_userfaultfd syscall fallback (2021-09-22 10:24:02 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 50b078184604fea95adbb144ff653912fb0e48c6:

  Merge tag 'kvmarm-fixes-5.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2021-09-24 06:04:42 -0400)

----------------------------------------------------------------
x86:

- missing TLB flush

- nested virtualization fixes for SMM (secure boot on nested hypervisor)
  and other nested SVM fixes

- syscall fuzzing fixes

- live migration fix for AMD SEV

- mirror VMs now work for SEV-ES too

- fixes for reset

- possible out-of-bounds access in IOAPIC emulation

- fix enlightened VMCS on Windows 2022

ARM:

- Add missing FORCE target when building the EL2 object

- Fix a PMU probe regression on some platforms

Generic:

- KCSAN fixes

selftests:

- random fixes, mostly for clang compilation

----------------------------------------------------------------

A bit late...  I got sidetracked by back-from-vacation routines first and
conferences second.  But most of these patches are already a few weeks
old and things look more calm on the mailing list than what this pull
request would suggest.

Paolo

Chenyi Qiang (1):
      KVM: nVMX: Fix nested bus lock VM exit

David Matlack (3):
      KVM: selftests: Change backing_src flag to -s in demand_paging_test
      KVM: selftests: Refactor help message for -s backing_src
      KVM: selftests: Create a separate dirty bitmap per slot

Fares Mehanna (1):
      kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]

Haimin Zhang (1):
      KVM: x86: Handle SRCU initialization failure during page track init

Hou Wenlong (1):
      kvm: fix wrong exception emulation in check_rdtsc

Lai Jiangshan (3):
      KVM: X86: Fix missed remote tlb flush in rmap_write_protect()
      KVM: X86: Synchronize the shadow pagetable before link it
      KVM: Remove tlbs_dirty

Marc Zyngier (1):
      KVM: arm64: Fix PMU probe ordering

Maxim Levitsky (11):
      KVM: x86: nSVM: restore the L1 host state prior to resuming nested guest on SMM exit
      KVM: x86: reset pdptrs_from_userspace when exiting smm
      KVM: x86: SVM: call KVM_REQ_GET_NESTED_STATE_PAGES on exit from SMM mode
      KVM: x86: nSVM: refactor svm_leave_smm and smm_enter_smm
      KVM: x86: VMX: synthesize invalid VM exit when emulating invalid guest state
      KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry
      KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
      KVM: x86: nSVM: restore int_vector in svm_clear_vintr
      KVM: x86: selftests: test simultaneous uses of V_IRQ from L1 and L0
      KVM: x86: nSVM: test eax for 4K alignment for GP errata workaround
      KVM: x86: nSVM: don't copy virt_ext from vmcb12

Mingwei Zhang (1):
      KVM: SVM: fix missing sev_decommission in sev_receive_start

Oliver Upton (4):
      selftests: KVM: Fix check for !POLLIN in demand_paging_test
      selftests: KVM: Align SMCCC call with the spec in steal_time
      selftests: KVM: Call ucall_init when setting up in rseq_test
      selftests: KVM: Explicitly use movq to read xmm registers

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-5.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master

Peter Gonda (3):
      KVM: SEV: Acquire vcpu mutex when updating VMSA
      KVM: SEV: Update svm_vm_copy_asid_from for SEV-ES
      KVM: SEV: Allow some commands for mirror VM

Sean Christopherson (8):
      KVM: x86: Mark all registers as avail/dirty at vCPU creation
      KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT
      KVM: VMX: Remove defunct "nr_active_uret_msrs" field
      KVM: SEV: Pin guest memory for write for RECEIVE_UPDATE_DATA
      KVM: x86: Query vcpu->vcpu_idx directly and drop its accessor
      KVM: x86: Identify vCPU0 by its vcpu_idx instead of its vCPUs array entry
      KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
      KVM: KVM: Use cpumask_available() to check for NULL cpumask when kicking vCPUs

Sergey Senozhatsky (1):
      KVM: do not shrink halt_poll_ns below grow_start

Vitaly Kuznetsov (2):
      KVM: x86: Fix stack-out-of-bounds memory access from ioapic_write_indirect()
      KVM: nVMX: Filter out all unsupported controls when eVMCS was activated

Yu Zhang (1):
      KVM: nVMX: fix comments of handle_vmon()

Zenghui Yu (1):
      KVM: arm64: nvhe: Fix missing FORCE for hyp-reloc.S build rule

 arch/arm64/kvm/hyp/nvhe/Makefile                   |   2 +-
 arch/arm64/kvm/perf.c                              |   3 -
 arch/arm64/kvm/pmu-emul.c                          |   9 +-
 arch/s390/kvm/interrupt.c                          |   4 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/x86/include/asm/kvm_page_track.h              |   2 +-
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/hyperv.c                              |   7 +-
 arch/x86/kvm/hyperv.h                              |   2 +-
 arch/x86/kvm/ioapic.c                              |  10 +-
 arch/x86/kvm/mmu/mmu.c                             |  17 +--
 arch/x86/kvm/mmu/page_track.c                      |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |  46 +++----
 arch/x86/kvm/svm/nested.c                          |  10 +-
 arch/x86/kvm/svm/sev.c                             |  92 +++++++++-----
 arch/x86/kvm/svm/svm.c                             | 137 +++++++++++----------
 arch/x86/kvm/svm/svm.h                             |   3 +-
 arch/x86/kvm/vmx/evmcs.c                           |  12 +-
 arch/x86/kvm/vmx/nested.c                          |  24 ++--
 arch/x86/kvm/vmx/vmx.c                             |  37 ++++--
 arch/x86/kvm/vmx/vmx.h                             |   5 +-
 arch/x86/kvm/x86.c                                 |  28 ++++-
 drivers/perf/arm_pmu.c                             |   2 +
 include/kvm/arm_pmu.h                              |   3 -
 include/linux/kvm_host.h                           |   6 -
 include/linux/perf/arm_pmu.h                       |   6 +
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../selftests/kvm/access_tracking_perf_test.c      |   6 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |  15 ++-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  62 +++++++---
 tools/testing/selftests/kvm/include/test_util.h    |   4 +-
 .../selftests/kvm/include/x86_64/processor.h       |  34 ++---
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   7 +-
 tools/testing/selftests/kvm/lib/test_util.c        |  17 ++-
 tools/testing/selftests/kvm/rseq_test.c            |   1 +
 tools/testing/selftests/kvm/steal_time.c           |   4 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c        | 128 +++++++++++++++++++
 virt/kvm/kvm_main.c                                |  68 +++++++---
 40 files changed, 556 insertions(+), 269 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c

