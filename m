Return-Path: <kvm+bounces-25294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC14963102
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF3B51C23648
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBACC1ABEC4;
	Wed, 28 Aug 2024 19:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5CFzl7t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27151547DD
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 19:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724873670; cv=none; b=qv49wvGZW0ZmINmREmeZqDdG84AwoveNraLdXQ5W/rHPWeFpWBHG3sBiePTIcWwu2NKNCUJYOH4lSe74eHaGqcLzkzTJqS9lV+XPaXkKwo3Ga7HX+W4O46wEHcEQv16j2h9IyOOZGdX5ISEr2sNvH+tbdn0xCCDjlfKw7Xyq9pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724873670; c=relaxed/simple;
	bh=U0nRJfuSYu2oeCnqg4TuSfGnDjuRmeMvB7KYV69MFlY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XhmyOK1M0EB2DHRUWPKayboyqdaQm60AUwdKtqA2SX/K7DwFvQO4umB8GQ906HVR5YeyiWcZfMrwred8qKiFFuk/QJkdeC1S456ZwDhwpjt8DuAou5E9M0b1LzIXMtYQJ/1v0TcD0m2Ogqzgzg6fmBa+GjVUE5JSU+i0k5hx0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D5CFzl7t; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7bbe0ab18caso6934562a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724873668; x=1725478468; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5v9jviBqnz5aAXffGbPI/pVMtwvNCYwzoWJJtUG+kNo=;
        b=D5CFzl7t45rN4C/D/4gzn7Jfs9Z1aJRBuZasZhWJ+yrSEXpN/VQPEglJG7B0DtdCJx
         M71qzL0IWAS9VWyOps6ml1y2+UIv9tc3gCLALJBpoWR20WhmsQxlJKvUNstd34LHcCU9
         rR0OLVBxPptT23RmVvasWrsH8nmcSjq/b3wd71lfLJ4ZRWy0KqjTMd5MlWcq9gN7SktQ
         RAA+22Kse58pH2xLIDFzOnFul9o+RJkO4m7GVUpp7GmDnnRxGZuXrRs1Yud5TutnR4+6
         91NlZHa4ZImY9govLXlpxyijQSSaOj6ENyF43YPxRsSWOG4tdevxz8CogK0wpocUMlbU
         BTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724873668; x=1725478468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5v9jviBqnz5aAXffGbPI/pVMtwvNCYwzoWJJtUG+kNo=;
        b=SK0AQUFYKKxbj5HJwyypMxgayXE9sxSqycgTM3MTCJHT+PiVEYaDhjlW+oSNXwGvMY
         ZfkzwxQRvGzpJJAsgdmqMBUXCgjSPAgYi6erUzZDuDFD9W7zpKSTPnWKzWvG/V+2Jeop
         X+1JLCQstNotX5QA156T0AHyLYSFuLd6Y4meGua+4VWU3kOm+GzEV/WKIjGlvoWgYm1u
         zDl53dvKq1tTo3ukyCacuwtr72mNplRtGaSwgHI+IgLUlX+Kf4WdZiiQ7s8Vtzs3Pxvt
         PnQQZ3KXOLVDDM/VZFWjatJsZizc3qGpUOOJVVv5QIjGbA2v+PeWqK0EArpy5/iMFogf
         zUvA==
X-Forwarded-Encrypted: i=1; AJvYcCUYvdqJJnQaszoF/hRwT7RO/Xgrj1yWcLY/lXphSEaPMgyHkP3YxpPRVWGBgsHgLkbd17w=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpgmx8Dw6GqIkB+J33ApTBzKu5vQxnZ32B4osQRZKiPFV/5xQG
	3QbJDlrBe4T/msUIoLJPf9itl4wGZldeW8V0w7u9jyE2o451S2Hkc6hyGirefub+32ElD5pXIBH
	Atg==
X-Google-Smtp-Source: AGHT+IFhurU2w7TOC2i2YTwMzYrDKPVl0I4SkeelnW34OxzACgmyVnofxdJB3JjrwrdP4YpCpvJQepXchXI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:200e:b0:2c8:b576:2822 with SMTP id
 98e67ed59e1d1-2d8564e70e6mr540a91.8.1724873667973; Wed, 28 Aug 2024 12:34:27
 -0700 (PDT)
Date: Wed, 28 Aug 2024 12:34:26 -0700
In-Reply-To: <20240821095127.45d17b19@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240821095127.45d17b19@gandalf.local.home>
Message-ID: <Zs97wp2-vIRjgk-e@google.com>
Subject: Re: [RFC][PATCH] KVM: Remove HIGH_RES_TIMERS dependency
From: Sean Christopherson <seanjc@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	"x86@kernel.org" <x86@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Suleiman Souhlal <ssouhlal@freebsd.org>, Vineeth Pillai <vineeth@bitbyteword.org>, 
	Borislav Petkov <bp@alien8.de>, Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 21, 2024, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Commit 92b5265d38f6a ("KVM: Depend on HIGH_RES_TIMERS") added a dependency
> to high resolution timers with the comment:
> 
>     KVM lapic timer and tsc deadline timer based on hrtimer,
>     setting a leftmost node to rb tree and then do hrtimer reprogram.
>     If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
>     do nothing and then make kvm lapic timer and tsc deadline timer fail.
> 
> That was back in 2012, where hrtimer_start_range_ns() would do the
> reprogramming with hrtimer_enqueue_reprogram(). But as that was a nop with
> high resolution timers disabled, this did not work. But a lot has changed
> in the last 12 years.
> 
> For example, commit 49a2a07514a3a ("hrtimer: Kick lowres dynticks targets on
> timer enqueue") modifies __hrtimer_start_range_ns() to work with low res
> timers. There's been lots of other changes that make low res work.
> 
> I added this change to my main server that runs all my VMs (my mail
> server, my web server, my ssh server) and disabled HIGH_RES_TIMERS and the
> system has been running just fine for over a month.
> 
> ChromeOS has tested this before as well, and it hasn't seen any issues with
> running KVM with high res timers disabled.

Can you provide some background on why this is desirable, and what the effective
tradeoffs are?  Mostly so that future users have some chance of making an
informed decision.  Realistically, anyone running with HIGH_RES_TIMERS=n is likely
already aware of the tradeoffs, but it'd be nice to capture the info here.

> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  arch/x86/kvm/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 472a1537b7a9..c65127e796a9 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -19,7 +19,6 @@ if VIRTUALIZATION
>  
>  config KVM
>  	tristate "Kernel-based Virtual Machine (KVM) support"
> -	depends on HIGH_RES_TIMERS

I did some very basic testing and nothing exploded on me either.  So long as
nothing in the host catches fire, I don't see a good reason to make high resolution
timers a hard requirement.

My only concern is that this could, at least in theory, result in people
unintentionally breaking their setups, but that seems quite unlikely.

One thought would be to require the user to enable EXPERT in order to break the
HIGH_RES_TIMERS dependency.  In practice, I doubt that will be much of a deterrent
since (IIRC) many distros ship with EXPERT=y.  But it would at least document that
using KVM x86 without HIGH_RES_TIMERS may come with caveats.  E.g.

	depends on HIGH_RES_TIMERS || EXPERT

