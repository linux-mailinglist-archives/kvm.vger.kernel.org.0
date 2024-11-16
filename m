Return-Path: <kvm+bounces-31980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22BA39CFD88
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC699288BF2
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 09:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234D2194A52;
	Sat, 16 Nov 2024 09:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lcu/t+CU"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3B91917E6;
	Sat, 16 Nov 2024 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731749855; cv=none; b=Gqljwa/iUrQEiVe7Pd6y54UX2W79Yk8NYFDaCp4ecrNDemC0agvZLrLAV2glVGo5+Dk1URZmB/JeYe1D9oVt/76P7iMDSa5jA4/DjMN1L+7b4rHIodelhgzrHwFHUWTPLeGK1Y8XH7GmEMQDbTspNb8/bZUgnaulljffPnjnJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731749855; c=relaxed/simple;
	bh=l4G5WfJOZEr5+pSJS0lKmvb8gMwkRCDFa0hFiHAyUoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1HHWUsgz6ACJ6pNYic9L1orBXZtWPaVJm4wE+cP/0L1BqfieOipkszwZtYx4AS8DxTBhwQGYlvOz+DN/wsNznSIq3+sNCuNvukDcow/pxn/t4RrbmllJiv0ul34U9fN0ufpIisPZYs9JLAmcU3zqDdYLIXPunT1b22feo75bvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lcu/t+CU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BEpdkubQ2J5nIsM7FvnVQvF0gX3H9kY65PmcmQ5KL/8=; b=Lcu/t+CU1cUgx9fb2sw8sEhwD9
	79mvfygtHI3OWNN3umoXLSwKxZ4zrtPajy7DgPSseqYOhmYO9EZ9KmciY3QHB5TZFpb6h4RW0Oc3N
	/E2Xll/yFJsBRf3k5bKdJlqqz+aX8Yw16fBPOmEsJlzKe+9aTZ68AL0QPoOqck9u+IjGyJTQUlY6A
	ZqMW9vkLXKDa5SuPCguyCyxbA3oEWbCkGEO0Aj5762UTMcCzWAzeuk1mml7ozhN62cFi436WIGv89
	TP6WJOSyzhC2JkcznEWB+YklLybwkS7/AVxOkhd1DmLjqhFt4MoJQdF4SHee3RUTv9gz+FwTkFOPX
	oaSRaEng==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFFB-000000013pI-2NNN;
	Sat, 16 Nov 2024 09:37:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 75C55300472; Sat, 16 Nov 2024 10:37:30 +0100 (CET)
Date: Sat, 16 Nov 2024 10:37:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 07/12] objtool: Convert ANNOTATE_INTRA_FUNCTION_CALLS
 to ANNOTATE
Message-ID: <20241116093730.GJ22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.788965667@infradead.org>
 <20241115184027.64qogefila6oy7qr@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115184027.64qogefila6oy7qr@jpoimboe>

On Fri, Nov 15, 2024 at 10:40:27AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:59:42PM +0100, Peter Zijlstra wrote:
> > +++ b/include/linux/objtool_types.h
> > @@ -63,5 +63,6 @@ struct unwind_hint {
> >  #define ANNOTYPE_INSTR_END		4
> >  #define ANNOTYPE_UNRET_BEGIN		5
> >  #define ANNOTYPE_IGNORE_ALTS		6
> > +#define ANNOTYPE_INTRA_FUNCTION_CALLS	7
> 
> Should be a singular "CALL"?

Sure, one regex on the patch sorted that :-)

