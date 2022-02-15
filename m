Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209274B615B
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 04:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiBODIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 22:08:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiBODI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 22:08:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5148BD7610;
        Mon, 14 Feb 2022 19:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644894500; x=1676430500;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=geRpObVSkW/4BdCaIv62nRssJKtA31qUc5woj+F+Kyw=;
  b=lhmsE3wMFDeT0NAb1/ZzKUE5sEO98n6Up8eYGzfv1BPXDy4yVZzwD8zh
   Wtka4nv036ANpwIDcZetmqKT76YFc6DurXTUmhhL0U+525F7VRNaWNh2e
   8udKdgKLK6VoJTg075kgFiFzxQq8iE+fpXBzPKuWAI157mx90eGLBlOBT
   cb5id9VCQoz1qPm5iWFVIp/uVfoHmty40Mg6UC0zia8WeDhsuKWmqwhzx
   WJgnQWKtLn2Ize6ku+4iyrucExPsqdyMUniwnkDuxvHzXmH5kT8MJv+vy
   oGM2lFL2J/OGlMAmRSIylidTMpfHvLkW95+GALN4Ebs0zxYhELKD/R65R
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="274811837"
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="274811837"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 19:08:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="680812468"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2022 19:08:13 -0800
Message-ID: <ee9c2210-f718-223f-c678-038d3ea4a93e@linux.intel.com>
Date:   Tue, 15 Feb 2022 11:06:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-8-baolu.lu@linux.intel.com>
 <Ygoo/lCt/G6tWDz9@kroah.com> <20220214123842.GT4160@nvidia.com>
 <YgpQOmBA7QJJu+2E@kroah.com> <20220214131117.GW4160@nvidia.com>
 <YgpbhlPOZsLFm4It@kroah.com> <20220214134356.GB929467@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220214134356.GB929467@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 9:43 PM, Jason Gunthorpe wrote:
> On Mon, Feb 14, 2022 at 02:39:18PM +0100, Greg Kroah-Hartman wrote:
> 
>>> A driver that sets this flag can still decide to enable the dma API on
>>> its own. eg tegra drivers do this.
>>
>> So you are just forcing the driver to manage this all on their own, so
>> how about, "driver_managed_dma", or even shorter "managed_dma"?
> 
> Yeah, I like "driver_managed_dma" alot, it captures the entire idea

This makes a lot of sense. For most drivers, they don't need to care
about this flag as all DMAs are handled through the kernel DMA API. For
VFIO or similar drivers, they know how to manage the DMA themselves and
set this flag so that the IOMMU layer will allow them to setup and
manage their own I/O address space.

If there is no better naming, I'd like to use this and add some comments
for device drivers developers.

Thanks a lot to Greg and Jason.

Best regards,
baolu
