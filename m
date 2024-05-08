Return-Path: <kvm+bounces-17026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DF28C011C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 17:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 476E81C244D5
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9E2128365;
	Wed,  8 May 2024 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xd8NFkCc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0E8127B4B
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715182507; cv=none; b=u9khaANbJKTx9izxDGsj72dCjUmxmGBZiQpy4hkESmjei8LypxjVoBys0yVd4g6pdKIBKX3dznfTzChGZjxcH/tEqO3snbEr6aexRjp/ZGqCCPcMmEze+8AY6nIqDlK7KFYMREjUc14KF7MC1GoyRZ4kAPZy4A61Q+iPuKugJo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715182507; c=relaxed/simple;
	bh=YNwnw7x/Uo6NlKxdHmJmjTkvzz/xc3NOR1EbfVQ1Qdk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bxW69+BnqnIFhOhMDKo8X3WWL9Yg/UdPPhhEgnn88eKC+gS73XxEldlrIOMCTkKNJke67W1K0WnaY1hYBqwQh162IF03cpquwu7Nw6fdM5A8YZkIYxgQqoBI8HN9Cy4/03s67U0tDictxYk2ZlzmQ2PkX7HFvuIMs9tWf3hXvpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xd8NFkCc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-61c4bbe49e3so4455907a12.3
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 08:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715182505; x=1715787305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zgF+FfCyif5jmmQvrN+Ij7wj3+WZfQYjh63u9JDeBL0=;
        b=xd8NFkCc5uRmmg9BWiGkeXd81FmeWv95bsD91ua9LNqd2BJOus1sHuHAWNJjNo9jdR
         1A0/j6lIji3UVVlW7RJTknyiVNHm1KHCSQ0EwMFbPsY9J8DLZqc63C+MBJf5SEPA6PuA
         1IUIKKz5cHMucshl4W4bDv5Ukk95HANWdTI3fOd1Zq6r0r+fybv6d+3aua1CFAHmcdrb
         EPPJCoPkAwWILLodkqCV668AL5PBygrQL5Po4dIt7OmBn/mOS6rkJ5nSHiQxKt1hD24B
         gH2kVJd4Boc5vmQLyDvNt1O7HXQ6eyWhL+dbZFOMjFT3UN7VhUERJNrEGZaTUEHy5L/Q
         2SKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715182505; x=1715787305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zgF+FfCyif5jmmQvrN+Ij7wj3+WZfQYjh63u9JDeBL0=;
        b=qNvWOR5VMbuoGeUonO/EAaPxwp1yA0NtrWj7Fdfu4lIZHbQg+6VdW89lIdckk/ePO4
         +rrKviA7yivXv5EzHWhZzoD/jKv2m3YVbGFJp/piPgm+IE7lMpkUmVZGhk2pYbH3ZpYJ
         VdSW6KtxoDZVgrbEV4vaWOJsQyuYc6Se2Xb1p6ozpIwyBW/pIYHKu447cnP8IkJp7ER/
         etIZJUo1iwD6xJyE6dxOL6DX36E0gAvOFn7WEasedUOY7qqjLBQr9xB8jO95JjQK127Q
         Nog4rl2zCAqpQXlbx2Ym0itSiq6XS+HHrWW7pXxLHUFn8meeu+ujbNBM2KXloMI0hfAY
         rKew==
X-Forwarded-Encrypted: i=1; AJvYcCW5RUywXsvAEC3FXB3Ld4EZSNpV5b770656Niu91ebNkFagHDFyORE+/qmpSRpdHcYbgZbYNgyGwgIomZSIjLNRjIqI
X-Gm-Message-State: AOJu0YxHihjG7aCG3eispnwfqjjZMPXTWFnB7L7l2V6KInM2MTqfehcE
	gV23n4TJo8hrh35IJbcu4bbiTOTaI7oCYhlxT7LCRb3O5bGl/gbYWsd3ySXMbbfy74jvFuMV0os
	hyQ==
X-Google-Smtp-Source: AGHT+IGnMl8b2DL5U8JgKn7vuhtLw31dGCqH0NqCNx0jQuIgeqpJ7VJDjS8TlyGz9TbXKbQbvpZPAFH5nNw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:65c1:0:b0:5dc:af76:f57d with SMTP id
 41be03b00d2f7-62f223af825mr37896a12.7.1715182505319; Wed, 08 May 2024
 08:35:05 -0700 (PDT)
