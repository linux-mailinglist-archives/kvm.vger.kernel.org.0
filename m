Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B7B4BD455
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 04:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344295AbiBUDkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 22:40:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiBUDkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 22:40:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2153E443D7;
        Sun, 20 Feb 2022 19:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645414790; x=1676950790;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=60/MPdEQofHhnUr7veVOqJ/oCjaVN9C6ovq/oXXWh9A=;
  b=UHr1P9ih8WOjUbFc9VDcuGLkfnLkGSBabapLrSt03WXxGooRHsRKVwrf
   mqXr5JI95Es90tiaDFf866fsAIVVjVoJKlvm0bG97PPnkSD0L5qf3ubuN
   Cwi3VaLD7HKQstiJNjNOmf1SRBa8SzwNVTqgpIPFKkVf2YXMewI6BcPHY
   kJV7YbeFVIvHL8+ytc2FAfyVLeZ/S6CqjWoXqLm8se8/JpTgYDpiZYXMH
   GrEPSaKUc3oSNdjLrllwLRF3tjEyyrsrvhvhW41LS6tCe0sZMBzj3fe1j
   os9y3D2wA35Z0wtEvKt6YMO63kXX+PzlcLa5rcO35VxpW1INR/iXvafy7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="234969227"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="234969227"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 19:39:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="683075535"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2022 19:39:42 -0800
Message-ID: <48fbee94-6726-de98-5161-877c80073ac8@linux.intel.com>
Date:   Mon, 21 Feb 2022 11:38:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [PATCH v6 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218155121.GU4160@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220218155121.GU4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 11:51 PM, Jason Gunthorpe wrote:
> On Fri, Feb 18, 2022 at 08:55:10AM +0800, Lu Baolu wrote:
>> Hi folks,
>>
>> The iommu group is the minimal isolation boundary for DMA. Devices in
>> a group can access each other's MMIO registers via peer to peer DMA
>> and also need share the same I/O address space.
>>
>> Once the I/O address space is assigned to user control it is no longer
>> available to the dma_map* API, which effectively makes the DMA API
>> non-working.
>>
>> Second, userspace can use DMA initiated by a device that it controls
>> to access the MMIO spaces of other devices in the group. This allows
>> userspace to indirectly attack any kernel owned device and it's driver.
> This series has changed quite a lot since v1 - but I couldn't spot
> anything wrong with this. It is a small incremental step and I think
> it is fine now, so
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> 
> I hope you continue to work on the "Scrap iommu_attach/detach_group()
> interfaces" series and try to minimize all the special places testing
> against the default domain

Sure.

Best regards,
baolu
