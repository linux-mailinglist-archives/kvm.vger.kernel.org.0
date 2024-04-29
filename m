Return-Path: <kvm+bounces-16182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AEA8B5FFC
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 19:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F38971C20A93
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8188614C;
	Mon, 29 Apr 2024 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="biuj0VnZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A611F8626D
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 17:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411363; cv=none; b=lNK28zMGDyIsO/MZsK+a3EGjcSTwAae4eDFANT/UwsDp3juIEZR8LeJ6+wJ4IfnKuxgxb/XgXCYX5QwQe82cg6NXUim8LM8jGPH2EeQQcEM0Hw0LJ7evs9oQZ4ib/LVBU+kjbD8ueoWkRi+AKMo7wtFAw3cAAkhClZRMRZAcSCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411363; c=relaxed/simple;
	bh=NHM8mhvuqE2YmWujCBKfT2XQf8caVp3zgEgsvZBwXwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aPatCjxX9G4lxFNHmH2oyh+Ap4vzxkdBmhrigvxUmHXyZ9T9SksUQ5wQp6N1J6GTFKO0PNx9mOwW3kk6Pkfb3/jq2RoX96gwy898G0N+RfXkT3wEjx8Ir+HUNFRxgAuXBqKP/PMTueCn+BRv1nMcq6JAux9krZWHNXiWKb6cEdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=biuj0VnZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41c1b75ca31so11049125e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 10:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714411360; x=1715016160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bY9NtM4l1OUlmup1sFxlexRkXCme0fYBvyiSR54uwJA=;
        b=biuj0VnZ9cxFSPVM1jvP0zBA1IG0BpHpzFN2Y6rNP5eLapkUyx+BjszC71ZVY9I6zW
         6ioQrWnnxT7ujJ8//MfJNodvA1JcZ2lyVoFJEfEuwVnHFBV8LksdD3CuoZyN6UE0fCFl
         Qg4c1032Wo9Goka1VB0MnFCP2jXBGCCkeTkEC7QcjS0d+rpZn/MrnxLVA/ar/j32Yo4A
         zNKsTI6pd8RWa3hHHEZZXlMVq1vAXG4+PvtTl3pNVP7c5qAXOEr5F8fsJMja/XqPQd6H
         6MqPlej+gX7nad9H+fT5woVc8CvZVOvcc5e6or5ozRLjLGQ3ZryO3e49umICsGhxV4ZB
         L6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714411360; x=1715016160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bY9NtM4l1OUlmup1sFxlexRkXCme0fYBvyiSR54uwJA=;
        b=JosMBoGSQHjyHxtRB+P2bCNOV7MAnc8JWaDHGteWGQUgkzppuaD4xxfTotnraCGmmN
         p0UP1KXfKpsKI5QbbleTrBMuvH+j722UnI8STlD6yRhzNU5kgxciuJ/OGAm1rI6fNQ8Q
         ZVjeiLsohzO4JS5FUaDoegHbv6kARhPtXMCabMxC8gLeaRMBe/CAcTMhT6Zi2Yyq6EX4
         7SleaDzgNG2Ig17skTkYKtlxxu/mefuKp6HNeSivCtbNdnpZAPlulcyWNu2YvrQd+IPP
         kywG3mVp6Hx+5xiav9C3B62+zM7b+CHw9/nXYm5s1o/BmlNHmrWKjmpcWW7blHfwsKm6
         /HJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPzbuBd5aTPIl1sBizv7Dr0zt9EKZb9om06lKWZDnKZxbhYR8mVgeEcgwmo2xbNrWyN9v8q0L63sVxm7aozasKyoTx
X-Gm-Message-State: AOJu0YwUhcAeCn8cNB69inO8M9nlgqc5ZHr9Ug2QzCBjOH4nvqogzy6c
	qPkfdzT2aivq8/IsUEf0rySQv1I8O/jGh42kVEn1+d9+2HU1zO/IyNcZfBCT/S7ZuhXp1tbINTz
	EPL2/iHdoRd7bPU7tiBUOr31Qo3xj3Fy5x7eR
X-Google-Smtp-Source: AGHT+IGCQOtF9jLso2lkol5VLZ6yQYkPDXuv+nkVy3Uqk6k0o0pFj2M1Hhz9l2jvbx+cb4/CaRf5uRH4+eHXP3rlssA=
X-Received: by 2002:adf:e283:0:b0:349:8ae9:b01f with SMTP id
 v3-20020adfe283000000b003498ae9b01fmr8260906wri.1.1714411359816; Mon, 29 Apr
 2024 10:22:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307163541.92138-1-dmatlack@google.com> <ZiwWG4iHQYREwFP2@google.com>
