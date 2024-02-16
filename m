Return-Path: <kvm+bounces-8886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6ED085839D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EBF21F242F2
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 17:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45D4131E52;
	Fri, 16 Feb 2024 17:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GlNdL4KP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFC0130E4F
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708103440; cv=none; b=t8GUBjRgM+gWbPiC/kPLTd6AcPWI7EgwQS9QZPUoQ1vYTWWB6cfPPyRBUQgo5A+7gkyVPoNUZ/HGGl6wuxHgx8IwR7O2C2DVJP4KPS/YHf257fdLdbJCtMitanmEivuvoKDi7IOh3A9PcG02TBEoHApLTJkkusj+68QmIuEfkr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708103440; c=relaxed/simple;
	bh=Qb/cffHRD7eH7TywIvhozOLCYtKKMQjojU9VPyw+v+k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iVQOhmyjeSqy8htmbrOIsa5NfSTIYewb60D0qc/zydInJnhpg9x3Y/kdtluHcjHWd51ynOM9yxyAz+BaePak8BAIft898OvNUoKLOf2gk+ym/gWlbgWVYk5pHu679gwdNVHAbs3eGVKx75VepFFLJvkXzJm3PLxRrXtykeK5qg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GlNdL4KP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708103436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6Ii0Q1pQtZuRQ3mM3g3FAo2+zpYotLJDehy5Xa9J8kg=;
	b=GlNdL4KPehYcBd43vyTUHYJ0DpmoKfEi6+OxdghW7m/wRUSyARaojLh0nUJz0ryiUXG6Zz
	5w3B5RbEyigud8mT8d4fW8OQh30mKXV7xYIdxaVElb/7ltzh5LNkRr1m9rXja5OvoEx3+S
	hJne61q4vEoMf+tKqEbl/4B65oH96Jw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-_L2kYD-PN7y0ildATIRTBg-1; Fri, 16 Feb 2024 12:10:31 -0500
X-MC-Unique: _L2kYD-PN7y0ildATIRTBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11722185A781;
	Fri, 16 Feb 2024 17:10:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E71912166AE5;
	Fri, 16 Feb 2024 17:10:30 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes and cleanups for 6.8-rc5
Date: Fri, 16 Feb 2024 12:10:30 -0500
Message-Id: <20240216171030.12745-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Linus,

