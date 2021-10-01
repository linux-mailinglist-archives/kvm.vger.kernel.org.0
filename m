Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7610241ED43
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 14:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhJAMYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 08:24:12 -0400
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:50240
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230498AbhJAMYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 08:24:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rccj+PHeaAFCxg3nNrl9c86rJYSRPXqqMt5Y2Ve9P9w4n+p+4orEtD2ELxo54H/cNu8RoMBaQC1mPu1UiPNKJnWsLAjPlqN4A6RwldLCIgnnH9nT1Sn1gIeSEnBlezB4dN7/7ClyrL3F3sWhw6Z36Bl0fM4tZiGJU3qg1suiSUu9vR8R/oziKl34pQe0cBCXOGr7f+FU0uWdntUuLp8yxus3qqN4UrT0Mf9gkR4d7Ql/cd1wVFTuyZph89W62jJmR7WhU7+wrqOSXj6O/oFTDjVjfLN/GoICFzy7BiZrXIfMmmLcjIlsZp7vBo4LY8gd2RmLA0+ytUYgBAl8nZIznw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u42DleCkTtJJfoHGEgEjQjktEqi/dlqvt8kSdy9ReIY=;
 b=gEM5uLPsrk9zWqy4JeQy9llvQDUAghMn/ve60wzib3Hz7AGB6xrPMRWH7GRcC8Lw3N6m3go7OCCvWdNwACgY7d6xOSiCLcS2k0rd53kI52dN55f9RcuQe3DgLRkZganZd2cQKCaPQJaVRJprOW6lIb+UUKUEH008BiUiQFEgw/rzC+jKATo2kaFi3wVUDkWHbbsbM8QbsHYyYuAQhir8ayw9h+1/Dwxr6RZ95Kw56m9ix4gqsMoOPidmhS+jIuqxXpxnydy+UKAqNHcm5EwfmdDkh7XJDmgVbIccCZwKM4ApOuA5S5Vyjma/beYio7NCZIGcbmDIW8kzrQ7L8CPsNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u42DleCkTtJJfoHGEgEjQjktEqi/dlqvt8kSdy9ReIY=;
 b=mlpO8kTiOVtn0DRWiKLXYObVQomjnRHDSbC8ZpEynXXZ60nIKq59WcCCbNT5Guybgwy3MUL+cWkvsLCJScPrSckGEqNTDDfv4pyBvHTJb5duxqDt3BLAD2C6L5CasvszDfC62uk7n6d3dRn50Y5xnKqNg8lwfFcLbegYrj7BUHn0DFqX0Pb9qjRfo01fWAtkXH0LHbVip0yc9YDYOuGRLBgXB6hke4SljxToYWYqHuPWvIZysiBGn8ExXpUm5CJp1GEPxDGb8CtF7ojbgig7P3zdNmgGWpB85pYJcbS8hsfjACpA63XaUzN2ywf8tZgrl+UiyFjd24xnFq4i/dI+Hg==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 12:22:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 12:22:26 +0000
