Return-Path: <kvm+bounces-10254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70ECB86B05A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 949891C25CEF
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A8614E2DA;
	Wed, 28 Feb 2024 13:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrtoESqG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3871487DB
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709126977; cv=none; b=E2DXCc9Ryn/lDSpny9s36S8QKTUujcVMFOenGkwEt7X3uCQnBV/fkTz6fkB+EKlkAVZ9EyJs/cb+HHfD3nleoKQpsMuhANYDOfwijF2BTYzTAK5o/cVrgV3O+OExTXcDLJjKmLqOOmN80dPAxs9onaGNwzPPvitKCPwaYebhGoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709126977; c=relaxed/simple;
	bh=8C9xjDtwVubJnIZ59ku4USy+YZ5NXDWqvFar24cX19Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K34sSllg1NXFCnSGHaXYLINsQrKTwE3p5jbPO2roH9rwilhZ0nLPYVwUgB43kPJe+z+4H5uom4zlFcFuRdbqMJXcXojWwAVQIMmgHC9ptqhhB8Yhlc9Ic1PobxaL7A/1by4TdcGCTGF9LBVw2uD/jJlFrYEa4xxnLvrgFT7LJFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RrtoESqG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709126974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DhHR8mT655dVQv+Wx7zsXbjJvhrKDohyC9LbFEwHkvs=;
	b=RrtoESqGGOKQ2xoI61b1gmSrk80hxA0gocEkue6yJ8MrC7TRBkmq7vij+Ros4j1TtCG571
	Xa5Alo7scUE7hLjS4rUCb2x6anWMGMP73hpma7oHUJgB8jSy2nRz+G3/ktpgy6DbltvaWG
	MWdAAwvXqNDKo6LJLH6/q+s9J7TnG2M=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-eVhnYbgFOtekEGMq7kPv5A-1; Wed, 28 Feb 2024 08:29:32 -0500
X-MC-Unique: eVhnYbgFOtekEGMq7kPv5A-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d29fb0dbbcso15391691fa.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 05:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709126971; x=1709731771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DhHR8mT655dVQv+Wx7zsXbjJvhrKDohyC9LbFEwHkvs=;
        b=AB0M8eAZl0xL2iVvecCauxlemo39tDEZJQAgvqD0hEk2nsBnqqi/RfZj7p7TMvJRhT
         TsY3WGlmL+4LfTnOJqDMycP6cYhb3N2Qw4xwFFPcldYNQt0tC6lu0c+pomZvh6VLniHX
         P5Yp1KORnq4z/8jtVWrcPsiovukCn82YhiuN8+7gNi5oSSVZl6DyuwTU4pnxNN1hPF0Q
         91RLU0QF5+ob4FG8zTHs+XEz+dmueFv68Ern8TRsuEKbb1yQqBeTM8uPR5cEsv5DIbLR
         UC4J0ypgBN0M3dtIIoF6+ZfBjgSb7N5N79EY3Z+8JTUqfzKcGTAzlrzqbxme4g1LYhGu
         /1vQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9BpvuKQ1IdX/ls/ss/hlLjiUoRl1EFCnO/LmDOrLRI9V8z4o0MLGmHH40pIT2D2eW8F5+pH3mEJPv7FANB51TvdYa
X-Gm-Message-State: AOJu0YxAYEwh1u8hGsP4rh65NcGaPxWeJ15bJ6iooOz1dJuiHB/ksblz
	FLJf5MbLsQZg1VXMttqBGIeZVfvN4h6uFZtKjMvZjnWGFAt+cp+EPKXPXZyW22LJyWBWogrBlng
	yQaDA8UfO7TUCBdLC3W24MvSxz+TMUnSxoKOvFpVdBcgqY7XzjLdnLjE1kqU6yJdkYwL2m2TdGx
	NEBhrFkyIRSmaI+nDVxRsE1woS
X-Received: by 2002:a2e:b889:0:b0:2d2:6676:3b0f with SMTP id r9-20020a2eb889000000b002d266763b0fmr10984738ljp.22.1709126971557;
        Wed, 28 Feb 2024 05:29:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH17mlMZ28t5T5IRr+YR1u98XdOGcHpUxH/XtQl8vHXHH/lyEkZGla24b3RJVS283feQNM31uhk8u+TJ+8sakc=
X-Received: by 2002:a2e:b889:0:b0:2d2:6676:3b0f with SMTP id
 r9-20020a2eb889000000b002d266763b0fmr10984717ljp.22.1709126971174; Wed, 28
 Feb 2024 05:29:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <Zd6LK7RpZZ8t-5CY@google.com>
In-Reply-To: <Zd6LK7RpZZ8t-5CY@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Feb 2024 14:29:20 +0100
Message-ID: <CABgObfYpRJnDdQrxp=OgjhbT9A+LHK36MHjMvzcQJsHAmfX++w@mail.gmail.com>
Subject: Re: [PATCH 00/21] TDX/SNP part 1 of n, for 6.9
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 2:25=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> > This is a first set of, hopefully non-controversial patches from the
>
> Heh, you jinxed yourself.  :-)

