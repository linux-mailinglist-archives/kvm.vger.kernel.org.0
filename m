Return-Path: <kvm+bounces-53680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FF8B15578
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48F084E0ECF
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19F0284B59;
	Tue, 29 Jul 2025 22:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d6StkXtk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E4C8633F
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829731; cv=none; b=LrtXHUHXL0n86lkoiLsnLHpzFtL9Xz3pjesmmLBKmi3UmluOVEZ8yb+8C7t24GPqTqDyDNiiae8/8CdjVjsNbPDQ8l/B+/k/FGnTpWPrv8nVyeR8GRI9AG4fV3jFssOHpFyM4FW8T+3bZ5PT7D4lRCgWOiibew5qKE0ynVssKgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829731; c=relaxed/simple;
	bh=E9x9+cPa6JkPTywd8ZwfDBIN3aB6QEip1AAaCabMxfo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YC1TxczKjBwG5lPCHAlqZDhrrryvLkS4YqFuUQL6b4nBJsZiSRMQuKe9J5+Ldsi4W1alAtBeE7iRRo2Ni5SpMJX/vuDE3hVKIl2mScsKuVghbSa7jSYOtscK2TFUCSqZdijTCRM4aKm8rJj9RRI1xjh6V490dgi/dQW5HgUc90Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d6StkXtk; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31df10dfadso4285086a12.0
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829729; x=1754434529; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xJQZhw5yV62Y2vPCQPybVQ771QZon9BJ9XOycOZeU8=;
        b=d6StkXtkbpE15+dSR5uZdz1zeUqcN2nXXJummer3hx+XumDwB/I9Mx5DuueybLpJkC
         TuRiYwd+IQCEc94B1wtXhe1K03rQQ2CdBHc45YBZHydil1us138p/ftbQV/yDdqqLyCh
         obbrkyAVmqBO45uQbfcxXJrEypcJzPp3yvkmbImlU6TjJiRUy4AtvGnAsPDXO9sgbyCu
         8Dr6N8kuo/eYFs2EYAUUL3DsmJEhrp/tR3tQTeKv5BHETF1XOkRvlGtiwDRlbIINi3jX
         BJs/cIkxXWAfrGGQOMsRvwPulF4kNNA/5F2k9/vaZlSxS2bbsa2aoI7/bsc/g9eonjAC
         HjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829729; x=1754434529;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1xJQZhw5yV62Y2vPCQPybVQ771QZon9BJ9XOycOZeU8=;
        b=tWhOmkAlOZLJta/JUU8Ap3deqkpUHeL+0tEKTbVOkhZLRfW5JvZC0gvRqJFCYzLiM+
         94QuIU6WtE7fRVbT3hSwdUu2He5MrqfiFDDgyNoPfeGeLCZKpSPqIZZi8+uzoeZP1/Ik
         RJpV/QHEkPVAfot0sbpAblQKy4z2QuI6ewXn8rvs+yOJlH89I28pK9nTIQXs2k91PlzQ
         Z8yGNauP2zAc6pJuGEpcl9k531XbUPSwkhOMKmCzla/PZ9c3e3w6mDWvKxg6NXa8sT3g
         TNybs41YVLHrFr+XSyKBVvl4IuSKdPT6XXi1RQ3swSuoljJ3r+Qy9dyq8LxJgCdYHYJc
         NjVg==
X-Gm-Message-State: AOJu0YxtEFsEDxHxlahZ/8K396jVtg3rGC1tAGXOxgfO28K0qjGRrxr6
	yjQn4E6kMBbmcyrhngBO1dd2RDZd8zvI+Gg/wWDuxr5d8ANdTAKn4p/FIcKeZmJ0CXAWX+TaH1P
	++RYipA==
