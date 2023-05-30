Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F817162AD
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjE3NxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjE3NxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:53:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DB88C7;
        Tue, 30 May 2023 06:53:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42B4616F2;
        Tue, 30 May 2023 06:45:03 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6636A3F67D;
        Tue, 30 May 2023 06:44:16 -0700 (PDT)
Message-ID: <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
Date:   Tue, 30 May 2023 14:44:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com,
        Sean Christopherson <seanjc@google.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com> <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com> <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZHXxkUe4IZXUc1PV@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/2023 1:52 pm, Jason Gunthorpe wrote:
> On Tue, May 30, 2023 at 01:14:41PM +0100, Robin Murphy wrote:
>> On 2023-05-30 12:54, Jason Gunthorpe wrote:
>>> On Tue, May 30, 2023 at 06:05:41PM +1000, Alistair Popple wrote:
>>>>
>>>>>> As no notification is sent and the SMMU does not snoop TLB invalidates
>>>>>> it will continue to return read-only entries to a device even though
>>>>>> the CPU page table contains a writable entry. This leads to a
>>>>>> continually faulting device and no way of handling the fault.
>>>>>
>>>>> Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
>>>>> just have the iommu driver push an iotlb invalidation command before
>>>>> it acks it? PRI is already really slow so I'm not sure a pipelined
>>>>> invalidation is going to be a problem? Does the SMMU architecture
>>>>> permit negative caching which would suggest we need it anyhow?
>>>>
>>>> Yes, SMMU architecture (which matches the ARM architecture in regards to
>>>> TLB maintenance requirements) permits negative caching of some mapping
>>>> attributes including the read-only attribute. Hence without the flushing
>>>> we fault continuously.
>>>
>>> Sounds like a straight up SMMU bug, invalidate the cache after
>>> resolving the PRI event.
>>
>> No, if the IOPF handler calls back into the mm layer to resolve the fault,
>> and the mm layer issues an invalidation in the process of that which isn't
>> propagated back to the SMMU (as it would be if BTM were in use), logically
>> that's the mm layer's failing. The SMMU driver shouldn't have to issue extra
>> mostly-redundant invalidations just because different CPU architectures have
>> different idiosyncracies around caching of permissions.
> 
> The mm has a definition for invalidate_range that does not include all
> the invalidation points SMMU needs. This is difficult to sort out
> because this is general purpose cross arch stuff.
> 
> You are right that this is worth optimizing, but right now we have a
> -rc bug that needs fixing and adding and extra SMMU invalidation is a
> straightforward -rc friendly way to address it.

Sure; to clarify, I'm not against the overall idea of putting a hack in 
the SMMU driver with a big comment that it is a hack to work around 
missing notifications under SVA, but it would not constitute an "SMMU 
bug" to not do that. SMMU is just another VMSAv8-compatible MMU - if, 
say, KVM or some other arm64 hypervisor driver wanted to do something 
funky with notifiers to shadow stage 1 permissions for some reason, it 
would presumably be equally affected.

FWIW, the VT-d spec seems to suggest that invalidation on RO->RW is only 
optional if the requester supports recoverable page faults, so although 
there's no use-case for non-PRI-based SVA at the moment, there is some 
potential argument that the notifier issue generalises even to x86.

Thanks,
Robin.
