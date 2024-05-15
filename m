Return-Path: <kvm+bounces-17453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 224578C6BBB
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 19:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8953B1F2331A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CAB158D76;
	Wed, 15 May 2024 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDfg1h+i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6331E158878
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 17:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715795466; cv=none; b=KccUbikGVfGRD7NOtoze2S36dNeSDbWxTA1ujZU2xYKkBDHhn28sIZpJYx1AO5yQZhvWcoUeJmUyUfxzMoaNmm6vOG+4PU5w0BZtVkz1vG0Xb63zPbf/kWEP9tdFWEE8pFv2+b7rWvQ99fUs/fDuwiBVAOy0h1JRdPdX6QIZuBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715795466; c=relaxed/simple;
	bh=57YhwDLz5OR+rAAleHIvItEhHluwcCnrZUlceDt69O4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VG1n1WEJ8CFrHeTb7bFAOtYDi/9wUFj79ftyYm4p9mC9dLGDefcj9NKwJF8MTcW23hRhRQ0ZVyahNJ5Y30suyv8scF+sdNFftKCMu8HlH2pD3gARwK2iVy2Ncyouo+AoQh0N7BJwhigHo1d7crNTggTAkVHEpTES1EGFVQVDXhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDfg1h+i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715795461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hgQrUw9EiGc659JG52BzXScbGH4AEnL41icB4H7QJ3U=;
	b=hDfg1h+i11PR0XHu6EV/O9crYjynVcDuAAtZtW6antwtxLF9Y0SgbAvNAJuopfoLnT2A7c
	Rwfs+L4sa4862ohOAb85A6xUHZeVOZmi3SWknH3su+9jw2irvaDRFmaoHltVjkVKYx02A6
	4JQyavxU2eLBja4YR9enw8omzlK+D5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-DmAOZzfhO52YhnMqk760Qw-1; Wed, 15 May 2024 13:50:58 -0400
X-MC-Unique: DmAOZzfhO52YhnMqk760Qw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4D36800074;
	Wed, 15 May 2024 17:50:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79873C15BB9;
	Wed, 15 May 2024 17:50:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.10 merge window
Date: Wed, 15 May 2024 13:50:51 -0400
Message-ID: <20240515175056.4050172-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Linus,

