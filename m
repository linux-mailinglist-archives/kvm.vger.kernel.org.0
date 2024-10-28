Return-Path: <kvm+bounces-29868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 757799B36ED
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 364B5281ECE
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36D01DEFE2;
	Mon, 28 Oct 2024 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGeGT423"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0641DEFDC
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133843; cv=none; b=KySRphTuidjMDBAAtqxaDfcdsYscy+nvcbk547oVaqcNFMac2bV+06rzkQNcHp0du/yjoTYFr71dxTQgldM/+zoD6P91KOhtEaPXB+KyndNoOQoyQvY+gVYYVhByRQABCiQzd7Mb/fu98W/0znsTGqQ91qp3IhpRgV7mPIFtdPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133843; c=relaxed/simple;
	bh=5U/BlhyWnIq29nL86XXLwJkwzlKQyZzuRLybvzL75FY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qgeHo4JI0XrlGcT76LkJ73zJVStOi2cCm4LbkrpCsP3/HmculYHZVMfHnF0wCrI9+g+Z/9bclbSOPJQcfk8Ur6lR6de8vhBNSCE+r1JlTT7L0kirKdayjMdNbFmyopvnXWRJ/vX7pMQlHjyKesr5MgE1FjlrOSnB2R07TzlKclE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGeGT423; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-460a8d1a9b7so368231cf.1
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 09:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730133840; x=1730738640; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdUZtk1fpQmVlMAy2eFWyRES/zFmVCuya2ON3EbDm7k=;
        b=jGeGT423f8Pr3SZMB0BR7PRR9Ey5ddCAiRQhpIZPvaQ5xR/OLrvYFBMnTNO+am7BuK
         xK4y8kVHTE0p9FHYeqd/DaprIR/5bQcJ/AB1TpV3GNs3OgN+7dTSEWJ0J0s4EJZqP1vg
         oIEVvx7Z0C2N9+O1IfXAbJ4YXIBKQXKMa8t3FACVf4d7hVOcdk07/A1ZSl72nOMG0FPu
         cEO2o0qQca05Tc6zW+UgdkTUIRp3ZW41e4gRFzMTVSyakjQewRebxGCzeN39JfuJ36B+
         VEAQeOqlbcd8IH91U2O60nVDEEGZdzg9VKTsewFe0qSoWQM3Z3m9/nvqbgqApWs62GIU
         KJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730133840; x=1730738640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdUZtk1fpQmVlMAy2eFWyRES/zFmVCuya2ON3EbDm7k=;
        b=Mf1QPQmKpdZ1EDxWYr3Ncfx867bp6Y3pnKzBzwS+v2PUUWMsfcgDFm4V/O9oy8/g8C
         EdEn/qwXrw2bR3kzPKi8i/f4eq1NaGncbFFPtf8JFHoJmYB0BmzM0ag/xmUI9uIhAM7Q
         y+u5lbLzcsZXQx73w+K+/85G8+f4L8yEBkJvBIpBDb+unS8ay9c4OB/tBz1EqBvj8snq
         PXpRCkC+tD+kpw2Te5s+6KhJWiW2w/FHmpbCVU8RBWBLFcdH/N+tFRW/pOUXR8cVMX8C
         uDUg25uT0jU/gATvO0xkguw89NjNERvZlhH0lLk35AjD9M3TqS1lkdrTz5bBMHZTpzlA
         rf/A==
X-Forwarded-Encrypted: i=1; AJvYcCWFaO0JqMwyUoPTES09b7LFvvweRQpjMN3JEhAa636GnGIemC615CfX+drDhliiO6LQcy4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTbxUpsKl27+QxOXGpMA+YiyDPVxjMoPePyIvY3AnJ2fL5tuZZ
	xsJxnSw3uj2354odYxSUrKjqaiiABKta5dju8S5iJvXeZqKId0el7FVdPYvIEqnw8IWCIof9b+i
	/Ibya/UEj5JJwgC05hzxErXMqONGHl7LExMvn7eJAOXZswKSa58lwgxQ=
X-Google-Smtp-Source: AGHT+IEghDPlnRG5rp1sejh9aj1o1ldjwh0sg0K+Pts7Qn1e0eo7gyHR2Y3Bk11hNYvDVU4SH68ne++ka9GQaWQoClE=
X-Received: by 2002:ac8:470f:0:b0:461:4150:b833 with SMTP id
 d75a77b69052e-4614150b8f8mr3465511cf.22.1730133840204; Mon, 28 Oct 2024
 09:44:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025221220.2985227-1-rananta@google.com> <Zxx_X9-MdmAFzHUO@linux.dev>
 <87ttcztili.wl-maz@kernel.org> <Zx0CT1gdSWVyKLuD@linux.dev>
