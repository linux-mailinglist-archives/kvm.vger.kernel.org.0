Return-Path: <kvm+bounces-52468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C80B05673
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95A9F1AA6CEF
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EB82D12E4;
	Tue, 15 Jul 2025 09:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZS7rnK/0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9666B1E5018
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572035; cv=none; b=I/PkANtoyhzDImj3pGLBBN1X5e+pn0TOa944AHoeFS631TpVmHZUcshhz+4pwG7742uf3gXK/brsMLjgs4Ts0CmQDDyN7mOtOzYgHw6p3XrPFFasu6nS2ddmUcwkj8gVtGP9JDM6livu189pU7pCSHGqyjU0sNMbmGvNYAIkQlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572035; c=relaxed/simple;
	bh=8K4cyzXaTxVK0exe11kHjRbHaq5OiKRUEqbJ8e+exys=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iDkd1f6jbY07T2P8W/x1csafrwZXbRQzrh22x186vfaWSno+5Ow5wnwcU85+kTNzgQ9JtfewEY6P9mqFqZvjTG9D1tGNJ49kD+nMm3Jz+rveLpLxrd4QONfVt/dRgDUClka2Khw/Uomhq/eCwvwT1RGrbKutaGUsl92Xay3XeSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZS7rnK/0; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3af3c860ed7so2304016f8f.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572032; x=1753176832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j4t1n4nwyoQBKZNhO7jMcqNzHzTkyclHCojNDUTYuIc=;
        b=ZS7rnK/06qCVXUFZfe4gc9bit0IGOXSL+L+EWupoNwyRFMnGYYk5VgfGtFYdttmFMj
         ERqfLJqYLqIcQfTs4p7eUg6kkiwq6plk5258719L2ztSgNAoWxCNfpI5lEjBqy3e8IfZ
         CGdi+JumekhKHfRcJVnnYZU9DWyksS29MXLPcN/9NcaHyYnL/8xer2TElKZGdVi80+UP
         duJlON0drNEJr5bhQb1/cBqjUv/QZQIXCcf9kJ8eOQ7iEfzIT77x6FBI9FvVgQq/GLjJ
         EiDx1p2mYe/ckywLdx890L7kbW1PhnsZ25XUSfvRMjh5JrdW5DomaWzc2WV9f95le2Ss
         DN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572032; x=1753176832;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j4t1n4nwyoQBKZNhO7jMcqNzHzTkyclHCojNDUTYuIc=;
        b=mVxeh/IYI6r06Wsf1/2eoGi+kpZcN8HIaWA7ftO/Q24WXZGv/sjh3jletqsJT31YgF
         FrrS2l6rEFVnwB2jmVek7FTdLEZpo1+qQniBLtbe6Qtutwp++lyWKLPodAkoGcQH2gZ2
         A1JM+A2AAsL5LapMTWvy9dpg5ZR6y9cztxuJWN8OEAsdKySalfXbfjBowBQ62V5o1+8T
         OpxN7qLfesufuojzTEALsyZhmzyGUjotMyVk7DKMRMVX9/77ge1UPwDY+TIG4dDL5JHm
         X8XM42FvwMuq97VflXp00deTMSpmCEWrVbJg5nMYgDXkomgM6m8DXlFMSHgERN3pongd
         JL9Q==
X-Gm-Message-State: AOJu0YztF4+Ejl2SEGutM7T+tVZsA/Doyc7hSzw2C0o7Q2dyGHSaApv1
	Pg3l43dsLdjZ/aUPv/LWaFDQsqNdw9GtS3Air+rO5jFdwXEOeRfsuYkeMMi2RZ4XQuRhtIfuoHV
	4M8j+ar9D4gUS+UgBg2piQ+GWW5ilsOGbC0W66xomQ4tMfE4TQNzAujqOyP5qNGgW+EcmPQkHkz
	Es08HJJtw+ENI7ITEDaifwX4aFSgo=
X-Google-Smtp-Source: AGHT+IGz/WL5Nm2M8E0afS2hsyGmPGgazwMmwD3sXKJKeTBCyM54UVdaP4fiGdQY16/I+BzGEw8xAOzLrQ==
X-Received: from wrce6.prod.google.com ([2002:adf:9bc6:0:b0:3a5:7dbc:4d24])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5e8a:0:b0:3b5:e5c9:93c5
 with SMTP id ffacd0b85a97d-3b5f2e28d8bmr10048876f8f.49.1752572031962; Tue, 15
 Jul 2025 02:33:51 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-1-tabba@google.com>
