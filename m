Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C08026D831
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 11:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgIQJzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 05:55:31 -0400
Received: from foss.arm.com ([217.140.110.172]:43634 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgIQJzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 05:55:23 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 05:55:23 EDT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43A7711D4;
        Thu, 17 Sep 2020 02:46:24 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08E903F68F;
        Thu, 17 Sep 2020 02:46:22 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>
Cc:     Ying Fang <fangying1@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
 <20200917080429.jimidzdtdskwhbdx@kamzik.brq.redhat.com>
 <198c63d5e9e17ddb4c3848845891301c@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
Date:   Thu, 17 Sep 2020 10:47:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <198c63d5e9e17ddb4c3848845891301c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/17/20 9:42 AM, Marc Zyngier wrote:
> On 2020-09-17 09:04, Andrew Jones wrote:
>> On Thu, Sep 17, 2020 at 08:47:42AM +0100, Marc Zyngier wrote:
>>> On 2020-09-17 03:30, Ying Fang wrote:
>>> > Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
>>> > so that we can support cpu topology for arm.
>>>
>>> MPIDR has *nothing* to do with CPU topology in the ARM architecture.
>>> I encourage you to have a look at the ARM ARM and find out how often
>>> the word "topology" is used in conjunction with the MPIDR_EL1 register.
>>>
>>
>> Hi Marc,
>>
>> I mostly agree. However, the CPU topology descriptions use MPIDR to
>> identify PEs. If userspace wants to build topology descriptions then
>> it either needs to
>>
>> 1) build them after instantiating all KVM VCPUs in order to query KVM
>>    for each MPIDR, or
>> 2) have a way to ask KVM for an MPIDR of given VCPU ID in advance
>>    (maybe just a scratch VCPU), or
>> 3) have control over the MPIDRs so it can choose them when it likes,
>>    use them for topology descriptions, and then instantiate KVM VCPUs
>>    with them.
>>
>> I think (3) is the most robust approach, and it has the least overhead.
>
> I don't disagree with the goal, and not even with the choice of
> implementation (though I have huge reservations about its quality).
>
> But the key word here is *userspace*. Only userspace has a notion of
> how MPIDR values map to the assumed topology. That's not something
> that KVM does nor should interpret (aside from the GIC-induced Aff0
> brain-damage). So talking of "topology" in a KVM kernel patch sends
> the wrong message, and that's all this remark was about.

There's also a patch queued for next which removes using MPIDR as a source of
information about CPU topology [1]: "arm64: topology: Stop using MPIDR for
topology information".

I'm not really sure how useful KVM fiddling with the guest MPIDR will be going
forward, at least for a Linux guest.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?id=3102bc0e6ac7

Thanks,
Alex
