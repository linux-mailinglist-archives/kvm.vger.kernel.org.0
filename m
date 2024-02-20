Return-Path: <kvm+bounces-9129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 963B985B1EC
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 05:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 546602849FA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824F755E60;
	Tue, 20 Feb 2024 04:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GMmgx9uf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF4C168B8
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 04:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708403067; cv=none; b=cD+JtAC0FxmhoL3gmSzCftvNIbr+rnWhEhISS3sgGTV1Uc5Hp70GEhVJRZ1WC1ZrCtVKJwRUIzfLhlnNs/ylDLb3Kdzv7eYu3qOZhzzDt0flGHD0RYchlC0P2jZPmqVSzQxjhgzd8rYZy2dCl3pTFRQ8v6qWMFl8h/aUT40fpcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708403067; c=relaxed/simple;
	bh=FVpnY/nZxIdpiBUmBM95zWQeREuRUOCpl4s1Drgg10Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mBpQq8J4Q0E8ntfSPpLLKm+U1GB+lW38L2dLwsP9R0HLKkkIprlnidmZpIFFKMDnB9wn2oKJs/wItTT3U82GwkTB+e8E5Gbr28RxOvmLupu8I+FIhyBPUwFfmj6g6CPCx905GctGJFe7ysHfX/lJS7SVEJmI6tEqsrlIAP6K0lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GMmgx9uf; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-512a96e44e2so3058670e87.2
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 20:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1708403064; x=1709007864; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0RqToqS2dxGn5ETFJhDpR6T+22uNhhjH9Noy3IDSkgw=;
        b=GMmgx9ufPkIX1hUm0lS4J2NI4vr0NTlFQOztzKYAfVI9MUu6btzwPS8e/92BiYzpCz
         cYjh72GESTYeKVmk8s9SoYRjC9oKIdFLrR3ITqdCVIBRgJXkndcfOB7LGvcLfVWcQDLC
         M8GufyfzgWbS1btqXmNYKAUDXuEZAfUfMyVLZhOUA3SlgbVut1TjJJai6maFxcmFXc0w
         kjq9XpfPLyK/9rDl+xUfFY0DYhvH4gqwRDWdOs27yAoVYBa6MPG7XR33C+vdkJPIdS4H
         HFfNfJNa8B2r0fUGqzeNsZgjOOoMcm6I4unWexh73R0Ln6GqG9gQy6NGh/HSUSa6fakN
         hnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708403064; x=1709007864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0RqToqS2dxGn5ETFJhDpR6T+22uNhhjH9Noy3IDSkgw=;
        b=UUIfx6J2V8qXYqE64wq01EnImx8v0V5MaGHvHhv9IUZhnR6icwGpwyXr7LiQST0d6G
         BgSH7SaiwM4CaosACto8u9D41disu0BiR00r4AZIrTX5hBRwfkbR1Yf1q0sAnxuDsqDN
         zGxEelH615vK6S5+vkiBcohIcr6GurRGxHkXU/0uS4ErFHynKuBLZoo3rOXGX80+RsOx
         CCTVnL4RqTApERP1s0qByUs7cGx+rQq9mBXKTrmNHqkqIKFNX8UNWvijUmGbx+P9wwM9
         1tGCEdJPB1OorYUyKkkFTeLDKDN7UN5Or1ghLDrAQ5IbG5MDRCtu702Ak+jkKHVIn6gC
         3jMQ==
X-Gm-Message-State: AOJu0YyEnHzWJ1TYIzokCLqB/PIEK0ESmolwna+sJr6FmANZwBJragMl
	jKnF9HVTO49pGh9W/0qWs4wuNcM/3fm293UvHDfgspcwLdnyb5D6X0BMYDRe5pZvGpdvL80fihp
	eoygA8ACIuglaF2daTMDAEL01uIygdFiLDxjA8A==
X-Google-Smtp-Source: AGHT+IHabIzb7cPYtJPl2JjCGWBHmTvkKyJsxNufjXrMNfXSiP65z5dVUNLsKvQcDGxt2qKhNjHBlCwPNVoU2OSbDZQ=
X-Received: by 2002:a05:6512:68f:b0:512:8d90:7dd2 with SMTP id
 t15-20020a056512068f00b005128d907dd2mr9530334lfe.65.1708403063824; Mon, 19
 Feb 2024 20:24:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240206074931.22930-1-duchao@eswincomputing.com>
 <20240206074931.22930-2-duchao@eswincomputing.com> <CAK9=C2VZ1t3ctTWKiqeKOALjLh0kJgzVEsZvM=xfc2j7yQOEcQ@mail.gmail.com>
 <4a5a30cd.18c.18dc4734699.Coremail.duchao@eswincomputing.com>
