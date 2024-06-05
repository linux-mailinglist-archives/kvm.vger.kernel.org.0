Return-Path: <kvm+bounces-18894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9BD68FCCA7
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 14:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAE961C23D45
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA2C19B580;
	Wed,  5 Jun 2024 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOVO7dgJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B5719B3D5
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 11:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588610; cv=none; b=T0uYFYhokt9l+tGAIYMOjBS+xPxo1yASJH3WnKRsn+Seb753u+EwvQC4jOBfINfdZHgC9Pw1pxlKVXBaf5L2SgOQmJ7hAu9Dg7M5McM96h8a1TkAq/tWSU636yVB82VXUxOfN6ghnkAhKnCrxYcPSk9aCO/sdNkYnnea4Uy6S5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588610; c=relaxed/simple;
	bh=niNfvfs3lYh+aaP6ba83DH1G4UPziatbs15+x4qA950=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yl7+yStUIL+uNHezG1XTIFk9KCAQhQoHR8YdFhqHmeS/53xG7niz5XzJwEo7mrYBS9tQJNwTdCrPfoYO541n0Gw0X57jz7tVJex42iCSKUg9brM+2A1QEtCrfjyXW3vvC//KVLlp5YM7YBA2vcNy45tPWFyOH2lVkEZq07+X6yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOVO7dgJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717588607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a7imkIby037X25+fsT/F73EnWVXiorh6YbAA2BcEv58=;
	b=XOVO7dgJSibRJ0QuAzu9yIreBnlR7WgFY8gPEbU7S0oMEKSs3Cq7ft+DT01/hEM/ialGej
	T6DcA+zZ81z/uVRTRAptx+4CB07qopsQUgxQ9YjiG8iUROKSwfvWPHt30mlyS+EBq2c0Mz
	L6vo2uP/XyiNaWJTG6/YAGgUiKOD/xA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-82-i9wSdHcfNrqB9KZrnHI8UQ-1; Wed,
 05 Jun 2024 07:56:44 -0400
X-MC-Unique: i9wSdHcfNrqB9KZrnHI8UQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BABA3806702;
	Wed,  5 Jun 2024 11:56:44 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 726852166AF4;
	Wed,  5 Jun 2024 11:56:44 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.10-rc3
Date: Wed,  5 Jun 2024 07:56:44 -0400
Message-ID: <20240605115644.8573-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Linus,

The following changes since commit c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to db574f2f96d0c9a245a9e787e3d9ec288fb2b445:

  KVM: x86/mmu: Don't save mmu_invalidate_seq after checking private attr (2024-06-05 06:45:06 -0400)

The pull request is dominated by a couple large series for ARM
and x86 respectively, but apart from that things are calm.

----------------------------------------------------------------
ARM:

* Large set of FP/SVE fixes for pKVM, addressing the fallout
  from the per-CPU data rework and making sure that the host
  is not involved in the FP/SVE switching any more

* Allow FEAT_BTI to be enabled with NV now that FEAT_PAUTH
  is completely supported

* Fix for the respective priorities of Failed PAC, Illegal
  Execution state and Instruction Abort exceptions

* Fix the handling of AArch32 instruction traps failing their
  condition code, which was broken by the introduction of
  ESR_EL2.ISS2

* Allow vcpus running in AArch32 state to be restored in
  System mode

* Fix AArch32 GPR restore that would lose the 64 bit state
  under some conditions

RISC-V:

* No need to use mask when hart-index-bits is 0

* Fix incorrect reg_subtype labels in kvm_riscv_vcpu_set_reg_isa_ext()

x86:

* Fixes and debugging help for the #VE sanity check.  Also disable
  it by default, even for CONFIG_DEBUG_KERNEL, because it was found
  to trigger spuriously (most likely a processor erratum as the
  exact symptoms vary by generation).

* Avoid WARN() when two NMIs arrive simultaneously during an NMI-disabled
  situation (GIF=0 or interrupt shadow) when the processor supports
  virtual NMI.  While generally KVM will not request an NMI window
  when virtual NMIs are supported, in this case it *does* have to
  single-step over the interrupt shadow or enable the STGI intercept,
  in order to deliver the latched second NMI.

* Drop support for hand tuning APIC timer advancement from userspace.
  Since we have adaptive tuning, and it has proved to work well,
  drop the module parameter for manual configuration and with it a
  few stupid bugs that it had.

----------------------------------------------------------------
Fuad Tabba (9):
      KVM: arm64: Reintroduce __sve_save_state
      KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
      KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
      KVM: arm64: Specialize handling of host fpsimd state on trap
      KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM
      KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
      KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve in pKVM
      KVM: arm64: Refactor CPACR trap bit setting/clearing to use ELx format
      KVM: arm64: Ensure that SME controls are disabled in protected mode

