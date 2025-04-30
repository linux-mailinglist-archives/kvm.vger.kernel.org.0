Return-Path: <kvm+bounces-44941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 191D9AA5232
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A5DB165EE2
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC14264A69;
	Wed, 30 Apr 2025 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CaPqdgTa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69DC190676
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032220; cv=none; b=Zse5fYqOpk5NV/s9TtTqtJxAiXfKB2Lah65a0Dhw++DJlfurVcdzCXQ3gG7ccxIINLdPNz0hIBykni7nDLPOxlOTgV1Quj7+5QJRvYOk0U2vOLTOFxr1rAAW/OVjP5FIP6Fx5qquyYq/4WisHnVzIWyBwHMFx0HKTqqXt7/RUGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032220; c=relaxed/simple;
	bh=EFxgAa8FQdhHI2di0hKEHlvzVdZkUjKQzhtuzeSgM7o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=i0746tlGEjWzq7tC7FRMWOEf+NeL91j77T2nw7uy/CoYzIwCTBdYWHMbB59WJecWYL8b3MDx1X9oIRoVC1CiLL6c5bXZY2z27hxeXGY1yEhaLrfJF5QYS6mGbdp7HC0z+G9GA7gODYa+hRLnuellxh7rz0LoXOaPp2Tt+2GJa2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CaPqdgTa; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43eed325461so45515e9.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032217; x=1746637017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T43Ue4g6bjq/nL4SqLo7xv0mu1p0WiGDtOfd7HkqUpc=;
        b=CaPqdgTaAkWpOacdb8x1tpeBbYGBxPkOtAhNkyiEXI/zy0AxL+rdo43+MWwUz9LZZa
         okNomkbBATQseY6eOPH/gp5c52GQSfLw+IQCtRpOG3IQEiWr/+8dIVDlddyGN/MiS6wy
         g5ww58WKqcn21Kyhfel/Xknrc+8Wpfe0aL7iQJc+BGqfOPI1doyOo1knk24MI5VvKN2W
         +VoKhJLixv1mu1xoQkKgkmcxyOpIqI0a7/0m3Ev+UoU4f9xPQCcP0jWMyOdnQupLDZFC
         YdiRWgc6PlDSGBgJnHac+QovzREMptNgkAvQtXrxNVL0dnu1x4KsJfGa7zwK2WLN5v63
         6TmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032217; x=1746637017;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T43Ue4g6bjq/nL4SqLo7xv0mu1p0WiGDtOfd7HkqUpc=;
        b=k6yBdkBygJ1/tlpxOebipIT2iqf0Je9U4NPoOhFm/RsON80ewNgpp9wsPxJagSOByV
         co7P6iAAR2UXgOBRQ/ttmQE5/IT3jEATLUuKwhWu5urAa+upzX3v5Tq9sAg27AlI7V4n
         EktGX7OifuosWlPoEjauJEpetAckJ5OZx9t7FM5f0e0hHZ5ESUcH9fbvNim8GS0CzLlO
         C0P7IMyvJ0nz/4fET+5nhiobtoOsNEbCW/oIx2aLH0JmrvRidv05AR6kv0cHSG22ZAbt
         fXTvlSnqI+dnMjp/T9z3Yxg5ssiKWf+M5MZbD660WHqcZ7fRMUMwJJnmeHOwlNcdOR+p
         G9yg==
X-Gm-Message-State: AOJu0YxC4ynkVZ982qvhMi0ulmjCbqueJjD+4iWeuDx9XQBncOY3aBCs
	jZ2UyetFXGiwdPLuEwySP8UhidmaVIERnAzg6KYDIoO+wRNYFALUDkP0c+lhguucjC1hS0yDupX
	lQsK+optjEAIPpPQk0wYmpACKYj0r+qDyJQp6VP6Krce6HQcqThUkmvYfAcaIFGnGu8EXge4p73
	oug6h3FHor/0HFUyi3kS0dLxs=
X-Google-Smtp-Source: AGHT+IGLbLHWJLTtxQ2+hsAfuFL0SmsYOOUwmglTFnrn34i6deXuovfrm0Yy4rbWq9iAjli8ARhAHInyhw==
X-Received: from wmbay26.prod.google.com ([2002:a05:600c:1e1a:b0:440:58dd:3795])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8507:b0:440:94a2:95b8
 with SMTP id 5b1f17b1804b1-441b265a0b4mr44426365e9.16.1746032217088; Wed, 30
 Apr 2025 09:56:57 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-1-tabba@google.com>
Subject: [PATCH v8 00/13] KVM: Mapping guest_memfd backed memory at the host
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v7 [1]:
- Renaming/refactoring to decouple guest memory from whether the
  underlying memory is private vs being backed by guest_memfd
- Drop folio_put() callback patches
- Fixes based on feedback from the previous series
- Rebase on Linux 6.15-rc4

