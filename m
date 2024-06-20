Return-Path: <kvm+bounces-20042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7DC90FD42
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 09:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 001631C215C5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 07:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB47B4EB2B;
	Thu, 20 Jun 2024 07:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vuk+3YsK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF444D8A1;
	Thu, 20 Jun 2024 07:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718867034; cv=none; b=ItPFUruh975//+p+ogDqbzoFCrhG3uLEuKwKY4VREsF31M30uKkQRndpcyMtYvjvBMMrOWuiySibgNxgYOTL4BhsFnEtYLHF/PTR9veZ8HNim+GXplmmxcUCobFSXVpkgmcR3aizBIQwzgok4qjPGV5igEsyjS6DMXkY2prz75g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718867034; c=relaxed/simple;
	bh=feL+O6XAYCnO7cgHF+U+NbYShvDQeHdCKf8S45bkvcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=XcZkl2iYOjv3iCtoY9XG6X3Copxw4gfNv4uXksB1NJ2bwVpd8lW7SKGd434EdPKapfWf6+SzY6D94dlZPnASDadIO1T41sbuDGaYb8Ue8tQp6h8ieaIcylaVOxOtz7wiOeT3MRSKmm8pPRc3Djw1uz3efF08Xi/26BDukPX8Oa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vuk+3YsK; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7062bf8bb75so517984b3a.0;
        Thu, 20 Jun 2024 00:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718867032; x=1719471832; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QG0GzpxeQ8OdVtQCgpCYaiOgyBHSoT7dFIqwUD/EmV8=;
        b=Vuk+3YsKdGwRsxEVvRiRnuWK/YrEtnRPtBNm36cUKeXu9logTWWRo8TcQT8RkTRU/U
         Jwc2UKbagZMRlZ7xjlG4uKzh0i6a485j4erxQMEvE51AyhiXXgogSCmPfTQxwB8RPnyo
         EP5XCPRg3S4GAkTe39ytjYvWT7hVG9DfnTN9VBKd37UHBrxsFTz8vmMJ+0tMxz0YTF8E
         U1qYs7R5gESPsyWg8WECVqkxlNyONgAQF66Zp9bGPsr9iKCjX7xQ9aq7CVgylDTU9Qgn
         4KQJNUXq9naKqwBUEkP3rWVxhZAlpgYXPm7QgykbGfOutQSnXEVBispBdzy7IPRR4gEM
         hlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718867032; x=1719471832;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QG0GzpxeQ8OdVtQCgpCYaiOgyBHSoT7dFIqwUD/EmV8=;
        b=n7IPXXEBST5DmIWDzQinPtfrBuLWPBexUk9GuY2XxTdXJ7Gxs7uSBHDqY113pDpNlo
         c8KaEd3ZPaDQryQwZwznhbDaAT7NVVsYlEbjx6flfaRkBHPAnUYDXmjXHgqpTt3eXiu2
         +kZWearye+oEwVQJiadecSBSRNRaKubltzWu50239FlBLRos4+8EzeYJ3C4Qpetov7Gv
         /bloQjMfn0fCJisrV2PU9FzwfVazdENkBdBN1RyPJ2E11CV3c3CDfibJr4bR56/rrt4H
         c7VpEPbLKIP9ego54+29ROR5qZviGlNiGE4FB0Jrc7coBnUcywGyxNJRL2VXyjoK2yaN
         ql/A==
X-Forwarded-Encrypted: i=1; AJvYcCXwRlAocknBqZem9B4JaKcH3eW+EI15z9iv6YAwDqOd8S4wOPtZhz/o5cW3wSgH7QT8F+uA+iY51kqOzG3GkCg3zsdsjiFO3jZVRMUFcfeXi7eCZxVQx7MjKEH02J+3XgNf
X-Gm-Message-State: AOJu0Yx/dQcIZeQIounmmb5aoseUTIsvTljQ5i79yavGCE0dRtr9lFjU
	1SvL7mSwMZQq1Z9mRf73v7tRPFPf5eKKCh6O7Mk3BI0b2b5XA+rIHNGHVA==
X-Google-Smtp-Source: AGHT+IFxXJVoIRzGIiIxYXMd41s9IKJk0gnq5jpClV1joNWB0v4gqqtPw8xCsmt9mmNJ3FFKzErjiQ==
X-Received: by 2002:a05:6a20:ba98:b0:1b2:ae30:95b5 with SMTP id adf61e73a8af0-1bcbb66401fmr4271877637.56.1718867031441;
        Thu, 20 Jun 2024 00:03:51 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a801:c138:e21d:3579:5747:ad1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6ea47sm12131984b3a.171.2024.06.20.00.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 00:03:50 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
