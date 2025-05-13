Return-Path: <kvm+bounces-46354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D68A1AB59F9
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 996C14A7615
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012902BEC5B;
	Tue, 13 May 2025 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m5TOlu63"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582EE2BE0F5
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154084; cv=none; b=tyd5JkBLPCYA20hpOI71B0zD5F/VZHACuiJArIvvoOCyGlmYYaV20R8Az4dtuy7oBt69u24GeNZfjsHIgbW+8BfvIECzw9iV4tXjPElb4xckD1qUvC9mTYjkzICazsdklPHb8W9qty8x8CA9Ubtae+YNJX2ezra3N2LVCMCpd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154084; c=relaxed/simple;
	bh=8+/dBMgW7/N/1hy03OD58pusNeyYHgRZGDaZa51JjGw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=f5UDTc8/JlaZEwa+h3zbr2yuANxDwQKYUQEPK0ZdWIOpyZpuwb6X1VnWwImCntoA5QxUJsEgAl00v5JMflL6wawp7/1sbZpEzBiMOO9u04g0OtBMKLCtu8CRN9dzQy4r1DiBuS99oa0f4Qzol+irYEYgxhHBUyJx5xJitdwoYQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m5TOlu63; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-44059976a1fso20052775e9.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154080; x=1747758880; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7KUVo2viMPnYSE5ZDE55JuoChHZyPuFMM0oZmNJPumM=;
        b=m5TOlu63p8XPaScMaNXKuWKIIM0B4ITtZexddZbMHj+vv83e3oSM4xNwTh+gdeAppi
         4Or9MpgfVYGdM6xR/jQrPjfGAS+VSi4r7Efbctb6tL4v0xTb0JkKB9wnzrVO2O+mq4Wv
         YPh9KH5aSahIwA+4sB7VxZDq7mVXIOgS9HfMX/hrFd9GofkCfT5dRAGJb77+Q1oLg5RR
         Qr6qMTvek4YyNZPEHdAfNojbsknGcCZlwqKaQCVTusvQNdeErUeNRPy3JGX6KdD7J2XO
         hrM2SCWV8Jr7wVIryMjwh2OjzymUP71xH0oVEPKHgv1pivxSAvYml2hzb77zV5IgJOdT
         NP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154080; x=1747758880;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7KUVo2viMPnYSE5ZDE55JuoChHZyPuFMM0oZmNJPumM=;
        b=qDMvfCIpdbOeJtp0izjlcokIxMGjjOwhrEudXa4E0loCxyBag7YCIjrHEc5HY3kjHI
         K3YEytvrGaf4Ra88vwosbL0M42vAVNCHtjaUDpBr9jgmaQimCJvhD4ebZ1blKtAGWJQk
         53eq2RoRBCMLSXPegZU5dH+NhZ/ZYoPAinoGi+EtkwPe8I0/nzG5DDqGJVNNvu408Hoy
         b/QKQ8GARoXX4GJ8i464rtgUmgXFnPgSQWqDKv4W9y29ZyHXf3FPUzJPvNdZaU++wSUj
         OknewCzJegmjg9nuibadlzdQM+wZ91e9N3RFPIXsMktCAhs9xg2GNSBHCZO/v4P3GBTV
         z3lw==
X-Gm-Message-State: AOJu0Yx6QvbKfZEGk7KpfS5N3x/tJch6ap4FArkXFp8o62brPrNI67Xs
	W402nZTbAIp3KEwkTlW12JgrAFvPVTWkxTZ3nqvT//9abu5m8fwnpvlNJYputCJgx9Tr5qdz02A
	zGQifwdI95c1SB1KYu9NO+HjPglhCuVoZm4AKmqkvZ2Zv+F6mBM00IQrX9RpyBQroCwsojPAsqT
	mKS/o2eVIqnMrPSEm+9lN/7xw=
