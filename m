Return-Path: <kvm+bounces-53549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10468B13DD4
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 662243BEDCE
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FFAE270576;
	Mon, 28 Jul 2025 15:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZN533QF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776FF2163B2
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753714944; cv=none; b=AQbc2Oeom+aMLQvw4G0imbJnX+12ii5Tb3JABcz+juOeq5tGmKWpzMeQMS6QeDpnmy/ngazl28csQrqRjR8/13No6oAqGG5xhRkVxD8FK3kexxg+2eb6FjvDly5FyrD4e60hnIN89tcaSNQfZgbDMLC9fjphZ0R1+g7bmWZr0ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753714944; c=relaxed/simple;
	bh=BTh86zDwFb6ZznGgyrNL2o8eYOdsnKcaACLzqZYSXYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n+aPrgD2sMtdB0PZBjDu1fjnKo/y3JI4tJtS3kqccJcVaQzmq8ltMSX0XYEhU5rNzxLA98YmveqyiTJHNfITyzcJ12mt7TdQwEDFyPy2Te54zeUO6X4hnAlJqFq3LHZsNhANKDp4U19Raw6vDOX0cyitO5XXvP7vf2LaKDh3jng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZN533QF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753714941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=elGSecSV9OSST+U7dctHU9qFzRKIaARMsPLSyHWoxAg=;
	b=WZN533QFOJf9EGaMX0hpLi6xgmv4ApdRKPFzhZhzd5ldzNa1vZ0rfjGB+wYPL+0WflqVqt
	6YV+8+rK017J+Hn84arbvEIUsgo5pW5pD11ehDppELjpoNKz3B/+erYPTEz4+AYADUr2Tr
	aL/UjOwR/cpL/JAxNPYnw+ai1FT1fdU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-xi5fMZEGPFCU8_5ITh7MNA-1; Mon, 28 Jul 2025 11:02:19 -0400
X-MC-Unique: xi5fMZEGPFCU8_5ITh7MNA-1
X-Mimecast-MFC-AGG-ID: xi5fMZEGPFCU8_5ITh7MNA_1753714938
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b785aee904so818597f8f.2
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 08:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753714938; x=1754319738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=elGSecSV9OSST+U7dctHU9qFzRKIaARMsPLSyHWoxAg=;
        b=MhD595cd7fTSnfs8Ex7Bdr1GE8luXaZ6SHMzOKqXvq3e6D0SoFtxyMe8wlZ8O8D0pn
         eam0TOcblHK7VKSokylsn4oqMTTD6I+UrSFmWwOe2wLMfWM1Nwre9rNrpUMEbzEUVtVr
         S6NYOj7bRqZy86/cJRfpq62ki3jRoIcui1FCcxoZzEAEN5ha15CthwgD8Sm55e591U5u
         IrF0orxCJj/JHEC5CKWAnbQ+O9BpUptOm969TxdarqNZcGUznwfoLRAeyPSnh4y59Ghk
         KyxGlNOCF2017m8xg0GxcsjK/rABFxOf2RVQcBJ15Emwt4a8+gfSOIZbQT5zWWYQZfm1
         ADPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMnJrrR5ISTXjQrX7y3asmsq08DZsHsHmbBQOXvUYXx42KauLL1ULay5xdvz8105+TZDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWbY9Ezjs1CtnyavqGm1ENn9BtbSYoWFSNy4PbHJOb8YXcPka9
	3QgOIx1w7+QLXjSv23ciaO47GFRGmY3Iq+vHf+hQ9/gKpW7R2G08NJwHSlZSiu0E8tuu5ksLTAJ
	6LUI8yq6VwfCZdzwUDxdaDgsJEAN2ivThm5rZJyy+S6/gomlvucNtyxbki62ujYrpi3R+3Tg5oz
	nu3LClAuNLoasDUQk/jtCTVHgB5yH/
X-Gm-Gg: ASbGnctSAJC1zWgj4L0tSNmRJcQpbDsvzqzKY8nEeYAe4BgaIszbs+/2nmCMGygd5dX
	f0t9HeRk//Ew7Z/iG/5K5nobc/I7UjFRWT27xekUIGVkBCjDzGXvbRafbKFcHM1FTbEzY2F5jwh
	xqg/kCDzdwyhMztSOm9cyIcA==
X-Received: by 2002:a05:6000:4026:b0:3b5:e244:52f9 with SMTP id ffacd0b85a97d-3b776763a56mr7346996f8f.40.1753714937029;
        Mon, 28 Jul 2025 08:02:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6uzlF+jACUVPLsGPhbpbskPMptmcLXwnAAXMMCON0yyh+bjQzlGx9K7h1FPmhAnrCqJROCMjrx/w0eClEYNo=
X-Received: by 2002:a05:6000:4026:b0:3b5:e244:52f9 with SMTP id
 ffacd0b85a97d-3b776763a56mr7346923f8f.40.1753714936286; Mon, 28 Jul 2025
 08:02:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
