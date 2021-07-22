Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7183D2795
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 18:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhGVPuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 11:50:07 -0400
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:51745
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbhGVPuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 11:50:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RY3xv2QKlTZbQ7dTsfRfod50Y1UFis/OKugdriWfhG+lxkXDcHDVLQjjpaLgIj79RISDdx3icJgcDPRW9WL1qrCQrApMtYb/yVB8y/+M6Ctuy0D+PXrT0yi0Q4mEAAtyMIRgI/oetTmB4MOZ6JXp8rGMeJ0zJaS0K+k2IErc+SafK4hUZB3op+wyOJbS9ouRbyIKMBwq+YmxleJJ1MesLmP1uUtdDwE6szE/sOpsUC5MNV9RCNEPpCJZJ06WayoL48sb1iQQeL0Ss+78N3SoYGTcFVHxgBM7xxuQX7/rffTemgbH3pBE5jdDTCHSWCIQ15R+JSfX6+lBM1SpUUk/zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+Xl85mqAfUzqoaN7WR3UVFRYZK7wA8f8T2jHt92iG8=;
 b=JDriLA6Qy5aCHDAxIrulJe1zS0zC95gW81KXS9Swukz50URkTtT4w0p0WegfTSKvh62uj+BDrepBZ1Vrt34RWzo91n2+loJ+wh2q33sk4SWOZNff2+k2iW0l5+FlbaKJn9sKPFTfqFwRtvsDP9l+YMYKnxBZiSUoIvTsWZn8+Yv5NlAk9sca3gX0nKzOq+xOHay1wMf8WWCwWP9ROVW17k2yqc3Ur/fHdWyEXeTTw8YUMTrav1RsFay0XAl4wLmGt3cgqROLwmiFIQ3ZNyH26xgCK7L2OTMYxtLpUhv0PwrRGsGq5xZBOer+xB7ysbMouh/BNT3uGORZRxsNSryG8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+Xl85mqAfUzqoaN7WR3UVFRYZK7wA8f8T2jHt92iG8=;
 b=H8Unr5zt6+nVY1D17+p2JRk0kuPciMW7e3LE4+RS89ApghJwSRjudyvFNw6qLhhAYMlXJQsVjTLKNIsu2saskf4rXSnfGJYUcbjia/42+iBCWKaolKr0+2on5oiU0WXXMn6WcjKF9UGYSrai5GOD4P73YcBSQxAHDxE3oZvR4CkVmwLhAOxRfeIeIMOD0NB6IJ66ub4qCm7EImcJnMeWxDur9atlW+0e4alf/2sI7U//d6U80bImizmN1EPXr9nf4u6O2zCfsCJHlqMRuTvRMCjJh5gM4dSd0TxBb5YigFB0lA2wQVuMbQmbL7cHncj1Ju6vQ/GuIHtPCB9nPo8d/w==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 16:30:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 16:30:40 +0000