Well I
> > SNP and TDX series.  They cover mostly changes to generic code and new
> > gmem APIs, and in general have already been reviewed when posted by
> > Isaku and Michael.
> >
> > One important change is that the gmem hook for initializing memory
> > is designed to return -EEXIST if the page already exists in the
> > guestmemfd filemap.  The idea is that the special case of
> > KVM_SEV_SNP_LAUNCH_UPDATE, where __kvm_gmem_get_pfn() is used to
> > return an uninitialized page and make it guest-owned, can be be done at
> > most once per page unless the ioctl fails.
> >
> > Of course these patches add a bunch of dead code.  This is intentional
> > because it's the only way to trim the large TDX (and to some extent SNP=
)
> > series to the point that it's possible to discuss them.  The next step =
is
> > probably going to be the private<->shared page logic from the TDX serie=
s.
> >
> > Paolo
> >
> > Isaku Yamahata (5):
> >   KVM: x86/mmu: Add Suppress VE bit to EPT
> >     shadow_mmio_mask/shadow_present_mask
> >   KVM: VMX: Introduce test mode related to EPT violation VE
> >   KVM: x86/tdp_mmu: Init role member of struct kvm_mmu_page at
> >     allocation
> >   KVM: x86/tdp_mmu: Sprinkle __must_check
> >   KVM: x86/mmu: Pass around full 64-bit error code for KVM page faults
>
> I have a slight tweak to this patch (drop truncation), and a rewritten ch=
angelog.
>
> > Michael Roth (2):
> >   KVM: x86: Add gmem hook for invalidating memory
> >   KVM: x86: Add gmem hook for determining max NPT mapping level
> >
> > Paolo Bonzini (6):
> >   KVM: x86/mmu: pass error code back to MMU when async pf is ready
> >   KVM: x86/mmu: Use PFERR_GUEST_ENC_MASK to indicate fault is private
>
> This doesn't work.  The ENC flag gets set on any SNP *capable* CPU, which=
 results
> in false positives for SEV and SEV-ES guests[*].

You didn't look at the patch did you? :) It does check for
has_private_mem (alternatively I could have dropped the bit in SVM
code for SEV and SEV-ES guests).

> I have a medium-sized series to add a KVM-defined synthetic flag, and cle=
an up
> the related code (it also has my slight variation on the 64-bit error cod=
e patch).
>
> I'll post my series exactly as I have it, mostly so that I don't need to =
redo
> testing, but also because it's pretty much a drop-in replacement.  This s=
eries
> applies cleanly on top, except for the two obvious conflicts.

Ok, I will check it out. This is exactly why I posted these.

Paolo

> [*] https://lore.kernel.org/all/Zdar_PrV4rzHpcGc@google.com
>
> >   KVM: guest_memfd: pass error up from filemap_grab_folio
> >   filemap: add FGP_CREAT_ONLY
> >   KVM: x86: Add gmem hook for initializing memory
> >   KVM: guest_memfd: add API to undo kvm_gmem_get_uninit_pfn
> >
> > Sean Christopherson (7):
> >   KVM: x86: Split core of hypercall emulation to helper function
> >   KVM: Allow page-sized MMU caches to be initialized with custom 64-bit
> >     values
> >   KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPT=
E
> >   KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
> >   KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed
> >     SPTE
> >   KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
> >   KVM: VMX: Modify NMI and INTR handlers to take intr_info as function
> >     argument
> >
> > Tom Lendacky (1):
> >   KVM: SEV: Use a VMSA physical address variable for populating VMCB
> >
> >  arch/x86/include/asm/kvm-x86-ops.h |   3 +
> >  arch/x86/include/asm/kvm_host.h    |  12 +
> >  arch/x86/include/asm/vmx.h         |  13 +
> >  arch/x86/kvm/Makefile              |   2 +-
> >  arch/x86/kvm/mmu.h                 |   1 +
> >  arch/x86/kvm/mmu/mmu.c             |  55 ++--
> >  arch/x86/kvm/mmu/mmu_internal.h    |   6 +-
> >  arch/x86/kvm/mmu/mmutrace.h        |   2 +-
> >  arch/x86/kvm/mmu/paging_tmpl.h     |   4 +-
> >  arch/x86/kvm/mmu/spte.c            |  16 +-
> >  arch/x86/kvm/mmu/spte.h            |  21 +-
> >  arch/x86/kvm/mmu/tdp_iter.h        |  12 +
> >  arch/x86/kvm/mmu/tdp_mmu.c         |  74 +++--
> >  arch/x86/kvm/svm/sev.c             |   3 +-
> >  arch/x86/kvm/svm/svm.c             |   9 +-
> >  arch/x86/kvm/svm/svm.h             |   1 +
> >  arch/x86/kvm/vmx/main.c            | 168 +++++++++++
> >  arch/x86/kvm/vmx/vmcs.h            |   5 +
> >  arch/x86/kvm/vmx/vmx.c             | 460 +++++++++++------------------
> >  arch/x86/kvm/vmx/vmx.h             |   6 +-
> >  arch/x86/kvm/vmx/x86_ops.h         | 124 ++++++++
> >  arch/x86/kvm/x86.c                 |  69 +++--
> >  include/linux/kvm_host.h           |  25 ++
> >  include/linux/kvm_types.h          |   1 +
> >  include/linux/pagemap.h            |   2 +
> >  mm/filemap.c                       |   4 +
> >  virt/kvm/Kconfig                   |   8 +
> >  virt/kvm/guest_memfd.c             | 120 +++++++-
> >  virt/kvm/kvm_main.c                |  16 +-
> >  29 files changed, 855 insertions(+), 387 deletions(-)
> >  create mode 100644 arch/x86/kvm/vmx/main.c
> >  create mode 100644 arch/x86/kvm/vmx/x86_ops.h
> >
> > --
> > 2.39.0
> >
>


