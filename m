Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC08F9DF0F
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 09:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfH0Htr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 03:49:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:41954 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfH0Htr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 03:49:47 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 54B5E417F00AEC2B86DC;
        Tue, 27 Aug 2019 15:49:44 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 15:49:38 +0800
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Use a single IO device per
 redistributor
To:     Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <maz@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
CC:     <zhang.zhanghailiang@huawei.com>, <wanghaibin.wang@huawei.com>,
        <james.morse@arm.com>, <qemu-arm@nongnu.org>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <peter.maydell@linaro.org>, <andre.przywara@arm.com>
References: <20190823173330.23342-1-eric.auger@redhat.com>
 <f5b47614-de48-f3cb-0e6f-8a667cb951c0@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5cdcfe9e-98d8-454e-48e7-992fe3ee5eae@huawei.com>
Date:   Tue, 27 Aug 2019 15:49:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <f5b47614-de48-f3cb-0e6f-8a667cb951c0@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

Thanks for this patch!

On 2019/8/24 1:52, Auger Eric wrote:
> Hi Zenghui, Marc,
> 
> On 8/23/19 7:33 PM, Eric Auger wrote:
>> At the moment we use 2 IO devices per GICv3 redistributor: one
                                                              ^^^
>> one for the RD_base frame and one for the SGI_base frame.
   ^^^
>>
>> Instead we can use a single IO device per redistributor (the 2
>> frames are contiguous). This saves slots on the KVM_MMIO_BUS
>> which is currently limited to NR_IOBUS_DEVS (1000).
>>
>> This change allows to instantiate up to 512 redistributors and may
>> speed the guest boot with a large number of VCPUs.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> I tested this patch with below kernel and QEMU branches:
> kernel: https://github.com/eauger/linux/tree/256fix-v1
> (Marc's patch + this patch)
> https://github.com/eauger/qemu/tree/v4.1.0-256fix-rfc1-rc0
> (header update + kvm_arm_gic_set_irq modification)

I also tested these three changes on HiSi D05 (with 64 pcpus), and yes,
I can get a 512U guest to boot properly now.

Tested-by: Zenghui Yu <yuzenghui@huawei.com>

> On a machine with 224 pcpus, I was able to boot a 512 vcpu guest.
> 
> As expected, qemu outputs warnings:
> 
> qemu-system-aarch64: warning: Number of SMP cpus requested (512) exceeds
> the recommended cpus supported by KVM (224)
> qemu-system-aarch64: warning: Number of hotpluggable cpus requested
> (512) exceeds the recommended cpus supported by KVM (224)
> 
> on the guest: getconf _NPROCESSORS_ONLN returns 512
> 
> Then I have no clue about what can be expected of such overcommit config
> and I have not further exercised the guest at the moment. But at least
> it seems to boot properly. I also tested without overcommit and it seems
> to behave as before (boot, migration).
> 
> I still need to look at the migration of > 256vcpu guest at qemu level.

Let us know if further tests are needed.


Thanks,
zenghui

