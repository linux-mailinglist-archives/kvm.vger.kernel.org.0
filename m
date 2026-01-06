Return-Path: <kvm+bounces-67176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B18FCFAE46
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 21:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6694F309AD8D
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 20:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DA9350A11;
	Tue,  6 Jan 2026 19:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bitZLyBT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB05F350A0E
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728972; cv=pass; b=uHK0Z7Qf4C9GILvXwGEB2D0foODWyssq3RHSMIURcjc460I1dyyaGoma5HsEBGwOlmmCLTxh2KqunAsABa1sVPhcEybyS6fC8XxOft16fThJaJLbmEbLkA8Mderd4JQ75+BRP5YMi4nhxagZO3lMkEmDdP8Oc89HFaVVKZZP43c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728972; c=relaxed/simple;
	bh=p6oeRyLM2d9R8ycZvPrjdHpPqvJio4+nRSZFHhJA4O4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pAeKlDbhqPO2tpywkNtUUsMiCR5Tpl2qXO8Q3vyU2HRaLyoNO1r9S8jgfBX8w11VaViMxhymrgRXz5WlhwXdVeBwRUaPFMyGZBY+TZ8Pr6OZQf+xHljLNmQi6WkpPHZgCaWgN7rgZbjPgM5vo8ZR4yk5UHwbjTibwigay8FJebA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bitZLyBT; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4f34f257a1bso62111cf.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 11:49:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767728970; cv=none;
        d=google.com; s=arc-20240605;
        b=bDPsriLz5/z9x0W7L4RVWwbhAzM6ZKw0q2HSwVcOrm8tvti5f0RZ4cS4l8mdP/QfcN
         IF6UuytuEO1E2h+eL+PZbbHuOcuhWEIKlXULxmeAsO4viE1xvF31878lY0dUpMbRb5xg
         44jcR9mtFiYUMocz58NFOLIAonKxPtp47IVzWIDsZYDdQJ9Ml00VQ4ICoXot3neRhB5b
         sxRntPGp642RkTBx12h2mIMsfzLjQrQkW+gi+6le/6rXylKHHN4jUr9S4jYsTsJHNrMb
         NQuJSguw9QMODc1JvwVYA6sF/f+2gCGUHWiSlzSop6aPzS759rfXJQ1YdiMGUZZOBZYl
         NLSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k9+aHBxxyMm5uEUryvCGnluoRKqqLv7iqR1X9acm+vo=;
        fh=M05P1DkrSKgGfPRlVnUJeVM1Z8U3a1oVV9NUr2GgNAE=;
        b=ZVT1sqsB+Bb7wAAfGHW5jkptbxGUnWh5fLKAJyy6SVZr3YoR0Lvfa2xLCUF921MaE2
         d2K7jgejMagEZ6OSc/0ejY2lxwVprKB+q3cJKA0bc40guFCTAIQAycmHyBcWWv2SBFsC
         mmtRiei3/zaa2FaF0ARBdhwevuuXd8GS9EUmvQLThygNilaZ9U8wSyCsTKSw7tMAOIxB
         4PF1GfhumGAkJZGW/EJO/NgvrplkWvD1DUTKaMi4/xm7hP3kaBht4JnaF+BR2xm6WfS1
         dzOaRYOPaUTVluO4f6WNRnRqNH4aJrmb+mUoave1845L8SShjXHK3SRzmC2deKfF93MP
         ldkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767728970; x=1768333770; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k9+aHBxxyMm5uEUryvCGnluoRKqqLv7iqR1X9acm+vo=;
        b=bitZLyBTfHNYDyWGmz0OYgSC7vi9+BEjaqZaZtCtFSUvRtnIq8B2lzhuDtwS8Vx9WM
         bUQH+MuhZnV4XNVjMpn1GNdXJIZxWoCVqjVqcVFO8CwK53cR10ba1IRgMRniEmlOQU6n
         x1J608jO3HN2r2WSK6In/kz4S93SA3CB8lpTIfhUwox5/bNAyX9mECEtcEzfWjmLelxP
         OZYTB3dJBVg46F1qU05/5KtlWdDXPp/ueGU4/GBMWhPvvVI3EIQRd2e2fyJOgmd5zwq7
         90uumQrlc0E/5zsqQaaS/vYsIwrgLumKSy8QILUwPKO9RisgCWMd27LYN98+O1/3Psyi
         Fbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728970; x=1768333770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9+aHBxxyMm5uEUryvCGnluoRKqqLv7iqR1X9acm+vo=;
        b=ihrMNMbahQjMOPJ2Vfk5hPs1oWYAwjDziBAl9MHa0YMn9xpObb6+3RBoMLP7EyKPcg
         fWbmv/Q9EDX0uhk18vl4P0E1PrbVRzMfzYzkdq/glSJmuFh9UMHVNCp3q1bOfEdxwD74
         RetFSghF8yPQQhWi8eE2iYbV5U6g634BmyKythIwQlWG0ERL1yd4x2DmFrlm7h61Le4j
         86UdC86E8KRaCuIlmfF4w/OGQrOIC9c68TIwj5G2lklXYm91xmq+LjAqw94zQMBg0oUs
         P8p7e0dviSkCRm8RpC2jY/uJYie4uM7zgSPCrg9GIQYXf5aSKV9nQcHGOiP5cH4todcC
         oQ3w==
