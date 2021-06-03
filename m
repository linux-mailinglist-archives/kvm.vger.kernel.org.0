Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B517639A1A9
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhFCM6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:58:10 -0400
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:51041
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231271AbhFCM6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:58:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnM+IjfcfTjQPhKrbKw7avRGWenm10H1KRU6kBiE8RHEHLJ48QiKjYixH/DkiJPjqvMxREUfxGHV368k/syZ3ivHvBxKEp+dEf1RvDlVJqcZrVB17LEHp6mvGW9PqYB2pHt+cT+AXdvAnhzU1gXsiVEljW2L9ZPAdEnitw6Pzkg2kd5tq9R6LA2xD58EEMKA2TpHVcFIsBRO4qEkXXjVLOmlPR+ein1T+TG12TK6Bd8fSROBh3wxSJv6VWTGbTwSc5vW7FHomISsmUn1r+zOO6B/oCd50iizINl8PvbdULpL5LsiGXghEEygsnUVlenMCkKocivyjbRTB2cQaEorgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQhJLsV8t7rNQl/WnfFTiSu5QjP0zeEZQOsgD957lRM=;
 b=SM5xrp3xPBuHoFJH1LUhjBGSx2QpyUxcVdkmLjiWpq4v48aEQ6lYBcmWkidZ+qRZSS6raZc9Yq5bwaNFsZ03RO2VHOD/63XG+Vil1kADAmh4Cwc14Tx3hver+a3Td8JS3Ds3HVueD72x5xCr4ttGpX1iSpc8hxKDT+o8hR57C6CxHzZa/C+iMpaI/lqjwKLwZmBiKK7OgZl4vAVlx49d+qsLxLgdeZLvfx9murgIlbyS/BhJGoNFojM0mBeVkvnx8kzQa5ZzNrkweA6vdWHvj6O5eBctUP50Z2QU1Qwv5wE7gLTrlxdb06ZroYtGQE0Iy1H3uWiafWLMue8XO6dEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQhJLsV8t7rNQl/WnfFTiSu5QjP0zeEZQOsgD957lRM=;
 b=CE85nkfzcG03CO+24v62jwNRCjkV6iR9svF+76qUYgq+CsUysGu2VZP2XCbso8AEDcIHLK/zy/N13xx4/I+qEBqaQyUBx+/OKxckEzPBXmVAdlO/LOWjj1fpefAR7lRTXm9T/7NXx4grMJb282nWzLuhQ4zlN/grTwHb5jFp6pk2ZRkyOOfgByTpXU0ZczbhIcojFC4rASC0h6dL3RpJeU0MR1h4hBiVCFi0VYyz+VYI/KCNcTDtix6b+/ZQYi/Kh7OGbK7reUH/xJs4+iMIF/X2TdBgvoBVdoqN092jf1EGYrK+j329yC+C+EM+K8QyJLnmue29qFJgOkQBq0lYiQ==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 3 Jun
 2021 12:56:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 12:56:21 +0000
