Return-Path: <kvm+bounces-14682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83BAD8A596D
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39A8428577D
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BB113A3F0;
	Mon, 15 Apr 2024 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wzuL4wO7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD7E85925
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713203695; cv=none; b=ID2ksi4Z9RNQG02fg/C20zlR6Lwk1SWNxPGh5Y82b6sHuZzWLt80KBA9kcLqiv5blOiLxS35DEig9g5/P/nYoJlRr/CU8PNCWb/5DW0hx1G52FxsiBJg9armfLX+Ww4Imk3dQ7ZKGq8kABIjyAFxQ2HbvjLGfsR77+G5o4gXjig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713203695; c=relaxed/simple;
	bh=Wr/pDR3d/zKmmnQccwLePNG5XdVvSksoQYryiRcRuKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kzf+VFmPov+NvoRRix7ktDwheKVmq0sTfLsQH5+/kYlJReRkRp6PFchWp+69ZcoqlAingeGoVG2GQCBMlF7mYc1HTlOE2y48fgr1A2C4/z4Tbm/XVijzkq6Hxc11KIv34/0iEcwoYKIQ0hegwwtD+KJtBpVVutIwQEhJM0s5Zqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wzuL4wO7; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d82713f473so60755641fa.3
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 10:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713203692; x=1713808492; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igNYJ1pXewB6u5NzWIC4GeGY+3kLjUQqImaU0uTKues=;
        b=wzuL4wO7SvIb9fYmQlgYKC1GZYZ1jTAlcOHvwfjDLD8pfOjeBdKD/els/eaAi4IXYI
         fs4nPZW9/lrhCT/egvAGGuouuasq6jWlVZDG8evznD+6d4N+sth5tAoY/ifMBVipg3VK
         raDcOrSciN3gtdIA2Y4tZBDu4cCZQ0Fgxo/A2dNOQ25mgpZv4F9Dk/SkUOHpuJkZk3l+
         resMrYqLCooXCqgOE6jvOJpbbruMrYr5x+wpbJlCaDdjQ1pUpEun1eD9ctH2BirICWZu
         kj1f1/7bxkWH5/8UHGF+lfQC16ogM0lGQwEB6mS+oUt+HXkmcRAZsCpnjGokY+2rI+69
         rXTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713203692; x=1713808492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=igNYJ1pXewB6u5NzWIC4GeGY+3kLjUQqImaU0uTKues=;
        b=uvhl06xBWG+Mfv7syqvKf7SeysbxFQD5HbyQhBekA50ivpYhU44CHxPyC+2p/aJgwC
         6rsG4rxMoGMV4qnqCzdcbhFhvaXfnoVFrbtMPEA7/TDQj1KhFQgIB4l6m/a6Hk0jtWc0
         fymsdEDRNvNSA9bfw760fC1/eunox1gwEJZahMjjKbRLlkzZ5QfwIwBYxSxil9HcQkT1
         vOqh6HmLTugdsDAU9loSLguaOsLzuaT8MtN55aATGiUBxdn9QAbshUs4/GWQTT2IQ7lt
         J6c6I/PswS0hyaB71nxmEoZ8Pn5c2m1I34+eJzyaElJwuMtyYsorNDxg6yndf2XUKX/9
         zBiw==
X-Forwarded-Encrypted: i=1; AJvYcCXr0eYTi+BYDnfhH203A4bi76ztUwkDYO12/JFkgOk+dABsjgHat/m7DOup529VRpJO7NvArP33ZJwHFm6TprfUaYWG
X-Gm-Message-State: AOJu0YyEnQmcyyc1urRj6Qk64ONbgaKmvAq1xz2ZimRvWiQKbTqlyDBX
	iL5z/x2vFfvGYN2p01sror/c7AhRqcHInstN48NNctrZ/NXkyy01bVUDD6AESWrsZ8xSzTrkvgb
	FZW/HX7PvRmCHJsXWtY3WlaZFy+EoE2BJurLo
X-Google-Smtp-Source: AGHT+IEGZ/QSN12QZ3Kvtifco1R7sEnyXPpjjrkwzoC0qp0JYVVV1PbYsE8fokyGM6XWM+LBozUeUxtGGTYsfAcg+5w=
X-Received: by 2002:a05:651c:623:b0:2da:16fd:5c9b with SMTP id
 k35-20020a05651c062300b002da16fd5c9bmr7081458lje.9.1713203691518; Mon, 15 Apr
 2024 10:54:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com> <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com> <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com> <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com> <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com>
