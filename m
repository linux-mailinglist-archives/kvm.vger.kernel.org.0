Return-Path: <kvm+bounces-15362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 957F88AB575
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 21:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DB0F28176E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 19:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CED513C905;
	Fri, 19 Apr 2024 19:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Phyt+OmO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2FF13C3F2
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713554066; cv=none; b=aiaARa4e8BadWBfXMIWnIusAoobeJHK8E45g3Ep52lyw10X4vI7+lpMmt/V1gzD+vWQHspbXA5fs2LD6JQLy0qS0LRvCwrP+b3GmHNcMp5h+R1gsfTcffiQhOEwD8PwVZzWRR1vLb1lTTrnWEjHoCfcf4JWT4cGxDai4SB6V7yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713554066; c=relaxed/simple;
	bh=ghHRvfsnLZoBuD+thj2tzA2nIrRJDK62IHkGCKIFt9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xp/ENG26a+w2AjzLyjohdnz73C+g63Ot9/8eUsWPiugqfD2lhyUc7qGPJ+31tu7n1mclhtEiKSBlnt72NUuHzYtgzMMhifeClm1N2Z/ooR/Y8Bn/p2pf1PQpdCoa6YuBc66Yl9baTEmlRCXQfOv8t6ZSZ5ijqkhSRmM/4krCAGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Phyt+OmO; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso4522458276.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713554064; x=1714158864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LxyLjfyND/X0CfR1qvIubJS+urbDCxyrK24QGGBvcRg=;
        b=Phyt+OmOLRhTdZkGxZSe2A7lyD8q0bdQAvdmS0mUtCeCjk/hEm+PpA70c7g9yvOR+9
         NcvK1QiLKQJJDu1IVCizbI3tFm3Ttq83m7aHboMwtXJMJUnsA/ZTXz9GY6RcCAQe1G4R
         ltj3kBgL73AE0WbAKKB/NTeHlfZy3nWGmIViEAvV7/SJWTj7z77jzH8jdyvNqrf4YuG0
         2aXk+90jUYDyMMMGJSM9GTFpWginoX2BH99C8G3qHT5xYkb8wSOyfscR50xbefu1Ckcx
         3thmYxD8qDOl+Iyaah8Z2PGvMijJSwbf067mBjDmQCZz9adnirJPAcZxptWV3VkIKNn+
         BiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713554064; x=1714158864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LxyLjfyND/X0CfR1qvIubJS+urbDCxyrK24QGGBvcRg=;
        b=rn2Q3DDNGQEg/ZCq72cj2+AEV7xE2dP3T1mQMxMg137CQK3GvS0vTTLnQHDv/LrsPc
         uzHU66T8/JNK6DZmLFuiagkyHb2tPi2TyhH3Y2t5c/Bdnynu5TVgzVA9+beAv+lnb/ch
         OaOiuQfuqYGttMTaY6NFwcDdzEXeLmQMAzYSAX0l9B7p+o1mlpGNhJBAQI/BU3U6X42g
         CHFH+AiLE4PCwrabANk8TDh+jWxYqCHXdXMCu9FCVFlTmn4n4kNPwWplW9riGZZh27tj
         pAsvapVnAL8hRPEM/J/NyvuU70SJNWFVSIMzrH8+fowa/koThhtzf4lQCimO6/ALWUaE
         hSSA==
X-Forwarded-Encrypted: i=1; AJvYcCWsjkzjtjozsfuh8THjHX4pj0Q8zble4u2sqexp461y70MaFS9fx5iKEtG0nfFIGTX4kXfbkrIeFdWR7Aksg142i1Hl
X-Gm-Message-State: AOJu0YzLB10pKj5IZfJNMU9IuWM1Papk/uniYE7gPj1wvkPZTHwzVxJk
	CMt/kIaGL1BLABiOMTTkVgFX64aoz34d4QC3f3dzy+pVBJ6FKo4Kw4ZAg7x0daWMwoae9EXMP8E
	zvQ==
X-Google-Smtp-Source: AGHT+IGVgn8Gf0JE3BoAkURXxw8LyhcDmWzr3Q2r8XR7+A5tBJUam6WylNWXRK1YN/QeAIyjeaEID9m1Od4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c01:b0:dcd:b431:7f5b with SMTP id
 fs1-20020a0569020c0100b00dcdb4317f5bmr824560ybb.0.1713554064161; Fri, 19 Apr
 2024 12:14:24 -0700 (PDT)
