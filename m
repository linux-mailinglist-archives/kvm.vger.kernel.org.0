Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7CF73595E
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjFSOUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 10:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjFSOUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 10:20:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AAEDE7;
        Mon, 19 Jun 2023 07:20:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 056E012FC;
        Mon, 19 Jun 2023 07:21:20 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2B643F59C;
        Mon, 19 Jun 2023 07:20:34 -0700 (PDT)
Message-ID: <0c1aec7a-8724-0f49-bccb-6025f5863bb7@arm.com>
Date:   Mon, 19 Jun 2023 15:20:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <5d0d6665-93e4-f61f-d700-008c0fcb4a2f@arm.com> <ZJBbJHevOa8mAdll@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZJBbJHevOa8mAdll@nvidia.com>
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

On 19/06/2023 2:41 pm, Jason Gunthorpe wrote:
> On Mon, Jun 19, 2023 at 02:33:18PM +0100, Robin Murphy wrote:
>>> @@ -2121,6 +2125,21 @@ static int __iommu_device_set_domain(struct iommu_group *group,
>>>    {
>>>    	int ret;
>>> +	/*
>>> +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
>>> +	 * the blocking domain to be attached as it does not contain the
>>> +	 * required 1:1 mapping. This test effectively exclusive the device from
>>> +	 * being used with iommu_group_claim_dma_owner() which will block vfio
>>> +	 * and iommufd as well.
>>> +	 */
>>> +	if (dev->iommu->requires_direct &&
>>> +	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
>>
>> Given the notion elsewhere that we want to use the blocking domain as a last
>> resort to handle an attach failure,
> 
> We shouldn't do that for cases where requires_direct is true, the last
> resort will have to be the static identity domain.
> 
>> at face value it looks suspect that failing to attach to a blocking
>> domain could also be a thing. I guess technically this is failing at
>> a slightly different level so maybe it does work out OK, but it's
>> still smelly.
> 
> It basically says that this driver doesn't support blocking domains on
> this device. What we don't want is for the driver to fail blocking or
> identity attaches.

Is that really the relevant semantic though? I thought the point was to 
prevent userspace (or anyone else for that matter) taking ownership of a 
device with reserved regions which we can't trust them to honour. Not 
least because the series is entitled "Prevent RESV_DIRECT devices from 
user assignment", not anything about attaching to blocking domains. Plus 
the existing intel-iommu behaviour being generalised is specific to 
IOMMU_DOMAIN_UNMANAGED.

>> The main thing, though, is that not everything implements the
>> IOMMU_DOMAIN_BLOCKED optimisation, so a nominal blocking domain could be
>> IOMMU_DOMAIN_UNMANAGED as well.
> 
> Yes, it should check new_domain == group->blocking_domain as well.
> 
>> FWIW I'd prefer to make the RESV_DIRECT check explicit in
>> __iommu_take_dma_ownership() rather than hide it in an
>> implementation detail; that's going to be a lot clearer to reason
>> about as time goes on.
> 
> We want to completely forbid blocking domains at all on these devices
> because they are not supported (by FW request). I don't really like
> the idea that we go and assume the only users of blocking domains are
> also using take_dma_ownership() - that feels like a future bug waiting
> to happen.

On reflection, I don't think that aspect actually matters anyway - 
nobody can explicitly request attachment to a blocking domain, so if the 
only time they're used is when the IOMMU driver has already had a 
catastrophic internal failure such that we decide to declare the device 
toasted and deliberately put it into an unusable state, blocking its 
reserved regions doesn't seem like a big deal. In fact if anything it 
kind of feels like the right thing to do for that situation. We're 
saying that we want the device to stop accessing memory because things 
might be in an inconsistent state which we can't trust; who says that 
mappings of RESV_DIRECT regions haven't also gone wonky? Having BLOCKED 
mean that the device truly cannot access - and thus potentially corrupt 
- *any* memory anywhere seems like the most robust and useful behaviour.

Thanks,
Robin.
