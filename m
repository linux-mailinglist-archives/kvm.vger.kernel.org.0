Return-Path: <kvm+bounces-32056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DCBC9D278C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7A652836D7
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8907D1CDA0D;
	Tue, 19 Nov 2024 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LN+rsl3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F46D1CCB58
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024817; cv=none; b=A980Qj2ZqQyRRA6S4dGjYnM7bQHpStUQlwef5CePqFUqkhOLsDBtgpqqApMS0rK+tzNCJKFvOCl1kxxcPN+AhyOIENIMVpVdi5SB9NkyuPKl5FWEc6iqxRxuCPR2apw6v1yCBtshMLEesviw0BXeS8e83YcHlPP6C3Ry9nTvnMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024817; c=relaxed/simple;
	bh=NNmtEzPeJrsLehi1WhmNqlBFpj9Ip1FKTLN9uY9VKy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dt3mdjq0hCVRNAHaSed48C+yYe4GNYTuFvkynCV1WedfNkf1ilSMkH+Zd2kxbrSPFN6PHltxdGVBBgQYZfbqkVYZsnMtogGpsujjyyZjF7PPQYemTymakbPds+2bdhAtPm+CPH+pGu7bTm0yPYQ4lKo5fzFvCuXCtAnZcrwX3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LN+rsl3Y; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ee3fc5a13fso50001017b3.1
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 06:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732024815; x=1732629615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOXHJiJ+SXG98Hij2HNzlC3M3lEHF7DmQUkB5bHSfGg=;
        b=LN+rsl3YfrD7jub0g9i8zCtO75raMuZ8fZoJ65yh01Z8d+Us5eC+GK0qJ2npCXhp0W
         TSsQkReELxkRagA9kf0f3mKz+dcHXsT4EsjhfkpUa3BnuAisaCaSEu/F5Mgxqd2i29+3
         nNt4TFvlcBQL0ZEDnrs+onSFhWR0mFP/fyQNUYdSxE9+MYdCATa0jxkob4gIe6LC/umD
         +0v+06800fnvUpLONY603olu6U7d8asCOaPRV2ltYmwmR0oecZ1sC9WXTSDtio4kwyn4
         ZN+WJ6gDh4giqmR1Rmyq7xs2gDhP+nyr5QuuveoMdqIHgswRgr1k5O+EtPw1xEUIFnxn
         DjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732024815; x=1732629615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOXHJiJ+SXG98Hij2HNzlC3M3lEHF7DmQUkB5bHSfGg=;
        b=H0Qtv0ZeK68qPdQj5ajsIDB7QXKPa9pH+IaDHTOGreQngu072IuQfK+kekHHYF7MNU
         C5uYg9vVn845aWFgF+aIS2ZiI5qPqQGg/BmnkOwivCBhjC007x5HVAMfHdD+drW88sBS
         HjrrKN5j8EBSwKfNjQavK3JaCXzWk1aNNsnDRrr1BzQjOKeET9wclLWZUVtolJpKYvax
         5ljVsUJftdUoyF1gcC32syGC/nyH+YUPspA+TDD85YolRX3pkLJjdDd8cJJQlz0kWowJ
         JQTPryvPKjkzlwKA+fzdt/N9k2/bp5UMFr7sz40WkibqrWj277EdLt60Y6yV8T305InM
         uUNA==
X-Forwarded-Encrypted: i=1; AJvYcCVZ6B7m8oXQUplfdA6oImnHUMYoBJA/ldabLMP5IbUqGZV8i8vAkGvyMHKCWS3dS/Yb4D8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBQtVt5nMs6Cut71NCViKWfOKJExRNFeiSWBgYIKDHJr6NEpxQ
	h9xGkCMrBiFwMNqVTkkQIQn4KfQ1CkxL8meaug6vc8beEaMcCwDd2fnYWyxQXzRqLx8RDnLTzBf
	o8g==
X-Google-Smtp-Source: AGHT+IF84+tXqMFcYD1nE5UAQFaK7SulZziKQGYlSvVLsWe37f0ou2CMMA7A5s+Ie0wwJEMH08XgyMK5H9I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4512:b0:620:32ea:e1d4 with SMTP id
 00721157ae682-6eeaa0028f4mr1943287b3.0.1732024814819; Tue, 19 Nov 2024
 06:00:14 -0800 (PST)
Date: Tue, 19 Nov 2024 06:00:13 -0800
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
Message-ID: <ZzyZ7U9C3EZyudz7@google.com>
Subject: Re: [RFC PATCH v3 00/58] Mediated Passthrough vPMU 3.0 for x86
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> This series contains perf interface improvements to address Peter's
> comments. In addition, fix several bugs for v2. This version is based on
> 6.10-rc4. The main changes are:
> 
>  - Use atomics to replace refcounts to track the nr_mediated_pmu_vms.
>  - Use the generic ctx_sched_{in,out}() to switch PMU resources when a
>    guest is entering and exiting.
>  - Add a new EVENT_GUEST flag to indicate the context switch case of
>    entering and exiting a guest. Updates the generic ctx_sched_{in,out}
>    to specifically handle this case, especially for time management.
>  - Switch PMI vector in perf_guest_{enter,exit}() as well. Add a new
>    driver-specific interface to facilitate the switch.
>  - Remove the PMU_FL_PASSTHROUGH flag and uses the PASSTHROUGH pmu
>    capability instead.
>  - Adjust commit sequence in PERF and KVM PMI interrupt functions.
>  - Use pmc_is_globally_enabled() check in emulated counter increment [1]
>  - Fix PMU context switch [2] by using rdpmc() instead of rdmsr().
> 
> AMD fixes:
>  - Add support for legacy PMU MSRs in MSR interception.
>  - Make MSR usage consistent if PerfMonV2 is available.
>  - Avoid enabling passthrough vPMU when local APIC is not in kernel.
>  - increment counters in emulation mode.
> 
> This series is organized in the following order:
> 
> Patches 1-3:
>  - Immediate bug fixes that can be applied to Linux tip.
>  - Note: will put immediate fixes ahead in the future. These patches
>    might be duplicated with existing posts.
>  - Note: patches 1-2 are needed for AMD when host kernel enables
>    preemption. Otherwise, guest will suffer from softlockup.
> 
> Patches 4-17:
>  - Perf side changes, infra changes in core pmu with API for KVM.
> 
> Patches 18-48:
>  - KVM mediated passthrough vPMU framework + Intel CPU implementation.
> 
> Patches 49-58:
>  - AMD CPU implementation for vPMU.

Please rename everything in KVM to drop "passthrough" and simply use "mediated"
for the overall concept.  This is not a passthrough setup by any stretch of the
word.  I realize it's a ton of renaming, but calling this "passthrough" is very
misleading and actively harmful for unsuspecting readers.

For helpers and/or comments that deal with intercepting (or not) MSRs, use
"intercept" and appropriate variations.  E.g. intel_pmu_update_msr_intercepts().

And for RDPMC, maybe kvm_rdpmc_in_guest() to follow kvm_{hlt,mwait,pause,cstate_in_guest()?
I don't love the terminology, but there's a lot of value in being consistent
throughout KVM.

I am not willing to budge on this, at all.

I'm ok with the perf side of things using "passthrough" if "mediated" feels weird
in that context and we can't come up with a better option, but for the KVM side,
"passthrough" is simply wrong.

