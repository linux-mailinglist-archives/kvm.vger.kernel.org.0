Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683A54659C5
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 00:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243299AbhLAX22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 18:28:28 -0500
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:59616
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232038AbhLAX21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 18:28:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LroNM9eu1NmCCQgrxTPYqtEdyT+1R+rWh/61Vm9xd9wfgqefsMnEEmU3nfJ5nM2Hb1Jh8dwR4q7BKdGouQLU6UD114QyvYb1x8iQaNssFFljbpfKCasa2qPyMkrgYKAgHbELqkSadt+Y16Egq45HQWvxkaD+wjtqhLsokgYxNkEg/g4nMTzrrKFUjbJP4gOhZakMB7mj5OhDdb/dXmj4RcTm/SlyH85uwoYK6s2TybHnCITn97XI9Fgdyg3DiD8Tm8SS+4hFQ0ABdSoVmSITjImGXM/6+3d2MSBek7F054d6/cd1e6/j2wWw6ntDrBrphTP0C4NzE3tmDukX/PmVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbTJULDyJyYbRkWI2S+GIS2hKSLWpO7rNTv1ob4JEkM=;
 b=MM12gMpY+JF9Kmr3NnETYYSJa9Wz7Bf/sNg7uZgVgXrJe9VK2uZYiMOpASlsGYjtvA8xNnJsj0UWNmEm8O1ZKVVYAUAI/730BTFvXAsBoPh2GXtEnrrHrRcZm9iZ1vE5xe05HXsl5Pajh6XX2cSVgwtdHdBgtoLQGKOACfmZECI/QNtmQgICq+Z3ZeclJU4ztu8CdlIkAAkwVXSA510OmkkGJne51iNFrrtqIoWYf7XbfvyRXCKVa7Py6HFzfCdLNtwb8KIIU0S79yOsk3Rg/6x+sC0iPTcR/eKL7J8534Y1+k4SQPcPnUEttj/kOF7Fkvq94hIuF7dUtf+L4zoRfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbTJULDyJyYbRkWI2S+GIS2hKSLWpO7rNTv1ob4JEkM=;
 b=aTFZCQRqH/awimYiTyj1yJHvPMfZtMgHQZw3uBGKNB5Sdip1PgBvAAY1pmJl9RiEcdhGItHjWNVZZj35zda6JCoPKpJ+UW32oxRb6Dty5tUHdCI5MHo6P4+4BewKyKpT4t/746XQuVKfbArT14MU4t7quc5MCZS5euURrHe/V1iC91qmyWqhSc1PFUI5bIRzlb+qWDARF9zlDmx+vAnzo/VQPZNdHiUfSydnBQDlaltHDM/mFrJZSguzWAeOtMDFtFxM3/R1sSEe+xK2x1ykmwbLxZaE1qGAOWnbyG9Le7l8YwM8v0cM/V9KzO/kNmsVRuKhSQD/mV9MRab17mkW7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5261.namprd12.prod.outlook.com (2603:10b6:5:398::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Wed, 1 Dec 2021 23:25:04 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::1569:38dd:26fb:bf87]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::1569:38dd:26fb:bf87%8]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 23:25:04 +0000
