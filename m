Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AAA483A09
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiADBzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:55:17 -0500
Received: from mga17.intel.com ([192.55.52.151]:26751 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbiADBzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:55:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261315; x=1672797315;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=SY0Ryi1NwGIpRAEonFk2jxPsk87fE1CBTswYWv3obpo=;
  b=Z/fQkIy3+Hx8addrgWth+yQjCP0GF6kftfpDuNAWW4VxQ6D6q3wBbtJ+
   t4dTmNfbcIcPgo6a8sqJ+fygGXFpLRlc/jcIKHK+SK30muvVq/aThMQf0
   HqRlL8yRYZLclARzD+rgV3LXXAnTxwCqWCLeAqUe3VMqh5AjVVTovCRJa
   Sk7D+5r7tVJmcA0leJFRq33TbY3Bm3cViYPSJch29JJmIeeWujZ9oc787
   16BSzV1vgrh3f5e1Ve61UDILHF4c0bikiuA1yPFK+ocPGadYF778HDKmK
   pD2wkOpUTjejVwG/6IVuKbnwTFDcyxsu33gK/mqWaqeg8MVssPeeD+Tq8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="222813035"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="222813035"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525817281"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 03 Jan 2022 17:55:07 -0800
Cc:     baolu.lu@linux.intel.com, Bjorn Helgaas <helgaas@kernel.org>,
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
Subject: Re: [PATCH v4 03/13] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <568b6d1d-69df-98ad-a864-dd031bedd081@linux.intel.com>
 <20211230222414.GA1805873@bhelgaas> <20211231004019.GH1779224@nvidia.com>
 <5eb8650c-432f-bf06-c63d-6320199ef894@linux.intel.com>
 <20220103195318.GA2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <2bbe6e20-6b1a-64ae-a4c6-2f414a8665f2@linux.intel.com>
Date:   Tue, 4 Jan 2022 09:54:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220103195318.GA2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/4/22 3:53 AM, Jason Gunthorpe wrote:
> On Fri, Dec 31, 2021 at 09:10:43AM +0800, Lu Baolu wrote:
> 
>> We still need to call iommu_device_use_dma_api() in bus dma_configure()
>> callback. But we can call iommu_device_unuse_dma_api() in the .probe()
>> of vfio (and vfio-approved) drivers, so that we don't need the new flag
>> anymore.
> 
> No, we can't. The action that iommu_device_use_dma_api() takes is to
> not call probe, it obviously cannot be undone by code inside probe.

Yes. Agreed.

> Jason
> 

Best regards,
baolu
