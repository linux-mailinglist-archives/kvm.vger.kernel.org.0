Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A6BDA89C
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 11:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393745AbfJQJlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 05:41:23 -0400
Received: from [217.140.110.172] ([217.140.110.172]:37042 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2408545AbfJQJlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 05:41:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87CCC1993;
        Thu, 17 Oct 2019 02:41:00 -0700 (PDT)
Received: from [10.1.194.43] (unknown [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03C673F718;
        Thu, 17 Oct 2019 02:40:58 -0700 (PDT)
Subject: Re: [PATCH v6 01/10] KVM: arm64: Document PV-time interface
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-2-steven.price@arm.com>
 <20191015175651.GF24604@lakrids.cambridge.arm.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <be7ef86e-37f5-040b-bcb9-3c36df9f3fe3@arm.com>
Date:   Thu, 17 Oct 2019 10:40:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015175651.GF24604@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/2019 18:56, Mark Rutland wrote:
> Hi Steven,
> 
> On Fri, Oct 11, 2019 at 01:59:21PM +0100, Steven Price wrote:
>> Introduce a paravirtualization interface for KVM/arm64 based on the
>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
> 
> I notice that as published, this is a BETA Draft, with the explicit
> note:
> 
> | This document is for review purposes only and should not be used
> | for any implementation as changes are likely.
> 
> ... what's the plan for getting a finalised version published?

Sadly this wasn't handled very well, there's actually *two* documents
called DEN/0057A:

 * The draft[1] which contains the text above and previous postings were
based on

 * The final[2] document which this latest series is updated to.

At least for me if you visit the short form link[3] you can only get to
the released version - the version drop down gives you two choices ('a'
or 'a') but both get you to the same place.

[1]
https://static.docs.arm.com/den0057/a/den0057a_paravirtualized_time_for_arm-based_systems_beta-2.pdf
[2]
https://static.docs.arm.com/den0057/a/DEN0057A_Paravirtualized_Time_for_Arm-based_Systems_v1.0.pdf
[3] https://developer.arm.com/docs/den0057/a

>> This only adds the details about "Stolen Time" as the details of "Live
>> Physical Time" have not been fully agreed.
> 
> ... and what do we expect to happen on this front?
> 
> AFAICT, the spec hasn't changed since I called out issues in that area:
> 
>   https://lore.kernel.org/r/20181210114047.tifwh6ilwzphsbqy@lakrids.cambridge.arm.com
> 
> ... and I'd feel much happier about supporting this if that were dropped
> from the finalised spec.

LPT has been dropped from the final spec (and annoyingly the SMC values
re-assigned). I can't say for sure what the long-term future of LPT is
going to be, but for now it's gone.

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
>>  Documentation/virt/kvm/arm/pvtime.rst   | 77 +++++++++++++++++++++++++
>>  Documentation/virt/kvm/devices/vcpu.txt | 14 +++++
>>  2 files changed, 91 insertions(+)
>>  create mode 100644 Documentation/virt/kvm/arm/pvtime.rst
>>
>> diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
>> new file mode 100644
>> index 000000000000..de949933ec78
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/arm/pvtime.rst
>> @@ -0,0 +1,77 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +Paravirtualized time support for arm64
>> +======================================
>> +
>> +Arm specification DEN0057/A defines a standard for paravirtualised time
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
>> +* PV_TIME_FEATURES: 0xC5000020
>> +* PV_TIME_ST:       0xC5000021
>> +
>> +These are only available in the SMC64/HVC64 calling convention as
>> +paravirtualized time is not available to 32 bit Arm guests. The existence of
>> +the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
>> +mechanism before calling it.
>> +
>> +PV_TIME_FEATURES
>> +    ============= ========    ==========
>> +    Function ID:  (uint32)    0xC5000020
>> +    PV_call_id:   (uint32)    The function to query for support.
>> +                              Currently only PV_TIME_ST is supported.
>> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>> +                              PV-time feature is supported by the hypervisor.
>> +    ============= ========    ==========
>> +
>> +PV_TIME_ST
>> +    ============= ========    ==========
>> +    Function ID:  (uint32)    0xC5000021
>> +    Return value: (int64)     IPA of the stolen time data structure for this
>> +                              VCPU. On failure:
>> +                              NOT_SUPPORTED (-1)
>> +    ============= ========    ==========
>> +
>> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
>> +with inner and outer write back caching attributes, in the inner shareable
>> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
>> +meaningfully filled by the hypervisor (see structure below).
> 
> At what granularity is this allowed to share IPA space with other
> mappings? The spec doesn't provide any guidance here, and I strongly
> suspect that it should.
> 
> To support a 64K guest, we must ensure that this doesn't share a 64K IPA
> granule with any MMIO, and it probably only makes sense for an instance
> of this structure to share that granule with another vCPU's structure.
> 
> We probably _also_ want to ensure that this doesn't share a 64K granule
> with memory the guest sees as regular system RAM. Otherwise we're liable
> to force it into having mismatched attributes for any of that RAM it
> happens to map as part of mapping the PV_TIME_ST structure.

Good points, but this is no different from any other 'device' that is
mapped into the guest space (e.g. you don't want a serial port sharing
the same 64K page with memory for the same reasons). Ultimately user
space must arrange the memory layout appropriately for the guest. Of
course we can request this guidance to be added in the next release of
the spec.

>> +
>> +PV_TIME_ST returns the structure for the calling VCPU.
>> +
>> +Stolen Time
>> +-----------
>> +
>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>> +
>> ++-------------+-------------+-------------+----------------------------+
>> +| Field       | Byte Length | Byte Offset | Description                |
>> ++=============+=============+=============+============================+
>> +| Revision    |      4      |      0      | Must be 0 for version 1.0  |
>> ++-------------+-------------+-------------+----------------------------+
>> +| Attributes  |      4      |      4      | Must be 0                  |
>> ++-------------+-------------+-------------+----------------------------+
>> +| Stolen time |      8      |      8      | Stolen time in unsigned    |
>> +|             |             |             | nanoseconds indicating how |
>> +|             |             |             | much time this VCPU thread |
>> +|             |             |             | was involuntarily not      |
>> +|             |             |             | running on a physical CPU. |
>> ++-------------+-------------+-------------+----------------------------+
>> +
>> +All values in the structure are stored little-endian.
> 
> Looking at the published DEN 0057A, endianness is never stated. Is this
> going to be corrected in the next release?

I've provided feedback that this should be explicit in the next revision
of the spec. So yes, I expect this to be stated. For now though, Linux
has to make a decision so I've documented it here.

Steve
