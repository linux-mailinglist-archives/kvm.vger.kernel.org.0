Return-Path: <kvm+bounces-39215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 021CDA452FB
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 03:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 118BA3A77FB
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DACE218EB9;
	Wed, 26 Feb 2025 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="babI3YOP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD423CE
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 02:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536242; cv=none; b=qhroKePyGsSbXDRLbrS8RullWunb/pVCxCjB1chHnhwPNV8FmTz6BnWrloB7EBzVZYsS5kOMMCZIgC0voxfRuw/sXCY06iVXTgTI/ADIT+0FxgeiEAAWct2UaKctA3zEv2K3f7OKUsDJ6DxOpxMNZ+Ld8ulrlzaO8CHG1IoEAPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536242; c=relaxed/simple;
	bh=5Shs29vFnsTdfRPK1do1DpzdyueIIk8IoPkKYFH6cwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=alMG1FlUTEtyRKNuvqs9ON8yV/BVDPr/LWyGAfBepBvamFrhoTeD5FL1qZ3vosrkWimScXEPBnT1tW5wqictxDdbc7FvLRQwHJbJ3QVp9KMeG4kIE1iZMh2Mh85VbKFteKTb8VUAbsdSVgHe7wbzZWKDkeADlLxBJBPEGeWp3BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=babI3YOP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc404aaed5so20810585a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 18:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740536240; x=1741141040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hEnXDJtrtWgIV8UK2eQVwYwkNADKUtEKEpksO/7JGns=;
        b=babI3YOP6gIAzm5D/1UQJchu6f3Py4/4Lyklx8D45KlMs6xqQmr2Uodz+7uieZ+k88
         ZxWSSRvRvMQNNE9rEV56qMsDM8N93tgoN0D951SUVknVG7iyX71VbXfUC8DHBVie4Oqs
         aFBh/Dwa3QMnq2rXZE0xvqppvRZ13EyiiDOC9Jobw6r9ybKbEG8RZTrApeG5+rgeJksz
         dLfrdBJmX3rK+TRVzWytNbRBFp+YlttUJyoyysDptVGQnUM8me+90CsjLu0d6prKcdB5
         CdE300ve7rss6u6CeW3w723xSBTJGnpp/HtP+ngOMpmsciCpgsdTJRSBf1NAv8P5C9N0
         4BYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740536240; x=1741141040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hEnXDJtrtWgIV8UK2eQVwYwkNADKUtEKEpksO/7JGns=;
        b=R4Pd4RaWqyCyiq/lIGWLOLF4J5Bgg4KX0Ew3QiykreGZzH0gxCbAWDrmTpdxso3tNV
         nb2Ps0xPQDr2f8ZKwmf2ODCVd0u2O7JSjghRrV1n7hDp3Lr1X7/CUM10s74ZrF6EGbj8
         HB0bUPlvn3GY9XPHMmwo4riZaoV+JX4zxwUUhZWdjS5ATDk3jhoxKYFb1YGFSpwsdMX9
         RCr9QPcm66vfwGE42p6HxYKktOPh6EnJ0r9ub2R3gJcfUu6BNWsCFb6m01dd6sy8Vj8q
         i2g2Kk7mD7/LGD4poiZRicbulDUSrbCt7LzNKjtTu7QAnSWVCduSzU39Nf+t+SERGlYy
         WJHg==
X-Forwarded-Encrypted: i=1; AJvYcCVwf3X2eZ8ODjwDuajzjNPuUJgQlO3I/JdtO4srKB3ZYPqOwmakQyz87KogUMHKZcbqVOk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn59C3BgN9plms2GUYVrAFymr8yKOSZpctlcvJQbIvW0EwtJm+
	WPd/pxA/kohBfXJhEZx/hqwDXoZLcr7iNntHxB3jXtwGTDgPo4rSqE77vA+9yPyqR+gC9tkiFDM
	xRA==
