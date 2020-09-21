Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6902E272A90
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 17:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgIUPos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 11:44:48 -0400
Received: from foss.arm.com ([217.140.110.172]:45688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgIUPor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 11:44:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A864E147A;
        Mon, 21 Sep 2020 08:44:46 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B01013F718;
        Mon, 21 Sep 2020 08:44:44 -0700 (PDT)
Subject: Re: [PATCH v6 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        swboyd@chromium.org, sumit.garg@linaro.org,
        Julien Thierry <julien.thierry@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200819133419.526889-1-alexandru.elisei@arm.com>
 <20200819133419.526889-6-alexandru.elisei@arm.com>
 <20200921134301.GJ2139@willie-the-truck>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a8763d49-d105-3920-8acf-c14d3a723b18@arm.com>
Date:   Mon, 21 Sep 2020 16:45:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200921134301.GJ2139@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On 9/21/20 2:43 PM, Will Deacon wrote:
> On Wed, Aug 19, 2020 at 02:34:17PM +0100, Alexandru Elisei wrote:
>> From: Julien Thierry <julien.thierry@arm.com>
>>
>> kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
>> NMI context, defer waking the vcpu to an irq_work queue.
>>
>> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
>> Cc: kvm@vger.kernel.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arch/arm64/kvm/pmu-emul.c | 25 ++++++++++++++++++++++++-
>>  include/kvm/arm_pmu.h     |  1 +
>>  2 files changed, 25 insertions(+), 1 deletion(-)
> I'd like an Ack from the KVM side on this one, but some minor comments
> inline.
>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index f0d0312c0a55..30268397ed06 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -433,6 +433,22 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
>>  	kvm_pmu_update_state(vcpu);
>>  }
>>  
>> +/**
>> + * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
>> + * to the event.
>> + * This is why we need a callback to do it once outside of the NMI context.
>> + */
>> +static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_pmu *pmu;
>> +
>> +	pmu = container_of(work, struct kvm_pmu, overflow_work);
>> +	vcpu = kvm_pmc_to_vcpu(&pmu->pmc[0]);
> Can you spell this kvm_pmc_to_vcpu(pmu->pmc); ?

Of course, that is much better.

>
>> +
>> +	kvm_vcpu_kick(vcpu);
> How do we guarantee that the vCPU is still around by the time this runs?
> Sorry to ask such a horrible question, but I don't see anything associating
> the workqueue with the lifetime of the vCPU.

That's a very nice catch, indeed the code doesn't guarantee that the VM is still
around when the work is executed. I will add an irq_work_sync() call to
kvm_pmu_vcpu_destroy() (which is called by kvm_vcpu_destroy() ->
kvm_arch_vcpu_destroy()), and to kvm_pmu_vcpu_reset(), similar to how x86 handles it.

Thanks,
Alex
