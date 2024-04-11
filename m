Return-Path: <kvm+bounces-14284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE3A8A1D5C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40D101C23448
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725DB1D429D;
	Thu, 11 Apr 2024 17:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iG6++Tkx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F53C51C5B
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712855020; cv=none; b=Ln+sgBHZczM0Tfkg5ujQGNdJotz6bnjvQ59If0FgpLWML19UHdb00Mnpag0sg+JSziZW1YOB/jsDVU79hK+a3U4hdAgwrX5JVId8SsTlMrJIg3g1Wwga0ui6I3tq1IOmZ4a4r63/PXiUMFiZMCvnJbXnzcmF4L2Z0h/geSCGDl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712855020; c=relaxed/simple;
	bh=atNz7o/Atoh6+JRJ4K/8ocTdr56+cF7aLa6JWMaTE8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L2JHQgYQZpQjG7c3jAuSl+jtdDbqhnOehC5oeO1zl7xn9DkiIYIogwPwBfCDYA6nbYzKoQqip8mFGcTw9uaks0NeQ5ctt1iXuTTvI58WgzCJ1juKG0hfmtUCQ+xJSe4O3HtNFYHmTMHll+/2dTiC3h9HloGdupHLzHXkL5aJVeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iG6++Tkx; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61810d4408cso83800267b3.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712855018; x=1713459818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aHiyBrCf2EF07WYxlcVRpDjkENbbQGRrolG7oRWf4Js=;
        b=iG6++TkxN78RRYO+hUmrMc/tBKsHQAq0k+D6jH4U8JRSv3JBi08+EArRLTl1kIBI5m
         foUUK3M3hYo7/WqmWhi/gEbYcvbbD+IECwBJOctYksMizf46mfNaipjKfMbB9kMBIqrW
         UN8l66+bGhAMJTrzOWsuse4/7/pRzd9YPTZWry/oSF9M22LTHtpfFkqWO7jRLJ/hfqW1
         Nf6dUwuv2VPHDnUVRYSZpSdrrdWBeZN5JFUpb3Je4/hNfwKN6WMMw3J3ECEzKhWU0Rdh
         fkH4h81VwXH/f7Ny23BwuwuUhzzNwmFYv6kRlgaumBfofbBUk8atavAubhl8fVgIfRZ2
         wtVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712855018; x=1713459818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aHiyBrCf2EF07WYxlcVRpDjkENbbQGRrolG7oRWf4Js=;
        b=kiikOWE2CpiG4dmT0T0ZTVP0NHFtL3mkPKHLxnTzlXbRhAEn9iL0JIFJmVdUzF1SSp
         GpHu9fnRB5ct3Gg3Q+dBHIF/5RenFHozGSOmLdkE3EldHV5Xnjx/bDWPN+VfbVb66QPT
         6UfDrBPoeuSVLUWLJKYhcDP7o+8FUxbXZNBZofV5xyQso6eOMMyaY1lRggo9FZkdgM/M
         CtBV+g0JYeOE7LvnDXjOPxHpYsCBA7045zE3pk/vgz+IIryH8QsRDK3fRLQw+XMJPOE/
         6x/6eFoLwQOA/q57WiuHB1tQFy/poPsJVvlm2ABh5sSxCQ9eC+1ohtRwlZhUp3Aeriwd
         OYhw==
X-Forwarded-Encrypted: i=1; AJvYcCW5j1dE/4lkJF72fS5qYkQhTQgXryWSjssRRquMduRQ4EhDA6sGTyQE5LG8yCaGhBjBB0CnUHox2ltUYFCgCyUMNjSW
X-Gm-Message-State: AOJu0YyTQ63goFBYEQLAId1Mt8Vctg9To7kEIsf3Vf6pbstrvJd0wNsE
	3Nr3PjLrmsoLXiv0pKhz451WfCzQ8FWyKlCX7oV7eSOEC0PZerpKAeszt0TrqAxmGbA6PeAV9NA
	ofA==
X-Google-Smtp-Source: AGHT+IF6jeOHUmhJ8aHuaekWulkjlMt+kUMfPktqjoSjKqLilk2hoOWcefaDLzldIcM9M9Xx/fUE5fKcL4g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120a:b0:dc7:68b5:4f21 with SMTP id
 s10-20020a056902120a00b00dc768b54f21mr20344ybu.9.1712855018241; Thu, 11 Apr
 2024 10:03:38 -0700 (PDT)
Date: Thu, 11 Apr 2024 10:03:36 -0700
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhgX6BStTh05OfEd@google.com>
Subject: Re: [RFC PATCH 00/41] KVM: x86/pmu: Introduce passthrough vPM
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

