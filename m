Return-Path: <kvm+bounces-29450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DBB39AB980
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 00:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24D821F23D33
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B709A1CEAA7;
	Tue, 22 Oct 2024 22:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BDLf7UPk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508D419C540
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 22:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729636261; cv=none; b=SkTmoyxq/XBPvYskPewJFI5E7ENrDHqca2q/cXtB4vSabogkNQ2zmReAiJU1f2qwX9wxUPliYaUYpFiyQKli2ORrkxAoCHeMZVQvPZCqM5hEMZGfF47W442YBk1KNM4A6jak+QJ7eAyh92T3pzM8aEUG8PmSriI+go83C0BrRuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729636261; c=relaxed/simple;
	bh=GbpHqXO70UymoofiYbfPzNeoxpUmCo/eXHSBvHQo9Us=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DXboyJbvTc//V4LHElJ8Sa1qQPg8AXJDssLzBNlPZZJmnX13dEhFnpUaerDHRUGHzT/i8uyYLuZNYMq6brRwgk/sYWRvMM/+uFMvVzvSaQYd6z9bNlKKGCVhhW91+FREN2yY4eUCdbUryApeZjEHvXvFP4JZIWrXvGPkTktVfeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BDLf7UPk; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-690404fd230so120970427b3.3
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 15:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729636259; x=1730241059; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XOqBWZrZXtWTTpPGYoMu4m/4ZnTX0L7qg4xRYMuF1qk=;
        b=BDLf7UPk7OtTKkXNIkxKUumrI8NqSiSLJYBMmASrd70UQ+qZeNd5/0Aa2zx3EjqiCX
         wTX0mtJUuQGb4tvkG/N+5U5WecFmkAYs9/KQUHDv8DpD05cPKUa8hzF9na2SZSU/vA9K
         1BS9f5gHj9RVhiby/LVW026pdMVMV/UXcVEZtburigCzlrRwDGDkAbRWJ5yQArobUAl3
         rxRX3nL7bNwSkz3S1rDdD1O5QnrXzBcVQnEWNHJeurBqOUNGwYUR3+WNui24WLpNKdhJ
         drOIKwEG5nw05m9O/HWfochZdKWiJ8OEz4icl3Blm+PEy+0A8qDTS8z9YM97umD0M86N
         YkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729636259; x=1730241059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XOqBWZrZXtWTTpPGYoMu4m/4ZnTX0L7qg4xRYMuF1qk=;
        b=rUCxSBbKooiULrsK/ZfdRSXtHDyG+o7IcrQJlNvr+m1sSApVNOKWCstukcsovhpkkt
         Rttdf5fEPDcIW1nt+IGOovZ3X5bmbq9spg+X8KeqmMUc+wQH0ovH+zer0rIcb+fUx9Hr
         pTNfeBIjQ5+oNypWb8fo/1K3Dm+TR9+QWz8DG4D4tmZIOKUp5pW4oKkUxUaQuRFLIXnW
         UNsrjDcbojuwpawvq1Jqx3sCN/z6MP2/hXNoJeKJyh3EqWlAkq5SLkfZWBg7gG0jkh8v
         pt29wV8hVyUxXyDUP/vNGsUg9Eq1NTTcJhUmpjXIhXTuw8n0ucZdNn0WmbiynkhWrZbU
         XERw==
X-Forwarded-Encrypted: i=1; AJvYcCXsDxWqcQ6RbwwcsOsbB/MDgPtjQJewxPezJdP4FMhieFFV9pjHUWszhqILoatsnd+Btys=@vger.kernel.org
X-Gm-Message-State: AOJu0YwygEJNFZTIBRdXnp5Ii1Ee8hCsBIZGMVaQxlPmW4YZu1BnXsWi
	ORqVhWUT781z8AtdV8YnXjsDoY2vRzHcEmWo/M2CIYyNKemATiKhouFkHcU6pccCbnFh/dz62Kf
	uOw==
X-Google-Smtp-Source: AGHT+IGcqbY82rYWFSyzU4sD78yuqoJ/yG31UhWaIGXmch+HUW0FApvVNi4wRoSd0uA0A0VOd4tLZ9MP+V4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6485:b0:6e3:da91:3e17 with SMTP id
 00721157ae682-6e7f0db3b18mr232037b3.2.1729636259303; Tue, 22 Oct 2024
 15:30:59 -0700 (PDT)
