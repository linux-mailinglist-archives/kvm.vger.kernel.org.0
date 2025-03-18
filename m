Return-Path: <kvm+bounces-41380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EB6A67477
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 14:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91801163F97
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 13:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F00D20C471;
	Tue, 18 Mar 2025 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VtvT6zqQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856D842AA1
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742302990; cv=none; b=IO8mOc4dUlNdNUywi0mQ8jrhM7JJmDx435VlgbJ4btw6n0vcMXYvksz0FBKeiR/7QcntSbgseRaS8O1FeZwN4FfypJ7lMJHub4aNe8xccko8xzd0X5FW9fS9PEzwEvED2KNfDU4OB4eKEA2+hlXN9dhQONore3FHXjrzGR2nGMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742302990; c=relaxed/simple;
	bh=83mJiQFk6O/J0Ri3zfmNXBdEj1xk+7UQUDMa6zXq1R8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fp6qH44uOZMrIorAb92AByJnXbXoIhutQdbgY4gTQPwbg9F7GL1ssfCdcBiPOquEcDoujUDGg+u9QWNvbUE3d3Jst0Ypodo3twBO/ebbqOTYmRPPHRjz85tG2ek6BQAVTL8UKNrDVIuNLeI2/OfOl4j5lOQp9EYMfTE9pS7T0Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VtvT6zqQ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394c489babso15984385e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 06:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742302987; x=1742907787; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=whP3Ztar/RkUapRVfDAPzBt4fOO+FCwNAyDQSaMiseQ=;
        b=VtvT6zqQw6EU5I54wA5+NaCLIK0h2XZ2nshxAX9YRw5Cv2S/c05r22QS2TA8MQ1S6E
         qA5M18k2G1JzVTxYMHerRNSfQ1jLY+60lhEzgdblg8GlZPfqlPbqgXMV9aiOaodO6Ukt
         1XBIZ0HcOyAQpGYJZ3eT1O7rV4wfPItoFzdS/H+vOdexS63nK9bmkEFNGjClWdQu9EYH
         l/FnJk07sYCcPGBV3BqcHyPa8I+w9ICFwIFekrdTiIm6vEAWwPQN6S7t/QysmJhcsUeM
         qIDMEebkyhQmWrxWhUDcYymMmsaqAoBO1s2ZvQ1xPZNqpwWDab/Ge30hBZEZxRhBNTqN
         /03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742302987; x=1742907787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=whP3Ztar/RkUapRVfDAPzBt4fOO+FCwNAyDQSaMiseQ=;
        b=kgzEM+AZPy9Y/L4/43QMA78PogK2fM8yA2ZMIBri8cvIOsHw4X1TLYvU5fiNXNtEdF
         hVUXFLR4HyO0jbIwMkv0L/vaaovTD8Ztzp9RcmIzS6+bemWWlAPEK5FIwY6+IDFX3qry
         2BNZS0CgSV9I30na7cqCPK0KDst+aSDY7G/AFmIneFfwoBikx+yEmZZtd/vjwZD3s5Cu
         l7xCNJNozbkYjE2NaoBlhIuyxOML8g91wx2MAwzCtlSQDBrk39kj7fgnJgyN0wjqOGb8
         Aug/gNBo+mGRQU2jrtOdiHCda5kP3CkAIl5Yu035DyorKh4oqNmSoA6Zn/OXQiKbyGt0
         S2eg==
X-Forwarded-Encrypted: i=1; AJvYcCUSkYE9rt3sG8YFVF1JjkoVEYQwqEpV+J9noR67o16MS66PykN0jHXRrWh3B00gGH5zHK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUlHs+XFRzNjlzvKmXarWCTjV36AhLMEYtGcp0HToEdZ2VU4nM
	ScrDLgPI+htjCzGwTlG3XkbVj/IxtGHxXHWslDJz8REPb9uIOY8pyPrr3mff/7Zeixnb0n7nY/D
	AWVr1eeeM8A==
