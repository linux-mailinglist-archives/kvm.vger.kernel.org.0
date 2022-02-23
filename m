Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF36C4C0B5A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiBWFDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiBWFDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:03:13 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A97865810;
        Tue, 22 Feb 2022 21:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645592567; x=1677128567;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FNDR7wni8O9F98zBun4+rCEdedHrEYsctc1r1OAxlDU=;
  b=h3vZbMfgX1W31zHx390r2Ofsf283Cxp7JS/QgzH+ioCooCMU+JG6fd7K
   ulTA1W/aKKkbeBE0PGPRo5VMrLqMTAyb3gQGq2bx+/qzuUCL31bhwKpjE
   8f6n0rNOfo/7uLlFIpT9oVDXXckWY5QUHhcQix55NF2oWGmHdLmKZEcaM
   93Gpb7gInTxMzVcZ6SypEnkDjUJmqaS+27x3ePaptASf9AyUiLOzNOs8v
   xQRXnFFD9XUAEa1KqreHScRVwhWfNUUtyXpAtkUySDFZKyxdWtwapEO1E
   t54UNna+HU2NtXJPYhxTX8wnM6DAbc18F4RWfNAqpTsg9LVNAOFxVIDSW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="315113368"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="315113368"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 21:02:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="683771422"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 22 Feb 2022 21:02:40 -0800
Message-ID: <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
Date:   Wed, 23 Feb 2022 13:01:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-3-baolu.lu@linux.intel.com>
 <YhCdEmC2lYStmUSL@infradead.org>
 <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
 <20220221234837.GA10061@nvidia.com>
 <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
 <20220222151632.GB10061@nvidia.com>
 <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220222235353.GF10061@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/22 7:53 AM, Jason Gunthorpe wrote:
>> To spell it out, the scheme I'm proposing looks like this:
> Well, I already got this, it is what is in driver_or_DMA_API_token()
> that matters
> 
> I think you are suggesting to do something like:
> 
>     if (!READ_ONCE(dev->driver) ||  ???)
>         return NULL;
>     return group;  // A DMA_API 'token'
> 
> Which is locklessly reading dev->driver, and why you are talking about
> races, I guess.
> 

I am afraid that we are not able to implement a race-free
driver_or_DMA_API_token() helper. The lock problem between the IOMMU
core and driver core always exists.

For example, when we implemented iommu_group_store_type() to change the
default domain type of a device through sysfs, we could only comprised
and limited this functionality to singleton groups to avoid the lock
issue.

Unfortunately, that compromise cannot simply applied to the problem to
be solved by this series, because the iommu core cannot abort the driver
binding when the conflict is detected in the bus notifier.

Best regards,
baolu