Date: Tue, 22 Oct 2024 15:30:57 -0700
In-Reply-To: <2a8e6f2c-4284-4218-9b91-af6a4d65e982@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241014105124.24473-1-adrian.hunter@intel.com>
 <20241014105124.24473-4-adrian.hunter@intel.com> <Zw1iCMNSI4Lc0mSG@google.com>
 <b29e8ba4-5893-4ca0-b2cc-55d95f2fc968@intel.com> <ZxfTOQzcXTBEiXMG@google.com>
 <2a8e6f2c-4284-4218-9b91-af6a4d65e982@intel.com>
Message-ID: <ZxgnoTKt2IBnBBJ2@google.com>
Subject: Re: [PATCH V13 03/14] KVM: x86: Fix Intel PT Host/Guest mode when
 host tracing also
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Thomas Richter <tmricht@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach <mike.leach@linaro.org>, 
	James Clark <james.clark@arm.com>, coresight@lists.linaro.org, 
	linux-arm-kernel@lists.infradead.org, Yicong Yang <yangyicong@hisilicon.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Will Deacon <will@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Ian Rogers <irogers@google.com>, Andi Kleen <ak@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, mizhang@google.com, 
	kvm@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 22, 2024, Adrian Hunter wrote:
> On 22/10/24 19:30, Sean Christopherson wrote:
> >>> LOL, yeah, this needs to be burned with fire.  It's wildly broken.  So for stable@,
> >>
> >> It doesn't seem wildly broken.  Just the VMM passing invalid CPUID
> >> and KVM not validating it.
> > 
> > Heh, I agree with "just", but unfortunately "just ... not validating" a large
> > swath of userspace inputs is pretty widly broken.  More importantly, it's not
> > easy to fix.  E.g. KVM could require the inputs to exactly match hardware, but
> > that creates an ABI that I'm not entirely sure is desirable in the long term.
> 
> Although the CPUID ABI does not really change.  KVM does not support
> emulating Intel PT, so accepting CPUID that the hardware cannot support
> seems like a bit of a lie.

But it's not all or nothing, e.g. KVM should support exposing fewer address ranges
than are supported by hardware, so that the same virtual CPU model can be run on
different generations of hardware.

> Aren't there other features that KVM does not support if the hardware support
> is not there?

Many.  But either features are one-off things without configurable properties,
or KVM does the right thing (usually).  E.g. nested virtualization heavily relies
on hardware, and has a plethora of knobs, but KVM (usually) honors and validates
the configuration provided by userspace.

> To some degree, a testing and debugging feature does not have to be
> available in 100% of cases because it can still be useful when it is
> available.

I don't disagree, but "works on my machine" is how KVM has gotten into so many
messes with such features.  I also don't necessarily disagree with supporting a
very limited subset of use cases, but I want such support to come as well-defined
package with proper guard rails, docs, and ideally tests.

> >>> I'll post a patch to hide the module param if CONFIG_BROKEN=n (and will omit
> >>> stable@ for the previous patch).
> >>>
> >>> Going forward, if someone actually cares about virtualizing PT enough to want to
> >>> fix KVM's mess, then they can put in the effort to fix all the bugs, write all
> >>> the tests, and in general clean up the implementation to meet KVM's current
> >>> standards.  E.g. KVM usage of intel_pt_validate_cap() instead of KVM's guest CPUID
> >>> and capabilities infrastructure needs to go.
> >>
> >> The problem below seems to be caused by not validating against the *host*
> >> CPUID.  KVM's CPUID information seems to be invalid.
> > 
> > Yes.
> > 
> >>> My vote is to queue the current code for removal, and revisit support after the
> >>> mediated PMU has landed.  Because I don't see any point in supporting Intel PT
> >>> without a mediated PMU, as host/guest mode really only makes sense if the entire
> >>> PMU is being handed over to the guest.
> >>
> >> Why?
> > 
> > To simplify the implementation, and because I don't see how virtualizing Intel PT
> > without also enabling the mediated PMU makes any sense.
> > 
> > Conceptually, KVM's PT implementation is very, very similar to the mediated PMU.
> > They both effectively give the guest control of hardware when the vCPU starts
> > running, and take back control when the vCPU stops running.
> > 
> > If KVM allows Intel PT without the mediated PMU, then KVM and perf have to support
> > two separate implementations for the same model.  If virtualizing Intel PT is
> > allowed if and only if the mediated PMU is enabled, then .handle_intel_pt_intr()
> > goes away.  And on the flip side, it becomes super obvious that host usage of
> > Intel PT needs to be mutually exclusive with the mediated PMU.
> 
> And forgo being able to trace mediated passthough with Intel PT ;-)

It can't work, generally.  Anything that generates a ToPA PMI will go sideways.
In the worst case scenario, the spurious PMI could crash the guest.

And when the mediated PMU supports PEBS, that would likely break too.

