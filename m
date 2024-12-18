Return-Path: <kvm+bounces-34041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D889F6275
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 11:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64E8116CD50
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 10:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A02619755B;
	Wed, 18 Dec 2024 10:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r7yjB8hB"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548E18CC0B
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 10:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734516824; cv=none; b=Wy58g+lqJSF575AT9/jl9P6wQInOusCFegZ7zp9/Qju2XJBxCYAuPDICFWJwY+btC0NoKWhb/oOyE2t933KO1ZBt09tyhdIvZcYgQ0eNzOVU35Ee8qE/wYCY1i2dzWzT8KouTVaWuYNl35Ab2otbY0HoItunuFOoyBnWWw285cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734516824; c=relaxed/simple;
	bh=ruwETCgGr1HK0aQBaEDjqXsWNsHBavmfSpgWmZA9Wo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eb42bmJDxa4puw+gr1k/bY0QuBkZGcJjxPh/HM9nVisd2ketffvHahBYnFc1oLL3hS6ePFNtMsQy5rrxJo9E0Peh0Rtr2xlL7VY/Uhhvoexpy/jSarU/58AIETKzXw80ATlUFTLl+79d/WAnd0YaONi0TjZi8vlyrCErQMNl25w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r7yjB8hB; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Dec 2024 11:13:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734516820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OveAGhn86eJdz/Spx4SXPWRtOVC+MXVXDzm1h+uRiOk=;
	b=r7yjB8hBMf0jo5MPCtjS7m4yEObclGK866BAf46NHuBKwyh9kb6YDw4QBhLLVZxZNrSY5O
	rgdk8Io+PgkOtonh/ltZApyc18gUt7LWQepvWDpzN6Uqb/sJFVWlK6y3ukMouvAniw97ux
	6SM+09jPyJSCjy+AWFMdbaMGponqTqk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/3] riscv: Add Image header to flat
 binaries
Message-ID: <20241218-d2753dad681a37b3b15c7c75@orel>
References: <20241210044442.91736-1-samuel.holland@sifive.com>
 <20241210044442.91736-2-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210044442.91736-2-samuel.holland@sifive.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 09, 2024 at 10:44:40PM -0600, Samuel Holland wrote:
> This allows flat binaries to be understood by U-Boot's booti command and
> its PXE boot flow.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
>  riscv/cstart.S | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/riscv/cstart.S b/riscv/cstart.S
> index b7ee9b9c..106737a1 100644
> --- a/riscv/cstart.S
> +++ b/riscv/cstart.S
> @@ -39,15 +39,29 @@
>   * The hartid of the current core is in a0
>   * The address of the devicetree is in a1
>   *
> - * See Linux kernel doc Documentation/riscv/boot.rst
> + * See Linux kernel doc Documentation/arch/riscv/boot.rst and
> + * Documentation/arch/riscv/boot-image-header.rst
>   */
>  .global start
>  start:
> +	j	1f
> +	.balign	8
> +	.dword	0				// text offset

When I added a header like this for the bpi I needed the text offset to be
0x200000, like Linux has it.  Did you do something to avoid that?

> +	.dword	stacktop - ImageBase		// image size
> +	.dword	0				// flags
> +	.word	(0 << 16 | 2 << 0)		// version
> +	.word	0				// res1
> +	.dword	0				// res2
> +	.ascii	"RISCV\0\0\0"			// magic
> +	.ascii	"RSC\x05"			// magic2
> +	.word	0				// res3
> +
>  	/*
>  	 * Stash the hartid in scratch and shift the dtb address into a0.
>  	 * thread_info_init() will later promote scratch to point at thread
>  	 * local storage.
>  	 */
> +1:
>  	csrw	CSR_SSCRATCH, a0
>  	mv	a0, a1
>  
> -- 
> 2.39.3 (Apple Git-146)
>

Thanks,
drew

