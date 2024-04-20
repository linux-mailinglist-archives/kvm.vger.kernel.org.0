Return-Path: <kvm+bounces-15412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 772DF8ABA4F
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 10:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0B251F222C9
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 08:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9492114AB0;
	Sat, 20 Apr 2024 08:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+a+o15Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD830134BF
	for <kvm@vger.kernel.org>; Sat, 20 Apr 2024 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713602106; cv=none; b=cZp27EDS/zNJREvOyCqFr/VS/pHrdu3IUiNiAq7tTGMKZCUJAJ7Hnf779P6dY3V7zbIDhfXDP41nhqXKcIJCYfp5YmgEFIZlP91hk7/pKc7EnnPfYUgp3GvZ8Oky7q8fLHURgrk91KRK6aE/yqoPOxfjz0FzZOKRNugoQu4NI5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713602106; c=relaxed/simple;
	bh=sqVG+a/S+zk12II7AeFEZhAVsiWjW1ScyvLAr+oX/j0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kwL8p/O1xxZjpvsf5NPAb5QJ2UfDgRNGGmteOMLdhsoo84zVBlwehTx2L9b93vkOiMnI8erPB6vkQpAIPFixmP0DAJmiTDoy1HiWhmXCryKP0KB/XgUHGzSFB7ZWobgBBihQyZhzyLvFA+BZnFKufT5t7MZocmvfm/PfyMoxN2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C+a+o15Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713602103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iZq4P3HHVC0RfCF2HHIcIAnQe5aCLFWGD5vDn+X2/Z0=;
	b=C+a+o15QxD8LagnSXxeXoUibDhOEBbXAC1wEYFOyHXwZ9/dCIu5jJ1doof+f6CiMCPlCD+
	FMukytAgrC5SvCAqxGwXANU7fDpW5f5Z7D8FuDBLnVWiRnZImq5GQq15GFOKkRKY6nKC4w
	wcYxEcJH4W+DJu9rYaWfPAIF+PMk7Zk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-wVRD5RxuMAu8vbwJCbqSFQ-1; Sat,
 20 Apr 2024 04:34:59 -0400
X-MC-Unique: wVRD5RxuMAu8vbwJCbqSFQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B06B3C025B0;
	Sat, 20 Apr 2024 08:34:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E054FC1A225;
	Sat, 20 Apr 2024 08:34:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.9-rc5
Date: Sat, 20 Apr 2024 04:34:58 -0400
Message-ID: <20240420083458.3692711-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Linus,

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 44ecfa3e5f1ce2b5c7fa7003abde8a667c158f88:

  Merge branch 'svm' of https://github.com/kvm-x86/linux into HEAD (2024-04-17 11:44:37 -0400)

This is a bit on the large side, mostly due to two parts of the pull request:

* changes to disable some broken PMU virtualization

* a clean up to SVM's enter/exit assembly code so that it can be compiled
  without OBJECT_FILES_NON_STANDARD, fixing a warning that appeared in
  6.9-rc1.

Everything else is small bugfixes and selftest changes.

----------------------------------------------------------------
* Clean up SVM's enter/exit assembly code so that it can be compiled
  without OBJECT_FILES_NON_STANDARD.  This fixes a warning
  "Unpatched return thunk in use. This should not happen!" when running
  KVM selftests.

* Fix a mostly benign bug in the gfn_to_pfn_cache infrastructure where KVM
  would allow userspace to refresh the cache with a bogus GPA.  The bug has
  existed for quite some time, but was exposed by a new sanity check added in
  6.9 (to ensure a cache is either GPA-based or HVA-based).

* Drop an unused param from gfn_to_pfn_cache_invalidate_start() that got left
  behind during a 6.9 cleanup.

* Fix a math goof in x86's hugepage logic for KVM_SET_MEMORY_ATTRIBUTES that
  results in an array overflow (detected by KASAN).

* Fix a bug where KVM incorrectly clears root_role.direct when userspace sets
  guest CPUID.

* Fix a dirty logging bug in the where KVM fails to write-protect SPTEs used
  by a nested guest, if KVM is using Page-Modification Logging and the nested
  hypervisor is NOT using EPT.

x86 PMU:

* Drop support for virtualizing adaptive PEBS, as KVM's implementation is
  architecturally broken without an obvious/easy path forward, and because
  exposing adaptive PEBS can leak host LBRs to the guest, i.e. can leak
  host kernel addresses to the guest.

* Set the enable bits for general purpose counters in PERF_GLOBAL_CTRL at
  RESET time, as done by both Intel and AMD processors.

* Disable LBR virtualization on CPUs that don't support LBR callstacks, as
  KVM unconditionally uses PERF_SAMPLE_BRANCH_CALL_STACK when creating the
  perf event, and would fail on such CPUs.

Tests:

* Fix a flaw in the max_guest_memory selftest that results in it exhausting
  the supply of ucall structures when run with more than 256 vCPUs.

