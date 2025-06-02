Return-Path: <kvm+bounces-48153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50118ACA9B6
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 09:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 847057AA90F
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 07:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5BD41A8F9E;
	Mon,  2 Jun 2025 07:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBWxdU5q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD19317A303
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 07:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748848307; cv=none; b=JMOH4yfX7e/TPghfRtF3tYzAu2hMprt6rZnTbZ4tqCRKVyAwCuGXHRe34+8DwsbZEVHKh4cZ4FDMPf/zdabfw5f4XogExQWy1y/ddl5fWPK9Nql8CtCjUWTwUocU0baFfj27utQtw2g+EhcEY9+tmAYmB9Fi/T1QSafMlwPaO2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748848307; c=relaxed/simple;
	bh=LDeYjJaDiKHthJVHt6zUGuXWJaDvePnE/19S2dH/4YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vn/YlMMcT/5449jGIk3IpwOaXq/E2x/CLB3dS4tI+eiBgQSIOobCsSRZUlMJldgtDvfpBWq0ur8bvwBR4V8idBL57KEwhSPi9BywSE1hvcfDMDnqjHUR6O6D+1UwL+CWKzBif0Y/75Z7jkozWf9LLUKpM+O2vHfyQFKuyifY+tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBWxdU5q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748848303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tHicIQrCDyLG0s3p+dta+qz+bbPLhUwOsUiCICfSJjM=;
	b=SBWxdU5q/LlavE9NY6DR5hFpak01jHYu5VhPREFc6BROzJJOnmjdNNDmUZTveipkTiyPia
	BZvGepwWkkyfIJgZAhfMAux4h7iuXTzstAq7/Ci8PXikjf3gy+PZSkiYHRo/VR32bZVPO/
	SLgoAIb/V0kGlzrBHdIBAHInjChpwTY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-tCITOv2vOZyDE-mmtApwgA-1; Mon,
 02 Jun 2025 03:11:42 -0400
X-MC-Unique: tCITOv2vOZyDE-mmtApwgA-1
X-Mimecast-MFC-AGG-ID: tCITOv2vOZyDE-mmtApwgA_1748848301
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2378C1956096;
	Mon,  2 Jun 2025 07:11:41 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 842E919560A7;
	Mon,  2 Jun 2025 07:11:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 6.16 merge window
Date: Mon,  2 Jun 2025 03:11:39 -0400
Message-ID: <20250602071139.133967-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus,

