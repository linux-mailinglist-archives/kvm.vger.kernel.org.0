Return-Path: <kvm+bounces-27013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF70097A73D
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A49EA28951B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D12016C84B;
	Mon, 16 Sep 2024 18:18:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D639B15CD58;
	Mon, 16 Sep 2024 18:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726510706; cv=none; b=kVZtJDazz2hu2qP4d7zj827fSaQZtVKrltuDlCcHSIf+fseZEEDgUcHMVUSoXr/tq3ejpJ1H9yeIHb7rrqejrIh456moPs2EX3MVCWCQz64q+JQJ0vs9yyHzlWHWG/AlYR4sh2Da65FWHA/5UMLZPMRqoGiKh+Wcmf9apO6oPf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726510706; c=relaxed/simple;
	bh=MDSaJl5sAMnH3y/1CLTaSwzclLTxhLAIttfd4HIbynM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUlFCjnpQEO3EHCG7Uxlam5EE/4Jna4g+xWIPJsO18s/B9/0QmwezY7+iqHZjUmG0yisWPiGFAOeI8pWpAmkwO9SNTAyFn6T20biIGEdf8Fi/oNCTrB+yZTGkzhsYBSHrlxvkcRKum1xKicdO17fdzP77pcv1ov6n99d1kxuxtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 449301F8C3;
	Mon, 16 Sep 2024 18:18:08 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B42E13A3A;
	Mon, 16 Sep 2024 18:18:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wJALHF926GbveAAAD6G6ig
	(envelope-from <roy.hopkins@suse.com>); Mon, 16 Sep 2024 18:18:07 +0000
From: Roy Hopkins <roy.hopkins@suse.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev
Cc: Roy Hopkins <roy.hopkins@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 1/5] kvm: Move kvm_vcpu fields into common structure
Date: Mon, 16 Sep 2024 19:17:53 +0100
Message-ID: <fc18643cc23514fb8838293c335cc8634bac2c3e.1726506534.git.roy.hopkins@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1726506534.git.roy.hopkins@suse.com>
References: <cover.1726506534.git.roy.hopkins@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 449301F8C3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

This commit is in preparation for supporting multiple VM privilege
levels (VMPLs) within KVM by creating an instance of struct kvm_vcpu
for each VMPL. Support for multiple VMPLs will be introduced in a later
commit. This commit prepares struct kvm_vcpu by allowing the fields that
are common to all VMPLs to be accessed from the struct kvm_vcpu for any
VMPL.

To add support for common fields across multiple struct kvm_vcpus, this
commit creates a sub-structure within struct kvm_vcpu for storing the
common fields. Any fields that have been identified as common across
VMPLs for SEV-SNP (for now) have been moved into this sub-structure.

When the struct kvm_vcpu is initialised, a pointer to the common
structure is stored within struct kvm_vcpu allowing access to the common
fields.

This means that any reference to these common fields needs to be updated
to access them via the structure pointer, e.g.
vcpu->common->[common_field]. This has resulted in this patch generating
many small changes to many files which is an unfortunate side-effect of
this implementation.

Signed-off-by: Roy Hopkins <roy.hopkins@suse.com>
---
 Documentation/virt/kvm/api.rst                |   2 +-
 Documentation/virt/kvm/locking.rst            |   6 +-
 Documentation/virt/kvm/vcpu-requests.rst      |  20 +-
 arch/arm64/kvm/arch_timer.c                   |   4 +-
 arch/arm64/kvm/arm.c                          |  34 +-
 arch/arm64/kvm/debug.c                        |  22 +-
 arch/arm64/kvm/guest.c                        |   6 +-
 arch/arm64/kvm/handle_exit.c                  |  12 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   2 +-
 arch/arm64/kvm/hypercalls.c                   |   2 +-
 arch/arm64/kvm/mmio.c                         |  14 +-
 arch/arm64/kvm/pmu-emul.c                     |   4 +-
 arch/arm64/kvm/psci.c                         |  14 +-
 arch/arm64/kvm/vgic/vgic.c                    |   2 +-
 arch/loongarch/kvm/exit.c                     |  52 +--
 arch/loongarch/kvm/timer.c                    |   2 +-
 arch/loongarch/kvm/vcpu.c                     |  22 +-
 arch/mips/kvm/emulate.c                       |  94 ++---
 arch/mips/kvm/mips.c                          |  52 +--
 arch/mips/kvm/vz.c                            |  30 +-
 arch/powerpc/kvm/book3s.c                     |   4 +-
 arch/powerpc/kvm/book3s_emulate.c             |   6 +-
 arch/powerpc/kvm/book3s_hv.c                  |  38 +-
 arch/powerpc/kvm/book3s_hv_nested.c           |   4 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c          |   8 +-
 arch/powerpc/kvm/book3s_pr.c                  |  38 +-
 arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
 arch/powerpc/kvm/book3s_xics.c                |   8 +-
 arch/powerpc/kvm/book3s_xive.c                |  12 +-
 arch/powerpc/kvm/book3s_xive_native.c         |   8 +-
 arch/powerpc/kvm/booke.c                      |  38 +-
 arch/powerpc/kvm/booke_emulate.c              |  22 +-
 arch/powerpc/kvm/e500_emulate.c               |   6 +-
 arch/powerpc/kvm/emulate.c                    |   6 +-
 arch/powerpc/kvm/emulate_loadstore.c          |   2 +-
 arch/powerpc/kvm/powerpc.c                    |  62 ++--
 arch/powerpc/kvm/timing.h                     |  28 +-
 arch/powerpc/kvm/trace.h                      |   2 +-
 arch/powerpc/kvm/trace_hv.h                   |   2 +-
 arch/riscv/kvm/aia_device.c                   |   8 +-
 arch/riscv/kvm/aia_imsic.c                    |   2 +-
 arch/riscv/kvm/vcpu.c                         |  24 +-
 arch/riscv/kvm/vcpu_insn.c                    |  14 +-
 arch/riscv/kvm/vcpu_sbi.c                     |   2 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                 |   2 +-
 arch/s390/include/asm/kvm_host.h              |   8 +-
 arch/s390/kvm/diag.c                          |  72 ++--
 arch/s390/kvm/gaccess.c                       |   4 +-
 arch/s390/kvm/guestdbg.c                      |  14 +-
 arch/s390/kvm/intercept.c                     |  30 +-
 arch/s390/kvm/interrupt.c                     |  82 ++---
 arch/s390/kvm/kvm-s390.c                      | 160 ++++----
 arch/s390/kvm/kvm-s390.h                      |  12 +-
 arch/s390/kvm/priv.c                          | 186 +++++-----
 arch/s390/kvm/pv.c                            |   2 +-
 arch/s390/kvm/sigp.c                          |  62 ++--
 arch/s390/kvm/vsie.c                          |   6 +-
 arch/x86/kvm/debugfs.c                        |   2 +-
 arch/x86/kvm/hyperv.c                         |  20 +-
 arch/x86/kvm/kvm_cache_regs.h                 |   4 +-
 arch/x86/kvm/lapic.c                          |   4 +-
 arch/x86/kvm/mmu/mmu.c                        |  28 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/pmu.c                            |   2 +-
 arch/x86/kvm/svm/nested.c                     |   6 +-
 arch/x86/kvm/svm/sev.c                        |  66 ++--
 arch/x86/kvm/svm/svm.c                        |  56 +--
 arch/x86/kvm/vmx/nested.c                     |  18 +-
 arch/x86/kvm/vmx/posted_intr.c                |   2 +-
 arch/x86/kvm/vmx/sgx.c                        |   4 +-
 arch/x86/kvm/vmx/vmx.c                        | 128 +++----
 arch/x86/kvm/x86.c                            | 348 +++++++++---------
 arch/x86/kvm/xen.c                            |  24 +-
 arch/x86/kvm/xen.h                            |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c             |  10 +-
 include/linux/kvm_host.h                      | 167 +++++----
 .../selftests/kvm/aarch64/debug-exceptions.c  |   2 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |   2 +-
 .../selftests/kvm/aarch64/smccc_filter.c      |   2 +-
 .../selftests/kvm/demand_paging_test.c        |   2 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   4 +-
 .../testing/selftests/kvm/guest_print_test.c  |   4 +-
 .../selftests/kvm/hardware_disable_test.c     |   2 +-
 .../selftests/kvm/kvm_page_table_test.c       |   2 +-
 .../testing/selftests/kvm/lib/aarch64/ucall.c |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  14 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c |   2 +-
 .../kvm/lib/s390x/diag318_test_handler.c      |   2 +-
 .../selftests/kvm/lib/s390x/processor.c       |   6 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c |   2 +-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   2 +-
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 .../testing/selftests/kvm/memslot_perf_test.c |   2 +-
 .../selftests/kvm/pre_fault_memory_test.c     |   2 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c |  20 +-
 .../testing/selftests/kvm/s390x/debug_test.c  |  12 +-
 tools/testing/selftests/kvm/s390x/memop.c     |   2 +-
 tools/testing/selftests/kvm/s390x/resets.c    |  14 +-
 .../selftests/kvm/s390x/sync_regs_test.c      |  10 +-
 tools/testing/selftests/kvm/s390x/tprot.c     |   2 +-
 .../selftests/kvm/set_memory_region_test.c    |   4 +-
 tools/testing/selftests/kvm/steal_time.c      |   2 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |   2 +-
 .../testing/selftests/kvm/x86_64/debug_regs.c |   2 +-
 .../selftests/kvm/x86_64/fix_hypercall_test.c |   2 +-
 .../selftests/kvm/x86_64/flds_emulation.h     |   2 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c   |   2 +-
 .../kvm/x86_64/nested_exceptions_test.c       |   4 +-
 .../kvm/x86_64/private_mem_conversions_test.c |   4 +-
 .../kvm/x86_64/private_mem_kvm_exits_test.c   |  16 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   2 +-
 .../selftests/kvm/x86_64/sev_smoke_test.c     |  22 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     |  16 +-
 .../kvm/x86_64/triple_fault_event_test.c      |   2 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   2 +-
 .../selftests/kvm/x86_64/userspace_io_test.c  |   2 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |   2 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c  |   2 +-
 .../vmx_exception_with_invalid_guest_state.c  |   2 +-
 .../x86_64/vmx_invalid_nested_guest_state.c   |   2 +-
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |   2 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |   2 +-
 virt/kvm/async_pf.c                           |  60 +--
 virt/kvm/dirty_ring.c                         |   6 +-
 virt/kvm/kvm_main.c                           | 176 ++++-----
 127 files changed, 1375 insertions(+), 1366 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 33938468d62d..5f4df9a90907 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7494,7 +7494,7 @@ initial handling in the kernel, KVM exits to user space with
 KVM_EXIT_S390_STSI to allow user space to insert further data.
 
 Before exiting to userspace, kvm handlers should fill in s390_stsi field of
-vcpu->run::
+vcpu->common->run::
 
   struct {
 	__u64 addr;
diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 02880d5552d5..a571cfa9a8be 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -11,7 +11,7 @@ The acquisition orders for mutexes are as follows:
 
 - cpus_read_lock() is taken outside kvm_lock
 
-- kvm->lock is taken outside vcpu->mutex
+- kvm->lock is taken outside vcpu->common->mutex
 
 - kvm->lock is taken outside kvm->slots_lock and kvm->irq_lock
 
@@ -27,7 +27,7 @@ The acquisition orders for mutexes are as follows:
 For SRCU:
 
 - ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
-  for kvm->lock, vcpu->mutex and kvm->slots_lock.  These locks _cannot_
+  for kvm->lock, vcpu->common->mutex and kvm->slots_lock.  These locks _cannot_
   be taken inside a kvm->srcu read-side critical section; that is, the
   following is broken::
 
@@ -41,7 +41,7 @@ For SRCU:
 
 On x86:
 
-- vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock and kvm->arch.xen.xen_lock
+- vcpu->common->mutex is taken outside kvm->arch.hyperv.hv_lock and kvm->arch.xen.xen_lock
 
 - kvm->arch.mmu_lock is an rwlock; critical sections for
   kvm->arch.tdp_mmu_pages_lock and kvm->arch.mmu_unsync_pages_lock must
diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index 06718b9bc959..2a54cdc908e3 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -63,9 +63,9 @@ are listed below:
 VCPU Mode
 ---------
 
-VCPUs have a mode state, ``vcpu->mode``, that is used to track whether the
+VCPUs have a mode state, ``vcpu->common->mode``, that is used to track whether the
 guest is running in guest mode or not, as well as some specific
-outside guest mode states.  The architecture may use ``vcpu->mode`` to
+outside guest mode states.  The architecture may use ``vcpu->common->mode`` to
 ensure VCPU requests are seen by VCPUs (see "Ensuring Requests Are Seen"),
 as well as to avoid sending unnecessary IPIs (see "IPI Reduction"), and
 even to ensure IPI acknowledgements are waited upon (see "Waiting for
@@ -198,7 +198,7 @@ enter guest mode.  This means that an optimized implementation (see "IPI
 Reduction") must be certain when it's safe to not send the IPI.  One
 solution, which all architectures except s390 apply, is to:
 
-- set ``vcpu->mode`` to IN_GUEST_MODE between disabling the interrupts and
+- set ``vcpu->common->mode`` to IN_GUEST_MODE between disabling the interrupts and
   the last kvm_request_pending() check;
 - enable interrupts atomically when entering the guest.
 
@@ -209,15 +209,15 @@ can exclude the possibility of a VCPU thread observing
 the next request made of it, even if the request is made immediately after
 the check.  This is done by way of the Dekker memory barrier pattern
 (scenario 10 of [lwn-mb]_).  As the Dekker pattern requires two variables,
-this solution pairs ``vcpu->mode`` with ``vcpu->requests``.  Substituting
+this solution pairs ``vcpu->common->mode`` with ``vcpu->requests``.  Substituting
 them into the pattern gives::
 
   CPU1                                    CPU2
   =================                       =================
   local_irq_disable();
-  WRITE_ONCE(vcpu->mode, IN_GUEST_MODE);  kvm_make_request(REQ, vcpu);
+  WRITE_ONCE(vcpu->common->mode, IN_GUEST_MODE);  kvm_make_request(REQ, vcpu);
   smp_mb();                               smp_mb();
-  if (kvm_request_pending(vcpu)) {        if (READ_ONCE(vcpu->mode) ==
+  if (kvm_request_pending(vcpu)) {        if (READ_ONCE(vcpu->common->mode) ==
                                               IN_GUEST_MODE) {
       ...abort guest entry...                 ...send IPI...
   }                                       }
@@ -225,9 +225,9 @@ them into the pattern gives::
 As stated above, the IPI is only useful for VCPU threads in guest mode or
 that have already disabled interrupts.  This is why this specific case of
 the Dekker pattern has been extended to disable interrupts before setting
-``vcpu->mode`` to IN_GUEST_MODE.  WRITE_ONCE() and READ_ONCE() are used to
+``vcpu->common->mode`` to IN_GUEST_MODE.  WRITE_ONCE() and READ_ONCE() are used to
 pedantically implement the memory barrier pattern, guaranteeing the
-compiler doesn't interfere with ``vcpu->mode``'s carefully planned
+compiler doesn't interfere with ``vcpu->common->mode``'s carefully planned
 accesses.
 
 IPI Reduction
@@ -269,8 +269,8 @@ even the request-less VCPU kick is coupled with the same
 local_irq_disable() + smp_mb() pattern described above; the ON bit
 (Outstanding Notification) in the posted interrupt descriptor takes the
 role of ``vcpu->requests``.  When sending a posted interrupt, PIR.ON is
-set before reading ``vcpu->mode``; dually, in the VCPU thread,
-vmx_sync_pir_to_irr() reads PIR after setting ``vcpu->mode`` to
+set before reading ``vcpu->common->mode``; dually, in the VCPU thread,
+vmx_sync_pir_to_irr() reads PIR after setting ``vcpu->common->mode`` to
 IN_GUEST_MODE.
 
 Additional Considerations
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 879982b1cc73..d488bff63fcc 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -431,7 +431,7 @@ void kvm_timer_update_run(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *regs = &vcpu->common->run->s.regs;
 
 	/* Populate the device bitmap with the timer states */
 	regs->device_irq_level &= ~(KVM_ARM_DEV_EL1_VTIMER |
@@ -861,7 +861,7 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-	struct kvm_sync_regs *sregs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *sregs = &vcpu->common->run->s.regs;
 	bool vlevel, plevel;
 
 	if (likely(irqchip_in_kernel(vcpu->kvm)))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a7ca776b51ec..1a2de4007d08 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -456,11 +456,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	spin_lock_init(&vcpu->arch.mp_state_lock);
 
 #ifdef CONFIG_LOCKDEP
-	/* Inform lockdep that the config_lock is acquired after vcpu->mutex */
-	mutex_lock(&vcpu->mutex);
+	/* Inform lockdep that the config_lock is acquired after vcpu->common->mutex */
+	mutex_lock(&vcpu->common->mutex);
 	mutex_lock(&vcpu->kvm->arch.config_lock);
 	mutex_unlock(&vcpu->kvm->arch.config_lock);
-	mutex_unlock(&vcpu->mutex);
+	mutex_unlock(&vcpu->common->mutex);
 #endif
 
 	/* Force users to call KVM_ARM_VCPU_INIT */
@@ -975,9 +975,9 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * userspace informing it of the wakeup condition.
 	 */
 	if (kvm_arch_vcpu_runnable(vcpu)) {
-		memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_WAKEUP;
-		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		memset(&vcpu->common->run->system_event, 0, sizeof(vcpu->common->run->system_event));
+		vcpu->common->run->system_event.type = KVM_SYSTEM_EVENT_WAKEUP;
+		vcpu->common->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 		return 0;
 	}
 
@@ -1067,7 +1067,7 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
  */
 static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	/*
 	 * If we're using a userspace irqchip, then check if we need
@@ -1127,7 +1127,7 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
  */
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int ret;
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
@@ -1138,7 +1138,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	vcpu_load(vcpu);
 
-	if (!vcpu->wants_to_run) {
+	if (!vcpu->common->wants_to_run) {
 		ret = -EINTR;
 		goto out;
 	}
@@ -1192,10 +1192,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
 		 */
-		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		smp_store_mb(vcpu->common->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
+			vcpu->common->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
@@ -1217,8 +1217,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
-		vcpu->stat.exits++;
+		vcpu->common->mode = OUTSIDE_GUEST_MODE;
+		vcpu->common->stat.exits++;
 		/*
 		 * Back from guest
 		 *************************************************************/
@@ -1920,7 +1920,7 @@ static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
 
 	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
 		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
-		mutex_unlock(&tmp_vcpu->mutex);
+		mutex_unlock(&tmp_vcpu->common->mutex);
 	}
 }
 
@@ -1941,13 +1941,13 @@ bool lock_all_vcpus(struct kvm *kvm)
 
 	/*
 	 * Any time a vcpu is in an ioctl (including running), the
-	 * core KVM code tries to grab the vcpu->mutex.
+	 * core KVM code tries to grab the vcpu->common->mutex.
 	 *
-	 * By grabbing the vcpu->mutex of all VCPUs we ensure that no
+	 * By grabbing the vcpu->common->mutex of all VCPUs we ensure that no
 	 * other VCPUs can fiddle with the state while we access it.
 	 */
 	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
-		if (!mutex_trylock(&tmp_vcpu->mutex)) {
+		if (!mutex_trylock(&tmp_vcpu->common->mutex)) {
 			unlock_vcpus(kvm, c - 1);
 			return false;
 		}
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index ce8886122ed3..8a0984778cfa 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -108,7 +108,7 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 				MDCR_EL2_TDOSA);
 
 	/* Is the VM being debugged by userspace? */
-	if (vcpu->guest_debug)
+	if (vcpu->common->guest_debug)
 		/* Route all software debug exceptions to EL2 */
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
 
@@ -119,7 +119,7 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 *  - The guest is not using debug (DEBUG_DIRTY clear).
 	 *  - The guest has enabled the OS Lock (debug exceptions are blocked).
 	 */
-	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
+	if ((vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW) ||
 	    !vcpu_get_flag(vcpu, DEBUG_DIRTY) ||
 	    kvm_vcpu_os_lock_enabled(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
@@ -171,12 +171,12 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
 	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
 
-	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
+	trace_kvm_arm_setup_debug(vcpu, vcpu->common->guest_debug);
 
 	kvm_arm_setup_mdcr_el2(vcpu);
 
 	/* Check if we need to use the debug registers. */
-	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
+	if (vcpu->common->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -200,7 +200,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		 * returns to normal once the host is no longer
 		 * debugging the system.
 		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 			/*
 			 * If the software step state at the last guest exit
 			 * was Active-pending, we don't set DBG_SPSR_SS so
@@ -232,7 +232,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		 * debug ioctl. The existing DEBUG_DIRTY mechanism ensures
 		 * the registers are updated on the world switch.
 		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW) {
 			/* Enable breakpoints/watchpoints */
 			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 			mdscr |= DBG_MDSCR_MDE;
@@ -264,7 +264,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	BUG_ON(!vcpu->guest_debug &&
+	BUG_ON(!vcpu->common->guest_debug &&
 		vcpu->arch.debug_ptr != &vcpu->arch.vcpu_debug_state);
 
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
@@ -280,13 +280,13 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
-	trace_kvm_arm_clear_debug(vcpu->guest_debug);
+	trace_kvm_arm_clear_debug(vcpu->common->guest_debug);
 
 	/*
 	 * Restore the guest's debug registers if we were using them.
 	 */
-	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
-		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+	if (vcpu->common->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 			if (!(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
 				/*
 				 * Mark the vcpu as ACTIVE_PENDING
@@ -301,7 +301,7 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 		 * If we were using HW debug we need to restore the
 		 * debug_ptr to the guest debug state.
 		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW) {
 			kvm_arm_reset_debug_ptr(vcpu);
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 11098eb7eb44..891b6cc27c7c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -927,16 +927,16 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	}
 
 	if (dbg->control & KVM_GUESTDBG_ENABLE) {
-		vcpu->guest_debug = dbg->control;
+		vcpu->common->guest_debug = dbg->control;
 
 		/* Hardware assisted Break and Watch points */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW) {
 			vcpu->arch.external_debug_state = dbg->arch;
 		}
 
 	} else {
 		/* If not enabled clear all flags */
-		vcpu->guest_debug = 0;
+		vcpu->common->guest_debug = 0;
 		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
 	}
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d7c2990e7c9e..de749c8e3009 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -38,7 +38,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
-	vcpu->stat.hvc_exit_stat++;
+	vcpu->common->stat.hvc_exit_stat++;
 
 	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
 	if (vcpu_has_nv(vcpu)) {
@@ -132,10 +132,10 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 
 	if (esr & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
-		vcpu->stat.wfe_exit_stat++;
+		vcpu->common->stat.wfe_exit_stat++;
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
-		vcpu->stat.wfi_exit_stat++;
+		vcpu->common->stat.wfi_exit_stat++;
 	}
 
 	if (esr & ESR_ELx_WFx_ISS_WFxT) {
@@ -176,11 +176,11 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
  * guest and host are using the same debug facilities it will be up to
  * userspace to re-inject the correct exception for guest delivery.
  *
- * @return: 0 (while setting vcpu->run->exit_reason)
+ * @return: 0 (while setting vcpu->common->run->exit_reason)
  */
 static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 
 	run->exit_reason = KVM_EXIT_DEBUG;
@@ -360,7 +360,7 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
  */
 int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (ARM_SERROR_PENDING(exception_index)) {
 		/*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f59ccfe11ab9..6e846b14542f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -645,7 +645,7 @@ static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu, u64 *exit_code
 	 * active-not-pending state?
 	 */
 	if (cpus_have_final_cap(ARM64_WORKAROUND_2077057)		&&
-	    vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP			&&
+	    vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP			&&
 	    *vcpu_cpsr(vcpu) & DBG_SPSR_SS				&&
 	    ESR_ELx_EC(read_sysreg_el2(SYS_ESR)) == ESR_ELx_EC_PAC)
 		write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5763d979d8ca..1b4e11414125 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -244,7 +244,7 @@ static u8 kvm_smccc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
 static void kvm_prepare_hypercall_exit(struct kvm_vcpu *vcpu, u32 func_id)
 {
 	u8 ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	u64 flags = 0;
 
 	if (ec == ESR_ELx_EC_SMC32 || ec == ESR_ELx_EC_SMC64)
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index cd6b7b83e2c3..4524f590e170 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -85,13 +85,13 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	int mask;
 
 	/* Detect an already handled MMIO return */
-	if (unlikely(!vcpu->mmio_needed))
+	if (unlikely(!vcpu->common->mmio_needed))
 		return 1;
 
-	vcpu->mmio_needed = 0;
+	vcpu->common->mmio_needed = 0;
 
 	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
-		struct kvm_run *run = vcpu->run;
+		struct kvm_run *run = vcpu->common->run;
 
 		len = kvm_vcpu_dabt_get_as(vcpu);
 		data = kvm_mmio_read_buf(run->mmio.data, len);
@@ -122,7 +122,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	unsigned long data;
 	unsigned long rt;
 	int ret;
@@ -187,20 +187,20 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	run->mmio.is_write	= is_write;
 	run->mmio.phys_addr	= fault_ipa;
 	run->mmio.len		= len;
-	vcpu->mmio_needed	= 1;
+	vcpu->common->mmio_needed	= 1;
 
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
 		if (!is_write)
 			memcpy(run->mmio.data, data_buf, len);
-		vcpu->stat.mmio_exit_kernel++;
+		vcpu->common->stat.mmio_exit_kernel++;
 		kvm_handle_mmio_return(vcpu);
 		return 1;
 	}
 
 	if (is_write)
 		memcpy(run->mmio.data, data_buf, len);
-	vcpu->stat.mmio_exit_user++;
+	vcpu->common->stat.mmio_exit_user++;
 	run->exit_reason	= KVM_EXIT_MMIO;
 	return 0;
 }
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 82a2a003259c..daa6f4a16612 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -373,7 +373,7 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_sync_regs *sregs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *sregs = &vcpu->common->run->s.regs;
 	bool run_level = sregs->device_irq_level & KVM_ARM_DEV_PMU;
 
 	if (likely(irqchip_in_kernel(vcpu->kvm)))
@@ -387,7 +387,7 @@ bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_update_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *regs = &vcpu->common->run->s.regs;
 
 	/* Populate the timer bitmap for user space */
 	regs->device_irq_level &= ~KVM_ARM_DEV_PMU;
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..5eb741514196 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -182,11 +182,11 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-	vcpu->run->system_event.type = type;
-	vcpu->run->system_event.ndata = 1;
-	vcpu->run->system_event.data[0] = flags;
-	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	memset(&vcpu->common->run->system_event, 0, sizeof(vcpu->common->run->system_event));
+	vcpu->common->run->system_event.type = type;
+	vcpu->common->run->system_event.ndata = 1;
+	vcpu->common->run->system_event.data[0] = flags;
+	vcpu->common->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
 static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
@@ -207,9 +207,9 @@ static void kvm_psci_system_reset2(struct kvm_vcpu *vcpu)
 
 static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
-	memset(&run->system_event, 0, sizeof(vcpu->run->system_event));
+	memset(&run->system_event, 0, sizeof(vcpu->common->run->system_event));
 	run->system_event.type = KVM_SYSTEM_EVENT_SUSPEND;
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f07b3ddff7d4..4685bc985779 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -24,7 +24,7 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
 /*
  * Locking order is always:
  * kvm->lock (mutex)
- *   vcpu->mutex (mutex)
+ *   vcpu->common->mutex (mutex)
  *     kvm->arch.config_lock (mutex)
  *       its->cmd_lock (mutex)
  *         its->its_lock (mutex)
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea73f9dc2cc6..baf8df7b2dcf 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -31,7 +31,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 
 	rd = inst.reg2_format.rd;
 	rj = inst.reg2_format.rj;
-	++vcpu->stat.cpucfg_exits;
+	++vcpu->common->stat.cpucfg_exits;
 	index = vcpu->arch.gprs[rj];
 
 	/*
@@ -241,7 +241,7 @@ int kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 int kvm_emu_idle(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.idle_exits;
+	++vcpu->common->stat.idle_exits;
 	trace_kvm_exit_idle(vcpu, KVM_TRACE_EXIT_IDLE);
 
 	if (!kvm_arch_vcpu_runnable(vcpu))
@@ -255,7 +255,7 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
 	unsigned long curr_pc;
 	larch_inst inst;
 	enum emulation_result er = EMULATE_DONE;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	/* Fetch the instruction */
 	inst.word = vcpu->arch.badi;
@@ -328,10 +328,10 @@ static int kvm_handle_gspr(struct kvm_vcpu *vcpu)
 	if (er == EMULATE_DONE) {
 		ret = RESUME_GUEST;
 	} else if (er == EMULATE_DO_MMIO) {
-		vcpu->run->exit_reason = KVM_EXIT_MMIO;
+		vcpu->common->run->exit_reason = KVM_EXIT_MMIO;
 		ret = RESUME_HOST;
 	} else if (er == EMULATE_DO_IOCSR) {
-		vcpu->run->exit_reason = KVM_EXIT_LOONGARCH_IOCSR;
+		vcpu->common->run->exit_reason = KVM_EXIT_LOONGARCH_IOCSR;
 		ret = RESUME_HOST;
 	} else {
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -345,10 +345,10 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 {
 	int ret;
 	unsigned int op8, opcode, rd;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	run->mmio.phys_addr = vcpu->arch.badv;
-	vcpu->mmio_needed = 2;	/* signed */
+	vcpu->common->mmio_needed = 2;	/* signed */
 	op8 = (inst.word >> 24) & 0xff;
 	ret = EMULATE_DO_MMIO;
 
@@ -377,21 +377,21 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 			run->mmio.len = 1;
 			break;
 		case ldbu_op:
-			vcpu->mmio_needed = 1;	/* unsigned */
+			vcpu->common->mmio_needed = 1;	/* unsigned */
 			run->mmio.len = 1;
 			break;
 		case ldh_op:
 			run->mmio.len = 2;
 			break;
 		case ldhu_op:
-			vcpu->mmio_needed = 1;	/* unsigned */
+			vcpu->common->mmio_needed = 1;	/* unsigned */
 			run->mmio.len = 2;
 			break;
 		case ldw_op:
 			run->mmio.len = 4;
 			break;
 		case ldwu_op:
-			vcpu->mmio_needed = 1;	/* unsigned */
+			vcpu->common->mmio_needed = 1;	/* unsigned */
 			run->mmio.len = 4;
 			break;
 		case ldd_op:
@@ -412,21 +412,21 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 			break;
 		case ldxbu_op:
 			run->mmio.len = 1;
-			vcpu->mmio_needed = 1;	/* unsigned */
+			vcpu->common->mmio_needed = 1;	/* unsigned */
 			break;
 		case ldxh_op:
 			run->mmio.len = 2;
 			break;
 		case ldxhu_op:
 			run->mmio.len = 2;
-			vcpu->mmio_needed = 1;	/* unsigned */
+			vcpu->common->mmio_needed = 1;	/* unsigned */
 			break;
 		case ldxw_op:
 			run->mmio.len = 4;
 			break;
 		case ldxwu_op:
 			run->mmio.len = 4;
-			vcpu->mmio_needed = 1;	/* unsigned */
+			vcpu->common->mmio_needed = 1;	/* unsigned */
 			break;
 		case ldxd_op:
 			run->mmio.len = 8;
@@ -444,14 +444,14 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 		/* Set for kvm_complete_mmio_read() use */
 		vcpu->arch.io_gpr = rd;
 		run->mmio.is_write = 0;
-		vcpu->mmio_is_write = 0;
+		vcpu->common->mmio_is_write = 0;
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
 				run->mmio.phys_addr, NULL);
 	} else {
 		kvm_err("Read not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
 			inst.word, vcpu->arch.pc, vcpu->arch.badv);
 		kvm_arch_vcpu_dump_regs(vcpu);
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 	}
 
 	return ret;
@@ -466,19 +466,19 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	update_pc(&vcpu->arch);
 	switch (run->mmio.len) {
 	case 1:
-		if (vcpu->mmio_needed == 2)
+		if (vcpu->common->mmio_needed == 2)
 			*gpr = *(s8 *)run->mmio.data;
 		else
 			*gpr = *(u8 *)run->mmio.data;
 		break;
 	case 2:
-		if (vcpu->mmio_needed == 2)
+		if (vcpu->common->mmio_needed == 2)
 			*gpr = *(s16 *)run->mmio.data;
 		else
 			*gpr = *(u16 *)run->mmio.data;
 		break;
 	case 4:
-		if (vcpu->mmio_needed == 2)
+		if (vcpu->common->mmio_needed == 2)
 			*gpr = *(s32 *)run->mmio.data;
 		else
 			*gpr = *(u32 *)run->mmio.data;
@@ -504,7 +504,7 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 	int ret;
 	unsigned int rd, op8, opcode;
 	unsigned long curr_pc, rd_val = 0;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	void *data = run->mmio.data;
 
 	/*
@@ -595,8 +595,8 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 
 	if (ret == EMULATE_DO_MMIO) {
 		run->mmio.is_write = 1;
-		vcpu->mmio_needed = 1;
-		vcpu->mmio_is_write = 1;
+		vcpu->common->mmio_needed = 1;
+		vcpu->common->mmio_is_write = 1;
 		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
 				run->mmio.phys_addr, data);
 	} else {
@@ -615,7 +615,7 @@ static int kvm_handle_rdwr_fault(struct kvm_vcpu *vcpu, bool write)
 	int ret;
 	larch_inst inst;
 	enum emulation_result er = EMULATE_DONE;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	unsigned long badv = vcpu->arch.badv;
 
 	ret = kvm_handle_mm_fault(vcpu, badv, write);
@@ -667,7 +667,7 @@ static int kvm_handle_write_fault(struct kvm_vcpu *vcpu)
  */
 static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (!kvm_guest_has_fpu(&vcpu->arch)) {
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -812,13 +812,13 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 
 	switch (code) {
 	case KVM_HCALL_SERVICE:
-		vcpu->stat.hypercall_exits++;
+		vcpu->common->stat.hypercall_exits++;
 		kvm_handle_service(vcpu);
 		break;
 	case KVM_HCALL_SWDBG:
 		/* KVM_HCALL_SWDBG only in effective when SW_BP is enabled */
-		if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
-			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
+			vcpu->common->run->exit_reason = KVM_EXIT_DEBUG;
 			ret = RESUME_HOST;
 			break;
 		}
diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index bcc6b6d063d9..195984339769 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -30,7 +30,7 @@ enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer)
 
 	vcpu = container_of(timer, struct kvm_vcpu, arch.swtimer);
 	kvm_queue_irq(vcpu, INT_TI);
-	rcuwait_wake_up(&vcpu->wait);
+	rcuwait_wake_up(&vcpu->common->wait);
 
 	return HRTIMER_NORESTART;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 16756ffb55e8..cf63b36d92e8 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -156,7 +156,7 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_deliver_intr(vcpu);
 		kvm_deliver_exception(vcpu);
 		/* Make sure the vcpu mode has been written */
-		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		smp_store_mb(vcpu->common->mode, IN_GUEST_MODE);
 		kvm_check_vpid(vcpu);
 
 		/*
@@ -171,7 +171,7 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending()) {
 			/* make sure the vcpu mode has been written */
-			smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
+			smp_store_mb(vcpu->common->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			ret = -EAGAIN;
 		}
@@ -190,7 +190,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	u32 intr = estat & 0x1fff; /* Ignore NMI */
 	u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	vcpu->common->mode = OUTSIDE_GUEST_MODE;
 
 	/* Set a default exit reason */
 	run->exit_reason = KVM_EXIT_UNKNOWN;
@@ -204,7 +204,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		ret = kvm_handle_fault(vcpu, ecode);
 	} else {
 		WARN(!intr, "vm exiting with suspicious irq\n");
-		++vcpu->stat.int_exits;
+		++vcpu->common->stat.int_exits;
 	}
 
 	if (ret == RESUME_GUEST)
@@ -316,9 +316,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (dbg->control & KVM_GUESTDBG_ENABLE)
-		vcpu->guest_debug = dbg->control;
+		vcpu->common->guest_debug = dbg->control;
 	else
-		vcpu->guest_debug = 0;
+		vcpu->common->guest_debug = 0;
 
 	return 0;
 }
@@ -1403,12 +1403,12 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	int r = -EINTR;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
-	if (vcpu->mmio_needed) {
-		if (!vcpu->mmio_is_write)
+	if (vcpu->common->mmio_needed) {
+		if (!vcpu->common->mmio_is_write)
 			kvm_complete_mmio_read(vcpu, run);
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 	}
 
 	if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
@@ -1416,7 +1416,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			kvm_complete_iocsr_read(vcpu, run);
 	}
 
-	if (!vcpu->wants_to_run)
+	if (!vcpu->common->wants_to_run)
 		return r;
 
 	/* Clear exit_reason */
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 0feec52222fb..f8612236d553 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -947,7 +947,7 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 	kvm_debug("[%#lx] !!!WAIT!!! (%#lx)\n", vcpu->arch.pc,
 		  vcpu->arch.pending_exceptions);
 
-	++vcpu->stat.wait_exits;
+	++vcpu->common->stat.wait_exits;
 	trace_kvm_exit(vcpu, KVM_TRACE_EXIT_WAIT);
 	if (!vcpu->arch.pending_exceptions) {
 		kvm_vz_lose_htimer(vcpu);
@@ -959,7 +959,7 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 		 * check if any I/O interrupts are pending.
 		 */
 		if (kvm_arch_vcpu_runnable(vcpu))
-			vcpu->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
+			vcpu->common->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 	}
 
 	return EMULATE_DONE;
@@ -972,7 +972,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 	int r;
 	enum emulation_result er;
 	u32 rt;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	void *data = run->mmio.data;
 	unsigned int imme;
 	unsigned long curr_pc;
@@ -1245,15 +1245,15 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 		goto out_fail;
 	}
 
-	vcpu->mmio_needed = 1;
+	vcpu->common->mmio_needed = 1;
 	run->mmio.is_write = 1;
-	vcpu->mmio_is_write = 1;
+	vcpu->common->mmio_is_write = 1;
 
 	r = kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
 			run->mmio.phys_addr, run->mmio.len, data);
 
 	if (!r) {
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 		return EMULATE_DONE;
 	}
 
@@ -1268,7 +1268,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 					    u32 cause, struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int r;
 	enum emulation_result er;
 	unsigned long curr_pc;
@@ -1297,7 +1297,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 	if (run->mmio.phys_addr == KVM_INVALID_ADDR)
 		return EMULATE_FAIL;
 
-	vcpu->mmio_needed = 2;	/* signed */
+	vcpu->common->mmio_needed = 2;	/* signed */
 	switch (op) {
 #if defined(CONFIG_64BIT)
 	case ld_op:
@@ -1305,7 +1305,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		break;
 
 	case lwu_op:
-		vcpu->mmio_needed = 1;	/* unsigned */
+		vcpu->common->mmio_needed = 1;	/* unsigned */
 		fallthrough;
 #endif
 	case lw_op:
@@ -1313,14 +1313,14 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		break;
 
 	case lhu_op:
-		vcpu->mmio_needed = 1;	/* unsigned */
+		vcpu->common->mmio_needed = 1;	/* unsigned */
 		fallthrough;
 	case lh_op:
 		run->mmio.len = 2;
 		break;
 
 	case lbu_op:
-		vcpu->mmio_needed = 1;	/* unsigned */
+		vcpu->common->mmio_needed = 1;	/* unsigned */
 		fallthrough;
 	case lb_op:
 		run->mmio.len = 1;
@@ -1334,16 +1334,16 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		imme = vcpu->arch.host_cp0_badvaddr & 0x3;
 		switch (imme) {
 		case 0:
-			vcpu->mmio_needed = 3;	/* 1 byte */
+			vcpu->common->mmio_needed = 3;	/* 1 byte */
 			break;
 		case 1:
-			vcpu->mmio_needed = 4;	/* 2 bytes */
+			vcpu->common->mmio_needed = 4;	/* 2 bytes */
 			break;
 		case 2:
-			vcpu->mmio_needed = 5;	/* 3 bytes */
+			vcpu->common->mmio_needed = 5;	/* 3 bytes */
 			break;
 		case 3:
-			vcpu->mmio_needed = 6;	/* 4 bytes */
+			vcpu->common->mmio_needed = 6;	/* 4 bytes */
 			break;
 		default:
 			break;
@@ -1358,16 +1358,16 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		imme = vcpu->arch.host_cp0_badvaddr & 0x3;
 		switch (imme) {
 		case 0:
-			vcpu->mmio_needed = 7;	/* 4 bytes */
+			vcpu->common->mmio_needed = 7;	/* 4 bytes */
 			break;
 		case 1:
-			vcpu->mmio_needed = 8;	/* 3 bytes */
+			vcpu->common->mmio_needed = 8;	/* 3 bytes */
 			break;
 		case 2:
-			vcpu->mmio_needed = 9;	/* 2 bytes */
+			vcpu->common->mmio_needed = 9;	/* 2 bytes */
 			break;
 		case 3:
-			vcpu->mmio_needed = 10;	/* 1 byte */
+			vcpu->common->mmio_needed = 10;	/* 1 byte */
 			break;
 		default:
 			break;
@@ -1383,28 +1383,28 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		imme = vcpu->arch.host_cp0_badvaddr & 0x7;
 		switch (imme) {
 		case 0:
-			vcpu->mmio_needed = 11;	/* 1 byte */
+			vcpu->common->mmio_needed = 11;	/* 1 byte */
 			break;
 		case 1:
-			vcpu->mmio_needed = 12;	/* 2 bytes */
+			vcpu->common->mmio_needed = 12;	/* 2 bytes */
 			break;
 		case 2:
-			vcpu->mmio_needed = 13;	/* 3 bytes */
+			vcpu->common->mmio_needed = 13;	/* 3 bytes */
 			break;
 		case 3:
-			vcpu->mmio_needed = 14;	/* 4 bytes */
+			vcpu->common->mmio_needed = 14;	/* 4 bytes */
 			break;
 		case 4:
-			vcpu->mmio_needed = 15;	/* 5 bytes */
+			vcpu->common->mmio_needed = 15;	/* 5 bytes */
 			break;
 		case 5:
-			vcpu->mmio_needed = 16;	/* 6 bytes */
+			vcpu->common->mmio_needed = 16;	/* 6 bytes */
 			break;
 		case 6:
-			vcpu->mmio_needed = 17;	/* 7 bytes */
+			vcpu->common->mmio_needed = 17;	/* 7 bytes */
 			break;
 		case 7:
-			vcpu->mmio_needed = 18;	/* 8 bytes */
+			vcpu->common->mmio_needed = 18;	/* 8 bytes */
 			break;
 		default:
 			break;
@@ -1419,28 +1419,28 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		imme = vcpu->arch.host_cp0_badvaddr & 0x7;
 		switch (imme) {
 		case 0:
-			vcpu->mmio_needed = 19;	/* 8 bytes */
+			vcpu->common->mmio_needed = 19;	/* 8 bytes */
 			break;
 		case 1:
-			vcpu->mmio_needed = 20;	/* 7 bytes */
+			vcpu->common->mmio_needed = 20;	/* 7 bytes */
 			break;
 		case 2:
-			vcpu->mmio_needed = 21;	/* 6 bytes */
+			vcpu->common->mmio_needed = 21;	/* 6 bytes */
 			break;
 		case 3:
-			vcpu->mmio_needed = 22;	/* 5 bytes */
+			vcpu->common->mmio_needed = 22;	/* 5 bytes */
 			break;
 		case 4:
-			vcpu->mmio_needed = 23;	/* 4 bytes */
+			vcpu->common->mmio_needed = 23;	/* 4 bytes */
 			break;
 		case 5:
-			vcpu->mmio_needed = 24;	/* 3 bytes */
+			vcpu->common->mmio_needed = 24;	/* 3 bytes */
 			break;
 		case 6:
-			vcpu->mmio_needed = 25;	/* 2 bytes */
+			vcpu->common->mmio_needed = 25;	/* 2 bytes */
 			break;
 		case 7:
-			vcpu->mmio_needed = 26;	/* 1 byte */
+			vcpu->common->mmio_needed = 26;	/* 1 byte */
 			break;
 		default:
 			break;
@@ -1462,19 +1462,19 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		 */
 		case 0x0:
 			run->mmio.len = 1;
-			vcpu->mmio_needed = 27;	/* signed */
+			vcpu->common->mmio_needed = 27;	/* signed */
 			break;
 		case 0x1:
 			run->mmio.len = 2;
-			vcpu->mmio_needed = 28;	/* signed */
+			vcpu->common->mmio_needed = 28;	/* signed */
 			break;
 		case 0x2:
 			run->mmio.len = 4;
-			vcpu->mmio_needed = 29;	/* signed */
+			vcpu->common->mmio_needed = 29;	/* signed */
 			break;
 		case 0x3:
 			run->mmio.len = 8;
-			vcpu->mmio_needed = 30;	/* signed */
+			vcpu->common->mmio_needed = 30;	/* signed */
 			break;
 		default:
 			kvm_err("Godson Extended GS-Load for float not yet supported (inst=0x%08x)\n",
@@ -1487,19 +1487,19 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 	default:
 		kvm_err("Load not yet supported (inst=0x%08x)\n",
 			inst.word);
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 		return EMULATE_FAIL;
 	}
 
 	run->mmio.is_write = 0;
-	vcpu->mmio_is_write = 0;
+	vcpu->common->mmio_is_write = 0;
 
 	r = kvm_io_bus_read(vcpu, KVM_MMIO_BUS,
 			run->mmio.phys_addr, run->mmio.len, run->mmio.data);
 
 	if (!r) {
 		kvm_mips_complete_mmio_load(vcpu);
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 		return EMULATE_DONE;
 	}
 
@@ -1508,7 +1508,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 
 enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
 	enum emulation_result er = EMULATE_DONE;
 
@@ -1523,7 +1523,7 @@ enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
 
 	switch (run->mmio.len) {
 	case 8:
-		switch (vcpu->mmio_needed) {
+		switch (vcpu->common->mmio_needed) {
 		case 11:
 			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffffffffff) |
 				(((*(s64 *)run->mmio.data) & 0xff) << 56);
@@ -1590,7 +1590,7 @@ enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
 		break;
 
 	case 4:
-		switch (vcpu->mmio_needed) {
+		switch (vcpu->common->mmio_needed) {
 		case 1:
 			*gpr = *(u32 *)run->mmio.data;
 			break;
@@ -1631,14 +1631,14 @@ enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
 		break;
 
 	case 2:
-		if (vcpu->mmio_needed == 1)
+		if (vcpu->common->mmio_needed == 1)
 			*gpr = *(u16 *)run->mmio.data;
 		else
 			*gpr = *(s16 *)run->mmio.data;
 
 		break;
 	case 1:
-		if (vcpu->mmio_needed == 1)
+		if (vcpu->common->mmio_needed == 1)
 			*gpr = *(u8 *)run->mmio.data;
 		else
 			*gpr = *(s8 *)run->mmio.data;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b5de770b092e..1669bf24f40f 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -265,7 +265,7 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
 	kvm_mips_callbacks->queue_timer_int(vcpu);
 
 	vcpu->arch.wait = 0;
-	rcuwait_wake_up(&vcpu->wait);
+	rcuwait_wake_up(&vcpu->common->wait);
 
 	return kvm_mips_count_timeout(vcpu);
 }
@@ -428,13 +428,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_activate(vcpu);
 
-	if (vcpu->mmio_needed) {
-		if (!vcpu->mmio_is_write)
+	if (vcpu->common->mmio_needed) {
+		if (!vcpu->common->mmio_is_write)
 			kvm_mips_complete_mmio_load(vcpu);
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 	}
 
-	if (!vcpu->wants_to_run)
+	if (!vcpu->common->wants_to_run)
 		goto out;
 
 	lose_fpu(1);
@@ -445,11 +445,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Make sure the read of VCPU requests in vcpu_run() callback is not
-	 * reordered ahead of the write to vcpu->mode, or we could miss a TLB
+	 * reordered ahead of the write to vcpu->common->mode, or we could miss a TLB
 	 * flush request while the requester sees the VCPU as outside of guest
 	 * mode and not needing an IPI.
 	 */
-	smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+	smp_store_mb(vcpu->common->mode, IN_GUEST_MODE);
 
 	r = kvm_mips_vcpu_enter_exit(vcpu);
 
@@ -1168,7 +1168,7 @@ static void kvm_mips_set_c0_status(void)
  */
 static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	u32 cause = vcpu->arch.host_cp0_cause;
 	u32 exccode = (cause >> CAUSEB_EXCCODE) & 0x1f;
 	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
@@ -1177,7 +1177,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 	u32 inst;
 	int ret = RESUME_GUEST;
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	vcpu->common->mode = OUTSIDE_GUEST_MODE;
 
 	/* Set a default exit reason */
 	run->exit_reason = KVM_EXIT_UNKNOWN;
@@ -1199,7 +1199,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 	case EXCCODE_INT:
 		kvm_debug("[%d]EXCCODE_INT @ %p\n", vcpu->vcpu_id, opc);
 
-		++vcpu->stat.int_exits;
+		++vcpu->common->stat.int_exits;
 
 		if (need_resched())
 			cond_resched();
@@ -1210,7 +1210,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 	case EXCCODE_CPU:
 		kvm_debug("EXCCODE_CPU: @ PC: %p\n", opc);
 
-		++vcpu->stat.cop_unusable_exits;
+		++vcpu->common->stat.cop_unusable_exits;
 		ret = kvm_mips_callbacks->handle_cop_unusable(vcpu);
 		/* XXXKYMA: Might need to return to user space */
 		if (run->exit_reason == KVM_EXIT_IRQ_WINDOW_OPEN)
@@ -1218,7 +1218,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		break;
 
 	case EXCCODE_MOD:
-		++vcpu->stat.tlbmod_exits;
+		++vcpu->common->stat.tlbmod_exits;
 		ret = kvm_mips_callbacks->handle_tlb_mod(vcpu);
 		break;
 
@@ -1227,7 +1227,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 			  cause, kvm_read_c0_guest_status(&vcpu->arch.cop0), opc,
 			  badvaddr);
 
-		++vcpu->stat.tlbmiss_st_exits;
+		++vcpu->common->stat.tlbmiss_st_exits;
 		ret = kvm_mips_callbacks->handle_tlb_st_miss(vcpu);
 		break;
 
@@ -1235,52 +1235,52 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		kvm_debug("TLB LD fault: cause %#x, PC: %p, BadVaddr: %#lx\n",
 			  cause, opc, badvaddr);
 
-		++vcpu->stat.tlbmiss_ld_exits;
+		++vcpu->common->stat.tlbmiss_ld_exits;
 		ret = kvm_mips_callbacks->handle_tlb_ld_miss(vcpu);
 		break;
 
 	case EXCCODE_ADES:
-		++vcpu->stat.addrerr_st_exits;
+		++vcpu->common->stat.addrerr_st_exits;
 		ret = kvm_mips_callbacks->handle_addr_err_st(vcpu);
 		break;
 
 	case EXCCODE_ADEL:
-		++vcpu->stat.addrerr_ld_exits;
+		++vcpu->common->stat.addrerr_ld_exits;
 		ret = kvm_mips_callbacks->handle_addr_err_ld(vcpu);
 		break;
 
 	case EXCCODE_SYS:
-		++vcpu->stat.syscall_exits;
+		++vcpu->common->stat.syscall_exits;
 		ret = kvm_mips_callbacks->handle_syscall(vcpu);
 		break;
 
 	case EXCCODE_RI:
-		++vcpu->stat.resvd_inst_exits;
+		++vcpu->common->stat.resvd_inst_exits;
 		ret = kvm_mips_callbacks->handle_res_inst(vcpu);
 		break;
 
 	case EXCCODE_BP:
-		++vcpu->stat.break_inst_exits;
+		++vcpu->common->stat.break_inst_exits;
 		ret = kvm_mips_callbacks->handle_break(vcpu);
 		break;
 
 	case EXCCODE_TR:
-		++vcpu->stat.trap_inst_exits;
+		++vcpu->common->stat.trap_inst_exits;
 		ret = kvm_mips_callbacks->handle_trap(vcpu);
 		break;
 
 	case EXCCODE_MSAFPE:
-		++vcpu->stat.msa_fpe_exits;
+		++vcpu->common->stat.msa_fpe_exits;
 		ret = kvm_mips_callbacks->handle_msa_fpe(vcpu);
 		break;
 
 	case EXCCODE_FPE:
-		++vcpu->stat.fpe_exits;
+		++vcpu->common->stat.fpe_exits;
 		ret = kvm_mips_callbacks->handle_fpe(vcpu);
 		break;
 
 	case EXCCODE_MSADIS:
-		++vcpu->stat.msa_disabled_exits;
+		++vcpu->common->stat.msa_disabled_exits;
 		ret = kvm_mips_callbacks->handle_msa_disabled(vcpu);
 		break;
 
@@ -1317,7 +1317,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			run->exit_reason = KVM_EXIT_INTR;
 			ret = (-EINTR << 2) | RESUME_HOST;
-			++vcpu->stat.signal_exits;
+			++vcpu->common->stat.signal_exits;
 			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_SIGNAL);
 		}
 	}
@@ -1327,11 +1327,11 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 
 		/*
 		 * Make sure the read of VCPU requests in vcpu_reenter()
-		 * callback is not reordered ahead of the write to vcpu->mode,
+		 * callback is not reordered ahead of the write to vcpu->common->mode,
 		 * or we could miss a TLB flush request while the requester sees
 		 * the VCPU as outside of guest mode and not needing an IPI.
 		 */
-		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		smp_store_mb(vcpu->common->mode, IN_GUEST_MODE);
 
 		kvm_mips_callbacks->vcpu_reenter(vcpu);
 
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 99d5a71e4300..7f720410f2fd 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -833,7 +833,7 @@ static int kvm_trap_vz_no_handler(struct kvm_vcpu *vcpu)
 		exccode, opc, inst, badvaddr,
 		read_gc0_status());
 	kvm_arch_vcpu_dump_regs(vcpu);
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	return RESUME_HOST;
 }
 
@@ -1162,7 +1162,7 @@ static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction inst,
 	rd = inst.loongson3_lscsr_format.rd;
 	switch (inst.loongson3_lscsr_format.fr) {
 	case 0x8:  /* Read CPUCFG */
-		++vcpu->stat.vz_cpucfg_exits;
+		++vcpu->common->stat.vz_cpucfg_exits;
 		hostcfg = read_cpucfg(vcpu->arch.gprs[rs]);
 
 		switch (vcpu->arch.gprs[rs]) {
@@ -1491,38 +1491,38 @@ static int kvm_trap_vz_handle_guest_exit(struct kvm_vcpu *vcpu)
 	trace_kvm_exit(vcpu, KVM_TRACE_EXIT_GEXCCODE_BASE + gexccode);
 	switch (gexccode) {
 	case MIPS_GCTL0_GEXC_GPSI:
-		++vcpu->stat.vz_gpsi_exits;
+		++vcpu->common->stat.vz_gpsi_exits;
 		er = kvm_trap_vz_handle_gpsi(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GSFC:
-		++vcpu->stat.vz_gsfc_exits;
+		++vcpu->common->stat.vz_gsfc_exits;
 		er = kvm_trap_vz_handle_gsfc(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_HC:
-		++vcpu->stat.vz_hc_exits;
+		++vcpu->common->stat.vz_hc_exits;
 		er = kvm_trap_vz_handle_hc(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GRR:
-		++vcpu->stat.vz_grr_exits;
+		++vcpu->common->stat.vz_grr_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GVA:
-		++vcpu->stat.vz_gva_exits;
+		++vcpu->common->stat.vz_gva_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GHFC:
-		++vcpu->stat.vz_ghfc_exits;
+		++vcpu->common->stat.vz_ghfc_exits;
 		er = kvm_trap_vz_handle_ghfc(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GPA:
-		++vcpu->stat.vz_gpa_exits;
+		++vcpu->common->stat.vz_gpa_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
 	default:
-		++vcpu->stat.vz_resvd_exits;
+		++vcpu->common->stat.vz_resvd_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
@@ -1534,7 +1534,7 @@ static int kvm_trap_vz_handle_guest_exit(struct kvm_vcpu *vcpu)
 	} else if (er == EMULATE_HYPERCALL) {
 		ret = kvm_mips_handle_hypcall(vcpu);
 	} else {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		ret = RESUME_HOST;
 	}
 	return ret;
@@ -1579,7 +1579,7 @@ static int kvm_trap_vz_handle_cop_unusable(struct kvm_vcpu *vcpu)
 		break;
 
 	case EMULATE_FAIL:
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		ret = RESUME_HOST;
 		break;
 
@@ -1611,7 +1611,7 @@ static int kvm_trap_vz_handle_msa_disabled(struct kvm_vcpu *vcpu)
 	    (read_gc0_status() & (ST0_CU1 | ST0_FR)) == ST0_CU1 ||
 	    !(read_gc0_config5() & MIPS_CONF5_MSAEN) ||
 	    vcpu->arch.aux_inuse & KVM_MIPS_AUX_MSA) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		return RESUME_HOST;
 	}
 
@@ -1622,7 +1622,7 @@ static int kvm_trap_vz_handle_msa_disabled(struct kvm_vcpu *vcpu)
 
 static int kvm_trap_vz_handle_tlb_ld_miss(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	u32 *opc = (u32 *) vcpu->arch.pc;
 	u32 cause = vcpu->arch.host_cp0_cause;
 	ulong badvaddr = vcpu->arch.host_cp0_badvaddr;
@@ -1669,7 +1669,7 @@ static int kvm_trap_vz_handle_tlb_ld_miss(struct kvm_vcpu *vcpu)
 
 static int kvm_trap_vz_handle_tlb_st_miss(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	u32 *opc = (u32 *) vcpu->arch.pc;
 	u32 cause = vcpu->arch.host_cp0_cause;
 	ulong badvaddr = vcpu->arch.host_cp0_badvaddr;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index ff6c38373957..75665a8ae276 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -178,7 +178,7 @@ void kvmppc_book3s_dequeue_irqprio(struct kvm_vcpu *vcpu,
 
 void kvmppc_book3s_queue_irqprio(struct kvm_vcpu *vcpu, unsigned int vec)
 {
-	vcpu->stat.queue_intr++;
+	vcpu->common->stat.queue_intr++;
 
 	set_bit(kvmppc_book3s_vec2irqprio(vec),
 		&vcpu->arch.pending_exceptions);
@@ -818,7 +818,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
 	vcpu_load(vcpu);
-	vcpu->guest_debug = dbg->control;
+	vcpu->common->guest_debug = dbg->control;
 	vcpu_put(vcpu);
 	return 0;
 }
diff --git a/arch/powerpc/kvm/book3s_emulate.c b/arch/powerpc/kvm/book3s_emulate.c
index de126d153328..7078db40fb17 100644
--- a/arch/powerpc/kvm/book3s_emulate.c
+++ b/arch/powerpc/kvm/book3s_emulate.c
@@ -367,13 +367,13 @@ int kvmppc_core_emulate_op_pr(struct kvm_vcpu *vcpu,
 			if (kvmppc_h_pr(vcpu, cmd) == EMULATE_DONE)
 				break;
 
-			vcpu->run->papr_hcall.nr = cmd;
+			vcpu->common->run->papr_hcall.nr = cmd;
 			for (i = 0; i < 9; ++i) {
 				ulong gpr = kvmppc_get_gpr(vcpu, 4 + i);
-				vcpu->run->papr_hcall.args[i] = gpr;
+				vcpu->common->run->papr_hcall.args[i] = gpr;
 			}
 
-			vcpu->run->exit_reason = KVM_EXIT_PAPR_HCALL;
+			vcpu->common->run->exit_reason = KVM_EXIT_PAPR_HCALL;
 			vcpu->arch.hcall_needed = 1;
 			emulated = EMULATE_EXIT_USER;
 			break;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8f7d7e37bc8c..b71735d10d85 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -238,7 +238,7 @@ static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 
 	waitp = kvm_arch_vcpu_get_wait(vcpu);
 	if (rcuwait_wake_up(waitp))
-		++vcpu->stat.generic.halt_wakeup;
+		++vcpu->common->stat.generic.halt_wakeup;
 
 	cpu = READ_ONCE(vcpu->arch.thread_cpu);
 	if (cpu >= 0 && kvmppc_ipi_thread(cpu))
@@ -1482,8 +1482,8 @@ static int kvmppc_emulate_debug_inst(struct kvm_vcpu *vcpu)
 	}
 
 	if (ppc_inst_val(last_inst) == KVMPPC_INST_SW_BREAKPOINT) {
-		vcpu->run->exit_reason = KVM_EXIT_DEBUG;
-		vcpu->run->debug.arch.address = kvmppc_get_pc(vcpu);
+		vcpu->common->run->exit_reason = KVM_EXIT_DEBUG;
+		vcpu->common->run->debug.arch.address = kvmppc_get_pc(vcpu);
 		return RESUME_HOST;
 	} else {
 		kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
@@ -1627,10 +1627,10 @@ static int kvmppc_tm_unavailable(struct kvm_vcpu *vcpu)
 static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				 struct task_struct *tsk)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int r = RESUME_HOST;
 
-	vcpu->stat.sum_exits++;
+	vcpu->common->stat.sum_exits++;
 
 	/*
 	 * This can happen if an interrupt occurs in the last stages
@@ -1659,13 +1659,13 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
 		fallthrough;
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
-		vcpu->stat.dec_exits++;
+		vcpu->common->stat.dec_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_EXTERNAL:
 	case BOOK3S_INTERRUPT_H_DOORBELL:
 	case BOOK3S_INTERRUPT_H_VIRT:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->common->stat.ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
 	/* SR/HMI/PMI are HV interrupts that host has handled. Resume guest.*/
@@ -1887,7 +1887,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			vcpu->arch.last_inst = kvmppc_need_byteswap(vcpu) ?
 				swab32(vcpu->arch.emul_inst) :
 				vcpu->arch.emul_inst;
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
 			r = kvmppc_emulate_debug_inst(vcpu);
 		} else {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
@@ -1960,7 +1960,7 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 	int r;
 	int srcu_idx;
 
-	vcpu->stat.sum_exits++;
+	vcpu->common->stat.sum_exits++;
 
 	/*
 	 * This can happen if an interrupt occurs in the last stages
@@ -1981,22 +1981,22 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 	switch (vcpu->arch.trap) {
 	/* We're good on these - the host merely wanted to get our attention */
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
-		vcpu->stat.dec_exits++;
+		vcpu->common->stat.dec_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_EXTERNAL:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->common->stat.ext_intr_exits++;
 		r = RESUME_HOST;
 		break;
 	case BOOK3S_INTERRUPT_H_DOORBELL:
 	case BOOK3S_INTERRUPT_H_VIRT:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->common->stat.ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
 	/* These need to go to the nested HV */
 	case BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER:
 		vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
-		vcpu->stat.dec_exits++;
+		vcpu->common->stat.dec_exits++;
 		r = RESUME_HOST;
 		break;
 	/* SR/HMI/PMI are HV interrupts that host has handled. Resume guest.*/
@@ -4679,7 +4679,7 @@ static int kvmhv_setup_mmu(struct kvm_vcpu *vcpu)
 
 static int kvmppc_run_vcpu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int n_ceded, i, r;
 	struct kvmppc_vcore *vc;
 	struct kvm_vcpu *v;
@@ -4790,7 +4790,7 @@ static int kvmppc_run_vcpu(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.state == KVMPPC_VCPU_RUNNABLE) {
 		kvmppc_remove_runnable(vc, vcpu, mftb());
-		vcpu->stat.signal_exits++;
+		vcpu->common->stat.signal_exits++;
 		run->exit_reason = KVM_EXIT_INTR;
 		vcpu->arch.ret = -EINTR;
 	}
@@ -4811,7 +4811,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 			  unsigned long lpcr)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int trap, r, pcpu;
 	int srcu_idx;
 	struct kvmppc_vcore *vc;
@@ -4978,7 +4978,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 		for (;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (signal_pending(current)) {
-				vcpu->stat.signal_exits++;
+				vcpu->common->stat.signal_exits++;
 				run->exit_reason = KVM_EXIT_INTR;
 				vcpu->arch.ret = -EINTR;
 				break;
@@ -5001,7 +5001,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	return vcpu->arch.ret;
 
  sigpend:
-	vcpu->stat.signal_exits++;
+	vcpu->common->stat.signal_exits++;
 	run->exit_reason = KVM_EXIT_INTR;
 	vcpu->arch.ret = -EINTR;
  out:
@@ -5015,7 +5015,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int r;
 	int srcu_idx;
 	struct kvm *kvm;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 05f5220960c6..0a8383cca6f7 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -203,7 +203,7 @@ static void kvmhv_nested_mmio_needed(struct kvm_vcpu *vcpu, u64 regs_ptr)
 	 * written there in kvmppc_complete_mmio_load()
 	 */
 	if (((vcpu->arch.io_gpr & KVM_MMIO_REG_EXT_MASK) == KVM_MMIO_REG_GPR)
-	    && (vcpu->mmio_is_write == 0)) {
+	    && (vcpu->common->mmio_is_write == 0)) {
 		vcpu->arch.nested_io_gpr = (gpa_t) regs_ptr +
 					   offsetof(struct pt_regs,
 						    gpr[vcpu->arch.io_gpr]);
@@ -420,7 +420,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	if (r == -EINTR)
 		return H_INTERRUPT;
 
-	if (vcpu->mmio_needed) {
+	if (vcpu->common->mmio_needed) {
 		kvmhv_nested_mmio_needed(vcpu, regs_ptr);
 		return H_TOO_HARD;
 	}
diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index f2636414d82a..abc5b2b7afc5 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -132,7 +132,7 @@ static void icp_rm_set_vcpu_irq(struct kvm_vcpu *vcpu,
 	int hcore;
 
 	/* Mark the target VCPU as having an interrupt pending */
-	vcpu->stat.queue_intr++;
+	vcpu->common->stat.queue_intr++;
 	set_bit(BOOK3S_IRQPRIO_EXTERNAL, &vcpu->arch.pending_exceptions);
 
 	/* Kick self ? Just set MER and return */
@@ -713,14 +713,14 @@ static int ics_rm_eoi(struct kvm_vcpu *vcpu, u32 irq)
 
 	/* Handle passthrough interrupts */
 	if (state->host_irq) {
-		++vcpu->stat.pthru_all;
+		++vcpu->common->stat.pthru_all;
 		if (state->intr_cpu != -1) {
 			int pcpu = raw_smp_processor_id();
 
 			pcpu = cpu_first_thread_sibling(pcpu);
-			++vcpu->stat.pthru_host;
+			++vcpu->common->stat.pthru_host;
 			if (state->intr_cpu != pcpu) {
-				++vcpu->stat.pthru_bad_aff;
+				++vcpu->common->stat.pthru_bad_aff;
 				xics_opal_set_server(state->host_irq, pcpu);
 			}
 			state->intr_cpu = -1;
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 7b8ae509328f..a9ba0b6334d0 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -493,7 +493,7 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
 	if (msr & MSR_POW) {
 		if (!vcpu->arch.pending_exceptions) {
 			kvm_vcpu_halt(vcpu);
-			vcpu->stat.generic.halt_wakeup++;
+			vcpu->common->stat.generic.halt_wakeup++;
 
 			/* Unset POW bit after we woke up */
 			msr &= ~MSR_POW;
@@ -774,17 +774,17 @@ static int kvmppc_handle_pagefault(struct kvm_vcpu *vcpu,
 		/* The guest's PTE is not mapped yet. Map on the host */
 		if (kvmppc_mmu_map_page(vcpu, &pte, iswrite) == -EIO) {
 			/* Exit KVM if mapping failed */
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 			return RESUME_HOST;
 		}
 		if (data)
-			vcpu->stat.sp_storage++;
+			vcpu->common->stat.sp_storage++;
 		else if (vcpu->arch.mmu.is_dcbz32(vcpu) &&
 			 (!(vcpu->arch.hflags & BOOK3S_HFLAG_DCBZ32)))
 			kvmppc_patch_dcbz(vcpu, &pte);
 	} else {
 		/* MMIO */
-		vcpu->stat.mmio_exits++;
+		vcpu->common->stat.mmio_exits++;
 		vcpu->arch.paddr_accessed = pte.raddr;
 		vcpu->arch.vaddr_accessed = pte.eaddr;
 		r = kvmppc_emulate_mmio(vcpu);
@@ -1056,7 +1056,7 @@ void kvmppc_set_fscr(struct kvm_vcpu *vcpu, u64 fscr)
 
 static void kvmppc_setup_debug(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		u64 msr = kvmppc_get_msr(vcpu);
 
 		kvmppc_set_msr(vcpu, msr | MSR_SE);
@@ -1065,7 +1065,7 @@ static void kvmppc_setup_debug(struct kvm_vcpu *vcpu)
 
 static void kvmppc_clear_debug(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		u64 msr = kvmppc_get_msr(vcpu);
 
 		kvmppc_set_msr(vcpu, msr & ~MSR_SE);
@@ -1105,7 +1105,7 @@ static int kvmppc_exit_pr_progint(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 		}
 	}
 
-	vcpu->stat.emulated_inst_exits++;
+	vcpu->common->stat.emulated_inst_exits++;
 	er = kvmppc_emulate_instruction(vcpu);
 	switch (er) {
 	case EMULATE_DONE:
@@ -1121,7 +1121,7 @@ static int kvmppc_exit_pr_progint(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 		r = RESUME_GUEST;
 		break;
 	case EMULATE_DO_MMIO:
-		vcpu->run->exit_reason = KVM_EXIT_MMIO;
+		vcpu->common->run->exit_reason = KVM_EXIT_MMIO;
 		r = RESUME_HOST_NV;
 		break;
 	case EMULATE_EXIT_USER:
@@ -1136,11 +1136,11 @@ static int kvmppc_exit_pr_progint(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 
 int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int r = RESUME_HOST;
 	int s;
 
-	vcpu->stat.sum_exits++;
+	vcpu->common->stat.sum_exits++;
 
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	run->ready_for_interrupt_injection = 1;
@@ -1154,7 +1154,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	case BOOK3S_INTERRUPT_INST_STORAGE:
 	{
 		ulong shadow_srr1 = vcpu->arch.shadow_srr1;
-		vcpu->stat.pf_instruc++;
+		vcpu->common->stat.pf_instruc++;
 
 		if (kvmppc_is_split_real(vcpu))
 			kvmppc_fixup_split_real(vcpu);
@@ -1182,7 +1182,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 			int idx = srcu_read_lock(&vcpu->kvm->srcu);
 			r = kvmppc_handle_pagefault(vcpu, kvmppc_get_pc(vcpu), exit_nr);
 			srcu_read_unlock(&vcpu->kvm->srcu, idx);
-			vcpu->stat.sp_instruc++;
+			vcpu->common->stat.sp_instruc++;
 		} else if (vcpu->arch.mmu.is_dcbz32(vcpu) &&
 			  (!(vcpu->arch.hflags & BOOK3S_HFLAG_DCBZ32))) {
 			/*
@@ -1203,7 +1203,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	{
 		ulong dar = kvmppc_get_fault_dar(vcpu);
 		u32 fault_dsisr = vcpu->arch.fault_dsisr;
-		vcpu->stat.pf_storage++;
+		vcpu->common->stat.pf_storage++;
 
 #ifdef CONFIG_PPC_BOOK3S_32
 		/* We set segments as unused segments when invalidating them. So
@@ -1258,13 +1258,13 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
 	case BOOK3S_INTERRUPT_DOORBELL:
 	case BOOK3S_INTERRUPT_H_DOORBELL:
-		vcpu->stat.dec_exits++;
+		vcpu->common->stat.dec_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_EXTERNAL:
 	case BOOK3S_INTERRUPT_EXTERNAL_HV:
 	case BOOK3S_INTERRUPT_H_VIRT:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->common->stat.ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_HMI:
@@ -1333,7 +1333,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 			r = RESUME_GUEST;
 		} else {
 			/* Guest syscalls */
-			vcpu->stat.syscall_exits++;
+			vcpu->common->stat.syscall_exits++;
 			kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
 			r = RESUME_GUEST;
 		}
@@ -1407,7 +1407,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_TRACE:
-		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 			run->exit_reason = KVM_EXIT_DEBUG;
 			r = RESUME_HOST;
 		} else {
@@ -1813,7 +1813,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_vcpu *vcpu)
 
 	/* Check if we can run the vcpu at all */
 	if (!vcpu->arch.sane) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1855,7 +1855,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_vcpu *vcpu)
 
 	srr_regs_clobbered();
 out:
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	vcpu->common->mode = OUTSIDE_GUEST_MODE;
 	return ret;
 }
 
diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index b2c89e850d7a..bde9c79c339b 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -393,7 +393,7 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 	case H_CEDE:
 		kvmppc_set_msr_fast(vcpu, kvmppc_get_msr(vcpu) | MSR_EE);
 		kvm_vcpu_halt(vcpu);
-		vcpu->stat.generic.halt_wakeup++;
+		vcpu->common->stat.generic.halt_wakeup++;
 		return EMULATE_DONE;
 	case H_LOGICAL_CI_LOAD:
 		return kvmppc_h_pr_logical_ci_load(vcpu);
diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index 589a8f257120..94bd793a760d 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -1353,17 +1353,17 @@ static void kvmppc_xics_release(struct kvm_device *dev)
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		/*
-		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
+		 * Take vcpu->common->mutex to ensure that no one_reg get/set ioctl
 		 * (i.e. kvmppc_xics_[gs]et_icp) can be done concurrently.
-		 * Holding the vcpu->mutex also means that execution is
+		 * Holding the vcpu->common->mutex also means that execution is
 		 * excluded for the vcpu until the ICP was freed. When the vcpu
 		 * can execute again, vcpu->arch.icp and vcpu->arch.irq_type
 		 * have been cleared and the vcpu will not be going into the
 		 * XICS code anymore.
 		 */
-		mutex_lock(&vcpu->mutex);
+		mutex_lock(&vcpu->common->mutex);
 		kvmppc_xics_free_icp(vcpu);
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 	}
 
 	if (kvm)
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 1362c672387e..ae7ec36e5fbd 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1510,7 +1510,7 @@ int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval)
 
 	/*
 	 * We can't update the state of a "pushed" VCPU, but that
-	 * shouldn't happen because the vcpu->mutex makes running a
+	 * shouldn't happen because the vcpu->common->mutex makes running a
 	 * vcpu mutually exclusive with doing one_reg get/set on it.
 	 */
 	if (WARN_ON(vcpu->arch.xive_pushed))
@@ -1770,7 +1770,7 @@ void kvmppc_xive_disable_vcpu_interrupts(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Clear pointers to escalation interrupt ESB.
-	 * This is safe because the vcpu->mutex is held, preventing
+	 * This is safe because the vcpu->common->mutex is held, preventing
 	 * any other CPU from concurrently executing a KVM_RUN ioctl.
 	 */
 	vcpu->arch.xive_esc_vaddr = 0;
@@ -2663,16 +2663,16 @@ static void kvmppc_xive_release(struct kvm_device *dev)
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		/*
-		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
+		 * Take vcpu->common->mutex to ensure that no one_reg get/set ioctl
 		 * (i.e. kvmppc_xive_[gs]et_icp) can be done concurrently.
-		 * Holding the vcpu->mutex also means that the vcpu cannot
+		 * Holding the vcpu->common->mutex also means that the vcpu cannot
 		 * be executing the KVM_RUN ioctl, and therefore it cannot
 		 * be executing the XIVE push or pull code or accessing
 		 * the XIVE MMIO regions.
 		 */
-		mutex_lock(&vcpu->mutex);
+		mutex_lock(&vcpu->common->mutex);
 		kvmppc_xive_cleanup_vcpu(vcpu);
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 	}
 
 	/*
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 6e2ebbd8aaac..8cf6489f0d76 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1045,16 +1045,16 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		/*
-		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
+		 * Take vcpu->common->mutex to ensure that no one_reg get/set ioctl
 		 * (i.e. kvmppc_xive_native_[gs]et_vp) can be being done.
-		 * Holding the vcpu->mutex also means that the vcpu cannot
+		 * Holding the vcpu->common->mutex also means that the vcpu cannot
 		 * be executing the KVM_RUN ioctl, and therefore it cannot
 		 * be executing the XIVE push or pull code or accessing
 		 * the XIVE MMIO regions.
 		 */
-		mutex_lock(&vcpu->mutex);
+		mutex_lock(&vcpu->common->mutex);
 		kvmppc_xive_native_cleanup_vcpu(vcpu);
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 	}
 
 	/*
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 6a5be025a8af..10e4fbf8b8cd 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -234,7 +234,7 @@ static void kvmppc_vcpu_sync_debug(struct kvm_vcpu *vcpu)
 #endif
 
 	/* Force enable debug interrupts when user space wants to debug */
-	if (vcpu->guest_debug) {
+	if (vcpu->common->guest_debug) {
 #ifdef CONFIG_KVM_BOOKE_HV
 		/*
 		 * Since there is no shadow MSR, sync MSR_DE into the guest
@@ -743,14 +743,14 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
 #endif
 
 	if (kvm_check_request(KVM_REQ_WATCHDOG, vcpu)) {
-		vcpu->run->exit_reason = KVM_EXIT_WATCHDOG;
+		vcpu->common->run->exit_reason = KVM_EXIT_WATCHDOG;
 		r = 0;
 	}
 
 	if (kvm_check_request(KVM_REQ_EPR_EXIT, vcpu)) {
-		vcpu->run->epr.epr = 0;
+		vcpu->common->run->epr.epr = 0;
 		vcpu->arch.epr_needed = true;
-		vcpu->run->exit_reason = KVM_EXIT_EPR;
+		vcpu->common->run->exit_reason = KVM_EXIT_EPR;
 		r = 0;
 	}
 
@@ -763,7 +763,7 @@ int kvmppc_vcpu_run(struct kvm_vcpu *vcpu)
 	struct debug_reg debug;
 
 	if (!vcpu->arch.sane) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		return -EINVAL;
 	}
 
@@ -823,7 +823,7 @@ int kvmppc_vcpu_run(struct kvm_vcpu *vcpu)
 #endif
 
 out:
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	vcpu->common->mode = OUTSIDE_GUEST_MODE;
 	return ret;
 }
 
@@ -848,8 +848,8 @@ static int emulation_exit(struct kvm_vcpu *vcpu)
 		       __func__, vcpu->arch.regs.nip, vcpu->arch.last_inst);
 		/* For debugging, encode the failing instruction and
 		 * report it to userspace. */
-		vcpu->run->hw.hardware_exit_reason = ~0ULL << 32;
-		vcpu->run->hw.hardware_exit_reason |= vcpu->arch.last_inst;
+		vcpu->common->run->hw.hardware_exit_reason = ~0ULL << 32;
+		vcpu->common->run->hw.hardware_exit_reason |= vcpu->arch.last_inst;
 		kvmppc_core_queue_program(vcpu, ESR_PIL);
 		return RESUME_HOST;
 
@@ -863,11 +863,11 @@ static int emulation_exit(struct kvm_vcpu *vcpu)
 
 static int kvmppc_handle_debug(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct debug_reg *dbg_reg = &(vcpu->arch.dbg_reg);
 	u32 dbsr = vcpu->arch.dbsr;
 
-	if (vcpu->guest_debug == 0) {
+	if (vcpu->common->guest_debug == 0) {
 		/*
 		 * Debug resources belong to Guest.
 		 * Imprecise debug event is not injected
@@ -993,8 +993,8 @@ static int kvmppc_resume_inst_load(struct kvm_vcpu *vcpu,
 		       __func__, vcpu->arch.regs.nip);
 		/* For debugging, encode the failing instruction and
 		 * report it to userspace. */
-		vcpu->run->hw.hardware_exit_reason = ~0ULL << 32;
-		vcpu->run->hw.hardware_exit_reason |= last_inst;
+		vcpu->common->run->hw.hardware_exit_reason = ~0ULL << 32;
+		vcpu->common->run->hw.hardware_exit_reason |= last_inst;
 		kvmppc_core_queue_program(vcpu, ESR_PIL);
 		return RESUME_HOST;
 
@@ -1010,7 +1010,7 @@ static int kvmppc_resume_inst_load(struct kvm_vcpu *vcpu,
  */
 int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int r = RESUME_HOST;
 	int s;
 	int idx;
@@ -1040,7 +1040,7 @@ int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 		break;
 	case BOOKE_INTERRUPT_PROGRAM:
 		/* SW breakpoints arrive as illegal instructions on HV */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
 			emulated = kvmppc_get_last_inst(vcpu, INST_GENERIC, &pinst);
 			last_inst = ppc_inst_val(pinst);
 		}
@@ -1136,7 +1136,7 @@ int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 		break;
 
 	case BOOKE_INTERRUPT_PROGRAM:
-		if ((vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) &&
+		if ((vcpu->common->guest_debug & KVM_GUESTDBG_USE_SW_BP) &&
 			(last_inst == KVMPPC_INST_SW_BREAKPOINT)) {
 			/*
 			 * We are here because of an SW breakpoint instr,
@@ -2039,16 +2039,16 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
 		vcpu->arch.dbg_reg.dbcr0 = 0;
-		vcpu->guest_debug = 0;
+		vcpu->common->guest_debug = 0;
 		kvm_guest_protect_msr(vcpu, MSR_DE, false);
 		goto out;
 	}
 
 	kvm_guest_protect_msr(vcpu, MSR_DE, true);
-	vcpu->guest_debug = dbg->control;
+	vcpu->common->guest_debug = dbg->control;
 	vcpu->arch.dbg_reg.dbcr0 = 0;
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vcpu->arch.dbg_reg.dbcr0 |= DBCR0_IDM | DBCR0_IC;
 
 	/* Code below handles only HW breakpoints */
@@ -2072,7 +2072,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	dbg_reg->dbcr2 = DBCR2_DAC1US | DBCR2_DAC2US;
 #endif
 
-	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
+	if (!(vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 		goto out;
 
 	ret = -EINVAL;
diff --git a/arch/powerpc/kvm/booke_emulate.c b/arch/powerpc/kvm/booke_emulate.c
index d8d38aca71bd..77d0f0f40db8 100644
--- a/arch/powerpc/kvm/booke_emulate.c
+++ b/arch/powerpc/kvm/booke_emulate.c
@@ -146,7 +146,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -157,7 +157,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -169,7 +169,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -180,7 +180,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -192,7 +192,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -203,7 +203,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -214,7 +214,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -229,7 +229,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -240,7 +240,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		debug_inst = true;
@@ -251,7 +251,7 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 		 * If userspace is debugging guest then guest
 		 * can not access debug registers.
 		 */
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			break;
 
 		vcpu->arch.dbsr &= ~spr_val;
@@ -427,7 +427,7 @@ int kvmppc_booke_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, ulong *spr_val)
 		break;
 	case SPRN_DBCR0:
 		*spr_val = vcpu->arch.dbg_reg.dbcr0;
-		if (vcpu->guest_debug)
+		if (vcpu->common->guest_debug)
 			*spr_val = *spr_val | DBCR0_EDM;
 		break;
 	case SPRN_DBCR1:
diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index 051102d50c31..ded7c572157e 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -90,9 +90,9 @@ static int kvmppc_e500_emul_ehpriv(struct kvm_vcpu *vcpu,
 
 	switch (get_oc(inst)) {
 	case EHPRIV_OC_DEBUG:
-		vcpu->run->exit_reason = KVM_EXIT_DEBUG;
-		vcpu->run->debug.arch.address = vcpu->arch.regs.nip;
-		vcpu->run->debug.arch.status = 0;
+		vcpu->common->run->exit_reason = KVM_EXIT_DEBUG;
+		vcpu->common->run->debug.arch.address = vcpu->arch.regs.nip;
+		vcpu->common->run->debug.arch.status = 0;
 		kvmppc_account_exit(vcpu, DEBUG_EXITS);
 		emulated = EMULATE_EXIT_USER;
 		*advance = 0;
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 355d5206e8aa..e66c5a637a4b 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -272,9 +272,9 @@ int kvmppc_emulate_instruction(struct kvm_vcpu *vcpu)
 		 * these are illegal instructions.
 		 */
 		if (inst == KVMPPC_INST_SW_BREAKPOINT) {
-			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
-			vcpu->run->debug.arch.status = 0;
-			vcpu->run->debug.arch.address = kvmppc_get_pc(vcpu);
+			vcpu->common->run->exit_reason = KVM_EXIT_DEBUG;
+			vcpu->common->run->debug.arch.status = 0;
+			vcpu->common->run->debug.arch.address = kvmppc_get_pc(vcpu);
 			emulated = EMULATE_EXIT_USER;
 			advance = 0;
 		} else
diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index ec60c7979718..9869f2f65cee 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -97,7 +97,7 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 		int type = op.type & INSTR_TYPE_MASK;
 		int size = GETSIZE(op.type);
 
-		vcpu->mmio_is_write = OP_IS_STORE(type);
+		vcpu->common->mmio_is_write = OP_IS_STORE(type);
 
 		switch (type) {
 		case LOAD:  {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 5e6c7b527677..b7346994f526 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -93,15 +93,15 @@ int kvmppc_prepare_to_enter(struct kvm_vcpu *vcpu)
 
 		if (signal_pending(current)) {
 			kvmppc_account_exit(vcpu, SIGNAL_EXITS);
-			vcpu->run->exit_reason = KVM_EXIT_INTR;
+			vcpu->common->run->exit_reason = KVM_EXIT_INTR;
 			r = -EINTR;
 			break;
 		}
 
-		vcpu->mode = IN_GUEST_MODE;
+		vcpu->common->mode = IN_GUEST_MODE;
 
 		/*
-		 * Reading vcpu->requests must happen after setting vcpu->mode,
+		 * Reading vcpu->requests must happen after setting vcpu->common->mode,
 		 * so we don't miss a request because the requester sees
 		 * OUTSIDE_GUEST_MODE and assumes we'll be checking requests
 		 * before next entering the guest (and thus doesn't IPI).
@@ -295,7 +295,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 		r = RESUME_GUEST;
 		break;
 	case EMULATE_DO_MMIO:
-		vcpu->run->exit_reason = KVM_EXIT_MMIO;
+		vcpu->common->run->exit_reason = KVM_EXIT_MMIO;
 		/* We must reload nonvolatiles because "update" load/store
 		 * instructions modify register state. */
 		/* Future optimization: only reload non-volatiles if they were
@@ -318,7 +318,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 		if (!IS_ENABLED(CONFIG_BOOKE)) {
 			ulong dsisr = DSISR_BADACCESS;
 
-			if (vcpu->mmio_is_write)
+			if (vcpu->common->mmio_is_write)
 				dsisr |= DSISR_ISSTORE;
 
 			kvmppc_core_queue_data_storage(vcpu,
@@ -352,7 +352,7 @@ int kvmppc_st(struct kvm_vcpu *vcpu, ulong *eaddr, int size, void *ptr,
 	struct kvmppc_pte pte;
 	int r = -EINVAL;
 
-	vcpu->stat.st++;
+	vcpu->common->stat.st++;
 
 	if (vcpu->kvm->arch.kvm_ops && vcpu->kvm->arch.kvm_ops->store_to_eaddr)
 		r = vcpu->kvm->arch.kvm_ops->store_to_eaddr(vcpu, eaddr, ptr,
@@ -395,7 +395,7 @@ int kvmppc_ld(struct kvm_vcpu *vcpu, ulong *eaddr, int size, void *ptr,
 	struct kvmppc_pte pte;
 	int rc = -EINVAL;
 
-	vcpu->stat.ld++;
+	vcpu->common->stat.ld++;
 
 	if (vcpu->kvm->arch.kvm_ops && vcpu->kvm->arch.kvm_ops->load_from_eaddr)
 		rc = vcpu->kvm->arch.kvm_ops->load_from_eaddr(vcpu, eaddr, ptr,
@@ -1138,7 +1138,7 @@ static inline u32 dp_to_sp(u64 fprd)
 
 static void kvmppc_complete_mmio_load(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	u64 gpr;
 
 	if (run->mmio.len > sizeof(gpr))
@@ -1250,7 +1250,7 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vcpu,
 				unsigned int rt, unsigned int bytes,
 				int is_default_endian, int sign_extend)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int idx, ret;
 	bool host_swabbed;
 
@@ -1270,8 +1270,8 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.io_gpr = rt;
 	vcpu->arch.mmio_host_swabbed = host_swabbed;
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_is_write = 0;
+	vcpu->common->mmio_needed = 1;
+	vcpu->common->mmio_is_write = 0;
 	vcpu->arch.mmio_sign_extend = sign_extend;
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
@@ -1283,7 +1283,7 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vcpu,
 
 	if (!ret) {
 		kvmppc_complete_mmio_load(vcpu);
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 		return EMULATE_DONE;
 	}
 
@@ -1324,7 +1324,7 @@ int kvmppc_handle_vsx_load(struct kvm_vcpu *vcpu,
 		if (emulated != EMULATE_DONE)
 			break;
 
-		vcpu->arch.paddr_accessed += vcpu->run->mmio.len;
+		vcpu->arch.paddr_accessed += vcpu->common->run->mmio.len;
 
 		vcpu->arch.mmio_vsx_copy_nums--;
 		vcpu->arch.mmio_vsx_offset++;
@@ -1336,7 +1336,7 @@ int kvmppc_handle_vsx_load(struct kvm_vcpu *vcpu,
 int kvmppc_handle_store(struct kvm_vcpu *vcpu,
 			u64 val, unsigned int bytes, int is_default_endian)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	void *data = run->mmio.data;
 	int idx, ret;
 	bool host_swabbed;
@@ -1354,8 +1354,8 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
 	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
 	run->mmio.len = bytes;
 	run->mmio.is_write = 1;
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_is_write = 1;
+	vcpu->common->mmio_needed = 1;
+	vcpu->common->mmio_is_write = 1;
 
 	if ((vcpu->arch.mmio_sp64_extend) && (bytes == 4))
 		val = dp_to_sp(val);
@@ -1385,7 +1385,7 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	if (!ret) {
-		vcpu->mmio_needed = 0;
+		vcpu->common->mmio_needed = 0;
 		return EMULATE_DONE;
 	}
 
@@ -1470,7 +1470,7 @@ int kvmppc_handle_vsx_store(struct kvm_vcpu *vcpu,
 		if (emulated != EMULATE_DONE)
 			break;
 
-		vcpu->arch.paddr_accessed += vcpu->run->mmio.len;
+		vcpu->arch.paddr_accessed += vcpu->common->run->mmio.len;
 
 		vcpu->arch.mmio_vsx_copy_nums--;
 		vcpu->arch.mmio_vsx_offset++;
@@ -1481,13 +1481,13 @@ int kvmppc_handle_vsx_store(struct kvm_vcpu *vcpu,
 
 static int kvmppc_emulate_mmio_vsx_loadstore(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	enum emulation_result emulated = EMULATE_FAIL;
 	int r;
 
 	vcpu->arch.paddr_accessed += run->mmio.len;
 
-	if (!vcpu->mmio_is_write) {
+	if (!vcpu->common->mmio_is_write) {
 		emulated = kvmppc_handle_vsx_load(vcpu, vcpu->arch.io_gpr,
 			 run->mmio.len, 1, vcpu->arch.mmio_sign_extend);
 	} else {
@@ -1530,7 +1530,7 @@ int kvmppc_handle_vmx_load(struct kvm_vcpu *vcpu,
 		if (emulated != EMULATE_DONE)
 			break;
 
-		vcpu->arch.paddr_accessed += vcpu->run->mmio.len;
+		vcpu->arch.paddr_accessed += vcpu->common->run->mmio.len;
 		vcpu->arch.mmio_vmx_copy_nums--;
 		vcpu->arch.mmio_vmx_offset++;
 	}
@@ -1650,7 +1650,7 @@ int kvmppc_handle_vmx_store(struct kvm_vcpu *vcpu,
 		if (emulated != EMULATE_DONE)
 			break;
 
-		vcpu->arch.paddr_accessed += vcpu->run->mmio.len;
+		vcpu->arch.paddr_accessed += vcpu->common->run->mmio.len;
 		vcpu->arch.mmio_vmx_copy_nums--;
 		vcpu->arch.mmio_vmx_offset++;
 	}
@@ -1660,13 +1660,13 @@ int kvmppc_handle_vmx_store(struct kvm_vcpu *vcpu,
 
 static int kvmppc_emulate_mmio_vmx_loadstore(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	enum emulation_result emulated = EMULATE_FAIL;
 	int r;
 
 	vcpu->arch.paddr_accessed += run->mmio.len;
 
-	if (!vcpu->mmio_is_write) {
+	if (!vcpu->common->mmio_is_write) {
 		emulated = kvmppc_handle_vmx_load(vcpu,
 				vcpu->arch.io_gpr, run->mmio.len, 1);
 	} else {
@@ -1792,14 +1792,14 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int r;
 
 	vcpu_load(vcpu);
 
-	if (vcpu->mmio_needed) {
-		vcpu->mmio_needed = 0;
-		if (!vcpu->mmio_is_write)
+	if (vcpu->common->mmio_needed) {
+		vcpu->common->mmio_needed = 0;
+		if (!vcpu->common->mmio_is_write)
 			kvmppc_complete_mmio_load(vcpu);
 #ifdef CONFIG_VSX
 		if (vcpu->arch.mmio_vsx_copy_nums > 0) {
@@ -1810,7 +1810,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.mmio_vsx_copy_nums > 0) {
 			r = kvmppc_emulate_mmio_vsx_loadstore(vcpu);
 			if (r == RESUME_HOST) {
-				vcpu->mmio_needed = 1;
+				vcpu->common->mmio_needed = 1;
 				goto out;
 			}
 		}
@@ -1824,7 +1824,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.mmio_vmx_copy_nums > 0) {
 			r = kvmppc_emulate_mmio_vmx_loadstore(vcpu);
 			if (r == RESUME_HOST) {
-				vcpu->mmio_needed = 1;
+				vcpu->common->mmio_needed = 1;
 				goto out;
 			}
 		}
@@ -1852,7 +1852,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_activate(vcpu);
 
-	if (!vcpu->wants_to_run)
+	if (!vcpu->common->wants_to_run)
 		r = -EINTR;
 	else
 		r = kvmppc_vcpu_run(vcpu);
diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index 45817ab82bb4..78b8872e5995 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -45,46 +45,46 @@ static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
 	*/
 	switch (type) {
 	case EXT_INTR_EXITS:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->common->stat.ext_intr_exits++;
 		break;
 	case DEC_EXITS:
-		vcpu->stat.dec_exits++;
+		vcpu->common->stat.dec_exits++;
 		break;
 	case EMULATED_INST_EXITS:
-		vcpu->stat.emulated_inst_exits++;
+		vcpu->common->stat.emulated_inst_exits++;
 		break;
 	case DSI_EXITS:
-		vcpu->stat.dsi_exits++;
+		vcpu->common->stat.dsi_exits++;
 		break;
 	case ISI_EXITS:
-		vcpu->stat.isi_exits++;
+		vcpu->common->stat.isi_exits++;
 		break;
 	case SYSCALL_EXITS:
-		vcpu->stat.syscall_exits++;
+		vcpu->common->stat.syscall_exits++;
 		break;
 	case DTLB_REAL_MISS_EXITS:
-		vcpu->stat.dtlb_real_miss_exits++;
+		vcpu->common->stat.dtlb_real_miss_exits++;
 		break;
 	case DTLB_VIRT_MISS_EXITS:
-		vcpu->stat.dtlb_virt_miss_exits++;
+		vcpu->common->stat.dtlb_virt_miss_exits++;
 		break;
 	case MMIO_EXITS:
-		vcpu->stat.mmio_exits++;
+		vcpu->common->stat.mmio_exits++;
 		break;
 	case ITLB_REAL_MISS_EXITS:
-		vcpu->stat.itlb_real_miss_exits++;
+		vcpu->common->stat.itlb_real_miss_exits++;
 		break;
 	case ITLB_VIRT_MISS_EXITS:
-		vcpu->stat.itlb_virt_miss_exits++;
+		vcpu->common->stat.itlb_virt_miss_exits++;
 		break;
 	case SIGNAL_EXITS:
-		vcpu->stat.signal_exits++;
+		vcpu->common->stat.signal_exits++;
 		break;
 	case DBELL_EXITS:
-		vcpu->stat.dbell_exits++;
+		vcpu->common->stat.dbell_exits++;
 		break;
 	case GDBELL_EXITS:
-		vcpu->stat.gdbell_exits++;
+		vcpu->common->stat.gdbell_exits++;
 		break;
 	}
 }
diff --git a/arch/powerpc/kvm/trace.h b/arch/powerpc/kvm/trace.h
index ea1d7c808319..35c000d918bb 100644
--- a/arch/powerpc/kvm/trace.h
+++ b/arch/powerpc/kvm/trace.h
@@ -108,7 +108,7 @@ TRACE_EVENT(kvm_check_requests,
 
 	TP_fast_assign(
 		__entry->cpu_nr		= vcpu->vcpu_id;
-		__entry->requests	= vcpu->requests;
+		__entry->requests	= vcpu->common->requests;
 	),
 
 	TP_printk("vcpu=%x requests=%x",
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 77ebc724e6cd..6395698cfe05 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -504,7 +504,7 @@ TRACE_EVENT(kvmppc_run_vcpu_exit,
 
 	TP_fast_assign(
 		__entry->vcpu_id  = vcpu->vcpu_id;
-		__entry->exit     = vcpu->run->exit_reason;
+		__entry->exit     = vcpu->common->run->exit_reason;
 		__entry->ret      = vcpu->arch.ret;
 	),
 
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 39cd26af5a69..17cf59ccfae3 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -18,7 +18,7 @@ static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
 
 	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
 		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
-		mutex_unlock(&tmp_vcpu->mutex);
+		mutex_unlock(&tmp_vcpu->common->mutex);
 	}
 }
 
@@ -33,7 +33,7 @@ static bool lock_all_vcpus(struct kvm *kvm)
 	unsigned long c;
 
 	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
-		if (!mutex_trylock(&tmp_vcpu->mutex)) {
+		if (!mutex_trylock(&tmp_vcpu->common->mutex)) {
 			unlock_vcpus(kvm, c - 1);
 			return false;
 		}
@@ -207,12 +207,12 @@ static int aia_imsic_addr(struct kvm *kvm, u64 *addr,
 			return -EINVAL;
 	}
 
-	mutex_lock(&vcpu->mutex);
+	mutex_lock(&vcpu->common->mutex);
 	if (write)
 		vcpu_aia->imsic_addr = *addr;
 	else
 		*addr = vcpu_aia->imsic_addr;
-	mutex_unlock(&vcpu->mutex);
+	mutex_unlock(&vcpu->common->mutex);
 
 	return 0;
 }
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 0a1e859323b4..cceae3dc9102 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -734,7 +734,7 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 	struct imsic_mrif tmrif;
 	void __iomem *new_vsfile_va;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_vcpu_aia *vaia = &vcpu->arch.aia_context;
 	struct imsic *imsic = vaia->imsic_state;
 	int ret = 0, new_vsfile_hgei = -1, old_vsfile_hgei, old_vsfile_cpu;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8d7d381737ee..c2c8bc303394 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -517,10 +517,10 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
 	if (dbg->control & KVM_GUESTDBG_ENABLE) {
-		vcpu->guest_debug = dbg->control;
+		vcpu->common->guest_debug = dbg->control;
 		vcpu->arch.cfg.hedeleg &= ~BIT(EXC_BREAKPOINT);
 	} else {
-		vcpu->guest_debug = 0;
+		vcpu->common->guest_debug = 0;
 		vcpu->arch.cfg.hedeleg |= BIT(EXC_BREAKPOINT);
 	}
 
@@ -555,7 +555,7 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 	}
 
 	cfg->hedeleg = KVM_HEDELEG_DEFAULT;
-	if (vcpu->guest_debug)
+	if (vcpu->common->guest_debug)
 		cfg->hedeleg &= ~BIT(EXC_BREAKPOINT);
 }
 
@@ -732,7 +732,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	int ret;
 	struct kvm_cpu_trap trap;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (!vcpu->arch.ran_atleast_once)
 		kvm_riscv_vcpu_setup_config(vcpu);
@@ -745,15 +745,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	switch (run->exit_reason) {
 	case KVM_EXIT_MMIO:
 		/* Process MMIO value returned from user-space */
-		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
+		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->common->run);
 		break;
 	case KVM_EXIT_RISCV_SBI:
 		/* Process SBI value returned from user-space */
-		ret = kvm_riscv_vcpu_sbi_return(vcpu, vcpu->run);
+		ret = kvm_riscv_vcpu_sbi_return(vcpu, vcpu->common->run);
 		break;
 	case KVM_EXIT_RISCV_CSR:
 		/* Process CSR value returned from user-space */
-		ret = kvm_riscv_vcpu_csr_return(vcpu, vcpu->run);
+		ret = kvm_riscv_vcpu_csr_return(vcpu, vcpu->common->run);
 		break;
 	default:
 		ret = 0;
@@ -764,7 +764,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		return ret;
 	}
 
-	if (!vcpu->wants_to_run) {
+	if (!vcpu->common->wants_to_run) {
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		return -EINTR;
 	}
@@ -803,7 +803,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
 		 */
-		vcpu->mode = IN_GUEST_MODE;
+		vcpu->common->mode = IN_GUEST_MODE;
 
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		smp_mb__after_srcu_read_unlock();
@@ -820,7 +820,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu) ||
 		    xfer_to_guest_mode_work_pending()) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
+			vcpu->common->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
 			preempt_enable();
 			kvm_vcpu_srcu_read_lock(vcpu);
@@ -841,8 +841,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_riscv_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
-		vcpu->stat.exits++;
+		vcpu->common->mode = OUTSIDE_GUEST_MODE;
+		vcpu->common->stat.exits++;
 
 		/*
 		 * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 97dec18e6989..c5e4f869cc33 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -201,7 +201,7 @@ void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
 
 static int wfi_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 {
-	vcpu->stat.wfi_exit_stat++;
+	vcpu->common->stat.wfi_exit_stat++;
 	kvm_riscv_vcpu_wfi(vcpu);
 	return KVM_INSN_CONTINUE_NEXT_SEPC;
 }
@@ -335,7 +335,7 @@ static int csr_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 		if (rc > KVM_INSN_EXIT_TO_USER_SPACE) {
 			if (rc == KVM_INSN_CONTINUE_NEXT_SEPC) {
 				run->riscv_csr.ret_value = val;
-				vcpu->stat.csr_exit_kernel++;
+				vcpu->common->stat.csr_exit_kernel++;
 				kvm_riscv_vcpu_csr_return(vcpu, run);
 				rc = KVM_INSN_CONTINUE_SAME_SEPC;
 			}
@@ -345,7 +345,7 @@ static int csr_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 
 	/* Exit to user-space for CSR emulation */
 	if (rc <= KVM_INSN_EXIT_TO_USER_SPACE) {
-		vcpu->stat.csr_exit_user++;
+		vcpu->common->stat.csr_exit_user++;
 		run->exit_reason = KVM_EXIT_RISCV_CSR;
 	}
 
@@ -576,13 +576,13 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (!kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_addr, len, data_buf)) {
 		/* Successfully handled MMIO access in the kernel so resume */
 		memcpy(run->mmio.data, data_buf, len);
-		vcpu->stat.mmio_exit_kernel++;
+		vcpu->common->stat.mmio_exit_kernel++;
 		kvm_riscv_vcpu_mmio_return(vcpu, run);
 		return 1;
 	}
 
 	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
+	vcpu->common->stat.mmio_exit_user++;
 	run->exit_reason = KVM_EXIT_MMIO;
 
 	return 0;
@@ -709,13 +709,13 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (!kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
 			      fault_addr, len, run->mmio.data)) {
 		/* Successfully handled MMIO access in the kernel so resume */
-		vcpu->stat.mmio_exit_kernel++;
+		vcpu->common->stat.mmio_exit_kernel++;
 		kvm_riscv_vcpu_mmio_return(vcpu, run);
 		return 1;
 	}
 
 	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
+	vcpu->common->stat.mmio_exit_user++;
 	run->exit_reason = KVM_EXIT_MMIO;
 
 	return 0;
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 62f409d4176e..3e450efc8a87 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -117,7 +117,7 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 
 	vcpu->arch.sbi_context.return_handled = 0;
-	vcpu->stat.ecall_exit_stat++;
+	vcpu->common->stat.ecall_exit_stat++;
 	run->exit_reason = KVM_EXIT_RISCV_SBI;
 	run->riscv_sbi.extension_id = cp->a7;
 	run->riscv_sbi.function_id = cp->a6;
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index dce667f4b6ab..a759f1b80b8a 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -81,7 +81,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 		return SBI_ERR_INVALID_PARAM;
 	if (!kvm_riscv_vcpu_stopped(target_vcpu))
 		return SBI_HSM_STATE_STARTED;
-	else if (vcpu->stat.generic.blocking)
+	else if (vcpu->common->stat.generic.blocking)
 		return SBI_HSM_STATE_SUSPENDED;
 	else
 		return SBI_HSM_STATE_STOPPED;
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8e77afbed58e..337bb899c7ac 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -708,13 +708,13 @@ struct kvm_hw_bp_info_arch {
 #define KVM_GUESTDBG_EXIT_PENDING 0x10000000
 
 #define guestdbg_enabled(vcpu) \
-		(vcpu->guest_debug & KVM_GUESTDBG_ENABLE)
+		(vcpu->common->guest_debug & KVM_GUESTDBG_ENABLE)
 #define guestdbg_sstep_enabled(vcpu) \
-		(vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		(vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 #define guestdbg_hw_bp_enabled(vcpu) \
-		(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		(vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP)
 #define guestdbg_exit_pending(vcpu) (guestdbg_enabled(vcpu) && \
-		(vcpu->guest_debug & KVM_GUESTDBG_EXIT_PENDING))
+		(vcpu->common->guest_debug & KVM_GUESTDBG_EXIT_PENDING))
 
 #define KVM_GUESTDBG_VALID_MASK \
 		(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP |\
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 2a32438e09ce..7535e159961a 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -22,9 +22,9 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
 	unsigned long start, end;
 	unsigned long prefix  = kvm_s390_get_prefix(vcpu);
 
-	start = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
-	end = vcpu->run->s.regs.gprs[vcpu->arch.sie_block->ipa & 0xf] + PAGE_SIZE;
-	vcpu->stat.instruction_diagnose_10++;
+	start = vcpu->common->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
+	end = vcpu->common->run->s.regs.gprs[vcpu->arch.sie_block->ipa & 0xf] + PAGE_SIZE;
+	vcpu->common->stat.instruction_diagnose_10++;
 
 	if (start & ~PAGE_MASK || end & ~PAGE_MASK || start >= end
 	    || start < 2 * PAGE_SIZE)
@@ -73,11 +73,11 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 	u16 ry = (vcpu->arch.sie_block->ipa & 0x0f);
 
 	VCPU_EVENT(vcpu, 3, "diag page reference parameter block at 0x%llx",
-		   vcpu->run->s.regs.gprs[rx]);
-	vcpu->stat.instruction_diagnose_258++;
-	if (vcpu->run->s.regs.gprs[rx] & 7)
+		   vcpu->common->run->s.regs.gprs[rx]);
+	vcpu->common->stat.instruction_diagnose_258++;
+	if (vcpu->common->run->s.regs.gprs[rx] & 7)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
-	rc = read_guest(vcpu, vcpu->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
+	rc = read_guest(vcpu, vcpu->common->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 	if (parm.parm_version != 2 || parm.parm_len < 5 || parm.code != 0x258)
@@ -94,7 +94,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 			 * the token must not be changed.  We have to return
 			 * decimal 8 instead, as mandated in SC24-6084.
 			 */
-			vcpu->run->s.regs.gprs[ry] = 8;
+			vcpu->common->run->s.regs.gprs[ry] = 8;
 			return 0;
 		}
 
@@ -108,7 +108,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 		vcpu->arch.pfault_token = parm.token_addr;
 		vcpu->arch.pfault_select = parm.select_mask;
 		vcpu->arch.pfault_compare = parm.compare_mask;
-		vcpu->run->s.regs.gprs[ry] = 0;
+		vcpu->common->run->s.regs.gprs[ry] = 0;
 		rc = 0;
 		break;
 	case 1: /*
@@ -122,13 +122,13 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 		    parm.compare_mask || parm.zarch)
 			return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-		vcpu->run->s.regs.gprs[ry] = 0;
+		vcpu->common->run->s.regs.gprs[ry] = 0;
 		/*
 		 * If the pfault handling was not established or is already
 		 * canceled SC24-6084 requests to return decimal 4.
 		 */
 		if (vcpu->arch.pfault_token == KVM_S390_PFAULT_TOKEN_INVALID)
-			vcpu->run->s.regs.gprs[ry] = 4;
+			vcpu->common->run->s.regs.gprs[ry] = 4;
 		else
 			vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
 
@@ -145,7 +145,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
 {
 	VCPU_EVENT(vcpu, 5, "%s", "diag time slice end");
-	vcpu->stat.instruction_diagnose_44++;
+	vcpu->common->stat.instruction_diagnose_44++;
 	kvm_vcpu_on_spin(vcpu, true);
 	return 0;
 }
@@ -169,8 +169,8 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	int tcpu_cpu;
 	int tid;
 
-	tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
-	vcpu->stat.instruction_diagnose_9c++;
+	tid = vcpu->common->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
+	vcpu->common->stat.instruction_diagnose_9c++;
 
 	/* yield to self */
 	if (tid == vcpu->vcpu_id)
@@ -194,7 +194,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 		VCPU_EVENT(vcpu, 5,
 			   "diag time slice end directed to %d: yield forwarded",
 			   tid);
-		vcpu->stat.diag_9c_forward++;
+		vcpu->common->stat.diag_9c_forward++;
 		return 0;
 	}
 
@@ -205,23 +205,23 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	return 0;
 no_yield:
 	VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d: ignored", tid);
-	vcpu->stat.diag_9c_ignored++;
+	vcpu->common->stat.diag_9c_ignored++;
 	return 0;
 }
 
 static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
 {
 	unsigned int reg = vcpu->arch.sie_block->ipa & 0xf;
-	unsigned long subcode = vcpu->run->s.regs.gprs[reg] & 0xffff;
+	unsigned long subcode = vcpu->common->run->s.regs.gprs[reg] & 0xffff;
 
 	VCPU_EVENT(vcpu, 3, "diag ipl functions, subcode %lx", subcode);
-	vcpu->stat.instruction_diagnose_308++;
+	vcpu->common->stat.instruction_diagnose_308++;
 	switch (subcode) {
 	case 3:
-		vcpu->run->s390_reset_flags = KVM_S390_RESET_CLEAR;
+		vcpu->common->run->s390_reset_flags = KVM_S390_RESET_CLEAR;
 		break;
 	case 4:
-		vcpu->run->s390_reset_flags = 0;
+		vcpu->common->run->s390_reset_flags = 0;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -233,13 +233,13 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
 		kvm_s390_vcpu_stop(vcpu);
-	vcpu->run->s390_reset_flags |= KVM_S390_RESET_SUBSYSTEM;
-	vcpu->run->s390_reset_flags |= KVM_S390_RESET_IPL;
-	vcpu->run->s390_reset_flags |= KVM_S390_RESET_CPU_INIT;
-	vcpu->run->exit_reason = KVM_EXIT_S390_RESET;
+	vcpu->common->run->s390_reset_flags |= KVM_S390_RESET_SUBSYSTEM;
+	vcpu->common->run->s390_reset_flags |= KVM_S390_RESET_IPL;
+	vcpu->common->run->s390_reset_flags |= KVM_S390_RESET_CPU_INIT;
+	vcpu->common->run->exit_reason = KVM_EXIT_S390_RESET;
 	VCPU_EVENT(vcpu, 3, "requesting userspace resets %llx",
-	  vcpu->run->s390_reset_flags);
-	trace_kvm_s390_request_resets(vcpu->run->s390_reset_flags);
+	  vcpu->common->run->s390_reset_flags);
+	trace_kvm_s390_request_resets(vcpu->common->run->s390_reset_flags);
 	return -EREMOTE;
 }
 
@@ -247,16 +247,16 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	vcpu->stat.instruction_diagnose_500++;
+	vcpu->common->stat.instruction_diagnose_500++;
 	/* No virtio-ccw notification? Get out quickly. */
 	if (!vcpu->kvm->arch.css_support ||
-	    (vcpu->run->s.regs.gprs[1] != KVM_S390_VIRTIO_CCW_NOTIFY))
+	    (vcpu->common->run->s.regs.gprs[1] != KVM_S390_VIRTIO_CCW_NOTIFY))
 		return -EOPNOTSUPP;
 
 	VCPU_EVENT(vcpu, 4, "diag 0x500 schid 0x%8.8x queue 0x%x cookie 0x%llx",
-			    (u32) vcpu->run->s.regs.gprs[2],
-			    (u32) vcpu->run->s.regs.gprs[3],
-			    vcpu->run->s.regs.gprs[4]);
+			    (u32) vcpu->common->run->s.regs.gprs[2],
+			    (u32) vcpu->common->run->s.regs.gprs[3],
+			    vcpu->common->run->s.regs.gprs[4]);
 
 	/*
 	 * The layout is as follows:
@@ -265,16 +265,16 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 	 * - gpr 4 contains the index on the bus (optionally)
 	 */
 	ret = kvm_io_bus_write_cookie(vcpu, KVM_VIRTIO_CCW_NOTIFY_BUS,
-				      vcpu->run->s.regs.gprs[2] & 0xffffffff,
-				      8, &vcpu->run->s.regs.gprs[3],
-				      vcpu->run->s.regs.gprs[4]);
+				      vcpu->common->run->s.regs.gprs[2] & 0xffffffff,
+				      8, &vcpu->common->run->s.regs.gprs[3],
+				      vcpu->common->run->s.regs.gprs[4]);
 
 	/*
 	 * Return cookie in gpr 2, but don't overwrite the register if the
 	 * diagnose will be handled by userspace.
 	 */
 	if (ret != -EOPNOTSUPP)
-		vcpu->run->s.regs.gprs[2] = ret;
+		vcpu->common->run->s.regs.gprs[2] = ret;
 	/* kvm_io_bus_write_cookie returns -EOPNOTSUPP if it found no match. */
 	return ret < 0 ? ret : 0;
 }
@@ -301,7 +301,7 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 	case 0x500:
 		return __diag_virtio_hypercall(vcpu);
 	default:
-		vcpu->stat.instruction_diagnose_other++;
+		vcpu->common->stat.instruction_diagnose_other++;
 		return -EOPNOTSUPP;
 	}
 }
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index e65f597e3044..3431bc47371c 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -235,8 +235,8 @@ static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce, u8 ar,
 		return -EINVAL;
 
 	if (vcpu->arch.acrs_loaded)
-		save_access_regs(vcpu->run->s.regs.acrs);
-	alet.val = vcpu->run->s.regs.acrs[ar];
+		save_access_regs(vcpu->common->run->s.regs.acrs);
+	alet.val = vcpu->common->run->s.regs.acrs[ar];
 
 	if (ar == 0 || alet.val == 0) {
 		asce->val = vcpu->arch.sie_block->gcr[1];
diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
index 80879fc73c90..82c4a2dd066c 100644
--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -370,8 +370,8 @@ static struct kvm_hw_wp_info_arch *any_wp_changed(struct kvm_vcpu *vcpu)
 
 void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu)
 {
-	vcpu->run->exit_reason = KVM_EXIT_DEBUG;
-	vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
+	vcpu->common->run->exit_reason = KVM_EXIT_DEBUG;
+	vcpu->common->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
 }
 
 #define PER_CODE_MASK		(PER_EVENT_MASK >> 24)
@@ -388,7 +388,7 @@ void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu)
 static int debug_exit_required(struct kvm_vcpu *vcpu, u8 perc,
 			       unsigned long peraddr)
 {
-	struct kvm_debug_exit_arch *debug_exit = &vcpu->run->debug.arch;
+	struct kvm_debug_exit_arch *debug_exit = &vcpu->common->run->debug.arch;
 	struct kvm_hw_wp_info_arch *wp_info = NULL;
 	struct kvm_hw_bp_info_arch *bp_info = NULL;
 	unsigned long addr = vcpu->arch.sie_block->gpsw.addr;
@@ -482,8 +482,8 @@ static int per_fetched_addr(struct kvm_vcpu *vcpu, unsigned long *addr)
 			u32 disp = opcode[1] & 0x0fff;
 			u32 index = opcode[0] & 0x000f;
 
-			*addr = base ? vcpu->run->s.regs.gprs[base] : 0;
-			*addr += index ? vcpu->run->s.regs.gprs[index] : 0;
+			*addr = base ? vcpu->common->run->s.regs.gprs[base] : 0;
+			*addr += index ? vcpu->common->run->s.regs.gprs[index] : 0;
 			*addr += disp;
 		}
 		*addr = kvm_s390_logical_to_effective(vcpu, *addr);
@@ -516,7 +516,7 @@ int kvm_s390_handle_per_ifetch_icpt(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_prog_irq(vcpu, &pgm_info);
 
 	if (debug_exit_required(vcpu, pgm_info.per_code, pgm_info.per_address))
-		vcpu->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
+		vcpu->common->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
 
 	if (!guest_per_enabled(vcpu) ||
 	    !(vcpu->arch.sie_block->gcr[9] & PER_EVENT_IFETCH))
@@ -589,7 +589,7 @@ int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu)
 
 	if (debug_exit_required(vcpu, vcpu->arch.sie_block->perc,
 				vcpu->arch.sie_block->peraddr))
-		vcpu->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
+		vcpu->common->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
 
 	rc = filter_guest_per_event(vcpu);
 	if (rc)
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index b16352083ff9..8c8569b506b6 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -56,7 +56,7 @@ static int handle_stop(struct kvm_vcpu *vcpu)
 	int rc = 0;
 	uint8_t flags, stop_pending;
 
-	vcpu->stat.exit_stop_request++;
+	vcpu->common->stat.exit_stop_request++;
 
 	/* delay the stop if any non-stop irq is pending */
 	if (kvm_s390_vcpu_has_irq(vcpu, 1))
@@ -92,7 +92,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 {
 	int viwhy = vcpu->arch.sie_block->ipb >> 16;
 
-	vcpu->stat.exit_validity++;
+	vcpu->common->stat.exit_validity++;
 	trace_kvm_s390_intercept_validity(vcpu, viwhy);
 	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
 		  current->pid, vcpu->kvm);
@@ -105,7 +105,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 
 static int handle_instruction(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.exit_instruction++;
+	vcpu->common->stat.exit_instruction++;
 	trace_kvm_s390_intercept_instruction(vcpu,
 					     vcpu->arch.sie_block->ipa,
 					     vcpu->arch.sie_block->ipb);
@@ -248,7 +248,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 	psw_t psw;
 	int rc;
 
-	vcpu->stat.exit_program_interruption++;
+	vcpu->common->stat.exit_program_interruption++;
 
 	/*
 	 * Intercept 8 indicates a loop of specification exceptions
@@ -306,7 +306,7 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 	psw_t newpsw;
 	int rc;
 
-	vcpu->stat.exit_external_interrupt++;
+	vcpu->common->stat.exit_external_interrupt++;
 
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		newpsw = vcpu->arch.sie_block->gpsw;
@@ -363,7 +363,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
 	/* Ensure that the source is paged-in, no actual access -> no key checking */
-	rc = guest_translate_address_with_key(vcpu, vcpu->run->s.regs.gprs[reg2],
+	rc = guest_translate_address_with_key(vcpu, vcpu->common->run->s.regs.gprs[reg2],
 					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
@@ -372,7 +372,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 		return rc;
 
 	/* Ensure that the source is paged-in, no actual access -> no key checking */
-	rc = guest_translate_address_with_key(vcpu, vcpu->run->s.regs.gprs[reg1],
+	rc = guest_translate_address_with_key(vcpu, vcpu->common->run->s.regs.gprs[reg1],
 					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
@@ -387,7 +387,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 
 static int handle_partial_execution(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.exit_pei++;
+	vcpu->common->stat.exit_pei++;
 
 	if (vcpu->arch.sie_block->ipa == 0xb254)	/* MVPG */
 		return handle_mvpg_pei(vcpu);
@@ -412,10 +412,10 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
-	code = vcpu->run->s.regs.gprs[reg1];
-	addr = vcpu->run->s.regs.gprs[reg2];
+	code = vcpu->common->run->s.regs.gprs[reg1];
+	addr = vcpu->common->run->s.regs.gprs[reg2];
 
-	vcpu->stat.instruction_sthyi++;
+	vcpu->common->stat.instruction_sthyi++;
 	VCPU_EVENT(vcpu, 3, "STHYI: fc: %llu addr: 0x%016llx", code, addr);
 	trace_kvm_s390_handle_sthyi(vcpu, code, addr);
 
@@ -454,7 +454,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 	}
 
 	free_page((unsigned long)sctns);
-	vcpu->run->s.regs.gprs[reg2 + 1] = rc;
+	vcpu->common->run->s.regs.gprs[reg2 + 1] = rc;
 	kvm_s390_set_psw_cc(vcpu, cc);
 	return r;
 }
@@ -464,7 +464,7 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
 	psw_t oldpsw, newpsw;
 	int rc;
 
-	vcpu->stat.exit_operation_exception++;
+	vcpu->common->stat.exit_operation_exception++;
 	trace_kvm_s390_handle_operexc(vcpu, vcpu->arch.sie_block->ipa,
 				      vcpu->arch.sie_block->ipb);
 
@@ -608,10 +608,10 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 
 	switch (vcpu->arch.sie_block->icptcode) {
 	case ICPT_EXTREQ:
-		vcpu->stat.exit_external_request++;
+		vcpu->common->stat.exit_external_request++;
 		return 0;
 	case ICPT_IOREQ:
-		vcpu->stat.exit_io_request++;
+		vcpu->common->stat.exit_io_request++;
 		return 0;
 	case ICPT_INST:
 		rc = handle_instruction(vcpu);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 4f0e7f61edf7..9b545e4307f9 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -488,7 +488,7 @@ static int __must_check __deliver_cpu_timer(struct kvm_vcpu *vcpu)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	int rc = 0;
 
-	vcpu->stat.deliver_cputm++;
+	vcpu->common->stat.deliver_cputm++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CPU_TIMER,
 					 0, 0);
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -512,7 +512,7 @@ static int __must_check __deliver_ckc(struct kvm_vcpu *vcpu)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	int rc = 0;
 
-	vcpu->stat.deliver_ckc++;
+	vcpu->common->stat.deliver_ckc++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CLOCK_COMP,
 					 0, 0);
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -584,8 +584,8 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 
 	mci.val = mchk->mcic;
 	/* take care of lazy register loading */
-	kvm_s390_fpu_store(vcpu->run);
-	save_access_regs(vcpu->run->s.regs.acrs);
+	kvm_s390_fpu_store(vcpu->common->run);
+	save_access_regs(vcpu->common->run->s.regs.acrs);
 	if (MACHINE_HAS_GS && vcpu->arch.gs_enabled)
 		save_gs_cb(current->thread.gs_cb);
 
@@ -615,7 +615,7 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 	}
 
 	if (!rc && mci.vr && ext_sa_addr && test_kvm_facility(vcpu->kvm, 129)) {
-		if (write_guest_abs(vcpu, ext_sa_addr, vcpu->run->s.regs.vrs,
+		if (write_guest_abs(vcpu, ext_sa_addr, vcpu->common->run->s.regs.vrs,
 				    512))
 			mci.vr = 0;
 	} else {
@@ -624,7 +624,7 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 	if (!rc && mci.gs && ext_sa_addr && test_kvm_facility(vcpu->kvm, 133)
 	    && (lc == 11 || lc == 12)) {
 		if (write_guest_abs(vcpu, ext_sa_addr + 1024,
-				    &vcpu->run->s.regs.gscb, 32))
+				    &vcpu->common->run->s.regs.gscb, 32))
 			mci.gs = 0;
 	} else {
 		mci.gs = 0;
@@ -640,15 +640,15 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 
 	/* Register-save areas */
 	if (cpu_has_vx()) {
-		convert_vx_to_fp(fprs, (__vector128 *) vcpu->run->s.regs.vrs);
+		convert_vx_to_fp(fprs, (__vector128 *) vcpu->common->run->s.regs.vrs);
 		rc |= write_guest_lc(vcpu, __LC_FPREGS_SAVE_AREA, fprs, 128);
 	} else {
 		rc |= write_guest_lc(vcpu, __LC_FPREGS_SAVE_AREA,
-				     vcpu->run->s.regs.fprs, 128);
+				     vcpu->common->run->s.regs.fprs, 128);
 	}
 	rc |= write_guest_lc(vcpu, __LC_GPREGS_SAVE_AREA,
-			     vcpu->run->s.regs.gprs, 128);
-	rc |= put_guest_lc(vcpu, vcpu->run->s.regs.fpc,
+			     vcpu->common->run->s.regs.gprs, 128);
+	rc |= put_guest_lc(vcpu, vcpu->common->run->s.regs.fpc,
 			   (u32 __user *) __LC_FP_CREG_SAVE_AREA);
 	rc |= put_guest_lc(vcpu, vcpu->arch.sie_block->todpr,
 			   (u32 __user *) __LC_TOD_PROGREG_SAVE_AREA);
@@ -657,7 +657,7 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 	rc |= put_guest_lc(vcpu, vcpu->arch.sie_block->ckc >> 8,
 			   (u64 __user *) __LC_CLOCK_COMP_SAVE_AREA);
 	rc |= write_guest_lc(vcpu, __LC_AREGS_SAVE_AREA,
-			     &vcpu->run->s.regs.acrs, 64);
+			     &vcpu->common->run->s.regs.acrs, 64);
 	rc |= write_guest_lc(vcpu, __LC_CREGS_SAVE_AREA,
 			     &vcpu->arch.sie_block->gcr, 128);
 
@@ -716,7 +716,7 @@ static int __must_check __deliver_machine_check(struct kvm_vcpu *vcpu)
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 						 KVM_S390_MCHK,
 						 mchk.cr14, mchk.mcic);
-		vcpu->stat.deliver_machine_check++;
+		vcpu->common->stat.deliver_machine_check++;
 		rc = __write_machine_check(vcpu, &mchk);
 	}
 	return rc;
@@ -728,7 +728,7 @@ static int __must_check __deliver_restart(struct kvm_vcpu *vcpu)
 	int rc = 0;
 
 	VCPU_EVENT(vcpu, 3, "%s", "deliver: cpu restart");
-	vcpu->stat.deliver_restart_signal++;
+	vcpu->common->stat.deliver_restart_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_RESTART, 0, 0);
 
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -755,7 +755,7 @@ static int __must_check __deliver_set_prefix(struct kvm_vcpu *vcpu)
 	clear_bit(IRQ_PEND_SET_PREFIX, &li->pending_irqs);
 	spin_unlock(&li->lock);
 
-	vcpu->stat.deliver_prefix_signal++;
+	vcpu->common->stat.deliver_prefix_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_SIGP_SET_PREFIX,
 					 prefix.address, 0);
@@ -778,7 +778,7 @@ static int __must_check __deliver_emergency_signal(struct kvm_vcpu *vcpu)
 	spin_unlock(&li->lock);
 
 	VCPU_EVENT(vcpu, 4, "%s", "deliver: sigp emerg");
-	vcpu->stat.deliver_emergency_signal++;
+	vcpu->common->stat.deliver_emergency_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_EMERGENCY,
 					 cpu_addr, 0);
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -811,7 +811,7 @@ static int __must_check __deliver_external_call(struct kvm_vcpu *vcpu)
 	spin_unlock(&li->lock);
 
 	VCPU_EVENT(vcpu, 4, "%s", "deliver: sigp ext call");
-	vcpu->stat.deliver_external_call++;
+	vcpu->common->stat.deliver_external_call++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_INT_EXTERNAL_CALL,
 					 extcall.code, 0);
@@ -863,7 +863,7 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
 	ilen = pgm_info.flags & KVM_S390_PGM_FLAGS_ILC_MASK;
 	VCPU_EVENT(vcpu, 3, "deliver: program irq code 0x%x, ilen:%d",
 		   pgm_info.code, ilen);
-	vcpu->stat.deliver_program++;
+	vcpu->common->stat.deliver_program++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_PROGRAM_INT,
 					 pgm_info.code, 0);
 
@@ -1013,7 +1013,7 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
 
 	VCPU_EVENT(vcpu, 4, "deliver: sclp parameter 0x%x",
 		   ext.ext_params);
-	vcpu->stat.deliver_service_signal++;
+	vcpu->common->stat.deliver_service_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
 					 ext.ext_params, 0);
 
@@ -1037,7 +1037,7 @@ static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
 	spin_unlock(&fi->lock);
 
 	VCPU_EVENT(vcpu, 4, "%s", "deliver: sclp parameter event");
-	vcpu->stat.deliver_service_signal++;
+	vcpu->common->stat.deliver_service_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
 					 ext.ext_params, 0);
 
@@ -1100,7 +1100,7 @@ static int __must_check __deliver_virtio(struct kvm_vcpu *vcpu)
 		VCPU_EVENT(vcpu, 4,
 			   "deliver: virtio parm: 0x%x,parm64: 0x%llx",
 			   inti->ext.ext_params, inti->ext.ext_params2);
-		vcpu->stat.deliver_virtio++;
+		vcpu->common->stat.deliver_virtio++;
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 				inti->type,
 				inti->ext.ext_params,
@@ -1186,7 +1186,7 @@ static int __must_check __deliver_io(struct kvm_vcpu *vcpu,
 			inti->io.subchannel_id >> 1 & 0x3,
 			inti->io.subchannel_nr);
 
-		vcpu->stat.deliver_io++;
+		vcpu->common->stat.deliver_io++;
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 				inti->type,
 				((__u32)inti->io.subchannel_id << 16) |
@@ -1214,7 +1214,7 @@ static int __must_check __deliver_io(struct kvm_vcpu *vcpu,
 		VCPU_EVENT(vcpu, 4, "%s isc %u", "deliver: I/O (AI/gisa)", isc);
 		memset(&io, 0, sizeof(io));
 		io.io_int_word = isc_to_int_word(isc);
-		vcpu->stat.deliver_io++;
+		vcpu->common->stat.deliver_io++;
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 			KVM_S390_INT_IO(1, 0, 0, 0),
 			((__u32)io.subchannel_id << 16) |
@@ -1299,7 +1299,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 	struct kvm_s390_gisa_interrupt *gi = &vcpu->kvm->arch.gisa_int;
 	u64 sltime;
 
-	vcpu->stat.exit_wait_state++;
+	vcpu->common->stat.exit_wait_state++;
 
 	/* fast path */
 	if (kvm_arch_vcpu_runnable(vcpu))
@@ -1332,7 +1332,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 no_timer:
 	kvm_vcpu_srcu_read_unlock(vcpu);
 	kvm_vcpu_halt(vcpu);
-	vcpu->valid_wakeup = false;
+	vcpu->common->valid_wakeup = false;
 	__unset_cpu_idle(vcpu);
 	kvm_vcpu_srcu_read_lock(vcpu);
 
@@ -1342,7 +1342,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu)
 {
-	vcpu->valid_wakeup = true;
+	vcpu->common->valid_wakeup = true;
 	kvm_vcpu_wake_up(vcpu);
 
 	/*
@@ -1469,11 +1469,11 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 	 * singlestep event now.
 	 */
 	if (delivered && guestdbg_sstep_enabled(vcpu)) {
-		struct kvm_debug_exit_arch *debug_exit = &vcpu->run->debug.arch;
+		struct kvm_debug_exit_arch *debug_exit = &vcpu->common->run->debug.arch;
 
 		debug_exit->addr = vcpu->arch.sie_block->gpsw.addr;
 		debug_exit->type = KVM_SINGLESTEP;
-		vcpu->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
+		vcpu->common->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
 	}
 
 	set_intercept_indicators(vcpu);
@@ -1485,7 +1485,7 @@ static int __inject_prog(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_program++;
+	vcpu->common->stat.inject_program++;
 	VCPU_EVENT(vcpu, 3, "inject: program irq code 0x%x", irq->u.pgm.code);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_PROGRAM_INT,
 				   irq->u.pgm.code, 0);
@@ -1527,7 +1527,7 @@ static int __inject_pfault_init(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_pfault_init++;
+	vcpu->common->stat.inject_pfault_init++;
 	VCPU_EVENT(vcpu, 4, "inject: pfault init parameter block at 0x%llx",
 		   irq->u.ext.ext_params2);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_PFAULT_INIT,
@@ -1546,7 +1546,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_extcall_info *extcall = &li->irq.extcall;
 	uint16_t src_id = irq->u.extcall.code;
 
-	vcpu->stat.inject_external_call++;
+	vcpu->common->stat.inject_external_call++;
 	VCPU_EVENT(vcpu, 4, "inject: external call source-cpu:%u",
 		   src_id);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_EXTERNAL_CALL,
@@ -1571,7 +1571,7 @@ static int __inject_set_prefix(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	struct kvm_s390_prefix_info *prefix = &li->irq.prefix;
 
-	vcpu->stat.inject_set_prefix++;
+	vcpu->common->stat.inject_set_prefix++;
 	VCPU_EVENT(vcpu, 3, "inject: set prefix to %x",
 		   irq->u.prefix.address);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_SIGP_SET_PREFIX,
@@ -1592,7 +1592,7 @@ static int __inject_sigp_stop(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_stop_info *stop = &li->irq.stop;
 	int rc = 0;
 
-	vcpu->stat.inject_stop_signal++;
+	vcpu->common->stat.inject_stop_signal++;
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_SIGP_STOP, 0, 0);
 
 	if (irq->u.stop.flags & ~KVM_S390_STOP_SUPP_FLAGS)
@@ -1616,7 +1616,7 @@ static int __inject_sigp_restart(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_restart++;
+	vcpu->common->stat.inject_restart++;
 	VCPU_EVENT(vcpu, 3, "%s", "inject: restart int");
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_RESTART, 0, 0);
 
@@ -1629,7 +1629,7 @@ static int __inject_sigp_emergency(struct kvm_vcpu *vcpu,
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_emergency_signal++;
+	vcpu->common->stat.inject_emergency_signal++;
 	VCPU_EVENT(vcpu, 4, "inject: emergency from cpu %u",
 		   irq->u.emerg.code);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_EMERGENCY,
@@ -1650,7 +1650,7 @@ static int __inject_mchk(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	struct kvm_s390_mchk_info *mchk = &li->irq.mchk;
 
-	vcpu->stat.inject_mchk++;
+	vcpu->common->stat.inject_mchk++;
 	VCPU_EVENT(vcpu, 3, "inject: machine check mcic 0x%llx",
 		   irq->u.mchk.mcic);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_MCHK, 0,
@@ -1681,7 +1681,7 @@ static int __inject_ckc(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_ckc++;
+	vcpu->common->stat.inject_ckc++;
 	VCPU_EVENT(vcpu, 3, "%s", "inject: clock comparator external");
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_CLOCK_COMP,
 				   0, 0);
@@ -1695,7 +1695,7 @@ static int __inject_cpu_timer(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_cputm++;
+	vcpu->common->stat.inject_cputm++;
 	VCPU_EVENT(vcpu, 3, "%s", "inject: cpu timer external");
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_CPU_TIMER,
 				   0, 0);
@@ -3195,12 +3195,12 @@ void kvm_s390_gisa_enable(struct kvm *kvm)
 	if (!gisa_desc)
 		return;
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		mutex_lock(&vcpu->common->mutex);
 		vcpu->arch.sie_block->gd = gisa_desc;
 		vcpu->arch.sie_block->eca |= ECA_AIV;
 		VCPU_EVENT(vcpu, 3, "AIV gisa format-%u enabled for cpu %03u",
 			   vcpu->arch.sie_block->gd & 0x3, vcpu->vcpu_id);
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 	}
 }
 
@@ -3231,10 +3231,10 @@ void kvm_s390_gisa_disable(struct kvm *kvm)
 	if (!gi->origin)
 		return;
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		mutex_lock(&vcpu->common->mutex);
 		vcpu->arch.sie_block->eca &= ~ECA_AIV;
 		vcpu->arch.sie_block->gd = 0U;
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 		VCPU_EVENT(vcpu, 3, "AIV disabled for cpu %03u", vcpu->vcpu_id);
 	}
 	kvm_s390_gisa_destroy(kvm);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0fd96860fc45..0b8c368af939 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2450,13 +2450,13 @@ int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 	 * We want to return the first failure rc and rrc, though.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		mutex_lock(&vcpu->common->mutex);
 		if (kvm_s390_pv_destroy_cpu(vcpu, &_rc, &_rrc) && !ret) {
 			*rc = _rc;
 			*rrc = _rrc;
 			ret = -EIO;
 		}
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 	}
 	/* Ensure that we re-enable gisa if the non-PV guest used it but the PV guest did not. */
 	if (use_gisa)
@@ -2488,9 +2488,9 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 		kvm_s390_gisa_disable(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		mutex_lock(&vcpu->common->mutex);
 		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 		if (r)
 			break;
 	}
@@ -3874,8 +3874,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		VCPU_EVENT(vcpu, 3, "AIV gisa format-%u enabled for cpu %03u",
 			   vcpu->arch.sie_block->gd & 0x3, vcpu->vcpu_id);
 	}
-	vcpu->arch.sie_block->sdnxo = virt_to_phys(&vcpu->run->s.regs.sdnx) | SDNXC;
-	vcpu->arch.sie_block->riccbd = virt_to_phys(&vcpu->run->s.regs.riccb);
+	vcpu->arch.sie_block->sdnxo = virt_to_phys(&vcpu->common->run->s.regs.sdnx) | SDNXC;
+	vcpu->arch.sie_block->riccbd = virt_to_phys(&vcpu->common->run->s.regs.riccb);
 
 	if (sclp.has_kss)
 		kvm_s390_set_cpuflags(vcpu, CPUSTAT_KSS);
@@ -3938,7 +3938,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
 	kvm_clear_async_pf_completion_queue(vcpu);
-	vcpu->run->kvm_valid_regs = KVM_SYNC_PREFIX |
+	vcpu->common->run->kvm_valid_regs = KVM_SYNC_PREFIX |
 				    KVM_SYNC_GPRS |
 				    KVM_SYNC_ACRS |
 				    KVM_SYNC_CRS |
@@ -3948,20 +3948,20 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.acrs_loaded = false;
 	kvm_s390_set_prefix(vcpu, 0);
 	if (test_kvm_facility(vcpu->kvm, 64))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_RICCB;
+		vcpu->common->run->kvm_valid_regs |= KVM_SYNC_RICCB;
 	if (test_kvm_facility(vcpu->kvm, 82))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_BPBC;
+		vcpu->common->run->kvm_valid_regs |= KVM_SYNC_BPBC;
 	if (test_kvm_facility(vcpu->kvm, 133))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_GSCB;
+		vcpu->common->run->kvm_valid_regs |= KVM_SYNC_GSCB;
 	if (test_kvm_facility(vcpu->kvm, 156))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_ETOKEN;
+		vcpu->common->run->kvm_valid_regs |= KVM_SYNC_ETOKEN;
 	/* fprs can be synchronized via vrs, even if the guest has no vx. With
 	 * cpu_has_vx(), (load|store)_fpu_regs() will work with vrs format.
 	 */
 	if (cpu_has_vx())
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_VRS;
+		vcpu->common->run->kvm_valid_regs |= KVM_SYNC_VRS;
 	else
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_FPRS;
+		vcpu->common->run->kvm_valid_regs |= KVM_SYNC_FPRS;
 
 	if (kvm_is_ucontrol(vcpu->kvm)) {
 		rc = __kvm_ucontrol_vcpu_init(vcpu);
@@ -4077,7 +4077,7 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
 	if (get_lowcore()->avg_steal_timer * 100 / (TICK_USEC << 12) >=
 	    READ_ONCE(halt_poll_max_steal)) {
-		vcpu->stat.halt_no_poll_steal++;
+		vcpu->common->stat.halt_no_poll_steal++;
 		return true;
 	}
 	return false;
@@ -4196,7 +4196,7 @@ static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_RI;
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
-	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
+	memset(vcpu->common->run->s.regs.riccb, 0, sizeof(vcpu->common->run->s.regs.riccb));
 
 	kvm_clear_async_pf_completion_queue(vcpu);
 	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
@@ -4223,18 +4223,18 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
 
 	/* ... the data in sync regs */
-	memset(vcpu->run->s.regs.crs, 0, sizeof(vcpu->run->s.regs.crs));
-	vcpu->run->s.regs.ckc = 0;
-	vcpu->run->s.regs.crs[0] = CR0_INITIAL_MASK;
-	vcpu->run->s.regs.crs[14] = CR14_INITIAL_MASK;
-	vcpu->run->psw_addr = 0;
-	vcpu->run->psw_mask = 0;
-	vcpu->run->s.regs.todpr = 0;
-	vcpu->run->s.regs.cputm = 0;
-	vcpu->run->s.regs.ckc = 0;
-	vcpu->run->s.regs.pp = 0;
-	vcpu->run->s.regs.gbea = 1;
-	vcpu->run->s.regs.fpc = 0;
+	memset(vcpu->common->run->s.regs.crs, 0, sizeof(vcpu->common->run->s.regs.crs));
+	vcpu->common->run->s.regs.ckc = 0;
+	vcpu->common->run->s.regs.crs[0] = CR0_INITIAL_MASK;
+	vcpu->common->run->s.regs.crs[14] = CR14_INITIAL_MASK;
+	vcpu->common->run->psw_addr = 0;
+	vcpu->common->run->psw_mask = 0;
+	vcpu->common->run->s.regs.todpr = 0;
+	vcpu->common->run->s.regs.cputm = 0;
+	vcpu->common->run->s.regs.ckc = 0;
+	vcpu->common->run->s.regs.pp = 0;
+	vcpu->common->run->s.regs.gbea = 1;
+	vcpu->common->run->s.regs.fpc = 0;
 	/*
 	 * Do not reset these registers in the protected case, as some of
 	 * them are overlaid and they are not accessible in this case
@@ -4250,7 +4250,7 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 
 static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
 {
-	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *regs = &vcpu->common->run->s.regs;
 
 	/* Clear reset is a superset of the initial reset */
 	kvm_arch_vcpu_ioctl_initial_reset(vcpu);
@@ -4267,7 +4267,7 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu_load(vcpu);
-	memcpy(&vcpu->run->s.regs.gprs, &regs->gprs, sizeof(regs->gprs));
+	memcpy(&vcpu->common->run->s.regs.gprs, &regs->gprs, sizeof(regs->gprs));
 	vcpu_put(vcpu);
 	return 0;
 }
@@ -4275,7 +4275,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu_load(vcpu);
-	memcpy(&regs->gprs, &vcpu->run->s.regs.gprs, sizeof(regs->gprs));
+	memcpy(&regs->gprs, &vcpu->common->run->s.regs.gprs, sizeof(regs->gprs));
 	vcpu_put(vcpu);
 	return 0;
 }
@@ -4285,7 +4285,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	vcpu_load(vcpu);
 
-	memcpy(&vcpu->run->s.regs.acrs, &sregs->acrs, sizeof(sregs->acrs));
+	memcpy(&vcpu->common->run->s.regs.acrs, &sregs->acrs, sizeof(sregs->acrs));
 	memcpy(&vcpu->arch.sie_block->gcr, &sregs->crs, sizeof(sregs->crs));
 
 	vcpu_put(vcpu);
@@ -4297,7 +4297,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 {
 	vcpu_load(vcpu);
 
-	memcpy(&sregs->acrs, &vcpu->run->s.regs.acrs, sizeof(sregs->acrs));
+	memcpy(&sregs->acrs, &vcpu->common->run->s.regs.acrs, sizeof(sregs->acrs));
 	memcpy(&sregs->crs, &vcpu->arch.sie_block->gcr, sizeof(sregs->crs));
 
 	vcpu_put(vcpu);
@@ -4310,12 +4310,12 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	vcpu->run->s.regs.fpc = fpu->fpc;
+	vcpu->common->run->s.regs.fpc = fpu->fpc;
 	if (cpu_has_vx())
-		convert_fp_to_vx((__vector128 *) vcpu->run->s.regs.vrs,
+		convert_fp_to_vx((__vector128 *) vcpu->common->run->s.regs.vrs,
 				 (freg_t *) fpu->fprs);
 	else
-		memcpy(vcpu->run->s.regs.fprs, &fpu->fprs, sizeof(fpu->fprs));
+		memcpy(vcpu->common->run->s.regs.fprs, &fpu->fprs, sizeof(fpu->fprs));
 
 	vcpu_put(vcpu);
 	return ret;
@@ -4327,10 +4327,10 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	if (cpu_has_vx())
 		convert_vx_to_fp((freg_t *) fpu->fprs,
-				 (__vector128 *) vcpu->run->s.regs.vrs);
+				 (__vector128 *) vcpu->common->run->s.regs.vrs);
 	else
-		memcpy(fpu->fprs, vcpu->run->s.regs.fprs, sizeof(fpu->fprs));
-	fpu->fpc = vcpu->run->s.regs.fpc;
+		memcpy(fpu->fprs, vcpu->common->run->s.regs.fprs, sizeof(fpu->fprs));
+	fpu->fpc = vcpu->common->run->s.regs.fpc;
 
 	vcpu_put(vcpu);
 	return 0;
@@ -4343,8 +4343,8 @@ static int kvm_arch_vcpu_ioctl_set_initial_psw(struct kvm_vcpu *vcpu, psw_t psw)
 	if (!is_vcpu_stopped(vcpu))
 		rc = -EBUSY;
 	else {
-		vcpu->run->psw_mask = psw.mask;
-		vcpu->run->psw_addr = psw.addr;
+		vcpu->common->run->psw_mask = psw.mask;
+		vcpu->common->run->psw_addr = psw.addr;
 	}
 	return rc;
 }
@@ -4366,7 +4366,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	vcpu_load(vcpu);
 
-	vcpu->guest_debug = 0;
+	vcpu->common->guest_debug = 0;
 	kvm_s390_clear_bp_data(vcpu);
 
 	if (dbg->control & ~VALID_GUESTDBG_FLAGS) {
@@ -4379,7 +4379,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	}
 
 	if (dbg->control & KVM_GUESTDBG_ENABLE) {
-		vcpu->guest_debug = dbg->control;
+		vcpu->common->guest_debug = dbg->control;
 		/* enforce guest PER */
 		kvm_s390_set_cpuflags(vcpu, CPUSTAT_P);
 
@@ -4391,7 +4391,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	}
 
 	if (rc) {
-		vcpu->guest_debug = 0;
+		vcpu->common->guest_debug = 0;
 		kvm_s390_clear_bp_data(vcpu);
 		kvm_s390_clear_cpuflags(vcpu, CPUSTAT_P);
 	}
@@ -4672,8 +4672,8 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 	 */
 	kvm_check_async_pf_completion(vcpu);
 
-	vcpu->arch.sie_block->gg14 = vcpu->run->s.regs.gprs[14];
-	vcpu->arch.sie_block->gg15 = vcpu->run->s.regs.gprs[15];
+	vcpu->arch.sie_block->gg14 = vcpu->common->run->s.regs.gprs[14];
+	vcpu->arch.sie_block->gg15 = vcpu->common->run->s.regs.gprs[15];
 
 	if (need_resched())
 		schedule();
@@ -4751,8 +4751,8 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 	if (guestdbg_enabled(vcpu))
 		kvm_s390_restore_guest_per_regs(vcpu);
 
-	vcpu->run->s.regs.gprs[14] = vcpu->arch.sie_block->gg14;
-	vcpu->run->s.regs.gprs[15] = vcpu->arch.sie_block->gg15;
+	vcpu->common->run->s.regs.gprs[14] = vcpu->arch.sie_block->gg14;
+	vcpu->common->run->s.regs.gprs[15] = vcpu->arch.sie_block->gg15;
 
 	if (exit_reason == -EINTR) {
 		VCPU_EVENT(vcpu, 3, "%s", "machine check");
@@ -4768,26 +4768,26 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 
 		if (rc != -EOPNOTSUPP)
 			return rc;
-		vcpu->run->exit_reason = KVM_EXIT_S390_SIEIC;
-		vcpu->run->s390_sieic.icptcode = vcpu->arch.sie_block->icptcode;
-		vcpu->run->s390_sieic.ipa = vcpu->arch.sie_block->ipa;
-		vcpu->run->s390_sieic.ipb = vcpu->arch.sie_block->ipb;
+		vcpu->common->run->exit_reason = KVM_EXIT_S390_SIEIC;
+		vcpu->common->run->s390_sieic.icptcode = vcpu->arch.sie_block->icptcode;
+		vcpu->common->run->s390_sieic.ipa = vcpu->arch.sie_block->ipa;
+		vcpu->common->run->s390_sieic.ipb = vcpu->arch.sie_block->ipb;
 		return -EREMOTE;
 	} else if (exit_reason != -EFAULT) {
-		vcpu->stat.exit_null++;
+		vcpu->common->stat.exit_null++;
 		return 0;
 	} else if (kvm_is_ucontrol(vcpu->kvm)) {
-		vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
-		vcpu->run->s390_ucontrol.trans_exc_code =
+		vcpu->common->run->exit_reason = KVM_EXIT_S390_UCONTROL;
+		vcpu->common->run->s390_ucontrol.trans_exc_code =
 						current->thread.gmap_addr;
-		vcpu->run->s390_ucontrol.pgm_code = 0x10;
+		vcpu->common->run->s390_ucontrol.pgm_code = 0x10;
 		return -EREMOTE;
 	} else if (current->thread.gmap_pfault) {
 		trace_kvm_s390_major_guest_pfault(vcpu);
 		current->thread.gmap_pfault = 0;
 		if (kvm_arch_setup_async_pf(vcpu))
 			return 0;
-		vcpu->stat.pfault_sync++;
+		vcpu->common->stat.pfault_sync++;
 		return kvm_arch_fault_in_page(vcpu, current->thread.gmap_addr, 1);
 	}
 	return vcpu_post_run_fault_in_sie(vcpu);
@@ -4821,14 +4821,14 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		local_irq_enable();
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(sie_page->pv_grregs,
-			       vcpu->run->s.regs.gprs,
+			       vcpu->common->run->s.regs.gprs,
 			       sizeof(sie_page->pv_grregs));
 		}
 		exit_reason = sie64a(vcpu->arch.sie_block,
-				     vcpu->run->s.regs.gprs,
+				     vcpu->common->run->s.regs.gprs,
 				     gmap_get_enabled()->asce);
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
-			memcpy(vcpu->run->s.regs.gprs,
+			memcpy(vcpu->common->run->s.regs.gprs,
 			       sie_page->pv_grregs,
 			       sizeof(sie_page->pv_grregs));
 			/*
@@ -4857,7 +4857,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
 
@@ -4920,7 +4920,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
 		}
 		if (vcpu->arch.gs_enabled) {
 			current->thread.gs_cb = (struct gs_cb *)
-						&vcpu->run->s.regs.gscb;
+						&vcpu->common->run->s.regs.gscb;
 			restore_gs_cb(current->thread.gs_cb);
 		}
 		preempt_enable();
@@ -4930,7 +4930,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
 
 static void sync_regs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
 		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
@@ -4944,9 +4944,9 @@ static void sync_regs(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
 	}
 	save_access_regs(vcpu->arch.host_acrs);
-	restore_access_regs(vcpu->run->s.regs.acrs);
+	restore_access_regs(vcpu->common->run->s.regs.acrs);
 	vcpu->arch.acrs_loaded = true;
-	kvm_s390_fpu_load(vcpu->run);
+	kvm_s390_fpu_load(vcpu->common->run);
 	/* Sync fmt2 only data */
 	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu))) {
 		sync_regs_fmt2(vcpu);
@@ -4970,7 +4970,7 @@ static void sync_regs(struct kvm_vcpu *vcpu)
 
 static void store_regs_fmt2(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 
 	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
 	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
@@ -4994,7 +4994,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu)
 
 static void store_regs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 
 	kvm_run->psw_mask = vcpu->arch.sie_block->gpsw.mask;
 	kvm_run->psw_addr = vcpu->arch.sie_block->gpsw.addr;
@@ -5005,17 +5005,17 @@ static void store_regs(struct kvm_vcpu *vcpu)
 	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
 	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
 	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
-	save_access_regs(vcpu->run->s.regs.acrs);
+	save_access_regs(vcpu->common->run->s.regs.acrs);
 	restore_access_regs(vcpu->arch.host_acrs);
 	vcpu->arch.acrs_loaded = false;
-	kvm_s390_fpu_store(vcpu->run);
+	kvm_s390_fpu_store(vcpu->common->run);
 	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu)))
 		store_regs_fmt2(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 	DECLARE_KERNEL_FPU_ONSTACK32(fpu);
 	int rc;
 
@@ -5028,7 +5028,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.pv.dumping)
 		return -EINVAL;
 
-	if (!vcpu->wants_to_run)
+	if (!vcpu->common->wants_to_run)
 		return -EINTR;
 
 	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_S390_VALID_FIELDS ||
@@ -5086,7 +5086,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_deactivate(vcpu);
 
-	vcpu->stat.exit_userspace++;
+	vcpu->common->stat.exit_userspace++;
 out:
 	vcpu_put(vcpu);
 	return rc;
@@ -5120,21 +5120,21 @@ int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long gpa)
 
 	/* manually convert vector registers if necessary */
 	if (cpu_has_vx()) {
-		convert_vx_to_fp(fprs, (__vector128 *) vcpu->run->s.regs.vrs);
+		convert_vx_to_fp(fprs, (__vector128 *) vcpu->common->run->s.regs.vrs);
 		rc = write_guest_abs(vcpu, gpa + __LC_FPREGS_SAVE_AREA,
 				     fprs, 128);
 	} else {
 		rc = write_guest_abs(vcpu, gpa + __LC_FPREGS_SAVE_AREA,
-				     vcpu->run->s.regs.fprs, 128);
+				     vcpu->common->run->s.regs.fprs, 128);
 	}
 	rc |= write_guest_abs(vcpu, gpa + __LC_GPREGS_SAVE_AREA,
-			      vcpu->run->s.regs.gprs, 128);
+			      vcpu->common->run->s.regs.gprs, 128);
 	rc |= write_guest_abs(vcpu, gpa + __LC_PSW_SAVE_AREA,
 			      &vcpu->arch.sie_block->gpsw, 16);
 	rc |= write_guest_abs(vcpu, gpa + __LC_PREFIX_SAVE_AREA,
 			      &px, 4);
 	rc |= write_guest_abs(vcpu, gpa + __LC_FP_CREG_SAVE_AREA,
-			      &vcpu->run->s.regs.fpc, 4);
+			      &vcpu->common->run->s.regs.fpc, 4);
 	rc |= write_guest_abs(vcpu, gpa + __LC_TOD_PROGREG_SAVE_AREA,
 			      &vcpu->arch.sie_block->todpr, 4);
 	cputm = kvm_s390_get_cpu_timer(vcpu);
@@ -5144,7 +5144,7 @@ int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long gpa)
 	rc |= write_guest_abs(vcpu, gpa + __LC_CLOCK_COMP_SAVE_AREA,
 			      &clkcomp, 8);
 	rc |= write_guest_abs(vcpu, gpa + __LC_AREGS_SAVE_AREA,
-			      &vcpu->run->s.regs.acrs, 64);
+			      &vcpu->common->run->s.regs.acrs, 64);
 	rc |= write_guest_abs(vcpu, gpa + __LC_CREGS_SAVE_AREA,
 			      &vcpu->arch.sie_block->gcr, 128);
 	return rc ? -EFAULT : 0;
@@ -5157,8 +5157,8 @@ int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
 	 * switch in the run ioctl. Let's update our copies before we save
 	 * it into the save area
 	 */
-	kvm_s390_fpu_store(vcpu->run);
-	save_access_regs(vcpu->run->s.regs.acrs);
+	kvm_s390_fpu_store(vcpu->common->run);
+	save_access_regs(vcpu->common->run->s.regs.acrs);
 
 	return kvm_s390_store_status_unloaded(vcpu, addr);
 }
@@ -5422,7 +5422,7 @@ static long kvm_s390_vcpu_memsida_op(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_S390_MEMOP_SIDA_READ:
 	case KVM_S390_MEMOP_SIDA_WRITE:
-		/* we are locked against sida going away by the vcpu->mutex */
+		/* we are locked against sida going away by the vcpu->common->mutex */
 		r = kvm_s390_vcpu_sida_op(vcpu, mop);
 		break;
 	default:
@@ -5473,7 +5473,7 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 	 * after (and not before) the interrupt delivery.
 	 */
 	if (!rc)
-		vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
+		vcpu->common->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
 
 	return rc;
 }
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index bf8534218af3..992d78d7b408 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -135,7 +135,7 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
 	if (ar)
 		*ar = base2;
 
-	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
+	return (base2 ? vcpu->common->run->s.regs.gprs[base2] : 0) + disp2;
 }
 
 static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
@@ -150,7 +150,7 @@ static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
 	if (ar)
 		*ar = base1;
 
-	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + disp1;
+	return (base1 ? vcpu->common->run->s.regs.gprs[base1] : 0) + disp1;
 }
 
 static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
@@ -162,8 +162,8 @@ static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
 	u32 base2 = (vcpu->arch.sie_block->ipb & 0xf000) >> 12;
 	u32 disp2 = vcpu->arch.sie_block->ipb & 0x0fff;
 
-	*address1 = (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + disp1;
-	*address2 = (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
+	*address1 = (base1 ? vcpu->common->run->s.regs.gprs[base1] : 0) + disp1;
+	*address2 = (base2 ? vcpu->common->run->s.regs.gprs[base2] : 0) + disp2;
 
 	if (ar_b1)
 		*ar_b1 = base1;
@@ -191,7 +191,7 @@ static inline u64 kvm_s390_get_base_disp_rsy(struct kvm_vcpu *vcpu, u8 *ar)
 	if (ar)
 		*ar = base2;
 
-	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + (long)(int)disp2;
+	return (base2 ? vcpu->common->run->s.regs.gprs[base2] : 0) + (long)(int)disp2;
 }
 
 static inline u64 kvm_s390_get_base_disp_rs(struct kvm_vcpu *vcpu, u8 *ar)
@@ -202,7 +202,7 @@ static inline u64 kvm_s390_get_base_disp_rs(struct kvm_vcpu *vcpu, u8 *ar)
 	if (ar)
 		*ar = base2;
 
-	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
+	return (base2 ? vcpu->common->run->s.regs.gprs[base2] : 0) + disp2;
 }
 
 /* Set the condition code in the guest program status word */
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 1a49b89706f8..414c534b66aa 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -31,7 +31,7 @@
 
 static int handle_ri(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_ri++;
+	vcpu->common->stat.instruction_ri++;
 
 	if (test_kvm_facility(vcpu->kvm, 64)) {
 		VCPU_EVENT(vcpu, 3, "%s", "ENABLE: RI (lazy)");
@@ -52,13 +52,13 @@ int kvm_s390_handle_aa(struct kvm_vcpu *vcpu)
 
 static int handle_gs(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_gs++;
+	vcpu->common->stat.instruction_gs++;
 
 	if (test_kvm_facility(vcpu->kvm, 133)) {
 		VCPU_EVENT(vcpu, 3, "%s", "ENABLE: GS (lazy)");
 		preempt_disable();
 		local_ctl_set_bit(2, CR2_GUARDED_STORAGE_BIT);
-		current->thread.gs_cb = (struct gs_cb *)&vcpu->run->s.regs.gscb;
+		current->thread.gs_cb = (struct gs_cb *)&vcpu->common->run->s.regs.gscb;
 		restore_gs_cb(current->thread.gs_cb);
 		preempt_enable();
 		vcpu->arch.sie_block->ecb |= ECB_GS;
@@ -87,7 +87,7 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
 	u8 ar;
 	u64 op2;
 
-	vcpu->stat.instruction_sck++;
+	vcpu->common->stat.instruction_sck++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -126,7 +126,7 @@ static int handle_set_prefix(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_spx++;
+	vcpu->common->stat.instruction_spx++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -164,7 +164,7 @@ static int handle_store_prefix(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_stpx++;
+	vcpu->common->stat.instruction_stpx++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -194,7 +194,7 @@ static int handle_store_cpu_address(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_stap++;
+	vcpu->common->stat.instruction_stap++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -261,7 +261,7 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 	bool unlocked;
 	int rc;
 
-	vcpu->stat.instruction_iske++;
+	vcpu->common->stat.instruction_iske++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -272,7 +272,7 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
-	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
+	gaddr = vcpu->common->run->s.regs.gprs[reg2] & PAGE_MASK;
 	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
 	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
 	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
@@ -296,8 +296,8 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 	if (rc < 0)
 		return rc;
-	vcpu->run->s.regs.gprs[reg1] &= ~0xff;
-	vcpu->run->s.regs.gprs[reg1] |= key;
+	vcpu->common->run->s.regs.gprs[reg1] &= ~0xff;
+	vcpu->common->run->s.regs.gprs[reg1] |= key;
 	return 0;
 }
 
@@ -308,7 +308,7 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 	bool unlocked;
 	int rc;
 
-	vcpu->stat.instruction_rrbe++;
+	vcpu->common->stat.instruction_rrbe++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -319,7 +319,7 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
-	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
+	gaddr = vcpu->common->run->s.regs.gprs[reg2] & PAGE_MASK;
 	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
 	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
 	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
@@ -359,7 +359,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 	bool unlocked;
 	int rc;
 
-	vcpu->stat.instruction_sske++;
+	vcpu->common->stat.instruction_sske++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -377,8 +377,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
-	key = vcpu->run->s.regs.gprs[reg1] & 0xfe;
-	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
+	key = vcpu->common->run->s.regs.gprs[reg1] & 0xfe;
+	start = vcpu->common->run->s.regs.gprs[reg2] & PAGE_MASK;
 	start = kvm_s390_logical_to_effective(vcpu, start);
 	if (m3 & SSKE_MB) {
 		/* start already designates an absolute address */
@@ -421,24 +421,24 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 			kvm_s390_set_psw_cc(vcpu, 3);
 		} else {
 			kvm_s390_set_psw_cc(vcpu, rc);
-			vcpu->run->s.regs.gprs[reg1] &= ~0xff00UL;
-			vcpu->run->s.regs.gprs[reg1] |= (u64) oldkey << 8;
+			vcpu->common->run->s.regs.gprs[reg1] &= ~0xff00UL;
+			vcpu->common->run->s.regs.gprs[reg1] |= (u64) oldkey << 8;
 		}
 	}
 	if (m3 & SSKE_MB) {
 		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_64BIT)
-			vcpu->run->s.regs.gprs[reg2] &= ~PAGE_MASK;
+			vcpu->common->run->s.regs.gprs[reg2] &= ~PAGE_MASK;
 		else
-			vcpu->run->s.regs.gprs[reg2] &= ~0xfffff000UL;
+			vcpu->common->run->s.regs.gprs[reg2] &= ~0xfffff000UL;
 		end = kvm_s390_logical_to_effective(vcpu, end);
-		vcpu->run->s.regs.gprs[reg2] |= end;
+		vcpu->common->run->s.regs.gprs[reg2] |= end;
 	}
 	return 0;
 }
 
 static int handle_ipte_interlock(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_ipte_interlock++;
+	vcpu->common->stat.instruction_ipte_interlock++;
 	if (psw_bits(vcpu->arch.sie_block->gpsw).pstate)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 	wait_event(vcpu->kvm->arch.ipte_wq, !ipte_lock_held(vcpu->kvm));
@@ -452,13 +452,13 @@ static int handle_test_block(struct kvm_vcpu *vcpu)
 	gpa_t addr;
 	int reg2;
 
-	vcpu->stat.instruction_tb++;
+	vcpu->common->stat.instruction_tb++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
 	kvm_s390_get_regs_rre(vcpu, NULL, &reg2);
-	addr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
+	addr = vcpu->common->run->s.regs.gprs[reg2] & PAGE_MASK;
 	addr = kvm_s390_logical_to_effective(vcpu, addr);
 	if (kvm_s390_check_low_addr_prot_real(vcpu, addr))
 		return kvm_s390_inject_prog_irq(vcpu, &vcpu->arch.pgm);
@@ -473,7 +473,7 @@ static int handle_test_block(struct kvm_vcpu *vcpu)
 	if (kvm_clear_guest(vcpu->kvm, addr, PAGE_SIZE))
 		return -EFAULT;
 	kvm_s390_set_psw_cc(vcpu, 0);
-	vcpu->run->s.regs.gprs[0] = 0;
+	vcpu->common->run->s.regs.gprs[0] = 0;
 	return 0;
 }
 
@@ -486,7 +486,7 @@ static int handle_tpi(struct kvm_vcpu *vcpu)
 	u64 addr;
 	u8 ar;
 
-	vcpu->stat.instruction_tpi++;
+	vcpu->common->stat.instruction_tpi++;
 
 	addr = kvm_s390_get_base_disp_s(vcpu, &ar);
 	if (addr & 3)
@@ -548,12 +548,12 @@ static int handle_tsch(struct kvm_vcpu *vcpu)
 	struct kvm_s390_interrupt_info *inti = NULL;
 	const u64 isc_mask = 0xffUL << 24; /* all iscs set */
 
-	vcpu->stat.instruction_tsch++;
+	vcpu->common->stat.instruction_tsch++;
 
 	/* a valid schid has at least one bit set */
-	if (vcpu->run->s.regs.gprs[1])
+	if (vcpu->common->run->s.regs.gprs[1])
 		inti = kvm_s390_get_io_int(vcpu->kvm, isc_mask,
-					   vcpu->run->s.regs.gprs[1]);
+					   vcpu->common->run->s.regs.gprs[1]);
 
 	/*
 	 * Prepare exit to userspace.
@@ -563,15 +563,15 @@ static int handle_tsch(struct kvm_vcpu *vcpu)
 	 * interrupts, this is no problem since the priority is kept
 	 * intact.
 	 */
-	vcpu->run->exit_reason = KVM_EXIT_S390_TSCH;
-	vcpu->run->s390_tsch.dequeued = !!inti;
+	vcpu->common->run->exit_reason = KVM_EXIT_S390_TSCH;
+	vcpu->common->run->s390_tsch.dequeued = !!inti;
 	if (inti) {
-		vcpu->run->s390_tsch.subchannel_id = inti->io.subchannel_id;
-		vcpu->run->s390_tsch.subchannel_nr = inti->io.subchannel_nr;
-		vcpu->run->s390_tsch.io_int_parm = inti->io.io_int_parm;
-		vcpu->run->s390_tsch.io_int_word = inti->io.io_int_word;
+		vcpu->common->run->s390_tsch.subchannel_id = inti->io.subchannel_id;
+		vcpu->common->run->s390_tsch.subchannel_nr = inti->io.subchannel_nr;
+		vcpu->common->run->s390_tsch.io_int_parm = inti->io.io_int_parm;
+		vcpu->common->run->s390_tsch.io_int_word = inti->io.io_int_word;
 	}
-	vcpu->run->s390_tsch.ipb = vcpu->arch.sie_block->ipb;
+	vcpu->common->run->s390_tsch.ipb = vcpu->arch.sie_block->ipb;
 	kfree(inti);
 	return -EREMOTE;
 }
@@ -593,7 +593,7 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.sie_block->ipa == 0xb235)
 			return handle_tsch(vcpu);
 		/* Handle in userspace. */
-		vcpu->stat.instruction_io_other++;
+		vcpu->common->stat.instruction_io_other++;
 		return -EOPNOTSUPP;
 	} else {
 		/*
@@ -642,7 +642,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	 * Note: running nested under z/VM can result in intercepts for other
 	 * function codes, e.g. PQAP(QCI). We do not support this and bail out.
 	 */
-	reg0 = vcpu->run->s.regs.gprs[0];
+	reg0 = vcpu->common->run->s.regs.gprs[0];
 	fc = (reg0 >> 24) & 0xff;
 	if (fc != 0x03)
 		return -EOPNOTSUPP;
@@ -677,7 +677,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 		pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
 		ret = pqap_hook(vcpu);
 		if (!ret) {
-			if (vcpu->run->s.regs.gprs[1] & 0x00ff0000)
+			if (vcpu->common->run->s.regs.gprs[1] & 0x00ff0000)
 				kvm_s390_set_psw_cc(vcpu, 3);
 			else
 				kvm_s390_set_psw_cc(vcpu, 0);
@@ -692,7 +692,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	 * We send this response to the guest.
 	 */
 	status.response_code = 0x01;
-	memcpy(&vcpu->run->s.regs.gprs[1], &status, sizeof(status));
+	memcpy(&vcpu->common->run->s.regs.gprs[1], &status, sizeof(status));
 	kvm_s390_set_psw_cc(vcpu, 3);
 	return 0;
 }
@@ -702,7 +702,7 @@ static int handle_stfl(struct kvm_vcpu *vcpu)
 	int rc;
 	unsigned int fac;
 
-	vcpu->stat.instruction_stfl++;
+	vcpu->common->stat.instruction_stfl++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -751,7 +751,7 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_lpsw++;
+	vcpu->common->stat.instruction_lpsw++;
 
 	if (gpsw->mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -780,7 +780,7 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_lpswe++;
+	vcpu->common->stat.instruction_lpswe++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -834,7 +834,7 @@ static int handle_stidp(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_stidp++;
+	vcpu->common->stat.instruction_stidp++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -882,25 +882,25 @@ static void handle_stsi_3_2_2(struct kvm_vcpu *vcpu, struct sysinfo_3_2_2 *mem)
 static void insert_stsi_usr_data(struct kvm_vcpu *vcpu, u64 addr, u8 ar,
 				 u8 fc, u8 sel1, u16 sel2)
 {
-	vcpu->run->exit_reason = KVM_EXIT_S390_STSI;
-	vcpu->run->s390_stsi.addr = addr;
-	vcpu->run->s390_stsi.ar = ar;
-	vcpu->run->s390_stsi.fc = fc;
-	vcpu->run->s390_stsi.sel1 = sel1;
-	vcpu->run->s390_stsi.sel2 = sel2;
+	vcpu->common->run->exit_reason = KVM_EXIT_S390_STSI;
+	vcpu->common->run->s390_stsi.addr = addr;
+	vcpu->common->run->s390_stsi.ar = ar;
+	vcpu->common->run->s390_stsi.fc = fc;
+	vcpu->common->run->s390_stsi.sel1 = sel1;
+	vcpu->common->run->s390_stsi.sel2 = sel2;
 }
 
 static int handle_stsi(struct kvm_vcpu *vcpu)
 {
-	int fc = (vcpu->run->s.regs.gprs[0] & 0xf0000000) >> 28;
-	int sel1 = vcpu->run->s.regs.gprs[0] & 0xff;
-	int sel2 = vcpu->run->s.regs.gprs[1] & 0xffff;
+	int fc = (vcpu->common->run->s.regs.gprs[0] & 0xf0000000) >> 28;
+	int sel1 = vcpu->common->run->s.regs.gprs[0] & 0xff;
+	int sel2 = vcpu->common->run->s.regs.gprs[1] & 0xffff;
 	unsigned long mem = 0;
 	u64 operand2;
 	int rc = 0;
 	u8 ar;
 
-	vcpu->stat.instruction_stsi++;
+	vcpu->common->stat.instruction_stsi++;
 	VCPU_EVENT(vcpu, 3, "STSI: fc: %u sel1: %u sel2: %u", fc, sel1, sel2);
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
@@ -919,12 +919,12 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 			 !vcpu->kvm->arch.user_stsi))
 		goto out_no_data;
 
-	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
-	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
+	if (vcpu->common->run->s.regs.gprs[0] & 0x0fffff00
+	    || vcpu->common->run->s.regs.gprs[1] & 0xffff0000)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	if (fc == 0) {
-		vcpu->run->s.regs.gprs[0] = 3 << 28;
+		vcpu->common->run->s.regs.gprs[0] = 3 << 28;
 		kvm_s390_set_psw_cc(vcpu, 0);
 		return 0;
 	}
@@ -973,7 +973,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
 	free_page(mem);
 	kvm_s390_set_psw_cc(vcpu, 0);
-	vcpu->run->s.regs.gprs[0] = 0;
+	vcpu->common->run->s.regs.gprs[0] = 0;
 	return rc;
 out_no_data:
 	kvm_s390_set_psw_cc(vcpu, 3);
@@ -1044,16 +1044,16 @@ static int handle_epsw(struct kvm_vcpu *vcpu)
 {
 	int reg1, reg2;
 
-	vcpu->stat.instruction_epsw++;
+	vcpu->common->stat.instruction_epsw++;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
 	/* This basically extracts the mask half of the psw. */
-	vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00000000UL;
-	vcpu->run->s.regs.gprs[reg1] |= vcpu->arch.sie_block->gpsw.mask >> 32;
+	vcpu->common->run->s.regs.gprs[reg1] &= 0xffffffff00000000UL;
+	vcpu->common->run->s.regs.gprs[reg1] |= vcpu->arch.sie_block->gpsw.mask >> 32;
 	if (reg2) {
-		vcpu->run->s.regs.gprs[reg2] &= 0xffffffff00000000UL;
-		vcpu->run->s.regs.gprs[reg2] |=
+		vcpu->common->run->s.regs.gprs[reg2] &= 0xffffffff00000000UL;
+		vcpu->common->run->s.regs.gprs[reg2] |=
 			vcpu->arch.sie_block->gpsw.mask & 0x00000000ffffffffUL;
 	}
 	return 0;
@@ -1076,7 +1076,7 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	unsigned long start, end;
 	unsigned char key;
 
-	vcpu->stat.instruction_pfmf++;
+	vcpu->common->stat.instruction_pfmf++;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
@@ -1086,32 +1086,32 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_RESERVED)
+	if (vcpu->common->run->s.regs.gprs[reg1] & PFMF_RESERVED)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	/* Only provide non-quiescing support if enabled for the guest */
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_NQ &&
+	if (vcpu->common->run->s.regs.gprs[reg1] & PFMF_NQ &&
 	    !test_kvm_facility(vcpu->kvm, 14))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	/* Only provide conditional-SSKE support if enabled for the guest */
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_SK &&
+	if (vcpu->common->run->s.regs.gprs[reg1] & PFMF_SK &&
 	    test_kvm_facility(vcpu->kvm, 10)) {
-		mr = vcpu->run->s.regs.gprs[reg1] & PFMF_MR;
-		mc = vcpu->run->s.regs.gprs[reg1] & PFMF_MC;
+		mr = vcpu->common->run->s.regs.gprs[reg1] & PFMF_MR;
+		mc = vcpu->common->run->s.regs.gprs[reg1] & PFMF_MC;
 	}
 
-	nq = vcpu->run->s.regs.gprs[reg1] & PFMF_NQ;
-	key = vcpu->run->s.regs.gprs[reg1] & PFMF_KEY;
-	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
+	nq = vcpu->common->run->s.regs.gprs[reg1] & PFMF_NQ;
+	key = vcpu->common->run->s.regs.gprs[reg1] & PFMF_KEY;
+	start = vcpu->common->run->s.regs.gprs[reg2] & PAGE_MASK;
 	start = kvm_s390_logical_to_effective(vcpu, start);
 
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_CF) {
+	if (vcpu->common->run->s.regs.gprs[reg1] & PFMF_CF) {
 		if (kvm_s390_check_low_addr_prot_real(vcpu, start))
 			return kvm_s390_inject_prog_irq(vcpu, &vcpu->arch.pgm);
 	}
 
-	switch (vcpu->run->s.regs.gprs[reg1] & PFMF_FSC) {
+	switch (vcpu->common->run->s.regs.gprs[reg1] & PFMF_FSC) {
 	case 0x00000000:
 		/* only 4k frames specify a real address */
 		start = kvm_s390_real_to_abs(vcpu, start);
@@ -1141,12 +1141,12 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 		if (kvm_is_error_hva(vmaddr))
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 
-		if (vcpu->run->s.regs.gprs[reg1] & PFMF_CF) {
+		if (vcpu->common->run->s.regs.gprs[reg1] & PFMF_CF) {
 			if (kvm_clear_guest(vcpu->kvm, start, PAGE_SIZE))
 				return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 		}
 
-		if (vcpu->run->s.regs.gprs[reg1] & PFMF_SK) {
+		if (vcpu->common->run->s.regs.gprs[reg1] & PFMF_SK) {
 			int rc = kvm_s390_skey_check_enable(vcpu);
 
 			if (rc)
@@ -1169,13 +1169,13 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 		}
 		start += PAGE_SIZE;
 	}
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_FSC) {
+	if (vcpu->common->run->s.regs.gprs[reg1] & PFMF_FSC) {
 		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_64BIT) {
-			vcpu->run->s.regs.gprs[reg2] = end;
+			vcpu->common->run->s.regs.gprs[reg2] = end;
 		} else {
-			vcpu->run->s.regs.gprs[reg2] &= ~0xffffffffUL;
+			vcpu->common->run->s.regs.gprs[reg2] &= ~0xffffffffUL;
 			end = kvm_s390_logical_to_effective(vcpu, end);
-			vcpu->run->s.regs.gprs[reg2] |= end;
+			vcpu->common->run->s.regs.gprs[reg2] |= end;
 		}
 	}
 	return 0;
@@ -1196,7 +1196,7 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 	 */
 
 	kvm_s390_get_regs_rre(vcpu, &r1, &r2);
-	gfn = vcpu->run->s.regs.gprs[r2] >> PAGE_SHIFT;
+	gfn = vcpu->common->run->s.regs.gprs[r2] >> PAGE_SHIFT;
 	hva = gfn_to_hva(vcpu->kvm, gfn);
 	entries = (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
 
@@ -1206,7 +1206,7 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 	nappended = pgste_perform_essa(vcpu->kvm->mm, hva, orc, &ptev, &pgstev);
 	if (nappended < 0) {
 		res = orc ? 0x10 : 0;
-		vcpu->run->s.regs.gprs[r1] = res; /* Exception Indication */
+		vcpu->common->run->s.regs.gprs[r1] = res; /* Exception Indication */
 		return 0;
 	}
 	res = (pgstev & _PGSTE_GPS_USAGE_MASK) >> 22;
@@ -1223,7 +1223,7 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 	}
 	if (pgstev & _PGSTE_GPS_NODAT)
 		res |= 0x20;
-	vcpu->run->s.regs.gprs[r1] = res;
+	vcpu->common->run->s.regs.gprs[r1] = res;
 	/*
 	 * It is possible that all the normal 511 slots were full, in which case
 	 * we will now write in the 512th slot, which is reserved for host use.
@@ -1256,7 +1256,7 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 
 	VCPU_EVENT(vcpu, 4, "ESSA: release %d pages", entries);
 	gmap = vcpu->arch.gmap;
-	vcpu->stat.instruction_essa++;
+	vcpu->common->stat.instruction_essa++;
 	if (!vcpu->kvm->arch.use_cmma)
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 
@@ -1345,7 +1345,7 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_lctl++;
+	vcpu->common->stat.instruction_lctl++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1384,7 +1384,7 @@ int kvm_s390_handle_stctl(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_stctl++;
+	vcpu->common->stat.instruction_stctl++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1418,7 +1418,7 @@ static int handle_lctlg(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_lctlg++;
+	vcpu->common->stat.instruction_lctlg++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1456,7 +1456,7 @@ static int handle_stctg(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_stctg++;
+	vcpu->common->stat.instruction_stctg++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1508,7 +1508,7 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
 	int ret, cc;
 	u8 ar;
 
-	vcpu->stat.instruction_tprot++;
+	vcpu->common->stat.instruction_tprot++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1572,16 +1572,16 @@ static int handle_sckpf(struct kvm_vcpu *vcpu)
 {
 	u32 value;
 
-	vcpu->stat.instruction_sckpf++;
+	vcpu->common->stat.instruction_sckpf++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (vcpu->run->s.regs.gprs[0] & 0x00000000ffff0000)
+	if (vcpu->common->run->s.regs.gprs[0] & 0x00000000ffff0000)
 		return kvm_s390_inject_program_int(vcpu,
 						   PGM_SPECIFICATION);
 
-	value = vcpu->run->s.regs.gprs[0] & 0x000000000000ffff;
+	value = vcpu->common->run->s.regs.gprs[0] & 0x000000000000ffff;
 	vcpu->arch.sie_block->todpr = value;
 
 	return 0;
@@ -1589,7 +1589,7 @@ static int handle_sckpf(struct kvm_vcpu *vcpu)
 
 static int handle_ptff(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_ptff++;
+	vcpu->common->stat.instruction_ptff++;
 
 	/* we don't emulate any control instructions yet */
 	kvm_s390_set_psw_cc(vcpu, 3);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 75e81ba26d04..9c36d0c2a8ef 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -27,7 +27,7 @@ EXPORT_SYMBOL_GPL(kvm_s390_pv_is_protected);
 
 bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
 {
-	lockdep_assert_held(&vcpu->mutex);
+	lockdep_assert_held(&vcpu->common->mutex);
 	return !!kvm_s390_pv_cpu_get_handle(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pv_cpu_is_protected);
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 55c34cb35428..cfdc920d2b87 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -306,61 +306,61 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
 
 	switch (order_code) {
 	case SIGP_SENSE:
-		vcpu->stat.instruction_sigp_sense++;
+		vcpu->common->stat.instruction_sigp_sense++;
 		rc = __sigp_sense(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_EXTERNAL_CALL:
-		vcpu->stat.instruction_sigp_external_call++;
+		vcpu->common->stat.instruction_sigp_external_call++;
 		rc = __sigp_external_call(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_EMERGENCY_SIGNAL:
-		vcpu->stat.instruction_sigp_emergency++;
+		vcpu->common->stat.instruction_sigp_emergency++;
 		rc = __sigp_emergency(vcpu, dst_vcpu);
 		break;
 	case SIGP_STOP:
-		vcpu->stat.instruction_sigp_stop++;
+		vcpu->common->stat.instruction_sigp_stop++;
 		rc = __sigp_stop(vcpu, dst_vcpu);
 		break;
 	case SIGP_STOP_AND_STORE_STATUS:
-		vcpu->stat.instruction_sigp_stop_store_status++;
+		vcpu->common->stat.instruction_sigp_stop_store_status++;
 		rc = __sigp_stop_and_store_status(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_STORE_STATUS_AT_ADDRESS:
-		vcpu->stat.instruction_sigp_store_status++;
+		vcpu->common->stat.instruction_sigp_store_status++;
 		rc = __sigp_store_status_at_addr(vcpu, dst_vcpu, parameter,
 						 status_reg);
 		break;
 	case SIGP_SET_PREFIX:
-		vcpu->stat.instruction_sigp_prefix++;
+		vcpu->common->stat.instruction_sigp_prefix++;
 		rc = __sigp_set_prefix(vcpu, dst_vcpu, parameter, status_reg);
 		break;
 	case SIGP_COND_EMERGENCY_SIGNAL:
-		vcpu->stat.instruction_sigp_cond_emergency++;
+		vcpu->common->stat.instruction_sigp_cond_emergency++;
 		rc = __sigp_conditional_emergency(vcpu, dst_vcpu, parameter,
 						  status_reg);
 		break;
 	case SIGP_SENSE_RUNNING:
-		vcpu->stat.instruction_sigp_sense_running++;
+		vcpu->common->stat.instruction_sigp_sense_running++;
 		rc = __sigp_sense_running(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_START:
-		vcpu->stat.instruction_sigp_start++;
+		vcpu->common->stat.instruction_sigp_start++;
 		rc = __prepare_sigp_re_start(vcpu, dst_vcpu, order_code);
 		break;
 	case SIGP_RESTART:
-		vcpu->stat.instruction_sigp_restart++;
+		vcpu->common->stat.instruction_sigp_restart++;
 		rc = __prepare_sigp_re_start(vcpu, dst_vcpu, order_code);
 		break;
 	case SIGP_INITIAL_CPU_RESET:
-		vcpu->stat.instruction_sigp_init_cpu_reset++;
+		vcpu->common->stat.instruction_sigp_init_cpu_reset++;
 		rc = __prepare_sigp_cpu_reset(vcpu, dst_vcpu, order_code);
 		break;
 	case SIGP_CPU_RESET:
-		vcpu->stat.instruction_sigp_cpu_reset++;
+		vcpu->common->stat.instruction_sigp_cpu_reset++;
 		rc = __prepare_sigp_cpu_reset(vcpu, dst_vcpu, order_code);
 		break;
 	default:
-		vcpu->stat.instruction_sigp_unknown++;
+		vcpu->common->stat.instruction_sigp_unknown++;
 		rc = __prepare_sigp_unknown(vcpu, dst_vcpu);
 	}
 
@@ -387,34 +387,34 @@ static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
 		return 0;
 	/* update counters as we're directly dropping to user space */
 	case SIGP_STOP:
-		vcpu->stat.instruction_sigp_stop++;
+		vcpu->common->stat.instruction_sigp_stop++;
 		break;
 	case SIGP_STOP_AND_STORE_STATUS:
-		vcpu->stat.instruction_sigp_stop_store_status++;
+		vcpu->common->stat.instruction_sigp_stop_store_status++;
 		break;
 	case SIGP_STORE_STATUS_AT_ADDRESS:
-		vcpu->stat.instruction_sigp_store_status++;
+		vcpu->common->stat.instruction_sigp_store_status++;
 		break;
 	case SIGP_STORE_ADDITIONAL_STATUS:
-		vcpu->stat.instruction_sigp_store_adtl_status++;
+		vcpu->common->stat.instruction_sigp_store_adtl_status++;
 		break;
 	case SIGP_SET_PREFIX:
-		vcpu->stat.instruction_sigp_prefix++;
+		vcpu->common->stat.instruction_sigp_prefix++;
 		break;
 	case SIGP_START:
-		vcpu->stat.instruction_sigp_start++;
+		vcpu->common->stat.instruction_sigp_start++;
 		break;
 	case SIGP_RESTART:
-		vcpu->stat.instruction_sigp_restart++;
+		vcpu->common->stat.instruction_sigp_restart++;
 		break;
 	case SIGP_INITIAL_CPU_RESET:
-		vcpu->stat.instruction_sigp_init_cpu_reset++;
+		vcpu->common->stat.instruction_sigp_init_cpu_reset++;
 		break;
 	case SIGP_CPU_RESET:
-		vcpu->stat.instruction_sigp_cpu_reset++;
+		vcpu->common->stat.instruction_sigp_cpu_reset++;
 		break;
 	default:
-		vcpu->stat.instruction_sigp_unknown++;
+		vcpu->common->stat.instruction_sigp_unknown++;
 	}
 	VCPU_EVENT(vcpu, 3, "SIGP: order %u for CPU %d handled in userspace",
 		   order_code, cpu_addr);
@@ -427,7 +427,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 	int r1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
 	int r3 = vcpu->arch.sie_block->ipa & 0x000f;
 	u32 parameter;
-	u16 cpu_addr = vcpu->run->s.regs.gprs[r3];
+	u16 cpu_addr = vcpu->common->run->s.regs.gprs[r3];
 	u8 order_code;
 	int rc;
 
@@ -440,21 +440,21 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 		return -EOPNOTSUPP;
 
 	if (r1 % 2)
-		parameter = vcpu->run->s.regs.gprs[r1];
+		parameter = vcpu->common->run->s.regs.gprs[r1];
 	else
-		parameter = vcpu->run->s.regs.gprs[r1 + 1];
+		parameter = vcpu->common->run->s.regs.gprs[r1 + 1];
 
 	trace_kvm_s390_handle_sigp(vcpu, order_code, cpu_addr, parameter);
 	switch (order_code) {
 	case SIGP_SET_ARCHITECTURE:
-		vcpu->stat.instruction_sigp_arch++;
+		vcpu->common->stat.instruction_sigp_arch++;
 		rc = __sigp_set_arch(vcpu, parameter,
-				     &vcpu->run->s.regs.gprs[r1]);
+				     &vcpu->common->run->s.regs.gprs[r1]);
 		break;
 	default:
 		rc = handle_sigp_dst(vcpu, order_code, cpu_addr,
 				     parameter,
-				     &vcpu->run->s.regs.gprs[r1]);
+				     &vcpu->common->run->s.regs.gprs[r1]);
 	}
 
 	if (rc < 0)
@@ -476,7 +476,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu)
 {
 	int r3 = vcpu->arch.sie_block->ipa & 0x000f;
-	u16 cpu_addr = vcpu->run->s.regs.gprs[r3];
+	u16 cpu_addr = vcpu->common->run->s.regs.gprs[r3];
 	struct kvm_vcpu *dest_vcpu;
 	u8 order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
 
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 89cafea4c41f..6a9a0fbfc41d 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1028,7 +1028,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 	case 14:
 		return vsie_page->scb_s.gg14;
 	default:
-		return vcpu->run->s.regs.gprs[reg];
+		return vcpu->common->run->s.regs.gprs[reg];
 	}
 }
 
@@ -1150,7 +1150,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	vcpu->arch.sie_block->prog0c |= PROG_IN_SIE;
 	barrier();
 	if (!kvm_s390_vcpu_sie_inhibited(vcpu))
-		rc = sie64a(scb_s, vcpu->run->s.regs.gprs, gmap_get_enabled()->asce);
+		rc = sie64a(scb_s, vcpu->common->run->s.regs.gprs, gmap_get_enabled()->asce);
 	barrier();
 	vcpu->arch.sie_block->prog0c &= ~PROG_IN_SIE;
 
@@ -1426,7 +1426,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 	unsigned long scb_addr;
 	int rc;
 
-	vcpu->stat.instruction_sie++;
+	vcpu->common->stat.instruction_sie++;
 	if (!test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_SIEF2))
 		return -EOPNOTSUPP;
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 999227fc7c66..2c71b422238a 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -24,7 +24,7 @@ DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, N
 static int vcpu_get_guest_mode(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
-	*val = vcpu->stat.guest_mode;
+	*val = vcpu->common->stat.guest_mode;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f0a94346d00..d95beecd818d 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -337,9 +337,9 @@ static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
 {
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 
-	if (vcpu->run->hyperv.u.syndbg.msr == HV_X64_MSR_SYNDBG_CONTROL)
+	if (vcpu->common->run->hyperv.u.syndbg.msr == HV_X64_MSR_SYNDBG_CONTROL)
 		hv->hv_syndbg.control.status =
-			vcpu->run->hyperv.u.syndbg.status;
+			vcpu->common->run->hyperv.u.syndbg.status;
 	return 1;
 }
 
@@ -1988,7 +1988,7 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
 			kvm_x86_call(flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
 
-		++vcpu->stat.tlb_flush;
+		++vcpu->common->stat.tlb_flush;
 	}
 	return 0;
 
@@ -2387,7 +2387,7 @@ static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
 
 	trace_kvm_hv_hypercall_done(result);
 	kvm_hv_hypercall_set_result(vcpu, result);
-	++vcpu->stat.hypercalls;
+	++vcpu->common->stat.hypercalls;
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
@@ -2399,7 +2399,7 @@ static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
 
 static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 {
-	return kvm_hv_hypercall_complete(vcpu, vcpu->run->hyperv.u.hcall.result);
+	return kvm_hv_hypercall_complete(vcpu, vcpu->common->run->hyperv.u.hcall.result);
 }
 
 static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
@@ -2678,11 +2678,11 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	return kvm_hv_hypercall_complete(vcpu, ret);
 
 hypercall_userspace_exit:
-	vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-	vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
-	vcpu->run->hyperv.u.hcall.input = hc.param;
-	vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
-	vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
+	vcpu->common->run->exit_reason = KVM_EXIT_HYPERV;
+	vcpu->common->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
+	vcpu->common->run->hyperv.u.hcall.input = hc.param;
+	vcpu->common->run->hyperv.u.hcall.params[0] = hc.ingpa;
+	vcpu->common->run->hyperv.u.hcall.params[1] = hc.outgpa;
 	vcpu->arch.complete_userspace_io = kvm_hv_hypercall_complete_userspace;
 	return 0;
 }
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index b1eb46e26b2e..6d99076e570f 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -208,7 +208,7 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
-	vcpu->stat.guest_mode = 1;
+	vcpu->common->stat.guest_mode = 1;
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
@@ -220,7 +220,7 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
 	}
 
-	vcpu->stat.guest_mode = 0;
+	vcpu->common->stat.guest_mode = 0;
 }
 
 static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4915acdbfcd8..e2dd573e4f2d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -173,7 +173,7 @@ bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return kvm_can_post_timer_interrupt(vcpu) && vcpu->mode == IN_GUEST_MODE;
+	return kvm_can_post_timer_interrupt(vcpu) && vcpu->common->mode == IN_GUEST_MODE;
 }
 
 static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
@@ -1564,7 +1564,7 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 static void __report_tpr_access(struct kvm_lapic *apic, bool write)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	kvm_make_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu);
 	run->tpr_access.rip = kvm_rip_read(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 928cf84778b0..a61e68249620 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -658,9 +658,9 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 
 		/*
 		 * Make sure a following spte read is not reordered ahead of the write
-		 * to vcpu->mode.
+		 * to vcpu->common->mode.
 		 */
-		smp_store_mb(vcpu->mode, READING_SHADOW_PAGE_TABLES);
+		smp_store_mb(vcpu->common->mode, READING_SHADOW_PAGE_TABLES);
 	}
 }
 
@@ -670,11 +670,11 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 		kvm_tdp_mmu_walk_lockless_end();
 	} else {
 		/*
-		 * Make sure the write to vcpu->mode is not reordered in front of
+		 * Make sure the write to vcpu->common->mode is not reordered in front of
 		 * reads to sptes.  If it does, kvm_mmu_commit_zap_page() can see us
 		 * OUTSIDE_GUEST_MODE and proceed to free the shadow page table.
 		 */
-		smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
+		smp_store_release(&vcpu->common->mode, OUTSIDE_GUEST_MODE);
 		local_irq_enable();
 	}
 }
@@ -2609,7 +2609,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	/*
 	 * We need to make sure everyone sees our modifications to
-	 * the page tables and see changes to vcpu->mode here. The barrier
+	 * the page tables and see changes to vcpu->common->mode here. The barrier
 	 * in the kvm_flush_remote_tlbs() achieves this. This pairs
 	 * with vcpu_enter_guest and walk_shadow_page_lockless_begin/end.
 	 *
@@ -2880,7 +2880,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool write_fault = fault && fault->write;
 
 	if (unlikely(is_noslot_pfn(pfn))) {
-		vcpu->stat.pf_mmio_spte_created++;
+		vcpu->common->stat.pf_mmio_spte_created++;
 		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
 		return RET_PF_EMULATE;
 	}
@@ -3547,7 +3547,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	walk_shadow_page_lockless_end(vcpu);
 
 	if (ret != RET_PF_INVALID)
-		vcpu->stat.pf_fast++;
+		vcpu->common->stat.pf_fast++;
 
 	return ret;
 }
@@ -4299,7 +4299,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	 * truly spurious and never trigger emulation
 	 */
 	if (r == RET_PF_FIXED)
-		vcpu->stat.pf_fixed++;
+		vcpu->common->stat.pf_fixed++;
 }
 
 static inline u8 kvm_max_level_for_order(int order)
@@ -5997,7 +5997,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		vcpu->stat.pf_taken++;
+		vcpu->common->stat.pf_taken++;
 
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type, NULL);
@@ -6009,11 +6009,11 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		return r;
 
 	if (r == RET_PF_FIXED)
-		vcpu->stat.pf_fixed++;
+		vcpu->common->stat.pf_fixed++;
 	else if (r == RET_PF_EMULATE)
-		vcpu->stat.pf_emulate++;
+		vcpu->common->stat.pf_emulate++;
 	else if (r == RET_PF_SPURIOUS)
-		vcpu->stat.pf_spurious++;
+		vcpu->common->stat.pf_spurious++;
 
 	if (r != RET_PF_EMULATE)
 		return 1;
@@ -6145,7 +6145,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 	 * done here for them.
 	 */
 	kvm_mmu_invalidate_addr(vcpu, vcpu->arch.walk_mmu, gva, KVM_MMU_ROOTS_ALL);
-	++vcpu->stat.invlpg;
+	++vcpu->common->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
 
@@ -6167,7 +6167,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 
 	if (roots)
 		kvm_mmu_invalidate_addr(vcpu, mmu, gva, roots);
-	++vcpu->stat.invlpg;
+	++vcpu->common->stat.invlpg;
 
 	/*
 	 * Mappings not reachable via the current cr3 or the prev_roots will be
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c7dc49ee7388..edc6d0594d1c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1053,7 +1053,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
 	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
-		vcpu->stat.pf_mmio_spte_created++;
+		vcpu->common->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
 		ret = RET_PF_EMULATE;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 47a46283c866..599827b14fcd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -503,7 +503,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 
 	/*
 	 * The reprogramming bitmap can be written asynchronously by something
-	 * other than the task that holds vcpu->mutex, take care to clear only
+	 * other than the task that holds vcpu->common->mutex, take care to clear only
 	 * the bits that will actually processed.
 	 */
 	BUILD_BUG_ON(sizeof(bitmap) != sizeof(atomic64_t));
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6f704c1037e5..521b3e9ce60a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1795,10 +1795,10 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 			return false;
 
 	if (!nested_svm_vmrun_msrpm(svm)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->internal.suberror =
 			KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		vcpu->common->run->internal.ndata = 0;
 		return false;
 	}
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 25d5fe0dab5a..2ad1b9b497e0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -825,7 +825,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	int i;
 
 	/* Check some debug related fields before encrypting the VMSA */
-	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
+	if (svm->vcpu.common->guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
 		return -EINVAL;
 
 	/*
@@ -916,7 +916,7 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
 
-	if (vcpu->guest_debug) {
+	if (vcpu->common->guest_debug) {
 		pr_warn_once("KVM_SET_GUEST_DEBUG for SEV-ES guest is not supported");
 		return -EINVAL;
 	}
@@ -970,13 +970,13 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -ENOTTY;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		ret = mutex_lock_killable(&vcpu->mutex);
+		ret = mutex_lock_killable(&vcpu->common->mutex);
 		if (ret)
 			return ret;
 
 		ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
 
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 		if (ret)
 			return ret;
 	}
@@ -1931,7 +1931,7 @@ static int sev_lock_vcpus_for_migration(struct kvm *kvm,
 	unsigned long i, j;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (mutex_lock_killable_nested(&vcpu->mutex, role))
+		if (mutex_lock_killable_nested(&vcpu->common->mutex, role))
 			goto out_unlock;
 
 #ifdef CONFIG_PROVE_LOCKING
@@ -1942,7 +1942,7 @@ static int sev_lock_vcpus_for_migration(struct kvm *kvm,
 			 */
 			role = SEV_NR_MIGRATION_ROLES;
 		else
-			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
+			mutex_release(&vcpu->common->mutex.dep_map, _THIS_IP_);
 #endif
 	}
 
@@ -1956,10 +1956,10 @@ static int sev_lock_vcpus_for_migration(struct kvm *kvm,
 
 #ifdef CONFIG_PROVE_LOCKING
 		if (j)
-			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
+			mutex_acquire(&vcpu->common->mutex.dep_map, role, 0, _THIS_IP_);
 #endif
 
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 	}
 	return -EINTR;
 }
@@ -1974,10 +1974,10 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
 		if (first)
 			first = false;
 		else
-			mutex_acquire(&vcpu->mutex.dep_map,
+			mutex_acquire(&vcpu->common->mutex.dep_map,
 				      SEV_NR_MIGRATION_ROLES, 0, _THIS_IP_);
 
-		mutex_unlock(&vcpu->mutex);
+		mutex_unlock(&vcpu->common->mutex);
 	}
 }
 
@@ -3697,7 +3697,7 @@ static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (vcpu->run->hypercall.ret)
+	if (vcpu->common->run->hypercall.ret)
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
 	else
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP);
@@ -3721,14 +3721,14 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 		return 1; /* resume guest */
 	}
 
-	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
-	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
-	vcpu->run->hypercall.args[0] = gpa;
-	vcpu->run->hypercall.args[1] = 1;
-	vcpu->run->hypercall.args[2] = (op == SNP_PAGE_STATE_PRIVATE)
+	vcpu->common->run->exit_reason = KVM_EXIT_HYPERCALL;
+	vcpu->common->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+	vcpu->common->run->hypercall.args[0] = gpa;
+	vcpu->common->run->hypercall.args[1] = 1;
+	vcpu->common->run->hypercall.args[2] = (op == SNP_PAGE_STATE_PRIVATE)
 				       ? KVM_MAP_GPA_RANGE_ENCRYPTED
 				       : KVM_MAP_GPA_RANGE_DECRYPTED;
-	vcpu->run->hypercall.args[2] |= KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
+	vcpu->common->run->hypercall.args[2] |= KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
 
 	vcpu->arch.complete_userspace_io = snp_complete_psc_msr;
 
@@ -3777,7 +3777,7 @@ static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 
-	if (vcpu->run->hypercall.ret) {
+	if (vcpu->common->run->hypercall.ret) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1; /* resume guest */
 	}
@@ -3884,14 +3884,14 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	switch (entry_start.operation) {
 	case VMGEXIT_PSC_OP_PRIVATE:
 	case VMGEXIT_PSC_OP_SHARED:
-		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
-		vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
-		vcpu->run->hypercall.args[0] = gfn_to_gpa(gfn);
-		vcpu->run->hypercall.args[1] = npages;
-		vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
+		vcpu->common->run->exit_reason = KVM_EXIT_HYPERCALL;
+		vcpu->common->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+		vcpu->common->run->hypercall.args[0] = gfn_to_gpa(gfn);
+		vcpu->common->run->hypercall.args[1] = npages;
+		vcpu->common->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
 					       ? KVM_MAP_GPA_RANGE_ENCRYPTED
 					       : KVM_MAP_GPA_RANGE_DECRYPTED;
-		vcpu->run->hypercall.args[2] |= entry_start.pagesize
+		vcpu->common->run->hypercall.args[2] |= entry_start.pagesize
 						? KVM_MAP_GPA_RANGE_PAGE_SZ_2M
 						: KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
 		vcpu->arch.complete_userspace_io = snp_complete_one_psc;
@@ -4578,10 +4578,10 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	return ret;
 
 out_terminate:
-	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
-	vcpu->run->system_event.ndata = 1;
-	vcpu->run->system_event.data[0] = control->ghcb_gpa;
+	vcpu->common->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->common->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+	vcpu->common->run->system_event.ndata = 1;
+	vcpu->common->run->system_event.data[0] = control->ghcb_gpa;
 
 	return 0;
 }
@@ -4656,7 +4656,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					    svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
-		++vcpu->stat.nmi_window_exits;
+		++vcpu->common->stat.nmi_window_exits;
 		svm->nmi_masked = false;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		ret = 1;
@@ -4695,10 +4695,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_TERM_REQUEST:
 		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
 			control->exit_info_1, control->exit_info_2);
-		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
-		vcpu->run->system_event.ndata = 1;
-		vcpu->run->system_event.data[0] = control->ghcb_gpa;
+		vcpu->common->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		vcpu->common->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->common->run->system_event.ndata = 1;
+		vcpu->common->run->system_event.data[0] = control->ghcb_gpa;
 		break;
 	case SVM_VMGEXIT_PSC:
 		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 632c74cb41f4..478cd15bb9f2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1064,7 +1064,7 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
 {
 	svm->nmi_singlestep = false;
 
-	if (!(svm->vcpu.guest_debug & KVM_GUESTDBG_SINGLESTEP)) {
+	if (!(svm->vcpu.common->guest_debug & KVM_GUESTDBG_SINGLESTEP)) {
 		/* Clear our flags if they were not set by the guest */
 		if (!(svm->nmi_singlestep_guest_rflags & X86_EFLAGS_TF))
 			svm->vmcb->save.rflags &= ~X86_EFLAGS_TF;
@@ -1554,7 +1554,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
-	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
+	if (vcpu->common->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 
 	if (sd->current_vmcb != svm->vmcb) {
@@ -1574,7 +1574,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 
 	svm_prepare_host_switch(vcpu);
 
-	++vcpu->stat.host_state_reload;
+	++vcpu->common->stat.host_state_reload;
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
@@ -1976,8 +1976,8 @@ static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
 
 	clr_exception_intercept(svm, BP_VECTOR);
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_ENABLE) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_SW_BP)
 			set_exception_intercept(svm, BP_VECTOR);
 	}
 }
@@ -2087,10 +2087,10 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 
 static int db_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!(vcpu->guest_debug &
+	if (!(vcpu->common->guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
 		u32 payload = svm->vmcb->save.dr6 ^ DR6_ACTIVE_LOW;
@@ -2104,7 +2104,7 @@ static int db_interception(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
 
-	if (vcpu->guest_debug &
+	if (vcpu->common->guest_debug &
 	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.dr6 = svm->vmcb->save.dr6;
@@ -2121,7 +2121,7 @@ static int db_interception(struct kvm_vcpu *vcpu)
 static int bp_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 
 	kvm_run->exit_reason = KVM_EXIT_DEBUG;
 	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
@@ -2207,7 +2207,7 @@ static int mc_interception(struct kvm_vcpu *vcpu)
 
 static int shutdown_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 
@@ -2238,7 +2238,7 @@ static int io_interception(struct kvm_vcpu *vcpu)
 	int size, in, string;
 	unsigned port;
 
-	++vcpu->stat.io_exits;
+	++vcpu->common->stat.io_exits;
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
 	port = io_info >> 16;
@@ -2268,7 +2268,7 @@ static int smi_interception(struct kvm_vcpu *vcpu)
 
 static int intr_interception(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.irq_exits;
+	++vcpu->common->stat.irq_exits;
 	return 1;
 }
 
@@ -2592,7 +2592,7 @@ static int iret_interception(struct kvm_vcpu *vcpu)
 
 	WARN_ON_ONCE(sev_es_guest(vcpu->kvm));
 
-	++vcpu->stat.nmi_window_exits;
+	++vcpu->common->stat.nmi_window_exits;
 	svm->awaiting_iret_completion = true;
 
 	svm_clr_iret_intercept(svm);
@@ -2767,7 +2767,7 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 	if (sev_es_guest(vcpu->kvm))
 		return 1;
 
-	if (vcpu->guest_debug == 0) {
+	if (vcpu->common->guest_debug == 0) {
 		/*
 		 * No more DR vmexits; force a reload of the debug registers
 		 * and reenter on this instruction.  The next vmexit will
@@ -2804,7 +2804,7 @@ static int cr8_write_interception(struct kvm_vcpu *vcpu)
 		return r;
 	if (cr8_prev <= kvm_get_cr8(vcpu))
 		return r;
-	vcpu->run->exit_reason = KVM_EXIT_SET_TPR;
+	vcpu->common->run->exit_reason = KVM_EXIT_SET_TPR;
 	return 0;
 }
 
@@ -3231,7 +3231,7 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	 */
 	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
 
-	++vcpu->stat.irq_window_exits;
+	++vcpu->common->stat.irq_window_exits;
 	return 1;
 }
 
@@ -3482,11 +3482,11 @@ static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 {
 	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
 	dump_vmcb(vcpu);
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_code;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->common->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->common->run->internal.ndata = 2;
+	vcpu->common->run->internal.data[0] = exit_code;
+	vcpu->common->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 	return 0;
 }
 
@@ -3530,7 +3530,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
@@ -3612,7 +3612,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 		svm->nmi_masked = true;
 		svm_set_iret_intercept(svm);
 	}
-	++vcpu->stat.nmi_injections;
+	++vcpu->common->stat.nmi_injections;
 }
 
 static bool svm_is_vnmi_pending(struct kvm_vcpu *vcpu)
@@ -3643,7 +3643,7 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
 	 * the NMI is "injected", but for all intents and purposes, passing the
 	 * NMI off to hardware counts as injection.
 	 */
-	++vcpu->stat.nmi_injections;
+	++vcpu->common->stat.nmi_injections;
 
 	return true;
 }
@@ -3664,7 +3664,7 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
 			   vcpu->arch.interrupt.soft, reinjected);
-	++vcpu->stat.irq_injections;
+	++vcpu->common->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
 				       SVM_EVTINJ_VALID | type;
@@ -3674,10 +3674,10 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vector)
 {
 	/*
-	 * apic->apicv_active must be read after vcpu->mode.
+	 * apic->apicv_active must be read after vcpu->common->mode.
 	 * Pairs with smp_store_release in vcpu_enter_guest.
 	 */
-	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
+	bool in_guest_mode = (smp_load_acquire(&vcpu->common->mode) == IN_GUEST_MODE);
 
 	/* Note, this is called iff the local APIC is in-kernel. */
 	if (!READ_ONCE(vcpu->arch.apic->apicv_active)) {
@@ -4292,7 +4292,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		/* Track VMRUNs that have made past consistency checking */
 		if (svm->nested.nested_run_pending &&
 		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
-                        ++vcpu->stat.nested_run;
+                        ++vcpu->common->stat.nested_run;
 
 		svm->nested.nested_run_pending = 0;
 	}
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254d..9e02425a9c4e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3281,10 +3281,10 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		} else {
 			pr_debug_ratelimited("%s: no backing for APIC-access address in vmcs12\n",
 					     __func__);
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
+			vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->common->run->internal.suberror =
 				KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+			vcpu->common->run->internal.ndata = 0;
 			return false;
 		}
 	}
@@ -3355,10 +3355,10 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	if (!nested_get_evmcs_page(vcpu)) {
 		pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
 				     __func__);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->internal.suberror =
 			KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		vcpu->common->run->internal.ndata = 0;
 
 		return false;
 	}
@@ -4733,7 +4733,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 		 * and vcpu->arch.dr7 is not squirreled away before the
 		 * nested VMENTER (not worth adding a variable in nested_vmx).
 		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP)
 			kvm_set_dr(vcpu, 7, DR7_FIXED_1);
 		else
 			WARN_ON(kvm_set_dr(vcpu, 7, vmcs_readl(GUEST_DR7)));
@@ -6261,11 +6261,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 			return vcpu->arch.apf.host_apf_flags ||
 			       vmx_need_pf_intercept(vcpu);
 		else if (is_debug(intr_info) &&
-			 vcpu->guest_debug &
+			 vcpu->common->guest_debug &
 			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
 			return true;
 		else if (is_breakpoint(intr_info) &&
-			 vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+			 vcpu->common->guest_debug & KVM_GUESTDBG_USE_SW_BP)
 			return true;
 		else if (is_alignment_check(intr_info) &&
 			 !vmx_guest_inject_ac(vcpu))
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..64fff7e2d487 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -208,7 +208,7 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 	 * as blocking and preempted, e.g. if it's preempted between setting
 	 * its wait state and manually scheduling out.
 	 */
-	if (vcpu->preempted)
+	if (vcpu->common->preempted)
 		pi_set_sn(pi_desc);
 }
 
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6fef01e0536e..5487a4abfe0f 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -394,8 +394,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
 		if (leaf == EINIT)
 			return handle_encls_einit(vcpu);
 		WARN_ONCE(1, "unexpected exit on ENCLS[%u]", leaf);
-		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
-		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
+		vcpu->common->run->exit_reason = KVM_EXIT_UNKNOWN;
+		vcpu->common->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
 		return 0;
 	}
 	return 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..3af12f593f57 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -887,7 +887,7 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	 */
 	if (enable_vmware_backdoor)
 		eb |= (1u << GP_VECTOR);
-	if ((vcpu->guest_debug &
+	if ((vcpu->common->guest_debug &
 	     (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)) ==
 	    (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP))
 		eb |= 1u << BP_VECTOR;
@@ -1362,7 +1362,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 
 	host_state = &vmx->loaded_vmcs->host_state;
 
-	++vmx->vcpu.stat.host_state_reload;
+	++vmx->vcpu.common->stat.host_state_reload;
 
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
@@ -1519,7 +1519,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
+	if (vcpu->common->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
@@ -4174,7 +4174,7 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 						     int pi_vec)
 {
 #ifdef CONFIG_SMP
-	if (vcpu->mode == IN_GUEST_MODE) {
+	if (vcpu->common->mode == IN_GUEST_MODE) {
 		/*
 		 * The vector of the virtual has already been set in the PIR.
 		 * Send a notification event to deliver the virtual interrupt
@@ -4229,14 +4229,14 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 		/*
-		 * This pairs with the smp_mb_*() after setting vcpu->mode in
+		 * This pairs with the smp_mb_*() after setting vcpu->common->mode in
 		 * vcpu_enter_guest() to guarantee the vCPU sees the event
 		 * request if triggering a posted interrupt "fails" because
-		 * vcpu->mode != IN_GUEST_MODE.  The extra barrier is needed as
+		 * vcpu->common->mode != IN_GUEST_MODE.  The extra barrier is needed as
 		 * the smb_wmb() in kvm_make_request() only ensures everything
 		 * done before making the request is visible when the request
 		 * is visible, it doesn't ensure ordering between the store to
-		 * vcpu->requests and the load from vcpu->mode.
+		 * vcpu->requests and the load from vcpu->common->mode.
 		 */
 		smp_mb__after_atomic();
 
@@ -4275,9 +4275,9 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 
 	/*
 	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
-	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
+	 * after setting vcpu->common->mode in vcpu_enter_guest(), thus the vCPU is
 	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
-	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
+	 * posted interrupt "fails" because vcpu->common->mode != IN_GUEST_MODE.
 	 */
 	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
 	return 0;
@@ -4953,7 +4953,7 @@ void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
 	trace_kvm_inj_virq(irq, vcpu->arch.interrupt.soft, reinjected);
 
-	++vcpu->stat.irq_injections;
+	++vcpu->common->stat.irq_injections;
 	if (vmx->rmode.vm86_active) {
 		int inc_eip = 0;
 		if (vcpu->arch.interrupt.soft)
@@ -4990,7 +4990,7 @@ void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->vnmi_blocked_time = 0;
 	}
 
-	++vcpu->stat.nmi_injections;
+	++vcpu->common->stat.nmi_injections;
 	vmx->loaded_vmcs->nmi_known_unmasked = false;
 
 	if (vmx->rmode.vm86_active) {
@@ -5129,11 +5129,11 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
 		 */
 		to_vmx(vcpu)->vcpu.arch.event_exit_inst_len =
 			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_SW_BP)
 			return false;
 		fallthrough;
 	case DB_VECTOR:
-		return !(vcpu->guest_debug &
+		return !(vcpu->common->guest_debug &
 			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP));
 	case DE_VECTOR:
 	case OF_VECTOR:
@@ -5204,7 +5204,7 @@ bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu)
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 	u32 intr_info, ex_no, error_code;
 	unsigned long cr2, dr6;
 	u32 vect_info;
@@ -5270,13 +5270,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	 */
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
 	    !(is_page_fault(intr_info) && !(error_code & PFERR_RSVD_MASK))) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_SIMUL_EX;
-		vcpu->run->internal.ndata = 4;
-		vcpu->run->internal.data[0] = vect_info;
-		vcpu->run->internal.data[1] = intr_info;
-		vcpu->run->internal.data[2] = error_code;
-		vcpu->run->internal.data[3] = vcpu->arch.last_vmentry_cpu;
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->internal.suberror = KVM_INTERNAL_ERROR_SIMUL_EX;
+		vcpu->common->run->internal.ndata = 4;
+		vcpu->common->run->internal.data[0] = vect_info;
+		vcpu->common->run->internal.data[1] = intr_info;
+		vcpu->common->run->internal.data[2] = error_code;
+		vcpu->common->run->internal.data[3] = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
@@ -5302,7 +5302,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	switch (ex_no) {
 	case DB_VECTOR:
 		dr6 = vmx_get_exit_qual(vcpu);
-		if (!(vcpu->guest_debug &
+		if (!(vcpu->common->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
 			/*
 			 * If the #DB was due to ICEBP, a.k.a. INT1, skip the
@@ -5377,14 +5377,14 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.irq_exits;
+	++vcpu->common->stat.irq_exits;
 	return 1;
 }
 
 static int handle_triple_fault(struct kvm_vcpu *vcpu)
 {
-	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
-	vcpu->mmio_needed = 0;
+	vcpu->common->run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->common->mmio_needed = 0;
 	return 0;
 }
 
@@ -5397,7 +5397,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	string = (exit_qualification & 16) != 0;
 
-	++vcpu->stat.io_exits;
+	++vcpu->common->stat.io_exits;
 
 	if (string)
 		return kvm_emulate_instruction(vcpu, 0);
@@ -5516,7 +5516,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 				 * KVM_GUESTDBG_SINGLESTEP-triggered
 				 * KVM_EXIT_DEBUG here.
 				 */
-				vcpu->run->exit_reason = KVM_EXIT_SET_TPR;
+				vcpu->common->run->exit_reason = KVM_EXIT_SET_TPR;
 				return 0;
 			}
 		}
@@ -5549,7 +5549,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	default:
 		break;
 	}
-	vcpu->run->exit_reason = 0;
+	vcpu->common->run->exit_reason = 0;
 	vcpu_unimpl(vcpu, "unhandled control register: op %d cr %d\n",
 	       (int)(exit_qualification >> 4) & 3, cr);
 	return 0;
@@ -5578,12 +5578,12 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		 * need to emulate the latter, either for the host or the
 		 * guest debugging itself.
 		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
-			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_ACTIVE_LOW;
-			vcpu->run->debug.arch.dr7 = dr7;
-			vcpu->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
-			vcpu->run->debug.arch.exception = DB_VECTOR;
-			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
+			vcpu->common->run->debug.arch.dr6 = DR6_BD | DR6_ACTIVE_LOW;
+			vcpu->common->run->debug.arch.dr7 = dr7;
+			vcpu->common->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
+			vcpu->common->run->debug.arch.exception = DB_VECTOR;
+			vcpu->common->run->exit_reason = KVM_EXIT_DEBUG;
 			return 0;
 		} else {
 			kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BD);
@@ -5591,7 +5591,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (vcpu->guest_debug == 0) {
+	if (vcpu->common->guest_debug == 0) {
 		exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
 
 		/*
@@ -5651,7 +5651,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
-	++vcpu->stat.irq_window_exits;
+	++vcpu->common->stat.irq_window_exits;
 	return 1;
 }
 
@@ -5848,7 +5848,7 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu)
 		return -EIO;
 
 	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
-	++vcpu->stat.nmi_window_exits;
+	++vcpu->common->stat.nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	return 1;
@@ -6075,7 +6075,7 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
 	bool context_invalid = exit_qual & NOTIFY_VM_CONTEXT_INVALID;
 
-	++vcpu->stat.notify_window_exits;
+	++vcpu->common->stat.notify_window_exits;
 
 	/*
 	 * Notify VM exit happened while executing iret from NMI,
@@ -6087,8 +6087,8 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 
 	if (vcpu->kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_USER ||
 	    context_invalid) {
-		vcpu->run->exit_reason = KVM_EXIT_NOTIFY;
-		vcpu->run->notify.flags = context_invalid ?
+		vcpu->common->run->exit_reason = KVM_EXIT_NOTIFY;
+		vcpu->common->run->notify.flags = context_invalid ?
 					  KVM_NOTIFY_CONTEXT_INVALID : 0;
 		return 0;
 	}
@@ -6516,19 +6516,19 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	if (exit_reason.failed_vmentry) {
 		dump_vmcs(vcpu);
-		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-		vcpu->run->fail_entry.hardware_entry_failure_reason
+		vcpu->common->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		vcpu->common->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason.full;
-		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
+		vcpu->common->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
 	if (unlikely(vmx->fail)) {
 		dump_vmcs(vcpu);
-		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-		vcpu->run->fail_entry.hardware_entry_failure_reason
+		vcpu->common->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		vcpu->common->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
-		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
+		vcpu->common->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
@@ -6548,17 +6548,17 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
 		int ndata = 3;
 
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
-		vcpu->run->internal.data[0] = vectoring_info;
-		vcpu->run->internal.data[1] = exit_reason.full;
-		vcpu->run->internal.data[2] = vmx_get_exit_qual(vcpu);
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
+		vcpu->common->run->internal.data[0] = vectoring_info;
+		vcpu->common->run->internal.data[1] = exit_reason.full;
+		vcpu->common->run->internal.data[2] = vmx_get_exit_qual(vcpu);
 		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
-			vcpu->run->internal.data[ndata++] =
+			vcpu->common->run->internal.data[ndata++] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 		}
-		vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
-		vcpu->run->internal.ndata = ndata;
+		vcpu->common->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
+		vcpu->common->run->internal.ndata = ndata;
 		return 0;
 	}
 
@@ -6612,12 +6612,12 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 		    exit_reason.full);
 	dump_vmcs(vcpu);
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror =
+	vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->common->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_reason.full;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	vcpu->common->run->internal.ndata = 2;
+	vcpu->common->run->internal.data[0] = exit_reason.full;
+	vcpu->common->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 	return 0;
 }
 
@@ -6631,9 +6631,9 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 */
 	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
 		if (ret > 0)
-			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
+			vcpu->common->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
 
-		vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
+		vcpu->common->run->flags |= KVM_RUN_X86_BUS_LOCK;
 		return 0;
 	}
 	return ret;
@@ -6680,7 +6680,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 			return;
 	}
 
-	vcpu->stat.l1d_flush++;
+	vcpu->common->stat.l1d_flush++;
 
 	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
 		native_wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
@@ -7401,7 +7401,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	 * vmentry fails as it then expects bit 14 (BS) in pending debug
 	 * exceptions being set, but that's not correct for the guest debugging
 	 * case. */
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
 	kvm_load_guest_xsave_state(vcpu);
@@ -7458,7 +7458,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		 */
 		if (vmx->nested.nested_run_pending &&
 		    !vmx->exit_reason.failed_vmentry)
-			++vcpu->stat.nested_run;
+			++vcpu->common->stat.nested_run;
 
 		vmx->nested.nested_run_pending = 0;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3efc3a89499c..e646b4042963 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -764,7 +764,7 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
 
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
-	++vcpu->stat.pf_guest;
+	++vcpu->common->stat.pf_guest;
 
 	/*
 	 * Async #PF in L2 is always forwarded to L1 as a VM-Exit regardless of
@@ -1318,7 +1318,7 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 {
 	int i;
 
-	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
+	if (!(vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
 		for (i = 0; i < KVM_NR_DB_REGS; i++)
 			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
 	}
@@ -1328,7 +1328,7 @@ void kvm_update_dr7(struct kvm_vcpu *vcpu)
 {
 	unsigned long dr7;
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP)
 		dr7 = vcpu->arch.guest_debug_dr7;
 	else
 		dr7 = vcpu->arch.dr7;
@@ -1358,7 +1358,7 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 	switch (dr) {
 	case 0 ... 3:
 		vcpu->arch.db[array_index_nospec(dr, size)] = val;
-		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
+		if (!(vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 			vcpu->arch.eff_db[dr] = val;
 		break;
 	case 4:
@@ -1970,15 +1970,15 @@ EXPORT_SYMBOL_GPL(kvm_set_msr);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->run->msr.error) {
-		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
-		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
+	if (!vcpu->common->run->msr.error) {
+		kvm_rax_write(vcpu, (u32)vcpu->common->run->msr.data);
+		kvm_rdx_write(vcpu, vcpu->common->run->msr.data >> 32);
 	}
 }
 
 static int complete_emulated_msr_access(struct kvm_vcpu *vcpu)
 {
-	return complete_emulated_insn_gp(vcpu, vcpu->run->msr.error);
+	return complete_emulated_insn_gp(vcpu, vcpu->common->run->msr.error);
 }
 
 static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
@@ -1989,7 +1989,7 @@ static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
 
 static int complete_fast_msr_access(struct kvm_vcpu *vcpu)
 {
-	return kvm_x86_call(complete_emulated_msr)(vcpu, vcpu->run->msr.error);
+	return kvm_x86_call(complete_emulated_msr)(vcpu, vcpu->common->run->msr.error);
 }
 
 static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
@@ -2021,12 +2021,12 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 	if (!(vcpu->kvm->arch.user_space_msr_mask & msr_reason))
 		return 0;
 
-	vcpu->run->exit_reason = exit_reason;
-	vcpu->run->msr.error = 0;
-	memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
-	vcpu->run->msr.reason = msr_reason;
-	vcpu->run->msr.index = index;
-	vcpu->run->msr.data = data;
+	vcpu->common->run->exit_reason = exit_reason;
+	vcpu->common->run->msr.error = 0;
+	memset(vcpu->common->run->msr.pad, 0, sizeof(vcpu->common->run->msr.pad));
+	vcpu->common->run->msr.reason = msr_reason;
+	vcpu->common->run->msr.index = index;
+	vcpu->common->run->msr.data = data;
 	vcpu->arch.complete_userspace_io = completion;
 
 	return 1;
@@ -2126,7 +2126,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_monitor);
 static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
 	xfer_to_guest_mode_prepare();
-	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
+	return vcpu->common->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
 		xfer_to_guest_mode_work_pending();
 }
 
@@ -3596,7 +3596,7 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 
 static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
+	++vcpu->common->stat.tlb_flush;
 	kvm_x86_call(flush_tlb_all)(vcpu);
 
 	/* Flushing all ASIDs flushes the current ASID... */
@@ -3605,7 +3605,7 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
+	++vcpu->common->stat.tlb_flush;
 
 	if (!tdp_enabled) {
 		/*
@@ -3630,7 +3630,7 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 
 static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
+	++vcpu->common->stat.tlb_flush;
 	kvm_x86_call(flush_tlb_current)(vcpu);
 }
 
@@ -4993,7 +4993,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vcpu->arch.l1tf_flush_l1d = true;
 
-	if (vcpu->scheduled_out && pmu->version && pmu->event_count) {
+	if (vcpu->common->scheduled_out && pmu->version && pmu->event_count) {
 		pmu->need_cleanup = true;
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
@@ -5065,11 +5065,11 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	 * preempted if and only if the VM-Exit was due to a host interrupt.
 	 */
 	if (!vcpu->arch.at_instruction_boundary) {
-		vcpu->stat.preemption_other++;
+		vcpu->common->stat.preemption_other++;
 		return;
 	}
 
-	vcpu->stat.preemption_reported++;
+	vcpu->common->stat.preemption_reported++;
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -5100,7 +5100,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted) {
+	if (vcpu->common->preempted) {
 		vcpu->arch.preempted_in_kernel = kvm_arch_vcpu_in_kernel(vcpu);
 
 		/*
@@ -7867,10 +7867,10 @@ struct read_write_emulator_ops {
 
 static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 {
-	if (vcpu->mmio_read_completed) {
+	if (vcpu->common->mmio_read_completed) {
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
-			       vcpu->mmio_fragments[0].gpa, val);
-		vcpu->mmio_read_completed = 0;
+			       vcpu->common->mmio_fragments[0].gpa, val);
+		vcpu->common->mmio_read_completed = 0;
 		return 1;
 	}
 
@@ -7905,9 +7905,9 @@ static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			   void *val, int bytes)
 {
-	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
+	struct kvm_mmio_fragment *frag = &vcpu->common->mmio_fragments[0];
 
-	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
+	memcpy(vcpu->common->run->mmio.data, frag->data, min(8u, frag->len));
 	return X86EMUL_CONTINUE;
 }
 
@@ -7968,8 +7968,8 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	bytes -= handled;
 	val += handled;
 
-	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
-	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
+	WARN_ON(vcpu->common->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
+	frag = &vcpu->common->mmio_fragments[vcpu->common->mmio_nr_fragments++];
 	frag->gpa = gpa;
 	frag->data = val;
 	frag->len = bytes;
@@ -7990,7 +7990,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 		  ops->read_write_prepare(vcpu, val, bytes))
 		return X86EMUL_CONTINUE;
 
-	vcpu->mmio_nr_fragments = 0;
+	vcpu->common->mmio_nr_fragments = 0;
 
 	/* Crossing a page boundary? */
 	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
@@ -8014,18 +8014,18 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	if (!vcpu->mmio_nr_fragments)
+	if (!vcpu->common->mmio_nr_fragments)
 		return rc;
 
-	gpa = vcpu->mmio_fragments[0].gpa;
+	gpa = vcpu->common->mmio_fragments[0].gpa;
 
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
+	vcpu->common->mmio_needed = 1;
+	vcpu->common->mmio_cur_fragment = 0;
 
-	vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
-	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->common->run->mmio.len = min(8u, vcpu->common->mmio_fragments[0].len);
+	vcpu->common->run->mmio.is_write = vcpu->common->mmio_is_write = ops->write;
+	vcpu->common->run->exit_reason = KVM_EXIT_MMIO;
+	vcpu->common->run->mmio.phys_addr = gpa;
 
 	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
 }
@@ -8178,12 +8178,12 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	else
 		memcpy(vcpu->arch.pio_data, data, size * count);
 
-	vcpu->run->exit_reason = KVM_EXIT_IO;
-	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
-	vcpu->run->io.size = size;
-	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
-	vcpu->run->io.count = count;
-	vcpu->run->io.port = port;
+	vcpu->common->run->exit_reason = KVM_EXIT_IO;
+	vcpu->common->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
+	vcpu->common->run->io.size = size;
+	vcpu->common->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
+	vcpu->common->run->io.count = count;
+	vcpu->common->run->io.port = port;
 	return 0;
 }
 
@@ -8767,7 +8767,7 @@ EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
 					   u8 ndata, u8 *insn_bytes, u8 insn_size)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	u64 info[5];
 	u8 info_start;
 
@@ -8839,7 +8839,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	++vcpu->stat.insn_emulation_fail;
+	++vcpu->common->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
 	if (emulation_type & EMULTYPE_VMWARE_GP) {
@@ -8998,9 +8998,9 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 
 static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		kvm_run->debug.arch.dr6 = DR6_BS | DR6_ACTIVE_LOW;
 		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
@@ -9074,9 +9074,9 @@ static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 			      EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP | EMULTYPE_PF))
 		return false;
 
-	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
+	if (unlikely(vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
 	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
-		struct kvm_run *kvm_run = vcpu->run;
+		struct kvm_run *kvm_run = vcpu->common->run;
 		unsigned long eip = kvm_get_linear_rip(vcpu);
 		u32 dr6 = kvm_vcpu_check_hw_bp(eip, 0,
 					   vcpu->arch.guest_debug_dr7,
@@ -9161,7 +9161,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
-	++vcpu->stat.insn_emulation;
+	++vcpu->common->stat.insn_emulation;
 
 	return r;
 }
@@ -9290,8 +9290,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	}
 
 	if (ctxt->have_exception) {
-		WARN_ON_ONCE(vcpu->mmio_needed && !vcpu->mmio_is_write);
-		vcpu->mmio_needed = false;
+		WARN_ON_ONCE(vcpu->common->mmio_needed && !vcpu->common->mmio_is_write);
+		vcpu->common->mmio_needed = false;
 		r = 1;
 		inject_emulated_exception(vcpu);
 	} else if (vcpu->arch.pio.count) {
@@ -9303,10 +9303,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			vcpu->arch.complete_userspace_io = complete_emulated_pio;
 		}
 		r = 0;
-	} else if (vcpu->mmio_needed) {
-		++vcpu->stat.mmio_exits;
+	} else if (vcpu->common->mmio_needed) {
+		++vcpu->common->stat.mmio_exits;
 
-		if (!vcpu->mmio_is_write)
+		if (!vcpu->common->mmio_is_write)
 			writeback = false;
 		r = 0;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
@@ -9335,7 +9335,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			if (ctxt->is_branch)
 				kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
 			kvm_rip_write(vcpu, ctxt->eip);
-			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
+			if (r && (ctxt->tf || (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
 			kvm_x86_call(update_emulated_instruction)(vcpu);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
@@ -9933,12 +9933,12 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	 * managed by userspace, in which case userspace is responsible for
 	 * handling wake events.
 	 */
-	++vcpu->stat.halt_exits;
+	++vcpu->common->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
 		vcpu->arch.mp_state = state;
 		return 1;
 	} else {
-		vcpu->run->exit_reason = reason;
+		vcpu->common->run->exit_reason = reason;
 		return 0;
 	}
 }
@@ -10073,7 +10073,7 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	struct kvm_vcpu *target = NULL;
 	struct kvm_apic_map *map;
 
-	vcpu->stat.directed_yield_attempted++;
+	vcpu->common->stat.directed_yield_attempted++;
 
 	if (single_task_running())
 		goto no_yield;
@@ -10086,7 +10086,7 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 
 	rcu_read_unlock();
 
-	if (!target || !READ_ONCE(target->ready))
+	if (!target || !READ_ONCE(target->common->ready))
 		goto no_yield;
 
 	/* Ignore requests to yield to self */
@@ -10096,7 +10096,7 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	if (kvm_vcpu_yield_to(target) <= 0)
 		goto no_yield;
 
-	vcpu->stat.directed_yield_successful++;
+	vcpu->common->stat.directed_yield_successful++;
 
 no_yield:
 	return;
@@ -10104,12 +10104,12 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 
 static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 {
-	u64 ret = vcpu->run->hypercall.ret;
+	u64 ret = vcpu->common->run->hypercall.ret;
 
 	if (!is_64_bit_mode(vcpu))
 		ret = (u32)ret;
 	kvm_rax_write(vcpu, ret);
-	++vcpu->stat.hypercalls;
+	++vcpu->common->stat.hypercalls;
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
@@ -10180,16 +10180,16 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 			break;
 		}
 
-		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
-		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
-		vcpu->run->hypercall.args[0]  = gpa;
-		vcpu->run->hypercall.args[1]  = npages;
-		vcpu->run->hypercall.args[2]  = attrs;
-		vcpu->run->hypercall.flags    = 0;
+		vcpu->common->run->exit_reason        = KVM_EXIT_HYPERCALL;
+		vcpu->common->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
+		vcpu->common->run->hypercall.args[0]  = gpa;
+		vcpu->common->run->hypercall.args[1]  = npages;
+		vcpu->common->run->hypercall.args[2]  = attrs;
+		vcpu->common->run->hypercall.flags    = 0;
 		if (op_64_bit)
-			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
+			vcpu->common->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
 
-		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
+		WARN_ON_ONCE(vcpu->common->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
 		/* stat is incremented on completion. */
 		return 0;
@@ -10200,7 +10200,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 	}
 
 out:
-	++vcpu->stat.hypercalls;
+	++vcpu->common->stat.hypercalls;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
@@ -10263,14 +10263,14 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
 {
-	return vcpu->run->request_interrupt_window &&
+	return vcpu->common->run->request_interrupt_window &&
 		likely(!pic_in_kernel(vcpu->kvm));
 }
 
 /* Called within kvm->srcu read side.  */
 static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 
 	kvm_run->if_flag = kvm_x86_call(get_if_flag)(vcpu);
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
@@ -10496,7 +10496,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	}
 
 	/* Don't inject interrupts if the user asked to avoid doing so */
-	if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ)
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_BLOCKIRQ)
 		return 0;
 
 	/*
@@ -10884,7 +10884,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 #endif
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
+			vcpu->common->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;
 			goto out;
 		}
@@ -10893,8 +10893,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				kvm_x86_ops.nested_ops->triple_fault(vcpu);
 
 			if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
-				vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
-				vcpu->mmio_needed = 0;
+				vcpu->common->run->exit_reason = KVM_EXIT_SHUTDOWN;
+				vcpu->common->mmio_needed = 0;
 				r = 0;
 				goto out;
 			}
@@ -10921,8 +10921,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			BUG_ON(vcpu->arch.pending_ioapic_eoi > 255);
 			if (test_bit(vcpu->arch.pending_ioapic_eoi,
 				     vcpu->arch.ioapic_handled_vectors)) {
-				vcpu->run->exit_reason = KVM_EXIT_IOAPIC_EOI;
-				vcpu->run->eoi.vector =
+				vcpu->common->run->exit_reason = KVM_EXIT_IOAPIC_EOI;
+				vcpu->common->run->eoi.vector =
 						vcpu->arch.pending_ioapic_eoi;
 				r = 0;
 				goto out;
@@ -10936,24 +10936,24 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_reload_apic_access_page(vcpu);
 #ifdef CONFIG_KVM_HYPERV
 		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
-			vcpu->run->system_event.ndata = 0;
+			vcpu->common->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+			vcpu->common->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+			vcpu->common->run->system_event.ndata = 0;
 			r = 0;
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
-			vcpu->run->system_event.ndata = 0;
+			vcpu->common->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+			vcpu->common->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
+			vcpu->common->run->system_event.ndata = 0;
 			r = 0;
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_EXIT, vcpu)) {
 			struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
-			vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-			vcpu->run->hyperv = hv_vcpu->exit;
+			vcpu->common->run->exit_reason = KVM_EXIT_HYPERV;
+			vcpu->common->run->hyperv = hv_vcpu->exit;
 			r = 0;
 			goto out;
 		}
@@ -10987,7 +10987,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
 	    kvm_xen_has_interrupt(vcpu)) {
-		++vcpu->stat.req_event;
+		++vcpu->common->stat.req_event;
 		r = kvm_apic_accept_events(vcpu);
 		if (r < 0) {
 			r = 0;
@@ -11028,8 +11028,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	local_irq_disable();
 
-	/* Store vcpu->apicv_active before vcpu->mode.  */
-	smp_store_release(&vcpu->mode, IN_GUEST_MODE);
+	/* Store vcpu->apicv_active before vcpu->common->mode.  */
+	smp_store_release(&vcpu->common->mode, IN_GUEST_MODE);
 
 	kvm_vcpu_srcu_read_unlock(vcpu);
 
@@ -11058,7 +11058,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_x86_call(sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
-		vcpu->mode = OUTSIDE_GUEST_MODE;
+		vcpu->common->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_enable();
 		preempt_enable();
@@ -11113,7 +11113,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 
 		/* Note, VM-Exits that go down the "slow" path are accounted below. */
-		++vcpu->stat.exits;
+		++vcpu->common->stat.exits;
 	}
 
 	/*
@@ -11123,7 +11123,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * KVM_DEBUGREG_WONT_EXIT again.
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
-		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP);
 		kvm_x86_call(sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
@@ -11142,7 +11142,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	vcpu->common->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
 	/*
@@ -11167,7 +11167,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
 	local_irq_enable();
-	++vcpu->stat.exits;
+	++vcpu->common->stat.exits;
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
@@ -11300,7 +11300,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->common->run->exit_reason = KVM_EXIT_UNKNOWN;
 
 	for (;;) {
 		/*
@@ -11329,8 +11329,8 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		if (dm_request_for_irq_injection(vcpu) &&
 			kvm_vcpu_ready_for_interrupt_injection(vcpu)) {
 			r = 0;
-			vcpu->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
-			++vcpu->stat.request_irq_exits;
+			vcpu->common->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
+			++vcpu->common->stat.request_irq_exits;
 			break;
 		}
 
@@ -11378,22 +11378,22 @@ static int complete_emulated_pio(struct kvm_vcpu *vcpu)
  */
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_mmio_fragment *frag;
 	unsigned len;
 
-	BUG_ON(!vcpu->mmio_needed);
+	BUG_ON(!vcpu->common->mmio_needed);
 
 	/* Complete previous fragment */
-	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
+	frag = &vcpu->common->mmio_fragments[vcpu->common->mmio_cur_fragment];
 	len = min(8u, frag->len);
-	if (!vcpu->mmio_is_write)
+	if (!vcpu->common->mmio_is_write)
 		memcpy(frag->data, run->mmio.data, len);
 
 	if (frag->len <= 8) {
 		/* Switch to the next fragment. */
 		frag++;
-		vcpu->mmio_cur_fragment++;
+		vcpu->common->mmio_cur_fragment++;
 	} else {
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
@@ -11401,22 +11401,22 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 		frag->len -= len;
 	}
 
-	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
-		vcpu->mmio_needed = 0;
+	if (vcpu->common->mmio_cur_fragment >= vcpu->common->mmio_nr_fragments) {
+		vcpu->common->mmio_needed = 0;
 
 		/* FIXME: return into emulator if single-stepping.  */
-		if (vcpu->mmio_is_write)
+		if (vcpu->common->mmio_is_write)
 			return 1;
-		vcpu->mmio_read_completed = 1;
+		vcpu->common->mmio_read_completed = 1;
 		return complete_emulated_io(vcpu);
 	}
 
 	run->exit_reason = KVM_EXIT_MMIO;
 	run->mmio.phys_addr = frag->gpa;
-	if (vcpu->mmio_is_write)
+	if (vcpu->common->mmio_is_write)
 		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
 	run->mmio.len = min(8u, frag->len);
-	run->mmio.is_write = vcpu->mmio_is_write;
+	run->mmio.is_write = vcpu->common->mmio_is_write;
 	vcpu->arch.complete_userspace_io = complete_emulated_mmio;
 	return 0;
 }
@@ -11433,14 +11433,14 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, false);
-	++vcpu->stat.fpu_reload;
+	++vcpu->common->stat.fpu_reload;
 	trace_kvm_fpu(0);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
-	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm_run *kvm_run = vcpu->common->run;
 	int r;
 
 	vcpu_load(vcpu);
@@ -11450,7 +11450,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-		if (!vcpu->wants_to_run) {
+		if (!vcpu->common->wants_to_run) {
 			r = -EINTR;
 			goto out;
 		}
@@ -11486,7 +11486,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			r = -EINTR;
 			kvm_run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.signal_exits;
+			++vcpu->common->stat.signal_exits;
 		}
 		goto out;
 	}
@@ -11534,10 +11534,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			goto out;
 	} else {
 		WARN_ON_ONCE(vcpu->arch.pio.count);
-		WARN_ON_ONCE(vcpu->mmio_needed);
+		WARN_ON_ONCE(vcpu->common->mmio_needed);
 	}
 
-	if (!vcpu->wants_to_run) {
+	if (!vcpu->common->wants_to_run) {
 		r = -EINTR;
 		goto out;
 	}
@@ -11820,11 +11820,11 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	 * Report an error userspace if MMIO is needed, as KVM doesn't support
 	 * MMIO during a task switch (or any other complex operation).
 	 */
-	if (ret || vcpu->mmio_needed) {
-		vcpu->mmio_needed = false;
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+	if (ret || vcpu->common->mmio_needed) {
+		vcpu->common->mmio_needed = false;
+		vcpu->common->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->common->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->common->run->internal.ndata = 0;
 		return 0;
 	}
 
@@ -12018,7 +12018,7 @@ static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
 	down_write(&kvm->arch.apicv_update_lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
+		if (vcpu->common->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
 			set = true;
 			break;
 		}
@@ -12054,11 +12054,11 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	 */
 	rflags = kvm_get_rflags(vcpu);
 
-	vcpu->guest_debug = dbg->control;
-	if (!(vcpu->guest_debug & KVM_GUESTDBG_ENABLE))
-		vcpu->guest_debug = 0;
+	vcpu->common->guest_debug = dbg->control;
+	if (!(vcpu->common->guest_debug & KVM_GUESTDBG_ENABLE))
+		vcpu->common->guest_debug = 0;
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
 		for (i = 0; i < KVM_NR_DB_REGS; ++i)
 			vcpu->arch.eff_db[i] = dbg->arch.debugreg[i];
 		vcpu->arch.guest_debug_dr7 = dbg->arch.debugreg[7];
@@ -12068,7 +12068,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	}
 	kvm_update_dr7(vcpu);
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
 
 	/*
@@ -12163,40 +12163,40 @@ static void store_regs(struct kvm_vcpu *vcpu)
 {
 	BUILD_BUG_ON(sizeof(struct kvm_sync_regs) > SYNC_REGS_SIZE_BYTES);
 
-	if (vcpu->run->kvm_valid_regs & KVM_SYNC_X86_REGS)
-		__get_regs(vcpu, &vcpu->run->s.regs.regs);
+	if (vcpu->common->run->kvm_valid_regs & KVM_SYNC_X86_REGS)
+		__get_regs(vcpu, &vcpu->common->run->s.regs.regs);
 
-	if (vcpu->run->kvm_valid_regs & KVM_SYNC_X86_SREGS)
-		__get_sregs(vcpu, &vcpu->run->s.regs.sregs);
+	if (vcpu->common->run->kvm_valid_regs & KVM_SYNC_X86_SREGS)
+		__get_sregs(vcpu, &vcpu->common->run->s.regs.sregs);
 
-	if (vcpu->run->kvm_valid_regs & KVM_SYNC_X86_EVENTS)
+	if (vcpu->common->run->kvm_valid_regs & KVM_SYNC_X86_EVENTS)
 		kvm_vcpu_ioctl_x86_get_vcpu_events(
-				vcpu, &vcpu->run->s.regs.events);
+				vcpu, &vcpu->common->run->s.regs.events);
 }
 
 static int sync_regs(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_REGS) {
-		__set_regs(vcpu, &vcpu->run->s.regs.regs);
-		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_REGS;
+	if (vcpu->common->run->kvm_dirty_regs & KVM_SYNC_X86_REGS) {
+		__set_regs(vcpu, &vcpu->common->run->s.regs.regs);
+		vcpu->common->run->kvm_dirty_regs &= ~KVM_SYNC_X86_REGS;
 	}
 
-	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_SREGS) {
-		struct kvm_sregs sregs = vcpu->run->s.regs.sregs;
+	if (vcpu->common->run->kvm_dirty_regs & KVM_SYNC_X86_SREGS) {
+		struct kvm_sregs sregs = vcpu->common->run->s.regs.sregs;
 
 		if (__set_sregs(vcpu, &sregs))
 			return -EINVAL;
 
-		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_SREGS;
+		vcpu->common->run->kvm_dirty_regs &= ~KVM_SYNC_X86_SREGS;
 	}
 
-	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_EVENTS) {
-		struct kvm_vcpu_events events = vcpu->run->s.regs.events;
+	if (vcpu->common->run->kvm_dirty_regs & KVM_SYNC_X86_EVENTS) {
+		struct kvm_vcpu_events events = vcpu->common->run->s.regs.events;
 
 		if (kvm_vcpu_ioctl_x86_set_vcpu_events(vcpu, &events))
 			return -EINVAL;
 
-		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_EVENTS;
+		vcpu->common->run->kvm_dirty_regs &= ~KVM_SYNC_X86_EVENTS;
 	}
 
 	return 0;
@@ -12320,7 +12320,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	if (mutex_lock_killable(&vcpu->mutex))
+	if (mutex_lock_killable(&vcpu->common->mutex))
 		return;
 	vcpu_load(vcpu);
 	kvm_synchronize_tsc(vcpu, NULL);
@@ -12329,7 +12329,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	/* poll control enabled by default */
 	vcpu->arch.msr_kvm_poll_control = 1;
 
-	mutex_unlock(&vcpu->mutex);
+	mutex_unlock(&vcpu->common->mutex);
 
 	if (kvmclock_periodic_sync && vcpu->vcpu_idx == 0)
 		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
@@ -13171,7 +13171,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 {
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (!list_empty_careful(&vcpu->common->async_pf.done))
 		return true;
 
 	if (kvm_apic_has_pending_init_or_sipi(vcpu) &&
@@ -13297,7 +13297,7 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 	unsigned long rflags;
 
 	rflags = kvm_x86_call(get_rflags)(vcpu);
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		rflags &= ~X86_EFLAGS_TF;
 	return rflags;
 }
@@ -13305,7 +13305,7 @@ EXPORT_SYMBOL_GPL(kvm_get_rflags);
 
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
+	if (vcpu->common->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
 	    kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip))
 		rflags |= X86_EFLAGS_TF;
 	kvm_x86_call(set_rflags)(vcpu, rflags);
@@ -13813,22 +13813,22 @@ EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
 
 static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_mmio_fragment *frag;
 	unsigned int len;
 
-	BUG_ON(!vcpu->mmio_needed);
+	BUG_ON(!vcpu->common->mmio_needed);
 
 	/* Complete previous fragment */
-	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
+	frag = &vcpu->common->mmio_fragments[vcpu->common->mmio_cur_fragment];
 	len = min(8u, frag->len);
-	if (!vcpu->mmio_is_write)
+	if (!vcpu->common->mmio_is_write)
 		memcpy(frag->data, run->mmio.data, len);
 
 	if (frag->len <= 8) {
 		/* Switch to the next fragment. */
 		frag++;
-		vcpu->mmio_cur_fragment++;
+		vcpu->common->mmio_cur_fragment++;
 	} else {
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
@@ -13836,8 +13836,8 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 		frag->len -= len;
 	}
 
-	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
-		vcpu->mmio_needed = 0;
+	if (vcpu->common->mmio_cur_fragment >= vcpu->common->mmio_nr_fragments) {
+		vcpu->common->mmio_needed = 0;
 
 		// VMG change, at this point, we're always done
 		// RIP has already been advanced
@@ -13847,7 +13847,7 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 	// More MMIO is needed
 	run->mmio.phys_addr = frag->gpa;
 	run->mmio.len = min(8u, frag->len);
-	run->mmio.is_write = vcpu->mmio_is_write;
+	run->mmio.is_write = vcpu->common->mmio_is_write;
 	if (run->mmio.is_write)
 		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
 	run->exit_reason = KVM_EXIT_MMIO;
@@ -13875,20 +13875,20 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 	data += handled;
 
 	/*TODO: Check if need to increment number of frags */
-	frag = vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments = 1;
+	frag = vcpu->common->mmio_fragments;
+	vcpu->common->mmio_nr_fragments = 1;
 	frag->len = bytes;
 	frag->gpa = gpa;
 	frag->data = data;
 
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
+	vcpu->common->mmio_needed = 1;
+	vcpu->common->mmio_cur_fragment = 0;
 
-	vcpu->run->mmio.phys_addr = gpa;
-	vcpu->run->mmio.len = min(8u, frag->len);
-	vcpu->run->mmio.is_write = 1;
-	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+	vcpu->common->run->mmio.phys_addr = gpa;
+	vcpu->common->run->mmio.len = min(8u, frag->len);
+	vcpu->common->run->mmio.is_write = 1;
+	memcpy(vcpu->common->run->mmio.data, frag->data, min(8u, frag->len));
+	vcpu->common->run->exit_reason = KVM_EXIT_MMIO;
 
 	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
 
@@ -13914,19 +13914,19 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 	data += handled;
 
 	/*TODO: Check if need to increment number of frags */
-	frag = vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments = 1;
+	frag = vcpu->common->mmio_fragments;
+	vcpu->common->mmio_nr_fragments = 1;
 	frag->len = bytes;
 	frag->gpa = gpa;
 	frag->data = data;
 
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
+	vcpu->common->mmio_needed = 1;
+	vcpu->common->mmio_cur_fragment = 0;
 
-	vcpu->run->mmio.phys_addr = gpa;
-	vcpu->run->mmio.len = min(8u, frag->len);
-	vcpu->run->mmio.is_write = 0;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+	vcpu->common->run->mmio.phys_addr = gpa;
+	vcpu->common->run->mmio.len = min(8u, frag->len);
+	vcpu->common->run->mmio.is_write = 0;
+	vcpu->common->run->exit_reason = KVM_EXIT_MMIO;
 
 	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 622fe24da910..57a699db05f2 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1360,7 +1360,7 @@ static int kvm_xen_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 
 static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (unlikely(!kvm_is_linear_rip(vcpu, vcpu->arch.xen.hypercall_rip)))
 		return 1;
@@ -1696,17 +1696,17 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 		return kvm_xen_hypercall_set_result(vcpu, r);
 
 handle_in_userspace:
-	vcpu->run->exit_reason = KVM_EXIT_XEN;
-	vcpu->run->xen.type = KVM_EXIT_XEN_HCALL;
-	vcpu->run->xen.u.hcall.longmode = longmode;
-	vcpu->run->xen.u.hcall.cpl = cpl;
-	vcpu->run->xen.u.hcall.input = input;
-	vcpu->run->xen.u.hcall.params[0] = params[0];
-	vcpu->run->xen.u.hcall.params[1] = params[1];
-	vcpu->run->xen.u.hcall.params[2] = params[2];
-	vcpu->run->xen.u.hcall.params[3] = params[3];
-	vcpu->run->xen.u.hcall.params[4] = params[4];
-	vcpu->run->xen.u.hcall.params[5] = params[5];
+	vcpu->common->run->exit_reason = KVM_EXIT_XEN;
+	vcpu->common->run->xen.type = KVM_EXIT_XEN_HCALL;
+	vcpu->common->run->xen.u.hcall.longmode = longmode;
+	vcpu->common->run->xen.u.hcall.cpl = cpl;
+	vcpu->common->run->xen.u.hcall.input = input;
+	vcpu->common->run->xen.u.hcall.params[0] = params[0];
+	vcpu->common->run->xen.u.hcall.params[1] = params[1];
+	vcpu->common->run->xen.u.hcall.params[2] = params[2];
+	vcpu->common->run->xen.u.hcall.params[3] = params[3];
+	vcpu->common->run->xen.u.hcall.params[4] = params[4];
+	vcpu->common->run->xen.u.hcall.params[5] = params[5];
 	vcpu->arch.xen.hypercall_rip = kvm_get_linear_rip(vcpu);
 	vcpu->arch.complete_userspace_io =
 		kvm_xen_hypercall_complete_userspace;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f5841d9000ae..ce0d90767df8 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -184,7 +184,7 @@ static inline void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
 	 * behalf of the vCPU. Only if the VMM does actually block
 	 * does it need to enter RUNSTATE_blocked.
 	 */
-	if (WARN_ON_ONCE(!vcpu->preempted))
+	if (WARN_ON_ONCE(!vcpu->common->preempted))
 		return;
 
 	kvm_xen_update_runstate(vcpu, RUNSTATE_runnable);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9f76f2d7b66e..b851c7650bbb 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -350,7 +350,7 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
  */
 static int vfio_ap_validate_nib(struct kvm_vcpu *vcpu, dma_addr_t *nib)
 {
-	*nib = vcpu->run->s.regs.gprs[2];
+	*nib = vcpu->common->run->s.regs.gprs[2];
 
 	if (!*nib)
 		return -EINVAL;
@@ -576,7 +576,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 			       .response_code = AP_RESPONSE_Q_NOT_AVAIL, };
 	struct ap_matrix_mdev *matrix_mdev;
 
-	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
+	apqn = vcpu->common->run->s.regs.gprs[0] & 0xffff;
 
 	/* If we do not use the AIV facility just go to userland */
 	if (!(vcpu->arch.sie_block->eca & ECA_AIV)) {
@@ -615,7 +615,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	status = vcpu->run->s.regs.gprs[1];
+	status = vcpu->common->run->s.regs.gprs[1];
 
 	/* If IR bit(16) is set we enable the interrupt */
 	if ((status >> (63 - 16)) & 0x01)
@@ -624,8 +624,8 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 		qstatus = vfio_ap_irq_disable(q);
 
 out_unlock:
-	memcpy(&vcpu->run->s.regs.gprs[1], &qstatus, sizeof(qstatus));
-	vcpu->run->s.regs.gprs[1] >>= 32;
+	memcpy(&vcpu->common->run->s.regs.gprs[1], &qstatus, sizeof(qstatus));
+	vcpu->common->run->s.regs.gprs[1] >>= 32;
 	mutex_unlock(&matrix_dev->mdevs_lock);
 	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79a6b1a63027..fb5c58c90975 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -179,13 +179,13 @@ static inline bool is_error_page(struct page *page)
  * OUTSIDE_GUEST_MODE.  KVM_REQ_OUTSIDE_GUEST_MODE differs from a vCPU "kick"
  * in that it ensures the vCPU has reached OUTSIDE_GUEST_MODE before continuing
  * on.  A kick only guarantees that the vCPU is on its way out, e.g. a previous
- * kick may have set vcpu->mode to EXITING_GUEST_MODE, and so there's no
+ * kick may have set vcpu->common->mode to EXITING_GUEST_MODE, and so there's no
  * guarantee the vCPU received an IPI and has actually exited guest mode.
  */
 #define KVM_REQ_OUTSIDE_GUEST_MODE	(KVM_REQUEST_NO_ACTION | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
-	BUILD_BUG_ON((unsigned)(nr) >= (sizeof_field(struct kvm_vcpu, requests) * 8) - KVM_REQUEST_ARCH_BASE); \
+	BUILD_BUG_ON((unsigned)(nr) >= (sizeof_field(struct kvm_vcpu, _common.requests) * 8) - KVM_REQUEST_ARCH_BASE); \
 	(unsigned)(((nr) + KVM_REQUEST_ARCH_BASE) | (flags)); \
 })
 #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
@@ -328,73 +328,80 @@ struct kvm_vcpu {
 	int cpu;
 	int vcpu_id; /* id given by userspace at creation */
 	int vcpu_idx; /* index into kvm->vcpu_array */
-	int ____srcu_idx; /* Don't use this directly.  You've been warned. */
-#ifdef CONFIG_PROVE_RCU
-	int srcu_depth;
-#endif
-	int mode;
-	u64 requests;
-	unsigned long guest_debug;
 
-	struct mutex mutex;
-	struct kvm_run *run;
+	struct kvm_vcpu_arch arch;
 
-#ifndef __KVM_HAVE_ARCH_WQP
-	struct rcuwait wait;
+	struct kvm_vcpu_common {
+		int ____srcu_idx; /* Don't use this directly.  You've been warned. */
+#ifdef CONFIG_PROVE_RCU
+		int srcu_depth;
 #endif
-	struct pid __rcu *pid;
-	int sigset_active;
-	sigset_t sigset;
-	unsigned int halt_poll_ns;
-	bool valid_wakeup;
+		int mode;
+		u64 requests;
+		unsigned long guest_debug;
+	
+		struct mutex mutex;
+
+		struct kvm_run *run;
+
+	#ifndef __KVM_HAVE_ARCH_WQP
+		struct rcuwait wait;
+	#endif
+		struct pid __rcu *pid;
+		int sigset_active;
+		sigset_t sigset;
+		unsigned int halt_poll_ns;
+		bool valid_wakeup;
 
 #ifdef CONFIG_HAS_IOMEM
-	int mmio_needed;
-	int mmio_read_completed;
-	int mmio_is_write;
-	int mmio_cur_fragment;
-	int mmio_nr_fragments;
-	struct kvm_mmio_fragment mmio_fragments[KVM_MAX_MMIO_FRAGMENTS];
+		int mmio_needed;
+		int mmio_read_completed;
+		int mmio_is_write;
+		int mmio_cur_fragment;
+		int mmio_nr_fragments;
+		struct kvm_mmio_fragment mmio_fragments[KVM_MAX_MMIO_FRAGMENTS];
 #endif
 
 #ifdef CONFIG_KVM_ASYNC_PF
-	struct {
-		u32 queued;
-		struct list_head queue;
-		struct list_head done;
-		spinlock_t lock;
-	} async_pf;
+		struct {
+			u32 queued;
+			struct list_head queue;
+			struct list_head done;
+			spinlock_t lock;
+		} async_pf;
 #endif
 
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
-	/*
-	 * Cpu relax intercept or pause loop exit optimization
-	 * in_spin_loop: set when a vcpu does a pause loop exit
-	 *  or cpu relax intercepted.
-	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
-	 */
-	struct {
-		bool in_spin_loop;
-		bool dy_eligible;
-	} spin_loop;
+		/*
+		* Cpu relax intercept or pause loop exit optimization
+		* in_spin_loop: set when a vcpu does a pause loop exit
+		*  or cpu relax intercepted.
+		* dy_eligible: indicates whether vcpu is eligible for directed yield.
+		*/
+		struct {
+			bool in_spin_loop;
+			bool dy_eligible;
+		} spin_loop;
 #endif
-	bool wants_to_run;
-	bool preempted;
-	bool ready;
-	bool scheduled_out;
-	struct kvm_vcpu_arch arch;
-	struct kvm_vcpu_stat stat;
-	char stats_id[KVM_STATS_NAME_SIZE];
-	struct kvm_dirty_ring dirty_ring;
+		bool wants_to_run;
+		bool preempted;
+		bool ready;
+		bool scheduled_out;
+		struct kvm_vcpu_stat stat;
+		char stats_id[KVM_STATS_NAME_SIZE];
+		struct kvm_dirty_ring dirty_ring;
 
-	/*
-	 * The most recently used memslot by this vCPU and the slots generation
-	 * for which it is valid.
-	 * No wraparound protection is needed since generations won't overflow in
-	 * thousands of years, even assuming 1M memslot operations per second.
-	 */
-	struct kvm_memory_slot *last_used_slot;
-	u64 last_used_slot_gen;
+		/*
+		* The most recently used memslot by this vCPU and the slots generation
+		* for which it is valid.
+		* No wraparound protection is needed since generations won't overflow in
+		* thousands of years, even assuming 1M memslot operations per second.
+		*/
+		struct kvm_memory_slot *last_used_slot;
+		u64 last_used_slot_gen;
+	} _common;
+
+	struct kvm_vcpu_common *common;
 };
 
 /*
@@ -550,11 +557,11 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * The memory barrier ensures a previous write to vcpu->requests cannot
-	 * be reordered with the read of vcpu->mode.  It pairs with the general
-	 * memory barrier following the write of vcpu->mode in VCPU RUN.
+	 * be reordered with the read of vcpu->common->mode.  It pairs with the general
+	 * memory barrier following the write of vcpu->common->mode in VCPU RUN.
 	 */
 	smp_mb__before_atomic();
-	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
+	return cmpxchg(&vcpu->common->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
 }
 
 /*
@@ -923,19 +930,19 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_PROVE_RCU
-	WARN_ONCE(vcpu->srcu_depth++,
-		  "KVM: Illegal vCPU srcu_idx LOCK, depth=%d", vcpu->srcu_depth - 1);
+	WARN_ONCE(vcpu->common->srcu_depth++,
+		  "KVM: Illegal vCPU srcu_idx LOCK, depth=%d", vcpu->common->srcu_depth - 1);
 #endif
-	vcpu->____srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	vcpu->common->____srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 }
 
 static inline void kvm_vcpu_srcu_read_unlock(struct kvm_vcpu *vcpu)
 {
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->____srcu_idx);
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->common->____srcu_idx);
 
 #ifdef CONFIG_PROVE_RCU
-	WARN_ONCE(--vcpu->srcu_depth,
-		  "KVM: Illegal vCPU srcu_idx UNLOCK, depth=%d", vcpu->srcu_depth);
+	WARN_ONCE(--vcpu->common->srcu_depth,
+		  "KVM: Illegal vCPU srcu_idx UNLOCK, depth=%d", vcpu->common->srcu_depth);
 #endif
 }
 
@@ -1611,7 +1618,7 @@ static inline struct rcuwait *kvm_arch_vcpu_get_wait(struct kvm_vcpu *vcpu)
 #ifdef __KVM_HAVE_ARCH_WQP
 	return vcpu->arch.waitp;
 #else
-	return &vcpu->wait;
+	return &vcpu->common->wait;
 #endif
 }
 
@@ -2148,7 +2155,7 @@ static inline void __kvm_make_request(int req, struct kvm_vcpu *vcpu)
 	 * caller.  Paired with the smp_mb__after_atomic in kvm_check_request.
 	 */
 	smp_wmb();
-	set_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
+	set_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
 }
 
 static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
@@ -2166,17 +2173,17 @@ static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 
 static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
 {
-	return READ_ONCE(vcpu->requests);
+	return READ_ONCE(vcpu->common->requests);
 }
 
 static inline bool kvm_test_request(int req, struct kvm_vcpu *vcpu)
 {
-	return test_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
+	return test_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
 }
 
 static inline void kvm_clear_request(int req, struct kvm_vcpu *vcpu)
 {
-	clear_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
+	clear_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
 }
 
 static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
@@ -2267,11 +2274,11 @@ extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
 
 static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
 {
-	vcpu->spin_loop.in_spin_loop = val;
+	vcpu->common->spin_loop.in_spin_loop = val;
 }
 static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 {
-	vcpu->spin_loop.dy_eligible = val;
+	vcpu->common->spin_loop.dy_eligible = val;
 }
 
 #else /* !CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
@@ -2312,7 +2319,7 @@ bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
 /* If we wakeup during the poll time, was it a sucessful poll? */
 static inline bool vcpu_valid_wakeup(struct kvm_vcpu *vcpu)
 {
-	return vcpu->valid_wakeup;
+	return vcpu->common->valid_wakeup;
 }
 
 #else
@@ -2364,8 +2371,8 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
 #ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
 static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 {
-	vcpu->run->exit_reason = KVM_EXIT_INTR;
-	vcpu->stat.signal_exits++;
+	vcpu->common->run->exit_reason = KVM_EXIT_INTR;
+	vcpu->common->stat.signal_exits++;
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
@@ -2397,14 +2404,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 						 bool is_write, bool is_exec,
 						 bool is_private)
 {
-	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
-	vcpu->run->memory_fault.gpa = gpa;
-	vcpu->run->memory_fault.size = size;
+	vcpu->common->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+	vcpu->common->run->memory_fault.gpa = gpa;
+	vcpu->common->run->memory_fault.size = size;
 
 	/* RWX flags are not (yet) defined or communicated to userspace. */
-	vcpu->run->memory_fault.flags = 0;
+	vcpu->common->run->memory_fault.flags = 0;
 	if (is_private)
-		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
+		vcpu->common->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2582c49e525a..b162545286b0 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -474,7 +474,7 @@ void test_single_step_from_userspace(int test_cnt)
 	struct kvm_guest_debug debug = {};
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code_ss);
-	run = vcpu->run;
+	run = vcpu->common->run;
 	vcpu_args_set(vcpu, 1, test_cnt);
 
 	while (1) {
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index d29b08198b42..357e842a3328 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -660,7 +660,7 @@ static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 	struct ucall uc;
 	int ret;
 
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	for (;;) {
 		ret = _vcpu_run(vcpu);
diff --git a/tools/testing/selftests/kvm/aarch64/smccc_filter.c b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
index 2d189f3da228..bbcc1a1a9c1a 100644
--- a/tools/testing/selftests/kvm/aarch64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
@@ -207,7 +207,7 @@ static void test_filter_denied(void)
 static void expect_call_fwd_to_user(struct kvm_vcpu *vcpu, uint32_t func_id,
 				    enum smccc_conduit conduit)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_HYPERCALL,
 		    "Unexpected exit reason: %u", run->exit_reason);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0202b78f8680..be98b5c3d629 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -33,7 +33,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	int vcpu_idx = vcpu_args->vcpu_idx;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct timespec start;
 	struct timespec ts_diff;
 	int ret;
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 9f24303acb8c..1e194fbc87b5 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -77,7 +77,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	struct timespec avg;
 	int ret;
 
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	while (!READ_ONCE(host_quit)) {
 		int current_iteration = READ_ONCE(iteration);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index aacf80f57439..35890dcd8d6f 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -253,7 +253,7 @@ static void vcpu_handle_sync_stop(void)
 
 static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
 		    "vcpu run failed: errno=%d", err);
@@ -391,7 +391,7 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 
 static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	/* A ucall-sync or ring-full event is allowed */
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index 8092c2d0f5d6..bbb910363120 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -110,7 +110,7 @@ static void ucall_abort(const char *assert_msg, const char *expected_assert_msg)
 static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
 		     const char *expected_assert)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct ucall uc;
 
 	while (1) {
@@ -158,7 +158,7 @@ static void test_limits(void)
 	struct ucall uc;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code_limits);
-	run = vcpu->run;
+	run = vcpu->common->run;
 	vcpu_run(vcpu);
 
 	TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index bce73bcb973c..805363b9e706 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -34,7 +34,7 @@ static void guest_code(void)
 static void *run_vcpu(void *arg)
 {
 	struct kvm_vcpu *vcpu = arg;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	vcpu_run(vcpu);
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index dd8b12f626d3..12ae35b635ca 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -205,7 +205,7 @@ static void *vcpu_worker(void *data)
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
 		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
 			    "Invalid guest sync status: exit_reason=%s",
-			    exit_reason_str(vcpu->run->exit_reason));
+			    exit_reason_str(vcpu->common->run->exit_reason));
 
 		pr_debug("Got sync event from vCPU %d\n", vcpu->id);
 		stage = READ_ONCE(*current_stage);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index ddab0ce89d4d..7146625553ce 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -21,7 +21,7 @@ void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == vcpu->vm->ucall_mmio_addr) {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56b170b725b3..520e820d7683 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -684,7 +684,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 		vcpu->dirty_gfns = NULL;
 	}
 
-	ret = munmap(vcpu->run, vcpu_mmap_sz());
+	ret = munmap(vcpu->common->run, vcpu_mmap_sz());
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 
 	ret = close(vcpu->fd);
@@ -1349,12 +1349,12 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpu_id);
 	TEST_ASSERT_VM_VCPU_IOCTL(vcpu->fd >= 0, KVM_CREATE_VCPU, vcpu->fd, vm);
 
-	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
+	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->common->run), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
-		vcpu_mmap_sz(), sizeof(*vcpu->run));
-	vcpu->run = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
+		vcpu_mmap_sz(), sizeof(*vcpu->common->run));
+	vcpu->common->run = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
 		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
-	TEST_ASSERT(vcpu->run != MAP_FAILED,
+	TEST_ASSERT(vcpu->common->run != MAP_FAILED,
 		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
 
 	/* Add to linked-list of VCPUs. */
@@ -1739,9 +1739,9 @@ void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	vcpu->run->immediate_exit = 1;
+	vcpu->common->run->immediate_exit = 1;
 	ret = __vcpu_run(vcpu);
-	vcpu->run->immediate_exit = 0;
+	vcpu->common->run->immediate_exit = 0;
 
 	TEST_ASSERT(ret == -1 && errno == EINTR,
 		    "KVM_RUN IOCTL didn't exit immediately, rc: %i, errno: %i",
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index b5035c63d516..2f9c327eace1 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -13,7 +13,7 @@
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (run->exit_reason == KVM_EXIT_RISCV_SBI &&
 	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
diff --git a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
index 2c432fa164f1..f9207a502eab 100644
--- a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
+++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
@@ -33,7 +33,7 @@ static uint64_t diag318_handler(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vcpu_run(vcpu);
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s390_sieic.icptcode == ICPT_INSTRUCTION,
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 4ad4492eea1d..f717e8bcd03c 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -157,7 +157,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 {
-	vcpu->run->psw_addr = (uintptr_t)guest_code;
+	vcpu->common->run->psw_addr = (uintptr_t)guest_code;
 }
 
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
@@ -187,7 +187,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	sregs.crs[1] = vm->pgd | 0xf;		/* Primary region table */
 	vcpu_sregs_set(vcpu, &sregs);
 
-	vcpu->run->psw_mask = 0x0400000180000000ULL;  /* DAT enabled + 64 bit mode */
+	vcpu->common->run->psw_mask = 0x0400000180000000ULL;  /* DAT enabled + 64 bit mode */
 
 	return vcpu;
 }
@@ -215,7 +215,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 {
 	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
-		indent, "", vcpu->run->psw_mask, vcpu->run->psw_addr);
+		indent, "", vcpu->common->run->psw_mask, vcpu->common->run->psw_addr);
 }
 
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index cca98734653d..bd6822a78ab7 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -8,7 +8,7 @@
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
 	    run->s390_sieic.icptcode == 4 &&
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index 1265cecc7dd1..b40e55525897 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -44,7 +44,7 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
 		struct kvm_regs regs;
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 49f162573126..7d8957ddb8a1 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -37,7 +37,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	struct kvm_run *run;
 	int ret;
 
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	/* Let the guest access its memory until a stop signal is received */
 	while (!READ_ONCE(memstress_args.stop_vcpus)) {
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 579a64f97333..ab419ad6bb41 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -137,7 +137,7 @@ static void *vcpu_worker(void *__data)
 {
 	struct vm_data *data = __data;
 	struct kvm_vcpu *vcpu = data->vcpu;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct ucall uc;
 
 	while (1) {
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 0350a8896a2f..a2f956821d1e 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -104,7 +104,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
 	vcpu_run(vcpu);
 
-	run = vcpu->run;
+	run = vcpu->common->run;
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Wanted KVM_EXIT_IO, got exit reason: %u (%s)",
 		    run->exit_reason, exit_reason_str(run->exit_reason));
diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390x/cmma_test.c
index b39033844756..dad56f823d8e 100644
--- a/tools/testing/selftests/kvm/s390x/cmma_test.c
+++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
@@ -262,10 +262,10 @@ static void test_get_cmma_basic(void)
 
 static void assert_exit_was_hypercall(struct kvm_vcpu *vcpu)
 {
-	TEST_ASSERT_EQ(vcpu->run->exit_reason, 13);
-	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, 4);
-	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x8300);
-	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipb, 0x5010000);
+	TEST_ASSERT_EQ(vcpu->common->run->exit_reason, 13);
+	TEST_ASSERT_EQ(vcpu->common->run->s390_sieic.icptcode, 4);
+	TEST_ASSERT_EQ(vcpu->common->run->s390_sieic.ipa, 0x8300);
+	TEST_ASSERT_EQ(vcpu->common->run->s390_sieic.ipb, 0x5010000);
 }
 
 static void test_migration_mode(void)
@@ -287,7 +287,7 @@ static void test_migration_mode(void)
 
 	enable_cmma(vm);
 	vcpu = vm_vcpu_add(vm, 1, guest_do_one_essa);
-	orig_psw = vcpu->run->psw_addr;
+	orig_psw = vcpu->common->run->psw_addr;
 
 	/*
 	 * Execute one essa instruction in the guest. Otherwise the guest will
@@ -313,7 +313,7 @@ static void test_migration_mode(void)
 	errno = 0;
 
 	/* execute another ESSA instruction to see this goes fine */
-	vcpu->run->psw_addr = orig_psw;
+	vcpu->common->run->psw_addr = orig_psw;
 	vcpu_run(vcpu);
 	assert_exit_was_hypercall(vcpu);
 
@@ -334,7 +334,7 @@ static void test_migration_mode(void)
 		   );
 
 	/* ESSA instructions should still execute fine */
-	vcpu->run->psw_addr = orig_psw;
+	vcpu->common->run->psw_addr = orig_psw;
 	vcpu_run(vcpu);
 	assert_exit_was_hypercall(vcpu);
 
@@ -359,7 +359,7 @@ static void test_migration_mode(void)
 		   );
 
 	/* ESSA instructions should still execute fine */
-	vcpu->run->psw_addr = orig_psw;
+	vcpu->common->run->psw_addr = orig_psw;
 	vcpu_run(vcpu);
 	assert_exit_was_hypercall(vcpu);
 
@@ -510,7 +510,7 @@ static void test_get_skip_holes(void)
 	enable_cmma(vm);
 	vcpu = vm_vcpu_add(vm, 1, guest_dirty_test_data);
 
-	orig_psw = vcpu->run->psw_addr;
+	orig_psw = vcpu->common->run->psw_addr;
 
 	/*
 	 * Execute some essa instructions in the guest. Otherwise the guest will
@@ -526,7 +526,7 @@ static void test_get_skip_holes(void)
 	assert_all_slots_cmma_dirty(vm);
 
 	/* Then, dirty just the TEST_DATA memslot */
-	vcpu->run->psw_addr = orig_psw;
+	vcpu->common->run->psw_addr = orig_psw;
 	vcpu_run(vcpu);
 
 	gfn_offset = TEST_DATA_START_GFN;
diff --git a/tools/testing/selftests/kvm/s390x/debug_test.c b/tools/testing/selftests/kvm/s390x/debug_test.c
index 84313fb27529..bc9acb6fb068 100644
--- a/tools/testing/selftests/kvm/s390x/debug_test.c
+++ b/tools/testing/selftests/kvm/s390x/debug_test.c
@@ -47,8 +47,8 @@ static void test_step_int(void *guest_code, size_t new_psw_off)
 
 	vm = test_step_int_1(&vcpu, guest_code, new_psw_off, new_psw);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
-	TEST_ASSERT_EQ(vcpu->run->psw_mask, new_psw[0]);
-	TEST_ASSERT_EQ(vcpu->run->psw_addr, new_psw[1]);
+	TEST_ASSERT_EQ(vcpu->common->run->psw_mask, new_psw[0]);
+	TEST_ASSERT_EQ(vcpu->common->run->psw_addr, new_psw[1]);
 	kvm_vm_free(vm);
 }
 
@@ -85,13 +85,13 @@ static void test_step_pgm_diag(void)
 	vm = test_step_int_1(&vcpu, test_step_pgm_diag_guest_code,
 			     __LC_PGM_NEW_PSW, new_psw);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
-	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_INSTRUCTION);
-	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa & 0xff00, IPA0_DIAG);
+	TEST_ASSERT_EQ(vcpu->common->run->s390_sieic.icptcode, ICPT_INSTRUCTION);
+	TEST_ASSERT_EQ(vcpu->common->run->s390_sieic.ipa & 0xff00, IPA0_DIAG);
 	vcpu_ioctl(vcpu, KVM_S390_IRQ, &irq);
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
-	TEST_ASSERT_EQ(vcpu->run->psw_mask, new_psw[0]);
-	TEST_ASSERT_EQ(vcpu->run->psw_addr, new_psw[1]);
+	TEST_ASSERT_EQ(vcpu->common->run->psw_mask, new_psw[0]);
+	TEST_ASSERT_EQ(vcpu->common->run->psw_addr, new_psw[1]);
 	kvm_vm_free(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index f2df7416be84..77cd0549d9d6 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -252,7 +252,7 @@ static struct test_default test_default_init(void *guest_code)
 	t.kvm_vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	t.vm = (struct test_info) { t.kvm_vm, NULL };
 	t.vcpu = (struct test_info) { t.kvm_vm, vcpu };
-	t.run = vcpu->run;
+	t.run = vcpu->common->run;
 	return t;
 }
 
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index 357943f2bea8..ecb8526339f5 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -84,7 +84,7 @@ static void assert_noirq(struct kvm_vcpu *vcpu)
 
 static void assert_clear(struct kvm_vcpu *vcpu)
 {
-	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *sync_regs = &vcpu->common->run->s.regs;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 	struct kvm_fpu fpu;
@@ -111,7 +111,7 @@ static void assert_clear(struct kvm_vcpu *vcpu)
 
 static void assert_initial_noclear(struct kvm_vcpu *vcpu)
 {
-	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *sync_regs = &vcpu->common->run->s.regs;
 
 	TEST_ASSERT(sync_regs->gprs[0] == 0xffff000000000000UL,
 		    "gpr0 == 0xffff000000000000 (sync_regs)");
@@ -128,7 +128,7 @@ static void assert_initial_noclear(struct kvm_vcpu *vcpu)
 
 static void assert_initial(struct kvm_vcpu *vcpu)
 {
-	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *sync_regs = &vcpu->common->run->s.regs;
 	struct kvm_sregs sregs;
 	struct kvm_fpu fpu;
 
@@ -156,8 +156,8 @@ static void assert_initial(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(sync_regs->gbea == 1, "gbea == 1 (sync_regs)");
 
 	/* kvm_run */
-	TEST_ASSERT(vcpu->run->psw_addr == 0, "psw_addr == 0 (kvm_run)");
-	TEST_ASSERT(vcpu->run->psw_mask == 0, "psw_mask == 0 (kvm_run)");
+	TEST_ASSERT(vcpu->common->run->psw_addr == 0, "psw_addr == 0 (kvm_run)");
+	TEST_ASSERT(vcpu->common->run->psw_mask == 0, "psw_mask == 0 (kvm_run)");
 
 	vcpu_fpu_get(vcpu, &fpu);
 	TEST_ASSERT(!fpu.fpc, "fpc == 0");
@@ -171,7 +171,7 @@ static void assert_initial(struct kvm_vcpu *vcpu)
 
 static void assert_normal_noclear(struct kvm_vcpu *vcpu)
 {
-	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
+	struct kvm_sync_regs *sync_regs = &vcpu->common->run->s.regs;
 
 	TEST_ASSERT(sync_regs->crs[2] == 0x10, "cr2 == 10 (sync_regs)");
 	TEST_ASSERT(sync_regs->crs[8] == 1, "cr10 == 1 (sync_regs)");
@@ -182,7 +182,7 @@ static void assert_normal_noclear(struct kvm_vcpu *vcpu)
 static void assert_normal(struct kvm_vcpu *vcpu)
 {
 	test_one_reg(vcpu, KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
-	TEST_ASSERT(vcpu->run->s.regs.pft == KVM_S390_PFAULT_TOKEN_INVALID,
+	TEST_ASSERT(vcpu->common->run->s.regs.pft == KVM_S390_PFAULT_TOKEN_INVALID,
 			"pft == 0xff.....  (sync_regs)");
 	assert_noirq(vcpu);
 }
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index 53def355ccba..cd843306788c 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -73,7 +73,7 @@ static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
 
 void test_read_invalid(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int rv;
 
 	/* Request reading invalid register set from VCPU. */
@@ -94,7 +94,7 @@ void test_read_invalid(struct kvm_vcpu *vcpu)
 
 void test_set_invalid(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int rv;
 
 	/* Request setting invalid register set into VCPU. */
@@ -115,7 +115,7 @@ void test_set_invalid(struct kvm_vcpu *vcpu)
 
 void test_req_and_verify_all_valid_regs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 	int rv;
@@ -141,7 +141,7 @@ void test_req_and_verify_all_valid_regs(struct kvm_vcpu *vcpu)
 
 void test_set_and_verify_various_reg_values(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 	int rv;
@@ -180,7 +180,7 @@ void test_set_and_verify_various_reg_values(struct kvm_vcpu *vcpu)
 
 void test_clear_kvm_dirty_regs_bits(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int rv;
 
 	/* Clear kvm_dirty_regs bits, verify new s.regs values are
diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
index 7a742a673b7c..d181e999c74c 100644
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -214,7 +214,7 @@ int main(int argc, char *argv[])
 	ksft_set_plan(STAGE_END);
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	HOST_SYNC(vcpu, STAGE_INIT_SIMPLE);
 	mprotect(addr_gva2hva(vm, (vm_vaddr_t)pages), PAGE_SIZE * 2, PROT_READ);
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index bb8002084f52..458e6072c263 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -52,7 +52,7 @@ static inline uint64_t guest_spin_on_val(uint64_t spin_val)
 static void *vcpu_worker(void *data)
 {
 	struct kvm_vcpu *vcpu = data;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct ucall uc;
 	uint64_t cmd;
 
@@ -298,7 +298,7 @@ static void test_delete_memory_region(void)
 
 	pthread_join(vcpu_thread, NULL);
 
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN ||
 		    run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index a8d3afa0b86b..0e49c153c5c1 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -334,7 +334,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu->run->exit_reason));
+			    exit_reason_str(vcpu->common->run->exit_reason));
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 8c579ce714e9..89ae4537f160 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -119,7 +119,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu->run->exit_reason));
+			    exit_reason_str(vcpu->common->run->exit_reason));
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index f6b295e0b2d2..ee391b07ada3 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -98,7 +98,7 @@ int main(void)
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	/* Test software BPs - int3 */
 	memset(&debug, 0, sizeof(debug));
diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index 762628f7d4ba..b76a020b740b 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -88,7 +88,7 @@ KVM_ONE_VCPU_TEST_SUITE(fix_hypercall);
 
 static void enter_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct ucall uc;
 
 	vcpu_run(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
index 37b1a9f52864..ebc81c02e719 100644
--- a/tools/testing/selftests/kvm/x86_64/flds_emulation.h
+++ b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
@@ -19,7 +19,7 @@ static inline void flds(uint64_t address)
 
 static inline void handle_flds_emulation_failure_exit(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_regs regs;
 	uint8_t *insn_bytes;
 	uint64_t flags;
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
index 949e08e98f31..5562f19a6b60 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -53,7 +53,7 @@ int main(void)
 	}
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
+	run = vcpu->common->run;
 	vcpu_set_hv_cpuid(vcpu);
 
 	/* Hypercall input */
diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
index 3eb0313ffa39..342a71434586 100644
--- a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
@@ -238,7 +238,7 @@ int main(int argc, char *argv[])
 
 	/* Pend #SS and request immediate exit.  #SS should still be pending. */
 	queue_ss_exception(vcpu, false);
-	vcpu->run->immediate_exit = true;
+	vcpu->common->run->immediate_exit = true;
 	vcpu_run_complete_io(vcpu);
 
 	/* Verify the pending events comes back out the same as it went in. */
@@ -254,7 +254,7 @@ int main(int argc, char *argv[])
 	 * Run for real with the pending #SS, L1 should get a VM-Exit due to
 	 * #SS interception and re-enter L2 to request #GP (via injected #SS).
 	 */
-	vcpu->run->immediate_exit = false;
+	vcpu->common->run->immediate_exit = false;
 	vcpu_run(vcpu);
 	assert_ucall_vector(vcpu, GP_VECTOR);
 
diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index 82a8d88b5338..fe887798811d 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -288,7 +288,7 @@ static void guest_code(uint64_t base_gpa)
 
 static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	uint64_t gpa = run->hypercall.args[0];
 	uint64_t size = run->hypercall.args[1] * PAGE_SIZE;
 	bool set_attributes = run->hypercall.args[2] & MAP_GPA_SET_ATTRIBUTES;
@@ -314,7 +314,7 @@ static bool run_vcpus;
 static void *__test_mem_conversions(void *__vcpu)
 {
 	struct kvm_vcpu *vcpu = __vcpu;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_vm *vm = vcpu->vm;
 	struct ucall uc;
 
diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
index 13e72fcec8dd..ad1d63aeca97 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
@@ -34,9 +34,9 @@ static uint32_t run_vcpu_get_exit_reason(struct kvm_vcpu *vcpu)
 	r = _vcpu_run(vcpu);
 	if (r) {
 		TEST_ASSERT(errno == EFAULT, KVM_IOCTL_ERROR(KVM_RUN, r));
-		TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MEMORY_FAULT);
+		TEST_ASSERT_EQ(vcpu->common->run->exit_reason, KVM_EXIT_MEMORY_FAULT);
 	}
-	return vcpu->run->exit_reason;
+	return vcpu->common->run->exit_reason;
 }
 
 const struct vm_shape protected_vm_shape = {
@@ -75,9 +75,9 @@ static void test_private_access_memslot_deleted(void)
 	exit_reason = (uint32_t)(uint64_t)thread_return;
 
 	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	TEST_ASSERT_EQ(vcpu->common->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
+	TEST_ASSERT_EQ(vcpu->common->run->memory_fault.gpa, EXITS_TEST_GPA);
+	TEST_ASSERT_EQ(vcpu->common->run->memory_fault.size, EXITS_TEST_SIZE);
 
 	kvm_vm_free(vm);
 }
@@ -104,9 +104,9 @@ static void test_private_access_memslot_not_private(void)
 	exit_reason = run_vcpu_get_exit_reason(vcpu);
 
 	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	TEST_ASSERT_EQ(vcpu->common->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
+	TEST_ASSERT_EQ(vcpu->common->run->memory_fault.gpa, EXITS_TEST_GPA);
+	TEST_ASSERT_EQ(vcpu->common->run->memory_fault.size, EXITS_TEST_SIZE);
 
 	kvm_vm_free(vm);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 49913784bc82..581b98df7cdd 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -81,7 +81,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 			REPORT_GUEST_ASSERT(uc);
 		default:
 			TEST_ASSERT(false, "Unexpected exit: %s",
-				    exit_reason_str(vcpu->run->exit_reason));
+				    exit_reason_str(vcpu->common->run->exit_reason));
 		}
 	}
 }
diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
index 7c70c0da4fb7..d807e758ad7c 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -106,12 +106,12 @@ static void test_sync_vmsa(uint32_t policy)
 
 	vcpu_run(vcpu);
 
-	TEST_ASSERT(vcpu->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+	TEST_ASSERT(vcpu->common->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
 		    "Wanted SYSTEM_EVENT, got %s",
-		    exit_reason_str(vcpu->run->exit_reason));
-	TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
-	TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 1);
-	TEST_ASSERT_EQ(vcpu->run->system_event.data[0], GHCB_MSR_TERM_REQ);
+		    exit_reason_str(vcpu->common->run->exit_reason));
+	TEST_ASSERT_EQ(vcpu->common->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
+	TEST_ASSERT_EQ(vcpu->common->run->system_event.ndata, 1);
+	TEST_ASSERT_EQ(vcpu->common->run->system_event.data[0], GHCB_MSR_TERM_REQ);
 
 	compare_xsave((u8 *)&xsave, (u8 *)hva);
 
@@ -135,12 +135,12 @@ static void test_sev(void *guest_code, uint64_t policy)
 		vcpu_run(vcpu);
 
 		if (policy & SEV_POLICY_ES) {
-			TEST_ASSERT(vcpu->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+			TEST_ASSERT(vcpu->common->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
 				    "Wanted SYSTEM_EVENT, got %s",
-				    exit_reason_str(vcpu->run->exit_reason));
-			TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
-			TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 1);
-			TEST_ASSERT_EQ(vcpu->run->system_event.data[0], GHCB_MSR_TERM_REQ);
+				    exit_reason_str(vcpu->common->run->exit_reason));
+			TEST_ASSERT_EQ(vcpu->common->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
+			TEST_ASSERT_EQ(vcpu->common->run->system_event.ndata, 1);
+			TEST_ASSERT_EQ(vcpu->common->run->system_event.data[0], GHCB_MSR_TERM_REQ);
 			break;
 		}
 
@@ -153,7 +153,7 @@ static void test_sev(void *guest_code, uint64_t policy)
 			REPORT_GUEST_ASSERT(uc);
 		default:
 			TEST_FAIL("Unexpected exit: %s",
-				  exit_reason_str(vcpu->run->exit_reason));
+				  exit_reason_str(vcpu->common->run->exit_reason));
 		}
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 8fa3948b0170..a2089abfd29a 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -162,7 +162,7 @@ static void race_sync_regs(struct kvm_vcpu *vcpu, void *racer)
 	pthread_t thread;
 	time_t t;
 
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	run->kvm_valid_regs = KVM_SYNC_X86_SREGS;
 	vcpu_run(vcpu);
@@ -207,7 +207,7 @@ static void race_sync_regs(struct kvm_vcpu *vcpu, void *racer)
 
 KVM_ONE_VCPU_TEST(sync_regs_test, read_invalid, guest_code)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int rv;
 
 	/* Request reading invalid register set from VCPU. */
@@ -228,7 +228,7 @@ KVM_ONE_VCPU_TEST(sync_regs_test, read_invalid, guest_code)
 
 KVM_ONE_VCPU_TEST(sync_regs_test, set_invalid, guest_code)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int rv;
 
 	/* Request setting invalid register set into VCPU. */
@@ -249,7 +249,7 @@ KVM_ONE_VCPU_TEST(sync_regs_test, set_invalid, guest_code)
 
 KVM_ONE_VCPU_TEST(sync_regs_test, req_and_verify_all_valid, guest_code)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_vcpu_events events;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
@@ -272,7 +272,7 @@ KVM_ONE_VCPU_TEST(sync_regs_test, req_and_verify_all_valid, guest_code)
 
 KVM_ONE_VCPU_TEST(sync_regs_test, set_and_verify_various, guest_code)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_vcpu_events events;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
@@ -310,7 +310,7 @@ KVM_ONE_VCPU_TEST(sync_regs_test, set_and_verify_various, guest_code)
 
 KVM_ONE_VCPU_TEST(sync_regs_test, clear_kvm_dirty_regs_bits, guest_code)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	/* Clear kvm_dirty_regs bits, verify new s.regs values are
 	 * overwritten with existing guest values.
@@ -327,7 +327,7 @@ KVM_ONE_VCPU_TEST(sync_regs_test, clear_kvm_dirty_regs_bits, guest_code)
 
 KVM_ONE_VCPU_TEST(sync_regs_test, clear_kvm_valid_and_dirty_regs, guest_code)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_regs regs;
 
 	/* Run once to get register set */
@@ -358,7 +358,7 @@ KVM_ONE_VCPU_TEST(sync_regs_test, clear_kvm_valid_and_dirty_regs, guest_code)
 
 KVM_ONE_VCPU_TEST(sync_regs_test, clear_kvm_valid_regs_bits, guest_code)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	struct kvm_regs regs;
 
 	/* Run once to get register set */
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index 56306a19144a..bbd8344046e3 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -86,7 +86,7 @@ int main(void)
 	}
 
 	vm_enable_cap(vm, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 1);
-	run = vcpu->run;
+	run = vcpu->common->run;
 	vcpu_run(vcpu);
 
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index 12b0964f4f13..9356a4da7cec 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -87,7 +87,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu->run->exit_reason));
+			    exit_reason_str(vcpu->common->run->exit_reason));
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index 9481cbcf284f..d2165b76c93a 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -59,7 +59,7 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	memset(&regs, 0, sizeof(regs));
 
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 32b2794b78fe..dc2ab9a7fc3d 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -379,7 +379,7 @@ static void check_for_guest_assert(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	if (vcpu->run->exit_reason == KVM_EXIT_IO &&
+	if (vcpu->common->run->exit_reason == KVM_EXIT_IO &&
 	    get_ucall(vcpu, &uc) == UCALL_ABORT) {
 		REPORT_GUEST_ASSERT(uc);
 	}
@@ -387,7 +387,7 @@ static void check_for_guest_assert(struct kvm_vcpu *vcpu)
 
 static void process_rdmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	check_for_guest_assert(vcpu);
 
@@ -419,7 +419,7 @@ static void process_rdmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 
 static void process_wrmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	check_for_guest_assert(vcpu);
 
@@ -626,7 +626,7 @@ static void handle_wrmsr(struct kvm_run *run)
 KVM_ONE_VCPU_TEST(user_msr, msr_filter_deny, guest_code_filter_deny)
 {
 	struct kvm_vm *vm = vcpu->vm;
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 	int rc;
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
index a81a24761aac..e36ea3afd548 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -91,7 +91,7 @@ int main(int argc, char *argv[])
 	vcpu_args_set(vcpu, 2, vmx_pages_gva, high_gpa);
 
 	while (!done) {
-		volatile struct kvm_run *run = vcpu->run;
+		volatile struct kvm_run *run = vcpu->common->run;
 		struct ucall uc;
 
 		vcpu_run(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index dad988351493..e2b5ac2af396 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -60,7 +60,7 @@ int main(int argc, char *argv[])
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
+		volatile struct kvm_run *run = vcpu->common->run;
 		struct ucall uc;
 
 		vcpu_run(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
index 3fd6eceab46f..f7cb3eec4a17 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
@@ -22,7 +22,7 @@ static void guest_code(void)
 
 static void __run_vcpu_with_invalid_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
+	struct kvm_run *run = vcpu->common->run;
 
 	vcpu_run(vcpu);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
index a100ee5f0009..8006d6d11ccd 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
@@ -68,7 +68,7 @@ int main(int argc, char *argv[])
 
 	vcpu_run(vcpu);
 
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	/*
 	 * The first exit to L0 userspace should be an I/O access from L2.
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index 95ce192d0753..b1427e8835de 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -107,7 +107,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
+	run = vcpu->common->run;
 
 	while (1) {
 		vcpu_run(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index e149d0574961..30f2aee1f1e9 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -102,7 +102,7 @@ int main(int argc, char *argv[])
 	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 2);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
+		volatile struct kvm_run *run = vcpu->common->run;
 		struct ucall uc;
 
 		vcpu_run(vcpu);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 0ee4816b079a..a54c27b0f8c9 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -37,9 +37,9 @@ void kvm_async_pf_deinit(void)
 
 void kvm_async_pf_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	INIT_LIST_HEAD(&vcpu->async_pf.done);
-	INIT_LIST_HEAD(&vcpu->async_pf.queue);
-	spin_lock_init(&vcpu->async_pf.lock);
+	INIT_LIST_HEAD(&vcpu->common->async_pf.done);
+	INIT_LIST_HEAD(&vcpu->common->async_pf.queue);
+	spin_lock_init(&vcpu->common->async_pf.lock);
 }
 
 static void async_pf_execute(struct work_struct *work)
@@ -77,10 +77,10 @@ static void async_pf_execute(struct work_struct *work)
 	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
 		kvm_arch_async_page_present(vcpu, apf);
 
-	spin_lock(&vcpu->async_pf.lock);
-	first = list_empty(&vcpu->async_pf.done);
-	list_add_tail(&apf->link, &vcpu->async_pf.done);
-	spin_unlock(&vcpu->async_pf.lock);
+	spin_lock(&vcpu->common->async_pf.lock);
+	first = list_empty(&vcpu->common->async_pf.done);
+	list_add_tail(&apf->link, &vcpu->common->async_pf.done);
+	spin_unlock(&vcpu->common->async_pf.lock);
 
 	/*
 	 * The apf struct may be freed by kvm_check_async_pf_completion() as
@@ -120,9 +120,9 @@ static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 {
 	/* cancel outstanding work queue item */
-	while (!list_empty(&vcpu->async_pf.queue)) {
+	while (!list_empty(&vcpu->common->async_pf.queue)) {
 		struct kvm_async_pf *work =
-			list_first_entry(&vcpu->async_pf.queue,
+			list_first_entry(&vcpu->common->async_pf.queue,
 					 typeof(*work), queue);
 		list_del(&work->queue);
 
@@ -134,40 +134,40 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 #endif
 	}
 
-	spin_lock(&vcpu->async_pf.lock);
-	while (!list_empty(&vcpu->async_pf.done)) {
+	spin_lock(&vcpu->common->async_pf.lock);
+	while (!list_empty(&vcpu->common->async_pf.done)) {
 		struct kvm_async_pf *work =
-			list_first_entry(&vcpu->async_pf.done,
+			list_first_entry(&vcpu->common->async_pf.done,
 					 typeof(*work), link);
 		list_del(&work->link);
 
-		spin_unlock(&vcpu->async_pf.lock);
+		spin_unlock(&vcpu->common->async_pf.lock);
 		kvm_flush_and_free_async_pf_work(work);
-		spin_lock(&vcpu->async_pf.lock);
+		spin_lock(&vcpu->common->async_pf.lock);
 	}
-	spin_unlock(&vcpu->async_pf.lock);
+	spin_unlock(&vcpu->common->async_pf.lock);
 
-	vcpu->async_pf.queued = 0;
+	vcpu->common->async_pf.queued = 0;
 }
 
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
 
-	while (!list_empty_careful(&vcpu->async_pf.done) &&
+	while (!list_empty_careful(&vcpu->common->async_pf.done) &&
 	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
-		spin_lock(&vcpu->async_pf.lock);
-		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
+		spin_lock(&vcpu->common->async_pf.lock);
+		work = list_first_entry(&vcpu->common->async_pf.done, typeof(*work),
 					      link);
 		list_del(&work->link);
-		spin_unlock(&vcpu->async_pf.lock);
+		spin_unlock(&vcpu->common->async_pf.lock);
 
 		kvm_arch_async_page_ready(vcpu, work);
 		if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
 			kvm_arch_async_page_present(vcpu, work);
 
 		list_del(&work->queue);
-		vcpu->async_pf.queued--;
+		vcpu->common->async_pf.queued--;
 		kvm_flush_and_free_async_pf_work(work);
 	}
 }
@@ -181,7 +181,7 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 {
 	struct kvm_async_pf *work;
 
-	if (vcpu->async_pf.queued >= ASYNC_PF_PER_VCPU)
+	if (vcpu->common->async_pf.queued >= ASYNC_PF_PER_VCPU)
 		return false;
 
 	/* Arch specific code should not do async PF in this case */
@@ -204,8 +204,8 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	INIT_WORK(&work->work, async_pf_execute);
 
-	list_add_tail(&work->queue, &vcpu->async_pf.queue);
-	vcpu->async_pf.queued++;
+	list_add_tail(&work->queue, &vcpu->common->async_pf.queue);
+	vcpu->common->async_pf.queued++;
 	work->notpresent_injected = kvm_arch_async_page_not_present(vcpu, work);
 
 	schedule_work(&work->work);
@@ -218,7 +218,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	struct kvm_async_pf *work;
 	bool first;
 
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (!list_empty_careful(&vcpu->common->async_pf.done))
 		return 0;
 
 	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
@@ -228,14 +228,14 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	work->wakeup_all = true;
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
 
-	spin_lock(&vcpu->async_pf.lock);
-	first = list_empty(&vcpu->async_pf.done);
-	list_add_tail(&work->link, &vcpu->async_pf.done);
-	spin_unlock(&vcpu->async_pf.lock);
+	spin_lock(&vcpu->common->async_pf.lock);
+	first = list_empty(&vcpu->common->async_pf.done);
+	list_add_tail(&work->link, &vcpu->common->async_pf.done);
+	spin_unlock(&vcpu->common->async_pf.lock);
 
 	if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC) && first)
 		kvm_arch_async_page_present_queued(vcpu);
 
-	vcpu->async_pf.queued++;
+	vcpu->common->async_pf.queued++;
 	return 0;
 }
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 7bc74969a819..370e64680548 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -171,7 +171,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 
 void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset)
 {
-	struct kvm_dirty_ring *ring = &vcpu->dirty_ring;
+	struct kvm_dirty_ring *ring = &vcpu->common->dirty_ring;
 	struct kvm_dirty_gfn *entry;
 
 	/* It should never get full */
@@ -203,9 +203,9 @@ bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
 	 * the dirty ring is reset by userspace.
 	 */
 	if (kvm_check_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu) &&
-	    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
+	    kvm_dirty_ring_soft_full(&vcpu->common->dirty_ring)) {
 		kvm_make_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
-		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
+		vcpu->common->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
 		trace_kvm_dirty_ring_exit(vcpu);
 		return true;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92901656a0d4..d1874848862d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -343,7 +343,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	 * - powerpc: smp_mb in kvmppc_prepare_to_enter.
 	 *
 	 * There is already an smp_mb__after_atomic() before
-	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
+	 * kvm_make_all_cpus_request() reads vcpu->common->mode. We reuse that
 	 * barrier here.
 	 */
 	if (!kvm_arch_flush_remote_tlbs(kvm)
@@ -481,41 +481,43 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
-	mutex_init(&vcpu->mutex);
+	vcpu->common = &vcpu->_common;
+
+	mutex_init(&vcpu->common->mutex);
 	vcpu->cpu = -1;
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
-	vcpu->pid = NULL;
+	vcpu->common->pid = NULL;
 #ifndef __KVM_HAVE_ARCH_WQP
-	rcuwait_init(&vcpu->wait);
+	rcuwait_init(&vcpu->common->wait);
 #endif
 	kvm_async_pf_vcpu_init(vcpu);
 
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
 	kvm_vcpu_set_dy_eligible(vcpu, false);
-	vcpu->preempted = false;
-	vcpu->ready = false;
+	vcpu->common->preempted = false;
+	vcpu->common->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
-	vcpu->last_used_slot = NULL;
+	vcpu->common->last_used_slot = NULL;
 
 	/* Fill the stats id string for the vcpu */
-	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
+	snprintf(vcpu->common->stats_id, sizeof(vcpu->common->stats_id), "kvm-%d/vcpu-%d",
 		 task_pid_nr(current), id);
 }
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_vcpu_destroy(vcpu);
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
+	kvm_dirty_ring_free(&vcpu->common->dirty_ring);
 
 	/*
 	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes
 	 * the vcpu->pid pointer, and at destruction time all file descriptors
 	 * are already gone.
 	 */
-	put_pid(rcu_dereference_protected(vcpu->pid, 1));
+	put_pid(rcu_dereference_protected(vcpu->common->pid, 1));
 
-	free_page((unsigned long)vcpu->run);
+	free_page((unsigned long)vcpu->common->run);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
@@ -2606,12 +2608,12 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 	 * This also protects against using a memslot from a different address space,
 	 * since different address spaces have different generation numbers.
 	 */
-	if (unlikely(gen != vcpu->last_used_slot_gen)) {
-		vcpu->last_used_slot = NULL;
-		vcpu->last_used_slot_gen = gen;
+	if (unlikely(gen != vcpu->common->last_used_slot_gen)) {
+		vcpu->common->last_used_slot = NULL;
+		vcpu->common->last_used_slot_gen = gen;
 	}
 
-	slot = try_get_memslot(vcpu->last_used_slot, gfn);
+	slot = try_get_memslot(vcpu->common->last_used_slot, gfn);
 	if (slot)
 		return slot;
 
@@ -2622,7 +2624,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 	 */
 	slot = search_memslots(slots, gfn, false);
 	if (slot) {
-		vcpu->last_used_slot = slot;
+		vcpu->common->last_used_slot = slot;
 		return slot;
 	}
 
@@ -3638,7 +3640,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->sigset_active)
+	if (!vcpu->common->sigset_active)
 		return;
 
 	/*
@@ -3647,12 +3649,12 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 	 * ->real_blocked don't care as long ->real_blocked is always a subset
 	 * of ->blocked.
 	 */
-	sigprocmask(SIG_SETMASK, &vcpu->sigset, &current->real_blocked);
+	sigprocmask(SIG_SETMASK, &vcpu->common->sigset, &current->real_blocked);
 }
 
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->sigset_active)
+	if (!vcpu->common->sigset_active)
 		return;
 
 	sigprocmask(SIG_SETMASK, &current->real_blocked, NULL);
@@ -3663,7 +3665,7 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
 	unsigned int old, val, grow, grow_start;
 
-	old = val = vcpu->halt_poll_ns;
+	old = val = vcpu->common->halt_poll_ns;
 	grow_start = READ_ONCE(halt_poll_ns_grow_start);
 	grow = READ_ONCE(halt_poll_ns_grow);
 	if (!grow)
@@ -3673,7 +3675,7 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 	if (val < grow_start)
 		val = grow_start;
 
-	vcpu->halt_poll_ns = val;
+	vcpu->common->halt_poll_ns = val;
 out:
 	trace_kvm_halt_poll_ns_grow(vcpu->vcpu_id, val, old);
 }
@@ -3682,7 +3684,7 @@ static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
 	unsigned int old, val, shrink, grow_start;
 
-	old = val = vcpu->halt_poll_ns;
+	old = val = vcpu->common->halt_poll_ns;
 	shrink = READ_ONCE(halt_poll_ns_shrink);
 	grow_start = READ_ONCE(halt_poll_ns_grow_start);
 	if (shrink == 0)
@@ -3693,7 +3695,7 @@ static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 	if (val < grow_start)
 		val = 0;
 
-	vcpu->halt_poll_ns = val;
+	vcpu->common->halt_poll_ns = val;
 	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
 }
 
@@ -3727,7 +3729,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	bool waited = false;
 
-	vcpu->stat.generic.blocking = 1;
+	vcpu->common->stat.generic.blocking = 1;
 
 	preempt_disable();
 	kvm_arch_vcpu_blocking(vcpu);
@@ -3749,7 +3751,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	preempt_enable();
 
-	vcpu->stat.generic.blocking = 0;
+	vcpu->common->stat.generic.blocking = 0;
 
 	return waited;
 }
@@ -3757,16 +3759,16 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 					  ktime_t end, bool success)
 {
-	struct kvm_vcpu_stat_generic *stats = &vcpu->stat.generic;
+	struct kvm_vcpu_stat_generic *stats = &vcpu->common->stat.generic;
 	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
 
-	++vcpu->stat.generic.halt_attempted_poll;
+	++vcpu->common->stat.generic.halt_attempted_poll;
 
 	if (success) {
-		++vcpu->stat.generic.halt_successful_poll;
+		++vcpu->common->stat.generic.halt_successful_poll;
 
 		if (!vcpu_valid_wakeup(vcpu))
-			++vcpu->stat.generic.halt_poll_invalid;
+			++vcpu->common->stat.generic.halt_poll_invalid;
 
 		stats->halt_poll_success_ns += poll_ns;
 		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_success_hist, poll_ns);
@@ -3809,14 +3811,14 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 	bool do_halt_poll;
 	u64 halt_ns;
 
-	if (vcpu->halt_poll_ns > max_halt_poll_ns)
-		vcpu->halt_poll_ns = max_halt_poll_ns;
+	if (vcpu->common->halt_poll_ns > max_halt_poll_ns)
+		vcpu->common->halt_poll_ns = max_halt_poll_ns;
 
-	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
+	do_halt_poll = halt_poll_allowed && vcpu->common->halt_poll_ns;
 
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
-		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
+		ktime_t stop = ktime_add_ns(start, vcpu->common->halt_poll_ns);
 
 		do {
 			if (kvm_vcpu_check_block(vcpu) < 0)
@@ -3830,9 +3832,9 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 
 	cur = ktime_get();
 	if (waited) {
-		vcpu->stat.generic.halt_wait_ns +=
+		vcpu->common->stat.generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(poll_end);
-		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.generic.halt_wait_hist,
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->common->stat.generic.halt_wait_hist,
 				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
 out:
@@ -3854,18 +3856,18 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
 		} else if (max_halt_poll_ns) {
-			if (halt_ns <= vcpu->halt_poll_ns)
+			if (halt_ns <= vcpu->common->halt_poll_ns)
 				;
 			/* we had a long block, shrink polling */
-			else if (vcpu->halt_poll_ns &&
+			else if (vcpu->common->halt_poll_ns &&
 				 halt_ns > max_halt_poll_ns)
 				shrink_halt_poll_ns(vcpu);
 			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+			else if (vcpu->common->halt_poll_ns < max_halt_poll_ns &&
 				 halt_ns < max_halt_poll_ns)
 				grow_halt_poll_ns(vcpu);
 		} else {
-			vcpu->halt_poll_ns = 0;
+			vcpu->common->halt_poll_ns = 0;
 		}
 	}
 
@@ -3876,8 +3878,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
 	if (__kvm_vcpu_wake_up(vcpu)) {
-		WRITE_ONCE(vcpu->ready, true);
-		++vcpu->stat.generic.halt_wakeup;
+		WRITE_ONCE(vcpu->common->ready, true);
+		++vcpu->common->stat.generic.halt_wakeup;
 		return true;
 	}
 
@@ -3904,8 +3906,8 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * within the vCPU thread itself.
 	 */
 	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
-		if (vcpu->mode == IN_GUEST_MODE)
-			WRITE_ONCE(vcpu->mode, EXITING_GUEST_MODE);
+		if (vcpu->common->mode == IN_GUEST_MODE)
+			WRITE_ONCE(vcpu->common->mode, EXITING_GUEST_MODE);
 		goto out;
 	}
 
@@ -3934,7 +3936,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 	int ret = 0;
 
 	rcu_read_lock();
-	pid = rcu_dereference(target->pid);
+	pid = rcu_dereference(target->common->pid);
 	if (pid)
 		task = get_pid_task(pid, PIDTYPE_PID);
 	rcu_read_unlock();
@@ -3974,11 +3976,11 @@ static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 	bool eligible;
 
-	eligible = !vcpu->spin_loop.in_spin_loop ||
-		    vcpu->spin_loop.dy_eligible;
+	eligible = !vcpu->common->spin_loop.in_spin_loop ||
+		    vcpu->common->spin_loop.dy_eligible;
 
-	if (vcpu->spin_loop.in_spin_loop)
-		kvm_vcpu_set_dy_eligible(vcpu, !vcpu->spin_loop.dy_eligible);
+	if (vcpu->common->spin_loop.in_spin_loop)
+		kvm_vcpu_set_dy_eligible(vcpu, !vcpu->common->spin_loop.dy_eligible);
 
 	return eligible;
 #else
@@ -4002,7 +4004,7 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
 		return true;
 
 #ifdef CONFIG_KVM_ASYNC_PF
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (!list_empty_careful(&vcpu->common->async_pf.done))
 		return true;
 #endif
 
@@ -4052,7 +4054,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			} else if (pass && i > last_boosted_vcpu)
 				break;
-			if (!READ_ONCE(vcpu->ready))
+			if (!READ_ONCE(vcpu->common->ready))
 				continue;
 			if (vcpu == me)
 				continue;
@@ -4065,7 +4067,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			 * be spinning waiting on IPI delivery, i.e. the target
 			 * vCPU is in-kernel for the purposes of directed yield.
 			 */
-			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+			if (READ_ONCE(vcpu->common->preempted) && yield_to_kernel_mode &&
 			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
 			    !kvm_arch_vcpu_preempted_in_kernel(vcpu))
 				continue;
@@ -4107,7 +4109,7 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 	struct page *page;
 
 	if (vmf->pgoff == 0)
-		page = virt_to_page(vcpu->run);
+		page = virt_to_page(vcpu->common->run);
 #ifdef CONFIG_X86
 	else if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
 		page = virt_to_page(vcpu->arch.pio_data);
@@ -4118,7 +4120,7 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 #endif
 	else if (kvm_page_in_dirty_ring(vcpu->kvm, vmf->pgoff))
 		page = kvm_dirty_ring_get_page(
-		    &vcpu->dirty_ring,
+		    &vcpu->common->dirty_ring,
 		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
 	else
 		return kvm_arch_vcpu_fault(vcpu, vmf);
@@ -4178,7 +4180,7 @@ static int vcpu_get_pid(void *data, u64 *val)
 	struct kvm_vcpu *vcpu = data;
 
 	rcu_read_lock();
-	*val = pid_nr(rcu_dereference(vcpu->pid));
+	*val = pid_nr(rcu_dereference(vcpu->common->pid));
 	rcu_read_unlock();
 	return 0;
 }
@@ -4245,22 +4247,22 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 		goto vcpu_decrement;
 	}
 
+	kvm_vcpu_init(vcpu, kvm, id);
+
 	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
 		goto vcpu_free;
 	}
-	vcpu->run = page_address(page);
-
-	kvm_vcpu_init(vcpu, kvm, id);
+	vcpu->common->run = page_address(page);
 
 	r = kvm_arch_vcpu_create(vcpu);
 	if (r)
 		goto vcpu_free_run_page;
 
 	if (kvm->dirty_ring_size) {
-		r = kvm_dirty_ring_alloc(&vcpu->dirty_ring,
+		r = kvm_dirty_ring_alloc(&vcpu->common->dirty_ring,
 					 id, kvm->dirty_ring_size);
 		if (r)
 			goto arch_vcpu_destroy;
@@ -4269,9 +4271,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	mutex_lock(&kvm->lock);
 
 #ifdef CONFIG_LOCKDEP
-	/* Ensure that lockdep knows vcpu->mutex is taken *inside* kvm->lock */
-	mutex_lock(&vcpu->mutex);
-	mutex_unlock(&vcpu->mutex);
+	/* Ensure that lockdep knows vcpu->common->mutex is taken *inside* kvm->lock */
+	mutex_lock(&vcpu->common->mutex);
+	mutex_unlock(&vcpu->common->mutex);
 #endif
 
 	if (kvm_get_vcpu_by_id(kvm, id)) {
@@ -4312,11 +4314,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
+	kvm_dirty_ring_free(&vcpu->common->dirty_ring);
 arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_free_run_page:
-	free_page((unsigned long)vcpu->run);
+	free_page((unsigned long)vcpu->common->run);
 vcpu_free:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 vcpu_decrement:
@@ -4330,10 +4332,10 @@ static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
 {
 	if (sigset) {
 		sigdelsetmask(sigset, sigmask(SIGKILL)|sigmask(SIGSTOP));
-		vcpu->sigset_active = 1;
-		vcpu->sigset = *sigset;
+		vcpu->common->sigset_active = 1;
+		vcpu->common->sigset = *sigset;
 	} else
-		vcpu->sigset_active = 0;
+		vcpu->common->sigset_active = 0;
 	return 0;
 }
 
@@ -4342,9 +4344,9 @@ static ssize_t kvm_vcpu_stats_read(struct file *file, char __user *user_buffer,
 {
 	struct kvm_vcpu *vcpu = file->private_data;
 
-	return kvm_stats_read(vcpu->stats_id, &kvm_vcpu_stats_header,
-			&kvm_vcpu_stats_desc[0], &vcpu->stat,
-			sizeof(vcpu->stat), user_buffer, size, offset);
+	return kvm_stats_read(vcpu->common->stats_id, &kvm_vcpu_stats_header,
+			&kvm_vcpu_stats_desc[0], &vcpu->common->stat,
+			sizeof(vcpu->common->stat), user_buffer, size, offset);
 }
 
 static int kvm_vcpu_stats_release(struct inode *inode, struct file *file)
@@ -4457,7 +4459,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (r != -ENOIOCTLCMD)
 		return r;
 
-	if (mutex_lock_killable(&vcpu->mutex))
+	if (mutex_lock_killable(&vcpu->common->mutex))
 		return -EINTR;
 	switch (ioctl) {
 	case KVM_RUN: {
@@ -4465,7 +4467,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 		if (arg)
 			goto out;
-		oldpid = rcu_access_pointer(vcpu->pid);
+		oldpid = rcu_access_pointer(vcpu->common->pid);
 		if (unlikely(oldpid != task_pid(current))) {
 			/* The thread running this VCPU changed. */
 			struct pid *newpid;
@@ -4475,16 +4477,16 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				break;
 
 			newpid = get_task_pid(current, PIDTYPE_PID);
-			rcu_assign_pointer(vcpu->pid, newpid);
+			rcu_assign_pointer(vcpu->common->pid, newpid);
 			if (oldpid)
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
-		vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit__unsafe);
+		vcpu->common->wants_to_run = !READ_ONCE(vcpu->common->run->immediate_exit__unsafe);
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
-		vcpu->wants_to_run = false;
+		vcpu->common->wants_to_run = false;
 
-		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
+		trace_kvm_userspace_exit(vcpu->common->run->exit_reason, r);
 		break;
 	}
 	case KVM_GET_REGS: {
@@ -4655,7 +4657,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
 out:
-	mutex_unlock(&vcpu->mutex);
+	mutex_unlock(&vcpu->common->mutex);
 	kfree(fpu);
 	kfree(kvm_sregs);
 	return r;
@@ -4993,7 +4995,7 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 	mutex_lock(&kvm->slots_lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
+		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->common->dirty_ring);
 
 	mutex_unlock(&kvm->slots_lock);
 
@@ -6122,7 +6124,7 @@ static int kvm_get_stat_per_vcpu(struct kvm *kvm, size_t offset, u64 *val)
 	*val = 0;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		*val += *(u64 *)((void *)(&vcpu->stat) + offset);
+		*val += *(u64 *)((void *)(&vcpu->common->stat) + offset);
 
 	return 0;
 }
@@ -6133,7 +6135,7 @@ static int kvm_clear_stat_per_vcpu(struct kvm *kvm, size_t offset)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		*(u64 *)((void *)(&vcpu->stat) + offset) = 0;
+		*(u64 *)((void *)(&vcpu->common->stat) + offset) = 0;
 
 	return 0;
 }
@@ -6359,13 +6361,13 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	WRITE_ONCE(vcpu->preempted, false);
-	WRITE_ONCE(vcpu->ready, false);
+	WRITE_ONCE(vcpu->common->preempted, false);
+	WRITE_ONCE(vcpu->common->ready, false);
 
 	__this_cpu_write(kvm_running_vcpu, vcpu);
 	kvm_arch_vcpu_load(vcpu, cpu);
 
-	WRITE_ONCE(vcpu->scheduled_out, false);
+	WRITE_ONCE(vcpu->common->scheduled_out, false);
 }
 
 static void kvm_sched_out(struct preempt_notifier *pn,
@@ -6373,11 +6375,11 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	WRITE_ONCE(vcpu->scheduled_out, true);
+	WRITE_ONCE(vcpu->common->scheduled_out, true);
 
-	if (current->on_rq && vcpu->wants_to_run) {
-		WRITE_ONCE(vcpu->preempted, true);
-		WRITE_ONCE(vcpu->ready, true);
+	if (current->on_rq && vcpu->common->wants_to_run) {
+		WRITE_ONCE(vcpu->common->preempted, true);
+		WRITE_ONCE(vcpu->common->ready, true);
 	}
 	kvm_arch_vcpu_put(vcpu);
 	__this_cpu_write(kvm_running_vcpu, NULL);
@@ -6477,7 +6479,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		kmem_cache_create_usercopy("kvm_vcpu", vcpu_size, vcpu_align,
 					   SLAB_ACCOUNT,
 					   offsetof(struct kvm_vcpu, arch),
-					   offsetofend(struct kvm_vcpu, stats_id)
+					   offsetofend(struct kvm_vcpu, _common)
 					   - offsetof(struct kvm_vcpu, arch),
 					   NULL);
 	if (!kvm_vcpu_cache) {
-- 
2.43.0


