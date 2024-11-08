Return-Path: <kvm+bounces-31320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CC59C2597
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B8EC2857C5
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A791C1F06;
	Fri,  8 Nov 2024 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lGL3ULaR"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED3B233D79;
	Fri,  8 Nov 2024 19:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731094339; cv=none; b=SGp4ugToDANfwovvrrSx6+DCJtLdl5uT9NH0tlxDDwgwjBPEYjVMeEo9jIpiS4c3edDpAEKQsdjudNMiyv2WzV7mc7gyTaf2YYse1Nfw5MDYPBvKEVnSlgw8oAmfujiIGwd8HK4uYOiqQgSlKIeScaMvO061sqTGkJe8mHyzmC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731094339; c=relaxed/simple;
	bh=hoBzpFB0OkEDRkiYhf9JKfhP+AkpGB1v3rwZ6doySso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcH0gnCWDBo92Bbt/4+KJCmNGN2EQn5AF4vm1nG88vluFfm3txCr+GkejrJirtHMpN/2pk+aWN/wyoqVj7ypwYEbtCZSpV/ekHG1FUwgyOTw4SP+fiITuKfy82R4vcB1BiZTwcoPy6KVRXkqaXSDMTka8nuq9f5UQaFXX5WIepI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lGL3ULaR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qFRzNI5DfFiu+JYAcGStf7GLEGzYk/QY4lQcntQCySg=; b=lGL3ULaRWdu2Akw/Y19it6Q3jM
	KWv9cmjXIpe6/WiQu6YsBZMXv1uaS0zwkhcynAZrHTwSFJOVBPXXo4c1X29Xy6tueMv5xE/uyvVqz
	UUSk1AybdlMyGzga//U4/q11RBKsGYyVkcwtgTxpd2ugk+q6M/ObL7CiLXI9GFqWJcBf8KpUFVOor
	JJisCsf4ptpseER9AR99Dkmj1EgzlqpFgyC0qMHZ4omO+cZsK9k4iXYv0egBdueiNadO6BtpC9Aej
	W6Gz7heyDXFtfAz87U4uAKFlERlD81b6510jyZ8GCPYKZtiq96hg42aJgYQILimrMa8cGlF8yhANA
	J3K6+ybA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t9UiC-00000009EL1-1dYM;
	Fri, 08 Nov 2024 19:32:05 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9556130049D; Fri,  8 Nov 2024 20:32:04 +0100 (CET)
Date: Fri, 8 Nov 2024 20:32:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, seanjc@google.com,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, will@kernel.org, linux@armlinux.org.uk,
	catalin.marinas@arm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com, tglx@linutronix.de,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v7 4/5] x86: perf: Refactor misc flag assignments
Message-ID: <20241108193204.GC38972@noisy.programming.kicks-ass.net>
References: <20241108153411.GF38786@noisy.programming.kicks-ass.net>
 <gsntbjypft37.fsf@coltonlewis-kvm.c.googlers.com>
 <20241108192043.GA22801@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108192043.GA22801@noisy.programming.kicks-ass.net>

On Fri, Nov 08, 2024 at 08:20:44PM +0100, Peter Zijlstra wrote:

> Isn't the below more or less what you want?
> 
> static unsigned long misc_flags(struct pt_regs *regs)
> {
> 	unsigned long flags = 0;
> 
> 	if (regs->flags & PERF_EFLAGS_EXACT)
> 		flags |= PERF_RECORD_MISC_EXACT_IP;
> 
> 	return flags;
> }
> 
> static unsigned long native_flags(struct pt_regs *regs)
> {
> 	unsigned long flags = 0;
> 
> 	if (user_mode(regs))
> 		flags |= PERF_RECORD_MISC_USER;
> 	else
> 		flags |= PERF_RECORD_MISC_KERNEL;
> 
> 	return flags;
> }
> 
> static unsigned long guest_flags(struct pt_regs *regs)
> {
> 	unsigned long guest_state = perf_guest_state();
> 	unsigned long flags = 0;
> 
> 	if (guest_state & PERF_GUEST_ACTIVE) {
> 		if (guest_state & PERF_GUEST_USER)
> 			flags |= PERF_RECORD_MISC_GUEST_USER;
> 		else
> 			flags |= PERF_RECORD_MISC_GUEST_KERNEL;
> 	}
> 
> 	return flags;
> }
> 
> unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> {
> 	unsigned long flags;
> 
> 	flags = misc_flags(regs);
> 	flags |= guest_flags(regs);
> 
> 	return flags;
> }
> 
> unsigned long perf_arch_misc_flags(struct pt_regs *regs)
> {
> 	unsigned long flags;
> 	unsigned long guest;
> 
> 	flags = misc_flags(regs);
> 	guest = guest_flags(regs);
> 	if (guest)
> 		flags |= guest;
> 	else
> 		flags |= native_flags(regs);
> 
> 	return flags;
> }

This last can be written more concise:

unsigned long perf_arch_misc_flags(struct pt_regs *regs)
{
	unsigned long flags;

	flags = guest_flags(regs);
	if (!flags)
		flags |= native_flags(regs);

	flgs |= misc_flags(regs);

	return flags;
}


