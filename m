Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BE7565929
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 17:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiGDPAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 11:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiGDPAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 11:00:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 521336339
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 08:00:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61FCD150C;
        Mon,  4 Jul 2022 08:00:38 -0700 (PDT)
Received: from [10.57.41.70] (unknown [10.57.41.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 932D23F792;
        Mon,  4 Jul 2022 08:00:35 -0700 (PDT)
Message-ID: <b91ae197-d191-2204-aab5-21a0aabded69@arm.com>
Date:   Mon, 4 Jul 2022 16:00:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Content-Language: en-GB
To:     Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Peter Collingbourne <pcc@google.com>, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Gavin Shan <gshan@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com> <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
 <875ykmcd8q.fsf@redhat.com> <YrwRPh1S6qjzkJMm@arm.com>
 <7a32fde7-611d-4649-2d74-f5e434497649@arm.com> <871qv12hqj.fsf@redhat.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <871qv12hqj.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/2022 13:19, Cornelia Huck wrote:
> On Mon, Jul 04 2022, Steven Price <steven.price@arm.com> wrote:
> 
>> On 29/06/2022 09:45, Catalin Marinas wrote:
>>> On Mon, Jun 27, 2022 at 05:55:33PM +0200, Cornelia Huck wrote:
>>>> [I'm still in the process of trying to grok the issues surrounding
>>>> MTE+KVM, so apologies in advance if I'm muddying the waters]
>>>
>>> No worries, we are not that far ahead either ;).
>>>
>>>> On Sat, Jun 25 2022, Steven Price <steven.price@arm.com> wrote:
>>>>> On 24/06/2022 18:05, Catalin Marinas wrote:
>>>>>> + Steven as he added the KVM and swap support for MTE.
>>>>>>
>>>>>> On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
>>>>>>> Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
>>>>>>> depend on being able to map guest memory as MAP_SHARED. The current
>>>>>>> restriction on sharing MAP_SHARED pages with the guest is preventing
>>>>>>> the use of those features with MTE. Therefore, remove this restriction.
>>>>>>
>>>>>> We already have some corner cases where the PG_mte_tagged logic fails
>>>>>> even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
>>>>>> KVM MAP_SHARED will potentially make things worse (or hard to reason
>>>>>> about; for example the VMM sets PROT_MTE as well). I'm more inclined to
>>>>>> get rid of PG_mte_tagged altogether, always zero (or restore) the tags
>>>>>> on user page allocation, copy them on write. For swap we can scan and if
>>>>>> all tags are 0 and just skip saving them.
>>>>>>
>>>>>> Another aspect is a change in the KVM ABI with this patch. It's probably
>>>>>> not that bad since it's rather a relaxation but it has the potential to
>>>>>> confuse the VMM, especially as it doesn't know whether it's running on
>>>>>> older kernels or not (it would have to probe unless we expose this info
>>>>>> to the VMM in some other way).
>>>>
>>>> Which VMMs support KVM+MTE so far? (I'm looking at adding support in QEMU.)
>>>
>>> Steven to confirm but I think he only played with kvmtool. Adding
>>> Jean-Philippe who also had Qemu on his plans at some point.
>>
>> Yes I've only played with kvmtool so far. 'basic support' at the moment
>> is little more than enabling the cap - that allows the guest to access
>> tags. However obviously aspects such as migration need to understand
>> what's going on to correctly save/restore tags - which is mostly only
>> relevant to Qemu.
> 
> Yes, simply only enabling the cap seems to work fine in QEMU as well (as
> in, 'mte selftests work fine'). Migration support is the
> hard/interesting part.
> 
>>
>>>> What happens in kvm_vm_ioctl_mte_copy_tags()? I think we would just end
>>>> up copying zeroes?
>>>
>>> Yes. For migration, the VMM could ignore sending over tags that are all
>>> zeros or maybe use some simple compression. We don't have a way to
>>> disable MTE for guests, so all pages mapped into the guest address space
>>> end up with PG_mte_tagged.
>>
>> Architecturally we don't (yet) have a way of describing memory without
>> tags, so indeed you will get all zeros if the guest hasn't populated the
>> tags yet.
> 
> Nod.
> 
>>
>>>> That said, do we make any assumptions about when KVM_ARM_MTE_COPY_TAGS
>>>> will be called? I.e. when implementing migration, it should be ok to
>>>> call it while the vm is paused, but you probably won't get a consistent
>>>> state while the vm is running?
>>>
>>> Wouldn't this be the same as migrating data? The VMM would only copy it
>>> after it was marked read-only. BTW, I think sanitise_mte_tags() needs a
>>> barrier before setting the PG_mte_tagged() flag (unless we end up with
>>> some lock for reading the tags).
>>
>> As Catalin says, tags are no different from data so the VMM needs to
>> either pause the VM or mark the page read-only to protect it from guest
>> updates during the copy.
> 
> Yes, that seems reasonable; not sure whether the documentation should
> call that out explicitly.
> 
>>
>> The whole test_bit/set_bit dance does seem to be leaving open race
>> conditions. I /think/ that Peter's extra flag as a lock with an added
>> memory barrier is sufficient to mitigate it, but at this stage I'm also
>> thinking some formal modelling would be wise as I don't trust my
>> intuition when it comes to memory barriers.
>>
>>>> [Postcopy needs a different interface, I guess, so that the migration
>>>> target can atomically place a received page and its metadata. I see
>>>> https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/;
>>>> has there been any follow-up?]
>>>
>>> I don't follow the qemu list, so I wasn't even aware of that thread. But
>>> postcopy, the VMM needs to ensure that both the data and tags are up to
>>> date before mapping such page into the guest address space.
>>>
>>
>> I'm not sure I see how atomically updating data+tags is different from
>> the existing issues around atomically updating the data. The VMM needs
>> to ensure that the guest doesn't see the page before all the data+all
>> the tags are written. It does mean lazy setting of the tags isn't
>> possible in the VMM, but I'm not sure that's a worthwhile thing anyway.
>> Perhaps I'm missing something?
> 
> For postcopy, we basically want to fault in any not-yet-migrated page
> via uffd once the guest accesses it. We only get the page data that way,
> though, not the tag. I'm wondering whether we'd need a 'page+metadata'
> uffd mode; not sure if that makes sense. Otherwise, we'd need to stop
> the guest while grabbing the tags for the page as well, and stopping is
> the thing we want to avoid here.

Ah, I think I see now. UFFDIO_COPY atomically populates the (data) page
and ensures that no thread will see the partially populated page. But
there's currently no way of doing that with tags as well.

I'd not looked at the implementation of userfaultfd before and I'd
assumed it avoided the need for an 'atomic' operation like this. But
apparently not! AFAICT either a new ioctl would be needed (which can
take a tag buffer) or a new flag to UFFDIO_COPY which would tighten the
alignment requirements of `src` and would copy the tags along with the data.

Steve
