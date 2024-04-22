Return-Path: <kvm+bounces-15541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBBE8AD302
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFED8B25420
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1251552EC;
	Mon, 22 Apr 2024 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KY1xfZkb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DCA15383C
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713805280; cv=none; b=Sn28kvsE36fmvCNvQyNE8CiHyGj5iApletYXCs/5kX7nmjJQaTvNE3Eb8ybmc/AmScIdqS9oPh7hASFyCvotvFTszrBfXNbasU6PE5VRuP9B/3jfy7GqWmoPskSYOgxVrV0QD1bLGEq+aoomW2NHQhaknAIMpQxOWs8tjgHbm4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713805280; c=relaxed/simple;
	bh=tFtTqcaa3UL3gUHgYz3SnGVDhY1APQClW8vbGEb5RYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q1qLM1if7OJAjXFy82tjvRMHAcliesJMU2XVXhOs9w6aA8MTR0uN5HwHlaFiZMUU5A/Txhiabc6/D+MWi1OnVJ7xdow3oe32+PAXnWMtOj1+GciMxEVBsGljKUOij5+przXzmChdbVKtqMuai5t0FUTPD92i3WPYkWYBb0GjlqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KY1xfZkb; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b4ede655aso33109017b3.0
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 10:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713805278; x=1714410078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FZ7fYvxgvMd9WAE1xHWyeLUfwlp+MDVvS9r+qsqhFSI=;
        b=KY1xfZkbOljrZD701zOJWld9owj3vpNIVLtoK3jsx4R6QSEOFXSA+3Fm19KCPKkuAl
         yFSSQHFoTQdM0WFL7D3/dtZqkm9hxOuYSJteP66JtE8GNllyI2zwF+m1kd9KFIdbPTQY
         YXRcuYFU8i1+k9vefruTbjuDmKrH1QvaT4FxKq0z+8+8KUW25apnuNfFw0rtJAsHK6Hz
         kKZ+gSanAGB1ZJ4YH/R44wluLCgC18bGpB6o72MNTMcaL+vi1AMvT+P0WB9eJOCR63BG
         dj08DB8VJ8tKKY37Wnt4U8DphFvdzA6ADMHa0Mz+rMcQEIb/Lf/kUOon2ciex1cUGaK+
         XzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713805278; x=1714410078;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FZ7fYvxgvMd9WAE1xHWyeLUfwlp+MDVvS9r+qsqhFSI=;
        b=FoM+XNJQkDO1T69aOeQhXmomPBqe/+KLu0PKJR53iAr/kXij0kvZBvHVciFNCNCUj2
         kxZSNXEHY5j1Su8jzLUqTS5XU4F1+qT9Hzs0W4pSM84+lUadj/aCp+6b+BZX/RQQAGDQ
         dZXL1vGmvVfwJB16O3+Kf4z3dcVge/imA5PpvLXptNHhS5wNctemKyi2BM1jweGhnXAp
         lJrhqZBS1y3Z2eYGhGHLzN3T40YSXO+keaVohXrmMZEEdpTT+iwtgfs0R9fq8e3L/jEj
         AO6QYdPMo41HDc9wnRm5tEQX5qqdV2DCaQANZjbSXB78UkP9xQLmyqQsyoB7Nrx4m2LQ
         g5Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXXZCUtOZgX+Zxuq5dC6D48xw5KKOTXsXMc4+EpYvZAvzI5yYPaLAXqhRnLZaVgNt1YdwGbQAwdTdmC5q8DW/MstRE1
X-Gm-Message-State: AOJu0Yyj2IgBqO4aCNXHLd8GJqrz4PSqUbdH2DzIyzN26vUOBAP0PGMr
	B6T6QZ+ywDEFcDijl1FImbeUxD0QDG1QdkUKxA1PTdT6JOKAAFKGAFQPQ6aezlIywzuccwUzTDZ
	1gg==
X-Google-Smtp-Source: AGHT+IHxPMIKb+cXXFc3JSk+qqDotC8cWUwgp6OnLCVbJKSb7mac0sVKwo0ojDibXTLNBvO5Jg4rAs0+vxA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d649:0:b0:615:80c8:94eb with SMTP id
 y70-20020a0dd649000000b0061580c894ebmr2287195ywd.10.1713805278077; Mon, 22
 Apr 2024 10:01:18 -0700 (PDT)
