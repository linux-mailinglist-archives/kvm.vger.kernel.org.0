Return-Path: <kvm+bounces-33584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 192179EEAAB
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C22402818A8
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 15:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13318221DAB;
	Thu, 12 Dec 2024 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3lPAPtFS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED9B215048
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 15:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016570; cv=none; b=g/ls9mGZNddqusCe3jp5AtXAcQF55LBBmymXv+9LCuhBBxOpeIkFw6YRAY6Qdcm2LeHbu3Z3dKcrmqRPKkF99aLfsJzRc69x1j1V9/8ugk138/dOsgd4YVOPaq8Z8n2sQkXQgKXDVbsyg6hhA5jL8luuTODhs6CvYQN8yvhohMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016570; c=relaxed/simple;
	bh=9fffTQdpWJhNALJxEvTaf/rO30fqud+Z6ubMNvTEEAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MFEFhqlOhOBivfjya5rj29f3Ls2odrXkTCVE2jI3o/oIloyaHAKfeVcA1kut8yf6g15yg/5xs4y+gV+Sr/HwxeUH3m3p+RxB6WQ6dyxkHm7MI3p8HSOZyfZQmCaJ1iRp25RCXfJnbQeTQhiX2YirUDe7gO+9FTbHKY5w2wPDmLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3lPAPtFS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9b9981f1so1046082a91.3
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 07:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734016568; x=1734621368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0npqMPaizFs8y4cj6WS+6Zs4SEP8glO2GcWXj+/iPTE=;
        b=3lPAPtFSrQhAULXygpaIYN89HCYKlyfITRb1+Fk5PHlOuJG0fT7eEh+or5WF6vmY/2
         PE5hRt6kdlhR9dS9saOyF2mo/RA61so5GY3cOx1QKwkzKbJtCK2M2eBX2f7Kya9b5kbz
         yQ+ODL2jXPY0wwX1rPDbDho/n0n0WLpOck7hJokBFriIPZ84TgRFa0YdLwcHoPEehR9b
         AbLACOhlC3zLNBQthNkPRfYoumniXjIPetBgTRxVD/Iqz9+Yw0bLSE/gjad1/XtFqOEc
         3s/lVn4Xz8jG8SnoVhn6uwOpg6V0yR+e72RxELM8zCs8fs8tpESlC7BZx3FkwaGBB71f
         vX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734016568; x=1734621368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0npqMPaizFs8y4cj6WS+6Zs4SEP8glO2GcWXj+/iPTE=;
        b=wwE/BokflGBS0FuDkjXipMSCbZ7BUBDmBEPx//+KTz/iMFeSXZefDxDip4GGP4qfK5
         piKW8WTZwn2siQP1ipHuTZ0Up+SleqFLyuD80IFWTkanKK3cd2mp3cI2660pAZTfDl/H
         Hwcex3pFch2QOdgjKh2w3sGKbCOhhemNtJAd6pHL+T6VMZBvJn6eSs2AwmMU6+7a4r2U
         //uq4D9swBalu0Tp80ikG3P6BXvZ74ufjt3y46deNDq3RMJ8ggxWc7PdX+Yzty5w8a2R
         Y1VqKEc7QwHF4F7AQPraDiWB+jJnodM16AHfFWDff84aK6XGzAPFv9WOTudC8/kTqEQ4
         t1sg==
X-Gm-Message-State: AOJu0Yxu8hro27nQtvH4xAiBPaSRvJiuANlkMU0sNyteQbdMDptnZzln
	boUDTW7ZNp9pqoSqQdFrZa23SIvs1q9rwSZl8ww+hFg9J69O6v3WFVDZe1KEpWFjxQO4uYQuJSr
	D8A==
