Return-Path: <kvm+bounces-17436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D8C8C6912
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 16:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46A801C21340
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 14:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714E8155747;
	Wed, 15 May 2024 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dgI4gCrh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926A81E480;
	Wed, 15 May 2024 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785062; cv=none; b=ucax1CJey5L551qdry2hehaCZ8Qi762hNWG3OZy8mQMEdQ3oXA5iHnd7IHHl0P6DkvpKPD/kranl4WGYA7mxeAI296Rol/luySJonVeIjGGAMMN8HU1kHtEG7UjWpbw0BRvxL1UIQagtN8fpWY2fnUxN/CYC0jbRLK6J3HmQ0rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785062; c=relaxed/simple;
	bh=WZoYbqGGnOPQEjzC3t94VjU0p7tCnohke6zY104Itrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOFhEeiiQJRzi/hOfAcsc7A2jGwCBrvIcrQPdhJDVbet/IGobrFypMW+1UpQ+IOMuhohk6zQ7D+swNviiTa9O+0AiEBo1ZFPX287imc8nS12fj+i1w66NG+ufpQ8eNZOlNKqc5AAGFWaSAMMcs3YKWx0SKvJr5FR2fyOAd2lg88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dgI4gCrh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18897C116B1;
	Wed, 15 May 2024 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715785062;
	bh=WZoYbqGGnOPQEjzC3t94VjU0p7tCnohke6zY104Itrk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=dgI4gCrhm8ErfM11kskowGtGU8gXHhXctsKdQ//nEYfJmqUINpSzyGocVth4T8O+S
	 6r34N50hcA6BI5OpysiZAV0F7tOBtIwyWxEtRTVvuW5udYhX1q3Akx0bwypugodVSr
	 HPQyQlnCIi33KvUPHjJIWBg4DYI2BOTm1U7VVWL67o6AZiVo1ytt3YnGiW+84WYM4w
	 OYRU0HGC7DEtnzjEH8YrHTsFxUisoJkdSjMGS7DUDJ/3ekkGD/P9aMQa0jcuTKZvnH
	 71SAJ8sNH02NEfafNORz4gL1rMQVv5bobaWtPBpXDs91EGw6u88Yfi4QkwS9nVWXtk
	 8dw6KyydEb3ow==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 46BE9CE0443; Wed, 15 May 2024 07:57:41 -0700 (PDT)
Date: Wed, 15 May 2024 07:57:41 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Leonardo Bras <leobras@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Message-ID: <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240511020557.1198200-1-leobras@redhat.com>
 <ZkJsvTH3Nye-TGVa@google.com>
 <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com>
 <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop>
 <ZkQ97QcEw34aYOB1@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZkQ97QcEw34aYOB1@LeoBras>

