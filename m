Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708DF47DC6E
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 01:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbhLWA5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 19:57:17 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:2272
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235367AbhLWA5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 19:57:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eo4EAdVH2oPST6pivcoJT9Ez/VcTBRLNzhEvFH4mHJHPb5+PSH0Gmkl/LREnjjUpfUiuVnD4o6D1Wa1OgE18QPipfkE6UouxebOJnMK+eM/mg2jBuscA0ylxeR+Hq2E5RjEDtckkG5rUnz1ragVLzmw5UIreF7yRR7IRgoe9F5pcU/3YU+JZTNdGK+6H4fxkCX9WYENcVChzv68atNUa3Wcd2BIoY1s7+sZw7ZB1wuy4xxwZiS4PHQFCkuHvCYH/xDu9P4FwX9IERnBPijtuib5yslffFzP5w28uxgH2O1mD7IK5ubUkEk2NkhemmOc0ccmMivbY7lTfqLT7ePNmfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8b/MI4f8ed5HLSsCpH46jtH4orPelhFJH6IJcABq7Ks=;
 b=VfVZstTvQz9/DfdmYsMt08NYJHDSPZzKB9tBB2wdv6VfeQkqcoybKtjXR7CM2d3cKSAsLdAMPVLYrsI8HMuUNowLF3337AsODZGv0qumCLmvD1GhkYngqHnuBStUytPaNA0dbq+YzuWAa01xg2vKAYi9X7Te7elL9b6DKPtUukeb+d7uv0TxHrgPp49npTaR6U3sRaBIa5aW7F/a86oAPd6Hd7vI4LHzFHyCWCiHVOQqr4CiYHG2+xBEfyVOaCCtBirPVW0CLKIHC+p7Hz0t0myQ6ueFw0cRqTnltaWWRAP2eGXZNbnX3afXk90tjb08nSDNU2PcEJPUjQdGHjdCXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8b/MI4f8ed5HLSsCpH46jtH4orPelhFJH6IJcABq7Ks=;
 b=DajlqFlHYdcy4YN94RR9+/TyIMi+i6i1CXkmyA1YFnffMGKfc0j3xxuOew5jarU2IbpZMeUSCPatt7YlyveJ23pSggIvr9IusQwMkCKFcWhk2JVSwiQoHfF/jSdVy5XGdBJDWc2uANc7vqPQgHAwjoeUJURPZ8h5qIczdxv2tL3mxllC5eOcUVni1aKM99nidBcpj1FjouD/4fQduNOfsf6mlz4TS3Va5MhwrLsiYZukp5uGuMXQTW+HtF7t43smi0w/0sm+eRGt1o+v5TAmPf33yp5B012fak+OipEjufIjxeumXyBJG4tHLqOQ0wXqn1nIMO9gTgoma2degyCFEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Thu, 23 Dec
 2021 00:57:14 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 00:57:14 +0000
