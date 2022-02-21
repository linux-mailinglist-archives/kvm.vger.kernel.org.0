Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59484BD495
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 05:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbiBUED5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 23:03:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbiBUEDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 23:03:54 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F248E31DD6;
        Sun, 20 Feb 2022 20:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645416212; x=1676952212;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a8s6oPn2OepoA76s//VWNsP4UZFDI+9oeHKC9k5AQGM=;
  b=M/HWzCybvLl4fVSsSHXzBFMOejqsHoIpnejBmbC63ebvvpFfRWaBfo0y
   RowkODqI9IL8q4lONkg5x3YmZgh/Cphv2ieXocCEjEEI0gnUg5lRKAoQI
   uw6tJdmJCwyC5V3xXqedLFwJbnogxO4uoKGafr5liQ0rNSLJzTiSzE8RA
   dzVKfDNrQ/bA0CAZz859yo2lCdIfqTIbYFCROhNEe46wud9vCSVT2sTkO
   sVNFz2Pd1V/kO8NuvcHnXRGuQ0y9WJmRC6Lf93PTa7t/R6S9OJvri7kHJ
   ek4OXwrdIwFfe6VyaXJBdaOHP7PQSj39JvjzqupVKD0156Ht4zuqWqWXB
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251612704"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251612704"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 20:03:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="683079024"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2022 20:03:25 -0800
Message-ID: <97485ead-2570-2782-8766-9a4d8c4c8535@linux.intel.com>
Date:   Mon, 21 Feb 2022 12:02:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v6 01/11] iommu: Add dma ownership management interfaces
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
 <YhCc6dKyojInJe7u@infradead.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <YhCc6dKyojInJe7u@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/22 3:31 PM, Christoph Hellwig wrote:
> The overall API and patch looks fine, but:
> 
>> + * iommu_group_dma_owner_claimed() - Query group dma ownership status
>> + * @group: The group.
>> + *
>> + * This provides status query on a given group. It is racey and only for
>> + * non-binding status reporting.
> 
> s/racey/racy/

Yes.

> 
>> + */
>> +bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>> +{
>> +	unsigned int user;
>> +
>> +	mutex_lock(&group->mutex);
>> +	user = group->owner_cnt;
>> +	mutex_unlock(&group->mutex);
>> +
>> +	return user;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
> 
> Still no no need for the lock here.

We've discussed this before. I tend to think that is right.

We don't lose anything with this lock held and it also follows the rule
that all accesses to the internal group structure must be done with the
group->mutex held.

Best regards,
baolu
