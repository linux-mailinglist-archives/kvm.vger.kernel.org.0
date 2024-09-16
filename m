Return-Path: <kvm+bounces-27008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A4197A731
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9313E1C21D18
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B3F15956C;
	Mon, 16 Sep 2024 18:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="efXLiX5b";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="efXLiX5b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB151757D;
	Mon, 16 Sep 2024 18:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726510691; cv=none; b=YSjKt2/t/xIM5/yxcEGnzD3aCyIBaRqeWk70D3vWz6qoH161wbHeBxDO+otVy7ICHLHDLJDDZ/AFvpYLdoIbJgjLIYixLl3iSc5BVGcp8lqiGOY/Q5zF48Jopf3XM1xdFa24W/Q2W5G2JknQcVEuYPcJMoNCLHoqAEq6wsizQPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726510691; c=relaxed/simple;
	bh=m229F7lTAsNvK6HcL/O64g5VlZo0y/U95D0dCXRtmtM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LsW4tRo5nJP6Rz2cOXiqxvHqyf0CAJ+RS6q5xoEedAcsVqfsGipaybno0rZ9iZbTbtCsyxoVQJcqRd3SnN+Al52jG9jJM3HHO/DePMRPCzwn/fjkeS36L12mtpfxfkCFjYTev3hNSKoyoziNy+qp6oAEKYk1aL2uSXigwDx6hYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=efXLiX5b; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=efXLiX5b; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6746E21C28;
	Mon, 16 Sep 2024 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DSY+rRM/oRoUBLntwZdVzVpI0q9tw7YCBKmspwhGVp4=;
	b=efXLiX5bV0bpflHPeVNZjbTmGMpXZzfEjCbINJwJbRz8OLL0kGha7r/H+KgipvzuTbmmV1
	d5nY/TZBG5QkQAlhoY77jGRKqQRmwTjqjpwIZ+Mzp7jGWtnuEMR+EjupqxAs0mw6I0YOLU
	4Es+E8OyMJI8o0OyY045Sqs1gww27ls=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DSY+rRM/oRoUBLntwZdVzVpI0q9tw7YCBKmspwhGVp4=;
	b=efXLiX5bV0bpflHPeVNZjbTmGMpXZzfEjCbINJwJbRz8OLL0kGha7r/H+KgipvzuTbmmV1
	d5nY/TZBG5QkQAlhoY77jGRKqQRmwTjqjpwIZ+Mzp7jGWtnuEMR+EjupqxAs0mw6I0YOLU
	4Es+E8OyMJI8o0OyY045Sqs1gww27ls=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFCEC139CE;
	Mon, 16 Sep 2024 18:18:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Nu85LF526GbveAAAD6G6ig
	(envelope-from <roy.hopkins@suse.com>); Mon, 16 Sep 2024 18:18:06 +0000
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
Subject: [RFC PATCH 0/5] Extend SEV-SNP SVSM support with a kvm_vcpu per VMPL
Date: Mon, 16 Sep 2024 19:17:52 +0100
Message-ID: <cover.1726506534.git.roy.hopkins@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

I've prepared this series as an extension to the RFC patch series: 'SEV-SNP
support for running an SVSM' posted by Tom Lendacky [1]. This extends the
support for transitioning a vCPU between VM Privilege Levels (VMPLs) by
storing the vCPU state for each VMPL in its own `struct kvm_vcpu`. This
additionally allows for separate APICs for each VMPL.

In treating each VMPL as a `struct kvm_vcpu` it makes it very simple to 
perform a VMPL transition. In most cases it is a simple as just switching
the context from one kvm_vcpu pointer to another. This results in very
low overhead VMPL switches. This can can also support the case where a VMPL
switch occurs during guest execution - something that we will need to support
for Intel TDX and perhaps other isolation technologies.

Obviously, there is much to consider when splitting a single vCPU into being
managed by multiple `struct kvm_vcpu`s. First and foremost is the fact that
much of the state should be shared between all kvm_vcpu's that relate to a
single vCPU, such as the vCPU ID, requests, mutexes, etc. This series
introduces a solution where the common fields are accessed via a pointer in
each kvm_vcpu. Unfortunately this means that any code that refers to these
fields needs to be updated, resulting in the first patch in the series that
touches many areas of the code.

This is very much proof-of-concept code and, like Tom's series, is introduced
to trigger discussions around implementing VMPL support and not intended for
merging at this stage. The code currently has some instabilities during guest
startup which I need to locate.

This series is based off the same tip tree as [1], and the patches from that
series need to be applied before this series:
  https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master

  b0c57a7002b0 ("Merge branch into tip/master: 'x86/cpu'")

[1] Provide SEV-SNP support for running under an SVSM
https://lore.kernel.org/lkml/cover.1706307364.git.thomas.lendacky@amd.com/

Roy Hopkins (5):
  kvm: Move kvm_vcpu fields into common structure
  x86/kvm: Create a child struct kvm_vcpu for each VMPL
  kvm/sev: Update SEV VMPL handling to use multiple struct kvm_vcpus
  x86/kvm: Add x86 field to find the default VMPL that IRQs should
    target
  x86/kvm: Add target VMPL to IRQs and send to APIC for VMPL

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
 arch/mips/kvm/emulate.c                       |  94 ++--
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
 arch/powerpc/kvm/powerpc.c                    |  62 +--
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
 arch/s390/kvm/interrupt.c                     |  82 ++--
 arch/s390/kvm/kvm-s390.c                      | 160 +++----
 arch/s390/kvm/kvm-s390.h                      |  12 +-
 arch/s390/kvm/priv.c                          | 186 ++++----
 arch/s390/kvm/pv.c                            |   2 +-
 arch/s390/kvm/sigp.c                          |  62 +--
 arch/s390/kvm/vsie.c                          |   6 +-
 arch/x86/include/asm/kvm_host.h               |   8 +
 arch/x86/kvm/cpuid.c                          |  78 ++--
 arch/x86/kvm/debugfs.c                        |   2 +-
 arch/x86/kvm/hyperv.c                         |  20 +-
 arch/x86/kvm/ioapic.c                         |   3 +
 arch/x86/kvm/irq_comm.c                       |   1 +
 arch/x86/kvm/kvm_cache_regs.h                 |   4 +-
 arch/x86/kvm/lapic.c                          |  10 +-
 arch/x86/kvm/mmu/mmu.c                        |  28 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/pmu.c                            |   2 +-
 arch/x86/kvm/svm/nested.c                     |   6 +-
 arch/x86/kvm/svm/sev.c                        | 231 +++++-----
 arch/x86/kvm/svm/svm.c                        | 122 +++---
 arch/x86/kvm/svm/svm.h                        |  36 +-
 arch/x86/kvm/trace.h                          |  12 +-
 arch/x86/kvm/vmx/nested.c                     |  18 +-
 arch/x86/kvm/vmx/posted_intr.c                |   2 +-
 arch/x86/kvm/vmx/sgx.c                        |   4 +-
 arch/x86/kvm/vmx/vmx.c                        | 128 +++---
 arch/x86/kvm/x86.c                            | 406 ++++++++++--------
 arch/x86/kvm/xen.c                            |  24 +-
 arch/x86/kvm/xen.h                            |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c             |  10 +-
 include/linux/kvm_host.h                      | 180 ++++----
 include/trace/events/kvm.h                    |  48 +++
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
 virt/kvm/kvm_main.c                           | 274 +++++++-----
 134 files changed, 1746 insertions(+), 1587 deletions(-)

-- 
2.43.0