Date:   Wed, 22 Dec 2021 20:57:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
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
Message-ID: <20211223005712.GA1779224@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
X-ClientProxiedBy: BL1PR13CA0269.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f690428c-fbb1-4975-06d6-08d9c5af2888
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB55397D0E525F60833BEA593CC27E9@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHHL1wqRSAKjuF3UoaKFQe1q/W9uoKHXooW6H5T6IMEAiKhyIsURtdcskfjCPkBjlrQ5h3CTuyvB31Au3lr/7Z0iuN5fn+nt458lfArE/kSJevbhDpruKp1xCiRQPza0Fqe2zUAbGvSvaJMrI+3aWROagUSF9MuUPK4hTRKpSKR3etKHWT/tNfcwixpjYpOyelfKvy5ITtGIl98bQf9K+3CzK2M8wyvRSNobL6DDZ0TYSdzrCnc8ZQxK3Qy9J88wNmoQjBnL4OlIP6HYt29p4Lc90/VSApLvEIkL2syCpwXUWy/UGulVSTTddAigrMmzH6wfO5HE3u0jc66MizUl+UX3xj7861njj1JJ9VOurL8OpO428ECVjAmrM1oSWoKl07d3pkQ0rikunp0PytCZesTlgaN73gSUiQrGjuEKFcPxqd8dQ1qcXEfNYtTfNMluBpY/tF9KhqXveqrBkGuxVqbYHesUXxYPzzCaL9U1alnVQh57+/+YIJx3qnxV0+GnGBckVLYBHNQYjC0oOgKHnDpcvY/KLeEq81WHY8bHpVweVQopPz9Z3yVhrYtnXqGnnKXwHGVILOtggfyiuNaJY0dvQn0jWIj6FCtD7avRYmzIsoFtIMqN7Haviz87Syimo1mMaedWyK75nDogRUINFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(2906002)(8936002)(5660300002)(36756003)(186003)(6512007)(6916009)(6506007)(316002)(86362001)(33656002)(54906003)(53546011)(6486002)(8676002)(26005)(38100700002)(4326008)(83380400001)(66946007)(66556008)(508600001)(66476007)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D4JIbmHbtK2Gmlcej6tJcVMa6kWJI5M0nCV4FR9DJdUuv6zbFGhdrB5ZeAOm?=
 =?us-ascii?Q?vLF/rbMAhS6pJonT4TfR0Sg1CwlfyjRMbhKfPH6mwJCYL4/N9hEnC4ILK+IP?=
 =?us-ascii?Q?oqOlNp+/FwU8ohyI5FjZdoxGYBeMp+qRRTv6bYmR1HicsRcnOI9EpNomfa0K?=
 =?us-ascii?Q?i2+5shqdNXQuBoUr7MxGxgD1tv3TJjK1fZoOegO+/MoPGg1j7Gq++ULxFLl8?=
 =?us-ascii?Q?sHVMMha53ahm1oeCwQS0j+SUQ7JEQolJg0Os6KPHvk0BHI+Hk5IOiCIRch31?=
 =?us-ascii?Q?746oKxZ5PlFGvdod0uC80O+QpnA8gomnThUgW/L7sUkG5jWjWQ7WzMRkIU3V?=
 =?us-ascii?Q?3DLRs/jxUARu0g0IYF+hLojMDkCZe83lAdrwibjB29E3KMpq8uiSbvLvxLFp?=
 =?us-ascii?Q?V/qFPiChJQO7rzTj4smozzDXYNy+f5TQmKg0csFM25B6+g5CkG4cBtBGpZCi?=
 =?us-ascii?Q?t0BloUWPcOHC1N+sPYi0gHR5BPreu2f9CkI3uQuwIQoBoqBQ5lNrfGMDrjqv?=
 =?us-ascii?Q?uyrvkpkK4VWHHI8ULy2avKBw7Xn37AIARopUbUuEd5A6Xso0MCjHc95hZRfW?=
 =?us-ascii?Q?vusmjvvk50cT365e/R45bSuYxhvCJ2CA8jdXMAT+ICy8Hjbbqc8LJKYkiDiL?=
 =?us-ascii?Q?7fJrMjtMKIFwWaDeFbc4r6N6j6usLqITpzYLhsIHCIxRH2ArBTEh6SQXb+uP?=
 =?us-ascii?Q?8JU+ZkcRCCVNBq3BvVuC863DuSmz2Y9IWBzttz6c/+TGV0cPD49RDdu978qC?=
 =?us-ascii?Q?OOeYSDL7tW31f0243eubImuuPM9mC1R6PM5jsAwH4E/BbGarzdw9rN4Xzzht?=
 =?us-ascii?Q?Opng4ljk3p+TP0ut9S3mVQpDCQpslHNw3j57bS7vqqGDEgb6Mv13XnplmbWc?=
 =?us-ascii?Q?/pJHdNxawD+HpEpY16AF9XaM4c3f94EHpmFN4VF+IisS1y0JKlRdjwaZ7gnO?=
 =?us-ascii?Q?QAp0kXNrlioFJpOd7R2PlsN70yamkuRryXGh/eLSgw8OGVJd7QbscAz8KVm0?=
 =?us-ascii?Q?nw/ZkNG/7zncVS5RvkNSjT9K50GMnrVJrhqZKLAIc4JHjyfnv1H27R9vQUnS?=
 =?us-ascii?Q?xDxd8ur51eBkbhNdJ9f8LK2d6x/m/wNFN4omd5FHQ/dolN51a7qPGbmsSQTI?=
 =?us-ascii?Q?V2VZOtohyGn5ughQ92VrOHsIZDA9UjEZiwRuTP+bzYSDZ3wjkljxhZkDtnVe?=
 =?us-ascii?Q?8R3LIQlntQ78gSEXpAtWkMDdOQLLBGhS1yfjUc7Bd17ES7hx57YWHU6DfezO?=
 =?us-ascii?Q?/Egndv33qHmS4s+Mzaerlm1+s0Wia2yz6VQhxARdsfDErYD/++x07lUwdvNK?=
 =?us-ascii?Q?5zovB5p5DLKjWl+KhvFx50gkvjzudDO2wYN+kPgcATJAK3Ey1b/HAfuGhcmY?=
 =?us-ascii?Q?5YbC1nPl6/SxfaxfLL02h/a4yBaF8hg+0bfHAYtx+sN3FJpPfuOtJf75jz63?=
 =?us-ascii?Q?WFogHgLgzRWAOybdaks+D8QiuqFrwKX6LxpM3wFYdEWdlym66yNm6HSovfgu?=
 =?us-ascii?Q?/rgu97GK511wL3Gxx59j8qePptkCqMBNiss0bO0/1DqQHzwvk8pDF5UJJxw8?=
 =?us-ascii?Q?PJ1l6tDRN+FXtXh1w94=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f690428c-fbb1-4975-06d6-08d9c5af2888
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 00:57:14.2399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRpLOM8ZzECFxLIawHacA52Cytiz5kIRA7L+rOQoUqp+dmwpnDhgo7DoMorCCy55
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 22, 2021 at 08:26:34PM +0000, Robin Murphy wrote:
> On 21/12/2021 6:46 pm, Jason Gunthorpe wrote:
> > On Tue, Dec 21, 2021 at 04:50:56PM +0000, Robin Murphy wrote:
> > 
> > > this proposal is the worst of both worlds, in that drivers still have to be
> > > just as aware of groups in order to know whether to call the _shared
> > > interface or not, except it's now entirely implicit and non-obvious.
> > 
> > Drivers are not aware of groups, where did you see that?
> 
> `git grep iommu_attach_group -- :^drivers/iommu :^include`
> 
> Did I really have to explain that?

