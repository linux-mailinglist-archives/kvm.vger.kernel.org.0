Return-Path: <kvm+bounces-55096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4814EB2D3E5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 08:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C367B1C40B61
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 06:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915332BE621;
	Wed, 20 Aug 2025 06:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ws6zIGfr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69CA23B61A;
	Wed, 20 Aug 2025 06:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755670269; cv=none; b=ciKyAgjRmSgtRhLWVmS41/zRAnH94gZI8WPF7I7/Cby7tq57aw5NmdyBm+U+UHGJO6x7d1Ocdk7YT+AqqxbvDkS3fCFp8uarX7ug1+FCHsj4dY8asLiLkp/5a985ak/2EAQWf9uAT6GZ99RtsjEi9P4ki4vd1AEqehaTJ8OmBiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755670269; c=relaxed/simple;
	bh=UuRLgKv9rGDuNUFOLobTIw2x1dsZd/po2KirUvWaq1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EGIkgxVT5Y8byz0RDujdDcecethCXi0W1ZfN2xEn9654IhUyDZ5qf/ZURsJzjjYXdGP930/CFHNU50vnOWUwJk2JLdUs997gHJpqIln8tiUb90daIXd79WNZGOAAugQc+TnPu61mC43a6TSvaiH3YY16eml5faQhM0izYZ4TYJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ws6zIGfr; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-333f8ef379dso50853351fa.1;
        Tue, 19 Aug 2025 23:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755670266; x=1756275066; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkTG3esE0fyfE8MJmsDXcTYybTUbr/EWyWd71r3Vms0=;
        b=Ws6zIGfrV15C8hCc9jY9t3pSTSmVobXxzKzmwXKbaHLYK5XbCzvaGs4x3awV1vHYvj
         oX3zngLvAthNpxcdJgBhXm07RBATHuppj3Nb4jyPUygEXAoFHzCf3VNhY/1Sk2PVfhuy
         lAy4ipj+phIuH8/HA6EC/7Qma6Ti7FxN0shoSUczFF2mBlcGfgYg2xp3M14QGi0vafKC
         NNJw4DPA9q5YWFh69n8YQkbBjhiLChz/jN7RnB22Gl7okLVcUzwGcIVS0doiykX2IbWM
         kJyNjUaM57fzRIjHeJZwgd/fi0o07q+JhzaoC7T5Con0HjFliRt16DIRzS1MBi7h62w8
         RZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755670266; x=1756275066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rkTG3esE0fyfE8MJmsDXcTYybTUbr/EWyWd71r3Vms0=;
        b=bR+NvRKyaMfI0nTVgtu/YMsP1gHagOWvZ0NTNKGUxCObunID1RjnNptiJppbBZYhI3
         R4xPmHNpUYVl9NFsMfvDnbGdNizlKcuNWJ9aSM1ekih7MdDQEtmd3k2CV0ieeQ3jZOH4
         JqH/q5ImylTL8Gw6kwtPq51aaX8V01aQnhuVOMuFr6yBwRsBwayJHSBKlki4+0EPGNFp
         h1afoWym90ktSzY0V0FQjyX0HEM8EWbFt+8aNQnNBtXjpM/HmhN3n4+jFu719q+31+sj
         PNq7hdnPCOXfEhKRDy+0ULi8n//RRnnvLGG2JXphIkXAoCWSRx1cRF9Wvmqx02oob2RS
         mQFA==
X-Forwarded-Encrypted: i=1; AJvYcCXoNMcftvQFQ8np2hqBWNZleseKr5KJy+vRey4N38iFqG9bFU7mVg3u/PlyPRFt4OGWpKwlgs4s3DpgMlw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh3lcrllMsUkhjaE9YGljDgy+DaKgrFmmhSyxENno4cTi74hVz
	HENHFKsNqDCvhEe/I8o6yXT0/ppD844Ahu3oyCtzrZw5UU6HlW/o+A/rdz/3kl8TT8DM9jdGCHn
	nvkEgwwES/JHnBYl8rmBhjYeBYs4EXYU=
X-Gm-Gg: ASbGncs6xcSYDnQnJNfqU+e5juOusUfI38V0I2d86znJKyxyH2LFtE5W2n79F6kepdt
	efSAKIwkhXbimxfday9r+BJ0UdNjB09+9dLKhHxpD/zrVgiHF9mRr/PunsuSRg9/cmV31o7ed4N
	3r3AKjkmKjsoFXKWbHhxg0aFupSNEPlxg9ufu/9N9ZXzQfJ1tmSJIG5aLhIq0NREyniWKJCUABG
	E5YAG3QXZw7fdiGTg==