<bikeshed>

I think we should call this a mediated PMU, not a passthrough PMU.  KVM still
emulates the control plane (controls and event selectors), while the data is
fully passed through (counters).

</bikeshed>

On Fri, Jan 26, 2024, Xiong Zhang wrote:

> 1. host system wide / QEMU events handling during VM running
>    At VM-entry, all the host perf events which use host x86 PMU will be
>    stopped. These events with attr.exclude_guest = 1 will be stopped here
>    and re-started after vm-exit. These events without attr.exclude_guest=1
>    will be in error state, and they cannot recovery into active state even
>    if the guest stops running. This impacts host perf a lot and request
>    host system wide perf events have attr.exclude_guest=1.
> 
>    This requests QEMU Process's perf event with attr.exclude_guest=1 also.
> 
>    During VM running, perf event creation for system wide and QEMU
>    process without attr.exclude_guest=1 fail with -EBUSY. 
> 
> 2. NMI watchdog
>    the perf event for NMI watchdog is a system wide cpu pinned event, it
>    will be stopped also during vm running, but it doesn't have
>    attr.exclude_guest=1, we add it in this RFC. But this still means NMI
>    watchdog loses function during VM running.
> 
>    Two candidates exist for replacing perf event of NMI watchdog:
>    a. Buddy hardlock detector[3] may be not reliable to replace perf event.
>    b. HPET-based hardlock detector [4] isn't in the upstream kernel.

I think the simplest solution is to allow mediated PMU usage if and only if
the NMI watchdog is disabled.  Then whether or not the host replaces the NMI
watchdog with something else becomes an orthogonal discussion, i.e. not KVM's
problem to solve.

> 3. Dedicated kvm_pmi_vector
>    In emulated vPMU, host PMI handler notify KVM to inject a virtual
>    PMI into guest when physical PMI belongs to guest counter. If the
>    same mechanism is used in passthrough vPMU and PMI skid exists
>    which cause physical PMI belonging to guest happens after VM-exit,
>    then the host PMI handler couldn't identify this PMI belongs to
>    host or guest.
>    So this RFC uses a dedicated kvm_pmi_vector, PMI belonging to guest
>    has this vector only. The PMI belonging to host still has an NMI
>    vector.
> 
>    Without considering PMI skid especially for AMD, the host NMI vector
>    could be used for guest PMI also, this method is simpler and doesn't

I don't see how multiplexing NMIs between guest and host is simpler.  At best,
the complexity is a wash, just in different locations, and I highly doubt it's
a wash.  AFAIK, there is no way to precisely know that an NMI came in via the
LVTPC.

E.g. if an IPI NMI arrives before the host's PMU is loaded, confusion may ensue.
SVM has the luxury of running with GIF=0, but that simply isn't an option on VMX.

>    need x86 subsystem to reserve the dedicated kvm_pmi_vector, and we
>    didn't meet the skid PMI issue on modern Intel processors.
> 
> 4. per-VM passthrough mode configuration
>    Current RFC uses a KVM module enable_passthrough_pmu RO parameter,
>    it decides vPMU is passthrough mode or emulated mode at kvm module
>    load time.
>    Do we need the capability of per-VM passthrough mode configuration?
>    So an admin can launch some non-passthrough VM and profile these
>    non-passthrough VMs in host, but admin still cannot profile all
>    the VMs once passthrough VM existence. This means passthrough vPMU
>    and emulated vPMU mix on one platform, it has challenges to implement.
>    As the commit message in commit 0011, the main challenge is 
>    passthrough vPMU and emulated vPMU have different vPMU features, this
>    ends up with two different values for kvm_cap.supported_perf_cap, which
>    is initialized at module load time. To support it, more refactor is
>    needed.

I have no objection to an all-or-nothing setup.  I'd honestly love to rip out the
existing vPMU support entirely, but that's probably not be realistic, at least not
in the near future.

> Remain Works
> ===
> 1. To reduce passthrough vPMU overhead, optimize the PMU context switch.

Before this gets out of its "RFC" phase, I would at least like line of sight to
a more optimized switch.  I 100% agree that starting with a conservative
implementation is the way to go, and the kernel absolutely needs to be able to
profile KVM itself (and everything KVM calls into), i.e. _always_ keeping the
guest PMU loaded for the entirety of KVM_RUN isn't a viable option.

But I also don't want to get into a situation where can't figure out a clean,
robust way to do the optimized context switch without needing (another) massive
rewrite.

