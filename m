Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740F581BA7
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbfHENQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:16:22 -0400
Received: from foss.arm.com ([217.140.110.172]:48182 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfHENGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:06:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C0D91597;
        Mon,  5 Aug 2019 06:06:11 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEB373F706;
        Mon,  5 Aug 2019 06:06:09 -0700 (PDT)
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
To:     Marc Zyngier <maz@kernel.org>
Cc:     peter.maydell@linaro.org, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com> <20190803121343.2f482200@why>
From:   Steven Price <steven.price@arm.com>
Message-ID: <9b2077d1-29f2-549a-fd61-f9c8d3730c9c@arm.com>
Date:   Mon, 5 Aug 2019 14:06:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803121343.2f482200@why>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/2019 12:13, Marc Zyngier wrote:
> On Fri,  2 Aug 2019 15:50:09 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
> [+Peter for the userspace aspect of things]
> 
> Hi Steve,
> 
>> Introduce a paravirtualization interface for KVM/arm64 based on the
>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>>
>> This only adds the details about "Stolen Time" as the details of "Live
>> Physical Time" have not been fully agreed.
>>
>> User space can specify a reserved area of memory for the guest and
>> inform KVM to populate the memory with information on time that the host
>> kernel has stolen from the guest.
>>
>> A hypercall interface is provided for the guest to interrogate the
>> hypervisor's support for this interface and the location of the shared
>> memory structures.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/virtual/kvm/arm/pvtime.txt | 107 +++++++++++++++++++++++
>>  1 file changed, 107 insertions(+)
>>  create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
>>
>> diff --git a/Documentation/virtual/kvm/arm/pvtime.txt b/Documentation/virtual/kvm/arm/pvtime.txt
>> new file mode 100644
>> index 000000000000..e6ae9799e1d5
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/arm/pvtime.txt
>> @@ -0,0 +1,107 @@
>> +Paravirtualized time support for arm64
>> +======================================
>> +
>> +Arm specification DEN0057/A defined a standard for paravirtualised time
>> +support for Aarch64 guests:
> 
> nit: AArch64
> 
>> +
>> +https://developer.arm.com/docs/den0057/a
> 
> Between this file and the above document, which one is authoritative?

The above document should be authoritative - although I'm still waiting
for the final version to be published. I'm not expecting any changes to
the stolen time part though.

>> +
>> +KVM/Arm64 implements the stolen time part of this specification by providing
> 
> nit: KVM/arm64
> 
>> +some hypervisor service calls to support a paravirtualized guest obtaining a
>> +view of the amount of time stolen from its execution.
>> +
>> +Two new SMCCC compatible hypercalls are defined:
>> +
>> +PV_FEATURES 0xC5000020
>> +PV_TIME_ST  0xC5000022
>> +
>> +These are only available in the SMC64/HVC64 calling convention as
>> +paravirtualized time is not available to 32 bit Arm guests.
>> +
>> +PV_FEATURES
>> +    Function ID:  (uint32)  : 0xC5000020
>> +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
>> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>> +                              PV-time feature is supported by the hypervisor.
> 
> How is PV_FEATURES discovered? Is the intention to make it a generic
> ARM-wide PV discovery mechanism, not specific to PV time?

SMCCC is mandated for PV time. So, assuming the hypervisor supports
SMCCC, the "NOT_SUPPORTED" return is mandated by SMCCC if PV time isn't
supported.

However, we do also use the SMCCC_ARCH_FEATURES mechanism to check the
existence of PV_FEATURES before use. I'll update the document to call
this out.

>> +
>> +PV_TIME_ST
>> +    Function ID:  (uint32)  : 0xC5000022
>> +    Return value: (int64)   : IPA of the stolen time data structure for this
>> +                              (V)CPU. On failure:
>> +                              NOT_SUPPORTED (-1)
>> +
> 
> Is the size implicit? What are the memory attributes? This either needs
> documenting here, or point to the right bit to the spec.

The size is implicit - it's a pointer to the below structure, so the
guest can only rely on the first 16 bytes being valid. The memory
attributes are described in the specification as:

"The calling guest can map the IPA into normal memory with inner and
outer write back caching attributes, in the inner sharable domain"

I'll put those details in this document for completeness.

>> +Stolen Time
>> +-----------
>> +
>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>> +
>> +  Field       | Byte Length | Byte Offset | Description
>> +  ----------- | ----------- | ----------- | --------------------------
>> +  Revision    |      4      |      0      | Must be 0 for version 0.1
>> +  Attributes  |      4      |      4      | Must be 0
>> +  Stolen time |      8      |      8      | Stolen time in unsigned
>> +              |             |             | nanoseconds indicating how
>> +              |             |             | much time this VCPU thread
>> +              |             |             | was involuntarily not
>> +              |             |             | running on a physical CPU.
>> +
>> +The structure will be updated by the hypervisor periodically as time is stolen
> 
> Is it really periodic? If so, when is the update frequency?

Hmm, periodic might be the wrong term - there is no guaranteed frequency
of update. The spec says:

"The hypervisor must update this value prior to scheduling a virtual CPU"

I guess that's probably the best description.

>> +from the VCPU. It will be present within a reserved region of the normal
>> +memory given to the guest. The guest should not attempt to write into this
>> +memory. There is a structure by VCPU of the guest.
> 
> What if the vcpu writes to it? Does it get a fault?

From the perspective from the specification this is undefined. A fault
would therefore be acceptable but isn't generated in the implementation
defined here.

> If there is a
> structure per vcpu, what is the layout in memory? How does a vcpu find
> its own data structure? Is that the address returned by PV_TIME_ST?

A call to PV_TIME_ST returns the structure for the calling vCPU - I'll
make that explicit. The layout is therefore defined by the hypervisor
and cannot be relied on by the guest. As below this implementation uses
a simple array of structures.

>> +
>> +User space interface
>> +====================
>> +
>> +User space can request that KVM provide the paravirtualized time interface to
>> +a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
>> +
>> +    struct kvm_create_device pvtime_device = {
>> +            .type = KVM_DEV_TYPE_ARM_PV_TIME,
>> +            .attr = 0,
>> +            .flags = 0,
>> +    };
>> +
>> +    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
>> +
>> +The guest IPA of the structures must be given to KVM. This is the base address
> 
> nit: s/guest //
> 
>> +of an array of stolen time structures (one for each VCPU). For example:
>> +
>> +    struct kvm_device_attr st_base = {
>> +            .group = KVM_DEV_ARM_PV_TIME_PADDR,
>> +            .attr = KVM_DEV_ARM_PV_TIME_ST,
>> +            .addr = (u64)(unsigned long)&st_paddr
>> +    };
>> +
>> +    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &st_base);
> 
> So the allocation itself is performed by the kernel? What are the
> ordering requirements between creating vcpus and the device? What are
> the alignment requirements for the base address?

The base address should be page aligned - I'll spell that out.

There are currently no ordering requirements between creating vcpus and
the device. However...

>> +
>> +For migration (or save/restore) of a guest it is necessary to save the contents
>> +of the shared page(s) and later restore them. KVM_DEV_ARM_PV_TIME_STATE_SIZE
>> +provides the size of this data and KVM_DEV_ARM_PV_TIME_STATE allows the state
>> +to be read/written.
> 
> Is the size variable depending on the number of vcpus?

...yes - so restoring the state after migration must be done after
creating the vcpus. I'll point out that the device should created after.

Thanks for the review,

Steve