Date: Fri, 19 Apr 2024 12:14:22 -0700
In-Reply-To: <ZiGGiOspm6N-vIta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <ZhgX6BStTh05OfEd@google.com> <ZiGGiOspm6N-vIta@google.com>
Message-ID: <ZiLCjutwO6XIQp5Z@google.com>
Subject: Re: [RFC PATCH 00/41] KVM: x86/pmu: Introduce passthrough vPM
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	dapeng1.mi@linux.intel.com, jmattson@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 18, 2024, Mingwei Zhang wrote:
> On Thu, Apr 11, 2024, Sean Christopherson wrote:
> > <bikeshed>
> > 
> > I think we should call this a mediated PMU, not a passthrough PMU.  KVM still
> > emulates the control plane (controls and event selectors), while the data is
> > fully passed through (counters).
> > 
> > </bikeshed>
> Sean,
> 
> I feel "mediated PMU" seems to be a little bit off the ..., no? In
> KVM, almost all of features are mediated. In our specific case, the
> legacy PMU is mediated by KVM and perf subsystem on the host. In new
> design, it is mediated by KVM only.

Currently, at a feature level, I mentally bin things into two rough categories
in KVM:

 1. Virtualized - Guest state is loaded into hardware, or hardware supports
                  running with both host and guest state (e.g. TSC scaling), and
                  the guest has full read/write access to its state while running.

 2. Emulated    - Guest state is never loaded into hardware, and instead the 
                  feature/state is emulated in software.

There is no "Passthrough" because that's (mostly) covered by my Virtualized
definition.   And because I also think of passthrough as being about *assets*,
not about the features themselves.
 
They are far from perfect definitions, e.g. individual assets can be passed through,
virtualized by hardware, or emulated in software.  But for the most part, I think
classifying features as virtualized vs. emulated works well, as it helps reason
about the expected behavior and performance of a feature.

E.g. for some virtualized features, certain assets may need to be explicitly passed
through, e.g. access to x2APIC MSRs for APICv.  But APICv itself still falls
into the virtualized category, e.g. the "real" APIC state isn't passed through
to the guest.

If KVM didn't already have a PMU implementation to deal with, this wouldn't be
an issue, e.g. we'd just add "enable_pmu" and I'd mentally bin it into the
virtualized category.  But we need to distinguish between the two PMU models,
and using "enable_virtualized_pmu" would be comically confusing for users. :-)

And because this is user visible, I would like to come up with a name that (some)
KVM users will already be familiar with, i.e. will have some chance of intuitively
understand without having to go read docs.

Which is why I proposed "mediated"; what we are proposing for the PMU is similar
to the "mediated device" concepts in VFIO.  And I also think "mediated" is a good
fit in general, e.g. this becomes my third classification:

 3. Mediated    - Guest is context switched at VM-Enter/VM-Exit, i.e. is loaded
                  into hardware, but the guest does NOT have full read/write access
                  to the feature.

But my main motiviation for using "mediated" really is that I hope that it will
help KVM users grok the basic gist of the design without having to read and
understand KVM documentation, because there is already existing terminology in
the broader KVM space.

> We intercept the control plan in current design, but the only thing
> we do is the event filtering. No fancy code change to emulate the control
> registers. So, it is still a passthrough logic.

It's not though.  Passthrough very specifically means the guest has unfettered
access to some asset, and/or KVM does no filtering/adjustments whatseover.

"Direct" is similar, e.g. KVM's uses "direct" in MMU context to refer to addresses
that don't require KVM to intervene and translate.  E.g. entire MMUs can be direct,
but individual shadow pages can also be direct (no corresponding guest PTE to
translate).

For this flavor of PMU, it's not full passthrough or direct.  Some assets are
passed through, e.g. PMCs, but others are not.  

> In some (rare) business cases, I think maybe we could fully passthrough
> the control plan as well. For instance, sole-tenant machine, or
> full-machine VM + full offload. In case if there is a cpu errata, KVM
> can force vmexit and dynamically intercept the selectors on all vcpus
> with filters checked. It is not supported in current RFC, but maybe
> doable in later versions.

Heh, that's an argument for using something other than "passthrough", because if
we ever do support such a use case, we'd end up with enable_fully_passthrough_pmu,
or in the spirit of KVM shortlogs, really_passthrough_pmu :-)

Though I think even then I would vote for "enable_dedicated_pmu", or something
along those lines, purely to avoid overloading "passthrough", i.e. to try to use
passhtrough strictly when talking about assets, not features.  And because unless
we can also passthrough LVTPC, it still wouldn't be a complete passthrough of the
PMU as KVM would be emulating PMIs.

