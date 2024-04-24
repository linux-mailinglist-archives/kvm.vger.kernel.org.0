Return-Path: <kvm+bounces-15815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA198B0D7E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C97E28D198
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B26C15F321;
	Wed, 24 Apr 2024 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q64toCyl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E1215ECF2
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713970827; cv=none; b=ZkNN8zEBOQVAL9FJP/tmGFXfvDJZnxIZt1/BSnF+gwUJ8LyQ7Yu/FLASZKVX9AGC2ZT4s1RULl0gO2iKQZahL4xTDZUKhduU3oWMPuTqJrdJ4PVSTpCq4OaJebDTzifD6230vgGUppbwJaXkFNJZ8nnJDarxrco0GWya5GTNMRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713970827; c=relaxed/simple;
	bh=m2kvDOjAcs0/fOGssqgm6z3aXoukHOTqP1RoSeztxz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B6qFqAXP7usaE3fsrq5U8DWixcThxX5U0bAIghzBkFi2zKq6ObvZc519NdX7LOzz9xhHRT2U3MuwOCIjwxtePd+yCoxE/hr37H2JOC+wNYPCWaRNo6C1d94jRoMP3qAjgShCuUM1AnmDbA5bR4wYE7GOaU9zN9rGN5GeqeyLgow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q64toCyl; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so10918215276.3
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 08:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713970825; x=1714575625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iTow4IhQ+Q7ezsDpFxCw9QP7cHw66mii0qlTGERXHWI=;
        b=q64toCyl3FC9eb9bdPgLikX+Tg+qejWAbhRj/hveXefzZhVP161I/nwDjJUk0BoR5Q
         EjKiIr/GERKHwP2SqmpJbmzAsBwbyUI5bJhE66Bwrz42FYHViH8fBNjtRt/9TTo9eP3b
         0aXnV4Ed87SttaL0ihb4IngpJE4PsSHQEp0Hn9Uyz5vWdP70pGi29sqkxvCJkGkOLjh3
         EDiZvv/z8s1ccpQS9iMvlfoZonilL130jm8Qs+jRRnLWjdP998/M2+O5zSyONEFISBob
         vP6sjh0hMY4Ihg1lSb01sVaLIV09s3ulOEYyXkXvshWNUTKTff1V7Un/FXYwO+kZYD/G
         SCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713970825; x=1714575625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTow4IhQ+Q7ezsDpFxCw9QP7cHw66mii0qlTGERXHWI=;
        b=kGY58XhlWdiDxAHiMuEINMLKuaNlB8N6QC5UcVr0M+Xw+ySNoElZwdeueWqMXozKda
         ZzljpUA68/t6Yt+FFNcK7WNy87LIiv+SsAIm8cMMZ2wsRrR7Jmzn+4ht6kwc9eguYoaB
         N3YjgbhmsW2zlVBpP7eCAkzXuyBytECKhdeEIFOO+/FMOGDFTbJP0XWMACNhApdYL0o3
         x6Kjj5344DsX38r58qY2RYPyoszISPUsWIPP77Tdq1LYxen2sIPfhGQdg5yLVazT5MyS
         KKiGKnAMwc0ujdVfjsx1+mjo5I7X6Pd04DUOTDNi68iGnTxfNU0ph8Wi2C8qIXwmqm5j
         5+7g==
X-Forwarded-Encrypted: i=1; AJvYcCW7CGRz24EMnwE0yWoubJR5lHuTiTPfakoXP+STQ+X26kYkliV7IRaVTnDjRjqES8ictGjLAHjig1ODeuCLF0KHopln
X-Gm-Message-State: AOJu0Yx14vuOPNzMfBBtrXbIqnFwKqvTWe1GQl+xR9pHUoPN5tCs7rzP
	VY5wpq3Z9OQDm9vutoq1ykrgmv4H2LnhlAGSBetRxiT3MJimhm7lQy423GJHP03IReTT1qOb62l
	ETg==
X-Google-Smtp-Source: AGHT+IFFD+SYfagl/TClvPMU0JQ850YCyw4YR2sbV6rmuRkaHu0K9DZ/AAPWyBohe3gIvA3eeokv75tdbZA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce12:0:b0:de5:1ea2:fc75 with SMTP id
 x18-20020a25ce12000000b00de51ea2fc75mr219027ybe.7.1713970824986; Wed, 24 Apr
 2024 08:00:24 -0700 (PDT)
Date: Wed, 24 Apr 2024 08:00:23 -0700
In-Reply-To: <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZiaX3H3YfrVh50cs@google.com> <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com> <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com> <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn> <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com>
Message-ID: <Zikeh2eGjwzDbytu@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, maobibo <maobibo@loongson.cn>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, peterz@infradead.org, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 24, 2024, Dapeng Mi wrote:
> 
> On 4/24/2024 1:02 AM, Mingwei Zhang wrote:
> > > > Maybe, (just maybe), it is possible to do PMU context switch at vcpu
> > > > boundary normally, but doing it at VM Enter/Exit boundary when host is
> > > > profiling KVM kernel module. So, dynamically adjusting PMU context
> > > > switch location could be an option.
> > > If there are two VMs with pmu enabled both, however host PMU is not
> > > enabled. PMU context switch should be done in vcpu thread sched-out path.
> > > 
> > > If host pmu is used also, we can choose whether PMU switch should be
> > > done in vm exit path or vcpu thread sched-out path.
> > > 
> > host PMU is always enabled, ie., Linux currently does not support KVM
> > PMU running standalone. I guess what you mean is there are no active
> > perf_events on the host side. Allowing a PMU context switch drifting
> > from vm-enter/exit boundary to vcpu loop boundary by checking host
> > side events might be a good option. We can keep the discussion, but I
> > won't propose that in v2.
> 
> I suspect if it's really doable to do this deferring. This still makes host
> lose the most of capability to profile KVM. Per my understanding, most of
> KVM overhead happens in the vcpu loop, exactly speaking in VM-exit handling.
> We have no idea when host want to create perf event to profile KVM, it could
> be at any time.

No, the idea is that KVM will load host PMU state asap, but only when host PMU
state actually needs to be loaded, i.e. only when there are relevant host events.

If there are no host perf events, KVM keeps guest PMU state loaded for the entire
KVM_RUN loop, i.e. provides optimal behavior for the guest.  But if a host perf
events exists (or comes along), the KVM context switches PMU at VM-Enter/VM-Exit,
i.e. lets the host profile almost all of KVM, at the cost of a degraded experience
for the guest while host perf events are active.

My original sketch: https://lore.kernel.org/all/ZR3eNtP5IVAHeFNC@google.com

