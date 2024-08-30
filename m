Return-Path: <kvm+bounces-25494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52267965F80
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CDAF289E26
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A81192D73;
	Fri, 30 Aug 2024 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EcEnLh2w"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0833D17E002
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 10:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014549; cv=none; b=HBUmZY9mzs5IbtOkA9ZW6D8wWqmHUJjtbDLcaB9jDm0IX4tiJ3tm4ODTH9/lpz3hSN8nHpZZ4xzVNrWHJAyM7LtItt77UiL8xx/aYmbOf0n7FBYYxuCIz5D2MGX9o0Y/6kJtdzbM7ex31e8sSxapzxBSY7IwMVZGGItx1ByWh2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014549; c=relaxed/simple;
	bh=XwAV9ibpnd5zOwPD8igBpDEf7yL/eZb/BR8ShZrjl2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gu7Q35+jlZYsSgGjNaJRa2mbuz6fYXj6TggkFbptKOfaeS/5hAfTn7RPOq6ZFKZUMkBWeGbl7E+4paIAkt6IV5NtIhWExEiVkMY4gaZ3STRsCkvfAoDm9D0fr51t3GWUZHqfBnomqn7HMxgD5eu/Va8FU6zyckvNKb9ZChTaEPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EcEnLh2w; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 Aug 2024 12:42:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725014545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XR2j7KeW9SLWBPdUicmkQIUSh+P47ib8tWnCIwSZqiY=;
	b=EcEnLh2w4g3LExme9swRfSJkvDc7ukiA/KHgiHcnFg/lSqr2grYrqg27I2VSk9BdGiVWo0
	AB2LxqrnlQO7G1pckPCge6nSWwLOwXXlse93XaJ+m2EEiVpkrYUJDYXfkfv0SXIJbfNtPj
	kG9uK/fMOB5dECjoaw6MOgzJjPgNmdo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH] riscv: Fix argc
Message-ID: <20240830-929e0ec699dd16d146481c6b@orel>
References: <20240830102007.2206384-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830102007.2206384-2-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 30, 2024 at 12:20:08PM GMT, Andrew Jones wrote:
> __argc is 32 bits so even rv64 should load it with lw, not just rv32.
> This fixes odd behavior such as getting false when testing argc < 2
> even though we know argc should be 1. argc < 2 being false comes from
> the register comparison using the full register width and the upper
> 32 bits being loaded with junk.
> 
> Fixes: bd744d465910 ("riscv: Initial port, hello world")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/cstart.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/riscv/cstart.S b/riscv/cstart.S
> index d5d8ad253748..a9ac72df4dd2 100644
> --- a/riscv/cstart.S
> +++ b/riscv/cstart.S
> @@ -93,7 +93,7 @@ start:
>  
>  	/* run the test */
>  	la	a0, __argc
> -	REG_L	a0, 0(a0)
> +	lw	a0, 0(a0)
>  	la	a1, __argv
>  	la	a2, __environ
>  	call	main
> -- 
> 2.45.2

Merged.

Thanks,
drew

