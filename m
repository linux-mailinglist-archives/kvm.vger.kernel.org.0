Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D978482136
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 02:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbhLaBLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 20:11:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:46014 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240883AbhLaBLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 20:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640913085; x=1672449085;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6rk8MecEhpwbWspAjVxoCvCgMk2ueISFEzgwGnGfDMs=;
  b=bhWQq9Muqdvps269JyGlZZj1Kv2qfCqJ9WZyrR6oliUlKQXppSk3hV+K
   ofh9gvAWjzd+uactpRp3dSLhDiQtvLYmIERxt9aU1YH7FxW+v9fXiAL6p
   A219ZLJQDiK3dxhTKqQECSakIz9Oxkdk6ZScwrrK+4RxVHdiuHTsWW3EM
   5Q7cg21Lzmz1fcZGLfamVk4ax4JmyYDwL33zXOmMqntxws7eoseMnEuZW
   HMZZegO1NgmlUzn/sks4KfocF32Vs+98X3OC/DlrfjSTNDf9sMitoPkS/
   bXYHQ+O57tchXAuyhIEJzHMx3q+9Md19DOTU2aeYDAo43mamqoOijdof5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="241709291"
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="241709291"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2021 17:11:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="524573848"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 30 Dec 2021 17:11:15 -0800
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
Subject: Re: [PATCH v4 03/13] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>
References: <568b6d1d-69df-98ad-a864-dd031bedd081@linux.intel.com>
 <20211230222414.GA1805873@bhelgaas> <20211231004019.GH1779224@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <5eb8650c-432f-bf06-c63d-6320199ef894@linux.intel.com>
Date:   Fri, 31 Dec 2021 09:10:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211231004019.GH1779224@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 12/31/21 8:40 AM, Jason Gunthorpe wrote:
> On Thu, Dec 30, 2021 at 04:24:14PM -0600, Bjorn Helgaas wrote:
> 
>> I was speculating that maybe the DMA ownership claiming must be done
>> *before* the driver's .probe() method?
> 
> This is correct.
> 
>> If DMA ownership could be claimed by the .probe() method, we
>> wouldn't need the new flag in struct device_driver.
> 
> The other requirement is that every existing driver must claim
> ownership, so pushing this into the device driver's probe op would
> require revising almost every driver in Linux...
> 
> In effect the new flag indicates if the driver will do the DMA
> ownership claim in it's probe, or should use the default claim the
> core code does.
> 
> In almost every case a driver should do a claim. A driver like
> pci-stub, or a bridge, that doesn't actually operate MMIO on the
> device would be the exception.

We still need to call iommu_device_use_dma_api() in bus dma_configure()
callback. But we can call iommu_device_unuse_dma_api() in the .probe()
of vfio (and vfio-approved) drivers, so that we don't need the new flag
anymore.

> 
> Jason
> 

Best regards,
baolu
