Return-Path: <kvm+bounces-47185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A37ABE6D3
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 220474C6732
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC3725F790;
	Tue, 20 May 2025 22:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yPSITkon"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEC0252906
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 22:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747779604; cv=none; b=oWS9qWPcwGAdw5+rpngbm2oDpZXkHWnptpVV3Tnzz89EopPHFkYPHrktpuzNOiJBfQuLd4Rpzqx/3z8KWiTCtCzEnesmKVYFTd59X3nI2YVcL3F0MKlVBxM90/EhKkchJtnmKAtdK82DKINfsLH3bEfMH10UXuuZJg5t4pFM6fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747779604; c=relaxed/simple;
	bh=yAGEzQUXdc/wVqTOY22PEJhqYz72ZGCmkjww4aZKXSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ToxYVjptOq8yk+q+jpV5ye4id0QD+bBZyPCYDmB8hTmDY7IShstWlrQoGwv8b7rLVzO581niJr5wTkFMIXTrDNtEl7O18u8sc0XS4W5aZLCXpPe6LGO8cxMz4JOICVK7DlSVnsVhQ6GYndRAbcNgU9K9MV2cY3/8BXci5dxH4F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yPSITkon; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e9b2e7a34so3152743a91.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 15:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747779602; x=1748384402; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8HKYrw1mX2rWYU9hhnTeFvSQNlJmWd9SuBazr4xA8xE=;
        b=yPSITkonmFP/ayz7YCCGBVhCVQUG2m+821CZclbqmtnFUpMXjJMylWsE0Tgc+5QN9j
         cqTwHYCKEnuGxBrK1c1cFPhpAZLv7xyImcDrIx+VazeSSJjtLPe0H53tEzF8774eZLy9
         qyN3wA8T2oR66rCn/0e36FioO7VaLMnO4TdISsixaD7zGSr1Vid8m8LhigiMgPuFpgk8
         qTjUuAsvCl+0xmno/l7HSBB7jgLGyUQuUT3QUQVmdH+2390tQQLaUNat2bc1EpQ7seDG
         Yy6aSKlWrHMGVQF7En6gUlcaRQUgQoMCw8IK+qZULVUAy54yIQXqvvMiCvckhcFFmeMe
         sNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747779602; x=1748384402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8HKYrw1mX2rWYU9hhnTeFvSQNlJmWd9SuBazr4xA8xE=;
        b=sADhUW7NLXTwoJz/aBw2kZZJjafHfYWLhAJuhd5koMITI5pIX2otgNFtg32SUHmwF/
         gVJ/EWvoxPFT163ByK8Ug/IN7AnJEt2G4vwbP9M6gb4R7PHq26yLBXTCybH+suK74kyW
         Yzk5aWvMRfninG9giw2+VwhF1vcMUkqsnf23fs4TDxuw3iU0PdvmgCUe7PxlGPqV/WOj
         q44XQgPW76H6G0QjRoz4udxoIVl2uQMEgH+fxgNlzMaH7rxfK+FgZXzQmLGakJt2nqGi
         YOxFHEJ1d1EDS0Ep3kpi2HnUOuu0c/R/YINX1GPL+3MqMMKrFiJnnunTtcAk5i0l7WQM
         fgEg==
X-Forwarded-Encrypted: i=1; AJvYcCXG9kmbVtirIHpRDD9SdfWP8pD3EGqmC3PgROWS+eSr1Jc52m+1VZaxamU2tFB6EnbMLdM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6LIh4B1AiS+Qm9qjAFE9ZYAx/eF5wkJJWcgFVw7EzHX4+xP+J
	JHJ46Ad4KFoSPcwgZw3f0r3pNI5A4wIsYxiX5q9F/BI+eiAwLmV6IxQ7DG/7Z/3fp43L2ZiDCUn
	G0R1kxg==
X-Google-Smtp-Source: AGHT+IGm0Qd18FrnDfhlG7/JjUl4lMpy15ihv5+w3UyMikyFwPD+eN8+5DcFhlZu44RxRjwOsuD2Z657iBM=
X-Received: from pjoo5.prod.google.com ([2002:a17:90b:5825:b0:2fc:e37d:85dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5188:b0:305:5f28:2d5c
 with SMTP id 98e67ed59e1d1-30e7d558d26mr28473120a91.15.1747779602268; Tue, 20
 May 2025 15:20:02 -0700 (PDT)
Date: Tue, 20 May 2025 15:20:00 -0700
In-Reply-To: <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com> <20250519185514.2678456-9-seanjc@google.com>
 <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
Message-ID: <aC0AEJX0FIMl9lDy@google.com>
Subject: Re: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 20, 2025, Peter Zijlstra wrote:
> On Mon, May 19, 2025 at 11:55:10AM -0700, Sean Christopherson wrote:
> > Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() to
> > differentiate it from add_wait_queue_priority_exclusive().  The one and
> > only user add_wait_queue_priority(), Xen privcmd's irqfd_wakeup(),
> > unconditionally returns '0', i.e. doesn't actually operate in exclusive
> > mode.
> 
> I find:
> 
> drivers/hv/mshv_eventfd.c:      add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
> drivers/xen/privcmd.c:  add_wait_queue_priority(wqh, &kirqfd->wait);
> 
> I mean, it might still be true and all, but hyperv seems to also use
> this now.

Oh FFS, another "heavily inspired by KVM".  I should have bribed someone to take
this series when I had the chance.  *sigh*

Unfortunately, the Hyper-V code does actually operate in exclusive mode.  Unless
you have a better idea, I'll tweak the series to:

  1. Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() and have the callers
     explicitly set the flag, 
  2. Add a patch to drop WQ_FLAG_EXCLUSIVE from Xen privcmd entirely.
  3. Introduce add_wait_queue_priority_exclusive() and switch KVM to use it.

That has an added bonus of introducing the Xen change in a dedicated patch, i.e.
is probably a sequence anyways.

Alternatively, I could rewrite the Hyper-V code a la the KVM changes, but I'm not
feeling very charitable at the moment (the complete lack of documentation for
their ioctl doesn't help).

