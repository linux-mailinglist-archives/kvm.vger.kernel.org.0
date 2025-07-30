Return-Path: <kvm+bounces-53746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65153B1661B
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 543033AB104
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 18:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD282DFA2F;
	Wed, 30 Jul 2025 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYXrmBY6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBDD1DED66
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753899436; cv=none; b=fYgq2fPSw5wPS28P7FS8ctK88qZE8S0c2IKe9XNteaCilX+JS2OsWktNzvmj/CDA5rU77XZCEaiklMOmFfMqeWNw0SZP4K2vi/LbFarTdS9Et7S5BNQxAZtcH3Rc/kFoptNo76q+iKUns7CW0Lc8WRUbarV2gtSxpIf+TbRe8B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753899436; c=relaxed/simple;
	bh=8DFIfCWxzr3xdqfktg3e2ltntSMq+TLiHfLzkwYlo2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bXq/DLvRqtAUTWzZlIXmTWEbp1V3yP5oA0jK11eMF6nhMbjx3FqouHYysequsBTirdcAkIt2n4SEGOIdqIIGNNnq6WANkUQ9TAQTCRNMgbzKJaWD/V6J/oHnILx1CCb5A3ldtYU9pwYsUk9ZbtKtUkfJqGMdcbiQO+M6Ogd4ZfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JYXrmBY6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753899432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8suOskvQyJMUzz0DAKMp6KBUyvlfQ/cN7eGf63Swpsk=;
	b=JYXrmBY6lnmIqUDVKqgo2m0XqvyR9JaZ1m/TCRmPXFpSWCNTB6bLJHP269yR4y5hwmk4s2
	z+9nPKBscKT1r2rYznKe+4ShA4ixzsdabyTHMD9nXUL3LZchzCT8KJ/JRfQflTbypurkUo
	DJpMJCqzFogEP/jlWv3ftmEEu98ud9E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-CGZ0sZnUPxqy6cOofvKCig-1; Wed,
 30 Jul 2025 14:17:06 -0400
X-MC-Unique: CGZ0sZnUPxqy6cOofvKCig-1
X-Mimecast-MFC-AGG-ID: CGZ0sZnUPxqy6cOofvKCig_1753899426
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9E40195608A;
	Wed, 30 Jul 2025 18:17:05 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E2E961800D87;
	Wed, 30 Jul 2025 18:17:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.17 merge window
Date: Wed, 30 Jul 2025 14:17:02 -0400
Message-ID: <20250730181703.113459-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Linus,

The following changes since commit 038d61fd642278bab63ee8ef722c50d10ab01e8f:

  Linux 6.16 (2025-07-27 14:26:38 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030:

  Merge tag 'kvm-s390-next-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2025-07-30 13:56:09 -0400)

The GICv5 branch is shared between the irqchip and KVM pull requests;
so far you have not pulled it.

There is a conflict with "entry: Split generic entry into generic
exception and syscall entry" from the tip tree.  The new function
from

    git show ee4a2e08c101 -- include/linux/entry-common.h

must be moved to include/linux/irq-entry-common.h, which is as easy
as piping that into "patch include/linux/irq-entry-common.h".

Thanks,

Paolo

----------------------------------------------------------------
ARM:

- Host driver for GICv5, the next generation interrupt controller for
  arm64, including support for interrupt routing, MSIs, interrupt
  translation and wired interrupts.

- Use FEAT_GCIE_LEGACY on GICv5 systems to virtualize GICv3 VMs on
  GICv5 hardware, leveraging the legacy VGIC interface.

- Userspace control of the 'nASSGIcap' GICv3 feature, allowing
  userspace to disable support for SGIs w/o an active state on hardware
  that previously advertised it unconditionally.

- Map supporting endpoints with cacheable memory attributes on systems
  with FEAT_S2FWB and DIC where KVM no longer needs to perform cache
  maintenance on the address range.

- Nested support for FEAT_RAS and FEAT_DoubleFault2, allowing the guest
  hypervisor to inject external aborts into an L2 VM and take traps of
  masked external aborts to the hypervisor.

- Convert more system register sanitization to the config-driven
  implementation.

- Fixes to the visibility of EL2 registers, namely making VGICv3 system
  registers accessible through the VGIC device instead of the ONE_REG
  vCPU ioctls.

- Various cleanups and minor fixes.

LoongArch:

- Add stat information for in-kernel irqchip

- Add tracepoints for CPUCFG and CSR emulation exits

- Enhance in-kernel irqchip emulation

- Various cleanups.

RISC-V:

- Enable ring-based dirty memory tracking

- Improve perf kvm stat to report interrupt events

- Delegate illegal instruction trap to VS-mode

- MMU improvements related to upcoming nested virtualization

s390:

- Fixes

x86:

- Add CONFIG_KVM_IOAPIC for x86 to allow disabling support for I/O APIC,
  PIC, and PIT emulation at compile time.

- Share device posted IRQ code between SVM and VMX and
  harden it against bugs and runtime errors.

- Use vcpu_idx, not vcpu_id, for GA log tag/metadata, to make lookups O(1)
  instead of O(n).

- For MMIO stale data mitigation, track whether or not a vCPU has access to
  (host) MMIO based on whether the page tables have MMIO pfns mapped; using
  VFIO is prone to false negatives

- Rework the MSR interception code so that the SVM and VMX APIs are more or
  less identical.

- Recalculate all MSR intercepts from scratch on MSR filter changes,
  instead of maintaining shadow bitmaps.

- Advertise support for LKGS (Load Kernel GS base), a new instruction
  that's loosely related to FRED, but is supported and enumerated
  independently.

- Fix a user-triggerable WARN that syzkaller found by setting the vCPU
  in INIT_RECEIVED state (aka wait-for-SIPI), and then putting the vCPU
  into VMX Root Mode (post-VMXON).  Trying to detect every possible path
  leading to architecturally forbidden states is hard and even risks
  breaking userspace (if it goes from valid to valid state but passes
  through invalid states), so just wait until KVM_RUN to detect that
  the vCPU state isn't allowed.

- Add KVM_X86_DISABLE_EXITS_APERFMPERF to allow disabling interception of
  APERF/MPERF reads, so that a "properly" configured VM can access
  APERF/MPERF.  This has many caveats (APERF/MPERF cannot be zeroed
  on vCPU creation or saved/restored on suspend and resume, or preserved
  over thread migration let alone VM migration) but can be useful whenever
  you're interested in letting Linux guests see the effective physical CPU
  frequency in /proc/cpuinfo.

- Reject KVM_SET_TSC_KHZ for vm file descriptors if vCPUs have been
  created, as there's no known use case for changing the default
  frequency for other VM types and it goes counter to the very reason
  why the ioctl was added to the vm file descriptor.  And also, there
  would be no way to make it work for confidential VMs with a "secure"
  TSC, so kill two birds with one stone.

- Dynamically allocation the shadow MMU's hashed page list, and defer
  allocating the hashed list until it's actually needed (the TDP MMU
  doesn't use the list).

- Extract many of KVM's helpers for accessing architectural local APIC
  state to common x86 so that they can be shared by guest-side code for
  Secure AVIC.

- Various cleanups and fixes.

x86 (Intel):

- Preserve the host's DEBUGCTL.FREEZE_IN_SMM when running the guest.
  Failure to honor FREEZE_IN_SMM can leak host state into guests.

- Explicitly check vmcs12.GUEST_DEBUGCTL on nested VM-Enter to prevent
  L1 from running L2 with features that KVM doesn't support, e.g. BTF.

x86 (AMD):

- WARN and reject loading kvm-amd.ko instead of panicking the kernel if the
  nested SVM MSRPM offsets tracker can't handle an MSR (which is pretty
  much a static condition and therefore should never happen, but still).

