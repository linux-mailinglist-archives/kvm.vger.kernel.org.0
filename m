Return-Path: <kvm+bounces-25779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D727E96A62C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6820B287835
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544FB1917D9;
	Tue,  3 Sep 2024 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jTwrZ4SR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30E190662
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725386854; cv=none; b=KKUMNtx9L485v1T2Zr5gT3TWnlESWSgnOEMEWHfEG1O0W6iWg233b9SX1pARS8cvRkaIKObpjANnDnkDAXxGfDpAzLe1LYWBC4WfmOB1VVauD26bFOPN9H2esklQteTqADwBqAx1Puytnrky516KtbCL3bQ21mZsd5/u0LhcZjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725386854; c=relaxed/simple;
	bh=klsfJ1Hq2Re+YPq/Pa3ldNM9QbpNsKv5uXNqj+Cxohc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l28uzIypGXOPL1jXtEVqkXT1RKwIvVZ2PW2Tt424MGffIF859kwWn4x087QZcjTklW1/fde6LMTLyE46zdLkYTLDhhOduGAfTaB8VOzxVUTKBVKveKXqzUfiKkdr0MeAHPIM+FrrEYdT1PIO3864rVYL/ujq28Tq4pvzlB7jHu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jTwrZ4SR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20537e42b7aso46951195ad.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 11:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725386852; x=1725991652; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/mYjEszGj3VrU1zhax/3scIdkCgdcwnWdTWHjZj2Pk=;
        b=jTwrZ4SRTyZ2AOwCQfDmpx5ecRs9L+MqlLF3kUDjfcIqE6eg2kyhcmKZrkVshCucPe
         5RGm2clpYfusB36C3L0GwACddOuRaBKdwPZEcs8m3EXiEkD7WQj5p8dfqcJ6+vrpqowQ
         XjzJEtiHCt5Q5e2q+dwJFB0DdWxY9xCyw6Qcqkk3kBCtQN2mKPd7Po7ouAkEapGzCyal
         22OmXOxhvSAZhEUROoaeuc9DToccIXkC9Iizv+El+Ea8p9FVMkj3EYf6p93y/nvsvQIw
         C1GyBwy0tkRn4bNtvhssokx2yHvqQR51e04vDTnW0jYohjYDfed1mnFyYvLYukHcdJoc
         szbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725386852; x=1725991652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/mYjEszGj3VrU1zhax/3scIdkCgdcwnWdTWHjZj2Pk=;
        b=t9nIYNtpBn25FVSTywYHZqb98C2sSP2zgK75yml7B/zGdcD7/3bASOWE8tLzH9yPhJ
         V5lQJ3/eHeneYX6B/Fumk45IvPuf3+VRTSphF/QPPRhOLQIsjWSp2qC6xPUXY1dGrMmQ
         NkYAwPZG/4jOg80y/jMyvI3O5RszBpjgqWljyV04DziPhTXTN8AQjfD6x5EwZA2ioIK7
         VdiA9M7xIy0YNOz4AJJImjxySrtf72VJeWfKTPCgceWxIUD0EeanZGuBxZWnioUDNDue
         BKhM2x5ZV/UL3BuS2u8J/GBmodR3O1kCr0BW5mFzJfezEbe7i56hQiKLrAgON1jSXnwd
         Rh5g==
X-Forwarded-Encrypted: i=1; AJvYcCUVjI97or+43+1uoO/cC+Vh14qmtArJy72YbdBp4wrd6R73hCBf70EHbdmlXuNOP3s+Sqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlDDtyCjzwiO6NFG9CFSILKka903pCBdxf5LDYA7MCj+feARJV
	5FB32mDYUitHRV7xK86rO9Oe+SoXQCRUf8h2fhfw/yn7HCc1r7R5jAnUCjmKoQwmOZbsMGrzywH
	bFQ==
X-Google-Smtp-Source: AGHT+IFWNUf5Q+CP+RQfZ6qatkFRaN1+ePphu3o0HxeU9cZo+gQlQzy/TThthvyRGlnikrtrGRaZqDo1feU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d505:b0:1fc:5ef0:23d1 with SMTP id
 d9443c01a7336-20527f73900mr13706515ad.7.1725386852143; Tue, 03 Sep 2024
 11:07:32 -0700 (PDT)
Date: Tue, 3 Sep 2024 11:07:30 -0700
In-Reply-To: <ZnPUTGSdF7t0DCwR@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240511020557.1198200-1-leobras@redhat.com> <ZkJsvTH3Nye-TGVa@google.com>
 <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com>
 <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop> <ZkQ97QcEw34aYOB1@LeoBras>
 <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop> <ZnPUTGSdF7t0DCwR@LeoBras>
Message-ID: <ZtdQYvfw9GV3LCRK@google.com>
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
From: Sean Christopherson <seanjc@google.com>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Leonardo Bras <leobras@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 20, 2024, Leonardo Bras wrote:
> On Wed, May 15, 2024 at 07:57:41AM -0700, Paul E. McKenney wrote:
> I tested x86 by counting cycles (using rdtsc_ordered()).
> 
> Cycles were counted upon function entry/exit on 
> {svm,vmx}_vcpu_enter_exit(), and right before / after 
> __{svm,vmx}_vcpu_run() in the same function.

Note, for posterity, this is the super-duper inner portion of KVM's run loop.
I.e. the 18-22% increase in latency sounds scary, but only because Leo used a
a relatively small portion of the entry flow for the baseline.  E.g. the total
time would be significantly higher, and thus the percentage increase much lower,
if the measurement started at the beginning of vmx_vcpu_run().

