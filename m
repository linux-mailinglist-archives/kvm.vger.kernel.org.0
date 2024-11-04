Return-Path: <kvm+bounces-30434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C37929BAAC6
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 03:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF8DFB20DC1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 02:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5897616C687;
	Mon,  4 Nov 2024 02:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0U+9dyh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1E37603F;
	Mon,  4 Nov 2024 02:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730686912; cv=none; b=apQ8iBl9kuFPTPeyQeoP5kBF80jH0q2hASVHxcDLruue3PSODbbHXSerxdkU9cCj4I8b2Nhtq4oGag84BNQsn7IjnIkdUZqsfvZRgPuqeZ7biKsuBwP9c00+gbzS1ZmcQvCLi3b0qV9LCMQlmxd57rPwjrjIi94Q66e6SrNw0hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730686912; c=relaxed/simple;
	bh=1tcggB/GHix8frE72Yp+mCAP/HIONKZbEjU2qKYxPC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+KmNSAKfVZmtMi0waIUV+WfCJkwigm9OLPWlVvjqUCLwjg4bXHmn0dZGlQh81hMQS/JEhMJuaPYU+fjuvyO4bxHZIPLHI63cwZ6Bc34ekEsWHJmez0j0/2NqTw8LLhedE4xUH342BsblygoqPXfJJf0EZBPodeR4xbW0dcOJro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0U+9dyh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC10C4AF09;
	Mon,  4 Nov 2024 02:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730686912;
	bh=1tcggB/GHix8frE72Yp+mCAP/HIONKZbEjU2qKYxPC4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=H0U+9dyhjvx0nwrhweIMrtw69s/iyKOiCCGBrJ2GVxvt1jeksTpdjKdCA6zKbP1cn
	 1idFD/onQW3Om/lrKSSpNQVvxO1XQTBhnR8VIA0ol4lMU+dSJjKsFkjpNxA1KS+Bp7
	 QDKAx5jM4e3G7hkQTcnrJG1OpE+DxSKdcm7CDoQ+gqCUe21ak3FUEGWeSVUg7qXkCq
	 JZb7qcsyNDfhOgZWqyUn+aPWy8KIu4qIJCjI7riHHUOYmi7HccwnEnGX97xwU2TzHd
	 InX6VY8b4ebptis6y9rrimlfQCSexlf6J7CWmSPumqaFNo76V2A3SEENU7woXV5fBz
	 VcmLXtvCg8HHg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a3dc089d8so629853666b.3;
        Sun, 03 Nov 2024 18:21:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU/nIUzMtQVAW+cKViE+xAEeX7+4Q6qtGZAQDbFNsIyCr/4831Uh2f5TsNifFRCtsHJRwC02STRG+kB5m6W@vger.kernel.org, AJvYcCX0mU508gLtlujG1oG+iW4WBX8j3Vn3B5bcceZxKlbbCV6rRt3SvVtv7wtsgg6z10vIqaE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2aupoiNPbKwN/HykJsdUTWoyND340+CJLpfVDkphCMk140odO
	LMhZ5KrCJ0qEyjmD/QvoW2F25ZzdFbDDu6pmkwZBpUC8luUTA+f/EIZZCCApGgg9I+qQHj3pgzf
	N0awDqaNWNdZqCVRK+f3JlifdXJk=
X-Google-Smtp-Source: AGHT+IGVRk4kNX2sK07GgPWmR05AatJnpVg09BYrcls4Sf4y/EcEbjEgl3o85bto2nxYgIGRqyuNmvbmmEm5trXqa0g=
X-Received: by 2002:a17:907:3d8f:b0:a99:4a8f:c83f with SMTP id
 a640c23a62f3a-a9e65490cdcmr1178297566b.5.1730686910626; Sun, 03 Nov 2024
 18:21:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240815071545.925867-1-maobibo@loongson.cn> <20240815071545.925867-2-maobibo@loongson.cn>
 <3e88f855-5edc-9416-0348-ea16cd860a1f@loongson.cn>
In-Reply-To: <3e88f855-5edc-9416-0348-ea16cd860a1f@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 4 Nov 2024 10:21:40 +0800
X-Gmail-Original-Message-ID: <CAAhV-H44ph_XhEtKDvoHQK2pqm3Bj1AMHm_mOWMnvWk94sdgCQ@mail.gmail.com>
Message-ID: <CAAhV-H44ph_XhEtKDvoHQK2pqm3Bj1AMHm_mOWMnvWk94sdgCQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] LoongArch: Fix AP booting issue in VM mode
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 9:34=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote=
:
>
> ping.
Queued, thanks.

