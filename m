Return-Path: <kvm+bounces-59529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CAAB2BBE48F
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 16:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AA081894CB1
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 14:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF7B02D47F2;
	Mon,  6 Oct 2025 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fq8UXIdY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74CD1B5EC8
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759759821; cv=none; b=HkfyR+e1F4fmT4c7ER+Ptc8oupvPHiMDOSTwVt+AuVXT4ALwM38m/9zZcM1O/GjlZP1kw+hCvZrmP7unciFVHKUQhsE+jN1eylj74DR5BY6VUbhnvCV4jlFeboFMoqFIV9e3M5/qCbZs0WWODkF+ykYuL18Em/ISVesPeBlpsDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759759821; c=relaxed/simple;
	bh=oeMVGb2RhBnyP9uWNYaMs9K+lGkUhRLa5VREmhDNJAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bn3spGs5trJQ76UMyNdn0rDHscNoM1Zd9edlL8gJ1DRVOnuunrj27FLcNPTG+rzal5pqgIcDhPwNK18C+eEkuUADt4moZQfFU8c1VTFdXwMA3sGH1FCB8PdhsalNz/mkxArs0niizK3p3iVyIiTaBEYij65Z9yPoghdSyksb7Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fq8UXIdY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759759817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hVI0fWJhILzKyGgiYnwIGGBh3T7dLASH/Y4dw4wJEg4=;
	b=fq8UXIdYjEpgZXoMyZFuSxuGm+cBCYlAYJ5TaXvfXkxJ8Ndn9lathc0arieYpWbvCuuxS/
	Uk0rXWzB0jSV4d96Vosdgxs8zvEF9ysIjxXX244v0R1STDUfDuAZ/15YIJ7huLJ1NyFQNE
	L4UW+n9dP+w0RCfBDeUc4SjtgOMepDc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-cIWqWnOXMxeRVHAlmLK1nA-1; Mon,
 06 Oct 2025 10:10:16 -0400
X-MC-Unique: cIWqWnOXMxeRVHAlmLK1nA-1
X-Mimecast-MFC-AGG-ID: cIWqWnOXMxeRVHAlmLK1nA_1759759814
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A707B180048E;
	Mon,  6 Oct 2025 14:10:13 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 266EC19560AB;
	Mon,  6 Oct 2025 14:10:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] Second batch of KVM changes for Linux 6.18
Date: Mon,  6 Oct 2025 10:10:11 -0400
Message-ID: <20251006141011.74372-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus,

The following changes since commit 99cab80208809cb918d6e579e6165279096f058a:

  Merge tag 'kvm-x86-generic-6.18' of https://github.com/kvm-x86/linux into HEAD (2025-09-30 13:27:59 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 6b36119b94d0b2bb8cea9d512017efafd461d6ac:

  KVM: x86: Export KVM-internal symbols for sub-modules only (2025-09-30 13:40:02 -0400)

As mentioned, I was expecting a couple unusual conflicts based on reports
from linux-next.  However, it looks like PeterZ's "KVM: x86: Introduce
EM_ASM_1" is in tip but has not been submitted for inclusion.  In case
it does come in, the resolution is at the end of this message (basically,
Peter removed F() so all F() would become I() in the conflicting area).

Moving on to actual conflicts that you'll encounter:

- cpufeatures.h has a conflict in the scattered CPU features.  Those are
  allocated on a first-come-first-served basis, so you'll have to push
  X86_FEATURE_MSR_IMM from bit 15 to bit 16.

