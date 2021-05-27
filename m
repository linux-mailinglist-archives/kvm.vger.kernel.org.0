Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F77E392FDE
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 15:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhE0NiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 09:38:11 -0400
Received: from mail-bn1nam07on2052.outbound.protection.outlook.com ([40.107.212.52]:49599
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236007AbhE0NiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 09:38:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECqbc88Gbl06YN7SXaQkLEXYSv9hMR16FkuyrZPvsfQxIKma4dhJynwYrneS1FypyKd3TzCxhPsaut9U7oNEHrGXeh5Ywm1kRdh0jN4dqJReA4vELbemJGbwtC904yZGLRDRxrTQjhy5JyWz8BELF2/tJ5GwV4zIeBLobjKlvPuuDJVq7myALHzedeLDj5g8H3dbsTL0isqqFhrWBTPaHe3lIoLWnqrrP76ZMEfZft9dV71UjA4/L/Xhunps+dSuSF6TgnRMlosLiwhZVawT2xgP6IFNupipakCowl5lBbwhLOfFm4D/C7arQLoPOkOR8ODdG+RRV0oFOpGXTdzKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNtUHTU7lYLH9+/halfl6U76JnHV8zZoqbRyXWSvK2M=;
 b=eDuzWL/VWuJ6G16gSE0EBIE0KqND+ToGc7C0cWuClsj1dEzxJLnBRcv0tHiIPwIDWyNhnnMQ9CUjFF+ZTNmFDMlrPGmEDSz+U2JqVhzILYvutRH29hT35P1K/35QhzUuOpl0oXAhkXhpbTaTD52p/hhKZPoLJ08bTvSC322CXKylzqUjfPBDUctobAdhQ1mqRZUOyqkmIxqWhIm1TqQtZVlAJ9Xk+qWIp1Xyxal2x7kQC9jqnr5DQGvM1MEOMUuJUMFilBTMGJPvS6RQp29QC0U5m33294erbKT8hAv3KG1h8VitaQ3YolVgmeZLj6RvCmGT3RKFKIDHVzHU2zpcnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNtUHTU7lYLH9+/halfl6U76JnHV8zZoqbRyXWSvK2M=;
 b=syIJ+ty6hcLFcekBKEtR0oNUaWRloN0gI6aTV64ZIwHgyN5p2EZ5YG5VR991mDboS3WXF6HPrvPiD4yravh7k48G/yIoUg/ovwzlmRwu9KAhIzMfWZ8OObnvPZeHnLS9ivos0U4aCpdn/lqlr2i41+Y864SkhJ4HBSywFcyKUGzASenelxB/g1WhQM1f/PrwoBRtKNpAD/G1pRerH7YaKs3S9nCDMXXlxPN1L1AH8gNnBDI2A9VPeY0ILqonV08Iyn5taHe4hGeMCagmmWe5rBEpAb03o1K/cwRfK26bXS4emFuv+Vh5p65dafccdil6E2Wjfil60tMhmKmXwGbwrg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 13:36:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Thu, 27 May 2021
 13:36:32 +0000
Date:   Thu, 27 May 2021 10:36:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, tglx@linutronix.de, vkoul@kernel.org,
        megha.dey@intel.com, jacob.jun.pan@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
Message-ID: <20210527133631.GC1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
 <20210523235023.GL1002214@nvidia.com>
 <29cec5cd-3f23-f947-4545-f507b3f70988@intel.com>
 <20210527005444.GV1002214@nvidia.com>
 <20210527014107.GA18829@otc-nc-03>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527014107.GA18829@otc-nc-03>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:610:b3::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0054.namprd03.prod.outlook.com (2603:10b6:610:b3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 13:36:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmGBb-00FZYJ-De; Thu, 27 May 2021 10:36:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9dde9b9-dcbc-4ee1-8165-08d9211470d2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB525430A6CB548754BF5B151BC2239@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A0Vpf1ZTw+iADOJK0FteaZ0CJUOuNYLRgQRBkT890TGgCK8KpsatRXoFfsxnJ/x8pYo3lgHrOKA4mvCBy+1sgJfXY9zs06rrWwmjrpTnMOqrVv3wtxMMGd0H5L3VqDu01twyLR5OcmXZ7meB+T+WC1/5l1+4nj+wT45Ay6iAxyNgk2NOpPCGQDf5BRlWExV9yedm1wvtugjQ5bW5uMv84iNa6K53sOusFjg1mI5E6zbKWZVf+JN6vuTKI/zKbVmquh751hfPoj0RZRhv0YXj+MW4xyeNY/qElY2LUXn57t9b2GSQX/dI1sJdmC9o0Ocpgkb7LqpRbsN3ZsgdNO8D41YTgpGGdfXXxHYGY3q3XrYNK+st+V67apw4gAEYMmH5bMODiZ2YyCaeejNNct5O6IFtpJJP7gKVQwpID2R0UaJmcdjQNQEdL6OYE4mWGDwvRFWgUC86oqqbOfhZnhE0eyRCpiqERz0aWYCIf41gVVg7TE4Edjl72HqgRNOS6f4YQSlZ90spZHOAVHtniAKj5i7IYCN5FHwhXsoJiRqJsM17LgzmJiZ4HQNVToOb5+Uj2sRee1uiUVXGlPAnblq5SHlg+tTOveNv5mymLP7WbSM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(33656002)(478600001)(5660300002)(38100700002)(2906002)(36756003)(6916009)(426003)(186003)(7416002)(9746002)(9786002)(66946007)(66556008)(2616005)(53546011)(66476007)(1076003)(26005)(86362001)(8936002)(8676002)(83380400001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O6DEhgJyBqkbrdphpiQRuA269m8m9U00jU6Ar+T71hTLmYCB09VaAspKtASc?=
 =?us-ascii?Q?EmBkJy2MYa1Qpsr9GYLoXAugN+AwvBHPyNkP4+ubq9I4Sk0UxHZOoF8pu2Jf?=
 =?us-ascii?Q?eJdb6HI/BRMj1uLA08qg5Rdyw7L7tlagl5v5VR1AVkbe9MGh5Q7sVa6IY2Cm?=
 =?us-ascii?Q?DZT63+FjB0SmCe4+k2+UWvixKepMDQ+za4/Unq+XHv8Y0jVchBRujfNZSNDq?=
 =?us-ascii?Q?vwGqNcq4yZJt8CDLa/fWywzkSKmdHmRjz9bFJuLfRkNPaL6PNblEgDAQmt3p?=
 =?us-ascii?Q?5xfmeSt4i9bdrmYVBA0OY+2qzgtN1r+yZMgWvs1Y9S33XTIv9UfH9QSKefAe?=
 =?us-ascii?Q?/PLUzhylHD3SHpPy9ZKIS7NjyAmgnPVeOOlFgCCZwUMmMJom6VAlHENuLK1+?=
 =?us-ascii?Q?DqRFqO1yl1yqhGzO+71zjisPJImAEZ/WY07i36FHu9SnHgKd0vnmwKqwVLlK?=
 =?us-ascii?Q?LhEGRbVW56Gk/qEzuqtWA1IT+X8SjrcY08VhJmhpBw2kUethImDyF1bcYz5W?=
 =?us-ascii?Q?KktukE1hpQMUc4GLD380RgPdLWdU3TtSUc83BVXu5p6giD1rdxMRr0Gx5eHt?=
 =?us-ascii?Q?JfcEAPdINYfTovaZ9Wcew8XAPu8e1ySXrHtpmJJNFe5pbwUMuyHt90636sb7?=
 =?us-ascii?Q?LVW9ousTOlsHK8ncxDjT4V8wEoghEXyJMTnEbqybw6jfZyGs1MPSfTdP55zN?=
 =?us-ascii?Q?pZ/DYmBW1d7pCyFIaRqJKctTZUHNC+S6I0ZfhkoNpA4jVuVvyrU8EJn+Y7Eb?=
 =?us-ascii?Q?vkd9B/w/2PnZLxQRe2CHwLb53XSe2W6xCkpXVDpLUnUpjlmhuFEvUq9BOZ9G?=
 =?us-ascii?Q?KQEKI9o13H4sgA5+BOGbG/6ZBHsvwUYtKv0UtwrRs+wVFizOPZwjdwH6kyGJ?=
 =?us-ascii?Q?WLd5C1JflY3Ow/9557vWFmJzR+ztdfFcyp5JZllMiL62fh8NuecXOe2CSoJE?=
 =?us-ascii?Q?b55UUAK1zPP1i6jmuQyxyKZJqtLAItujJULCVqLDIXAcZJMFiTEh2H7R6T1+?=
 =?us-ascii?Q?xHSc8QDB81/ndhF80dG083svcYuduac/ZRjC72KgpFGb3uELgMvHAHiSfP5R?=
 =?us-ascii?Q?d8gyGwW4ZtHVzQhPf+8JsfbHc1lvb/z1fR8JnMm3g4DM5LIyEza9eIHQIGsG?=
 =?us-ascii?Q?Ckk7/DhVkVfAGLGE/OV3q60F8NtVgmgYchqUXzzkDUcISk388dXBy4NfjNnU?=
 =?us-ascii?Q?7xTUY7JRaljgetObcP9u/EuDP14Fdtr/C5Tfzma+XTx/58T2Y7CM4REoeGaG?=
 =?us-ascii?Q?KHwSpa7cdwYib5VzNSCzgoh1YoU7KKduiZYJ0EqyyN4BmHWOyTIU4P9uKONW?=
 =?us-ascii?Q?qzEu1gw64MxataVT9pNL0g5l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9dde9b9-dcbc-4ee1-8165-08d9211470d2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 13:36:32.7553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PoXy7q2WXyQBj2dpheX3Yai993sN9nVHyLG93R0Ib0A/1w+uF8j+9jRG0LI1Vp+e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 06:41:07PM -0700, Raj, Ashok wrote:
> On Wed, May 26, 2021 at 09:54:44PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 26, 2021 at 05:22:22PM -0700, Dave Jiang wrote:
> > > 
> > > On 5/23/2021 4:50 PM, Jason Gunthorpe wrote:
> > > > On Fri, May 21, 2021 at 05:20:37PM -0700, Dave Jiang wrote:
> > > > > @@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
> > > > >   		return rc;
> > > > >   	}
> > > > > +	ims_info.max_slots = idxd->ims_size;
> > > > > +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
> > > > > +	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
> > > > > +	if (!idxd->ims_domain) {
> > > > > +		dev_warn(dev, "Fail to acquire IMS domain\n");
> > > > > +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
> > > > > +		return -ENODEV;
> > > > > +	}
> > > > I'm quite surprised that every mdev doesn't create its own ims_domain
> > > > in its probe function.
> > > > 
> > > > This places a global total limit on the # of vectors which makes me
> > > > ask what was the point of using IMS in the first place ?
> > > > 
> > > > The entire idea for IMS was to make the whole allocation system fully
> > > > dynamic based on demand.
> > > 
> > > Hi Jason, thank you for the review of the series.
> > > 
> > > My understanding is that the driver creates a single IMS domain for the
> > > device and provides the address base and IMS numbers for the domain based on
> > > device IMS resources. So the IMS region needs to be contiguous. Each mdev
> > > can call msi_domain_alloc_irqs() and acquire the number of IMS vectors it
> > > desires and the DEV MSI core code will keep track of which vectors are being
> > > used. This allows the mdev devices to dynamically allocate based on demand.
> > > If the driver allocates a domain per mdev, it'll needs to do internal
> > > accounting of the base and vector numbers for each of those domains that the
> > > MSI core already provides. Isn't that what we are trying to avoid? As mdevs
> > > come and go, that partitioning will become fragmented.
> > 
> > I suppose it depends entirely on how the HW works.
> > 
> > If the HW has a fixed number of interrupt vectors organized in a
> > single table then by all means allocate a single domain that spans the
> > entire fixed HW vector space. But then why do we have a ims_size
> > variable here??
> > 
> > However, that really begs the question of why the HW is using IMS at
> > all? I'd expect needing 2x-10x the max MSI-X vector size before
> > reaching for IMS.
> 
> Its more than the number of vectors. Yes, thats one of the attributes.
> IMS also has have additional flexibility. I think we covered this a while
> back but maybe lost since its been a while.
> 
> - Format isn't just the standard MSIx, for e.g. DSA has the pending bits
>   all merged and co-located together with the interrupt store.

But this is just random hardware churn, there is nothing wrong with
keeping the pending bits in the standard format

> - You might want the vector space to be mabe on device. (I think you
>   alluded one of your devices can actually do that?)

Sure, but IDXD is not doing this

> - Remember we do handle validation when interrupts are requested from user
>   space. Interrupts are validated with PASID of requester. (I think we also
>   talked about if we should turn the interrupt message to also take a PASID
>   as opposed to request without PASID as its specified in PCIe)

Yes, but overall this doesn't really make sense to me, and doesn't in
of itself require IMS. The PASID table could be an addendum to the
normal MSI-X table.

Besides, Interrupts and PASID are not related concepts. Does every
user SVA process with a unique PASID get a unique interrupt?  The
device and CPU doesn't have enough vectors to do this.

Frankly I expect interrupts to be multiplexed by queues not by PASID,
so that interrupts can be shared.

> - For certain devices the interupt might be simply in the user context
>   maintained by the kernel. Graphics for e.g.

IDXD is also not doing this.

Jason
