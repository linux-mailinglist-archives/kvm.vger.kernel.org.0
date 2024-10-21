Return-Path: <kvm+bounces-29300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2039A70DE
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 19:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BDB61C21557
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 17:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE021EB9F3;
	Mon, 21 Oct 2024 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzgAR9r8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8CA47A73
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729531057; cv=none; b=DQPxv8gVvXYpvCEF9fT7XmxAvTFyydOYsjruI7oFKceiP5XyZZ2z9sdsgjHpHwiGFO5Ykgc5vI6JMKnXawVu4zXlhtXym09VXwnw2gSLQwRp3OBb2fN9xsL12AHcBIjfbnLATQgzoeY+X00LHoqo9M7Wq1SH30Nr9BnjThBrLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729531057; c=relaxed/simple;
	bh=Pssf58C9KYMaZ1C3qQd3lMGGHwG0fgPM4SOvOt42Fx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EzrYosjhrVukDrTevvmmfPQC0s80hCbS4Q8YeejzioiJcC675VR50hhnSMxX4OKX5h6Eb5lXD+eMblPuA91bpodIBDJ2eHEAciG4FQovWtYat4IN1crSKovAv3BZ3FIdKJB3HXUxOSshlNCJ3MbCMCBBMMA8cfYDW4PncDDP//o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzgAR9r8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729531054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nhOC5GPQkpePVojMReRZl5Tz4DJriOb7GbQOy4xKCGk=;
	b=gzgAR9r8ePLiTsObE5BBWEckCjI6xxguSyRj8mdOGC/0ACX5PWVQPSEImGR3aa1KJ3m8GC
	Nqkp+0w3rPLc6DBQ8LhZBgMNXKNYmMrI3XLG4HfsLN9eElRzOfUBn1/dWKPCzRuSKOB8t1
	4xmY5BNvM1iqCEq/22Bgw1IGOhWYoHM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-XrErIfc8NsWeZ0_SMJMbZw-1; Mon,
 21 Oct 2024 13:17:31 -0400
X-MC-Unique: XrErIfc8NsWeZ0_SMJMbZw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 195C61954232;
	Mon, 21 Oct 2024 17:17:30 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 67EAC1955F4B;
	Mon, 21 Oct 2024 17:17:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.12-rc5
Date: Mon, 21 Oct 2024 13:17:28 -0400
Message-ID: <20241021171728.274997-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Linus,

The following changes since commit c8d430db8eec7d4fd13a6bea27b7086a54eda6da:

  Merge tag 'kvmarm-fixes-6.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-10-06 03:59:22 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e9001a382fa2c256229adc68d55212028b01d515:

  Merge tag 'kvmarm-fixes-6.12-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-10-20 12:10:59 -0400)

After seeing your release commentary yesterday, well, this is not
going to make rc5 smaller.  The short description is that there is
mostly Arm stuff here (due to me sitting on submaintainer pull requests
for perhaps too long) and a bit of everything for x86 (host, guest,
selftests, docs).

Paolo

----------------------------------------------------------------
ARM64:

* Fix the guest view of the ID registers, making the relevant fields
  writable from userspace (affecting ID_AA64DFR0_EL1 and ID_AA64PFR1_EL1)

* Correcly expose S1PIE to guests, fixing a regression introduced
  in 6.12-rc1 with the S1POE support

* Fix the recycling of stage-2 shadow MMUs by tracking the context
  (are we allowed to block or not) as well as the recycling state

* Address a couple of issues with the vgic when userspace misconfigures
  the emulation, resulting in various splats. Headaches courtesy
  of our Syzkaller friends

* Stop wasting space in the HYP idmap, as we are dangerously close
  to the 4kB limit, and this has already exploded in -next

* Fix another race in vgic_init()

* Fix a UBSAN error when faking the cache topology with MTE
  enabled

RISCV:

* RISCV: KVM: use raw_spinlock for critical section in imsic

x86:

* A bandaid for lack of XCR0 setup in selftests, which causes trouble
  if the compiler is configured to have x86-64-v3 (with AVX) as the
  default ISA.  Proper XCR0 setup will come in the next merge window.

* Fix an issue where KVM would not ignore low bits of the nested CR3
  and potentially leak up to 31 bytes out of the guest memory's bounds

