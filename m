Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4771485F57
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 04:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiAFDsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 22:48:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:7494 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230498AbiAFDsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 22:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641440916; x=1672976916;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=s88NpyScOH/XjHqT1y7xLL0UmtzfW9rw5bZNtIuacDQ=;
  b=lOxOwoIQ15KuMbql7N6AA6wUn/8h0QE56SMTMYQN0iObfPbvzVXE3RsL
   tdpk8YE82tlUQIlxqgpof0+P4yxfDo5zk0kOXtu0c7KzyMAMz9l4u2kiC
   XW7hQ8104P1HPAekaxqFbuOIus56Fa7imOVWHWxYxurRZluM3Lh2onOi4
   0DfsSEKuXCLKLMoQzN3saDKhAxaLOS1wKGCah2cnHSYtSklqf8NXk+SoN
   ZVxq3z5dSByuNjmLFZx+0jOMNrwmvVzukrciWU0+lcTl16u0bEwcADI7K
   xqCy4qYS//0pyFgvBNbPY2mDm3fE009kLCTvM0R3elDAFmXxfcNd5DJiA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229907951"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="229907951"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 19:48:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526815184"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 19:48:29 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v5 01/14] iommu: Add dma ownership management interfaces
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20220104164100.GA101735@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <8e83da6c-7ae4-b855-ccf0-148d2babfcce@linux.intel.com>
Date:   Thu, 6 Jan 2022 11:47:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104164100.GA101735@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 12:41 AM, Bjorn Helgaas wrote:
>>> Devices under kernel drivers control must call iommu_device_use_dma_api()
>>> before driver probes. The driver binding process must be aborted if it
>>> returns failure.
> "Devices" don't call functions.  Drivers do, or in this case, it looks
> like the bus DMA code (platform, amba, fsl, pci, etc).
> 
> These functions are EXPORT_SYMBOL_GPL(), but it looks like all the
> callers are built-in, so maybe the export is unnecessary?

Yes. If all callers are built-in, we can remove this export.

> 
> You use "iommu"/"IOMMU" and "dma"/"DMA" interchangeably above.  Would
> be easier to read if you picked one.
> 

I should cleanup all these. I also realized that I forgot to
cleanup some typos you pointed out in v4:

https://lore.kernel.org/linux-iommu/20211229211626.GA1701512@bhelgaas/

Sorry about it. I will take care of all these in the next version.

Best regards,
baolu