Date:   Wed, 1 Dec 2021 19:25:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211201232502.GO4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201130314.69ed679c@omen>
X-ClientProxiedBy: BL0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:2d::25) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:208:2d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Wed, 1 Dec 2021 23:25:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1msYyE-006cx0-Mq; Wed, 01 Dec 2021 19:25:02 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b63fd9d3-4046-45af-3a73-08d9b521cd9b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5261:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5261F2C7666503468E8DEA02C2689@DM4PR12MB5261.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUdPNKeWfsOjTrMeGKPnzfVMHwSR6qVMYcHutXRFqjbn0mfzHaIssZu/dT0zH8fv8VG2vzMdtRoB9J7+XPvKl5uxFp5FYwoTZyWsD+TKQb0M+9H5DiNEud4U7ZKO2tQ87snwiGcd2s0Tkp2X6tyu+EM8ywfbh29D6BhoV4jk1TYu+Cu15cJySnlqnl6y9CL8/rB+MYD64fIQX1O/T2qc3erP6UE9k1ilr/2d1xpd8sPOQm4P3kPWFtyno0mL1PGtwaFOJZOfvMoC+AQ8kPsrV3EFppna+hpGPPEDJxBOq2pH+hgm0LPYthGKBo0a1q0MUiiEnZnLEzYl62MLpzgLxtMXvtLVkBBG9qg9YAoS+VWJV/nCzjmt/HgfySSfdGoXAE+oDLeD3XYYzb+W8nY+HgZGNe0OSGDh6IWjdJ0fY1VVXXURydXWhhIAu+B4ZyPFtRYnh/Adi+lpoDR6yb3qvzXMhdlPbShmZbl1h5Gr/6yhH9d0fhBEAso7SeMqkJx6k/SdeeRXqCwG30IXkr2pI79py/psavBZqtX+0FOERkrXrrYPT0Pt5a7XtCrsS0ulTl1G97+CdoVEI9SOH45b8j8vqWVzSOZ7USqfm2UDBtmn5sSJ4yHC6Wf/P1MEkakYlzeP3VJFhTgjD8gogv4kYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(186003)(1076003)(66946007)(8676002)(86362001)(508600001)(26005)(2906002)(36756003)(4326008)(426003)(316002)(54906003)(9746002)(83380400001)(6916009)(5660300002)(107886003)(2616005)(8936002)(66556008)(66476007)(9786002)(30864003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0YQb3l7OTYBoH+HJPxbTCV1f1KMpZcAvxU+TK7bveyWbx9nbQlpfynb80PKH?=
 =?us-ascii?Q?a80ybeQN9501OjGMeqwO8I8xaSo0awy8XpePInxDwS6erX8hyTN4QP1ExmYc?=
 =?us-ascii?Q?tL1qtfLGOqq+v0/GUvWX4GhM6lXuqat/7ZpoIRQag+EKYyM1H1JYaqKjqnt0?=
 =?us-ascii?Q?4d0m0LOKhhqaw/Yedy5T2+0/GJu68UrJFYWl7r9wjCFGQHjYv4env1q5OQHN?=
 =?us-ascii?Q?W9LEW5J9+dcGjWjV+v+sdAwKGkVXL2LTgYr4j/cdUr6uOAR7KVXR8hNZMd1y?=
 =?us-ascii?Q?enqTChtpcd6dMVa3DIUmjw5lfIwzLU54dBIVRuZUYdMwVFkBZIPe00rYG/Bk?=
 =?us-ascii?Q?vjdy97TYFJZkahis5/RX5LZWaGJGXXt4XS4eGpUioG/l+D1JWKWR/z0+hU+8?=
 =?us-ascii?Q?3FM4VdJjXJoD5var6oH6Bdc00/nAGFV1PSg/KRLGXCUY7ussiezbD5yF95wV?=
 =?us-ascii?Q?JAw6QfCHlEt67aviLAKijJb86BBnc9xN2TZx9a7b3fgx7dkb3yDWL+hp6Pa+?=
 =?us-ascii?Q?l3WWnOicsfCTXgluEAtcB9jnNwH1mVbR3uvKSq0919c20pt3GfWKOqVsy438?=
 =?us-ascii?Q?icKGOc4r/auoZsgEfy69cE4Ga6oOER9FgoyKo/AK4HTJvkXkCVw8XAURZx9T?=
 =?us-ascii?Q?8SzXNeyMYskuUlrVxf21OjbyF4MghOgGW2+6MZMDq8STlALVNRydyHa2YKXq?=
 =?us-ascii?Q?EHaRXls9v37BgC2ef/rkKOreELLHili4L83aK65GzVYsW5nTl/tQZMvpLDIo?=
 =?us-ascii?Q?etUoCwFHIJCz8fXxsz8Cfrh0oFzTxX50Gq5LPgKZL4yU+5DarlIiNdDycDu4?=
 =?us-ascii?Q?MyafjVkCfOgp9ZCaV6Nnj1nzZxEP5/T8kHCdEHK2b2jI+S6XHw+fOXw0exNh?=
 =?us-ascii?Q?CNQccNb8f+FFb22/DKtaHFgXiPVBW6LeZUBpKLrziqeekMHV7OqGCCQVkfqX?=
 =?us-ascii?Q?dMYaDVrEbfAjreiLoS1ldLheZ9fMfKMiK8PUXtlGbC4ygtGe4dB8Aiqnp65T?=
 =?us-ascii?Q?Qb7yKrPQzWrUgqNNgMEfz9O/Ae9aINPVt14LLDQgwS7/Jn202vpdihjr3J4G?=
 =?us-ascii?Q?Uv7Wqu0Iz20z30lSv9b9syo0pvru7wdVEeQgdyNSKlwD31doGz4DxybIbDrD?=
 =?us-ascii?Q?UBd6iv8if8ZMT33/WnpHqUKIpv3cDEOBAodtCqPfvtaKb5SsyJ+Z6udUPFcf?=
 =?us-ascii?Q?wt1Exd1hUcmzQk0vPS1TbiNcrGsxToikVcrah0wFtWS4qQMTYdzf7Fovi3VQ?=
 =?us-ascii?Q?6F6+iA306eER5zAGVsmws6/6ks1hbDm6BltMN/anGOqTE3pM2kTWT/bLQ2th?=
 =?us-ascii?Q?A+OR/h5NDZ+M2Z0YpuLNjFKB8cA+9mjd5mkwmOzcAyXntqMQe/xOChKzwBAs?=
 =?us-ascii?Q?UVIrLCiulhtediztKHyuaUmVLsSvf9rcAy5WwLbSxTpEslgAtXOqlae0+myh?=
 =?us-ascii?Q?aMGBVH18+R00dTSzeRXb3TPDSSTQTUTPZjjwZHvUp3kqxmRB4lRUth1IB6Yh?=
 =?us-ascii?Q?1xawCdenRHvKpDlU94HPssHfZWEZ8ExnOQQbAb15kwSOrhZgk/zwxNI6Ex6I?=
 =?us-ascii?Q?uwB91XA21eAyFPymrHI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63fd9d3-4046-45af-3a73-08d9b521cd9b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 23:25:04.0573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAwlTGG8GTph5ycjB8oxhyBHKwIWN47zQG0F+1i7ud1DAA0Rn0XId66GV/wprapE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5261
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021 at 01:03:14PM -0700, Alex Williamson wrote:
> On Tue, 30 Nov 2021 23:14:07 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Nov 30, 2021 at 03:35:41PM -0700, Alex Williamson wrote:
> > 
> > > > From what HNS said the device driver would have to trap every MMIO to
> > > > implement NDMA as it must prevent touches to the physical HW MMIO to
> > > > maintain the NDMA state.
> > > > 
> > > > The issue is that the HW migration registers can stop processing the
> > > > queue and thus enter NDMA but a MMIO touch can resume queue
> > > > processing, so NDMA cannot be sustained.
> > > > 
> > > > Trapping every MMIO would have a huge negative performance impact.  So
> > > > it doesn't make sense to do so for a device that is not intended to be
> > > > used in any situation where NDMA is required.  
> > > 
> > > But migration is a cooperative activity with userspace.  If necessary
> > > we can impose a requirement that mmap access to regions (other than the
> > > migration region itself) are dropped when we're in the NDMA or !RUNNING
> > > device_state.    
> > 
> > It is always NDMA|RUNNING, so we can't fully drop access to
> > MMIO. Userspace would have to transfer from direct MMIO to
> > trapping. With enough new kernel infrastructure and qemu support it
> > could be done.
> 
> This is simply toggling whether the mmap MemoryRegion in QEMU is
> enabled, when not enabled access falls through to the read/write access
> functions.  We already have this functionality for unmasking INTx
> interrupts when we don't have EOI support.
>
> > Even so, we can't trap accesses through the IOMMU so such a scheme
> > would still require removing IOMMU acess to the device. Given that the
> > basic qemu mitigation for no NDMA support is to eliminate P2P cases by
> > removing the IOMMU mappings this doesn't seem to advance anything and
> > only creates complexity.
> 
> NDMA only requires that the device cease initiating DMA, so I suppose
> you're suggesting that the MMIO of a device that doesn't expect to make
> use of p2p DMA could be poked through DMA, which might cause the device
> to initiate a DMA and potentially lose sync with mediation.  That would
> be bad, but seems like a non-issue for hns.

Yes, not sure how you get to a non-issue though? If the IOMMU map is
present the huawei device can be attacked by a hostile VM and forced
to exit NDMA. All this takes is any two DMA capable devices to be
plugged in?

> > At least I'm not going to insist that hns do all kinds of work like
> > this for a edge case they don't care about as a precondition to get a
> > migration driver.
> 
> I wonder if we need a region flag to opt-out of IOMMU mappings for
> devices that do not support p2p use cases.  If there were no IOMMU
> mappings and mediation handled CPU driven MMIO accesses, then we'd have
> a viable NDMA mode for hns.

This is a good idea, if we want to make huawei support NDMA then
flagging it to never be in the iommu map in the first place is a great
solution. Then they can use CPU mmio trapping get the rest of the way.

> > > There's no reason that mediation while in the NDMA state needs to
> > > impose any performance penalty against the default RUNNING state.   
> > 
> > Eh? Mitigation of no NDMA support would have to mediate the MMIO on a
> > a performance doorbell path, there is no escaping a performance
> > hit. I'm not sure what you mean
> 
> Read it again, I'm suggesting that mediation during NDMA doesn't need
> to carry over any performance penalty to the default run state.  We
> don't care if mediation imposes a performance penalty while NDMA is set,
> we're specifically attempting to quiesce the device.  The slower it
> runs the better ;)

