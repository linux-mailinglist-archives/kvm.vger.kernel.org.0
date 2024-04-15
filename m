Return-Path: <kvm+bounces-14681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 981AD8A5952
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 479DF1F23162
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D621327F8;
	Mon, 15 Apr 2024 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rdhugJFe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E884A48
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713202735; cv=none; b=qiy+94tmIoEN+wpzPMZOmukHMpoHn2Yb7gRBjIYOHIZ6MwlcrjtpYfpvwX9sCUWbMYxsLUHHSfWCWlkvb6WuV+/3jCrpSR42dTXgcKofkVYkrDM2u2lB47+avY2MdQfAiPTAVoSMqNUvz9wMHzyDCHDB+eaQUf2rJ5hyLb9/I1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713202735; c=relaxed/simple;
	bh=L22n2kCvTPK9XcI/4uS/HsKJEBXwSpUSzpEaXjfZhzc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t/57a3Xf8KQ6T6U/TWykJjK3QScPy/u8u9wp0XT1ROOMRUcZ8Gs0ta5y0fMqYz0Vip/4Vx9EToD3qzkTV/Wox7NPlbY4qxseJBru68pgkbBqaBW/CU1FG+yxdP6MM3y9C416spRpfjAlAD49Tn1sEJcm83v/pv1iVDue7YYY51Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rdhugJFe; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso2463754a12.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 10:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713202733; x=1713807533; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uwFH+Sl4Dup9217t0rj3A5vCbDNAQn+qKOR55rnIiUg=;
        b=rdhugJFevZpZvqqEI2o7hkRH8s11SqSNQDRaL2dCmtSe3DOB6CfNJPWC+8Y4fCqYXO
         kZ/GZiRLaReJT5We0T5oP9RR9rBRrAEG9si5a8F06fZc0w/fGL+bZ4EST15mh5oH5QwB
         KCJ0DKZr8zdohqjZoCVjiKlzxwWHRDH7qflSrUiym0dT22Y3UUs7NLE4aK+ws98AaKkz
         aYmedL7OFJNOZ2wv5/rFz70U5aHRNDQRUPJB0Lr4y9cxYIPcQc+cEf5FEsnSDkO1t/Gl
         hFhtLa0hZnL2+8MJiIUJdus7YlCyNJ76RyJ9pIFcN9t5n9iLliu630TiIJAXi9pfmEzo
         0h9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713202733; x=1713807533;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uwFH+Sl4Dup9217t0rj3A5vCbDNAQn+qKOR55rnIiUg=;
        b=EitFn3Eo2oKDfPv5BxX2XOGtPQarO8g0N44V3o3CWPpzGTB76S0ewCoZkiy+n/dDJo
         FIMGV8yrxxX42MiSKOqv0Z1dqUerlpk/eBmVR4+HuF8/jZPTNzG251Gw6Ewuesw1qcEy
         YRTEVn2ZZAJTr2QBp8bI13A/B6FmTVaNILTuln5Cx9McMwD1Fv9Q4SDC+lCdBklalVmp
         d6OhXuGtxDEr8q4rF2bjXPaNMtNqztkDWUvcS7WSD24/TrAfSUjkwBiepUIjeLG5x34I
         Txpn4PulwfppkL9Yl+EzDpzm83rk2WuWgbCwzkCIyP4o6M0KMPuqSJESToIjWZY9XwA8
         xZww==
X-Forwarded-Encrypted: i=1; AJvYcCXG2LCplQPfnvb/vZQKeOakWHQnoF46SgLLkxo8WAb3W+c0erXHpTKhAvfB8Npha+X/kswheeApN1CY5wXn/WS1Ebh6
X-Gm-Message-State: AOJu0YwweVZdILnlvg3hRCfXGTtvNuQmYMLSupA3zx9WcQah2CJTo3UH
	D4+YeKO3UQA/AOLtNNAZ8ShIocyyUHqKlzr1htZbjnhw9B2zYXPvyHdxGv8natjv5ud7kEKujUb
	b6w==
