Return-Path: <kvm+bounces-31983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 580B59CFDA9
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 052E51F25903
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 09:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991DB195390;
	Sat, 16 Nov 2024 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q5NABSZw"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DE4191F67;
	Sat, 16 Nov 2024 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731750718; cv=none; b=Odl3CSSnf59YJIVlFNXtPL/7EprCaZWoZS5aK+F1WNiZZxfhT63bjslNhPHipcDJTFD4PAFGmbjKr4TRs0EpHckkq3f7TYHZfND0/p/BmtZO3MrwkW7NJTpLcTXsVap3cNksOM7V5SaOiLbELXPK1nwU+nMkhbXcuQuqu5rEsR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731750718; c=relaxed/simple;
	bh=zVCc939sk04A1yJMA7UBNYAOKlV8gQZiicq0DCfOEjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVuZvyRI+0tY/N0+a433ARSsRjZ/3H9QcJjq9ZFeiL7yjMSO0q67yam+kmiR23geeQE81Z41nEXqyYzklhf3r3z5Ey1Hx1S/tqzI3ZsMnbMa1ejqqSkGSoMeJXZQPJUIIIi7L4i+2JJsoDRztX3GLdNbtEq6e1g6wGbUvzRaoVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q5NABSZw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O5nB4+sLM9LLKuWB/wxba1ZJuYJOkIcKppUHsoTYmLc=; b=q5NABSZw+xfQ/FtoORaxsdgb22
	Rw3NyFgLpuml8xRFrZtiBAqRH1nHilpk4t4xNQXotFsUtr1TSLdW6n+8wNUDcGuOY4+F7NXE+Zz8x
	Zz+kFbE1LinJ1hdy3qCPsMS2Rhd9jFwowxW5WfAY8kZ9Y7uiY8R0bPmnfor8MAt4IGnwQLrcpmyfH
	I1P2wa+7mkswEDK5lV95pKRuf+hADq3oEEwFM0QcXcb4bG7QAYhQC5T+Ae1XKFvHaIT1ctLVfSZ6q
	5q/hwwRbtAvd6I49LJguiU0GdjekQ6sjuW+mK+wQH/6ataproR5XjVoQAlpOBOaftLc7jtAPMs6HV
	imJlXJpQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFT7-000000000cI-0yfp;
	Sat, 16 Nov 2024 09:51:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D3111300472; Sat, 16 Nov 2024 10:51:52 +0100 (CET)
Date: Sat, 16 Nov 2024 10:51:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 04/12] objtool: Convert instrumentation_{begin,end}()
 to ANNOTATE
Message-ID: <20241116095152.GM22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.469665219@infradead.org>
 <20241115184008.ek774neoqkvczxz4@jpoimboe>
 <20241116093626.GI22801@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241116093626.GI22801@noisy.programming.kicks-ass.net>

On Sat, Nov 16, 2024 at 10:36:26AM +0100, Peter Zijlstra wrote:
> On Fri, Nov 15, 2024 at 10:40:08AM -0800, Josh Poimboeuf wrote:
> > On Mon, Nov 11, 2024 at 12:59:39PM +0100, Peter Zijlstra wrote:
> > > +++ b/include/linux/objtool.h
> > > @@ -51,13 +51,16 @@
> > >  	".long 998b\n\t"						\
> > >  	".popsection\n\t"
> > >  
> > > -#define ASM_ANNOTATE(x)						\
> > > -	"911:\n\t"						\
> > > +#define __ASM_ANNOTATE(s, x)					\
> > >  	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > > -	".long 911b - .\n\t"					\
> > > +	".long " __stringify(s) "b - .\n\t"			\
> > 
> > It would probably be better for __ASM_ANNOTATE's callers to pass in the
> > full label name (e.g. '911b') since they know where the label is?  It
> > could even be a named label.
> 
> I have this somewhere later, changing it here would be a pain because
> the existing annotations dont do it like that.

Reading is hard, yes let me do what you said.