OK, I don't read it like that. It seems OK to have a performance hit
in NDMA since it is only a short grace state.

> > It would make userspace a bit simpler at the cost of excluding or
> > complicating devices like hns for a use case they don't care about.
> > 
> > On the other hand, the simple solution in qemu is when there is no
> > universal NDMA it simply doesn't include any MMIO ranges in the
> > IOMMU.
> 
> That leads to mysterious performance penalties when a VM was previously
> able to make use of (ex.) GPUDirect, 

Not a penalty it will just explode somehow. There is no way right now
for a VM to know P2P doesn't work. It is one of these annoying things
that leaks to the VMM like the no-snoop mess. A VMM installing a
device combination that is commonly used with P2P, like a GPU and a
NIC, had a better make sure P2P works :)

> but adds an hns device and suddenly can no longer use p2p.  Or
> rejected hotplugs if a device has existing NDMA capable devices, p2p
> might be active, but the new device does not support NDMA.  

I don't think qemu can go back on what it already did, so rejected
hotplug seems the only choice.

> This all makes it really complicated to get deterministic behavior
> for devices.  I don't know how to make QEMU behavior predictable and
> supportable in such an environment.

And this is the thing that gives me pause to think maybe the huawei
device should do the extra work?

On the other hand I suspect their use case is fine with qemu set to
disable P2P completely.