In-Reply-To: <4a5a30cd.18c.18dc4734699.Coremail.duchao@eswincomputing.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 20 Feb 2024 09:54:11 +0530
Message-ID: <CAK9=C2XAEDfac+GQTD3jE2RLR+5ngNPedEE_G6tL4e2KByUZ1w@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2024 at 8:31=E2=80=AFAM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> On 2024-02-14 21:19, Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > On Tue, Feb 6, 2024 at 1:22=E2=80=AFPM Chao Du <duchao@eswincomputing.c=
om> wrote:
> > >
> > > kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEBUG i=
s
> > > being checked.
> > >
> > > kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug flags
> > > from userspace accordingly. Route the breakpoint exceptions to HS mod=
e
> > > if the VM is being debugged by userspace, by clearing the correspondi=
ng
> > > bit in hedeleg CSR.
> > >
> > > Signed-off-by: Chao Du <duchao@eswincomputing.com>
> > > ---
> > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > >  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
> > >  arch/riscv/kvm/vm.c               |  1 +
> > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/u=
api/asm/kvm.h
> > > index d6b7a5b95874..8890977836f0 100644
> > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > @@ -17,6 +17,7 @@
> > >
> > >  #define __KVM_HAVE_IRQ_LINE
> > >  #define __KVM_HAVE_READONLY_MEM
> > > +#define __KVM_HAVE_GUEST_DEBUG
> > >
> > >  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> > >
> > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > index b5ca9f2e98ac..6cee974592ac 100644
> > > --- a/arch/riscv/kvm/vcpu.c
> > > +++ b/arch/riscv/kvm/vcpu.c
> > > @@ -475,8 +475,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_v=
cpu *vcpu,
> > >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> > >                                         struct kvm_guest_debug *dbg)
> > >  {
> > > -       /* TODO; To be implemented later. */
> > > -       return -EINVAL;
> > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > +               if (vcpu->guest_debug !=3D dbg->control) {
> > > +                       vcpu->guest_debug =3D dbg->control;
> > > +                       csr_clear(CSR_HEDELEG, BIT(EXC_BREAKPOINT));
> > > +               }
> > > +       } else {
> > > +               if (vcpu->guest_debug !=3D 0) {
> > > +                       vcpu->guest_debug =3D 0;
> > > +                       csr_set(CSR_HEDELEG, BIT(EXC_BREAKPOINT));
> > > +               }
> > > +       }
> >
> > This is broken because directly setting breakpoint exception delegation
> > in CSR also affects other VCPUs running on the same host CPU.
> >
> > To address the above, we should do the following:
> > 1) Add "unsigned long hedeleg" in "struct kvm_vcpu_config" which
> >    is pre-initialized in kvm_riscv_vcpu_setup_config() without setting
> >    EXC_BREAKPOINT bit.
> > 2) The kvm_arch_vcpu_ioctl_set_guest_debug() should only set/clear
> >     EXC_BREAKPOINT bit in "hedeleg" of "struct kvm_vcpu_config".
> > 3) The kvm_riscv_vcpu_swap_in_guest_state() must write the
> >      HEDELEG csr before entering the Guest/VM.
> >
> > Regards,
> > Anup
> >
>
> Thanks for the review and detailed suggestion.
> Maybe we could make it a bit easier:
> 1) The kvm_arch_vcpu_ioctl_set_guest_debug() only update vcpu->guest_debu=
g
>    accordingly.
> 2) The kvm_riscv_vcpu_swap_in_guest_state() check vcpu->guest_debug and
>    set/clear the HEDELEG csr accordingly.
>
> Could you confirm if this is OK?

Your suggestion will work but it adds an additional "if ()" check in
kvm_riscv_vcpu_swap_in_guest_state() which is in the hot path.

I am still leaning towards what I suggested.

Regards,
Anup

> If yes, I will post another revision.
>
> Regards,
> Chao
>
> > > +
> > > +       return 0;
> > >  }
> > >
> > >  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > index ce58bc48e5b8..7396b8654f45 100644
> > > --- a/arch/riscv/kvm/vm.c
> > > +++ b/arch/riscv/kvm/vm.c
> > > @@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> > >         case KVM_CAP_READONLY_MEM:
> > >         case KVM_CAP_MP_STATE:
> > >         case KVM_CAP_IMMEDIATE_EXIT:
> > > +       case KVM_CAP_SET_GUEST_DEBUG:
> > >                 r =3D 1;
> > >                 break;
> > >         case KVM_CAP_NR_VCPUS:
> > > --
> > > 2.17.1
> > >
> > >
> > > --
> > > kvm-riscv mailing list
> > > kvm-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/kvm-riscv
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