In-Reply-To: <ZiwWG4iHQYREwFP2@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 29 Apr 2024 10:22:10 -0700
Message-ID: <CALzav=dyeNtDKW5-s=vGhWASbbxtBY4gkHKv_eqPnqavPfoa+g@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Mark a vCPU as preempted/ready iff it's scheduled
 out while running
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024 at 2:01=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Thu, Mar 07, 2024, David Matlack wrote:
> >
> > -     if (current->on_rq) {
> > +     if (current->on_rq && vcpu->wants_to_run) {
> >               WRITE_ONCE(vcpu->preempted, true);
> >               WRITE_ONCE(vcpu->ready, true);
> >       }
>
> Long story short, I was playing around with wants_to_run for a few hairbr=
ained
> ideas, and realized that there's a TOCTOU bug here.  Userspace can toggle
> run->immediate_exit at will, e.g. can clear it after the kernel loads it =
to
> compute vcpu->wants_to_run.
>
> That's not fatal for this use case, since userspace would only be shootin=
g itself
> in the foot, but it leaves a very dangerous landmine, e.g. if something e=
lse in
> KVM keys off of vcpu->wants_to_run to detect that KVM is in its run loop,=
 i.e.
> relies on wants_to_run being set if KVM is in its core run loop.
>
> To address that, I think we should have all architectures check wants_to_=
run, not
> immediate_exit.

Rephrasing to make sure I understand you correctly: It's possible for
KVM to see conflicting values of wants_to_run and immediate_exit,
since userspace can change immediate_exit at any point. e.g. It's
possible for KVM to see wants_to_run=3Dtrue and immediate_exit=3Dtrue,
which wouldn't make sense. This wouldn't cause any bugs today, but
could result in buggy behavior down the road so we might as well clean
it up now.

> And loading immediate_exit needs to be done with READ_ONCE().

+1, good point

>
> E.g. for x86 (every other arch has similar code)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e9ef1fa4b90b..1a2f6bf14fb2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11396,7 +11396,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
)
>
>         kvm_vcpu_srcu_read_lock(vcpu);
>         if (unlikely(vcpu->arch.mp_state =3D=3D KVM_MP_STATE_UNINITIALIZE=
D)) {
> -               if (kvm_run->immediate_exit) {
> +               if (!vcpu->wants_to_run) {
>                         r =3D -EINTR;
>                         goto out;
>                 }
> @@ -11474,7 +11474,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
)
>                 WARN_ON_ONCE(vcpu->mmio_needed);
>         }
>
> -       if (kvm_run->immediate_exit) {
> +       if (!vcpu->wants_to_run) {
>                 r =3D -EINTR;
>                 goto out;
>         }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f9b9ce0c3cd9..0c0aae224000 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1497,9 +1497,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_=
vcpu *vcpu,
>                                         struct kvm_guest_debug *dbg);
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
>
> -void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
> -
> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in);
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
>  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9501fbd5dfd2..4384bbdba65c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4410,7 +4410,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                                 synchronize_rcu();
>                         put_pid(oldpid);
>                 }
> -               vcpu->wants_to_run =3D !vcpu->run->immediate_exit;
> +               vcpu->wants_to_run =3D !READ_ONCE(vcpu->run->immediate_ex=
it);
>                 r =3D kvm_arch_vcpu_ioctl_run(vcpu);
>                 vcpu->wants_to_run =3D false;
>
>
> ---
>
> Hmm, and we should probably go a step further and actively prevent using
> immediate_exit from the kernel, e.g. rename it to something scary like:
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2190adbe3002..9c5fe1dae744 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -196,7 +196,11 @@ struct kvm_xen_exit {
>  struct kvm_run {
>         /* in */
>         __u8 request_interrupt_window;
> +#ifndef __KERNEL__
>         __u8 immediate_exit;
> +#else
> +       __u8 hidden_do_not_touch;
> +#endif

This would result in:

  vcpu->wants_to_run =3D !READ_ONCE(vcpu->run->hidden_do_not_touch);

:)

Of course we could pick a better name... but isn't every field in
kvm_run open to TOCTOU issues? (Is immediate_exit really special
enough to need this protection?)

