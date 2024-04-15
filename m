Return-Path: <kvm+bounces-14699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B279D8A5DCB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 00:45:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12D41283463
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 22:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F57A1586F3;
	Mon, 15 Apr 2024 22:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8o3MDkP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48013AA47
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 22:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713221146; cv=none; b=mY6o+4BvzawGwc2dI2xIRN39XTJqiZQjxLru7XRPf0FGeN3sfdaDy8QGOip+YpHVElgwJcRVhVuBJpF6z9YDfQ6+HqsOpU1bYsohBhNZY93UFNhCgYErXn9hYCu7FndxDnxQnUgZeZ/jVapjawDMnI06BE2jemo2TKOehlkzpBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713221146; c=relaxed/simple;
	bh=NdkNiga89MPA5JtPx7h8+p/Mmvr1IGbB5uTLd53WSKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WrFwuggBxst+xmrhcgIMgfPLcnZ9Pk/MyMWvl2wTE7lIJlS2ftmMvI43RQELDNpzbEtU0BAbNee687bIsn6kWvsqtYQzIwD+qdBM6AktE+SWXKfWmKfjGFXOb1xOn2tVZ5jBcnerSGjxrSqBFTOorfTx6jqupbfQHQbZzaKmxEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8o3MDkP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61aecbcb990so4283967b3.1
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 15:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713221144; x=1713825944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AcLghFDaZvqvUFg0UJfSdHpX3MrK3jZqKyMZa6gZF4M=;
        b=N8o3MDkPDxJcREVd15RAHsp4rkFb76HEKiJf8II4sSJLClaOYVmT/CXuVfcsbpO2nh
         UVjmHITd3wGLlyTIc86y9vwaZIrn4EnSf2tl6ltX6BEtp1mTqglpDVPvv0JAvVdZE2kU
         8TFZBzxrwZbLMcHyCdFKEaQmjd7mJXcFs38UJHLDZftYEFOwZxudVpVbxQnwgKunCaUn
         SHVbMKalO5n6iXUSw5Ge5HvxaHs6LTSmArRjRxkBhnrAmbdlXxNNuetKVKxQ/pVRqoT/
         Ld+4PbvGQw8LqgTNyikksTx2QwMO4jiS6nhk0dF8BhrNYvL/IEmaWBDSM/CFa9DlJU1Q
         5ayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713221144; x=1713825944;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AcLghFDaZvqvUFg0UJfSdHpX3MrK3jZqKyMZa6gZF4M=;
        b=RS6fm8QVQSOgD3Jyc8Vzhi1BtFvZCvw+8fgTxtTFky9wrt9u8BXYUhjM6Q3YEprldK
         pH9orXIxnfeZ6UixCr00e8LoNED6eUKDigNE4tT0Axf1Nf82RwBmTQqPH3nhFnUhhrFc
         VFplz9IdcyRiMpFYHkgpe6k3XApNtrTPeagycFKY3H1Z+umMPV/TBwrxzozup4DJacz+
         VFcFcXN6H1iTq7CFPfZmcd6ddLdBfEe+QfgTb6jUHif5ELk/J90oLffmVe5yCh0USu7k
         olSwG4HFX+AfYvQSYr8P48Uq9jPTHYgmaP/12rmvPjMVreNAnv1VNVKNSdzaiu4O/3rP
         iMYA==
X-Forwarded-Encrypted: i=1; AJvYcCXuDt1HwXQEGpAm0qeCWkIb7S4HPJ5f6UnZfzhYSuGHVWHe+Q563u5oa9ATyQOWLbrdTLOksu7L//qMFl0cKpMusbtp
X-Gm-Message-State: AOJu0YyVwYNGMG2SQhi0yBRaNTByYAQzurp/6ljyAfHkc/ttkVZ1jITr
	zLp4BeXR364qiyii6zpJC+AcqkJXIfO94QchgGW2BfzA0Ub5hTkmdOvwXUpsMIT5J7+svyTlP3z
	WRA==
X-Google-Smtp-Source: AGHT+IHIupi0Fg0bltpgOwUNtSrEqGQTtyEncw+MiPr4mUztOCh+pX1opwxL4LzkeINH0sJ4gYv4zQX3IEw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:eace:0:b0:61a:d9f8:e397 with SMTP id
 t197-20020a0deace000000b0061ad9f8e397mr721563ywe.3.1713221144309; Mon, 15 Apr
 2024 15:45:44 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:45:42 -0700
In-Reply-To: <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com> <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com> <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com> <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com> <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
Message-ID: <Zh2uFkfH8BA23lm0@google.com>
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
> On Mon, Apr 15, 2024 at 10:38=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > One my biggest complaints with the current vPMU code is that the roles =
and
> > responsibilities between KVM and perf are poorly defined, which leads t=
o suboptimal
> > and hard to maintain code.
> >
> > Case in point, I'm pretty sure leaving guest values in PMCs _would_ lea=
k guest
> > state to userspace processes that have RDPMC permissions, as the PMCs m=
ight not
> > be dirty from perf's perspective (see perf_clear_dirty_counters()).
> >
> > Blindly clearing PMCs in KVM "solves" that problem, but in doing so mak=
es the
> > overall code brittle because it's not clear whether KVM _needs_ to clea=
r PMCs,
> > or if KVM is just being paranoid.
>=20
> So once this rolls out, perf and vPMU are clients directly to PMU HW.

I don't think this is a statement we want to make, as it opens a discussion
that we won't win.  Nor do I think it's one we *need* to make.  KVM doesn't=
 need
to be on equal footing with perf in terms of owning/managing PMU hardware, =
KVM
just needs a few APIs to allow faithfully and accurately virtualizing a gue=
st PMU.

> Faithful cleaning (blind cleaning) has to be the baseline
> implementation, until both clients agree to a "deal" between them.
> Currently, there is no such deal, but I believe we could have one via
> future discussion.

What I am saying is that there needs to be a "deal" in place before this co=
de
is merged.  It doesn't need to be anything fancy, e.g. perf can still pave =
over
PMCs it doesn't immediately load, as opposed to using cpu_hw_events.dirty t=
o lazily
do the clearing.  But perf and KVM need to work together from the get go, i=
.e. I
don't want KVM doing something without regard to what perf does, and vice v=
ersa.

