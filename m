Return-Path: <kvm+bounces-18932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B61CD8FD262
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C7F8B26709
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5526155A25;
	Wed,  5 Jun 2024 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7MO2dbJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182BC14AD2D;
	Wed,  5 Jun 2024 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603382; cv=none; b=PDWVfNbFWEAVkgOeYyikGydESsdoQxnJZFwAzqwzUu+nM2VCdL5qKOD9QVW+cztQnqjf/O6rfj/Pk0ZBn0QRPTg/ydIzKzKQKOiFyiMJJAxzcLnd4MXxWy2NEx32QYg7UFeogfvHl4wXdLHmszW/Blnr1D8920jEq+xaOc2eg2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603382; c=relaxed/simple;
	bh=5PGKLYGBYfyqSWcJBCPurIVx/TWoCyZIYimjVoqwxgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LHs5zLCb55JWcYT7Zlq+QuqGH41ZKYjj5b6ImbM1QuD716Y45Tmd99rX1Wi8/gY+zAqSgGFNDPnNxc6oGr0tQrWrM2EBq0isenpE+JRLDMk/486U9nUMyOQwqXxhDXLHTejokXY5FsKZW0DD6QlEzE1j/zT3B0kWBbGwb1l9D3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7MO2dbJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44C9C3277B;
	Wed,  5 Jun 2024 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717603381;
	bh=5PGKLYGBYfyqSWcJBCPurIVx/TWoCyZIYimjVoqwxgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O7MO2dbJ2mQOIeJzqM5LSuqmK2Zhqjy8Po9lWoXno6+uKhGuxeuVj43hSOhOctoNn
	 cn94s1lbEJyaaA92NBO4qgzHRpeM9QpJiRHI+1C4QDPVNvDb1L05cMpMxqS1YBl1Rv
	 ve7cWPHQo8VzdQHSxr1a9Q3zjlh8ttnwGbjeIDfFkyp9Jfv+VnE8X9Jk5uVCWEex7q
	 nvefAybgSjPxgt4gHZ0lNBF99zv3mr2q1y4hrEBqXBsQU5lOPuaTMcrUG5zMTm6Soy
	 2PBgRKXrAsYyBF7c5ONohrMcK3Pfsg0F4sxRiR4+PBGAR08xt0SxwBrT2f4KjcwFHS
	 OZ+aK+FTmPALg==
Date: Wed, 5 Jun 2024 17:02:56 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 03/13] KVM: arm64: nVHE: Simplify __guest_exit_panic
 path
Message-ID: <20240605160256.GA22199@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-4-ptosi@google.com>
 <20240603143030.GD19151@willie-the-truck>
 <qob5gnca2nte4ggkrnn4uil5mfbkz3p55lmk3egpxstnumixfr@lq7xomrhf6za>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <qob5gnca2nte4ggkrnn4uil5mfbkz3p55lmk3egpxstnumixfr@lq7xomrhf6za>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 04, 2024 at 04:48:02PM +0100, Pierre-Clément Tosi wrote:
> On Mon, Jun 03, 2024 at 03:30:30PM +0100, Will Deacon wrote:
> > On Wed, May 29, 2024 at 01:12:09PM +0100, Pierre-Clément Tosi wrote:
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > > index 135cfb294ee5..71fb311b4c0e 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > > @@ -197,18 +197,13 @@ SYM_FUNC_END(__host_hvc)
> > >  	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
> > >  	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
> > >  
> > > -	/* If a guest is loaded, panic out of it. */
> > > -	stp	x0, x1, [sp, #-16]!
> > > -	get_loaded_vcpu x0, x1
> > > -	cbnz	x0, __guest_exit_panic
> > > -	add	sp, sp, #16
> > 
> > I think this is actually dead code and we should just remove it. AFAICT,
> > invalid_host_el2_vect is only used for the host vectors and the loaded
> > vCPU will always be NULL, so this is pointless. set_loaded_vcpu() is
> > only called by the low-level guest entry/exit code and with the guest
> > EL2 vectors installed.
> 
> This is correct.
> 
> > > -
> > >  	/*
> > >  	 * The panic may not be clean if the exception is taken before the host
> > >  	 * context has been saved by __host_exit or after the hyp context has
> > >  	 * been partially clobbered by __host_enter.
> > >  	 */
> > > -	b	hyp_panic
> > > +	stp	x0, x1, [sp, #-16]!
> > > +	b	__guest_exit_panic
> > 
> > In which case, this should just be:
> > 
> > 	add	sp, sp, #16
> > 	b	hyp_panic
> > 
> > Did I miss something?
> 
> Jumping to hyp_panic directly makes sense.
> 
> However, this patch keeps jumping to __guest_exit_panic() to prepare for the
> kCFI changes as having a single point where all handlers (from various vectors)
> panicking from assembly end up before branching to C turns out to be very
> convenient for hooking in the kCFI handler (e.g.  when saving the registers, to
> be parsed from C). I also didn't want to modify the same code twice in the
> series and found it easier to limit the scope of this commit to a minimum by
> following the existing code and keeping the same branch target.
> 
> With this in mind, please confirm if you still prefer this fix to jump to
> hyp_panic directly (knowing the branch will be modified again in the series).

I think having a patch which removes the dead code and has the
unconditional branch to hyp_panic is the best thing here. It might
change later on in the series, but it's a sensible patch on its own and,
with assembly, I think having small incremental changes is the best
option.

> Also, I don't get why the 'add sp, sp, #16' is needed; what is it undoing?

Oh, sorry, I missed that you'd dropped the stp earlier on. So the SP doesn't
need any adjusting and we can just branch to hyp_panic after the overflow
check.

Will