Date: Mon, 22 Apr 2024 10:01:16 -0700
In-Reply-To: <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com> <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com> <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com> <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
 <Zh2uFkfH8BA23lm0@google.com> <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
Message-ID: <ZiaX3H3YfrVh50cs@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Sean Christopherson <seanjc@google.com>
To: maobibo <maobibo@loongson.cn>
Cc: Mingwei Zhang <mizhang@google.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, peterz@infradead.org, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024, maobibo wrote:
> On 2024/4/16 =E4=B8=8A=E5=8D=886:45, Sean Christopherson wrote:
> > On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> > > On Mon, Apr 15, 2024 at 10:38=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > One my biggest complaints with the current vPMU code is that the ro=
les and
> > > > responsibilities between KVM and perf are poorly defined, which lea=
ds to suboptimal
> > > > and hard to maintain code.
> > > >=20
> > > > Case in point, I'm pretty sure leaving guest values in PMCs _would_=
 leak guest
> > > > state to userspace processes that have RDPMC permissions, as the PM=
Cs might not
> > > > be dirty from perf's perspective (see perf_clear_dirty_counters()).
> > > >=20
> > > > Blindly clearing PMCs in KVM "solves" that problem, but in doing so=
 makes the
> > > > overall code brittle because it's not clear whether KVM _needs_ to =
clear PMCs,
> > > > or if KVM is just being paranoid.
> > >=20
> > > So once this rolls out, perf and vPMU are clients directly to PMU HW.
> >=20
> > I don't think this is a statement we want to make, as it opens a discus=
sion
> > that we won't win.  Nor do I think it's one we *need* to make.  KVM doe=
sn't need
> > to be on equal footing with perf in terms of owning/managing PMU hardwa=
re, KVM
> > just needs a few APIs to allow faithfully and accurately virtualizing a=
 guest PMU.
> >=20
> > > Faithful cleaning (blind cleaning) has to be the baseline
> > > implementation, until both clients agree to a "deal" between them.
> > > Currently, there is no such deal, but I believe we could have one via
> > > future discussion.
> >=20
> > What I am saying is that there needs to be a "deal" in place before thi=
s code
> > is merged.  It doesn't need to be anything fancy, e.g. perf can still p=
ave over
> > PMCs it doesn't immediately load, as opposed to using cpu_hw_events.dir=
ty to lazily
> > do the clearing.  But perf and KVM need to work together from the get g=
o, ie. I
> > don't want KVM doing something without regard to what perf does, and vi=
ce versa.
> >=20
> There is similar issue on LoongArch vPMU where vm can directly pmu hardwa=
re
> and pmu hw is shard with guest and host. Besides context switch there are
> other places where perf core will access pmu hw, such as tick
> timer/hrtimer/ipi function call, and KVM can only intercept context switc=
h.

Two questions:

 1) Can KVM prevent the guest from accessing the PMU?

 2) If so, KVM can grant partial access to the PMU, or is it all or nothing=
?

If the answer to both questions is "yes", then it sounds like LoongArch *re=
quires*
mediated/passthrough support in order to virtualize its PMU.

> Can we add callback handler in structure kvm_guest_cbs?  just like this:
> @@ -6403,6 +6403,7 @@ static struct perf_guest_info_callbacks kvm_guest_c=
bs
> =3D {
>         .state                  =3D kvm_guest_state,
>         .get_ip                 =3D kvm_guest_get_ip,
>         .handle_intel_pt_intr   =3D NULL,
> +       .lose_pmu               =3D kvm_guest_lose_pmu,
>  };
>=20
> By the way, I do not know should the callback handler be triggered in per=
f
> core or detailed pmu hw driver. From ARM pmu hw driver, it is triggered i=
n
> pmu hw driver such as function kvm_vcpu_pmu_resync_el0,
> but I think it will be better if it is done in perf core.

I don't think we want to take the approach of perf and KVM guests "fighting=
" over
the PMU.  That's effectively what we have today, and it's a mess for KVM be=
cause
it's impossible to provide consistent, deterministic behavior for the guest=
.  And
it's just as messy for perf, which ends up having wierd, cumbersome flows t=
hat
exists purely to try to play nice with KVM.