- Fix a variety of flaws and bugs in the AVIC device posted IRQ code.

- Inhibit AVIC if a vCPU's ID is too big (relative to what hardware
  supports) instead of rejecting vCPU creation.

- Extend enable_ipiv module param support to SVM, by simply leaving
  IsRunning clear in the vCPU's physical ID table entry.

- Disable IPI virtualization, via enable_ipiv, if the CPU is affected by
  erratum #1235, to allow (safely) enabling AVIC on such CPUs.

- Request GA Log interrupts if and only if the target vCPU is blocking,
  i.e. only if KVM needs a notification in order to wake the vCPU.

- Intercept SPEC_CTRL on AMD if the MSR shouldn't exist according to the
  vCPU's CPUID model.

- Accept any SNP policy that is accepted by the firmware with respect to
  SMT and single-socket restrictions.  An incompatible policy doesn't put
  the kernel at risk in any way, so there's no reason for KVM to care.

- Drop a superfluous WBINVD (on all CPUs!) when destroying a VM and
  use WBNOINVD instead of WBINVD when possible for SEV cache maintenance.

- When reclaiming memory from an SEV guest, only do cache flushes on CPUs
  that have ever run a vCPU for the guest, i.e. don't flush the caches for
  CPUs that can't possibly have cache lines with dirty, encrypted data.

Generic:

- Rework irqbypass to track/match producers and consumers via an xarray
  instead of a linked list.  Using a linked list leads to O(n^2) insertion
  times, which is hugely problematic for use cases that create large
  numbers of VMs.  Such use cases typically don't actually use irqbypass,
  but eliminating the pointless registration is a future problem to
  solve as it likely requires new uAPI.

- Track irqbypass's "token" as "struct eventfd_ctx *" instead of a "void *",
  to avoid making a simple concept unnecessarily difficult to understand.

- Decouple device posted IRQs from VFIO device assignment, as binding a VM
  to a VFIO group is not a requirement for enabling device posted IRQs.

- Clean up and document/comment the irqfd assignment code.

- Disallow binding multiple irqfds to an eventfd with a priority waiter,
  i.e.  ensure an eventfd is bound to at most one irqfd through the entire
  host, and add a selftest to verify eventfd:irqfd bindings are globally
  unique.

- Add a tracepoint for KVM_SET_MEMORY_ATTRIBUTES to help debug issues
  related to private <=> shared memory conversions.

- Drop guest_memfd's .getattr() implementation as the VFS layer will call
  generic_fillattr() if inode_operations.getattr is NULL.

- Fix issues with dirty ring harvesting where KVM doesn't bound the
  processing of entries in any way, which allows userspace to keep KVM
  in a tight loop indefinitely.

- Kill off kvm_arch_{start,end}_assignment() and x86's associated tracking,
  now that KVM no longer uses assigned_device_count as a heuristic for
  either irqbypass usage or MDS mitigation.

Selftests:

- Fix a comment typo.

- Verify KVM is loaded when getting any KVM module param so that attempting
  to run a selftest without kvm.ko loaded results in a SKIP message about
  KVM not being loaded/enabled (versus some random parameter not existing).

- Skip tests that hit EACCES when attempting to access a file, and rpint
  a "Root required?" help message.  In most cases, the test just needs to
  be run with elevated permissions.

----------------------------------------------------------------
Ankit Agrawal (5):
      KVM: arm64: Rename the device variable to s2_force_noncacheable
      KVM: arm64: Assume non-PFNMAP/MIXEDMAP VMAs can be mapped cacheable
      KVM: arm64: Block cacheable PFNMAP mapping
      KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
      KVM: arm64: Expose new KVM cap for cacheable PFNMAP

Anup Patel (12):
      RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
      RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
      RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
      RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with KVM_REQ_TLB_FLUSH
      RISC-V: KVM: Don't flush TLB when PTE is unchanged
      RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
      RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
      RISC-V: KVM: Factor-out MMU related declarations into separate headers
      RISC-V: KVM: Introduce struct kvm_gstage_mapping
      RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
      RISC-V: KVM: Factor-out g-stage page table management
      RISC-V: KVM: Pass VMID as parameter to kvm_riscv_hfence_xyz() APIs

Bibo Mao (8):
      LoongArch: KVM: Remove unnecessary local variable
      LoongArch: KVM: Remove unused parameter len
      LoongArch: KVM: Remove never called default case statement
      LoongArch: KVM: Use standard bitops API with eiointc
      LoongArch: KVM: Use generic function loongarch_eiointc_read()
      LoongArch: KVM: Use generic function loongarch_eiointc_write()
      LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
      LoongArch: KVM: Add stat information with kernel irqchip

Chao Gao (2):
      KVM: x86: Deduplicate MSR interception enabling and disabling
      KVM: SVM: Simplify MSR interception logic for IA32_XSS MSR

Clément Léger (2):
      RISC-V: KVM: add SBI extension init()/deinit() functions
      RISC-V: KVM: add SBI extension reset callback