* Fix case in which an out-of-date cached value for the segments could
  by returned by KVM_GET_SREGS.

* More cleanups for KVM_X86_QUIRK_SLOT_ZAP_ALL

* Override MTRR state for KVM confidential guests, making it WB by
  default as is already the case for Hyper-V guests.

Generic:

* Remove a couple of unused functions

----------------------------------------------------------------
Cyan Yang (1):
      RISCV: KVM: use raw_spinlock for critical section in imsic

Dr. David Alan Gilbert (2):
      KVM: Remove unused kvm_vcpu_gfn_to_pfn
      KVM: Remove unused kvm_vcpu_gfn_to_pfn_atomic

Ilkka Koskinen (1):
      KVM: arm64: Fix shift-out-of-bounds bug

Kirill A. Shutemov (1):
      x86/kvm: Override default caching mode for SEV-SNP and TDX

Marc Zyngier (3):
      Merge branch kvm-arm64/idregs-6.12 into kvmarm/fixes
      KVM: arm64: Don't eagerly teardown the vgic on init error
      KVM: arm64: Shave a few bytes from the EL2 idmap code

Mark Brown (1):
      KVM: arm64: Expose S1PIE to guests

Maxim Levitsky (1):
      KVM: VMX: reset the segment cache after segment init in vmx_vcpu_reset()

Oliver Upton (7):
      KVM: arm64: Unregister redistributor for failed vCPU creation
      KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
      KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
      KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
      KVM: arm64: nv: Clarify safety of allowing TLBI unmaps to reschedule
      KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
      KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.12-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvmarm-fixes-6.12-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sean Christopherson (5):
      KVM: x86/mmu: Zap only SPs that shadow gPTEs when deleting memslot
      KVM: x86/mmu: Add lockdep assert to enforce safe usage of kvm_unmap_gfn_range()
      KVM: x86: Clean up documentation for KVM_X86_QUIRK_SLOT_ZAP_ALL
      KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory
      KVM: selftests: Fix out-of-bounds reads in CPUID test's array lookups

Shameer Kolothum (1):
      KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1 writable from userspace

Shaoqin Huang (4):
      KVM: arm64: Disable fields that KVM doesn't know how to handle in ID_AA64PFR1_EL1
      KVM: arm64: Use kvm_has_feat() to check if FEAT_SSBS is advertised to the guest
      KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
      KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1

Vitaly Kuznetsov (1):
      KVM: selftests: x86: Avoid using SSE/AVX instructions

 Documentation/virt/kvm/api.rst                    | 16 ++---
 Documentation/virt/kvm/locking.rst                |  2 +-
 arch/arm64/include/asm/kvm_asm.h                  |  1 +
 arch/arm64/include/asm/kvm_host.h                 |  7 +++
 arch/arm64/include/asm/kvm_mmu.h                  |  3 +-
 arch/arm64/include/asm/kvm_nested.h               |  4 +-
 arch/arm64/kernel/asm-offsets.c                   |  1 +
 arch/arm64/kvm/arm.c                              |  5 ++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                | 52 ++++++++-------
 arch/arm64/kvm/hypercalls.c                       | 12 ++--
 arch/arm64/kvm/mmu.c                              | 15 ++---
 arch/arm64/kvm/nested.c                           | 53 +++++++++++++---
 arch/arm64/kvm/sys_regs.c                         | 77 ++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-init.c                   | 41 ++++++++++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c             |  7 ++-
 arch/riscv/kvm/aia_imsic.c                        |  8 +--
 arch/x86/kernel/kvm.c                             |  4 ++
 arch/x86/kvm/mmu/mmu.c                            | 27 +++++---
 arch/x86/kvm/svm/nested.c                         |  6 +-
 arch/x86/kvm/vmx/vmx.c                            |  6 +-
 include/linux/kvm_host.h                          |  2 -
 tools/testing/selftests/kvm/Makefile              |  1 +
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 16 ++++-
 tools/testing/selftests/kvm/x86_64/cpuid_test.c   |  2 +-
 virt/kvm/kvm_main.c                               | 12 ----
 25 files changed, 277 insertions(+), 103 deletions(-)


