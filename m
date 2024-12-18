Return-Path: <kvm+bounces-34080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 103719F6F85
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 22:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E789418939AA
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 21:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F811FC7E7;
	Wed, 18 Dec 2024 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PNYL+0JO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F60815C120
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734557819; cv=none; b=fNMm3NA2C9Yj4ppaXWTznZZxt0lxyejU6uJWvC8WWitCWjzcW3roMY4NUJVFnY3jCvaAlaxoHboKXeAgOyZJmaQFBkNReAFDwUfAWhay7fxipdkJA+HcR34ACv1ShftXmuVjVbhEZfsv67A/yQs2gnSjx/lcCvvE0Vkok9Mhz7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734557819; c=relaxed/simple;
	bh=XPuo/CZn2Usv+9YMqDzuAf+BZP+rPD7a5SSHClAT9sI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HyDB+TNo3TwEfM8VuK6VuGHs/SCGzLCCJqYvOf6mEacZFEBb5wJaB/lIGncV5c7SK0bkU71lfZz4qDJccta+heRS5eF/J7o3jfk9oBCMHYUvHqQ9dRIDtqMTwVKIHFUjLESfmhBCdMe/KvOqEWq7yBNMTxT9cnaxqBO+8b2/d5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PNYL+0JO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee6b027a90so147057a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 13:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734557817; x=1735162617; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EyaJhiMjuIL9HY6dyZK3annl/R0dDwtO/JJB1kPLtXM=;
        b=PNYL+0JORonSRK25prudWpEFm9Qe7/mSCT8qqlw5G+jvSPOhCiLPLzwFovPjVlmfQ2
         2PIH9IVlInKYZoiYwa6drNRJmXlm5U18CXt+jy67NE5KwHhYD+Wt+nY3w6tAVEa17V1F
         jdBP3MYKWYChbx9b5Mi/reZ1uKyTP6aztG+9+aR9vZ6n6hm4pHkQH8ZaRWNe/lTDpC85
         UKN3KTDtpQkbuUyXNqunEuuNdqF2G2WfnggZopEFpxD9pYLNpO56PfR8OH/NkQlHawFu
         WxRAEa/qTTCYeVKCgWujEYztOjQ6hvrdfV2t3WjQMhBmlOskIi96OfdW/1qrcmv+nGOi
         W+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734557817; x=1735162617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EyaJhiMjuIL9HY6dyZK3annl/R0dDwtO/JJB1kPLtXM=;
        b=Ay/3CAbLcB3qQWAZBBlLBXBJJv4r/+H8JBvm/xaEBQkdSz4Yk6tocMQfYbB5yFDDNJ
         wdC021N8ME3WVUa+ZMfKNbIayPQZgoY4f1mL5U1NVRXSB8LmBIZAaRQ8yHH7LHQpBKbN
         9OoFCWkhz8V7fkNtiNL8GKdgMh33LQ7ItYEG1kBkp+8+06SGMiHo9RGianHYZYbLUfuH
         C0xzWV35+96VcdMkRt0O7DwwY7Axn0szbUm4qm5cymD81Bc25qV4aXC47XY1T1u1EYbZ
         /SwQ+eB5q5UJd214fxUuV0lligwYORWW2W0rPrGeMHQ8k/Q7CSMHFuxC0Ed7iAX8dUH/
         UaZA==
X-Forwarded-Encrypted: i=1; AJvYcCXeRhHRjfQr2aX4ixTkUEXPYWZ/T+7zc6R3897PabmDhc7Yzywqdt3EwkDxLYQ1j5cDZVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXSZkQuT7a3xufx3zGg+roUAAIJIpUxEJfSImJo6LbKXmN/SYq
	Dkw7I63g6hXNakBcSqLdXONoRwICNNztwRh3C3GlAtUBPVx5e4EJVQpglhxBTV5HjGicnoW8ST4
	E0A==
X-Google-Smtp-Source: AGHT+IHMB5G/YaAxG4Rmui13Dlu0Ftb95T2/skLpSUbdJAmz3y6tgGwkpKUDfoCoCCHcVKSk8CO9mYVVar0=
X-Received: from pja15.prod.google.com ([2002:a17:90b:548f:b0:2ef:9ef2:8790])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ed0:b0:2ee:c4f2:a76d
 with SMTP id 98e67ed59e1d1-2f2e91f9f3cmr5450681a91.21.1734557817474; Wed, 18
 Dec 2024 13:36:57 -0800 (PST)
Date: Wed, 18 Dec 2024 13:36:56 -0800
In-Reply-To: <f91364794fd3d08e2eb142b53a4e18c5b05cb7c4.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com> <20241214010721.2356923-3-seanjc@google.com>
 <f91364794fd3d08e2eb142b53a4e18c5b05cb7c4.camel@redhat.com>
Message-ID: <Z2NAeH4wXTr-bvcb@google.com>
Subject: Re: [PATCH 02/20] KVM: selftests: Sync dirty_log_test iteration to
 guest *before* resuming
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > Sync the new iteration to the guest prior to restarting the vCPU, otherwise
> > it's possible for the vCPU to dirty memory for the next iteration using the
> > current iteration's value.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_test.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index cdae103314fc..41c158cf5444 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -859,9 +859,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >  		 */
> >  		if (++iteration == p->iterations)
> >  			WRITE_ONCE(host_quit, true);
> > -
> > -		sem_post(&sem_vcpu_cont);
> >  		sync_global_to_guest(vm, iteration);
> > +
> > +		sem_post(&sem_vcpu_cont);
> >  	}
> >  
> >  	pthread_join(vcpu_thread, NULL);
> 
> 
> AFAIK, this patch doesn't 100% gurantee that this won't happen:
> 
> The READ_ONCE that guest uses only guarntees no wierd compiler optimizations
> are used.  The guest can still read the iteration value to a register, get
> #vmexit, after which the iteration will be increased and then write the old
> value.

Hmm, right, it's not 100% guaranteed because of the register caching angle.  But
it does guarantee that at most only write can retire with the previous iteration,
and patch 1 from you addresses that issue, so I think this is solid?

Assuming we end up going with the "collect everything for the current iteration",
I'll expand the changelog to call out the dependency along with exactly what
protection this does and does not provide

> Is this worth to reorder this to decrease the chances of this happening? I am
> not sure, as this will just make this problem rarer and thus harder to debug.
> Currently the test just assumes that this can happen and deals with this.

The test deals with it by effectively disabling verification.  IMO, that's just
hacking around a bug. 

