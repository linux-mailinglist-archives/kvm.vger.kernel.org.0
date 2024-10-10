Return-Path: <kvm+bounces-28476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3DA2998FD2
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3E4B1F25658
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205931CEE85;
	Thu, 10 Oct 2024 18:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0JwQEt2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621E19D06D
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584638; cv=none; b=kdT5cTuRiAmaf955uCDSvkTM9OUiJd1LJBsa/rL9wfhlmAnQPkAgCijPXh7q+tpQ6fjdCXbjmM5ZXavfninp0pIjvkeM4pNgLMJHOa8TefSBUcBeBALzKbXlyYCY65R9Ob+QgzeAVKjtXqtjXQZO/1yp9DygFrnJ9XW6LdnIlD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584638; c=relaxed/simple;
	bh=Wmg0PWvt3WloQSDzy40kPeWutCLR/9gx0+GwUl5x7Rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CwHLYsQ++VHizVbKtHW44f4rCzCs2a1cMwDHXydxJ8bUdXuiXYuMXFNIV03yrsFOa1AK66rEyOwkn07swg7V6ZLfrqL6yPrfXAl4yJWMiDqhZfnMETDQPc4s4pMLFLdiV0X2gU9l5LGRNLBUmZMsUjL5tZbP9KjEysgROgdZ+3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0JwQEt2; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e2baf2ff64so22451957b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584634; x=1729189434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqewRWhuvMwo0Bco6jB7T6q+2ZKwD2xyzgsyOWDZbow=;
        b=s0JwQEt2ps+OyXU5RZG6JiilD0HFAADPnWVy+nKLZTSvB+/WQCf4U7nJn6YXj3cnkk
         Yf4mTlUQeoqm2EUY/zkccOJX+yY505wIDEUggufsXKty5o7WKfIgiR70ZEe1zwxFIjkp
         WWaXXLI8gKkX9RYhB/Pfgz7OOdA4/nfmNYAgkt1gs45Oo8eg8XT04ZgZDvYHvm83pZnz
         aiGJxQRZsdylzO4TZot35N+yy8e6cuezGCOxogvPgSHIAMD9lJzqNVomzm1cNNCfjbWM
         VGmROtDMzP3Uq4aLXR58y37nTGOGzDFyo56OSy6Ulw/bZrn3KyjXmsJbV96KuW2sA8i5
         b3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584634; x=1729189434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqewRWhuvMwo0Bco6jB7T6q+2ZKwD2xyzgsyOWDZbow=;
        b=kHiXT/o6ZWAbuAdDaS5tossDWrkSp2BEBFL1oEvZh/sCzBEcALXPLVa2CSoJYtxMz6
         9PmeO7wrMXelbI1MQb2j02Zg9K5FVwpFCc9RxhguEswHfB72ZSto3Ycgb+wBHwT2cxJ+
         XVpKFFECvX+pfUeeZ4CiT1V19I6Xt+eY85dWmU+iNbaLiNySzTndROjJtsWOvb5llEB+
         EDOEpxiE7YBYdhcvXh+HQgjiFjD4U5ykJvk7zkq+OZWbe2FIGCQviDA4sEAdUz7xfTjb
         nihz2sC8xGFCb3NKrkB4yyfaGnegjTZ+3AHBzBNQpO6+sJXFDMBzBYiRhTuHQikL38D+
         2bOw==
X-Forwarded-Encrypted: i=1; AJvYcCU4E5JPUnOTeX/ma6gFKm+SptE3viC80TBZzq8yEyN5fHW/UIStJ4OeAA6HP/uff/4eQF8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn6JG4DmmyEuubgI5jisnLJ4ya7qUsI43dn09k7m5inE1TOMbP
	9x2V9Xfovv9BNFejwhGo8oEEgbMD6F+g5VnPMcT/XkJLlrBTZbPR6qPFRikvQgspXhEhdvUMmql
	RJg==
X-Google-Smtp-Source: AGHT+IH9ywuf6nxC3oZt4wl64os4x2Nl/eKP0XQEvyFMCWMOfF9Ka8reJJL/xMnlzP7eGHO8qjM9XEpQziI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:b19:b0:e28:f19d:ed45 with SMTP id
 3f1490d57ef6-e28fe348675mr93685276.4.1728584634284; Thu, 10 Oct 2024 11:23:54
 -0700 (PDT)
Date: Thu, 10 Oct 2024 11:23:52 -0700
In-Reply-To: <20241010091843.GK33184@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240727102732.960974693@infradead.org> <20240727105030.226163742@infradead.org>
 <CGME20240828223802eucas1p16755f4531ed0611dc4871649746ea774@eucas1p1.samsung.com>
 <5618d029-769a-4690-a581-2df8939f26a9@samsung.com> <ZwdA0sbA2tJA3IKh@google.com>
 <20241010081940.GC17263@noisy.programming.kicks-ass.net> <20241010091843.GK33184@noisy.programming.kicks-ass.net>
Message-ID: <ZwgbuA5rggErT7ev@google.com>
Subject: Re: [PATCH 17/24] sched/fair: Implement delayed dequeue
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, mingo@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	linux-kernel@vger.kernel.org, kprateek.nayak@amd.com, 
	wuyun.abel@bytedance.com, youssefesmat@chromium.org, tglx@linutronix.de, 
	efault@gmx.de, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 10, 2024, Peter Zijlstra wrote:
> On Thu, Oct 10, 2024 at 10:19:40AM +0200, Peter Zijlstra wrote:
> > On Wed, Oct 09, 2024 at 07:49:54PM -0700, Sean Christopherson wrote:
> > 
> > > TL;DR: Code that checks task_struct.on_rq may be broken by this commit.
> > 
> > Correct, and while I did look at quite a few, I did miss KVM used it,
> > damn.
> > 
> > > Peter,
> > > 
> > > Any thoughts on how best to handle this?  The below hack-a-fix resolves the issue,
> > > but it's obviously not appropriate.  KVM uses vcpu->preempted for more than just
> > > posted interrupts, so KVM needs equivalent functionality to current->on-rq as it
> > > was before this commit.
> > > 
> > > @@ -6387,7 +6390,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
> > >  
> > >         WRITE_ONCE(vcpu->scheduled_out, true);
> > >  
> > > -       if (current->on_rq && vcpu->wants_to_run) {
> > > +       if (se_runnable(&current->se) && vcpu->wants_to_run) {
> > >                 WRITE_ONCE(vcpu->preempted, true);
> > >                 WRITE_ONCE(vcpu->ready, true);
> > >         }
> > 
> > se_runnable() isn't quite right, but yes, a helper along those lines is
> > probably best. Let me try and grep more to see if there's others I
> > missed as well :/
> 
> How's the below? I remember looking at the freezer thing before and
> deciding it isn't a correctness thing, but given I added the helper, I
> changed it anyway. I've added a bunch of comments and the perf thing is
> similar to KVM, it wants to know about preemptions so that had to change
> too.

Fixes KVM's woes!  Thanks!

