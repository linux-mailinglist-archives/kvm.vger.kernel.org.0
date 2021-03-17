Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A733133F4E1
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 17:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhCQQBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 12:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232301AbhCQQBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 12:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD39D64E61;
        Wed, 17 Mar 2021 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615996878;
        bh=we520fPnvR+Rv9m8n4m+wndrb+dnrLpZXA3mdbq49uQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pPj0efyieA0yEzJ70ka3Gx5g46Q7tkHPeNCzVS+hZCHJG9DAz5vtsER1hfFPzGjFl
         QLgrDP8Y+IIAfUM7FrzRIiHJOFHwyGmGtphz4nqL3ld80zE1CsNKVZ0QbspYDO/mXW
         IMrqhSFfmAmQczE45DKGzHw3TyqDRcpjOtFvhNLTEgZRVHJI4uWmNOkeJtK/Zisc1e
         H74duv2v6hYqIF/ocoWF/KdfM1cYz9K5q2diQzmsT+YLN9PInv/c2U8JwvTsQeZ/bR
         1jtAoWfjBUEhyiR4p7Rs3bSgkIIDHBQhCE62fzV0mXGpH1BLvztQauk//LiRUUunEw
         WSdHWXVl813aw==
Date:   Wed, 17 Mar 2021 16:01:12 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 06/10] KVM: arm64: Map SVE context at EL2 when available
Message-ID: <20210317160112.GA5556@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-7-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:08AM +0000, Marc Zyngier wrote:
> When running on nVHE, and that the vcpu supports SVE, map the
> SVE state at EL2 so that KVM can access it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index b7e36a506d3d..84afca5ed6f2 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -43,6 +43,17 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		goto error;
>  
> +	if (vcpu->arch.sve_state) {
> +		void *sve_end;
> +
> +		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu) + 1;

Why do you need the '+ 1' here?

Will
