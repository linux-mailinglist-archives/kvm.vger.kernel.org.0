Return-Path: <kvm+bounces-32134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B4C1B9D35F3
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 09:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B4A2B23C62
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 08:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBC81865E5;
	Wed, 20 Nov 2024 08:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gzqe1rXw"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBD250276;
	Wed, 20 Nov 2024 08:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732092779; cv=none; b=AlgfT7bFWU/LIN2QK2URNn1d6FM1eEZalwxspSp+NvGmzff+Mo8mUrpscjKlU5U4ndLIe2Aan1a6GsnMkCfnUEqhItLlgF1AqarvK8dosCNUMhnEjxswUak2vL6CFjdPIXKDgu3aldgf2uua39sc0zli//QNn4H/tXIUdp1sQvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732092779; c=relaxed/simple;
	bh=jqzSeCffgKwl2e+YsJwV22juE1J7GGkkNSKBdv2GvYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAmq81C80g4HZxE78Q6A57oeGfLzvjougSb2VysVdcQJv03tWQH9qgGnWoQD1xV9rhh3vfa06+D3usldyeOgnng0TTJlfhILfNdHHyKOelkZFcXtrXzlKZ7cftG0a76g4LPq5ivJFJ55roWcm2thdO/i/4X0IftMiSb4nGguRMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gzqe1rXw; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jduJ178qgdK5BAmuRB8bUI3Uay+hyDu+MXXtJ5Xz4wY=; b=Gzqe1rXwcqU62Zz8HPkWOQrYLm
	WDwHOXSf8sN6k2Zmqj6EWOT/22aEn8EBPDRUqJAxYVQyD7suFu79yKIcGL+tT+IkyZCLLpcBZ5OJ0
	hi9JiRAoguReGgvxwwsGiBY1P7gyHls8fH7kEJEEvO67j9yMqYtORGmZUOw4QtRjOCS7vcSiAp5hL
	QZbxXdz/iN2hAKqmO4eJqcYwC4A23EKDv6wXtkhg08WwX0YKQi9xEcgF7F7jUR8mLjT22nx+aEtCS
	lGP2m6UmLSauunqXGGt0/De04SrlzrqkGTNfZjcrjuSo62Pma9/+L+GYzZtbhLy0fplK/inlrucyG
	1ylFkNdQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDgSD-000000052wP-39Li;
	Wed, 20 Nov 2024 08:52:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A336B3006AB; Wed, 20 Nov 2024 09:52:54 +0100 (CET)
Date: Wed, 20 Nov 2024 09:52:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 01/12] objtool: Generic annotation infrastructure
Message-ID: <20241120085254.GD19989@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.113053713@infradead.org>
 <20241115183828.6cs64mpbp5cqtce4@jpoimboe>
 <20241116093331.GG22801@noisy.programming.kicks-ass.net>
 <20241120003123.rhb57tk7mljeyusl@jpoimboe>
 <20241120010424.thsbdwfwz2e7elza@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120010424.thsbdwfwz2e7elza@jpoimboe>

On Tue, Nov 19, 2024 at 05:04:24PM -0800, Josh Poimboeuf wrote:
> On Tue, Nov 19, 2024 at 04:31:25PM -0800, Josh Poimboeuf wrote:
> > On Sat, Nov 16, 2024 at 10:33:31AM +0100, Peter Zijlstra wrote:
> > > On Fri, Nov 15, 2024 at 10:38:28AM -0800, Josh Poimboeuf wrote:
> > > > On Mon, Nov 11, 2024 at 12:59:36PM +0100, Peter Zijlstra wrote:
> > > > > +#define ASM_ANNOTATE(x)						\
> > > > > +	"911:\n\t"						\
> > > > > +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > > > > +	".long 911b - .\n\t"					\
> > > > > +	".long " __stringify(x) "\n\t"				\
> > > > > +	".popsection\n\t"
> > > > 
> > > > Why mergeable and progbits?
> > > 
> > > In order to get sh_entsize ?
> > 
> > Is that a guess?  If so, it's not very convincing as I don't see what
> > entsize would have to do with it.
> 
> Oh, nevermind... I see it's a gas syntax issue.

Not a guess, only mergable gets entsize, and progbits is a required
argument per the syntax in order to specify entsize.