OTOH "supportable" qemu could certainly make the default choice to
require devices for simplicity.

> > Since qemu is the only implementation it would be easy for drivers to
> > rely on the implicit reset it seems to do, it seems an important point
> > that should be written either way.
> > 
> > I don't have a particular requirement to have the reset, but it does
> > seem like a good idea. If you feel strongly, then let's say the
> > opposite that the driver must enter RESUME with no preconditions,
> > doing an internal reset if required.
> 
> It seems cleaner to me than unnecessarily requiring userspace to pass
> through an ioctl in order to get to the next device_state.

Ok, I'll add something like this.

> > Can you point to something please? I can't work with "I'm not sure"
> 
> The reset behavior that I'm trying to clarify above is the primary
> offender, but "I'm not sure" I understand the bit prioritization enough
> to know that there isn't something there as well.  I'm also not sure if
> the "end of stream" phrasing below matches the uAPI.

Realistically I think userspace should not make use of the bit
prioritization. It is more as something driver implementors should
follow for consistent behavior.
 
> > IMO the header file doesn't really say much and can be read in a way
> > that is consistent with this more specific document.
> 
> But if this document is suggesting the mlx5/QEMU interpretation is the
> only valid interpretations for driver authors, those clarifications
> should be pushed back into the uAPI header.

