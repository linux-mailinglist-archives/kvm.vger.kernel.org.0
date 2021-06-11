Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1B63A488A
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhFKSXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 14:23:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:50739 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhFKSXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 14:23:46 -0400
IronPort-SDR: ci/Kk1l0D2v8QYXMBFGy1ZbkU6PPktOUs9bIID86NpiJt644tE4MFNaSTsKsE0ZGtUtXNnoUd6
 d8Zk0s9MQXXA==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="205609389"
X-IronPort-AV: E=Sophos;i="5.83,267,1616482800"; 
   d="scan'208";a="205609389"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 11:21:44 -0700
IronPort-SDR: w9TxV2FNT8i/u7UpQAXKrviI2R+3AE9mCVzZe8ZGTOOSSo7JPXmawrYaVWibYxMlus6hC6THkp
 1gNtX1azImVg==
X-IronPort-AV: E=Sophos;i="5.83,267,1616482800"; 
   d="scan'208";a="420147048"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.170.146]) ([10.213.170.146])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 11:21:43 -0700
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
From:   Dave Jiang <dave.jiang@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603014932.GN1002214@nvidia.com>
 <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603214009.68fac0c4.alex.williamson@redhat.com>
 <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <168ee05a-faf4-3fce-e278-d783104fc442@intel.com>
 <20210607191126.GP1002214@nvidia.com>
 <bb39b5d4-093b-ded4-8ff1-73bbd472d905@intel.com>
Message-ID: <46472732-e139-87b9-ca3d-e8c41fda83aa@intel.com>
Date:   Fri, 11 Jun 2021 11:21:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bb39b5d4-093b-ded4-8ff1-73bbd472d905@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/8/2021 9:02 AM, Dave Jiang wrote:
>
> On 6/7/2021 12:11 PM, Jason Gunthorpe wrote:
>> On Mon, Jun 07, 2021 at 11:13:04AM -0700, Dave Jiang wrote:
>>
>>> So in step 1, we 'tag' the wq to be dedicated to guest usage and put 
>>> the
>>> hardware wq into enable state. For a dedicated mode wq, we can 
>>> definitely
>>> just register directly and skip the mdev step. For a shared wq mode, 
>>> we can
>>> have multiple mdev running on top of a single wq. So we need some 
>>> way to
>>> create more mdevs. We can either go with the existing established 
>>> creation
>>> path by mdev, or invent something custom for the driver as Jason 
>>> suggested
>>> to accomodate additional virtual devices for guests. We implemented 
>>> the mdev
>>> path originally with consideration of mdev is established and has a 
>>> known
>>> interface already.
>> It sounds like you could just as easially have a 'create new vfio'
>> file under the idxd sysfs.. Especially since you already have a bus
>> and dynamic vfio specific things being created on this bus.
>
> Will explore this and using of 'struct vfio_device' without mdev.
>
Hi Jason. I hacked the idxd driver to remove mdev association and use 
vfio_device directly. Ran into some issues. Specifically mdev does some 
special handling when it comes to iommu domain. When we hit 
vfio_iommu_type1_attach_group(), there's a branch in there for 
mdev_bus_type. It sets the group with mdev_group flag, which later has 
effect of special handling for iommu_attach_group. And in addition, it 
ends up switching the bus to pci_bus_type before iommu_domain_alloc() is 
called.  Do we need to provide similar type of handling for vfio_device 
that are not backed by an entire PCI device like vfio_pci? Not sure it's 
the right thing to do to attach these devices to pci_bus_type directly.
