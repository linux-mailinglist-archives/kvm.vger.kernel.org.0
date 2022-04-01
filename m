Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966364EF795
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 18:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiDAQL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 12:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349767AbiDAQJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 12:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5CF5FFB52
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 08:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648827179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=em7/fTw6LvQa2Hc0AbekM+wcT42DD4pAvXBp00DF3Zc=;
        b=gu4psxXDQ8kTA5KE0FmQB32FGfWxv3tJLt70W8/PU3MnB+RbNQ+dySh7z3zy8W4eh2G/OC
        3gdoNcFxnZrPDmS3wHeEGbFX1aVftgF8DJt+3P/i7JuLsTYvACccDSkLebs7w33PinYV6F
        VFJOlw03odCxeaMSb3dkId03DDnG/QY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-70s7NRLpNRatsLonP2aPLw-1; Fri, 01 Apr 2022 11:32:56 -0400
X-MC-Unique: 70s7NRLpNRatsLonP2aPLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 681F78002BF;
        Fri,  1 Apr 2022 15:32:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46F63C07F5D;
        Fri,  1 Apr 2022 15:32:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.18
Date:   Fri,  1 Apr 2022 11:32:56 -0400
Message-Id: <20220401153256.103938-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit c9b8fecddb5bb4b67e351bbaeaa648a6f7456912:

  KVM: use kvcalloc for array allocations (2022-03-21 09:28:41 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d1fb6a1ca3e535f89628193ab94203533b264c8c:

  KVM: x86: fix sending PV IPI (2022-04-01 11:15:52 -0400)

----------------------------------------------------------------
The larger change here is support for in-kernel delivery of Xen events
and timers, but there are also several other smaller features and fixes,
consisting of 1-2 patches each.

* New ioctls to get/set TSC frequency for a whole VM

* Only do MSR filtering for MSRs accessed by rdmsr/wrmsr

* Allow userspace to opt out of hypercall patching

* Documentation improvements

Nested virtualization improvements for AMD:

* Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
  nested vGIF)

* Allow AVIC to co-exist with a nested guest running

* Fixes for LBR virtualizations when a nested guest is running,
  and nested LBR virtualization support

* PAUSE filtering for nested hypervisors

Bugfixes:

* Prevent module exit until all VMs are freed

* PMU Virtualization fixes

* Fix for kvm_irq_delivery_to_apic_fast() NULL-pointer dereferences

* Other miscellaneous bugfixes

Guest support:

* Decoupling of vcpu_is_preempted from PV spinlocks

----------------------------------------------------------------
Boris Ostrovsky (1):
      KVM: x86/xen: handle PV spinlocks slowpath

Dan Carpenter (1):
      KVM: MMU: fix an IS_ERR() vs NULL bug

David Matlack (2):
      KVM: Prevent module exit until all VMs are freed
      Revert "KVM: set owner of cpu and vm file operations"

David Woodhouse (16):
      KVM: avoid double put_page with gfn-to-pfn cache
      KVM: Remove dirty handling from gfn_to_pfn_cache completely
      KVM: x86/xen: Use gfn_to_pfn_cache for runstate area
      KVM: x86: Use gfn_to_pfn_cache for pv_time
      KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info
      KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_time_info
      KVM: x86/xen: Make kvm_xen_set_evtchn() reusable from other places
      KVM: x86/xen: Support direct injection of event channel events
      KVM: x86/xen: Add KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
      KVM: x86/xen: Kernel acceleration for XENVER_version
      KVM: x86/xen: Support per-vCPU event channel upcall via local APIC
      KVM: x86/xen: Advertise and document KVM_XEN_HVM_CONFIG_EVTCHN_SEND
      KVM: x86/xen: Add self tests for KVM_XEN_HVM_CONFIG_EVTCHN_SEND
      KVM: x86/xen: Update self test for Xen PV timers
      KVM: x86: Accept KVM_[GS]ET_TSC_KHZ as a VM ioctl.
      KVM: x86: Test case for TSC scaling and offset sync

Hou Wenlong (3):
      KVM: x86/emulator: Emulate RDPID only if it is enabled in guest
      KVM: x86: Only do MSR filtering when access MSR by rdmsr/wrmsr
      KVM: x86/mmu: Don't rebuild page when the page is synced and no tlb flushing is required

