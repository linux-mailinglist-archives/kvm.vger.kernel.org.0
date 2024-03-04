Return-Path: <kvm+bounces-10806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 354248703B0
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9198B26D5A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 14:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0233FB1C;
	Mon,  4 Mar 2024 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XidIWVV0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85F13FB04
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 14:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709561342; cv=none; b=c5Qx7v6atYC1yotvm6+taLHpe8q/qp9qV8Ys4iZxD0XIynDeXMPC1d/49MkPkKBHaREBJ30Z3e+EcAKDfhUyofP+OGV0Z6WFc5/3eRBzfvT9+yZijX25wMYyOWJnBfPZPX/CzEovKxQZ2qQyJw8i9YPJ9rMyh+pv9g0bKegP0FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709561342; c=relaxed/simple;
	bh=rC7WWMVQiACo7gP0bvAUytA1mDVKpCZe39JZm2T7nwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3kDuQXsDashKON+yy5xo/vXDhFg/6/Dl4ju79xTjZTI/1s/VytGl+RXQMkoLrPecE6gpl6esyjpliZY7SDxlPLAhJ+w5bYbj9muy1up1Qcbg7naz2YZ5FqJx56gM55ilwEo30p4RGAmdEHwCmcjjV6/PnQbRz4i7cU1A3fj3Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XidIWVV0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8193DC433C7;
	Mon,  4 Mar 2024 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709561342;
	bh=rC7WWMVQiACo7gP0bvAUytA1mDVKpCZe39JZm2T7nwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XidIWVV0eG1SWWYaUrBifCKTYLWSF/Srgm8UBnreS/RC0kQcxyopv7Bze4a1U66Tl
	 3lIznpcYJ0IPIpUK7QuO/20yYdGgEFsookFkW1gb4nhFLRYyjyKRWfHFCXnRDITM0B
	 jwu9jEFldT/d0//mNOUNhbvseOo5QYYnMjAFml8TPJEUGN7yoxgmkZQgDPTD44bfuQ
	 MQQX6FEvfA2fHcalVCb4c3+iTBwtyJNDM2PquRfhE5iVOWum1G0yOr5uwowm7SJVEZ
	 fmBLs4ISUPrBwnxdYlwEFindL64q1rP38pLSemDkkK81LLHG42AwEtinV7i03JEgf+
	 ymD9a92K4OzaQ==
Date: Mon, 4 Mar 2024 14:08:58 +0000
From: Will Deacon <will@kernel.org>
To: Sicheng Liu <lsc2001@outlook.com>
Cc: kvm@vger.kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool] x86: Fix bios memory size in e820_setup
Message-ID: <20240304140857.GA20574@willie-the-truck>
References: <SY6P282MB3733A7DAEFD362632DAF4897A3572@SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY6P282MB3733A7DAEFD362632DAF4897A3572@SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 21, 2024 at 05:28:43AM +0000, Sicheng Liu wrote:
> The memory region of MB_BIOS is [MB_BIOS_BEGIN, MB_BIOS_END],
> so its memory size should be MB_BIOS_END - MB_BIOS_BEGIN + 1.
> 
> Signed-off-by: Sicheng Liu <lsc2001@outlook.com>
> ---
>  x86/bios.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/bios.c b/x86/bios.c
> index 5ac9e24ae0a8..380e0aba7129 100644
> --- a/x86/bios.c
> +++ b/x86/bios.c
> @@ -75,7 +75,7 @@ static void e820_setup(struct kvm *kvm)
>  	};
>  	mem_map[i++]	= (struct e820entry) {
>  		.addr		= MB_BIOS_BEGIN,
> -		.size		= MB_BIOS_END - MB_BIOS_BEGIN,
> +		.size		= MB_BIOS_END - MB_BIOS_BEGIN + 1,

Use MB_BIOS_SIZE for this?

Even with that, there are a whole bunch of suspicious-looking memset()s
in setup_bios() that probably need similar treatment.

Will

