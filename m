Return-Path: <kvm+bounces-47717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08362AC3F6C
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 14:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53ABE16C38D
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 12:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22895202F71;
	Mon, 26 May 2025 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="YlQBa+iG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B1C1DFE12
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748263355; cv=none; b=gKFD7zOJdsbzBeQbtnz+tJIQS3TsZ/vhxUvvyMKmkNo1bwJd5hfX5deo5NkIq/rir157hB5/2HJfoPmoWACPXfxeLRsCXla+qARSHDXMSskUp2u386fYH266yJtA7vTq15fDInQRJejm23dQf7WQWILlMQ0Sd9uHRDgmx1ZY83U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748263355; c=relaxed/simple;
	bh=wabvdY6iXWN7fKPKUIXkwmqKXj3xjuQyMQ7cQ1+Pf+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFvyjoQply8S/SZVHtU001nWkkbsZto11UW+seh5wJA7sK7GvJoLFU0F+vfWUxTUnQsdEPMRXmqiqAJ2sWWOEFQe5BrvSfl4V73JbwyE73YnQdVJxL/iqMFWqeX/lpWMElmBGKkuTBRxiYPs12PHMjeyEL6Kl+2SZSJ11BCNTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=YlQBa+iG; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3dc83a8a4afso9188125ab.1
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 05:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1748263351; x=1748868151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWUnArj1hPFx4s/1Awe4zRs6iqJh4kdVZSKnLxEE17g=;
        b=YlQBa+iGXjugezBU9JqSYOaLQVdXnFoprktZb5CohBs4+KAIbrBMqMcYHyGUDaUjAZ
         qQwxb9E85oV5TkV/fY8X6IneyrsvJqEUgTzxhOcm2iQcWZOqGpKdZ0N37NLcsmjIsUKP
         vSbBhnP6AP+NeRe8aOCBVpCxMdvb08UzyPeGkl/y2liVGBVjdb77cSCGZvvD7kmFh/Lm
         EYPTfgkG00bECoWIVYqcMWt8F84Eglgv2ytVsjjWGPyBZwklLqRx8EJeQgi+GydqIdcE
         xhGdAXXEfV0YabqBE7ThvyAXUoYysze0h04UGWtUBLYY4iC/UAzWuY1GwMCx4vp3EMdF
         OJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748263351; x=1748868151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWUnArj1hPFx4s/1Awe4zRs6iqJh4kdVZSKnLxEE17g=;
        b=ahGqKVAk1y7oEzC6/kOufiwVEUx/OJlPAcQlG3ukB1g42ug1pG+OhyJww3rlhs9m8R
         0HnjbKJ58dCWJsgB0U+bE2nOxxA/XidBXt0WvO1fTc/XwJ2WVxzUTtk8Zdo3CkrtSk+/
         voRysi/RaA39SwHfosv6WA+0U7SLaE0WOjn91BsD6u5jYRJl8PrvGuq0yyxLbZhSO26L
         9XJo9Ye+dC8bPIFNsQVq4CE33pYrc51AOkBuRAATSf7sPfS7ZhKARtk1hcE2rUryRsP9
         yE29GA0v3mgoFWqrB1rNMCWq6aNiG0JCeKfQ8/mDvRtYSSZX0lF3FeLjN5Dsz01MRxBc
         NV3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUd7ZIie367ktlH2gG/ylBurjVWF5yOt2TnZJQRkUxCgiB13bNj7kzTAbByLEWRIq4X7YY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIZzHKW66xg3u5iE6o/MZm7ICwxEGkyInLFIeWNfU1f8H+S9nv
	WM3aAsnw9yiIptmDz2N9x2u7siLhVDDzDA6nkrYOv6d628M3n9614twPa/inJ0tYb8vTasJp5PJ
	10d19S8A9tm0AZzyEbqHEQMGDr9xvQbn1qey4fzr+Q5JOtrP/s4MYJ80=
X-Gm-Gg: ASbGncuTt13l2036mLnF1s9z452afyuVhsr3zW11XhLGmidlZmhZxpc6ophQCyzeBqS
	WOXoiyxDxaVFoQnw39SzCFcKR+xb5Z3/o3oAYWDy4FlrjP2+EfHuMRJfJ7nfxTwmjhwjRrJip4c
	exODE4eBKk1bylvqxWJQdCe10t8BZ0LtVtrA==