Jim Mattson (2):
      KVM: x86/pmu: Use different raw event masks for AMD and Intel
      KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Joao Martins (3):
      KVM: x86/xen: intercept EVTCHNOP_send from guests
      KVM: x86/xen: handle PV IPI vcpu yield
      KVM: x86/xen: handle PV timers oneshot mode

Jon Kohler (1):
      KVM: x86: optimize PKU branching in kvm_load_{guest|host}_xsave_state

Lai Jiangshan (4):
      KVM: X86: Change the type of access u32 to u64
      KVM: X86: Fix comments in update_permission_bitmask
      KVM: X86: Rename variable smap to not_smap in permission_fault()
      KVM: X86: Handle implicit supervisor access with SMAP

Li RongQing (2):
      KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
      KVM: x86: fix sending PV IPI

Like Xu (2):
      KVM: x86/i8259: Remove a dead store of irq in a conditional block
      KVM: x86/pmu: Fix and isolate TSX-specific performance event logic

Maxim Levitsky (17):
      KVM: x86: nSVM: implement nested VMLOAD/VMSAVE
      KVM: x86: SVM: allow to force AVIC to be enabled
      KVM: x86: mark synthetic SMM vmexit as SVM_EXIT_SW
      KVM: x86: mmu: trace kvm_mmu_set_spte after the new SPTE was set
      KVM: x86: SVM: use vmcb01 in init_vmcb
      kvm: x86: SVM: use vmcb* instead of svm->vmcb where it makes sense
      KVM: x86: SVM: fix avic spec based definitions again
      KVM: x86: SVM: move tsc ratio definitions to svm.h
      kvm: x86: SVM: remove unused defines
      KVM: x86: SVM: fix tsc scaling when the host doesn't support it
      KVM: x86: SVM: remove vgif_enabled()
      KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running
      KVM: x86: nSVM: implement nested LBR virtualization
      KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE
      KVM: x86: nSVM: implement nested vGIF
      KVM: x86: allow per cpu apicv inhibit reasons
      KVM: x86: SVM: allow AVIC to co-exist with a nested guest running

Nathan Chancellor (1):
      KVM: x86: Fix clang -Wimplicit-fallthrough in do_host_cpuid()

Oliver Upton (2):
      KVM: x86: Allow userspace to opt out of hypercall patching
      selftests: KVM: Test KVM_X86_QUIRK_FIX_HYPERCALL_INSN

Paolo Bonzini (10):
      Documentation: kvm: fixes for locking.rst
      Documentation: kvm: include new locks
      Documentation: KVM: add separate directories for architecture-specific documentation
      Documentation: KVM: add virtual CPU errata documentation
      Documentation: KVM: add API issues section
      KVM: MMU: propagate alloc_workqueue failure
      KVM: x86: document limitations of MSR filtering
      KVM: MIPS: remove reference to trap&emulate virtualization
      x86, kvm: fix compilation for !CONFIG_PARAVIRT_SPINLOCKS or !CONFIG_SMP
      KVM: x86/mmu: do compare-and-exchange of gPTE via the user address

Peter Gonda (1):
      KVM: SVM: Fix kvm_cache_regs.h inclusions for is_guest_mode()

Sean Christopherson (7):
      KVM: x86/mmu: Zap only TDP MMU leafs in zap range and mmu_notifier unmap
      KVM: Don't actually set a request when evicting vCPUs for GFN cache invd
      KVM: Use enum to track if cached PFN will be used in guest and/or host
      KVM: x86: Make APICv inhibit reasons an enum and cleanup naming
      KVM: x86: Add wrappers for setting/clearing APICv inhibits
      KVM: x86: Trace all APICv inhibit changes and capture overall status
      KVM: x86: Don't snapshot "max" TSC if host TSC is constant

Vitaly Kuznetsov (3):
      KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
      KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
      KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Yi Wang (1):
      KVM: SVM: fix panic on out-of-bounds guest IRQ

Zeng Guang (1):
      KVM: VMX: Prepare VMCS setting for posted interrupt enabling when APICv is available

