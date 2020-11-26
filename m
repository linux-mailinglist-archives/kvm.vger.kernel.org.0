Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E078F2C5812
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 16:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391322AbgKZPZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 10:25:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389756AbgKZPZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 10:25:27 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44BE12087C;
        Thu, 26 Nov 2020 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606404326;
        bh=ex8zM01Qf4GRjPCLPiCrNyiXTx9goms244wEAdEL7NQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VLV1daix0z8iPONDOP+71WX/IOApqNx+Rx+fdXn3AF7cp9vVuvZmKZcWhlOFavXqy
         9dWw3lUQnequckWPtHnUH9Nt+0KKSOYtcKaeAzXAK5EK5swiKpvwHIbfwHW//M17hh
         JgCY9Z/i9HxHfVpMe9oKfq1CGBbfvZb19LNy3QB0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiJ9A-00Dq9p-9S; Thu, 26 Nov 2020 15:25:24 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 15:25:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: Re: [PATCH 3/8] KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at
 reset time
In-Reply-To: <27c74186-d9d6-4021-c561-54ae4475bf88@arm.com>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-4-maz@kernel.org>
 <27c74186-d9d6-4021-c561-54ae4475bf88@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7abf75c1d1248a9c0e3fcb7737a101c0@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2020-11-26 14:59, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 11/13/20 6:25 PM, Marc Zyngier wrote:
>> We accept to configure a PMU when a vcpu is created, even if the
>> HW (or the host) doesn't support it. This results in failures
>> when attributes get set, which is a bit odd as we should have
>> failed the vcpu creation the first place.
>> 
>> Move the check to the point where we check the vcpu feature set,
>> and fail early if we cannot support a PMU. This further simplifies
>> the attribute handling.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/pmu-emul.c | 4 ++--
>>  arch/arm64/kvm/reset.c    | 4 ++++
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index e7e3b4629864..200f2a0d8d17 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -913,7 +913,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int 
>> irq)
>> 
>>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct 
>> kvm_device_attr *attr)
>>  {
>> -	if (!kvm_arm_support_pmu_v3() || !kvm_vcpu_has_pmu(vcpu))
>> +	if (!kvm_vcpu_has_pmu(vcpu))
>>  		return -ENODEV;
>> 
>>  	if (vcpu->arch.pmu.created)
>> @@ -1034,7 +1034,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu 
>> *vcpu, struct kvm_device_attr *attr)
>>  	case KVM_ARM_VCPU_PMU_V3_IRQ:
>>  	case KVM_ARM_VCPU_PMU_V3_INIT:
>>  	case KVM_ARM_VCPU_PMU_V3_FILTER:
>> -		if (kvm_arm_support_pmu_v3() && kvm_vcpu_has_pmu(vcpu))
>> +		if (kvm_vcpu_has_pmu(vcpu))
>>  			return 0;
>>  	}
>> 
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 74ce92a4988c..3e772ea4e066 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -285,6 +285,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>  			pstate = VCPU_RESET_PSTATE_EL1;
>>  		}
>> 
>> +		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
> 
> This looks correct, but right at the beginning of the function, before 
> this
> non-preemptible section, we do kvm_pmu_vcpu_reset(), which is wrong for 
> several
> reasons:
> 
> - we don't check if the feature flag is set
> - we don't check if the hardware supports a PMU
> - kvm_pmu_vcpu_reset() relies on __vcpu_sys_reg(vcpu, PMCR_EL0), which 
> is set in
> kvm_reset_sys_regs() below when the VCPU is initialized.

I'm not sure it actually matters. Here's my rational:

- PMU support not compiled in: no problem!
- PMU support compiled in, but no HW PMU: we just reset some state to 0, 
no harm done
- HW PMU, but no KVM PMU for this vcpu: same thing
- HW PMU, and KVM PMU: we do the right thing!

Am I missing anything?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