Can we go the other way and move more of the uAPI header text here?

> > I have no idea anymore. You asked for docs and complete picture as a
> > percondition for merging a driver. Here it is.
> > 
> > What do you want?
> 
> Looking through past conversations, I definitely asked that we figure
> out how NDMA is going to work.  Are you thinking of a different request
> from me?

It was part of the whole etherpad thing. This was what we said we'd do
to resolve the discussion.

I expect to come to some agreement with you and Connie on this text
and we will go ahead.
 
> The restriction implied by lack of NDMA support are pretty significant.
> Maybe a given device like hns doesn't care because they don't intend to
> support p2p, but they should care if it means we can't hot-add their
> device to a VM in the presences of devices that can support p2p and if
> cold plugging their device into an existing configuration implies loss
> of functionality or performance elsewhere.
> 
> I'd tend to expect though that we'd incorporate NDMA documentation into
> the uAPI with a formal proposal for discovery and outline a number of
> those usage implications.

Yishai made a patch, but we have put the discussion of NDMA here, not
hidden in a commit message
 
> > > We've tried to define a specification that's more flexible than a
> > > single implementation and by these standards we seem to be flipping
> > > that implementation back into the specification.  
> > 
> > What specification!?! All we have is a couple lines in a header file
> > that is no where near detailed enough for multi-driver
> > interoperability with userspace. You have no idea how much effort has
> > been expended to get this far based on the few breadcrumbs that were
> > left, and we have access to the team that made the only other
> > implementation!
> > 
> > *flexible* is not a specification.
> 
> There are approximately 220 lines of the uAPI header file dealing
> specifically with the migration region.  A bit more than a couple.

Unfortunately more than half of that describes how the data window
works, and half of the rest is kind of obvious statements.

> We've tried to define it by looking at the device requirements to
> support migration rather than tailor it specifically to the current QEMU
> implementation of migration.  Attempting to undo that generality by
> suggesting only current usage patterns are relevant is therefore going
> to generate friction.

In your mind you see generality, in our mind we want to know how to
write an inter operable driver and there is no documention saying how
to do that.

> > > Userspace can attempt RESUMING -> RUNNING regardless of what we specify,
> > > so a driver needs to be prepared for such an attempted state change
> > > either way.  So what's the advantage to telling a driver author that
> > > they can expect a given behavior?  
> > 
> > The above didn't tell a driver author to expect a certain behavior, it
> > tells userspace what to do.
> 
>   "The migration driver can rely on user-space issuing a
>    VFIO_DEVICE_RESET prior to starting RESUMING."

I trimmed too much, the original text you quoted was

"To abort a RESUMING issue a VFIO_DEVICE_RESET."

Which I still think is fine.

> Tracing that shows a reset preceding entering RESUMING doesn't suggest
> to me that QEMU is performing a reset for the specific purpose of
> entering RESUMING.  Correlation != causation.

Kernel doesn't care why qemu did it - it was done. Intent doesn't
matter :)

> The order I see in the v5 mlx5 post is:
> 
> if RUNNING 1->0
>   quiesce + freeze
> if RUNNING or SAVING change && state == !RUNNING | SAVING
>   save device state
> if RESUMING 0->1
>   reset device state
> if RESUMING 1->0
>   load device state
> if RUNNING 0->1
>   unfreeze + unquiesce

Right, which matches the text:

 - !RUNNING
 - SAVING | !RUNNING
 - RESUMING
 - !RESUMING
 - RUNNING
 
> So maybe part of my confusion stems from the fact that the mlx5 driver
> doesn't support pre-copy, which by the provided list is the highest
> priority.  

