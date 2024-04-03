Return-Path: <kvm+bounces-13461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A95896FCE
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 15:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11F491C25BC1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 13:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3C4147C7D;
	Wed,  3 Apr 2024 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzfkGazH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B281EEF9
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 13:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712149465; cv=none; b=TKWLiT3fzgHRlaHWJ0u3SbcRiy/UW5vablwF1uj21on5K5/MPaLswszqml5b3NOhE4DKWSDvS22e57vw+0bQICF6DzQ7EIcmU4kKjviW0l+unvVjiiyTLATjVn+gJ2K86kovNEIU5efkebUsQU/iteKE6qK0HhNO2cK6+0Te2xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712149465; c=relaxed/simple;
	bh=3vRLtZdpkmYqJ8NLGKs+nEQLx32bjtZDqMWLPuAUFvA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FXMLfm1UqZaLxl6Sm0rm8bM0dJ6vnmX6dXciok5+wasrfSgbHLCNPj7KZ2H1aVDFhpQKTQOiXyxUIxyt6a4ecDZFrVlODu9Q9YAaF13E0TvP6a5IaCC4NHCE3YRB22Niwx0RfPzZxIqXEiQICeugl0gP8yGvm3722WelFbbHozc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzfkGazH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712149463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/UUFdKOIgSUdlJyeU9vl+F/Hh52S5plvfkKfHoxr/LQ=;
	b=GzfkGazHSWl1EbLfgPwszMkLOV7rjVgeomlu+R9806Ntr80t43N3vMLX/OoaGHhR8hWlOA
	yAhJ77lz9CW9ms9GxGj3QEwnFhhxJpLl7qpDGng4BuPjJB15D0aV9yZ2dJ8zvrJgMCKkxE
	pvYLUwLREcZKX1tO507awpH0nYwRLyM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111--MGrU6-mOUaf3TCtRaKeuQ-1; Wed, 03 Apr 2024 09:04:19 -0400
X-MC-Unique: -MGrU6-mOUaf3TCtRaKeuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6251788CC44;
	Wed,  3 Apr 2024 13:04:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43E49C017A0;
	Wed,  3 Apr 2024 13:04:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.9-rc3
Date: Wed,  3 Apr 2024 09:04:18 -0400
Message-ID: <20240403130418.3068910-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Linus,