The purpose of this series is to allow mapping guest_memfd backed memory
at the host. This support enables VMMs like Firecracker to run VM guests
backed completely by guest_memfd [2]. Combined with Patrick's series for
direct map removal in guest_memfd [3], this would allow running VMs that
offer additional hardening against Spectre-like transient execution
attacks.

This series will also serve as a base for _restricted_ mmap() support
for guest_memfd backed memory at the host for CoCos that allow sharing
guest memory in-place with the host [4].

Patches 1 to 7 are mainly about decoupling the concept of guest memory
being private vs guest memory being backed by guest_memfd. They are
mostly refactoring and renaming.

Patch 8 adds support for in-place shared memory, as well as the ability
to map it by the host as long as it is shared, gated by a new
configuration option, and adviertised to userspace by a new capability.

Patches 9 to 12 add arm64 and x86 support for in-place shared memory.

Patch 13 expands the guest_memfd selftest to test in-place shared memory
when avaialble.

To test this patch series on x86 (I use a standard Debian image):

Build:

- Build the kernel with the following config options enabled:
defconfigs:
	x86_64_defconfig
	kvm_guest.config
Additional config options to enable:
	KVM_SW_PROTECTED_VM
	KVM_GMEM_SHARED_MEM

- Build the kernel kvm selftest tools/testing/selftests/kvm, you
only need guest_memfd_test, e.g.:
	make EXTRA_CFLAGS="-static -DDEBUG" -C tools/testing/selftests/kvm

- Build kvmtool [5] lkvm-static (I build it on a different machine).
	make lkvm-static

Run:
Boot your Linux image with the kernel you built above.

The selftest you can run as it is:
	./guest_memfd_test

For kvmtool, where bzImage is the same as the host's:
	./lkvm-static run -c 2 -m 512 -p "break=mount" --kernel bzImage --debug --guest_memfd --sw_protected

To test this patch series on arm64 (I use a standard Debian image):

Build:

- Build the kernel with defconfig

- Build the kernel kvm selftest tools/testing/selftests/kvm, you
only need guest_memfd_test.

- Build kvmtool [5] lkvm-static (I cross compile it on a different machine).
You are likely to need libfdt as well.

For libfdt (in the same directory as kvmtool):
	git clone git://git.kernel.org/pub/scm/utils/dtc/dtc.git
	cd dtc
	export CC=aarch64-linux-gnu-gcc
	make
	cd ..

Then for kvmtool:
	make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LIBFDT_DIR=./dtc/libfdt/ lkvm-static

Run:
Boot your Linux image with the kernel you built above.

The selftest you can run as it is:
	./guest_memfd_test

For kvmtool, where Image is the same as the host's, and rootfs is
your rootfs image (in case kvmtool can't figure it out):
	./lkvm-static run -c 2 -m 512 -d rootfs --kernel Image --force-pci --irqchip gicv3 --debug --guest_memfd --sw_protected

You can find (potentially slightly outdated) instructions on how
to a full arm64 system stack under QEMU here [6].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250318161823.4005529-1-tabba@google.com/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[5] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-basic-6.15
[6] https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/docs/qemu/qemu-arm64-howto.html

Fuad Tabba (13):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_KVM_GENERIC_GMEM_POPULATE
  KVM: Rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
  KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: x86: Generalize private fault lookups to guest_memfd fault
    lookups
  KVM: Fix comments that refer to slots_lock
  KVM: guest_memfd: Allow host to map guest_memfd() pages
  KVM: arm64: Refactor user_mem_abort() calculation of force_pte
  KVM: arm64: Handle guest_memfd()-backed guest page faults
  KVM: arm64: Enable mapping guest_memfd in arm64
  KVM: x86: KVM_X86_SW_PROTECTED_VM to support guest_memfd shared memory
  KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
    allowed

 arch/arm64/include/asm/kvm_host.h             | 12 +++
 arch/arm64/kvm/Kconfig                        |  1 +
 arch/arm64/kvm/mmu.c                          | 76 +++++++++------
 arch/x86/include/asm/kvm_host.h               | 17 ++--
 arch/x86/kvm/Kconfig                          |  4 +-
 arch/x86/kvm/mmu/mmu.c                        | 31 +++---
 arch/x86/kvm/svm/sev.c                        |  4 +-
 arch/x86/kvm/svm/svm.c                        |  4 +-
 arch/x86/kvm/x86.c                            |  3 +-
 include/linux/kvm_host.h                      | 44 +++++++--
 include/uapi/linux/kvm.h                      |  1 +
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 75 +++++++++++++--
 virt/kvm/Kconfig                              | 15 ++-
 virt/kvm/Makefile.kvm                         |  2 +-
 virt/kvm/guest_memfd.c                        | 96 ++++++++++++++++++-
 virt/kvm/kvm_main.c                           | 21 ++--
 virt/kvm/kvm_mm.h                             |  4 +-
 18 files changed, 316 insertions(+), 95 deletions(-)


base-commit: b4432656b36e5cc1d50a1f2dc15357543add530e
-- 
2.49.0.901.g37484f566f-goog