Right.

> But what actually makes that the highest priority?  Any
> combination of SAVING and RESUMING is invalid, so we can eliminate
> those.  We obviously can't have RUNNING and !RUNNING, so we can
> eliminate all cases of !RUNNING, so we can shorten the list relativeto
> prioritizing SAVING|RUNNING to:

There are several orders that can make sense. What we've found is
following the reference flow order has given something workable for
precedence.

> SAVING | RUNNING would need to be processed after !RESUMING, but
> maybe before RUNNING itself.

It is a good point, it does make more sense after RUNNING as a device
should be already RUNNING before entering pre-copy. I moved it to
before !NDMA

> NDMA only requires that the device cease initiating DMA before the call
> returns and it only has meaning if RUNNING, so I'm not sure why setting
> NDMA is given any priority.  I guess maybe we're trying
> (unnecessarily?) to preempt any DMA that might occur as a result of
> setting RUNNING (so why is it above cases including !RUNNING?)?

Everything was given priority so there is no confusing omission. For
the order, as NDMA has no meaning outside RUNNING, it makes sense you'd
do a NDMA before making it meaningless / after making it meaningful.

This is made concrete by mlx5's scheme that always requires quiesce
(NDMA) to happen before freeze (!RUNNING) and viceversa, so we get to
this order. mlx5 implicitly does NDMA on !RUNNING 

> Obviously presenting a priority scheme without a discussion of the
> associativity of the states and a barely sketched out nomenclature is
> really not inviting an actual understanding how this is reasoned (imo).

Sure, but how we got here isn't really important to the intent of the
document to guide implementors.

Well, you wrote a lot, and found a correction, but I haven't been left
with a way to write this more clearly? Now that you obviously
understand what it is saying, what do you think?

> I'm feeling like there's a bit of a chicken and egg problem here to
> decide if this is sufficiently clear documentation before a new posting
> of the mlx5 driver where the mlx5 driver is the authoritative source
> for the reasoning of the priority scheme documented here (and doesn't
> make use of pre-copy).

I wouldn't fixate on the ordering, it is a small part of the
document..

> The migration data stream is entirely opaque to userspace, so what's
> the benefit to userspace to suggest anything about the content in each
> phase?  This is presented in a userspace edge concerns section, but the
> description is much more relevant to a driver author.

It is informative for the device driver author to understand what
device functionality to map to this.

> > > I think the fact that a user is not required to run the pre-copy
> > > phase until completion is also noteworthy.  
> > 
> > This text doesn't try to detail how the migration window works, that
> > is a different large task. The intention is that the migration window
> > must be fully drained to be successful.
> 
> Clarification, the *!RUNNING* migration window must be fully drained.
> 
> > I added this for some clarity ""The entire migration data, up to each
> > end of stream must be transported from the saving to resuming side.""
> 
> Per the uAPI regarding pre-copy:
> 
>   "The user must not be required to consume all migration data before
>   the device transitions to a new state, including the stop-and-copy
>   state."
> 
> If "end of stream" suggests the driver defined end of the data stream
> for pre-copy rather than simply the end of the user accumulated data
> stream, that conflicts with the uAPI.  Thanks,

Hmm, yes. I can try to clarify how this all works better. We don't
implement pre-copy but it should still be described better than it has
been.

I'm still not sure how this works. 

We are in SAVING|RUNNING and we dump all the dirty data and return end
of stream.

We stay in SAVING|RUNNING and some more device state became dirty. How
does userspace know? Should it poll and see if the stream got longer?

Below is what I collected from your feedback so far

Thanks,
Jason

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index d9be47570f878c..2ff47823a889b4 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -258,7 +258,9 @@ Setting/clearing bit groups triggers device action, and each bit controls a
 continuous device behavior.
 
 Along with the device_state the migration driver provides a data window which
-allows streaming migration data into or out of the device.
+allows streaming migration data into or out of the device. The entire
+migration data, up to the end of stream must be transported from the saving to
+resuming side.
 
 A lot of flexibility is provided to user-space in how it operates these
 bits. What follows is a reference flow for saving device state in a live