* Mark KVM_MEM_READONLY as supported for RISC-V in set_memory_region_test.

----------------------------------------------------------------
Andrew Jones (1):
      KVM: selftests: fix supported_flags for riscv

Christophe JAILLET (1):
      KVM: SVM: Remove a useless zeroing of allocated memory

David Matlack (4):
      KVM: x86/mmu: Write-protect L2 SPTEs in TDP MMU when clearing dirty status
      KVM: x86/mmu: Remove function comments above clear_dirty_{gfn_range,pt_masked}()
      KVM: x86/mmu: Fix and clarify comments about clearing D-bit vs. write-protecting
      KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_test

Maxim Levitsky (1):
      KVM: selftests: fix max_guest_memory_test with more that 256 vCPUs

Paolo Bonzini (2):
      Merge tag 'kvm-x86-fixes-6.9-rcN' of https://github.com/kvm-x86/linux into HEAD
      Merge branch 'svm' of https://github.com/kvm-x86/linux into HEAD

Rick Edgecombe (1):
      KVM: x86/mmu: x86: Don't overflow lpage_info when checking attributes

Sandipan Das (1):
      KVM: x86/pmu: Do not mask LVTPC when handling a PMI on AMD platforms

Sean Christopherson (20):
      KVM: Add helpers to consolidate gfn_to_pfn_cache's page split check
      KVM: Check validity of offset+length of gfn_to_pfn_cache prior to activation
      KVM: Explicitly disallow activatating a gfn_to_pfn_cache with INVALID_GPA
      KVM: x86/pmu: Disable support for adaptive PEBS
      KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at "RESET"
      KVM: selftests: Verify post-RESET value of PERF_GLOBAL_CTRL in PMCs test
      KVM: SVM: Create a stack frame in __svm_vcpu_run() for unwinding
      KVM: SVM: Wrap __svm_sev_es_vcpu_run() with #ifdef CONFIG_KVM_AMD_SEV
      KVM: SVM: Drop 32-bit "support" from __svm_sev_es_vcpu_run()
      KVM: SVM: Clobber RAX instead of RBX when discarding spec_ctrl_intercepted
      KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN via host save area
      KVM: SVM: Save/restore args across SEV-ES VMRUN via host save area
      KVM: SVM: Create a stack frame in __svm_sev_es_vcpu_run()
      KVM: x86: Stop compiling vmenter.S with OBJECT_FILES_NON_STANDARD
      KVM: x86: Snapshot if a vCPU's vendor model is AMD vs. Intel compatible
      KVM: VMX: Snapshot LBR capabilities during module initialization
      perf/x86/intel: Expose existence of callback support to KVM
      KVM: VMX: Disable LBR virtualization if the CPU doesn't support LBR callstacks
      KVM: x86/mmu: Precisely invalidate MMU root_role during CPUID update
      KVM: Drop unused @may_block param from gfn_to_pfn_cache_invalidate_start()

Tao Su (1):
      KVM: VMX: Ignore MKTME KeyID bits when intercepting #PF for allow_smaller_maxphyaddr

 arch/x86/events/intel/lbr.c                        |  1 +
 arch/x86/include/asm/kvm_host.h                    |  1 +
 arch/x86/include/asm/perf_event.h                  |  1 +
 arch/x86/kvm/Makefile                              |  5 --
 arch/x86/kvm/cpuid.c                               |  1 +
 arch/x86/kvm/cpuid.h                               | 10 +++
 arch/x86/kvm/lapic.c                               |  3 +-
 arch/x86/kvm/mmu/mmu.c                             | 11 +--
 arch/x86/kvm/mmu/tdp_mmu.c                         | 51 +++++-------
 arch/x86/kvm/pmu.c                                 | 16 +++-
 arch/x86/kvm/svm/sev.c                             |  2 +-
 arch/x86/kvm/svm/svm.c                             | 17 ++--
 arch/x86/kvm/svm/svm.h                             |  3 +-
 arch/x86/kvm/svm/vmenter.S                         | 97 ++++++++++------------
 arch/x86/kvm/vmx/pmu_intel.c                       |  2 +-
 arch/x86/kvm/vmx/vmx.c                             | 41 +++++++--
 arch/x86/kvm/vmx/vmx.h                             |  6 +-
 arch/x86/kvm/x86.c                                 |  2 +-
 .../testing/selftests/kvm/max_guest_memory_test.c  | 15 ++--
 .../testing/selftests/kvm/set_memory_region_test.c |  2 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c       | 20 ++++-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      | 60 +++++++++----
 virt/kvm/kvm_main.c                                |  3 +-
 virt/kvm/kvm_mm.h                                  |  6 +-
 virt/kvm/pfncache.c                                | 50 +++++++----
 25 files changed, 267 insertions(+), 159 deletions(-)


