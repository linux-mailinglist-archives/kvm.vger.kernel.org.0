Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0642127EF
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgGBPc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:32:26 -0400
Received: from foss.arm.com ([217.140.110.172]:35842 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729936AbgGBPc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:32:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B950E31B;
        Thu,  2 Jul 2020 08:32:25 -0700 (PDT)
Received: from [10.37.12.95] (unknown [10.37.12.95])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 686573F68F;
        Thu,  2 Jul 2020 08:32:24 -0700 (PDT)
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
To:     maz@misterjones.org
Cc:     kvm@vger.kernel.org, andre.przywara@arm.com, sami.mujawar@arm.com,
        will@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
 <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <0657181e-dff8-5bcc-add6-1b41df2993af@arm.com>
Date:   Thu, 2 Jul 2020 16:37:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc

On 07/01/2020 04:42 PM, Marc Zyngier wrote:
> On 2020-07-01 15:20, Suzuki K Poulose wrote:
>> When the host doesn't support 32bit guests, the kvmtool fails
>> without a proper message on what is wrong. i.e,
>>
>>  $ lkvm run -c 1 Image --aarch32
>>   # lkvm run -k Image -m 256 -c 1 --name guest-105618
>>   Fatal: Unable to initialise vcpu
>>
>> Given that there is no other easy way to check if the host supports 32bit
>> guests, it is always good to report this by checking the capability, 
>> rather
>> than leaving the users to hunt this down by looking at the code!
>>
>> After this patch:
>>
>>  $ lkvm run -c 1 Image --aarch32
>>   # lkvm run -k Image -m 256 -c 1 --name guest-105695
>>   Fatal: 32bit guests are not supported
> 
> Fancy!
> 
>>
>> Cc: Will Deacon <will@kernel.org>
>> Reported-by: Sami Mujawar <sami.mujawar@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>  arm/kvm-cpu.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
>> index 554414f..2acecae 100644
>> --- a/arm/kvm-cpu.c
>> +++ b/arm/kvm-cpu.c
>> @@ -46,6 +46,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm,
>> unsigned long cpu_id)
>>          .features = ARM_VCPU_FEATURE_FLAGS(kvm, cpu_id)
>>      };
>>
>> +    if (kvm->cfg.arch.aarch32_guest &&
>> +        !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
> 
> Can you please check that this still compiles for 32bit host?

Yes, it does. I have built this on an arm32 rootfs with make ARCH=arm.
The kvm->cfg.arch is common across arm/arm64 and is defined here :

arm/include/arm-common/kvm-config-arch.h

And the aarch32 command line option is only available on aarch64 host.
So this is safe on an arm32 host.

> 
>> +        die("32bit guests are not supported\n");
>> +
>>      vcpu = calloc(1, sizeof(struct kvm_cpu));
>>      if (!vcpu)
>>          return NULL;
> 
> With the above detail checked,
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Thanks
Suzuki
