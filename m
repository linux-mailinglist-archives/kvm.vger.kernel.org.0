Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4367932E8
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 02:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239409AbjIFAaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 20:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjIFAaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 20:30:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FB1E1B4;
        Tue,  5 Sep 2023 17:30:04 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5EA711FB;
        Tue,  5 Sep 2023 17:30:41 -0700 (PDT)
Received: from [10.57.5.192] (unknown [10.57.5.192])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2A663F64C;
        Tue,  5 Sep 2023 17:30:02 -0700 (PDT)
Message-ID: <5ff1591c-d41c-331f-84a6-ac690c48ff5d@arm.com>
Date:   Wed, 6 Sep 2023 01:29:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
 <ZN0S28lkbo6+D7aF@google.com> <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
 <ZN5elYQ5szQndN8n@google.com> <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
 <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com> <ZPd6Y9KJ0FfbCa0Q@google.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZPd6Y9KJ0FfbCa0Q@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-09-05 19:59, Sean Christopherson wrote:
> +swiotbl maintainers and Linus
> 
> Spinning off a discussion about swiotlb behavior to its own thread.
> 
> Quick background: when running Linux as a KVM guest, Yan observed memory accesses
> where Linux is reading completely uninitialized memory (never been written by the
> guest) and traced it back to this code in the swiotlb:
> 
> 	/*
> 	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
> 	 * to the tlb buffer, if we knew for sure the device will
> 	 * overwrite the entire current content. But we don't. Thus
> 	 * unconditional bounce may prevent leaking swiotlb content (i.e.
> 	 * kernel memory) to user-space.
> 	 */
> 	swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
> 
> The read-before-write behavior results in suboptimal performance as KVM maps the
> memory as read-only, and then triggers CoW when the guest inevitably writes the
> memory (CoW is significantly more expensive when KVM is involved).
> 
> There are a variety of ways to workaround this in KVM, but even if we decide to
> address this in KVM, the swiotlb behavior is sketchy.  Not to mention that any
> KVM changes are highly unlikely to be backported to LTS kernels.
> 
> On Mon, Sep 04, 2023, Yan Zhao wrote:
>> ...
>>>> Actually, I don't even completely understand how you're seeing CoW behavior in
>>>> the first place.  No sane guest should blindly read (or execute) uninitialized
>>>> memory.  IIUC, you're not running a Windows guest, and even if you are, AFAIK
>>>> QEMU doesn't support Hyper-V's enlightment that lets the guest assume memory has
>>>> been zeroed by the hypervisor.  If KSM is to blame, then my answer it to turn off
>>>> KSM, because turning on KSM is antithetical to guest performance (not to mention
>>>> that KSM is wildly insecure for the guest, especially given the number of speculative
>>>> execution attacks these days).
>>> I'm running a linux guest.
>>> KSM is not turned on both in guest and host.
>>> Both guest and host have turned on transparent huge page.
>>>
>>> The guest first reads a GFN in a writable memslot (which is for "pc.ram"),
>>> which will cause
>>>      (1) KVM first sends a GUP without FOLL_WRITE, leaving a huge_zero_pfn or a zero-pfn
>>>          mapped.
>>>      (2) KVM calls get_user_page_fast_only() with FOLL_WRITE as the memslot is writable,
>>>          which will fail
>>>
>>> The guest then writes the GFN.
>>> This step will trigger (huge pmd split for huge page case) and .change_pte().
>>>
>>> My guest is surely a sane guest. But currently I can't find out why
>>> certain pages are read before write.
>>> Will return back to you the reason after figuring it out after my long vacation.
>> Finally I figured out the reason.
>>
>> Except 4 pages were read before written from vBIOS (I just want to skip finding
>> out why vBIOS does this), the remaining thousands of pages were read before
>> written from the guest Linux kernel.
> 
> ...
> 
>> When the guest kernel triggers a guest block device read ahead, pages are
>> allocated as page cache pages, and requests to read disk data into the page
>> cache are issued.
>>
>> The disk data read requests will cause dma_direct_map_page() called if vIOMMU
>> is not enabled. Then, because the virtual IDE device can only direct access
>> 32-bit DMA address (equal to GPA) at maximum, swiotlb will be used as DMA
>> bounce if page cache pages are with GPA > 32 bits.
>>
>> Then the call path is
>> dma_direct_map_page() --> swiotlb_map() -->swiotlb_tbl_map_single()
>>
>> In swiotlb_tbl_map_single(), though DMA direction is DMA_FROM_DEVICE,
>> this swiotlb_tbl_map_single() will call
>> swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE) to read page cache
>> content to the bounce buffer first.
>> Then, during device DMAs, device content is DMAed into the bounce buffer.
>> After that, the bounce buffer data will be copied back to the page cache page
>> after calling dma_direct_unmap_page() --> swiotlb_tbl_unmap_single().
>>
>>
>> IOW, before reading ahead device data into the page cache, the page cache is
>> read and copied to the bounce buffer, though an immediate write is followed to
>> copy bounce buffer data back to the page cache.
>>
>> This explains why it's observed in host that most pages are written immediately
>> after it's read, and .change_pte() occurs heavily during guest boot-up and
>> nested guest boot-up, -- when disk readahead happens abundantly.
>>
>> The reason for this unconditional read of page into bounce buffer
>> (caused by "swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE)")
>> is explained in the code:
>>
>> /*
>>   * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
>>   * to the tlb buffer, if we knew for sure the device will
>>   * overwrite the entire current content. But we don't. Thus
>>   * unconditional bounce may prevent leaking swiotlb content (i.e.
>>   * kernel memory) to user-space.
>>   */
>>
>> If we neglect this risk and do changes like
>> -       swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
>> +       if (dir != DMA_FROM_DEVICE)
>> +               swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
>>
>> the issue of pages read before written from guest kernel just went away.
>>
>> I don't think it's a swiotlb bug, because to prevent leaking swiotlb
>> content, if target page content is not copied firstly to the swiotlb's
>> bounce buffer, then the bounce buffer needs to be initialized to 0.
>> However, swiotlb_tbl_map_single() does not know whether the target page
>> is initialized or not. Then, it would cause page content to be trimmed
>> if device does not overwrite the entire memory.
> 
> The math doesn't add up though.  Observing a read-before-write means the intended
> goal of preventing data leaks to userspace is not being met.  I.e. instead of
> leaking old swiotlb, the kernel is (theoretically) leaking whatever data is in the
> original page (page cache in your case).

