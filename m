Return-Path: <kvm+bounces-18145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C21D8CEA34
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 21:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32C531C20FA3
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 19:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25685381C6;
	Fri, 24 May 2024 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jit+t6H7"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E245942ABD
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 19:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716577930; cv=none; b=OdXawUWpzFALcsiJQ9smF42JP06YR6m4fAVoyy4F+lruOgpQ1LvrtSbKzOPhwywZRxfvwGa8HhB3oko7L1dnR7eO9iWiIlm3JqOiae/hXHAlNI/AygVG0o6iEiYs0BKC/3+PySdVmKRJhCq++8XeFIcmCSNLMYYuFDFv2Jhu1zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716577930; c=relaxed/simple;
	bh=To0OfW8UhNyQzsEaufFFs9KOq/Dr+/1breFnWXwFUxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYZTYepf/+4H85gJaAEB4nK5Fec5T+vSdyjz8gDAWPOvrU17ALbIcpoUTxnIVs6nD6gUORvBT25jhV2Xqr88xt6y//UnZlUu1X0+B+A2xKW8nn2IyabRAReGxf1Woj+m0Fcgj5oh+ZDjEb9sJAwJgyicZyC/pauFpJ+ZZ5L0SYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jit+t6H7; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716577924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aOQPR+PFW3Jz3mG3fzP+mOTdARSvGM3LenEwZaOdVug=;
	b=jit+t6H7r37/KNWwUSPDSkjz9HghvGWPqoxpUComVVA0vEhopRO+L2QLxQIWFljiAo8Gxa
	FoLiXJ8ZxlDgMQTxCGiofZ/iVLySGhXnlzuWIpFsp0BhkRI/mvX3HF0wVfnt3ADnVt81Wr
	GGjNikISz2O18CPcy9BlO5lpmtGJ4Jk=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: nsg@linux.ibm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: stable@vger.kernel.org
Date: Fri, 24 May 2024 12:11:59 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: arm64: Allow AArch32 PSTATE.M to be restored as
 System mode
Message-ID: <ZlDmf6SkfCkEAWtn@linux.dev>
References: <20240524141956.1450304-1-maz@kernel.org>
 <20240524141956.1450304-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524141956.1450304-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, May 24, 2024 at 03:19:55PM +0100, Marc Zyngier wrote:
> It appears that we don't allowed a vcpu to be restored in AArch32

s/allowed/allow/

> System mode, as we *never* included it in the list of valid modes.
> 
> Just add it to the list of allowed modes.
> 
> Fixes: 0d854a60b1d7 ("arm64: KVM: enable initialization of a 32bit vcpu")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/guest.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index d9617b11f7a8..11098eb7eb44 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -251,6 +251,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  		case PSR_AA32_MODE_SVC:
>  		case PSR_AA32_MODE_ABT:
>  		case PSR_AA32_MODE_UND:
> +		case PSR_AA32_MODE_SYS:
>  			if (!vcpu_el1_is_32bit(vcpu))
>  				return -EINVAL;
>  			break;
> -- 
> 2.39.2
> 

