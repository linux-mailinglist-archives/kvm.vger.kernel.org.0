Return-Path: <kvm+bounces-33101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA129E4B3A
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 01:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67C222830D9
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 00:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916ABDF49;
	Thu,  5 Dec 2024 00:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ncAmXn3N"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069B1C13D
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 00:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733359068; cv=none; b=Kchir5Umw/MfwuSJY+SHkE12wuUXi+oD0qqpkXp0vVb9cwKS+EmWcp7j4hL/U5nO6akar5d+t0LBSMsLMerOYnNuScIS2QOddzeE+qtsTDp9XKzssYP3B0lzWbsujHKDHzbmx7sc34GEpskleishgMNEDSAVRY8aBYpFB1U3SZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733359068; c=relaxed/simple;
	bh=KM2YJrJrmR4GN9beohUVoA1GHdeIeU0RH12p3chA3PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4Ebpu57Bz5acxvo+GERUNWB5NUJR+TJyOsiha924/6mk7cE6FD/a3bsxqas874QpF5sm2adPXDK1OdlrJ4lCHoLVkTbdYo6RdCMEjw5jvKbU4ebk2biW6ICXjbUZGUERso+qqQa/tt+AT5r8NZjW7dSGz/tAio64Q5chVbaYuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ncAmXn3N; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Dec 2024 16:37:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733359063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y+fesaggYnmYPTzNBJhmMN//258qRMFZQIkG5W+7nf4=;
	b=ncAmXn3NSw8a8PcZ3ZdbA+Sk7ZibUOGTbgwXXbJrGv82qW64BwjUsCdSRqpCTs6dBEngub
	tWEqrhO55s+7IIotR0RT41ftfStdWGaOdVmbvxXcTLAAjijsQ2KTaDB4kp43I4M78abNUt
	ZFpijB0n+1EyiDcMrpAfOqKyqNcXjaU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 06/11] KVM: arm64: nv: Acceletate EL0 counter accesses
 from hypervisor context
Message-ID: <Z1D1zus18KCpCqjD@linux.dev>
References: <20241202172134.384923-1-maz@kernel.org>
 <20241202172134.384923-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202172134.384923-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

typo: accelerate

On Mon, Dec 02, 2024 at 05:21:29PM +0000, Marc Zyngier wrote:
> Similarly to handling the physical timer accesses early when FEAT_ECV
> causes a trap, we try to handle the physical counter without returning
> to the general sysreg handling.
> 
> More surprisingly, we introduce something similar for the virtual
> counter. Although this isn't necessary yet, it will prove useful on
> systems that have a broken CNTVOFF_EL2 implementation. Yes, they exist.
> 
> Special care is taken to offset reads of the counter with the host's
> CNTPOFF_EL2, as we perform this with TGE clear.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  5 +++++
>  arch/arm64/kvm/hyp/vhe/switch.c         | 13 +++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 34f53707892df..30e572de28749 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -501,6 +501,11 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
> +{
> +	return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
> +}
> +
>  static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_context *ctxt;
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index b014b0b10bf5d..49815a8a4c9bc 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -296,6 +296,13 @@ static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
>  			val = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
>  		}
>  		break;
> +	case SYS_CNTPCT_EL0:
> +	case SYS_CNTPCTSS_EL0:
> +		/* If !ELIsInHost(EL0), the guest's CNTPOFF_EL2 applies */
> +		val = compute_counter_value(!(vcpu_el2_e2h_is_set(vcpu) &&
> +					      vcpu_el2_tge_is_set(vcpu)) ?
> +					    vcpu_ptimer(vcpu) : vcpu_hptimer(vcpu));
> +		break;
>  	case SYS_CNTV_CTL_EL02:
>  		val = __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
>  		break;
> @@ -314,6 +321,12 @@ static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		else
>  			val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
>  		break;
> +	case SYS_CNTVCT_EL0:
> +	case SYS_CNTVCTSS_EL0:
> +		/* If !ELIsInHost(EL2), the guest's CNTVOFF_EL2 applies */

!ELIsInHost(EL0)

> +		val = compute_counter_value(!vcpu_el2_e2h_is_set(vcpu) ?
> +					    vcpu_vtimer(vcpu) : vcpu_hvtimer(vcpu));
> +		break;
>  	default:
>  		return false;
>  	}
> -- 
> 2.39.2
> 