In-Reply-To: <Zh1mKoHJcj22rKy8@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Mon, 15 Apr 2024 10:54:15 -0700
Message-ID: <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	pbonzini@redhat.com, peterz@infradead.org, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, jmattson@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 10:38=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> > On Mon, Apr 15, 2024 at 3:04=E2=80=AFAM Mi, Dapeng <dapeng1.mi@linux.in=
tel.com> wrote:
> > > On 4/15/2024 2:06 PM, Mingwei Zhang wrote:
> > > > On Fri, Apr 12, 2024 at 9:25=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linu=
x.intel.com> wrote:
> > > >>>> It's necessary to clear the EVENTSELx MSRs for both GP and fixed=
 counters.
> > > >>>> Considering this case, Guest uses GP counter 2, but Host doesn't=
 use it. So
> > > >>>> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would=
 be enabled
> > > >>>> unexpectedly on host later since Host perf always enable all val=
idate bits
> > > >>>> in PERF_GLOBAL_CTRL MSR. That would cause issues.
> > > >>>>
> > > >>>> Yeah,  the clearing for PMCx MSR should be unnecessary .
> > > >>>>
> > > >>> Why is clearing for PMCx MSR unnecessary? Do we want to leaking c=
ounter
> > > >>> values to the host? NO. Not in cloud usage.
> > > >> No, this place is clearing the guest counter value instead of host
> > > >> counter value. Host always has method to see guest value in a norm=
al VM
> > > >> if he want. I don't see its necessity, it's just a overkill and
> > > >> introduce extra overhead to write MSRs.
> > > >>
> > > > I am curious how the perf subsystem solves the problem? Does perf
> > > > subsystem in the host only scrubbing the selector but not the count=
er
> > > > value when doing the context switch?
> > >
> > > When context switch happens, perf code would schedule out the old eve=
nts
> > > and schedule in the new events. When scheduling out, the ENABLE bit o=
f
> > > EVENTSELx MSR would be cleared, and when scheduling in, the EVENTSELx
> > > and PMCx MSRs would be overwritten with new event's attr.config and
> > > sample_period separately.  Of course, these is only for the case when
> > > there are new events to be programmed on the PMC. If no new events, t=
he
> > > PMCx MSR would keep stall value and won't be cleared.
> > >
> > > Anyway, I don't see any reason that PMCx MSR must be cleared.
> > >
> >
> > I don't have a strong opinion on the upstream version. But since both
> > the mediated vPMU and perf are clients of PMU HW, leaving PMC values
> > uncleared when transition out of the vPMU boundary is leaking info
> > technically.
>
> I'm not objecting to ensuring guest PMCs can't be read by any entity that=
's not
> in the guest's TCB, which is what I would consider a true leak.  I'm obje=
cting
> to blindly clearing all PMCs, and more specifically objecting to *KVM* cl=
earing
> PMCs when saving guest state without coordinating with perf in any way.
>
> I am ok if we start with (or default to) a "safe" implementation that zer=
oes all
> PMCs when switching to host context, but I want KVM and perf to work toge=
ther to
> do the context switches, e.g. so that we don't end up with code where KVM=
 writes
> to all PMC MSRs and that perf also immediately writes to all PMC MSRs.

I am fully aligned with you on this.

>
> One my biggest complaints with the current vPMU code is that the roles an=
d
> responsibilities between KVM and perf are poorly defined, which leads to =
suboptimal
> and hard to maintain code.
>
> Case in point, I'm pretty sure leaving guest values in PMCs _would_ leak =
guest
> state to userspace processes that have RDPMC permissions, as the PMCs mig=
ht not
> be dirty from perf's perspective (see perf_clear_dirty_counters()).
>
> Blindly clearing PMCs in KVM "solves" that problem, but in doing so makes=
 the
> overall code brittle because it's not clear whether KVM _needs_ to clear =
PMCs,
> or if KVM is just being paranoid.

So once this rolls out, perf and vPMU are clients directly to PMU HW.
Faithful cleaning (blind cleaning) has to be the baseline
implementation, until both clients agree to a "deal" between them.
Currently, there is no such deal, but I believe we could have one via
future discussion.

Thanks.
-Mingwei