X-Google-Smtp-Source: AGHT+IEo/v26Aru3DgRKudIcvvi5iVXlISbjRtcfMMClu/BOmgGyumhv1wki9aUCVQEAJDbjuPXzjomGr/lwuQ==
X-Received: from wmbes18.prod.google.com ([2002:a05:600c:8112:b0:43b:c7e5:66e0])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1da4:b0:43d:26e3:f2f6 with SMTP id 5b1f17b1804b1-43d3b950035mr23761825e9.5.1742302986910;
 Tue, 18 Mar 2025 06:03:06 -0700 (PDT)
Date: Tue, 18 Mar 2025 13:03:05 +0000
In-Reply-To: <4ce0b11c-d2fd-4dff-b9db-30e50500ee83@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
 <20250228084355.2061899-1-jackmanb@google.com> <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
 <5aa114f7-3efb-4dab-8579-cb9af4abd3c0@google.com> <20250315123621.GCZ9V0RWGFapbQNL1w@fat_crate.local>
 <Z9gKLdNm9p6qGACS@google.com> <4ce0b11c-d2fd-4dff-b9db-30e50500ee83@google.com>
X-Mailer: aerc 0.18.2
Message-ID: <D8JEV1QJHY6E.10X36UUX60ECW@google.com>
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
From: Brendan Jackman <jackmanb@google.com>
To: Junaid Shahid <junaids@google.com>, Borislav Petkov <bp@alien8.de>
Cc: <akpm@linux-foundation.org>, <dave.hansen@linux.intel.com>, 
	<yosryahmed@google.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <peterz@infradead.org>, 
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue Mar 18, 2025 at 12:50 AM UTC, Junaid Shahid wrote:
> On 3/17/25 4:40 AM, Brendan Jackman wrote:
> > 
> > I don't understand having both asi_[un]lock() _and_
> > asi_{start,enter}_critical_region(). The only reason we need the
> > critical section concept is for the purposes of the NMI glue code you
> > mentioned in part 1, and that setup must happen before the switch into
> > the restricted address space.
> > 
> > Also, I don't think we want part 5 inside the asi_lock()->asi_unlock()
> > region. That seems like the region betwen part 5 and 6, we are in the
> > unrestricted address space, but the NMI entry code is still set up to
> > return to the restricted address space on exception return. I think
> > that would actually be harmless, but it doesn't achieve anything.
> > 
> > The more I talk about it, the more convinced I am that the proper API
> > should only have two elements, one that says "I'm about to run
> > untrusted code" and one that says "I've finished running untrusted
> > code". But...
> > 
> >> 1. you can do empty calls to keep the interface balanced and easy to use
> >>
> >> 2. once you can remove asi_exit(), you should be able to replace all in-tree
> >>     users in one atomic change so that they're all switched to the new,
> >>     simplified interface
> > 
> > Then what about if we did this:
> > 
> > /*
> >   * Begin a region where ASI restricted address spaces _may_ be used.
> >   *
> >   * Preemption must be off throughout this region.
> >   */
> > static inline void asi_start(void)
> > {
> > 	/*
> > 	 * Cannot currently context switch in the restricted adddress
> > 	 * space.
> > 	 */
> > 	lockdep_assert_preemption_disabled();
>
> I assume that this limitation is just for the initial version in this RFC, 
> right? 

Well I think we also wanna get ASI in-tree with this limitation,
otherwise the initial series will be too big and complex. But yea,
it's a temporary thing for sure. Maybe resolving that would be the
highest-priority issue once ASI is merged.

> But even in that case, I think this should be in asi_start_critical() 
> below, not asi_start(), since IIRC the KVM run loop does contain preemptible 
> code as well. And we would need an explicit asi_exit() in the context switch 
> code like we had in an earlier RFC.

Oh. Yeah. In my proposal below I had totally forgotten we had
asi_exit() in the context_switch() path (it is there in this patch).

So we only need the asi_exit() in the KVM code in order to avoid
actually hitting e.g. exit_to_user_mode() in the restricted address
space.

But... we can just put an asi_exit() there explicitly instead of
dumping all this weirdness into the "core API" and the KVM codebase.

So... I think all we really need is asi_start_critical() and
asi_end_critical()? And make everything else happen as part of the
normal functioning of the entry and context-switching logic. Am I
forgetting something else?