David Woodhouse (1):
      KVM: arm64: vgic-its: Return -ENXIO to invalid KVM_DEV_ARM_VGIC_GRP_CTRL attrs

Jim Mattson (3):
      KVM: x86: Replace growing set of *_in_guest bools with a u64
      KVM: x86: Provide a capability to disable APERF/MPERF read intercepts
      KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF

Kai Huang (1):
      KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created

Kevin Loughlin (1):
      KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

Kuninori Morimoto (2):
      arm64: kvm: sys_regs: use string choices helper
      arm64: kvm: trace_handle_exit: use string choices helper

Liam Merwick (2):
      KVM: Add trace_kvm_vm_set_mem_attributes()
      KVM: fix typo in kvm_vm_set_mem_attributes() comment

Lorenzo Pieralisi (30):
      dt-bindings: interrupt-controller: Add Arm GICv5
      arm64/sysreg: Add GCIE field to ID_AA64PFR2_EL1
      arm64/sysreg: Add ICC_PPI_PRIORITY<n>_EL1
      arm64/sysreg: Add ICC_ICSR_EL1
      arm64/sysreg: Add ICC_PPI_HMR<n>_EL1
      arm64/sysreg: Add ICC_PPI_ENABLER<n>_EL1
      arm64/sysreg: Add ICC_PPI_{C/S}ACTIVER<n>_EL1
      arm64/sysreg: Add ICC_PPI_{C/S}PENDR<n>_EL1
      arm64/sysreg: Add ICC_CR0_EL1
      arm64/sysreg: Add ICC_PCR_EL1
      arm64/sysreg: Add ICC_IDR0_EL1
      arm64/sysreg: Add ICH_HFGRTR_EL2
      arm64/sysreg: Add ICH_HFGWTR_EL2
      arm64/sysreg: Add ICH_HFGITR_EL2
      arm64: Disable GICv5 read/write/instruction traps
      arm64: cpucaps: Rename GICv3 CPU interface capability
      arm64: cpucaps: Add GICv5 CPU interface (GCIE) capability
      arm64: Add support for GICv5 GSB barriers
      irqchip/gic-v5: Add GICv5 PPI support
      irqchip/gic-v5: Add GICv5 IRS/SPI support
      irqchip/gic-v5: Add GICv5 LPI/IPI support
      irqchip/gic-v5: Enable GICv5 SMP booting
      of/irq: Add of_msi_xlate() helper function
      PCI/MSI: Add pci_msi_map_rid_ctlr_node() helper function
      irqchip/gic-v3: Rename GICv3 ITS MSI parent
      irqchip/msi-lib: Add IRQ_DOMAIN_FLAG_FWNODE_PARENT handling
      irqchip/gic-v5: Add GICv5 ITS support
      irqchip/gic-v5: Add GICv5 IWB support
      docs: arm64: gic-v5: Document booting requirements for GICv5
      arm64: Kconfig: Enable GICv5

Marc Zyngier (28):
      arm64: smp: Support non-SGIs for IPIs
      KVM: arm64: Add helper to identify a nested context
      arm64: smp: Fix pNMI setup after GICv5 rework
      KVM: arm64: Make RVBAR_EL2 accesses UNDEF
      KVM: arm64: Don't advertise ICH_*_EL2 registers through GET_ONE_REG
      KVM: arm64: Define constant value for ICC_SRE_EL2
      KVM: arm64: Define helper for ICH_VTR_EL2
      KVM: arm64: Let GICv3 save/restore honor visibility attribute
      KVM: arm64: Expose GICv3 EL2 registers via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
      KVM: arm64: Condition FGT registers on feature availability
      KVM: arm64: Advertise FGT2 registers to userspace
      KVM: arm64: selftests: get-reg-list: Simplify feature dependency
      KVM: arm64: selftests: get-reg-list: Add base EL2 registers
      KVM: arm64: Document registers exposed via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
      arm64: sysreg: Add THE/ASID2 controls to TCR2_ELx
      KVM: arm64: Convert TCR2_EL2 to config-driven sanitisation
      KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation
      KVM: arm64: Convert MDCR_EL2 to config-driven sanitisation
      KVM: arm64: Tighten the definition of FEAT_PMUv3p9
      KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
      KVM: arm64: Filter out HCR_EL2 bits when running in hypervisor context
      KVM: arm64: Make RAS registers UNDEF when RAS isn't advertised
      KVM: arm64: Remove the wi->{e0,}poe vs wr->{p,u}ov confusion
      KVM: arm64: Follow specification when implementing WXN
      KVM: arm64: vgic-v3: Fix ordering of ICH_HCR_EL2
      KVM: arm64: Clarify the check for reset callback in check_sysreg_table()
      KVM: arm64: Enforce the sorting of the GICv3 system register table
      KVM: arm64: selftest: vgic-v3: Add basic GICv3 sysreg userspace access test

Mark Brown (1):
      KVM: selftests: Add CONFIG_EVENTFD for irqfd selftest

Mark Rutland (2):
      entry: Add arch_in_rcu_eqs()
      KVM: s390: Rework guest entry logic

Maxim Levitsky (5):
      KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter
      KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs
      KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while running the guest
      KVM: SVM: Add enable_ipiv param, never set IsRunning if disabled
      KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU has erratum #1235

Neeraj Upadhyay (13):
      KVM: x86: Open code setting/clearing of bits in the ISR
      KVM: x86: Remove redundant parentheses around 'bitmap'
      KVM: x86: Rename VEC_POS/REG_POS macro usages
      KVM: x86: Change lapic regs base address to void pointer
      KVM: x86: Rename find_highest_vector()
      KVM: x86: Rename lapic get/set_reg() helpers
      KVM: x86: Rename lapic get/set_reg64() helpers
      KVM: x86: Rename lapic set/clear vector helpers
      x86/apic: KVM: Move apic_find_highest_vector() to a common header
      x86/apic: KVM: Move lapic get/set helpers to common code
      x86/apic: KVM: Move lapic set/clear_vector() helpers to common code
      x86/apic: KVM: Move apic_test)vector() to common code
      x86/apic: Rename 'reg_off' to 'reg'

