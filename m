Return-Path: <kvm+bounces-30796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5319BD5D7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:29:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84B51B21C11
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312321FF7BE;
	Tue,  5 Nov 2024 19:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XemYl18E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F321D5AD3
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730834935; cv=none; b=N+5TiykOkwVcQ+Q71+GwzeevQ/DonaPMVMcCAQe5oAEcHQK+kOPgNrN27J2qNkG+gRGHh2p/oUCW2+IXeI+6bWBpL6o+cRr7jwUKU4sJ/C+MN7/oQ2k2NP2jrO3fYaOSGWQQnkex/oOOwEvWHd4HOOmptTlzc3iEN7eo5WgqiOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730834935; c=relaxed/simple;
	bh=aV1GBmfWwECTnh3xy+hQGhDmcKjtbAaLxtRrWStQAok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kczCDhiQpGw2kXIHyGu9WC0qj1RtLmzJFkqaRCIleeFhc0oW4PR7KmUU3I7Wp5ROaOn57uQQGtrOEyiwXhMghh6W39lhrXUun5mTsOiyLuiRR38ecEpGCFFeq005fAwB1xnl5bd5lsLj9UG7zUEZuxfXA7QozXRKrsT3HX5vk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XemYl18E; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-50dc984bf5dso1975823e0c.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730834933; x=1731439733; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aV1GBmfWwECTnh3xy+hQGhDmcKjtbAaLxtRrWStQAok=;
        b=XemYl18ENZvN3AhGGy3XPGd12REf7WovqpTjFmmZIXTXk+o211g4aJoIPUYwLG9HWp
         tPGwXdVyf8WtMYtIQDZ0ddu6tNh2h7Yq6bjLBI088sF7j0VCK0eqfWx3wLleQbZUJS2s
         1raZ4CBlvilr/k8+gsB133lxGAd3Q8vrRnEcGbml/5WMnuFS4qFYZozArZXAFiy4axQF
         Kqpsicibe5EoSuxlEEj1DcXj1nojPYEWop06rg4dX/7Vv3QY4wJq0IK8nOgZBm5pmx94
         wu2jQYvfV1UpsVQg/aoN3oz8JwmT9mV/lj0nfTmZeFkEK0FXBQsC4RABN69eLcuxlhMM
         KUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730834933; x=1731439733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aV1GBmfWwECTnh3xy+hQGhDmcKjtbAaLxtRrWStQAok=;
        b=F7NzoM2SRBHkCP/UuEB6b+ldCtMZ5WwJYOtfQhQAu86zFm74qGljtHfoAIjOAPsbPi
         n4dnsNnWMCsWbxux2QQ38R6CpklrKuN6HHLiaacUj5sTqzb6fqA+y6t+Dp6C6C4vE38O
         gcKeBbTxXZhemnN0mqaMr2iK58EH6oDx9KGBPPbwa5gh26IQfrYw/95HCfZu4h+hE2nf
         hBQJA4z9dYMwSm66UIcY2Ug+5FjOeYKB0TUtZU1i1YZDqn2FxM6juWP7WKGmRC2gSjSc
         bYZPN/46zqbDQiHdgimMlMr5edQp/XIdbPIowVeK+QxV0qIU2vY4qSOX2uC2m0k0K71v
         zI+g==
X-Forwarded-Encrypted: i=1; AJvYcCXoNV714ylO9yx8AseoYLsu1Zelzw/l+zxx4D0SpVgfdw9wAybxvFxWcrzGRA/mQ45ly1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp8CtaUqE7tjYg1FS519hMRSShcA79yYb3jo26AAv+MVbh8vk6
	UdaiiX8QXWx7I2e4vok/goZWznbkIPcsogkNep+0MUrl49DcTdTPhAkQoixbtafIv/uB+kgO0pF
	WsLjVQvp/0irWC86TT2jhEGxOggiOei4gh1pD
X-Google-Smtp-Source: AGHT+IFPlCCiewSZ6qz8bcLHkHivbB20ubjuUQ31T2KZYTtpAPhMRahB4La6g3xvfoM46VOamf93kqFuQDDNQFJVMtw=
X-Received: by 2002:a05:6102:1890:b0:4a9:61c1:4e56 with SMTP id
 ada2fe7eead31-4a961c14ea1mr12336943137.13.1730834932474; Tue, 05 Nov 2024
 11:28:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <CAOUHufYS0XyLEf_V+q5SCW54Zy2aW5nL8CnSWreM8d1rX5NKYg@mail.gmail.com>
In-Reply-To: <CAOUHufYS0XyLEf_V+q5SCW54Zy2aW5nL8CnSWreM8d1rX5NKYg@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 5 Nov 2024 12:28:15 -0700
Message-ID: <CAOUHufadf0kmHTY4=gvMtm4LfFFjijYHWmX5VcYqwDEhw18=+A@mail.gmail.com>
Subject: Re: [PATCH v8 00/11] KVM: x86/mmu: Age sptes locklessly
To: James Houghton <jthoughton@google.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 12:21=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrote:
>
> On Tue, Nov 5, 2024 at 11:43=E2=80=AFAM James Houghton <jthoughton@google=
.com> wrote:
> >
> > Andrew has queued patches to make MGLRU consult KVM when doing aging[8]=
.
> > Now, make aging lockless for the shadow MMU and the TDP MMU. This allow=
s
> > us to reduce the time/CPU it takes to do aging and the performance
> > impact on the vCPUs while we are aging.
> >
> > The final patch in this series modifies access_tracking_stress_test to
> > age using MGLRU. There is a mode (-p) where it will age while the vCPUs
> > are faulting memory in. Here are some results with that mode:
>
> Additional background in case I didn't provide it before:
>
> At Google we keep track of hotness/coldness of VM memory to identify
> opportunities to demote cold memory into slower tiers of storage. This
> is done in a controlled manner so that while we benefit from the
> improved memory efficiency through improved bin-packing, without
> violating customer SLOs.
>
> However, the monitoring/tracking introduced two major overheads [1] for u=
s:
> 1. the traditional (host) PFN + rmap data structures [2] used to
> locate host PTEs (containing the accessed bits).
> 2. the KVM MMU lock required to clear the accessed bits in
> secondary/shadow PTEs.
>
> MGLRU provides the infrastructure for us to reach out into page tables
> directly from a list of mm_struct's, and therefore allows us to bypass
> the first problem above and reduce the CPU overhead by ~80% for our
> workloads (90%+ mmaped memory). This series solves the second problem:
> by supporting locklessly clearing the accessed bits in SPTEs, it would
> reduce our current KVM MMU lock contention by >80% [3]. All other
> existing mechanisms, e.g., Idle Page Tracking, DAMON, etc., can also
> seamlessly benefit from this series when monitoring/tracking VM
> memory.
>
> [1] https://lwn.net/Articles/787611/
> [2] https://docs.kernel.org/admin-guide/mm/idle_page_tracking.html
> [3] https://research.google/pubs/profiling-a-warehouse-scale-computer/

And we also ran an A/B experiment on quarter million Chromebooks
running Android in VMs last year (with an older version of this
series):

It reduced PSI by 10% at the 99th percentile and "janks" by 8% at the
95th percentile, which resulted in an overall improvement in user
engagement by 16% at the 75th percentile (all statistically
significant).

