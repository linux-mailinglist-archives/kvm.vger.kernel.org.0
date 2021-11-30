Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A82E463C5F
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 17:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbhK3RBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 12:01:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231626AbhK3RBD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 12:01:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638291463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o3GqI+aQzSaZmc8uceGxj8T0XIl/xXTBH7K23L4gwg8=;
        b=aHUYZGzqQrrFehdTo85n9NLRFCqd6+VHG8vFBx2feWFucolCqTTbwmNfo2NYEcTlkny3Py
        7D4So7z7qaA9fgszy29+PADHVYfyajXnCI++EDqV2wXPfnvGm1oPL4obnxXZyirGi2y9xN
        xxct0wnNRZfonvirhzcI1AJrFkdAxC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-8fA2DhY6Nta_OeExNDqJGw-1; Tue, 30 Nov 2021 11:57:40 -0500
X-MC-Unique: 8fA2DhY6Nta_OeExNDqJGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4014B1006AAC;
        Tue, 30 Nov 2021 16:57:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E452B76612;
        Tue, 30 Nov 2021 16:57:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.16-rc4
Date:   Tue, 30 Nov 2021 11:57:38 -0500
Message-Id: <20211130165738.358058-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 7cfc5c653b07782e7059527df8dc1e3143a7591e:

  KVM: fix avic_set_running for preemptable kernels (2021-11-30 07:40:48 -0500)

----------------------------------------------------------------
ARM64:

* Fix constant sign extension affecting TCR_EL2 and preventing
running on ARMv8.7 models due to spurious bits being set

* Fix use of helpers using PSTATE early on exit by always sampling
it as soon as the exit takes place

* Move pkvm's 32bit handling into a common helper

RISC-V:

* Fix incorrect KVM_MAX_VCPUS value

* Unmap stage2 mapping when deleting/moving a memslot

x86:

* Fix and downgrade BUG_ON due to uninitialized cache

* Many APICv and MOVE_ENC_CONTEXT_FROM fixes

* Correctly emulate TLB flushes around nested vmentry/vmexit
and when the nested hypervisor uses VPID

* Prevent modifications to CPUID after the VM has run

* Other smaller bugfixes

Generic:

* Memslot handling bugfixes

----------------------------------------------------------------
This is the large bugfix pull request that I mentioned just before rc2,
with the APICv and MOVE_ENC_CONTEXT_FROM/COPY_ENC_CONTEXT_FROM bug
shakedown.  It missed rc3 due to Thanksgiving (half of the patches
are mine and I wanted to get reviews on them for obvious reasons).

Thanks,

Paolo

Anup Patel (1):
      RISC-V: KVM: Fix incorrect KVM_MAX_VCPUS value

Ben Gardon (1):
      KVM: x86/mmu: Fix TLB flush range when handling disconnected pt

Catalin Marinas (1):
      KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1

Hou Wenlong (2):
      KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()
      KVM: x86/mmu: Pass parameter flush as false in kvm_tdp_mmu_zap_collapsible_sptes()

Juergen Gross (1):
      x86/kvm: remove unused ack_notifier callbacks

Lai Jiangshan (2):
      KVM: X86: Fix when shadow_root_level=5 && guest root_level<4
      KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()

Maciej S. Szmigiero (1):
      KVM: selftests: page_table_test: fix calculation of guest_test_phys_mem

Marc Zyngier (2):
      KVM: arm64: Save PSTATE early on exit
      KVM: arm64: Move pkvm's special 32bit handling into a generic infrastructure

Paolo Bonzini (24):
      Merge tag 'kvm-riscv-fixes-5.16-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-fixes-5.16-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge branch 'kvm-5.16-fixes-pre-rc2' into HEAD
      KVM: VMX: do not use uninitialized gfn_to_hva_cache
      KVM: downgrade two BUG_ONs to WARN_ON_ONCE
      KVM: x86: ignore APICv if LAPIC is not enabled
      selftests: fix check for circular KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
      selftests: sev_migrate_tests: free all VMs
      KVM: SEV: expose KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM capability
      KVM: MMU: shadow nested paging does not have PKU
      KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
      KVM: x86: check PIR even for vCPUs with disabled APICv
      KVM: x86: Use a stable condition around all VT-d PI paths
      KVM: SEV: do not use list_replace_init on an empty list
      KVM: SEV: cleanup locking for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
      KVM: SEV: initialize regions_list of a mirror VM
      KVM: SEV: move mirror status to destination of KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
      selftests: sev_migrate_tests: add tests for KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
      KVM: SEV: Do COPY_ENC_CONTEXT_FROM with both VMs locked
      KVM: SEV: Prohibit migration of a VM that has mirrors
      KVM: SEV: do not take kvm->lock when destroying
      KVM: SEV: accept signals in sev_lock_two_vms
      KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled
      KVM: fix avic_set_running for preemptable kernels

Sean Christopherson (9):
      KVM: Ensure local memslot copies operate on up-to-date arch-specific data
      KVM: Disallow user memslot with size that exceeds "unsigned long"
      KVM: RISC-V: Unmap stage2 mapping when deleting/moving a memslot
      KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST
      KVM: nVMX: Abide to KVM_REQ_TLB_FLUSH_GUEST request on nested vmentry/vmexit
      KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with new vpid12
      KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU notifier unmapping
      KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU zap collapsible path
      KVM: x86/mmu: Handle "default" period when selectively waking kthread

Vitaly Kuznetsov (3):
      KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in hyperv_features test
      KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
      KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE

 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  14 ++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |   7 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   8 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   4 +
 arch/riscv/include/asm/kvm_host.h                  |   8 +-
 arch/riscv/kvm/mmu.c                               |   6 +
 arch/x86/kvm/ioapic.h                              |   1 -
 arch/x86/kvm/irq.h                                 |   1 -
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  97 ++++++------
 arch/x86/kvm/mmu/tdp_mmu.c                         |  38 ++---
 arch/x86/kvm/mmu/tdp_mmu.h                         |   5 +-
 arch/x86/kvm/svm/avic.c                            |  16 +-
 arch/x86/kvm/svm/sev.c                             | 161 ++++++++++----------
 arch/x86/kvm/svm/svm.c                             |   1 -
 arch/x86/kvm/svm/svm.h                             |   1 +
 arch/x86/kvm/vmx/nested.c                          |  49 +++---
 arch/x86/kvm/vmx/posted_intr.c                     |  20 +--
 arch/x86/kvm/vmx/vmx.c                             |  66 +++++----
 arch/x86/kvm/x86.c                                 |  66 +++++++--
 arch/x86/kvm/x86.h                                 |   7 +-
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |  30 ++++
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   2 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c | 140 ++++++++---------
 .../selftests/kvm/x86_64/sev_migrate_tests.c       | 165 +++++++++++++++++++--
 virt/kvm/kvm_main.c                                |  56 ++++---
 27 files changed, 623 insertions(+), 352 deletions(-)

