Return-Path: <kvm+bounces-51907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 122C9AFE6A5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:00:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 684561887FCB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D32928D8EE;
	Wed,  9 Jul 2025 10:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4zKcKAgW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC5288528
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058792; cv=none; b=aa6Q0fXonPeOw9Im/4/F+/4QBkRU8C0/7I+91KasUtDRvuHKxRlzVOpyogMx31eHHQx068/MVdn+56G5I9qONwVTkf7li9h2BXeAsqB/mktESBn9ccRPA0bPOMVclX1nkHGXfLYBfRRvv4pY+H8VRcZoNJhpiAuL31fQ7TqO4Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058792; c=relaxed/simple;
	bh=xXuPW7BNu1kc7MdxI3u1vqsSmr7Hbq2kX0tG6vFVM44=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PgY2rVI9vwjyDDNaRcAe0zv2RoBCAB+GcRfpkv8y+p7oMthOX8llrfBWgseeeLBROsiLWNA82dhpXkaeQn8nl8KcsUmsD98spSOvT8Tse2m1cFgsi9A/ZRscMUHc8vu7b7LEzjloJysegmwhuA1xm9jnXPhJyUTdIGbjUKVV118=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4zKcKAgW; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-450de98b28eso3656285e9.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 03:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058789; x=1752663589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dnO+KloSGnsCSQpQy5155dfzAZ7oAybktNY4973okqU=;
        b=4zKcKAgW1Rh9ocZfcvWquW51pM11e0dAEsHNAROQiM+iuQnN2PvJCS+XqeY70mszT2
         dyPoGlFwhVXpp1iN7xWSywa6OCWEDAdHEcxHPPjw+jX23JtiGNHmn1Ny6yyz3JiU2s5g
         /pPGx4qvPilvvfaB7Zc/L4skjkIFTkflipdQtxasb3ZpmL2Ssvgh39KJgreoqkZ3s8du
         wxEb+wYhFGZWx1i8+VHr31YKj5aLLDu/m4OGFTh1+8V9DGNShLYLcZZ3U7nK+yYvlrbx
         amETCWIC1nVnEhEMaKgNJWyFMxFELV9KB9K/b9g6jlmqfZkZ/9NT15h5bq1pVjOSa5yj
         7lCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058789; x=1752663589;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dnO+KloSGnsCSQpQy5155dfzAZ7oAybktNY4973okqU=;
        b=B5YOCxliTpMwxjrXK2Ik6PHDEXdyKAR3ubQkHLnzgJedBhkcpmTOYp82fbk4/waR3s
         yP9gbFDp26uCqXyv6gVnJEumHSv1OQVHnZHin9tDHHnmF+Xi97lkrVQToABniZxVdBYE
         DwQbLzZ6fDEuYSVnFvk06rM1vr8fgKp+U+TxSglf67fLRsgPEGPKnJH7wrhgoZMOzcrc
         uYsasjy6aKUUgPflKs6s7kxmgSXR8KPCrl6nk5dKt5rBSo+EIeaOtmQbEBhU6DkQZReG
         ewxuG5KXidvF2xcw0LBDfg4HOz6L68/xi2X9wyKZbJalFKxYXJnhc7MIuMwci4ljDgI9
         A5+Q==
X-Gm-Message-State: AOJu0YzQ8KM5FfupldxjGBuatvz6OdPFv5h2k8zL+M5qrDxGBbW/KAKV
	XXw2zACqxjZxYqyuOHVPiSG/xGlWe1vsBchu6GyO5HTbrkCB98qsW1ezO1bGYq9pjnjFjEfmN6Q
	tRJM06JwAAIYtcLfG+ZKAFItg9MNm7fezB9MomrNa6fdxzwMtxZDgz4EGaNqEKfBu68KtTCpw5E
	x3sQSJkC2XapP9aU9jrErMnPwa07A=
X-Google-Smtp-Source: AGHT+IH97vlc2PwP5kjBWi2BuUgBLehVgDMNHnMBRqDSahyj4kB6WdLKy5MfyYEnD1QG3au218TPdoT90g==
X-Received: from wmbes22.prod.google.com ([2002:a05:600c:8116:b0:440:5d62:5112])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b0f:b0:453:aca:4d08
 with SMTP id 5b1f17b1804b1-454d545fc59mr18960475e9.1.1752058788528; Wed, 09
 Jul 2025 03:59:48 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-1-tabba@google.com>
Subject: [PATCH v13 00/20] KVM: Enable host userspace mapping for
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

Main changes since v12 [1]:
* Rename various functions and variables
* Expand and clarify commit messages
* Rebase on Linux 6.16-rc5

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

Patches 15-17: Implement arm64 guest_memfd mmap support.

Patch 18: Introduce the new capability to advertise this support and
update the documentation.

Patches 19-20: Update and expand selftests for guest_memfd to include
mmap functionality and improve portability.

To test this patch series and boot a guest utilizing the new features,
please refer to the instructions in v8 of the series [5]. Note that
kvmtool for Linux 6.16 (available at [6]) is required, as the
KVM_CAP_GMEM_MMAP capability number has changed, additionally, drop the
--sw_protected kvmtool parameter to test with the default VM type.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250611133330.1514028-3-tabba@google.com/T/
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

Fuad Tabba (16):
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
  KVM: arm64: Enable host mapping of shared guest_memfd memory
  KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
  KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mmap is supported

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 190 ++++++++++++----
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  18 +-
 arch/x86/kvm/Kconfig                          |   7 +-
 arch/x86/kvm/mmu/mmu.c                        | 115 ++++++----
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
 24 files changed, 622 insertions(+), 167 deletions(-)


base-commit: d7b8f8e20813f0179d8ef519541a3527e7661d3a
-- 
2.50.0.727.gbf7dc18ff4-goog