Date: Wed, 8 May 2024 08:35:03 -0700
In-Reply-To: <ac66bb23-2955-41bf-b1f0-85adcc4628a0@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZjUwHvyvkM3lj80Q@LeoBras> <ZjVXVc2e_V8NiMy3@google.com>
 <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop> <ZjprKm5jG3JYsgGB@google.com>
 <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop> <ZjqWXPFuoYWWcxP3@google.com>
 <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop> <Zjq9okodmvkywz82@google.com>
 <ZjrClk4Lqw_cLO5A@google.com> <ac66bb23-2955-41bf-b1f0-85adcc4628a0@paulmck-laptop>
Message-ID: <Zjubp36yHVf01C16@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 07, 2024, Paul E. McKenney wrote:
> On Tue, May 07, 2024 at 05:08:54PM -0700, Sean Christopherson wrote:
> > > > This is admittedly a bit indirect, but then again this is Linux-kernel
> > > > RCU that we are talking about.
> > > > 
> > > > > And I'm arguing that, since the @user check isn't bombproof, there's no reason to
> > > > > try to harden against every possible edge case in an equivalent @guest check,
> > > > > because it's unnecessary for kernel safety, thanks to the guardrails.
> > > > 
> > > > And the same argument above would also apply to an equivalent check for
> > > > execution in guest mode at the time of the interrupt.
> > > 
> > > This is partly why I was off in the weeds.  KVM cannot guarantee that the
> > > interrupt that leads to rcu_pending() actually interrupted the guest.  And the
> > > original patch didn't help at all, because a time-based check doesn't come
> > > remotely close to the guarantees that the @user check provides.
> 
> Nothing in the registers from the interrupted context permits that
> determination?

No, because the interrupt/call chain that reaches rcu_pending() actually originates
in KVM host code, not guest code.  I.e. the eventual IRET will return control to
KVM, not to the guest.

On AMD, the interrupt quite literally interrupts the host, not the guest.  AMD
CPUs don't actually acknowledge/consume the physical interrupt when the guest is
running, the CPU simply generates a VM-Exit that says "there's an interrupt pending".
It's up to software, i.e. KVM, to enable IRQs and handle (all!) pending interrupts.

Intel CPUs have a mode where the CPU fully acknowledges the interrupt and reports
the exact vector that caused the VM-Exit, but it's still up to software to invoke
the interrupt handler, i.e. the interrupt trampolines through KVM.

And before handling/forwarding the interrupt, KVM exits its quiescent state,
leaves its no-instrumention region, invokes tracepoitnes, etc.  So even my PF_VCPU
idea is _very_ different than the user/idle scenarios, where the interrupt really
truly does original from an extended quiescent state.

> > > > But if we do need RCU to be more aggressive about treating guest execution as
> > > > an RCU quiescent state within the host, that additional check would be an
> > > > excellent way of making that happen.
> > > 
> > > It's not clear to me that being more agressive is warranted.  If my understanding
> > > of the existing @user check is correct, we _could_ achieve similar functionality
> > > for vCPU tasks by defining a rule that KVM must never enter an RCU critical section
> > > with PF_VCPU set and IRQs enabled, and then rcu_pending() could check PF_VCPU.
> > > On x86, this would be relatively straightforward (hack-a-patch below), but I've
> > > no idea what it would look like on other architectures.
> 
> At first glance, this looks plausible.  I would guess that a real patch
> would have to be architecture dependent, and that could simply involve
> a Kconfig option (perhaps something like CONFIG_RCU_SENSE_GUEST), so
> that the check you add to rcu_pending is conditioned on something like
> IS_ENABLED(CONFIG_RCU_SENSE_GUEST).
> 
> There would also need to be a similar check in rcu_sched_clock_irq(),
> or maybe in rcu_flavor_sched_clock_irq(), to force a call to rcu_qs()
> in this situation.
> 
> > > But the value added isn't entirely clear to me, probably because I'm still missing
> > > something.  KVM will have *very* recently called __ct_user_exit(CONTEXT_GUEST) to
> > > note the transition from guest to host kernel.  Why isn't that a sufficient hook
> > > for RCU to infer grace period completion?
> 
> Agreed, unless we are sure we need the change, we should not make it.

+1.  And your comments about tracepoints, instrumentions, etc. makes me think
that trying to force the issue with PF_VCPU would be a bad idea.

