Return-Path: <kvm+bounces-64493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F568C84C10
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 12:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 091C43ACA71
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B1A2F60D6;
	Tue, 25 Nov 2025 11:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="nEHkgvJa"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E45927603C
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 11:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764070471; cv=none; b=BKkcZaeC6E54HkYVWLjhUX3UM+jrm4TZrpAt2WbgCWHRmVLTrZsUrOwRH17gbDH2AAllc/fFZ+6s4RxBT25d9tpHEzMJsGF+AKQykr6JlgIgM8CLAPk7D9TU27rBhO0g0S1TiKSMYLfSVPi1yt0rpka/6ux7t7mVH8Kk760J1Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764070471; c=relaxed/simple;
	bh=Hqu2/5CXPgEaxogT5E41aAfZjC2qwAxGqdXsfZRrN1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7n2xj/OthUWfRyJbEN9sBZ6XCGWvHHKYppwVHL+Lo8ut85DcbjCxJ320gx6u9mAtHj4gxhuM2hgk2n3uJrNyBpMH1yOocoMHekpgIPeTpWT5jVSrzcAnE3iS2iCvHSv0u8v7bUEqKWf8xX3qIuNqXVNOL0LDpQcKz+79K6ajck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=nEHkgvJa; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vNrJI-0068Nn-JA; Tue, 25 Nov 2025 12:34:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=E18goiVMEjUJwHM3ClD1gLrN51V8XAaBnO2jsp+sQ9I=; b=nEHkgvJaE6E9hly/8yRaTH7Gy2
	MDrhFJJm1FE/3rne3id9qLBR9ofvXb4GMQYypzsFSe/XGZRnZK22TyhIuy46+BETBz6Tt9Lvs/gsL
	QwZrPTz6jg6xanHSdJfqDYCa6iEeNAHtB2F1W1ySbhw1l/iiJHenhMI8Jh0ORsC0mn8ejvDEQsqIk
	pDkFUgfcxLkfUGVNuYxu/TC5OvAaShSTCtZ3RQ0vzIhPHsDaLsh9iMquTxM5n7ofb15IZYewu/54I
	H2e6ZsSnDDSo1dPcWeAEbV1xgOYT7dl79QrLX2m/qWbRYV+TMujqkr0k7Ux/xJgD8ec8ubo8Dvils
	OInQJYHg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vNrJH-0005Kd-CT; Tue, 25 Nov 2025 12:34:15 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vNrJC-00AiWa-Gw; Tue, 25 Nov 2025 12:34:10 +0100
Date: Tue, 25 Nov 2025 11:34:07 +0000
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
Message-ID: <20251125113407.7b241b59@pumpkin>
In-Reply-To: <20251124193126.sdmrhk6dw4jgf5ql@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
	<20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
	<4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
	<e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
	<f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
	<20251121181632.czfwnfzkkebvgbye@desk>
	<e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
	<20251121212627.6vweba7aehs4cc3h@desk>
	<20251122110558.64455a8d@pumpkin>
	<20251124193126.sdmrhk6dw4jgf5ql@desk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Nov 2025 11:31:26 -0800
Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:

> On Sat, Nov 22, 2025 at 11:05:58AM +0000, david laight wrote:
...
> > For subtle reasons one of the mitigations that slows kernel entry caused
> > a doubling of the execution time of a largely single-threaded task that
> > spends almost all its time in userspace!
> > (I thought I'd disabled it at compile time - but the config option
> > changed underneath me...)  
> 
> That is surprising. If its okay, could you please share more details about
> this application? Or any other way I can reproduce this?

The 'trigger' program is a multi-threaded program that wakes up every 10ms
to process RTP and TDM audio data.
So we have a low RT priority process with one thread per cpu.
Since they are RT they usually get scheduled on the same cpu as last lime.
I think this simple program will have the desired effect:
A main process that does:
	syscall(SYS_clock_gettime, CLOCK_MONOTONIC, &start_time);
	start_time += 1sec;
	for (n = 1; n < num_cpu; n++)
		pthread_create(thread_code, start_time);
	thread_code(start_time);
with:
thread_code(ts)
{
	for (;;) {
		ts += 10ms;
		syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
		do_work();
	}

So all the threads wake up at exactly the same time every 10ms.
(You need to use syscall(), don't look at what glibc does.)

On my system the program wasn't doing anything, so do_work() was empty.
What matters is whether all the threads end up running at the same time.
I managed that using pthread_broadcast(), but the clock code above
ought to be worse (and I've since changed the daemon to work that way
to avoid all this issues with pthread_broadcast() being sequential
and threads not running because the target cpu is running an ISR or
just looping in kernel).

The process that gets 'hit' is anything cpu bound.
Even a shell loop (eg while :; do ;: done) but with a counter will do.

Without the 'trigger' program, it will (mostly) sit on one cpu and the
clock frequency of that cpu will increase to (say) 3GHz while the other
all run at 800Mhz.
But the 'trigger' program runs threads on all the cpu at the same time.
So the 'hit' program is pre-empted and is later rescheduled on a
different cpu - running at 800MHz.
The cpu speed increases, but 10ms later it gets bounced again.

The real issue is that the cpu speed is associated with the cpu, not
the process running on it.

	David