X-Google-Smtp-Source: AGHT+IGaxcWmFDKGwZrWj7pqH7ospcLQPlncerJUmyl/cLjhK8EfQXRjnzM85IkOCzxza2AGNlEEwnrrJ2U=
X-Received: from pfbmb27.prod.google.com ([2002:a05:6a00:761b:b0:746:18ec:d11a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8c9:b0:747:accb:773c
 with SMTP id d2e1a72fcca58-76ab2f4beabmr1613976b3a.13.1753829729537; Tue, 29
 Jul 2025 15:55:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-1-seanjc@google.com>
Subject: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Paolo,

The arm64 patches have been Reviewed-by Marc, and AFAICT the x86 side of
things is a go.  Barring a screwup on my end, this just needs your approval.

Assuming everything looks good, it'd be helpful to get this into kvm/next
shortly after rc1.  The x86 Kconfig changes in particular create semantic
conflicts with in-flight series.


Add support for host userspace mapping of guest_memfd-backed memory for VM
types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
no way to detect private vs. shared).

mmap() support paves the way for several evolving KVM use cases:

 * Allows VMMs like Firecracker to run guests entirely backed by
   guest_memfd [1]. This provides a unified memory management model for
   both confidential and non-confidential guests, simplifying VMM design.

 * Enhanced Security via direct map removal: When combined with Patrick's
   series for direct map removal [2], this provides additional hardening
   against Spectre-like transient execution attacks by eliminating the
   need for host kernel direct maps of guest memory.

 * Lays the groundwork for *restricted* mmap() support for guest_memfd-backed
   memory on CoCo platforms [3] that permit in-place
   sharing of guest memory with the host.

Based on kvm/queue.

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[2] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk
[3] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com

v17:
 - Collect reviews. [Xiaoyao, David H.]
 - Write a better changelog for the CONFIG_KVM_GENERIC_PRIVATE_MEM =>
   CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE rename. [Xiaoyao]
 - Correctly gmem_max_mapping_level()'s '0' return in the right patch. [Xiaoyao]
 - Replace call to kvm_gmem_get_pfn() with a WARN_ONCE() in the hugepage
   recovery path. [Ackerley]
 - Add back "KVM: x86/mmu: Handle guest page faults for guest_memfd with
   shared memory". [Ackerley]
 - Rework the selftest flags testcase to query MMAP support for a given VM
   type instead of hardcoding expectations in the test. [Sean]
 - Add a testcase to verify KVM can map guest_memfd memory into the guest
   even if the userspace address in the memslot isn't (properly) mmap'd. [Sean]

v16:
 - https://lore.kernel.org/all/20250723104714.1674617-1-tabba@google.com
 - Rework and simplify Kconfig selection and dependencies.
 - Always enable guest_memfd for KVM x86 (64-bit) and arm64, which
   simplifies the enablement checks.
 - Based on kvm-x86/next: commit 33f843444e28 ("Merge branch 'vmx'").

v15:
 - https://lore.kernel.org/all/20250717162731.446579-1-tabba@google.com
 - Removed KVM_SW_PROTECTED_VM dependency on KVM_GENERIC_GMEM_POPULATE
 - Fixed some commit messages

v14:
 - https://lore.kernel.org/all/20250715093350.2584932-1-tabba@google.com
 - Fixed handling of guest faults in case of invalidation in arm64
 - Handle VNCR_EL2-triggered faults backed by guest_memfd (arm64 nested
   virt)
 - Applied suggestions from latest feedback
 - Rebase on Linux 6.16-rc6

Ackerley Tng (2):
  KVM: x86/mmu: Rename .private_max_mapping_level() to
    .gmem_max_mapping_level()
  KVM: x86/mmu: Handle guest page faults for guest_memfd with shared
    memory

Fuad Tabba (15):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: Fix comment that refers to kvm uapi header path
  KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
  KVM: guest_memfd: Add plumbing to host to map guest_memfd pages
  KVM: guest_memfd: Track guest_memfd mmap support in memslot
  KVM: arm64: Refactor user_mem_abort()
  KVM: arm64: Handle guest_memfd-backed guest page faults
  KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
  KVM: arm64: Enable support for guest_memfd backed memory
  KVM: Allow and advertise support for host mmap() on guest_memfd files
  KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mmap is supported

Sean Christopherson (7):
  KVM: x86: Have all vendor neutral sub-configs depend on KVM_X86, not
    just KVM
  KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly from
    KVM_SW_PROTECTED_VM
  KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff
    CONFIG_KVM_INTEL_TDX=y
  KVM: x86/mmu: Hoist guest_memfd max level/order helpers "up" in mmu.c
  KVM: x86/mmu: Enforce guest_memfd's max order when recovering
    hugepages
  KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
    mappings
  KVM: selftests: Add guest_memfd testcase to fault-in on !mmap()'d
    memory

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 203 +++++++++++----
 arch/arm64/kvm/nested.c                       |  41 ++-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |   6 +-
 arch/x86/kvm/Kconfig                          |  26 +-
 arch/x86/kvm/mmu/mmu.c                        | 142 ++++++-----
 arch/x86/kvm/mmu/mmu_internal.h               |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/svm/sev.c                        |   6 +-
 arch/x86/kvm/svm/svm.c                        |   2 +-
 arch/x86/kvm/svm/svm.h                        |   4 +-
 arch/x86/kvm/vmx/main.c                       |   7 +-
 arch/x86/kvm/vmx/tdx.c                        |   5 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |  11 +
 include/linux/kvm_host.h                      |  38 +--
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 236 ++++++++++++++++--
 virt/kvm/Kconfig                              |  15 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        |  81 +++++-
 virt/kvm/kvm_main.c                           |  12 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 26 files changed, 648 insertions(+), 214 deletions(-)


base-commit: beafd7ecf2255e8b62a42dc04f54843033db3d24
-- 
2.50.1.552.g942d659e1b-goog


