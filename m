Return-Path: <kvm+bounces-52603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A33B0719E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A10C1625D9
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027FB2F0E49;
	Wed, 16 Jul 2025 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWQQgYbw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FEE291C0B;
	Wed, 16 Jul 2025 09:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752658082; cv=none; b=XKC2mrzi8t9NGA+EjJPl/5/d3mHDLHrzHxUlGviEDBZJ+SEbhkrPw+IZNC6YZ9/+16e2UWcaHMpx/pA7ltAR6GjtjBzV4iJIru1R55Qr9Gc9rtRrdVPPvRKoG3vphlBD1rP9gyl6Yf2J44a+xvRG8lu3J5QPzSdk3++NpXkQB04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752658082; c=relaxed/simple;
	bh=/ooNibycT6Ptl/l+d9wY9QftFzDnh8lZ2fneZVt1FJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqFq3UQOiRQLcJXHc/IkIlHh6z2jzS41tM6spA4b787dpwAp5cxfcLvnZChkzxDEBQPsYwjv2KgG7ZnsLqtWnj2yiCr1EjN8HWReBBjGQR7SG+0D3HZj+u5EyCv4pKsuSnYwqZjfhg4Ga/IO/jpt5KdpPqRmJoFfetLgCWhgQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWQQgYbw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7406C4CEF0;
	Wed, 16 Jul 2025 09:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752658081;
	bh=/ooNibycT6Ptl/l+d9wY9QftFzDnh8lZ2fneZVt1FJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LWQQgYbw74g1N9ak3YE5xW4qWaeR1NmJdowSCUL1bmSKkkeJGvvHB0XzLb0NN2n/e
	 PSB4+yGl88CRni4hGmDRT9fJ360DSm/jHWF8hEQtTIIBtn1IaRob6t96XPjX+caLv3
	 5K0HieqTvR6LjZD+hRL9XwC57pBapOSfnHBIunUv4gQzNwJ87k/UENP5rTyeKMdwUe
	 kouQiU1yiLzM+a+mdOYoPYd/eNgZoCEwC2U4/tbuu7iFVz3YZ3kBF+Tx6fYP7Dyb33
	 mzOzFiaZj34iK2N9ywAHzCNcDIJ3isEx8haCKQKkdV8lfKdw0wnWmg2usKO8VL3s5p
	 nrVbieQc1PLOg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-608acb0a27fso8975221a12.0;
        Wed, 16 Jul 2025 02:28:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVzj/YGbKr6keieKHzzbHGYNjsrI3VRacAaVYBo2Ztbvh6QRxQTrnoxRdTrVstf1Y16Nm4=@vger.kernel.org, AJvYcCWY2rLL8SGkcxOK4d/3AF9bpYL7gePSFyngbDnhHcjS3ZypCQeqbSAwsNza3rUhBnm9zEw6eFvsVnre5jad@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx3kLd0rgteCCs8EGgsuzMsJ0SwXplxfaCVTBfMFj9l/imY5G3
	yMja/Tux4s8sBhYcKR2ncdH5f1Q+aByO0IhU5YZfLFp9NgHgpNaztVWe1o+Ive7iaLA1kpZ+Ljz
	7sxODA5RCFUQ8JJHFxco/SGTYg6iur3I=
X-Google-Smtp-Source: AGHT+IE3+olCTWk70P4IwLbkQxcU5HqWybKxI8NHr0VQQ7alAGumsr+W1LKSTysDG5mfqU3m9HTc3rO/ag112PxRcww=
X-Received: by 2002:a05:6402:254f:b0:607:f558:e328 with SMTP id
 4fb4d7f45d1cf-6128592c9c1mr1586433a12.5.1752658080243; Wed, 16 Jul 2025
 02:28:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250702105922.1035771-1-wheatfox17@icloud.com> <9e9b54fe-4762-f128-a53f-1a92d160a5b7@loongson.cn>
