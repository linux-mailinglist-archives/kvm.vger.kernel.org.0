Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0D36CB9D6
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 10:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjC1IwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 04:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjC1IwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 04:52:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54B6AFA
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 01:52:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52E0FC14;
        Tue, 28 Mar 2023 01:53:04 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF3643F73F;
        Tue, 28 Mar 2023 01:52:18 -0700 (PDT)
Message-ID: <23758eb0-a5b9-afa6-a85e-faa2690323c7@arm.com>
Date:   Tue, 28 Mar 2023 09:52:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 05/11] KVM: arm64: Start handling SMCs from EL1
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-6-oliver.upton@linux.dev>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230320221002.4191007-6-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 22:09, Oliver Upton wrote:
> Whelp, the architecture gods have spoken and confirmed that the function
> ID space is common between SMCs and HVCs. Not only that, the expectation
> is that hypervisors handle calls to both SMC and HVC conduits. KVM
> recently picked up support for SMCCCs in commit bd36b1a9eb5a ("KVM:
> arm64: nv: Handle SMCs taken from virtual EL2") but scoped it only to a
> nested hypervisor.
> 
> Let's just open the floodgates and let EL1 access our SMCCC
> implementation with the SMC instruction as well.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

One minor observation below.

> ---
>   arch/arm64/kvm/handle_exit.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 5e4f9737cbd5..68f95dcd41a1 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -72,13 +72,15 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>   	 *
>   	 * We need to advance the PC after the trap, as it would
>   	 * otherwise return to the same address...
> -	 *
> -	 * Only handle SMCs from the virtual EL2 with an immediate of zero and
> -	 * skip it otherwise.
>   	 */
> -	if (!vcpu_is_el2(vcpu) || kvm_vcpu_hvc_get_imm(vcpu)) {
> +	kvm_incr_pc(vcpu);
> +
> +	/*
> +	 * SMCs with a nonzero immediate are reserved according to DEN0028E 2.9
> +	 * "SMC and HVC immediate value".
> +	 */
> +	if (kvm_vcpu_hvc_get_imm(vcpu)) {
>   		vcpu_set_reg(vcpu, 0, ~0UL);
> -		kvm_incr_pc(vcpu);
>   		return 1;
>   	}
>   
> @@ -93,8 +95,6 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>   	if (ret < 0)
>   		vcpu_set_reg(vcpu, 0, ~0UL);

Nothing to do with this patch. But that check above is different
from how we handle HVC. i.e., we return back to guest for HVCs.
But for SMCs, we tend to return "ret" indicating an error (ret < 0).

Do we need to fix that ?

Suzuki

