Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB25D4C2395
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 06:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiBXFbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 00:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiBXFbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 00:31:18 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3DB23BF28;
        Wed, 23 Feb 2022 21:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645680649; x=1677216649;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MRJOuFFYYPPC0Fs9nMbQSx2XuzsoF0+2SRmq/hChfag=;
  b=QPLGr+QJ9Ys2dsrgnq93k1WfQgvhyKpq2SJCeDjnoJJ0morpyOgztwv1
   RcSM9Vbr3qesQWiwFoxFHagJdZ9R3nwCq/L1a5tEwc47dxfK+gYwd7oN7
   q7wew9fXwhhQdbG4hYFL9AM6HIfrOfDcohBaWp/qRnuEy8yV0XBiREHH7
   EJQi6k94YFoMTiNihKWXPfydNWc7v3vklwbTU/1KcO+aPHnNHWA3pVi+d
   ACdmiOWPB3liaY7CB82QCwkKrFTfeqhfVy6lVpdV1C3l2pgRU9E3gsfd8
   7aUNixOdrjVIiA0GIG9dM6aKo1M+bwHaVYbBitsfRgTfNv9E+GrR6/JVR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="239549729"
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="239549729"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 21:30:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="684161288"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2022 21:30:40 -0800
Message-ID: <c591f91a-392c-21a2-e9bd-10c64073e9e8@linux.intel.com>
Date:   Thu, 24 Feb 2022 13:29:11 +0800
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
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
 <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
 <20220223180244.GA390403@nvidia.com>
 <dd944ab4-cf25-fa41-0170-875e5c5fd0e8@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <dd944ab4-cf25-fa41-0170-875e5c5fd0e8@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/24/22 1:16 PM, Lu Baolu wrote:
> Hi Robin and Jason,
> 
> On 2/24/22 2:02 AM, Jason Gunthorpe wrote:
>> On Wed, Feb 23, 2022 at 06:00:06PM +0000, Robin Murphy wrote:
>>
>>> ...and equivalently just set owner_cnt directly to 0 here. I don't see a
>>> realistic use-case for any driver to claim the same group more than 
>>> once,
>>> and allowing it in the API just feels like opening up various potential
>>> corners for things to get out of sync.
>> I am Ok if we toss it out to get this merged, as there is no in-kernel
>> user right now.
> 
> So we don't need the owner pointer in the API anymore, right?

Oh, NO.

The owner token represents that the group has been claimed for user
space access. And the default domain auto-attach policy will be changed
accordingly.

So we still need this. Sorry for the noise.

Best regards,
baolu
