Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DE9399156
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhFBRVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 13:21:17 -0400
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:41569
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230256AbhFBRVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 13:21:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSfUVqzjz1aG+cONE1Mptmb5gLeRsjAFXHuVJfi5cEqyd3vFenwvMM6BWjtY3bjtaZwFMnzVjiaiESA8loLUZ8p+LM0zraaTbhPTgsgxXnXy5+o7k3Bu4QolHw1CM3dnxNV3pPghPfiY66ZA8ncHKEm3kuHIR5CCRYdQMN6beAmrdfkxC5nef6tGl35aAUN9N62NNTbu3D9pzTuv+DOJI+wa8XmF/3GCQgzuo701eLpVpRW7TM+n7VpyXQFT7uvzBzON7v9mekIbsqLVQrrFjlAEy7AhhHhlSvKONaoGJxgHgM45/a5D/ypUgU9D33NVtIt5/pX+irjerqIPzluiqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3STWdXf3rxopN9TDJAyQsapnZPDmYN5z27l68nTbOh4=;
 b=YFOViJSfXBpbCczA6AtDtPTSXAbzw8tD0w4AcVCFXXqtK2kccch5jkJnxYVj9MgfDWWHJR8DgLC26qEJ58LAqsC/v8RIpJC9boPuPDUJszvwA/iLQ5id7BSAHAc4XVxx2MjEf1fQSClKMV7LY7Ouql427AIa1ktkcpa9lYxvlfrdpQxK4YmFJpyj2qzORd9hy3YP936LQBflsSMtlw88kIk9xyUFbvXgcPkZ/a3V8pz4w9AKRveRMvYWgoJumz+eH6Wn+aq/04LtOC7ZYKplERhMvRBb67wVzQkr36HXOXewGdxFQGfTOu0XM2C2bfF4CFKGyHwBQHj2wvCXR7cn6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3STWdXf3rxopN9TDJAyQsapnZPDmYN5z27l68nTbOh4=;
 b=iu8tG7v7Trm1e/RsIsyMY2TWr+ax5oYNGDsMRc/iChnpbsCmRsf6yoUh7ZjtsXxTDHxejOdZV57IEtBna9woQINW/pt9+aB9KHTXqxLgmY+ruYXUhAF4JQd+q6mLWF+TIM8res/6dudnfBQCF5aqen+b9HBKDLGs1Vu1eUm2TldLC9bLL/lpk30w8QpTfSQ+GUO0Dbxkaxw9G0sInVyu5pJNGdJaBzxjlwBM6nIGu2hOKW4nv7V+GNb0F3sw6WDdBeuJ/+rqlhcxBLw8/AMG5v1SlEuFyf8xFOtpOgykSXi2HDQaBzas6a0i+p7ciCd553SM18cHzZAnqadqyZ54Kw==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 17:19:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 17:19:32 +0000