@@ -299,12 +301,9 @@ entities (VCPU_RUNNING and DIRTY_TRACKING) the VMM controls fit in.
 and the reference flow for resuming:
 
   RUNNING
-     Issue VFIO_DEVICE_RESET to clear the internal device state
-  0
-     Device is halted
+     Use ioctl(VFIO_GROUP_GET_DEVICE_FD) to obtain a fresh device
   RESUMING
-     Push in migration data. Data captured during pre-copy should be
-     prepended to data captured during SAVING.
+     Push in migration data.
   NDMA | RUNNING
      Peer to Peer DMA grace state
   RUNNING, VCPU_RUNNING
@@ -315,48 +314,73 @@ states act as cross device synchronization points. The VMM must bring all
 devices to the grace state before advancing past it.
 
 The above reference flows are built around specific requirements on the
-migration driver for its implementation of the migration_state input.
+migration driver for its implementation of the device_state input.
 
-The migration_state cannot change asynchronously, upon writing the
-migration_state the driver will either keep the current state and return
+The device_state cannot change asynchronously, upon writing the
+device_state the driver will either keep the current state and return
 failure, return failure and go to ERROR, or succeed and go to the new state.
 
-Event triggered actions happen when user-space requests a new migration_state
-that differs from the current migration_state. Actions happen on a bit group
+Event triggered actions happen when user-space requests a new device_state
+that differs from the current device_state. Actions happen on a bit group
 basis:
 
+ SAVING
+   The device clears the data window and prepares to stream migration data.
+   The entire data from the start of SAVING to the end of stream is transfered
+   to the other side to execute a resume.
+
  SAVING | RUNNING
-   The device clears the data window and begins streaming 'pre copy' migration
-   data through the window. Devices that cannot log internal state changes
-   return a 0 length migration stream.
+   The device beings streaming 'pre copy' migration data through the window.
+
+   A device that does not support internal state logging should return a 0
+   length stream.
+
+   The migration window may reach an end of stream, this can be a permanent or
+   temporary condition.
+
+   User space can do SAVING | !RUNNING at any time, any in progress transfer
+   through the migration window is carried forward.
+
+   This allows the device to implement a dirty log for its internal state.
+   During this state the data window should present the device state being
+   logged and during SAVING | !RUNNING the data window should transfer the
+   dirtied state and conclude the migration data.
+
+   The state is only concerned with internal device state. External DMAs are
+   covered by the separate DIRTY_TRACKING function.
 
  SAVING | !RUNNING
-   The device captures its internal state that is not covered by internal
-   logging, as well as any logged changes.
+   The device captures its internal state and streams it through the
+   migration window.
 
-   The device clears the data window and begins streaming the captured
-   migration data through the window. Devices that cannot log internal state
-   changes stream all their device state here.
+   When the migration window reaches an end of stream the saving is concluded
+   and there is no further data. All of the migration data streamed from the
+   time SAVING starts to this final end of stream is concatenated together
+   and provided to RESUMING.
+
+   Devices that cannot log internal state changes stream all their device
+   state here.
 
  RESUMING
    The data window is cleared, opened, and can receive the migration data
-   stream.
+   stream. The device must always be able to enter resuming and it may reset
+   the device to do so.
 
  !RESUMING
    All the data transferred into the data window is loaded into the device's
-   internal state. The migration driver can rely on user-space issuing a
-   VFIO_DEVICE_RESET prior to starting RESUMING.
+   internal state.
 
-   To abort a RESUMING issue a VFIO_DEVICE_RESET.
+   The internal state of a device is undefined while in RESUMING. To abort a
+   RESUMING and return to a known state issue a VFIO_DEVICE_RESET.
 
    If the migration data is invalid then the ERROR state must be set.
 
-Continuous actions are in effect when migration_state bit groups are active:
+Continuous actions are in effect when device_state bit groups are active:
 
  RUNNING | NDMA
    The device is not allowed to issue new DMA operations.
 
