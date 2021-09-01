Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965E53FDF64
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbhIAQJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241143AbhIAQJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 12:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 835C46103A;
        Wed,  1 Sep 2021 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630512487;
        bh=CGRr6nYqgnqjd/OYRrpKynPEeJKzCb5cQOkP2sb5HJE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PRT0Xq1/vQ/2yiwbTRtyAMGE1kvM0tORl3cnio+QSVu7fjyQtNfxnNk7y4hu1t6qz
         l8O9rJE2YCnqXMDBt4W0k6w/UdK32hh+AnVZp7LR7KcqdlHnUnPXA/Wf2XDxt03c28
         Zwqqw98fY1sotEaWuuwo/mMP+M/Lk9tPB4KoYPfkmwXFQaSdriQJptIP+aWYy44uHk
         T9ZokBMm+y3yehwGtTG8r1yy57OZdVc5bg9BdCK0PsO1UQwDzWIjjI+8r7vDOx2J9E
         BJVRWcjHIJEL8mIivY/+hmZMLws4zAPoqDGrL0iVu34GSsRt1DykPhkeSc00dz2dYv
         p2OqVvzNjSPeg==
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
Date:   Wed, 1 Sep 2021 09:07:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/21 3:24 AM, Yu Zhang wrote:
> On Tue, Aug 31, 2021 at 09:53:27PM -0700, Andy Lutomirski wrote:
>>
>>
>> On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
>>> On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
>>
>>> Thanks a lot for this summary. A question about the requirement: do we or
>>> do we not have plan to support assigned device to the protected VM?
>>>
>>> If yes. The fd based solution may need change the VFIO interface as well(
>>> though the fake swap entry solution need mess with VFIO too). Because:
>>>
>>> 1> KVM uses VFIO when assigning devices into a VM.
>>>
>>> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
>>> guest pages will have to be mapped in host IOMMU page table to host pages,
>>> which are pinned during the whole life cycle fo the VM.
>>>
>>> 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
>>> in vfio_dma_do_map().
>>>
>>> 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
>>> and pin the page. 
>>>
>>> But if we are using fd based solution, not every GPA can have a HVA, thus
>>> the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
>>> doubt if VFIO can be modified to support this easily.
>>>
>>>
>>
>> Do you mean assigning a normal device to a protected VM or a hypothetical protected-MMIO device?
>>
>> If the former, it should work more or less like with a non-protected VM. mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether anyone will actually do this, but it should be possible, at least in principle.  Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device with the understanding that the guest can't trust it wouldn't be entirely crazy ether.
>>
>> If the latter, AFAIK there is no spec for how it would work even in principle. Presumably it wouldn't work quite like VFIO -- instead, the kernel could have a protection-virtual-io-fd mechanism, and that fd could be bound to a memslot in whatever way we settle on for binding secure memory to a memslot.
>>
> 
> Thanks Andy. I was asking the first scenario.
> 
> Well, I agree it is doable if someone really want some assigned
> device in TD guest. As Kevin mentioned in his reply, HPA can be
> generated, by extending VFIO with a new mapping protocol which
> uses fd+offset, instead of HVA. 

I'm confused.  I don't see why any new code is needed for this at all.
Every proposal I've seen for handling TDX memory continues to handle TDX
*shared* memory exactly like regular guest memory today.  The only
differences are that more hole punching will be needed, which will
require lightweight memslots (to have many of them), memslots with
holes, or mappings backing memslots with holes (which can be done with
munmap() on current kernels).

So you can literally just mmap a VFIO device and expect it to work,
exactly like it does right now.  Whether the guest will be willing to
use the device will depend on the guest security policy (all kinds of
patches about that are flying around), but if the guest tries to use it,
it really should just work.

> 
> Another issue is current TDX does not support DMA encryption, and
> only shared GPA memory shall be mapped in the VT-d. So to support
> this, KVM may need to work with VFIO to dynamically program host
> IOPT(IOMMU Page Table) when TD guest notifies a shared GFN range(e.g.,
> with a MAP_GPA TDVMCALL), instead of prepopulating the IOPT at VM
> creation time, by mapping entire GFN ranges of a guest.

Given that there is no encrypted DMA support, shouldn't the only IOMMU
mappings (real host-side IOMMU) that point at guest memory be for
non-encrypted DMA?  I don't see how this interacts at all.  If the guest
tries to MapGPA to turn a shared MMIO page into private, the host should
fail the hypercall because the operation makes no sense.

It is indeed the case that, with a TDX guest, MapGPA shared->private to
a page that was previously used for unencrypted DMA will need to avoid
having IOPT entries to the new private page, but even that doesn't seem
particularly bad.  The fd+special memslot proposal for private memory
means that shared *backing store* pages never actually transition
between shared and private without being completely freed.

As far as I can tell, the actual problem you're referring to is:

>>> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
>>> guest pages will have to be mapped in host IOMMU page table to host
pages,
>>> which are pinned during the whole life cycle fo the VM.

In principle, you could actually initialize a TDX guest with all of its
memory shared and all of it mapped in the host IOMMU.  When a guest
turns some pages private, user code could punch a hole in the memslot,
allocate private memory at that address, but leave the shared backing
store in place and still mapped in the host IOMMU.  The result would be
that guest-initiated DMA to the previously shared address would actually
work but would hit pages that are invisible to the guest.  And a whole
bunch of memory would be waste, but the whole system should stll work.

Improving this may well need VFIO changes, but I think those would be
roughly the same pages needed to have VFIO DMA be filtered through a
guest-controlled virtual IOMMU and wouldn't have anything to do with
private memory per se.

--Andy
