Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F14483A02
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiADByb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:54:31 -0500
Received: from mga18.intel.com ([134.134.136.126]:25504 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbiADBya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:54:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261270; x=1672797270;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Ss8QCGOz/6iEe4yePS2efWHOxCXd1yzggIK/DRLWMvI=;
  b=ZoYyZpujkkdHngcCsm24I2UoM+xZIPytfbtZkImuGaBsEexq7f0hC1MC
   wf7PvNMUhu+39ev5DkCMzXwhKtqnqlp3Lwt0BOKHHE1DFl0l+JiemAUkt
   m0ac4trnNitHfJk208AVtNuhX6kWxSBY9OFSV+vn00UWOt83H5x1Se41b
   ltRhKmr4P3ge4hmtk9evxkCzF1AVDoav1hPJ4t4de/HYWV2sD1/ouxgLf
   haY+WD3Tt9UBMgW0JsfiqMYPgvtu667UnSFAfDIInGw6I0ySjfwBQCSfe
   /QA/ewoPGEYEFQsJEHhd9HuXhtZSF9aGAM0oAf1pCdWwi49qwXI8LJb9M
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="228960990"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="228960990"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:54:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525816995"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 03 Jan 2022 17:54:23 -0800
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
 <20211223005712.GA1779224@nvidia.com>
 <fea0fc91-ac4c-dfe4-f491-5f906bea08bd@linux.intel.com>
 <20211223140300.GC1779224@nvidia.com>
 <50b8bb0f-3873-b128-48e8-22f6142f7118@linux.intel.com>
 <20211224025036.GD1779224@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <1a22fecf-9cba-76f8-7dc4-88a56b2457cd@linux.intel.com>
Date:   Tue, 4 Jan 2022 09:53:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211224025036.GD1779224@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/24/21 10:50 AM, Jason Gunthorpe wrote:
>>> We don't need _USER anymore because iommu_group_set_dma_owner() always
>>> does detatch, and iommu_replace_group_domain() avoids ever reassigning
>>> default_domain. The sepecial USER behavior falls out automatically.
>> This means we will grow more group-centric interfaces. My understanding
>> is the opposite that we should hide the concept of group in IOMMU
>> subsystem, and the device drivers only faces device specific interfaces.
> Ideally group interfaces would be reduced, but in this case VFIO needs
> the group. It has sort of a fundamental problem with its uAPI that
> expects the container is fully setup with a domain at the moment the
> group is attached. So deferring domain setup to when the device is
> available becomes a user visible artifact - and if this is important
> or not is a whole research question that isn't really that important
> for this series.
> 
> We also can't just pull a device out of thin air, a device that hasn't
> been probed() hasn't even had dma_configure called! Let alone the
> lifetime and locking problems with that kind of idea.
> 
> So.. leaving it as a group interface makes the most sense,
> particularly for this series which is really about fixing the sharing
> model in the iommu core and deleting the BUG_ONs.

I feel it makes more sense if we leave the attach_device/group
refactoring patches into a separated series. I will come up with this
new series so that people can review and comment on the real code.

Best regards,
baolu