Well, yes you did, because it shows you haven't understood my
question. After this series we deleted all those calls (though Lu, we
missed one of the tegra ones in staging, let's get it for the next
posting)

So, after this series, where do you see drivers being aware of groups?
If things are missed lets expect to fix them.

> > If the driver uses multiple struct devices and intends to connect them
> > all to the same domain then it uses the _shared variant. The only
> > difference between the two is the _shared varient lacks some of the
> > protections against driver abuse of the API.
> 
> You've lost me again; how are those intentions any different? Attaching one
> device to a private domain is a literal subset of attaching more than one
> device to a private domain. 

Yes it is a subset, but drivers will malfunction if they are not
designed to have multi-attachment and wrongly get it, and there is
only one driver that does actually need this.

I maintain a big driver subsystem and have learned that grepability of
the driver mess for special cases is quite a good thing to
have. Forcing drivers to mark in code when they do something weird is
an advantage, even if it causes some small API redundancy.

However, if you really feel strongly this should really be one API
with the _shared implementation I won't argue it any further.

> So then we have the iommu_attach_group() interface for new code (and still
> nobody has got round to updating the old code to it yet), for which
> the

This series is going in the direction of eliminating
iommu_attach_group() as part of the driver
interface. iommu_attach_group() is repurposed to only be useful for
VFIO.

> properly, or iommu_attach_group() with a potentially better interface and
> actual safety. The former is still more prevalent (and the interface
> argument compelling), so if we put the new implementation behind that, with
> the one tweak of having it set DMA_OWNER_PRIVATE_DOMAIN automatically, kill
> off iommu_attach_group() by converting its couple of users, 

This is what we did, iommu_attach_device() & _shared() are to be the
only interface for the drivers, and we killed off the
iommu_attach_group() couple of users except VFIO (the miss of
drivers/staging excepted)

> and not only have we solved the VFIO problem but we've also finally
> updated all the legacy code for free! Of course you can have a
> separate version for VFIO to attach with
> DMA_OWNER_PRIVATE_DOMAIN_USER if you like, although I still fail to
> understand the necessity of the distinction.

And the seperate version for VFIO is called 'iommu_attach_group()'.

Lu, it is probably a good idea to add an assertion here that the group
is in DMA_OWNER_PRIVATE_DOMAIN_USER to make it clear that
iommu_attach_group() is only for VFIO.

VFIO has a special requirement that it be able to do:

+       ret = iommu_group_set_dma_owner(group->iommu_group,
+                                       DMA_OWNER_PRIVATE_DOMAIN_USER, f.file);

Without having a iommu_domain to attach.

This is because of the giant special case that PPC made of VFIO's
IOMMU code. PPC (aka vfio_iommu_spapr_tce.c) requires the group
isolation that iommu_group_set_dma_owner() provides, but does not
actually have an iommu_domain and can not/does not call
iommu_attach_group().

Fixing this is a whole other giant adventure I'm hoping David will
help me unwind next year.. 

This series solves this problem by using the two step sequence of
iommu_group_set_dma_owner()/iommu_attach_group() and conceptually
redefining how iommu_attach_group() works to require the external
caller to have done the iommu_group_set_dma_owner() for it. This is
why the series has three APIs, because the VFIO special one assumes
external iommu_group_set_dma_owner(). It just happens that is exactly
the same code as iommu_attach_group() today.

As for why does DMA_OWNER_PRIVATE_DOMAIN_USER exist? VFIO doesn't have
an iommu_domain at this point but it still needs the iommu core to
detatch the default domain. This is what the _USER does.

Soo..

There is another way to organize this and perhaps it does make more
sense. I will try to sketch briefly in email, try to imagine the
gaps..

API family (== compares to this series):

   iommu_device_use_dma_api(dev);
     == iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);

   iommu_group_set_dma_owner(group, file);
     == iommu_device_set_dma_owner(dev, DMA_OWNER_PRIVATE_DOMAIN_USER,
                                   file);
     Always detaches all domains from the group

   iommu_attach_device(domain, dev)
     == as is in this patch
     dev and domain are 1:1

   iommu_attach_device_shared(domain, dev)
     == as is in this patch
     dev and domain are N:1
     * could just be the same as iommu_attach_device

   iommu_replace_group_domain(group, old_domain, new_domain)
     Makes group point at new_domain. new_domain can be NULL.

   iommu_device_unuse_dma_api(dev)
    == iommu_device_release_dma_owner() in this patch

   iommu_group_release_dma_owner(group)
    == iommu_detatch_group() && iommu_group_release_dma_owner()

VFIO would use the sequence:

   iommu_group_set_dma_owner(group, file);
   iommu_replace_group_domain(group, NULL, domain_1);
   iommu_replace_group_domain(group, domain_1, domain_2);
   iommu_group_release_dma_owner(group);

Simple devices would use

   iommu_attach_device(domain, dev);
   iommu_detatch_device(domain, dev);

Tegra would use:

   iommu_attach_device_shared(domain, dev);
   iommu_detatch_device_shared(domain, dev);
   // Or not, if people agree we should not mark this

DMA API would have the driver core dma_configure do:
   iommu_device_use_dma_api(dev);
   dev->driver->probe()
   iommu_device_unuse_dma_api(dev);

It is more APIs overall, but perhaps they have a much clearer
purpose. 

I think it would be clear why iommu_group_set_dma_owner(), which
actually does detatch, is not the same thing as iommu_attach_device().

I'm not sure if this entirely eliminates
DMA_OWNER_PRIVATE_DOMAIN_USER, or not, but at least it isn't in the
API.

Is it better?

> What VFIO wants is (conceptually[1]) "attach this device to my domain,
> provided it and any other devices in its group are managed by a driver I
> approve of." 

Yes, sure, "conceptually". But, there are troublesome details.

> VFIO will also need a struct device anyway, because once I get back from my
> holiday in the new year I need to start working with Simon on evolving the
> rest of the API away from bus->iommu_ops to dev->iommu so we can finally
> support IOMMU drivers coexisting[2].

For VFIO it would be much easier to get the ops from the struct
iommu_group (eg via iommu_group->default_domain->ops, or whatever).

> Indeed I agree with that second point, I'm just increasingly baffled how
> it's not clear to you that there is only one fundamental use-case here.
> Perhaps I'm too familiar with the history to objectively see how unclear the
> current state of things might be :/

I think it is because you are just not familiar with the dark corners
of VFIO. 

VFIO has a special case, I outlined above.

> > This is taking 426a to it's logical conclusion and *removing* the
> > group API from the drivers entirely. This is desirable because drivers
> > cannot do anything sane with the group.
> 
> I am in complete agreement with that (to the point of also not liking patch
> #6).

Unfortunately patch #6 is only because of VFIO needing to use the
group as a handle.

Jason
