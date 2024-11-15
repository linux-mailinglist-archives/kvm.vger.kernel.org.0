Return-Path: <kvm+bounces-31959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC20C9CF426
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:41:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 592731F250B0
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716E01E1A23;
	Fri, 15 Nov 2024 18:41:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83771CEE8D;
	Fri, 15 Nov 2024 18:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696066; cv=none; b=gOiyBsEp3+aDXzMg8HajnMu2JYuCy0Z8Nnz/EZ/ZxQcEvufxEDV/J6IQqDsRPcIIls9eM/PGXQ/4Imypu02fm9A54TnhqNFBNss8iHbqv+jk6Vsr7CX0ByLAqRDIBcFI59cPUlJP7AqXTy20MneA3tOpZMsR8Zl0bXMWFMdNbWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696066; c=relaxed/simple;
	bh=4tgsxuFm6ktU7HANM+GP+hPQ12KJXMi0kJAK1+P1hGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EV81OXmnhXjZf6lshquc5sYjC5W65h49lqA7D0hGyap/t4WZwjW8Q+dUBEj1PR925IM+T3HhX+Y+y9Sm3qPrdqF8nKLZA07hRR0BejMuStKBM3UAXdSad+cTtd3AIJaVP1+ioTfscj/aiYE35hNYQDKlhyDqquJDbs/cxs+lcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34489C4CED0;
	Fri, 15 Nov 2024 18:41:06 +0000 (UTC)
Date: Fri, 15 Nov 2024 10:41:04 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 12/12] x86/kvm/emulate: Avoid RET for fastops
Message-ID: <20241115184104.pud5l26v5vx3vcbp@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125219.361243118@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111125219.361243118@infradead.org>

On Mon, Nov 11, 2024 at 12:59:47PM +0100, Peter Zijlstra wrote:
> Since there is only a single fastop() function, convert the FASTOP
> stuff from CALL_NOSPEC+RET to JMP_NOSPEC+JMP, avoiding the return
> thunks and all that jazz.
> 
> Specifically FASTOPs rely on the return thunk to preserve EFLAGS,
> which not all of them can trivially do (call depth tracing suffers
> here).
> 
> Objtool strenuously complains about this:
> 
>  - indirect call without a .rodata, fails to determine JUMP_TABLE,
>    annotate
>  - fastop functions fall through, exception
>  - unreachable instruction after fastop_return, save/restore

This wording makes it sound like this patch triggers objtool warnings,
which I'm guessing is not true?

-- 
Josh

