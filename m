Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174FE19C2F5
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731945AbgDBNri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 09:47:38 -0400
Received: from foss.arm.com ([217.140.110.172]:42898 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbgDBNri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 09:47:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A7EC30E;
        Thu,  2 Apr 2020 06:47:37 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1B173F52E;
        Thu,  2 Apr 2020 06:47:36 -0700 (PDT)
Date:   Thu, 2 Apr 2020 15:47:35 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: PSCI: Narrow input registers when using
 32bit functions
Message-ID: <20200402134735.GF3650@e113682-lin.lund.arm.com>
References: <20200401165816.530281-1-maz@kernel.org>
 <20200401165816.530281-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401165816.530281-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 05:58:15PM +0100, Marc Zyngier wrote:
> When a guest delibarately uses an SSMC32 function number (which is allowed),
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
> -- 
> 2.25.0
> 

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
