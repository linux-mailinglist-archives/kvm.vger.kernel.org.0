Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C0C453B32
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhKPUve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:51:34 -0500
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:37664
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229527AbhKPUvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:51:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8l1AHEHaY4aVI16dAQI75juD9XudwRzP+Zq708JVc1BGUWZ5d6dYUidfeHePxw07tuzispmqtkvF/w7vllDUFuGZQUjy+708KlxnP3NkGZ3oGzrjVxKvZV4vwMnl52+9xe2udnigcA7smI7vHfeioTxmref9bTbAv7pfAJa4IUpz530n32e112m/hg/dBOVCYok4QPjS31DzEexSGP0EuIXif4oxoTXRbju8/7vg3c3I+aauVE207McJd/+yald2UeuWQNRBPoRGql+u++uA8WcBebCpl/VPgAzgSbTOOb99EvXnOcKYlWY3ebCxIypeQgfDaY+JeacWnimBR38Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txWjKYCTVc7iVTNkGHghOHNGQpil12vVO1xLbMyH4ow=;
 b=nqYJH8kO2dJM+1VMtp7oXaGVrR8u41mkxCNGAimzFS7ThPyy9SczabFNlC/uzftTEH91yKmRsBHULoSzTlfV9WCmH0uqZQ0t/SAQBHMG2AEBCUIh13KpfO9QfcU5zpkM0Qmw8XG/hEg+gfkTY7xLdR6A83pDc3b8vnqpbYn7k8cOLnXmkXOvPbJk2QPFzNKjg9rb2hLaXOHIFuOMRvnYXSZr+sJPzc723x9YuGCONqdaInxmWdaPgNprxON5xHYsS9aP4zjjd8fuYnJRswKTzjRFk18bXsPn8JHNkwDjS/UeB9v79SDpJzIPPkp5lZBhKh53D2Qe/T3eFx55JBOyvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txWjKYCTVc7iVTNkGHghOHNGQpil12vVO1xLbMyH4ow=;
 b=PkU/8lkF5LDE8YjBkR+c2jH7EA4zMZ/mPsubgFDSL/x04/zBL9o6oEoUScOAhDwsgHnHnEOtb16E9+6r2gkSc9kO4QrbBxEWMIz6bVeTilHAEKbj/KbrWTNfBNh9poesxblO/ylWFbVbm7qtQ9LsLktO/CyDqQMOqAJajrbo3OiBh+z8US5pWyzE5szUsWMNXs0aWczrlyUMQL7xGb7EQtc+64hGSv8n1o5Rb+kRfqgVzTavAS0jbidGlfRRbhq1hhqZYdDnLsQ7VztPOwpTgHDyQoUYiqyi8Z20FE8V5KuLcSBFHJ2RdnQGkphF+ebInXw1mw6qmNmYS5v/sgctKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 16 Nov
 2021 20:48:34 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 20:48:34 +0000
Date:   Tue, 16 Nov 2021 16:48:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        rafael@kernel.org, Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20211116204833.GG2105516@nvidia.com>
References: <4f95bea7-3c1c-4f12-aed5-a3fcdcd3fee3@linux.intel.com>
 <20211116202201.GA1676368@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116202201.GA1676368@bhelgaas>
