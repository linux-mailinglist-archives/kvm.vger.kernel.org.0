Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD546797550
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbjIGPqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343932AbjIGPbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:31:42 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 720641FC0
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 08:31:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 185B7176B;
        Thu,  7 Sep 2023 08:30:34 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C01103F67D;
        Thu,  7 Sep 2023 08:29:54 -0700 (PDT)
Date:   Thu, 7 Sep 2023 16:29:52 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: Re: [PATCH 3/5] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when
 mpidr_data is available
Message-ID: <20230907152952.GC69899@e124191.cambridge.arm.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907100931.1186690-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907100931.1186690-4-maz@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 11:09:29AM +0100, Marc Zyngier wrote:
> If our fancy little table is present when calling kvm_mpidr_to_vcpu(),
> use it to recover the corresponding vcpu.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 30ce394c09d4..5b75b2db12be 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2395,6 +2395,18 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
>  	unsigned long i;
>  
>  	mpidr &= MPIDR_HWID_BITMASK;
> +
> +	if (kvm->arch.mpidr_data) {
> +		u16 idx = kvm_mpidr_index(kvm->arch.mpidr_data, mpidr);
> +
> +		vcpu = kvm_get_vcpu(kvm,
> +				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
> +		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
> +			vcpu = NULL;
> +
> +		return vcpu;
> +	}
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
>  			return vcpu;

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
