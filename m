Return-Path: <kvm+bounces-7864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DAF88475C4
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 18:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 620661C232D7
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 17:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3682F14D423;
	Fri,  2 Feb 2024 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HMJ2FJDL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7B014A4F5
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706893637; cv=none; b=ssRX2lT4mky0o38HSyTmUpobSm9c/U6x2Kp5c1twJ16ZkTgB0M4/eo9/w5J7zJ+fTrBYxzdK46s29y7IAUzndeCce67KxGQOxXSAk1J0xiosL525Dd95UWwCJK9TgQnGO1SEpwde1p8Bk/T9x4lQHGMBys1WnZFKTLWCGIO1LY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706893637; c=relaxed/simple;
	bh=ZxYwtQl6gwkvn4vNBtszF0Bkjvg2DtSi0J2BX7wpt0I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fbzeyBLZ6wUdRsSMdYrFNwhESk8iIN3Cw+qa/7AOF5Qc2GX01bxNU0XWk6TBTCNMBUTvj7GNOi00sWyQG+B4CtqR1BTURZuRraNY6FFHeAUf+graQD2HWQkzMko2STRnrQ6MSqCsSagAIPnHcOkLTSHWU2lVxAjR/kptdryk02Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HMJ2FJDL; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-603c0e020a6so34124587b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 09:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706893634; x=1707498434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=52hREpEdz1wY5YQcf323vOpsz5jH6pb2sFOoSjdgNLo=;
        b=HMJ2FJDLYfvzE1o+llrEPHrviYAQlluTGKopi6t+mNB9P29lfyQ1YEnDlLlKrblq3H
         RUMrjYDE1168Msw+NH2z+2gZnePwFPkh1PblRWcIXUuXcq4M3QGJI+bN3kRHxvbI0tRj
         1YHs4XHz7iikq9vlnlGRaXJh7PlyiYF+wzkKobWuQ5VWftXfFS+N4qtNNaDT31KRoAW4
         /Fzt4FbB+j4ZPO1iNiwidOVT+/MlyjncWpxBGJrPT26oHWngS39ScA13tcMqd31RnWCR
         2KkhbiEpFZTYfY/Rp1VlkIBC2RLbISA60+JcaSGS/aBGy/cT5EJrzQkJp7+rj7iwLcgO
         JuZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706893634; x=1707498434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=52hREpEdz1wY5YQcf323vOpsz5jH6pb2sFOoSjdgNLo=;
        b=pFvvZhgHUB92KMABqKmywJwsax/Me8kE7fFx7BV18qUw8vs4yv028RahLIg4+Uc6PJ
         TQ7AR2nyOpNshMFASH5vVB9Kn79Vp/jaj65B5Lz3AVX81g8W3zf+Hg4S1jUZGjQRvmaO
         Io6xGPSgyf5GjAxd7Hn3+rDZxH4ns9mZQ75kwPii368WqwnggG1zbGc4IBbXJKELz9+c
         kegbuR/nP92GdZw83EXPNeaoFgsyfLxZ3pdr+8tnWrxQZ03dbu1z1Eez9zbLWW81R/XD
         P4vxwXECcZ5qNGSMa6EpxE7YdvO4NBiN/rDsJwghkj1Gt1/xqW6GCB9MllZMU3hySGyr
         Dn6Q==
X-Gm-Message-State: AOJu0YzYNIA63DzxK5cRiVN2iuMH9JFRXXw6g8UXoItvzpzCH0RuA+md
	HDm0mRL4eNu6qoXIyz8yiXEKTRQyPlMH6h+ujz1YJbhoL+qShq/cBN7ZCYSy6AKn3BTLt9z8XnM
	NJA==
X-Google-Smtp-Source: AGHT+IGW368ALVFacBMp4luOZOtgF9xdwUNWVenx3J/2DBP1Gf1M9X6P48vkhXsEFewVeUm8CzD7lSb87CA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9805:0:b0:602:d545:a3bb with SMTP id
 p5-20020a819805000000b00602d545a3bbmr990910ywg.1.1706893634791; Fri, 02 Feb
 2024 09:07:14 -0800 (PST)