- there is a simple conflict in msr-index.h where commit cdfed9370b96 ("KVM:
  x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header")
  conflicts with changes done to other perf capabilities macros.

Thanks,

Paolo

----------------------------------------------------------------
Generic:

* Rework almost all of KVM's exports to expose symbols only to KVM's x86
  vendor modules (kvm-{amd,intel}.ko and PPC's kvm-{pr,hv}.ko.

x86:

* Rework almost all of KVM x86's exports to expose symbols only to KVM's
  vendor modules, i.e. to kvm-{amd,intel}.ko.

* Add support for virtualizing Control-flow Enforcement Technology (CET) on
  Intel (Shadow Stacks and Indirect Branch Tracking) and AMD (Shadow Stacks).
  It's worth noting that while SHSTK and IBT can be enabled separately in CPUID,
  it is not really possible to virtualize them separately.  Therefore, Intel
  processors will really allow both SHSTK and IBT under the hood if either is
  made visible in the guest's CPUID.  The alternative would be to intercept
  XSAVES/XRSTORS, which is not feasible for performance reasons.

* Fix a variety of fuzzing WARNs all caused by checking L1 intercepts when
  completing userspace I/O.  KVM has already committed to allowing L2 to
  to perform I/O at that point.

* Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2 guests, as the MSR is
  supposed to exist for v2 PMUs.

* Allow Centaur CPU leaves (base 0xC000_0000) for Zhaoxin CPUs.

* Add support for the immediate forms of RDMSR and WRMSRNS, sans full
  emulator support (KVM should never need to emulate the MSRs outside of
  forced emulation and other contrived testing scenarios).

* Clean up the MSR APIs in preparation for CET and FRED virtualization, as
  well as mediated vPMU support.

* Clean up a pile of PMU code in anticipation of adding support for mediated
  vPMUs.

* Reject in-kernel IOAPIC/PIT for TDX VMs, as KVM can't obtain EOI vmexits
  needed to faithfully emulate an I/O APIC for such guests.

* Many cleanups and minor fixes.

* Recover possible NX huge pages within the TDP MMU under read lock to
  reduce guest jitter when restoring NX huge pages.

* Return -EAGAIN during prefault if userspace concurrently deletes/moves the
  relevant memslot, to fix an issue where prefaulting could deadlock with the
  memslot update.

x86 (AMD):

* Enable AVIC by default for Zen4+ if x2AVIC (and other prereqs) is supported.

* Require a minimum GHCB version of 2 when starting SEV-SNP guests via
  KVM_SEV_INIT2 so that invalid GHCB versions result in immediate errors
  instead of latent guest failures.

* Add support for SEV-SNP's CipherText Hiding, an opt-in feature that prevents
  unauthorized CPU accesses from reading the ciphertext of SNP guest private
  memory, e.g. to attempt an offline attack.  This feature splits the shared
  SEV-ES/SEV-SNP ASID space into separate ranges for SEV-ES and SEV-SNP guests,
  therefore a new module parameter is needed to control the number of ASIDs
  that can be used for VMs with CipherText Hiding vs. how many can be used to
  run SEV-ES guests.

* Add support for Secure TSC for SEV-SNP guests, which prevents the untrusted
  host from tampering with the guest's TSC frequency, while still allowing the
  the VMM to configure the guest's TSC frequency prior to launch.

* Validate the XCR0 provided by the guest (via the GHCB) to avoid bugs
  resulting from bogus XCR0 values.

* Save an SEV guest's policy if and only if LAUNCH_START fully succeeds to
  avoid leaving behind stale state (thankfully not consumed in KVM).

* Explicitly reject non-positive effective lengths during SNP's LAUNCH_UPDATE
  instead of subtly relying on guest_memfd to deal with them.

* Reload the pre-VMRUN TSC_AUX on #VMEXIT for SEV-ES guests, not the host's
  desired TSC_AUX, to fix a bug where KVM was keeping a different vCPU's
  TSC_AUX in the host MSR until return to userspace.

KVM (Intel):

* Preparation for FRED support.

* Don't retry in TDX's anti-zero-step mitigation if the target memslot is
  invalid, i.e. is being deleted or moved, to fix a deadlock scenario similar
  to the aforementioned prefaulting case.

* Misc bugfixes and minor cleanups.

----------------------------------------------------------------
Ashish Kalra (2):
      KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
      KVM: SEV: Add SEV-SNP CipherTextHiding support

Bagas Sanjaya (1):
      KVM: x86: Fix hypercalls docs section number order

Chao Gao (5):
      KVM: x86: Zero XSTATE components on INIT by iterating over supported features
      KVM: x86: Check XSS validity against guest CPUIDs
      KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
      KVM: nVMX: Add consistency checks for CET states
      KVM: nVMX: Advertise new VM-Entry/Exit control bits for CET state

Dapeng Mi (5):
      KVM: x86/pmu: Correct typo "_COUTNERS" to "_COUNTERS"
      KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
      KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
      KVM: VMX: Add helpers to toggle/change a bit in VMCS execution controls
      KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents

Ewan Hai (1):
      KVM: x86: allow CPUID 0xC000_0000 to proceed on Zhaoxin CPUs

Hou Wenlong (2):
      KVM: x86: Add helper to retrieve current value of user return MSR
      KVM: SVM: Re-load current, not host, TSC_AUX on #VMEXIT from SEV-ES guest

Jiaming Zhang (1):
      Documentation: KVM: Call out that KVM strictly follows the 8254 PIT spec

John Allen (4):
      KVM: SVM: Emulate reads and writes to shadow stack MSRs
      KVM: SVM: Update dump_vmcb with shadow stack save area additions
      KVM: SVM: Pass through shadow stack MSRs as appropriate
      KVM: SVM: Enable shadow stack virtualization for SVM

Liao Yuanhong (2):
      KVM: x86: Use guard() instead of mutex_lock() to simplify code
      KVM: x86: hyper-v: Use guard() instead of mutex_lock() to simplify code

Mathias Krause (1):
      KVM: VMX: Make CR4.CET a guest owned bit

Naveen N Rao (1):
      KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support

Nikunj A Dadhania (4):
      KVM: SEV: Drop GHCB_VERSION_DEFAULT and open code it
      KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
      x86/cpufeatures: Add SNP Secure TSC
      KVM: SVM: Enable Secure TSC for SNP guests

Paolo Bonzini (6):
      Merge tag 'kvm-x86-mmu-6.18' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.18' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.18' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-ciphertext-6.18' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.18' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-cet-6.18' of https://github.com/kvm-x86/linux into HEAD

Qianfeng Rong (1):
      KVM: TDX: Remove redundant __GFP_ZERO

Sagi Shahar (1):
      KVM: TDX: Reject fully in-kernel irqchip if EOIs are protected, i.e. for TDX VMs

Sean Christopherson (82):
      KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O
      KVM: VMX: Add host MSR read/write helpers to consolidate preemption handling
      KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
      KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid
      KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath IPIs
      KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) handler
      KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
      KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath exits
      KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to be skipped
      KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
      KVM: x86: Fold WRMSR fastpath helpers into the main handler
      KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
      KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
      KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSRs
      KVM: x86/pmu: Rename pmc_speculative_in_use() to pmc_is_locally_enabled()
      KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
      KVM: x86/pmu: Drop redundant check on PMC being globally enabled for emulation
      KVM: x86/pmu: Drop redundant check on PMC being locally enabled for emulation
      KVM: x86/pmu: Rename check_pmu_event_filter() to pmc_is_event_allowed()
      KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger_event()
      KVM: x86: Add a fastpath handler for INVD
      KVM: x86: Rename local "ecx" variables to "msr" and "pmc" as appropriate
      KVM: x86: Use double-underscore read/write MSR helpers as appropriate
      KVM: x86: Manually clear MPX state only on INIT
      KVM: SVM: Move SEV-ES VMSA allocation to a dedicated sev_vcpu_create() helper
      KVM: SEV: Move init of SNP guest state into sev_init_vmcb()
      KVM: SEV: Set RESET GHCB MSR value during sev_es_init_vmcb()
      KVM: SEV: Fold sev_es_vcpu_reset() into sev_vcpu_create()
      KVM: SEV: Save the SEV policy if and only if LAUNCH_START succeeds
      KVM: x86: Move kvm_irq_delivery_to_apic() from irq.c to lapic.c
      KVM: x86: Make "lowest priority" helpers local to lapic.c
      KVM: x86: Move vector_hashing into lapic.c
      KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves memslot during prefault
      KVM: TDX: Do not retry locally when the retry is caused by invalid memslot
      KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
      KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
      KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
      KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic RECALC_INTERCEPTS
      KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
      KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x86
      KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS to PMU v2+
      KVM: x86: Don't treat ENTER and LEAVE as branches, because they aren't
      KVM: SEV: Rename kvm_ghcb_get_sw_exit_code() to kvm_get_cached_sw_exit_code()
      KVM: SEV: Read save fields from GHCB exactly once
      KVM: SEV: Validate XCR0 provided by guest in GHCB
      KVM: SEV: Reject non-positive effective lengths during LAUNCH_UPDATE
      KVM: SVM: Make svm_x86_ops globally visible, clean up on-HyperV usage
      KVM: SVM: Move x2AVIC MSR interception helper to avic.c
      KVM: SVM: Update "APICv in x2APIC without x2AVIC" in avic.c, not svm.c
      KVM: SVM: Always print "AVIC enabled" separately, even when force enabled
      KVM: SVM: Don't advise the user to do force_avic=y (when x2AVIC is detected)
      KVM: SVM: Move global "avic" variable to avic.c
      KVM: x86: Merge 'svm' into 'cet' to pick up GHCB dependencies
      KVM: x86: Merge 'selftests' into 'cet' to pick up ex_str()
      KVM: x86: Report XSS as to-be-saved if there are supported features
      KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
      KVM: x86: Don't emulate instructions affected by CET features
      KVM: x86: Don't emulate task switches when IBT or SHSTK is enabled
      KVM: x86: Emulate SSP[63:32]!=0 #GP(0) for FAR JMP to 32-bit mode
      KVM: x86/mmu: WARN on attempt to check permissions for Shadow Stack #PF
      KVM: x86/mmu: Pretty print PK, SS, and SGX flags in MMU tracepoints
      KVM: nVMX: Always forward XSAVES/XRSTORS exits from L2 to L1
      KVM: x86: Disable support for Shadow Stacks if TDP is disabled
      KVM: x86: Initialize allow_smaller_maxphyaddr earlier in setup
      KVM: x86: Disable support for IBT and SHSTK if allow_smaller_maxphyaddr is true
      KVM: VMX: Configure nested capabilities after CPU capabilities
      KVM: nSVM: Save/load CET Shadow Stack state to/from vmcb12/vmcb02
      KVM: SEV: Synchronize MSR_IA32_XSS from the GHCB when it's valid
      KVM: x86: Add human friendly formatting for #XM, and #VE
      KVM: x86: Define Control Protection Exception (#CP) vector
      KVM: x86: Define AMD's #HV, #VC, and #SX exception vectors
      KVM: selftests: Add an MSR test to exercise guest/host and read/write
      KVM: selftests: Add support for MSR_IA32_{S,U}_CET to MSRs test
      KVM: selftests: Extend MSRs test to validate vCPUs without supported features
      KVM: selftests: Add KVM_{G,S}ET_ONE_REG coverage to MSRs test
      KVM: selftests: Add coverage for KVM-defined registers in MSRs test
      KVM: selftests: Verify MSRs are (not) in save/restore list when (un)supported
      KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot() instead of open coded equivalent
      KVM: Export KVM-internal symbols for sub-modules only
      KVM: x86: Move kvm_intr_is_single_vcpu() to lapic.c
      KVM: x86: Drop pointless exports of kvm_arch_xxx() hooks
      KVM: x86: Export KVM-internal symbols for sub-modules only

Thomas Huth (1):
      arch/x86/kvm/ioapic: Remove license boilerplate with bad FSF address

Thorsten Blum (1):
      KVM: nSVM: Replace kzalloc() + copy_from_user() with memdup_user()

Tony Lindgren (1):
      KVM: TDX: Fix uninitialized error code for __tdx_bringup()

Vipin Sharma (3):
      KVM: x86/mmu: Track possible NX huge pages separately for TDP vs. Shadow MMU
      KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better indicate its purpose
      KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock

Xin Li (6):
      KVM: VMX: Fix an indentation
      x86/cpufeatures: Add a CPU feature bit for MSR immediate form instructions
      KVM: x86: Rename handle_fastpath_set_msr_irqoff() to handle_fastpath_wrmsr()
      KVM: x86: Add support for RDMSR/WRMSRNS w/ immediate on Intel
      KVM: VMX: Support the immediate form of WRMSRNS in the VM-Exit fastpath
      KVM: x86: Advertise support for the immediate form of MSR instructions

Yang Weijiang (18):
      KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest accesses
      KVM: x86: Add kvm_msr_{read,write}() helpers
      KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
      KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
      KVM: x86: Initialize kvm_caps.supported_xss
      KVM: x86: Add fault checks for guest CR4.CET setting
      KVM: x86: Report KVM supported CET MSRs as to-be-saved
      KVM: VMX: Introduce CET VMCS fields and control bits
      KVM: x86: Enable guest SSP read/write interface with new uAPIs
      KVM: VMX: Emulate read and write to CET MSRs
      KVM: x86: Save and reload SSP to/from SMRAM
      KVM: VMX: Set up interception for CET MSRs
      KVM: VMX: Set host constant supervisor states to VMCS fields
      KVM: x86: Allow setting CR4.CET if IBT or SHSTK is supported
      KVM: x86: Add XSS support for CET_KERNEL and CET_USER
      KVM: x86: Enable CET virtualization for VMX and advertise to userspace
      KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2
      KVM: nVMX: Prepare for enabling CET support for nested guest

Yury Norov (1):
      kvm: x86: simplify kvm_vector_to_index()

 Documentation/admin-guide/kernel-parameters.txt    |  21 +
 Documentation/virt/kvm/api.rst                     |  20 +-
 Documentation/virt/kvm/x86/hypercalls.rst          |   6 +-
 arch/powerpc/include/asm/Kbuild                    |   1 -
 arch/powerpc/include/asm/kvm_types.h               |  15 +
 arch/s390/include/asm/kvm_host.h                   |   2 +
 arch/s390/kvm/priv.c                               |   8 +
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |  83 +-
 arch/x86/include/asm/kvm_types.h                   |  10 +
 arch/x86/include/asm/msr-index.h                   |  16 +-
 arch/x86/include/asm/svm.h                         |   1 +
 arch/x86/include/asm/vmx.h                         |   9 +
 arch/x86/include/uapi/asm/kvm.h                    |  34 +
 arch/x86/include/uapi/asm/vmx.h                    |   6 +-
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kvm/cpuid.c                               |  58 +-
 arch/x86/kvm/emulate.c                             | 163 +++-
 arch/x86/kvm/hyperv.c                              |  16 +-
 arch/x86/kvm/ioapic.c                              |  15 +-
 arch/x86/kvm/irq.c                                 |  91 +-
 arch/x86/kvm/irq.h                                 |   4 -
 arch/x86/kvm/kvm_cache_regs.h                      |   3 +-
 arch/x86/kvm/kvm_emulate.h                         |   3 +-
 arch/x86/kvm/kvm_onhyperv.c                        |   6 +-
 arch/x86/kvm/lapic.c                               | 244 ++++--
 arch/x86/kvm/lapic.h                               |  19 +-
 arch/x86/kvm/mmu.h                                 |   2 +-
 arch/x86/kvm/mmu/mmu.c                             | 201 +++--
 arch/x86/kvm/mmu/mmu_internal.h                    |   6 +-
 arch/x86/kvm/mmu/mmutrace.h                        |   3 +
 arch/x86/kvm/mmu/spte.c                            |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  51 +-
 arch/x86/kvm/mmu/tdp_mmu.h                         |   3 +-
 arch/x86/kvm/pmu.c                                 | 175 +++-
 arch/x86/kvm/pmu.h                                 |  60 +-
 arch/x86/kvm/reverse_cpuid.h                       |   5 +
 arch/x86/kvm/smm.c                                 |  14 +-
 arch/x86/kvm/smm.h                                 |   2 +-
 arch/x86/kvm/svm/avic.c                            | 151 +++-
 arch/x86/kvm/svm/nested.c                          |  38 +-
 arch/x86/kvm/svm/pmu.c                             |   8 +-
 arch/x86/kvm/svm/sev.c                             | 231 +++--
 arch/x86/kvm/svm/svm.c                             | 236 +++--
 arch/x86/kvm/svm/svm.h                             |  44 +-
 arch/x86/kvm/svm/svm_onhyperv.c                    |  28 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |  31 +-
 arch/x86/kvm/trace.h                               |   5 +-
 arch/x86/kvm/vmx/capabilities.h                    |  12 +-
 arch/x86/kvm/vmx/main.c                            |  14 +-
 arch/x86/kvm/vmx/nested.c                          | 215 ++++-
 arch/x86/kvm/vmx/nested.h                          |   5 +
 arch/x86/kvm/vmx/pmu_intel.c                       |  79 +-
 arch/x86/kvm/vmx/tdx.c                             |  28 +-
 arch/x86/kvm/vmx/vmcs12.c                          |   6 +
 arch/x86/kvm/vmx/vmcs12.h                          |  14 +-
 arch/x86/kvm/vmx/vmx.c                             | 233 +++--
 arch/x86/kvm/vmx/vmx.h                             |  22 +-
 arch/x86/kvm/vmx/x86_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 | 952 +++++++++++++++------
 arch/x86/kvm/x86.h                                 |  42 +-
 drivers/crypto/ccp/sev-dev.c                       | 127 ++-
 drivers/crypto/ccp/sev-dev.h                       |   6 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |   2 +-
 include/linux/kvm_types.h                          |  25 +-
 include/linux/psp-sev.h                            |  44 +-
 include/uapi/linux/psp-sev.h                       |  10 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../testing/selftests/kvm/include/x86/processor.h  |   5 +
 tools/testing/selftests/kvm/x86/msrs_test.c        | 489 +++++++++++
 .../testing/selftests/kvm/x86/pmu_counters_test.c  |   8 +-
 virt/kvm/eventfd.c                                 |   2 +-
 virt/kvm/guest_memfd.c                             |   7 +-
 virt/kvm/kvm_main.c                                | 127 +--
 75 files changed, 3381 insertions(+), 1259 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_types.h
 create mode 100644 tools/testing/selftests/kvm/x86/msrs_test.c

diff --cc arch/x86/kvm/emulate.c
index 796d0c64f9baf,5c5fb6a6f7f92..0000000000000
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@@ -4001,11 -4153,11 +4088,11 @@@ static const struct opcode group4[] = 
  };
  
  static const struct opcode group5[] = {
 -	F(DstMem | SrcNone | Lock,		em_inc),
 -	F(DstMem | SrcNone | Lock,		em_dec),
 +	I(DstMem | SrcNone | Lock,		em_inc),
 +	I(DstMem | SrcNone | Lock,		em_dec),
- 	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
- 	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
+ 	I(SrcMem | NearBranch | IsBranch | ShadowStack, em_call_near_abs),
+ 	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack, em_call_far),
 -	I(SrcMem | NearBranch | IsBranch, em_jmp_abs),
 +	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
  	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
  	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
  };


