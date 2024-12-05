Return-Path: <kvm+bounces-33130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C9F29E5503
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 13:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F14771882C9F
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDA8217F2A;
	Thu,  5 Dec 2024 12:07:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DE521773E
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 12:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733400437; cv=none; b=I1GCzWsVhrrbPC/jW1r01ToA+Nl093+oHc1IazdcVoq5fR70Keca1PFgB3Hz7DJ7wNnWoYm9ZaGVkHy0Gq5o9VHlyaxBgiIEvjphrqQSQJkBZQ+2ek4bWJWXR/mF0RIPBFUVKrow8jxJqp69Zuc7rZgnimh4XlSmaHTxvGYU9dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733400437; c=relaxed/simple;
	bh=yHPA4gghsiZ/IB/ITJyjXf4axTcB1gUH1IIvh6nY/9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NluHCbl/CiC0Rov8xMpHNsc71UOO/jP8Wx0kTTbZqHwU/jwCKziIvDcneNXLnVi6CRboylzzOvs6stC76C+0qoB6XfK6sRxZEMVN6aLIDD591FJ9qo5TpJUW/udhz5LVRbyetuWkkteziPuCEroAjQd7mTxEUvrO/7GTVhd78qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFE901063;
	Thu,  5 Dec 2024 04:07:42 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 463633F5A1;
	Thu,  5 Dec 2024 04:07:13 -0800 (PST)
Date: Thu, 5 Dec 2024 12:07:07 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 06/11] KVM: arm64: nv: Acceletate EL0 counter accesses
 from hypervisor context
Message-ID: <20241205120707.GA102570@e124191.cambridge.arm.com>
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

Can you explain this part a bit more? I'm assuming it's somehow related to the
arch_timer_read_cntpct_el0() call.

However I think we're at EL2 inside kvm_hyp_handle_timer(), so reading
CNTPCT_EL0 won't involve CNTPOFF_EL2.

What am I missing/misunderstanding?

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
> +		val = compute_counter_value(!vcpu_el2_e2h_is_set(vcpu) ?
> +					    vcpu_vtimer(vcpu) : vcpu_hvtimer(vcpu));
> +		break;
>  	default:
>  		return false;
>  	}

Thanks,
Joey