-   Whenever the kernel returns with a migration_state of NDMA there can be no
+   Whenever the kernel returns with a device_state of NDMA there can be no
    in progress DMAs.
 
  !RUNNING
@@ -384,24 +408,24 @@ Continuous actions are in effect when migration_state bit groups are active:
    during ERROR to avoid corrupting other devices or a VM during a failed
    migration.
 
-When multiple bits change in the migration_state they may describe multiple
-event triggered actions, and multiple changes to continuous actions.  The
-migration driver must process them in a priority order:
+When multiple bits change in the device_state they may describe multiple event
+triggered actions, and multiple changes to continuous actions.  The migration
+driver must process the new device_state bits in a priority order:
 
- - SAVING | RUNNING
  - NDMA
  - !RUNNING
  - SAVING | !RUNNING
  - RESUMING
  - !RESUMING
  - RUNNING
+ - SAVING | RUNNING
  - !NDMA
 
 In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
 device back to device_state RUNNING. When a migration driver executes this
-ioctl it should discard the data window and set migration_state to RUNNING as
+ioctl it should discard the data window and set device_state to RUNNING as
 part of resetting the device to a clean state. This must happen even if the
-migration_state has errored. A freshly opened device FD should always be in
+device_state has errored. A freshly opened device FD should always be in
 the RUNNING state.
 
 The migration driver has limitations on what device state it can affect. Any
@@ -438,8 +462,9 @@ implementing migration:
   As Peer to Peer DMA is a MMIO touch like any other, it is important that
   userspace suspend these accesses before entering any device_state where MMIO
   is not permitted, such as !RUNNING. This can be accomplished with the NDMA
-  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
-  device does not support NDMA and rely on that to guarantee quiet MMIO.
+  state. Userspace may also choose to never install MMIO mappings into the
+  IOMMU if devices do not support NDMA and rely on that to guarantee quiet
+  MMIO.
 
   The Peer to Peer Grace States exist so that all devices may reach RUNNING
   before any device is subjected to a MMIO access.
@@ -458,16 +483,6 @@ implementing migration:
   Device that do not support NDMA cannot be configured to generate page faults
   that require the VCPU to complete.
 
-- pre-copy allows the device to implement a dirty log for its internal state.
-  During the SAVING | RUNNING state the data window should present the device
-  state being logged and during SAVING | !RUNNING the data window should present
-  the unlogged device state as well as the changes from the internal dirty log.
-
-  On RESUME these two data streams are concatenated together.
-
-  pre-copy is only concerned with internal device state. External DMAs are
-  covered by the separate DIRTY_TRACKING function.
-
 - Atomic Read and Clear of the DMA log is a HW feature. If the tracker
   cannot support this, then NDMA could be used to synthesize it less
   efficiently.
@@ -476,14 +491,23 @@ implementing migration:
   are pushed down to the next step in the sequence and various behaviors that
   rely on NDMA cannot be used.
 
-- Migration control registers inside the same iommu_group as the VFIO device.
-  This immediately raises a security concern as user-space can use Peer to Peer
-  DMA to manipulate these migration control registers concurrently with
+  NDMA is made optional to support simple HW implementations that either just
+  cannot do NDMA, or cannot do NDMA without a performance cost. NDMA is only
+  necessary for special features like P2P and PRI, so devices can omit it in
+  exchange for limitations on the guest.
+
+- Devices that have their HW migration control MMIO registers inside the same
+  iommu_group as the VFIO device have some special considerations. In this
+  case a driver will be operating HW registers from kernel space that are also
+  subjected to userspace controlled DMA due to the iommu_group.
+
+  This immediately raises a security concern as user-space can use Peer to
+  Peer DMA to manipulate these migration control registers concurrently with
   any kernel actions.
 
   A device driver operating such a device must ensure that kernel integrity
   cannot be broken by hostile user space operating the migration MMIO
-  registers via peer to peer, at any point in the sequence. Notably the kernel
+  registers via peer to peer, at any point in the sequence. Further the kernel
   cannot use DMA to transfer any migration data.
 
   However, as discussed above in the "Device Peer to Peer DMA" section, it can
