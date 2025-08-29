Return-Path: <kvm+bounces-56355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8D4B3C1BA
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 19:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D18011BA68C4
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD138342C8A;
	Fri, 29 Aug 2025 17:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bhfMjb6n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABA5341AA3
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756488458; cv=none; b=DMKT786KEwazXyx6zmAIiyyESchpLovD2yia742NNgeltnsVGd1McjpelnlWOsTb3k7XWEuJqLLgDhGtHWEag5kvxX8ica5fNlG7vJWYyekefzKsazgp6LzyWd9bDSjKq1fbrJP+HS2KHb0VUWPpCwq0exXIILzTJPTcYBZLqMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756488458; c=relaxed/simple;
	bh=0oPo0z9udsRw3FBDzdXm4YI4rjAsiGVGsBsgpZKUYxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fjSrGvx+HtGhrhcMQNJn+h6Rq/+Y1vZBtMCQygaOvRVHY5+ZEWQIRY+xS6z2tyf3vrh8ZSjVs1AEVgXVamX3Ll6iRRji3engUfgL9iOc83NCusfAEL6BdbnMUrBlRayXQAtT+cWnxTTv4HtyH5PmUs52BJd0I94wtPtXMB46aTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bhfMjb6n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756488453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7kpwuDFksK4MkfxysqJDIcI5j4cOj4EGr1wTOPuLSnc=;
	b=bhfMjb6not9MAhROnCd+IziqZ11YSoaT9MqNvwfwa2u9aFvUPaUccp2NaM0GK7LyH8s2E+
	BhPMqpQG1hP0GDh9gmSHI/o1+bbFVO5lYPKbnCSees/guZkKsEsKyvijSMg5pcQg6mAzl4
	eHHKcaX2eeLYP9dXontJFEdcjoYZWwA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-XKeSi6jaMN6uGctGBpVDRw-1; Fri,
 29 Aug 2025 13:27:30 -0400
X-MC-Unique: XKeSi6jaMN6uGctGBpVDRw-1
X-Mimecast-MFC-AGG-ID: XKeSi6jaMN6uGctGBpVDRw_1756488449
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29A4D195E906;
	Fri, 29 Aug 2025 17:27:29 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7BF4D19560B4;
	Fri, 29 Aug 2025 17:27:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 6.17-rc4
Date: Fri, 29 Aug 2025 13:27:26 -0400
Message-ID: <20250829172727.169887-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus,

The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 42a0305ab114975dbad3fe9efea06976dd62d381:

  Merge tag 'kvmarm-fixes-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2025-08-29 12:57:31 -0400)

It's a whole bunch of stuff that has accumulated since the merge
window.  Mostly due to ARM changes involving sysreg context switching,
it's quite on the larger side; there is a lot of unrelated fixed, but
here is an excerpt of the commit message from the biggest issue:

    Volodymyr reports (again!) that under some circumstances (E2H==0,
    walking S1 PTs), PAR_EL1 doesn't report the value of the latest
    walk in the CPU register, but that instead the value is written to
    the backing store.
    
    Further investigation indicates that the root cause of this is
    that a group of registers (PAR_EL1, TPIDR*_EL{0,1}, the *32_EL2 dregs)
    should always be considered as "on CPU", as they are not remapped
    between EL1 and EL2.
    
    We fail to treat them accordingly, and end-up considering that
    the register (PAR_EL1 in this example) should be written to memory
    instead of in the register.

Also, probably I won't be sending another until rc6 or rc7 unless
there's something egregious.  But with KVM Forum happening next week,
I expect that things will stay relatively calm.

Thanks,

Paolo

----------------------------------------------------------------
ARM:

- Correctly handle 'invariant' system registers for protected VMs

- Improved handling of VNCR data aborts, including external aborts

- Fixes for handling of FEAT_RAS for NV guests, providing a sane
  fault context during SEA injection and preventing the use of
  RASv1p1 fault injection hardware

- Ensure that page table destruction when a VM is destroyed gives an
  opportunity to reschedule

- Large fix to KVM's infrastructure for managing guest context loaded
  on the CPU, addressing issues where the output of AT emulation
  doesn't get reflected to the guest

- Fix AT S12 emulation to actually perform stage-2 translation when
  necessary

- Avoid attempting vLPI irqbypass when GICv4 has been explicitly
  disabled for a VM

- Minor KVM + selftest fixes

RISC-V:

- Fix pte settings within kvm_riscv_gstage_ioremap()

- Fix comments in kvm_riscv_check_vcpu_requests()

- Fix stack overrun when setting vlenb via ONE_REG

x86:

- Use array_index_nospec() to sanitize the target vCPU ID when handling PV
  IPIs and yields as the ID is guest-controlled.

- Drop a superfluous cpumask_empty() check when reclaiming SEV memory, as
  the common case, by far, is that at least one CPU will have entered the
  VM, and wbnoinvd_on_cpus_mask() will naturally handle the rare case where
  the set of have_run_cpus is empty.

Selftests (not KVM):