On Wed, May 15, 2024 at 01:45:33AM -0300, Leonardo Bras wrote:
> On Tue, May 14, 2024 at 03:54:16PM -0700, Paul E. McKenney wrote:
> > On Mon, May 13, 2024 at 06:47:13PM -0300, Leonardo Bras Soares Passos wrote:
> > > On Mon, May 13, 2024 at 4:40 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Fri, May 10, 2024, Leonardo Bras wrote:
> > > > > As of today, KVM notes a quiescent state only in guest entry, which is good
> > > > > as it avoids the guest being interrupted for current RCU operations.
> > > > >
> > > > > While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> > > > > check for any RCU operations waiting for this CPU. In case there are any of
> > > > > such, it invokes rcu_core() in order to sched-out the current thread and
> > > > > note a quiescent state.
> > > > >
> > > > > This occasional schedule work will introduce tens of microsseconds of
> > > > > latency, which is really bad for vcpus running latency-sensitive
> > > > > applications, such as real-time workloads.
> > > > >
> > > > > So, note a quiescent state in guest exit, so the interrupted guests is able
> > > > > to deal with any pending RCU operations before being required to invoke
> > > > > rcu_core(), and thus avoid the overhead of related scheduler work.
> > > >
> > > > Are there any downsides to this?  E.g. extra latency or anything?  KVM will note
> > > > a context switch on the next VM-Enter, so even if there is extra latency or
> > > > something, KVM will eventually take the hit in the common case no matter what.
> > > > But I know some setups are sensitive to handling select VM-Exits as soon as possible.
> > > >
> > > > I ask mainly because it seems like a no brainer to me to have both VM-Entry and
> > > > VM-Exit note the context switch, which begs the question of why KVM isn't already
> > > > doing that.  I assume it was just oversight when commit 126a6a542446 ("kvm,rcu,nohz:
> > > > use RCU extended quiescent state when running KVM guest") handled the VM-Entry
> > > > case?
> > > 
> > > I don't know, by the lore I see it happening in guest entry since the
> > > first time it was introduced at
> > > https://lore.kernel.org/all/1423167832-17609-5-git-send-email-riel@redhat.com/
> > > 
> > > Noting a quiescent state is cheap, but it may cost a few accesses to
> > > possibly non-local cachelines. (Not an expert in this, Paul please let
> > > me know if I got it wrong).
> > 
> > Yes, it is cheap, especially if interrupts are already disabled.
> > (As in the scheduler asks RCU to do the same amount of work on its
> > context-switch fastpath.)
> 
> Thanks!
> 
> > 
> > > I don't have a historic context on why it was just implemented on
> > > guest_entry, but it would make sense when we don't worry about latency
> > > to take the entry-only approach:
> > > - It saves the overhead of calling rcu_virt_note_context_switch()
> > > twice per guest entry in the loop
> > > - KVM will probably run guest entry soon after guest exit (in loop),
> > > so there is no need to run it twice
> > > - Eventually running rcu_core() may be cheaper than noting quiescent
> > > state every guest entry/exit cycle
> > > 
> > > Upsides of the new strategy:
> > > - Noting a quiescent state in guest exit avoids calling rcu_core() if
> > > there was a grace period request while guest was running, and timer
> > > interrupt hits the cpu.
> > > - If the loop re-enter quickly there is a high chance that guest
> > > entry's rcu_virt_note_context_switch() will be fast (local cacheline)
> > > as there is low probability of a grace period request happening
> > > between exit & re-entry.
> > > - It allows us to use the rcu patience strategy to avoid rcu_core()
> > > running if any grace period request happens between guest exit and
> > > guest re-entry, which is very important for low latency workloads
> > > running on guests as it reduces maximum latency in long runs.
> > > 
> > > What do you think?
> > 
> > Try both on the workload of interest with appropriate tracing and
> > see what happens?  The hardware's opinion overrides mine.  ;-)
> 
> That's a great approach!
> 
> But in this case I think noting a quiescent state in guest exit is 
> necessary to avoid a scenario in which a VM takes longer than RCU 
> patience, and it ends up running rcuc in a nohz_full cpu, even if guest 
> exit was quite brief. 
> 
> IIUC Sean's question is more on the tone of "Why KVM does not note a 
> quiescent state in guest exit already, if it does in guest entry", and I 
> just came with a few arguments to try finding a possible rationale, since 
> I could find no discussion on that topic in the lore for the original 
> commit.

Understood, and maybe trying it would answer that question quickly.
Don't get me wrong, just because it appears to work in a few tests doesn't
mean that it really works, but if it visibly blows up, that answers the
question quite quickly and easily.  ;-)

But yes, if it appears to work, there must be a full investigation into
whether or not the change really is safe.

							Thanx, Paul

> Since noting a quiescent state in guest exit is cheap enough, avoids rcuc 
> schedules when grace period starts during guest execution, and enables a 
> much more rational usage of RCU patience, it's a safe to assume it's a 
> better way of dealing with RCU compared to current implementation.
> 
> Sean, what do you think?
> 
> Thanks!
> Leo
> 
> > 
> > 							Thanx, Paul
> > 
> 

