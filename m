Return-Path: <kvm+bounces-68825-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGkcOEticWkHGgAAu9opvQ
	(envelope-from <kvm+bounces-68825-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 00:33:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 90EBC5F90D
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 00:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3C3F348A136
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4747D45BD66;
	Wed, 21 Jan 2026 23:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5QIBB47"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A16635A923;
	Wed, 21 Jan 2026 23:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769038331; cv=none; b=ar7Rv+bs/WaD+drXoSGKndPQW+zAjpPBbflYALbXXMy97MpDSuUpciU/XUJNlysIIqzTykwWXEJ2jFpguQhAdquYJ336ocntfqz5Xoaec8d2+8Z+SumviZvZTGy187yRPnA4UO4asUYoSn0IdyfWolMLXMXSMU1ljYEmlPvuP7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769038331; c=relaxed/simple;
	bh=nkvchCcqQhAAmS8zGkyfFLYiFbzKmdwcZy36WJKOnTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1pqJ7qU0Vuuh/zgDLP79JexxINipMsaSyuPr9aQuE9IsDjfNkokJSe2Ccf5zOS/3Fa1t80pIaXuYmaPoPmu+pqv5DEbuLwGGlj2ztkGIxBIU7enO6Gl1nD/aOkzhPl6Ad+y2RQ2BD/pkyXaupB2H78Fu16+6yU2L5SwLLnb7LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5QIBB47; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8A6C4CEF1;
	Wed, 21 Jan 2026 23:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769038329;
	bh=nkvchCcqQhAAmS8zGkyfFLYiFbzKmdwcZy36WJKOnTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A5QIBB47jUpqq11SfeZHWLtxbdvAc23J4MyRuKt6xZg2GJaG/AV/K+R/V13BJT1PD
	 F/vxCKLlutlfJJ4pWuv0fXK9Og/pGhxYd37c0cAe8wTG/UeSMmxjg2Rkb72TsVeDxk
	 nRILcxpnUhD0kpOc/bNcJ+lBjo9iX+P2JHykg90vTAkZI82b5Fbt1FHjLoJFNiL10Z
	 3RHscnBl/3fwxVJetTPNpnRP8PZk0tbEJyauBYu4+IosVXcnyhmgoHBVZvT9HpvpVM
	 rCHcYOW76iqah73IVuqdqyNTK/R6dMWxc7u6QLAYYGf8h6b5LCW29mktFc4Y+ficZ1
	 JSNgClFkU62Xg==
Date: Wed, 21 Jan 2026 16:32:04 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Message-ID: <20260121233204.GA1507843@ax162>
References: <20251210173024.561160-1-maz@kernel.org>
 <20251210173024.561160-5-maz@kernel.org>
 <20260120211558.GA834868@ax162>
 <86zf67b5oa.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zf67b5oa.wl-maz@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68825-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	R_SPF_SOFTFAIL(0.00)[~all];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nathan@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 90EBC5F90D
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 10:50:45AM +0000, Marc Zyngier wrote:
> Let me guess: Cortex-A72 or similarly ancient ARM-designed CPUs, as
> hinted by the lack of GICv3 TDIR control? Then these do not have
> FEAT_FGT.

Yeah, Cortex-A72 for the one box and an Ampere Altra Q80-26 (which I
believe is Neoverse-N1 cores?), so indeed, no FGT it seems.

> The issue stems from the fact that as an optimisation, we skip the
> parsing of the FGT trap table on such hardware, which also results in
> the FGT masks of known bits not being updated. We then compute the
> effective feature map, and discover that the two don't match.
> 
> It was harmless so far, as we were only dealing with RES0 bits, and
> assuming that anything that wasn't a RES0 bit was a stateful bit. With
> the introduction of RES1 handling, we've run out of luck. To be clear,
> that's just a warning, not a functional issue.
> 
> At this point, I don't think the above "optimisation" is worth having.
> This is only done *once*, at boot time, so the gain is extremely
> small. I'd like the checks to be effective irrespective of the HW the
> kernel runs on, which is consistent with what we do for other tables
> describing the architectural state.
> 
> Anyway, I came up with the following hack, which performs the checks,
> but avoid inserting the FGT information in the sysreg xarray if the HW
> doesn't support it, as a memory saving measure. Please let me know if
> that helps (it does on my old boxes).

Works for me as well, no warnings on either box with this patch applied.
If it is useful for a follow up submission:

Tested-by: Nathan Chancellor <nathan@kernel.org>

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 88336336efc9f..fa8fa09de67dc 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2284,9 +2284,6 @@ int __init populate_nv_trap_config(void)
>  	kvm_info("nv: %ld coarse grained trap handlers\n",
>  		 ARRAY_SIZE(encoding_to_cgt));
>  
> -	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> -		goto check_mcb;
> -
>  	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
>  		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
>  		union trap_config tc;
> @@ -2306,6 +2303,15 @@ int __init populate_nv_trap_config(void)
>  			}
>  
>  			tc.val |= fgt->tc.val;
> +
> +			if (!aggregate_fgt(tc)) {
> +				ret = -EINVAL;
> +				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
> +			}
> +
> +			if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +				continue;
> +
>  			prev = xa_store(&sr_forward_xa, enc,
>  					xa_mk_value(tc.val), GFP_KERNEL);
>  
> @@ -2313,11 +2319,6 @@ int __init populate_nv_trap_config(void)
>  				ret = xa_err(prev);
>  				print_nv_trap_error(fgt, "Failed FGT insertion", ret);
>  			}
> -
> -			if (!aggregate_fgt(tc)) {
> -				ret = -EINVAL;
> -				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
> -			}
>  		}
>  	}
>  
> @@ -2333,7 +2334,6 @@ int __init populate_nv_trap_config(void)
>  	kvm_info("nv: %ld fine grained trap handlers\n",
>  		 ARRAY_SIZE(encoding_to_fgt));
>  
> -check_mcb:
>  	for (int id = __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITIONS__; id++) {
>  		const enum cgt_group_id *cgids;
>  
> 
> -- 
> Without deviation from the norm, progress is not possible.

