Return-Path: <kvm+bounces-47759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2B6AC48F4
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A95FE189D3B3
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132B0205ABB;
	Tue, 27 May 2025 06:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="F2WAm7iL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D872C1FCF41
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 06:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748329131; cv=none; b=PU5/TEnOf1gJ7zQNsZkpnuKy0Eho0x0W8w61rQUYzZt6TvvyqVXZx/ulJ8nepu0qThuhxoTS62Er5pqkcWwa6U6JIRC8a2ZRTEYWjCfcz01sC9e1u1MX+YbWXhhbAfePUp539SzXXP4ZNIV5JPgKFMNiNxPe+k5j1R0jEHEBvpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748329131; c=relaxed/simple;
	bh=fpkvLBVuTAYEIEPT7LlEGWQ8NMvC1E1BlUqUR0CtrAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZ36KHh7KbdSklC+re4l8I28WnKrRLrNGST+JQkBx3k1Pq8SmPehI0i14ylfwx0si7BVLnqeIPoFDZgeapW62Xn7yWJx7bA4dF8uMcsURRwMQnJ4UsGuDVY++kvbZrrt5wXBoQv8eUtUVWWTgrNuR6ELw4W4AQNoOvcYnerexHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=F2WAm7iL; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-442f5b3c710so28396215e9.1
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 23:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748329127; x=1748933927; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IvHPnEqJkHaFg0addX5NNhxyCN45o5Itm5HB4I862Ls=;
        b=F2WAm7iLTNwvr7YT3hZnTrSWtLPXNGjGP35J0b6cUh4iLHdQ/Y+CfZqQqRYmQNc7nm
         BFcCaj5ZJsyGkClZEo4TYKMK2ljUp31Hgv5THJN0RqgB94NpTE7nZ5lNTPJdkSqH1xAw
         A7zfl95cRSo+uNJdA/pRNjaGrpJDOleSgQUarCf7A3OoEmQdnvc9AUNbZ6MVlG0eKL2e
         laZoG6FpegTy5m44NNeu6nrvqq9HbaH+YREXmOiCxTjiRSD59H8I9FJKQfJsQGF9RjUk
         Da9k3R9L/gLWexytW9jUwEOGwxuvlm6swrP7N5gA6kRxrzKEjgC2NujtgunJsDVXdoHu
         yAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748329127; x=1748933927;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IvHPnEqJkHaFg0addX5NNhxyCN45o5Itm5HB4I862Ls=;
        b=bcA8eBRLy9HZ/VS0s+q2mAPAzDRpPImGezXo6DbUNeJuR/TXFIBrF5cR7JSn1hcig8
         3R2DbW252h5ZADgO47nbT2AiIjtpmg9E2fbskV/PwNPHuxn65I149U2OHqeUMlacW3bM
         gIOI2/AFApUawya6xMhj83yzt/ajrGLJ7gW/GjHfUcBmy8PjXt0orRVWA+b7+tydrLrz
         qIieNo1ddE9EMgA6Vc71ZjDjfJkkTfSi+3UhbctwoZKaHHNxkQ/iIygNt4+5a/Zz5DoU
         /IazYL7yBhEppKoht/05p1MjskqAdudojjByaO4PH27ELpxPfuCMpl3mLi+ryTDOuNko
         Zzxg==
X-Forwarded-Encrypted: i=1; AJvYcCUIGhRCT20I5LM0ieluRycCySrx/E9MbC5c1NRgEwJC3vaZEZYlawTYwBiIylznYII2Q/s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE82yKjazMZIGRg0JhrgmgUuCmN12/E9KQJovHl3zjuxuaJpxi
	HD/kRdVD61THTXcNGMDcHJGfMIcUFKwnKcYEu7tMHxE+yW2SM8VlsHMH0Cp/w2SLkw8=
