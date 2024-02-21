Return-Path: <kvm+bounces-9252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F2C85CF26
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAFD01C22A35
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0509C2837E;
	Wed, 21 Feb 2024 03:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="aMNpgLU2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFE138DD2
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 03:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708487367; cv=none; b=AdsPXK9Vpx6MyiTjVmDa0uf3l2U9BdYe1NrgCVsWI6NITFzJS9aUtYqdiVKhYYJWrrGRer+OCDQBgj+a5DeH2ynqf0iauK63PMGwKXTP0aPqV9zDs1qGbsQKQray8xgrJbINXrMCNWADjgZl5FFIAZrh4pXSC7i4UNdYJ40PP1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708487367; c=relaxed/simple;
	bh=y8O/mwaQ7Px8v+Frk1wcJy2nHkn8+at7VPWO9+3VbBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cP/vNq+Xg/JnlwgEktfu45t+751JrYQcul0y+XZPYDcAD9BDSDjs3zVdJsT4BTEr43aYKKef/LNsna8mxUqTQfUM53anAvZ8nd0yqTq39zHBLK++KWCVRzIwQ53Z/3npx/HYFuRy+RoOn3j4rXfPfUo0PMUINoMepO5kK47cFnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=aMNpgLU2; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d0cdbd67f0so86820931fa.3
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 19:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1708487363; x=1709092163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ejkDxgSv9Wy1s6DoDk6Rey43bdmMYQ0qUMcSL0mEarU=;
        b=aMNpgLU2M3Fh1ICsznUfHlyJXBg0Lzyv5QTJW14maOn0QFBCs5k9NiFqsdt0SFgvRj
         JO6R58om5RL+Awdhkhasg7RQknzPCMcR5UBDSnGGyf0y7nkxF2f8bShN4l3obIxVSoyb
         +6tjINpoPAaLkEm3pf2vgvCFRu0F0pWg/KGgtW2U8hOTyw7QoEdp6UzU6rH9BdDQ/HYQ
         J5eXas5M9zKWlW5O0NX0qd0ytuhZjfVoQdclokPNPm+qReJhtDMxocblMg6gnEoIKukE
         8WBv8NuMKQrAaHKzenDeK6aqwsCBedwwSL26r+kAQW90uo5BfsOZWBnJ35JWKhP+UmE1
         ehEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708487363; x=1709092163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejkDxgSv9Wy1s6DoDk6Rey43bdmMYQ0qUMcSL0mEarU=;
        b=Glv9Retf5GdQr+8x0bEdi+cnjPxF46Dz81zjROmUHoDbhYpgJgPIRYKE9gJKirCX+/
         zkoCJ8RmQZLJw7ptBhF0iILD71oblaQuIXEnrPtVTjIQn/kJXeDFJDqGf8tz3Xla264K
         pWJRUWB3myImuuKY/jl+Nde6fhNdySCc1QjUf9hunfx9rpEsPh+ANl2VluSaJ0FW34qQ
         BKP4v+eq/06KWOdKsSCa7hU4dlu3sqPCkqQG1tdRv0ZVVoLhECuNwz1WW6VS46TlhiDt
         2jydkTsOpOfP8L6z/eCzPslV6MpjbKpaF2zpcoabXFiv/HMsBqTRMU7uH4VuWGNMfLiq
         DYRg==
X-Gm-Message-State: AOJu0YzHUgF8q4sQmIDmCgtSPX4tPsRziUrdCkEeLvVCCBAkB2V7vb1f
	IYG1oCf66XJsKWJ+TSxTq9ZbeGFfbdPxpcc3xMGluI5HDD+hJWfkiwRoKPMs/7x08g0+XKFlXZ9
	W3cAolMdHR5Fm6neafaOoAIq/xhs4gV/JecXkju7gVXAUt6XP1oI=
X-Google-Smtp-Source: AGHT+IF00qdDY2SVx03Wa6LPc9UWgk5meVyN8jFzSLxISc318SPD+ipCGJJdFn/tTL6oBpo41VL38QU7btVEWW/ntC0=
X-Received: by 2002:a2e:2a02:0:b0:2d2:4f67:ad7b with SMTP id
 q2-20020a2e2a02000000b002d24f67ad7bmr1663585ljq.27.1708487363091; Tue, 20 Feb
 2024 19:49:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240206074931.22930-1-duchao@eswincomputing.com>
 <20240206074931.22930-2-duchao@eswincomputing.com> <CAK9=C2VZ1t3ctTWKiqeKOALjLh0kJgzVEsZvM=xfc2j7yQOEcQ@mail.gmail.com>
 <4a5a30cd.18c.18dc4734699.Coremail.duchao@eswincomputing.com>
 <CAK9=C2XAEDfac+GQTD3jE2RLR+5ngNPedEE_G6tL4e2KByUZ1w@mail.gmail.com> <61f5b01b.323.18dc95f8d58.Coremail.duchao@eswincomputing.com>
In-Reply-To: <61f5b01b.323.18dc95f8d58.Coremail.duchao@eswincomputing.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Wed, 21 Feb 2024 09:19:10 +0530
Message-ID: <CAK9=C2Waz7iLx+8p9=QTQS5i4aomodn2G6Z2L8wn8UXOBm=qzQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 7:28=E2=80=AFAM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> On 2024-02-20 12:54, Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > On Tue, Feb 20, 2024 at 8:31=E2=80=AFAM Chao Du <duchao@eswincomputing.=
com> wrote:
> > >
> > > On 2024-02-14 21:19, Anup Patel <apatel@ventanamicro.com> wrote:
> > > >
> > > > On Tue, Feb 6, 2024 at 1:22=E2=80=AFPM Chao Du <duchao@eswincomputi=
ng.com> wrote:
> > > > >
> > > > > kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEB=
UG is
> > > > > being checked.
> > > > >
> > > > > kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug fla=
gs
> > > > > from userspace accordingly. Route the breakpoint exceptions to HS=
 mode