Huacai

>
>
> On 2024/8/15 =E4=B8=8B=E5=8D=883:15, Bibo Mao wrote:
> > Native IPI is used for AP booting, it is booting interface between
> > OS and BIOS firmware. The paravirt ipi is only used inside OS, native
> > IPI is necessary to boot AP.
> >
> > When booting AP, BP writes kernel entry address in the HW mailbox of
> > AP and send IPI interrupt to AP. AP executes idle instruction and
> > waits for interrupt or SW events, and clears IPI interrupt and jumps
> > to kernel entry from HW mailbox.
> >
> > Between BP writes HW mailbox and is ready to send IPI to AP, AP is woke=
n
> > up by SW events and jumps to kernel entry, so ACTION_BOOT_CPU IPI
> > interrupt will keep pending during AP booting. And native IPI interrupt
> > handler needs be registered so that it can clear pending native IPI, el=
se
> > there will be endless IRQ handling during AP booting stage.
> >
> > Here native ipi interrupt is initialized even if paravirt IPI is used.
> >
> > Fixes: 74c16b2e2b0c ("LoongArch: KVM: Add PV IPI support on guest side"=
)
> >
> > Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> > ---
> >   arch/loongarch/kernel/paravirt.c | 19 +++++++++++++++++++
> >   1 file changed, 19 insertions(+)
> >
> > diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/p=
aravirt.c
> > index 9c9b75b76f62..348920b25460 100644
> > --- a/arch/loongarch/kernel/paravirt.c
> > +++ b/arch/loongarch/kernel/paravirt.c
> > @@ -13,6 +13,9 @@ static int has_steal_clock;
> >   struct static_key paravirt_steal_enabled;
> >   struct static_key paravirt_steal_rq_enabled;
> >   static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64=
);
> > +#ifdef CONFIG_SMP
> > +static struct smp_ops old_ops;
> > +#endif
> >
> >   static u64 native_steal_clock(int cpu)
> >   {
> > @@ -55,6 +58,11 @@ static void pv_send_ipi_single(int cpu, unsigned int=
 action)
> >       int min, old;
> >       irq_cpustat_t *info =3D &per_cpu(irq_stat, cpu);
> >
> > +     if (unlikely(action =3D=3D ACTION_BOOT_CPU)) {
> > +             old_ops.send_ipi_single(cpu, action);
> > +             return;
> > +     }
> > +
> >       old =3D atomic_fetch_or(BIT(action), &info->message);
> >       if (old)
> >               return;
> > @@ -71,6 +79,12 @@ static void pv_send_ipi_mask(const struct cpumask *m=
ask, unsigned int action)
> >       __uint128_t bitmap =3D 0;
> >       irq_cpustat_t *info;
> >
> > +     if (unlikely(action =3D=3D ACTION_BOOT_CPU)) {
> > +             /* Use native IPI to boot AP */
> > +             old_ops.send_ipi_mask(mask, action);
> > +             return;
> > +     }
> > +
> >       if (cpumask_empty(mask))
> >               return;
> >
> > @@ -141,6 +155,8 @@ static void pv_init_ipi(void)
> >   {
> >       int r, swi;
> >
> > +     /* Init native ipi irq since AP booting uses it */
> > +     old_ops.init_ipi();
> >       swi =3D get_percpu_irq(INT_SWI0);
> >       if (swi < 0)
> >               panic("SWI0 IRQ mapping failed\n");
> > @@ -179,6 +195,9 @@ int __init pv_ipi_init(void)
> >               return 0;
> >
> >   #ifdef CONFIG_SMP
> > +     old_ops.init_ipi        =3D mp_ops.init_ipi;
> > +     old_ops.send_ipi_single =3D mp_ops.send_ipi_single;
> > +     old_ops.send_ipi_mask   =3D mp_ops.send_ipi_mask;
> >       mp_ops.init_ipi         =3D pv_init_ipi;
> >       mp_ops.send_ipi_single  =3D pv_send_ipi_single;
> >       mp_ops.send_ipi_mask    =3D pv_send_ipi_mask;
> >
>
>