Zhenzhong Duan (2):
      KVM: x86: cleanup enter_rmode()
      KVM: x86: Remove redundant vm_entry_controls_clearbit() call

 Documentation/virt/kvm/api.rst                     |  210 +++-
 Documentation/virt/kvm/index.rst                   |   26 +-
 Documentation/virt/kvm/locking.rst                 |   43 +-
 Documentation/virt/kvm/s390/index.rst              |   12 +
 Documentation/virt/kvm/{ => s390}/s390-diag.rst    |    0
 Documentation/virt/kvm/{ => s390}/s390-pv-boot.rst |    0
 Documentation/virt/kvm/{ => s390}/s390-pv.rst      |    0
 Documentation/virt/kvm/vcpu-requests.rst           |   10 +
 .../virt/kvm/{ => x86}/amd-memory-encryption.rst   |    0
 Documentation/virt/kvm/{ => x86}/cpuid.rst         |    0
 Documentation/virt/kvm/x86/errata.rst              |   39 +
 Documentation/virt/kvm/{ => x86}/halt-polling.rst  |    0
 Documentation/virt/kvm/{ => x86}/hypercalls.rst    |    0
 Documentation/virt/kvm/x86/index.rst               |   19 +
 Documentation/virt/kvm/{ => x86}/mmu.rst           |    0
 Documentation/virt/kvm/{ => x86}/msr.rst           |    0
 Documentation/virt/kvm/{ => x86}/nested-vmx.rst    |    0
 .../virt/kvm/{ => x86}/running-nested-guests.rst   |    0
 Documentation/virt/kvm/{ => x86}/timekeeping.rst   |    0
 arch/s390/kvm/kvm-s390.c                           |    2 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    1 +
 arch/x86/include/asm/kvm_host.h                    |   80 +-
 arch/x86/include/asm/svm.h                         |   14 +-
 arch/x86/include/uapi/asm/kvm.h                    |   11 +-
 arch/x86/kernel/asm-offsets_64.c                   |    4 +-
 arch/x86/kernel/kvm.c                              |   77 +-
 arch/x86/kvm/cpuid.c                               |    1 +
 arch/x86/kvm/emulate.c                             |    8 +-
 arch/x86/kvm/hyperv.c                              |   22 +-
 arch/x86/kvm/i8254.c                               |    6 +-
 arch/x86/kvm/i8259.c                               |    1 -
 arch/x86/kvm/irq.c                                 |   10 +-
 arch/x86/kvm/irq_comm.c                            |    2 +-
 arch/x86/kvm/kvm_emulate.h                         |    3 +
 arch/x86/kvm/lapic.c                               |    4 +
 arch/x86/kvm/mmu.h                                 |   32 +-
 arch/x86/kvm/mmu/mmu.c                             |   45 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   82 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   72 +-
 arch/x86/kvm/mmu/tdp_mmu.h                         |   12 +-
 arch/x86/kvm/pmu.c                                 |   18 +-
 arch/x86/kvm/svm/avic.c                            |   24 +-
 arch/x86/kvm/svm/nested.c                          |  297 +++--
 arch/x86/kvm/svm/pmu.c                             |    9 +-
 arch/x86/kvm/svm/svm.c                             |  239 ++--
 arch/x86/kvm/svm/svm.h                             |   68 +-
 arch/x86/kvm/svm/svm_onhyperv.c                    |    1 -
 arch/x86/kvm/trace.h                               |   22 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   14 +-
 arch/x86/kvm/vmx/vmx.c                             |   28 +-
 arch/x86/kvm/x86.c                                 |  372 +++---
 arch/x86/kvm/xen.c                                 | 1253 ++++++++++++++++----
 arch/x86/kvm/xen.h                                 |   62 +-
 include/linux/kvm_host.h                           |   63 +-
 include/linux/kvm_types.h                          |   11 +-
 include/uapi/linux/kvm.h                           |   48 +-
 tools/testing/selftests/kvm/.gitignore             |    1 +
 tools/testing/selftests/kvm/Makefile               |    2 +
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |  170 +++
 .../selftests/kvm/x86_64/tsc_scaling_sync.c        |  119 ++
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  366 +++++-
 virt/kvm/kvm_main.c                                |   22 +-
 virt/kvm/pfncache.c                                |   72 +-
 63 files changed, 3157 insertions(+), 972 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/index.rst
 rename Documentation/virt/kvm/{ => s390}/s390-diag.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv-boot.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/amd-memory-encryption.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/cpuid.rst (100%)
 create mode 100644 Documentation/virt/kvm/x86/errata.rst
 rename Documentation/virt/kvm/{ => x86}/halt-polling.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/hypercalls.rst (100%)
 create mode 100644 Documentation/virt/kvm/x86/index.rst
 rename Documentation/virt/kvm/{ => x86}/mmu.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/msr.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/nested-vmx.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/running-nested-guests.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/timekeeping.rst (100%)
 create mode 100644 tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c