X-Google-Smtp-Source: AGHT+IGu7If+xrmf0hNrIvv6brDz9Z3waO+dySUDZU2XW8kb1xb85BRptKjinU+AOJhFvfh64k5LuqPmJwWHYVgeMx8=
X-Received: by 2002:a05:6e02:3993:b0:3dc:8e8b:42af with SMTP id
 e9e14a558f8ab-3dc9ae6add9mr79151775ab.7.1748263350871; Mon, 26 May 2025
 05:42:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523113347.2898042-3-rkrcmar@ventanamicro.com> <20250526-e67c64d52c84a8ad7cb519c4@orel>
In-Reply-To: <20250526-e67c64d52c84a8ad7cb519c4@orel>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 26 May 2025 18:12:19 +0530
X-Gm-Features: AX0GCFuKk6Htt7XYnEu1WPLNKulrHECVaYCqOdb4gk38bWr8dEzfg-J6AXRf2_E
Message-ID: <CAAhSdy1wtuLm2O7EwfVzCT7wgKf7-n9q9_DxfpA6kQA1oSoZoQ@mail.gmail.com>
Subject: Re: [PATCH v4] RISC-V: KVM: add KVM_CAP_RISCV_USERSPACE_SBI
To: Andrew Jones <ajones@ventanamicro.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 2:52=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Fri, May 23, 2025 at 01:33:49PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 wro=
te:
> > The new capability allows userspace to implement SBI extensions that KV=
M
> > does not handle.  This allows userspace to implement any SBI ecall as
> > userspace already has the ability to disable acceleration of selected
> > SBI extensions.
> > The base extension is made controllable as well, but only with the new
> > capability, because it was previously handled specially for some reason=
.
> > *** The related compatibility TODO in the code needs addressing. ***
> >
> > This is a VM capability, because userspace will most likely want to hav=
e
> > the same behavior for all VCPUs.  We can easily make it both a VCPU and
> > a VM capability if there is demand in the future.
> >
> > Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> > ---
> > v4:
> > * forward base extension as well
> > * change the id to 242, because 241 is already taken in linux-next
> > * QEMU example: https://github.com/radimkrcmar/qemu/tree/mp_state_reset
> > v3: new
> > ---
> >  Documentation/virt/kvm/api.rst    | 11 +++++++++++
> >  arch/riscv/include/asm/kvm_host.h |  3 +++
> >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> >  arch/riscv/kvm/vcpu_sbi.c         | 17 ++++++++++++++---
> >  arch/riscv/kvm/vm.c               |  5 +++++
> >  include/uapi/linux/kvm.h          |  1 +
> >  6 files changed, 35 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index e107694fb41f..c9d627d13a5e 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -8507,6 +8507,17 @@ given VM.
> >  When this capability is enabled, KVM resets the VCPU when setting
> >  MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preser=
ved.
> >
> > +7.44 KVM_CAP_RISCV_USERSPACE_SBI
> > +--------------------------------
> > +
> > +:Architectures: riscv
> > +:Type: VM
> > +:Parameters: None
> > +:Returns: 0 on success, -EINVAL if arg[0] is not zero
> > +
> > +When this capability is enabled, KVM forwards ecalls from disabled or =
unknown
> > +SBI extensions to userspace.
> > +
> >  8. Other capabilities.
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > index 85cfebc32e4c..6f17cd923889 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -122,6 +122,9 @@ struct kvm_arch {
> >
> >       /* KVM_CAP_RISCV_MP_STATE_RESET */
> >       bool mp_state_reset;
> > +
> > +     /* KVM_CAP_RISCV_USERSPACE_SBI */
> > +     bool userspace_sbi;
> >  };
> >
> >  struct kvm_cpu_trap {
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 5f59fd226cc5..dd3a5dc53d34 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -204,6 +204,7 @@ enum KVM_RISCV_SBI_EXT_ID {
> >       KVM_RISCV_SBI_EXT_DBCN,
> >       KVM_RISCV_SBI_EXT_STA,
> >       KVM_RISCV_SBI_EXT_SUSP,
> > +     KVM_RISCV_SBI_EXT_BASE,
> >       KVM_RISCV_SBI_EXT_MAX,
> >  };
> >
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index 31fd3cc98d66..497d5b023153 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -39,7 +39,7 @@ static const struct kvm_riscv_sbi_extension_entry sbi=
_ext[] =3D {
> >               .ext_ptr =3D &vcpu_sbi_ext_v01,
> >       },
> >       {
> > -             .ext_idx =3D KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled =
*/
> > +             .ext_idx =3D KVM_RISCV_SBI_EXT_BASE,
> >               .ext_ptr =3D &vcpu_sbi_ext_base,
> >       },
> >       {
> > @@ -217,6 +217,11 @@ static int riscv_vcpu_set_sbi_ext_single(struct kv=
m_vcpu *vcpu,
> >       if (!sext || scontext->ext_status[sext->ext_idx] =3D=3D KVM_RISCV=
_SBI_EXT_STATUS_UNAVAILABLE)
> >               return -ENOENT;
> >
> > +     // TODO: probably remove, the extension originally couldn't be
> > +     // disabled, but it doesn't seem necessary
> > +     if (!vcpu->kvm->arch.userspace_sbi && sext->ext_id =3D=3D KVM_RIS=
CV_SBI_EXT_BASE)
> > +             return -ENOENT;
> > +
>
> I agree that we don't need to babysit userspace and it's even conceivable
> to have guests that don't need SBI. KVM should only need checks in its
> UAPI to protect itself from userspace and to enforce proper use of the
> API. It's not KVM's place to ensure userspace doesn't violate the SBI spe=
c
> or create broken guests (userspace is the boss, even if it's a boss that
> doesn't make sense)
>
> So, I vote we drop the check.
>
> >       scontext->ext_status[sext->ext_idx] =3D (reg_val) ?
> >                       KVM_RISCV_SBI_EXT_STATUS_ENABLED :
> >                       KVM_RISCV_SBI_EXT_STATUS_DISABLED;
> > @@ -471,8 +476,14 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
> >  #endif
> >               ret =3D sbi_ext->handler(vcpu, run, &sbi_ret);
> >       } else {
> > -             /* Return error for unsupported SBI calls */
> > -             cp->a0 =3D SBI_ERR_NOT_SUPPORTED;
> > +             if (vcpu->kvm->arch.userspace_sbi) {
> > +                     next_sepc =3D false;
> > +                     ret =3D 0;
> > +                     kvm_riscv_vcpu_sbi_forward(vcpu, run);
> > +             } else {
> > +                     /* Return error for unsupported SBI calls */
> > +                     cp->a0 =3D SBI_ERR_NOT_SUPPORTED;
> > +             }
> >               goto ecall_done;
> >       }
> >
> > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > index b27ec8f96697..0b6378b83955 100644
> > --- a/arch/riscv/kvm/vm.c
> > +++ b/arch/riscv/kvm/vm.c
> > @@ -217,6 +217,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struc=
t kvm_enable_cap *cap)
> >                       return -EINVAL;
> >               kvm->arch.mp_state_reset =3D true;
> >               return 0;
> > +     case KVM_CAP_RISCV_USERSPACE_SBI:
> > +             if (cap->flags)
> > +                     return -EINVAL;
> > +             kvm->arch.userspace_sbi =3D true;
> > +             return 0;
> >       default:
> >               return -EINVAL;
> >       }
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 454b7d4a0448..bf23deb6679e 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -931,6 +931,7 @@ struct kvm_enable_cap {
> >  #define KVM_CAP_X86_GUEST_MODE 238
> >  #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> >  #define KVM_CAP_RISCV_MP_STATE_RESET 240
> > +#define KVM_CAP_RISCV_USERSPACE_SBI 242
> >
> >  struct kvm_irq_routing_irqchip {
> >       __u32 irqchip;
> > --
> > 2.49.0
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

We are not going ahead with this approach for the reasons
mentioned in v3 series [1].

Regards,
Anup

[1] https://patchwork.ozlabs.org/project/kvm-riscv/cover/20250515143723.245=
0630-4-rkrcmar@ventanamicro.com/

