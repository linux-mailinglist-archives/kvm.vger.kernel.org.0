Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430CA8108B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 05:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfHED02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Aug 2019 23:26:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3754 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfHED01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Aug 2019 23:26:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0D4FB1DD753B7D944085;
        Mon,  5 Aug 2019 11:26:25 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 5 Aug 2019
 11:26:17 +0800
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
To:     Steven Price <steven.price@arm.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <linux-doc@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3bdd764a-b6f5-d17e-a703-d8eb13838efc@huawei.com>
Date:   Mon, 5 Aug 2019 11:23:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190802145017.42543-2-steven.price@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steven,

On 2019/8/2 22:50, Steven Price wrote:
> Introduce a paravirtualization interface for KVM/arm64 based on the
> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
> 
> This only adds the details about "Stolen Time" as the details of "Live
> Physical Time" have not been fully agreed.
> 
> User space can specify a reserved area of memory for the guest and
> inform KVM to populate the memory with information on time that the host
> kernel has stolen from the guest.
> 
> A hypercall interface is provided for the guest to interrogate the
> hypervisor's support for this interface and the location of the shared
> memory structures.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   Documentation/virtual/kvm/arm/pvtime.txt | 107 +++++++++++++++++++++++
>   1 file changed, 107 insertions(+)
>   create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
                                     ^^^^^^^
This directory has been renamed recently, see:

https://patchwork.ozlabs.org/patch/1136104/


Zenghui

> 
> diff --git a/Documentation/virtual/kvm/arm/pvtime.txt b/Documentation/virtual/kvm/arm/pvtime.txt
> new file mode 100644
> index 000000000000..e6ae9799e1d5
> --- /dev/null
> +++ b/Documentation/virtual/kvm/arm/pvtime.txt
> @@ -0,0 +1,107 @@
> +Paravirtualized time support for arm64
> +======================================
> +
> +Arm specification DEN0057/A defined a standard for paravirtualised time
> +support for Aarch64 guests:
> +
> +https://developer.arm.com/docs/den0057/a
> +
> +KVM/Arm64 implements the stolen time part of this specification by providing
> +some hypervisor service calls to support a paravirtualized guest obtaining a
> +view of the amount of time stolen from its execution.
> +
> +Two new SMCCC compatible hypercalls are defined:
> +
> +PV_FEATURES 0xC5000020
> +PV_TIME_ST  0xC5000022
> +
> +These are only available in the SMC64/HVC64 calling convention as
> +paravirtualized time is not available to 32 bit Arm guests.
> +
> +PV_FEATURES
> +    Function ID:  (uint32)  : 0xC5000020
> +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> +                              PV-time feature is supported by the hypervisor.
> +
> +PV_TIME_ST
> +    Function ID:  (uint32)  : 0xC5000022
> +    Return value: (int64)   : IPA of the stolen time data structure for this
> +                              (V)CPU. On failure:
> +                              NOT_SUPPORTED (-1)
> +
> +Stolen Time
> +-----------
> +
> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
> +
> +  Field       | Byte Length | Byte Offset | Description
> +  ----------- | ----------- | ----------- | --------------------------
> +  Revision    |      4      |      0      | Must be 0 for version 0.1
> +  Attributes  |      4      |      4      | Must be 0
> +  Stolen time |      8      |      8      | Stolen time in unsigned
> +              |             |             | nanoseconds indicating how
> +              |             |             | much time this VCPU thread
> +              |             |             | was involuntarily not
> +              |             |             | running on a physical CPU.
> +
> +The structure will be updated by the hypervisor periodically as time is stolen
> +from the VCPU. It will be present within a reserved region of the normal
> +memory given to the guest. The guest should not attempt to write into this
> +memory. There is a structure by VCPU of the guest.
> +
> +User space interface
> +====================
> +
> +User space can request that KVM provide the paravirtualized time interface to
> +a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
> +
> +    struct kvm_create_device pvtime_device = {
> +            .type = KVM_DEV_TYPE_ARM_PV_TIME,
> +            .attr = 0,
> +            .flags = 0,
> +    };
> +
> +    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
> +
> +The guest IPA of the structures must be given to KVM. This is the base address
> +of an array of stolen time structures (one for each VCPU). For example:
> +
> +    struct kvm_device_attr st_base = {
> +            .group = KVM_DEV_ARM_PV_TIME_PADDR,
> +            .attr = KVM_DEV_ARM_PV_TIME_ST,
> +            .addr = (u64)(unsigned long)&st_paddr
> +    };
> +
> +    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &st_base);
> +
> +For migration (or save/restore) of a guest it is necessary to save the contents
> +of the shared page(s) and later restore them. KVM_DEV_ARM_PV_TIME_STATE_SIZE
> +provides the size of this data and KVM_DEV_ARM_PV_TIME_STATE allows the state
> +to be read/written.
> +
> +It is also necessary for the physical address to be set identically when
> +restoring.
> +
> +    void *save_state(int fd, u64 attr, u32 *size) {
> +        struct kvm_device_attr get_size = {
> +                .group = KVM_DEV_ARM_PV_TIME_STATE_SIZE,
> +                .attr = attr,
> +                .addr = (u64)(unsigned long)size
> +        };
> +
> +        ioctl(fd, KVM_GET_DEVICE_ATTR, get_size);
> +
> +        void *buffer = malloc(*size);
> +
> +        struct kvm_device_attr get_state = {
> +                .group = KVM_DEV_ARM_PV_TIME_STATE,
> +                .attr = attr,
> +                .addr = (u64)(unsigned long)size
> +        };
> +
> +        ioctl(fd, KVM_GET_DEVICE_ATTR, buffer);
> +    }
> +
> +    void *st_state = save_state(pvtime_fd, KVM_DEV_ARM_PV_TIME_ST, &st_size);
> +
> 

