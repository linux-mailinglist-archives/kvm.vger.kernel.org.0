Return-Path: <kvm+bounces-31955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C7B9CF460
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:54:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CA82B36056
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5B61E0E0A;
	Fri, 15 Nov 2024 18:39:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBDA1D9663;
	Fri, 15 Nov 2024 18:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695978; cv=none; b=ZLVeu9YAt3sZF6NZN9KEfv5u/GwjanLm7qH19tZ5OKVywcNg1L1Rj9Hause3jG5mKKY+oEAHdiK3IBN9tHPC9LjHv4BJG3BOD8atfHCkWDahCpAQOAeJWlse/ZsIHlfHsKf2NpYjCYjIdji3q/LBc+56PSHoAhJ8yxOwyRsX3Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695978; c=relaxed/simple;
	bh=trOpuSigcxG+aPu1gAvHfTCzNFMZEhFJxwPj1NiueLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oU+cF3fpfFjjKvpvrZSLW9uOeT14/fDkgB7NLP5vXvlb8LfTPeXrj50ShxjmQPCCBnWgyiIHFuJYuq2Vx2thrVD75WCj3IdpMqFEVfjfX0bD2Wx/N5a1oqOoobPzS0zAqAy/im9Om+VLpB0zuBNOgLLerJxCd3ZTM1qloktSWXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5532C4CECF;
	Fri, 15 Nov 2024 18:39:37 +0000 (UTC)
Date: Fri, 15 Nov 2024 10:39:36 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 03/12] objtool: Convert ANNOTATE_RETPOLINE_SAFE to
 ANNOTATE
Message-ID: <20241115183936.bbval2orosqrj5ww@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.357848045@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111125218.357848045@infradead.org>

On Mon, Nov 11, 2024 at 12:59:38PM +0100, Peter Zijlstra wrote:
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/include/asm/nospec-branch.h |   13 +-------
>  include/linux/objtool_types.h        |    1 
>  tools/include/linux/objtool_types.h  |    1 
>  tools/objtool/check.c                |   52 ++++++++++++-----------------------
>  4 files changed, 22 insertions(+), 45 deletions(-)
> 
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -193,12 +193,7 @@
>   * objtool the subsequent indirect jump/call is vouched safe for retpoline
>   * builds.
>   */
> -.macro ANNOTATE_RETPOLINE_SAFE
> -.Lhere_\@:
> -	.pushsection .discard.retpoline_safe
> -	.long .Lhere_\@
> -	.popsection
> -.endm
> +#define ANNOTATE_RETPOLINE_SAFE	ANNOTATE type=ANNOTYPE_RETPOLINE_SAFE

I'm thinking it would be nice to put all the ANNOTATE_* definitions
in objtool.h so we can have all the annotations and their descriptions
in one place.

-- 
Josh