X-ClientProxiedBy: BL1PR13CA0268.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0268.namprd13.prod.outlook.com (2603:10b6:208:2ba::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.18 via Frontend Transport; Tue, 16 Nov 2021 20:48:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mn5NZ-00BDol-Er; Tue, 16 Nov 2021 16:48:33 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41d51caf-1263-4824-31b6-08d9a94274e6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5127A2DAD56D63381BDEEF51C2999@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32wI808t9Tvt8CPp5Aub3OUUM5r1/mrmY1d9Uf814pasUwf414AoltTGheNxFc7AttHy5WTY893Jz7JxX8YntAmwUcGpN4giuoeprYdSB5p6a2gX9ZYYHEV1COfRd2gcguHVufsXmjCTLDblavy7VEM5HebBiEMZLhEyOxawgBSI0WxoLjYOY09whb6Otrva4cDGSEFLO3bps5p/CIh7/s0GdXICmJewqDWLLWvtt1JIRKlyYxW0/eLyjagDjIcYrApy9Wedb8FcZzAiOBJyKzhgQr/4l5hQlwaFgrnkJ/IKugMBwS7Eglx/PjyMI8g4WKWyQg18UL8Ase/vc7Jx4kvaPJmGOAaf92C8yLO/E0gAh0xASAY1SSM6HMiKc88vnAVw1W5vKHn9L1C4ia9R8lHD9xF5C6iVZmcn3lAG5l14r+1ohy+sQSWFAzNnONvAwasxJaAL57flARRbHqfH6xXggJPfE4SiiA+iyNnM6ifLqiIjf2xXefPhrKusMRCJRfGCAgH1KnxH7PBix0yUYP4ME/h4Rp0yA5ZHRh+R7mHvi5bnhtjMWAuQjIS6NspSXV5aoMn7uCnRV3pjbaQl8lbSVPGViAc1xmTHRLIjE6vodQhi8fGnNGT0oYfBncjd83T+yi1vHXWrE9QNAd5aSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(8676002)(66946007)(5660300002)(1076003)(6916009)(86362001)(8936002)(186003)(26005)(53546011)(66556008)(66476007)(38100700002)(83380400001)(33656002)(508600001)(7416002)(54906003)(9786002)(9746002)(2906002)(316002)(426003)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15JsD4JKbApvTI0F/PzrOVhhmUeyw5W2/Lr2Q+XT5zGZ/G8Xob5a4pcyJjd5?=
 =?us-ascii?Q?Mv5h6/wo9Kq/G6MNzUmRmDQiS/LkZe2gu8QSFK++J5G3PD8+v+iAADTKH3NI?=
 =?us-ascii?Q?4P+42xfLK3FcNRJHt+kT9Q0rjvUEV3s5OXC2s/xG6FY/SBBweHj5M4CTOP91?=
 =?us-ascii?Q?krUvxGjQmK0tlGxwr9KGzboRtzLt08Ssq1yuZ14w0wRCJmQeM9eAW1L/8IPh?=
 =?us-ascii?Q?yGVIQsRuC5XJ3BfZqjU9b/ohsFE5K0z+EJesB2xn1VJFHuJRMDJ2Fl3swU9y?=
 =?us-ascii?Q?drZASO3m5MX3oc3G2L2dxvsYNXl/G2aB+kBKbCULPWtYzd3EJad4VYGjsOtw?=
 =?us-ascii?Q?Drbaft9Zqm0RsWegqV0hQ8k0s4FonL3EpDaq76njWVR8FdZcQO7GTOu1gjac?=
 =?us-ascii?Q?Lgu2sWHTR8kdKLg7l38Zr7wvgG7Crm96oDyCGXeW7bndimr3nvuyl22Uc3L5?=
 =?us-ascii?Q?KJSuobQu5utdC6hryI6ONXYEeHuNd4Kxi0yOoKAMdpye27qZBYyeSj+W55fc?=
 =?us-ascii?Q?VnqrRNnSh9KtnurvqDtdrDMqRB7veZHguIEFGJhKGrP4dxrthurxtfV4GoFs?=
 =?us-ascii?Q?4uH7cp/Tppl95g1AKQaQWP3WP8s3n3ioPoSOlvszBoZtsKQy1pxzw3uD9S1E?=
 =?us-ascii?Q?Va2XCYmEQXMB6SbCFGJS7hpMuK7lohJEyAJ+4uOrTrKkMRWW4bnwd/2+LczL?=
 =?us-ascii?Q?1rGh5ZdiRao7nnarnJNSF26kJC9P6xLptY0fWoLVdPSO/U4qd1jJ0Iu+X/l2?=
 =?us-ascii?Q?KVopPinzxGau1gNJIS53kDWyYEvXQcXJ4pw3y2IcBAd2gOIXv8CtDNzns9X5?=
 =?us-ascii?Q?s2zZHx8Ql/6xwii13WdriAs9k3b3mZ3FqJVUDSTGSvKMKrm1WZ4gjBv9d6zd?=
 =?us-ascii?Q?G6mYxo1NY+gouKxtMoqPeaza6713wD9ciG2HoULYQ7V4oAzjXgziN+qnQ4dM?=
 =?us-ascii?Q?tluHuOjVze65C+dWzjmHUHloKwXVz4pap1GYuYpirz994u+hut2KznLHB6QX?=
 =?us-ascii?Q?Nm1Dv/lxrWttKJyk32ulycUq5PZ8Pcoh8mMY3bgwKQduuSieiWkN4GuJrcXP?=
 =?us-ascii?Q?OeggjbgMasygu2EaOSIZqft6mLhrb1VfFQWwe8SdtXT4egkwmQpPxaVOuS1n?=
 =?us-ascii?Q?r/kOtRISnUxkqYPuXiZbKkArrGx3v5AJDbVnw5wf4UBVuI2v6X0iyEJi1424?=
 =?us-ascii?Q?bF/a309d1TOJOm19tCGd54V77aF9MWYEvjZx0OXZxrRI9yLmIa9oxRlfMsIm?=
 =?us-ascii?Q?mUlZ5AxLF/rPPZF0jD1EOS0+mYqBGuh3bFhlELA9GsTp8AmWcbJC08FOuKrG?=
 =?us-ascii?Q?eDqfnOADjiT8/NdKWf7wZ1q+oJCXNvXHlkb36KFwqIultl5HS3fmC1WP/W0R?=
 =?us-ascii?Q?14sc+iQy1cOwmUEUxr63uXi82+gpqK3iAJFUgK4XurUtYfF/mpZZh7ljP3ah?=
 =?us-ascii?Q?yXnBeZfUWDkOmBIE/t42xyjZV1HpEFhQ2aoeSN0MOMF8u4ioTNWpCt7hD0HT?=
 =?us-ascii?Q?HedJWGaDcADS7+a4x2m8I4Cwe3ewZ1td2fCDHI7huP752a/XH+Krk6xaJdOG?=
 =?us-ascii?Q?QTRoPbKPE0FxZeYXR+M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d51caf-1263-4824-31b6-08d9a94274e6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 20:48:34.5855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1FwJhB6pq4ubbvEuuZhQLxq17VsnOOC6zAloJdA0VxEbe1xmdcMye5J0h2jnwjn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 02:22:01PM -0600, Bjorn Helgaas wrote:
> On Tue, Nov 16, 2021 at 03:24:29PM +0800, Lu Baolu wrote:
> > On 2021/11/16 4:44, Bjorn Helgaas wrote:
> > > On Mon, Nov 15, 2021 at 10:05:45AM +0800, Lu Baolu wrote:
> > > > IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
> > > > then all of the downstream devices will be part of the same IOMMU group
> > > > as the bridge.
> > > 
> > > I think this means something like: "If a PCIe Switch Downstream Port
> > > lacks <a specific set of ACS capabilities>, all downstream devices
> > > will be part of the same IOMMU group as the switch," right?
> > 
> > For this patch, yes.
> > 
> > > If so, can you fill in the details to make it specific and concrete?
> > 
> > The existing vfio implementation allows a kernel driver to bind with a
> > PCI bridge while its downstream devices are assigned to the user space
> > though there lacks ACS-like isolation in bridge.
> > 
> > drivers/vfio/vfio.c:
> >  540 static bool vfio_dev_driver_allowed(struct device *dev,
> >  541                                     struct device_driver *drv)
> >  542 {
> >  543         if (dev_is_pci(dev)) {
> >  544                 struct pci_dev *pdev = to_pci_dev(dev);
> >  545
> >  546                 if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
> >  547                         return true;
> >  548         }
> > 
> > We are moving the group viability check to IOMMU core, and trying to
> > make it compatible with the current vfio policy. We saw three types of
> > bridges:
> > 
> > #1) PCIe/PCI-to-PCI bridges
> >     These bridges are configured in the PCI framework, there's no
> >     dedicated driver for such devices.
> > 
> > #2) Generic PCIe switch downstream port
> >     The port driver doesn't map and access any MMIO in the PCI BAR.
> >     The iommu group is viable to user even this driver is bound.
> > 
> > #3) Hot Plug Controller
> >     The controller driver maps and access the device MMIO. The iommu
> >     group is not viable to user with this driver bound to its device.
> 
> I *guess* the question here is whether the bridge can or will do DMA?
> I think that's orthogonal to the question of whether it implements
> BARs, so I'm not sure why the MMIO BARs are part of this discussion.
> I assume it's theoretically possible for a driver to use registers in
> config space to program a device to do DMA, even if the device has no
> BARs.

There are two questions Lu is trying to get at:

 1) Does the bridge driver use DMA? Calling pci_set_master() or
    a dma_map_* API is a sure indicate the driver is doing DMA

    Kernel DMA doesn't work if the PCI device is attached to
    non-default iommu domain.

 2) If the bridge driver uses MMIO, is it tolerant to hostile
    userspace also touching the same MMIO registers via P2P DMA
    attacks?

    Conservatively if the driver maps a MMIO region at all
    we can say it fails this test.

Unless someone want to do the audit work, identifying MMIO usage alone
is sufficient to disqualify a driver.

Jason
