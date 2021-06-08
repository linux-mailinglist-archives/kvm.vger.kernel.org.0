Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470AC39FBA1
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhFHQE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 12:04:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:17023 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhFHQEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 12:04:55 -0400
IronPort-SDR: UHCdbKtlyzn3buLIOFpjiMite/E6YmGfQSrTuAX3WrHcW8fKHYlE5ST5LBak4pbGyJ6PCcrl2W
 TIb14BK3Lbpg==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="191983999"
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="191983999"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 09:03:00 -0700
IronPort-SDR: 3Hkk1m8f8AkixH/gVJ42Gf9agNRzt/9wcUiKjw6Zx6w4TBo3blVm+7zkpmi4pC5MWmUIocTLNv
 2QHbM8wlTNuA==
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="449574835"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.254.189.206]) ([10.254.189.206])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 09:02:59 -0700
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
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
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <bb39b5d4-093b-ded4-8ff1-73bbd472d905@intel.com>
Date:   Tue, 8 Jun 2021 09:02:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210607191126.GP1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/7/2021 12:11 PM, Jason Gunthorpe wrote:
> On Mon, Jun 07, 2021 at 11:13:04AM -0700, Dave Jiang wrote:
>
>> So in step 1, we 'tag' the wq to be dedicated to guest usage and put the
>> hardware wq into enable state. For a dedicated mode wq, we can definitely
>> just register directly and skip the mdev step. For a shared wq mode, we can
>> have multiple mdev running on top of a single wq. So we need some way to
>> create more mdevs. We can either go with the existing established creation
>> path by mdev, or invent something custom for the driver as Jason suggested
>> to accomodate additional virtual devices for guests. We implemented the mdev
>> path originally with consideration of mdev is established and has a known
>> interface already.
> It sounds like you could just as easially have a 'create new vfio'
> file under the idxd sysfs.. Especially since you already have a bus
> and dynamic vfio specific things being created on this bus.

Will explore this and using of 'struct vfio_device' without mdev.



>
> Have you gone over this with Dan?
>
>> I think things become more complicated when we go from a dedicated wq to
>> shared wq where the relationship of wq : mdev is 1 : 1 goes to 1 : N. Also
>> needing to keep a consistent user config experience is desired, especially
>> we already have such behavior since kernel 5.6 for host usages. So we really
>> need try to avoid doing wq configuration differently just for "mdev" wqs. In
>> the case suggested above, we basically just flipped the configuration steps.
>> Mdev is first created through mdev sysfs interface. And then the device
>> paramters are configured. Where for us, we configure the device parameter
>> first, and then create the mdev. But in the end, it's still the hybrid mdev
>> setup right?
> So you don't even use mdev to configure anything? Yuk.
>
> Jason
