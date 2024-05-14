Return-Path: <kvm+bounces-17394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 255428C5DEA
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 00:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 754E0B2145F
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 22:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0470B182C91;
	Tue, 14 May 2024 22:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9r6tOa+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2685A181CFB;
	Tue, 14 May 2024 22:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715727258; cv=none; b=gI16P+qAatg0rt8OgrPb31LhW0s4IkTmME644lbmGyL5Tz9LrWoHBGTy/tjs8V/MRP9D+MrVW2NkY/BzDqLzU67R1lwzogLxHJmso3dLxFJbAch9+dUeoAJRCh5lsGPrDMF3msBIGWLmbugR481Vd4DkOC4Ekay8fSOSm/FjdbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715727258; c=relaxed/simple;
	bh=ZW2Nbj8GoOGUug2rnm6oGISqRv9Ml9tWbdtZP+OfDHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TL5U6dgPfpapfrx/3dcodKkRamzdxtqhqZQGKS0/hJfJp6BKTTxLgf62v4+ja+gdhLYSyp9D3ctypLUyM6i2XJbB5BtqGn4aTbjXU7kP8nm06O+FT27hr0eSEYDKA6it5Yq+HNC2peNHpzMwCAk2gEJzqKMDaCNBc5erN/KIXd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9r6tOa+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79D7C2BD10;
	Tue, 14 May 2024 22:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715727258;
	bh=ZW2Nbj8GoOGUug2rnm6oGISqRv9Ml9tWbdtZP+OfDHQ=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=u9r6tOa+h89rC+qs1fFPEQXOaR+IHTxetn5eExiWLaHGsOXkyaUgdQjldcmCF0R6R
	 gjzG0oda7SLPU4WpK8HErrTcmLZio1DxHD2ryUR+9iPFEva/eKbHn2/pMWnQ9To1WQ
	 8TXftfroH8kicxlUbEfUcxmsaD0yS2nAwNV2esA+Zbtvhr+VcrShMIyNNg2yeKcJdn
	 XTHpqPpJyYCJdtnR8g82CKDCJio7RDG6dhpaH/LGya7SgtyNcVkG/AxO4/cWJw2FN1
	 r6QMMlHRdKIj8ncrlj8y+a8DZ3a4gKaL76c9GJCc94GYhTrR6TGbfshTo4JfUH1FRG
	 S6DfQcmYZsHRw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 94D09CE0481; Tue, 14 May 2024 15:54:16 -0700 (PDT)
Date: Tue, 14 May 2024 15:54:16 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Leonardo Bras Soares Passos <leobras@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Message-ID: <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240511020557.1198200-1-leobras@redhat.com>
 <ZkJsvTH3Nye-TGVa@google.com>
 <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com>

On Mon, May 13, 2024 at 06:47:13PM -0300, Leonardo Bras Soares Passos wrote:
> On Mon, May 13, 2024 at 4:40 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, May 10, 2024, Leonardo Bras wrote:
> > > As of today, KVM notes a quiescent state only in guest entry, which is good
> > > as it avoids the guest being interrupted for current RCU operations.
> > >
> > > While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> > > check for any RCU operations waiting for this CPU. In case there are any of
> > > such, it invokes rcu_core() in order to sched-out the current thread and
> > > note a quiescent state.
> > >
> > > This occasional schedule work will introduce tens of microsseconds of
> > > latency, which is really bad for vcpus running latency-sensitive
> > > applications, such as real-time workloads.
> > >
> > > So, note a quiescent state in guest exit, so the interrupted guests is able
> > > to deal with any pending RCU operations before being required to invoke
> > > rcu_core(), and thus avoid the overhead of related scheduler work.
> >
> > Are there any downsides to this?  E.g. extra latency or anything?  KVM will note
> > a context switch on the next VM-Enter, so even if there is extra latency or
> > something, KVM will eventually take the hit in the common case no matter what.
> > But I know some setups are sensitive to handling select VM-Exits as soon as possible.
> >
> > I ask mainly because it seems like a no brainer to me to have both VM-Entry and
> > VM-Exit note the context switch, which begs the question of why KVM isn't already
> > doing that.  I assume it was just oversight when commit 126a6a542446 ("kvm,rcu,nohz:
> > use RCU extended quiescent state when running KVM guest") handled the VM-Entry
> > case?
> 
> I don't know, by the lore I see it happening in guest entry since the
> first time it was introduced at
> https://lore.kernel.org/all/1423167832-17609-5-git-send-email-riel@redhat.com/
> 
> Noting a quiescent state is cheap, but it may cost a few accesses to
> possibly non-local cachelines. (Not an expert in this, Paul please let
> me know if I got it wrong).

Yes, it is cheap, especially if interrupts are already disabled.
(As in the scheduler asks RCU to do the same amount of work on its
context-switch fastpath.)

> I don't have a historic context on why it was just implemented on
> guest_entry, but it would make sense when we don't worry about latency
> to take the entry-only approach:
> - It saves the overhead of calling rcu_virt_note_context_switch()
> twice per guest entry in the loop
> - KVM will probably run guest entry soon after guest exit (in loop),
> so there is no need to run it twice
> - Eventually running rcu_core() may be cheaper than noting quiescent
> state every guest entry/exit cycle
> 
> Upsides of the new strategy:
> - Noting a quiescent state in guest exit avoids calling rcu_core() if
> there was a grace period request while guest was running, and timer
> interrupt hits the cpu.
> - If the loop re-enter quickly there is a high chance that guest
> entry's rcu_virt_note_context_switch() will be fast (local cacheline)
> as there is low probability of a grace period request happening
> between exit & re-entry.
> - It allows us to use the rcu patience strategy to avoid rcu_core()
> running if any grace period request happens between guest exit and
> guest re-entry, which is very important for low latency workloads
> running on guests as it reduces maximum latency in long runs.
> 
> What do you think?

Try both on the workload of interest with appropriate tracing and
see what happens?  The hardware's opinion overrides mine.  ;-)

							Thanx, Paul

