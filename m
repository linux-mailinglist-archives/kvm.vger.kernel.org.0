Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C052126B65D
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIPADk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:03:40 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:42870 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgIOO3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 10:29:45 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60cfbd0000>; Tue, 15 Sep 2020 22:29:17 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 07:29:17 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Tue, 15 Sep 2020 07:29:17 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 14:29:15 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.55) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Sep 2020 14:29:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieHyflX0IxKGx+izojBHvJMWhu/46Lu6JFUXIRJsKQJLIIzibBbkgGbgzoNsIZ/tZAGyrPVOWuerkWqYFEuxfG3sI3d1M6ruam7rHVwKjn8nAI/Prr2I8xd31bzloTyZhuYlT/jqWhxVPP9swzOCW+2eA2xN30CzE+1H+fQlyv0ItFsJctuQ46jaKDz8SYR5UJhagWGc4W9eQpQnWh95lmylujObeo0nykrenC0OKCWu6k2Lxh9dEOMmRXkHIkL6FoCcK/7OMwmC4k/rNMthybszbt3LgOzG8l+v0N17sJoLxlA21RwVv4rU2xVCw/dQlpzWy6kRSoZLMugNzay+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azJw3bY8Rk5JJYNfDrY6V/sc95hljC5151l+msjnQfM=;
 b=VZJwpxl/W5c8PDAdHHGQcgPccbM3OfL00XqTFw9QXKrLBFc6NZbW/viU3KcnEY+QfNyvWyxxUzadCBY9Qlo3U8TKoVDGKitCkYaCTwwh0ksH1g6JlSof0a4KKUroq0Z0KWcrm7oBVSo6Uq1hq12WCHLbfGrda6gWU2MlfWLWyR1+m0AQWblNmODJLRhSFzmd83Ju2rZZGLp+2ZiZhwlsamVUbKZOndATXIrDAh9lhbNgqSZQqR49D6mp6l5VtD1O+nNROVG0sc0l2UuFTiToRbSWrDU/XuWmTTr+j+xVOMWdo/fbn6L76qzFNTCL9IF930d987Y6D/hffQK3ltTskA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2857.namprd12.prod.outlook.com (2603:10b6:5:184::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 15 Sep
 2020 14:29:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 14:29:09 +0000
Date:   Tue, 15 Sep 2020 11:29:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jacob.jun.pan@linux.intel.com>,
        <jun.j.tian@intel.com>, <yi.y.sun@intel.com>, <peterx@redhat.com>,
        <hao.wu@intel.com>, <stefanha@gmail.com>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200915142906.GX904879@nvidia.com>
References: <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <20200914133113.GB1375106@myrica> <20200914134738.GX904879@nvidia.com>
 <20200914162247.GA63399@otc-nc-03> <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home> <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home> <20200914190057.GM904879@nvidia.com>
 <20200914163310.450c8d6e@x1.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200914163310.450c8d6e@x1.home>
X-ClientProxiedBy: YQBPR01CA0116.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YQBPR01CA0116.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 14:29:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIBxC-006SkW-K8; Tue, 15 Sep 2020 11:29:06 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e48da425-6df3-4717-d628-08d85983b4e9
X-MS-TrafficTypeDiagnostic: DM6PR12MB2857:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28570074CDE332C8413707A7C2200@DM6PR12MB2857.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJOYAMzGFSWUlnI5bKS6DHc0GWaeaDd8sGtnBlDEkbqHe+o1+gyF6m7REUHfFtUix4yB9W0my7+ytpJfd/79wFAdsq2cITRgfbDyzkikw5madfAg4zRr8JWQK+MRwdpmPvAapfy44aF7YkVq+ml3kTM6WzSRN936XDAMdxjO8oFb3V+H/DIzstVhAS6PvnaPRZ5aXx6Fs5ocUhspml6sFLR6ljDEQH9jTcPyaYO89ZDrKaukBJ+C1erT2yZqgZ2vSn/W9WdplSgsSTHj5YN6v8fa6ExNrsPPE9kHha6XVVfRMuvndQQilNAjqsvoabvgt5/O+/4/vcJ15V/nKlU1YoGppj65jK6adEdCZNyev0/R4mRgGyhIpO2uhP3W5Nsu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(83380400001)(36756003)(7416002)(33656002)(9746002)(9786002)(86362001)(8936002)(6916009)(8676002)(4326008)(1076003)(2906002)(66556008)(66476007)(66946007)(478600001)(5660300002)(2616005)(54906003)(316002)(426003)(26005)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 72UPrs0Wd7ycrnI90b5wc2zoH0hRWnU8eyEDGDrr6U6qlVzFmmHOydxv4Cn71SByJNlpWvcafeF4fcEDCbFXA8A52Hi0cQVlzLapFl3JHmSEP7uBbF5M/4w5HQfXEVLQyyB8Na5Wn7z2nyCc+fS9gXaNaVouedsZrK3gdOSkow7B7qcgdXkrCFDlflvVk11/3eCJswxlDwXX1vEKU4Y2M3PvpRKLntSe3IU+0U0J1CsFUnW8yg2WkmSWZYMc47EPWyxNj7lwDYLkGZiMCy/cPeJbDzh/i+jAx+oc+ILPESVN70FB07+PjsqauzMY+y/4AQWLqYhLNomi0fFDD6xxY98JR9Ef/FU53QUKFEotc2B/C92AcRLRVOoImtbiqs+VgUHXEO9hpU3q+YCJFjUnZEZJY6BCOjXOfsfLGi40hIi65zKrINXnIYjvwWDEG3/aMI7/2EDGxpsoZNHOMhJG4xheNfEdImj7Chkh/0T6jrNTOHz8guZ9f1d4Sy/Snlp6JvDW35GZ5mgtSay7nmjkvRtOFMHbn6b59yoy8w23SwXsbm08nHPICafo7HDy78gGv/JGGhmXHRjQsMvUVCrtxOuiR7UowcgsC1DB7YjWdm1hfbHYBvt5KTrw7SZ/DC1WHu3V0tmMAXiFXiXoFBwSBg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e48da425-6df3-4717-d628-08d85983b4e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 14:29:09.0712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgWpLlsUe2rLXFLZonlf2NOqm0ap5Nw/Z/oi7K9+AU5rY0hXNTVaGoG6TIUiMC/2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2857
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600180157; bh=azJw3bY8Rk5JJYNfDrY6V/sc95hljC5151l+msjnQfM=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=FCOyjxFrCLWQxQ89i7OyeCj0/99Tl6qcl+TXZv/KNWtJ6vu/Bm/ioU+M0/7hSqBld
         ib9WoZwnvt0JUVfFd6Dl8QlfAmvXpXi39f3iajdM+IifCE5IGEVcz5zJrlyc7rnDgb
         /McpDbCln8RumtU9KAJMsjbwOlotr6KYK34qsZLzB4WvLdgxrsOWzQ469m8LLTYJqz
         /uV5QUfrQRDnyA6/xZRGasjzcs2Gxd/SeYyyssXRJHGP92NvU9vKGg6/CkrnL/VCBJ
         vRVoxFOavyDvxzmOcMptxhM/ruRIR3XPW8qGXLfAIPj3o0TwiGKkP6yTbSv22NPGhH
         AAMedAB2X+9Sg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 04:33:10PM -0600, Alex Williamson wrote:

> Can you explain that further, or spit-ball what you think this /dev/sva
> interface looks like and how a user might interact between vfio and
> this new interface? 

When you open it you get some container, inside the container the
user can create PASIDs. PASIDs outside that container cannot be
reached.

Creating a PASID, or the guest PASID range would be the entry point
for doing all the operations against a PASID or range that this patch
series imagines:
 - Map process VA mappings to the PASID's DMA virtual address space
 - Catch faults
 - Setup any special HW stuff like Intel's two level thing, ARM stuff, etc
 - Expose resource controls, cgroup, whatever
 - Migration special stuff (allocate fixed PASIDs)

A PASID is a handle for an IOMMU page table, and the tools to
manipulate it. Within /dev/sva the page table is just 'floating' and
not linked to any PCI functions

The open /dev/sva FD holding the allocated PASIDs would be passed to a
kernel driver. This is a security authorization that the specified
PASID can be assigned to a PCI device by the kernel.

At this point the kernel driver would have the IOMMU permit its
bus/device/function to use the PASID. The PASID can be passed to
multiple drivers of any driver flavour so table re-use is
possible. Now the IOMMU page table is linked to a device.

The kernel device driver would also do the device specific programming
to setup the PASID in the device, attach it to some device object and
expose the device for user DMA.

For instance IDXD's char dev would map the queue memory and associate
the PASID with that queue and setup the HW to be ready for the new
enque instruction. The IDXD mdev would link to its emulated PCI BAR
and ensure the guest can only use PASID's included in the /dev/sva
container.

The qemu control plane for vIOMMU related to PASID would run over
/dev/sva.

I think the design could go further where a 'PASID' is just an
abstract idea of a page table, then vfio-pci could consume it too as a
IOMMU page table handle even though there is no actual PASID. So qemu
could end up with one API to universally control the vIOMMU, an API
that can be shared between subsystems and is not tied to VFIO.

> allocating pasids and associating them with page tables for that
> two-stage IOMMU setup, performing cache invalidations based on page
> table updates, etc.  How does it make more sense for a vIOMMU to
> setup some aspects of the IOMMU through vfio and others through a
> TBD interface?

vfio's IOMMU interface is about RID based full device ownership,
and fixed mappings.

PASID is about mediation, shared ownership and page faulting.

Does PASID overlap with the existing IOMMU RID interface beyond both
are using the IOMMU?

> The IOMMU needs to allocate PASIDs, so in that sense it enforces a
> quota via the architectural limits, but is the IOMMU layer going to
> distinguish in-kernel versus user limits?  A cgroup limit seems like a
> good idea, but that's not really at the IOMMU layer either and I don't
> see that a /dev/sva and vfio interface couldn't both support a cgroup
> type quota.

It is all good questions. PASID is new, this stuff needs to be
sketched out more. A lot of in-kernel users of IOMMU PASID are
probably going to be triggered by userspace actions.

I think a cgroup quota would end up near the IOMMU layer, so vfio,
sva, and any other driver char devs would all be restricted by the
cgroup as peers.

> And it's not clear that they'll have compatible requirements.  A
> userspace idxd driver might have limited needs versus a vIOMMU backend.
> Does a single quota model adequately support both or are we back to the
> differences between access to a device and ownership of a device?

At the end of the day a PASID is just a number and the drivers only
use of it is to program it into HW.

All these other differences deal with the IOMMU side of the PASID, how
pages are mapped into it, how page fault works, etc, etc. Keeping the
two concerns seperated seems very clean. A device driver shouldn't
care how the PASID is setup.

> > > This series is a blueprint within the context of the ownership and
> > > permission model that VFIO already provides.  It doesn't seem like we
> > > can pluck that out on its own, nor is it necessarily the case that VFIO
> > > wouldn't want to provide PASID services within its own API even if we
> > > did have this undefined /dev/sva interface.  
> > 
> > I don't see what you do - VFIO does not own PASID, and in this
> > vfio-mdev mode it does not own the PCI device/IOMMU either. So why
> > would this need to be part of the VFIO owernship and permission model?
> 
> Doesn't the PASID model essentially just augment the requester ID IOMMU
> model so as to manage the IOVAs for a subdevice of a RID?  

I'd say not really.. PASID is very different from RID because PASID
must always be mediated by the kernel. vfio-pci doesn't know how to
use PASID because it doesn't know how to program the PASID into
a specific device. While RID is fully self contained with vfio-pci.

Further, with the SVA models, the mediated devices are highly likely
to be shared between a vfio-mdev and a normal driver, as IDXD
shows. Userspace will get PASID's for SVA and share the device equally
with vfio-mdev.

> What elevates a user to be able to allocate such resources in this
> new proposal?

AFAIK the target for the current SVA model is no limitation. User
processes can open their devices, establish SVA and go ahead with
their workload.

If you are asking about iommu groups.. For PASID the PCI
bus/device/function that is the 'control point' for PASID must be
secure and owned by the kernel. ie only the kernel can progam the
device to use a given PASID. P2P access from other devices under
non-kernel control must not be allowed, as they could program a device
to use a PASID the kernel would not authorize.

All of this has to be done regardless of VFIO's involvement..

> Do they need a device at all?  It's not clear to me why RID based
> IOMMU management fits within vfio's scope, but PASID based does not.

In RID mode vfio-pci completely owns the PCI function, so it is more
natural that VFIO, as the sole device owner, would own the DMA mapping
machinery. Further, the RID IOMMU mode is rarely used outside of VFIO
so there is not much reason to try and disaggregate the API.

PASID on the other hand, is shared. vfio-mdev drivers will share the
device with other kernel drivers. PASID and DMA will be concurrent
with VFIO and other kernel drivers/etc.

Thus it makes more sense here to have the control plane for PASID also
be shared and not tied exclusively to VFIO.

Jason