Oliver Upton (43):
      arm64: Detect FEAT_SCTLR2
      arm64: Detect FEAT_DoubleFault2
      KVM: arm64: Treat vCPU with pending SError as runnable
      KVM: arm64: nv: Respect exception routing rules for SEAs
      KVM: arm64: nv: Honor SError exception routing / masking
      KVM: arm64: nv: Add FEAT_RAS vSError sys regs to table
      KVM: arm64: nv: Use guest hypervisor's vSError state
      KVM: arm64: nv: Advertise support for FEAT_RAS
      KVM: arm64: nv: Describe trap behavior of SCTLR2_EL1
      KVM: arm64: Wire up SCTLR2_ELx sysreg descriptors
      KVM: arm64: Context switch SCTLR2_ELx when advertised to the guest
      KVM: arm64: Enable SCTLR2 when advertised to the guest
      KVM: arm64: Describe SCTLR2_ELx RESx masks
      KVM: arm64: Factor out helper for selecting exception target EL
      KVM: arm64: nv: Ensure Address size faults affect correct ESR
      KVM: arm64: Route SEAs to the SError vector when EASE is set
      KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set
      KVM: arm64: nv: Honor SError routing effects of SCTLR2_ELx.NMEA
      KVM: arm64: nv: Enable vSErrors when HCRX_EL2.TMEA is set
      KVM: arm64: Advertise support for FEAT_SCTLR2
      KVM: arm64: Advertise support for FEAT_DoubleFault2
      KVM: arm64: Don't retire MMIO instruction w/ pending (emulated) SError
      KVM: arm64: selftests: Add basic SError injection test
      KVM: arm64: selftests: Test SEAs are taken to SError vector when EASE=1
      KVM: arm64: selftests: Add SCTLR2_EL1 to get-reg-list
      KVM: arm64: selftests: Catch up set_id_regs with the kernel
      KVM: arm64: Populate ESR_ELx.EC for emulated SError injection
      KVM: arm64: selftests: Test ESR propagation for vSError injection
      KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately
      KVM: arm64: Disambiguate support for vSGIs v. vLPIs
      KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
      KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
      Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init
      Merge branch 'kvm-arm64/cacheable-pfnmap' into kvmarm/next
      Merge branch 'kvm-arm64/doublefault2' into kvmarm/next
      Merge tag 'irqchip-gic-v5-host' into kvmarm/next
      Merge branch 'kvm-arm64/gcie-legacy' into kvmarm/next
      Merge branch 'kvm-arm64/misc' into kvmarm/next
      Merge branch 'kvm-arm64/config-masks' into kvmarm/next
      Merge branch 'kvm-arm64/el2-reg-visibility' into kvmarm/next
      Merge branch 'kvm-arm64/vgic-v4-ctl' into kvmarm/next
      KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list
      Documentation: KVM: Use unordered list for pre-init VGIC registers

Paolo Bonzini (16):
      Merge tag 'kvm-riscv-6.17-2' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-x86-irqs-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmio-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-generic-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-dirty_ring-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-no_assignment-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-apic-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'x86_core_for_kvm' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into HEAD
      Merge tag 'kvm-x86-sev-6.17' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvmarm-6.17' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'loongarch-kvm-6.17' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-s390-next-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Quan Zhou (4):
      RISC-V: KVM: Enable ring-based dirty memory tracking
      RISC-V: perf/kvm: Add reporting of interrupt events
      RISC-V: KVM: Use find_vma_intersection() to search for intersecting VMAs
      RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()

Raghavendra Rao Ananta (2):
      KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
      KVM: arm64: selftests: Add test for nASSGIcap attribute

Rahul Kumar (1):
      KVM: selftests: Fix spelling of 'occurrences' in sparsebit.c comments

Samuel Holland (1):
      RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap

Sascha Bischoff (5):
      irqchip/gic-v5: Skip deactivate for forwarded PPI interrupts
      irqchip/gic-v5: Populate struct gic_kvm_info
      arm64/sysreg: Add ICH_VCTLR_EL2
      KVM: arm64: gic-v5: Support GICv3 compat
      KVM: arm64: gic-v5: Probe for GICv5

