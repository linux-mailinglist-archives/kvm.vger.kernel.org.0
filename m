Return-Path: <kvm+bounces-47741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3799AC46EF
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 05:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3029E7AB41D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 03:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D537C1C8638;
	Tue, 27 May 2025 03:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="gWkVOl1F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F741802B
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 03:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748317999; cv=none; b=ukkJH+iFU67Nub5sPhsIB9uxTJ6gfVbphdB0i0Lo0VdVQxhNs65rlACRS0yOAD4ku2Sig16DY2PUPbazSIFcuKll8v0i0zR8U9pznNV2OFKoxd5t+1XS2LXMMPkTkzGxJzONuoKzY8kbo/jQLa9WOHYRV5sfg2RGM1ZDsbnJmU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748317999; c=relaxed/simple;
	bh=IgUtu+iLkBrk1B0B4v8JHfUEqxee5mlwSDioSwW6W5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gaW9xTlkIrY0cxm1cK7QbkBLv0zXFR8V5WbqJz4/bjKf0ExoD4OSsrwCewMnO381Gfja8op7fLFcxZLUnsBG4yTY9+MwJTMfuKbT9+At+dP1pwKbkVuEeLLTErbVwikPSyHKyNK990A/EG66zD3Sx+DnPow4sAHoYWk/GOysxbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=gWkVOl1F; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d96d16b369so22934825ab.0
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 20:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1748317997; x=1748922797; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xrKH9i0vLKm95FaV4H3aJUrB006oqaghq5fFnCZo2M=;
        b=gWkVOl1FcXam/5tnl81IviC6qUsKMuizXrCll5oLqIh3KmJsFAhwyiQpX5LxJawOD3
         5d9iJZ4KeL6UKsdVPewmFlHv6YEoTwQlsaYA8y0Y9tKX68PfGf6dnCYiFzEGg/vEcjK9
         2f+2SSgDmigV5nY2AzoYpnW9W1UlsqWIu0WvFNJaQDPtkfkK2DQltIdTVXEeScMUyd7c
         N/9aZhixfYX5+c+y/UxvEvb7SwY4tfFKsgr+2kuagMzKAfsV2NbdLOy66U/ibkst9GFx
         QDDlH1HBksu+UbOwudxgO016+HKDChRImbAVlclNm/7OyXsYTVoP1S6nPAqZswYOBlKx
         sbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748317997; x=1748922797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xrKH9i0vLKm95FaV4H3aJUrB006oqaghq5fFnCZo2M=;
        b=llikmjUfsBlY7RZ/9ZBYJNkX9BAhNEhIPbi9FeYLAc8ISIvYTwCdmzjLOSB6r+DJYn
         MoZiT/rZQJM73B7SguiP2tPYn7IflciMySSMLORpu3gSx6cX/Sqii9od9XTUiVesBT0j
         Z/H0ngwMVBEOQYL9VMUlNC5By3yBKL+QWcI1L5A/WOpwPwHJsNZe7dvw+IG7BnSvc4O+
         ZRG2vZRMtirf7Fzy/wPbhsG/1+/GKOf57BHSVVEN1Pf5tTf2hD51N/yeXxNSSjXE7T0m
         Ue5snCAiWagAekHKUEUXga3/jA/nWF1vYLTcg9HbefPvmmszSotpD9tUKDPcTfn3Qcmu
         dIcw==
X-Forwarded-Encrypted: i=1; AJvYcCWWM9WP97gWAAM2Trl/MO/kySol1fT6Una5oX7Qf62DNAWFXOETD+UF8rZ6FtO7ky62CMU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1xwl5Rm7Meioo85XYM6HkRU9+BhwLkP5Bg8Vo/lHf8Gq8FCWH
	cQsTnZas46jq/m0cgFoGhu5cySews35POgXBAG8gBglNj0K0BTFqNnS/A3qvlELFe42Pvlk2mt9
	+AaZgAMhGjMQt8uDw3/sKH2SVwtO4L3AC+gNzfNSm+A==
X-Gm-Gg: ASbGnctxTOqsClYlUA9cN+MrKKS8gTFNGZsiaw6XAWltINUq+zhjGS6n7KzExPI465L
	qH1ckKV94RrkY1mREEHWQ2KnbKHgqBL+rYF+b3BQEclytqqTIE0L0bhc/yPFyQivW7deH9L6MZX
	2nzYGo0NuK/qxOGeNo8vwxPjbJvETKDnb98w==
X-Google-Smtp-Source: AGHT+IGxfTnvxcVhTT6Neh0+crV2uPu9gqQ3HtpS9iFZUfbD9668utg3xBLYk8xm/XIXcdCCLY5kNZqolBPcgTbXOwI=
X-Received: by 2002:a05:6e02:12ca:b0:3dc:7a9a:44d5 with SMTP id
 e9e14a558f8ab-3dc9b751754mr103323995ab.22.1748317997035; Mon, 26 May 2025
 20:53:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523113347.2898042-3-rkrcmar@ventanamicro.com>
 <20250526-e67c64d52c84a8ad7cb519c4@orel> <CAAhSdy1wtuLm2O7EwfVzCT7wgKf7-n9q9_DxfpA6kQA1oSoZoQ@mail.gmail.com>
 <20250526-c5be5322d773143825948b8b@orel>