In-Reply-To: <Zx0CT1gdSWVyKLuD@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 28 Oct 2024 09:43:45 -0700
Message-ID: <CAJHc60wn=vA9j421FhVkMqYc0w8u2ZYuc-9TJ+rvriSXjseKHw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Mark the VM as dead for failed initializations
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,


On Sat, Oct 26, 2024 at 7:53=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Sat, Oct 26, 2024 at 08:43:21AM +0100, Marc Zyngier wrote:
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index bf64fed9820e..c315bc1a4e9a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -74,8 +74,6 @@ enum kvm_mode kvm_get_mode(void);
> >  static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE;=
 };
> >  #endif
> >
> > -DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> > -
> >  extern unsigned int __ro_after_init kvm_sve_max_vl;
> >  extern unsigned int __ro_after_init kvm_host_sve_max_vl;
> >  int __init kvm_arm_init_sve(void);
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index 879982b1cc73..1215df590418 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -206,8 +206,7 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct ti=
mer_map *map)
> >
> >  static inline bool userspace_irqchip(struct kvm *kvm)
> >  {
> > -     return static_branch_unlikely(&userspace_irqchip_in_use) &&
> > -             unlikely(!irqchip_in_kernel(kvm));
> > +     return unlikely(!irqchip_in_kernel(kvm));
> >  }
> >
> >  static void soft_timer_start(struct hrtimer *hrt, u64 ns)
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 48cafb65d6ac..70ff9a20ef3a 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -69,7 +69,6 @@ DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_=
hyp_ctxt);
> >  static bool vgic_present, kvm_arm_initialised;
> >
> >  static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
> > -DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >
> >  bool is_kvm_arm_initialised(void)
> >  {
> > @@ -503,9 +502,6 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu=
)
> >
> >  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  {
> > -     if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->=
kvm)))
> > -             static_branch_dec(&userspace_irqchip_in_use);
> > -
> >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> >       kvm_timer_vcpu_terminate(vcpu);
> >       kvm_pmu_vcpu_destroy(vcpu);
> > @@ -848,14 +844,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *=
vcpu)
> >                       return ret;
> >       }
> >
> > -     if (!irqchip_in_kernel(kvm)) {
> > -             /*
> > -              * Tell the rest of the code that there are userspace irq=
chip
> > -              * VMs in the wild.
> > -              */
> > -             static_branch_inc(&userspace_irqchip_in_use);
> > -     }
> > -
> >       /*
> >        * Initialize traps for protected VMs.
> >        * NOTE: Move to run in EL2 directly, rather than via a hypercall=
, once
> > @@ -1077,7 +1065,7 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu=
 *vcpu, int *ret)
> >        * state gets updated in kvm_timer_update_run and
> >        * kvm_pmu_update_run below).
> >        */
> > -     if (static_branch_unlikely(&userspace_irqchip_in_use)) {
> > +     if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
> >               if (kvm_timer_should_notify_user(vcpu) ||
> >                   kvm_pmu_should_notify_user(vcpu)) {
> >                       *ret =3D -EINTR;
> > @@ -1199,7 +1187,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
)
> >                       vcpu->mode =3D OUTSIDE_GUEST_MODE;
> >                       isb(); /* Ensure work in x_flush_hwstate is commi=
tted */
> >                       kvm_pmu_sync_hwstate(vcpu);
> > -                     if (static_branch_unlikely(&userspace_irqchip_in_=
use))
> > +                     if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
> >                               kvm_timer_sync_user(vcpu);
> >                       kvm_vgic_sync_hwstate(vcpu);
> >                       local_irq_enable();
> > @@ -1245,7 +1233,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
)
> >                * we don't want vtimer interrupts to race with syncing t=
he
> >                * timer virtual interrupt state.
> >                */
> > -             if (static_branch_unlikely(&userspace_irqchip_in_use))
> > +             if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
> >                       kvm_timer_sync_user(vcpu);
> >
> >               kvm_arch_vcpu_ctxsync_fp(vcpu);
> >
> > I think this would fix the problem you're seeing without changing the
> > userspace view of an erroneous configuration. It would also pave the
> > way for the complete removal of the interrupt notification to
> > userspace, which I claim has no user and is just a shit idea.
>
> Yeah, looks like this ought to get it done.
>
> Even with a fix for this particular issue I do wonder if we should
> categorically harden against late initialization failures and un-init
> the vCPU (or bug VM, where necessary) to avoid dealing with half-baked
> vCPUs/VMs across our UAPI surfaces.
>
> A sane userspace will probably crash when KVM_RUN returns EINVAL anyway.

Thanks for the suggestion. Sure, I'll take another look at the
possible things that we can uninitialize and try to re-spin the patch.

Marc,

If you feel userspace_irqchip_in_use is not necessary anymore, and as
a quick fix to this issue, we can get rid of that independent of the
un-init effort.

Thank you.
Raghavendra