> > > > > if the VM is being debugged by userspace, by clearing the corresp=
onding
> > > > > bit in hedeleg CSR.
> > > > >
> > > > > Signed-off-by: Chao Du <duchao@eswincomputing.com>
> > > > > ---
> > > > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > > > >  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
> > > > >  arch/riscv/kvm/vm.c               |  1 +
> > > > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/inclu=
de/uapi/asm/kvm.h
> > > > > index d6b7a5b95874..8890977836f0 100644
> > > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > > @@ -17,6 +17,7 @@
> > > > >
> > > > >  #define __KVM_HAVE_IRQ_LINE
> > > > >  #define __KVM_HAVE_READONLY_MEM
> > > > > +#define __KVM_HAVE_GUEST_DEBUG
> > > > >
> > > > >  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> > > > >
> > > > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > > > index b5ca9f2e98ac..6cee974592ac 100644
> > > > > --- a/arch/riscv/kvm/vcpu.c
> > > > > +++ b/arch/riscv/kvm/vcpu.c
> > > > > @@ -475,8 +475,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct k=
vm_vcpu *vcpu,
> > > > >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> > > > >                                         struct kvm_guest_debug *d=
bg)
> > > > >  {
> > > > > -       /* TODO; To be implemented later. */
> > > > > -       return -EINVAL;
> > > > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > > > +               if (vcpu->guest_debug !=3D dbg->control) {
> > > > > +                       vcpu->guest_debug =3D dbg->control;
> > > > > +                       csr_clear(CSR_HEDELEG, BIT(EXC_BREAKPOINT=
));
> > > > > +               }
> > > > > +       } else {
> > > > > +               if (vcpu->guest_debug !=3D 0) {
> > > > > +                       vcpu->guest_debug =3D 0;
> > > > > +                       csr_set(CSR_HEDELEG, BIT(EXC_BREAKPOINT))=
;
> > > > > +               }
> > > > > +       }
> > > >
> > > > This is broken because directly setting breakpoint exception delega=
tion
> > > > in CSR also affects other VCPUs running on the same host CPU.
> > > >
> > > > To address the above, we should do the following:
> > > > 1) Add "unsigned long hedeleg" in "struct kvm_vcpu_config" which
> > > >    is pre-initialized in kvm_riscv_vcpu_setup_config() without sett=
ing
> > > >    EXC_BREAKPOINT bit.
> > > > 2) The kvm_arch_vcpu_ioctl_set_guest_debug() should only set/clear
> > > >     EXC_BREAKPOINT bit in "hedeleg" of "struct kvm_vcpu_config".
> > > > 3) The kvm_riscv_vcpu_swap_in_guest_state() must write the
> > > >      HEDELEG csr before entering the Guest/VM.
> > > >
> > > > Regards,
> > > > Anup
> > > >
> > >
> > > Thanks for the review and detailed suggestion.
> > > Maybe we could make it a bit easier:
> > > 1) The kvm_arch_vcpu_ioctl_set_guest_debug() only update vcpu->guest_=
debug
> > >    accordingly.
> > > 2) The kvm_riscv_vcpu_swap_in_guest_state() check vcpu->guest_debug a=
nd
> > >    set/clear the HEDELEG csr accordingly.
> > >
> > > Could you confirm if this is OK?
> >
> > Your suggestion will work but it adds an additional "if ()" check in
> > kvm_riscv_vcpu_swap_in_guest_state() which is in the hot path.
> >
>
> Yes, it makes sense.
> I will prepare a V2 patch.

I just realized that kvm_arch_vcpu_load() will be a much
better place to add hedeleg CSR write instead of
kvm_riscv_vcpu_swap_in_guest_state(). This way
it will be only at the start hot-path (aka run-loop).

Regards,
Anup

>
> Thanks,
> Chao
>
> > I am still leaning towards what I suggested.
> >
> > Regards,
> > Anup
> >
> > > If yes, I will post another revision.
> > >
> > > Regards,
> > > Chao
> > >
> > > > > +
> > > > > +       return 0;
> > > > >  }
> > > > >
> > > > >  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> > > > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > > > index ce58bc48e5b8..7396b8654f45 100644
> > > > > --- a/arch/riscv/kvm/vm.c
> > > > > +++ b/arch/riscv/kvm/vm.c
> > > > > @@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *=
kvm, long ext)
> > > > >         case KVM_CAP_READONLY_MEM:
> > > > >         case KVM_CAP_MP_STATE:
> > > > >         case KVM_CAP_IMMEDIATE_EXIT:
> > > > > +       case KVM_CAP_SET_GUEST_DEBUG:
> > > > >                 r =3D 1;
> > > > >                 break;
> > > > >         case KVM_CAP_NR_VCPUS:
> > > > > --
> > > > > 2.17.1
> > > > >
> > > > >
> > > > > --
> > > > > kvm-riscv mailing list
> > > > > kvm-riscv@lists.infradead.org
> > > > > http://lists.infradead.org/mailman/listinfo/kvm-riscv
> > > --
> > > kvm-riscv mailing list
> > > kvm-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/kvm-riscv

