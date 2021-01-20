Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8172FD4AC
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 16:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733192AbhATP6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 10:58:00 -0500
Received: from foss.arm.com ([217.140.110.172]:41362 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730476AbhATP5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 10:57:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 310691063;
        Wed, 20 Jan 2021 07:57:01 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A00BF3F68F;
        Wed, 20 Jan 2021 07:56:59 -0800 (PST)
Subject: Re: [PATCH 5/9] KVM: arm: move has_run_once after the map_resources
To:     Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-6-eric.auger@redhat.com>
 <0c9976a3-12ae-29b2-1f26-06ee52aa2ffe@arm.com>
 <3465e1e4-d202-ae36-5b61-87f796432428@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5590800f-f77d-52e1-e408-c1afe4e284a2@arm.com>
Date:   Wed, 20 Jan 2021 15:56:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <3465e1e4-d202-ae36-5b61-87f796432428@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 1/14/21 10:02 AM, Auger Eric wrote:
> Hi Alexandru,
>
> On 1/12/21 3:55 PM, Alexandru Elisei wrote:
>> Hi Eric,
>>
>> On 12/12/20 6:50 PM, Eric Auger wrote:
>>> has_run_once is set to true at the beginning of
>>> kvm_vcpu_first_run_init(). This generally is not an issue
>>> except when exercising the code with KVM selftests. Indeed,
>>> if kvm_vgic_map_resources() fails due to erroneous user settings,
>>> has_run_once is set and this prevents from continuing
>>> executing the test. This patch moves the assignment after the
>>> kvm_vgic_map_resources().
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> ---
>>>  arch/arm64/kvm/arm.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index c0ffb019ca8b..331fae6bff31 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -540,8 +540,6 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>>>  	if (!kvm_arm_vcpu_is_finalized(vcpu))
>>>  		return -EPERM;
>>>  
>>> -	vcpu->arch.has_run_once = true;
>>> -
>>>  	if (likely(irqchip_in_kernel(kvm))) {
>>>  		/*
>>>  		 * Map the VGIC hardware resources before running a vcpu the
>>> @@ -560,6 +558,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>>>  		static_branch_inc(&userspace_irqchip_in_use);
>>>  	}
>>>  
>>> +	vcpu->arch.has_run_once = true;
>> I have a few concerns regarding this:
>>
>> 1. Moving has_run_once = true here seems very arbitrary to me - kvm_timer_enable()
>> and kvm_arm_pmu_v3_enable(), below it, can both fail because of erroneous user
>> values. If there's a reason why the assignment cannot be moved at the end of the
>> function, I think it should be clearly stated in a comment for the people who
>> might be tempted to write similar tests for the timer or pmu.
> Setting has_run_once = true at the entry of the function looks to me
> even more arbitrary. I agree with you that eventually has_run_once may

Or it could be it's there to prevent the user from calling
kvm_vgic_map_resources() a second time after it failed. This is what I'm concerned
about and I think deserves more investigation.

Thanks,
Alex
> be moved at the very end but maybe this can be done later once timer,
> pmu tests haven ben written
>> 2. There are many ways that kvm_vgic_map_resources() can fail, other than
>> incorrect user settings. I started digging into how
>> kvm_vgic_map_resources()->vgic_v2_map_resources() can fail for a VGIC V2 and this
>> is what I managed to find before I gave up:
>>
>> * vgic_init() can fail in:
>>     - kvm_vgic_dist_init()
>>     - vgic_v3_init()
>>     - kvm_vgic_setup_default_irq_routing()
>> * vgic_register_dist_iodev() can fail in:
>>     - vgic_v3_init_dist_iodev()
>>     - kvm_io_bus_register_dev()(*)
>> * kvm_phys_addr_ioremap() can fail in:
>>     - kvm_mmu_topup_memory_cache()
>>     - kvm_pgtable_stage2_map()
> I changed the commit msg so that "incorrect user settings" sounds as an
> example.
>> So if any of the functions below fail, are we 100% sure it is safe to allow the
>> user to execute kvm_vgic_map_resources() again?
> I think additional tests will confirm this. However at the moment,
> moving the assignment, which does not look wrong to me, allows to
> greatly simplify the tests so I would tend to say that it is worth.
>> (*) It looks to me like kvm_io_bus_register_dev() doesn't take into account a
>> caller that tries to register the same device address range and it will create
>> another identical range. Is this intentional? Is it a bug that should be fixed? Or
>> am I misunderstanding the function?
> doesn't kvm_io_bus_cmp() do the check?
>
> Thanks
>
> Eric
>> Thanks,
>> Alex
>>> +
>>>  	ret = kvm_timer_enable(vcpu);
>>>  	if (ret)
>>>  		return ret;