The following changes since commit 4cece764965020c22cff7665b18a012006359095:

  Linux 6.9-rc1 (2024-03-24 14:10:05 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9bc60f733839ab6fcdde0d0b15cbb486123e6402:

  Merge tag 'kvm-riscv-fixes-6.9-1' of https://github.com/kvm-riscv/linux into HEAD (2024-04-02 12:29:51 -0400)

----------------------------------------------------------------
ARM:

- Ensure perf events programmed to count during guest execution
  are actually enabled before entering the guest in the nVHE
  configuration.

- Restore out-of-range handler for stage-2 translation faults.

- Several fixes to stage-2 TLB invalidations to avoid stale
  translations, possibly including partial walk caches.

- Fix early handling of architectural VHE-only systems to ensure E2H is
  appropriately set.

- Correct a format specifier warning in the arch_timer selftest.

- Make the KVM banner message correctly handle all of the possible
  configurations.

RISC-V:

- Remove redundant semicolon in num_isa_ext_regs().

- Fix APLIC setipnum_le/be write emulation.

- Fix APLIC in_clrip[x] read emulation.

x86:

- Fix a bug in KVM_SET_CPUID{2,} where KVM looks at the wrong CPUID entries (old
  vs. new) and ultimately neglects to clear PV_UNHALT from vCPUs with HLT-exiting
  disabled.

- Documentation fixes for SEV.

- Fix compat ABI for KVM_MEMORY_ENCRYPT_OP.

- Fix a 14-year-old goof in a declaration shared by host and guest; the enabled
  field used by Linux when running as a guest pushes the size of "struct
  kvm_vcpu_pv_apf_data" from 64 to 68 bytes.  This is really unconsequential
  because KVM never consumes anything beyond the first 64 bytes, but the
  resulting struct does not match the documentation.

Selftests:

- Fix spelling mistake in arch_timer selftest.

----------------------------------------------------------------
Anup Patel (2):
      RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
      RISC-V: KVM: Fix APLIC in_clrip[x] read emulation

Ashish Kalra (1):
      KVM: SVM: Add support for allowing zero SEV ASIDs

Colin Ian King (2):
      KVM: selftests: Fix spelling mistake "trigged" -> "triggered"
      RISC-V: KVM: Remove second semicolon

Marc Zyngier (2):
      arm64: Fix early handling of FEAT_E2H0 not being implemented
      KVM: arm64: Rationalise KVM banner output

Oliver Upton (1):
      KVM: arm64: Fix host-programmed guest events in nVHE

Paolo Bonzini (8):
      Merge tag 'kvm-x86-svm-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-asyncpf_abi-6.9' of https://github.com/kvm-x86/linux into HEAD
      KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
      Documentation: kvm/sev: separate description of firmware
      Documentation: kvm/sev: clarify usage of KVM_MEMORY_ENCRYPT_OP
      Merge tag 'kvm-x86-pvunhalt-6.9' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvmarm-fixes-6.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-fixes-6.9-1' of https://github.com/kvm-riscv/linux into HEAD

Sean Christopherson (4):
      KVM: SVM: Set sev->asid in sev_asid_new() instead of overloading the return
      KVM: SVM: Use unsigned integers when dealing with ASIDs
      KVM: SVM: Return -EINVAL instead of -EBUSY on attempt to re-init SEV/SEV-ES
      KVM: selftests: Fix __GUEST_ASSERT() format warnings in ARM's arch timer test

Vitaly Kuznetsov (3):
      KVM: x86: Introduce __kvm_get_hypervisor_cpuid() helper
      KVM: x86: Use actual kvm_cpuid.base for clearing KVM_FEATURE_PV_UNHALT
      KVM: selftests: Check that PV_UNHALT is cleared when HLT exiting is disabled

Will Deacon (4):
      KVM: arm64: Don't defer TLB invalidation when zapping table entries
      KVM: arm64: Don't pass a TLBI level hint when zapping table entries
      KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
      KVM: arm64: Ensure target address is granule-aligned for range TLBI

Wujie Duan (1):
      KVM: arm64: Fix out-of-IPA space translation fault handling

Xiaoyao Li (2):
      x86/kvm: Use separate percpu variable to track the enabling of asyncpf
      KVM: x86: Improve documentation of MSR_KVM_ASYNC_PF_EN

 .../virt/kvm/x86/amd-memory-encryption.rst         | 42 +++++++++-------
 Documentation/virt/kvm/x86/msr.rst                 | 19 ++++---
 arch/arm64/kernel/head.S                           | 29 ++++++-----
 arch/arm64/kvm/arm.c                               | 13 ++---
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |  3 +-
 arch/arm64/kvm/hyp/pgtable.c                       | 23 ++++++---
 arch/arm64/kvm/hyp/vhe/tlb.c                       |  3 +-
 arch/arm64/kvm/mmu.c                               |  2 +-
 arch/riscv/kvm/aia_aplic.c                         | 37 +++++++++++---
 arch/riscv/kvm/vcpu_onereg.c                       |  2 +-
 arch/x86/include/uapi/asm/kvm.h                    | 23 +++++++++
 arch/x86/include/uapi/asm/kvm_para.h               |  1 -
 arch/x86/kernel/kvm.c                              | 11 ++--
 arch/x86/kvm/cpuid.c                               | 44 +++++++++-------
 arch/x86/kvm/svm/sev.c                             | 58 +++++++++++++---------
 arch/x86/kvm/trace.h                               | 10 ++--
 include/kvm/arm_pmu.h                              |  2 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  4 +-
 .../selftests/kvm/include/x86_64/processor.h       | 11 ++++
 tools/testing/selftests/kvm/riscv/arch_timer.c     |  2 +-
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   | 39 +++++++++++++++
 21 files changed, 255 insertions(+), 123 deletions(-)


