Return-Path: <kvm+bounces-32154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 218C99D3CEF
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D12B628372B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D75D1AF0AC;
	Wed, 20 Nov 2024 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBYp0u7u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191F61AFB31
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732111132; cv=none; b=P8i3K8ADBtmIx8AAfAA2cDIY8O/Z8+pjo7476+fb5KuYtGemF+KJc1/HIr5caKYmB5F7eBfrDkYAn4+4AFkqMbOAss405P8rUbODwJdqmYTNDvIWD4iZc6bSR/aWpTobtyRX5Ej2w2sf64Dr5JSr1KRyJzjbrQG4Q027jI6Cois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732111132; c=relaxed/simple;
	bh=GGcNVOjnyY/vATPGRZT9PLPqqk8UpHKcBKl4GEA0rQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y3p+4DDuSlF54VYMrXpHSyktXaYxIhRN/4cBkq5brhbPCmjoH9EdXT6nk0LCLinGVwHBM4zAtk0EolSXnuY13QFGJqkT+I8r+i57TMaD9GwcCbb1+uYVYsQHhKe17ucAKjstKJtbQQJaa8CQRLnvkKhw/hMEGkGti7M2StTr6xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aBYp0u7u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732111128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vxRtDrEBjgEbixTdr2AI8waAGDnMZEz+0IL4qBPz9sA=;
	b=aBYp0u7uUpmB9XQLWo1fJbT8C5MEYSx16vMete84cTrnrT8XemQkSSmd47n9Q3jYK7fVFH
	f7SJWbwW86/bXvRgEFRarzU0myFJPrECLG7xM7amaKRZBWkrFnqYDDElpnju8icBBaQMVx
	iKb71PxaMKhyvFLhNr+FojyjZHO+rZI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-Sbsqwj3yMyG_PvsiDHBhhg-1; Wed,
 20 Nov 2024 08:58:46 -0500
X-MC-Unique: Sbsqwj3yMyG_PvsiDHBhhg-1
X-Mimecast-MFC-AGG-ID: Sbsqwj3yMyG_PvsiDHBhhg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD5061955EEA;
	Wed, 20 Nov 2024 13:58:44 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0142C30001A0;
	Wed, 20 Nov 2024 13:58:43 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.13 merge window
Date: Wed, 20 Nov 2024 08:58:42 -0500
Message-ID: <20241120135842.79625-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Linus,