X-Gm-Message-State: AOJu0Ywsjok9X04wdHEhBbhn/tCXHKBG89G4tlZ8+Hdf24rKWApBUE78
	sbftXRhQmzV7liDcZlphddyPLdXccL5ACNgUSswx4/j6B/+mYQyCTvQUThiE03GNMC66dDZwLXh
	3c+ARtuABibVH0oa6ctHiAd5AxZqF+0KW5lvYiopm
X-Gm-Gg: AY/fxX7bRTXf3yNyy+AJkLDmUwROx7snw5jsIYQoqXD8ISR95EbnRFHw8WlXbcU0oUk
	RmfvFUEOY6FpdAvt5Nty+Zg3KnqKCvIjsQaFQN4K4ZRL4f0BDY7GalA6LHC1Z4Im2wGh9469RVv
	Gm+zLLD+ZggvO2x/Q8xPNXfsPVqbINL/h0aZCdD4R6c+qmaPz4Owfphq9HXlZSfxVAoKnFB1r2l
	GvFThwUlZ12OeRnyqkNT4tM0KvAVs5e3TybWEoBhyewWZRq8sLALlXaEOnl4yBYoGcFJeki
X-Received: by 2002:ac8:58d3:0:b0:4ff:a98b:c33e with SMTP id
 d75a77b69052e-4ffb3c9bfd7mr1612321cf.6.1767728969218; Tue, 06 Jan 2026
 11:49:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com> <20260106092425.1529428-5-tabba@google.com>
 <aV1mqQtALFIUBHVM@google.com>
In-Reply-To: <aV1mqQtALFIUBHVM@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 6 Jan 2026 19:48:52 +0000
X-Gm-Features: AQt7F2oD6imhUH1-IKtVcA97OhzMLb8nSqzV2q_rb-md0NTxT87GehM6m6PIMYQ
Message-ID: <CA+EHjTw3YBG9HNateXEAYsSUJ625eWGu2OHt-2=Y0=-qzbObWw@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Move page_align() to shared header
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Jan 2026 at 19:46, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 06, 2026, Fuad Tabba wrote:
> > To avoid code duplication, move page_align() to the shared `kvm_util.h`
> > header file.
> >
> > No functional change intended.
> >
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
> >  tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
> >  tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
> >  3 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 81f4355ff28a..dabbe4c3b93f 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
> >       return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
> >  }
> >
> > +static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>
> Maybe vm_page_align()?  So that it's a bit more obvious when reading call sites
> that the alignment is done with respect to the guest's "base" page size, not the
> host's page size.

Yes, that's clearer. I'll fix this.

Thanks,
/fuad

> > +{
> > +     return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> > +}
> > +
> >  /*
> >   * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
> >   * to allow for arch-specific setup that is common to all tests, e.g. computing
> > diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > index 607a4e462984..143632917766 100644
> > --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > @@ -21,11 +21,6 @@
> >
> >  static vm_vaddr_t exception_handlers;
> >
> > -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> > -{
> > -     return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> > -}
> > -
> >  static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
> >  {
> >       unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
> > diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > index d5e8747b5e69..f8ff4bf938d9 100644
> > --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > @@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
> >       return !ret && !!value;
> >  }
> >
> > -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> > -{
> > -     return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> > -}
> > -
> >  static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
> >  {
> >       return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
> > --
> > 2.52.0.351.gbe84eed79e-goog
> >

