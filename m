Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5084DE4
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388390AbfHGNvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 09:51:19 -0400
Received: from foss.arm.com ([217.140.110.172]:48890 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388123AbfHGNvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 09:51:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D9F228;
        Wed,  7 Aug 2019 06:51:18 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D77E03F706;
        Wed,  7 Aug 2019 06:51:16 -0700 (PDT)
Subject: Re: [PATCH 6/9] KVM: arm64: Provide a PV_TIME device to user space
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-7-steven.price@arm.com> <20190803135113.6cdf500c@why>
 <20190803183335.149e0113@why> <5aa54066-b9f6-22d1-fa2b-ce5cbf244ab5@arm.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <9c416f28-d078-4575-8095-8b4cccfe40ec@kernel.org>
Date:   Wed, 7 Aug 2019 14:51:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5aa54066-b9f6-22d1-fa2b-ce5cbf244ab5@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/2019 14:39, Steven Price wrote:
> On 03/08/2019 18:34, Marc Zyngier wrote:
>> On Sat, 3 Aug 2019 13:51:13 +0100
>> Marc Zyngier <maz@kernel.org> wrote:
>>
>> [forgot that one]
>>
>>> On Fri,  2 Aug 2019 15:50:14 +0100
>>> Steven Price <steven.price@arm.com> wrote:
>>
>> [...]
>>
>>>> +static int __init kvm_pvtime_init(void)
>>>> +{
>>>> +	kvm_register_device_ops(&pvtime_ops, KVM_DEV_TYPE_ARM_PV_TIME);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +late_initcall(kvm_pvtime_init);
>>
>> Why is it an initcall? So far, the only initcall we've used is the one
>> that initializes KVM itself. Can't we just the device_ops just like we
>> do for the vgic?
> 
> So would you prefer a direct call from init_subsystems() in
> virt/kvm/arm/arm.c?

Yes. Consistency is important.

> The benefit of initcall is just that it keeps the code self-contained.
> In init_subsystems() I'd either need a #ifdef CONFIG_ARM64 or a dummy
> function for arm.

Having a dummy function for 32bit ARM is fine. Most of the code we add
to the 32bit port is made of empty stubs anyway.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
