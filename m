Return-Path: <kvm+bounces-47182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0873ABE53E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5367B4C5DE7
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672A721423C;
	Tue, 20 May 2025 20:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ov+kSPuw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149BE7DA8C
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 20:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747774624; cv=none; b=QN1oMgBNnfC4uLvKCm5jRAsZaJq1kZ8Br4exaXIMKKfmy5e4D5QcThQNfgTIL7K8uLEl7mAFafOwUbonhAKouJnuCI0KiPm8EElTqEU7oAhfjwH0Dfq2e5PPadmM8rCdCqezqRFm5O3tEmuWqzMitTqffCOP1E3fGQGic4Xg4aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747774624; c=relaxed/simple;
	bh=4NVAqMmE/xJIFdHB7+CceGBJ43TCYvrJvvG0LTTS2Ps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XpEt7tOQ9b/rk15LbMMGEDjO8BAOwkXinvRLk1c+qqMu2uaGR+Fy7zZO1XZsCmKlQ3w64ZnLlIMySYcGfgdzieBkXaK4xu2Q5iqWENFxV6jok9hd45u548Bcym0nNgult0BKVPXBlZrr3mFv++X7d2NZxonoPXLNdzBigs3uhIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ov+kSPuw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c9b0aa4ccso5852442a91.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747774622; x=1748379422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKutgaWFEQ+3gu/ouPLFwWIwK8y5oHoRF19CwGZ+S/c=;
        b=ov+kSPuwGREzGhEk/6rPaJvFmOnkVhMx736btHmwNlHQPgFYn91dRwtEzUmdjnuBPb
         GwFeL7VPPly6FlEzx1bZzy56ULs3xC9O+W0Y3qoqCp+PCIvNJvyZ4u6cFZASbsFakxqa
         SlxsN51uPvp8mntIZTZOPZF1jrNhmpNojPJYifcJW9hbHXNb1BS7yQdgWY4qdfsUhy9M
         P658VEsf/a+VXFkS+UhH8h6dO3g5HTHyb6FBykR9NKfn5QI8PrtZnur8uR4BjPUkXxc9
         r0xJVf9T7x47XNESs+srni6czVycphFIElekLYWOUdpieB63hcDXVXe5y4CD2t7njkBk
         6nZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747774622; x=1748379422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKutgaWFEQ+3gu/ouPLFwWIwK8y5oHoRF19CwGZ+S/c=;
        b=pzldftucNAegzSnAJaZWOm/leJJwwK/c9NQiNCoz/FYUQ+s5KeMc1gfWDQGkD4r9I/
         Zs7lwBuKqni7zISMVSYTMp1t7sPjMnqXuotI4rpcBcicvFI75yxM24hrIpL0j6F1LLwV
         Vi+iUli1v0OjLHZ0lAwyiazBXM+Gyv0PLdiaX1QJzoA1HVzCw38Mfb7vU4duNoWxSSAE
         XAiPj924kofVzoNHEL46f8ucKzUU+fr6JBxZKLxAGvvUfiEg8a/xN8UHc0IIRg+uvtdI
         FNPTytwUG+DoEl2jFUx/IanzyUz32ZJX4YRQsXsaPzmJevYPxfoH+OnA540JWbOdD07r
         fLNA==
X-Forwarded-Encrypted: i=1; AJvYcCW2tg74Fx8yhK7jNtd7UaOKjECoOBMrlL9s2UJEILKBIQ7lJ+4jtWdltq6CnEMiVWEyzx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJcxNPBJ6d+Cht1EZpliGDZDLc47WRyoyXji0pEUrcjCB4rhdk
	9nFxAN3FIhYepe2FVi6Ggazz+bKhXjG8KOF0ciGjuU6tcUqvlnkqH78FnShgCnOi7VqOV775Nz5
	KDuzGnw==
X-Google-Smtp-Source: AGHT+IFjfH39vLCcnXRNh1tmz9SqmTftxmR4IbkXgvupWrNryIrlY6xpDKX1XUbGhNR1KVx0wuk++Q37G+U=
X-Received: from pjbli1.prod.google.com ([2002:a17:90b:48c1:b0:30e:840f:131e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1846:b0:2ff:6488:e01c
 with SMTP id 98e67ed59e1d1-30e7d5bb354mr29441493a91.29.1747774622388; Tue, 20
 May 2025 13:57:02 -0700 (PDT)
Date: Tue, 20 May 2025 13:57:01 -0700
In-Reply-To: <20250520191723.GI16434@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com> <20250519185514.2678456-7-seanjc@google.com>
 <20250520191723.GI16434@noisy.programming.kicks-ass.net>
Message-ID: <aCzsnXPQ0TtKtqu9@google.com>
Subject: Re: [PATCH v2 06/12] sched/wait: Add a waitqueue helper for fully
 exclusive priority waiters
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
> On Mon, May 19, 2025 at 11:55:08AM -0700, Sean Christopherson wrote:
> > diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> > index 51e38f5f4701..03252badb8e8 100644
> > --- a/kernel/sched/wait.c
> > +++ b/kernel/sched/wait.c
> > @@ -47,6 +47,24 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
> >  }
> >  EXPORT_SYMBOL_GPL(add_wait_queue_priority);
> >  
> > +int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
> > +				      struct wait_queue_entry *wq_entry)
> > +{
> > +	struct list_head *head = &wq_head->head;
> > +
> > +	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
> > +
> > +	guard(spinlock_irqsave)(&wq_head->lock);
> > +
> > +	if (!list_empty(head) &&
> > +	    (list_first_entry(head, typeof(*wq_entry), entry)->flags & WQ_FLAG_PRIORITY))
> > +		return -EBUSY;
> > +
> > +	list_add(&wq_entry->entry, head);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(add_wait_queue_priority_exclusive);
> 
> add_wait_queue_priority() is a GPL export, leading me to believe the
> whole priority thing is _GPL only, should we maintain that?

Oh, yes, definitely.  Simply a goof.

