Return-Path: <kvm+bounces-11926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF87087D30D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D423A1C22775
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9624D13B;
	Fri, 15 Mar 2024 17:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S46tskld"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EDE4C600
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710524990; cv=none; b=rbPQA4yajMePkaYyfgnJnL/7xeapMi4jlG64vd5W126p7sACVfWjtHGz7cIq6b+cj5c1Neg/fcwSgdGL2GEgChQLro9K2e618/KuGWsRHnEN6pDxnGGi9Dci53/PMiH1O7u32RyxIYrk+c4uak1XLhQ8VjRUu6Qv2uuW8uujDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710524990; c=relaxed/simple;
	bh=FjSULfqN2tMS6t124lmqbHcMaXhmjScoXpFGoOP9lYU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SkK90hmIzSYQZ/pdfIw6WJdGmwvuF8yeB480nhOZb3xLUK4PeiVW48yqKZwFtGagz2yYvoZUpAA2mQrFxiPn135ZvVeG+ntelnJUbF+6yE3tJG7RXVfa9OxeWsG9dCghj6JiziYEnHyTtZ0NGGN9mey3m52Sx9YeLwySdINy19g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S46tskld; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710524986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KtmmVbEKVs1ZdGfxWaJ7uMEUupzsQ5zYF1Ie0WnQ83A=;
	b=S46tskldPLJSgbNO+NgB5YXZUfXPKgrIAz5Yh0AttJFzBx4qBOzalcdZRtg1K535rw82ve
	B/9ip1vVyihwQ+yVHkeMzbIM62sj+2HBYpi8fm2e9baTfFKW5IZVQUWZ3bVG0Z/fy4xSJC
	jprWwvzEIeEib04RrYR8yf1pHIdl6f8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-416-HVVZDLPsPi2Zjxmnw52oLA-1; Fri,
 15 Mar 2024 13:49:40 -0400
X-MC-Unique: HVVZDLPsPi2Zjxmnw52oLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D7D729AA2C9;
	Fri, 15 Mar 2024 17:49:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB1B740C6DB7;
	Fri, 15 Mar 2024 17:49:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.9 merge window
Date: Fri, 15 Mar 2024 13:49:39 -0400
Message-Id: <20240315174939.2530483-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Linus,

The following changes since commit 90d35da658da8cff0d4ecbb5113f5fac9d00eb72:

  Linux 6.8-rc7 (2024-03-03 13:02:52 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4781179012d9380005649b0fe07f77dcaa2610e3:

  selftests: kvm: remove meaningless assignments in Makefiles (2024-03-15 06:52:55 -0400)

There are some conflicts with the arm and perf tree (I waited until you
pulled the latter before sending my own PR):

- arch/arm64/include/asm/kvm_arm.h is simple but may be a bit confusing
  (HCRX_GUEST_FLAGS comes from this side, HCRX_HOST_FLAGS from the ARM
  tree that you've already pulled), the resolution is after the signature.

- arch/arm64/kernel/cpufeature.c is trivial but the resolution is also after
  the signature (I only included the part that gets an actual conflict, not the
  whole output of diff --cc).

- in tools/testing/selftests/kvm/Makefile, just pick my version - this is
  the one that is caused by a small cleanup that was sent through the perf
  tree, but the relevant rules were rewritten so I redid it locally (that's
  the very last commit that you can see in the blurb above).  I guess the
  change looked innocuous enough to Masahiro and Namhyung, no hard
  feelings about it. :)

There's a common KVM/VFIO branch that has acks from Alex Williamson for
VFIO and David Hildenbrand for a new VMA flag in include/linux/mm.h
(see commit 5c656fcdd6c6, "mm: Introduce new flag to indicate wc safe"
for the description).

Thanks,

Paolo

----------------------------------------------------------------
S390:

* Changes to FPU handling came in via the main s390 pull request

* Only deliver to the guest the SCLP events that userspace has
  requested.

* More virtual vs physical address fixes (only a cleanup since
  virtual and physical address spaces are currently the same).

* Fix selftests undefined behavior.

x86:

* Fix a restriction that the guest can't program a PMU event whose
  encoding matches an architectural event that isn't included in the
  guest CPUID.  The enumeration of an architectural event only says
  that if a CPU supports an architectural event, then the event can be
  programmed *using the architectural encoding*.  The enumeration does
  NOT say anything about the encoding when the CPU doesn't report support
  the event *in general*.  It might support it, and it might support it
  using the same encoding that made it into the architectural PMU spec.

* Fix a variety of bugs in KVM's emulation of RDPMC (more details on
  individual commits) and add a selftest to verify KVM correctly emulates
  RDMPC, counter availability, and a variety of other PMC-related
  behaviors that depend on guest CPUID and therefore are easier to
  validate with selftests than with custom guests (aka kvm-unit-tests).

* Zero out PMU state on AMD if the virtual PMU is disabled, it does not
  cause any bug but it wastes time in various cases where KVM would check
  if a PMC event needs to be synthesized.