X-Google-Smtp-Source: AGHT+IGTokf0OQ+2hOIq2A7X6nwlSf69djBPoKd73hqVAlnzbubKxZpTaLfCT5yWO/S25l1vLxNaAVP4Pvg=
X-Received: from pjbst8.prod.google.com ([2002:a17:90b:1fc8:b0:2ea:448a:8cd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:180b:b0:2ee:b8ac:73b0
 with SMTP id 98e67ed59e1d1-2f127f796bfmr10433341a91.2.1734016568047; Thu, 12
 Dec 2024 07:16:08 -0800 (PST)
Date: Thu, 12 Dec 2024 07:16:06 -0800
In-Reply-To: <Z1q4vxmEmZbkOiqC@mias.mediconcil.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241021102321.665060-1-bk@alpico.io> <Z1eXyv2VVsFiw_0i@google.com>
 <Z1ecILHBlpkiAThl@google.com> <Z1f45XzpgDMC2cvI@mias.mediconcil.de>
 <Z1nI22dBe01m3_k6@google.com> <Z1q4vxmEmZbkOiqC@mias.mediconcil.de>
Message-ID: <Z1r-Nh0JAQdL_L8n@google.com>
Subject: Re: [PATCH v2] KVM: x86: Drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 12, 2024, Bernhard Kauer wrote:
> On Wed, Dec 11, 2024 at 09:16:11AM -0800, Sean Christopherson wrote:
> > On Tue, Dec 10, 2024, Bernhard Kauer wrote:
> > > On Mon, Dec 09, 2024 at 05:40:48PM -0800, Sean Christopherson wrote:
> > > > > With a single vCPU pinned to a single pCPU, the average latency for a CPUID exit
> > > > > goes from 1018 => 1027 cycles, plus or minus a few.  With 8 vCPUs, no pinning
> > > > > (mostly laziness), the average latency goes from 1034 => 1053.
> > > 
> > > Are these kind of benchmarks tracked somewhere automatically?
> > 
> > I'm not sure what you're asking.  The benchmark is KVM-Unit-Test's[*] CPUID test,
> > e.g. "./x86/run x86/vmexit.flat -smp 1 -append 'cpuid'".
> 
> There are various issues with these benchmarks.

LOL, yes, they are far, far from perfect.  But they are good enough for developers
to detect egregious bugs, trends across multiple kernels, etc.

> 1. The absolute numbers depend on the particular CPU. My results
>    can't be compared to your absolute results.
> 
> 2. They have a 1% accuracy when warming up and pinning to a CPU.
>    Thus one has to do multiple runs.
> 
>       1 cpuid 1087
>       1 cpuid 1092
>       5 cpuid 1093
>       4 cpuid 1094
>       3 cpuid 1095
>      11 cpuid 1096
>       8 cpuid 1097
>      24 cpuid 1098
>      11 cpuid 1099
>      17 cpuid 1100
>       8 cpuid 1101
>       1 cpuid 1102
>       4 cpuid 1103
>       1 cpuid 1104
>       1 cpuid 1110
> 
> 3. Dynamic Frequency scaling makes it even more inaccurate.  A previously idle
>    CPU can be as low as 1072 cycles and without pinning even 1050 cycles. 
>    This 2.4% and 4.6% faster than the 1098 median.
> 
> 4. Patches that seem not to be worth checking for or where the impact is
>    smaller than measurement uncertainties might make the system slowly
>    slower.
> 
> 
> Most of this goes away if a dedicated machine tracks performance numbers
> continously.

I don't disagree, but I also don't see this happening anytime soon, at least not
for upstream kernels.  We don't even have meaningful CI testing for upstream
kernels, for a variety of reasons (some good, some bad).  Getting an entire mini-
fleet[*] of systems just for KVM performance testing of upstream kernels would be
wonderful, but for me it's a very distant second after getting testing in place.
Which I also don't see happening anytime soon, unfortunately.

[*] Performance (and regular) testing requires multiple machines to cover Intel
    vs. AMD, and the variety of hardware features/capabilities that KVM utilizes.
    E.g. adding support for new features can and does introduce overhead in the
    entry/exit flows.

