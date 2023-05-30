Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB17715EAA
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjE3MO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbjE3MOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:14:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0345AB0;
        Tue, 30 May 2023 05:14:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 988B3AB6;
        Tue, 30 May 2023 05:15:33 -0700 (PDT)
Received: from [10.57.83.37] (unknown [10.57.83.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F5DD3F67D;
        Tue, 30 May 2023 05:14:46 -0700 (PDT)
Message-ID: <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
Date:   Tue, 30 May 2023 13:14:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com,
        Sean Christopherson <seanjc@google.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com> <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZHXj/6Bjraxqk4YR@nvidia.com>
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

On 2023-05-30 12:54, Jason Gunthorpe wrote:
> On Tue, May 30, 2023 at 06:05:41PM +1000, Alistair Popple wrote:
>>
>>>> As no notification is sent and the SMMU does not snoop TLB invalidates
>>>> it will continue to return read-only entries to a device even though
>>>> the CPU page table contains a writable entry. This leads to a
>>>> continually faulting device and no way of handling the fault.
>>>
>>> Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
>>> just have the iommu driver push an iotlb invalidation command before
>>> it acks it? PRI is already really slow so I'm not sure a pipelined
>>> invalidation is going to be a problem? Does the SMMU architecture
>>> permit negative caching which would suggest we need it anyhow?
>>
>> Yes, SMMU architecture (which matches the ARM architecture in regards to
>> TLB maintenance requirements) permits negative caching of some mapping
>> attributes including the read-only attribute. Hence without the flushing
>> we fault continuously.
> 
> Sounds like a straight up SMMU bug, invalidate the cache after
> resolving the PRI event.

No, if the IOPF handler calls back into the mm layer to resolve the 
fault, and the mm layer issues an invalidation in the process of that 
which isn't propagated back to the SMMU (as it would be if BTM were in 
use), logically that's the mm layer's failing. The SMMU driver shouldn't 
have to issue extra mostly-redundant invalidations just because 
different CPU architectures have different idiosyncracies around caching 
of permissions.

Thanks,
Robin.
