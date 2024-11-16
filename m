Return-Path: <kvm+bounces-31982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FF29CFD8D
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82ACE1F23365
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 09:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D77194A65;
	Sat, 16 Nov 2024 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NnR6LguU"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A8D1392;
	Sat, 16 Nov 2024 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731749999; cv=none; b=l31HbbC/FiIAyJkyHlZNyuXKQx3v6LSaLGaEiZGOqdflRkNykFFXCvs6lVWn3deXVEilu3jQJTj4MBolOdTik1M782HFkvY0dTQww6yWW9wMu9JZdB8txGDGAsxpWkOLKYOUGS4BqV9dN69RHeoWrqT4GgcowcgDB0EZSh/+IqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731749999; c=relaxed/simple;
	bh=eeptnfSu1LA3dmzHDH2oLI1T9n+usxfxgrSJAuj84/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQaUONye3/cOfzpl9YNMTXzAysqn8VTuDxNq1ndMqWdoiaaAAhd05bRPGKTm2tfm1fg48X9ULnpcPiitM8yx8FxiCoUnSMZu66l0y8tohcbtGpyWhko05tDfY87uwAwSA0NHkV0bsR2gS2cbX1yobf0L2zCqnMBrQ5RjOE02n1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NnR6LguU; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mcRZXl/O5v+pVv4FpHegNRcqCoXz7a8z20QoL6PJOLk=; b=NnR6LguUx7auQzWUxs0pz6Vfzi
	RVgb/dOSjwU2sd/neTqO4h8zg4xD7+EggEH/2pL3tZp6ydDjiZbKDBUJIFzX4Oq8GTYKW6hlIVCWA
	o+PdP0lEE6f84vMrCsJ+YA2vyWFr8Rld3ePClyjGKfce3uSyljrYvi9jpKG7M559KfChLYAuIVtiO
	4IzYaBtE5C/3jn6zGvtCYpSuJuMfrSyd1dv5/75iwO538Rf5cu4P7mduNeVcEimYy377Hki3Nhq9s
	dk2qZ9Alyx0CkJUiA6ybv+wRX1s6yLOhZbm0h7IchMrphciaN4OR7tNmGpWtRbBh8OEDoSPw/XKVh
	F3ESW9Bw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFHX-000000000Wy-0bKw;
	Sat, 16 Nov 2024 09:39:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CA6B9300472; Sat, 16 Nov 2024 10:39:54 +0100 (CET)
Date: Sat, 16 Nov 2024 10:39:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 12/12] x86/kvm/emulate: Avoid RET for fastops
Message-ID: <20241116093954.GL22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125219.361243118@infradead.org>
 <20241115184104.pud5l26v5vx3vcbp@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115184104.pud5l26v5vx3vcbp@jpoimboe>

On Fri, Nov 15, 2024 at 10:41:04AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:59:47PM +0100, Peter Zijlstra wrote:
> > Since there is only a single fastop() function, convert the FASTOP
> > stuff from CALL_NOSPEC+RET to JMP_NOSPEC+JMP, avoiding the return
> > thunks and all that jazz.
> > 
> > Specifically FASTOPs rely on the return thunk to preserve EFLAGS,
> > which not all of them can trivially do (call depth tracing suffers
> > here).
> > 
> > Objtool strenuously complains about this:
> > 
> >  - indirect call without a .rodata, fails to determine JUMP_TABLE,
> >    annotate
> >  - fastop functions fall through, exception
> >  - unreachable instruction after fastop_return, save/restore
> 
> This wording makes it sound like this patch triggers objtool warnings,
> which I'm guessing is not true?

Right, no, it did without the fixups. This was a (poorly worder) attempt
at explaining the reasons for the various annotations in the patch.

