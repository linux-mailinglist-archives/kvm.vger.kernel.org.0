Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C143A877D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbfIDNzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 09:55:20 -0400
Received: from foss.arm.com ([217.140.110.172]:55286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729798AbfIDNzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 09:55:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5E6D1570;
        Wed,  4 Sep 2019 06:55:18 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA1DB3F59C;
        Wed,  4 Sep 2019 06:55:16 -0700 (PDT)
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
From:   Steven Price <steven.price@arm.com>
Message-ID: <118ceeea-5501-05b6-7232-e66a175d5fae@arm.com>
Date:   Wed, 4 Sep 2019 14:55:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190902125254.3w6lnvcbs7sfhjz7@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2019 13:52, Andrew Jones wrote:
> On Fri, Aug 30, 2019 at 04:25:08PM +0100, Steven Price wrote:
>> On 30/08/2019 15:47, Andrew Jones wrote:
>>> On Fri, Aug 30, 2019 at 09:42:46AM +0100, Steven Price wrote:
[...]
>>>> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>>>> +                              PV-time feature is supported by the hypervisor.
>>>> +
>>>> +PV_TIME_ST
>>>> +    Function ID:  (uint32)  : 0xC5000022
>>>> +    Return value: (int64)   : IPA of the stolen time data structure for this
>>>> +                              VCPU. On failure:
>>>> +                              NOT_SUPPORTED (-1)
>>>> +
>>>> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
>>>> +with inner and outer write back caching attributes, in the inner shareable
>>>> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
>>>> +meaningfully filled by the hypervisor (see structure below).
>>>> +
>>>> +PV_TIME_ST returns the structure for the calling VCPU.
>>>> +
>>>> +Stolen Time
>>>> +-----------
>>>> +
>>>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>>>> +
>>>> +  Field       | Byte Length | Byte Offset | Description
>>>> +  ----------- | ----------- | ----------- | --------------------------
>>>> +  Revision    |      4      |      0      | Must be 0 for version 0.1
>>>> +  Attributes  |      4      |      4      | Must be 0
>>>
>>> The above fields don't appear to be exposed to userspace in anyway. How
>>> will we handle migration from one KVM with one version of the structure
>>> to another?
>>
>> Interesting question. User space does have access to them now it is
>> providing the memory, but it's not exactly an easy method. In particular
>> user space has no (simple) way of probing the kernel's supported version.
>>
>> I guess one solution would be to add an extra attribute on the VCPU
>> which would provide the revision information. The current kernel would
>> then reject any revision other than 0, but this could then be extended
>> to support other revision numbers in the future.
>>
>> Although there's some logic in saying we could add the extra attribute
>> when(/if) there is a new version. Future kernels would then be expected
>> to use the current version unless user space explicitly set the new
>> attribute.
>>
>> Do you feel this is something that needs to be addressed now, or can it
>> be deferred until another version is proposed?
> 
> Assuming we'll want userspace to have the option of choosing version=0,
> and that we're fine with version=0 being the implicit choice, when nothing
> is selected, then I guess it can be left as is for now. If, OTOH, we just
> want migration to fail when attempting to migrate to another host with
> an incompatible stolen-time structure (i.e. version=0 is not selectable
> on hosts that implement later versions), then we should expose the version
> in some way now. Perhaps a VCPU's "PV config" should be described in a
> set of pseudo registers?

I wouldn't have thought making migration fail if/when the host upgrades
to a new version would be particularly helpful - we'd want to provide
backwards compatibility. In particular for the suspend/resume case (I
want to be able to save my VM to disk, upgrade the host kernel and then
resume the VM).

The only potential issue I see is the implicit "version=0 if not
specified". That seems solvable by rejecting setting the stolen time
base address if no version has been specified and the host kernel
doesn't support version=0.

>>
>>>> +  Stolen time |      8      |      8      | Stolen time in unsigned
>>>> +              |             |             | nanoseconds indicating how
>>>> +              |             |             | much time this VCPU thread
>>>> +              |             |             | was involuntarily not
>>>> +              |             |             | running on a physical CPU.
>>>> +
>>>> +The structure will be updated by the hypervisor prior to scheduling a VCPU. It
>>>> +will be present within a reserved region of the normal memory given to the
>>>> +guest. The guest should not attempt to write into this memory. There is a
>>>> +structure per VCPU of the guest.
>>>
>>> Should we provide a recommendation as to how that reserved memory is
>>> provided? One memslot divided into NR_VCPUS subregions? Should the
>>> reserved region be described to the guest kernel with DT/ACPI? Or
>>> should userspace ensure the region is not within any DT/ACPI described
>>> regions?
>>
>> I'm open to providing a recommendation, but I'm not entirely sure I know
>> enough here to provide one.
>>
>> There is an obvious efficiency argument for minimizing memslots with the
>> current code. But if someone has a reason for using multiple memslots
>> then that's probably a good argument for implementing a memslot-caching
>> kvm_put_user() rather than to be dis-recommended.
> 
> Actually even if a single memslot is used for all the PV structures for
> all VCPUs, but it's separate from the slot(s) used for main memory, then
> we'll likely see performance issues with memslot searches (even though
> it's a binary search). This is because memslots already have caching. The
> last used slot is stored in the memslots' lru_slot member (the "lru" name
> is confusing, but it means "last used" somehow). This means we could get
> thrashing on that slot cache if we're searching for the PV structure
> memslot on each vcpu load after searching for the main memory slot on each
> page fault.

True - a dedicated memslot for stolen time wouldn't be great if a VM is
needing to fault pages (which would obviously be in a different
memslot). I don't have a good idea of the overhead of missing in the
lru_slot cache. The main reason I stopped using a dedicated cache was
because I discovered that my initial implementation using
kvm_write_guest_offset_cached() (which wasn't single-copy atomic safe)
was actually failing to use the cache because the buffer crossed a page
boundary (see __kvm_gfn_to_hva_cache_init()). So switching away from the
"_cached" variant was actually avoiding the extra walks of the memslots.

I can look at reintroducing the caching for kvm_put_guest().

>>
>> My assumption (and testing) has been with a single memslot divided into
>> NR_VCPUS (or more accurately the number of VCPUs in the VM) subregions.
>>
>> For testing DT I've tested both methods: an explicit reserved region or
>> just ensuring it's not in any DT described region. Both seem reasonable,
>> but it might be easier to integrate into existing migration mechanisms
>> if it's simply a reserved region (then the memory block of the guest is
>> just as it always was).
>>
>> For ACPI the situation should be similar, but my testing has been with DT.
> 
> I also can't think of any reason why we'd have to describe it in DT/ACPI,
> but I get this feeling that if we don't, then we'll hit some issue that
> will make us wish we had...

Without knowing why we need it it's hard to justify what should go in
the bindings. But the idea of having the hypercalls is that the
description is returned via hypercalls rather than explicitly in
DT/ACPI. In theory we wouldn't need the hypercalls if it was fully
described in DT/ACPI.

Steve
