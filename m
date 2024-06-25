Return-Path: <kvm+bounces-20442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC874915C48
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 04:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40747B2267C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 02:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B483561FC1;
	Tue, 25 Jun 2024 02:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj6kJ3AI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C677B535C4
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 02:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719282728; cv=none; b=QZ2MStLlu9Ujhbw0yxt13r3FdHUJhZUDgt2vo4CjaZOtvRJQSk5POOlOizbnu8F1mExFQQeq5IsvoLwUCFS8pHuebQmPwuZpSvv8uiRexmTjFlnIk3uDFEfCnB+ryrLbECknbmGPQaYs/QdgXgcEqFUZTQTfLRZbtpF2pd7ZeDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719282728; c=relaxed/simple;
	bh=nKKJdses0mVEjtpPX+qZjXN+KqZPmH1hXRYWkh36Mb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=QpWIQ8Onp1xggkwLM7/S/9sRm6Uy8hp+3ztZ4AmOTFIGULMjPaDbrQTEAynzT5ln2CPDDSPvh/T74vUIQfkMEA+6XwdqTX33KOfzUkiIjnxx+WpC78x8NAMhVGZsXkN41q5lfOsLHtOlBIEmvl3PYBTLdTEME3fpZznMyEI1IQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gj6kJ3AI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719282725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JdOYHmVbQfzrXIDUS0kTztOftl6vBGAX5ErXYmTt9bU=;
	b=Gj6kJ3AINuu1aBICfIQEspA+dXQMmjUlUtErx3EWvpxHtuwKP8o16dMx5EEpUVV5tIQdnk
	yag0txHInCqqn1if/n8Yecu2vQhN80TekQvvrPRnWyVZo58BkLc/qmryVHMilmCWJ3Ih8L
	doYdSBCogi+2/IsnWwQiyYoqISWzN/Y=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-2JVytsB4MYq3CSeMq54Rmw-1; Mon, 24 Jun 2024 22:32:04 -0400
X-MC-Unique: 2JVytsB4MYq3CSeMq54Rmw-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-71a43a07997so3624917a12.3
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 19:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719282723; x=1719887523;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JdOYHmVbQfzrXIDUS0kTztOftl6vBGAX5ErXYmTt9bU=;
        b=i9UEbpffJmTFcF4uWpdpG+Xh9s5ra7lhPRS4VM79GnN5krJHbPjoJdBDBTtbK0+B2v
         r/maJ1rlCsyB4FhQ9jxZsWT6MRCrt7oXdJg/6Pg80v8O+IspUEW5QZlWtT2B9AARFoj3
         rr7ebrpmB7QVtwYMNM08aUE8MwyZi0jSy5F5XQtXlxt8EPrmJh4a1/WnniGwbm1KZNNj
         O8Hsns8Zf0IXXdswRyVeWA+nbhAe+reb2Wm7dVQmbtstN9+bTwWiDpgUH2YHACNs+hPb
         09FndRFb4ZxII6Wcxrg4YDJagnN7xJ7RsmuGfr5NkXHM+CTiGnYh+NiLdKGibr5d2yMh
         0RoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1Kp5IMoiM8Cs4rErQRV8fad0mGHDamgfMttPMwU2g4312NNjUNUg0iahTfJDZKYSG8MVNfg3SNMd6T2m31zRKP2pS
X-Gm-Message-State: AOJu0YwTHJvg1CxP1D8kstNV60dO3/OzuEKt9uNH+Gd7qGGOCNjDsEQ5
	a+KCkp7ON01P88oGRpdTfAFsgy+5mrv3o6W+PYI8S8ZJrZIQGNyrhtPjh0tf1vax6NTOd0ai4J7
	1PoiloBDH4BUjjnjrtwVAifH5Ja3N/+yQ9O9AqjbnZaLnMLL5kQ==
X-Received: by 2002:a17:902:d4d2:b0:1f9:ddb9:3ee5 with SMTP id d9443c01a7336-1fa23fbf4b4mr69506185ad.26.1719282722906;
        Mon, 24 Jun 2024 19:32:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiacLUWBWrz/2FgWyHDRKykXY3k2b72x44Eh/pEo/7jqkypyTOWmT8OBzcY49DgsEXbUG8+w==
