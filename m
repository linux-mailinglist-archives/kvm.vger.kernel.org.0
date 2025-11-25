Return-Path: <kvm+bounces-64520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C036FC86274
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3773D4EC963
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A0B329E6B;
	Tue, 25 Nov 2025 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hyEz2jcm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8638329C59
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090500; cv=none; b=ZVuli82nlzXnu5fhd+T0v2fE6eb8+pEv1Um0N3vPZvjZmByY4+9B5hZSxyTmuAtR3LFUoSLFSosAXOaWn30t03c4FUz7LjRCKjXx7NiIMIRllApOZcv+dlpjgRMuWT3KT3NzlTY8mn11fDYG+xYwUMmW5l+VvX9XKIYXaFiu50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090500; c=relaxed/simple;
	bh=Ws/YNKakph/oNkC8T2Z0oK5lQ8Qe0+L4yEIQYy1pOV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R3TjgTs1eihXV4LbaYFXTwwM/kylU4GpsxSiQ+g2I1KKq+IWmbNJcH4ucMBC6mk8RabWxdxHlCec61LssMFn+cr9RvfJZC3UTlJqhMO0JZ9+FVnSEz/lclex8GE1iqDze4x+KS+hI5eO+d9HW/vaKbkRUpS+EaZSSLjM+EeVNk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hyEz2jcm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34377900dbcso12698282a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764090498; x=1764695298; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y4ndUQJXblyMVIEo31GQ2aPBJsTj4kLS2trQiSNmxdk=;
        b=hyEz2jcmDG2VZ0SowrKZ1f5pZ//OeUIlgQGcTulUikVnNnF9oimfdIYuuQ8isRblV9
         uZGZOMxYsRwtRNXgEXYGXTQw3yTFxWDX43viymf507u157LsbHuAklGaWSyEu3g8DHAc
         usxaUz3Q8CzdMWkxbGpaAa7Q1UcSjyQkvOnB64zhiQihP2FcGEXsraebkPXnaDN3sNX9
         EfUcOxWEjX60n3P3ODo9JGA+7SjDWJuzMxFos8cSf5iHGVLE1/QPWXw/Wn3Z2AvsmXKG
         zmogkg2e3zLt1swH02vuKUSJrp+gjOHIJ4RhR19A5JXFkd9M9R4JQbbKEta888+07ko6
         5WXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764090498; x=1764695298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4ndUQJXblyMVIEo31GQ2aPBJsTj4kLS2trQiSNmxdk=;
        b=uP5RrP6hgbsyIZ9mEcZsiZRy0Y6uij5VJQk1qpIdVbRZTYs5kH2z7mivmClbyXn4L1
         DUe8x5j5xBPyBVIA4Qq5i4GzJipXElYotza4QUQ4kJfa/AXw1O69k3JZffR1OqUedS+K
         XnmZ93h4uHLyUlNqBe0cdjKxXgW0TtvCwec/B1qDBomnYXO3sqfAdepiZXZMO19N19Gk
         e6y7iAJyApo43c/G1ApkCrH1+ajhpFETmCKlCHD7GpWMLcxcwjCOI5RcbAo9LXIvOR2q
         EfiQQj/KV2nPRJqt7ZYR6YVli92vEX2BzMrocxJYfIbkfjPSGsP8GBJ9oFlkxTVV180P
         fIJw==
X-Forwarded-Encrypted: i=1; AJvYcCWlS00tQ/HdKVdPTmfb7SgY9+Hg49Zekgjv0YLGh9zAkZ2121uNZQMmr26ZfLMKiqMBQC4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy502jkQdXMRT+/djJWXmj56QoNoYF+joRjFBNKMi8sHzh72+WC
	7O+4aWSRWqTgEdT0YqZ03YA/1W5RVUplr2j2RhX86nAn8FlB35vjwjzEvh0pfl5iQ+7X9enBD8t
	HgqeR2g==
