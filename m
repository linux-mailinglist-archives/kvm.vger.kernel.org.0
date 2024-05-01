Return-Path: <kvm+bounces-16351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4FC8B8CF8
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 17:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A374CB203AA
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 15:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E48912F5B6;
	Wed,  1 May 2024 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DaSq8OS0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD012F59D
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714577375; cv=none; b=o3D0yTM8hAHEL9qkVWQw81CJi6j/bcjMz7H5ZwLYen4MjRCByUVFTb0/IAi9fcrUybY0jT3O6H8nzRiXExkeC+4lifgUCOb2nAN+Y7u9wRThm1UKwykPZ8XNjlweJhWsxcCNAAifRGPJ/q/QL7QEUy1f9GttJCVuPxgyjTTvaYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714577375; c=relaxed/simple;
	bh=oLeBWgB0+WXZmytF4guGj9ibVqIVjNYYvrW01MvrqPA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aSOvRneXy/+6jrOPNY0q4uCV+P4YX08nGPDRmTSXQuiMf5tKWCfRY/bV8y7g6rDXH9fPv4dU/ZSMI73bCcM/53ca3lSQj4F/JwZyhm6rgNL++eBNC3xQ3aMz9cPvDIePFmz3/i8t3JZ3x9BaWnQFiLYC3V5PYZ+2EAKZFRcpVxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DaSq8OS0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dbddee3694so677652a12.1
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 08:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714577373; x=1715182173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1XM+1gnsvWZBIoRYTk8OchwwR62glsxwZHuML6i3JI8=;
        b=DaSq8OS0fcQn9/krwlBE4g0ebyO9MIisxFvESxIQ0J+SpuH5wPeOBVt23ZhtX1Ikr0
         xxM8664iwzeeDkV0WnkVec6CNgfdirXdDWw4rAAy69pag3YsrbbZEueOBp0zbiLeOLxs
         wqiEiyzxotznO7ro/fWh4nxyYDFdv1UW30JTwEf7F2Z47/cxUbSkvhKR5u3M2imRL/ME
         GmISLHJy7W6Dpm7W3nP5mA0vDeiE8N1aGS9vdftsf6OHwHXnvDvXtsbq0HaNhGSWrTXJ
         lgE0Yzn5YV2aTfJa70e823WXb87W3EEwGq4Z/Hikgu4pAHFUAFb10giSmG2ucoxIZ3BA
         3ILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714577373; x=1715182173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1XM+1gnsvWZBIoRYTk8OchwwR62glsxwZHuML6i3JI8=;
        b=nXi4cZ+/yjn4YFfTL5jwxml9vA3/zedGvxZyUO2lo6+IFgD8gpBf/HdPb2aZckZ6LP
         IAMdn8FYznLkJ4fTSkx2rS4aattTJ8yDSVkfzXr5LaFEoTh7Kpc1NaXWtLIM4RKWbZSP
         /Q8a8zHafUGdl8o02FHieQCp4AdCZCZplmB/sNP//mhgZl/gTeuq/hS28Mw88WoUKIDe
         aBzwqgEhtCT7uhdKX8G8fVLGmBWFLemIsTuLQip4Aze2/10HLU6arWH1a0/xUWWi+c8Q
         kDias6xJQ09/N4mGNyOpO86QsMfMMQB7fvovBCc849aFftJ0YleWU2HtpciC49Bldmzp
         Ikyg==
X-Forwarded-Encrypted: i=1; AJvYcCVCDLbyO3bXpWFLNCOyHKwPMuJwryy5HMHlwLMH5QiAyV1muRlbXTzW5oaEUAZtDYQEDQM7FjDRdqbXynpHXdXUToV1
X-Gm-Message-State: AOJu0YxQun80lS/gkQg7NYNYkXID/7V3xyGkvTc2WhkMcGmbiRrWuNzF
	N0KfKlIkNtCsBWexX/ym2RdOIsfYQiSieDoBhYLk9d35JKXAD/XUHwQ8bg4f3c4W4lAbszekF/v
	LDA==
