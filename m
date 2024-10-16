Return-Path: <kvm+bounces-28962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C5B99FD01
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 02:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A8D51C24514
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 00:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4881EA933;
	Wed, 16 Oct 2024 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nNRxxStX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC750524F
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037832; cv=none; b=YRH4zFJyCYxamYpQPFQUdI7Nwp1WSEWi2peQ1rrWpbELPtYFFVkR75QNPlBDfGnFZC9Of5WdP+dTCWh/Q88Uqz+CrSNRvx87pvjH6FLBA7SOy1YaOTmQCS4PLmEAzMg9nr45L6GRwVCThhxtvTLDG8VPCZL/4umfQ+qEcI4vU4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037832; c=relaxed/simple;
	bh=Oi12u80iF5a5zrEGBQ+EomOdDgJDclTmP2OMI5Lmhfk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QDjQZ7cvXeBtBVkiESy0uW25o+pdK1dG/1QjKu7q9asE+QijxJljAz0yZse6CU52WD5OplpK2yhuiV+4/qhDplwRPu6sn1NGG8D+9iF2/IJu6TUBYKR2NN5b5SkZnjkLczB5jYUKuo1BO0EA5LhdK42iuyWIkklCKkXboQSg27c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nNRxxStX; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3705b2883so48894467b3.3
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 17:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729037830; x=1729642630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YIMG7wiGkBXbsz5ZL09Q+YNC60/nBpUsB21eUirnxYc=;
        b=nNRxxStXHWAFGxv+5gtbQLnMPMyFZ91UyL5+xZbbBfslz2fvvwyafOfJRK+wJ+M7WJ
         sP3OXVLBAkg/GNaOxiyEdrsE2NgytUY9EqEWwqzCscNHlbSgzrLzkjEtta1Czdb70EMt
         pU90AwSuDkSgzFJwtAmx4vT8eV8AFN+/oNdWoS6yx8F9p4qVhASSZD1fV+0C2Qye/Ay5
         HCUkHeUI1ARN/7gRgJQ7k4Y+/owICFcEqfdjXAA/EygfvzTUVjJeJBWFJrVpxPLQJ1u+
         K77WZ3NiY0qf6pHse3j9jw1ajOkDVkAc5LKM+WviEhuuFp/i/SqpiEr0+PFVPFeQBoJx
         jIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729037830; x=1729642630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YIMG7wiGkBXbsz5ZL09Q+YNC60/nBpUsB21eUirnxYc=;
        b=MeA4bF4YuZNFVLPpGycDJ+bUb1J6X2sIF7CSlAjp4X8TBzdPL3eKmOh53f6EsWkkQ0
         t9tJss5Gaefob0MMF6/nxjUEGgnUDJ53oH60IGXbsuxjuEL/Y3bPNfq2CPlbIpmKZNMV
         n/hVBzUcnZb6+eYhi9k7MZNsUUMWUvmm6sHuvC5gyTRxJc5eY7rc3c/wj9j1kSA9f08W
         kXK6I+bFdt9AwT6YSRsRYx1oLHOE5lqKIctJ/Kz43quGojnf+ziKeEblHb1FFP6Qlq3c
         2u/xWjfjxWp00vQpZ1yZFv64iQE/mvLDGVu8IouRTzlxGSHuWTr+izyeUPFc5LG7Tku+
         wlIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXri7BY1zkY2h4RDhUk3j5qduA2wj4cTtp6/K2PGnXKvI/qrRgYVmnvuwhisc0ZKKHAtOw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIOITydBKWWvWbH5Hqd7nhQB4UYD4/770NX3x0ZOVG/nwvXCa9
	g8mBo3p3ZKPgZh6qlX1nkd6AQl6uMi41l4Ptw8UKQwLnSbMZOv7wIrsZIFPK4zWj/dFD39Hv8Xm
	0/w==
X-Google-Smtp-Source: AGHT+IESdjRpRsglMZAGnwe25/AC94X0z+KtVW2TonxYtzy/w7rLciLkqmEjL7Nihu4PZvz6UnIexnCj2oM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ad64:0:b0:e16:68fb:f261 with SMTP id
 3f1490d57ef6-e297830baadmr1006276.5.1729037829792; Tue, 15 Oct 2024 17:17:09
 -0700 (PDT)
Date: Tue, 15 Oct 2024 17:17:08 -0700
In-Reply-To: <20240821202814.711673-4-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240821202814.711673-1-dwmw2@infradead.org> <20240821202814.711673-4-dwmw2@infradead.org>
Message-ID: <Zw8GBOtvNhPhSzuw@google.com>
Subject: Re: [PATCH v3 4/5] KVM: pfncache: Move invalidation to
 invalidate_range_end hook
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Mushahid Hussain <hmushi@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 21, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> By performing the invalidation from the 'end' hook, the process is a lot
> cleaner and simpler because it is guaranteed that ->needs_invalidation
> will be cleared after hva_to_pfn() has been called, so the only thing
> that hva_to_pfn_retry() needs to do is *wait* for there to be no pending
> invalidations.
> 
> Another false positive on the range based checks is thus removed as well.

...


> @@ -261,6 +239,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  			goto out_error;
>  		}
>  
> +		/*
> +		 * Avoid populating a GPC with a user address which is already
> +		 * being invalidated, if the invalidate_range_start() notifier
> +		 * has already been called. The actual invalidation happens in
> +		 * the invalidate_range_end() callback, so wait until there are
> +		 * no active invalidations (for the relevant HVA).
> +		 */
> +		gpc_wait_for_invalidations(gpc);

I'm not convinced scheduling out the vCPU is actually a good idea.  At first
blush, it sounds good, e.g. why consume CPU cycles when forward progress is
blocked?

But scheduling out the vCPU will likely negatively impact latency, and KVM can't
predict when the invalidation will complete.  E.g. the refresh() could have come
along at the start of the invalidation, but it also could have arrived at the
tail end.

And if the vCPU is the only runnable task on the CPU, and the system is under enough
load to trigger an invalidation, then scheduling out won't provide any benefit
because odds are good the processor won't be able to get into a deep enough sleep
state to allow other logical CPUs to hit higher turbo bins.

The wait+schedule() logic for the memslots update is purely about being deliberately
_unfair_ to avoid a deadlock (the original idea was to simply use a r/w semapahore
to block memslot updates, but lock fairness lead to a possible deadlock).

If we want to not busy wait, then we should probably do something along the lines
of halt-polling, e.g. busy wait for a bit and then schedule() out.  But even that
would require tuning, and I highly doubt that there will be enough colliding
invalidations and retries to build sufficient state to allow KVM to make a "good"
decision.

If you (or anyone else) have numbers to show that blocking until the invalidation
goes away provides meaningful value in most cases, then by all means.  But without
numbers, I don't think we should go this route as it's not a clear win.

>  		write_lock_irq(&gpc->lock);
>  
> @@ -269,6 +255,13 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  		 * attempting to refresh.
>  		 */
>  		WARN_ON_ONCE(gpc->valid);
> +
> +		/*
> +		 * Since gfn_to_pfn_cache_invalidate() is called from the
> +		 * kvm_mmu_notifier_invalidate_range_end() callback, it can
> +		 * invalidate the GPC the moment after hva_to_pfn() returned
> +		 * a valid PFN. If that happens, retry.
> +		 */
>  	} while (!gpc->needs_invalidation);
>  
>  	gpc->valid = true;
> -- 
> 2.44.0
> 

