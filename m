Return-Path: <kvm+bounces-64282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BCDC7CDDC
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 12:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AD0FB359AD6
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 11:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7DF2F28EB;
	Sat, 22 Nov 2025 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="P/KYghNJ"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7792DC772
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 11:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763809605; cv=none; b=TE5r0DA7qkpmkV8Pkr/I0tM5/rgq5NetiDn1zgRE3KYYmtd/swh0klUsfiWIx1wXcCDAwg89s+QPB/t/a3Rb4iPNQQmHm43Ajg2v827PD6Z5zbRpClKlW9a9kyFyP0QqvINA2rGRqvu9N6ggkTzPaOZY5LGlyLUSlS5nD2ESJR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763809605; c=relaxed/simple;
	bh=z4WD7xTwGGV9qVOovzIoKWz9wqjTG64Wd5jBKw24TQc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJ6PGtNvnLGn6bB9S9ZwAJ4qys0ahkn1PI/VIXOeTWnL8EIZRpiE7RkAkA7A5oqy2YJlT77ZPKZacTeCW/uOc94E4Uqk4r3eJdtICRkAiaegjBOUFGkRIqTGsHFpuGDa+7gyJqkq+c+RMM2r+j1SsN5AZ5rvMqWRHx3IB9n6bsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=P/KYghNJ; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vMlRZ-00Enf2-6H; Sat, 22 Nov 2025 12:06:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=7VZrXOXHWa8SVhKM3MPHVklgivUEO1zbUyipKcLJQE4=; b=P/KYghNJ86MIRvq0O1bLafD8wl
	l3YaOpPjhuwtUfa3xdmA9S0KJdHx5QeLWeoN4OJswXZvgsnelSLcjbryZ6t9DjL4K34a5s9inlg6r
	X7uhcvwBR2t40fao2TO1sehh1IoY24AuQfWt5beH+dm/rXN+2zw2PeiaqpqW0+8wdCgomyrZGqG/9
	q0GRqyHq61g2csC7K9MfVGeHtnH3kq5YmlJfYxct4M+NEvJtIT1LC/XLxZbgH77t6kmJdWVdZjXuX
	wqDZV64Rc/R0S7g7sRiPMMzEbhfocvPUr9soVup1Cs6vKnQGXS07l3x4yAK6DudixYft2EWFelErV
	71HwmCyA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vMlRY-0000Ti-2W; Sat, 22 Nov 2025 12:06:16 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vMlRI-003nP6-Qd; Sat, 22 Nov 2025 12:06:00 +0100
Date: Sat, 22 Nov 2025 11:05:58 +0000
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
Message-ID: <20251122110558.64455a8d@pumpkin>
In-Reply-To: <20251121212627.6vweba7aehs4cc3h@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
	<20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
	<4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
	<e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
	<f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
	<20251121181632.czfwnfzkkebvgbye@desk>
	<e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
	<20251121212627.6vweba7aehs4cc3h@desk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Nov 2025 13:26:27 -0800
Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:

> On Fri, Nov 21, 2025 at 10:42:24AM -0800, Dave Hansen wrote:
> > On 11/21/25 10:16, Pawan Gupta wrote:  
> > > On Fri, Nov 21, 2025 at 08:50:17AM -0800, Dave Hansen wrote:  
> > >> On 11/21/25 08:45, Nikolay Borisov wrote:  
> > >>> OTOH: the global variable approach seems saner as in the macro you'd
> > >>> have direct reference to them and so it will be more obvious how things
> > >>> are setup.  
> > >>
> > >> Oh, yeah, duh. You don't need to pass the variables in registers. They
> > >> could just be read directly.  
> > > 
> > > IIUC, global variables would introduce extra memory loads that may slow
> > > things down. I will try to measure their impact. I think those global
> > > variables should be in the .entry.text section to play well with PTI.  
> > 
> > Really? I didn't look exhaustively, but CLEAR_BRANCH_HISTORY seems to
> > get called pretty close to where the assembly jumps into C. Long after
> > we're running on the kernel CR3.  
> 
> You are right. PTI is not a concern here.
> 
> > > Also I was preferring constants because load values from global variables
> > > may also be subject to speculation. Although any speculation should be
> > > corrected before an indirect branch is executed because of the LFENCE after
> > > the sequence.  
> > 
> > I guess that's a theoretical problem, but it's not a practical one.  
> 
> Probably yes. But, load from memory would certainly be slower compared to
> immediates.
> 
> > So I think we have 4-ish options at this point:
> > 
> > 1. Generate the long and short sequences independently and in their
> >    entirety and ALTERNATIVE between them (the original patch)
> > 2. Store the inner/outer loop counts in registers and:
> >   2a. Load those registers from variables
> >   2b. Load them from ALTERNATIVES  
> 
> Both of these look to be good options to me.
> 
> 2b. would be my first preference, because it keeps the loop counts as
> inline constants. The resulting sequence stays the same as it is today.
> 
> > 3. Store the inner/outer loop counts in variables in memory  
> 
> I could be wrong, but this will likely have non-zero impact on performance.
> I am afraid to cause any regressions in BHI mitigation. That is why I
> preferred the least invasive approach in my previous attempts.

Surely it won't be significant compared to the cost of the loop itself.
That is the bit that really kills performance.

For subtle reasons one of the mitigations that slows kernel entry caused
a doubling of the execution time of a largely single-threaded task that
spends almost all its time in userspace!
(I thought I'd disabled it at compile time - but the config option
changed underneath me...)

	David



