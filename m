Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E1F39A093
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhFCMMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:12:53 -0400
Received: from mail-dm3nam07on2056.outbound.protection.outlook.com ([40.107.95.56]:42117
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229765AbhFCMMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:12:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZrzXDh1Z2Bfj6SHV0fQA3okrEk8G5FriClL5eH1C7ePI6FFVE0pQ9rDHjKhXFOSz9JxEFQ12uXe2a3WWjzkI08wvBOQihgfwTHX/0S8WKFWX1caUJ95bg7e/X3B2Fc0aJp6sbEvCQK8Az6gcL+aJm719PPp0hs7xUHgPq/0F19K0S7g9HWT6jPCWG2U9LQ3X+INfh8POJm9rQMPzeNq79qaAymK0YGt1UewFt4BBgaEqTvl2tAUH188ykTVMrxRApoSrLyKaMGrrL4Brd07R1ICre5ohuUWZdLcnnMOwyPUco2NcS4K+wggc1kjGKO0VkTj2Auigh2riXWsYDT83g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeOCeeMBESTZ6v6JAfyoSNBlVmdZPBl9MMH6xqp2Wio=;
 b=O6T3PAez/twgWo4anQbyL7DxifcRt5/8oFcSsnlWQKefTlfXQcnFZEHyZBR0pKLxrJMb/bnlHFF70AAH49RJUpP533AJghSXC2stddfEnPDqxs7lEPwVFRkA80uB4XYXmJ8glfxMgO+OFrhIhc/NzrslomcvSwjlhRNwnkilKjnh2+4+S81vC6LaH0mHnUlKBMh3z3Nw5lQVv0tlfMLd33xyi7PfMKxTEzHzjF1ln80HFhqyeFypmb7K5Pd9l1L0vYXcObdGqc4kw+6X4nXPCozUXQsw2kMivCxvcEkBr8R6FHGzOcyMwinnFq8fEuqqfnYbSnp7uS1Q5jWTBZj58g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeOCeeMBESTZ6v6JAfyoSNBlVmdZPBl9MMH6xqp2Wio=;
 b=RbNfwxv2aoqUZ2zTAoah6oNgEqfGWGP5+uQe5vuSfGnrCzeq1uQKkNnG1treDnKWIOuoczMM/moeOQ7o9Z6Wtuxt4/WP5Z1ZkDQLNKyk+GolOS0z3DatsOSDBuU3lvZC5MCNVTRzUD3IJP3CWkAC/Xxwedrzx8BWT1n43eHGmoxQ3gy3WhCr/J3lndc+zb5A5SpIRsd+oX1ciOMSTU2pOHcQZEGi07kWo42YGmCcf9dcwlZ9e+NYoRk5hD2Dchfk9w5qvILFZUW5KOc3p7PalUSrklZNjay8JR4Rvk9lSAQ0AWvf2GxDWPtXwLAcrlDQA1w4cp+DHqyTnee5sVnkWA==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 12:11:06 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 12:11:06 +0000
Date:   Thu, 3 Jun 2021 09:11:05 -0300
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
Message-ID: <20210603121105.GR1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
 <YLhsZRc72aIMZajz@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLhsZRc72aIMZajz@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0125.namprd13.prod.outlook.com (2603:10b6:208:2bb::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Thu, 3 Jun 2021 12:11:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lomBl-0014PM-JC; Thu, 03 Jun 2021 09:11:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3264873-c731-4acc-5707-08d92688aa3c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5302F7D4C4C4E07DB604879EC23C9@BL1PR12MB5302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6sK0VxpX8xua1l1an0IPmdhz7SPJHxx9Il8S4GKM7nugrWnQtDrF79jB2Q3NYSg938oL9Q1he+YGguT2pKusM+rBvEIAqqOxQHcErxF3yHJ611bSMDL9S9wFjG81GBofVm5KCYSf5856QLpdH+r6iTfW1QYeAoHX36fZeZCRLw7q4zhWDSEGZeuNXAr3OCKePlW03GdGUoY/wlmD9UBNxrAV1xaIit+IF+FisrdHZX8HE8JCj1lYmF6KH7zoK5i9wwC6efBtnDIwn9LEwCMftb8jZsj7tnRMaV2un9bpUbCfGD85waXmBRM2Mr39omYatyMIgEoeiVJERIeGMvGtTilezacuhbfh+Jz95jjRu2bockKtROFzeTSxcYwaUjqpQKFSIovIfubWLcJNqKfXOh8DoWYIdaqTy0nsXBPEm15YtsTGN2L53JuH6/C7cRM3KK23mxAWQMOeqhqKsgKt40/mHiXdC7CNJytsSYxT9NmR6DbhAgx5T5fmroveVXg86e5nU3F08K+bd9rz2HqrogU3gxrItLcVbFVmSfrxHRYcrzjvFe28MAJJfYKaptquHOtY6MoghgMaM7Xfl77SnLpNHqZ/pb2qjMFmA1oh0c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(66556008)(66476007)(66946007)(2616005)(8676002)(86362001)(33656002)(36756003)(316002)(54906003)(186003)(26005)(8936002)(426003)(6916009)(478600001)(7416002)(83380400001)(9746002)(1076003)(5660300002)(38100700002)(4326008)(2906002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ytf2wMHQliTciOdh4h0SVQr64sTTFw575eGcWakYRzhoWA5JUXQLpkIktTuj?=
 =?us-ascii?Q?L6x8tZAgfxusi4Y0jwi5c9iX7CZGeSMfzaV7Rh6eaEVkrRaSebz3ybUB+TVh?=
 =?us-ascii?Q?CEA+EUNBM3LTG77y8o3exXrlOloXx2JHLN7X8wDdTVBExt5ZiFdhKCIux1KJ?=
 =?us-ascii?Q?Ea6dU1KS605rPAYQz8JaKkHiJgZke3LpsrcwRo7Y+IpvufeHgpP6uu9nw2kX?=
 =?us-ascii?Q?k2uFPqZJ+fQj0NNFjkii/e5wMggJE4psOyE1gedMnJaClArjIpn14f/aOSI3?=
 =?us-ascii?Q?m3Lky4E6RRJAjAAGptJtpeYegRqOgiyFTTz4Tb5Cnt0M35VUXSSr6g6Mmz4T?=
 =?us-ascii?Q?Z0JacLyHFzuEC1IBMpZJt+VceT6GTRXqBeZdPlUaqXKr3kd3BCy/ofvFJUUy?=
 =?us-ascii?Q?8BUSTruFQO2Oyv99sne28x+Eoz+IKS351LuS7YThjiHTvx4kexXFFUTn+uSi?=
 =?us-ascii?Q?m33iSIn5bNwOlp0GFywnC+ebZsVE0ophVToCDuigirtSYZi/BakBnjyL3cpW?=
 =?us-ascii?Q?Tkz1dCO8nBO85RK4KcbK+1JaO8/JnIsoWgLe0tId35N1LFzVL5NrmXT2TthH?=
 =?us-ascii?Q?2oTRKqadA1x2a+5rMrJTGLVWcJZUFypbwfOpOvEHFxRwUYHO1nESY3sHcbI8?=
 =?us-ascii?Q?2rBGgmpFLcKgxGNsDOIfwXineJFhz0S/qf9sP5c2BPNudVKoF7U5sl8CdYj+?=
 =?us-ascii?Q?6CQSYDM+ejoWcn6WCcXVyfxsf9A2kvt1zZSbApsXiVlkD+ndTs3fx4KGgZHg?=
 =?us-ascii?Q?Ot7ywAEQf0ifq6HO0oXkhq20+wM5vG8K08k4Tvyzc2h76mLQBvzbuHtbsTqr?=
 =?us-ascii?Q?QpStcP5e1DQ4Xo59iunYfhPjhrnZbaKb/E99GqSiaejqpJWq4TpDOjYrVE5W?=
 =?us-ascii?Q?zDDC7MxgfQ6IQfZudJj8h4r8HCegeRn4LZPltdNYog4M+7dCG9h+wu2sqDcd?=
 =?us-ascii?Q?R/WPvhKHytxVV2/uF/fWUS5Fb1iMct6cJqQ8Q5qehqdHI0caqy2YmV7tZxKK?=
 =?us-ascii?Q?qEVqAgHPUXwGQZm5YX87OwyMGn/kIBnfs/TEmH6VpqkEbAuKAGNP+bUz+Lqi?=
 =?us-ascii?Q?bhqiDm1C0pf/5LArGVRrt/i+AiGmAIMOrlq49YFaxPuRvRdNaM7HVYadTnX7?=
 =?us-ascii?Q?CbEhGDHaQMLe+xpNbiQL11CHCtI2JcQFlr2MABd9SomDo/ME27zBUFaGOON3?=
 =?us-ascii?Q?J4ttbJFhQAgr8ktnk9M4h/ut6Yxe0HEC8Ho2cfEFvRnyBBr8K/WbENbeyA7q?=
 =?us-ascii?Q?zL919ZfpqFfXG2uEoO/QE/gKv8ZWx2jx9hDLW/FyJXl88p3XgGmVeNwLXtv4?=
 =?us-ascii?Q?Ja+3VBXRNS4TL9pgk1bndqeq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3264873-c731-4acc-5707-08d92688aa3c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:11:06.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JcJ/oB0I6FrbffIAToFoM7Vz2mXcZosdqBBxcjc7QUHJiL8BWGca0LiJ47LzzLEa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 03:45:09PM +1000, David Gibson wrote:
> On Wed, Jun 02, 2021 at 01:58:38PM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 02, 2021 at 04:48:35PM +1000, David Gibson wrote:
> > > > > 	/* Bind guest I/O page table  */
> > > > > 	bind_data = {
> > > > > 		.ioasid	= gva_ioasid;
> > > > > 		.addr	= gva_pgtable1;
> > > > > 		// and format information
> > > > > 	};
> > > > > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
> > > > 
> > > > Again I do wonder if this should just be part of alloc_ioasid. Is
> > > > there any reason to split these things? The only advantage to the
> > > > split is the device is known, but the device shouldn't impact
> > > > anything..
> > > 
> > > I'm pretty sure the device(s) could matter, although they probably
> > > won't usually. 
> > 
> > It is a bit subtle, but the /dev/iommu fd itself is connected to the
> > devices first. This prevents wildly incompatible devices from being
> > joined together, and allows some "get info" to report the capability
> > union of all devices if we want to do that.
> 
> Right.. but I've not been convinced that having a /dev/iommu fd
> instance be the boundary for these types of things actually makes
> sense.  For example if we were doing the preregistration thing
> (whether by child ASes or otherwise) then that still makes sense
> across wildly different devices, but we couldn't share that layer if
> we have to open different instances for each of them.

It is something that still seems up in the air.. What seems clear for
/dev/iommu is that it
 - holds a bunch of IOASID's organized into a tree
 - holds a bunch of connected devices
 - holds a pinned memory cache

One thing it must do is enforce IOMMU group security. A device cannot
be attached to an IOASID unless all devices in its IOMMU group are
part of the same /dev/iommu FD.

The big open question is what parameters govern allowing devices to
connect to the /dev/iommu:
 - all devices can connect and we model the differences inside the API
   somehow.
 - Only sufficiently "similar" devices can be connected
 - The FD's capability is the minimum of all the connected devices

There are some practical problems here, when an IOASID is created the
kernel does need to allocate a page table for it, and that has to be
in some definite format.

It may be that we had a false start thinking the FD container should
be limited. Perhaps creating an IOASID should pass in a list
of the "device labels" that the IOASID will be used with and that can
guide the kernel what to do?

> Right, but at this stage I'm just not seeing a really clear (across
> platforms and device typpes) boundary for what things have to be per
> IOASID container and what have to be per IOASID, so I'm just not sure
> the /dev/iommu instance grouping makes any sense.

I would push as much stuff as possible to be per-IOASID..
 
> > I don't know if that small advantage is worth the extra complexity
> > though.
> > 
> > > But it would certainly be possible for a system to have two
> > > different host bridges with two different IOMMUs with different
> > > pagetable formats.  Until you know which devices (and therefore
> > > which host bridge) you're talking about, you don't know what formats
> > > of pagetable to accept.  And if you have devices from *both* bridges
> > > you can't bind a page table at all - you could theoretically support
> > > a kernel managed pagetable by mirroring each MAP and UNMAP to tables
> > > in both formats, but it would be pretty reasonable not to support
> > > that.
> > 
> > The basic process for a user space owned pgtable mode would be:
> > 
> >  1) qemu has to figure out what format of pgtable to use
> > 
> >     Presumably it uses query functions using the device label.
> 
> No... in the qemu case it would always select the page table format
> that it needs to present to the guest.  That's part of the
> guest-visible platform that's selected by qemu's configuration.

I should have said "vfio user" here because apps like DPDK might use
this path
 
> >  4) For the next device qemu would have to figure out if it can re-use
> >     an existing IOASID based on the required proeprties.
> 
> Nope.  Again, what devices share an IO address space is a guest
> visible part of the platform.  If the host kernel can't supply that,
> then qemu must not start (or fail the hotplug if the new device is
> being hotplugged).

qemu can always emulate. If the config requires to devices that cannot
share an IOASID because the local platform is wonky then qemu needs to
shadow and duplicate the IO page table from the guest into two IOASID
objects to make it work. This is a SW emulation option.

> For this reason, amongst some others, I think when selecting a kernel
> managed pagetable we need to also have userspace explicitly request
> which IOVA ranges are mappable, and what (minimum) page size it
> needs.

It does make sense

Jason