X-Gm-Gg: ASbGnctozQjTZ8+Mwn4nGyiJpBssZJHWvMZbUiBKfHNEOt2T2ayy9LZphiynHw65FM7
	cY4aV9g9mc0DEbZu7I8rKG2ALiNZ3xXQGlQ+66OJFZtFqlD7PzGEUZdMZaVB1l5RljsJg1Hh452
	Rzv3qsaZUXgQMoNt6WIARog3p1bSItwsMgfNjiz+AOyn0oQ/6CB3wAKm/UkDJ7I26Tcpq8J8ptn
	zTp2kqHOG1lbLO4G49gPLw1pyfVtwuVJrAjGYc/KTb5uOCKmGM4Jy0yZIgBM9RbRUoxgWiJDvJ1
	khGZVzTq3kTWOgOlaP+5SwZFrcJMXRKduKEednc59ZnmP8dfig==
X-Google-Smtp-Source: AGHT+IEHhQQL0VEBdNls3pWCu2J/RUKzb/9Co2PPyCShUceoxcl4MXQDtgi0OraHyJERFxo/xRNOZA==
X-Received: by 2002:a05:600c:1d96:b0:440:6a1a:d89f with SMTP id 5b1f17b1804b1-44c916071a2mr114369435e9.4.1748329126908;
        Mon, 26 May 2025 23:58:46 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::ce80])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4dc1172ecsm4127292f8f.48.2025.05.26.23.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 23:58:46 -0700 (PDT)
Date: Tue, 27 May 2025 08:58:45 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <anup@brainfault.org>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Subject: Re: [PATCH v4] RISC-V: KVM: add KVM_CAP_RISCV_USERSPACE_SBI
Message-ID: <20250527-10d0318cf26e3602948545db@orel>
References: <20250523113347.2898042-3-rkrcmar@ventanamicro.com>
 <20250526-e67c64d52c84a8ad7cb519c4@orel>
 <CAAhSdy1wtuLm2O7EwfVzCT7wgKf7-n9q9_DxfpA6kQA1oSoZoQ@mail.gmail.com>
 <20250526-c5be5322d773143825948b8b@orel>
 <CAAhSdy0uX9dEPdGiMgDcYbR6WS+Nc=V3rLvK_TEoA=fzeD9wBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhSdy0uX9dEPdGiMgDcYbR6WS+Nc=V3rLvK_TEoA=fzeD9wBg@mail.gmail.com>

