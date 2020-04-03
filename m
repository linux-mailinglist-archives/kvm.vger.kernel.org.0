Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503C719D882
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390683AbgDCOCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:02:13 -0400
Received: from foss.arm.com ([217.140.110.172]:53716 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390573AbgDCOCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:02:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE3B431B;
        Fri,  3 Apr 2020 07:02:12 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A11DF3F52E;
        Fri,  3 Apr 2020 07:02:11 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: PSCI: Forbid 64bit functions for 32bit
 guests
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200401165816.530281-1-maz@kernel.org>
 <20200401165816.530281-3-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9c188c7e-5038-eb51-af1d-b3f54b070e6d@arm.com>
Date:   Fri, 3 Apr 2020 15:02:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401165816.530281-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 4/1/20 5:58 PM, Marc Zyngier wrote:
> Implementing (and even advertising) 64bit PSCI functions to 32bit
> guests is at least a bit odd, if not altogether violating the
> spec which says ("5.2.1 Register usage in arguments and return values"):
>
> "Adherence to the SMC Calling Conventions implies that any AArch32
> caller of an SMC64 function will get a return code of 0xFFFFFFFF(int32).
> This matches the NOT_SUPPORTED error code used in PSCI"
>
> Tighten the implementation by pretending these functions are not
> there for 32bit guests.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/psci.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 69ff4a51ceb5..122795cdd984 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -199,6 +199,21 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
>  		vcpu_set_reg(vcpu, i, (u32)vcpu_get_reg(vcpu, i));
>  }
>  
> +static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
> +{
> +	switch(fn) {
> +	case PSCI_0_2_FN64_CPU_SUSPEND:
> +	case PSCI_0_2_FN64_CPU_ON:
> +	case PSCI_0_2_FN64_AFFINITY_INFO:

I checked in ARM DEN 0022D, those are indeed the only 3 functions that KVM
implements and have a different function ID based on the calling convention.

> +		/* Disallow these functions for 32bit guests */
> +		if (vcpu_mode_is_32bit(vcpu))
> +			return PSCI_RET_NOT_SUPPORTED;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -206,6 +221,10 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  	unsigned long val;
>  	int ret = 1;
>  
> +	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
> +	if (val)
> +		goto out;
> +
>  	switch (psci_fn) {
>  	case PSCI_0_2_FN_PSCI_VERSION:
>  		/*
> @@ -273,6 +292,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  		break;
>  	}
>  
> +out:
>  	smccc_set_retval(vcpu, val, 0, 0, 0);
>  	return ret;
>  }
> @@ -290,6 +310,10 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
>  		break;
>  	case PSCI_1_0_FN_PSCI_FEATURES:
>  		feature = smccc_get_arg1(vcpu);
> +		val = kvm_psci_check_allowed_function(vcpu, feature);
> +		if (val)
> +			break;
> +
>  		switch(feature) {
>  		case PSCI_0_2_FN_PSCI_VERSION:
>  		case PSCI_0_2_FN_CPU_SUSPEND:

The patch makes sense to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
