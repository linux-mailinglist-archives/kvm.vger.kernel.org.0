Return-Path: <kvm+bounces-68742-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDZmEMf4cGnibAAAu9opvQ
	(envelope-from <kvm+bounces-68742-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:03:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CF02E59A1F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EC68F9EEB61
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248A747D923;
	Wed, 21 Jan 2026 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Eeb1fftB"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B509D4779B3;
	Wed, 21 Jan 2026 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769009497; cv=none; b=QHBA4pft8Jgc5b8/gI9nZJhR//tjX/hmEJ+gHNM/rjExke92VL1+UapYF2N4Cj+cjoJDT19H/ikCxEOLZ9FqDZNvRttZyiwmUoB/09BjeXxGeQk6lzgyyTm9BBGzczeJwiVxZd+jaE2PaoDj21jlXHk1Qq3qKKdcQA2n6ThvPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769009497; c=relaxed/simple;
	bh=obw6HarFyVHtBB1yPFy+hnDtdrCkA/cpeRGgY4EOmtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIG6aKgPV9Y3x27KyV5izh0P8JkV0Z/wFXyVwoaK1iVWy8WuvzG2iUHsUe1Cj0wM3x4b4O+Bb79exNAi5D8tL2jY1q2uHpAAVMRTOZFxiW/n0G0cjiB1LQ3Fw1R1mSn114oqFdRspchUAd22BNuSK6qastQqF7G+q1j85hZvvvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Eeb1fftB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i3JkLE7dUkOYmMfJyJBrEltJHtZpM7j/thftjQhkvB0=; b=Eeb1fftBHTnBVKe7SjS0pm7mb6
	IUORuQJKk0skvtyCcv+U6iiYwi/BA12JD5Wj0w2fEyJzTB6rgJPW48WVwibT+qTN5x5arTQVcHvjr
	xf1uknvMCpyuzhrOoASwckEESul6AzdOMmmVqIcggPgw/aCzewn2lzlN7SA95/gZT1KA/3i8t90ll
	tEm8tKUqU8jxu8ZXLicywfRWlRmT9in/aDizpXMqxF/HQ6FgOX2L41fh+LrJ7lK0lEhnL1yEE0hL1
	/Ccl3Z41f8ULoh+tpX8s88kOsC9TLB0sNBXLyp4ylLWcCiqzF6ABXP0c5LJ2iBBKC+g3jE3Injd41
	PVVNs1Rw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viaB2-0000000GXQh-38aq;
	Wed, 21 Jan 2026 15:31:24 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0FB2E300329; Wed, 21 Jan 2026 16:31:24 +0100 (CET)
Date: Wed, 21 Jan 2026 16:31:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fernand Sieber <sieberf@amazon.com>
Cc: dwmw2@infradead.org, seanjc@google.com, abusse@amazon.de, bp@alien8.de,
	dave.hansen@linux.intel.com, hborghor@amazon.de, hpa@zytor.com,
	jschoenh@amazon.de, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, mingo@redhat.com,
	nh-open-source@amazon.com, nsaenz@amazon.com, pbonzini@redhat.com,
	stable@vger.kernel.org, tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH v2] perf/x86/intel: Do not enable BTS for guests
Message-ID: <20260121153124.GB171111@noisy.programming.kicks-ass.net>
References: <20251210111655.GB3911114@noisy.programming.kicks-ass.net>
 <20251211183604.868641-1-sieberf@amazon.com>
 <ff49b3013a4ff7626c6f6ac574f85348c35ccc42.camel@infradead.org>
 <20260121135713.214711-1-sieberf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121135713.214711-1-sieberf@amazon.com>
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[infradead.org,none];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-68742-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: CF02E59A1F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 03:57:13PM +0200, Fernand Sieber wrote:
> Hi Peter,
> 
> Could you please take another look and see if you are happy to pull in v2 which
> implements the approach that you suggested?

Yeah, sorry, fell into a crack and all that. Got it now.

Thanks!

