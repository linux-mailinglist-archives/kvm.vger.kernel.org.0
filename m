Return-Path: <kvm+bounces-31958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAACA9CF439
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:46:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E6ACB2D3A6
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643F81E1049;
	Fri, 15 Nov 2024 18:40:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EC418FC89;
	Fri, 15 Nov 2024 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696058; cv=none; b=P9gLR8VVGwFbp+orSLX43RKaFXamZ19x0hsSP6vlXPE1Jf0szlGZ7yoPoD4pwwU6luvPvylRESn+Wwr7LFOPQC7kBkC+sDEOymDdNaMNI4pxlP2wSKsGbq0AYhs9rGApaXWZBsFrcEvimf5IuCh8YAI4OBNxey8GeR8CeHnjXYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696058; c=relaxed/simple;
	bh=72FRIa6n+lTg82UQoy2Y9zwxKSSTPfhpZXTVxrTJE3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OaIE/vb29tKJE2mw5DF2R+/Haiw0D4pGQ9rOPsgvLc2aBHti2HKRGBhi8wVPAXe6fzNdZ9PUolQVPx4FHH8vfC4WDUENVWFTkpSaCASZce2DexNj/LEwIm2bpcR2vKP/ql8FWZ9N5iIDnah3LoTQ/XMK80YsZiRxHAMG39ozXKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B4AC4CECF;
	Fri, 15 Nov 2024 18:40:57 +0000 (UTC)
Date: Fri, 15 Nov 2024 10:40:56 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 10/12] x86,nospec: Simplify {JMP,CALL}_NOSPEC (part 2)
Message-ID: <20241115184056.ifkb6rhqpnucjn43@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125219.140262800@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111125219.140262800@infradead.org>

On Mon, Nov 11, 2024 at 12:59:45PM +0100, Peter Zijlstra wrote:
> Counterpart to 09d09531a51a ("x86,nospec: Simplify
> {JMP,CALL}_NOSPEC"), x86_64 will rewrite all this anyway, see
> apply_retpoline.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/include/asm/nospec-branch.h |   29 +++++++++++------------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
> 
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -429,31 +429,24 @@ static inline void call_depth_return_thu
>  
>  #ifdef CONFIG_X86_64
>  
> +#define __CS_PREFIX						\
> +	".irp rs,r8,r9,r10,r11,r12,r13,r14,r15\n"		\
> +	".ifc %V[thunk_target],\\rs\n"				\
> +	".byte 0x2e\n"						\
> +	".endif\n"						\
> +	".endr\n"

After staring at this for some minutes I'm thinking it would be helpful
to add a comment saying this is equivalent to
-mindirect-branch-cs-prefix.

-- 
Josh