* Optimize triggering of emulated events, with a nice ~10% performance
  improvement in VM-Exit microbenchmarks when a vPMU is exposed to the
  guest.

* Tighten the check for "PMI in guest" to reduce false positives if an NMI
  arrives in the host while KVM is handling an IRQ VM-Exit.

* Fix a bug where KVM would report stale/bogus exit qualification information
  when exiting to userspace with an internal error exit code.

* Add a VMX flag in /proc/cpuinfo to report 5-level EPT support.

* Rework TDP MMU root unload, free, and alloc to run with mmu_lock held for
  read, e.g. to avoid serializing vCPUs when userspace deletes a memslot.

* Tear down TDP MMU page tables at 4KiB granularity (used to be 1GiB).  KVM
  doesn't support yielding in the middle of processing a zap, and 1GiB
  granularity resulted in multi-millisecond lags that are quite impolite
  for CONFIG_PREEMPT kernels.

* Allocate write-tracking metadata on-demand to avoid the memory overhead when
  a kernel is built with i915 virtualization support but the workloads use
  neither shadow paging nor i915 virtualization.

* Explicitly initialize a variety of on-stack variables in the emulator that
  triggered KMSAN false positives.

* Fix the debugregs ABI for 32-bit KVM.

* Rework the "force immediate exit" code so that vendor code ultimately decides
  how and when to force the exit, which allowed some optimization for both
  Intel and AMD.

* Fix a long-standing bug where kvm_has_noapic_vcpu could be left elevated if
  vCPU creation ultimately failed, causing extra unnecessary work.

* Cleanup the logic for checking if the currently loaded vCPU is in-kernel.

* Harden against underflowing the active mmu_notifier invalidation
  count, so that "bad" invalidations (usually due to bugs elsehwere in the
  kernel) are detected earlier and are less likely to hang the kernel.

x86 Xen emulation:

* Overlay pages can now be cached based on host virtual address,
  instead of guest physical addresses.  This removes the need to
  reconfigure and invalidate the cache if the guest changes the
  gpa but the underlying host virtual address remains the same.

* When possible, use a single host TSC value when computing the deadline for
  Xen timers in order to improve the accuracy of the timer emulation.