The following changes since commit dd5a440a31fae6e459c0d6271dddd62825505361:

  Linux 6.9-rc7 (2024-05-05 14:06:01 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to cba23f333fedf8e39743b0c9787b45a5bd7d03af:

  selftests/kvm: remove dead file (2024-05-15 13:40:16 -0400)

(Yes, the top commit is something I noticed right now while preparing
this message and reviewing the diffstat.  The patch itself is innocuous,
but still---guilty as charged).

There is a small semantic conflict that you will have to fix on merge:

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7c546ad3e4c9..d4ed681785fd 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,7 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "posted_intr.h"
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\

What happened is that commit 699f67512f04 ("KVM: VMX: Move posted
interrupt descriptor out of VMX code", from the tip tree) removed the
posted_intr.h include from vmx.h, and now the line has to be added back
into a .c file that is new in this merge.

Compared to the kvm/next branch which is included in linux-next, support
for AMD SEV-SNP is missing from this pull request.  I prepared this
tag a few days ago and at the time I wanted to double check that my
comaintainer agreed it was ready---both implementation and UAPI-wise.
I left it out of the tag for the time being, but we have discussed it
since and it will arrive early next week.

Thanks,

Paolo

----------------------------------------------------------------
ARM:

* Move a lot of state that was previously stored on a per vcpu
  basis into a per-CPU area, because it is only pertinent to the
  host while the vcpu is loaded. This results in better state
  tracking, and a smaller vcpu structure.

* Add full handling of the ERET/ERETAA/ERETAB instructions in
  nested virtualisation. The last two instructions also require
  emulating part of the pointer authentication extension.
  As a result, the trap handling of pointer authentication has
  been greatly simplified.

* Turn the global (and not very scalable) LPI translation cache
  into a per-ITS, scalable cache, making non directly injected
  LPIs much cheaper to make visible to the vcpu.

* A batch of pKVM patches, mostly fixes and cleanups, as the
  upstreaming process seems to be resuming. Fingers crossed!

* Allocate PPIs and SGIs outside of the vcpu structure, allowing
  for smaller EL2 mapping and some flexibility in implementing
  more or less than 32 private IRQs.

* Purge stale mpidr_data if a vcpu is created after the MPIDR
  map has been created.

* Preserve vcpu-specific ID registers across a vcpu reset.

* Various minor cleanups and improvements.

LoongArch:

* Add ParaVirt IPI support.

* Add software breakpoint support.

* Add mmio trace events support.

RISC-V:

* Support guest breakpoints using ebreak

* Introduce per-VCPU mp_state_lock and reset_cntx_lock

* Virtualize SBI PMU snapshot and counter overflow interrupts

* New selftests for SBI PMU and Guest ebreak

* Some preparatory work for both TDX and SNP page fault handling.
  This also cleans up the page fault path, so that the priorities
  of various kinds of fauls (private page, no memory, write
  to read-only slot, etc.) are easier to follow.

x86:

* Minimize amount of time that shadow PTEs remain in the special
  REMOVED_SPTE state.  This is a state where the mmu_lock is held for
  reading but concurrent accesses to the PTE have to spin; shortening
  its use allows other vCPUs to repopulate the zapped region while
  the zapper finishes tearing down the old, defunct page tables.

* Advertise the max mappable GPA in the "guest MAXPHYADDR" CPUID field,
  which is defined by hardware but left for software use.  This lets KVM
  communicate its inability to map GPAs that set bits 51:48 on hosts
  without 5-level nested page tables.  Guest firmware is expected to
  use the information when mapping BARs; this avoids that they end up at
  a legal, but unmappable, GPA.

* Fixed a bug where KVM would not reject accesses to MSR that aren't
  supposed to exist given the vCPU model and/or KVM configuration.

* As usual, a bunch of code cleanups.

x86 (AMD):

* Implement a new and improved API to initialize SEV and SEV-ES VMs, which
  will also be extendable to SEV-SNP.  The new API specifies the desired
  encryption in KVM_CREATE_VM and then separately initializes the VM.
  The new API also allows customizing the desired set of VMSA features;
  the features affect the measurement of the VM's initial state, and
  therefore enabling them cannot be done tout court by the hypervisor.

  While at it, the new API includes two bugfixes that couldn't be
  applied to the old one without a flag day in userspace or without
  affecting the initial measurement.  When a SEV-ES VM is created with
  the new VM type, KVM_GET_REGS/KVM_SET_REGS and friends are
  rejected once the VMSA has been encrypted.  Also, the FPU and AVX
  state will be synchronized and encrypted too.

* Support for GHCB version 2 as applicable to SEV-ES guests.  This, once
  more, is only accessible when using the new KVM_SEV_INIT2 flow for
  initialization of SEV-ES VMs.

x86 (Intel):

* An initial bunch of prerequisite patches for Intel TDX were merged.
  They generally don't do anything interesting.  The only somewhat user
  visible change is a new debugging mode that checks that KVM's MMU
  never triggers a #VE virtualization exception in the guest.

* Clear vmcs.EXIT_QUALIFICATION when synthesizing an EPT Misconfig VM-Exit to
  L1, as per the SDM.

Generic:

* Use vfree() instead of kvfree() for allocations that always use vcalloc()
  or __vcalloc().

* Remove .change_pte() MMU notifier - the changes to non-KVM code are
  small and Andrew Morton asked that I also take those through the KVM
  tree.  The callback was only ever implemented by KVM (which was also the
  original user of MMU notifiers) but it had been nonfunctional ever since
  calls to set_pte_at_notify were wrapped with invalidate_range_start
  and invalidate_range_end... in 2012.

Selftests:

* Enhance the demand paging test to allow for better reporting and stressing
  of UFFD performance.

* Convert the steal time test to generate TAP-friendly output.

* Fix a flaky false positive in the xen_shinfo_test due to comparing elapsed
  time across two different clock domains.

* Skip the MONITOR/MWAIT test if the host doesn't actually support MWAIT.

* Avoid unnecessary use of "sudo" in the NX hugepage test wrapper shell
  script, to play nice with running in a minimal userspace environment.

* Allow skipping the RSEQ test's sanity check that the vCPU was able to
  complete a reasonable number of KVM_RUNs, as the assert can fail on a
  completely valid setup.  If the test is run on a large-ish system that is
  otherwise idle, and the test isn't affined to a low-ish number of CPUs, the
  vCPU task can be repeatedly migrated to CPUs that are in deep sleep states,
  which results in the vCPU having very little net runtime before the next
  migration due to high wakeup latencies.

* Define _GNU_SOURCE for all selftests to fix a warning that was introduced by
  a change to kselftest_harness.h late in the 6.9 cycle, and because forcing
  every test to #define _GNU_SOURCE is painful.

* Provide a global pseudo-RNG instance for all tests, so that library code can
  generate random, but determinstic numbers.

* Use the global pRNG to randomly force emulation of select writes from guest
  code on x86, e.g. to help validate KVM's emulation of locked accesses.

* Allocate and initialize x86's GDT, IDT, TSS, segments, and default exception
  handlers at VM creation, instead of forcing tests to manually trigger the
  related setup.

Documentation:

* Fix a goof in the KVM_CREATE_GUEST_MEMFD documentation.

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: selftests: Fix off-by-one initialization of GDT limit

Alejandro Jimenez (2):
      KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if APICv is enabled
      KVM: x86: Remove VT-d mention in posted interrupt tracepoint

Anish Moorthy (6):
      KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
      KVM: Add function comments for __kvm_read/write_guest_page()
      KVM: Simplify error handling in __gfn_to_pfn_memslot()
      KVM: selftests: Report per-vcpu demand paging rate from demand paging test
      KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand paging test
      KVM: selftests: Use EPOLL in userfaultfd_util reader threads

Atish Patra (24):
      RISC-V: Fix the typo in Scountovf CSR name
      RISC-V: Add FIRMWARE_READ_HI definition
      drivers/perf: riscv: Read upper bits of a firmware counter
      drivers/perf: riscv: Use BIT macro for shifting operations
      RISC-V: Add SBI PMU snapshot definitions
      RISC-V: KVM: Rename the SBI_STA_SHMEM_DISABLE to a generic name
      RISC-V: Use the minor version mask while computing sbi version
      drivers/perf: riscv: Fix counter mask iteration for RV32
      drivers/perf: riscv: Implement SBI PMU snapshot function
      RISC-V: KVM: Fix the initial sample period value
      RISC-V: KVM: No need to update the counter value during reset
      RISC-V: KVM: No need to exit to the user space if perf event failed
      RISC-V: KVM: Implement SBI PMU Snapshot feature
      RISC-V: KVM: Add perf sampling support for guests
      RISC-V: KVM: Support 64 bit firmware counters on RV32
      RISC-V: KVM: Improve firmware counter read function
      KVM: riscv: selftests: Move sbi definitions to its own header file
      KVM: riscv: selftests: Add helper functions for extension checks
      KVM: riscv: selftests: Add Sscofpmf to get-reg-list test
      KVM: riscv: selftests: Add SBI PMU extension definitions
      KVM: riscv: selftests: Add SBI PMU selftest
      KVM: riscv: selftests: Add a test for PMU snapshot functionality
      KVM: riscv: selftests: Add a test for counter overflow
      KVM: riscv: selftests: Add commandline option for SBI PMU test

Bibo Mao (8):
      LoongArch/smp: Refine some ipi functions on LoongArch platform
      LoongArch: KVM: Add hypercall instruction emulation
      LoongArch: KVM: Add cpucfg area for kvm hypervisor
      LoongArch: KVM: Add vcpu mapping from physical cpuid
      LoongArch: KVM: Add PV IPI support on host side
      LoongArch: KVM: Add PV IPI support on guest side
      LoongArch: KVM: Add software breakpoint support
      LoongArch: KVM: Add mmio trace events support

Brendan Jackman (1):
      KVM: selftests: Avoid assuming "sudo" exists in NX hugepage test

Brijesh Singh (1):
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests

Carlos López (1):
      KVM: fix documentation for KVM_CREATE_GUEST_MEMFD

Chao Du (3):
      RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
      RISC-V: KVM: Handle breakpoint exits for VCPU
      RISC-V: KVM: selftests: Add ebreak test support

Colin Ian King (1):
      KVM: selftests: Remove second semicolon

David Matlack (1):
      KVM: x86/mmu: Process atomically-zapped SPTEs after TLB flush

Fuad Tabba (13):
      KVM: arm64: Initialize the kvm host data's fpsimd_state pointer in pKVM
      KVM: arm64: Move guest_owns_fp_regs() to increase its scope
      KVM: arm64: Refactor checks for FP state ownership
      KVM: arm64: Do not re-initialize the KVM lock
      KVM: arm64: Rename __tlb_switch_to_{guest,host}() in VHE
      KVM: arm64: Do not map the host fpsimd state to hyp in pKVM
      KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
      KVM: arm64: Change kvm_handle_mmio_return() return polarity
      KVM: arm64: Move setting the page as dirty out of the critical section
      KVM: arm64: Introduce and use predicates that check for protected VMs
      KVM: arm64: Clarify rationale for ZCR_EL1 value restored on guest exit
      KVM: arm64: Refactor setting the return value in kvm_vm_ioctl_enable_cap()
      KVM: arm64: Restrict supported capabilities for protected VMs

Gerd Hoffmann (2):
      KVM: x86: Don't advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID
      KVM: x86: Advertise max mappable GPA in CPUID.0x80000008.GuestPhysBits

Isaku Yamahata (3):
      KVM: x86/mmu: Add Suppress VE bit to EPT shadow_mmio_mask/shadow_present_mask
      KVM: VMX: Introduce test mode related to EPT violation VE
      KVM: x86/mmu: Pass full 64-bit error code when handling page faults

Li RongQing (1):
      KVM: Use vfree for memory allocated by vcalloc()/__vcalloc()

Marc Zyngier (34):
      KVM: arm64: Add accessor for per-CPU state
      KVM: arm64: Exclude host_debug_data from vcpu_arch
      KVM: arm64: Exclude mdcr_el2_host from kvm_vcpu_arch
      KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch
      KVM: arm64: Exclude FP ownership from kvm_vcpu_arch
      KVM: arm64: Improve out-of-order sysreg table diagnostics
      KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
      KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
      KVM: arm64: Constraint PAuth support to consistent implementations
      KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
      KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
      KVM: arm64: nv: Add trap forwarding for ERET and SMC
      KVM: arm64: nv: Fast-track 'InHost' exception returns
      KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
      KVM: arm64: nv: Handle HCR_EL2.{API,APK} independently
      KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
      KVM: arm64: nv: Add kvm_has_pauth() helper
      KVM: arm64: nv: Add emulation for ERETAx instructions
      KVM: arm64: nv: Handle ERETA[AB] instructions
      KVM: arm64: nv: Advertise support for PAuth
      KVM: arm64: Drop trapping of PAuth instructions/keys
      KVM: arm64: nv: Work around lack of pauth support in old toolchains
      KVM: arm64: Check for PTE validity when checking for executable/cacheable
      KVM: arm64: Simplify vgic-v3 hypercalls
      KVM: arm64: Force injection of a data abort on NISV MMIO exit
      KVM: arm64: vgic: Allocate private interrupts on demand
      KVM: arm64: Convert kvm_mpidr_index() to bitmap_gather()
      KVM: arm64: Move management of __hyp_running_vcpu to load/put on VHE
      Merge branch kvm-arm64/host_data into kvmarm-master/next
      Merge branch kvm-arm64/nv-eret-pauth into kvmarm-master/next
      Merge branch kvm-arm64/lpi-xa-cache into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-6.10 into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.10 into kvmarm-master/next
      Merge branch kvm-arm64/mpidr-reset into kvmarm-master/next

Michael Roth (2):
      KVM: SEV: Add GHCB handling for termination requests
      KVM: SEV: Allow per-guest configuration of GHCB protocol version

Oliver Upton (27):
      KVM: Treat the device list as an rculist
      KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
      KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
      KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
      KVM: arm64: vgic-debug: Use an xarray mark for debug iterator
      KVM: arm64: vgic-its: Get rid of vgic_copy_lpi_list()
      KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
      KVM: arm64: vgic-its: Maintain a translation cache per ITS
      KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
      KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
      KVM: arm64: vgic-its: Rip out the global translation cache
      KVM: arm64: vgic-its: Get rid of the lpi_list_lock
      KVM: selftests: Align with kernel's GIC definitions
      KVM: selftests: Standardise layout of GIC frames
      KVM: selftests: Add quadword MMIO accessors
      KVM: selftests: Add a minimal library for interacting with an ITS
      KVM: selftests: Add helper for enabling LPIs on a redistributor
      KVM: selftests: Use MPIDR_HWID_BITMASK from cputype.h
      KVM: selftests: Add stress test for LPI injection
      KVM: arm64: Destroy mpidr_data for 'late' vCPU creation
      KVM: arm64: Rename is_id_reg() to imply VM scope
      KVM: arm64: Reset VM feature ID regs from kvm_reset_sys_regs()
      KVM: arm64: Only reset vCPU-scoped feature ID regs once
      KVM: selftests: arm64: Rename helper in set_id_regs to imply VM scope
      KVM: selftests: arm64: Store expected register value in set_id_regs
      KVM: selftests: arm64: Test that feature ID regs survive a reset
      KVM: selftests: arm64: Test vCPU-scoped feature ID registers

Paolo Bonzini (40):
      KVM: SVM: Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
      KVM: x86: use u64_to_user_ptr()
      KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
      KVM: SEV: publish supported VMSA features
      KVM: SEV: store VMSA features in kvm_sev_info
      KVM: x86: add fields to struct kvm_arch for CoCo features
      KVM: x86: Add supported_vm_types to kvm_caps
      KVM: SEV: introduce to_kvm_sev_info
      KVM: SEV: define VM types for SEV and SEV-ES
      KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA time
      KVM: SEV: introduce KVM_SEV_INIT2 operation
      KVM: SEV: allow SEV-ES DebugSwap again
      selftests: kvm: add tests for KVM_SEV_INIT2
      selftests: kvm: switch to using KVM_X86_*_VM
      selftests: kvm: split "launch" phase of SEV VM creation
      selftests: kvm: add test for transferring FPU state into VMSA
      KVM: delete .change_pte MMU notifier callback
      KVM: remove unused argument of kvm_handle_hva_range()
      mmu_notifier: remove the .change_pte() callback
      mm: replace set_pte_at_notify() with just set_pte_at()
      Merge branch 'mm-delete-change-gpte' into HEAD
      Merge branch 'kvm-sev-init2' into HEAD
      KVM: VMX: Move out vmx_x86_ops to 'main.c' to dispatch VMX and TDX
      KVM: SEV: use u64_to_user_ptr throughout
      Merge x86 bugfixes from Linux 6.9-rc3
      KVM, x86: add architectural support code for #VE
      KVM: x86/mmu: check for invalid async page faults involving private memory
      Merge tag 'kvm-riscv-6.10-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge branch 'kvm-vmx-ve' into HEAD
      Merge branch 'kvm-coco-pagefault-prep' into HEAD
      Merge branch 'kvm-sev-es-ghcbv2' into HEAD
      Merge tag 'loongarch-kvm-6.10' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvmarm-6.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-generic-6.10' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.10' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.10' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests_utils-6.10' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.10' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.10' of https://github.com/kvm-x86/linux into HEAD
      selftests/kvm: remove dead file

Quentin Perret (4):
      KVM: arm64: Issue CMOs when tearing down guest s2 pages
      KVM: arm64: Avoid BUG-ing from the host abort path
      KVM: arm64: Prevent kmemleak from accessing .hyp.data
      KVM: arm64: Add is_pkvm_initialized() helper

Russell King (1):
      KVM: arm64: Remove duplicated AA64MMFR1_EL1 XNX

Sean Christopherson (54):
      KVM: nVMX: Clear EXIT_QUALIFICATION when injecting an EPT Misconfig
      KVM: x86: Move nEPT exit_qualification field from kvm_vcpu_arch to x86_exception
      KVM: nVMX: Add a sanity check that nested PML Full stems from EPT Violations
      KVM: SVM: Invert handling of SEV and SEV_ES feature flags
      KVM: x86: Split core of hypercall emulation to helper function
      KVM: VMX: Modify NMI and INTR handlers to take intr_info as function argument
      KVM: Allow page-sized MMU caches to be initialized with custom 64-bit values
      KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
      KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE
      KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
      KVM: selftests: Define _GNU_SOURCE for all selftests code
      KVM: selftests: Provide a global pseudo-RNG instance for all tests
      KVM: selftests: Provide an API for getting a random bool from an RNG
      KVM: selftests: Add global snapshot of kvm_is_forced_emulation_enabled()
      KVM: selftests: Add vcpu_arch_put_guest() to do writes from guest code
      KVM: selftests: Randomly force emulation on x86 writes from guest code
      Revert "kvm: selftests: move base kvm_util.h declarations to kvm_util_base.h"
      KVM: sefltests: Add kvm_util_types.h to hold common types, e.g. vm_vaddr_t
      KVM: selftests: Move GDT, IDT, and TSS fields to x86's kvm_vm_arch
      KVM: selftests: Move platform_info_test's main assert into guest code
      KVM: selftests: Rework platform_info_test to actually verify #GP
      KVM: selftests: Explicitly clobber the IDT in the "delete memslot" testcase
      KVM: selftests: Move x86's descriptor table helpers "up" in processor.c
      KVM: selftests: Rename x86's vcpu_setup() to vcpu_init_sregs()
      KVM: selftests: Init IDT and exception handlers for all VMs/vCPUs on x86
      KVM: selftests: Map x86's exception_handlers at VM creation, not vCPU setup
      KVM: selftests: Allocate x86's GDT during VM creation
      KVM: selftests: Drop superfluous switch() on vm->mode in vcpu_init_sregs()
      KVM: selftests: Fold x86's descriptor tables helpers into vcpu_init_sregs()
      KVM: selftests: Allocate x86's TSS at VM creation
      KVM: selftests: Add macro for TSS selector, rename up code/data macros
      KVM: selftests: Init x86's segments during VM creation
      KVM: selftests: Drop @selector from segment helpers
      KVM: x86: Allow, don't ignore, same-value writes to immutable MSRs
      KVM: x86/mmu: Fix a largely theoretical race in kvm_mmu_track_write()
      KVM: selftests: Require KVM_CAP_USER_MEMORY2 for tests that create memslots
      KVM: x86/mmu: Exit to userspace with -EFAULT if private fault hits emulation
      KVM: x86: Remove separate "bit" defines for page fault error code masks
      KVM: x86: Define more SEV+ page fault error bits/flags for #NPF
      KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
      KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error code are non-zero
      KVM: x86/mmu: Use synthetic page fault error code to indicate private faults
      KVM: x86/mmu: WARN and skip MMIO cache on private, reserved page faults
      KVM: x86/mmu: Move private vs. shared check above slot validity checks
      KVM: x86/mmu: Don't force emulation of L2 accesses to non-APIC internal slots
      KVM: x86/mmu: Explicitly disallow private accesses to emulated MMIO
      KVM: x86/mmu: Move slot checks from __kvm_faultin_pfn() to kvm_faultin_pfn()
      KVM: x86/mmu: Handle no-slot faults at the beginning of kvm_faultin_pfn()
      KVM: x86/mmu: Set kvm_page_fault.hva to KVM_HVA_ERR_BAD for "no slot" faults
      KVM: x86/mmu: Initialize kvm_page_fault's pfn and hva to error values
      KVM: x86/mmu: Sanity check that __kvm_faultin_pfn() doesn't create noslot pfns
      KVM: x86: Fully re-initialize supported_vm_types on vendor module load
      KVM: x86: Fully re-initialize supported_mce_cap on vendor module load
      KVM: x86: Explicitly zero kvm_caps during vendor module load

Sebastian Ene (1):
      KVM: arm64: Remove FFA_MSG_SEND_DIRECT_REQ from the denylist

Thomas Huth (1):
      KVM: selftests: Use TAP in the steal_time test

Tom Lendacky (1):
      KVM: SEV: Add support to handle AP reset MSR protocol

Venkatesh Srinivas (1):
      KVM: Remove kvm_make_all_cpus_request_except()

Vitaly Kuznetsov (1):
      KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK

Will Deacon (7):
      KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
      KVM: arm64: Support TLB invalidation in guest context
      KVM: arm64: Reformat/beautify PTP hypercall documentation
      KVM: arm64: Rename firmware pseudo-register documentation file
      KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
      KVM: arm64: Fix hvhe/nvhe early alias parsing
      KVM: arm64: Use hVHE in pKVM by default on CPUs with VHE support

Yong-Xuan Wang (2):
      RISCV: KVM: Introduce mp_state_lock to avoid lock inversion
      RISCV: KVM: Introduce vcpu->reset_cntx_lock

Zide Chen (2):
      KVM: selftests: Make monitor_mwait require MONITOR/MWAIT feature
      KVM: selftests: Allow skipping the KVM_RUN sanity check in rseq_test

 Documentation/virt/kvm/api.rst                     |   11 +-
 Documentation/virt/kvm/arm/fw-pseudo-registers.rst |  138 +++
 Documentation/virt/kvm/arm/hypercalls.rst          |  164 +--
 Documentation/virt/kvm/arm/index.rst               |    1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst             |   38 +-
 .../virt/kvm/x86/amd-memory-encryption.rst         |   59 +-
 arch/arm64/include/asm/esr.h                       |   12 +
 arch/arm64/include/asm/kvm_asm.h                   |    8 +-
 arch/arm64/include/asm/kvm_emulate.h               |   16 +-
 arch/arm64/include/asm/kvm_host.h                  |  156 ++-
 arch/arm64/include/asm/kvm_hyp.h                   |    4 +-
 arch/arm64/include/asm/kvm_nested.h                |   13 +
 arch/arm64/include/asm/kvm_ptrauth.h               |   21 +
 arch/arm64/include/asm/pgtable-hwdef.h             |    1 +
 arch/arm64/include/asm/virt.h                      |   12 +-
 arch/arm64/kernel/pi/idreg-override.c              |    4 +-
 arch/arm64/kvm/Makefile                            |    1 +
 arch/arm64/kvm/arm.c                               |  211 +++-
 arch/arm64/kvm/emulate-nested.c                    |   66 +-
 arch/arm64/kvm/fpsimd.c                            |   69 +-
 arch/arm64/kvm/handle_exit.c                       |   36 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h          |    8 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   86 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |    6 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |    8 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |    1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   27 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |    8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   14 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |    2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |    4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   18 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |  115 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   21 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   27 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  109 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |    4 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |   26 +-
 arch/arm64/kvm/mmio.c                              |   12 +-
 arch/arm64/kvm/mmu.c                               |   42 +-
 arch/arm64/kvm/nested.c                            |    8 +-
 arch/arm64/kvm/pauth.c                             |  206 ++++
 arch/arm64/kvm/pkvm.c                              |    2 +-
 arch/arm64/kvm/pmu.c                               |    2 +-
 arch/arm64/kvm/reset.c                             |    1 -
 arch/arm64/kvm/sys_regs.c                          |   69 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |   82 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   90 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  356 ++----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |    2 +-
 arch/arm64/kvm/vgic/vgic-v2.c                      |    9 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   23 +-
 arch/arm64/kvm/vgic/vgic.c                         |   17 +-
 arch/arm64/kvm/vgic/vgic.h                         |    8 +-
 arch/loongarch/Kconfig                             |    9 +
 arch/loongarch/include/asm/Kbuild                  |    1 -
 arch/loongarch/include/asm/hardirq.h               |    6 +
 arch/loongarch/include/asm/inst.h                  |    2 +
 arch/loongarch/include/asm/irq.h                   |   11 +-
 arch/loongarch/include/asm/kvm_host.h              |   34 +-
 arch/loongarch/include/asm/kvm_para.h              |  161 +++
 arch/loongarch/include/asm/kvm_vcpu.h              |   11 +
 arch/loongarch/include/asm/loongarch.h             |   12 +
 arch/loongarch/include/asm/paravirt.h              |   30 +
 arch/loongarch/include/asm/paravirt_api_clock.h    |    1 +
 arch/loongarch/include/asm/smp.h                   |   22 +-
 arch/loongarch/include/uapi/asm/kvm.h              |    4 +
 arch/loongarch/kernel/Makefile                     |    1 +
 arch/loongarch/kernel/irq.c                        |   24 +-
 arch/loongarch/kernel/paravirt.c                   |  151 +++
 arch/loongarch/kernel/perf_event.c                 |   14 +-
 arch/loongarch/kernel/smp.c                        |   52 +-
 arch/loongarch/kernel/time.c                       |   12 +-
 arch/loongarch/kvm/exit.c                          |  151 ++-
 arch/loongarch/kvm/mmu.c                           |   32 -
 arch/loongarch/kvm/trace.h                         |   20 +-
 arch/loongarch/kvm/vcpu.c                          |  105 +-
 arch/loongarch/kvm/vm.c                            |   11 +
 arch/mips/kvm/mmu.c                                |   30 -
 arch/powerpc/include/asm/kvm_ppc.h                 |    1 -
 arch/powerpc/kvm/book3s.c                          |    5 -
 arch/powerpc/kvm/book3s.h                          |    1 -
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   12 -
 arch/powerpc/kvm/book3s_hv.c                       |    1 -
 arch/powerpc/kvm/book3s_pr.c                       |    7 -
 arch/powerpc/kvm/e500_mmu_host.c                   |    6 -
 arch/riscv/include/asm/csr.h                       |    5 +-
 arch/riscv/include/asm/kvm_host.h                  |   21 +-
 arch/riscv/include/asm/kvm_vcpu_pmu.h              |   16 +-
 arch/riscv/include/asm/sbi.h                       |   38 +-
 arch/riscv/include/uapi/asm/kvm.h                  |    1 +
 arch/riscv/kernel/paravirt.c                       |    6 +-
 arch/riscv/kvm/aia.c                               |    5 +
 arch/riscv/kvm/main.c                              |   18 +-
 arch/riscv/kvm/mmu.c                               |   20 -
 arch/riscv/kvm/vcpu.c                              |   85 +-
 arch/riscv/kvm/vcpu_exit.c                         |    4 +
 arch/riscv/kvm/vcpu_onereg.c                       |    6 +
 arch/riscv/kvm/vcpu_pmu.c                          |  260 ++++-
 arch/riscv/kvm/vcpu_sbi.c                          |    7 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |   42 +-
 arch/riscv/kvm/vcpu_sbi_pmu.c                      |   17 +-
 arch/riscv/kvm/vcpu_sbi_sta.c                      |    4 +-
 arch/riscv/kvm/vm.c                                |    1 +
 arch/x86/include/asm/fpu/api.h                     |    3 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    1 +
 arch/x86/include/asm/kvm_host.h                    |   63 +-
 arch/x86/include/asm/sev-common.h                  |    8 +-
 arch/x86/include/asm/vmx.h                         |   13 +
 arch/x86/include/uapi/asm/kvm.h                    |   22 +-
 arch/x86/kernel/fpu/xstate.c                       |    1 +
 arch/x86/kernel/fpu/xstate.h                       |    2 -
 arch/x86/kvm/Kconfig                               |   13 +
 arch/x86/kvm/Makefile                              |    9 +-
 arch/x86/kvm/cpuid.c                               |   43 +-
 arch/x86/kvm/kvm_emulate.h                         |    1 +
 arch/x86/kvm/mmu.h                                 |    7 +-
 arch/x86/kvm/mmu/mmu.c                             |  295 ++---
 arch/x86/kvm/mmu/mmu_internal.h                    |   28 +-
 arch/x86/kvm/mmu/mmutrace.h                        |    2 +-
 arch/x86/kvm/mmu/page_track.c                      |    2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   28 +-
 arch/x86/kvm/mmu/spte.c                            |   40 +-
 arch/x86/kvm/mmu/spte.h                            |   26 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  139 +--
 arch/x86/kvm/mmu/tdp_mmu.h                         |    1 -
 arch/x86/kvm/svm/sev.c                             |  343 ++++--
 arch/x86/kvm/svm/svm.c                             |   36 +-
 arch/x86/kvm/svm/svm.h                             |   56 +-
 arch/x86/kvm/trace.h                               |    4 +-
 arch/x86/kvm/vmx/main.c                            |  166 +++
 arch/x86/kvm/vmx/nested.c                          |   30 +-
 arch/x86/kvm/vmx/vmcs.h                            |    5 +
 arch/x86/kvm/vmx/vmx.c                             |  440 +++-----
 arch/x86/kvm/vmx/vmx.h                             |    6 +-
 arch/x86/kvm/vmx/x86_ops.h                         |  124 +++
 arch/x86/kvm/x86.c                                 |  262 +++--
 arch/x86/kvm/x86.h                                 |    2 +
 drivers/perf/riscv_pmu.c                           |    3 +-
 drivers/perf/riscv_pmu_sbi.c                       |  316 +++++-
 include/kvm/arm_vgic.h                             |   16 +-
 include/linux/kvm_host.h                           |    4 -
 include/linux/kvm_types.h                          |    1 +
 include/linux/mmu_notifier.h                       |   44 -
 include/linux/perf/riscv_pmu.h                     |    8 +
 include/trace/events/kvm.h                         |   15 -
 kernel/events/uprobes.c                            |    6 +-
 mm/ksm.c                                           |    4 +-
 mm/memory.c                                        |    7 +-
 mm/migrate_device.c                                |    8 +-
 mm/mmu_notifier.c                                  |   17 -
 tools/testing/selftests/kvm/Makefile               |    9 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |   11 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |    5 +-
 tools/testing/selftests/kvm/aarch64/psci_test.c    |    4 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |  123 ++-
 tools/testing/selftests/kvm/aarch64/vgic_init.c    |    1 -
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   15 +-
 .../selftests/kvm/aarch64/vgic_lpi_stress.c        |  410 +++++++
 .../selftests/kvm/aarch64/vpmu_counter_access.c    |    6 +-
 tools/testing/selftests/kvm/arch_timer.c           |    4 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |   94 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |   15 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |   26 +-
 tools/testing/selftests/kvm/guest_memfd_test.c     |    4 +-
 tools/testing/selftests/kvm/guest_print_test.c     |    1 +
 .../testing/selftests/kvm/hardware_disable_test.c  |    3 -
 tools/testing/selftests/kvm/include/aarch64/gic.h  |   21 +-
 .../testing/selftests/kvm/include/aarch64/gic_v3.h |  588 +++++++++-
 .../selftests/kvm/include/aarch64/gic_v3_its.h     |   19 +
 .../selftests/kvm/include/aarch64/processor.h      |   21 +-
 .../testing/selftests/kvm/include/aarch64/ucall.h  |    2 +-
 tools/testing/selftests/kvm/include/aarch64/vgic.h |    5 +-
 tools/testing/selftests/kvm/include/kvm_util.h     | 1111 ++++++++++++++++++-
 .../testing/selftests/kvm/include/kvm_util_base.h  | 1135 --------------------
 .../testing/selftests/kvm/include/kvm_util_types.h |   20 +
 tools/testing/selftests/kvm/include/memstress.h    |    1 -
 .../selftests/kvm/include/riscv/processor.h        |   49 +-
 tools/testing/selftests/kvm/include/riscv/sbi.h    |  141 +++
 tools/testing/selftests/kvm/include/riscv/ucall.h  |    1 +
 tools/testing/selftests/kvm/include/s390x/ucall.h  |    2 +-
 tools/testing/selftests/kvm/include/test_util.h    |   19 +
 .../selftests/kvm/include/userfaultfd_util.h       |   19 +-
 .../selftests/kvm/include/x86_64/kvm_util_arch.h   |   28 +
 .../selftests/kvm/include/x86_64/processor.h       |   11 +-
 tools/testing/selftests/kvm/include/x86_64/sev.h   |   19 +-
 tools/testing/selftests/kvm/include/x86_64/ucall.h |    2 +-
 .../testing/selftests/kvm/kvm_binary_stats_test.c  |    2 -
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |    2 -
 tools/testing/selftests/kvm/kvm_page_table_test.c  |    4 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c      |   18 +-
 .../selftests/kvm/lib/aarch64/gic_private.h        |    4 +-
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   |   99 +-
 .../testing/selftests/kvm/lib/aarch64/gic_v3_its.c |  248 +++++
 .../testing/selftests/kvm/lib/aarch64/processor.c  |    2 +
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |   38 +-
 tools/testing/selftests/kvm/lib/assert.c           |    3 -
 tools/testing/selftests/kvm/lib/kvm_util.c         |   21 +-
 tools/testing/selftests/kvm/lib/memstress.c        |   13 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   13 +
 tools/testing/selftests/kvm/lib/test_util.c        |    2 -
 tools/testing/selftests/kvm/lib/ucall_common.c     |    5 +-
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |  156 +--
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  318 +++---
 tools/testing/selftests/kvm/lib/x86_64/sev.c       |   45 +-
 .../testing/selftests/kvm/max_guest_memory_test.c  |    2 -
 .../kvm/memslot_modification_stress_test.c         |    3 -
 tools/testing/selftests/kvm/riscv/arch_timer.c     |    6 +-
 tools/testing/selftests/kvm/riscv/ebreak_test.c    |   82 ++
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |    4 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |  681 ++++++++++++
 tools/testing/selftests/kvm/rseq_test.c            |   48 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c      |    3 +-
 tools/testing/selftests/kvm/s390x/memop.c          |    1 +
 tools/testing/selftests/kvm/s390x/sync_regs_test.c |    2 -
 tools/testing/selftests/kvm/s390x/tprot.c          |    1 +
 .../testing/selftests/kvm/set_memory_region_test.c |   21 +-
 tools/testing/selftests/kvm/steal_time.c           |   53 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c      |    4 -
 .../kvm/x86_64/dirty_log_page_splitting_test.c     |    1 +
 .../kvm/x86_64/exit_on_emulation_failure_test.c    |    5 +-
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |    2 -
 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c |    2 -
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |    2 -
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |    3 -
 .../testing/selftests/kvm/x86_64/hyperv_features.c |    6 -
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |    5 -
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |    1 -
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c        |    2 -
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |    3 -
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |    4 +-
 .../selftests/kvm/x86_64/nested_exceptions_test.c  |    2 -
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |    3 -
 .../selftests/kvm/x86_64/nx_huge_pages_test.sh     |   13 +-
 .../selftests/kvm/x86_64/platform_info_test.c      |   61 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c       |    8 -
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |    9 -
 .../kvm/x86_64/private_mem_conversions_test.c      |    1 -
 .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c |    1 -
 .../testing/selftests/kvm/x86_64/set_sregs_test.c  |    1 -
 .../testing/selftests/kvm/x86_64/sev_init2_tests.c |  152 +++
 .../testing/selftests/kvm/x86_64/sev_smoke_test.c  |   96 +-
 .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c |    6 -
 tools/testing/selftests/kvm/x86_64/smm_test.c      |    1 -
 tools/testing/selftests/kvm/x86_64/state_test.c    |    1 -
 .../selftests/kvm/x86_64/svm_int_ctl_test.c        |    3 -
 .../kvm/x86_64/svm_nested_shutdown_test.c          |    5 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |    5 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |    2 -
 .../selftests/kvm/x86_64/ucna_injection_test.c     |    7 -
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c |   15 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      |    3 -
 .../vmx_exception_with_invalid_guest_state.c       |    3 -
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |    4 -
 .../kvm/x86_64/vmx_preemption_timer_test.c         |    1 -
 .../testing/selftests/kvm/x86_64/xapic_ipi_test.c  |    4 -
 .../selftests/kvm/x86_64/xapic_state_test.c        |    1 -
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |    3 -
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |   59 +-
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c  |    2 -
 virt/kvm/kvm_main.c                                |  109 +-
 virt/kvm/vfio.c                                    |    2 +
 262 files changed, 8887 insertions(+), 4201 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/fw-pseudo-registers.rst
 create mode 100644 arch/arm64/kvm/pauth.c
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 create mode 100644 arch/loongarch/kernel/paravirt.c
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/x86_ops.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
 delete mode 100644 tools/testing/selftests/kvm/include/kvm_util_base.h
 create mode 100644 tools/testing/selftests/kvm/include/kvm_util_types.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/sbi.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c
 create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c
 create mode 100644 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c


