Return-Path: <kvm+bounces-18664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD9C8D8510
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 264B228624A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B3512FB15;
	Mon,  3 Jun 2024 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fg49YqSE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812CF57C9A;
	Mon,  3 Jun 2024 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425036; cv=none; b=jSTHXD7MwNTQF7k5dlOAT5LFiEo78WNGkeN8zE1s17oF3ECGYw7kFMxnSxjB/XB2+SoNHsF3XOhlvFgQ5U8Wzg4AGfIQ+J6vqRctqS4ZkNFiNbeiVpLy5ARyEcqIKyYCXtO/+58tIzRlUZ2dVbQXMYYNpWmONK+QOnr6Sqhj9NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425036; c=relaxed/simple;
	bh=zew+uG4r68QwYLUFKAKzwIzu32pc5sfFcOmdOWTc4V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JR5/tmW101azAnLdj9tSMrMUcRSHXCpis0b4lhFhCvZ24DSB4KqOeQ55lD1V1NlkNyOv04X1GMFTe3JpM7MX+TEAqhFKguB0AqDDZ+mXVK/AgKY0s4YQomk4Sq7zFX/NJAl1OxX4yU8EqDozr/H9cZyZGv6aZwqsWcOVumjqgvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fg49YqSE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6214AC4AF09;
	Mon,  3 Jun 2024 14:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425036;
	bh=zew+uG4r68QwYLUFKAKzwIzu32pc5sfFcOmdOWTc4V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fg49YqSESADLCHTZ8owxyuJbUfacYZM3r8mgmhN8iWK80vEK48+LWPLhqnBDJekrv
	 NvNtSSfeDBOSsKqdNIU4kJdtC2pTX2z+PYNzzkK/UwF3AXlTdD9PAmROp8EC5nJUMG
	 TUsh6ruqRtWpD6ECVJLujfnNAuTJl/iVhf1uEwqiEINIWbGejej7Ft/O+arqXaQwD3
	 Px4AZYeQj9veYg5u712HacUI//gJG0acajSga3m1HELZhp/DhuKrbgVPaOG7G87jll
	 rh22LBxo/Y7DEILknNRpDSK+BZSvat0BomoClfcWgChgE9EkPyqlkVNb+63esoLjb5
	 EDbw6l75Cxs+w==
Date: Mon, 3 Jun 2024 15:30:30 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 03/13] KVM: arm64: nVHE: Simplify __guest_exit_panic
 path
Message-ID: <20240603143030.GD19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-4-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-4-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:09PM +0100, Pierre-Clément Tosi wrote:
> In invalid_host_el2_vect (i.e. EL2{t,h} handlers in nVHE guest context),

*guest* context? Are you sure?

> remove the duplicate vCPU context check that __guest_exit_panic also
> performs, allowing an unconditional branch to it.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 135cfb294ee5..71fb311b4c0e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -197,18 +197,13 @@ SYM_FUNC_END(__host_hvc)
>  	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
>  	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
>  
> -	/* If a guest is loaded, panic out of it. */
> -	stp	x0, x1, [sp, #-16]!
> -	get_loaded_vcpu x0, x1
> -	cbnz	x0, __guest_exit_panic
> -	add	sp, sp, #16

I think this is actually dead code and we should just remove it. AFAICT,
invalid_host_el2_vect is only used for the host vectors and the loaded
vCPU will always be NULL, so this is pointless. set_loaded_vcpu() is
only called by the low-level guest entry/exit code and with the guest
EL2 vectors installed.

> -
>  	/*
>  	 * The panic may not be clean if the exception is taken before the host
>  	 * context has been saved by __host_exit or after the hyp context has
>  	 * been partially clobbered by __host_enter.
>  	 */
> -	b	hyp_panic
> +	stp	x0, x1, [sp, #-16]!
> +	b	__guest_exit_panic

In which case, this should just be:

	add	sp, sp, #16
	b	hyp_panic

Did I miss something?

Will