Isaku Yamahata (1):
      KVM: x86/mmu: Use SHADOW_NONPRESENT_VALUE for atomic zap in TDP MMU

Marc Zyngier (5):
      KVM: arm64: Fix AArch32 register narrowing on userspace write
      KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
      KVM: arm64: AArch32: Fix spurious trapping of conditional instructions
      KVM: arm64: nv: Fix relative priorities of exceptions generated by ERETAx
      KVM: arm64: nv: Expose BTI and CSV_frac to a guest hypervisor

Nikunj A Dadhania (1):
      KVM: SEV-ES: Prevent MSR access post VMSA encryption

Paolo Bonzini (3):
      Merge branch 'kvm-fixes-6.10-1' into HEAD
      Merge tag 'kvm-riscv-fixes-6.10-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-fixes-6.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Quan Zhou (1):
      RISC-V: KVM: Fix incorrect reg_subtype labels in kvm_riscv_vcpu_set_reg_isa_ext function

Ravi Bangoria (2):
      KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent
      KVM: SEV-ES: Delegate LBR virtualization to the processor

Sean Christopherson (11):
      KVM: VMX: Don't kill the VM on an unexpected #VE
      KVM: nVMX: Initialize #VE info page for vmcs02 when proving #VE support
      KVM: nVMX: Always handle #VEs in L0 (never forward #VEs from L2 to L1)
      KVM: x86/mmu: Add sanity checks that KVM doesn't create EPT #VE SPTEs
      KVM: VMX: Dump VMCS on unexpected #VE
      KVM: x86/mmu: Print SPTEs on unexpected #VE
      KVM: VMX: Enumerate EPT Violation #VE support in /proc/cpuinfo
      KVM: x86: Disable KVM_INTEL_PROVE_VE by default
      KVM: x86: Force KVM_WERROR if the global WERROR is enabled
      KVM: SVM: WARN on vNMI + NMI window iff NMIs are outright masked
      KVM: x86: Drop support for hand tuning APIC timer advancement from userspace

Tao Su (1):
      KVM: x86/mmu: Don't save mmu_invalidate_seq after checking private attr

Yong-Xuan Wang (1):
      RISC-V: KVM: No need to use mask when hart-index-bit is 0

 arch/arm64/include/asm/el2_setup.h      |  6 +--
 arch/arm64/include/asm/kvm_arm.h        |  6 +++
 arch/arm64/include/asm/kvm_emulate.h    | 71 ++++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h       | 25 +++++++++-
 arch/arm64/include/asm/kvm_hyp.h        |  4 +-
 arch/arm64/include/asm/kvm_pkvm.h       |  9 ++++
 arch/arm64/kvm/arm.c                    | 76 +++++++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c         | 21 +++++----
 arch/arm64/kvm/fpsimd.c                 | 11 +++--
 arch/arm64/kvm/guest.c                  |  3 +-
 arch/arm64/kvm/hyp/aarch32.c            | 18 ++++++-
 arch/arm64/kvm/hyp/fpsimd.S             |  6 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 36 +++++++-------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 84 +++++++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 17 ++-----
 arch/arm64/kvm/hyp/nvhe/setup.c         | 25 +++++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 24 ++++++++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 12 +++--
 arch/arm64/kvm/nested.c                 |  6 ++-
 arch/arm64/kvm/reset.c                  |  3 ++
 arch/riscv/kvm/aia_device.c             |  7 +--
 arch/riscv/kvm/vcpu_onereg.c            |  4 +-
 arch/x86/include/asm/kvm_host.h         |  1 +
 arch/x86/include/asm/vmxfeatures.h      |  2 +-
 arch/x86/kvm/Kconfig                    | 11 +++--
 arch/x86/kvm/lapic.c                    | 39 ++++++++-------
 arch/x86/kvm/lapic.h                    |  2 +-
 arch/x86/kvm/mmu/mmu.c                  | 48 ++++++++++++++-----
 arch/x86/kvm/mmu/spte.h                 |  9 ++++
 arch/x86/kvm/mmu/tdp_iter.h             |  2 +
 arch/x86/kvm/mmu/tdp_mmu.c              |  2 +-
 arch/x86/kvm/svm/sev.c                  | 19 ++++++--
 arch/x86/kvm/svm/svm.c                  | 69 ++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h                  |  4 +-
 arch/x86/kvm/vmx/nested.c               |  5 ++
 arch/x86/kvm/vmx/vmx.c                  | 11 ++++-
 arch/x86/kvm/x86.c                      | 11 +----
 38 files changed, 559 insertions(+), 151 deletions(-)