The following changes since commit e9f17038d814c0185e017a3fa62305a12d52f45c:

  x86/tdx: mark tdh_vp_enter() as __flatten (2025-05-26 16:45:07 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 61374cc145f4a56377eaf87c7409a97ec7a34041:

  Merge tag 'kvmarm-fixes-6.16-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2025-06-02 03:05:29 -0400)

----------------------------------------------------------------
Generic:

* Clean up locking of all vCPUs for a VM by using the *_nest_lock()
  family of functions, and move duplicated code to virt/kvm/.
  kernel/ patches acked by Peter Zijlstra.

* Add MGLRU support to the access tracking perf test.

ARM fixes:

* Make the irqbypass hooks resilient to changes in the GSI<->MSI
  routing, avoiding behind stale vLPI mappings being left behind. The
  fix is to resolve the VGIC IRQ using the host IRQ (which is stable)
  and nuking the vLPI mapping upon a routing change.

* Close another VGIC race where vCPU creation races with VGIC
  creation, leading to in-flight vCPUs entering the kernel w/o private
  IRQs allocated.

* Fix a build issue triggered by the recently added workaround for
  Ampere's AC04_CPU_23 erratum.

* Correctly sign-extend the VA when emulating a TLBI instruction
  potentially targeting a VNCR mapping.

* Avoid dereferencing a NULL pointer in the VGIC debug code, which can
  happen if the device doesn't have any mapping yet.

s390:

* Fix interaction between some filesystems and Secure Execution

* Some cleanups and refactorings, preparing for an upcoming big series

x86:

* Wait for target vCPU to acknowledge KVM_REQ_UPDATE_PROTECTED_GUEST_STATE to
  fix a race between AP destroy and VMRUN.

* Decrypt and dump the VMSA in dump_vmcb() if debugging enabled for the VM.

* Refine and harden handling of spurious faults.

* Add support for ALLOWED_SEV_FEATURES.

* Add #VMGEXIT to the set of handlers special cased for CONFIG_RETPOLINE=y.

* Treat DEBUGCTL[5:2] as reserved to pave the way for virtualizing features
  that utilize those bits.

* Don't account temporary allocations in sev_send_update_data().

* Add support for KVM_CAP_X86_BUS_LOCK_EXIT on SVM, via Bus Lock Threshold.

* Unify virtualization of IBRS on nested VM-Exit, and cross-vCPU IBPB, between
  SVM and VMX.

* Advertise support to userspace for WRMSRNS and PREFETCHI.

* Rescan I/O APIC routes after handling EOI that needed to be intercepted due
  to the old/previous routing, but not the new/current routing.

* Add a module param to control and enumerate support for device posted
  interrupts.

* Fix a potential overflow with nested virt on Intel systems running 32-bit kernels.

* Flush shadow VMCSes on emergency reboot.

* Add support for SNP to the various SEV selftests.

* Add a selftest to verify fastops instructions via forced emulation.

* Refine and optimize KVM's software processing of the posted interrupt bitmap, and share
  the harvesting code between KVM and the kernel's Posted MSI handler

----------------------------------------------------------------
Babu Moger (1):
      KVM: x86: Advertise support for AMD's PREFETCHI

Borislav Petkov (1):
      KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly

Chao Gao (1):
      KVM: VMX: Flush shadow VMCS on emergency reboot

Claudio Imbrenda (4):
      s390: Remove unneeded includes
      KVM: s390: Remove unneeded srcu lock
      KVM: s390: Refactor and split some gmap helpers
      KVM: s390: Simplify and move pv code

Dan Carpenter (1):
      KVM: x86: clean up a return

David Hildenbrand (3):
      s390/uv: Don't return 0 from make_hva_secure() if the operation was not successful
      s390/uv: Always return 0 from s390_wiggle_split_folio() if successful
      s390/uv: Improve splitting of large folios that cannot be split while dirty

Edward Adam Davis (1):
      KVM: VMX: use __always_inline for is_td_vcpu and is_td

James Houghton (3):
      cgroup: selftests: Move cgroup_util into its own library
      KVM: selftests: Build and link selftests/cgroup/lib into KVM selftests
      KVM: selftests: access_tracking_perf_test: Use MGLRU for access tracking

Kim Phillips (1):
      KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field

Kishon Vijay Abraham I (1):
      x86/cpufeatures: Add "Allowed SEV Features" Feature

Li RongQing (1):
      KVM: Remove obsolete comment about locking for kvm_io_bus_read/write

Manali Shukla (3):
      KVM: x86: Make kvm_pio_request.linear_rip a common field for user exits
      x86/cpufeatures: Add CPUID feature bit for the Bus Lock Threshold
      KVM: SVM: Add support for KVM_CAP_X86_BUS_LOCK_EXIT on SVM CPUs

Marc Zyngier (3):
      arm64: sysreg: Drag linux/kconfig.h to work around vdso build issue
      KVM: arm64: Mask out non-VA bits from TLBI VA* on VNCR invalidation
      KVM: arm64: vgic-debug: Avoid dereferencing NULL ITE pointer

Maxim Levitsky (7):
      KVM: selftests: access_tracking_perf_test: Add option to skip the sanity check
      locking/mutex: implement mutex_trylock_nested
      locking/mutex: implement mutex_lock_killable_nest_lock
      KVM: add kvm_lock_all_vcpus and kvm_trylock_all_vcpus
      x86: KVM: SVM: use kvm_lock_all_vcpus instead of a custom implementation
      KVM: arm64: use kvm_trylock_all_vcpus when locking all vCPUs
      RISC-V: KVM: use kvm_trylock_all_vcpus when locking all vCPUs

Nikunj A Dadhania (2):
      KVM: SVM: Add architectural definitions/assets for Bus Lock Threshold
      KVM: selftests: Add test to verify KVM_CAP_X86_BUS_LOCK_EXIT

Oliver Upton (5):
      KVM: arm64: Use lock guard in vgic_v4_set_forwarding()
      KVM: arm64: Protect vLPI translation with vgic_irq::irq_lock
      KVM: arm64: Resolve vLPI by host IRQ in vgic_v4_unset_forwarding()
      KVM: arm64: Unmap vLPIs affected by changes to GSI routing information
      KVM: arm64: vgic-init: Plug vCPU vs. VGIC creation race

Paolo Bonzini (11):
      Merge tag 'kvm-x86-misc-6.16' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.16' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pir-6.16' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.16' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.16' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.16' of https://github.com/kvm-x86/linux into HEAD
      rust: add helper for mutex_trylock
      Merge branch 'kvm-lockdep-common' into HEAD
      Merge tag 'kvm-s390-next-6.16-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      rtmutex_api: provide correct extern functions
      Merge tag 'kvmarm-fixes-6.16-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Peng Hao (2):
      KVM: SVM: avoid frequency indirect calls
      x86/sev: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables

Pratik R. Sampat (9):
      KVM: selftests: SEV-SNP test for KVM_SEV_INIT2
      KVM: selftests: Add vmgexit helper
      KVM: selftests: Add SMT control state helper
      KVM: selftests: Replace assert() with TEST_ASSERT_EQ()
      KVM: selftests: Introduce SEV VM type check
      KVM: selftests: Add library support for interacting with SNP
      KVM: selftests: Force GUEST_MEMFD flag for SNP VM type
      KVM: selftests: Decouple SEV policy from VM type
      KVM: selftests: Add a basic SEV-SNP smoke test

Sean Christopherson (23):
      x86/msr: Rename the WRMSRNS opcode macro to ASM_WRMSRNS (for KVM)
      KVM: x86: Advertise support for WRMSRNS
      KVM: x86: Isolate edge vs. level check in userspace I/O APIC route scanning
      KVM: x86: Add a helper to deduplicate I/O APIC EOI interception logic
      KVM: VMX: Don't send UNBLOCK when starting device assignment without APICv
      KVM: x86: Add module param to control and enumerate device posted IRQs
      x86/irq: Ensure initial PIR loads are performed exactly once
      x86/irq: Track if IRQ was found in PIR during initial loop (to load PIR vals)
      KVM: VMX: Ensure vIRR isn't reloaded at odd times when sync'ing PIR
      x86/irq: KVM: Track PIR bitmap as an "unsigned long" array
      KVM: VMX: Process PIR using 64-bit accesses on 64-bit kernels
      KVM: VMX: Isolate pure loads from atomic XCHG when processing PIR
      KVM: VMX: Use arch_xchg() when processing PIR to avoid instrumentation
      x86/irq: KVM: Add helper for harvesting PIR to deduplicate KVM and posted MSIs
      KVM: nVMX: Check MSR load/store list counts during VM-Enter consistency checks
      KVM: SVM: Treat DEBUGCTL[5:2] as reserved
      KVM: x86: Unify cross-vCPU IBPB
      KVM: x86: Revert kvm_x86_ops.mem_enc_ioctl() back to an OPTIONAL hook
      KVM: selftests: Add a test for x86's fastops emulation
      KVM: selftests: Extract guts of THP accessor to standalone sysfs helpers
      cgroup: selftests: Move memcontrol specific helpers out of common cgroup_util.c
      cgroup: selftests: Add API to find root of specific controller
      KVM: x86/mmu: Use kvm_x86_call() instead of manual static_call()

Tom Lendacky (6):
      KVM: SVM: Fix SNP AP destroy race with VMRUN
      KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if debugging is enabled
      KVM: SVM: Dump guest register state in dump_vmcb()
      KVM: SVM: Add the type of VM for which the VMCB/VMSA is being dumped
      KVM: SVM: Include the vCPU ID when dumping a VMCB
      KVM: SVM: Add a mutex to dump_vmcb() to prevent concurrent output

Uros Bizjak (1):
      KVM: VMX: Use LEAVE in vmx_do_interrupt_irqoff()

Vishal Verma (3):
      KVM: VMX: Move vt_apicv_pre_state_restore() to posted_intr.c and tweak name
      KVM: VMX: Define a VMX glue macro for kvm_complete_insn_gp()
      KVM: VMX: Clean up and macrofy x86_ops

Yan Zhao (4):
      KVM: x86/mmu: Further check old SPTE is leaf for spurious prefetch fault
      KVM: x86/tdp_mmu: Merge prefetch and access checks for spurious faults
      KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults
      KVM: x86/mmu: Warn if PFN changes on shadow-present SPTE in shadow MMU

Yosry Ahmed (4):
      x86/cpufeatures: Define X86_FEATURE_AMD_IBRS_SAME_MODE
      KVM: x86: Propagate AMD's IbrsSameMode to the guest
      KVM: x86: Generalize IBRS virtualization on emulated VM-exit
      KVM: SVM: Clear current_vmcb during vCPU free for all *possible* CPUs

weizijie (1):
      KVM: x86: Rescan I/O APIC routes after EOI interception for old routing

 Documentation/virt/kvm/api.rst                     |   5 +
 MAINTAINERS                                        |   2 +
 arch/arm64/include/asm/kvm_host.h                  |   3 -
 arch/arm64/include/asm/sysreg.h                    |   1 +
 arch/arm64/kvm/arch_timer.c                        |   4 +-
 arch/arm64/kvm/arm.c                               |  69 ++--
 arch/arm64/kvm/nested.c                            |   6 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |   5 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  31 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  56 +--
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  12 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |  92 ++---
 arch/riscv/kvm/aia_device.c                        |  34 +-
 arch/s390/include/asm/gmap.h                       |   2 -
 arch/s390/include/asm/gmap_helpers.h               |  15 +
 arch/s390/include/asm/tlb.h                        |   1 +
 arch/s390/include/asm/uv.h                         |   1 -
 arch/s390/kernel/uv.c                              |  97 +++++-
 arch/s390/kvm/Makefile                             |   2 +-
 arch/s390/kvm/diag.c                               |  30 +-
 arch/s390/kvm/gaccess.c                            |   3 +-
 arch/s390/kvm/gmap-vsie.c                          |   1 -
 arch/s390/kvm/gmap.c                               | 121 -------
 arch/s390/kvm/gmap.h                               |  39 ---
 arch/s390/kvm/intercept.c                          |   9 +-
 arch/s390/kvm/kvm-s390.c                           |  10 +-
 arch/s390/kvm/kvm-s390.h                           |  42 +++
 arch/s390/kvm/priv.c                               |   6 +-
 arch/s390/kvm/pv.c                                 |  61 +++-
 arch/s390/kvm/vsie.c                               |  19 +-
 arch/s390/mm/Makefile                              |   2 +
 arch/s390/mm/fault.c                               |   1 -
 arch/s390/mm/gmap.c                                | 185 +---------
 arch/s390/mm/gmap_helpers.c                        | 221 ++++++++++++
 arch/s390/mm/init.c                                |   1 -
 arch/s390/mm/pgalloc.c                             |   2 -
 arch/s390/mm/pgtable.c                             |   1 -
 arch/x86/include/asm/cpufeatures.h                 |   4 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   9 +-
 arch/x86/include/asm/msr.h                         |   4 +-
 arch/x86/include/asm/posted_intr.h                 |  78 ++++-
 arch/x86/include/asm/svm.h                         |  10 +-
 arch/x86/include/uapi/asm/kvm.h                    |   1 +
 arch/x86/include/uapi/asm/svm.h                    |   2 +
 arch/x86/kernel/irq.c                              |  63 +---
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/ioapic.c                              |   7 +-
 arch/x86/kvm/ioapic.h                              |   2 +
 arch/x86/kvm/irq_comm.c                            |  37 +-
 arch/x86/kvm/lapic.c                               |  28 +-
 arch/x86/kvm/lapic.h                               |   4 +-
 arch/x86/kvm/mmu/mmu.c                             |   5 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  19 +-
 arch/x86/kvm/svm/nested.c                          |  36 ++
 arch/x86/kvm/svm/sev.c                             | 185 ++++++----
 arch/x86/kvm/svm/svm.c                             | 162 +++++++--
 arch/x86/kvm/svm/svm.h                             |  14 +-
 arch/x86/kvm/vmx/common.h                          |   4 +-
 arch/x86/kvm/vmx/main.c                            | 202 ++++++-----
 arch/x86/kvm/vmx/nested.c                          |  48 +--
 arch/x86/kvm/vmx/posted_intr.c                     |  17 +-
 arch/x86/kvm/vmx/posted_intr.h                     |   5 +-
 arch/x86/kvm/vmx/vmenter.S                         |   3 +-
 arch/x86/kvm/vmx/vmx.c                             |  23 +-
 arch/x86/kvm/vmx/vmx.h                             |   3 +-
 arch/x86/kvm/vmx/x86_ops.h                         |  66 +---
 arch/x86/kvm/x86.c                                 |  44 ++-
 arch/x86/kvm/x86.h                                 |  18 +
 include/kvm/arm_vgic.h                             |   3 +-
 include/linux/kvm_host.h                           |  23 +-
 include/linux/mutex.h                              |  32 +-
 kernel/locking/mutex.c                             |  21 +-
 kernel/locking/rtmutex_api.c                       |  33 +-
 rust/helpers/mutex.c                               |   5 +
 tools/arch/x86/include/asm/cpufeatures.h           |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h              |   1 +
 tools/testing/selftests/cgroup/Makefile            |  21 +-
 .../selftests/cgroup/{ => lib}/cgroup_util.c       | 118 ++-----
 .../cgroup/{ => lib/include}/cgroup_util.h         |  13 +-
 tools/testing/selftests/cgroup/lib/libcgroup.mk    |  19 +
 tools/testing/selftests/cgroup/test_memcontrol.c   |  78 +++++
 tools/testing/selftests/kvm/Makefile.kvm           |   6 +-
 .../selftests/kvm/access_tracking_perf_test.c      | 281 +++++++++++++--
 tools/testing/selftests/kvm/include/kvm_util.h     |  35 ++
 tools/testing/selftests/kvm/include/lru_gen_util.h |  51 +++
 tools/testing/selftests/kvm/include/test_util.h    |   1 +
 .../testing/selftests/kvm/include/x86/processor.h  |   1 +
 tools/testing/selftests/kvm/include/x86/sev.h      |  53 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  21 +-
 tools/testing/selftests/kvm/lib/lru_gen_util.c     | 387 +++++++++++++++++++++
 tools/testing/selftests/kvm/lib/test_util.c        |  46 ++-
 tools/testing/selftests/kvm/lib/x86/processor.c    |   4 +-
 tools/testing/selftests/kvm/lib/x86/sev.c          |  76 +++-
 tools/testing/selftests/kvm/x86/fastops_test.c     | 165 +++++++++
 tools/testing/selftests/kvm/x86/hyperv_cpuid.c     |  21 +-
 tools/testing/selftests/kvm/x86/kvm_buslock_test.c | 135 +++++++
 tools/testing/selftests/kvm/x86/sev_init2_tests.c  |  13 +
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |  75 ++--
 virt/kvm/kvm_main.c                                |  81 ++++-
 100 files changed, 2883 insertions(+), 1242 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h
 create mode 100644 arch/s390/mm/gmap_helpers.c
 rename tools/testing/selftests/cgroup/{ => lib}/cgroup_util.c (88%)
 rename tools/testing/selftests/cgroup/{ => lib/include}/cgroup_util.h (91%)
 create mode 100644 tools/testing/selftests/cgroup/lib/libcgroup.mk
 create mode 100644 tools/testing/selftests/kvm/include/lru_gen_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/lru_gen_util.c
 create mode 100644 tools/testing/selftests/kvm/x86/fastops_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/kvm_buslock_test.c