X-Google-Original-From: Leonardo Bras <leobras@redhat.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Date: Thu, 20 Jun 2024 04:03:41 -0300
Message-ID: <ZnPUTGSdF7t0DCwR@LeoBras>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop>
References: <20240511020557.1198200-1-leobras@redhat.com> <ZkJsvTH3Nye-TGVa@google.com> <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com> <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop> <ZkQ97QcEw34aYOB1@LeoBras> <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, May 15, 2024 at 07:57:41AM -0700, Paul E. McKenney wrote:
> On Wed, May 15, 2024 at 01:45:33AM -0300, Leonardo Bras wrote:
> > On Tue, May 14, 2024 at 03:54:16PM -0700, Paul E. McKenney wrote:
> > > On Mon, May 13, 2024 at 06:47:13PM -0300, Leonardo Bras Soares Passos wrote:
> > > > On Mon, May 13, 2024 at 4:40 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Fri, May 10, 2024, Leonardo Bras wrote:
> > > > > > As of today, KVM notes a quiescent state only in guest entry, which is good
> > > > > > as it avoids the guest being interrupted for current RCU operations.
> > > > > >
> > > > > > While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> > > > > > check for any RCU operations waiting for this CPU. In case there are any of
> > > > > > such, it invokes rcu_core() in order to sched-out the current thread and
> > > > > > note a quiescent state.
> > > > > >
> > > > > > This occasional schedule work will introduce tens of microsseconds of
> > > > > > latency, which is really bad for vcpus running latency-sensitive
> > > > > > applications, such as real-time workloads.
> > > > > >
> > > > > > So, note a quiescent state in guest exit, so the interrupted guests is able
> > > > > > to deal with any pending RCU operations before being required to invoke
> > > > > > rcu_core(), and thus avoid the overhead of related scheduler work.
> > > > >
> > > > > Are there any downsides to this?  E.g. extra latency or anything?  KVM will note
> > > > > a context switch on the next VM-Enter, so even if there is extra latency or
> > > > > something, KVM will eventually take the hit in the common case no matter what.
> > > > > But I know some setups are sensitive to handling select VM-Exits as soon as possible.
> > > > >
> > > > > I ask mainly because it seems like a no brainer to me to have both VM-Entry and
> > > > > VM-Exit note the context switch, which begs the question of why KVM isn't already
> > > > > doing that.  I assume it was just oversight when commit 126a6a542446 ("kvm,rcu,nohz:
> > > > > use RCU extended quiescent state when running KVM guest") handled the VM-Entry
> > > > > case?
> > > > 
> > > > I don't know, by the lore I see it happening in guest entry since the
> > > > first time it was introduced at
> > > > https://lore.kernel.org/all/1423167832-17609-5-git-send-email-riel@redhat.com/
> > > > 
> > > > Noting a quiescent state is cheap, but it may cost a few accesses to
> > > > possibly non-local cachelines. (Not an expert in this, Paul please let
> > > > me know if I got it wrong).
> > > 
> > > Yes, it is cheap, especially if interrupts are already disabled.
> > > (As in the scheduler asks RCU to do the same amount of work on its
> > > context-switch fastpath.)
> > 
> > Thanks!
> > 
> > > 
> > > > I don't have a historic context on why it was just implemented on
> > > > guest_entry, but it would make sense when we don't worry about latency
> > > > to take the entry-only approach:
> > > > - It saves the overhead of calling rcu_virt_note_context_switch()
> > > > twice per guest entry in the loop
> > > > - KVM will probably run guest entry soon after guest exit (in loop),
> > > > so there is no need to run it twice
> > > > - Eventually running rcu_core() may be cheaper than noting quiescent
> > > > state every guest entry/exit cycle
> > > > 
> > > > Upsides of the new strategy:
> > > > - Noting a quiescent state in guest exit avoids calling rcu_core() if
> > > > there was a grace period request while guest was running, and timer
> > > > interrupt hits the cpu.
> > > > - If the loop re-enter quickly there is a high chance that guest
> > > > entry's rcu_virt_note_context_switch() will be fast (local cacheline)
> > > > as there is low probability of a grace period request happening
> > > > between exit & re-entry.
> > > > - It allows us to use the rcu patience strategy to avoid rcu_core()
> > > > running if any grace period request happens between guest exit and
> > > > guest re-entry, which is very important for low latency workloads
> > > > running on guests as it reduces maximum latency in long runs.
> > > > 
> > > > What do you think?
> > > 
> > > Try both on the workload of interest with appropriate tracing and
> > > see what happens?  The hardware's opinion overrides mine.  ;-)
> > 
> > That's a great approach!
> > 
> > But in this case I think noting a quiescent state in guest exit is 
> > necessary to avoid a scenario in which a VM takes longer than RCU 
> > patience, and it ends up running rcuc in a nohz_full cpu, even if guest 
> > exit was quite brief. 
> > 
> > IIUC Sean's question is more on the tone of "Why KVM does not note a 
> > quiescent state in guest exit already, if it does in guest entry", and I 
> > just came with a few arguments to try finding a possible rationale, since 
> > I could find no discussion on that topic in the lore for the original 
> > commit.
> 
> Understood, and maybe trying it would answer that question quickly.
> Don't get me wrong, just because it appears to work in a few tests doesn't
> mean that it really works, but if it visibly blows up, that answers the
> question quite quickly and easily.  ;-)
> 
> But yes, if it appears to work, there must be a full investigation into
> whether or not the change really is safe.
> 
> 							Thanx, Paul

