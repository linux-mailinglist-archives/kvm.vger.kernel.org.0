Return-Path: <kvm+bounces-65340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C03CA6E22
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E9EE30EC0B0
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 09:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2512331A75;
	Fri,  5 Dec 2025 09:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="d8jIAI9R"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DB1326954
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 09:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764926547; cv=none; b=dvObPEg9zosseEnk16RYM1WeP45tkOJFMrwJuE67XVHfE6HI2tvSuCJ+tU7ScgivZuhJqxqzSORCrAJDBqmB2MFBTihoULJh/x+bJSHwtcktMWeIiKe/f595ubIfmNDYcF0OuyeDvonozGdF+W1bno2OJljSBHLWjwf908rSBVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764926547; c=relaxed/simple;
	bh=fQsurPc7HBPQaac72RX7ulkqEHzoKbziouLTql4pAgI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4hQ7KvE/ncjwMLje7bvK4Wquoy/5hj3K3QUvwKQZ/oR8jC7F2oQMx8TddY7HQmQnK6rtWMqM3jT6lh74475JGIRRGtLg1FhHv1EXCWew33doSDTHSP6I6S9AU9a2PBk6bOkxDtK39v0VfW12x3U033W+xTQUghcYFgypPDNGEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=d8jIAI9R; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vRS0Y-003DdN-Hw; Fri, 05 Dec 2025 10:21:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector2; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=jnSOmzpxOVfxqBufVHAbglkP1YI+97SGM3i+QNQ8bjA=; b=d8jIAI9Rmhv68ZgyCctdFPOYQa
	dhnQHbzr61g+TTvqrOG3thgtT71C2rx+6qNpLJZQPCue7nBDBdd5yXs1oqzJLd79FDuM+ZRuTUc8J
	vM7NK+N7xp8kz0mJrD7Lk9CwjeTrxT7XoJalbTdofJLywHGAoIKOExQ26mF5LdSV7p1ticMWxwkFC
	kiFn3hahKfshAviE7lqUryjFgON34vb+Wp41kAF3YNbnjMe69w9mHvG4IAbT2d6q3gYBKfbf61AWb
	mzuCzVkTxGxRyjgQCSHgiNnmLCFHcFnLjG0ADCuYOOkLDtQOrSUXaPooCXWCCiRo5bQQyk/ok3Zd6
	oNU8dfeg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vRS0X-0002MU-7F; Fri, 05 Dec 2025 10:21:45 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vRS0V-002RQs-09; Fri, 05 Dec 2025 10:21:43 +0100
Date: Fri, 5 Dec 2025 09:21:40 +0000
From: david laight <david.laight@runbox.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Nikolay Borisov
 <nik.borisov@suse.com>, x86@kernel.org, David Kaplan
 <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang
 <tao1.zhang@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20251205092140.48fa5271@pumpkin>
In-Reply-To: <smt7yrupcypkjsfrtlwp6kznol3mrgrer63plubwfp2hcunoul@yi5rbq5r3w5j>
References: <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
	<f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
	<20251121181632.czfwnfzkkebvgbye@desk>
	<e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
	<20251121212627.6vweba7aehs4cc3h@desk>
	<20251122110558.64455a8d@pumpkin>
	<20251124193126.sdmrhk6dw4jgf5ql@desk>
	<20251125113407.7b241b59@pumpkin>
	<20251204014026.v5huyriswsqu3jat@desk>
	<20251204091511.757ea777@pumpkin>
	<smt7yrupcypkjsfrtlwp6kznol3mrgrer63plubwfp2hcunoul@yi5rbq5r3w5j>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Dec 2025 13:56:02 -0800
Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:

