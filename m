Return-Path: <kvm+bounces-31979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B909CFD87
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07F64286BDA
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 09:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BFE194A65;
	Sat, 16 Nov 2024 09:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XGr2jpv5"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6E62F29;
	Sat, 16 Nov 2024 09:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731749790; cv=none; b=G3dQVLJPlrGh7rubxjWb/mKJS1L21lrsu26kx7hIj7tKr4ktCjtKFj6KfLNXZH8QQpSK4YhhixZ1s+/xqdig8Iu3AmOTaAe7tGTOeLy6pOfimePxEO/yQFiSUhux2Q+CilR4WUhSeYJQ4tge6127xRHOqPbsF2AlJdyBUEPhgss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731749790; c=relaxed/simple;
	bh=STXSn3Muxq1hvovbapzvh21eOh2EnUwm56v2TVDxTiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q01raDvGwhfMPrb5UVYEOW1tYtiWBrdO1wbNarUgepNlb3ABNRXWSBTR8DWRYCKsg/2EyQtYESYmuOvqgVX+zdXFzh4jFa5u2gjeQCiL10C4C0IIiGKXdHNXqg5Qe3Brj/rOzLvnvvi4mOX8DTut50aQekQM+LIjWhHoY+hQ4qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XGr2jpv5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oSj/ojonZ6pird9UUpievPRkX20A/AckWetgx5kgx2A=; b=XGr2jpv57Cj8N6r13kvVdjgWkr
	21P1PO5MwZvs4kaOxW9bB3uB8B/5oubG99FgjXUcawlTAHkWrx5iB+hNJn+3Iz3kp34rY5iqISxnC
	UiVByP5uIDm2ShGtFn3DtxCl7cp5KLQ2O29kyTWmZ78HhBWnjuUdjm6zoQyQJcKRhCy0EkHF2E1in
	sD1iO3r8TR8khQnWjj7JMXOqaFLanv8KT/AijqThWXW09HVG/WiyPUcTLipIHcAOFr7q5e0L4N0iI
	QTjlzeAHK+jYhZATt0i9x5YE09uhYn3vEi0yFkjzkAvQHkx9wu9LBZSmeRXN1LrIla/v9zVHWvDEH
	jjEVa75Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFEA-000000013nJ-0Tc3;
	Sat, 16 Nov 2024 09:36:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 03713300472; Sat, 16 Nov 2024 10:36:27 +0100 (CET)
Date: Sat, 16 Nov 2024 10:36:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 04/12] objtool: Convert instrumentation_{begin,end}()
 to ANNOTATE
Message-ID: <20241116093626.GI22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.469665219@infradead.org>
 <20241115184008.ek774neoqkvczxz4@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115184008.ek774neoqkvczxz4@jpoimboe>

On Fri, Nov 15, 2024 at 10:40:08AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:59:39PM +0100, Peter Zijlstra wrote:
> > +++ b/include/linux/objtool.h
> > @@ -51,13 +51,16 @@
> >  	".long 998b\n\t"						\
> >  	".popsection\n\t"
> >  
> > -#define ASM_ANNOTATE(x)						\
> > -	"911:\n\t"						\
> > +#define __ASM_ANNOTATE(s, x)					\
> >  	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > -	".long 911b - .\n\t"					\
> > +	".long " __stringify(s) "b - .\n\t"			\
> 
> It would probably be better for __ASM_ANNOTATE's callers to pass in the
> full label name (e.g. '911b') since they know where the label is?  It
> could even be a named label.

I have this somewhere later, changing it here would be a pain because
the existing annotations dont do it like that.

