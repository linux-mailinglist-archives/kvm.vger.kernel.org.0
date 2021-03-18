Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7B6340700
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCRNfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231483AbhCRNfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 09:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D883564E27;
        Thu, 18 Mar 2021 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616074508;
        bh=drwRf6r5gnk51sjNwKIMpcBEidEESTQ50krX8/oftAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSRCQ+nrd6zWoS6wyFcVqCQno3fU8dhLOCqJSWq8Ak1J3eJEk85IiRVXzq6SNPE1l
         zRAEpM7cU5pWB503cpw5/9Mba59eGThFxIvximWdMXTJ3pLdvahh6aNcSMNLv5RGW/
         Dvi98vIMIxfqqFq+G1J8O98aOUuNnHAFDSUI7Elzu4EAg6Xn0VYRnAU67EFHT28Baf
         m0iDMHkBuK+F95qFt6F6YTNqEMHG3ZFeaXC5Kj4AJPFhttg1G5lSDELtO9lLKSwkXu
         +6/oAK99CIIobz4Om4PlXwX0yzHGqbz2H4nurU1mDJ7u9uG14zO5F0EC2BPdytYaYm
         HrzmvF3p/CwyA==
Date:   Thu, 18 Mar 2021 13:35:02 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, ascull@google.com, qperret@google.com,
        kernel-team@android.com
Subject: Re: [PATCH v2 07/11] KVM: arm64: Map SVE context at EL2 when
 available
Message-ID: <20210318133502.GD7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-8-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:25:28PM +0000, Marc Zyngier wrote:
> When running on nVHE, and that the vcpu supports SVE, map the
> SVE state at EL2 so that KVM can access it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index b7e36a506d3d..3c37a419fa82 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -43,6 +43,17 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		goto error;
>  
> +	if (vcpu->arch.sve_state) {
> +		void *sve_end;
> +
> +		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu);
> +
> +		ret = create_hyp_mappings(vcpu->arch.sve_state, sve_end,
> +					  PAGE_HYP);
> +		if (ret)
> +			goto error;
> +	}

Acked-by: Will Deacon <will@kernel.org>

Will
