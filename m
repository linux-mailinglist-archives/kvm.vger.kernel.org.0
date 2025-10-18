Return-Path: <kvm+bounces-60439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 09818BED1D0
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 16:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9EFD84E229C
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 14:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFAAE292B4B;
	Sat, 18 Oct 2025 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sc40sQdv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1945D1FECBA
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760799340; cv=none; b=SCqx/tw0Wcka4r9epPWFXN/T+7nNOybKOCBEHRXGnkceqmc+G5sQtBym+3JV++h0WeN+oadPLuyY35f/CidvVaiNkX7SxpY9BEQcUKVSQOTH24p7xeVkctD187kKN4C3aY6xxuiDgI7FATLWK00Pap9sTwpxFeKxxZKtIznWuvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760799340; c=relaxed/simple;
	bh=mLT2lbG3kXFkLie+we3VKqkPSWvx88i/kwFOpGyYazw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t9dhEVIdTSeSyKqQyx3fNRQ/2R3cU8FSvUHsjoT53u+sKH/DxGIqxtu3vR9lmDldATCTVkJQ41yUHgag1yHNSKeS2qYOXUumAGlTtfxyQHuN0/5LFB8oAXAtkJpZlftC4qc7aY1PQpVcNQ0nozpGSNWkFdVOb6b7HQAt8liqrIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sc40sQdv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760799338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r3aMuDzlSq6Jt3ItJ/z+zpBUl7GppMDUpf+VOUN8H78=;
	b=Sc40sQdvQ+sx6kEzLd+aAXkHikn2hWN0BruR1MGcY/ZiYAD6aIktU7xveAefCOv+wCzZ7o
	3XIfa23ohRq4TC6EREge8QuDxIUX3e/TP0vVJxoOVqWrVtuvTRNNdoBreIoFx0c3jT061P
	rHcPR9VZAwIvL26EF33aqngrdP4tztM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-7bqixOyxP92xONuvY4Q2Dw-1; Sat, 18 Oct 2025 10:55:36 -0400
X-MC-Unique: 7bqixOyxP92xONuvY4Q2Dw-1
X-Mimecast-MFC-AGG-ID: 7bqixOyxP92xONuvY4Q2Dw_1760799335
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47106a388cfso14315175e9.0
        for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 07:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760799335; x=1761404135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3aMuDzlSq6Jt3ItJ/z+zpBUl7GppMDUpf+VOUN8H78=;
        b=xJ7sECPbbLX0yPI0FBUoQ57jRfkVv1qQ02QYafVVOL3jT5mqDetWNgLoZXIr7vcNhf
         xf+u00oWBE6X4BhAylGL5BS3pp3nSFPIebQs20sJ9j75vOOty8xFGsIX18L5nkglKKqe
         VaFYCIpa6LobK+VP03O56K1G+ZVwT6IeEIRUKMox/IcJwydUu2p39JR5bDCbhnNJ/vyx
         ERHk+Fp48FJoUMiW8goVhVPdUC+DsDCeT2v8a2kx6NfwRThwyjfE13cKHsPReygjymGc
         BXUZc1QeCQLYNO6ikJ/aOFsvf1ROgRLgTYwp0y1Z7Fg1F2xMwWW9LJHyNe6Yv4mW8cHD
         FRig==
X-Forwarded-Encrypted: i=1; AJvYcCXZWRUR6g6RlfhHIxrdWr4zk7IUc/Q1xYj6960RDJ9Gp7IdiL777xmKco6so/YsNVbNiyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAjO3XONrs+pIeC47li5XZoGmjJg8hE2WzfSHqyK0VWxdD8sCa
	0G2Z3XiDjV1gx0rQvSJGlmmQShKCPqEVjIGn3PX4VWj/O3fAQ75wocmx76N7g/MwO0/EWawjJoG
	Vc8Dj3s6EW5zH8Egwp9M08YI0ppTTTUJx2Xt7rcOHNoVPEhCIbKxBuA==