Date:   Thu, 3 Jun 2021 09:56:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <20210603125620.GX1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <786295f7-b154-cf28-3f4c-434426e897d3@linux.intel.com>
 <YLhupAfUWWiVMDVU@yekko>
 <e2dc8e4d-1f62-36d5-b303-18c82b6a6770@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2dc8e4d-1f62-36d5-b303-18c82b6a6770@linux.intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:160::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR13CA0017.namprd13.prod.outlook.com (2603:10b6:208:160::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Thu, 3 Jun 2021 12:56:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lomtY-0015BN-2c; Thu, 03 Jun 2021 09:56:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d9f90c3-de24-44de-0b85-08d9268efc54
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5554258FB90615E21EBDDDB3C23C9@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PDR56UxPhCF1LVK/oHYv04TMdT9TqluS3XRN78jYfuo4QoPAx2E300ts3z+cG4MS3fyiOkmqgtlC8afHvVMfm6hP2Of0gwa3J/z36arQTQP9O/6hakUrygVfq0T5HA4pUDPz8PdNR5e242O/ockfhVGFpLG1pSJXMQwH0/rp4mZZjBZ6aEdqaQ0RNjtEqeOFH9ooV5d4LSNq3A71niR3YCqb6Nyfle/1tsuma8tNrfzOtXaRvNHw25L/kLvnzW/B5Y/NgfWyHlGKXXcJVeD6lt2ZjGtqrR0Y3mZePIjpsMrRBmDzdRr7o5Y8nz/J4gbHLxr41holJb5jRIUgFzASINNYnU+sH6g7GBYYOxFlAKEX/e7XioTVnp0zspFut0ppBKP49mJzPCFqb5YyRvh5ifD2VJkZt72dVPVKi2lf4Ag56IyxFqB51PcI2JVo6PRauNnAGmS3yIhXgYze33F7CzS7tCxWlnZxHrIhT7Y/t9cowy16W9OOXXp0Elezlib6dw0HSllva3dvrQ/+rze4ZjMDc7EbooLOA5urZTQALbgeHKUeL5GenORNLkMatAJcAq4ANh6DFeQDMWaRdLpoFvxTp9xrYVU1zrAxq6DJcjc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(53546011)(186003)(26005)(54906003)(38100700002)(316002)(5660300002)(86362001)(2616005)(1076003)(66556008)(66946007)(66476007)(426003)(2906002)(36756003)(33656002)(7416002)(6916009)(8936002)(478600001)(83380400001)(4326008)(9786002)(9746002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0ZiK0TD5uMNIvlJH+HXqZ0tIK/UR6+++5A6Y7OAQxewI7Nhdz/LGJBm2rjn1?=
 =?us-ascii?Q?fAqif6i4aE9O4QYbdAw0CK4bTpwTOSRVIsHkgdFbwjrGLCJ+kTqR64fM1Tc1?=
 =?us-ascii?Q?FqfQ9nW5B8lAagEkFWjPskaCO60WEyYht16W+A8FBFovtj66w8ZbCfxhbIow?=
 =?us-ascii?Q?ToMlXBiZE750f8mrRfLKkIfnVc2FyFcb8JWW64RyBGzJdfhwKKLngrjiIH17?=
 =?us-ascii?Q?XkMUT19ibCFOZdBUPgX9DgV+9kmHKf6h/+J84cPR0mwNO7idCD3wHGDD1lbU?=
 =?us-ascii?Q?sGL2yX+NR6claczYvHKYkUr7rYRB3CGoSGCu+rmZ+W2/gxVFTGfveOIZ5IaE?=
 =?us-ascii?Q?wIy5kZsTG2SM/u4SeEQ/1NyWJUOaG6mb7l3brnzB7Nb0jyS7fI5b8cCbBLM7?=
 =?us-ascii?Q?Qa5fABILHjaVeiv32tWxlWCCwJtlxbIdKh9bZsTIoB8BIx68YVVeftrxoWvZ?=
 =?us-ascii?Q?hA2crKnlgvmeosTP0I6zqhdWSWuuAY4HpBu7XKGq7XQe6dnEeTKeif0gg5Dy?=
 =?us-ascii?Q?tiG0rHU1MyF3Eb6gbu5oiA1mm+YWPz2OohmXJVp0Lpq9eQjsTaoHtVh1nkev?=
 =?us-ascii?Q?UMoFj++DHpoDx5+Yshl+i2C4EU8X939va+l6LI0LdJXGnYVQBGI+Y1Cjra0p?=
 =?us-ascii?Q?iD2JoBLncBKUQou5xwMS80AtLC0NJhrmArY+NWippQtSncMEuiAfuOtUBW7/?=
 =?us-ascii?Q?QHQRJRHYDdVFonnOQDBB4VblIA//QupEWHeNqZA9i/M8kWz0P93icqHj07XN?=
 =?us-ascii?Q?cPMA07suqp0SEVZyXwsgD0aeEipmZPkTirjdy3dN9BZnJd+vZruYT59r2WUW?=
 =?us-ascii?Q?/pEJtDw7AcKPb8cJuMVk7Dw+Hn5v1o8v++hlSRe92GwRvxXC3h2AlqtzbN6j?=
 =?us-ascii?Q?RttMYVNJ9NOApxNfnBKpoi0V5c8Ku4wKBluyaZN7qTIrCirAo7vdXXL0xCos?=
 =?us-ascii?Q?3ZvFt2J1R4WhTwF+/lAZtTNjn9Nk9qctu5lhFCzF6iE7Jy+jl4vKo/hZvxc9?=
 =?us-ascii?Q?9Z7ihIMZa6o3Df4ey/WYP34ixQWqeIL9Br3dfbLWE3uKi/tNXGvX+vKPZLD9?=
 =?us-ascii?Q?1lV7FWK2xlUFTDrZpFbDpmqyabzgohAczffRQN3g+980/IdfWFxZw7ohbudo?=
 =?us-ascii?Q?6f4NeFyIsORUCCvCfTKKxU0k0sRJSCgmlzGeqMtsKdikLGNpOhnaQGHN0avK?=
 =?us-ascii?Q?1A3sIPHO5pny50fsRm9Ze9VgO3Vb4Mz4pVY8IDQ/ypSVFEiDv2u3rSgPa1cl?=
 =?us-ascii?Q?YZZI7J7OEIYA4A70/LEMR2UR10BjqnFfEmPZu//Z/c2YsfagPpMe/Crh3FuZ?=
 =?us-ascii?Q?y1QcqtAWxJ1SnJ4Z1PG5tayA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9f90c3-de24-44de-0b85-08d9268efc54
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:56:21.1995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QagWqZsP1HQ4zDK+XvCfkRwYukgFgx+8bL/8Bk/zmJ+tpixyA1veYtbiGpWbfrVB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 02:50:11PM +0800, Lu Baolu wrote:
> Hi David,
> 
> On 6/3/21 1:54 PM, David Gibson wrote:
> > On Tue, Jun 01, 2021 at 07:09:21PM +0800, Lu Baolu wrote:
> > > Hi Jason,
> > > 
> > > On 2021/5/29 7:36, Jason Gunthorpe wrote:
> > > > > /*
> > > > >     * Bind an user-managed I/O page table with the IOMMU
> > > > >     *
> > > > >     * Because user page table is untrusted, IOASID nesting must be enabled
> > > > >     * for this ioasid so the kernel can enforce its DMA isolation policy
> > > > >     * through the parent ioasid.
> > > > >     *
> > > > >     * Pgtable binding protocol is different from DMA mapping. The latter
> > > > >     * has the I/O page table constructed by the kernel and updated
> > > > >     * according to user MAP/UNMAP commands. With pgtable binding the
> > > > >     * whole page table is created and updated by userspace, thus different
> > > > >     * set of commands are required (bind, iotlb invalidation, page fault, etc.).
> > > > >     *
> > > > >     * Because the page table is directly walked by the IOMMU, the user
> > > > >     * must  use a format compatible to the underlying hardware. It can
> > > > >     * check the format information through IOASID_GET_INFO.
> > > > >     *
> > > > >     * The page table is bound to the IOMMU according to the routing
> > > > >     * information of each attached device under the specified IOASID. The
> > > > >     * routing information (RID and optional PASID) is registered when a
> > > > >     * device is attached to this IOASID through VFIO uAPI.
> > > > >     *
> > > > >     * Input parameters:
> > > > >     *	- child_ioasid;
> > > > >     *	- address of the user page table;
> > > > >     *	- formats (vendor, address_width, etc.);
> > > > >     *
> > > > >     * Return: 0 on success, -errno on failure.
> > > > >     */
> > > > > #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
> > > > > #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)
> > > > Also feels backwards, why wouldn't we specify this, and the required
> > > > page table format, during alloc time?
> > > > 
> > > Thinking of the required page table format, perhaps we should shed more
> > > light on the page table of an IOASID. So far, an IOASID might represent
> > > one of the following page tables (might be more):
> > > 
> > >   1) an IOMMU format page table (a.k.a. iommu_domain)
> > >   2) a user application CPU page table (SVA for example)
> > >   3) a KVM EPT (future option)
> > >   4) a VM guest managed page table (nesting mode)
> > > 
> > > This version only covers 1) and 4). Do you think we need to support 2),
> > Isn't (2) the equivalent of using the using the host-managed pagetable
> > then doing a giant MAP of all your user address space into it?  But
> > maybe we should identify that case explicitly in case the host can
> > optimize it.
> 
> Conceptually, yes. Current SVA implementation just reuses the
> application's cpu page table w/o map/unmap operations.

The key distinction is faulting, and this goes back to the importance
of having the device tell drivers/iommu what TLPs it is generating.

A #1 table with a map of 'all user space memory' does not have IO DMA
faults. The pages should be pinned and this object should be
compatible with any DMA user.

A #2/#3 table allows page faulting, and it can only be used with a
device that supports the page faulting protocol. For instance a PCI
device needs to say it is running in ATS mode and supports PRI. This
is where you might fit in CAPI generically.

As the other case in my other email, the kind of TLPs the device
generates is only known by the driver when it connects to the IOASID
and must be communicated to the IOMMU so it knows how to set things
up. ATS/PRI w/ faulting is a very different setup than simple RID
matching.

Jason