Subject: [PATCH v14 00/21] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
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

Main changes since v13 [1]:
* Fixed handling of guest faults in case of invalidation in arm64
* Handle VNCR_EL2-triggered faults backed by guest_memfd (arm64 nested
  virt)
* Applied suggestions from latest feedback
* Rebase on Linux 6.16-rc6

This patch series enables host userspace mapping of guest_memfd-backed
memory for non-CoCo VMs. This is required for several evolving KVM use
cases:

* Allows VMMs like Firecracker to run guests entirely backed by
  guest_memfd [2]. This provides a unified memory management model for
  both confidential and non-confidential guests, simplifying VMM design.

* Enhanced Security via direct map removal: When combined with Patrick's
  series for direct map removal [3], this provides additional hardening
  against Spectre-like transient execution attacks by eliminating the
  need for host kernel direct maps of guest memory.

* Lays the groundwork for *restricted* mmap() support for
  guest_memfd-backed memory on CoCo platforms [4] that permit in-place
  sharing of guest memory with the host.

Patch breakdown:

Patches 1-7: Primarily infrastructure refactorings and renames to decouple
guest_memfd from the concept of "private" memory.

Patches 8-9: Add support for the host to map guest_memfd backed memory
for non-CoCo VMs, which includes support for mmap() and fault handling.
This is gated by a new configuration option, toggled by a new flag, and
advertised to userspace by a new capability (introduced in patch 18).

Patches 10-14: Implement x86 guest_memfd mmap support.

Patches 15-18: Implement arm64 guest_memfd mmap support.

Patch 19: Introduce the new capability to advertise this support and
update the documentation.

Patches 20-21: Update and expand selftests for guest_memfd to include
mmap functionality and improve portability.

To test this patch series and boot a guest utilizing the new features,
please refer to the instructions in v8 of the series [5]. Note that
kvmtool for Linux 6.16 (available at [6]) is required, as the
KVM_CAP_GMEM_MMAP capability number has changed, additionally, drop the
--sw_protected kvmtool parameter to test with the default VM type.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250709105946.4009897-1-tabba@google.com/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[5] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[6] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-basic-6.16

Ackerley Tng (4):
  KVM: x86/mmu: Generalize private_max_mapping_level x86 op to
    max_mapping_level
  KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
  KVM: x86/mmu: Consult guest_memfd when computing max_mapping_level
  KVM: x86/mmu: Handle guest page faults for guest_memfd with shared
    memory

Fuad Tabba (17):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_KVM_GENERIC_GMEM_POPULATE
  KVM: Introduce kvm_arch_supports_gmem()
  KVM: x86: Introduce kvm->arch.supports_gmem
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: Fix comment that refers to kvm uapi header path
  KVM: guest_memfd: Allow host to map guest_memfd pages
  KVM: guest_memfd: Track guest_memfd mmap support in memslot
  KVM: x86: Enable guest_memfd mmap for default VM type
  KVM: arm64: Refactor user_mem_abort()
  KVM: arm64: Handle guest_memfd-backed guest page faults
  KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
  KVM: arm64: Enable host mapping of shared guest_memfd memory
  KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
  KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mmap is supported

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   2 +
 arch/arm64/kvm/mmu.c                          | 203 ++++++++++++-----
 arch/arm64/kvm/nested.c                       |  41 +++-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  18 +-
 arch/x86/kvm/Kconfig                          |   7 +-
 arch/x86/kvm/mmu/mmu.c                        | 114 ++++++----
 arch/x86/kvm/svm/sev.c                        |  12 +-
 arch/x86/kvm/svm/svm.c                        |   3 +-
 arch/x86/kvm/svm/svm.h                        |   4 +-
 arch/x86/kvm/vmx/main.c                       |   6 +-
 arch/x86/kvm/vmx/tdx.c                        |   6 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |   5 +-
 include/linux/kvm_host.h                      |  64 +++++-
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 208 +++++++++++++++---
 virt/kvm/Kconfig                              |  14 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        |  96 +++++++-
 virt/kvm/kvm_main.c                           |  14 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 25 files changed, 664 insertions(+), 179 deletions(-)


base-commit: 347e9f5043c89695b01e66b3ed111755afcf1911
-- 
2.50.0.727.gbf7dc18ff4-goog


