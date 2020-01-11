Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E85137BE2
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2020 07:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgAKGvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jan 2020 01:51:54 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:33814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728404AbgAKGvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jan 2020 01:51:54 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 32DE7412A666736B8ACF;
        Sat, 11 Jan 2020 14:51:50 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 11 Jan 2020 14:51:49 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 11
 Jan 2020 14:51:49 +0800
Subject: Re: [PATCH v2 1/6] KVM: arm64: Document PV-lock interface
To:     Steven Price <steven.price@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <maz@kernel.org>, <james.morse@arm.com>, <linux@armlinux.org.uk>,
        <suzuki.poulose@arm.com>, <julien.thierry.kdev@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <will@kernel.org>, <daniel.lezcano@linaro.org>,
        <wanghaibin.wang@huawei.com>
References: <20191226135833.1052-1-yezengruan@huawei.com>
 <20191226135833.1052-2-yezengruan@huawei.com>
 <c26ebc8d-6a10-6bc4-0af8-cd4883addbf0@arm.com>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <e30649e0-c09f-8d16-a8a2-55e57420ad8d@huawei.com>
Date:   Sat, 11 Jan 2020 14:51:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c26ebc8d-6a10-6bc4-0af8-cd4883addbf0@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steve,

On 2020/1/9 22:53, Steven Price wrote:
> On 26/12/2019 13:58, Zengruan Ye wrote:
>> Introduce a paravirtualization interface for KVM/arm64 to obtain the VCPU
>> is currently running or not.
>>
>> The PV lock structure of the guest is allocated by user space.
>>
>> A hypercall interface is provided for the guest to interrogate the
>> hypervisor's support for this interface and the location of the shared
>> memory structures.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> ---
>>   Documentation/virt/kvm/arm/pvlock.rst   | 63 +++++++++++++++++++++++++
>>   Documentation/virt/kvm/devices/vcpu.txt | 14 ++++++
>>   2 files changed, 77 insertions(+)
>>   create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
>>
>> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
>> new file mode 100644
>> index 000000000000..58b3b8ee7537
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/arm/pvlock.rst
>> @@ -0,0 +1,63 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +Paravirtualized lock support for arm64
>> +======================================
>> +
>> +KVM/arm64 provides some hypervisor service calls to support a paravirtualized
>> +guest obtaining the VCPU is currently running or not.
> NIT:              ^ whether

Thanks for posting this.

> 
>> +
>> +Two new SMCCC compatible hypercalls are defined:
>> +
>> +* PV_LOCK_FEATURES:   0xC6000020
>> +* PV_LOCK_PREEMPTED:  0xC6000021
>> +
>> +The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
>> +ARCH_FEATURES mechanism before calling it.
> 
> Since these are within the "vendor specific" SMCCC region ideally you should also check that you are talking to KVM. (Other hypervisors could allocate SMCCC IDs differently within this block). Will has a patch on a branch which gives an example of how this could work [1]
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/commit/?h=kvm/hvc&id=464f5a1741e5959c3e4d2be1966ae0093b4dce06

OK, I will add "vendor specific" check next version.

> 
>> +
>> +PV_LOCK_FEATURES
>> +    ============= ========    ==========
>> +    Function ID:  (uint32)    0xC6000020
>> +    PV_call_id:   (uint32)    The function to query for support.
>> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>> +                              PV-lock feature is supported by the hypervisor.
>> +    ============= ========    ==========
>> +
>> +PV_LOCK_PREEMPTED
>> +    ============= ========    ==========
>> +    Function ID:  (uint32)    0xC6000021
>> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the IPA of
>> +                              this VCPU's pv data structure is configured by
>> +                              the hypervisor.
>> +    ============= ========    ==========
> 
> PV_LOCK_PREEMPTED also needs to return the address of this data structure. Either by returning this in another register, or by e.g. treating a positive return as an address and a negative value as an error.

This is somewhat embarrassing. The code does what you say, but the doc doesn't. Thanks for pointing it out to me! I'll update the doc to match.

> 
>> +
>> +The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
>> +memory with inner and outer write back caching attributes, in the inner
>> +shareable domain.
>> +
>> +PV_LOCK_PREEMPTED returns the structure for the calling VCPU.
>> +
>> +PV lock state
>> +-------------
>> +
>> +The structure pointed to by the PV_LOCK_PREEMPTED hypercall is as follows:
>> +
>> ++-----------+-------------+-------------+---------------------------------+
>> +| Field     | Byte Length | Byte Offset | Description                     |
>> ++===========+=============+=============+=================================+
>> +| preempted |      8      |      0      | Indicate the VCPU who owns this |
> 
> NIT: s/Indicate/Indicates that/. Also more common English would be "the VCPU *that* owns"

Will update.

> 
>> +|           |             |             | struct is running or not.       |
>> +|           |             |             | Non-zero values mean the VCPU   |
>> +|           |             |             | has been preempted. Zero means  |
>> +|           |             |             | the VCPU is not preempted.      |
>> ++-----------+-------------+-------------+---------------------------------+
>> +
>> +The preempted field will be updated to 1 by the hypervisor prior to scheduling
>> +a VCPU. When the VCPU is scheduled out, the preempted field will be updated
>> +to 0 by the hypervisor.
>> +
>> +The structure will be present within a reserved region of the normal memory
>> +given to the guest. The guest should not attempt to write into this memory.
>> +There is a structure per VCPU of the guest.
> 
> I think it would be worth mentioning in this document that the structure is guaranteed to be 64-byte aligned.

Good point, I'll update the doc.

> 
> Steve
> 
>> +
>> +For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
>> +section "4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL".
>> diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
>> index 6f3bd64a05b0..c10a5945075b 100644
>> --- a/Documentation/virt/kvm/devices/vcpu.txt
>> +++ b/Documentation/virt/kvm/devices/vcpu.txt
>> @@ -74,3 +74,17 @@ Specifies the base address of the stolen time structure for this VCPU. The
>>   base address must be 64 byte aligned and exist within a valid guest memory
>>   region. See Documentation/virt/kvm/arm/pvtime.txt for more information
>>   including the layout of the stolen time structure.
>> +
>> +4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL
>> +Architectures: ARM64
>> +
>> +4.1 ATTRIBUTE: KVM_ARM_VCPU_PVLOCK_IPA
>> +Parameters: 64-bit base address
>> +Returns: -ENXIO:  PV lock not implemented
>> +         -EEXIST: Base address already set for this VCPU
>> +         -EINVAL: Base address not 64 byte aligned
>> +
>> +Specifies the base address of the PV lock structure for this VCPU. The
>> +base address must be 64 byte aligned and exist within a valid guest memory
>> +region. See Documentation/virt/kvm/arm/pvlock.rst for more information
>> +including the layout of the pv lock structure.
>>
> 
> 
> .

Thanks,

Zengruan