Sure, it copies the destination page into the SWIOTLB buffer on map, 
then copies it back out again on unmap, so it's only "leaking" the 
previous contents of the page into the same page. Think of it as SWIOTLB 
doing a read-modify-write of the DMA-mapped region, because that's 
exactly what it's doing (on the basis that it can't be sure of 
overwriting it entirely).

You can then consider it the same as if the device DMAs to the page 
directly without SWIOTLB being involved - if it does a partial write and 
that lets previous contents be mapped to userspace which shouldn't have 
been, that can only be the fault of whoever failed to sanitise the page 
beforehand.

> That data *may* be completely uninitialized, especially during boot, but the
> original pages may also contain data from whatever was using the pages before they
> were allocated by the driver.
> 
> It's possible the read of uninitialized data is observed only when either the
> driver that triggered the mapping _knows_ that the device will overwrite the entire
> mapping, or the driver will consume only the written parts.  But in those cases,
> copying from the original memory is completely pointless.

Indeed, but sadly it is impossible for SWIOTLB to detect when that is or 
isn't the case. No matter what the SWIOTLB buffer is initialised with, 
there is always the possibility that the device coincidentally writes 
the same pattern of bytes, thus it cannot ever know for sure what was or 
wasn't touched between map and unmap.

This is why in the original discussion we also tossed around the idea of 
a DMA attribute for the caller to indicate "I definitely expect the 
device to overwrite this entire mapping", but then we went round in 
circles a bit more, concluded that it might be hard to get right, and 
shelved it, but then the wrong version of the patch got merged which did 
still include the half-formed attribute idea, and then there was the 
whole other trainwreck of reverting and unreverting, and I have a 
feeling that what we ended up with still wasn't quite right but by that 
point I was so fed up of the whole business I had stopped caring.

> If neither of the above holds true, then copying from the original adds value only
> if preserving the data is necessary for functional correctness, or the driver
> explicitly initialized the original memory.  Given that preserving source data was
> recently added, I highly doubt it's necessary for functional correctness.

Seems kinda hard to say that with certainty - I would imagine that the 
amount of actual testing done with "swiotlb=force" is minimal at best. 
There are so many 64-bit-capable devices in the world which would never 
normally interact with SWIOTLB, but are liable to find themselves forced 
into doing so in future confidential compute etc. scenarios. I don't 
think I'd bet anything of value that *nothing* anywhere is depending on 
partial DMA writes being handled correctly.

> And if the driver *doesn't* initialize the data, then the copy is at best pointless,
> and possibly even worse than leaking stale swiotlb data.

Other than the overhead, done right it can't be any worse than if 
SWIOTLB were not involved at all.

> Looking at commit ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE"),
> IIUC the data leak was observed with a synthetic test "driver" that was developed
> to verify a real data leak fixed by commit a45b599ad808 ("scsi: sg: allocate with
> __GFP_ZERO in sg_build_indirect()").  Which basically proves my point: copying
> from the source only adds value absent a bug in the owning driver.

Huh? IIUC the bug there was that the SCSI layer failed to sanitise 
partially-written buffers. That bug was fixed, and the scrutiny therein 
happened to reveal that SWIOTLB *also* had a lower-level problem with 
partial writes, in that it was corrupting DMA-mapped memory which was 
not updated by the device. Partial DMA writes are not in themselves 
indicative of a bug, they may well be a valid and expected behaviour.

> IMO, rather than copying from the original memory, swiotlb_tbl_map_single() should
> simply zero the original page(s) when establishing the mapping.  That would harden
> all usage of swiotlb and avoid the read-before-write behavior that is problematic
> for KVM.

Depends on one's exact definition of "harden"... Corrupting memory with 
zeros is less bad than corrupting memory with someone else's data if you 
look at it from an information security point of view, but from a 
not-corrupting-memory point of view it's definitely still corrupting 
memory :/

Taking a step back, is there not an argument that if people care about 
general KVM performance then they should maybe stop emulating obsolete 
PC hardware from 30 years ago, and at least emulate obsolete PC hardware 
from 20 years ago that supports 64-bit DMA? Even non-virtualised, 
SWIOTLB is pretty horrible for I/O performance by its very nature - 
avoiding it if at all possible should always be preferred.

Thanks,
Robin.
