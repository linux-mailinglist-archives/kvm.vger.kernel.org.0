Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C92455C40
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhKRNJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:09:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232076AbhKRNHy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:07:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637240694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HfwzmZ2MobkyIwIWDidcjJ0MnhsOQZdWqx5zBnctuJM=;
        b=ZnQx7iYH0ilEVWeoDmSKa62sCHfdtoyZA+imDMxWFnkP6FaAE0TcfYIhGQFbktPxW/1Wil
        ENaz70kV0L6GLbF8UxPQvIQCfpoVumiNj4694ZutoXnDCZmjmghzhszT5pAF8TWUAug611
        qLOaYkgloUV8lZ6AMOZVCP6FMwRWs0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-kUm77ADvNiuIYixwmqm2Gw-1; Thu, 18 Nov 2021 08:04:50 -0500
X-MC-Unique: kUm77ADvNiuIYixwmqm2Gw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAED5100CD00;
        Thu, 18 Nov 2021 13:04:49 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B9F2604CC;
        Thu, 18 Nov 2021 13:04:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.16-rc2
Date:   Thu, 18 Nov 2021 08:04:49 -0500
Message-Id: <20211118130449.71796-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 84886c262ebcfa40751ed508268457af8a20c1aa:

  Merge tag 'kvmarm-fixes-5.16-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2021-11-12 16:01:55 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2845e7353bc334d43309f5ea6d376c8fdbc94c93:

  KVM: x86: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS (2021-11-18 02:12:15 -0500)

----------------------------------------------------------------
Selftest changes:

* Cleanups for the perf test infrastructure and mapping hugepages

* Avoid contention on mmap_sem when the guests start to run

* Add event channel upcall support to xen_shinfo_test

x86 changes:

* Fixes for Xen emulation

* Kill kvm_map_gfn() / kvm_unmap_gfn() and broken gfn_to_pfn_cache

* Fixes for migration of 32-bit nested guests on 64-bit hypervisor

* Compilation fixes

* More SEV cleanups

Generic:

* Cap the return value of KVM_CAP_NR_VCPUS to both KVM_CAP_MAX_VCPUS
and num_online_cpus().  Most architectures were only using one of the two.

----------------------------------------------------------------

I'll say in advance that I will have another largish pull request in rc3;
it's mostly due to a lot of review and new tests happening at the same
time and uncovering a bunch of related bugs.  The gfn_to_pfn_cache thing
in the changelog above is one, next week I should finish preparing fixes
for APICv (old code) and SEV (new code).  But after that, things should
calm down as the attention should shift to 5.17.

Paolo

Arnaldo Carvalho de Melo (1):
      selftests: KVM: Add /x86_64/sev_migrate_tests to .gitignore

David Matlack (4):
      KVM: selftests: Start at iteration 0 instead of -1
      KVM: selftests: Move vCPU thread creation and joining to common helpers
      KVM: selftests: Wait for all vCPU to be created before entering guest mode
      KVM: selftests: Use perf_test_destroy_vm in memslot_modification_stress_test

David Woodhouse (8):
      KVM: selftests: Add event channel upcall support to xen_shinfo_test
      KVM: Fix steal time asm constraints
      KVM: x86/xen: Fix get_attr of KVM_XEN_ATTR_TYPE_SHARED_INFO
      KVM: nVMX: Use kvm_{read,write}_guest_cached() for shadow_vmcs12
      KVM: x86/xen: Use sizeof_field() instead of open-coding it
      KVM: nVMX: Use kvm_read_guest_offset_cached() for nested VMCS check
      KVM: nVMX: Use a gfn_to_hva_cache for vmptrld
      KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache

Maxim Levitsky (2):
      KVM: nVMX: don't use vcpu->arch.efer when checking host state on nested state load
      KVM: x86/mmu: include EFER.LMA in extended mmu role