Hello Paul, Sean, sorry for the delay on this.

I tested x86 by counting cycles (using rdtsc_ordered()).

Cycles were counted upon function entry/exit on 
{svm,vmx}_vcpu_enter_exit(), and right before / after 
__{svm,vmx}_vcpu_run() in the same function.

The main idea was to get cycles spend in the procedures before entering 
guest (such as reporting RCU quiescent state in entry / exit) and the 
cycles actually used by the VM. 

Those cycles were summed-up and stored in per-cpu structures, with a 
counter to get the average value. I then created a debug file to read the 
results and reset the counters.

As for the VM, it got 20 vcpus, 8GB memory, and was booted with idle=poll.

The workload inside the VM consisted in cyclictest in 16 vcpus 
(SCHED_FIFO,p95), while maintaining it's main routine in 4 other cpus 
(SCHED_OTHER). This was made to somehow simulate busy and idle-er cpus. 

 $cyclictest -m -q -p95 --policy=fifo -D 1h -h60 -t 16 -a 4-19 -i 200 
  --mainaffinity 0-3

All tests were run for exaclty 1 hour, and the clock counter was reset at 
the same moment cyclictest stared. After that VM was poweroff from guest.
Results show the average for all CPUs in the same category, in cycles.

With above setup, I tested 2 use cases:
1 - Non-RT host, no CPU Isolation, no RCU patience (regular use-case)
2 - PREEMPT_RT host, with CPU Isolation for all vcpus (pinned), and 
    RCU patience = 1000ms (best case for RT)

Results are:
# Test case 1:
Vanilla: (average on all vcpus)
VM Cycles / RT vcpu:		123287.75 
VM Cycles / non-RT vcpu:	709847.25
Setup Cycles:			186.00
VM entries / RT vcpu:		58737094.81
VM entries / non-RT vcpu:	10527869.25
Total cycles in RT VM:		7241564260969.80
Total cycles in non-RT VM:	7473179035472.06

Patched: (average on all vcpus)
VM Cycles / RT vcpu:		124695.31        (+ 1.14%)
VM Cycles / non-RT vcpu:	710479.00        (+ 0.09%)
Setup Cycles:			218.65           (+17.55%)
VM entries / RT vcpu:		60654285.44      (+ 3.26%) 
VM entries / non-RT vcpu:	11003516.75      (+ 4.52%)
Total cycles in RT VM:		7563305077093.26 (+ 4.44%)
Total cycles in non-RT VM:	7817767577023.25 (+ 4.61%)

Discussion:
Setup cycles raised in ~33 cycles, increasing overhead.
It proves that noting a quiescent state in guest entry introduces setup 
routine costs, which is expected.

On the other hand, both the average time spend inside the VM and the number 
of VM entries raised, causing the VM to have ~4.5% more cpu cycles 
available to run, which is positive. Extra cycles probably came from not 
having invoke_rcu_core() getting ran after VM exit.


# Test case 2:
Vanilla: (average on all vcpus)
VM Cycles / RT vcpu:		123785.63
VM Cycles / non-RT vcpu:	698758.25
Setup Cycles:			187.20
VM entries / RT vcpu:		61096820.75
VM entries / non-RT vcpu:	11191873.00
Total cycles in RT VM:		7562908142051.72
Total cycles in non-RT VM:	7820413591702.25

Patched: (average on all vcpus)
VM Cycles / RT vcpu:		123137.13        (- 0.52%)
VM Cycles / non-RT vcpu:	696824.25        (- 0.28%)
Setup Cycles:			229.35           (+22.52%)
VM entries / RT vcpu:		61424897.13      (+ 0.54%) 
VM entries / non-RT vcpu:	11237660.50      (+ 0.41%)
Total cycles in RT VM:		7563685235393.27 (+ 0.01%)
Total cycles in non-RT VM:	7830674349667.13 (+ 0.13%)

Discussion:
Setup cycles raised in ~42 cycles, increasing overhead.
It proves that noting a quiescent state in guest entry introduces setup 
routine costs, which is expected.

The average time spend inside the VM was reduced, but the number of VM  
entries raised, causing the VM to have around the same number of cpu cycles 
available to run, meaning that the overhead caused by reporting RCU 
quiescent state in VM exit got absorbed, and it may have to do with those 
rare invoke_rcu_core()s that were bothering latency.

The difference is much smaller compared to case 1, and this is probably 
because there is a clause in rcu_pending() for isolated (nohz_full) cpus 
which may be already inhibiting a lot of invoke_rcu_core()s.

Sean, Paul, what do you think?

Thanks!
Leo

> 
> > Since noting a quiescent state in guest exit is cheap enough, avoids rcuc 
> > schedules when grace period starts during guest execution, and enables a 
> > much more rational usage of RCU patience, it's a safe to assume it's a 
> > better way of dealing with RCU compared to current implementation.
> > 
> > Sean, what do you think?
> > 
> > Thanks!
> > Leo
> > 
> > > 
> > > 							Thanx, Paul
> > > 
> > 
> 

