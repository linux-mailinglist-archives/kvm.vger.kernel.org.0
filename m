Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4137779414D
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 18:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbjIFQTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 12:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjIFQTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 12:19:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4552F198B;
        Wed,  6 Sep 2023 09:18:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 852D8106F;
        Wed,  6 Sep 2023 09:19:36 -0700 (PDT)
Received: from [10.57.5.192] (unknown [10.57.5.192])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 512F63F67D;
        Wed,  6 Sep 2023 09:18:57 -0700 (PDT)
Message-ID: <5d81a9cd-f96d-bcdb-7878-74c2ead26cfb@arm.com>
Date:   Wed, 6 Sep 2023 17:18:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
 <ZN0S28lkbo6+D7aF@google.com> <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
 <ZN5elYQ5szQndN8n@google.com> <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
 <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com> <ZPd6Y9KJ0FfbCa0Q@google.com>
 <5ff1591c-d41c-331f-84a6-ac690c48ff5d@arm.com> <ZPiQQ0OANuaOYdIS@google.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZPiQQ0OANuaOYdIS@google.com>
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

On 2023-09-06 15:44, Sean Christopherson wrote:
> On Wed, Sep 06, 2023, Robin Murphy wrote:
>> On 2023-09-05 19:59, Sean Christopherson wrote:
>>> And if the driver *doesn't* initialize the data, then the copy is at best pointless,
>>> and possibly even worse than leaking stale swiotlb data.
>>
>> Other than the overhead, done right it can't be any worse than if SWIOTLB
>> were not involved at all.
> 
> Yep.
> 
>>> Looking at commit ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE"),
>>> IIUC the data leak was observed with a synthetic test "driver" that was developed
>>> to verify a real data leak fixed by commit a45b599ad808 ("scsi: sg: allocate with
>>> __GFP_ZERO in sg_build_indirect()").  Which basically proves my point: copying
>>> from the source only adds value absent a bug in the owning driver.
>>
>> Huh? IIUC the bug there was that the SCSI layer failed to sanitise
>> partially-written buffers. That bug was fixed, and the scrutiny therein
>> happened to reveal that SWIOTLB *also* had a lower-level problem with
>> partial writes, in that it was corrupting DMA-mapped memory which was not
>> updated by the device. Partial DMA writes are not in themselves indicative
>> of a bug, they may well be a valid and expected behaviour.
> 
> The problem is that the comment only talks about leaking data to userspace, and
> doesn't say anything about data corruption or the "swiotlb needs to match hardware"
> justification that Linus pointed out.  I buy both of those arguments for copying
> data from the original page, but the "may prevent leaking swiotlb content" is IMO
> completely nonsensical, because if preventing leakage is the only goal, then
> explicitly initializing the memory is better in every way.
> 
> If no one objects, I'll put together a patch to rewrite the comment in terms of
> mimicking hardware and not corrupting the caller's data.

Sounds good to me. I guess the trouble is that as soon as a CVE is 
involved it can then get hard to look past it, or want to risk appearing 
to downplay it :)

>>> IMO, rather than copying from the original memory, swiotlb_tbl_map_single() should
>>> simply zero the original page(s) when establishing the mapping.  That would harden
>>> all usage of swiotlb and avoid the read-before-write behavior that is problematic
>>> for KVM.
>>
>> Depends on one's exact definition of "harden"... Corrupting memory with
>> zeros is less bad than corrupting memory with someone else's data if you
>> look at it from an information security point of view, but from a
>> not-corrupting-memory point of view it's definitely still corrupting memory
>> :/
>>
>> Taking a step back, is there not an argument that if people care about
>> general KVM performance then they should maybe stop emulating obsolete PC
>> hardware from 30 years ago, and at least emulate obsolete PC hardware from
>> 20 years ago that supports 64-bit DMA?
> 
> Heh, I don't think there's an argument per se, people most definitely shouldn't
> be emulating old hardware if they care about performance.  I already told Yan as
> much.
> 
>> Even non-virtualised, SWIOTLB is pretty horrible for I/O performance by its
>> very nature - avoiding it if at all possible should always be preferred.
> 
> Yeah.  The main reason I didn't just sweep this under the rug is the confidential
> VM use case, where SWIOTLB is used to bounce data from guest private memory into
> shread buffers.  There's also a good argument that anyone that cares about I/O
> performance in confidential VMs should put in the effort to enlighten their device
> drivers to use shared memory directly, but practically speaking that's easier said
> than done.

Indeed a bunch of work has gone into SWIOTLB recently trying to make it 
a bit more efficient for such cases where it can't be avoided, so it is 
definitely still interesting to learn about impacts at other levels like 
this. Maybe there's a bit of a get-out for confidential VMs though, 
since presumably there's not much point COW-ing encrypted private 
memory, so perhaps KVM might end up wanting to optimise that out and 
thus happen to end up less sensitive to unavoidable SWIOTLB behaviour 
anyway?

Cheers,
Robin.
