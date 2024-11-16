Return-Path: <kvm+bounces-31978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7901D9CFD85
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15178B25F07
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 09:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A556194AEE;
	Sat, 16 Nov 2024 09:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jzo28U49"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D3D1922F5;
	Sat, 16 Nov 2024 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731749677; cv=none; b=qeveGK7vGVRm26Q3RXRxIQ5lj/xTCDGJScvPs3eH5YmD1uub703W6lxveziGGyACFfSc1Dif0+rw1zDyGZbooaE7WPo4wBQgg+7zN9uaZzWIe8vdSFsCYlO8QJejnqaoAxKlQYtQARCdnHGt87XUYRMAxGY29a472mNdHDa636M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731749677; c=relaxed/simple;
	bh=6G5mguZA75eRb4IFfxjNjS+J/ZLaqpiGJbAs0sq2S2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fef75lD5Y4Z147DIfXxcMfOrkBDZHiHCUsNGlPib4f/eJukKu4prLR8xzvive8+WguoEtudFlCOJFhfAK6tpMUqhWhhnXw6ASjCftwgQVtISO3TJF0x/3ERGLOXD6H3Qspzl5nljRxifvt2cQN+N9b7ibwddU1Pzz+BUpcllsj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jzo28U49; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/5wAdFw9+Rk3jGuRfB4U4f7KrhXwW202ZYBMi5HP+w0=; b=Jzo28U49r6AiOEooYYCbYugjwO
	1kFOcCKsl28KkxtIQcGDwpcyveUDEJxCF+mA9gYCdalRnfb3lwzOuJberhyDRIHebFyb1YE9B0RaJ
	QV1G0Yu//Dz6u3yyCUP2eBZDpJXxpaAa5J5//eNpQkICmsFLnbMFMTx+xpTIoow9kidlv28RZSl9p
	H52zu9CDnz6eUZ3gd7EuqlkFfY0XaPrzNBbH7u2ggyDYmSOB72nLOed1IvVyMdQmzea3ToOtUByMV
	h8EUjzQFD7TXr3T8cE3D7rpn7jPVXEUHIRFW4LEnjOhl8FBwqibY+EmcqmfJqnb7n3eiQqym7X69o
	IxE0JK3Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFCF-000000013iu-2rS3;
	Sat, 16 Nov 2024 09:34:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 93F53300472; Sat, 16 Nov 2024 10:34:28 +0100 (CET)
Date: Sat, 16 Nov 2024 10:34:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 03/12] objtool: Convert ANNOTATE_RETPOLINE_SAFE to
 ANNOTATE
Message-ID: <20241116093428.GH22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.357848045@infradead.org>
 <20241115183936.bbval2orosqrj5ww@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115183936.bbval2orosqrj5ww@jpoimboe>

On Fri, Nov 15, 2024 at 10:39:36AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:59:38PM +0100, Peter Zijlstra wrote:
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/x86/include/asm/nospec-branch.h |   13 +-------
> >  include/linux/objtool_types.h        |    1 
> >  tools/include/linux/objtool_types.h  |    1 
> >  tools/objtool/check.c                |   52 ++++++++++++-----------------------
> >  4 files changed, 22 insertions(+), 45 deletions(-)
> > 
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -193,12 +193,7 @@
> >   * objtool the subsequent indirect jump/call is vouched safe for retpoline
> >   * builds.
> >   */
> > -.macro ANNOTATE_RETPOLINE_SAFE
> > -.Lhere_\@:
> > -	.pushsection .discard.retpoline_safe
> > -	.long .Lhere_\@
> > -	.popsection
> > -.endm
> > +#define ANNOTATE_RETPOLINE_SAFE	ANNOTATE type=ANNOTYPE_RETPOLINE_SAFE
> 
> I'm thinking it would be nice to put all the ANNOTATE_* definitions
> in objtool.h so we can have all the annotations and their descriptions
> in one place.

Probably, but that's going to be somewhat of a pain. Let me do that at
the end and throw it at an allyesconfig or something.