Date:   Wed, 2 Jun 2021 14:19:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602171930.GB1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLch6zbbYqV4PyVf@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:32b::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0001.namprd03.prod.outlook.com (2603:10b6:208:32b::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Wed, 2 Jun 2021 17:19:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loUWg-000IO2-D5; Wed, 02 Jun 2021 14:19:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a6461ce-1c2b-4c1c-c73c-08d925ea95e6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51113B5BBB7790C1830AF1CCC23D9@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QP3imWVYudEG6f2T0AMnM6EnDvRuKR2Wcr4usJSayeuhHeLlfAUOUo2dKLVCiRVVwK+LXpCeVJprtH3vw4pHPSYbvAbu5PFxmTBlIi2Gjr0TiDGvfi72zjOrrVUGZdXE/7tYikBy8DUG2ifdNOaKtuZG2UhN0cFNJtAPFT+/SUksccSPq8nQaTrVep68AvWdbKF032bSnz1nnS6NMw8a/s7ByojNs8e7ak1/etUbSlFRu4+1jNZWVY3QEiQf7xauYxvKuQs0971o+F6OyHbGj0KsY/o8bA3MzqCMbZLywMyV8C/N7quQFU7PFliCLZAaCFll/Qv+bdFGIJrPKcCh+Wev24IRmNjssz++1obWYjJ8iRvmZu/+Xp8st3HjHdzlCRZCkH6yqw7v9VCXfg7J+PKtcYxlJ3X9zHKhZZ+0bSDO51I+Aal2yTg5Ly2a7MqnzvuYKBeNvi3jqous6r9WpLZgREibG8O3TlL2vWqVs4wFVkIEAg6m9rgNxE7SQ9x//8fB9kUeAA+kRVQfasJSxsaOAgSOinw5DyNmS8C5d6HAY1cNqx4vi0LiH7Z3VVF4IJ5Tw3dhBJpvNC+jehJ5LK+33iykm79+E6YBEpn/6/0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(38100700002)(316002)(9746002)(4326008)(33656002)(9786002)(8936002)(426003)(54906003)(1076003)(6916009)(186003)(26005)(36756003)(7416002)(66556008)(66476007)(66946007)(5660300002)(2906002)(478600001)(8676002)(86362001)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OwXwmQOKP/R/ylrc9A+O0lmHAgQXfZ1PSMiQ+KxiesdRwHzMbOGDoX0OAsI3?=
 =?us-ascii?Q?UWu0+BElq4e8HEs/5QELhRyjRZ7juz5nUlXtv6mpMHgPk76KwhMA5jfU8RiP?=
 =?us-ascii?Q?xrkrnN3UofDC9kSZCyQt5ec8TPxk+9gPvYP4HZCABawfUkvYbtZwBUwGrO3n?=
 =?us-ascii?Q?rtctvb5qQyswYyeLevNqkXiOPgDIpKQ1xeVjZex+TwCEmOtbDMGp1OVKPOhB?=
 =?us-ascii?Q?tx95Urz7Oh0ZIkIhpXIQ8PKwE0EKCgYPrTUreM+8mJsIi8IfeV8gdYwJkmjM?=
 =?us-ascii?Q?Zz3Gj4Y3A+SlNVMKAhrDew66tC5/GAQN90vTJI8xHnkZNW8/zSW2pBgRHz1f?=
 =?us-ascii?Q?UPiFd8Y1hg98O0XuC6gWdms1W1DVGA4x0fr3lfapOpAk7iTLawg+aV3P3IbW?=
 =?us-ascii?Q?hwX69XmAkxDQ56D1+TPblPsChxfY/DFZiw9G1k2glCwD7BYN5vNSI8LF6V3o?=
 =?us-ascii?Q?NtGdL20+QseqphWYRU6O/ZN6A6FubOIhBpZl4KAa/TlSEZPYflnqDIKHMEVw?=
 =?us-ascii?Q?RmLg1MT7dH4Eb1xW0XCuA4qvFrFniphWA0vw7icukALjWR11DM51j8zLfHob?=
 =?us-ascii?Q?KZ+YA3bissMZ8URlphdvlmPmfjhrqAYBOz9tDfetOIdJxtixqm+ivGoQiyaB?=
 =?us-ascii?Q?tIOCX3QBdDUPGsEvw7g4SzMEso3kihNeV0282w2HDgB4LGzPxcFmx7d25aQc?=
 =?us-ascii?Q?qfofHbxQhc0OP9j9GYvdSADtuyU1A0WLurqtGzuTRiWs33atFIb4x+irUb5h?=
 =?us-ascii?Q?0lvXnA56WY4ivbpO+shryfWwCCDYqobXQwGlv6JP4/fEBtrhEZ4AL/AcVBww?=
 =?us-ascii?Q?OfnDXT1FQp2Gvw60DAU1eXQB5lDEem1/r3UziemP15l0m9NvhnnQn58lsXwS?=
 =?us-ascii?Q?e3CfA/54sdz+WjPgYP/Pl224De2AK6lem1ikVUd/ReEeW9IeXNZjop86DQhr?=
 =?us-ascii?Q?2joi7GJPOWLlvry7DlrsMVbag4TGUCcMWiuo4y9iML/y/Gmk0dDexZjF8K3J?=
 =?us-ascii?Q?YEawTtVC35kHvyANYZ62MT9lq1mDrrac0/cQ11u/ILNEsxgbXyxSrPwBd1il?=
 =?us-ascii?Q?DITuqTaW3vJncis+8vmpHfra+hR0x2gbuZX5k5ZZym6nAXYgu/hBVBB7t2Ml?=
 =?us-ascii?Q?TQnGhXbnfz4d70Y+2WmI5k0qKcy1ZdpqQnvA2cJApILim+y9j6gsVbMeVl7p?=
 =?us-ascii?Q?7gfxBRAOpGcCrgxI7zuHf1Gsb3pMc4BmblriZQsbQzJhXl/FP1F0jmNtSFF9?=
 =?us-ascii?Q?a+PsnOxnRoxzrXNdHnSGxkhpmlBycNQkai2FWCNgrV/XqBCY0FBd+nY1c97L?=
 =?us-ascii?Q?UNTbFCCgEGpZ7rQHU2YKIs9E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6461ce-1c2b-4c1c-c73c-08d925ea95e6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 17:19:31.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2cYcyhI7LEQyn2R+5S+++BNOvAjJNdzq0r3YH1uZMJ2SQveJFjApND7WPlRhFVy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 04:15:07PM +1000, David Gibson wrote:

> Is there a compelling reason to have all the IOASIDs handled by one
> FD?

There was an answer on this, if every PASID needs an IOASID then there
are too many FDs.

It is difficult to share the get_user_pages cache across FDs.

There are global properties in the /dev/iommu FD, like what devices
are part of it, that are important for group security operations. This
becomes confused if it is split to many FDs.

> > I/O address space can be managed through two protocols, according to 
> > whether the corresponding I/O page table is constructed by the kernel or 
> > the user. When kernel-managed, a dma mapping protocol (similar to 
> > existing VFIO iommu type1) is provided for the user to explicitly specify 
> > how the I/O address space is mapped. Otherwise, a different protocol is 
> > provided for the user to bind an user-managed I/O page table to the 
> > IOMMU, plus necessary commands for iotlb invalidation and I/O fault 
> > handling. 
> > 
> > Pgtable binding protocol can be used only on the child IOASID's, implying 
> > IOASID nesting must be enabled. This is because the kernel doesn't trust 
> > userspace. Nesting allows the kernel to enforce its DMA isolation policy 
> > through the parent IOASID.
> 
> To clarify, I'm guessing that's a restriction of likely practice,
> rather than a fundamental API restriction.  I can see a couple of
> theoretical future cases where a user-managed pagetable for a "base"
> IOASID would be feasible:
> 
>   1) On some fancy future MMU allowing free nesting, where the kernel
>      would insert an implicit extra layer translating user addresses
>      to physical addresses, and the userspace manages a pagetable with
>      its own VAs being the target AS

