Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFADA8945
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfIDPHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:07:43 -0400
Received: from foss.arm.com ([217.140.110.172]:57036 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730717AbfIDPHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:07:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9ED8628;
        Wed,  4 Sep 2019 08:07:42 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B2783F246;
        Wed,  4 Sep 2019 08:07:40 -0700 (PDT)
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
 <7f459290-9c39-cfba-c514-a07469ff120f@arm.com>
 <20190902125254.3w6lnvcbs7sfhjz7@kamzik.brq.redhat.com>
 <118ceeea-5501-05b6-7232-e66a175d5fae@arm.com>
 <20190904142250.ohnkunb5ocwbnx6z@kamzik.brq.redhat.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <9ebbfde3-d592-b9c5-4456-a28a2f6e9125@arm.com>
Date:   Wed, 4 Sep 2019 16:07:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904142250.ohnkunb5ocwbnx6z@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/2019 15:22, Andrew Jones wrote:
> On Wed, Sep 04, 2019 at 02:55:15PM +0100, Steven Price wrote:
>> On 02/09/2019 13:52, Andrew Jones wrote:
>>> On Fri, Aug 30, 2019 at 04:25:08PM +0100, Steven Price wrote:
>>>> On 30/08/2019 15:47, Andrew Jones wrote:
>>>>> On Fri, Aug 30, 2019 at 09:42:46AM +0100, Steven Price wrote:
>> [...]
>>>>>> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>>>>>> +                              PV-time feature is supported by the hypervisor.
>>>>>> +
>>>>>> +PV_TIME_ST
>>>>>> +    Function ID:  (uint32)  : 0xC5000022
>>>>>> +    Return value: (int64)   : IPA of the stolen time data structure for this
>>>>>> +                              VCPU. On failure:
>>>>>> +                              NOT_SUPPORTED (-1)
>>>>>> +
>>>>>> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
>>>>>> +with inner and outer write back caching attributes, in the inner shareable
>>>>>> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
>>>>>> +meaningfully filled by the hypervisor (see structure below).
>>>>>> +
>>>>>> +PV_TIME_ST returns the structure for the calling VCPU.
>>>>>> +
>>>>>> +Stolen Time
>>>>>> +-----------
>>>>>> +
>>>>>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>>>>>> +
>>>>>> +  Field       | Byte Length | Byte Offset | Description
>>>>>> +  ----------- | ----------- | ----------- | --------------------------
>>>>>> +  Revision    |      4      |      0      | Must be 0 for version 0.1
>>>>>> +  Attributes  |      4      |      4      | Must be 0
>>>>>
>>>>> The above fields don't appear to be exposed to userspace in anyway. How
>>>>> will we handle migration from one KVM with one version of the structure
>>>>> to another?
>>>>
>>>> Interesting question. User space does have access to them now it is
>>>> providing the memory, but it's not exactly an easy method. In particular
>>>> user space has no (simple) way of probing the kernel's supported version.
>>>>
>>>> I guess one solution would be to add an extra attribute on the VCPU
>>>> which would provide the revision information. The current kernel would
>>>> then reject any revision other than 0, but this could then be extended
>>>> to support other revision numbers in the future.
>>>>
>>>> Although there's some logic in saying we could add the extra attribute
>>>> when(/if) there is a new version. Future kernels would then be expected
>>>> to use the current version unless user space explicitly set the new
>>>> attribute.
>>>>
>>>> Do you feel this is something that needs to be addressed now, or can it
>>>> be deferred until another version is proposed?
>>>
>>> Assuming we'll want userspace to have the option of choosing version=0,
>>> and that we're fine with version=0 being the implicit choice, when nothing
>>> is selected, then I guess it can be left as is for now. If, OTOH, we just
>>> want migration to fail when attempting to migrate to another host with
>>> an incompatible stolen-time structure (i.e. version=0 is not selectable
>>> on hosts that implement later versions), then we should expose the version
>>> in some way now. Perhaps a VCPU's "PV config" should be described in a
>>> set of pseudo registers?
>>
>> I wouldn't have thought making migration fail if/when the host upgrades
>> to a new version would be particularly helpful - we'd want to provide
>> backwards compatibility. In particular for the suspend/resume case (I
>> want to be able to save my VM to disk, upgrade the host kernel and then
>> resume the VM).
>>
>> The only potential issue I see is the implicit "version=0 if not
>> specified". That seems solvable by rejecting setting the stolen time
>> base address if no version has been specified and the host kernel
>> doesn't support version=0.
> 
> I think that's the same failure I was trying avoid by failing the
> migration instead. Maybe it's equivalent to fail at this vcpu-ioctl
> time though?

Yes this is effectively the same failure. But since we require the
vcpu-ioctl to enable stolen time this gives an appropriate place to
fail. Indeed this is the failure if migrating from a host with these
patches to one running an existing kernel with no stolen time support.

Steve
