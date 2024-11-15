Return-Path: <kvm+bounces-31956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 979E29CF448
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80008B3DF23
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285A51DDC03;
	Fri, 15 Nov 2024 18:40:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EE61CF7A2;
	Fri, 15 Nov 2024 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696010; cv=none; b=fNnnshRkA3XElafdyPEc3W8Jm71naFdaIZ5ea1uXNCGreCCMbZ40uyKRpACH5CWhvos8SnlX5lnRf9Y6YvUOE8L/PyhkGMfMJp9lRdo1g9WE5xs9VP5qQ6cAXIxVL5c7XzAT3p0mQV4UTaUvzD4FCOnobtWZ9zJ+c1mVjV/5SV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696010; c=relaxed/simple;
	bh=z6EZwOdv6JdKGNuEf5ul7jD11W4CLfTqh1/pw3h8hng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEGSKF2reE8zoEPU8MhMlmIaNqRbH2j7qsMPX3P4b4YWJu/wM+ipb+cK/PaQ0fm0XxnTkYZLj8FOqTqjLcBhMIvwv8QPrJfc9HdBE2SKmNLjr10uEauaUYVK8hB1Wl5q86AUXtA+04Lwx5R69V4NV3/AC6TYh+Ixd4VFutV+nFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D906DC4CECF;
	Fri, 15 Nov 2024 18:40:09 +0000 (UTC)
Date: Fri, 15 Nov 2024 10:40:08 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 04/12] objtool: Convert instrumentation_{begin,end}()
 to ANNOTATE
Message-ID: <20241115184008.ek774neoqkvczxz4@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.469665219@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111125218.469665219@infradead.org>

On Mon, Nov 11, 2024 at 12:59:39PM +0100, Peter Zijlstra wrote:
> +++ b/include/linux/objtool.h
> @@ -51,13 +51,16 @@
>  	".long 998b\n\t"						\
>  	".popsection\n\t"
>  
> -#define ASM_ANNOTATE(x)						\
> -	"911:\n\t"						\
> +#define __ASM_ANNOTATE(s, x)					\
>  	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> -	".long 911b - .\n\t"					\
> +	".long " __stringify(s) "b - .\n\t"			\

It would probably be better for __ASM_ANNOTATE's callers to pass in the
full label name (e.g. '911b') since they know where the label is?  It
could even be a named label.

-- 
Josh

