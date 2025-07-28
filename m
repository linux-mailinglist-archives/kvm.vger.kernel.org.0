Return-Path: <kvm+bounces-53562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F12B13F48
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DA3C16CD26
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED945272803;
	Mon, 28 Jul 2025 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ovS7rFJv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773C026CE1C
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753718150; cv=none; b=sEVASouZiY4+UJFA3Yu7atCUgcg2YQlyPLVGaImwJnv5cHWOjEfIGgtntIJlbboKRMvytvdvqvyv/t27y8Ini9BrJDI7wKva9ulmtSTH2QYG057m0FvhmnlRdQ65XoVN8dPw01kijJRYAAgX9jSdcVHFSrIyg2oFY8wVmVUnSaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753718150; c=relaxed/simple;
	bh=9r/Ht2nbV32jM7dP3siYnmI04ELhTd5f0jOF+AM1w8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d5xS/EEgiwZY77P0RpuTYfnqcqXCLbmZBWhlEo2xgYrIlV2SbgEcH2e6cggQa57z0FApqNoGqEB1rDVjvPA8NYln4DJIXQGOouUnpRvsoEhA2Fk+13PsOppT0Va8HYpxi408RsV59l8XZ2zGO9BM+67M3PFUW6r5ZnYntQUzzbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ovS7rFJv; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-87c04c907eeso399723539f.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 08:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1753718147; x=1754322947; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoQc7MqIQDw+6Efs0Tj4gYVMkroavuwmc+QEfRy0pSo=;
        b=ovS7rFJv+/vAlsSJVwcp9fZrIFSeFUppco8S1Eox0wabi3R4IuKyRicO+oHnrLSpR6
         mfiiFCZCaPIOFvTnheHkhLwyDckFg7unDpRjcpgwVUDGkZ4jf2K0HTR6Pv3B9t9FhTtK
         EvdMTt1zhBU1LeUnDSkjvJZqaPrOvYY0gBc9ki5b0SaApkcNvulzRAyVSM1awxqGQDU/
         oqbgc2TJh3Vhee2DjB2+kp5ypDI1+7jTfNvxs6WaPOPwm9WL+bGn5PU8yUMPsNxlNgyS
         hC8Vdmz2+vCdL0uOZjDQn2U9n81o2p0ZLrbHYnVlqGe7EE7IkWIx1X9Ks9KnpTP2MwjJ
         r/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753718147; x=1754322947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QoQc7MqIQDw+6Efs0Tj4gYVMkroavuwmc+QEfRy0pSo=;
        b=sZNw7cbDCPbHQiHwQglZH7SXrLhf/CbRu9ZRRaxaQnDZl0RJWgAgPrlSZpIMKYOCm+
         wC46HYwd6OHcjQdOmdLe5aEch2C1cDk+sM0MnpHBnCqsWfvp6FVNVGhp1EAexcHDj+Kp
         h4iWLV10k+wLVDYXWXZPXbV65Gw9ht33Kvuh/552ZIvMHYSRo0IWNT3hXSoRMO5LNg7M
         +k35qALheq2eeT0QiKmTJH5EnykgA+HYTj8gMxtLRBNRIZ5O73EA7wdnvmD+QGViE/tI
         Q0kiKgO3EOAK3Qtur5Jet+3KawLMvqj1EZTwWxjEtoB/Fk7clm+fFks8B3W3CdXAql6E
         vzOg==
X-Forwarded-Encrypted: i=1; AJvYcCVnOBbD9RTaB7THiFFUWb15Rv3dSmUZo5I1joLQvJ+sUgL/9SpBPzEVpHDMDAudqx1jCEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyKsogZ+YAsue32fPQPQJY9rqYE70tXvKLYntS5/TuH7yRCljl
	l/wb6JFXYuC9+7uRJqyOuPZg1QpPEEUI7Mwu61h6SaTZ0qILmGOFfCCv+oFDy3PTWUeSVpKZE7+
	lKONp2s7N/A+ojoKNslDGHGuEX4nkEdzCfBxTTKCpiw==
X-Gm-Gg: ASbGnct+EFwpgXGrJVuA3UeDcgoMgNVALh+MJpqlKZywV/gsU7FoABWn8qiahMovrIm
	ddCgNvslTcYRxYwsBBRyRapo/i1Vm3jzhcsC3VMGmf76lfMOgyTAG9rbBO4dvk7KhKlT4UWtZTq
	byIfF6LLg9bhrOvxD5kAOHLacNpVfadj33zISBkdeM5KksPSY+AcktLN3dmXRS/cduZdkH3cFVN
	R8ZEuNlWAEsCz8xMg==
