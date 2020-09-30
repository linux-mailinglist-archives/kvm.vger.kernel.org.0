Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB1727E7D7
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 13:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgI3Lpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 07:45:52 -0400
Received: from foss.arm.com ([217.140.110.172]:34684 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbgI3Lpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 07:45:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A8E730E;
        Wed, 30 Sep 2020 04:45:51 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 170DA3F6CF;
        Wed, 30 Sep 2020 04:45:48 -0700 (PDT)
Subject: Re: [PATCH v7 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, sumit.garg@linaro.org, swboyd@chromium.org,
        catalin.marinas@arm.com, will@kernel.org,
        Julien Thierry <julien.thierry@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200924110706.254996-1-alexandru.elisei@arm.com>
 <20200924110706.254996-6-alexandru.elisei@arm.com>
 <14a0562fee95d5c7aa5bc6b67d213858@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3379a8af-67ae-f71f-316d-3baa5fadc6dd@arm.com>
Date:   Wed, 30 Sep 2020 12:46:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <14a0562fee95d5c7aa5bc6b67d213858@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 9/29/20 9:11 AM, Marc Zyngier wrote:
> On 2020-09-24 12:07, Alexandru Elisei wrote:
>> From: Julien Thierry <julien.thierry@arm.com>
>>
>> kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
>> NMI context, defer waking the vcpu to an irq_work queue.
>>
>> A vcpu can be freed while it's not running by kvm_destroy_vm(). Prevent
>> running the irq_work for a non-existent vcpu by calling irq_work_sync() on
>> the PMU destroy path.
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
>> Tested-by: Sumit Garg <sumit.garg@linaro.org> (Developerbox)
>> [Alexandru E.: Added irq_work_sync()]
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> I suggested in v6 that I will add an irq_work_sync() to
>> kvm_pmu_vcpu_reset(). It turns out it's not necessary: a vcpu reset is done
>> by the vcpu being reset with interrupts enabled, which means all the work
>> has had a chance to run before the reset takes place.
>
> I don't understand your argument about interrupts being enabled. The real
> reason for not needing any synchronization is that all that the queued work
> does is to kick the vcpu. Given that the vcpu is resetting, no amount of
> kicking is going to change anything (it is already outside of the guest).
>
> Things are obviously different on destroy, where the vcpu is actively going
> away and we need to make sure we don't use stale data.

Like you and Will noticed, the above really doesn't make much sense. The reason we
don't need to wait for the irq_work to be finished on reset is indeed that the
vcpu isn't freed, so we will never trigger a use-after-free bug.

>
>>
>>  arch/arm64/kvm/pmu-emul.c | 26 +++++++++++++++++++++++++-
>>  include/kvm/arm_pmu.h     |  1 +
>>  2 files changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index f0d0312c0a55..81916e360b1e 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -269,6 +269,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
>>
>>      for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
>>          kvm_pmu_release_perf_event(&pmu->pmc[i]);
>> +    irq_work_sync(&vcpu->arch.pmu.overflow_work);
>>  }
>>
>>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>> @@ -433,6 +434,22 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
>>      kvm_pmu_update_state(vcpu);
>>  }
>>
>> +/**
>> + * When perf interrupt is an NMI, we cannot safely notify the vcpu
>> corresponding
>> + * to the event.
>> + * This is why we need a callback to do it once outside of the NMI context.
>> + */
>> +static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
>> +{
>> +    struct kvm_vcpu *vcpu;
>> +    struct kvm_pmu *pmu;
>> +
>> +    pmu = container_of(work, struct kvm_pmu, overflow_work);
>> +    vcpu = kvm_pmc_to_vcpu(pmu->pmc);
>> +
>> +    kvm_vcpu_kick(vcpu);
>> +}
>> +
>>  /**
>>   * When the perf event overflows, set the overflow status and inform the vcpu.
>>   */
>> @@ -465,7 +482,11 @@ static void kvm_pmu_perf_overflow(struct
>> perf_event *perf_event,
>>
>>      if (kvm_pmu_overflow_status(vcpu)) {
>>          kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>> -        kvm_vcpu_kick(vcpu);
>> +
>> +        if (!in_nmi())
>> +            kvm_vcpu_kick(vcpu);
>> +        else
>> +            irq_work_queue(&vcpu->arch.pmu.overflow_work);
>>      }
>>
>>      cpu_pmu->pmu.start(perf_event, PERF_EF_RELOAD);
>> @@ -764,6 +785,9 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>>              return ret;
>>      }
>>
>> +    init_irq_work(&vcpu->arch.pmu.overflow_work,
>> +              kvm_pmu_perf_overflow_notify_vcpu);
>> +
>>      vcpu->arch.pmu.created = true;
>>      return 0;
>>  }
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 6db030439e29..dbf4f08d42e5 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -27,6 +27,7 @@ struct kvm_pmu {
>>      bool ready;
>>      bool created;
>>      bool irq_level;
>> +    struct irq_work overflow_work;
>
> Nit: placing this new field right after the pmc array would avoid creating
> an unnecessary padding in the structure. Not a big deal, and definitely
> something we can sort out when applying the patch.

That makes sense, overflow_work must be aligned to 8 bytes, and there are 16
elements in the pmc array, which means no padding is required for the
overflow_work field.

Thanks,
Alex