Date:   Thu, 22 Jul 2021 13:30:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Shenming Lu <lushenming@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210722163038.GM1117491@nvidia.com>
References: <20210715152325.GF543781@nvidia.com>
 <20210715162141.GA593686@otc-nc-03>
 <20210715171826.GG543781@nvidia.com>
 <20210715174836.GB593686@otc-nc-03>
 <20210715175336.GH543781@nvidia.com>
 <20210715180545.GD593686@otc-nc-03>
 <20210715181327.GI543781@nvidia.com>
 <BN9PR11MB543337BAEA86708470AC1E0C8C119@BN9PR11MB5433.namprd11.prod.outlook.com>
 <013e240d-f627-3565-aba1-71b2d6f514b4@huawei.com>
 <BN9PR11MB54332CA3CF19835A7B2742688CE39@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54332CA3CF19835A7B2742688CE39@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:208:120::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR10CA0016.namprd10.prod.outlook.com (2603:10b6:208:120::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Thu, 22 Jul 2021 16:30:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m6bao-006M3t-B9; Thu, 22 Jul 2021 13:30:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 344eb88e-a973-4d32-226b-08d94d2e0aff
X-MS-TrafficTypeDiagnostic: BL1PR12MB5334:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53347E2EFCEF628DD78D4EF8C2E49@BL1PR12MB5334.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xYfeB8eRA0S6NtMY0FGWUEmaI6Zk5Q3Mb6d1ZpZ89Qo1rjhnj+UdnsQMKNMvDCwAR74NUQZiLBNGB05v2BE9qu+ZtzDOfcqJ0U9cV4KJJIoz/fVoSb1Ithz5Y6TSyy+YD9ztBigY/k6+qL1i+nOHatdrecdSAXQ9mxKTGPOgODHHAor/k4TTeBBOsX+bnzT5g9DzBgepwD8aaGUmuUQ7W8WL6E6CFfOi2q1C3+wXk9yyVT6PmAjBkGy/dGWTbz+QHRQ+v96b08aZe2vwYsvj4gl6RCleq7ZuY4IsdlL50sd5ABvoqC+xWZ9XnXeb+G1mov/SmexoA7lf46eVn1Dcfe3HpsBKsUMrHEDlk5rSKV4qJW+zAwQK7GED1497btBNiG+8F3WKf9VjdNOXrbb8Yr/ThSAtupFuOSE5u5v4nUdqGGuTATz1yuBrZNk5K0wcOjaWOPlIM3rNEl7XniaoiteivtgW4c/a7wbLsWIgTGBZ4dYtRdHvAZXbV/0swNRUoDsAljVG+JCZDmOIjlV9UG9khYoZ198wlUqqywoRs8hPJW+4RN1Kw0Zo29hbXJjOLqKDixUSOo3QVnsOvSbLhDYeLFMNa2opXxctEiRU8bwc9SjKmhxMGxRM0aXncjjhIt+URbcfFexc6mOWU9ytTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(478600001)(8676002)(83380400001)(66946007)(7416002)(5660300002)(54906003)(66556008)(66476007)(316002)(86362001)(33656002)(1076003)(4326008)(2906002)(186003)(8936002)(9746002)(53546011)(9786002)(2616005)(26005)(36756003)(6916009)(426003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bPxAI4w//4PUfQhC0QG00C94qw6Eeo9adotOi7owC+pwaL9IlscqHIlNi5cr?=
 =?us-ascii?Q?CnFLkn02ZGcuSF5hsS7gHqw7bX1DKo//a0w4WxdJDCJacgpPttmfrlIhG60b?=
 =?us-ascii?Q?0chJsBjZWhttFgwR/qHXzuMFbIoQhWgUeDJjtXEWleWy71ZYVACGSDlQ7JeM?=
 =?us-ascii?Q?R4/mHugvJQvYF5WSQ4EDcWXhQF5XNIZrdkckMoH6gtDs2Yq07WFTwXtSKMnX?=
 =?us-ascii?Q?BsawgjYcoqOp6CoEUDJL1mOpqyq1RJvcle5hCPm3KXto6FRw6gqKs8Y6Ivq4?=
 =?us-ascii?Q?KZBll4Q5F+dI+IDPXjdsj3YTQfI1tKJzqebKm+9rU13p8YXnkYbvdVSKgOmP?=
 =?us-ascii?Q?URXkJ2dhHd7zftp4jN3rnvALJ9dKWBaMvolJz2NwCJlzhBGXcsZu/k7t5kLl?=
 =?us-ascii?Q?9jD6QEvOVgBYDa6stC2EVrJdXtqImb+zy7hurRQ/BIZtazYZldD+ySz5SlVz?=
 =?us-ascii?Q?sqKswDsXuF48TGa80XfquIf6FWPAs5H3jtHbU8kqnNXBMZDAWORKzMaAoxex?=
 =?us-ascii?Q?pGslt2rFCgvpgyq5AXkmLQvCVmkdhAT4WsWDdP1jwNKFjrabSoMkL3z43R9o?=
 =?us-ascii?Q?cfzkXXkMY+0w7uI29m7U84J1PrX2iOG1h4Y6fbomm9D++QK/uKRRrQCBKrvI?=
 =?us-ascii?Q?Lj3sCs2FIi2xMo0CX1gxGvWhJFmHt1GQFRuCaZu2XFy2r3QNmp+Qo7dLPeeP?=
 =?us-ascii?Q?g/eVgTLuk4UoNY2Dzk3fYv/wU2mX78/CNe9FMzhYtJ9F1bqQ9RB5gdg6wyRp?=
 =?us-ascii?Q?dsPKj5EUxS9rDg/kTRk4jShkyK6z25yPYvVYhUFuJVnaipCkbISsJk0EYFH0?=
 =?us-ascii?Q?bJ6v7r7TnvlnPdRNhRgpTBA6aDHq99dp5dxWYe5TQBNwh+69ew/LL5dLGHzM?=
 =?us-ascii?Q?EnufrevsnJ8qavhIORh/Qh4WLhNJiQ3DZpbikMDjVBIzB0oLTDcimk2OXqZ9?=
 =?us-ascii?Q?49AlvbSlBwZQ0YCo9e/VraY49nBbManU0KY42T843LzwMnJV3nvj3ECtjBvF?=
 =?us-ascii?Q?cF+U8iy/6SM/HYF1ecig/FebiaC+TZDldTMxyvM1j5WOqXp2F1/3unY/D5+h?=
 =?us-ascii?Q?sCyqXMi5R29aTJST7xE69p89KlVTnwd++f7Z6nQLQUtn5TShSpefZHDMDK6c?=
 =?us-ascii?Q?/XbMMwhKC05BXAHloVtWzKzRaoxzVkghuYe0+yAr3vwYCk7qec2RwtjchaUH?=
 =?us-ascii?Q?qInjiCHQIkiYEP4h97w3nn4M8Eajd1mO1obNonk8US08agXmOeWBfBp5zZrP?=
 =?us-ascii?Q?TA7SHB/+OA/Luot/6z8rKkQBj+/RdlOoP+6xN7993UIeT73kL5aorDXrqekp?=
 =?us-ascii?Q?DBF4il5L1silZlXuQyGUXs8h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 344eb88e-a973-4d32-226b-08d94d2e0aff
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 16:30:40.0511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvUAEALwCS5w/XFYiV6mSybpjn/RxeexubCuYi/m0Sb9xPcWMB7luTqwOpBHb3YO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5334
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021 at 02:13:23AM +0000, Tian, Kevin wrote:
> > From: Shenming Lu
> > Sent: Friday, July 16, 2021 8:20 PM
> > 
> > On 2021/7/16 9:20, Tian, Kevin wrote:
> >  > To summarize, for vIOMMU we can work with the spec owner to
> > > define a proper interface to feedback such restriction into the guest
> > > if necessary. For the kernel part, it's clear that IOMMU fd should
> > > disallow two devices attached to a single [RID] or [RID, PASID] slot
> > > in the first place.
> > >
> > > Then the next question is how to communicate such restriction
> > > to the userspace. It sounds like a group, but different in concept.
> > > An iommu group describes the minimal isolation boundary thus all
> > > devices in the group can be only assigned to a single user. But this
> > > case is opposite - the two mdevs (both support ENQCMD submission)
> > > with the same parent have problem when assigned to a single VM
> > > (in this case vPASID is vm-wide translated thus a same pPASID will be
> > > used cross both mdevs) while they instead work pretty well when
> > > assigned to different VMs (completely different vPASID spaces thus
> > > different pPASIDs).
> > >
> > > One thought is to have vfio device driver deal with it. In this proposal
> > > it is the vfio device driver to define the PASID virtualization policy and
> > > report it to userspace via VFIO_DEVICE_GET_INFO. The driver understands
> > > the restriction thus could just hide the vPASID capability when the user
> > > calls GET_INFO on the 2nd mdev in above scenario. In this way the
> > > user even doesn't need to know such restriction at all and both mdevs
> > > can be assigned to a single VM w/o any problem.
> > >
> > 
> > The restriction only probably happens when two mdevs are assigned to one
> > VM,
> > how could the vfio device driver get to know this info to accurately hide
> > the vPASID capability for the 2nd mdev when VFIO_DEVICE_GET_INFO?
> > There is no
> > need to do this in other cases.
> > 
> 
> I suppose the driver can detect it via whether two mdevs are opened by a
> single process.

Just have the kernel some ID for the PASID numberspace - devices with
the same ID have to be represented as a single RID.

Jason