X-Received: by 2002:a17:902:d4d2:b0:1f9:ddb9:3ee5 with SMTP id d9443c01a7336-1fa23fbf4b4mr69506005ad.26.1719282722442;
        Mon, 24 Jun 2024 19:32:02 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a801:fda9:d11e:3755:61da:97fd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c6bb2sm69371235ad.142.2024.06.24.19.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 19:32:01 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Date: Mon, 24 Jun 2024 23:31:51 -0300
Message-ID: <ZnosF0tqZF72XARQ@LeoBras>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <ec8088fa-0312-4e98-9e0e-ba9a60106d58@paulmck-laptop>
References: <20240511020557.1198200-1-leobras@redhat.com> <ZkJsvTH3Nye-TGVa@google.com> <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com> <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop> <ZkQ97QcEw34aYOB1@LeoBras> <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop> <ZnPUTGSdF7t0DCwR@LeoBras> <ec8088fa-0312-4e98-9e0e-ba9a60106d58@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jun 20, 2024 at 10:26:38AM -0700, Paul E. McKenney wrote:
> On Thu, Jun 20, 2024 at 04:03:41AM -0300, Leonardo Bras wrote:
> > On Wed, May 15, 2024 at 07:57:41AM -0700, Paul E. McKenney wrote:
> > > On Wed, May 15, 2024 at 01:45:33AM -0300, Leonardo Bras wrote:
> > > > On Tue, May 14, 2024 at 03:54:16PM -0700, Paul E. McKenney wrote:
> > > > > On Mon, May 13, 2024 at 06:47:13PM -0300, Leonardo Bras Soares Passos wrote:
> > > > > > On Mon, May 13, 2024 at 4:40 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > >
> > > > > > > On Fri, May 10, 2024, Leonardo Bras wrote:
> > > > > > > > As of today, KVM notes a quiescent state only in guest entry, which is good
> > > > > > > > as it avoids the guest being interrupted for current RCU operations.
> > > > > > > >
> > > > > > > > While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> > > > > > > > check for any RCU operations waiting for this CPU. In case there are any of
> > > > > > > > such, it invokes rcu_core() in order to sched-out the current thread and
> > > > > > > > note a quiescent state.
> > > > > > > >
> > > > > > > > This occasional schedule work will introduce tens of microsseconds of
> > > > > > > > latency, which is really bad for vcpus running latency-sensitive
> > > > > > > > applications, such as real-time workloads.
> > > > > > > >
> > > > > > > > So, note a quiescent state in guest exit, so the interrupted guests is able
> > > > > > > > to deal with any pending RCU operations before being required to invoke
> > > > > > > > rcu_core(), and thus avoid the overhead of related scheduler work.
> > > > > > >
> > > > > > > Are there any downsides to this?  E.g. extra latency or anything?  KVM will note
> > > > > > > a context switch on the next VM-Enter, so even if there is extra latency or
> > > > > > > something, KVM will eventually take the hit in the common case no matter what.
> > > > > > > But I know some setups are sensitive to handling select VM-Exits as soon as possible.
> > > > > > >
> > > > > > > I ask mainly because it seems like a no brainer to me to have both VM-Entry and
> > > > > > > VM-Exit note the context switch, which begs the question of why KVM isn't already
> > > > > > > doing that.  I assume it was just oversight when commit 126a6a542446 ("kvm,rcu,nohz:
> > > > > > > use RCU extended quiescent state when running KVM guest") handled the VM-Entry
> > > > > > > case?
> > > > > > 
> > > > > > I don't know, by the lore I see it happening in guest entry since the
> > > > > > first time it was introduced at
> > > > > > https://lore.kernel.org/all/1423167832-17609-5-git-send-email-riel@redhat.com/
> > > > > > 
> > > > > > Noting a quiescent state is cheap, but it may cost a few accesses to
> > > > > > possibly non-local cachelines. (Not an expert in this, Paul please let
> > > > > > me know if I got it wrong).
> > > > > 
> > > > > Yes, it is cheap, especially if interrupts are already disabled.
> > > > > (As in the scheduler asks RCU to do the same amount of work on its
> > > > > context-switch fastpath.)
> > > > 
> > > > Thanks!
> > > > 
> > > > > 
> > > > > > I don't have a historic context on why it was just implemented on
> > > > > > guest_entry, but it would make sense when we don't worry about latency
> > > > > > to take the entry-only approach:
> > > > > > - It saves the overhead of calling rcu_virt_note_context_switch()
> > > > > > twice per guest entry in the loop
> > > > > > - KVM will probably run guest entry soon after guest exit (in loop),
> > > > > > so there is no need to run it twice
> > > > > > - Eventually running rcu_core() may be cheaper than noting quiescent
> > > > > > state every guest entry/exit cycle
> > > > > > 
> > > > > > Upsides of the new strategy:
> > > > > > - Noting a quiescent state in guest exit avoids calling rcu_core() if
> > > > > > there was a grace period request while guest was running, and timer
> > > > > > interrupt hits the cpu.
> > > > > > - If the loop re-enter quickly there is a high chance that guest
> > > > > > entry's rcu_virt_note_context_switch() will be fast (local cacheline)
> > > > > > as there is low probability of a grace period request happening
> > > > > > between exit & re-entry.
> > > > > > - It allows us to use the rcu patience strategy to avoid rcu_core()
> > > > > > running if any grace period request happens between guest exit and
> > > > > > guest re-entry, which is very important for low latency workloads
> > > > > > running on guests as it reduces maximum latency in long runs.
> > > > > > 
> > > > > > What do you think?
> > > > > 
> > > > > Try both on the workload of interest with appropriate tracing and
> > > > > see what happens?  The hardware's opinion overrides mine.  ;-)
> > > > 
> > > > That's a great approach!
> > > > 
> > > > But in this case I think noting a quiescent state in guest exit is 
> > > > necessary to avoid a scenario in which a VM takes longer than RCU 
> > > > patience, and it ends up running rcuc in a nohz_full cpu, even if guest 
> > > > exit was quite brief. 
> > > > 
> > > > IIUC Sean's question is more on the tone of "Why KVM does not note a 
> > > > quiescent state in guest exit already, if it does in guest entry", and I 
> > > > just came with a few arguments to try finding a possible rationale, since 
> > > > I could find no discussion on that topic in the lore for the original 
> > > > commit.
> > > 
> > > Understood, and maybe trying it would answer that question quickly.
> > > Don't get me wrong, just because it appears to work in a few tests doesn't
> > > mean that it really works, but if it visibly blows up, that answers the
> > > question quite quickly and easily.  ;-)
> > > 
> > > But yes, if it appears to work, there must be a full investigation into
> > > whether or not the change really is safe.
> > > 
> > > 							Thanx, Paul
> > 
> > Hello Paul, Sean, sorry for the delay on this.
> > 
> > I tested x86 by counting cycles (using rdtsc_ordered()).
> > 
> > Cycles were counted upon function entry/exit on 
> > {svm,vmx}_vcpu_enter_exit(), and right before / after 
> > __{svm,vmx}_vcpu_run() in the same function.
> > 
> > The main idea was to get cycles spend in the procedures before entering 
> > guest (such as reporting RCU quiescent state in entry / exit) and the 
> > cycles actually used by the VM. 
> > 
> > Those cycles were summed-up and stored in per-cpu structures, with a 
> > counter to get the average value. I then created a debug file to read the 
> > results and reset the counters.
> > 
> > As for the VM, it got 20 vcpus, 8GB memory, and was booted with idle=poll.
> > 
> > The workload inside the VM consisted in cyclictest in 16 vcpus 
> > (SCHED_FIFO,p95), while maintaining it's main routine in 4 other cpus 
> > (SCHED_OTHER). This was made to somehow simulate busy and idle-er cpus. 
> > 
> >  $cyclictest -m -q -p95 --policy=fifo -D 1h -h60 -t 16 -a 4-19 -i 200 
> >   --mainaffinity 0-3
> > 
> > All tests were run for exaclty 1 hour, and the clock counter was reset at 
> > the same moment cyclictest stared. After that VM was poweroff from guest.
> > Results show the average for all CPUs in the same category, in cycles.
> > 
> > With above setup, I tested 2 use cases:
> > 1 - Non-RT host, no CPU Isolation, no RCU patience (regular use-case)
> > 2 - PREEMPT_RT host, with CPU Isolation for all vcpus (pinned), and 
> >     RCU patience = 1000ms (best case for RT)
> > 
> > Results are:
> > # Test case 1:
> > Vanilla: (average on all vcpus)
> > VM Cycles / RT vcpu:		123287.75 
> > VM Cycles / non-RT vcpu:	709847.25
> > Setup Cycles:			186.00
> > VM entries / RT vcpu:		58737094.81
> > VM entries / non-RT vcpu:	10527869.25
> > Total cycles in RT VM:		7241564260969.80
> > Total cycles in non-RT VM:	7473179035472.06
> > 
> > Patched: (average on all vcpus)
> > VM Cycles / RT vcpu:		124695.31        (+ 1.14%)
> > VM Cycles / non-RT vcpu:	710479.00        (+ 0.09%)
> > Setup Cycles:			218.65           (+17.55%)
> > VM entries / RT vcpu:		60654285.44      (+ 3.26%) 
> > VM entries / non-RT vcpu:	11003516.75      (+ 4.52%)
> > Total cycles in RT VM:		7563305077093.26 (+ 4.44%)
> > Total cycles in non-RT VM:	7817767577023.25 (+ 4.61%)
> > 
> > Discussion:
> > Setup cycles raised in ~33 cycles, increasing overhead.
> > It proves that noting a quiescent state in guest entry introduces setup 
> > routine costs, which is expected.
> > 
> > On the other hand, both the average time spend inside the VM and the number 
> > of VM entries raised, causing the VM to have ~4.5% more cpu cycles 
> > available to run, which is positive. Extra cycles probably came from not 
> > having invoke_rcu_core() getting ran after VM exit.
> > 
> > 
> > # Test case 2:
> > Vanilla: (average on all vcpus)
> > VM Cycles / RT vcpu:		123785.63
> > VM Cycles / non-RT vcpu:	698758.25
> > Setup Cycles:			187.20
> > VM entries / RT vcpu:		61096820.75
> > VM entries / non-RT vcpu:	11191873.00
> > Total cycles in RT VM:		7562908142051.72
> > Total cycles in non-RT VM:	7820413591702.25
> > 
> > Patched: (average on all vcpus)
> > VM Cycles / RT vcpu:		123137.13        (- 0.52%)
> > VM Cycles / non-RT vcpu:	696824.25        (- 0.28%)
> > Setup Cycles:			229.35           (+22.52%)
> > VM entries / RT vcpu:		61424897.13      (+ 0.54%) 
> > VM entries / non-RT vcpu:	11237660.50      (+ 0.41%)
> > Total cycles in RT VM:		7563685235393.27 (+ 0.01%)
> > Total cycles in non-RT VM:	7830674349667.13 (+ 0.13%)
> > 
> > Discussion:
> > Setup cycles raised in ~42 cycles, increasing overhead.
> > It proves that noting a quiescent state in guest entry introduces setup 
> > routine costs, which is expected.
> > 
> > The average time spend inside the VM was reduced, but the number of VM  
> > entries raised, causing the VM to have around the same number of cpu cycles 
> > available to run, meaning that the overhead caused by reporting RCU 
> > quiescent state in VM exit got absorbed, and it may have to do with those 
> > rare invoke_rcu_core()s that were bothering latency.
> > 
> > The difference is much smaller compared to case 1, and this is probably 
> > because there is a clause in rcu_pending() for isolated (nohz_full) cpus 
> > which may be already inhibiting a lot of invoke_rcu_core()s.
> > 
> > Sean, Paul, what do you think?
> 
> First, thank you for doing this work!

Thanks you!

> 
> I must defer to Sean on how to handle this tradeoff.  My kneejerk reaction
> would be to add yet another knob, but knobs are not free.

Sure, let's wait for Sean's feedback. But I am very positive with the 
results, as we have lantecy improvements for RT, and IIUC performance 
improvements for non-RT.

While we wait, I ran stress-ng in a VM with non-RT kernel (rcu.patience=0), 
and could see instruction count raising in around 1.5% after applying the patch.

Maybe I am missing something, but I thought we could get the ~4.5% 
improvement as seen above.

Thanks!
Leo


> 
> 							Thanx, Paul
> 


