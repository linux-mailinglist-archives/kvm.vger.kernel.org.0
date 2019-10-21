Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC96DEE1F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfJUNlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 09:41:09 -0400
Received: from [217.140.110.172] ([217.140.110.172]:52994 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfJUNk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 09:40:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BE061007;
        Mon, 21 Oct 2019 06:40:34 -0700 (PDT)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B15A43F718;
        Mon, 21 Oct 2019 06:40:32 -0700 (PDT)
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
 <20191018171039.GA18838@lakrids.cambridge.arm.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <d01edcb3-0d9a-d4ec-6a60-a82f3ffccba5@arm.com>
Date:   Mon, 21 Oct 2019 14:40:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018171039.GA18838@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2019 18:10, Mark Rutland wrote:
> On Tue, Oct 15, 2019 at 06:56:51PM +0100, Mark Rutland wrote:
[...]
>>> +PV_TIME_ST
>>> +    ============= ========    ==========
>>> +    Function ID:  (uint32)    0xC5000021
>>> +    Return value: (int64)     IPA of the stolen time data structure for this
>>> +                              VCPU. On failure:
>>> +                              NOT_SUPPORTED (-1)
>>> +    ============= ========    ==========
>>> +
>>> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
>>> +with inner and outer write back caching attributes, in the inner shareable
>>> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
>>> +meaningfully filled by the hypervisor (see structure below).
>>
>> At what granularity is this allowed to share IPA space with other
>> mappings? The spec doesn't provide any guidance here, and I strongly
>> suspect that it should.
>>
>> To support a 64K guest, we must ensure that this doesn't share a 64K IPA
>> granule with any MMIO, and it probably only makes sense for an instance
>> of this structure to share that granule with another vCPU's structure.
>>
>> We probably _also_ want to ensure that this doesn't share a 64K granule
>> with memory the guest sees as regular system RAM. Otherwise we're liable
>> to force it into having mismatched attributes for any of that RAM it
>> happens to map as part of mapping the PV_TIME_ST structure.
> 
> I guess we can say that it's userspace's responsibiltiy to set this up
> with sufficient alignment, but I do think we want to make a
> recommendataion here.

I can add something like this to the kernel's documentation:

    It is advisable that one or more 64k pages are set aside for the
    purpose of these structures and not used for other purposes, this
    enables the guest to map the region using 64k pages and avoids
    conflicting attributes with other memory.

> [...]
> 
>>> +PV_TIME_ST returns the structure for the calling VCPU.
>>> +
>>> +Stolen Time
>>> +-----------
>>> +
>>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>>> +
>>> ++-------------+-------------+-------------+----------------------------+
>>> +| Field       | Byte Length | Byte Offset | Description                |
>>> ++=============+=============+=============+============================+
>>> +| Revision    |      4      |      0      | Must be 0 for version 1.0  |
>>> ++-------------+-------------+-------------+----------------------------+
>>> +| Attributes  |      4      |      4      | Must be 0                  |
>>> ++-------------+-------------+-------------+----------------------------+
>>> +| Stolen time |      8      |      8      | Stolen time in unsigned    |
>>> +|             |             |             | nanoseconds indicating how |
>>> +|             |             |             | much time this VCPU thread |
>>> +|             |             |             | was involuntarily not      |
>>> +|             |             |             | running on a physical CPU. |
>>> ++-------------+-------------+-------------+----------------------------+
>>> +
>>> +All values in the structure are stored little-endian.
>>
>> Looking at the published DEN 0057A, endianness is never stated. Is this
>> going to be corrected in the next release?
> 
> I'm assuming that this has been communicated internally, and we can
> assume the next rev of the spec will state so.

Yes I've fed that back, so hopefully it should be in the next rev of the
spec.

> Assuming so, this looks good to me.

Great, thanks for the review.

Steve