Sean Christopherson (165):
      KVM: TDX: Use kvm_arch_vcpu.host_debugctl to restore the host's DEBUGCTL
      KVM: x86: Convert vcpu_run()'s immediate exit param into a generic bitmap
      KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag
      KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported
      KVM: VMX: Extract checking of guest's DEBUGCTL into helper
      KVM: SVM: Disable interception of SPEC_CTRL iff the MSR exists for the guest
      KVM: SVM: Allocate IOPM pages after initial setup in svm_hardware_setup()
      KVM: SVM: Don't BUG if setting up the MSR intercept bitmaps fails
      KVM: SVM: Tag MSR bitmap initialization helpers with __init
      KVM: SVM: Use ARRAY_SIZE() to iterate over direct_access_msrs
      KVM: SVM: Kill the VM instead of the host if MSR interception is buggy
      KVM: x86: Use non-atomic bit ops to manipulate "shadow" MSR intercepts
      KVM: SVM: Massage name and param of helper that merges vmcb01 and vmcb12 MSRPMs
      KVM: SVM: Clean up macros related to architectural MSRPM definitions
      KVM: nSVM: Use dedicated array of MSRPM offsets to merge L0 and L1 bitmaps
      KVM: nSVM: Omit SEV-ES specific passthrough MSRs from L0+L1 bitmap merge
      KVM: nSVM: Don't initialize vmcb02 MSRPM with vmcb01's "always passthrough"
      KVM: SVM: Add helpers for accessing MSR bitmap that don't rely on offsets
      KVM: SVM: Implement and adopt VMX style MSR intercepts APIs
      KVM: SVM: Pass through GHCB MSR if and only if VM is an SEV-ES guest
      KVM: SVM: Drop "always" flag from list of possible passthrough MSRs
      KVM: x86: Move definition of X2APIC_MSR() to lapic.h
      KVM: VMX: Manually recalc all MSR intercepts on userspace MSR filter change
      KVM: SVM: Manually recalc all MSR intercepts on userspace MSR filter change
      KVM: x86: Rename msr_filter_changed() => recalc_msr_intercepts()
      KVM: SVM: Rename init_vmcb_after_set_cpuid() to make it intercepts specific
      KVM: SVM: Fold svm_vcpu_init_msrpm() into its sole caller
      KVM: SVM: Merge "after set CPUID" intercept recalc helpers
      KVM: SVM: Drop explicit check on MSRPM offset when emulating SEV-ES accesses
      KVM: SVM: Move svm_msrpm_offset() to nested.c
      KVM: SVM: Store MSRPM pointer as "void *" instead of "u32 *"
      KVM: nSVM: Access MSRPM in 4-byte chunks only for merging L0 and L1 bitmaps
      KVM: SVM: Return -EINVAL instead of MSR_INVALID to signal out-of-range MSR
      KVM: nSVM: Merge MSRPM in 64-bit chunks on 64-bit kernels
      KVM: SVM: Add a helper to allocate and initialize permissions bitmaps
      KVM: x86: Simplify userspace filter logic when disabling MSR interception
      KVM: selftests: Verify KVM disable interception (for userspace) on filter change
      KVM: x86: Drop pending_smi vs. INIT_RECEIVED check when setting MP_STATE
      KVM: x86: WARN and reject KVM_RUN if vCPU's MP_STATE is SIPI_RECEIVED
      KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN
      KVM: x86: Refactor handling of SIPI_RECEIVED when setting MP_STATE
      KVM: x86/mmu: Exempt nested EPT page tables from !USER, CR0.WP=0 logic
      KVM: TDX: Move TDX hardware setup from main.c to tdx.c
      KVM: selftests: Verify KVM is loaded when getting a KVM module param
      KVM: selftests: Add __open_path_or_exit() variant to provide extra help info
      KVM: selftests: Play nice with EACCES errors in open_path_or_exit()
      KVM: selftests: Print a more helpful message for EACCESS in access tracking test
      KVM: Bound the number of dirty ring entries in a single reset at INT_MAX
      KVM: Bail from the dirty ring reset flow if a signal is pending
      KVM: Conditionally reschedule when resetting the dirty ring
      KVM: Check for empty mask of harvested dirty ring entries in caller
      KVM: Use mask of harvested dirty ring entries to coalesce dirty ring resets
      KVM: Assert that slots_lock is held when resetting per-vCPU dirty rings
      KVM: arm64: WARN if unmapping a vLPI fails in any path
      irqbypass: Drop pointless and misleading THIS_MODULE get/put
      irqbypass: Drop superfluous might_sleep() annotations
      irqbypass: Take ownership of producer/consumer token tracking
      irqbypass: Explicitly track producer and consumer bindings
      irqbypass: Use paired consumer/producer to disconnect during unregister
      irqbypass: Use guard(mutex) in lieu of manual lock+unlock
      irqbypass: Use xarray to track producers and consumers
      irqbypass: Require producers to pass in Linux IRQ number during registration
      KVM: x86: Trigger I/O APIC route rescan in kvm_arch_irq_routing_update()
      KVM: x86: Drop superfluous kvm_set_pic_irq() => kvm_pic_set_irq() wrapper
      KVM: x86: Drop superfluous kvm_set_ioapic_irq() => kvm_ioapic_set_irq() wrapper
      KVM: x86: Drop superfluous kvm_hv_set_sint() => kvm_hv_synic_set_irq() wrapper
      KVM: x86: Move PIT ioctl helpers to i8254.c
      KVM: x86: Move KVM_{GET,SET}_IRQCHIP ioctl helpers to irq.c
      KVM: x86: Rename irqchip_kernel() to irqchip_full()
      KVM: x86: Move kvm_setup_default_irq_routing() into irq.c
      KVM: x86: Move kvm_{request,free}_irq_source_id() to i8254.c (PIT)
      KVM: x86: Hardcode the PIT IRQ source ID to '2'
      KVM: x86: Don't clear PIT's IRQ line status when destroying PIT
      KVM: x86: Explicitly check for in-kernel PIC when getting ExtINT
      KVM: Move x86-only tracepoints to x86's trace.h
      KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling in-kernel I/O APIC
      KVM: Squash two CONFIG_HAVE_KVM_IRQCHIP #ifdefs into one
      KVM: selftests: Fall back to split IRQ chip if full in-kernel chip is unsupported
      KVM: x86: Move IRQ mask notifier infrastructure to I/O APIC emulation
      KVM: x86: Fold irq_comm.c into irq.c
      KVM: Pass new routing entries and irqfd when updating IRTEs
      KVM: SVM: Track per-vCPU IRTEs using kvm_kernel_irqfd structure
      KVM: SVM: Delete IRTE link from previous vCPU before setting new IRTE
      iommu/amd: KVM: SVM: Delete now-unused cached/previous GA tag fields
      KVM: SVM: Delete IRTE link from previous vCPU irrespective of new routing
      KVM: SVM: Drop pointless masking of default APIC base when setting V_APIC_BAR
      KVM: SVM: Drop pointless masking of kernel page pa's with AVIC HPA masks
      KVM: SVM: Add helper to deduplicate code for getting AVIC backing page
      KVM: SVM: Drop vcpu_svm's pointless avic_backing_page field
      KVM: SVM: Inhibit AVIC if ID is too big instead of rejecting vCPU creation
      KVM: SVM: Drop redundant check in AVIC code on ID during vCPU creation
      KVM: SVM: Track AVIC tables as natively sized pointers, not "struct pages"
      KVM: SVM: Drop superfluous "cache" of AVIC Physical ID entry pointer
      KVM: VMX: Move enable_ipiv knob to common x86
      KVM: VMX: Suppress PI notifications whenever the vCPU is put
      KVM: SVM: Add a comment to explain why avic_vcpu_blocking() ignores IRQ blocking
      iommu/amd: KVM: SVM: Use pi_desc_addr to derive ga_root_ptr
      iommu/amd: KVM: SVM: Pass NULL @vcpu_info to indicate "not guest mode"
      KVM: SVM: Stop walking list of routing table entries when updating IRTE
      KVM: VMX: Stop walking list of routing table entries when updating IRTE
      KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
      KVM: x86: Move IRQ routing/delivery APIs from x86.c => irq.c
      KVM: x86: Nullify irqfd->producer after updating IRTEs
      KVM: x86: Dedup AVIC vs. PI code for identifying target vCPU
      KVM: x86: Move posted interrupt tracepoint to common code
      KVM: SVM: Clean up return handling in avic_pi_update_irte()
      iommu: KVM: Split "struct vcpu_data" into separate AMD vs. Intel structs
      KVM: Don't WARN if updating IRQ bypass route fails
      KVM: Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing()
      KVM: x86: Track irq_bypass_vcpu in common x86 code
      KVM: x86: Skip IOMMU IRTE updates if there's no old or new vCPU being targeted
      KVM: x86: Don't update IRTE entries when old and new routes were !MSI
      KVM: SVM: Revert IRTE to legacy mode if IOMMU doesn't provide IR metadata
      KVM: SVM: Take and hold ir_list_lock across IRTE updates in IOMMU
      iommu/amd: Document which IRTE fields amd_iommu_update_ga() can modify
      iommu/amd: KVM: SVM: Infer IsRun from validity of pCPU destination
      iommu/amd: Factor out helper for manipulating IRTE GA/CPU info
      iommu/amd: KVM: SVM: Set pCPU info in IRTE when setting vCPU affinity
      iommu/amd: KVM: SVM: Add IRTE metadata to affined vCPU's list if AVIC is inhibited
      KVM: SVM: Don't check for assigned device(s) when updating affinity
      KVM: SVM: Don't check for assigned device(s) when activating AVIC
      KVM: SVM: WARN if (de)activating guest mode in IOMMU fails
      KVM: SVM: Process all IRTEs on affinity change even if one update fails
      KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
      KVM: x86: Drop superfluous "has assigned device" check in kvm_pi_update_irte()
      KVM: x86: WARN if IRQ bypass isn't supported in kvm_pi_update_irte()
      KVM: x86: WARN if IRQ bypass routing is updated without in-kernel local APIC
      KVM: SVM: WARN if ir_list is non-empty at vCPU free
      KVM: x86: Decouple device assignment from IRQ bypass
      KVM: VMX: WARN if VT-d Posted IRQs aren't possible when starting IRQ bypass
      KVM: SVM: Use vcpu_idx, not vcpu_id, for GA log tag/metadata
      iommu/amd: WARN if KVM calls GA IRTE helpers without virtual APIC support
      KVM: SVM: Fold avic_set_pi_irte_mode() into its sole caller
      KVM: SVM: Don't check vCPU's blocking status when toggling AVIC on/off
      KVM: SVM: Consolidate IRTE update when toggling AVIC on/off
      iommu/amd: KVM: SVM: Allow KVM to control need for GA log interrupts
      KVM: SVM: Generate GA log IRQs only if the associated vCPUs is blocking
      KVM: x86: Rename kvm_set_msi_irq() => kvm_msi_to_lapic_irq()
      KVM: Use a local struct to do the initial vfs_poll() on an irqfd
      KVM: Acquire SCRU lock outside of irqfds.lock during assignment
      KVM: Initialize irqfd waitqueue callback when adding to the queue
      KVM: Add irqfd to KVM's list via the vfs_poll() callback
      KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
      sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
      xen: privcmd: Don't mark eventfd waiter as EXCLUSIVE
      sched/wait: Add a waitqueue helper for fully exclusive priority waiters
      KVM: Disallow binding multiple irqfds to an eventfd with a priority waiter
      KVM: Drop sanity check that per-VM list of irqfds is unique
      KVM: selftests: Assert that eventfd() succeeds in Xen shinfo test
      KVM: selftests: Add utilities to create eventfds and do KVM_IRQFD
      KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements
      KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
      KVM: x86: Use kvzalloc() to allocate VM struct
      KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list
      KVM: x86: Avoid calling kvm_is_mmio_pfn() when kvm_x86_ops.get_mt_mask is NULL
      KVM: x86/mmu: Locally cache whether a PFN is host MMIO when making a SPTE
      KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the guest
      Merge branch 'kvm-x86 mmio'
      Revert "kvm: detect assigned device via irqbypass manager"
      VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment()
      KVM: VMX: Add a macro to track which DEBUGCTL bits are host-owned
      KVM: selftests: Expand set of APIs for pinning tasks to a single CPU
      KVM: selftests: Convert arch_timer tests to common helpers to pin task
      KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent
      x86/apic: KVM: Deduplicate APIC vector => register+bit math

