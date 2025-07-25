Return-Path: <kvm+bounces-53446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27188B11E1E
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 14:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B812E3A4405
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 12:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2910A24468B;
	Fri, 25 Jul 2025 12:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="KPXHKSnQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DEB242D7F
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 12:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753445211; cv=none; b=Gfp19RUCoQYu4EYgoeN7Xx52504B/70A6v6yWSxVQVgLhrwEH5Xf7mf7TkrbBQa5rGUYvkvmSuMnDjh5inoJui99VJC16L/xs+xdgd9eOij5orI9OGu+DnFhqcqJQoM+lgwv6fJzf9FrTT4gmnlFGJbcfblSU/Umr0aj1iObKwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753445211; c=relaxed/simple;
	bh=85E40NLxS2nvmUGFAwKt8WkSlulmZAnqtN+Gr+keAlU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PucVwa/s3AAdlmdy0/Zuq0DATQV1p2Lg4Pn1BYWMADau4OzKZuhTt1ypGW29PFmMNot9xPjBqmKoutXP3sHrsWfzrNnHIQuHctmJWa22D8i4YQd9VPmSVaWvTgm7P9vSSfJvH+e9qtJOag2EUXNFYQylbWX28CRwjc5CW/zxUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=KPXHKSnQ; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-87c46159b24so74426339f.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 05:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1753445208; x=1754050008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7Jf1SSxOJbfpQP3N1Q99A6u9zArCFnC+5FZX72Ckuo0=;
        b=KPXHKSnQAoHM52vMpxYVyR6t6KDRsjZM8KNPaSiI1mP4ZXzXGdQAOdtCJisx9wZDWB
         harpa9VWeC1miRjDe4vzLuQoNvEZqJ3F0Ib6+vQ6yddY6VqT/rzOO6OgIqnc57jOaGYJ
         X/2qCxYEt1wYQs+WfoJoJnJqWpWQwKBOyjd9p7MXE0FT5nyKSe52PNSctLS6z+PVSKEk
         Xnl7LC81OkIlTmhIkLvZRozpmY+HGdnXUyLf/dpWKvABdpnU/r9bcL3hYGbLe8bYbBMy
         h1oppx8e5K1Ls73VLkJJDQkZb3YpnWvwMUWq0L4y2xsubEGvJ1FogcNOKGWhurQ6E53v
         dXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753445208; x=1754050008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Jf1SSxOJbfpQP3N1Q99A6u9zArCFnC+5FZX72Ckuo0=;
        b=WVylntQdbcKg/ZcTDuR6rOl30ElwgGiWnrEYimSB/2RBQ7HTgXWCZHavz4yUj/r4LR
         3DiviH9mexhcpj6Ham4hZSZzz1uMvIvAB3KjYvwaChNbAR+e7d/PKFZaGzplXRJlRIoD
         e524tWqXoQb+VQnHe9j5F9nmVE4DVtKoGs4ib2Fsia2M086My1a1rUkvvOjVZMJapOfb
         4IRCyG/i3SyZjsP5R705kSXfQonwUsHO5JB826kSNeqiFAcehI2/2J/Q/ga2v0w51ygp
         qEMDh/uDhXY/pwy2lMuN5Xkzv9rj81qH2PUp44VstEN1+CCqwB2KvfeIHeQfb/Rdlkqr
         ZxSA==
X-Forwarded-Encrypted: i=1; AJvYcCUpmKkRf5IVRaFTSwURPwgTfj0EyQYoIgcIFWN75xs9DvJRVODvY/8wZLU51D29tReO39c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0YekUd8fHhhHJh/EpU3KPqm0Z02zjsWbvFugZuHpAL4m3shds
	ATiQlyJ8yu7tqysKA+DCUvbZgPs8YiXZkUbnwFCM7WJ/3JPXR7nlZjErffWUoIbdb/r4OjNfZXT
	U99jFB7sUV7Tm4Z+MHPmA4oh+ypz/wDcMx5ybIIAO4TxzUcBVZy6B
X-Gm-Gg: ASbGnct6SgQ4glPhw8z0g/r60K8dePkn9ph9/Sq6IDGyHhADAYv6llv1aqFcT+l3ep5
	H2HIbEIKMbe+XANCtdBQnK2QYIuFJ8D1vcgf1/T9vqGJqXKJ6idu1yC1eG+I9Yh7RBkx50DgFRq
	LhtjyRSdoA9xg3szUGWtZ3y3duypjvruMhBBEllDrpyPkxZLEuJafGPBlrGzvVFlTaWeqvzi+n+
	Uo0QCQ=
X-Google-Smtp-Source: AGHT+IFa4dSsgSpZFYek8uZqLKc9MO74vkbxxoseVsenzFl4oi+CwAq4/ReQu91NZ+euJU2gTyKsu9V2xo8Zu7D9nkI=
X-Received: by 2002:a05:6602:168c:b0:879:674e:2c73 with SMTP id
 ca18e2360f4ac-8800f0b5176mr284008339f.4.1753445208246; Fri, 25 Jul 2025
 05:06:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 25 Jul 2025 17:36:36 +0530