X-Gm-Gg: ASbGncsahyou6skuXcHQXQ6wo/3yv3Un3FndyxG8os4w40hbrvv7lSX+G7VMkC/nArW
	FJspY+MUu9VWNu77qJpMqKlhlmYpdJhwUx24Be/ecKtVKMNqIU2eb78yrXgriylsa+6MS2v0d1P
	+JqOBz0I8zT8MGQRQEOFcbygTKxelHhjpB65f9CDqblA++Eb4t0zWBSxotUrGsltBgJ6GTDf8A2
	IZYUGq39gScqlJpQTyV+7RuZ7rn7jFyg1f3lFDhOPU/gv8r/IL8rEmmlF8JK4c5WWQUQr920/4O
	5dAEC8e1epPD4Uwa9bQOzMQQ/aZE0m6Ab0lO5xwyg6//DTR0RlWZRo9XXy2SPzum2EFbXx5dmfz
	MQK2NICqsWXtnJncIOxgFQ0najINDe7bhJnVwfYJIqewgFX2Gpjgz3guND0uj3sn6aF89OAtsip
	FfIA==
X-Received: by 2002:a05:600c:3b8d:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-471179176b9mr64820575e9.28.1760799335135;
        Sat, 18 Oct 2025 07:55:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH47C36StXNWXNVVjTZAihBvDIuXxzpw7R06UIDl2EkcoUsBSekmigElF3XqcAT20jxeHWlDQ==
X-Received: by 2002:a05:600c:3b8d:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-471179176b9mr64820425e9.28.1760799334644;
        Sat, 18 Oct 2025 07:55:34 -0700 (PDT)
