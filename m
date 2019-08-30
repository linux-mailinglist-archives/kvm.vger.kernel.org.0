Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21FC3A3A49
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfH3PZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 11:25:14 -0400
Received: from foss.arm.com ([217.140.110.172]:33962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfH3PZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 11:25:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6A8E344;
        Fri, 30 Aug 2019 08:25:12 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B2653F703;
        Fri, 30 Aug 2019 08:25:10 -0700 (PDT)
Subject: Re: [PATCH v4 01/10] KVM: arm64: Document PV-time interface
To:     Andrew Jones <drjones@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-2-steven.price@arm.com>
 <20190830144734.kvj4dvt32qzmhw32@kamzik.brq.redhat.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <7f459290-9c39-cfba-c514-a07469ff120f@arm.com>
Date:   Fri, 30 Aug 2019 16:25:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830144734.kvj4dvt32qzmhw32@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/2019 15:47, Andrew Jones wrote:
> On Fri, Aug 30, 2019 at 09:42:46AM +0100, Steven Price wrote:
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
>>  Documentation/virt/kvm/arm/pvtime.txt   | 64 +++++++++++++++++++++++++
>>  Documentation/virt/kvm/devices/vcpu.txt | 14 ++++++
>>  2 files changed, 78 insertions(+)
>>  create mode 100644 Documentation/virt/kvm/arm/pvtime.txt
>>
>> diff --git a/Documentation/virt/kvm/arm/pvtime.txt b/Documentation/virt/kvm/arm/pvtime.txt
>> new file mode 100644
>> index 000000000000..dda3f0f855b9
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/arm/pvtime.txt
>> @@ -0,0 +1,64 @@
>> +Paravirtualized time support for arm64
>> +======================================
>> +
>> +Arm specification DEN0057/A defined a standard for paravirtualised time
>> +support for AArch64 guests:
>> +
>> +https://developer.arm.com/docs/den0057/a
>> +
>> +KVM/arm64 implements the stolen time part of this specification by providing
>> +some hypervisor service calls to support a paravirtualized guest obtaining a
>> +view of the amount of time stolen from its execution.
>> +
>> +Two new SMCCC compatible hypercalls are defined:
>> +
>> +PV_FEATURES 0xC5000020
>> +PV_TIME_ST  0xC5000022
>> +
>> +These are only available in the SMC64/HVC64 calling convention as
>> +paravirtualized time is not available to 32 bit Arm guests. The existence of
>> +the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
>> +mechanism before calling it.
>> +
>> +PV_FEATURES
>> +    Function ID:  (uint32)  : 0xC5000020
>> +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
> 
> PV_TIME_LPT doesn't exist

Thanks, will remove.

>> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>> +                              PV-time feature is supported by the hypervisor.
>> +
>> +PV_TIME_ST
>> +    Function ID:  (uint32)  : 0xC5000022
>> +    Return value: (int64)   : IPA of the stolen time data structure for this
>> +                              VCPU. On failure:
>> +                              NOT_SUPPORTED (-1)
>> +
>> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
>> +with inner and outer write back caching attributes, in the inner shareable
>> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
>> +meaningfully filled by the hypervisor (see structure below).
>> +
>> +PV_TIME_ST returns the structure for the calling VCPU.
>> +
>> +Stolen Time
>> +-----------
>> +
>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>> +
>> +  Field       | Byte Length | Byte Offset | Description
>> +  ----------- | ----------- | ----------- | --------------------------
>> +  Revision    |      4      |      0      | Must be 0 for version 0.1
>> +  Attributes  |      4      |      4      | Must be 0
> 
> The above fields don't appear to be exposed to userspace in anyway. How
> will we handle migration from one KVM with one version of the structure
> to another?

Interesting question. User space does have access to them now it is
providing the memory, but it's not exactly an easy method. In particular
user space has no (simple) way of probing the kernel's supported version.

I guess one solution would be to add an extra attribute on the VCPU
which would provide the revision information. The current kernel would
then reject any revision other than 0, but this could then be extended
to support other revision numbers in the future.

Although there's some logic in saying we could add the extra attribute
when(/if) there is a new version. Future kernels would then be expected
to use the current version unless user space explicitly set the new
attribute.

Do you feel this is something that needs to be addressed now, or can it
be deferred until another version is proposed?

>> +  Stolen time |      8      |      8      | Stolen time in unsigned
>> +              |             |             | nanoseconds indicating how
>> +              |             |             | much time this VCPU thread
>> +              |             |             | was involuntarily not
>> +              |             |             | running on a physical CPU.
>> +
>> +The structure will be updated by the hypervisor prior to scheduling a VCPU. It
>> +will be present within a reserved region of the normal memory given to the
>> +guest. The guest should not attempt to write into this memory. There is a
>> +structure per VCPU of the guest.
> 
> Should we provide a recommendation as to how that reserved memory is
> provided? One memslot divided into NR_VCPUS subregions? Should the
> reserved region be described to the guest kernel with DT/ACPI? Or
> should userspace ensure the region is not within any DT/ACPI described
> regions?

I'm open to providing a recommendation, but I'm not entirely sure I know
enough here to provide one.

There is an obvious efficiency argument for minimizing memslots with the
current code. But if someone has a reason for using multiple memslots
then that's probably a good argument for implementing a memslot-caching
kvm_put_user() rather than to be dis-recommended.

My assumption (and testing) has been with a single memslot divided into
NR_VCPUS (or more accurately the number of VCPUs in the VM) subregions.

For testing DT I've tested both methods: an explicit reserved region or
just ensuring it's not in any DT described region. Both seem reasonable,
but it might be easier to integrate into existing migration mechanisms
if it's simply a reserved region (then the memory block of the guest is
just as it always was).

For ACPI the situation should be similar, but my testing has been with DT.

Thanks,

Steve

>> +
>> +For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
>> +section "3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL".
>> +
>> diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
>> index 2b5dab16c4f2..896777f76f36 100644
>> --- a/Documentation/virt/kvm/devices/vcpu.txt
>> +++ b/Documentation/virt/kvm/devices/vcpu.txt
>> @@ -60,3 +60,17 @@ time to use the number provided for a given timer, overwriting any previously
>>  configured values on other VCPUs.  Userspace should configure the interrupt
>>  numbers on at least one VCPU after creating all VCPUs and before running any
>>  VCPUs.
>> +
>> +3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
>> +Architectures: ARM64
>> +
>> +3.1 ATTRIBUTE: KVM_ARM_VCPU_PVTIME_SET_IPA
>> +Parameters: 64-bit base address
>> +Returns: -ENXIO:  Stolen time not implemented
>> +         -EEXIST: Base address already set for this VCPU
>> +         -EINVAL: Base address not 64 byte aligned
>> +
>> +Specifies the base address of the stolen time structure for this VCPU. The
>> +base address must be 64 byte aligned and exist within a valid guest memory
>> +region. See Documentation/virt/kvm/arm/pvtime.txt for more information
>> +including the layout of the stolen time structure.
>> -- 
>> 2.20.1
>>
> 
> Thanks,
> drew 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

