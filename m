Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A1D19D87F
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgDCOCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:02:02 -0400
Received: from foss.arm.com ([217.140.110.172]:53690 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgDCOCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:02:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C857D31B;
        Fri,  3 Apr 2020 07:02:01 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C01603F52E;
        Fri,  3 Apr 2020 07:02:00 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: PSCI: Narrow input registers when using
 32bit functions
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200401165816.530281-1-maz@kernel.org>
 <20200401165816.530281-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a7b7d9d7-120f-2c33-b803-64b999b5a839@arm.com>
Date:   Fri, 3 Apr 2020 15:02:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401165816.530281-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/1/20 5:58 PM, Marc Zyngier wrote:
> When a guest delibarately uses an SSMC32 function number (which is allowed),

s/SSMC32/SMC32

> we should make sure we drop the top 32bits from the input arguments, as they
> could legitimately be junk.
>
> Reported-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/psci.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 17e2bdd4b76f..69ff4a51ceb5 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -187,6 +187,18 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
>  	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
>  }
>  
> +static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	/*
> +	 * Zero the input registers' upper 32 bits. They will be fully
> +	 * zeroed on exit, so we're fine changing them in place.
> +	 */
> +	for (i = 1; i < 4; i++)
> +		vcpu_set_reg(vcpu, i, (u32)vcpu_get_reg(vcpu, i));

One minor suggestion, it could be lower_32_bits instead, but that's down to
personal preference and entirely up to you.

> +}
> +
>  static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -211,12 +223,16 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  		val = PSCI_RET_SUCCESS;
>  		break;
>  	case PSCI_0_2_FN_CPU_ON:
> +		kvm_psci_narrow_to_32bit(vcpu);
> +		fallthrough;
>  	case PSCI_0_2_FN64_CPU_ON:
>  		mutex_lock(&kvm->lock);
>  		val = kvm_psci_vcpu_on(vcpu);
>  		mutex_unlock(&kvm->lock);
>  		break;
>  	case PSCI_0_2_FN_AFFINITY_INFO:
> +		kvm_psci_narrow_to_32bit(vcpu);
> +		fallthrough;
>  	case PSCI_0_2_FN64_AFFINITY_INFO:
>  		val = kvm_psci_vcpu_affinity_info(vcpu);
>  		break;

From ARM DEN 0022D, those are indeed the only functions with ids that differ from
SMC32 to SMC64, and have arguments that KVM doesn't ignore (like it does with
CPU_SUSPEND).

I also had a look at smccc_get_arg{1,2,3}, because they read the register values
and return an unsigned long. smccc_get_arg1 is called after the registers have
been narrowed, or the result is cast into an u32 when called before that.
smccc_get_arg{2,3} are always called as part of the individual PSCI function
implementations, which come after the arguments have been narrowed. With that:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