Date: Fri, 2 Feb 2024 09:07:13 -0800
In-Reply-To: <9098e8bb-cbe4-432c-98d6-ce96a4f7094f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240123221220.3911317-1-mizhang@google.com> <ZbpqoU49k44xR4zB@google.com>
 <368248d0-d379-23c8-dedf-af7e1e8d23c7@oracle.com> <CAL715WJDesggP0S0M0SWX2QaFfjBNdqD1j1tDU10Qxk6h7O0pA@mail.gmail.com>
 <ZbvUyaEypRmb2s73@google.com> <ZbvjKtsVjpuQmKE2@google.com>
 <ZbvyrvvZM-Tocza2@google.com> <9098e8bb-cbe4-432c-98d6-ce96a4f7094f@linux.intel.com>
Message-ID: <Zb0hQfZX89gJOtRX@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
From: Sean Christopherson <seanjc@google.com>
To: Xiong Y Zhang <xiong.y.zhang@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Dongli Zhang <dongli.zhang@oracle.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 02, 2024, Xiong Y Zhang wrote:
> 
> 
> On 2/2/2024 3:36 AM, Sean Christopherson wrote:
> > On Thu, Feb 01, 2024, Mingwei Zhang wrote:
> >> On Thu, Feb 01, 2024, Sean Christopherson wrote:
> >>> On Wed, Jan 31, 2024, Mingwei Zhang wrote:
> >>>>> The PMC is still active while the VM side handle_pmi_common() is not going to handle it?
> >>>>
> >>>> hmm, so the new value is '0', but the old value is non-zero, KVM is
> >>>> supposed to zero out (stop) the fix counter), but it skips it. This
> >>>> leads to the counter continuously increasing until it overflows, but
> >>>> guest PMU thought it had disabled it. That's why you got this warning?
> >>>
> >>> No, that can't happen, and KVM would have a massive bug if that were the case.
> >>> The truncation can _only_ cause bits to disappear, it can't magically make bits
> >>> appear, i.e. the _only_ way this can cause a problem is for KVM to incorrectly
> >>> think a PMC is being disabled.
> >>
> >> The reason why the bug does not happen is because there is global
> >> control. So disabling a counter will be effectively done in the global
> >> disable part, ie., when guest PMU writes to MSR 0x38f.
> > 
> > 
> >>> fixed PMC is disabled. KVM will pause the counter in reprogram_counter(), and
> >>> then leave the perf event paused counter as pmc_event_is_allowed() will return
> >>> %false due to the PMC being locally disabled.
> >>>
> >>> But in this case, _if_ the counter is actually enabled, KVM will simply reprogram
> >>> the PMC.  Reprogramming is unnecessary and wasteful, but it's not broken.
> >>
> >> no, if the counter is actually enabled, but then it is assigned to
> >> old_fixed_ctr_ctrl, the value is truncated. When control goes to the
> >> check at the time of disabling the counter, KVM thinks it is disabled,
> >> since the value is already truncated to 0. So KVM will skip by saying
> >> "oh, the counter is already disabled, why reprogram? No need!".
> > 
> > Ooh, I had them backwards.  KVM can miss 1=>0, but not 0=>1.  I'll apply this
> > for 6.8; does this changelog work for you?
> > 
> >   Use a u64 instead of a u8 when taking a snapshot of pmu->fixed_ctr_ctrl
> >   when reprogramming fixed counters, as truncating the value results in KVM
> >   thinking all fixed counters, except counter 0, 
> each counter has four bits in fixed_ctr_ctrl, here u8 could cover counter 0
> and counter 1, so "except counter 0" can be modified to "except counter 0 and
> 1" 

Ugh, math.  I'll adjust it to:

  Use a u64 instead of a u8 when taking a snapshot of pmu->fixed_ctr_ctrl
  when reprogramming fixed counters, as truncating the value results in KVM
  thinking fixed counter 2 is already disabled (the bug also affects fixed
  counters 3+, but KVM doesn't yet support those).  As a result, if the
  guest disables fixed counter 2, KVM will get a false negative and fail to
  reprogram/disable emulation of the counter, which can leads to incorrect
  counts and spurious PMIs in the guest.

Thanks!