X-Google-Smtp-Source: AGHT+IFAloId2SLtV6JoxGQKYTsCZiTDpJiD55pzS4mF16K+I7cTwNvT5DGemB+vk09A1vwo4FoBOBPhjLY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6fc3:0:b0:5dc:4a5f:a5ee with SMTP id
 k186-20020a636fc3000000b005dc4a5fa5eemr844pgc.1.1713202732233; Mon, 15 Apr
 2024 10:38:52 -0700 (PDT)
Date: Mon, 15 Apr 2024 10:38:50 -0700
In-Reply-To: <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com> <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com> <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com> <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com> <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
Message-ID: <Zh1mKoHJcj22rKy8@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	pbonzini@redhat.com, peterz@infradead.org, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, jmattson@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> On Mon, Apr 15, 2024 at 3:04=E2=80=AFAM Mi, Dapeng <dapeng1.mi@linux.inte=
l.com> wrote:
> > On 4/15/2024 2:06 PM, Mingwei Zhang wrote:
> > > On Fri, Apr 12, 2024 at 9:25=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.=
intel.com> wrote:
> > >>>> It's necessary to clear the EVENTSELx MSRs for both GP and fixed c=
ounters.
> > >>>> Considering this case, Guest uses GP counter 2, but Host doesn't u=
se it. So
> > >>>> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would b=
e enabled
> > >>>> unexpectedly on host later since Host perf always enable all valid=
ate bits
> > >>>> in PERF_GLOBAL_CTRL MSR. That would cause issues.
> > >>>>
> > >>>> Yeah,  the clearing for PMCx MSR should be unnecessary .
> > >>>>
> > >>> Why is clearing for PMCx MSR unnecessary? Do we want to leaking cou=
nter
> > >>> values to the host? NO. Not in cloud usage.
> > >> No, this place is clearing the guest counter value instead of host
> > >> counter value. Host always has method to see guest value in a normal=
 VM
> > >> if he want. I don't see its necessity, it's just a overkill and
> > >> introduce extra overhead to write MSRs.
> > >>
> > > I am curious how the perf subsystem solves the problem? Does perf
> > > subsystem in the host only scrubbing the selector but not the counter
> > > value when doing the context switch?
> >
> > When context switch happens, perf code would schedule out the old event=
s
> > and schedule in the new events. When scheduling out, the ENABLE bit of
> > EVENTSELx MSR would be cleared, and when scheduling in, the EVENTSELx
> > and PMCx MSRs would be overwritten with new event's attr.config and
> > sample_period separately.  Of course, these is only for the case when
> > there are new events to be programmed on the PMC. If no new events, the
> > PMCx MSR would keep stall value and won't be cleared.
> >
> > Anyway, I don't see any reason that PMCx MSR must be cleared.
> >
>=20
> I don't have a strong opinion on the upstream version. But since both
> the mediated vPMU and perf are clients of PMU HW, leaving PMC values
> uncleared when transition out of the vPMU boundary is leaking info
> technically.

I'm not objecting to ensuring guest PMCs can't be read by any entity that's=
 not
in the guest's TCB, which is what I would consider a true leak.  I'm object=
ing
to blindly clearing all PMCs, and more specifically objecting to *KVM* clea=
ring
PMCs when saving guest state without coordinating with perf in any way.

I am ok if we start with (or default to) a "safe" implementation that zeroe=
s all
PMCs when switching to host context, but I want KVM and perf to work togeth=
er to
do the context switches, e.g. so that we don't end up with code where KVM w=
rites
to all PMC MSRs and that perf also immediately writes to all PMC MSRs.

One my biggest complaints with the current vPMU code is that the roles and
responsibilities between KVM and perf are poorly defined, which leads to su=
boptimal
and hard to maintain code.

Case in point, I'm pretty sure leaving guest values in PMCs _would_ leak gu=
est
state to userspace processes that have RDPMC permissions, as the PMCs might=
 not
be dirty from perf's perspective (see perf_clear_dirty_counters()).

Blindly clearing PMCs in KVM "solves" that problem, but in doing so makes t=
he
overall code brittle because it's not clear whether KVM _needs_ to clear PM=
Cs,
or if KVM is just being paranoid.