- Rename the is_signed_type() macro in kselftest_harness.h to is_signed_var()
  to fix a collision with linux/overflow.h.  The collision generates compiler
  warnings due to the two macros having different meaning.

----------------------------------------------------------------
Arnd Bergmann (1):
      kvm: arm64: use BUG() instead of BUG_ON(1)

Fangyu Yu (1):
      RISC-V: KVM: Fix pte settings within kvm_riscv_gstage_ioremap()

Fuad Tabba (3):
      KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for protected VMs
      KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef exception
      arm64: vgic-v2: Fix guest endianness check in hVHE mode

Marc Zyngier (14):
      KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 related fault
      KVM: arm64: selftest: Add standalone test checking for KVM's own UUID
      KVM: arm64: Correctly populate FAR_EL2 on nested SEA injection
      arm64: Add capability denoting FEAT_RASv1p1
      KVM: arm64: Handle RASv1p1 registers
      KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
      KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
      KVM: arm64: Make ID_AA64PFR1_EL1.RAS_frac writable
      KVM: arm64: Get rid of ARM64_FEATURE_MASK()
      KVM: arm64: Check for SYSREGS_ON_CPU before accessing the 32bit state
      KVM: arm64: Simplify sysreg access on exception delivery
      KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
      KVM: arm64: Remove __vcpu_{read,write}_sys_reg_{from,to}_cpu()
      KVM: arm64: nv: Fix ATS12 handling of single-stage translation

Mark Brown (1):
      KVM: arm64: selftests: Sync ID_AA64MMFR3_EL1 in set_id_regs

Oliver Upton (1):
      KVM: arm64: nv: Handle SEAs due to VNCR redirection

Paolo Bonzini (3):
      Merge tag 'kvm-x86-fixes-6.17-rc7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-riscv-fixes-6.17-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-fixes-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Quan Zhou (1):
      RISC-V: KVM: Correct kvm_riscv_check_vcpu_requests() comment

Radim Krčmář (1):
      RISC-V: KVM: fix stack overrun when loading vlenb

Raghavendra Rao Ananta (3):
      KVM: arm64: Don't attempt vLPI mappings when vPE allocation is disabled
      KVM: arm64: Split kvm_pgtable_stage2_destroy()
      KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables

Sean Christopherson (1):
      selftests: harness: Rename is_signed_type() to avoid collision with overflow.h

Thijs Raymakers (1):
      KVM: x86: use array_index_nospec with indices that come from guest

Yury Norov (1):
      KVM: SEV: don't check have_run_cpus in sev_writeback_caches()

 arch/arm64/include/asm/kvm_host.h                  | 111 +-----
 arch/arm64/include/asm/kvm_mmu.h                   |   1 +
 arch/arm64/include/asm/kvm_pgtable.h               |  30 ++
 arch/arm64/include/asm/kvm_pkvm.h                  |   4 +-
 arch/arm64/include/asm/kvm_ras.h                   |  25 --
 arch/arm64/include/asm/sysreg.h                    |   3 -
 arch/arm64/kernel/cpufeature.c                     |  24 ++
 arch/arm64/kvm/arm.c                               |   8 +-
 arch/arm64/kvm/at.c                                |   6 +-
 arch/arm64/kvm/emulate-nested.c                    |   2 +-
 arch/arm64/kvm/hyp/exception.c                     |  20 +-
 arch/arm64/kvm/hyp/nvhe/list_debug.c               |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +
 arch/arm64/kvm/hyp/pgtable.c                       |  25 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   5 +-
 arch/arm64/kvm/mmu.c                               |  65 +++-
 arch/arm64/kvm/nested.c                            |   5 +-
 arch/arm64/kvm/pkvm.c                              |  11 +-
 arch/arm64/kvm/sys_regs.c                          | 431 ++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   8 +
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   2 +-
 arch/arm64/kvm/vgic/vgic.h                         |  10 +-
 arch/arm64/tools/cpucaps                           |   1 +
 arch/riscv/kvm/mmu.c                               |   5 +-
 arch/riscv/kvm/vcpu.c                              |   2 +-
 arch/riscv/kvm/vcpu_vector.c                       |   2 +
 arch/x86/kvm/lapic.c                               |   2 +
 arch/x86/kvm/svm/sev.c                             |  10 +-
 arch/x86/kvm/x86.c                                 |   7 +-
 tools/arch/arm64/include/asm/sysreg.h              |   3 -
 tools/testing/selftests/kselftest_harness.h        |   4 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../testing/selftests/kvm/arm64/aarch32_id_regs.c  |   2 +-
 .../testing/selftests/kvm/arm64/debug-exceptions.c |  12 +-
 tools/testing/selftests/kvm/arm64/kvm-uuid.c       |  70 ++++
 tools/testing/selftests/kvm/arm64/no-vgic-v3.c     |   4 +-
 .../testing/selftests/kvm/arm64/page_fault_test.c  |   6 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   9 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c      |   2 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   6 +-
 41 files changed, 585 insertions(+), 368 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_ras.h
 create mode 100644 tools/testing/selftests/kvm/arm64/kvm-uuid.c


