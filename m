Return-Path: <kvm+bounces-7605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6EE844B28
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C1EDB23788
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928193A8C2;
	Wed, 31 Jan 2024 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gPSghukF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA353A1CB
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706740720; cv=none; b=bSCuMKh/wy8sZoBUtnvsLdzzmHTjmhiQ2vMl/Dksg7t14yqPmdk3ZxOM4M26vU8SyJoNxZDmPM+PIfooUav5d9nKiIg9Eshe+ScdYk7H5+nSNCSgQa9k2QUd/YpEa+o4tvXMedMdrp+4xqnnvZAA/8D9o3/VUaEIb+IIGPDznrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706740720; c=relaxed/simple;
	bh=yoNh0T6PTwSXjbboNf8HUKKSK9ptTYeZLMonhIMFcjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KaNYLCGPr44huThhsq0uz/Aen9kwbOyxc3Hqm2osM+3Ft8pT7HO2i1vw1CC0cI6ygkdXjNgo+GmEGHRdn1LzOtV6e/L9t/JJS0N83QEdf4dKCrNRN9c/cXS0Es11sMjOfDrdErA3mNuVBTiK5kitFLtWjC5asRXdTBl5pdvtKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gPSghukF; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3be90c51299so201574b6e.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 14:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706740718; x=1707345518; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sihp+DDuzPlSLNRO3613GGhwVYkcOubyS/IEd97PSkE=;
        b=gPSghukFgbZ3cLeQACcDu7kkTIrca6QjwiHY4K0LVZApYXfep2mJiUoYajnTIEXXUv
         42hQDzNq6Yaf4IDpS+64fvs0xaWP1uC3UDShK26W7mtX7SoTzQZswz9iIvTNuBX1iFDz
         /kEn8upp2pQTUo617T7NVEySjLGvpNVSk82yEPkEubJiDqJ1H3hUIiW/TZYATlzuIX7K
         EqionGjirHB3nrjUQJibhWLvGxI4A34gMiSbdAX+GdxJTGsykwlompHIgphV6frc1TPT
         10x4aFbZzbZjMqM5L9bZ6CUQyaReC9OUnuUaAEuQeEm47BSXX+Bg7n6yOkh1iFAIxQk/
         9uuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706740718; x=1707345518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sihp+DDuzPlSLNRO3613GGhwVYkcOubyS/IEd97PSkE=;
        b=q0Vg7laX+KY4G0YN0SZZuXdjTa7S2aCBX2rD2LK1VpW+AyqdVn2eNQ8rvM53zqLMWR
         3Q1OEpMi7xXm62OMRqn4kmZUXd8ScGflbtP8AiBJx+FpfAJRCKrvcd797TVYkuHVdEeC
         BB+wz5S3akP5UFcs3GAYAj0f2kp/TPhtYEZjNhAplCLpvEzPK2DYLwOJa/pdyeg5UasV
         r6pNFq+MMWlDN+KTI1C4Ju02n7NrED0jowxmK1j7nJIiteGnWZPFH4cADknhyyRORN/B
         oeaqge026Wn6mc0LTMuFR0LV35MUy2IEx49cXL+Od5Ex+6iUutP87xNZY6O4RiqybVF3
         bDBQ==
X-Gm-Message-State: AOJu0YyigUIEkTuMdywSx9oD3d67V2woS/1whS/zrFdFcSaBITWyG+q+
	pmbyMAnR9amEbgkH/5dk+eMLr1KQTsEzTXybqYmPlI9B4j5F9onfldmaM9/j61KEcR1tVyXzoLy
	930/9U+iyJtpUkss8G0Tq4HXQZYh3fe0kR9yh
X-Google-Smtp-Source: AGHT+IG8GrrgZLcy7HqR+2o1QAFDucoWMa3/eNN8i/KauxGYEngI/wPyqxBwo50CC35GztzssCnleBwgGP7jPiLTB3I=
X-Received: by 2002:a05:6870:3a09:b0:218:e36a:bc4f with SMTP id
 du9-20020a0568703a0900b00218e36abc4fmr362783oab.11.1706740718064; Wed, 31 Jan
 2024 14:38:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-10-amoorthy@google.com>
 <CADrL8HXLF+EQZt+oXJAiatoJNzz2E-fiwUSJj=YpHzGQxL00mQ@mail.gmail.com>