Shivank Garg (1):
      KVM: guest_memfd: Remove redundant kvm_gmem_getattr implementation

Tom Lendacky (2):
      KVM: SVM: Allow SNP guest policy disallow running with SMT enabled
      KVM: SVM: Allow SNP guest policy to specify SINGLE_SOCKET

Xin Li (1):
      KVM: x86: Advertise support for LKGS

Xu Lu (1):
      RISC-V: KVM: Delegate illegal instruction fault to VS mode

Yulong Han (1):
      LoongArch: KVM: Add tracepoints for CPUCFG and CSR emulation exits

Yury Norov (NVIDIA) (2):
      LoongArch: KVM: Rework kvm_send_pv_ipi()
      LoongArch: KVM: Simplify kvm_deliver_intr()

Zheyun Shen (2):
      KVM: SVM: Remove wbinvd in sev_vm_destroy()
      KVM: SVM: Flush cache only on CPUs running SEV guest

 Documentation/arch/arm64/booting.rst               |   41 +
 .../interrupt-controller/arm,gic-v5-iwb.yaml       |   78 ++
 .../bindings/interrupt-controller/arm,gic-v5.yaml  |  267 +++++
 Documentation/virt/kvm/api.rst                     |   40 +-
 Documentation/virt/kvm/devices/arm-vgic-v3.rst     |   77 +-
 MAINTAINERS                                        |   10 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/include/asm/barrier.h                   |    3 +
 arch/arm64/include/asm/el2_setup.h                 |   45 +
 arch/arm64/include/asm/kvm_emulate.h               |   51 +-
 arch/arm64/include/asm/kvm_host.h                  |   36 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   18 +
 arch/arm64/include/asm/kvm_nested.h                |    2 +
 arch/arm64/include/asm/smp.h                       |   24 +-
 arch/arm64/include/asm/sysreg.h                    |   71 +-
 arch/arm64/include/asm/vncr_mapping.h              |    2 +
 arch/arm64/kernel/cpufeature.c                     |   26 +-
 arch/arm64/kernel/smp.c                            |  144 ++-
 arch/arm64/kvm/Makefile                            |    3 +-
 arch/arm64/kvm/arch_timer.c                        |    2 +-
 arch/arm64/kvm/arm.c                               |   36 +-
 arch/arm64/kvm/at.c                                |   80 +-
 arch/arm64/kvm/config.c                            |  255 +++-
 arch/arm64/kvm/emulate-nested.c                    |   49 +-
 arch/arm64/kvm/guest.c                             |   62 +-
 arch/arm64/kvm/handle_exit.c                       |   24 +-
 arch/arm64/kvm/hyp/exception.c                     |   16 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   53 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |   49 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   53 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   14 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |    6 +
 arch/arm64/kvm/inject_fault.c                      |  235 ++--
 arch/arm64/kvm/mmio.c                              |   12 +-
 arch/arm64/kvm/mmu.c                               |  105 +-
 arch/arm64/kvm/nested.c                            |  109 +-
 arch/arm64/kvm/sys_regs.c                          |  205 +++-
 arch/arm64/kvm/sys_regs.h                          |    2 +-
 arch/arm64/kvm/trace_handle_exit.h                 |    2 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c                   |  127 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   30 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |    5 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |   70 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   33 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |    2 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |   14 +-
 arch/arm64/kvm/vgic/vgic-v5.c                      |   52 +
 arch/arm64/kvm/vgic/vgic.c                         |    4 +-
 arch/arm64/kvm/vgic/vgic.h                         |   48 +
 arch/arm64/tools/cpucaps                           |    4 +-
 arch/arm64/tools/sysreg                            |  514 +++++++-
 arch/loongarch/include/asm/kvm_host.h              |   12 +-
 arch/loongarch/kvm/exit.c                          |   33 +-
 arch/loongarch/kvm/intc/eiointc.c                  |  553 ++-------
 arch/loongarch/kvm/intc/ipi.c                      |   28 +-
 arch/loongarch/kvm/intc/pch_pic.c                  |    4 +-
 arch/loongarch/kvm/interrupt.c                     |   25 +-
 arch/loongarch/kvm/trace.h                         |   14 +-
 arch/loongarch/kvm/vcpu.c                          |    8 +-
 arch/riscv/include/asm/kvm_aia.h                   |    2 +-
 arch/riscv/include/asm/kvm_gstage.h                |   72 ++
 arch/riscv/include/asm/kvm_host.h                  |  105 +-
 arch/riscv/include/asm/kvm_mmu.h                   |   21 +
 arch/riscv/include/asm/kvm_tlb.h                   |   84 ++
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   12 +
 arch/riscv/include/asm/kvm_vmid.h                  |   27 +
 arch/riscv/include/uapi/asm/kvm.h                  |    1 +
 arch/riscv/kvm/Kconfig                             |    1 +
 arch/riscv/kvm/Makefile                            |    1 +
 arch/riscv/kvm/aia_device.c                        |    6 +-
 arch/riscv/kvm/aia_imsic.c                         |   12 +-
 arch/riscv/kvm/gstage.c                            |  338 ++++++
 arch/riscv/kvm/main.c                              |    3 +-
 arch/riscv/kvm/mmu.c                               |  509 ++------
 arch/riscv/kvm/tlb.c                               |  110 +-
 arch/riscv/kvm/vcpu.c                              |   48 +-
 arch/riscv/kvm/vcpu_exit.c                         |   20 +-
 arch/riscv/kvm/vcpu_onereg.c                       |   83 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   49 +
 arch/riscv/kvm/vcpu_sbi_replace.c                  |   17 +-
 arch/riscv/kvm/vcpu_sbi_sta.c                      |    3 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                      |   25 +-
 arch/riscv/kvm/vm.c                                |    7 +-
 arch/riscv/kvm/vmid.c                              |   25 +
 arch/s390/include/asm/entry-common.h               |   10 +
 arch/s390/include/asm/kvm_host.h                   |    3 +
 arch/s390/kvm/kvm-s390.c                           |   51 +-
 arch/s390/kvm/vsie.c                               |   17 +-
 arch/x86/include/asm/apic.h                        |   66 +-
 arch/x86/include/asm/irq_remapping.h               |   17 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    5 +-
 arch/x86/include/asm/kvm_host.h                    |   76 +-
 arch/x86/include/asm/msr-index.h                   |    1 +
 arch/x86/include/asm/svm.h                         |   13 +-
 arch/x86/kvm/Kconfig                               |   10 +
 arch/x86/kvm/Makefile                              |    7 +-
 arch/x86/kvm/cpuid.c                               |    1 +
 arch/x86/kvm/hyperv.c                              |   10 +-
 arch/x86/kvm/hyperv.h                              |    3 +-
 arch/x86/kvm/i8254.c                               |   90 +-
 arch/x86/kvm/i8254.h                               |   17 +-
 arch/x86/kvm/i8259.c                               |   17 +-
 arch/x86/kvm/ioapic.c                              |   55 +-
 arch/x86/kvm/ioapic.h                              |   24 +-
 arch/x86/kvm/irq.c                                 |  560 ++++++++-
 arch/x86/kvm/irq.h                                 |   45 +-
 arch/x86/kvm/irq_comm.c                            |  469 --------
 arch/x86/kvm/lapic.c                               |  104 +-
 arch/x86/kvm/lapic.h                               |   26 +-
 arch/x86/kvm/mmu/mmu.c                             |   75 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |    3 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |    8 +-
 arch/x86/kvm/mmu/spte.c                            |   43 +-
 arch/x86/kvm/mmu/spte.h                            |   10 +
 arch/x86/kvm/svm/avic.c                            |  692 +++++------
 arch/x86/kvm/svm/nested.c                          |  128 +-
 arch/x86/kvm/svm/sev.c                             |  149 ++-
 arch/x86/kvm/svm/svm.c                             |  512 +++-----
 arch/x86/kvm/svm/svm.h                             |  137 ++-
 arch/x86/kvm/trace.h                               |   99 +-
 arch/x86/kvm/vmx/capabilities.h                    |    1 -
 arch/x86/kvm/vmx/common.h                          |    2 -
 arch/x86/kvm/vmx/main.c                            |   61 +-
 arch/x86/kvm/vmx/nested.c                          |   27 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |    8 +-
 arch/x86/kvm/vmx/posted_intr.c                     |  138 +--
 arch/x86/kvm/vmx/posted_intr.h                     |   10 +-
 arch/x86/kvm/vmx/run_flags.h                       |   10 +-
 arch/x86/kvm/vmx/tdx.c                             |   71 +-
 arch/x86/kvm/vmx/tdx.h                             |    1 +
 arch/x86/kvm/vmx/vmx.c                             |  296 ++---
 arch/x86/kvm/vmx/vmx.h                             |   57 +-
 arch/x86/kvm/vmx/x86_ops.h                         |   16 +-
 arch/x86/kvm/x86.c                                 |  389 ++-----
 arch/x86/kvm/x86.h                                 |   40 +-
 drivers/hv/mshv_eventfd.c                          |    8 +
 drivers/iommu/amd/amd_iommu_types.h                |    1 -
 drivers/iommu/amd/iommu.c                          |  125 +-
 drivers/iommu/intel/irq_remapping.c                |   10 +-
 drivers/irqchip/Kconfig                            |   12 +
 drivers/irqchip/Makefile                           |    5 +-
 drivers/irqchip/irq-gic-common.h                   |    2 -
 ...3-its-msi-parent.c => irq-gic-its-msi-parent.c} |  168 ++-
 drivers/irqchip/irq-gic-its-msi-parent.h           |   12 +
 drivers/irqchip/irq-gic-v3-its.c                   |    1 +
 drivers/irqchip/irq-gic-v4.c                       |    4 +-
 drivers/irqchip/irq-gic-v5-irs.c                   |  822 +++++++++++++
 drivers/irqchip/irq-gic-v5-its.c                   | 1228 ++++++++++++++++++++
 drivers/irqchip/irq-gic-v5-iwb.c                   |  284 +++++
 drivers/irqchip/irq-gic-v5.c                       | 1137 ++++++++++++++++++
 drivers/irqchip/irq-gic.c                          |    2 +-
 drivers/irqchip/irq-msi-lib.c                      |    5 +-
 drivers/of/irq.c                                   |   22 +-
 drivers/pci/msi/irqdomain.c                        |   20 +
 drivers/vfio/pci/vfio_pci_intrs.c                  |   10 +-
 drivers/vhost/vdpa.c                               |   10 +-
 include/asm-generic/msi.h                          |    1 +
 include/kvm/arm_vgic.h                             |   11 +-
 include/linux/amd-iommu.h                          |   25 +-
 include/linux/entry-common.h                       |   16 +
 include/linux/irqbypass.h                          |   46 +-
 include/linux/irqchip/arm-gic-v4.h                 |    2 +-
 include/linux/irqchip/arm-gic-v5.h                 |  394 +++++++
 include/linux/irqchip/arm-vgic-info.h              |    4 +
 include/linux/irqdomain.h                          |    3 +
 include/linux/kvm_dirty_ring.h                     |   18 +-
 include/linux/kvm_host.h                           |   36 +-
 include/linux/kvm_irqfd.h                          |    5 +-
 include/linux/msi.h                                |    1 +
 include/linux/of_irq.h                             |    5 +
 include/linux/wait.h                               |    2 +
 include/trace/events/kvm.h                         |  111 +-
 include/uapi/linux/kvm.h                           |    2 +
 kernel/entry/common.c                              |    3 +-
 kernel/sched/wait.c                                |   22 +-
 tools/include/uapi/linux/kvm.h                     |    1 +
 tools/perf/arch/riscv/util/kvm-stat.c              |    6 +-
 tools/perf/arch/riscv/util/riscv_exception_types.h |   35 -
 tools/perf/arch/riscv/util/riscv_trap_types.h      |   57 +
 tools/testing/selftests/kvm/Makefile.kvm           |    4 +-
 .../selftests/kvm/access_tracking_perf_test.c      |    7 +-
 tools/testing/selftests/kvm/arch_timer.c           |    7 +-
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |   23 +-
 .../testing/selftests/kvm/arm64/external_aborts.c  |  330 ++++++
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |  203 +++-
 tools/testing/selftests/kvm/arm64/mmio_abort.c     |  159 ---
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   14 +-
 tools/testing/selftests/kvm/arm64/vgic_init.c      |  259 ++++-
 tools/testing/selftests/kvm/arm64/vgic_irq.c       |   12 +-
 tools/testing/selftests/kvm/config                 |    1 +
 .../selftests/kvm/include/arm64/processor.h        |   10 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   72 +-
 .../testing/selftests/kvm/include/x86/processor.h  |    6 +-
 tools/testing/selftests/kvm/irqfd_test.c           |  135 +++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   51 +-
 tools/testing/selftests/kvm/lib/memstress.c        |    2 +-
 tools/testing/selftests/kvm/lib/sparsebit.c        |    4 +-
 tools/testing/selftests/kvm/lib/x86/processor.c    |   10 -
 tools/testing/selftests/kvm/x86/aperfmperf_test.c  |  213 ++++
 .../selftests/kvm/x86/userspace_msr_exit_test.c    |    8 +
 .../x86/vmx_exception_with_invalid_guest_state.c   |    2 +-
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c  |   21 +-
 virt/kvm/dirty_ring.c                              |  107 +-
 virt/kvm/eventfd.c                                 |  159 ++-
 virt/kvm/guest_memfd.c                             |   11 -
 virt/kvm/irqchip.c                                 |    2 -
 virt/kvm/kvm_main.c                                |   13 +-
 virt/kvm/vfio.c                                    |    3 -
 virt/lib/irqbypass.c                               |  190 ++-
 209 files changed, 12103 insertions(+), 4778 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5-iwb.yaml
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5.yaml
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5.c
 create mode 100644 arch/riscv/include/asm/kvm_gstage.h
 create mode 100644 arch/riscv/include/asm/kvm_mmu.h
 create mode 100644 arch/riscv/include/asm/kvm_tlb.h
 create mode 100644 arch/riscv/include/asm/kvm_vmid.h
 create mode 100644 arch/riscv/kvm/gstage.c
 delete mode 100644 arch/x86/kvm/irq_comm.c
 rename drivers/irqchip/{irq-gic-v3-its-msi-parent.c => irq-gic-its-msi-parent.c} (59%)
 create mode 100644 drivers/irqchip/irq-gic-its-msi-parent.h
 create mode 100644 drivers/irqchip/irq-gic-v5-irs.c
 create mode 100644 drivers/irqchip/irq-gic-v5-its.c
 create mode 100644 drivers/irqchip/irq-gic-v5-iwb.c
 create mode 100644 drivers/irqchip/irq-gic-v5.c
 create mode 100644 include/linux/irqchip/arm-gic-v5.h
 delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
 create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h
 create mode 100644 tools/testing/selftests/kvm/arm64/external_aborts.c
 delete mode 100644 tools/testing/selftests/kvm/arm64/mmio_abort.c
 create mode 100644 tools/testing/selftests/kvm/irqfd_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c


