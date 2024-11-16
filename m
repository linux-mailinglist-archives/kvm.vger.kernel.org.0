Return-Path: <kvm+bounces-31981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F479CFD8B
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B45D1F25106
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 09:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF86194A52;
	Sat, 16 Nov 2024 09:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZKSQTSIe"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830B01392;
	Sat, 16 Nov 2024 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731749950; cv=none; b=j9M/8qeHVNCEXpP4T+zvOHXUJL/BiBMVfn6fXDqpTWS78uuc7a3uGb7No7sqRcnsLUZ1hbEzcu1P6cISwc6Sk+oaj+IKK6o3hk5qYD+8wbCZ+eHz0D7Uy/MgWaUJgkiqDo0xmutl6W+cWUos6Y4eaT0nNrRFwjZkaXMf+XKD9ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731749950; c=relaxed/simple;
	bh=FCr4DxAfVzysPd8L6nV7hglndfEfN1Hdf7+OMJ7HHB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1IIJwDxIEURk+1Hcnn2VanYfZPISPfpWwte6jqiC87u4lq78tdU84KF3cCEQj4oT5OReIqtL+EDfDEVAVjjzyC3bsjzIivbijGKrVHxIs5w3ywW3XAfORLS1DQYGp3GhtOwXEm8uxfZMSvBDTGDGP8kUEyoeugtw2lInkO84fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZKSQTSIe; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vhr4hbTxt/TE9njajUqvZcixBtDEtjeLgeEZhFMMO5c=; b=ZKSQTSIeruMzwYa6SOz4QMcrH3
	RadhjeO5FxGdv+0mQMc/H5+QiCDzhgbmyzmYuS7jiIBHdlwhCFiJk4gQbV+pRGM0vfZ1YfD6/b2S5
	XzWpQo0W8rbzcp6zUJr7hLvwjys1hvVndwdynJ7zAnwvA6B+DYohJjYemQl+z2r/2U7R3cLyH+w/D
	RxOCrnvFuc/dAhpxaL1cOcQe0bTS8xZmZZs4P/TslPs8kMHBw1ii8ZwnhFmoPhZ6SX/LECE/vBb9O
	Gc0Mq1X5I0YsqpWlkLahZX8mJE3dmBtVERRh+Aq+JN8RfFfstzgVYPLvCjwWs+4N2eBAX26hCK00v
	8IDh6imQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFGg-000000000Wi-2fD4;
	Sat, 16 Nov 2024 09:39:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D6890300472; Sat, 16 Nov 2024 10:39:01 +0100 (CET)
Date: Sat, 16 Nov 2024 10:39:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 10/12] x86,nospec: Simplify {JMP,CALL}_NOSPEC (part 2)
Message-ID: <20241116093901.GK22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125219.140262800@infradead.org>
 <20241115184056.ifkb6rhqpnucjn43@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115184056.ifkb6rhqpnucjn43@jpoimboe>

On Fri, Nov 15, 2024 at 10:40:56AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:59:45PM +0100, Peter Zijlstra wrote:
> > Counterpart to 09d09531a51a ("x86,nospec: Simplify
> > {JMP,CALL}_NOSPEC"), x86_64 will rewrite all this anyway, see
> > apply_retpoline.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/x86/include/asm/nospec-branch.h |   29 +++++++++++------------------
> >  1 file changed, 11 insertions(+), 18 deletions(-)
> > 
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -429,31 +429,24 @@ static inline void call_depth_return_thu
> >  
> >  #ifdef CONFIG_X86_64
> >  
> > +#define __CS_PREFIX						\
> > +	".irp rs,r8,r9,r10,r11,r12,r13,r14,r15\n"		\
> > +	".ifc %V[thunk_target],\\rs\n"				\
> > +	".byte 0x2e\n"						\
> > +	".endif\n"						\
> > +	".endr\n"
> 
> After staring at this for some minutes I'm thinking it would be helpful
> to add a comment saying this is equivalent to
> -mindirect-branch-cs-prefix.

I'll just copy-paste the comment from the other __CS_PREFIX elsewhere in
this file :-)