In-Reply-To: <CADrL8HXLF+EQZt+oXJAiatoJNzz2E-fiwUSJj=YpHzGQxL00mQ@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 31 Jan 2024 14:38:01 -0800
Message-ID: <CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=Yo8u9TZEuDTEtCV6qw@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate an EFAULT from stage-2 fault-handler
To: James Houghton <jthoughton@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 3:58=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Hi Anish,
>
> Sorry to get back to you so late. :) I was hoping others would provide
> more feedback, but I have a little bit to give anyway. Overall the
> series looks good to me.

Thanks James. I'm just happy to have some review :D

> On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com=
> wrote:
> >
> > Prevent the stage-2 fault handler from faulting in pages when
> > KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
> > calls to check the memslot flag.
> >
> > To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
> > when the stage-2 handler cannot resolve the pfn for a fault. With
> > KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of stage-2
> > faults as vCPU exits, which userspace can attempt to resolve without
> > terminating the guest.
> >
> > Delivering stage-2 faults to userspace in this way sidesteps the
> > significant scalabiliy issues associated with using userfaultfd for the
> > same purpose.
> >
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 2 +-
> >  arch/arm64/kvm/Kconfig         | 1 +
> >  arch/arm64/kvm/mmu.c           | 7 +++++--
> >  3 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index fd87bbfbfdf2..67fcb9dbe855 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -8068,7 +8068,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
> >  7.35 KVM_CAP_EXIT_ON_MISSING
> >  ----------------------------
> >
> > -:Architectures: x86
> > +:Architectures: x86, arm64
> >  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
> >
> >  The presence of this capability indicates that userspace may set the
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 1a777715199f..d6fae31f7e1a 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -43,6 +43,7 @@ menuconfig KVM
> >         select GUEST_PERF_EVENTS if PERF_EVENTS
> >         select INTERVAL_TREE
> >         select XARRAY_MULTI
> > +        select HAVE_KVM_EXIT_ON_MISSING
> >         help
> >           Support hosting virtualized guest machines.
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 13066a6fdfff..3b9fb80672ac 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1486,13 +1486,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu=
, phys_addr_t fault_ipa,
> >         mmap_read_unlock(current->mm);
> >
> >         pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
> > -                                  write_fault, &writable, false, NULL)=
;
> > +                                  write_fault, &writable, true, NULL);
> >         if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> >                 kvm_send_hwpoison_signal(hva, vma_shift);
> >                 return 0;
> >         }
> > -       if (is_error_noslot_pfn(pfn))
> > +       if (is_error_noslot_pfn(pfn)) {
> > +               kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PA=
GE_SIZE,
> > +                                             write_fault, exec_fault, =
false);
>
> I think that either (1) we move this kvm_prepare_memory_fault_exit
> logic into the previous patch[1], or (2) we merge this patch with the
> previous one. IIUC, we can only advertise KVM_CAP_MEMORY_FAULT_INFO on
> arm64 if this logic is present.

Actually (sorry, about-face from our off-list chat), *does* it make
sense to merge these two patches? arm64 could benefit from annotated
EFAULTs even without KVM_CAP_EXIT_ON_MISSING: for instance if there
were spots outside the stage-2 handler if EFAULTs were annotated [a].
And if this patch was for some reason reverted in the future, then we
probably wouldn't want that to entail silencing any other
KVM_EXIT_MEMORY_FAULTs that arm64 might also get.

Sean did also ask me to merge some patches back on v5 [b], but I think
the point there was to enable KVM_CAP_EXIT_ON_MISSING at the same time
as adding the stage-2 annotation, which I'm doing here.

[a] Theoretically, anyways. Atm only x86 code uses
kvm_prepare_memory_fault_exit()
[b] https://lore.kernel.org/kvm/ZR4WzE1JOvq_0dhE@google.com/

> As for the changelog in the previous patch[1], if you leave it
> unmerged with this one, something like "Enable
> KVM_CAP_MEMORY_FAULT_INFO to make KVM_CAP_EXIT_ON_MISSING useful, as
> without it, userspace doesn't know which page(s) of memory it needs to
> fix" works for me.

For that previous patch, I updated the description to the following

> Advertise to arm64 userspaces that KVM_RUN may return annotated EFAULTs
> (see KVM_EXIT_MEMORY_FAULT). In fact KVM_RUN might already be annotating
> some EFAULTs, but this capability is necessary for userspace to know
> that.

Which I think makes more sense than sort of forward-declaring
KVM_CAP_EXIT_ON_MISSING on arm64.

On Tue, Jan 30, 2024 at 3:58=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Also, I think we need to update the documentation for
> KVM_CAP_MEMORY_FAULT_INFO to say that it is available for arm64 now
> (just like you have done for KVM_CAP_EXIT_ON_MISSING).

Done, ty