X-Google-Smtp-Source: AGHT+IGZEpooXnuH5PP9VjT2oIs90hZOhiMQBHrEMJftVXkwM2PiQihaGa0o13m5Kl519+cPr6AyoZwjV/iItfdfZAQ=
X-Received: by 2002:a2e:a582:0:b0:332:43e5:e3df with SMTP id
 38308e7fff4ca-3353bd14389mr5451661fa.27.1755670265523; Tue, 19 Aug 2025
 23:11:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807063733.6943-1-ubizjak@gmail.com> <aKSRbjgtp7Nk8-sb@google.com>
 <CAFULd4ZOtj7WZkSSKqLjxCJ-yBr20AYrqzCpxj2K_=XmrX1QZg@mail.gmail.com> <aKTI1WOJAKDnkRyu@google.com>
In-Reply-To: <aKTI1WOJAKDnkRyu@google.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Wed, 20 Aug 2025 08:10:54 +0200
X-Gm-Features: Ac12FXypOvQ0e_jSRmN8GalULPuobSskhTxPMiAZxY4WSPAja6rTBl0SPQ9pp5I
Message-ID: <CAFULd4ZR6TPVqq5TXToR-0HbX5oM=NEdw126kcDe5LNDdxZ++w@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize SPEC_CTRL handling in __vmx_vcpu_run()
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 8:56=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Aug 19, 2025, Uros Bizjak wrote:
> > > >   2d: 48 8b 7c 24 10          mov    0x10(%rsp),%rdi
> > > >   32: 8b 87 48 18 00 00       mov    0x1848(%rdi),%eax
> > > >   38: 65 3b 05 00 00 00 00    cmp    %gs:0x0(%rip),%eax
> > > >   3f: 74 09                   je     4a <...>
> > > >   41: b9 48 00 00 00          mov    $0x48,%ecx
> > > >   46: 31 d2                   xor    %edx,%edx
> > > >   48: 0f 30                   wrmsr
> > > >
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > > > Cc: Sean Christopherson <seanjc@google.com>
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: Ingo Molnar <mingo@kernel.org>
> > > > Cc: Borislav Petkov <bp@alien8.de>
> > > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/vmenter.S | 6 ++----
> > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.=
S
> > > > index 0a6cf5bff2aa..c65de5de92ab 100644
> > > > --- a/arch/x86/kvm/vmx/vmenter.S
> > > > +++ b/arch/x86/kvm/vmx/vmenter.S
> > > > @@ -118,13 +118,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
> > > >        * and vmentry.
> > > >        */
> > > >       mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
> > > > -     movl VMX_spec_ctrl(%_ASM_DI), %edi
> > > > -     movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
> > > > -     cmp %edi, %esi
> > > > +     movl VMX_spec_ctrl(%_ASM_DI), %eax
> > > > +     cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
> > >
> > > Huh.  There's a pre-existing bug lurking here, and in the SVM code.  =
SPEC_CTRL
> > > is an MSR, i.e. a 64-bit value, but the assembly code assumes bits 63=
:32 are always
> > > zero.
> >
> > But MSBs are zero, MSR is defined in arch/x86/include/msr-index.h as:
> >
> > #define MSR_IA32_SPEC_CTRL 0x00000048 /* Speculation Control */
> >
> > and "movl $..., %eax" zero-extends the value to full 64-bit width.
> >
> > FWIW, MSR_IA32_SPEC_CTR is handled in the same way in arch/x86/entry/en=
try.S:
> >
> > movl $MSR_IA32_PRED_CMD, %ecx
>
> That's the MSR index, not the value.  I'm pointing out that:
>
>         movl VMX_spec_ctrl(%_ASM_DI), %edi              <=3D=3D drops vmx=
->spec_ctrl[63:32]
>         movl PER_CPU_VAR(x86_spec_ctrl_current), %esi   <=3D=3D drop x86_=
spec_ctrl_current[63:32]
>         cmp %edi, %esi                                  <=3D=3D can get f=
alse negatives
>         je .Lspec_ctrl_done
>         mov $MSR_IA32_SPEC_CTRL, %ecx
>         xor %edx, %edx                                  <=3D=3D can clobb=
er guest value
>         mov %edi, %eax
>         wrmsr
>
> The bug is _currently_ benign because neither KVM nor the kernel support =
setting
> any of bits 63:32, but it's still a bug that needs to be fixed.

Oh, I see it. Let me try to fix it in a new patch.

Thanks,
Uros.

