Return-Path: <kvm+bounces-48277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BA4ACC209
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 10:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC5987A5890
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 08:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D23615573F;
	Tue,  3 Jun 2025 08:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t5Cj4ccm"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AD9189F20
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 08:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748938614; cv=none; b=Xsb/pFWQG+Pn/YkkxZmI0VUJyYh6V6o3AMTSdFquIjM95FiBbjIOdqNB/zo5SbhWZXcrDB5mobXnYp/NDjoq7inU+EIMxZZRS1i4GzbMjwwH7CXGt4qj3Uyunkt8SvPnnqxttIiFTj8B0v2AORp+m8eQ3Miazv/5RlEeER13ltM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748938614; c=relaxed/simple;
	bh=zpK8gm0B7ly/1dFxI6m8Hfd8YRGfIsgusLbtlF2ehY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FU+x3cdd1Zk/dl05nG3a5L+QQ8SCeTimhFDIUK5QCTl5TS3SFWbmiX5sBiolQQA4r+hFHzoA5gNzA6jaaUnPcpT99zLNMCpGev5KWwzkIduPuWpl730FByRm3PrLjSqd5S4x7+dNKtETlSx5ohNUbaKM0MqV98p6dQnbGSOiEJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t5Cj4ccm; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Jun 2025 10:16:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748938609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LNu9yHF7auUvXoWOpFS6qTulI5/Yj43ibbQxcPI7DNw=;
	b=t5Cj4ccmuVAlZjMTFw0n9sHOVggbuDWL+eiJ29H2Y4KaBpQa2Q9euqJi5hMAfnLqSbLCdm
	Nkrr3rHBB6FCI9cFe2OeM04bymQzGKM208lLF9tDmXT+nhiE+Jei4Digt1bjzDsnG9GmgK
	KqYs9fOr+Mg7AoFK77XD5P1bUQoy5KU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [PATCH 2/3] lib/riscv: clear SDT when entering exception handling
Message-ID: <20250603-8e4c2aa217e6be3b3ee43972@orel>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
 <20250523075341.1355755-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523075341.1355755-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 23, 2025 at 09:53:09AM +0200, Clément Léger wrote:
> In order to avoid taking double trap once we have entered a trap and
> saved everything, clear SDT at the end of entry. This is not exactly
> required when double trap is disabled (probably most of the time), but
> that's not harmful.

Hmm... I wonder if this shouldn't be left to the handlers. Maybe
we should just provide a couple helpers in processor.h, such as

local_dlbtrp_enable()
local_dlbtrp_disable()

If we do need to manage this at save_context time, then I have
a couple comments below

> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/cstart.S | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/riscv/cstart.S b/riscv/cstart.S
> index 575f929b..a86f97f0 100644
> --- a/riscv/cstart.S
> +++ b/riscv/cstart.S
> @@ -212,14 +212,15 @@ secondary_entry:
>  	REG_S	t6, PT_T6(a0)			// x31
>  	csrr	a1, CSR_SEPC
>  	REG_S	a1, PT_EPC(a0)
> -	csrr	a1, CSR_SSTATUS
> -	REG_S	a1, PT_STATUS(a0)
>  	csrr	a1, CSR_STVAL
>  	REG_S	a1, PT_BADADDR(a0)
>  	csrr	a1, CSR_SCAUSE
>  	REG_S	a1, PT_CAUSE(a0)
>  	REG_L	a1, PT_ORIG_A0(a0)
>  	REG_S	a1, PT_A0(a0)
> +	li t0, 	SR_SDT
          ^    ^ should not be a tab
          ^ should be tabs

SR_SDT isn't defined until the next patch so this breaks compiling at this
point, which could break bisection. You can do a quick check of a series
for this with

 git rebase -i -x 'make' <base>

> +	csrrc 	a1, CSR_SSTATUS, t0
> +	REG_S	a1, PT_STATUS(a0)
>  .endm
>  
>  /*
> @@ -227,6 +228,8 @@ secondary_entry:
>   * Also restores a0.
>   */
>  .macro restore_context
> +	REG_L	a1, PT_STATUS(a0)
> +	csrw	CSR_SSTATUS, a1
>  	REG_L	ra, PT_RA(a0)			// x1
>  	REG_L	sp, PT_SP(a0)			// x2
>  	REG_L	gp, PT_GP(a0)			// x3
> @@ -260,8 +263,6 @@ secondary_entry:
>  	REG_L	t6, PT_T6(a0)			// x31
>  	REG_L	a1, PT_EPC(a0)
>  	csrw	CSR_SEPC, a1
> -	REG_L	a1, PT_STATUS(a0)
> -	csrw	CSR_SSTATUS, a1
>  	REG_L	a1, PT_BADADDR(a0)
>  	csrw	CSR_STVAL, a1
>  	REG_L	a1, PT_CAUSE(a0)
> -- 
> 2.49.0
>

Thanks,
drew

