Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6A39E1EF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 10:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfH0Hxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 03:53:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbfH0Hx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 03:53:29 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B6E43082E25;
        Tue, 27 Aug 2019 07:53:29 +0000 (UTC)
Received: from [10.36.116.105] (ovpn-116-105.ams2.redhat.com [10.36.116.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B010C600D1;
        Tue, 27 Aug 2019 07:53:25 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Use a single IO device per
 redistributor
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     zhang.zhanghailiang@huawei.com, wanghaibin.wang@huawei.com,
        james.morse@arm.com, qemu-arm@nongnu.org,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        peter.maydell@linaro.org, andre.przywara@arm.com
References: <20190823173330.23342-1-eric.auger@redhat.com>
 <f5b47614-de48-f3cb-0e6f-8a667cb951c0@redhat.com>
 <5cdcfe9e-98d8-454e-48e7-992fe3ee5eae@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ccb49856-f958-8bea-4b27-9a808415c43d@redhat.com>
Date:   Tue, 27 Aug 2019 09:53:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5cdcfe9e-98d8-454e-48e7-992fe3ee5eae@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 27 Aug 2019 07:53:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,
On 8/27/19 9:49 AM, Zenghui Yu wrote:
> Hi Eric,
> 
> Thanks for this patch!
> 
> On 2019/8/24 1:52, Auger Eric wrote:
>> Hi Zenghui, Marc,
>>
>> On 8/23/19 7:33 PM, Eric Auger wrote:
>>> At the moment we use 2 IO devices per GICv3 redistributor: one
>                                                              ^^^
>>> one for the RD_base frame and one for the SGI_base frame.
>   ^^^
>>>
>>> Instead we can use a single IO device per redistributor (the 2
>>> frames are contiguous). This saves slots on the KVM_MMIO_BUS
>>> which is currently limited to NR_IOBUS_DEVS (1000).
>>>
>>> This change allows to instantiate up to 512 redistributors and may
>>> speed the guest boot with a large number of VCPUs.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> I tested this patch with below kernel and QEMU branches:
>> kernel: https://github.com/eauger/linux/tree/256fix-v1
>> (Marc's patch + this patch)
>> https://github.com/eauger/qemu/tree/v4.1.0-256fix-rfc1-rc0
>> (header update + kvm_arm_gic_set_irq modification)
> 
> I also tested these three changes on HiSi D05 (with 64 pcpus), and yes,
> I can get a 512U guest to boot properly now.

Many thanks for the testing (and the bug report). I will formally post
the QEMU changes asap.

Thanks

Eric
> 
> Tested-by: Zenghui Yu <yuzenghui@huawei.com>
> 
>> On a machine with 224 pcpus, I was able to boot a 512 vcpu guest.
>>
>> As expected, qemu outputs warnings:
>>
>> qemu-system-aarch64: warning: Number of SMP cpus requested (512) exceeds
>> the recommended cpus supported by KVM (224)
>> qemu-system-aarch64: warning: Number of hotpluggable cpus requested
>> (512) exceeds the recommended cpus supported by KVM (224)
>>
>> on the guest: getconf _NPROCESSORS_ONLN returns 512
>>
>> Then I have no clue about what can be expected of such overcommit config
>> and I have not further exercised the guest at the moment. But at least
>> it seems to boot properly. I also tested without overcommit and it seems
>> to behave as before (boot, migration).
>>
>> I still need to look at the migration of > 256vcpu guest at qemu level.
> 
> Let us know if further tests are needed.
> 
> 
> Thanks,
> zenghui
> 