In-Reply-To: <20250526-c5be5322d773143825948b8b@orel>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 27 May 2025 09:23:05 +0530
X-Gm-Features: AX0GCFuBqduLJhMhh1XnRxqG9FgILJjrCfnWo1gi00WGZUliy_Wp90F5Rbgg8Bw
Message-ID: <CAAhSdy0uX9dEPdGiMgDcYbR6WS+Nc=V3rLvK_TEoA=fzeD9wBg@mail.gmail.com>
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

On Mon, May 26, 2025 at 8:09=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Mon, May 26, 2025 at 06:12:19PM +0530, Anup Patel wrote:
> > On Mon, May 26, 2025 at 2:52=E2=80=AFPM Andrew Jones <ajones@ventanamic=
ro.com> wrote:
> > >
> > > On Fri, May 23, 2025 at 01:33:49PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99=
 wrote:
> > > > The new capability allows userspace to implement SBI extensions tha=
t KVM
> > > > does not handle.  This allows userspace to implement any SBI ecall =
as
> > > > userspace already has the ability to disable acceleration of select=
ed
> > > > SBI extensions.
> > > > The base extension is made controllable as well, but only with the =
new
> > > > capability, because it was previously handled specially for some re=
ason.
> > > > *** The related compatibility TODO in the code needs addressing. **=
*
> > > >
> > > > This is a VM capability, because userspace will most likely want to=
 have
> > > > the same behavior for all VCPUs.  We can easily make it both a VCPU=
 and
> > > > a VM capability if there is demand in the future.
> > > >
> > > > Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.co=
m>
> > > > ---
> > > > v4:
> > > > * forward base extension as well
> > > > * change the id to 242, because 241 is already taken in linux-next
> > > > * QEMU example: https://github.com/radimkrcmar/qemu/tree/mp_state_r=
eset
> > > > v3: new
> > > > ---
> > > >  Documentation/virt/kvm/api.rst    | 11 +++++++++++
> > > >  arch/riscv/include/asm/kvm_host.h |  3 +++
> > > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > > >  arch/riscv/kvm/vcpu_sbi.c         | 17 ++++++++++++++---
> > > >  arch/riscv/kvm/vm.c               |  5 +++++
> > > >  include/uapi/linux/kvm.h          |  1 +
> > > >  6 files changed, 35 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kv=
m/api.rst
> > > > index e107694fb41f..c9d627d13a5e 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -8507,6 +8507,17 @@ given VM.
> > > >  When this capability is enabled, KVM resets the VCPU when setting
> > > >  MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is pr=
eserved.
> > > >
> > > > +7.44 KVM_CAP_RISCV_USERSPACE_SBI
> > > > +--------------------------------
> > > > +
> > > > +:Architectures: riscv
> > > > +:Type: VM
> > > > +:Parameters: None
> > > > +:Returns: 0 on success, -EINVAL if arg[0] is not zero
> > > > +
> > > > +When this capability is enabled, KVM forwards ecalls from disabled=
 or unknown