X-Google-Smtp-Source: AGHT+IHQzstJxmu1IG9JpOOsDONGuF/54MDhI9Dz8RNrMqMts6Kod4+nByWRgKhyT0HouE8HuwUsvhZjW/o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5955:0:b0:5f0:7fc6:83a7 with SMTP id
 j21-20020a635955000000b005f07fc683a7mr8pgm.0.1714577373008; Wed, 01 May 2024
 08:29:33 -0700 (PDT)
Date: Wed, 1 May 2024 15:29:31 +0000
In-Reply-To: <20240403140116.3002809-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
Message-ID: <ZjJf27yn-vkdB32X@google.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
From: Sean Christopherson <seanjc@google.com>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 03, 2024, Vineeth Pillai (Google) wrote:
> Double scheduling is a concern with virtualization hosts where the host
> schedules vcpus without knowing whats run by the vcpu and guest schedules
> tasks without knowing where the vcpu is physically running. This causes
> issues related to latencies, power consumption, resource utilization
> etc. An ideal solution would be to have a cooperative scheduling
> framework where the guest and host shares scheduling related information
> and makes an educated scheduling decision to optimally handle the
> workloads. As a first step, we are taking a stab at reducing latencies
> for latency sensitive workloads in the guest.
> 
> v1 RFC[1] was posted in December 2023. The main disagreement was in the
> implementation where the patch was making scheduling policy decisions
> in kvm and kvm is not the right place to do it. The suggestion was to
> move the polcy decisions outside of kvm and let kvm only handle the
> notifications needed to make the policy decisions. This patch series is
> an iterative step towards implementing the feature as a layered
> design where the policy could be implemented outside of kvm as a
> kernel built-in, a kernel module or a bpf program.
> 
> This design comprises mainly of 4 components:
> 
> - pvsched driver: Implements the scheduling policies. Register with
>     host with a set of callbacks that hypervisor(kvm) can use to notify
>     vcpu events that the driver is interested in. The callback will be
>     passed in the address of shared memory so that the driver can get
>     scheduling information shared by the guest and also update the
>     scheduling policies set by the driver.
> - kvm component: Selects the pvsched driver for a guest and notifies
>     the driver via callbacks for events that the driver is interested
>     in. Also interface with the guest in retreiving the shared memory
>     region for sharing the scheduling information.
> - host kernel component: Implements the APIs for:
>     - pvsched driver for register/unregister to the host kernel, and
>     - hypervisor for assingning/unassigning driver for guests.
> - guest component: Implements a framework for sharing the scheduling
>     information with the pvsched driver through kvm.

Roughly summarazing an off-list discussion.
 
 - Discovery schedulers should be handled outside of KVM and the kernel, e.g.
   similar to how userspace uses PCI, VMBUS, etc. to enumerate devices to the guest.

 - "Negotiating" features/hooks should also be handled outside of the kernel,
   e.g. similar to how VirtIO devices negotiate features between host and guest.

 - Pushing PV scheduler entities to KVM should either be done through an exported
   API, e.g. if the scheduler is provided by a separate kernel module, or by a
   KVM or VM ioctl() (especially if the desire is to have per-VM schedulers).

I think those were the main takeaways?  Vineeth and Joel, please chime in on
anything I've missed or misremembered.
 
The other reason I'm bringing this discussion back on-list is that I (very) briefly
discussed this with Paolo, and he pointed out the proposed rseq-based mechanism
that would allow userspace to request an extended time slice[*], and that if that
landed it would be easy-ish to reuse the interface for KVM's steal_time PV API.

I see that you're both on that thread, so presumably you're already aware of the
idea, but I wanted to bring it up here to make sure that we aren't trying to
design something that's more complex than is needed.

Specifically, if the guest has a generic way to request an extended time slice
(or boost its priority?), would that address your use cases?  Or rather, how close
does it get you?  E.g. the guest will have no way of requesting a larger time
slice or boosting priority when an event is _pending_ but not yet receiveed by
the guest, but is that actually problematic in practice?

[*] https://lore.kernel.org/all/20231025235413.597287e1@gandalf.local.home

