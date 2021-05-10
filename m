Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057063796DC
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 20:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhEJSPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 14:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbhEJSPv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 14:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620670485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DpuazqPXEj5SkAFURKacNphDW7TZ+kvKc2tK8caPseU=;
        b=Cxeyzr97BUqd7oCdqKCClBsQSC6I+Hqj5gjyqOiekF9zTBtSgCftXmahP2pKCpfAz5gGqM
        gbOAQ+QHF+YaN1PK5xOnGnHP7Qi5BDfirYIASGEt7XmhHuQt5LaLZK1pZmV8O15Fx8tpOR
        QZU9adZsvsR7vBbcfx/v1jAatBcXLuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-Pei9L6tuNg6vPzbftl4s-Q-1; Mon, 10 May 2021 14:14:43 -0400
X-MC-Unique: Pei9L6tuNg6vPzbftl4s-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 983BA195D560;
        Mon, 10 May 2021 18:14:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A18D14103;
        Mon, 10 May 2021 18:14:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM updates for Linux 5.13-rc2
Date:   Mon, 10 May 2021 14:14:41 -0400
Message-Id: <20210510181441.351452-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9ccce092fc64d19504fa54de4fd659e279cc92e7:

  Merge tag 'for-linus-5.13-ofs-1' of git://git.kernel.org/pub/scm/linux/kernel/git/hubcap/linux (2021-05-02 14:13:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to ce7ea0cfdc2e9ff31d12da31c3226deddb9644f5:

  KVM: SVM: Move GHCB unmapping to fix RCU warning (2021-05-07 06:06:23 -0400)

Thomas Gleixner and Michael Ellerman had some KVM changes in their
late merge window pull requests, but there are no conflicts.

----------------------------------------------------------------
* Lots of bug fixes.

* Fix virtualization of RDPID

* Virtualization of DR6_BUS_LOCK, which on bare metal is new in
  the 5.13 merge window

* More nested virtualization migration fixes (nSVM and eVMCS)

* Fix for KVM guest hibernation

* Fix for warning in SEV-ES SRCU usage

* Block KVM from loading on AMD machines with 5-level page tables,
  due to the APM not mentioning how host CR4.LA57 exactly impacts
  the guest.

----------------------------------------------------------------
Benjamin Segall (1):
      kvm: exit halt polling on need_resched() as well

Bill Wendling (1):
      selftests: kvm: remove reassignment of non-absolute variables

Chenyi Qiang (1):
      KVM: X86: Add support for the emulation of DR6_BUS_LOCK bit

Colin Ian King (1):
      KVM: x86: Fix potential fput on a null source_kvm_file

David Matlack (1):
      kvm: Cap halt polling at kvm->max_halt_poll_ns

Kai Huang (2):
      KVM: x86/mmu: Avoid unnecessary page table allocation in kvm_tdp_mmu_map()
      KVM: x86/mmu: Fix kdoc of __handle_changed_spte

Maxim Levitsky (5):
      KVM: nSVM: fix a typo in svm_leave_nested
      KVM: nSVM: fix few bugs in the vmcb02 caching logic
      KVM: nSVM: leave the guest mode prior to loading a nested state
      KVM: nSVM: always restore the L1's GIF on migration
      KVM: nSVM: remove a warning about vmcb01 VM exit reason

Nicholas Piggin (1):
      KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU notifier callbacks

Paolo Bonzini (1):
      KVM: X86: Expose bus lock debug exception to guest

Sean Christopherson (17):
      KVM: VMX: Do not advertise RDPID if ENABLE_RDTSCP control is unsupported
      KVM: x86: Emulate RDPID only if RDTSCP is supported
      KVM: SVM: Inject #UD on RDTSCP when it should be disabled in the guest
      KVM: x86: Move RDPID emulation intercept to its own enum
      KVM: VMX: Disable preemption when probing user return MSRs
      KVM: SVM: Probe and load MSR_TSC_AUX regardless of RDTSCP support in host
      KVM: x86: Add support for RDPID without RDTSCP
      KVM: VMX: Configure list of user return MSRs at module init
      KVM: VMX: Use flag to indicate "active" uret MSRs instead of sorting list
      KVM: VMX: Use common x86's uret MSR list as the one true list
      KVM: VMX: Disable loading of TSX_CTRL MSR the more conventional way
      KVM: x86: Export the number of uret MSRs to vendor modules
      KVM: x86: Move uret MSR slot management to common x86
      KVM: x86: Tie Intel and AMD behavior for MSR_TSC_AUX to guest CPU model
      KVM: x86: Hide RDTSCP and RDPID if MSR_TSC_AUX probing failed
      KVM: x86: Prevent KVM SVM from loading on kernels with 5-level paging
      KVM: SVM: Invert user pointer casting in SEV {en,de}crypt helpers