X-Google-Smtp-Source: AGHT+IGtyQUUSJu9cmUvDWm8BQBfdBuhLyQi/GAW+Z9BCrTE0REl/Sb8eIeFDFT/23beG7olLPsjNZMfh1lpKeQ/TI0=
X-Received: by 2002:a92:c242:0:b0:3e3:b74e:dd1a with SMTP id
 e9e14a558f8ab-3e3c5259f1fmr213615925ab.3.1753718147308; Mon, 28 Jul 2025
 08:55:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
 <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com>
In-Reply-To: <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 28 Jul 2025 21:25:34 +0530
X-Gm-Features: Ac12FXyEGCGVkoPimb9v9aLpanQxwX644xefgJ4XRf_NEt1F87U2LZyXgZpr8DU
Message-ID: <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 9:22=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Fri, Jul 25, 2025 at 2:06=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> >       RISC-V: perf/kvm: Add reporting of interrupt events
>
> Something here ate Quan Zhou's Signed-off-by line, which is present at
> https://lore.kernel.org/r/9693132df4d0f857b8be3a75750c36b40213fcc0.172621=
1632.git.zhouquan@iscas.ac.cn
> but not in your branch.

There were couple of "---" lines in patch description which
created problems for me so I tried fixing manually and
accidentally ate Signed-off-by.

Sorry about that.

Regards,
Anup

>
> Paolo
>
> >       RISC-V: KVM: Use find_vma_intersection() to search for intersecti=
ng VMAs
> >       RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
> >
> > Samuel Holland (2):
> >       RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
> >       RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN
> >
> > Xu Lu (1):
> >       RISC-V: KVM: Delegate illegal instruction fault to VS mode
> >
> >  Documentation/virt/kvm/api.rst                     |   2 +-
> >  arch/riscv/include/asm/kvm_aia.h                   |   2 +-
> >  arch/riscv/include/asm/kvm_gstage.h                |  72 +++
> >  arch/riscv/include/asm/kvm_host.h                  | 109 +----
> >  arch/riscv/include/asm/kvm_mmu.h                   |  21 +
> >  arch/riscv/include/asm/kvm_tlb.h                   |  84 ++++
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h              |  13 +
> >  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h         |  33 ++
> >  arch/riscv/include/asm/kvm_vmid.h                  |  27 ++
> >  arch/riscv/include/uapi/asm/kvm.h                  |   2 +
> >  arch/riscv/kvm/Kconfig                             |   1 +
> >  arch/riscv/kvm/Makefile                            |   2 +
> >  arch/riscv/kvm/aia_device.c                        |   6 +-
> >  arch/riscv/kvm/aia_imsic.c                         |  12 +-
> >  arch/riscv/kvm/gstage.c                            | 338 +++++++++++++=
+
> >  arch/riscv/kvm/main.c                              |   3 +-
> >  arch/riscv/kvm/mmu.c                               | 509 +++++--------=
--------
> >  arch/riscv/kvm/tlb.c                               | 110 ++---
> >  arch/riscv/kvm/vcpu.c                              |  48 +-
> >  arch/riscv/kvm/vcpu_exit.c                         |  20 +-
> >  arch/riscv/kvm/vcpu_onereg.c                       |  84 ++--
> >  arch/riscv/kvm/vcpu_sbi.c                          |  53 +++
> >  arch/riscv/kvm/vcpu_sbi_fwft.c                     | 338 +++++++++++++=
+
> >  arch/riscv/kvm/vcpu_sbi_replace.c                  |  17 +-
> >  arch/riscv/kvm/vcpu_sbi_sta.c                      |   3 +-
> >  arch/riscv/kvm/vcpu_sbi_v01.c                      |  25 +-
> >  arch/riscv/kvm/vm.c                                |   7 +-
> >  arch/riscv/kvm/vmid.c                              |  25 +
> >  tools/perf/arch/riscv/util/kvm-stat.c              |   6 +-
> >  tools/perf/arch/riscv/util/riscv_exception_types.h |  35 --
> >  tools/perf/arch/riscv/util/riscv_trap_types.h      |  57 +++
> >  31 files changed, 1382 insertions(+), 682 deletions(-)
> >  create mode 100644 arch/riscv/include/asm/kvm_gstage.h
> >  create mode 100644 arch/riscv/include/asm/kvm_mmu.h
> >  create mode 100644 arch/riscv/include/asm/kvm_tlb.h
> >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> >  create mode 100644 arch/riscv/include/asm/kvm_vmid.h
> >  create mode 100644 arch/riscv/kvm/gstage.c
> >  create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
> >  delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
> >  create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h
> >
>