X-Google-Smtp-Source: AGHT+IFzDAUOZTDNFOssfEjC4490DRPTOVZZ7CJwR5gD19Yg3yMCKcUxEwLwt1d5WA+HAajf5nh9jS9CJiQ=
X-Received: from pjbpw1.prod.google.com ([2002:a17:90b:2781:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384f:b0:341:8c8e:38b5
 with SMTP id 98e67ed59e1d1-34733f3e483mr14061440a91.25.1764090498218; Tue, 25
 Nov 2025 09:08:18 -0800 (PST)
Date: Tue, 25 Nov 2025 09:08:16 -0800
In-Reply-To: <83067602-325a-4655-a1b7-e6bd6a31eed4@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-29-seanjc@google.com>
 <aSUK8FuWT4lpMP3F@google.com> <83067602-325a-4655-a1b7-e6bd6a31eed4@linux.intel.com>
Message-ID: <aSXigAQznhuxZmy7@google.com>
Subject: Re: [PATCH v5 28/44] KVM: x86/pmu: Load/save GLOBAL_CTRL via
 entry/exit fields for mediated PMU
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 25, 2025, Dapeng Mi wrote:
> On 11/25/2025 9:48 AM, Sean Christopherson wrote:
> >> +	if (host_pmu->version < 4 || !(host_perf_cap & PERF_CAP_FW_WRITES))
> >> +		return false;
> >> +
> >> +	/*
> >> +	 * All CPUs that support a mediated PMU are expected to support loading
> >> +	 * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
> >> +	 */
> >> +	if (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
> >> +			 !cpu_has_save_perf_global_ctrl()))
> >> +		return false;
> > And so this WARN fires due to cpu_has_save_perf_global_ctrl() being false.  The
> > bad changelog is mine, but the code isn't entirely my fault.  I did suggest the
> > WARN in v3[1], probably because I forgot when PMU v4 was introduced and no one
> > corrected me.
> >
> > v4 of the series[2] then made cpu_has_save_perf_global_ctrl() a hard requirement,
> > based on my miguided feedback.
> >
> >    * Only support GLOBAL_CTRL save/restore with VMCS exec_ctrl, drop the MSR
> >      save/retore list support for GLOBAL_CTRL, thus the support of mediated
> >      vPMU is constrained to SapphireRapids and later CPUs on Intel side.
> >
> > Doubly frustrating is that this was discussed in the original RFC, where Jim
> > pointed out[3] that requiring VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL would prevent
> > enabling the mediated PMU on Skylake+, and I completely forgot that conversation
> > by the time v3 of the series rolled around :-(
> 
> VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL is introduced from SPR and later. I
> remember the original requirements includes to support Skylake and Icelake,
> but I ever thought there were some offline sync and the requirement changed...

Two things:

 1) Upstream's "requirements" are not the same as Google's requirements (or those
    of any company/individual).  Upstream most definitely is influenced by the
    needs and desires of end users, but ultimately the decision to do something
    (or not) is one that needs to be made by the upstream community.

 2) Decisions made off-list need to be summarized and communicated on-list,
    especially in cases like this where it's a relatively minor detail in a
    large series/feature, and thus easy to overlook.

I'll follow-up internally to make sure these points are well-understood by Google
folks as well (at least, those working on KVM).

> My bad,

Eh, this was a group "effort".  I'm as much to blame as anyone else.

> I should double confirm this at then.

No need, as above, Google's requirements (assuming the requirements you're referring
to are coming from Google people) are effectively just one data point.  At this
point, I want to drive the decision to support Sylake+ (or not) purely through
discussion of upstream patches.

> > As mentioned in the discussion with Jim, _if_ PMU v4 was introduced with ICX (or
> > later), then I'd be in favor of making VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL a hard
> > requirement.  But losing supporting Skylake+ is a bit much.
> >
> > There are a few warts with nVMX's use of the auto-store list that need to be
> > cleaned up, but on the plus side it's also a good excuse to clean up
> > {add,clear}_atomic_switch_msr(), which have accumulated some cruft and quite a
> > bit of duplicate code.  And while I still dislike using the auto-store list, the
> > code isn't as ugly as it was back in v3 because we _can_ make the "load" VMCS
> > controls mandatory without losing support for any CPUs (they predate PMU v4).
> 
> Yes, xxx_atomic_switch_msr() helpers need to be cleaned up and optimized. I
> suppose we can have an independent patch-set to clean up and support
> global_ctrl with auto-store list for Skylake and Icelake.

I have the code written (I wanted to see how much complexity it would add before
re-opening this discussion).  My plan is to put the Skylake+ support at the end
of the series, not a separate series, so that it can be reviewed in one shot.
E.g. if we can make a change in the "main" series that would simplify Skylake+
support, then I'd prefer to find and implement any such change right away.