> The main idea was to get cycles spend in the procedures before entering 
> guest (such as reporting RCU quiescent state in entry / exit) and the 
> cycles actually used by the VM. 
> 
> Those cycles were summed-up and stored in per-cpu structures, with a 
> counter to get the average value. I then created a debug file to read the 
> results and reset the counters.
> 
> As for the VM, it got 20 vcpus, 8GB memory, and was booted with idle=poll.
> 
> The workload inside the VM consisted in cyclictest in 16 vcpus 
> (SCHED_FIFO,p95), while maintaining it's main routine in 4 other cpus 
> (SCHED_OTHER). This was made to somehow simulate busy and idle-er cpus. 
> 
>  $cyclictest -m -q -p95 --policy=fifo -D 1h -h60 -t 16 -a 4-19 -i 200 
>   --mainaffinity 0-3
> 
> All tests were run for exaclty 1 hour, and the clock counter was reset at 
> the same moment cyclictest stared. After that VM was poweroff from guest.
> Results show the average for all CPUs in the same category, in cycles.
> 
> With above setup, I tested 2 use cases:
> 1 - Non-RT host, no CPU Isolation, no RCU patience (regular use-case)
> 2 - PREEMPT_RT host, with CPU Isolation for all vcpus (pinned), and 
>     RCU patience = 1000ms (best case for RT)
> 
> Results are:
> # Test case 1:
> Vanilla: (average on all vcpus)
> VM Cycles / RT vcpu:		123287.75 
> VM Cycles / non-RT vcpu:	709847.25
> Setup Cycles:			186.00
> VM entries / RT vcpu:		58737094.81
> VM entries / non-RT vcpu:	10527869.25
> Total cycles in RT VM:		7241564260969.80
> Total cycles in non-RT VM:	7473179035472.06
> 
> Patched: (average on all vcpus)
> VM Cycles / RT vcpu:		124695.31        (+ 1.14%)
> VM Cycles / non-RT vcpu:	710479.00        (+ 0.09%)
> Setup Cycles:			218.65           (+17.55%)
> VM entries / RT vcpu:		60654285.44      (+ 3.26%) 
> VM entries / non-RT vcpu:	11003516.75      (+ 4.52%)
> Total cycles in RT VM:		7563305077093.26 (+ 4.44%)
> Total cycles in non-RT VM:	7817767577023.25 (+ 4.61%)
> 
> Discussion:
> Setup cycles raised in ~33 cycles, increasing overhead.
> It proves that noting a quiescent state in guest entry introduces setup 

Isn't the effect of the patch note a quiescent state in guest exit?  

> routine costs, which is expected.
> 
> On the other hand, both the average time spend inside the VM and the number 
> of VM entries raised, causing the VM to have ~4.5% more cpu cycles 
> available to run, which is positive. Extra cycles probably came from not 
> having invoke_rcu_core() getting ran after VM exit.
> 
> 
> # Test case 2:
> Vanilla: (average on all vcpus)
> VM Cycles / RT vcpu:		123785.63
> VM Cycles / non-RT vcpu:	698758.25
> Setup Cycles:			187.20
> VM entries / RT vcpu:		61096820.75
> VM entries / non-RT vcpu:	11191873.00
> Total cycles in RT VM:		7562908142051.72
> Total cycles in non-RT VM:	7820413591702.25
> 
> Patched: (average on all vcpus)
> VM Cycles / RT vcpu:		123137.13        (- 0.52%)
> VM Cycles / non-RT vcpu:	696824.25        (- 0.28%)
> Setup Cycles:			229.35           (+22.52%)
> VM entries / RT vcpu:		61424897.13      (+ 0.54%) 
> VM entries / non-RT vcpu:	11237660.50      (+ 0.41%)
> Total cycles in RT VM:		7563685235393.27 (+ 0.01%)
> Total cycles in non-RT VM:	7830674349667.13 (+ 0.13%)
> 
> Discussion:
> Setup cycles raised in ~42 cycles, increasing overhead.
> It proves that noting a quiescent state in guest entry introduces setup 

Same here, s/entry/exit, correct?  I just want to make sure I'm not completely
misunderstanding something.

> routine costs, which is expected.
> 
> The average time spend inside the VM was reduced, but the number of VM  
> entries raised, causing the VM to have around the same number of cpu cycles 
> available to run, meaning that the overhead caused by reporting RCU 
> quiescent state in VM exit got absorbed, and it may have to do with those 
> rare invoke_rcu_core()s that were bothering latency.
> 
> The difference is much smaller compared to case 1, and this is probably 
> because there is a clause in rcu_pending() for isolated (nohz_full) cpus 
> which may be already inhibiting a lot of invoke_rcu_core()s.
> 
> Sean, Paul, what do you think?

I'm in favor of noting the context switch on exit.  Singling out this patch for
introducing ~30 cycles of latency in entry/exit is rather ridiculous.  I guarantee
ww have introduced far more latency at various times without any scrutiny, even
if we were to limit the search to just the fastpath entry/exit loop.  Outside of
the fastpath, there's basically zero chance the extra 30-40 cycles are meaningful.

Even without the non-RT improvement, I'd give this a thumbs up just so that entry
and exit are symmetrical.  The fact that noting the context switches seems to be
a win-win is icing on the cake.

So, assuming the above entry/exit confusion was just a typo,

Acked-by: Sean Christopherson <seanjc@google.com>

