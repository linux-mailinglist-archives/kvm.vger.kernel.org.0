Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCD14C2359
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 06:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiBXFXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 00:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiBXFX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 00:23:29 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7095623584E;
        Wed, 23 Feb 2022 21:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645680180; x=1677216180;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1VYAA0otK3uOMli0TWlsKVdJIhmRQYoEYeddYTO8BbE=;
  b=X2pC1XiUnUWS3a8FrN6aTIGageWov3vKaNle3d7IWjtB+7/dlEXMNird
   B+erECVOfvjYXE7Ey+LdpahGvw+d9wZPffkI5d2eiQv8DjqyVYp0b7+Fx
   Y1Q82fkaXXxOAW2tqTaIVbK7L2y6bmsWt3TlFw21aKGdxOVtD++dV/ZUT
   OOPjkNCZAqavYszQuiF7d7wStTFpfRh5L4sBekKH5nzEdOHU+Rh1yJllx
   OnPdrst708d/14mwf8tD4QuJosMS4JISKrmHr6r70yXgiTY2LakeP1yap
   Dwb6mNLQfX9H7PbJVrLQL7JqCzVjp4yI3g+3WXiuYqtoe//K1JN0/SaSt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="338590956"
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="338590956"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 21:23:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="684159597"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2022 21:22:53 -0800
Message-ID: <10a96a85-d7e9-7ac6-9c8d-f0e8b4597f01@linux.intel.com>
Date:   Thu, 24 Feb 2022 13:21:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/11] iommu: Add dma ownership management interfaces
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
 <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/24/22 2:00 AM, Robin Murphy wrote:
> On 2022-02-18 00:55, Lu Baolu wrote:
> [...]
>> +/**
>> + * iommu_group_claim_dma_owner() - Set DMA ownership of a group
>> + * @group: The group.
>> + * @owner: Caller specified pointer. Used for exclusive ownership.
>> + *
>> + * This is to support backward compatibility for vfio which manages
>> + * the dma ownership in iommu_group level. New invocations on this
>> + * interface should be prohibited.
>> + */
>> +int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
>> +{
>> +    int ret = 0;
>> +
>> +    mutex_lock(&group->mutex);
>> +    if (group->owner_cnt) {
> 
> To clarify the comment buried in the other thread, I really think we 
> should just unconditionally flag the error here...
> 
>> +        if (group->owner != owner) {
>> +            ret = -EPERM;
>> +            goto unlock_out;
>> +        }
>> +    } else {
>> +        if (group->domain && group->domain != group->default_domain) {
>> +            ret = -EBUSY;
>> +            goto unlock_out;
>> +        }
>> +
>> +        group->owner = owner;
>> +        if (group->domain)
>> +            __iommu_detach_group(group->domain, group);
>> +    }
>> +
>> +    group->owner_cnt++;
>> +unlock_out:
>> +    mutex_unlock(&group->mutex);
>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_group_claim_dma_owner);
>> +
>> +/**
>> + * iommu_group_release_dma_owner() - Release DMA ownership of a group
>> + * @group: The group.
>> + *
>> + * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
>> + */
>> +void iommu_group_release_dma_owner(struct iommu_group *group)
>> +{
>> +    mutex_lock(&group->mutex);
>> +    if (WARN_ON(!group->owner_cnt || !group->owner))
>> +        goto unlock_out;
>> +
>> +    if (--group->owner_cnt > 0)
>> +        goto unlock_out;
> 
> ...and equivalently just set owner_cnt directly to 0 here. I don't see a 
> realistic use-case for any driver to claim the same group more than 
> once, and allowing it in the API just feels like opening up various 
> potential corners for things to get out of sync.

Yeah! Both make sense to me. I will also drop the owner token in the API
as it's unnecessary anymore after the change.

> I think that's the only significant concern I have left with the series 
> as a whole - you can consider my other grumbles non-blocking :)

Thank you and very appreciated for your time!

Best regards,
baolu