X-Gm-Features: Ac12FXwjQXvT4XMofTKJke-pvu4QS2cpuv-CY57HpTPlGzz1oCnc7kjwlss85eA
Message-ID: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.17
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have the following KVM RISC-V changes for 6.17:
1) Enabled ring-based dirty memory tracking
2) Improved "perf kvm stat" to report interrupt events
3) Delegate illegal instruction trap to VS-mode
4) Added SBI FWFT extension for Guest/VM with misaligned
    delegation and pointer masking PMLEN features
5) MMU related improvements for KVM RISC-V for the
    upcoming nested virtualization support

Please pull.

Regards,
Anup

The following changes since commit 4cec89db80ba81fa4524c6449c0494b8ae08eeb0=
:

  RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
(2025-07-11 18:33:27 +0530)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.17-1

for you to fetch changes up to 583c7288feb43eb8cbb18d08376d328e9a48e72d:

  RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
(2025-07-23 17:20:41 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.17

- Enabled ring-based dirty memory tracking
- Improved perf kvm stat to report interrupt events
- Delegate illegal instruction trap to VS-mode
- Added SBI FWFT extension for Guest/VM with misaligned
  delegation and pointer masking PMLEN features
- MMU related improvements for KVM RISC-V for upcoming
  nested virtualization

----------------------------------------------------------------
Anup Patel (12):
      RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
      RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
      RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
      RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with KVM_REQ_TLB_FL=
USH
      RISC-V: KVM: Don't flush TLB when PTE is unchanged
      RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
      RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
      RISC-V: KVM: Factor-out MMU related declarations into separate header=
s
      RISC-V: KVM: Introduce struct kvm_gstage_mapping
      RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
      RISC-V: KVM: Factor-out g-stage page table management
      RISC-V: KVM: Pass VMID as parameter to kvm_riscv_hfence_xyz() APIs

Cl=C3=A9ment L=C3=A9ger (4):
      RISC-V: KVM: add SBI extension init()/deinit() functions
      RISC-V: KVM: add SBI extension reset callback
      RISC-V: KVM: add support for FWFT SBI extension
      RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG

Quan Zhou (4):
      RISC-V: KVM: Enable ring-based dirty memory tracking
      RISC-V: perf/kvm: Add reporting of interrupt events
      RISC-V: KVM: Use find_vma_intersection() to search for intersecting V=
MAs
      RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()

Samuel Holland (2):
      RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
      RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN

Xu Lu (1):
      RISC-V: KVM: Delegate illegal instruction fault to VS mode

 Documentation/virt/kvm/api.rst                     |   2 +-
 arch/riscv/include/asm/kvm_aia.h                   |   2 +-
 arch/riscv/include/asm/kvm_gstage.h                |  72 +++
 arch/riscv/include/asm/kvm_host.h                  | 109 +----
 arch/riscv/include/asm/kvm_mmu.h                   |  21 +
 arch/riscv/include/asm/kvm_tlb.h                   |  84 ++++
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  13 +
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h         |  33 ++
 arch/riscv/include/asm/kvm_vmid.h                  |  27 ++
 arch/riscv/include/uapi/asm/kvm.h                  |   2 +
 arch/riscv/kvm/Kconfig                             |   1 +
 arch/riscv/kvm/Makefile                            |   2 +
 arch/riscv/kvm/aia_device.c                        |   6 +-
 arch/riscv/kvm/aia_imsic.c                         |  12 +-
 arch/riscv/kvm/gstage.c                            | 338 ++++++++++++++
 arch/riscv/kvm/main.c                              |   3 +-
 arch/riscv/kvm/mmu.c                               | 509 +++++------------=
----
 arch/riscv/kvm/tlb.c                               | 110 ++---
 arch/riscv/kvm/vcpu.c                              |  48 +-
 arch/riscv/kvm/vcpu_exit.c                         |  20 +-
 arch/riscv/kvm/vcpu_onereg.c                       |  84 ++--
 arch/riscv/kvm/vcpu_sbi.c                          |  53 +++
 arch/riscv/kvm/vcpu_sbi_fwft.c                     | 338 ++++++++++++++
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  17 +-
 arch/riscv/kvm/vcpu_sbi_sta.c                      |   3 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                      |  25 +-
 arch/riscv/kvm/vm.c                                |   7 +-
 arch/riscv/kvm/vmid.c                              |  25 +
 tools/perf/arch/riscv/util/kvm-stat.c              |   6 +-
 tools/perf/arch/riscv/util/riscv_exception_types.h |  35 --
 tools/perf/arch/riscv/util/riscv_trap_types.h      |  57 +++
 31 files changed, 1382 insertions(+), 682 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_gstage.h
 create mode 100644 arch/riscv/include/asm/kvm_mmu.h
 create mode 100644 arch/riscv/include/asm/kvm_tlb.h
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
 create mode 100644 arch/riscv/include/asm/kvm_vmid.h
 create mode 100644 arch/riscv/kvm/gstage.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
 delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
 create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h