X-Google-Smtp-Source: AGHT+IF2FQtMVrCY2dMFVtyt04GwyNa3km0HRPrZ7dWjyUTUEzPcz0hdtDq1rWlVDZkTb9plo164752uosw=
X-Received: from pjbst5.prod.google.com ([2002:a17:90b:1fc5:b0:2e9:ee22:8881])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc5:b0:2f6:be57:49d2
 with SMTP id 98e67ed59e1d1-2fe7e32b7c8mr3043599a91.17.1740536240487; Tue, 25
 Feb 2025 18:17:20 -0800 (PST)
Date: Tue, 25 Feb 2025 18:17:19 -0800
In-Reply-To: <20250218202618.567363-1-sieberf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218202618.567363-1-sieberf@amazon.com>
Message-ID: <Z755r4S_7BLbHlWa@google.com>
Subject: Re: [RFC PATCH 0/3] kvm,sched: Add gtime halted
From: Sean Christopherson <seanjc@google.com>
To: Fernand Sieber <sieberf@amazon.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 18, 2025, Fernand Sieber wrote:
> With guest hlt, pause and mwait pass through, the hypervisor loses
> visibility on real guest cpu activity. From the point of view of the
> host, such vcpus are always 100% active even when the guest is
> completely halted.
> 
> Typically hlt, pause and mwait pass through is only implemented on
> non-timeshared pcpus. However, there are cases where this assumption
> cannot be strictly met as some occasional housekeeping work needs to be

What housekeeping work?

> scheduled on such cpus while we generally want to preserve the pass
> through performance gains. This applies for system which don't have
> dedicated cpus for housekeeping purposes.
> 
> In such cases, the lack of visibility of the hypervisor is problematic
> from a load balancing point of view. In the absence of a better signal,
> it will preemt vcpus at random. For example it could decide to interrupt
> a vcpu doing critical idle poll work while another vcpu sits idle.
> 
> Another motivation for gaining visibility into real guest cpu activity
> is to enable the hypervisor to vend metrics about it for external
> consumption.

Such as?

> In this RFC we introduce the concept of guest halted time to address
> these concerns. Guest halted time (gtime_halted) accounts for cycles
> spent in guest mode while the cpu is halted. gtime_halted relies on
> measuring the mperf msr register (x86) around VM enter/exits to compute
> the number of unhalted cycles; halted cycles are then derived from the
> tsc difference minus the mperf difference.

IMO, there are better ways to solve this than having KVM sample MPERF on every
entry and exit.

The kernel already samples APERF/MPREF on every tick and provides that information
via /proc/cpuinfo, just use that.  If your userspace is unable to use /proc/cpuinfo
or similar, that needs to be explained.

And if you're running vCPUs on tickless CPUs, and you're doing HLT/MWAIT passthrough,
*and* you want to schedule other tasks on those CPUs, then IMO you're abusing all
of those things and it's not KVM's problem to solve, especially now that sched_ext
is a thing.

> gtime_halted is exposed to proc/<pid>/stat as a new entry, which enables
> users to monitor real guest activity.
> 
> gtime_halted is also plumbed to the scheduler infrastructure to discount
> halted cycles from fair load accounting. This enlightens the load
> balancer to real guest activity for better task placement.
> 
> This initial RFC has a few limitations and open questions:
> * only the x86 infrastructure is supported as it relies on architecture
>   dependent registers. Future development will extend this to ARM.
> * we assume that mperf accumulates as the same rate as tsc. While I am
>   not certain whether this assumption is ever violated, the spec doesn't
>   seem to offer this guarantee [1] so we may want to calibrate mperf.
> * the sched enlightenment logic relies on periodic gtime_halted updates.
>   As such, it is incompatible with nohz full because this could result
>   in long periods of no update followed by a massive halted time update
>   which doesn't play well with the existing PELT integration. It is
>   possible to address this limitation with generalized, more complex
>   accounting.

