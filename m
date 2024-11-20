Return-Path: <kvm+bounces-32188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 578369D40E2
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE302B2A9EC
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DEBD15666B;
	Wed, 20 Nov 2024 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XHkhp6ki"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CD0149C4D
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732122393; cv=none; b=kNURgZW4lVvZCTzCvuk8FCZKw17z8Luum6LMekay8BaiPnPIYZf5pAxF9dWQGU6Pu2231WXUyEtXUCV1xjBhJLKWyILXM7dhNzJ4mVa6/xwWj+xwGINUghUcSeAQmNo+EUwc4qhLrEfZ8MNpV1JPqhLtrImyJJ5D9i7i6D69WK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732122393; c=relaxed/simple;
	bh=MN358yeAgMetR0+Jtkzwlffo/NhqEIxEzYW1pEwgFXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L2Qmvlhv+gOcZpKB26HF2iq6s9BnJbeAQiOCt7GsYyEHIGwUXQPy2ELGeqOP58KaN0D1uIWHY6sQphk0N/ipTiMOOUPA5oSaeuRPsAINi9twJvHvcgEPhW2ekOKtwhGOcA60469R959Zfpys+rzmFgifWyG0xvD7ie7gLIBVRQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XHkhp6ki; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ee7ccc0283so74395157b3.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 09:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732122390; x=1732727190; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=72KAuCGZk9dkQwE4EPXEULor/zpraUF3cNKJPF7sOZE=;
        b=XHkhp6kiTM155V/eJavlTDnHL7LzZHJQ4HcuKqgz4HLmtTaqsLb1cfUvpNpJOctLbv
         2GZYP/FxGuDB8aTu8yLnJTGA6MieJtlEmw/uCQLXUPhR2m/VhqmTZQI4SqUqyp9JzLGo
         FkCbMGIa84QPFAU/Kg/F3s8kOGi4/wZ6QjXR0u8LdrfZ5pz2b/n+rrK6+EQM80AS6Hw3
         sdmU02XQH8BomH+yxW8NzuZsNWUF+B8hMZyOe10EsbetXnRej2RTz4lJkZJi3aYWs5a3
         ncHPNTdGr8Ab2sOHXwA9J8YaoQZhCJ8ap8YC3LlRICPaM4fB4TaQPH2D4geOHCp6Fkcr
         8Qjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732122390; x=1732727190;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=72KAuCGZk9dkQwE4EPXEULor/zpraUF3cNKJPF7sOZE=;
        b=jPv/Qp15pvZYemZ7vlEslLma5jmEJOHJ7pADNuzKJrisEHnwQnSXQz4+YRmtcW2o32
         zYwc7bo47/gDRvPAAnDxBURIwjEhWrln6CQUGJXp+zk3kQTy5FBSqKFLxcXP2VpYXnDf
         Bch6NYzhVDmvetxsWyGQoaMCgFb1+NKtQNAL1BsFf8xFBln5iNH1yE7riPc5YDJIt9sw
         GqAO7Yb9u6D6BSIdSCuw3p9PyDGXsu8+Ot96mPKRNRsfZfkALsm0zb8DbY14x5tyCJpB
         NHh1Y82zD2naT1qK8GgerjAO5mO8KgHlfhuRWUGoVXJrP18qZCXhfiIpg5D8HEj32sB0
         EfwA==
X-Forwarded-Encrypted: i=1; AJvYcCVSCVhu+fWfl7U71utiiu/l/ETaBtIM+RiQuUGjvJnp1A8OnnRQYp+Hq8nCKMCpkygv1hI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjcmWRk6V4qosQZVQ2p7XaqAILZP/QgRiCx8gz0iU9h+1NriaM
	6UHqqN2LxHzFqqh4urls78W/KCM9y1pYMdW4RI2TF+nSVYBeSYEPTjQWdlRIz4x2bo3AAmQxZPr
	18Q==
X-Google-Smtp-Source: AGHT+IG1NjrX/WWRkhsrbPKCnh25jzfDgr3jbC8xsaKOsQLUAnNOynoCLYFmHliQyM7+eVt6cZuuVgrsatA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec9:b0:6a9:3d52:79e9 with SMTP id
 00721157ae682-6eebd298ff5mr785067b3.4.1732122389949; Wed, 20 Nov 2024
 09:06:29 -0800 (PST)
Date: Wed, 20 Nov 2024 09:06:28 -0800
In-Reply-To: <50ba7bd1-6acf-4b50-9eb1-8beb2beee9ec@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-19-mizhang@google.com>
 <Zzyg_0ACKwHGLC7w@google.com> <50ba7bd1-6acf-4b50-9eb1-8beb2beee9ec@linux.intel.com>
Message-ID: <Zz4XFMYMbMvFh54a@google.com>
Subject: Re: [RFC PATCH v3 18/58] KVM: x86/pmu: Introduce enable_passthrough_pmu
 module parameter
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2024, Dapeng Mi wrote:
> On 11/19/2024 10:30 PM, Sean Christopherson wrote:
> >> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> index ad465881b043..2ad122995f11 100644
> >> --- a/arch/x86/kvm/vmx/vmx.c
> >> +++ b/arch/x86/kvm/vmx/vmx.c
> >> @@ -146,6 +146,8 @@ module_param_named(preemption_timer, enable_preemp=
tion_timer, bool, S_IRUGO);
> >>  extern bool __read_mostly allow_smaller_maxphyaddr;
> >>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
> >> =20
> >> +module_param(enable_passthrough_pmu, bool, 0444);
> > Hmm, we either need to put this param in kvm.ko, or move enable_pmu to =
vendor
> > modules (or duplicate it there if we need to for backwards compatibilit=
y?).
> >
> > There are advantages to putting params in vendor modules, when it's saf=
e to do so,
> > e.g. it allows toggling the param when (re)loading a vendor module, so =
I think I'm
> > supportive of having the param live in vendor code.  I just don't want =
to split
> > the two PMU knobs.
>=20
> Since enable_passthrough_pmu has already been in vendor modules,=C2=A0 we=
'd better
> duplicate enable_pmu module parameter in vendor modules as the 1st step.

Paolo,

Any thoughts on having enable_pmu in vendor modules, vs. putting enable_med=
iated_pmu
in kvm.ko?  I don't have a strong opinion, there are pros and cons to both.

