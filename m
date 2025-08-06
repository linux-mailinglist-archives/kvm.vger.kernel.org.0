Return-Path: <kvm+bounces-54078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8F1B1BE07
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 02:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D931118A1593
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 00:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C08114B953;
	Wed,  6 Aug 2025 00:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KL7wxIz8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37574AD2C
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 00:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754441442; cv=none; b=gXArO9O/C9GfSWorKVUPUostVwIcKwplMDgRsdfOUJnFBU9UZtsBPkzNzYstiKQBJzFWWwT9C+W9b3wMd6BHqF9o9ALKqtPPsrGqFYSEFg98g4zIpg4en565ZPV1BHHtsY7uYWlzw+Gf7RdVFQ8ICC7z5uOCz15cdYPL19XdBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754441442; c=relaxed/simple;
	bh=IeVA0NaJz5e3d8CujHkpUIBK8kfZWpMLR45yOgnHLRA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISq3sFp+48PIou2HK+V7fB/ShfUFgM3zf/EJfMSoVRbepks+js8kxIkMO53RzDTZgO4y8U5PMAKQp0uMYkMr+UecZ4YHmdHWWp4G/sd9dlguMf95ahyfiu0qcaptFyDv7sAgh6peTaNJMA1Krlx05AKjOSN44RgJiCAm6u1fgTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KL7wxIz8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f32271a1fso502459a91.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 17:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754441440; x=1755046240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wkVY/voLoVdW57wTp815+eh0ROGJmnXwTEje5ztA/CM=;
        b=KL7wxIz8Hw//BJ6zUTYP6gAHaJY8+v7hHdSfNE+UFyeLo2LxPpT32laO2S4SbKJuHe
         1KTdeepe5HfNaESlgRyhBii1e8Cbw+ivPXqyXRB3yjDWrI9ozzlaAzbtF/3u037pVyTZ
         6Fme2APVbmU0Mnz3YWYjMY58FEVsxg8yOH7XEvTfoLZ0FChj0qJTzbxL9j1hAKaakpeV
         tNsPcUVVLOnkMcBVXnjlovtRhPBwShjgzai2WhhI1D0vwTxX6rc2zCbqeRoIcRxUycGq
         1/OVBU2rO1068itXLCkxpJ+6zA0wsI+RsnR5YgWefKdgawpH0i6Z3HX2ffvGbpXRFLCA
         4RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754441440; x=1755046240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wkVY/voLoVdW57wTp815+eh0ROGJmnXwTEje5ztA/CM=;
        b=VH7vVlx0xU0+x7Y2UeX4Nz5v3k68pokKh6zfqjFz64LXfJyhN7uuPDghX9h8XPydYk
         j7HMC5t79XzeUXYv/pbRUsVvocnDwKEUdt+AZilfkr0fu0k1fr4F7BbxofSyDaNuRAZu
         TwGtqSpSUdHu4mRDXc8kOSdjVmXwxkBcpRWFFaDF3nzY9SjSJdH54p3TV25REwdEDfpt
         BqW31LOFJFb/4zOBR7zHff1+deg7QHJoOtUeVAi/4XN5zt9fIgCoS8BWGKZ66eV87Yv0
         00TUiqERjzrvW5taI118Dc/O/JzHjExRDZ3hz5R0Yz9huYhNGf3rmrwfKoNXqVSbA+BB
         vZiw==
X-Forwarded-Encrypted: i=1; AJvYcCV7/rl92w/cDkvYpSxgHeo1bXXKeO/Xu2vWJ9NndLhhqX+tsfy88UZBy0GEtN/cSqbJf+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb7O66bu+jNiIuLp1hQUg4xUdFfLE3wX+qwoP0wI1YnqqJuNIi
	h0e3lZ0GJ7M2DTZhNNODKIbIcsDY7FPC4i6shDGgE+fjZfvdBwQu8wyqX43vYa1N4eJNpdl+07Q
	hxMRjew==
X-Google-Smtp-Source: AGHT+IHwbSUlGzQdJh5v7u8nF3mi6DLtG6ynJApkXTSM8sjtJ0k70c50LW/04rw/1spWGkR16CWnSmVQgAk=
X-Received: from pjbsg14.prod.google.com ([2002:a17:90b:520e:b0:31e:cdb5:aa34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d606:b0:321:1348:4438
 with SMTP id 98e67ed59e1d1-32166969b3amr1026957a91.7.1754441440558; Tue, 05
 Aug 2025 17:50:40 -0700 (PDT)
Date: Tue, 5 Aug 2025 17:50:39 -0700
In-Reply-To: <aJFWK-EiGgH5aiw1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-21-mizhang@google.com>
 <a700ab4c-0e8d-499d-be71-f24c4a6439cf@amd.com> <aG6QeTXrd7Can8PK@google.com>
 <7dc97db7-5eea-4b65-aed3-4fc2846e13a6@linux.intel.com> <aIlpaL-yEU_0kgrD@google.com>
 <7de2b6ed-af39-4434-9ead-5b06ed4761c5@linux.intel.com> <aI1OefS8b9vfHyu9@google.com>
 <aJFWK-EiGgH5aiw1@google.com>
Message-ID: <aJKm3zawEkrHT6Ms@google.com>
Subject: Re: [PATCH v4 20/38] KVM: x86/pmu: Check if mediated vPMU can
 intercept rdpmc
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandipan.das@amd.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Trimmed the Cc substantially, I'm guessing most folks don't need a play-by-play
update of misguided optimism. 

On Mon, Aug 04, 2025, Sean Christopherson wrote:
> On Fri, Aug 01, 2025, Sean Christopherson wrote:
> > On Wed, Jul 30, 2025, Dapeng Mi wrote:
> > > 
> > > On 7/30/2025 8:38 AM, Sean Christopherson wrote:
> > > > On Tue, Jul 29, 2025, Dapeng Mi wrote:
> > > >> BTW, Sean, may I know your plan about the mediated vPMU v5 patch set? Thanks.
> > > > I'll get it out this week (hopefully tomorrow).
> > > 
> > > Thumbs up! Thanks.
> > 
> > I lied, I'm not going to get it out until Monday.  Figuring out how to deal with
> > instruction emulation in the fastpath VM-Exit handlers took me longer than I was
> > hoping/expecting.
> > 
> > It's fully tested, and I have all but one changelog written, but I'm out of time
> > for today (I made a stupid goof (inverted a !) that cost me an ~hour today, *sigh*).
> > 
> > Unless I get hit by a meteor, I'll get it out Monday.
> 
> *sigh*
> 
> Wrong again (fortunately, I didn't get hit by a meteor).  Long story short, I
> revisited (yet again) how to deal with enabling the mediated PMU.  I had been
> doing almost all of my testing with a hack to force-enable a mediated PMU, and
> when it came time to rip that out, I just couldn't convince myself that requiring
> userspace to enable KVM_CAP_PMU_CAPABILITY was the best behavior (I especially
> hated that PMU support would silently disappear).
> 
> So, bad news is, v5 isn't happening today.  Good news is that I think I figured
> out a not-awful solution for enabling the mediated PMU.  I'll post details (and
> hopefully v5) tomorrow.

Too hopeful yet again.  I realized at the last minute that I neglected to add
support for disabling PMU MSR interception for L2 after rebasing on the MSR
interception cleanups.  Adding the code back was easy, but I need to test it.

I'm buried in meetings tomorrow, but there's a small chance I'll be able to squeak
out v5.