> On Thu, Dec 04, 2025 at 09:15:11AM +0000, david laight wrote:
> > On Wed, 3 Dec 2025 17:40:26 -0800
> > Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> >   
> > > On Tue, Nov 25, 2025 at 11:34:07AM +0000, david laight wrote:  
> > > > On Mon, 24 Nov 2025 11:31:26 -0800
> > > > Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> > > >     
> > > > > On Sat, Nov 22, 2025 at 11:05:58AM +0000, david laight wrote:    
> > > > ...    
> > > > > > For subtle reasons one of the mitigations that slows kernel entry caused
> > > > > > a doubling of the execution time of a largely single-threaded task that
> > > > > > spends almost all its time in userspace!
> > > > > > (I thought I'd disabled it at compile time - but the config option
> > > > > > changed underneath me...)      
> > > > > 
> > > > > That is surprising. If its okay, could you please share more details about
> > > > > this application? Or any other way I can reproduce this?    
> > > > 
> > > > The 'trigger' program is a multi-threaded program that wakes up every 10ms
> > > > to process RTP and TDM audio data.
> > > > So we have a low RT priority process with one thread per cpu.
> > > > Since they are RT they usually get scheduled on the same cpu as last lime.
> > > > I think this simple program will have the desired effect:
> > > > A main process that does:
> > > > 	syscall(SYS_clock_gettime, CLOCK_MONOTONIC, &start_time);
> > > > 	start_time += 1sec;
> > > > 	for (n = 1; n < num_cpu; n++)
> > > > 		pthread_create(thread_code, start_time);
> > > > 	thread_code(start_time);
> > > > with:
> > > > thread_code(ts)
> > > > {
> > > > 	for (;;) {
> > > > 		ts += 10ms;
> > > > 		syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
> > > > 		do_work();
> > > > 	}
> > > > 
> > > > So all the threads wake up at exactly the same time every 10ms.
> > > > (You need to use syscall(), don't look at what glibc does.)
> > > > 
> > > > On my system the program wasn't doing anything, so do_work() was empty.
> > > > What matters is whether all the threads end up running at the same time.
> > > > I managed that using pthread_broadcast(), but the clock code above
> > > > ought to be worse (and I've since changed the daemon to work that way
> > > > to avoid all this issues with pthread_broadcast() being sequential
> > > > and threads not running because the target cpu is running an ISR or
> > > > just looping in kernel).
> > > > 
> > > > The process that gets 'hit' is anything cpu bound.
> > > > Even a shell loop (eg while :; do ;: done) but with a counter will do.
> > > > 
> > > > Without the 'trigger' program, it will (mostly) sit on one cpu and the
> > > > clock frequency of that cpu will increase to (say) 3GHz while the other
> > > > all run at 800Mhz.
> > > > But the 'trigger' program runs threads on all the cpu at the same time.
> > > > So the 'hit' program is pre-empted and is later rescheduled on a
> > > > different cpu - running at 800MHz.
> > > > The cpu speed increases, but 10ms later it gets bounced again.    
> > > 
> > > Sorry I haven't tried creating this test yet.
> > >   
> > > > The real issue is that the cpu speed is associated with the cpu, not
> > > > the process running on it.    
> > > 
> > > So if the 'hit' program gets scheduled to a CPU that is running at 3GHz
> > > then we don't expect a dramatic performance drop? Setting scaling_governor
> > > to "performance" would be an interesting test.  
> > 
> > I failed to find a way to lock the cpu frequency (for other testing) on
> > that system an i7-7xxx - and the system will start thermally throttling
> > if you aren't careful.  
> 
> i7-7xxx would be Kaby Lake gen, those shouldn't need to deploy BHB clear
> mitigation. I am guessing it is the legacy-IBRS mitigation in your case.
> 
> What you described looks very similar to the issue fixed by commit:
> 
>   aa1567a7e644 ("intel_idle: Add ibrs_off module parameter to force-disable IBRS")
> 
>     Commit bf5835bcdb96 ("intel_idle: Disable IBRS during long idle")
>     disables IBRS when the cstate is 6 or lower. However, there are
>     some use cases where a customer may want to use max_cstate=1 to
>     lower latency. Such use cases will suffer from the performance
>     degradation caused by the enabling of IBRS in the sibling idle thread.
>     Add a "ibrs_off" module parameter to force disable IBRS and the
>     CPUIDLE_FLAG_IRQ_ENABLE flag if set.
> 
>     In the case of a Skylake server with max_cstate=1, this new ibrs_off
>     option will likely increase the IRQ response latency as IRQ will now
>     be disabled.
> 
>     When running SPECjbb2015 with cstates set to C1 on a Skylake system.
> 
>     First test when the kernel is booted with: "intel_idle.ibrs_off":
> 
>       max-jOPS = 117828, critical-jOPS = 66047
> 
>     Then retest when the kernel is booted without the "intel_idle.ibrs_off"
>     added:
> 
>       max-jOPS = 116408, critical-jOPS = 58958
> 
>     That means booting with "intel_idle.ibrs_off" improves performance by:
> 
>       max-jOPS:      +1.2%, which could be considered noise range.
>       critical-jOPS: +12%,  which is definitely a solid improvement.

No, it wasn't anything to do with sibling threads.
It was the simple issue of the single-threaded 'busy in userspace' program
getting migrated to an idle cpu running at a low priority.
The IBRS mitigation just affected the timings of the other processes in the
system enough to force the user thread be pre-empted and rescheduled.

So it was not directly related to this code - even though it caused it.
The real issues is the cpu speed being tied to the physical cpu, not the
thread running on it.

> 
> > ISTR that the hardware does most of the work.
> > So I'm not sure what difference "performance" makes (and can't remember what
> > might be set for that system - could set set anyway.)  
> 
> > We did have to disable some of the low power states, waking the cpu from those
> > just takes far too long.  
> 
> Seems like you have a workaround in place already.

I just needed to find out why my fpga compile had gone out from 12 minutes
to over 20 with a kernel update.
Fixing that was easy, but the 'busy thread being migrated to an idle cpu'
is a separate issue that could affect a lot of workloads.
(Whether or not these mitigations are in place.)
Diagnosing it required looking at the scheduler ftrace events and then
realising what effect they would have.
It wouldn't surprise me if people haven't 'fixed' the problem by pinning
a process to a specific cpu, I couldn't try that because the fpga compiler
has some multithreaded parts.

	David



