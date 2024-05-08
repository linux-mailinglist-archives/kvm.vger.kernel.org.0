Return-Path: <kvm+bounces-17019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4910D8BFFC7
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 16:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A2241C20CA0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05EC85624;
	Wed,  8 May 2024 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SsrDGka3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8286D53389
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715177612; cv=none; b=vEeIhko6OffZ+7Qjn0MFtaUimn2+s8SRDIdwJJxgLE8cQaY9cyP87UlefgU3zH7ggUwxetxdWOE027C90qNlHTd4RyhhtBx7GDr985eVSDW8ycwCj0r1bveiLmeoWV5ic9+h33VKA8VtVtiC8f12tpH9UCh3Bs4/91tEPiZQCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715177612; c=relaxed/simple;
	bh=61OD/9IaLuFsHEDBKcuzpgK0PsgjJcl8bgAHw8uresI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bau48hGIwUVXOBNw8qev/6GM96ZvWJRq/dDOwnrjee0dA0c3DpHvvZsoHxIQSkwvjIowIJ+/2udj0ZHjFbqwwzlwCpeNfBGeoqc1DTp3L2rui6xDl0I4sSv5ng4AoM795KsagQJuZQwHwGsXePJV2WBcGG4CCbeiAe7szdgqgZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SsrDGka3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61e0c296333so10658007b3.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 07:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715177610; x=1715782410; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BVDjHWc5/R6c0TdAMm7J4vZvfOmudqJs3mpnamvf2qo=;
        b=SsrDGka31YgzjFzv6hzhhf4HXHcQ1rNac7vLZqo8F1Ijz26HEajfRGgYm8ovNEWkfT
         9c6EIDXJjvStjsb0+YYMDseQ9R08nq6R9AhcwvmzR56XMQVQdB4/mgGvZJiYQWOmvzfq
         e0hFyG96KSgSd71DFIxj8c5YDvbZVg6kGafHPW3WaeepjazUo/ELJH1HQd9MhqZWUoN/
         vPbjzuHJx+kKxYrupmfMX0RZlL3teIm3blZ2tgeRh0kg1MJEhRbxn2TDZUYnPJLyQX3R
         CQ0cNh5wWoP+/kv7k8HXAhNz23RbdJJ/4RHomj5ebfBetYU+WBnzczJRWhQAJBUQeOPB
         H++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715177610; x=1715782410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BVDjHWc5/R6c0TdAMm7J4vZvfOmudqJs3mpnamvf2qo=;
        b=rZIPeoZ4HcC2GIT7Dw6CGrtYI1vYbwdNQW239nQxC4NyXwbcSCC/SGW6MmFs32TxGp
         7eO2qSwXGHF1xvW6teaFCrYQg97+Ov+UxYHT1eBmpY+x+726GL2306reWt+0PKlJ2KoZ
         lJV5xRRLMurGgrQuLchEtwKDlfP2goeNGUpNjejR99YkvTTVF8tnEE6Cbupr7pWadDjl
         NFGBroRYrO4H4eWpQy2k1mdyNFR3gy2lxz9ZFHNqnghYFgw2YxqvSHfO/IIdpNoH2zl+
         tChM2sQopxVO3UNZyHq+1f9gSsRkbA7UBCL2szCRbyoJG0lQJT7HiDSuJL6/pFYadQoS
         ZU8w==
X-Forwarded-Encrypted: i=1; AJvYcCVuyQ7Jn/zkuJ41ccyFez30qJIjxubAXNlg/oAcIyqME28F0/SjlsVeVOB0vqqlPra1pOij2KJAsPRg8Mt0Z3EZXl4y
X-Gm-Message-State: AOJu0Ywov79Hq4qwsIF/feyZQW0YwazYWEMb99vwQXk30H+T3Kmit9Z/
	QaarQ9UGou7Kui1SOabgkOOGcS2G0RYyzeoP9DRbrbeeQAVItjS6gWEsRWfglsHE2z8eRcky76d
	acA==
X-Google-Smtp-Source: AGHT+IENeF3rnph7fc8JeZe16l04XQs7NClzQF5EuFP6FS2QG565s/9c2Vu2Uv2xY57ikBOmWZf7+kjvljw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:702:b0:dbe:d0a9:2be3 with SMTP id
 3f1490d57ef6-debb95f21ecmr991296276.3.1715177610501; Wed, 08 May 2024
 07:13:30 -0700 (PDT)
Date: Wed, 8 May 2024 07:13:28 -0700
In-Reply-To: <fbb8306c-775b-4f00-a2a6-a0b17c8f038e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com> <20240506053020.3911940-18-mizhang@google.com>
 <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com> <CAL715WL80ZOtAo2mT95_zW9Xhv-qOqnPjLGPMp1bJKZ1dOxhTg@mail.gmail.com>
 <fbb8306c-775b-4f00-a2a6-a0b17c8f038e@linux.intel.com>
Message-ID: <ZjuIiDwbrWL7OD86@google.com>
Subject: Re: [PATCH v2 17/54] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, May 08, 2024, Dapeng Mi wrote:
> 
> On 5/8/2024 12:36 PM, Mingwei Zhang wrote:
> > if (pmu->passthrough && pmu->nr_arch_gp_counters)
> >
> > Since mediated passthrough PMU requires PerfMon v4 in Intel (PerfMon
> > v2 in AMD), once it is enabled (pmu->passthrough = true), then global
> > ctrl _must_ exist phyiscally. Regardless of whether we expose it to
> > the guest VM, at reset time, we need to ensure enabling bits for GP
> > counters are set (behind the screen). This is critical for AMD, since
> > most of the guests are usually in (AMD) PerfMon v1 in which global
> > ctrl MSR is inaccessible, but does exist and is operating in HW.
> >
> > Yes, if we eliminate that requirement (pmu->passthrough -> Perfmon v4
> > Intel / Perfmon v2 AMD), then this code will have to change. However,
> Yeah, that's what I'm worrying about. We ever discussed to support mediated
> vPMU on HW below perfmon v4. When someone implements this, he may not
> notice this place needs to be changed as well, this introduces a potential
> bug and we should avoid this.

Just add a WARN on the PMU version.  I haven't thought much about whether or not
KVM should support mediated PMU for earlier hardware, but having a sanity check
on the assumptions of this code is reasonable even if we don't _plan_ on supporting
earlier hardware.