Received: from [192.168.10.48] ([151.61.22.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471556e17afsm48295675e9.17.2025.10.18.07.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 07:55:34 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	maz@kernel.org,
	seanjc@google.com
Subject: [GIT PULL] KVM fixes for Linux 6.18-rc2
Date: Sat, 18 Oct 2025 16:55:32 +0200
Message-ID: <20251018145533.2072927-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4361f5aa8bfcecbab3fc8db987482b9e08115a6a:

  Merge tag 'kvm-x86-fixes-6.18-rc2' of https://github.com/kvm-x86/linux into HEAD (2025-10-18 10:25:43 +0200)

For the most part, these are fixes and tests for either Arm or guest_memfd.

----------------------------------------------------------------
ARM:

- Fix the handling of ZCR_EL2 in NV VMs

- Pick the correct translation regime when doing a PTW on
  the back of a SEA

- Prevent userspace from injecting an event into a vcpu that isn't
  initialised yet

- Move timer save/restore to the sysreg handling code, fixing EL2 timer
  access in the process

- Add FGT-based trapping of MDSCR_EL1 to reduce the overhead of debug

- Fix trapping configuration when the host isn't GICv3

- Improve the detection of HCR_EL2.E2H being RES1

- Drop a spurious 'break' statement in the S1 PTW

- Don't try to access SPE when owned by EL3

Documentation updates:

- Document the failure modes of event injection

- Document that a GICv3 guest can be created on a GICv5 host
  with FEAT_GCIE_LEGACY

Selftest improvements:

- Add a selftest for the effective value of HCR_EL2.AMO

- Address build warning in the timer selftest when building with clang

- Teach irqfd selftests about non-x86 architectures

- Add missing sysregs to the set_id_regs selftest

- Fix vcpu allocation in the vgic_lpi_stress selftest

- Correctly enable interrupts in the vgic_lpi_stress selftest

x86:

- Expand the KVM_PRE_FAULT_MEMORY selftest to add a regression test for the
  bug fixed by commit 3ccbf6f47098 ("KVM: x86/mmu: Return -EAGAIN if userspace
  deletes/moves memslot during prefault")

- Don't try to get PMU capabilities from perf when running a CPU with hybrid
  CPUs/PMUs, as perf will rightly WARN.

guest_memfd:

- Rework KVM_CAP_GUEST_MEMFD_MMAP (newly introduced in 6.18) into a more
  generic KVM_CAP_GUEST_MEMFD_FLAGS

- Add a guest_memfd INIT_SHARED flag and require userspace to explicitly set
  said flag to initialize memory as SHARED, irrespective of MMAP.  The
  behavior merged in 6.18 is that enabling mmap() implicitly initializes
  memory as SHARED, which would result in an ABI collision for x86 CoCo VMs
  as their memory is currently always initialized PRIVATE.

- Allow mmap() on guest_memfd for x86 CoCo VMs, i.e. on VMs with private
  memory, to enable testing such setups, i.e. to hopefully flush out any
  other lurking ABI issues before 6.18 is officially released.

- Add testcases to the guest_memfd selftest to cover guest_memfd without MMAP,
  and host userspace accesses to mmap()'d private memory.

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: selftests: Add test coverage for guest_memfd without GUEST_MEMFD_FLAG_MMAP

Dapeng Mi (1):
      KVM: x86/pmu: Don't try to get perf capabilities for hybrid CPUs

Marc Zyngier (15):
      KVM: arm64: nv: Don't advance PC when pending an SVE exception
      KVM: arm64: Hide CNTHV_*_EL2 from userspace for nVHE guests
      KVM: arm64: Introduce timer_context_to_vcpu() helper
      KVM: arm64: Replace timer context vcpu pointer with timer_id
      KVM: arm64: Make timer_set_offset() generally accessible
      KVM: arm64: Add timer UAPI workaround to sysreg infrastructure
      KVM: arm64: Move CNT*_CTL_EL0 userspace accessors to generic infrastructure
      KVM: arm64: Move CNT*_CVAL_EL0 userspace accessors to generic infrastructure
      KVM: arm64: Move CNT*CT_EL0 userspace accessors to generic infrastructure
      KVM: arm64: Fix WFxT handling of nested virt
      KVM: arm64: Kill leftovers of ad-hoc timer userspace access
      KVM: arm64: selftests: Make dependencies on VHE-specific registers explicit
      KVM: arm64: selftests: Add an E2H=0-specific configuration to get_reg_list
      KVM: arm64: selftests: Fix misleading comment about virtual timer encoding
      arm64: Revamp HCR_EL2.E2H RES1 detection

Mukesh Ojha (1):
      KVM: arm64: Guard PMSCR_EL1 initialization with SPE presence check

Oliver Upton (9):
      KVM: arm64: nv: Don't treat ZCR_EL2 as a 'mapped' register
      KVM: arm64: Use the in-context stage-1 in __kvm_find_s1_desc_level()
      KVM: arm64: selftests: Test effective value of HCR_EL2.AMO
      KVM: arm64: Prevent access to vCPU events before init
      KVM: arm64: Document vCPU event ioctls as requiring init'ed vCPU
      KVM: selftests: Fix irqfd_test for non-x86 architectures
      KVM: arm64: selftests: Actually enable IRQs in vgic_lpi_stress
      KVM: arm64: Compute per-vCPU FGTs at vcpu_load()
      KVM: arm64: nv: Use FGT write trap of MDSCR_EL1 when available

Osama Abdelkader (1):
      KVM: arm64: Remove unreachable break after return

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.18-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.18-rc2' of https://github.com/kvm-x86/linux into HEAD

Sascha Bischoff (2):
      KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests
      Documentation: KVM: Update GICv3 docs for GICv5 hosts

Sean Christopherson (13):
      KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
      KVM: guest_memfd: Add INIT_SHARED flag, reject user page faults if not set
      KVM: guest_memfd: Invalidate SHARED GPAs if gmem supports INIT_SHARED
      KVM: Explicitly mark KVM_GUEST_MEMFD as depending on KVM_GENERIC_MMU_NOTIFIER
      KVM: guest_memfd: Allow mmap() on guest_memfd for x86 VMs with private memory
      KVM: selftests: Stash the host page size in a global in the guest_memfd test
      KVM: selftests: Create a new guest_memfd for each testcase
      KVM: selftests: Add wrappers for mmap() and munmap() to assert success
      KVM: selftests: Isolate the guest_memfd Copy-on-Write negative testcase
      KVM: selftests: Add wrapper macro to handle and assert on expected SIGBUS
      KVM: selftests: Verify that faulting in private guest_memfd memory fails
      KVM: selftests: Verify that reads to inaccessible guest_memfd VMAs SIGBUS
      KVM: arm64: selftests: Track width of timer counter as "int", not "uint64_t"

Yan Zhao (1):
      KVM: selftests: Test prefault memory during concurrent memslot removal

Zenghui Yu (2):
      KVM: arm64: selftests: Sync ID_AA64PFR1, MPIDR, CLIDR in guest
      KVM: arm64: selftests: Allocate vcpus with correct size

 Documentation/virt/kvm/api.rst                     |  20 ++-
 Documentation/virt/kvm/devices/arm-vgic-v3.rst     |   3 +-
 arch/arm64/include/asm/el2_setup.h                 |  38 ++++-
 arch/arm64/include/asm/kvm_host.h                  |  50 ++++++
 arch/arm64/kvm/arch_timer.c                        | 105 ++-----------
 arch/arm64/kvm/arm.c                               |   7 +
 arch/arm64/kvm/at.c                                |   7 +-
 arch/arm64/kvm/config.c                            |  90 +++++++++++
 arch/arm64/kvm/debug.c                             |  15 +-
 arch/arm64/kvm/guest.c                             |  70 ---------
 arch/arm64/kvm/handle_exit.c                       |   7 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 148 ++----------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   1 +
 arch/arm64/kvm/nested.c                            |   9 +-
 arch/arm64/kvm/sys_regs.c                          | 131 ++++++++++++----
 arch/arm64/kvm/sys_regs.h                          |   6 +
 arch/arm64/kvm/vgic/vgic-v3.c                      |   5 +-
 arch/x86/kvm/pmu.c                                 |   8 +-
 arch/x86/kvm/x86.c                                 |   7 +-
 include/kvm/arm_arch_timer.h                       |  24 ++-
 include/linux/kvm_host.h                           |  12 +-
 include/uapi/linux/kvm.h                           |   5 +-
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |   2 +-
 .../testing/selftests/kvm/arm64/external_aborts.c  |  43 ++++++
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |  99 +++++++++++-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   3 +
 .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  |   3 +-
 tools/testing/selftests/kvm/guest_memfd_test.c     | 171 +++++++++++----------
 .../selftests/kvm/include/arm64/processor.h        |  12 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |  27 ++++
 tools/testing/selftests/kvm/include/test_util.h    |  19 +++
 tools/testing/selftests/kvm/irqfd_test.c           |  14 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  49 +++---
 tools/testing/selftests/kvm/lib/s390/processor.c   |   5 +
 tools/testing/selftests/kvm/lib/test_util.c        |   7 +
 tools/testing/selftests/kvm/lib/x86/processor.c    |   5 +
 tools/testing/selftests/kvm/mmu_stress_test.c      |   5 +-
 .../testing/selftests/kvm/pre_fault_memory_test.c  | 131 ++++++++++++++--
 tools/testing/selftests/kvm/s390/ucontrol_test.c   |  16 +-
 .../testing/selftests/kvm/set_memory_region_test.c |  17 +-
 virt/kvm/Kconfig                                   |   1 +
 virt/kvm/guest_memfd.c                             |  75 +++++----
 virt/kvm/kvm_main.c                                |   4 +-
 44 files changed, 941 insertions(+), 540 deletions(-)


