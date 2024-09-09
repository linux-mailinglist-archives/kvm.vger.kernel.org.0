Return-Path: <kvm+bounces-26150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADB3972265
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAE501F2495A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 19:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96121189F47;
	Mon,  9 Sep 2024 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KM+lRaaR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7DE189B84
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725909116; cv=none; b=jFktj+A7z3oviMcHj9eliCtAVZW9NFkwvHKmMStvse3nhLp6MQySgtLQaPb9rj2jT/xqFj23yfpbJjy2vGuo+3CE8a9/Gk0Cm5+inN24hA0sGO0sSk1aKNvLXZ0vG3+L7BRaufxVjMvieL50PG4gRo8Omxndkwa1DB8s8pYjpFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725909116; c=relaxed/simple;
	bh=A6d4YMiwN1Ngb6IzbjbrTIXlacqKp7Jq6KjY6cUl9Z8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VYn8T9XJe3DODAPn3SfoZsXNzTFYFd/VAaeQ/2lvZZg93RCRvKarXcVTf+JZylZjhsveM+Gaapp9sQ0OonLBS5IAMen44LVKIzl5Y6+CL275v4eSC6gmnUttVshBtb3vEsuM97nuvSxobN3yJjomUaRyh8lqmLpjuimIpsYvqYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KM+lRaaR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d3aa5a6715so129309187b3.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725909114; x=1726513914; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IDOUAU5NoY/5ttFNtEIaS5qbTX/scaI3qhxTGLdCCYs=;
        b=KM+lRaaR4ZFa0+TjgPoB9bOdG7EhwngNHPgygL7lnsG79uyLQS8voLe7zNjnZBvHri
         EJn6R/aCcNn8PB6IFIfMzfr7d2HCsrH+ddNRy9PhFgQJqWVU6aNxiPvM6G6jNAcbOipv
         mqn1eF0miXmT5cUZckzzwC2PKNEFlUvn7700Xthiru/ZYIJmRh7H5ZALrqJr/crWOHcu
         nXCpTzvIuD8R/EOoPJsLGoLXcHh5LjNEBCvPuto4Eult28rvOKn/SpbuyeEha5mZqse/
         DUS4o4yUeaJgj3RQ/RU5M8PcEpT7+XLEcUZBD1GdyxKboImAsSvy61v436neZal4dBXT
         fKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725909114; x=1726513914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IDOUAU5NoY/5ttFNtEIaS5qbTX/scaI3qhxTGLdCCYs=;
        b=MlE6FCxH2bxLswQ3Us47BVJz1NNkv5/zdspRteJILkc/RhHUL1rTdVANO+hYes1wiZ
         56e9Tv5NiAYOI62nUfcYZGSTXiPQp3brj8QVyq3VuhoC0nViWhM/kdeW4jCwNWwHmiyu
         mrHEex0AYARaW+0p4cKPL0kYG4dNTffAFn7JAtQMG3VmJwosIKd1dEFmxrWCWmxL2TSO
         c/Q6EPnl/fEIjf4YZUT6vndpwTRoKV68fqYrA54Rf0bZgrZvX51XUN8Z5D+/D6m5YotM
         FnnOdKec6PkGWJE3jWd/b/7qdncEEGK7faXmTVPu0G56TnGV2QlYldO4p2xc7nMf34Hb
         g/XQ==
X-Gm-Message-State: AOJu0YzFddAD3FF2zzcgOXqpHMpLeR9TcXFbZIF5Y5xbwr75XlsLDjpC
	DEBxoWh9v+QycAPAFLQDALHuFIn2BNDHIR7ZoAiC9dlhltCn5NlJyijeVThJZp9SL4n1wuHyWJa
	Cqg==
X-Google-Smtp-Source: AGHT+IHKozrySUUnjFM9Wne1J6W1t09r2ku4UPIzfqFg+dsqZQj0VDFOASjMwcQRafyt8IUivgBITF2eZAg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6a04:b0:6c1:298e:5a7 with SMTP id
 00721157ae682-6db4516f4a1mr4349037b3.5.1725909114342; Mon, 09 Sep 2024
 12:11:54 -0700 (PDT)
Date: Mon, 9 Sep 2024 12:11:52 -0700
In-Reply-To: <DA40912C-CACC-4273-95B8-60AC67DFE317@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <DA40912C-CACC-4273-95B8-60AC67DFE317@nutanix.com>
Message-ID: <Zt9IeD_15ZsFElIa@google.com>
Subject: Re: KVM: x86: __wait_lapic_expire silently using TPAUSE C0.2
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: "kvm @ vger . kernel . org" <kvm@vger.kernel.org>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, 
	"kyung.min.park@intel.com" <kyung.min.park@intel.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Jon Kohler wrote:
> delay_halt_fn uses __tpause() with TPAUSE_C02_STATE, which is the power
> optimized version of tpause, which according to documentation [3] is
> a slower wakeup latency and higher power savings, with an added benefit
> of being more SMT yield friendly.
> 
> For datacenter, latency sensitive workloads, this is problematic as
> the call to kvm_wait_lapic_expire happens directly prior to reentry
> through vmx_vcpu_enter_exit, which is the exact wrong place for slow
> wakeup latency.

...

> So, with all of that said, there are a few things that could be done,
> and I'm definitely open to ideas:
> 1. Update delay_halt_tpause to use TPAUSE_C01_STATE unilaterally, which
> anecdotally seems inline with the spirit of how AMD implemented
> MWAITX, which uses the same delay_halt loop, and calls mwaitx with
> MWAITX_DISABLE_CSTATES. 
> 2. Provide system level configurability to delay.c to optionally use
> C01 as a config knob, maybe a compile leve setting? That way distros
> aiming at low energy deployments could use that, but otherwise
> default is low latency instead?
> 3. Provide some different delay API that KVM could call, indicating it
> wants low wakeup latency delays, if hardware supports it?
> 4. Pull this code into kvm code directly (boooooo?) and manage it
> directly instead of using delay.c (boooooo?)
> 5. Something else?

The option that would likely give the best of both worlds would be to prioritize
lower wakeup latency for "small" delays.  That could be done in __delay() and/or
in KVM.  E.g. delay_halt_tpause() quite clearly assumes a relatively long delay,
which is a flawed assumption in this case.

	/*
	 * Hard code the deeper (C0.2) sleep state because exit latency is
	 * small compared to the "microseconds" that usleep() will delay.
	 */
	__tpause(TPAUSE_C02_STATE, edx, eax);

The reason I say "and/or KVM" is that even without TPAUSE in the picture, it might
make sense for KVM to avoid __delay() for anything but long delays.  Both because
the overhead of e.g. delay_tsc() could be higher than the delay itself, but also
because the intent of KVM's delay is somewhat unique.

By definition, KVM _knows_ there is an IRQ that is being deliver to the vCPU, i.e.
entering the guest and running the vCPU asap is a priority.  The _only_ reason KVM
is waiting is to not violate the architecture.  Reducing power consumption and
even letting an SMT sibling run are arguably non-goals, i.e. it might be best for
KVM to avoid even regular ol' PAUSE in this specific scenario, unless the wait
time is so high that delaying VM-Enter more than the absolute bare minimum
becomes a worthwhile tradeoff.

