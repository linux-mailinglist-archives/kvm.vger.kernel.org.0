Return-Path: <kvm+bounces-65257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 476F9CA2EFF
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D92EF3094B6B
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0318833DED7;
	Thu,  4 Dec 2025 09:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="lvwy+AIl"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEF02C0F8C;
	Thu,  4 Dec 2025 09:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764839761; cv=none; b=amsDvTGo8/+MzPME1tghrpZqbWyNv64woo5s/m54K+X2upA1Qr3A5MbI7dv0bEQnAvnT3jrl+QNChEJ/fSppIWznhescaS0jhYWhyKwyGzEbcPZhS7dlbpMPFH6fT9dfGgZqqA6X3pr9rgsSeyy27UFQCPTylSI47Hn68jiwozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764839761; c=relaxed/simple;
	bh=pYS0Xzd5LOCw5z5c+gWWUq+H+yDlEffmwLx7TsUOUKA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MtyalI91ddl7Ra7zs/Em2PSLsXZuEMk9HOQYHcCBMHWwIu7T89Lv8f/yE9kw9eRh8LEHF7VSSrjhyJUCVy903BgpTcmzlgtvlLxsxCdM+bC4yNE6UnomYpeZnzA6Ag1SxbSgCgCCJba29IeCfhxgHqZ1UDtMv8+wzY/JAeKUKTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=lvwy+AIl; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vR5Qx-00HONM-HL; Thu, 04 Dec 2025 10:15:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector2; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=SBmjjo/M1GuZIiaRdjn//6HnCZT6LsotKiHQsrygOEA=; b=lvwy+AIlPvi6PVlny+uevfmjzb
	tbGGU0EAagU9y3rECqeecBDH0UdHH8KQySRJgUJdJllZ7otmRB3cmIGXFJjqFwCVn8UO8P4hfzY0x
	6CyLnmn+knY+H6bk0roYAVWAv+SjysGMDJdOmW6YZeJH6sJrkz6V7FSfwfy5bqQDcMoYTE3Ts0+48
	3/qC0jepSi8bBtEcRwyw6C+F0vSpL/J6ZKkjQ+csqu8oEhpm47mPGS/7rngzNKdhmA+QGU30Nki2Y
	CADbzzRhvhQs21VvhAGSwBWQRBZVcCTQqCuQgf7CPcjcr+eIvYzYhLFXjalnD+Sa+3NpQ9qbEuhXa
	5RH63vhw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vR5Qw-0001RJ-DO; Thu, 04 Dec 2025 10:15:30 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vR5Qg-00EMr0-28; Thu, 04 Dec 2025 10:15:14 +0100
Date: Thu, 4 Dec 2025 09:15:11 +0000
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
Message-ID: <20251204091511.757ea777@pumpkin>
In-Reply-To: <20251204014026.v5huyriswsqu3jat@desk>
References: <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
	<4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
	<e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
	<f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
	<20251121181632.czfwnfzkkebvgbye@desk>
	<e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
	<20251121212627.6vweba7aehs4cc3h@desk>
	<20251122110558.64455a8d@pumpkin>
	<20251124193126.sdmrhk6dw4jgf5ql@desk>
	<20251125113407.7b241b59@pumpkin>
	<20251204014026.v5huyriswsqu3jat@desk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 Dec 2025 17:40:26 -0800
Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:

> On Tue, Nov 25, 2025 at 11:34:07AM +0000, david laight wrote:
> > On Mon, 24 Nov 2025 11:31:26 -0800
> > Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> >   
> > > On Sat, Nov 22, 2025 at 11:05:58AM +0000, david laight wrote:  
> > ...  
> > > > For subtle reasons one of the mitigations that slows kernel entry caused
> > > > a doubling of the execution time of a largely single-threaded task that
> > > > spends almost all its time in userspace!
> > > > (I thought I'd disabled it at compile time - but the config option
> > > > changed underneath me...)    
> > > 
> > > That is surprising. If its okay, could you please share more details about
> > > this application? Or any other way I can reproduce this?  
> > 
> > The 'trigger' program is a multi-threaded program that wakes up every 10ms
> > to process RTP and TDM audio data.
> > So we have a low RT priority process with one thread per cpu.
> > Since they are RT they usually get scheduled on the same cpu as last lime.
> > I think this simple program will have the desired effect:
> > A main process that does:
> > 	syscall(SYS_clock_gettime, CLOCK_MONOTONIC, &start_time);
> > 	start_time += 1sec;
> > 	for (n = 1; n < num_cpu; n++)
> > 		pthread_create(thread_code, start_time);
> > 	thread_code(start_time);
> > with:
> > thread_code(ts)
> > {
> > 	for (;;) {
> > 		ts += 10ms;
> > 		syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
> > 		do_work();
> > 	}
> > 
> > So all the threads wake up at exactly the same time every 10ms.
> > (You need to use syscall(), don't look at what glibc does.)
> > 
> > On my system the program wasn't doing anything, so do_work() was empty.
> > What matters is whether all the threads end up running at the same time.
> > I managed that using pthread_broadcast(), but the clock code above
> > ought to be worse (and I've since changed the daemon to work that way
> > to avoid all this issues with pthread_broadcast() being sequential
> > and threads not running because the target cpu is running an ISR or
> > just looping in kernel).
> > 
> > The process that gets 'hit' is anything cpu bound.
> > Even a shell loop (eg while :; do ;: done) but with a counter will do.
> > 
> > Without the 'trigger' program, it will (mostly) sit on one cpu and the
> > clock frequency of that cpu will increase to (say) 3GHz while the other
> > all run at 800Mhz.
> > But the 'trigger' program runs threads on all the cpu at the same time.
> > So the 'hit' program is pre-empted and is later rescheduled on a
> > different cpu - running at 800MHz.
> > The cpu speed increases, but 10ms later it gets bounced again.  
> 
> Sorry I haven't tried creating this test yet.
> 
> > The real issue is that the cpu speed is associated with the cpu, not
> > the process running on it.  
> 
> So if the 'hit' program gets scheduled to a CPU that is running at 3GHz
> then we don't expect a dramatic performance drop? Setting scaling_governor
> to "performance" would be an interesting test.

I failed to find a way to lock the cpu frequency (for other testing) on
that system an i7-7xxx - and the system will start thermally throttling
if you aren't careful.
ISTR that the hardware does most of the work.
So I'm not sure what difference "performance" makes (and can't remember what
might be set for that system - could set set anyway.)
We did have to disable some of the low power states, waking the cpu from those
just takes far too long.

	David