> > > > +SBI extensions to userspace.
> > > > +
> > > >  8. Other capabilities.
> > > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include=
/asm/kvm_host.h
> > > > index 85cfebc32e4c..6f17cd923889 100644
> > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > @@ -122,6 +122,9 @@ struct kvm_arch {
> > > >
> > > >       /* KVM_CAP_RISCV_MP_STATE_RESET */
> > > >       bool mp_state_reset;
> > > > +
> > > > +     /* KVM_CAP_RISCV_USERSPACE_SBI */
> > > > +     bool userspace_sbi;
> > > >  };
> > > >
> > > >  struct kvm_cpu_trap {
> > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include=
/uapi/asm/kvm.h
> > > > index 5f59fd226cc5..dd3a5dc53d34 100644
> > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > @@ -204,6 +204,7 @@ enum KVM_RISCV_SBI_EXT_ID {
> > > >       KVM_RISCV_SBI_EXT_DBCN,
> > > >       KVM_RISCV_SBI_EXT_STA,
> > > >       KVM_RISCV_SBI_EXT_SUSP,
> > > > +     KVM_RISCV_SBI_EXT_BASE,
> > > >       KVM_RISCV_SBI_EXT_MAX,
> > > >  };
> > > >
> > > > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > > > index 31fd3cc98d66..497d5b023153 100644
> > > > --- a/arch/riscv/kvm/vcpu_sbi.c
> > > > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > > > @@ -39,7 +39,7 @@ static const struct kvm_riscv_sbi_extension_entry=
 sbi_ext[] =3D {
> > > >               .ext_ptr =3D &vcpu_sbi_ext_v01,
> > > >       },
> > > >       {
> > > > -             .ext_idx =3D KVM_RISCV_SBI_EXT_MAX, /* Can't be disab=
led */
> > > > +             .ext_idx =3D KVM_RISCV_SBI_EXT_BASE,
> > > >               .ext_ptr =3D &vcpu_sbi_ext_base,
> > > >       },
> > > >       {
> > > > @@ -217,6 +217,11 @@ static int riscv_vcpu_set_sbi_ext_single(struc=
t kvm_vcpu *vcpu,
> > > >       if (!sext || scontext->ext_status[sext->ext_idx] =3D=3D KVM_R=
ISCV_SBI_EXT_STATUS_UNAVAILABLE)
> > > >               return -ENOENT;
> > > >
> > > > +     // TODO: probably remove, the extension originally couldn't b=
e
> > > > +     // disabled, but it doesn't seem necessary
> > > > +     if (!vcpu->kvm->arch.userspace_sbi && sext->ext_id =3D=3D KVM=
_RISCV_SBI_EXT_BASE)
> > > > +             return -ENOENT;
> > > > +
> > >
> > > I agree that we don't need to babysit userspace and it's even conceiv=
able
> > > to have guests that don't need SBI. KVM should only need checks in it=
s
> > > UAPI to protect itself from userspace and to enforce proper use of th=
e
> > > API. It's not KVM's place to ensure userspace doesn't violate the SBI=
 spec
> > > or create broken guests (userspace is the boss, even if it's a boss t=
hat
> > > doesn't make sense)
> > >
> > > So, I vote we drop the check.
> > >
> > > >       scontext->ext_status[sext->ext_idx] =3D (reg_val) ?
> > > >                       KVM_RISCV_SBI_EXT_STATUS_ENABLED :
> > > >                       KVM_RISCV_SBI_EXT_STATUS_DISABLED;
> > > > @@ -471,8 +476,14 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *=
vcpu, struct kvm_run *run)
> > > >  #endif
> > > >               ret =3D sbi_ext->handler(vcpu, run, &sbi_ret);
> > > >       } else {
> > > > -             /* Return error for unsupported SBI calls */
> > > > -             cp->a0 =3D SBI_ERR_NOT_SUPPORTED;
> > > > +             if (vcpu->kvm->arch.userspace_sbi) {
> > > > +                     next_sepc =3D false;
> > > > +                     ret =3D 0;
> > > > +                     kvm_riscv_vcpu_sbi_forward(vcpu, run);
> > > > +             } else {
> > > > +                     /* Return error for unsupported SBI calls */
> > > > +                     cp->a0 =3D SBI_ERR_NOT_SUPPORTED;
> > > > +             }
> > > >               goto ecall_done;
> > > >       }
> > > >
> > > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > > index b27ec8f96697..0b6378b83955 100644
> > > > --- a/arch/riscv/kvm/vm.c
> > > > +++ b/arch/riscv/kvm/vm.c
> > > > @@ -217,6 +217,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, s=
truct kvm_enable_cap *cap)
> > > >                       return -EINVAL;
> > > >               kvm->arch.mp_state_reset =3D true;
> > > >               return 0;
> > > > +     case KVM_CAP_RISCV_USERSPACE_SBI:
> > > > +             if (cap->flags)
> > > > +                     return -EINVAL;
> > > > +             kvm->arch.userspace_sbi =3D true;
> > > > +             return 0;
> > > >       default:
> > > >               return -EINVAL;
> > > >       }
> > > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > index 454b7d4a0448..bf23deb6679e 100644
> > > > --- a/include/uapi/linux/kvm.h
> > > > +++ b/include/uapi/linux/kvm.h
> > > > @@ -931,6 +931,7 @@ struct kvm_enable_cap {
> > > >  #define KVM_CAP_X86_GUEST_MODE 238
> > > >  #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> > > >  #define KVM_CAP_RISCV_MP_STATE_RESET 240
> > > > +#define KVM_CAP_RISCV_USERSPACE_SBI 242
> > > >
> > > >  struct kvm_irq_routing_irqchip {
> > > >       __u32 irqchip;
> > > > --
> > > > 2.49.0
> > > >
> > >
> > > Otherwise,
> > >
> > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> >
> > We are not going ahead with this approach for the reasons
> > mentioned in v3 series [1].
>
> IIUC, the main concern in that thread is that userspace won't know what t=
o
> do with some of the exits it gets or that it'll try to take control of
> extensions that it can't emulate. I feel like not exiting to userspace in
> those cases is trying to second guess it, i.e. KVM is trying to enforce a
> policy on userspace. But, KVM shouldn't be doing that, as userspace shoul=
d
> be the policy maker. If userspace uses this capability to opt into gettin=
g
> all the SBI exits (which it doesn't want KVM to handle), then it should b=
e
> allowed to get them -- and, if userspace doesn't know what it's doing,
> then it can keep all the pieces.

The userspace already has a mechanism to opt-in for select SBI exits
which it can implement such as SBI DBCN and SBI SUSP. With SBI v3.0,
userspace will be able implement SBI MPXY but SBI SSE, FWFT, and
DBTR will be in kernel space due to reasons mentioned in the v3 series.

There is no point in forwarding all SBI exits to userspace when userspace
has no mechanism to implement many critical SBI extensions.

Regards,
Anup