In-Reply-To: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Jul 2025 17:02:04 +0200
X-Gm-Features: Ac12FXy5nvj7N1QFJ6-2MfzWmrZqFxwa1WKNCcenlYu66yD-SVTUGy9HkIacZOE
Message-ID: <CABgObfZdhftTytMryGvkPf4Tqh3Nu76U0xqvE=4oycQvWoY4TA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2025 at 2:06=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.17:
> 1) Enabled ring-based dirty memory tracking
> 2) Improved "perf kvm stat" to report interrupt events
> 3) Delegate illegal instruction trap to VS-mode
> 4) Added SBI FWFT extension for Guest/VM with misaligned
>     delegation and pointer masking PMLEN features
> 5) MMU related improvements for KVM RISC-V for the
>     upcoming nested virtualization support
>
> Please pull.

Done, thanks.

Paolo

> Regards,
> Anup
>
> The following changes since commit 4cec89db80ba81fa4524c6449c0494b8ae08ee=
b0:
>
>   RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
> (2025-07-11 18:33:27 +0530)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.17-1
>
> for you to fetch changes up to 583c7288feb43eb8cbb18d08376d328e9a48e72d:
>
>   RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
> (2025-07-23 17:20:41 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.17
>
> - Enabled ring-based dirty memory tracking
> - Improved perf kvm stat to report interrupt events
> - Delegate illegal instruction trap to VS-mode
> - Added SBI FWFT extension for Guest/VM with misaligned
>   delegation and pointer masking PMLEN features
> - MMU related improvements for KVM RISC-V for upcoming
>   nested virtualization
>
> ----------------------------------------------------------------
> Anup Patel (12):
>       RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return val=
ue
>       RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
>       RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
>       RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with KVM_REQ_TLB_=
FLUSH
>       RISC-V: KVM: Don't flush TLB when PTE is unchanged
>       RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
>       RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
>       RISC-V: KVM: Factor-out MMU related declarations into separate head=
ers
>       RISC-V: KVM: Introduce struct kvm_gstage_mapping
>       RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
>       RISC-V: KVM: Factor-out g-stage page table management
>       RISC-V: KVM: Pass VMID as parameter to kvm_riscv_hfence_xyz() APIs
>
> Cl=C3=A9ment L=C3=A9ger (4):
>       RISC-V: KVM: add SBI extension init()/deinit() functions
>       RISC-V: KVM: add SBI extension reset callback
>       RISC-V: KVM: add support for FWFT SBI extension
>       RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG
>
> Quan Zhou (4):
>       RISC-V: KVM: Enable ring-based dirty memory tracking
>       RISC-V: perf/kvm: Add reporting of interrupt events
>       RISC-V: KVM: Use find_vma_intersection() to search for intersecting=
 VMAs
>       RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
>
> Samuel Holland (2):
>       RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
>       RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN
>
> Xu Lu (1):
>       RISC-V: KVM: Delegate illegal instruction fault to VS mode
>
>  Documentation/virt/kvm/api.rst                     |   2 +-
>  arch/riscv/include/asm/kvm_aia.h                   |   2 +-
>  arch/riscv/include/asm/kvm_gstage.h                |  72 +++
>  arch/riscv/include/asm/kvm_host.h                  | 109 +----
>  arch/riscv/include/asm/kvm_mmu.h                   |  21 +
>  arch/riscv/include/asm/kvm_tlb.h                   |  84 ++++
>  arch/riscv/include/asm/kvm_vcpu_sbi.h              |  13 +
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h         |  33 ++
>  arch/riscv/include/asm/kvm_vmid.h                  |  27 ++
>  arch/riscv/include/uapi/asm/kvm.h                  |   2 +
>  arch/riscv/kvm/Kconfig                             |   1 +
>  arch/riscv/kvm/Makefile                            |   2 +
>  arch/riscv/kvm/aia_device.c                        |   6 +-
>  arch/riscv/kvm/aia_imsic.c                         |  12 +-
>  arch/riscv/kvm/gstage.c                            | 338 ++++++++++++++
>  arch/riscv/kvm/main.c                              |   3 +-
>  arch/riscv/kvm/mmu.c                               | 509 +++++----------=
------
>  arch/riscv/kvm/tlb.c                               | 110 ++---
>  arch/riscv/kvm/vcpu.c                              |  48 +-
>  arch/riscv/kvm/vcpu_exit.c                         |  20 +-
>  arch/riscv/kvm/vcpu_onereg.c                       |  84 ++--
>  arch/riscv/kvm/vcpu_sbi.c                          |  53 +++
>  arch/riscv/kvm/vcpu_sbi_fwft.c                     | 338 ++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_replace.c                  |  17 +-
>  arch/riscv/kvm/vcpu_sbi_sta.c                      |   3 +-
>  arch/riscv/kvm/vcpu_sbi_v01.c                      |  25 +-
>  arch/riscv/kvm/vm.c                                |   7 +-
>  arch/riscv/kvm/vmid.c                              |  25 +
>  tools/perf/arch/riscv/util/kvm-stat.c              |   6 +-
>  tools/perf/arch/riscv/util/riscv_exception_types.h |  35 --
>  tools/perf/arch/riscv/util/riscv_trap_types.h      |  57 +++
>  31 files changed, 1382 insertions(+), 682 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_gstage.h
>  create mode 100644 arch/riscv/include/asm/kvm_mmu.h
>  create mode 100644 arch/riscv/include/asm/kvm_tlb.h
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>  create mode 100644 arch/riscv/include/asm/kvm_vmid.h
>  create mode 100644 arch/riscv/kvm/gstage.c
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
>  delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
>  create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h
>


