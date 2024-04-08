Return-Path: <kvm+bounces-13926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B6E89CEB3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8A0C1C21B26
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC92143C4F;
	Mon,  8 Apr 2024 23:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXu/kHVb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB31D28389
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 23:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712617585; cv=none; b=Eu8GQMRaAqARSGJhl+nwRY6la1QfS0Zi0cRApLHktT6Q44NDbzxymxU//XdkCB2+GUyGY9bXlUClL7ete5p3PIVYQEaA1iMmw2ZcT99SR/FRvbEU+fUsoCInIbvyMqIWxIT0CFOtlhc5vaGwosr3IP7LOTa5m6IoCUFBjaWvYfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712617585; c=relaxed/simple;
	bh=raNGJvl2Sk0V+Ra8kl0a7jUETMsXzW02VIRMS9MLecE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Domg2BnPEDeVFLm4J487GIjBeBnNMeaa382/yls4VcbxrXtx9CT7N6Ym+nYcHbWW0HMrMsrRUzAlaj2ZqP+44k4NN6JytsWIql1q7QgOIJoKcqRzbVsrgiy9pmoXoWFHxywNNIQ9TR+Hfkfs8KodMUjgX+Lv9Yw6IwlcCmVDHXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXu/kHVb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e2a1619cfcso38652875ad.0
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 16:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712617583; x=1713222383; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AzGg/0EymHzkfd/vQ5f3X3kSeFagpEymNquXWZZ9WTc=;
        b=uXu/kHVbKvOtQ+vZXgFCTy9AA+RZJBcXz92edp9NKVaDxHNJjQhpHydso/+blFcCXT
         gsfdgz4z3Ri+Jc0X7SnNoE/KqHDkdBZxylOSyMW7MAnnfLDmW5Q+GxZHdpo+w/YifpVy
         SHwi2WdDS23gyNnhca37Ku71LgTrfs6eb5xXF5UsFHKSDzz+wIPS2PaFnlYbL402YJnp
         UW1AieLCvhfUlc39tNBWFQumO5GKN+SS5jajF3H+KS3e7YDKj18Nl3egfSO6QebLueDP
         EefyFXb5m6rskHEYPs/wgfWRg4lBXydIKnD2UzUkDq1E48m9Z++gx9HqUoMvx5ajQITg
         cLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712617583; x=1713222383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AzGg/0EymHzkfd/vQ5f3X3kSeFagpEymNquXWZZ9WTc=;
        b=BtrHExm9bZYJKSav14wIDU+xlMrt+MuMLXeBrcP+pBEY8yiQRMkc+f/+lZwHOhU7lr
         mDRWzYt2sfIzpftebZ7UwMsCXTu+YE6XV+D5ceM32F60qLWVOGnq2ExDYNBNuE4pwtMS
         me7MjN2doj5NGOQDGNmYvSsDvTOWKEZLehkGhABDYLU6b+qcTxgfqxnpcyXqDQzgCWpR
         Mb3M4U3ovH2Elp+SEhePnXanptZZ4fCuqTe6oKB6pYHt7vUuFi3ckQyJaONZSyq1jE3m
         2bF/9zj2H+lWX04I9QlNjAw4xrKuTvzeTgoSFwHncQCj30iGLfht60GO2EiT+2nKNW80
         mG0A==
X-Forwarded-Encrypted: i=1; AJvYcCVs/ABpR7YJPim9nHF3Aaxs/+OiHca9CGjIp3SYeH3QgZUUQvHszGNJt8JJSVMf6Osr+Us4mHYIPIwUYczZaujyPw0g
X-Gm-Message-State: AOJu0Ywan26BRq8kUrqeJT/yow2oCxFEpCegugzOG3Hkjx/TF1WLt6Mj
	UMuV+35glEkR8FfvVFXP00CD5TBUzTCL/xbEjRYNhBb58K5FuWnOJvS+y+TjyYnhVP+8K/mlfeW
	QUw==
X-Google-Smtp-Source: AGHT+IFu+VYaPjAZAUCCs1sIip4eLJkqAOcS+AGrViDLVaZDdqHEK1uZTsQHtFz/um7v/WRpP6YyQFxeNlo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e547:b0:1db:f11d:fef2 with SMTP id
 n7-20020a170902e54700b001dbf11dfef2mr3523plf.0.1712617583226; Mon, 08 Apr
 2024 16:06:23 -0700 (PDT)
Date: Mon, 8 Apr 2024 16:06:22 -0700
In-Reply-To: <edc8b1ad-dee0-456f-89fb-47bd4709ff0e@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZgsXRUTj40LmXVS4@google.com> <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com> <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com> <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
 <ZhROKK9dEPsNnH4t@google.com> <44eb0d36-7454-41e7-9a16-ce92a88e568c@paulmck-laptop>
 <ZhRoDfoz-YqsGhIB@google.com> <edc8b1ad-dee0-456f-89fb-47bd4709ff0e@paulmck-laptop>
Message-ID: <ZhR4bnFLA08YgAgr@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Leonardo Bras <leobras@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <quic_neeraju@quicinc.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 08, 2024, Paul E. McKenney wrote:
> On Mon, Apr 08, 2024 at 02:56:29PM -0700, Sean Christopherson wrote:
> > > OK, then we can have difficulties with long-running interrupts hitting
> > > this range of code.  It is unfortunately not unheard-of for interrupts
> > > plus trailing softirqs to run for tens of seconds, even minutes.
> > 
> > Ah, and if that occurs, *and* KVM is slow to re-enter the guest, then there will
> > be a massive lag before the CPU gets back into a quiescent state.
> 
> Exactly!

...

> OK, then is it possible to get some other indication to the
> rcu_sched_clock_irq() function that it has interrupted a guest OS?

It's certainly possible, but I don't think we want to go down that road.

Any functionality built on that would be strictly limited to Intel CPUs, because
AFAIK, only Intel VMX has the mode where an IRQ can be handled without enabling
IRQs (which sounds stupid when I write it like that).

E.g. on AMD SVM, if an IRQ interrupts the guest, KVM literally handles it by
doing:

	local_irq_enable();
	++vcpu->stat.exits;
	local_irq_disable();

which means there's no way for KVM to guarantee that the IRQ that leads to
rcu_sched_clock_irq() is the _only_ IRQ that is taken (or that what RCU sees was
even the IRQ that interrupted the guest, though that probably doesn't matter much).

Orthogonal to RCU, I do think it makes sense to have KVM VMX handle IRQs in its
fastpath for VM-Exit, i.e. handle the IRQ VM-Exit and re-enter the guest without
ever enabling IRQs.  But that's purely a KVM optimization, e.g. to avoid useless
work when the host has already done what it needed to do.

But even then, to make it so RCU could safely skip invoke_rcu_core(), KVM would
need to _guarantee_ re-entry to the guest, and I don't think we want to do that.
E.g. if there is some work that needs to be done on the CPU, re-entering the guest
is a huge waste of cycles, as KVM would need to do some shenanigans to immediately
force a VM-Exit.  It'd also require a moderate amount of complexity that I wouldn't
want to maintain, particularly since it'd be Intel-only.

> Not an emergency, and maybe not even necessary, but it might well be
> one hole that would be good to stop up.
> 
> 							Thanx, Paul