The following changes since commit 841c35169323cd833294798e58b9bf63fa4fa1de:

  Linux 6.8-rc4 (2024-02-11 12:18:13 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9895ceeb5cd61092f147f8d611e2df575879dd6f:

  Merge tag 'kvmarm-fixes-6.8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-02-16 12:02:38 -0500)

This pull request is mostly a mix of cleanups and fixes in the KVM
selftests, but there are also some small arch/ changes.

Paolo
----------------------------------------------------------------
ARM:

* Avoid dropping the page refcount twice when freeing an unlinked
  page-table subtree.

* Don't source the VFIO Kconfig twice

* Fix protected-mode locking order between kvm and vcpus

RISC-V:

* Fix steal-time related sparse warnings

x86:

* Cleanup gtod_is_based_on_tsc() to return "bool" instead of an "int"

* Make a KVM_REQ_NMI request while handling KVM_SET_VCPU_EVENTS if and only
  if the incoming events->nmi.pending is non-zero.  If the target vCPU is in
  the UNITIALIZED state, the spurious request will result in KVM exiting to
  userspace, which in turn causes QEMU to constantly acquire and release
  QEMU's global mutex, to the point where the BSP is unable to make forward
  progress.

* Fix a type (u8 versus u64) goof that results in pmu->fixed_ctr_ctrl being
  incorrectly truncated, and ultimately causes KVM to think a fixed counter
  has already been disabled (KVM thinks the old value is '0').

* Fix a stack leak in KVM_GET_MSRS where a failed MSR read from userspace
  that is ultimately ignored due to ignore_msrs=true doesn't zero the output
  as intended.

Selftests cleanups and fixes:

* Remove redundant newlines from error messages.

* Delete an unused variable in the AMX test (which causes build failures when
  compiling with -Werror).

* Fail instead of skipping tests if open(), e.g. of /dev/kvm, fails with an
  error code other than ENOENT (a Hyper-V selftest bug resulted in an EMFILE,
  and the test eventually got skipped).

* Fix TSC related bugs in several Hyper-V selftests.

* Fix a bug in the dirty ring logging test where a sem_post() could be left
  pending across multiple runs, resulting in incorrect synchronization between
  the main thread and the vCPU worker thread.

* Relax the dirty log split test's assertions on 4KiB mappings to fix false
  positives due to the number of mappings for memslot 0 (used for code and
  data that is NOT being dirty logged) changing, e.g. due to NUMA balancing.

----------------------------------------------------------------
Andrew Jones (8):
      KVM: selftests: Remove redundant newlines
      KVM: selftests: aarch64: Remove redundant newlines
      KVM: selftests: riscv: Remove redundant newlines
      KVM: selftests: s390x: Remove redundant newlines
      KVM: selftests: x86_64: Remove redundant newlines
      RISC-V: paravirt: steal_time should be static
      RISC-V: paravirt: Use correct restricted types
      RISC-V: KVM: Use correct restricted types

Masahiro Yamada (1):
      KVM: arm64: Do not source virt/lib/Kconfig twice

Mathias Krause (1):
      KVM: x86: Fix KVM_GET_MSRS stack info leak

Mingwei Zhang (1):
      KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl

Paolo Bonzini (5):
      Merge tag 'kvm-x86-fixes-6.8-rcN' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.8-rcN' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-riscv-fixes-6.8-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-fixes-6.8-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvmarm-fixes-6.8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Prasad Pandit (1):
      KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu

Sean Christopherson (4):
      KVM: selftests: Reword the NX hugepage test's skip message to be more helpful
      KVM: selftests: Delete superfluous, unused "stage" variable in AMX test
      KVM: selftests: Fix a semaphore imbalance in the dirty ring logging test
      KVM: selftests: Don't assert on exact number of 4KiB in dirty log split test

Sebastian Ene (1):
      KVM: arm64: Fix circular locking dependency

Vitaly Kuznetsov (7):
      KVM: selftests: Avoid infinite loop in hyperv_features when invtsc is missing
      KVM: selftests: Fail tests when open() fails with !ENOENT
      KVM: selftests: Generalize check_clocksource() from kvm_clock_test
      KVM: selftests: Use generic sys_clocksource_is_tsc() in vmx_nested_tsc_scaling_test
      KVM: selftests: Run clocksource dependent tests with hyperv_clocksource_tsc_page too
      KVM: selftests: Make hyperv_clock require TSC based system clocksource
      KVM: x86: Make gtod_is_based_on_tsc() return 'bool'

Will Deacon (1):
      KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlinked()

 arch/arm64/kvm/Kconfig                             |  1 -
 arch/arm64/kvm/hyp/pgtable.c                       |  2 -
 arch/arm64/kvm/pkvm.c                              | 27 +++++++----
 arch/riscv/kernel/paravirt.c                       |  6 +--
 arch/riscv/kvm/vcpu_sbi_sta.c                      | 20 ++++----
 arch/x86/kvm/vmx/pmu_intel.c                       |  2 +-
 arch/x86/kvm/x86.c                                 | 20 ++++----
 tools/testing/selftests/kvm/aarch64/arch_timer.c   | 12 ++---
 tools/testing/selftests/kvm/aarch64/hypercalls.c   | 16 +++----
 .../selftests/kvm/aarch64/page_fault_test.c        |  6 +--
 tools/testing/selftests/kvm/aarch64/smccc_filter.c |  2 +-
 .../selftests/kvm/aarch64/vpmu_counter_access.c    | 12 ++---
 tools/testing/selftests/kvm/demand_paging_test.c   |  4 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  4 +-
 tools/testing/selftests/kvm/dirty_log_test.c       | 54 ++++++++++++----------
 tools/testing/selftests/kvm/get-reg-list.c         |  2 +-
 tools/testing/selftests/kvm/guest_print_test.c     |  8 ++--
 .../testing/selftests/kvm/hardware_disable_test.c  |  6 +--
 tools/testing/selftests/kvm/include/test_util.h    |  2 +
 .../selftests/kvm/include/x86_64/processor.h       |  2 +
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |  2 +-
 tools/testing/selftests/kvm/kvm_page_table_test.c  |  4 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  2 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |  4 +-
 tools/testing/selftests/kvm/lib/elf.c              |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 19 ++++----
 tools/testing/selftests/kvm/lib/memstress.c        |  2 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  2 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |  2 +-
 tools/testing/selftests/kvm/lib/test_util.c        | 25 ++++++++++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |  2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 21 +++++++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |  6 +--
 .../kvm/memslot_modification_stress_test.c         |  2 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |  6 +--
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  2 +-
 tools/testing/selftests/kvm/rseq_test.c            |  4 +-
 tools/testing/selftests/kvm/s390x/resets.c         |  4 +-
 tools/testing/selftests/kvm/s390x/sync_regs_test.c | 20 ++++----
 .../testing/selftests/kvm/set_memory_region_test.c |  6 +--
 .../selftests/kvm/system_counter_offset_test.c     |  2 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c      |  6 +--
 tools/testing/selftests/kvm/x86_64/cpuid_test.c    |  4 +-
 .../kvm/x86_64/dirty_log_page_splitting_test.c     | 21 +++++----
 .../testing/selftests/kvm/x86_64/flds_emulation.h  |  2 +-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |  5 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c |  9 ++--
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |  2 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c        |  2 +-
 .../testing/selftests/kvm/x86_64/kvm_clock_test.c  | 42 ++---------------
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |  6 +--
 .../selftests/kvm/x86_64/platform_info_test.c      |  2 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c       | 28 +++++------
 .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c |  4 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 10 ++--
 .../selftests/kvm/x86_64/ucna_injection_test.c     |  8 ++--
 .../selftests/kvm/x86_64/userspace_io_test.c       |  2 +-
 .../selftests/kvm/x86_64/vmx_apic_access_test.c    |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      | 16 +++----
 .../vmx_exception_with_invalid_guest_state.c       |  2 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       | 19 +-------
 .../testing/selftests/kvm/x86_64/xapic_ipi_test.c  |  8 ++--
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |  2 +-
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c  |  2 +-
 65 files changed, 277 insertions(+), 276 deletions(-)