The following changes since commit 2d5404caa8c7bb5c4e0435f94b28834ae5456623:

  Linux 6.12-rc7 (2024-11-10 14:19:35 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9ee62c33c0fe017ee02501a877f6f562363122fa:

  KVM: x86: Break CONFIG_KVM_X86's direct dependency on KVM_INTEL || KVM_AMD (2024-11-19 19:34:51 -0500)

The only conflict is in arm64's sysreg tables and is between commit:

   034993461890 ("arm64/sysreg: Update ID_AA64MMFR1_EL1 to DDI0601 2024-09")

from the arm64 tree and commit:

   9ae424d2a1ae ("arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT")

from the kvm-arm tree.  The arm64 version is a superset of the KVM version.
There are also some arm64 changes such as commit 09e6b306f3ba ("arm64:
cpufeature: discover CPU support for MPAM") with acks from the maintainers.

Some RISC-V changes are missing and should come next week.

Thanks,

Paolo

----------------------------------------------------------------
The biggest change here is eliminating the awful idea that KVM had, of
essentially guessing which pfns are refcounted pages.  The reason to
do so was that KVM needs to map both non-refcounted pages (for example
BARs of VFIO devices) and VM_PFNMAP/VM_MIXMEDMAP VMAs that contain
refcounted pages.  However, the result was security issues in the past,
and more recently the inability to map VM_IO and VM_PFNMAP memory
that _is_ backed by struct page but is not refcounted.  In particular
this broke virtio-gpu blob resources (which directly map host graphics
buffers into the guest as "vram" for the virtio-gpu device) with the
amdgpu driver, because amdgpu allocates non-compound higher order pages
and the tail pages could not be mapped into KVM.

This requires adjusting all uses of struct page in the per-architecture
code, to always work on the pfn whenever possible.  The large series that
did this, from David Stevens and Sean Christopherson, also cleaned up
substantially the set of functions that provided arch code with the
pfn for a host virtual addresses.  The previous maze of twisty little
passages, all different, is replaced by five functions (__gfn_to_page,
__kvm_faultin_pfn, the non-__ versions of these two, and kvm_prefetch_pages)
saving almost 200 lines of code.

ARM:

* Support for stage-1 permission indirection (FEAT_S1PIE) and
  permission overlays (FEAT_S1POE), including nested virt + the
  emulated page table walker

* Introduce PSCI SYSTEM_OFF2 support to KVM + client driver. This call
  was introduced in PSCIv1.3 as a mechanism to request hibernation,
  similar to the S4 state in ACPI

* Explicitly trap + hide FEAT_MPAM (QoS controls) from KVM guests. As
  part of it, introduce trivial initialization of the host's MPAM
  context so KVM can use the corresponding traps

* PMU support under nested virtualization, honoring the guest
  hypervisor's trap configuration and event filtering when running a
  nested guest

* Fixes to vgic ITS serialization where stale device/interrupt table
  entries are not zeroed when the mapping is invalidated by the VM

* Avoid emulated MMIO completion if userspace has requested synchronous
  external abort injection

* Various fixes and cleanups affecting pKVM, vCPU initialization, and
  selftests

LoongArch:

* Add iocsr and mmio bus simulation in kernel.

* Add in-kernel interrupt controller emulation.

* Add support for virtualization extensions to the eiointc irqchip.

PPC:

* Drop lingering and utterly obsolete references to PPC970 KVM, which was
  removed 10 years ago.

* Fix incorrect documentation references to non-existing ioctls

RISC-V:

* Accelerate KVM RISC-V when running as a guest

* Perf support to collect KVM guest statistics from host side

s390:

* New selftests: more ucontrol selftests and CPU model sanity checks

* Support for the gen17 CPU model

* List registers supported by KVM_GET/SET_ONE_REG in the documentation

x86:

* Cleanup KVM's handling of Accessed and Dirty bits to dedup code, improve
  documentation, harden against unexpected changes.  Even if the hardware
  A/D tracking is disabled, it is possible to use the hardware-defined A/D
  bits to track if a PFN is Accessed and/or Dirty, and that removes a lot
  of special cases.

* Elide TLB flushes when aging secondary PTEs, as has been done in x86's
  primary MMU for over 10 years.

* Recover huge pages in-place in the TDP MMU when dirty page logging is
  toggled off, instead of zapping them and waiting until the page is
  re-accessed to create a huge mapping.  This reduces vCPU jitter.

* Batch TLB flushes when dirty page logging is toggled off.  This reduces
  the time it takes to disable dirty logging by ~3x.

* Remove the shrinker that was (poorly) attempting to reclaim shadow page
  tables in low-memory situations.

* Clean up and optimize KVM's handling of writes to MSR_IA32_APICBASE.

* Advertise CPUIDs for new instructions in Clearwater Forest

* Quirk KVM's misguided behavior of initialized certain feature MSRs to
  their maximum supported feature set, which can result in KVM creating
  invalid vCPU state.  E.g. initializing PERF_CAPABILITIES to a non-zero
  value results in the vCPU having invalid state if userspace hides PDCM
  from the guest, which in turn can lead to save/restore failures.

* Fix KVM's handling of non-canonical checks for vCPUs that support LA57
  to better follow the "architecture", in quotes because the actual
  behavior is poorly documented.  E.g. most MSR writes and descriptor
  table loads ignore CR4.LA57 and operate purely on whether the CPU
  supports LA57.

* Bypass the register cache when querying CPL from kvm_sched_out(), as
  filling the cache from IRQ context is generally unsafe; harden the
  cache accessors to try to prevent similar issues from occuring in the
  future.  The issue that triggered this change was already fixed in 6.12,
  but was still kinda latent.

* Advertise AMD_IBPB_RET to userspace, and fix a related bug where KVM
  over-advertises SPEC_CTRL when trying to support cross-vendor VMs.

* Minor cleanups

* Switch hugepage recovery thread to use vhost_task.  These kthreads can
  consume significant amounts of CPU time on behalf of a VM or in response
  to how the VM behaves (for example how it accesses its memory); therefore
  KVM tried to place the thread in the VM's cgroups and charge the CPU
  time consumed by that work to the VM's container.  However the kthreads
  did not process SIGSTOP/SIGCONT, and therefore cgroups which had KVM
  instances inside could not complete freezing.  Fix this by replacing the
  kthread with a PF_USER_WORKER thread, via the vhost_task abstraction.
  Another 100+ lines removed, with generally better behavior too like
  having these threads properly parented in the process tree.

* Revert a workaround for an old CPU erratum (Nehalem/Westmere) that didn't
  really work; there was really nothing to work around anyway: the broken
  patch was meant to fix nested virtualization, but the PERF_GLOBAL_CTRL
  MSR is virtualized and therefore unaffected by the erratum.

* Fix 6.12 regression where CONFIG_KVM will be built as a module even
  if asked to be builtin, as long as neither KVM_INTEL nor KVM_AMD is 'y'.

x86 selftests:

* x86 selftests can now use AVX.

Documentation:

* Use rST internal links

* Reorganize the introduction to the API document

Generic:

* Protect vcpu->pid accesses outside of vcpu->mutex with a rwlock instead
  of RCU, so that running a vCPU on a different task doesn't encounter long
  due to having to wait for all CPUs become quiescent.  In general both reads
  and writes are rare, but userspace that supports confidential computing is
  introducing the use of "helper" vCPUs that may jump from one host processor
  to another.  Those will be very happy to trigger a synchronize_rcu(), and
  the effect on performance is quite the disaster.

----------------------------------------------------------------
Anup Patel (13):
      RISC-V: KVM: Order the object files alphabetically
      RISC-V: KVM: Save/restore HSTATUS in C source
      RISC-V: KVM: Save/restore SCOUNTEREN in C source
      RISC-V: KVM: Break down the __kvm_riscv_switch_to() into macros
      RISC-V: KVM: Replace aia_set_hvictl() with aia_hvictl_value()
      RISC-V: KVM: Don't setup SGEI for zero guest external interrupts
      RISC-V: Add defines for the SBI nested acceleration extension
      RISC-V: KVM: Add common nested acceleration support
      RISC-V: KVM: Use nacl_csr_xyz() for accessing H-extension CSRs
      RISC-V: KVM: Use nacl_csr_xyz() for accessing AIA CSRs
      RISC-V: KVM: Use SBI sync SRET call when available
      RISC-V: KVM: Save trap CSRs in kvm_riscv_vcpu_enter_exit()
      RISC-V: KVM: Use NACL HFENCEs for KVM request based HFENCEs

Arnd Bergmann (1):
      KVM: x86: add back X86_LOCAL_APIC dependency

Ba Jing (1):
      KVM: selftests: Remove unused macro in the hardware disable test

Bibo Mao (1):
      irqchip/loongson-eiointc: Add virt extension support

Björn Töpel (1):
      riscv: kvm: Fix out-of-bounds array access

Christoph Schlameuss (5):
      KVM: s390: selftests: Add uc_map_unmap VM test case
      KVM: s390: selftests: Add uc_skey VM test case
      KVM: s390: selftests: Verify reject memory region operations for ucontrol VMs
      KVM: s390: selftests: Fix whitespace confusion in ucontrol test
      KVM: s390: selftests: correct IP.b length in uc_handle_sieic debug output

David Matlack (5):
      KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
      KVM: x86/mmu: Batch TLB flushes when zapping collapsible TDP MMU SPTEs
      KVM: x86/mmu: Recover TDP MMU huge page mappings in-place instead of zapping
      KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
      KVM: x86/mmu: WARN if huge page recovery triggered during dirty logging

David Stevens (3):
      KVM: Replace "async" pointer in gfn=>pfn with "no_wait" and error code
      KVM: Introduce kvm_follow_pfn() to eventually replace "gfn_to_pfn" APIs
      KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()

David Woodhouse (6):
      firmware/psci: Add definitions for PSCI v1.3 specification
      KVM: arm64: Add PSCI v1.3 SYSTEM_OFF2 function for hibernation
      KVM: arm64: Add support for PSCI v1.2 and v1.3
      KVM: selftests: Add test for PSCI SYSTEM_OFF2
      KVM: arm64: nvhe: Pass through PSCI v1.3 SYSTEM_OFF2 call
      arm64: Use SYSTEM_OFF2 PSCI call to power off for hibernate

Fuad Tabba (4):
      KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
      KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
      KVM: arm64: Initialize the hypervisor's VM state at EL2
      KVM: arm64: Initialize trap register values in hyp in pKVM

Hariharan Mari (5):
      KVM: s390: selftests: Add regression tests for SORTL and DFLTCC CPU subfunctions
      KVM: s390: selftests: Add regression tests for PRNO, KDSA and KMA crypto subfunctions
      KVM: s390: selftests: Add regression tests for KMCTR, KMF, KMO and PCC crypto subfunctions
      KVM: s390: selftests: Add regression tests for KMAC, KMC, KM, KIMD and KLMD crypto subfunctions
      KVM: s390: selftests: Add regression tests for PLO subfunctions

Hendrik Brueckner (4):
      KVM: s390: add concurrent-function facility to cpu model
      KVM: s390: add msa11 to cpu model
      KVM: s390: add gen17 facilities to CPU model
      KVM: s390: selftests: Add regression tests for PFCR subfunctions

James Clark (1):
      KVM: arm64: Pass on SVE mapping failures

James Morse (7):
      arm64/sysreg: Convert existing MPAM sysregs and add the remaining entries
      arm64: head.S: Initialise MPAM EL2 registers and disable traps
      arm64: cpufeature: discover CPU support for MPAM
      KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
      KVM: arm64: Add a macro for creating filtered sys_reg_descs entries
      KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
      KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely ignored

Jiapeng Chong (1):
      KVM: selftests: Use ARRAY_SIZE for array length

Jim Mattson (2):
      KVM: x86: Advertise AMD_IBPB_RET to userspace
      KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB

Jing Zhang (1):
      KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*

Kai Huang (2):
      KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
      KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()

Kunkun Jiang (2):
      KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
      KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

Marc Zyngier (33):
      arm64: Drop SKL0/SKL1 from TCR2_EL2
      arm64: Remove VNCR definition for PIRE0_EL2
      arm64: Add encoding for PIRE0_EL2
      KVM: arm64: Drop useless struct s2_mmu in __kvm_at_s1e2()
      KVM: arm64: nv: Add missing EL2->EL1 mappings in get_el2_to_el1_mapping()
      KVM: arm64: nv: Handle CNTHCTL_EL2 specially
      arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
      KVM: arm64: Add TCR2_EL2 to the sysreg arrays
      KVM: arm64: nv: Save/Restore vEL2 sysregs
      KVM: arm64: Sanitise TCR2_EL2
      KVM: arm64: Correctly access TCR2_EL1, PIR_EL1, PIRE0_EL1 with VHE
      KVM: arm64: Add save/restore for TCR2_EL2
      KVM: arm64: Extend masking facility to arbitrary registers
      KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
      KVM: arm64: Add save/restore for PIR{,E0}_EL2
      KVM: arm64: Handle PIR{,E0}_EL2 traps
      KVM: arm64: Add AT fast-path support for S1PIE
      KVM: arm64: Split S1 permission evaluation into direct and hierarchical parts
      KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
      KVM: arm64: Implement AT S1PIE support
      KVM: arm64: Add a composite EL2 visibility helper
      KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
      arm64: Add encoding for POR_EL2
      KVM: arm64: Drop bogus CPTR_EL2.E0POE trap routing
      KVM: arm64: Subject S1PIE/S1POE registers to HCR_EL2.{TVM,TRVM}
      KVM: arm64: Add kvm_has_s1poe() helper
      KVM: arm64: Add basic support for POR_EL2
      KVM: arm64: Add save/restore support for POR_EL2
      KVM: arm64: Add POE save/restore for AT emulation fast-path
      KVM: arm64: Disable hierarchical permissions when POE is enabled
      KVM: arm64: Make PAN conditions part of the S1 walk context
      KVM: arm64: Handle stage-1 permission overlays
      KVM: arm64: Handle WXN attribute

Mark Brown (3):
      KVM: arm64: Define helper for EL2 registers with custom visibility
      KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
      KVM: arm64: Hide S1PIE registers from userspace when disabled for guests

Maxim Levitsky (5):
      KVM: x86: drop x86.h include from cpuid.h
      KVM: x86: Route non-canonical checks in emulator through emulate_ops
      KVM: x86: Add X86EMUL_F_MSR and X86EMUL_F_DT_LOAD to aid canonical checks
      KVM: x86: model canonical checks more precisely
      KVM: nVMX: fix canonical check of vmcs12 HOST_RIP

Oliver Upton (28):
      KVM: arm64: Don't retire aborted MMIO instruction
      tools: arm64: Grab a copy of esr.h from kernel
      KVM: arm64: selftests: Convert to kernel's ESR terminology
      KVM: arm64: selftests: Add tests for MMIO external abort injection
      arm64: sysreg: Describe ID_AA64DFR2_EL1 fields
      arm64: sysreg: Migrate MDCR_EL2 definition to table
      arm64: sysreg: Add new definitions for ID_AA64DFR0_EL1
      KVM: arm64: Describe RES0/RES1 bits of MDCR_EL2
      KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
      KVM: arm64: nv: Rename BEHAVE_FORWARD_ANY
      KVM: arm64: nv: Reinject traps that take effect in Host EL0
      KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
      KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
      KVM: arm64: nv: Advertise support for FEAT_HPMN0
      KVM: arm64: Rename kvm_pmu_valid_counter_mask()
      KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN
      KVM: arm64: Add helpers to determine if PMC counts at a given EL
      KVM: arm64: nv: Honor MDCR_EL2.HPME
      KVM: arm64: nv: Honor MDCR_EL2.HLP
      KVM: arm64: nv: Apply EL2 event filtering when in hyp context
      KVM: arm64: nv: Reprogram PMU events affected by nested transition
      Merge branch kvm-arm64/nv-s1pie-s1poe into kvmarm/next
      Merge branch kvm-arm64/psci-1.3 into kvmarm/next
      Merge branch kvm-arm64/mpam-ni into kvmarm/next
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/mmio-sea into kvmarm/next
      Merge branch kvm-arm64/nv-pmu into kvmarm/next
      Merge branch kvm-arm64/vgic-its-fixes into kvmarm/next

Paolo Bonzini (18):
      Merge branch 'kvm-no-struct-page' into HEAD
      KVM: powerpc: remove remaining traces of KVM_CAP_PPC_RMA
      Documentation: kvm: fix a few mistakes
      Documentation: kvm: replace section numbers with links
      Documentation: kvm: reorganize introduction
      Merge tag 'kvm-riscv-6.13-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-s390-next-6.13-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvm-x86-generic-6.13' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.13' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.13' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.13' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.13' of https://github.com/kvm-x86/linux into HEAD
      Merge branch 'kvm-docs-6.13' into HEAD
      Documentation: KVM: fix malformed table
      KVM: x86: expose MSR_PLATFORM_INFO as a feature MSR
      Merge tag 'kvmarm-6.13' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'loongarch-kvm-6.13' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      KVM: x86: switch hugepage recovery thread to vhost_task

Quan Zhou (2):
      riscv: perf: add guest vs host distinction
      riscv: KVM: add basic support for host vs guest profiling

Raghavendra Rao Ananta (1):
      KVM: arm64: Get rid of userspace_irqchip_in_use

Sean Christopherson (142):
      KVM: Drop KVM_ERR_PTR_BAD_PAGE and instead return NULL to indicate an error
      KVM: Allow calling kvm_release_page_{clean,dirty}() on a NULL page pointer
      KVM: Add kvm_release_page_unused() API to put pages that KVM never consumes
      KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf SPTE
      KVM: x86/mmu: Don't overwrite shadow-present MMU SPTEs when prefaulting
      KVM: x86/mmu: Invert @can_unsync and renamed to @synchronizing
      KVM: x86/mmu: Mark new SPTE as Accessed when synchronizing existing SPTE
      KVM: x86/mmu: Mark folio dirty when creating SPTE, not when zapping/modifying
      KVM: x86/mmu: Mark page/folio accessed only when zapping leaf SPTEs
      KVM: x86/mmu: Use gfn_to_page_many_atomic() when prefetching indirect PTEs
      KVM: Rename gfn_to_page_many_atomic() to kvm_prefetch_pages()
      KVM: Drop @atomic param from gfn=>pfn and hva=>pfn APIs
      KVM: Annotate that all paths in hva_to_pfn() might sleep
      KVM: Return ERR_SIGPENDING from hva_to_pfn() if GUP returns -EGAIN
      KVM: Drop extra GUP (via check_user_page_hwpoison()) to detect poisoned page
      KVM: x86/mmu: Drop kvm_page_fault.hva, i.e. don't track intermediate hva
      KVM: Drop unused "hva" pointer from __gfn_to_pfn_memslot()
      KVM: Remove pointless sanity check on @map param to kvm_vcpu_(un)map()
      KVM: Explicitly initialize all fields at the start of kvm_vcpu_map()
      KVM: Use NULL for struct page pointer to indicate mremapped memory
      KVM: nVMX: Rely on kvm_vcpu_unmap() to track validity of eVMCS mapping
      KVM: nVMX: Drop pointless msr_bitmap_map field from struct nested_vmx
      KVM: nVMX: Add helper to put (unmap) vmcs12 pages
      KVM: Use plain "struct page" pointer instead of single-entry array
      KVM: Provide refcounted page as output field in struct kvm_follow_pfn
      KVM: Move kvm_{set,release}_page_{clean,dirty}() helpers up in kvm_main.c
      KVM: pfncache: Precisely track refcounted pages
      KVM: Pin (as in FOLL_PIN) pages during kvm_vcpu_map()
      KVM: nVMX: Mark vmcs12's APIC access page dirty when unmapping
      KVM: Pass in write/dirty to kvm_vcpu_map(), not kvm_vcpu_unmap()
      KVM: Get writable mapping for __kvm_vcpu_map() only when necessary
      KVM: Disallow direct access (w/o mmu_notifier) to unpinned pfn by default
      KVM: x86: Don't fault-in APIC access page during initial allocation
      KVM: x86/mmu: Add "mmu" prefix fault-in helpers to free up generic names
      KVM: x86/mmu: Put direct prefetched pages via kvm_release_page_clean()
      KVM: x86/mmu: Add common helper to handle prefetching SPTEs
      KVM: x86/mmu: Add helper to "finish" handling a guest page fault
      KVM: x86/mmu: Mark pages/folios dirty at the origin of make_spte()
      KVM: Move declarations of memslot accessors up in kvm_host.h
      KVM: Add kvm_faultin_pfn() to specifically service guest page faults
      KVM: x86/mmu: Convert page fault paths to kvm_faultin_pfn()
      KVM: guest_memfd: Pass index, not gfn, to __kvm_gmem_get_pfn()
      KVM: guest_memfd: Provide "struct page" as output from kvm_gmem_get_pfn()
      KVM: x86/mmu: Put refcounted pages instead of blindly releasing pfns
      KVM: x86/mmu: Don't mark unused faultin pages as accessed
      KVM: Move x86's API to release a faultin page to common KVM
      KVM: VMX: Hold mmu_lock until page is released when updating APIC access page
      KVM: VMX: Use __kvm_faultin_page() to get APIC access page/pfn
      KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()
      KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock
      KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults
      KVM: arm64: Mark "struct page" pfns accessed/dirty before dropping mmu_lock
      KVM: arm64: Use __kvm_faultin_pfn() to handle memory aborts
      KVM: RISC-V: Mark "struct page" pfns dirty iff a stage-2 PTE is installed
      KVM: RISC-V: Mark "struct page" pfns accessed before dropping mmu_lock
      KVM: RISC-V: Use kvm_faultin_pfn() when mapping pfns into the guest
      KVM: PPC: Use __kvm_faultin_pfn() to handle page faults on Book3s HV
      KVM: PPC: Use __kvm_faultin_pfn() to handle page faults on Book3s Radix
      KVM: PPC: Drop unused @kvm_ro param from kvmppc_book3s_instantiate_page()
      KVM: PPC: Book3S: Mark "struct page" pfns dirty/accessed after installing PTE
      KVM: PPC: Use kvm_faultin_pfn() to handle page faults on Book3s PR
      KVM: LoongArch: Mark "struct page" pfns dirty only in "slow" page fault path
      KVM: LoongArch: Mark "struct page" pfns accessed only in "slow" page fault path
      KVM: LoongArch: Mark "struct page" pfn accessed before dropping mmu_lock
      KVM: LoongArch: Use kvm_faultin_pfn() to map pfns into the guest
      KVM: MIPS: Mark "struct page" pfns dirty only in "slow" page fault path
      KVM: MIPS: Mark "struct page" pfns accessed only in "slow" page fault path
      KVM: MIPS: Mark "struct page" pfns accessed prior to dropping mmu_lock
      KVM: MIPS: Use kvm_faultin_pfn() to map pfns into the guest
      KVM: PPC: Remove extra get_page() to fix page refcount leak
      KVM: PPC: Use kvm_vcpu_map() to map guest memory to patch dcbz instructions
      KVM: Convert gfn_to_page() to use kvm_follow_pfn()
      KVM: Add support for read-only usage of gfn_to_page()
      KVM: arm64: Use __gfn_to_page() when copying MTE tags to/from userspace
      KVM: PPC: Explicitly require struct page memory for Ultravisor sharing
      KVM: Drop gfn_to_pfn() APIs now that all users are gone
      KVM: s390: Use kvm_release_page_dirty() to unpin "struct page" memory
      KVM: Make kvm_follow_pfn.refcounted_page a required field
      KVM: x86/mmu: Don't mark "struct page" accessed when zapping SPTEs
      KVM: arm64: Don't mark "struct page" accessed when making SPTE young
      KVM: Drop APIs that manipulate "struct page" via pfns
      KVM: Don't grab reference on VM_MIXEDMAP pfns that have a "struct page"
      KVM: Rework core loop of kvm_vcpu_on_spin() to use a single for-loop
      KVM: Return '0' directly when there's no task to yield to
      KVM: Protect vCPU's "last run PID" with rwlock, not RCU
      KVM: x86/mmu: Flush remote TLBs iff MMU-writable flag is cleared from RO SPTE
      KVM: x86/mmu: Always set SPTE's dirty bit if it's created as writable
      KVM: x86/mmu: Fold all of make_spte()'s writable handling into one if-else
      KVM: x86/mmu: Don't force flush if SPTE update clears Accessed bit
      KVM: x86/mmu: Don't flush TLBs when clearing Dirty bit in shadow MMU
      KVM: x86/mmu: Drop ignored return value from kvm_tdp_mmu_clear_dirty_slot()
      KVM: x86/mmu: Fold mmu_spte_update_no_track() into mmu_spte_update()
      KVM: x86/mmu: WARN and flush if resolving a TDP MMU fault clears MMU-writable
      KVM: x86/mmu: Add a dedicated flag to track if A/D bits are globally enabled
      KVM: x86/mmu: Set shadow_accessed_mask for EPT even if A/D bits disabled
      KVM: x86/mmu: Set shadow_dirty_mask for EPT even if A/D bits disabled
      KVM: x86/mmu: Use Accessed bit even when _hardware_ A/D bits are disabled
      KVM: x86/mmu: Process only valid TDP MMU roots when aging a gfn range
      KVM: x86/mmu: Stop processing TDP MMU roots for test_age if young SPTE found
      KVM: x86/mmu: Dedup logic for detecting TLB flushes on leaf SPTE changes
      KVM: x86/mmu: Set Dirty bit for new SPTEs, even if _hardware_ A/D bits are disabled
      KVM: Allow arch code to elide TLB flushes when aging a young page
      KVM: x86: Don't emit TLB flushes when aging SPTEs for mmu_notifiers
      KVM: x86: Ensure vcpu->mode is loaded from memory in kvm_vcpu_exit_request()
      KVM: x86: Bypass register cache when querying CPL from kvm_sched_out()
      KVM: x86: Add lockdep-guarded asserts on register cache usage
      KVM: x86: Use '0' for guest RIP if PMI encounters protected guest state
      KVM: x86: Document an erratum in KVM_SET_VCPU_EVENTS on Intel CPUs
      KVM: x86: Co-locate initialization of feature MSRs in kvm_arch_vcpu_create()
      KVM: x86: Disallow changing MSR_PLATFORM_INFO after vCPU has run
      KVM: x86: Quirk initialization of feature MSRs to KVM's max configuration
      KVM: x86: Reject userspace attempts to access PERF_CAPABILITIES w/o PDCM
      KVM: VMX: Remove restriction that PMU version > 0 for PERF_CAPABILITIES
      KVM: x86: Reject userspace attempts to access ARCH_CAPABILITIES w/o support
      KVM: x86: Remove ordering check b/w MSR_PLATFORM_INFO and MISC_FEATURES_ENABLES
      KVM: selftests: Verify get/set PERF_CAPABILITIES w/o guest PDMC behavior
      KVM: selftests: Add a testcase for disabling feature MSRs init quirk
      KVM: selftests: Precisely mask off dynamic fields in CPUID test
      KVM: selftests: Mask off OSPKE and OSXSAVE when comparing CPUID entries
      KVM: selftests: Rework OSXSAVE CR4=>CPUID test to play nice with AVX insns
      KVM: selftests: Configure XCR0 to max supported value by default
      KVM: selftests: Verify XCR0 can be "downgraded" and "upgraded"
      KVM: selftests: Drop manual CR4.OSXSAVE enabling from CR4/CPUID sync test
      KVM: selftests: Drop manual XCR0 configuration from AMX test
      KVM: selftests: Drop manual XCR0 configuration from state test
      KVM: selftests: Drop manual XCR0 configuration from SEV smoke test
      KVM: selftests: Ensure KVM supports AVX for SEV-ES VMSA FPU test
      KVM: x86/mmu: Check yielded_gfn for forward progress iff resched is needed
      KVM: x86/mmu: Demote the WARN on yielded in xxx_cond_resched() to KVM_MMU_WARN_ON
      KVM: x86/mmu: Refactor TDP MMU iter need resched check
      KVM: x86: Short-circuit all kvm_lapic_set_base() if MSR value isn't changing
      KVM: x86: Drop superfluous kvm_lapic_set_base() call when setting APIC state
      KVM: x86: Get vcpu->arch.apic_base directly and drop kvm_get_apic_base()
      KVM: x86: Inline kvm_get_apic_mode() in lapic.h
      KVM: x86: Move kvm_set_apic_base() implementation to lapic.c (from x86.c)
      KVM: x86: Rename APIC base setters to better capture their relationship
      KVM: x86: Make kvm_recalculate_apic_map() local to lapic.c
      KVM: x86: Unpack msr_data structure prior to calling kvm_apic_set_base()
      KVM: x86: Short-circuit all of kvm_apic_set_base() if MSR value is unchanged
      KVM: selftests: Don't bother deleting memslots in KVM when freeing VMs
      Revert "KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()"
      KVM: x86: Break CONFIG_KVM_X86's direct dependency on KVM_INTEL || KVM_AMD

Shameer Kolothum (1):
      KVM: arm64: Make L1Ip feature in CTR_EL0 writable from userspace

Tao Su (1):
      x86: KVM: Advertise CPUIDs for new instructions in Clearwater Forest

Vipin Sharma (2):
      KVM: x86/mmu: Remove KVM's MMU shrinker
      KVM: x86/mmu: Drop per-VM zapped_obsolete_pages list

Will Deacon (2):
      KVM: arm64: Just advertise SEIS as 0 when emulating ICC_CTLR_EL1
      KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2 with pKVM

Xianglai Li (11):
      LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
      LoongArch: KVM: Add IPI device support
      LoongArch: KVM: Add IPI read and write function
      LoongArch: KVM: Add IPI user mode read and write function
      LoongArch: KVM: Add EIOINTC device support
      LoongArch: KVM: Add EIOINTC read and write functions
      LoongArch: KVM: Add EIOINTC user mode read and write functions
      LoongArch: KVM: Add PCHPIC device support
      LoongArch: KVM: Add PCHPIC read and write functions
      LoongArch: KVM: Add PCHPIC user mode read and write functions
      LoongArch: KVM: Add irqfd support

Yan Zhao (1):
      KVM: VMX: Remove the unused variable "gpa" in __invept()

Yong-Xuan Wang (1):
      RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation


 Documentation/arch/arm64/cpu-feature-registers.rst |    2 +
 Documentation/arch/loongarch/irq-chip-model.rst    |   64 ++
 .../zh_CN/arch/loongarch/irq-chip-model.rst        |   55 +
 Documentation/virt/kvm/api.rst                     |  190 ++--
 Documentation/virt/kvm/locking.rst                 |   80 +-
 Documentation/virt/kvm/x86/errata.rst              |   12 +
 arch/arm64/include/asm/cpu.h                       |    1 +
 arch/arm64/include/asm/cpucaps.h                   |    5 +
 arch/arm64/include/asm/cpufeature.h                |   17 +
 arch/arm64/include/asm/el2_setup.h                 |   14 +
 arch/arm64/include/asm/kvm_arm.h                   |   30 +-
 arch/arm64/include/asm/kvm_asm.h                   |    1 -
 arch/arm64/include/asm/kvm_emulate.h               |    9 +
 arch/arm64/include/asm/kvm_host.h                  |   46 +-
 arch/arm64/include/asm/kvm_pgtable.h               |    4 +-
 arch/arm64/include/asm/sysreg.h                    |   12 -
 arch/arm64/include/asm/vncr_mapping.h              |    1 -
 arch/arm64/include/uapi/asm/kvm.h                  |    6 +
 arch/arm64/kernel/cpufeature.c                     |   96 ++
 arch/arm64/kernel/cpuinfo.c                        |    3 +
 arch/arm64/kvm/arch_timer.c                        |    3 +-
 arch/arm64/kvm/arm.c                               |   26 +-
 arch/arm64/kvm/at.c                                |  484 +++++++--
 arch/arm64/kvm/emulate-nested.c                    |  301 +++---
 arch/arm64/kvm/guest.c                             |   15 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   31 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |   11 +-
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |    2 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   12 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  116 ++-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |    2 +
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   20 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c                |    2 +-
 arch/arm64/kvm/hyp/pgtable.c                       |    7 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |    3 -
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  160 ++-
 arch/arm64/kvm/hypercalls.c                        |    2 +
 arch/arm64/kvm/mmio.c                              |   32 +-
 arch/arm64/kvm/mmu.c                               |   21 +-
 arch/arm64/kvm/nested.c                            |   82 +-
 arch/arm64/kvm/pmu-emul.c                          |  143 ++-
 arch/arm64/kvm/psci.c                              |   44 +-
 arch/arm64/kvm/reset.c                             |    5 -
 arch/arm64/kvm/sys_regs.c                          |  309 ++++--
 arch/arm64/kvm/vgic/vgic-its.c                     |   32 +-
 arch/arm64/kvm/vgic/vgic.h                         |   23 +
 arch/arm64/tools/cpucaps                           |    2 +
 arch/arm64/tools/sysreg                            |  249 ++++-
 arch/loongarch/include/asm/irq.h                   |    1 +
 arch/loongarch/include/asm/kvm_eiointc.h           |  123 +++
 arch/loongarch/include/asm/kvm_host.h              |   18 +-
 arch/loongarch/include/asm/kvm_ipi.h               |   45 +
 arch/loongarch/include/asm/kvm_pch_pic.h           |   62 ++
 arch/loongarch/include/uapi/asm/kvm.h              |   20 +
 arch/loongarch/kvm/Kconfig                         |    5 +-
 arch/loongarch/kvm/Makefile                        |    4 +
 arch/loongarch/kvm/exit.c                          |   82 +-
 arch/loongarch/kvm/intc/eiointc.c                  | 1027 ++++++++++++++++++
 arch/loongarch/kvm/intc/ipi.c                      |  475 +++++++++
 arch/loongarch/kvm/intc/pch_pic.c                  |  519 +++++++++
 arch/loongarch/kvm/irqfd.c                         |   89 ++
 arch/loongarch/kvm/main.c                          |   19 +-
 arch/loongarch/kvm/mmu.c                           |   40 +-
 arch/loongarch/kvm/vcpu.c                          |    3 +
 arch/loongarch/kvm/vm.c                            |   21 +
 arch/mips/kvm/mmu.c                                |   26 +-
 arch/powerpc/include/asm/kvm_book3s.h              |    4 +-
 arch/powerpc/kvm/book3s.c                          |    7 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c              |    7 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c              |   12 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   25 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   35 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |    4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   25 +-
 arch/powerpc/kvm/book3s_pr.c                       |   14 +-
 arch/powerpc/kvm/book3s_xive_native.c              |    2 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |   19 +-
 arch/powerpc/kvm/powerpc.c                         |    3 -
 arch/riscv/include/asm/kvm_host.h                  |   10 +
 arch/riscv/include/asm/kvm_nacl.h                  |  245 +++++
 arch/riscv/include/asm/perf_event.h                |    6 +
 arch/riscv/include/asm/sbi.h                       |  120 +++
 arch/riscv/kernel/perf_callchain.c                 |   38 +
 arch/riscv/kvm/Kconfig                             |    1 +
 arch/riscv/kvm/Makefile                            |   27 +-
 arch/riscv/kvm/aia.c                               |  114 +-
 arch/riscv/kvm/aia_aplic.c                         |    3 +-
 arch/riscv/kvm/main.c                              |   63 +-
 arch/riscv/kvm/mmu.c                               |   13 +-
 arch/riscv/kvm/nacl.c                              |  152 +++
 arch/riscv/kvm/tlb.c                               |   57 +-
 arch/riscv/kvm/vcpu.c                              |  191 +++-
 arch/riscv/kvm/vcpu_sbi.c                          |   11 +-
 arch/riscv/kvm/vcpu_switch.S                       |  137 ++-
 arch/riscv/kvm/vcpu_timer.c                        |   28 +-
 arch/s390/include/asm/kvm_host.h                   |    1 +
 arch/s390/include/uapi/asm/kvm.h                   |    3 +-
 arch/s390/kvm/kvm-s390.c                           |   43 +-
 arch/s390/kvm/vsie.c                               |    7 +-
 arch/s390/tools/gen_facilities.c                   |    2 +
 arch/x86/include/asm/cpufeatures.h                 |    3 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    1 +
 arch/x86/include/asm/kvm_host.h                    |   13 +-
 arch/x86/include/uapi/asm/kvm.h                    |    1 +
 arch/x86/kvm/Kconfig                               |    6 +-
 arch/x86/kvm/cpuid.c                               |   22 +-
 arch/x86/kvm/cpuid.h                               |    1 -
 arch/x86/kvm/emulate.c                             |   15 +-
 arch/x86/kvm/kvm_cache_regs.h                      |   17 +
 arch/x86/kvm/kvm_emulate.h                         |    5 +
 arch/x86/kvm/lapic.c                               |   51 +-
 arch/x86/kvm/lapic.h                               |   11 +-
 arch/x86/kvm/mmu.h                                 |    1 +
 arch/x86/kvm/mmu/mmu.c                             |  444 +++-----
 arch/x86/kvm/mmu/mmu_internal.h                    |   10 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   31 +-
 arch/x86/kvm/mmu/spte.c                            |  102 +-
 arch/x86/kvm/mmu/spte.h                            |   78 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  280 +++--
 arch/x86/kvm/mmu/tdp_mmu.h                         |    6 +-
 arch/x86/kvm/mtrr.c                                |    1 +
 arch/x86/kvm/reverse_cpuid.h                       |    1 +
 arch/x86/kvm/svm/nested.c                          |    4 +-
 arch/x86/kvm/svm/sev.c                             |   12 +-
 arch/x86/kvm/svm/svm.c                             |   13 +-
 arch/x86/kvm/vmx/hyperv.c                          |    1 +
 arch/x86/kvm/vmx/main.c                            |    1 +
 arch/x86/kvm/vmx/nested.c                          |   77 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |    2 +-
 arch/x86/kvm/vmx/sgx.c                             |    5 +-
 arch/x86/kvm/vmx/vmx.c                             |  131 +--
 arch/x86/kvm/vmx/vmx.h                             |    3 +-
 arch/x86/kvm/vmx/vmx_ops.h                         |   16 +-
 arch/x86/kvm/x86.c                                 |  141 ++-
 arch/x86/kvm/x86.h                                 |   48 +-
 drivers/firmware/psci/psci.c                       |   45 +
 drivers/irqchip/irq-loongson-eiointc.c             |  102 +-
 include/kvm/arm_arch_timer.h                       |    3 +
 include/kvm/arm_pmu.h                              |   18 +-
 include/kvm/arm_psci.h                             |    4 +-
 include/linux/kvm_host.h                           |  127 ++-
 include/trace/events/kvm.h                         |   35 +
 include/uapi/linux/kvm.h                           |    8 +
 include/uapi/linux/psci.h                          |    5 +
 kernel/power/hibernate.c                           |    5 +-
 tools/arch/arm64/include/asm/brk-imm.h             |   42 +
 tools/arch/arm64/include/asm/esr.h                 |  455 ++++++++
 tools/arch/s390/include/uapi/asm/kvm.h             |    3 +-
 tools/testing/selftests/kvm/Makefile               |    5 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |   10 +-
 tools/testing/selftests/kvm/aarch64/mmio_abort.c   |  159 +++
 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c   |    2 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |    4 +-
 tools/testing/selftests/kvm/aarch64/psci_test.c    |   92 ++
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |   99 +-
 .../selftests/kvm/aarch64/vpmu_counter_access.c    |   12 +-
 .../testing/selftests/kvm/hardware_disable_test.c  |    1 -
 .../selftests/kvm/include/aarch64/processor.h      |   15 +-
 .../testing/selftests/kvm/include/s390x/facility.h |   50 +
 .../selftests/kvm/include/s390x/processor.h        |    6 +
 .../selftests/kvm/include/x86_64/processor.h       |    5 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |    6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   10 +-
 tools/testing/selftests/kvm/lib/s390x/facility.c   |   14 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   24 +
 .../selftests/kvm/s390x/cpumodel_subfuncs_test.c   |  301 ++++++
 tools/testing/selftests/kvm/s390x/ucontrol_test.c  |  322 +++++-
 tools/testing/selftests/kvm/x86_64/amx_test.c      |   23 +-
 tools/testing/selftests/kvm/x86_64/cpuid_test.c    |   67 +-
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     |   53 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c    |    2 +-
 .../selftests/kvm/x86_64/feature_msrs_test.c       |  113 ++
 .../selftests/kvm/x86_64/get_msr_index_features.c  |   35 -
 .../selftests/kvm/x86_64/platform_info_test.c      |    2 -
 .../testing/selftests/kvm/x86_64/sev_smoke_test.c  |   19 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |    5 -
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   23 +
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |   11 +-
 virt/kvm/Kconfig                                   |    4 +
 virt/kvm/guest_memfd.c                             |   28 +-
 virt/kvm/kvm_main.c                                | 1098 ++++++++------------
 virt/kvm/kvm_mm.h                                  |   36 +-
 virt/kvm/pfncache.c                                |   20 +-
 183 files changed, 9216 insertions(+), 2655 deletions(-)


