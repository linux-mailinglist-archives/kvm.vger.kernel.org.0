Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF0F47EF83
	for <lists+kvm@lfdr.de>; Fri, 24 Dec 2021 15:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352890AbhLXOYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Dec 2021 09:24:08 -0500
Received: from mail-mw2nam08on2051.outbound.protection.outlook.com ([40.107.101.51]:5729
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352862AbhLXOYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Dec 2021 09:24:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNRwtWtmLHbrJWf0S9U+4inHUaKOOM0GCDhZJs52riHRTzBEqxWMeozHbM9N+keVi8y1XB5tronrrqapYANt37nI1ado6xQDpliXaBoDZ2wB0+/EknpRcbx/dkDPo63tOtya/BTVWC+6fRtJyASOSpZ0LRcyAeyAqo0yCEP/9liO6UTVlYz8gbsba/hGfedPvgFpkTUNp9b3xsqj75PfV/Ir+E9A8bhRnqNtFsPi5obLdmGIc1fxEerY5fAwZRLjNkr+hVm4Z41Q+z+z3xZEJiG5wWtXOFprCHW5I6HvmUKu12a8JOJ+2KtYskLN3T8giQIH7iFjfU+eK7RWW4q5gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ELgRMFIDdac9+Y6Kbb+9N7eP2tpOpnrcsDKxiOgbKA=;
 b=lVpT3coIBpp7eu/V8r3YdqYwgQbk2CW/W+dVrx1283oqnk896DQ+ibH3nH0P0cD++32BFw65o/9gdGJCkohc/V5+DR0IV3uF80MsMTFg0eQt521L+uMG1QePe6MkAF/thDzMaFCQWhC4dVJucCkJfReygtrcNuNO8C+B1F/U2BYD7S1bH+m8sRDAoPGVOZMu2VNi4c3SXcx7uQHWqfPBDoQxRLRCm49qVC5hKTMvHYbAhwDP1GJUTrgUz0BR/VYYOt0kW5OlOuhH5Ac473GEBDPqFHoox6TvYURwcsZ57h8yE/DaRJUq+cK4wLsXwTo6+fh6W5HqZlc2xWst91H+gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ELgRMFIDdac9+Y6Kbb+9N7eP2tpOpnrcsDKxiOgbKA=;
 b=MNDKE8JEWfC/B5RrFN7HKPHBA59l48bN7/GAT700AW0sBv51ab5n9m4f8AgQpCg43nSNMntperJyeLArftIlCNqGiu3+Wz6aZxBz3aqRPt9fNxCdLy0ummzfk6NwGVffwh4EzPamK15leK7AaXEseo0zu/o4OcwTM22X8Q63WS392HRjAk9G+iVtb4Xcu50peAHcl87McCx79kJ0amPPC4PCvR4rGK/qXD88WIbhM9YBAAv4ciDcY7AEXDS9ikkajBM9NCrgf/kFgK2U9R+cbTkU+qGsnqzgRTi8gvDBL7hIxq8lZNda1waNqsmH+DBb7/7PeqSo/kSZuuujs+/QFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.17; Fri, 24 Dec
 2021 14:24:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4823.021; Fri, 24 Dec 2021
 14:24:05 +0000
Date:   Fri, 24 Dec 2021 10:24:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <20211224142404.GG1779224@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
 <b4405a5e-c4cc-f44a-ab43-8cb62b888565@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4405a5e-c4cc-f44a-ab43-8cb62b888565@linux.intel.com>
X-ClientProxiedBy: MN2PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:208:15e::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09e9789f-50e3-4ceb-7afb-08d9c6e90a69
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB511101491FE59B8C9D945278C27F9@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwFt6MCVyaQDIzMv7XCa/fchYIDJUCw8fhZ4Cjf5ZrwTSECPdnUERmFEOZJ225vhD+OYg/W3Rptqwmt1AjZUpU+RLX35m9/N91qcdKA3cq3zHMJ/K2p8mzjYiwSMvNtXtaI6QrXIgE3v4hVL0E0daEs1+NMVsYC+9yuG+dKu2JbhzKPhMk8GcOxwik6ryQA8NSrWX/yilXRZHSMPT+TvzWgcz1I/HcGzmJBbPfxEdJEW0SwPDng9E5vMiQ0uVL9A5SqSYCGeFnoxgIVc6NsGUbY81WmTPKMjZhVH7Mq7n1e1L2p2bd5z/jCRDud+QtiJ4yDGR0DP4DKyUHg5xQbDm6XFBaqwqyBhOV84PHK1QGHtjsisebDPLBul+57qp2fE+4xI2oNzmxMWOkeumwfcciMTWxhZW6UPg5//m78cgLrNhz+hFSKvyxHVDnehpRPmqNzgdLk2bWz0+fH0OKbZrnLRTgVi54NXMfNUD14liDKry567vQ446sGjC46Y4UAKctOpycjvsXBVKGCkEoSL+vYUJQqVIJYuishwaPVMXeJbxL01R+9m0bFHvww7k3FtD4cezlhS1Ktb/ZJ+pEVuLyZdofIss2oX9WZ3yoMyFs5fnwOGVYb9eZvDW7EwlEWgIzpF1dsMrjdKgC2qc8D5aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(26005)(2906002)(186003)(6916009)(8676002)(36756003)(6486002)(66946007)(6512007)(8936002)(508600001)(86362001)(1076003)(316002)(38100700002)(4326008)(54906003)(66476007)(7416002)(5660300002)(6506007)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q+c8u1h7XlelIHoIpomSULrj9AxCKB0CVvRp+SSvUvMS7gN/UNCTp/OCxn/Q?=
 =?us-ascii?Q?FkRWu51T3Gh5B0iUyUcmzNZGP5O7WfvQOiM1HIWJi9wDsULMSWDZNutc/vFL?=
 =?us-ascii?Q?RAxFikk3Y0Sb7tipiik6w2y9UvucKYRqrgIipdU5/lO5N6983LaN3gV/v6+h?=
 =?us-ascii?Q?yHSTn7SMyGgiqsppgcg59pdobUQLT2p6uwzV4KFTvgldjl8wRlkWEhsW7K4n?=
 =?us-ascii?Q?Yif76FrgjCzhKJGXkDZBO0yh7/oNa8KzXfLNPF8cxZHfIPyRmizQEVXrm+M4?=
 =?us-ascii?Q?7vcnMhKY582nQJmUcyv2NloU2upX+32OSra+bhvG/XJMw1Rqo4u0hhhKEQq+?=
 =?us-ascii?Q?2Ztxb0TcQS253bFX0ta4+A3xUvPJQXxQuJHKL5yn8y8rYRV9MWhToy8Q4JZK?=
 =?us-ascii?Q?RKgBqcog/RC/JJSa8VGdU//VOU/RQIbZCR7qop2pKhQOW4YfkgExFnhJgDEp?=
 =?us-ascii?Q?JUxmI0G3RoWxhusQhmPtLVeKwpOTt0t4Cj7Xrt0vZ8Wj7gIrSCchHzbNiYGY?=
 =?us-ascii?Q?rKbjxDFeZhEBxX6yp+Hw5eu9k8aPNs4I8cE36Nh9LegMOwiS7qaJqAStIoaH?=
 =?us-ascii?Q?vaqcNg+UJSogK5gXIEXnbAyQJHmCR4R6TQjF6JXpHOnluteE92wqzGrfkNe+?=
 =?us-ascii?Q?wX+S8urXwisGJxyx5vP25iDbenYYNvWh0DhoE8kdBfUAW+dQy7frxDfC1aRK?=
 =?us-ascii?Q?RXgnI5OEXm3zM+9gilCPRPyO1+gzVxZt9cw3U35JDxEKKJewlQ0R7xL5zVbf?=
 =?us-ascii?Q?DZZCV/TVECC8BazbdUHgrQUa9QuhVRwJWosnn8hPoAAJXks8FXCFjn2rYZEl?=
 =?us-ascii?Q?LB3zYzaffIiF5zDo0HdPA4ruLjjJ23V70sIyB0NBPDImCUI2TOwOBzSZKZ10?=
 =?us-ascii?Q?YcDVAenL/J9z+1c6BJO4r7OOm3MhR2KtyUpASwKT2N3cHmZaEDPBVpz3ovuY?=
 =?us-ascii?Q?0YK0Atn4NtvdipZL+k/2BtEPSnB7ZGo3f/5cvOaRIr1E9tHezFInjakwqy9Z?=
 =?us-ascii?Q?8RdAkmM9R5BdhSJUcAHAHBdNM0sWuQYNzam6f29NiO2eEMysBsogQTXaWrg2?=
 =?us-ascii?Q?2oSR8ykC9WEwoJm8iRupdQopJ+GNEocZCENVbunMS+av7SGZb06SS+RVcoJQ?=
 =?us-ascii?Q?JSbvfvO3SMPscH7m1aqqUPQnWCWjtCfCgxgwASX8oN9hqVjPTIDlPnKhG452?=
 =?us-ascii?Q?Tbng84ByaGKiQ77qtAx3pmZ+7KH2DSEUmUbbZbhOq04odXzCX6LLDQE3DZKE?=
 =?us-ascii?Q?oeSQqoqrbGwCHe0Aak2Gjq30caSqHe22i2D2Tydj7ZLWZ/Uu6ys2FJogZqsp?=
 =?us-ascii?Q?nHN1zmIPon7o4bA8pany3EDMWuM60JbJXU+b9Adm/Aaj95z69TQCoRDT0LHT?=
 =?us-ascii?Q?K/5rj94dX+kRPAhhhvn35wUKFt9YsRVo9SbnTzE/mCLXup7DZJXFheGo3MHO?=
 =?us-ascii?Q?B4rWs2inliyEwNygXPyxFZmw6FdEYzi2f1WZGf25z8D09hmYQgu19wVaGEn8?=
 =?us-ascii?Q?aHYsdaZLY3O653sjqJ+xGUXEP77hb2iTDYUhhcUzh3AOyg3ftS6b5RfhVJoG?=
 =?us-ascii?Q?m2rPEqAEjSwvlGPl2O0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e9789f-50e3-4ceb-7afb-08d9c6e90a69
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2021 14:24:05.5707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVx4DTD5gXNiV/0MrVKUxh3bzo6BgxD0Mi+rWkVuBT+ApIlDCh3HEaDeJV87drtD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 24, 2021 at 11:19:44AM +0800, Lu Baolu wrote:

> Let me summarize what I've got from above comments.
> 
> 1. Essentially we only need below interfaces for device drivers to
>    manage the I/O address conflict in iommu layer:
> 
> int iommu_device_set/release/query_kernel_dma(struct device *dev)
> 
> - Device driver lets the iommu layer know that driver DMAs go through
>   the kernel DMA APIs. The iommu layer should use the default domain
>   for DMA remapping. No other domains could be attached.
> - Device driver lets the iommu layer know that driver doesn't do DMA
>   anymore and other domains are allowed to be attached.
> - Device driver queries "can I only do DMA through the kernel DMA API?
>   In other words, can I attach my own domain?"

I'm not sure I see the utility of a query, but OK - this is the API
family v4 has added to really_probe, basically.

> int iommu_device_set/release_private_dma(struct device *dev)
> 
> - Device driver lets the iommu layer know that it wants to use its own
>   iommu domain. The iommu layer should detach the default domain and
>   allow the driver to attach or detach its own domain through
>   iommu_attach/detach_device() interfaces.
> - Device driver lets the iommy layer know that it on longer needs a
>   private domain.

Drivers don't actually need an interface like this, they all have
domains so they can all present their domain when they want to change
the ownership mode.

The advantage of presenting the domain in the API is that it allows
the core code to support sharing. Present the same domain and your
device gets to join the group. Present a different domain and it is
rejected. Simple.

Since there is no domain the above APIs cannot support tegra, for
instance.

>   Make the iommu_attach_device() the only and generic interface for the
>   device drivers to use their own private domain (I/O address space)
>   and replace all iommu_attach_group() uses with iommu_attach_device()
>   and deprecate the former.

Certainly in the devices drivers yes, VFIO should stay with group as
I've explained.

Ideals aside, we still need to have this series to have a scope that
is achievable in a reasonable size. So, we still end up with three
interfaces:

 1) iommu_attach_device() as used by the 11 current drivers that do
    not set suppress_auto_claim_dma_owner.
    It's key property is that it is API compatible with what we have
    today and doesn't require changing the 11 drivers.

 2) iommu_attach_device_shared() which is used by tegra and requires
    that drivers set suppress_auto_claim_dma_owner.

    A followup series could replace all calls of iommu_attach_device()
    with iommu_attach_device_shared() with one patch per driver that
    also sets suppress_auto_claim_dma_owner.

 3) Unless a better idea aries the
    iommu_group_set_dma_owner()/iommu_replace_group_domain()
    API that I suggested, used only by VFIO. This API is designed to
    work without a domain and uses the 'struct file *owner' instead
    of the domain to permit sharing. It swaps the obviously confusing
    concept of _USER for the more general concept of 'replace domain'.

All three need to consistently use the owner_cnt and related to
implement their internal logic.

It is a pretty clear explanation why there are three interfaces.

Jason