Shahin, Md Shahadat Hossain (1):
      kvm/x86: Fix 'lpages' kvm stat for TDM MMU

Siddharth Chandrasekaran (2):
      doc/kvm: Fix wrong entry for KVM_CAP_X86_MSR_FILTER
      KVM: x86: Hoist input checks in kvm_add_msr_filter()

Stefan Raspl (1):
      tools/kvm_stat: Fix documentation typo

Thomas Gleixner (2):
      KVM: x86: Cancel pvclock_gtod_work on module removal
      KVM: x86: Prevent deadlock against tk_core.seq

Tom Lendacky (1):
      KVM: SVM: Move GHCB unmapping to fix RCU warning

Vitaly Kuznetsov (9):
      x86/kvm: Fix pr_info() for async PF setup/teardown
      x86/kvm: Teardown PV features on boot CPU as well
      x86/kvm: Disable kvmclock on all CPUs on shutdown
      x86/kvm: Disable all PV features on crash
      x86/kvm: Unify kvm_pv_guest_cpu_reboot() with kvm_guest_cpu_offline()
      KVM: nVMX: Always make an attempt to map eVMCS after migration
      KVM: selftests: evmcs_test: Check that VMLAUNCH with bogus EVMPTR is causing #UD
      KVM: selftests: evmcs_test: Check that VMCS12 is alway properly synced to eVMCS after restore
      KVM: nVMX: Properly pad 'struct kvm_vmx_nested_state_hdr'

Wanpeng Li (1):
      KVM: LAPIC: Accurately guarantee busy wait for timer to expire when using hv_timer

 Documentation/virt/kvm/api.rst                    |   4 +-
 arch/powerpc/include/asm/kvm_book3s.h             |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c               |  46 +++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c            |   5 +-
 arch/x86/include/asm/kvm_host.h                   |  15 +-
 arch/x86/include/asm/kvm_para.h                   |  10 +-
 arch/x86/include/uapi/asm/kvm.h                   |   2 +
 arch/x86/kernel/kvm.c                             | 129 ++++++++-----
 arch/x86/kernel/kvmclock.c                        |  26 +--
 arch/x86/kvm/cpuid.c                              |  20 +-
 arch/x86/kvm/emulate.c                            |   2 +-
 arch/x86/kvm/kvm_emulate.h                        |   1 +
 arch/x86/kvm/lapic.c                              |   2 +-
 arch/x86/kvm/mmu/mmu.c                            |  20 +-
 arch/x86/kvm/mmu/tdp_mmu.c                        |  17 +-
 arch/x86/kvm/svm/nested.c                         |  23 ++-
 arch/x86/kvm/svm/sev.c                            |  32 ++--
 arch/x86/kvm/svm/svm.c                            |  62 +++---
 arch/x86/kvm/svm/svm.h                            |   1 +
 arch/x86/kvm/vmx/capabilities.h                   |   3 +
 arch/x86/kvm/vmx/nested.c                         |  29 ++-
 arch/x86/kvm/vmx/vmx.c                            | 220 +++++++++++-----------
 arch/x86/kvm/vmx/vmx.h                            |  12 +-
 arch/x86/kvm/x86.c                                | 153 +++++++++++----
 tools/kvm/kvm_stat/kvm_stat.txt                   |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/handlers.S |   4 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c   |  88 +++++++--
 virt/kvm/kvm_main.c                               |   7 +-
 28 files changed, 578 insertions(+), 359 deletions(-)

