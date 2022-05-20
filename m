Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C7352EFC9
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347830AbiETPzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 11:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351191AbiETPzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 11:55:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D689179955
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 08:55:42 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB7801480;
        Fri, 20 May 2022 08:55:41 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A884A3F73D;
        Fri, 20 May 2022 08:55:38 -0700 (PDT)
Date:   Fri, 20 May 2022 16:55:51 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/89] KVM: arm64: Return error from kvm_arch_init_vm()
 on allocation failure
Message-ID: <Yoe6BxKzJPIaZ+pk@monolith.localdoman>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-4-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519134204.5379-4-will@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, May 19, 2022 at 02:40:38PM +0100, Will Deacon wrote:
> If we fail to allocate the 'supported_cpus' cpumask in kvm_arch_init_vm()
> then be sure to return -ENOMEM instead of success (0) on the failure
> path.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 523bc934fe2f..775b52871b51 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -146,8 +146,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (ret)
>  		goto out_free_stage2_pgd;
>  
> -	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL))
> +	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
> +		ret = -ENOMEM;
>  		goto out_free_stage2_pgd;
> +	}
>  	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
>  
>  	kvm_vgic_early_init(kvm);

Thank you for the fix:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

This can go in independent of the series. I can send it after rc1 if you
prefer to focus on something else.

Thanks,
Alex