Date:   Fri, 1 Oct 2021 09:22:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20211001122225.GK964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <YVanJqG2pt6g+ROL@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVanJqG2pt6g+ROL@yekko>
X-ClientProxiedBy: BLAPR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:208:32a::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0120.namprd03.prod.outlook.com (2603:10b6:208:32a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 12:22:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWHYX-008PM8-5U; Fri, 01 Oct 2021 09:22:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30582f79-fcd5-43fb-2d95-08d984d620e6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5377F7C4E64EC81BE56BED89C2AB9@BL1PR12MB5377.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZDE7vFXZWj/WNIr6vf0XWOWX+l11Yg6jr1UGbF/FbQk7mtqtl+kNDKT6wf7/WA1rQwLOeB4VmMohqBus02BvOcGJDXBH/0ltvg/o8d5+GhKKLwsKqATT9ufvKhqSKBYJJTCKShzYuXppO5Cjwr+8MuepD1lopfnUCbU+2BpsXRWlkWHGQTvNcDvcQY980Nb/8PzZ7CK37wZ7hZMgurjxyvKZqkZ2+j4UdFqSDAKWcsToGlVAEHpz9nSPuA6f4YxXWSm7+qFOuxHXLWqonLT5WPeho9LqdV5BN6hoYNhamc4ghMuGFTOKGwQnuGK8holOk7sj1LB6pZv+3NZMP7fhws7DrSSCY3BBBKx0ilROludgvnHKCrEa5fhYKSoT12E4NBFOdN1UCcV8t9AGQEN4sGsg2Squ/dwnarEzT+bbAb1Z8Tz1ktUOsljNm9uNPwLYQX34dvmwcqJmdyr/Ao0d/cOOYhtiqRbP0Be0xnRHvyhI/M3ah50M3fka3i1aTTNXGw0+FMggooh4aaQCzrVYs6rVUS96AU4wo5751/vkU47DEh3N550jyFVTWXvmLK0gzi5sbDL+1/Cl69kjpgRMvEP2m0tetctRt7DTGMUxZ4PXShkhwuNCGq18jX0hvkYOOMHceo6IEhQDVh+7EuuYQRC/XytlAxoEl6jnQdpdTE5EdUt82iFKJgS3JhfQ4sQlPEUl0KOuTrSmLcWnFFFXnJBzjKXefQeZAynmv5A6Ftc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2906002)(83380400001)(66946007)(8936002)(9746002)(7416002)(38100700002)(66476007)(9786002)(426003)(66556008)(186003)(2616005)(26005)(33656002)(6916009)(1076003)(508600001)(8676002)(316002)(107886003)(86362001)(5660300002)(4326008)(27376004)(84603001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sHnF7Zm5h4u9kJMyX7bSDUB9ZpAeGRwa7ncE/PP2qNt32TZhE22SnewTq7Lx?=
 =?us-ascii?Q?gECysAVBppbN8dy/DjWAoUgWfes2pDbqZXgfCnPJkUt33RxIVstXIgwwHKOn?=
 =?us-ascii?Q?b2bVvBCdp5JbiuJdMsDtegeFqJtHvH+cYICYL9hzE70YciWNZPuZ7lILQtEy?=
 =?us-ascii?Q?J5JFwO1LnvqwXP7QOViaWIL5i+0OOcQ81x//f+ImGhRACM5n9TFdJfsUlftn?=
 =?us-ascii?Q?iXNLOUoU6S+U2UkKWryVeJO0c68OGfYMw0r7U73wNABCd+3V0s3fgycfOc4g?=
 =?us-ascii?Q?LCe14MLH0nZaVv6/ftnEmKaxe7ILDV+m4sukO1OAnpCFC2yzoDN1HHJVSrXg?=
 =?us-ascii?Q?u1R5nfEyESBIWfQLhPlKfXUtRzEI7A5Rxv+75tFl939glzoueNVseGP0WYwu?=
 =?us-ascii?Q?FxDBPlmY3V6HYa0pJ4dFEEqFh1kFG+XTzIkpQv21QUsIIA6Ru5rtKIwY6qQf?=
 =?us-ascii?Q?dPZ/ZTfcGTbkWZ+/e22NjhbjBVJcmLHbkYRmBVR2BwjPK3BnKZkpWCVugWVe?=
 =?us-ascii?Q?wBSJm3wKND7z/IZ58y8QcAIfuJabL9xpP6uIOu+o68tBaUF7AAwcAhKJMlk+?=
 =?us-ascii?Q?QhZvjUtiAuJUUvvLWvtgLtYNyshG9hpY9JTA303ylEBuuJ7NGkM8PiZmClhH?=
 =?us-ascii?Q?OLWZgfjrgXDn7G7e3Hst5u3MqoihtiYwWIOeBFpUlKN2Ch190urPC2keox/3?=
 =?us-ascii?Q?bDurKBytKnhDwY8Jw2byzyYBxOcIdEz1b9LGZFjkZCUqtKZT4tC8hvGf6SfR?=
 =?us-ascii?Q?KIPmzicZhXziOmpNF0pO7UpQjUeZkrUob5N4uQzyq0pueeMf2ToCd5CdnmRO?=
 =?us-ascii?Q?RIHkxGr+z7d/mX0ZqxytJTkecP+dvIV4MaGr94WQPSB9b/twSje0b7se1KYu?=
 =?us-ascii?Q?pLMRxnzVndmUmguM2fATyxzEzKjc6Dwir6OIsuvEoukvA3W+QY9U6oG2V1zo?=
 =?us-ascii?Q?0vOeTJMNDzNNWYzovZzCec/7iTUE5F/Zis7CKyKiVFHqQt3kXY62osq/GGlq?=
 =?us-ascii?Q?ujJXxdt2Q0UliU26AT8SY7Z/44BcS1ieFiwBdsZ74WZ9Lx/sOqm+uTDO5z6y?=
 =?us-ascii?Q?YOFnhDLMjMN+vcNzmKBHknPtqfx9TXphkvfHe0HDTefuxKGtVxTTsWQHjqAl?=
 =?us-ascii?Q?c1PWXGk/lQZDxgZuIcEDw0ia3ecEu8/epTi2UkSMHjeq28eEbEqPM81Stt6I?=
 =?us-ascii?Q?e0zfz3xru+GWJyNk8ebJn1POwmSQA7bky/9iDKl3N8TL1tLQ4SIII1lIwr8o?=
 =?us-ascii?Q?G78gHTEMwHOsai2/Kxyy0mp1wciUq37bYmFKn87NBiFZ7KdgPjQ6lF+rT4WH?=
 =?us-ascii?Q?WAP/vhgYAkkqdNqfciXuDcWL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30582f79-fcd5-43fb-2d95-08d984d620e6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 12:22:26.2725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3B4K5Mh25UvMWAFdm8UD6gqa8pQxI8o9J+aQsRN9+qXvV6WK2+EBvd9Kssnb6vp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 04:13:58PM +1000, David Gibson wrote:
> On Tue, Sep 21, 2021 at 02:44:38PM -0300, Jason Gunthorpe wrote:
> > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > This patch adds IOASID allocation/free interface per iommufd. When
> > > allocating an IOASID, userspace is expected to specify the type and
> > > format information for the target I/O page table.
> > > 
> > > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > semantics. For this type the user should specify the addr_width of
> > > the I/O address space and whether the I/O page table is created in
> > > an iommu enfore_snoop format. enforce_snoop must be true at this point,
> > > as the false setting requires additional contract with KVM on handling
> > > WBINVD emulation, which can be added later.
> > > 
> > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> > > for what formats can be specified when allocating an IOASID.
> > > 
> > > Open:
> > > - Devices on PPC platform currently use a different iommu driver in vfio.
> > >   Per previous discussion they can also use vfio type1v2 as long as there
> > >   is a way to claim a specific iova range from a system-wide address space.
> > >   This requirement doesn't sound PPC specific, as addr_width for pci devices
> > >   can be also represented by a range [0, 2^addr_width-1]. This RFC hasn't
> > >   adopted this design yet. We hope to have formal alignment in v1 discussion
> > >   and then decide how to incorporate it in v2.
> > 
> > I think the request was to include a start/end IO address hint when
> > creating the ios. When the kernel creates it then it can return the
> > actual geometry including any holes via a query.
> 
> So part of the point of specifying start/end addresses is that
> explicitly querying holes shouldn't be necessary: if the requested
> range crosses a hole, it should fail.  If you didn't really need all
> that range, you shouldn't have asked for it.
> 
> Which means these aren't really "hints" but optionally supplied
> constraints.

We have to be very careful here, there are two very different use
cases. When we are talking about the generic API I am mostly
interested to see that applications like DPDK can use this API and be
portable to any IOMMU HW the kernel supports. I view the fact that
there is VFIO PPC specific code in DPDK as a failing of the kernel to
provide a HW abstraction.

This means we cannot define an input that has a magic HW specific
value. DPDK can never provide that portably. Thus all these kinds of
inputs in the generic API need to be hints, if they exist at all.

As 'address space size hint'/'address space start hint' is both
generic, useful, and providable by DPDK I think it is OK. PPC can use
it to pick which of the two page table formats to use for this IOAS if
it wants.

The second use case is when we have a userspace driver for a specific
HW IOMMU. Eg a vIOMMU in qemu doing specific PPC/ARM/x86 acceleration.
We can look here for things to make general, but I would expect a
fairly high bar. Instead, I would rather see the userspace driver
communicate with the kernel driver in its own private language, so
that the entire functionality of the unique HW can be used.

So, when it comes to providing exact ranges as an input parameter we
have to decide if that is done as some additional general data, or if
it should be part of a IOAS_FORMAT_KERNEL_PPC. In this case I suggest
the guiding factor should be if every single IOMMU implementation can
be updated to support the value.

Jason