X-Google-Smtp-Source: AGHT+IHtsg7gz/6cwRuLjWybGINXKyS13ShwKFqFEum/5zvp/THSNOQqQ0KjNDOktFDBU7BPIiVHeub/nA==
X-Received: from wmbek10.prod.google.com ([2002:a05:600c:3eca:b0:442:c98d:df37])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3ba8:b0:439:8c80:6af4
 with SMTP id 5b1f17b1804b1-442f2110f24mr28985e9.19.1747154080538; Tue, 13 May
 2025 09:34:40 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-1-tabba@google.com>
Subject: [PATCH v9 00/17] KVM: Mapping guest_memfd backed memory at the host
 for software protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v8 [1]:
- Added guest_memfd flag that toggles support for in-place shared memory
- Added best-effort validation that the userspace memory address range
  matches the shared memory backed by guest_memfd
- Rework handling faults for shared guest_memfd memory in x86
- Fixes based on feedback from the previous series
- Rebase on Linux 6.15-rc6

The purpose of this series is to allow mapping guest_memfd backed memory
at the host. This support enables VMMs like Firecracker to run guests
backed completely by guest_memfd [2]. Combined with Patrick's series for
direct map removal in guest_memfd [3], this would allow running VMs that
offer additional hardening against Spectre-like transient execution
attacks.

This series will also serve as a base for _restricted_ mmap() support
for guest_memfd backed memory at the host for CoCos that allow sharing
guest memory in-place with the host [4].

Patches 1 to 6 are mainly about decoupling the concept of guest memory
being private vs guest memory being backed by guest_memfd. They are
mostly refactoring and renaming.

Patches 7 and 8 add support for in-place shared memory, as well as the
ability to map it by the host as long as it is shared, gated by a new
configuration option, toggled by a new flag, and advertised to userspace
by a new capability (introduced in patch 15).

Patches 9 to 14 add x86 and arm64 support for in-place shared memory.

Patch 15 introduces the capability that advertises support for in-place
shared memory, and updates the documentation.

Patches 16 and 17 add new selftests for the added features.

For details on how to test this patch series, and on how to boot a guest
has uses the new features, please refer to v8 [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/

Ackerley Tng (4):
  KVM: guest_memfd: Check that userspace_addr and fd+offset refer to
    same range
  KVM: x86/mmu: Handle guest page faults for guest_memfd with shared
    memory
  KVM: x86: Compute max_mapping_level with input from guest_memfd
  KVM: selftests: Test guest_memfd same-range validation

Fuad Tabba (13):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_KVM_GENERIC_GMEM_POPULATE
  KVM: Rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
  KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: guest_memfd: Allow host to map guest_memfd() pages
  KVM: arm64: Refactor user_mem_abort() calculation of force_pte
  KVM: arm64: Rename variables in user_mem_abort()
  KVM: arm64: Handle guest_memfd()-backed guest page faults
  KVM: arm64: Enable mapping guest_memfd in arm64
  KVM: Introduce the KVM capability KVM_CAP_GMEM_SHARED_MEM
  KVM: selftests: guest_memfd mmap() test when mapping is allowed

 Documentation/virt/kvm/api.rst                |  18 +
 arch/arm64/include/asm/kvm_host.h             |  10 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 149 +++++----
 arch/x86/include/asm/kvm_host.h               |  22 +-
 arch/x86/kvm/Kconfig                          |   4 +-
 arch/x86/kvm/mmu/mmu.c                        | 135 +++++---
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |   4 +-
 arch/x86/kvm/x86.c                            |   3 +-
 include/linux/kvm_host.h                      |  76 ++++-
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 313 ++++++++++++++++--
 virt/kvm/Kconfig                              |  15 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        | 152 ++++++++-
 virt/kvm/kvm_main.c                           |  21 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 19 files changed, 753 insertions(+), 183 deletions(-)


base-commit: 82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3
-- 
2.49.0.1045.g170613ef41-goog


