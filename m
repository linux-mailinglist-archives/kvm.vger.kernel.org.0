Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2543A2421
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 07:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFJFxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 01:53:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:38159 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJFxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 01:53:42 -0400
IronPort-SDR: aP+cPs91u8hfRGCPgNB6ANlnCQGUXx4K6wUHz7W4+GbcidFbSShVl0yrgxneZE/PlQj/svKnCR
 jzJmrpeikywg==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="192546133"
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="192546133"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 22:51:46 -0700
IronPort-SDR: lYZDBU6hA5oTn4VVKqizzKmtKcBFGSgqLubi9XRIwACO9pQQULnDbe7FgCznj4jwlvIz+SPiUv
 KJREAguEFGjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="552922753"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga001.fm.intel.com with ESMTP; 09 Jun 2021 22:51:41 -0700
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Plan for /dev/ioasid RFC v2
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org> <20210609123919.GA1002214@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <14d884a8-13bc-b2ba-7020-94b219e3e2d9@linux.intel.com>
Date:   Thu, 10 Jun 2021 13:50:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210609123919.GA1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/21 8:39 PM, Jason Gunthorpe wrote:
> On Wed, Jun 09, 2021 at 02:24:03PM +0200, Joerg Roedel wrote:
>> On Mon, Jun 07, 2021 at 02:58:18AM +0000, Tian, Kevin wrote:
>>> -   Device-centric (Jason) vs. group-centric (David) uAPI. David is not fully
>>>      convinced yet. Based on discussion v2 will continue to have ioasid uAPI
>>>      being device-centric (but it's fine for vfio to be group-centric). A new
>>>      section will be added to elaborate this part;
>> I would vote for group-centric here. Or do the reasons for which VFIO is
>> group-centric not apply to IOASID? If so, why?
> VFIO being group centric has made it very ugly/difficult to inject
> device driver specific knowledge into the scheme.
> 
> The device driver is the only thing that knows to ask:
>   - I need a SW table for this ioasid because I am like a mdev
>   - I will issue TLPs with PASID
>   - I need a IOASID linked to a PASID
>   - I am a devices that uses ENQCMD and vPASID
>   - etc in future
> 
> The current approach has the group try to guess the device driver
> intention in the vfio type 1 code.
> 
> I want to see this be clean and have the device driver directly tell
> the iommu layer what kind of DMA it plans to do, and thus how it needs
> the IOMMU and IOASID configured.
> 
> This is the source of the ugly symbol_get and the very, very hacky 'if
> you are a mdev*and*  a iommu then you must want a single PASID' stuff
> in type1.
> 
> The group is causing all this mess because the group knows nothing
> about what the device drivers contained in the group actually want.
> 
> Further being group centric eliminates the possibility of working in
> cases like !ACS. How do I use PASID functionality of a device behind a
> !ACS switch if the uAPI forces all IOASID's to be linked to a group,
> not a device?
> 
> Device centric with an report that "all devices in the group must use
> the same IOASID" covers all the new functionality, keep the old, and
> has a better chance to keep going as a uAPI into the future.

The iommu_group can guarantee the isolation among different physical
devices (represented by RIDs). But when it comes to sub-devices (ex. 
mdev or vDPA devices represented by RID + SSID), we have to rely on the
device driver for isolation. The devices which are able to generate sub-
devices should either use their own on-device mechanisms or use the
platform features like Intel Scalable IOV to isolate the sub-devices.

Under above conditions, different sub-device from a same RID device
could be able to use different IOASID. This seems to means that we can't
support mixed mode where, for example, two RIDs share an iommu_group and
one (or both) of them have sub-devices.

AIUI, when we attach a "RID + SSID" to an IOASID, we should require that
the RID doesn't share the iommu_group with any other RID.

Best regards,
baolu