On Tue, May 27, 2025 at 09:23:05AM +0530, Anup Patel wrote:
> On Mon, May 26, 2025 at 8:09 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Mon, May 26, 2025 at 06:12:19PM +0530, Anup Patel wrote:
> > > On Mon, May 26, 2025 at 2:52 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> > > >
> > > > On Fri, May 23, 2025 at 01:33:49PM +0200, Radim Krčmář wrote:
> > > > > The new capability allows userspace to implement SBI extensions that KVM
> > > > > does not handle.  This allows userspace to implement any SBI ecall as
> > > > > userspace already has the ability to disable acceleration of selected
> > > > > SBI extensions.
> > > > > The base extension is made controllable as well, but only with the new
> > > > > capability, because it was previously handled specially for some reason.
> > > > > *** The related compatibility TODO in the code needs addressing. ***
> > > > >
> > > > > This is a VM capability, because userspace will most likely want to have
> > > > > the same behavior for all VCPUs.  We can easily make it both a VCPU and
> > > > > a VM capability if there is demand in the future.
> > > > >
> > > > > Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> > > > > ---
> > > > > v4:
> > > > > * forward base extension as well
> > > > > * change the id to 242, because 241 is already taken in linux-next
> > > > > * QEMU example: https://github.com/radimkrcmar/qemu/tree/mp_state_reset
> > > > > v3: new
> > > > > ---
> > > > >  Documentation/virt/kvm/api.rst    | 11 +++++++++++
> > > > >  arch/riscv/include/asm/kvm_host.h |  3 +++
> > > > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > > > >  arch/riscv/kvm/vcpu_sbi.c         | 17 ++++++++++++++---
> > > > >  arch/riscv/kvm/vm.c               |  5 +++++
> > > > >  include/uapi/linux/kvm.h          |  1 +
> > > > >  6 files changed, 35 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > > index e107694fb41f..c9d627d13a5e 100644
> > > > > --- a/Documentation/virt/kvm/api.rst
> > > > > +++ b/Documentation/virt/kvm/api.rst
> > > > > @@ -8507,6 +8507,17 @@ given VM.
> > > > >  When this capability is enabled, KVM resets the VCPU when setting
> > > > >  MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
> > > > >
> > > > > +7.44 KVM_CAP_RISCV_USERSPACE_SBI
> > > > > +--------------------------------
> > > > > +
> > > > > +:Architectures: riscv
> > > > > +:Type: VM
> > > > > +:Parameters: None
> > > > > +:Returns: 0 on success, -EINVAL if arg[0] is not zero
> > > > > +
> > > > > +When this capability is enabled, KVM forwards ecalls from disabled or unknown
> > > > > +SBI extensions to userspace.
> > > > > +
> > > > >  8. Other capabilities.
> > > > >  ======================
> > > > >
> > > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > > > > index 85cfebc32e4c..6f17cd923889 100644
> > > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > > @@ -122,6 +122,9 @@ struct kvm_arch {
> > > > >
> > > > >       /* KVM_CAP_RISCV_MP_STATE_RESET */
> > > > >       bool mp_state_reset;
> > > > > +
> > > > > +     /* KVM_CAP_RISCV_USERSPACE_SBI */
> > > > > +     bool userspace_sbi;
> > > > >  };
> > > > >
> > > > >  struct kvm_cpu_trap {
> > > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > > > > index 5f59fd226cc5..dd3a5dc53d34 100644
> > > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > > @@ -204,6 +204,7 @@ enum KVM_RISCV_SBI_EXT_ID {
> > > > >       KVM_RISCV_SBI_EXT_DBCN,
> > > > >       KVM_RISCV_SBI_EXT_STA,
> > > > >       KVM_RISCV_SBI_EXT_SUSP,
> > > > > +     KVM_RISCV_SBI_EXT_BASE,
> > > > >       KVM_RISCV_SBI_EXT_MAX,
> > > > >  };
> > > > >
> > > > > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > > > > index 31fd3cc98d66..497d5b023153 100644
> > > > > --- a/arch/riscv/kvm/vcpu_sbi.c
> > > > > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > > > > @@ -39,7 +39,7 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
> > > > >               .ext_ptr = &vcpu_sbi_ext_v01,
> > > > >       },
> > > > >       {
> > > > > -             .ext_idx = KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled */
> > > > > +             .ext_idx = KVM_RISCV_SBI_EXT_BASE,
> > > > >               .ext_ptr = &vcpu_sbi_ext_base,
> > > > >       },
> > > > >       {
> > > > > @@ -217,6 +217,11 @@ static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
> > > > >       if (!sext || scontext->ext_status[sext->ext_idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE)
> > > > >               return -ENOENT;
> > > > >
> > > > > +     // TODO: probably remove, the extension originally couldn't be
> > > > > +     // disabled, but it doesn't seem necessary
> > > > > +     if (!vcpu->kvm->arch.userspace_sbi && sext->ext_id == KVM_RISCV_SBI_EXT_BASE)
> > > > > +             return -ENOENT;
> > > > > +
> > > >
> > > > I agree that we don't need to babysit userspace and it's even conceivable
> > > > to have guests that don't need SBI. KVM should only need checks in its
> > > > UAPI to protect itself from userspace and to enforce proper use of the
> > > > API. It's not KVM's place to ensure userspace doesn't violate the SBI spec
> > > > or create broken guests (userspace is the boss, even if it's a boss that
> > > > doesn't make sense)
> > > >
> > > > So, I vote we drop the check.
> > > >
> > > > >       scontext->ext_status[sext->ext_idx] = (reg_val) ?
> > > > >                       KVM_RISCV_SBI_EXT_STATUS_ENABLED :
> > > > >                       KVM_RISCV_SBI_EXT_STATUS_DISABLED;
> > > > > @@ -471,8 +476,14 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > > > >  #endif
> > > > >               ret = sbi_ext->handler(vcpu, run, &sbi_ret);
> > > > >       } else {
> > > > > -             /* Return error for unsupported SBI calls */
> > > > > -             cp->a0 = SBI_ERR_NOT_SUPPORTED;
> > > > > +             if (vcpu->kvm->arch.userspace_sbi) {
> > > > > +                     next_sepc = false;
> > > > > +                     ret = 0;
> > > > > +                     kvm_riscv_vcpu_sbi_forward(vcpu, run);
> > > > > +             } else {
> > > > > +                     /* Return error for unsupported SBI calls */
> > > > > +                     cp->a0 = SBI_ERR_NOT_SUPPORTED;
> > > > > +             }
> > > > >               goto ecall_done;
> > > > >       }
> > > > >
> > > > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > > > index b27ec8f96697..0b6378b83955 100644
> > > > > --- a/arch/riscv/kvm/vm.c
> > > > > +++ b/arch/riscv/kvm/vm.c
> > > > > @@ -217,6 +217,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> > > > >                       return -EINVAL;
> > > > >               kvm->arch.mp_state_reset = true;
> > > > >               return 0;
> > > > > +     case KVM_CAP_RISCV_USERSPACE_SBI:
> > > > > +             if (cap->flags)
> > > > > +                     return -EINVAL;
> > > > > +             kvm->arch.userspace_sbi = true;
> > > > > +             return 0;
> > > > >       default:
> > > > >               return -EINVAL;
> > > > >       }
> > > > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > > index 454b7d4a0448..bf23deb6679e 100644
> > > > > --- a/include/uapi/linux/kvm.h
> > > > > +++ b/include/uapi/linux/kvm.h
> > > > > @@ -931,6 +931,7 @@ struct kvm_enable_cap {
> > > > >  #define KVM_CAP_X86_GUEST_MODE 238
> > > > >  #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> > > > >  #define KVM_CAP_RISCV_MP_STATE_RESET 240
> > > > > +#define KVM_CAP_RISCV_USERSPACE_SBI 242
> > > > >
> > > > >  struct kvm_irq_routing_irqchip {
> > > > >       __u32 irqchip;
> > > > > --
> > > > > 2.49.0
> > > > >
> > > >
> > > > Otherwise,
> > > >
> > > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > >
> > > We are not going ahead with this approach for the reasons
> > > mentioned in v3 series [1].
> >
> > IIUC, the main concern in that thread is that userspace won't know what to
> > do with some of the exits it gets or that it'll try to take control of
> > extensions that it can't emulate. I feel like not exiting to userspace in
> > those cases is trying to second guess it, i.e. KVM is trying to enforce a
> > policy on userspace. But, KVM shouldn't be doing that, as userspace should
> > be the policy maker. If userspace uses this capability to opt into getting
> > all the SBI exits (which it doesn't want KVM to handle), then it should be
> > allowed to get them -- and, if userspace doesn't know what it's doing,
> > then it can keep all the pieces.
> 
> The userspace already has a mechanism to opt-in for select SBI exits
> which it can implement such as SBI DBCN and SBI SUSP. With SBI v3.0,
> userspace will be able implement SBI MPXY but SBI SSE, FWFT, and
> DBTR will be in kernel space due to reasons mentioned in the v3 series.
> 
> There is no point in forwarding all SBI exits to userspace when userspace
> has no mechanism to implement many critical SBI extensions.

Userspace can implement all truly disabled extensions, it just returns
not-supported. So, while I may be contriving this example a bit, enabling
userspace to log attempts to use disabled extensions would be one reason
to forward them.

Thanks,
drew