Paolo Bonzini (2):
      Merge branch 'kvm-selftest' into kvm-master
      Merge branch 'kvm-5.16-fixes' into kvm-master

Paul Durrant (1):
      cpuid: kvm_find_kvm_cpuid_features() should be declared 'static'

Randy Dunlap (1):
      riscv: kvm: fix non-kernel-doc comment block

Sean Christopherson (17):
      KVM: selftests: Explicitly state indicies for vm_guest_mode_params array
      KVM: selftests: Expose align() helpers to tests
      KVM: selftests: Assert mmap HVA is aligned when using HugeTLB
      KVM: selftests: Require GPA to be aligned when backed by hugepages
      KVM: selftests: Use shorthand local var to access struct perf_tests_args
      KVM: selftests: Capture per-vCPU GPA in perf_test_vcpu_args
      KVM: selftests: Use perf util's per-vCPU GPA/pages in demand paging test
      KVM: selftests: Move per-VM GPA into perf_test_args
      KVM: selftests: Remove perf_test_args.host_page_size
      KVM: selftests: Create VM with adjusted number of guest pages for perf tests
      KVM: selftests: Fill per-vCPU struct during "perf_test" VM creation
      KVM: selftests: Sync perf_test_args to guest during VM creation
      KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target has created vCPUs
      KVM: SEV: Set sev_info.active after initial checks in sev_guest_init()
      KVM: SEV: WARN if SEV-ES is marked active but SEV is not
      KVM: SEV: Drop a redundant setting of sev->asid during initialization
      KVM: SEV: Fix typo in and tweak name of cmd_allowed_from_miror()

Tom Lendacky (1):
      KVM: x86: Assume a 64-bit hypercall for guests with protected state

Vitaly Kuznetsov (6):
      KVM: arm64: Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
      KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
      KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
      KVM: RISC-V: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
      KVM: s390: Cap KVM_CAP_NR_VCPUS by num_online_cpus()
      KVM: x86: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS

黄乐 (1):
      KVM: x86: Fix uninitialized eoi_exit_bitmap usage in vcpu_load_eoi_exitmap()

 arch/arm64/kvm/arm.c                               |   9 +-
 arch/mips/kvm/mips.c                               |   2 +-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   2 +-
 arch/riscv/kvm/vm.c                                |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kvm/cpuid.c                               |   2 +-
 arch/x86/kvm/hyperv.c                              |   4 +-
 arch/x86/kvm/mmu/mmu.c                             |   1 +
 arch/x86/kvm/svm/sev.c                             |  18 +-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  98 +++++++----
 arch/x86/kvm/vmx/vmx.h                             |  10 ++
 arch/x86/kvm/x86.c                                 |  18 +-
 arch/x86/kvm/x86.h                                 |  12 ++
 arch/x86/kvm/xen.c                                 |  22 +--
 include/linux/kvm_host.h                           |   6 +-
 include/linux/kvm_types.h                          |   7 -
 tools/testing/selftests/kvm/.gitignore             |   1 +
 .../selftests/kvm/access_tracking_perf_test.c      |  54 ++----
 tools/testing/selftests/kvm/demand_paging_test.c   |  56 +------
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  29 +---
 tools/testing/selftests/kvm/dirty_log_test.c       |   6 +-
 .../testing/selftests/kvm/include/perf_test_util.h |  23 ++-
 tools/testing/selftests/kvm/include/test_util.h    |  26 +++
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   2 +-
 tools/testing/selftests/kvm/lib/elf.c              |   3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  44 ++---
 tools/testing/selftests/kvm/lib/perf_test_util.c   | 184 +++++++++++++++------
 tools/testing/selftests/kvm/lib/test_util.c        |   5 +
 .../kvm/memslot_modification_stress_test.c         |  38 +----
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  75 ++++++++-
 virt/kvm/kvm_main.c                                | 100 ++---------
 34 files changed, 461 insertions(+), 407 deletions(-)