* Inject pending upcall events when the vCPU software-enables its APIC to fix
  a bug where an upcall can be lost (and to follow Xen's behavior).

* Fall back to the slow path instead of warning if "fast" IRQ delivery of Xen
  events fails, e.g. if the guest has aliased xAPIC IDs.

RISC-V:

* Support exception and interrupt handling in selftests

* New self test for RISC-V architectural timer (Sstc extension)

* New extension support (Ztso, Zacas)

* Support userspace emulation of random number seed CSRs.

ARM:

* Infrastructure for building KVM's trap configuration based on the
  architectural features (or lack thereof) advertised in the VM's ID
  registers

* Support for mapping vfio-pci BARs as Normal-NC (vaguely similar to
  x86's WC) at stage-2, improving the performance of interacting with
  assigned devices that can tolerate it

* Conversion of KVM's representation of LPIs to an xarray, utilized to
  address serialization some of the serialization on the LPI injection
  path

* Support for _architectural_ VHE-only systems, advertised through the
  absence of FEAT_E2H0 in the CPU's ID register

* Miscellaneous cleanups, fixes, and spelling corrections to KVM and
  selftests

LoongArch:

* Set reserved bits as zero in CPUCFG.

* Start SW timer only when vcpu is blocking.

* Do not restart SW timer when it is expired.

* Remove unnecessary CSR register saving during enter guest.

* Misc cleanups and fixes as usual.

Generic:

* cleanup Kconfig by removing CONFIG_HAVE_KVM, which was basically always
  true on all architectures except MIPS (where Kconfig determines the
  available depending on CPU capabilities).  It is replaced either by
  an architecture-dependent symbol for MIPS, and IS_ENABLED(CONFIG_KVM)
  everywhere else.

* Factor common "select" statements in common code instead of requiring
  each architecture to specify it

* Remove thoroughly obsolete APIs from the uapi headers.

* Move architecture-dependent stuff to uapi/asm/kvm.h

* Always flush the async page fault workqueue when a work item is being
  removed, especially during vCPU destruction, to ensure that there are no
  workers running in KVM code when all references to KVM-the-module are gone,
  i.e. to prevent a very unlikely use-after-free if kvm.ko is unloaded.

* Grab a reference to the VM's mm_struct in the async #PF worker itself instead
  of gifting the worker a reference, so that there's no need to remember
  to *conditionally* clean up after the worker.

Selftests:

* Reduce boilerplate especially when utilize selftest TAP infrastructure.

* Add basic smoke tests for SEV and SEV-ES, along with a pile of library
  support for handling private/encrypted/protected memory.

* Fix benign bugs where tests neglect to close() guest_memfd files.

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: selftests: Add a macro to iterate over a sparsebit range

Alexander Gordeev (1):
      KVM: s390: fix virtual vs physical address confusion

Andrei Vagin (1):
      kvm/x86: allocate the write-tracking metadata on-demand

Ankit Agrawal (4):
      KVM: arm64: Introduce new flag for non-cacheable IO memory
      mm: Introduce new flag to indicate wc safe
      KVM: arm64: Set io memory s2 pte as normalnc for vfio pci device
      vfio: Convey kvm that the vfio-pci device is wc safe

Anup Patel (5):
      RISC-V: KVM: Forward SEED CSR access to user space
      RISC-V: KVM: Allow Ztso extension for Guest/VM
      KVM: riscv: selftests: Add Ztso extension to get-reg-list test
      RISC-V: KVM: Allow Zacas extension for Guest/VM
      KVM: riscv: selftests: Add Zacas extension to get-reg-list test

Arnd Bergmann (1):
      KVM: fix kvm_mmu_memory_cache allocation warning

Bibo Mao (4):
      LoongArch: KVM: Set reserved bits as zero in CPUCFG
      LoongArch: KVM: Start SW timer only when vcpu is blocking
      LoongArch: KVM: Do not restart SW timer when it is expired
      LoongArch: KVM: Remove unnecessary CSR register saving during enter guest

Bjorn Helgaas (1):
      KVM: arm64: Fix typos

Chao Gao (1):
      KVM: VMX: Report up-to-date exit qualification to userspace

Dapeng Mi (1):
      KVM: selftests: Test top-down slots event in x86's pmu_counters_test

David Woodhouse (5):
      KVM: x86/xen: improve accuracy of Xen timers
      KVM: x86/xen: inject vCPU upcall vector when local APIC is enabled
      KVM: x86/xen: remove WARN_ON_ONCE() with false positives in evtchn delivery
      KVM: pfncache: simplify locking and make more self-contained
      KVM: x86/xen: fix recursive deadlock in timer injection

Dionna Glaze (1):
      kvm: x86: use a uapi-friendly macro for BIT

Dongli Zhang (3):
      KVM: VMX: fix comment to add LBR to passthrough MSRs
      KVM: VMX: return early if msr_bitmap is not supported
      KVM: selftests: Explicitly close guest_memfd files in some gmem tests

Eric Farman (1):
      KVM: s390: only deliver the set service event bits

Haibo Xu (11):
      KVM: arm64: selftests: Data type cleanup for arch_timer test
      KVM: arm64: selftests: Enable tuning of error margin in arch_timer test
      KVM: arm64: selftests: Split arch_timer test code
      KVM: selftests: Add CONFIG_64BIT definition for the build
      tools: riscv: Add header file csr.h
      tools: riscv: Add header file vdso/processor.h
      KVM: riscv: selftests: Switch to use macro from csr.h
      KVM: riscv: selftests: Add exception handling support
      KVM: riscv: selftests: Add guest helper to get vcpu id
      KVM: riscv: selftests: Change vcpu_has_ext to a common function
      KVM: riscv: selftests: Add sstc timer test

Jing Zhang (1):
      KVM: arm64: selftests: Handle feature fields with nonzero minimum value correctly

Jinrong Liang (7):
      KVM: selftests: Add vcpu_set_cpuid_property() to set properties
      KVM: selftests: Add pmu.h and lib/pmu.c for common PMU assets
      KVM: selftests: Test Intel PMU architectural events on gp counters
      KVM: selftests: Test Intel PMU architectural events on fixed counters
      KVM: selftests: Test consistency of CPUID with num of gp counters
      KVM: selftests: Test consistency of CPUID with num of fixed counters
      KVM: selftests: Add functional test for Intel's fixed PMU counters

Joey Gouly (3):
      KVM: arm64: print Hyp mode
      KVM: arm64: add comments to __kern_hyp_va
      KVM: arm64: removed unused kern_hyp_va asm macro

John Allen (1):
      KVM: SVM: Rename vmplX_ssp -> plX_ssp

Julian Stecklina (2):
      KVM: x86: Clean up partially uninitialized integer in emulate_pop()
      KVM: x86: rename push to emulate_push for consistency

Kunwu Chan (1):
      KVM: x86/mmu: Use KMEM_CACHE instead of kmem_cache_create()

Like Xu (1):
      KVM: x86/pmu: Explicitly check NMI from guest to reducee false positives

Marc Zyngier (41):
      arm64: Add macro to compose a sysreg field value
      arm64: cpufeatures: Correctly handle signed values
      arm64: cpufeature: Correctly display signed override values
      arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
      arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
      arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
      arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative
      KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
      KVM: arm64: Force guest's HCR_EL2.E2H RES1 when NV1 is not implemented
      KVM: arm64: Handle Apple M2 as not having HCR_EL2.NV1 implemented
      arm64: cpufeatures: Add missing ID_AA64MMFR4_EL1 to __read_sysreg_by_encoding()
      arm64: cpufeatures: Only check for NV1 if NV is present
      arm64: cpufeatures: Fix FEAT_NV check when checking for FEAT_NV1
      arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
      KVM: arm64: Add feature checking helpers
      KVM: arm64: nv: Add sanitising to VNCR-backed sysregs
      KVM: arm64: nv: Add sanitising to EL2 configuration registers
      KVM: arm64: nv: Add sanitising to VNCR-backed FGT sysregs
      KVM: arm64: nv: Add sanitising to VNCR-backed HCRX_EL2
      KVM: arm64: nv: Drop sanitised_sys_reg() helper
      KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
      KVM: arm64: nv: Correctly handle negative polarity FGTs
      KVM: arm64: nv: Turn encoding ranges into discrete XArray stores
      KVM: arm64: Drop the requirement for XARRAY_MULTI
      KVM: arm64: nv: Move system instructions to their own sys_reg_desc array
      KVM: arm64: Always populate the trap configuration xarray
      KVM: arm64: Register AArch64 system register entries with the sysreg xarray
      KVM: arm64: Use the xarray as the primary sysreg/sysinsn walker
      KVM: arm64: Rename __check_nv_sr_forward() to triage_sysreg_trap()
      KVM: arm64: Add Fine-Grained UNDEF tracking information
      KVM: arm64: Propagate and handle Fine-Grained UNDEF bits
      KVM: arm64: Move existing feature disabling over to FGU infrastructure
      KVM: arm64: Streamline save/restore of HFG[RW]TR_EL2
      KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
      KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest
      KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the guest
      KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest
      KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking
      KVM: arm64: Add debugfs file for guest's ID registers
      KVM: arm64: Make build-time check of RES0/RES1 bits optional
      KVM: arm64: Fix TRFCR_EL1/PMSCR_EL1 access in hVHE mode

Mathias Krause (1):
      KVM: x86: Fix broken debugregs ABI for 32 bit kernels

Michael Roth (2):
      KVM: selftests: Make sparsebit structs const where appropriate
      KVM: selftests: Add support for protected vm_vaddr_* allocations

Mingwei Zhang (1):
      KVM: x86/mmu: Don't acquire mmu_lock when using indirect_shadow_pages as a heuristic

Nikolay Borisov (1):
      KVM: x86: Use mutex guards to eliminate __kvm_x86_vendor_init()

Nina Schoetterl-Glausch (1):
      KVM: s390: selftest: memop: Fix undefined behavior

Oliver Upton (20):
      KVM: selftests: Print timer ctl register in ISTATUS assertion
      KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
      KVM: arm64: vgic: Store LPIs in an xarray
      KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
      KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
      KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
      KVM: arm64: vgic: Get rid of the LPI linked-list
      KVM: arm64: vgic: Use atomics to count LPIs
      KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
      KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
      KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
      KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()
      KVM: arm64: Fail the idreg iterator if idregs aren't initialized
      KVM: arm64: Don't initialize idreg debugfs w/ preemption disabled
      Merge branch kvm-arm64/feat_e2h0 into kvmarm/next
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/vm-configuration into kvmarm/next
      Merge branch kvm-arm64/lpi-xarray into kvmarm/next
      Merge branch kvm-arm64/vfio-normal-nc into kvmarm/next
      Merge branch kvm-arm64/kerneldoc into kvmarm/next

Paolo Bonzini (33):
      uapi: introduce uapi-friendly macros for GENMASK
      kvm: x86: use a uapi-friendly macro for GENMASK
      KVM: remove more traces of device assignment UAPI
      KVM: x86: move x86-specific structs to uapi/asm/kvm.h
      KVM: powerpc: move powerpc-specific structs to uapi/asm/kvm.h
      KVM: s390: move s390-specific structs to uapi/asm/kvm.h
      KVM: arm64: move ARM-specific defines to uapi/asm/kvm.h
      kvm: replace __KVM_HAVE_READONLY_MEM with Kconfig symbol
      KVM: define __KVM_HAVE_GUEST_DEBUG unconditionally
      KVM: remove unnecessary #ifdef
      kvm: move "select IRQ_BYPASS_MANAGER" to common code
      MIPS: introduce Kconfig for MIPS VZ
      x86: replace CONFIG_HAVE_KVM with IS_ENABLED(CONFIG_KVM)
      vfio: replace CONFIG_HAVE_KVM with IS_ENABLED(CONFIG_KVM)
      treewide: remove CONFIG_HAVE_KVM
      Merge branch 'kvm-uapi'
      Merge branch 'kvm-kconfig'
      x86: irq: unconditionally define KVM interrupt vectors
      selftests/kvm: Fix issues with $(SPLIT_TESTS)
      Merge tag 'kvm-x86-guest_memfd_fixes-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'loongarch-kvm-6.9' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvmarm-6.9' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-6.9-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-asyncpf-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-generic-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-xen-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-s390-next-6.9-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      selftests: kvm: remove meaningless assignments in Makefiles

Paul Durrant (17):
      KVM: pfncache: Add a map helper function
      KVM: pfncache: remove unnecessary exports
      KVM: x86/xen: mark guest pages dirty with the pfncache lock held
      KVM: pfncache: add a mark-dirty helper
      KVM: pfncache: remove KVM_GUEST_USES_PFN usage
      KVM: pfncache: stop open-coding offset_in_page()
      KVM: pfncache: include page offset in uhva and use it consistently
      KVM: pfncache: allow a cache to be activated with a fixed (userspace) HVA
      KVM: x86/xen: separate initialization of shared_info cache and content
      KVM: x86/xen: re-initialize shared_info if guest (32/64-bit) mode is set
      KVM: x86/xen: allow shared_info to be mapped by fixed HVA
      KVM: x86/xen: allow vcpu_info to be mapped by fixed HVA
      KVM: selftests: map Xen's shared_info page using HVA rather than GFN
      KVM: selftests: re-map Xen's vcpu_info using HVA rather than GPA
      KVM: x86/xen: advertize the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA capability
      KVM: pfncache: check the need for invalidation under read lock first
      KVM: x86/xen: allow vcpu_info content to be 'safely' copied

Peter Gonda (5):
      KVM: selftests: Add support for allocating/managing protected guest memory
      KVM: selftests: Explicitly ucall pool from shared memory
      KVM: selftests: Allow tagging protected memory in guest page tables
      KVM: selftests: Add library for creating and interacting with SEV guests
      KVM: selftests: Add a basic SEV smoke test

Raghavendra Rao Ananta (1):
      KVM: selftests: aarch64: Remove unused functions from vpmu test

Randy Dunlap (10):
      KVM: arm64: debug: fix kernel-doc warnings
      KVM: arm64: guest: fix kernel-doc warnings
      KVM: arm64: hyp/aarch32: fix kernel-doc warnings
      KVM: arm64: vhe: fix a kernel-doc warning
      KVM: arm64: mmu: fix a kernel-doc warning
      KVM: arm64: PMU: fix kernel-doc warnings
      KVM: arm64: sys_regs: fix kernel-doc warnings
      KVM: arm64: vgic-init: fix a kernel-doc warning
      KVM: arm64: vgic-its: fix kernel-doc warnings
      KVM: arm64: vgic: fix a kernel-doc warning

Sean Christopherson (69):
      KVM: Harden against unpaired kvm_mmu_notifier_invalidate_range_end() calls
      KVM: x86/pmu: Always treat Fixed counters as available when supported
      KVM: x86/pmu: Allow programming events that match unsupported arch events
      KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural encodings
      KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
      KVM: x86/pmu: Get eventsel for fixed counters from perf
      KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC index on AMD
      KVM: x86/pmu: Prioritize VMX interception over #GP on RDPMC due to bad index
      KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
      KVM: x86/pmu: Disallow "fast" RDPMC for architectural Intel PMUs
      KVM: x86/pmu: Treat "fixed" PMU type in RDPMC as index as a value, not flag
      KVM: x86/pmu: Explicitly check for RDPMC of unsupported Intel PMC types
      KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
      KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
      KVM: selftests: Expand PMU counters test to verify LLC events
      KVM: selftests: Add a helper to query if the PMU module param is enabled
      KVM: selftests: Add helpers to read integer module params
      KVM: selftests: Query module param to detect FEP in MSR filtering test
      KVM: selftests: Move KVM_FEP macro into common library header
      KVM: selftests: Test PMC virtualization with forced emulation
      KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
      KVM: selftests: Add helpers for safe and safe+forced RDMSR, RDPMC, and XGETBV
      KVM: selftests: Extend PMU counters test to validate RDPMC after WRMSR
      KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is disabled
      KVM: x86/pmu: Add common define to capture fixed counters offset
      KVM: x86/pmu: Move pmc_idx => pmc translation helper to common code
      KVM: x86/pmu: Snapshot and clear reprogramming bitmap before reprogramming
      KVM: x86/pmu: Add macros to iterate over all PMCs given a bitmap
      KVM: x86/pmu: Process only enabled PMCs when emulating events in software
      KVM: x86/pmu: Snapshot event selectors that KVM emulates in software
      KVM: x86/pmu: Expand the comment about what bits are check emulating events
      KVM: x86/pmu: Check eventsel first when emulating (branch) insns retired
      KVM: x86/pmu: Avoid CPL lookup if PMC enabline for USER and KERNEL is the same
      KVM: Always flush async #PF workqueue when vCPU is being destroyed
      KVM: Put mm immediately after async #PF worker completes remote gup()
      KVM: Get reference to VM's address space in the async #PF worker
      KVM: Nullify async #PF worker's "apf" pointer as soon as it might be freed
      KVM: selftests: Fix GUEST_PRINTF() format warnings in ARM code
      KVM: s390: Refactor kvm_is_error_gpa() into kvm_is_gpa_in_memslot()
      x86/cpu: Add a VMX flag to enumerate 5-level EPT support to userspace
      KVM: x86: Make kvm_get_dr() return a value, not use an out parameter
      KVM: x86: Open code all direct reads to guest DR6 and DR7
      KVM: x86: Drop dedicated logic for direct MMUs in reexecute_instruction()
      KVM: x86: Drop superfluous check on direct MMU vs. WRITE_PF_TO_SP flag
      KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
      KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer exits
      KVM: VMX: Handle forced exit due to preemption timer in fastpath
      KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
      KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2
      KVM: x86: Fully defer to vendor code to decide how to force immediate exit
      KVM: x86: Move "KVM no-APIC vCPU" key management into local APIC code
      KVM: x86: Sanity check that kvm_has_noapic_vcpu is zero at module_exit()
      KVM: Add dedicated arch hook for querying if vCPU was preempted in-kernel
      KVM: x86: Rely solely on preempted_in_kernel flag for directed yield
      KVM: x86: Clean up directed yield API for "has pending interrupt"
      KVM: Add a comment explaining the directed yield pending interrupt logic
      KVM: x86/mmu: Zap invalidated TDP MMU roots at 4KiB granularity
      KVM: x86/mmu: Don't do TLB flush when zappings SPTEs in invalid roots
      KVM: x86/mmu: Allow passing '-1' for "all" as_id for TDP MMU iterators
      KVM: x86/mmu: Skip invalid roots when zapping leaf SPTEs for GFN range
      KVM: x86/mmu: Skip invalid TDP MMU roots when write-protecting SPTEs
      KVM: x86/mmu: Check for usable TDP MMU root while holding mmu_lock for read
      KVM: x86/mmu: Alloc TDP MMU roots while holding mmu_lock for read
      KVM: x86/mmu: Free TDP MMU roots while holding mmy_lock for read
      KVM: VMX: Combine "check" and "get" APIs for passthrough MSR lookups
      KVM: selftests: Move setting a vCPU's entry point to a dedicated API
      KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
      KVM: selftests: Use the SEV library APIs in the intra-host migration test
      KVM: selftests: Add a basic SEV-ES smoke test

Thomas Huth (7):
      KVM: selftests: x86: sync_regs_test: Use vcpu_run() where appropriate
      KVM: selftests: x86: sync_regs_test: Get regs structure before modifying it
      KVM: selftests: Add a macro to define a test with one vcpu
      KVM: selftests: x86: Use TAP interface in the sync_regs test
      KVM: selftests: x86: Use TAP interface in the fix_hypercall test
      KVM: selftests: x86: Use TAP interface in the vmx_pmu_caps test
      KVM: selftests: x86: Use TAP interface in the userspace_msr_exit test

Thomas Prescher (1):
      KVM: x86/emulator: emulate movbe with operand-size prefix

 Documentation/virt/kvm/api.rst                     |  51 +-
 arch/arm64/Kconfig                                 |   1 -
 arch/arm64/include/asm/cpu.h                       |   1 +
 arch/arm64/include/asm/cpufeature.h                |   1 +
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_emulate.h               |   3 +-
 arch/arm64/include/asm/kvm_host.h                  |  99 ++-
 arch/arm64/include/asm/kvm_hyp.h                   |   2 +-
 arch/arm64/include/asm/kvm_mmu.h                   |  46 +-
 arch/arm64/include/asm/kvm_nested.h                |   1 -
 arch/arm64/include/asm/kvm_pgtable.h               |   2 +
 arch/arm64/include/asm/memory.h                    |   2 +
 arch/arm64/include/asm/sysreg.h                    |   5 +-
 arch/arm64/include/uapi/asm/kvm.h                  |  15 +-
 arch/arm64/kernel/cpufeature.c                     | 105 +++-
 arch/arm64/kernel/cpuinfo.c                        |   1 +
 arch/arm64/kernel/head.S                           |  23 +-
 arch/arm64/kvm/Kconfig                             |  15 +-
 arch/arm64/kvm/arch_timer.c                        |   2 +-
 arch/arm64/kvm/arm.c                               |  14 +-
 arch/arm64/kvm/check-res-bits.h                    | 125 ++++
 arch/arm64/kvm/debug.c                             |   3 +-
 arch/arm64/kvm/emulate-nested.c                    | 231 +++++--
 arch/arm64/kvm/fpsimd.c                            |   2 +-
 arch/arm64/kvm/guest.c                             |   7 +-
 arch/arm64/kvm/hyp/aarch32.c                       |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 130 ++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  24 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   2 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  24 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |   2 +-
 arch/arm64/kvm/inject_fault.c                      |   2 +-
 arch/arm64/kvm/mmu.c                               |  16 +-
 arch/arm64/kvm/nested.c                            | 274 +++++++-
 arch/arm64/kvm/pmu-emul.c                          |  15 +-
 arch/arm64/kvm/sys_regs.c                          | 268 ++++++--
 arch/arm64/kvm/sys_regs.h                          |   2 +
 arch/arm64/kvm/vgic/vgic-debug.c                   |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  10 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  65 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   3 +-
 arch/arm64/kvm/vgic/vgic.c                         |  62 +-
 arch/arm64/kvm/vgic/vgic.h                         |  17 +-
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/sysreg                            |  45 +-
 arch/loongarch/Kconfig                             |   1 -
 arch/loongarch/include/uapi/asm/kvm.h              |   2 -
 arch/loongarch/kvm/Kconfig                         |   2 +-
 arch/loongarch/kvm/switch.S                        |   6 -
 arch/loongarch/kvm/timer.c                         |  43 +-
 arch/loongarch/kvm/vcpu.c                          |  33 +-
 arch/mips/Kconfig                                  |  18 +-
 arch/mips/include/uapi/asm/kvm.h                   |   2 -
 arch/mips/kvm/Kconfig                              |   3 +-
 arch/powerpc/include/uapi/asm/kvm.h                |  45 +-
 arch/powerpc/kvm/Kconfig                           |   1 -
 arch/powerpc/kvm/powerpc.c                         |   3 +-
 arch/riscv/include/uapi/asm/kvm.h                  |   3 +-
 arch/riscv/kvm/Kconfig                             |   1 +
 arch/riscv/kvm/vcpu_insn.c                         |  13 +
 arch/riscv/kvm/vcpu_onereg.c                       |   4 +
 arch/s390/Kconfig                                  |   1 -
 arch/s390/include/uapi/asm/kvm.h                   | 315 +++++++++-
 arch/s390/kvm/Kconfig                              |   1 -
 arch/s390/kvm/diag.c                               |   2 +-
 arch/s390/kvm/gaccess.c                            |  14 +-
 arch/s390/kvm/interrupt.c                          |   4 +-
 arch/s390/kvm/kvm-s390.c                           |   6 +-
 arch/s390/kvm/priv.c                               |   4 +-
 arch/s390/kvm/sigp.c                               |   2 +-
 arch/x86/Kconfig                                   |   1 -
 arch/x86/include/asm/hardirq.h                     |   2 +-
 arch/x86/include/asm/idtentry.h                    |   2 +-
 arch/x86/include/asm/irq.h                         |   2 +-
 arch/x86/include/asm/irq_vectors.h                 |   2 -
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 -
 arch/x86/include/asm/kvm-x86-pmu-ops.h             |   4 +-
 arch/x86/include/asm/kvm_host.h                    |  28 +-
 arch/x86/include/asm/svm.h                         |   8 +-
 arch/x86/include/asm/vmxfeatures.h                 |   1 +
 arch/x86/include/uapi/asm/kvm.h                    | 285 ++++++++-
 arch/x86/include/uapi/asm/kvm_para.h               |   2 +-
 arch/x86/kernel/cpu/feat_ctl.c                     |   2 +
 arch/x86/kernel/idt.c                              |   2 +-
 arch/x86/kernel/irq.c                              |   4 +-
 arch/x86/kvm/Kconfig                               |   4 +-
 arch/x86/kvm/debugfs.c                             |   3 +-
 arch/x86/kvm/emulate.c                             |  47 +-
 arch/x86/kvm/kvm_emulate.h                         |   4 +-
 arch/x86/kvm/lapic.c                               |  32 +-
 arch/x86/kvm/mmu/mmu.c                             |  37 +-
 arch/x86/kvm/mmu/page_track.c                      |  68 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         | 124 ++--
 arch/x86/kvm/mmu/tdp_mmu.h                         |   2 +-
 arch/x86/kvm/pmu.c                                 | 163 +++--
 arch/x86/kvm/pmu.h                                 |  57 +-
 arch/x86/kvm/smm.c                                 |  15 +-
 arch/x86/kvm/svm/pmu.c                             |  22 +-
 arch/x86/kvm/svm/svm.c                             |  25 +-
 arch/x86/kvm/trace.h                               |   9 +-
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 arch/x86/kvm/vmx/pmu_intel.c                       | 222 +++----
 arch/x86/kvm/vmx/vmx.c                             | 157 ++---
 arch/x86/kvm/vmx/vmx.h                             |   2 -
 arch/x86/kvm/x86.c                                 | 228 +++----
 arch/x86/kvm/x86.h                                 |   7 +-
 arch/x86/kvm/xen.c                                 | 315 +++++++---
 arch/x86/kvm/xen.h                                 |  18 +
 drivers/vfio/pci/vfio_pci_core.c                   |  19 +-
 drivers/vfio/vfio.h                                |   2 +-
 drivers/vfio/vfio_main.c                           |   4 +-
 include/kvm/arm_pmu.h                              |  11 -
 include/kvm/arm_vgic.h                             |   9 +-
 include/linux/bits.h                               |   8 +-
 include/linux/kvm_host.h                           |  60 +-
 include/linux/kvm_types.h                          |   8 -
 include/linux/mm.h                                 |  14 +
 include/uapi/asm-generic/bitsperlong.h             |   4 +
 include/uapi/linux/bits.h                          |  15 +
 include/uapi/linux/kvm.h                           | 689 +--------------------
 scripts/gdb/linux/constants.py.in                  |   6 +-
 scripts/gdb/linux/interrupts.py                    |   2 +-
 tools/arch/riscv/include/asm/csr.h                 | 541 ++++++++++++++++
 tools/arch/riscv/include/asm/vdso/processor.h      |  32 +
 tools/arch/x86/include/asm/irq_vectors.h           |   2 +-
 tools/testing/selftests/kvm/Makefile               |  31 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   | 299 +--------
 .../selftests/kvm/aarch64/debug-exceptions.c       |   2 +-
 tools/testing/selftests/kvm/aarch64/hypercalls.c   |   4 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |   2 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |  18 +-
 .../selftests/kvm/aarch64/vpmu_counter_access.c    |  28 +-
 tools/testing/selftests/kvm/arch_timer.c           | 259 ++++++++
 tools/testing/selftests/kvm/guest_memfd_test.c     |   3 +
 .../selftests/kvm/include/aarch64/kvm_util_arch.h  |   7 +
 .../selftests/kvm/include/aarch64/processor.h      |   4 -
 .../selftests/kvm/include/kvm_test_harness.h       |  36 ++
 .../testing/selftests/kvm/include/kvm_util_base.h  |  67 +-
 .../selftests/kvm/include/riscv/arch_timer.h       |  71 +++
 .../selftests/kvm/include/riscv/kvm_util_arch.h    |   7 +
 .../selftests/kvm/include/riscv/processor.h        |  72 ++-
 .../selftests/kvm/include/s390x/kvm_util_arch.h    |   7 +
 tools/testing/selftests/kvm/include/sparsebit.h    |  56 +-
 tools/testing/selftests/kvm/include/test_util.h    |   2 +
 tools/testing/selftests/kvm/include/timer_test.h   |  45 ++
 .../selftests/kvm/include/x86_64/kvm_util_arch.h   |  23 +
 tools/testing/selftests/kvm/include/x86_64/pmu.h   |  97 +++
 .../selftests/kvm/include/x86_64/processor.h       | 156 ++++-
 tools/testing/selftests/kvm/include/x86_64/sev.h   | 107 ++++
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  24 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 129 +++-
 tools/testing/selftests/kvm/lib/riscv/handlers.S   | 101 +++
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  96 ++-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |  13 +-
 tools/testing/selftests/kvm/lib/sparsebit.c        |  48 +-
 tools/testing/selftests/kvm/lib/ucall_common.c     |   3 +-
 tools/testing/selftests/kvm/lib/x86_64/pmu.c       |  31 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  60 +-
 tools/testing/selftests/kvm/lib/x86_64/sev.c       | 114 ++++
 tools/testing/selftests/kvm/riscv/arch_timer.c     | 111 ++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  19 +-
 tools/testing/selftests/kvm/s390x/memop.c          |   2 +
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |  27 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c       | 620 ++++++++++++++++++
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 143 ++---
 .../kvm/x86_64/private_mem_conversions_test.c      |   2 +
 .../selftests/kvm/x86_64/sev_migrate_tests.c       |  60 +-
 .../testing/selftests/kvm/x86_64/sev_smoke_test.c  |  88 +++
 .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c |   2 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 127 +++-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c |  78 +--
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |  54 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  59 +-
 virt/kvm/Kconfig                                   |   7 +-
 virt/kvm/async_pf.c                                |  73 ++-
 virt/kvm/kvm_main.c                                |  37 +-
 virt/kvm/pfncache.c                                | 249 ++++----
 179 files changed, 6668 insertions(+), 2723 deletions(-)


diff --cc arch/arm64/include/asm/kvm_arm.h
index 7f45ce9170bb,a1769e415d72..000000000000
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@@ -102,10 -102,8 +102,8 @@@
  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
  
- #define HCRX_GUEST_FLAGS \
- 	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
- 	 (cpus_have_final_cap(ARM64_HAS_MOPS) ? (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0))
+ #define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
 -#define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
 +#define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
  
  /* TCR_EL2 Registers bits */
  #define TCR_EL2_DS		(1UL << 32)
diff --cc arch/arm64/kernel/cpufeature.c
index d6679d8b737e,f309fd542c20..000000000000
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@@ -2751,31 -2818,12 +2829,38 @@@ static const struct arm64_cpu_capabilit
  		.matches = has_lpa2,
  	},
  	{
 +		.desc = "FPMR",
 +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 +		.capability = ARM64_HAS_FPMR,
 +		.matches = has_cpuid_feature,
 +		.cpu_enable = cpu_enable_fpmr,
 +		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, FPMR, IMP)
 +	},
 +#ifdef CONFIG_ARM64_VA_BITS_52
 +	{
 +		.capability = ARM64_HAS_VA52,
 +		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
 +		.matches = has_cpuid_feature,
 +#ifdef CONFIG_ARM64_64K_PAGES
 +		.desc = "52-bit Virtual Addressing (LVA)",
 +		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, VARange, 52)
 +#else
 +		.desc = "52-bit Virtual Addressing (LPA2)",
 +#ifdef CONFIG_ARM64_4K_PAGES
 +		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, TGRAN4, 52_BIT)
 +#else
 +		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, TGRAN16, 52_BIT)
 +#endif
 +#endif
 +	},
 +#endif
++	{,
+ 		.desc = "NV1",
+ 		.capability = ARM64_HAS_HCR_NV1,
+ 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+ 		.matches = has_nv1,
+ 		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI_NV1)
+ 	},
  	{},
  };
  