I would model this by having a "SVA" parent IOASID. A "SVA" IOASID one
where the IOVA == process VA and the kernel maintains this mapping.

Since the uAPI is so general I do have a general expecation that the
drivers/iommu implementations might need to be a bit more complicated,
like if the HW can optimize certain specific graphs of IOASIDs we
would still model them as graphs and the HW driver would have to
"compile" the graph into the optimal hardware.

This approach has worked reasonable in other kernel areas.

>   2) For a purely software virtual device, where its virtual DMA
>      engine can interpet user addresses fine

This also sounds like an SVA IOASID.

Depending on HW if a device can really only bind to a very narrow kind
of IOASID then it should ask for that (probably platform specific!)
type during its attachment request to drivers/iommu.

eg "I am special hardware and only know how to do PLATFORM_BLAH
transactions, give me an IOASID comatible with that". If the only way
to create "PLATFORM_BLAH" is with a SVA IOASID because BLAH is
hardwired to the CPU ASID  then that is just how it is.

> I wonder if there's a way to model this using a nested AS rather than
> requiring special operations.  e.g.
> 
> 	'prereg' IOAS
> 	|
> 	\- 'rid' IOAS
> 	   |
> 	   \- 'pasid' IOAS (maybe)
> 
> 'prereg' would have a kernel managed pagetable into which (for
> example) qemu platform code would map all guest memory (using
> IOASID_MAP_DMA).  qemu's vIOMMU driver would then mirror the guest's
> IO mappings into the 'rid' IOAS in terms of GPA.
> 
> This wouldn't quite work as is, because the 'prereg' IOAS would have
> no devices.  But we could potentially have another call to mark an
> IOAS as a purely "preregistration" or pure virtual IOAS.  Using that
> would be an alternative to attaching devices.

It is one option for sure, this is where I was thinking when we were
talking in the other thread. I think the decision is best
implementation driven as the datastructure to store the
preregsitration data should be rather purpose built.

> > /*
> >   * Map/unmap process virtual addresses to I/O virtual addresses.
> >   *
> >   * Provide VFIO type1 equivalent semantics. Start with the same 
> >   * restriction e.g. the unmap size should match those used in the 
> >   * original mapping call. 
> >   *
> >   * If IOASID_REGISTER_MEMORY has been called, the mapped vaddr
> >   * must be already in the preregistered list.
> >   *
> >   * Input parameters:
> >   *	- u32 ioasid;
> >   *	- refer to vfio_iommu_type1_dma_{un}map
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */
> > #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> > #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)
> 
> I'm assuming these would be expected to fail if a user managed
> pagetable has been bound?

Me too, or a SVA page table.

This document would do well to have a list of imagined page table
types and the set of operations that act on them. I think they are all
pretty disjoint..

Your presentation of 'kernel owns the table' vs 'userspace owns the
table' is a useful clarification to call out too

> > 5. Use Cases and Flows
> > 
> > Here assume VFIO will support a new model where every bound device
> > is explicitly listed under /dev/vfio thus a device fd can be acquired w/o 
> > going through legacy container/group interface. For illustration purpose
> > those devices are just called dev[1...N]:
> > 
> > 	device_fd[1...N] = open("/dev/vfio/devices/dev[1...N]", mode);
> 
> Minor detail, but I'd suggest /dev/vfio/pci/DDDD:BB:SS.F for the
> filenames for actual PCI functions.  Maybe /dev/vfio/mdev/something
> for mdevs.  That leaves other subdirs of /dev/vfio free for future
> non-PCI device types, and /dev/vfio itself for the legacy group
> devices.

There are a bunch of nice options here if we go this path

> > 5.2. Multiple IOASIDs (no nesting)
> > ++++++++++++++++++++++++++++
> > 
> > Dev1 and dev2 are assigned to the guest. vIOMMU is enabled. Initially
> > both devices are attached to gpa_ioasid.
> 
> Doesn't really affect your example, but note that the PAPR IOMMU does
> not have a passthrough mode, so devices will not initially be attached
> to gpa_ioasid - they will be unusable for DMA until attached to a
> gIOVA ioasid.

I think attachment should always be explicit in the API. If the user
doesn't explicitly ask for a device to be attached to the IOASID then
the iommu driver is free to block it.

If you want passthrough then you have to create a passthrough IOASID
and attach every device to it. Some of those attaches might be NOP's
due to groups.

Jason