In-Reply-To: <9e9b54fe-4762-f128-a53f-1a92d160a5b7@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 16 Jul 2025 17:27:49 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6B7Nd4jqVO-wM9JRgf0cqfhPMZwMM6kzcf0wdBC+RUcA@mail.gmail.com>
X-Gm-Features: Ac12FXzKrhACmL1IlFIBdPr7sv-aWNl5P4xDx2j6WE03-C5BgTbnN1goNn5F1-8
Message-ID: <CAAhV-H6B7Nd4jqVO-wM9JRgf0cqfhPMZwMM6kzcf0wdBC+RUcA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add tracepoints for CPUCFG and CSR
 emulation exits
To: Bibo Mao <maobibo@loongson.cn>
Cc: Yulong Han <wheatfox17@icloud.com>, kernel@xen0n.name, zhaotianrui@loongson.cn, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.


Huacai

On Mon, Jul 7, 2025 at 11:30=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> On 2025/7/2 =E4=B8=8B=E5=8D=886:59, Yulong Han wrote:
> > This patch adds tracepoints to track KVM exits caused by CPUCFG
> > and CSR emulation. Note that IOCSR emulation tracing is already
> > covered by the generic trace_kvm_iocsr().
> >
> > Signed-off-by: Yulong Han <wheatfox17@icloud.com>
> > ---
> >   arch/loongarch/kvm/exit.c  |  2 ++
> >   arch/loongarch/kvm/trace.h | 14 +++++++++++++-
> >   2 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> > index fa52251b3bf1c..6a47a23ae9cd6 100644
> > --- a/arch/loongarch/kvm/exit.c
> > +++ b/arch/loongarch/kvm/exit.c
> > @@ -289,9 +289,11 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *v=
cpu)
> >       er =3D EMULATE_FAIL;
> >       switch (((inst.word >> 24) & 0xff)) {
> >       case 0x0: /* CPUCFG GSPR */
> > +             trace_kvm_exit_cpucfg(vcpu, KVM_TRACE_EXIT_CPUCFG);
> >               er =3D kvm_emu_cpucfg(vcpu, inst);
> >               break;
> >       case 0x4: /* CSR{RD,WR,XCHG} GSPR */
> > +             trace_kvm_exit_csr(vcpu, KVM_TRACE_EXIT_CSR);
> >               er =3D kvm_handle_csr(vcpu, inst);
> >               break;
> >       case 0x6: /* Cache, Idle and IOCSR GSPR */
> > diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
> > index 1783397b1bc88..145514dab6d5b 100644
> > --- a/arch/loongarch/kvm/trace.h
> > +++ b/arch/loongarch/kvm/trace.h
> > @@ -46,11 +46,15 @@ DEFINE_EVENT(kvm_transition, kvm_out,
> >   /* Further exit reasons */
> >   #define KVM_TRACE_EXIT_IDLE         64
> >   #define KVM_TRACE_EXIT_CACHE                65
> > +#define KVM_TRACE_EXIT_CPUCFG                66
> > +#define KVM_TRACE_EXIT_CSR           67
> >
> >   /* Tracepoints for VM exits */
> >   #define kvm_trace_symbol_exit_types                 \
> >       { KVM_TRACE_EXIT_IDLE,          "IDLE" },       \
> > -     { KVM_TRACE_EXIT_CACHE,         "CACHE" }
> > +     { KVM_TRACE_EXIT_CACHE,         "CACHE" },      \
> > +     { KVM_TRACE_EXIT_CPUCFG,        "CPUCFG" },     \
> > +     { KVM_TRACE_EXIT_CSR,           "CSR" }
> >
> >   DECLARE_EVENT_CLASS(kvm_exit,
> >           TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> > @@ -82,6 +86,14 @@ DEFINE_EVENT(kvm_exit, kvm_exit_cache,
> >            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> >            TP_ARGS(vcpu, reason));
> >
> > +DEFINE_EVENT(kvm_exit, kvm_exit_cpucfg,
> > +          TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> > +          TP_ARGS(vcpu, reason));
> > +
> > +DEFINE_EVENT(kvm_exit, kvm_exit_csr,
> > +          TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> > +          TP_ARGS(vcpu, reason));
> > +
> >   DEFINE_EVENT(kvm_exit, kvm_exit,
> >            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> >            TP_ARGS(vcpu, reason));
> >
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>

