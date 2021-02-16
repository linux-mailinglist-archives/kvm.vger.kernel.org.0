Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8D031CA7F
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 13:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhBPMTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 07:19:43 -0500
Received: from foss.arm.com ([217.140.110.172]:34094 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230081AbhBPMTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 07:19:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEE2CD6E;
        Tue, 16 Feb 2021 04:18:56 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44B793F73B;
        Tue, 16 Feb 2021 04:18:55 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Handle CMOs on Read Only memslots
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        Jianyong Wu <jianyong.wu@arm.com>
References: <20210211142738.1478292-1-maz@kernel.org>
 <4bfd380b-a654-c104-f424-a258bb142e34@arm.com>
 <6c127a2d4276b56205d2d28cc0b9ffc2@kernel.org>
Message-ID: <951ad762-3f9e-9469-7b71-e93b7cb554a2@arm.com>
Date:   Tue, 16 Feb 2021 12:19:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6c127a2d4276b56205d2d28cc0b9ffc2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Thank you for the explanations!

On 2/12/21 6:18 PM, Marc Zyngier wrote:
> Hi Alex,
>
> On 2021-02-12 17:12, Alexandru Elisei wrote:
>> Hi Marc,
>>
>> I've been trying to get my head around what the architecture says about CMOs, so
>> please bare with me if I misunderstood some things.
>
> No worries. I've had this patch for a few weeks now, and can't
> make up my mind about it. It does address an actual issue though,
> so I couldn't just discard it... ;-)
>
>> On 2/11/21 2:27 PM, Marc Zyngier wrote:
>>> It appears that when a guest traps into KVM because it is
>>> performing a CMO on a Read Only memslot, our handling of
>>> this operation is "slightly suboptimal", as we treat it as
>>> an MMIO access without a valid syndrome.
>>>
>>> The chances that userspace is adequately equiped to deal
>>> with such an exception being slim, it would be better to
>>> handle it in the kernel.
>>>
>>> What we need to provide is roughly as follows:
>>>
>>> (a) if a CMO hits writeable memory, handle it as a normal memory acess
>>> (b) if a CMO hits non-memory, skip it
>>> (c) if a CMO hits R/O memory, that's where things become fun:
>>>   (1) if the CMO is DC IVAC, the architecture says this should result
>>>       in a permission fault

For KVM to get a stage 2 fault, the IPA must already be mapped as writable in the
guest's stage 1 tables. If I read that right and you are suggesting that the guest
should get a permission fault, I don't think that's correct from the guest's
viewpoint.

>>>
>>>   (2) if the CMO is DC CIVAC, it should work similarly to (a)
>>
>> When you say it should work similarly to (a), you mean it should be handled as a
>> normal memory access, without the "CMO hits writeable memory" part, right?
>
> What I mean is that the cache invalidation should take place,
> preferably without involving KVM at all (other than populating
> S2 if required).
>
>>
>>>
>>> We already perform (a) and (b) correctly, but (c) is a total mess.
>>> Hence we need to distinguish between IVAC (c.1) and CIVAC (c.2).
>>>
>>> One way to do it is to treat CMOs generating a translation fault as
>>> a *read*, even when they are on a RW memslot. This allows us to
>>> further triage things:
>>>
>>> If they come back with a permission fault, that is because this is
>>> a DC IVAC instruction:
>>> - inside a RW memslot: no problem, treat it as a write (a)(c.2)
>>> - inside a RO memslot: inject a data abort in the guest (c.1)
>>>
>>> The only drawback is that DC IVAC on a yet unmapped page faults
>>> twice: one for the initial translation fault that result in a RO
>>> mapping, and once for the permission fault. I think we can live with
>>> that.
>>
>> I'm trying to make sure I understand what the problem is.
>>
>> gfn_to_pfn_prot() returnsKVM_HVA_ERR_RO_BAD if the write is to a RO memslot.
>> KVM_HVA_ERR_RO_BAD is PAGE_OFFSET + PAGE_SIZE, which means that
>> is_error_noslot_pfn() return true. In that case we exit to userspace
>> with -EFAULT
>> for DC IVAC and DC CIVAC. But what we should be doing is this:
>>
>> - For DC IVAC, inject a dabt with ISS = 0x10, meaning an external abort (that's
>> what kvm_inject_dabt_does()).
>>
>> - For DC CIVAC, exit to userspace with -EFAULT.
>>
>> Did I get that right?
>
> Not quite. What I *think* we should do is:
>
> - DC CIVAC should just work, without going to userspace. I can't imagine
>   a reason why we'd involve userspace for this, and we currently don't
>   really have a good way to describe this to userspace.
>
> - DC IVAC is more nuanced: we could either inject an exception (which
>   is what this patch does), or perform the CMO ourselves as a DC CIVAC
>   (consistent with the IVA->CIVA upgrade caused by having a S2 translation).
>   This second approach is comparable to what we do when the guest
>   issues a CMO on an emulated MMIO address (we don't inject a fault).

Here are my thoughts about this.

There is nothing that userspace can do regarding the CMO operations, so I agree
that we should handle this in the kernel.

If there is no memslot associated with the faulting IPA, then I don't think we can
do the CMO because there is no PA associated with the IPA.

Assuming the memslot associated with the fault IPA is readonly:

Writes coming from the guest are emulated, so whatever the guest writes will never
be in a dirty cache line. Cleaning that address would match what KVM_MEM_READONLY
API guarantees: "[..] In this case, writes to this memory will be posted to
userspace as KVM_EXIT_MMIO exits." No dirty cache line (from the guest's point of
view), nothing written to memory.

The cache line might be dirty for two reasons:

- This is the first time the guest accesses that memory location. No need to do
anything (neither cleaning, nor mapping  at stage 2), because the subsequent read
from the guest will map it at stage 2, and that will trigger the dcache cleaning
in user_mem_abort().

- Userspace wrote to the physical address as part of device emulation. It is
entirely reasonable for host userspace to assume that the RO memslot is mapped as
device memory by the guest, which means that the guest reads from main memory,
while host userspace writes to cache (assuming no FWB). In this case, I think it's
the host userspace's duty to do the dcache cleaning.

Because of the two reasons above, I think cleaning the dcache will have no effect
from a correctness perspective.

As for invalidating the cache line, beside the two scenarios above, a clean cache
line could have been allocated by a read, done either by the guest (if it mapped
the IPA as Normal cacheable) or by the host (CPU speculating loads or
userspace/kernel reading from the address). I think invalidating, just like
cleaning, would have no effect on the correctness of the emulation.

My opinion is that we should simply skip CMOs on read-only memslot.

What do you think?

Thanks,
Alex
> Thanks,
>
>         M.
