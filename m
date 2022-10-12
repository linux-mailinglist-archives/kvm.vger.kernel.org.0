Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976E15FC559
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 14:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiJLMc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 08:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJLMcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 08:32:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9491C58A7
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 05:32:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7Y+df0uzfOi+9T7OZPN1Zf53pClS1dAUJwb4EGdzntLGGkQzyI177Eh96BFlMjZXa64RLqwkq4aQH4TZ/geY59BLcPDzy6MNDEzqtqZ63vJH1+ilX7DfaRGa22NAMmItwUegJ2blxt8c1hxaKrRkL/blT1FTI512FgIRLoL7OoowBG4EWKl5tQFo88HG/x4uMr/sqYRTzA9yaVYkWkXbFXAvyEE4UAXbWgbHCr7vxZYAG+P/EuNzgQOrHIKbfPVNDZMqt+4rCo76/7sGNFWmdfW4kzKmUV6HUAPAQmKzelTAO90HZQ0RDOZNd5B2I0zJWKTQogKJHbbdDuYptIc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z55iPC7ebLxGvvdVAN+hPoHKp1zIe1pkaxaefl9+dlQ=;
 b=JYt/YcwZx4d6hEm5giBn8LKhAyoJhQ/TpIRRQMAoAk2ZOTgebLuD9L/d5WzqVb81HxEp8Fwj5/5ZIb93TH7o7cWzxBqlIzVtvprVxZPGgppRQsQ1Rjz5mUikRNtINu9YLrQGpeEtoSeySkBr/M+HcizbdlegDw55ro9JWLXAGomH4zp3Rs2Eba0KC0CGk8WjYD11uGqL/oUzH7HDDl59Y5f/nLaOqjhxLVeiWd/MLrSfLgzvGHiirCNL7Zu9jeomRHvVVXb7AzXRD0DaM+I1ApelkVYmLG/OxWFdG0vwufjWWqHDKxSOHbCYbz6VSjoQWVluQn7csuRTJ9lgdqlpvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z55iPC7ebLxGvvdVAN+hPoHKp1zIe1pkaxaefl9+dlQ=;
 b=YOTfFfv3YiZaRnzzfWW84kUdKcdfrWljJP9HJFfED0RveIvGB/LvRYbbHmv+v4JTS4XoBwzn0qQnBtr1S3foo0Ra/RedfMG2PSE4d4kjTUCiPcymiBJBk3FNena29qaUCoZQr99QUkxcj4PGb5l44TzDnr9Sx9HZEykbO9Cldz2MphNgtOqUvYdewjtktQzOAVXZmzqOiT0M4K196E2gVgzXd7/TEYieBHOr1iutrb95ysIGoA3vYIPwOc2yiL0JB13mEOxaCtzB8O5TvlGnbM6bT6++SkSJMGRVDEhGUnHKe0bZaXPvjp6wkE1L0z3KegePsaYG18nBDJQBtg4xcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.19; Wed, 12 Oct
 2022 12:32:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Wed, 12 Oct 2022
 12:32:52 +0000
Date:   Wed, 12 Oct 2022 09:32:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Y0az8pNrA9jOA79k@nvidia.com>
References: <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com>
 <Yz777bJZjTyLrHEQ@nvidia.com>
 <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
 <Y0Vh868qUQPazQlr@nvidia.com>
 <634a8f2f-a025-6c74-7e5f-f3d99448dd4a@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <634a8f2f-a025-6c74-7e5f-f3d99448dd4a@oracle.com>
X-ClientProxiedBy: MN2PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:208:fc::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c2d4e4a-b8ac-40b8-7b63-08daac4de13b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3oHYcCIDch2oixq9u0yDtA9aPrzT1v3DktvQh80SRjD0pWfwFugnLWipCl5PwCuDieYoIJPBKAeLECCQUVsyNEu4V++367MVRl6UcoypgMt89IENlNLHbgvELkT41XYrfNfQkaSyZf0aRUCoBdYz++M9VyuurVX7ufvB9v9nluOy0CLVobZd5BStEbhXUDxZtLEzvUurzmvtlrESv1IbvLawXHnuyt1I4T8zN/xA/eh5+V5Ea/f7DPtluPr3bQS1MM9pVeI7Jc5QpfTIXKimGTimsf+AyraW3ZPDQKFtenZG0QpZJW0iX0mI2Cvxf3hZWhe/biPOXuFfICx+RFnjX1j6ZiQFZenNA3jU+MtxZg/hber1WN8iVvdf55qAa2pzoqjGzxBg1H6E8MhLRm99rAkVuBY03Zwx72kWdrRy4BKlwmSNPQ2812KwNahXEqyw8dq4pYWAQtT5/MrVbarHeThmvH28TFh3CG3vxi1s78/gcl0DP2A8bdSyNGCMzJvGvUvWkXH/z0BXr813M02meVFJkIQc9qThdNy9zj6lhbBhEe+aWNpuHcLq/OGsHi4jBwsNxjI4U7yYGcrK7DzALww95dKVPkFaeOy06GKojM6PRtoJ97biJ6fkVEzOqWbJQWPp7dV00lx45nlVay0qkgxoEpIaTJxjXymHNjyV7ZBP/SMZQLshQIB2wj81hprbowHNz4/HBW9fzl7q5PDh8y+1E1G3yLKoLs94EBu98S1LK3wIVLo3eOXtP123J1xz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199015)(86362001)(36756003)(7416002)(5660300002)(2616005)(186003)(38100700002)(83380400001)(316002)(6512007)(8676002)(26005)(53546011)(6506007)(6486002)(66556008)(66946007)(478600001)(54906003)(66476007)(8936002)(2906002)(41300700001)(4326008)(6916009)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5TGQN/LDJkZsRNlCoq+kMfDd/1YQj3RnN2G0DJFrFIckFWF7WigxT2ElOfSR?=
 =?us-ascii?Q?clo954IS6gRalFn9FmRaKoFho/ZuN3NeGU7e+SQ61CWNSGsxBOlF3iNcE86c?=
 =?us-ascii?Q?LvEiBCX87qSAlgeeBi6u+S5pcxoxVAoKdYmFF9NA1pTFuXiEG9rR06W0eNMY?=
 =?us-ascii?Q?ip6LAgeTBrwCRcs7rmE1vmAHOsFkI/Q2DKeCKy8UxUlPRTr2F+oFiuLKIV1y?=
 =?us-ascii?Q?6MIvxLIctDs9u/uZdP4jS6GlGkQR5C1CasRLVnl4Tngqdk/mLIhQxV30YIN7?=
 =?us-ascii?Q?y6MVPPyU3L5mze0ZWiTpWa1N4yot0q13Vmx6ih8gHYtejBsXo36YUC/xXPUu?=
 =?us-ascii?Q?/R/1vAfTbc/tmhdNxvwfTpG9Oo5SVJmxPrLEtXMdBjbzujp3WsKQ/asf/Uk3?=
 =?us-ascii?Q?42o9aUbEH3qZyc6GBXXxuLHQKtBfcVGGPKwwv4gvIFztGsvpo8j+sSBUewox?=
 =?us-ascii?Q?q+7GI9vS/GbqLDaRJpLk5ncIIo0DV1dUfZ1H7RbX/5o7gPdmkjXKh88rx7+e?=
 =?us-ascii?Q?jRURrTJJmN2lVHrVXrFBI2AdxJldAjDd8KZWpZYWG1LX090CGCpw3Bu5ta7s?=
 =?us-ascii?Q?zBryH5NhiZubz+fzqlNlIv9Zei25PfZPPZkwknqzZobPIeUu5CfLfLxZXscY?=
 =?us-ascii?Q?oAxrU+1FeiYYhqigR6Fcg79VZamP8AM0PKIbRA2CZpxiRJDnPxHnQbOO5nZJ?=
 =?us-ascii?Q?9tZXP2P6KOnFT6GL1V1Um4vtt+IEbyRRb/Q3WdOayOQ0KYJ4M44hSxPo6zM5?=
 =?us-ascii?Q?+0nHpLfHuyFFYqnxRTZ9wjlKCM363Aa0QTgQ/A3j0U3Oq//K/wXz6BxSXfid?=
 =?us-ascii?Q?Pon/lancLufkwV1nsyPbU0WExnsTpz70FuBaR7KMgfweNc5I7ffHqzGzOs4y?=
 =?us-ascii?Q?cVcKVITdmWbxyBQ7USY33vgrMWx9dV28anMJsyQtnQAKHeoaWqgDqeB/y8b8?=
 =?us-ascii?Q?iuBe/UcYG1nB5ZP69iPMNgdvmX6dPIq2RTU06A/QvbX/GwWYAvOjBNZnJQgs?=
 =?us-ascii?Q?1v8UMzYSOzeUNndOY/D/6t+zt0zGE/DkD1wERsVUcd73yM38ZE7wif5CfheR?=
 =?us-ascii?Q?Y0tjb9EcXnrDTp/QlCw2uj6W8fS6tzIzzP1/yMhKlgkGXDvC8Kfq41WdJMts?=
 =?us-ascii?Q?ozRKg/e0cLntw3tFVbZC/aXnz1yESQAi8XEptxJL0zcls1tOULZOHC8OKp6p?=
 =?us-ascii?Q?UohkJUdUsEzTn/aPSwqEftd9n2QTAegn9syKGp0kwUerTo2lL+tKVLDYp2+f?=
 =?us-ascii?Q?HpQ89Ub1VXfiyvVk2P3kGK2gxJaDsmKdpu4G2UmdXDBSRA6M9Adc28CHAhLo?=
 =?us-ascii?Q?3R8ZzaMMmo1TZurDfAKnlIRiVuV93TVafvCx5SvFPya2n5s7/SA23wM4bGRd?=
 =?us-ascii?Q?jFNRe+Nw0jRhylv8XPrNZCe/XFEwxQlZ3U98QKpTpSKOWUWowXwEaoGYt/hO?=
 =?us-ascii?Q?m7IpAkEkcf1jRTCjvNbiBcka7Fk+95aCRV7kyXMfj6US4vwC0W9LcRlgjuaU?=
 =?us-ascii?Q?rDuane1h4OUIc9cbfAIbl1doWDHh09fBN8lhlSrF0l4+L93xfyjbLa1hauNy?=
 =?us-ascii?Q?9libOYTN8vQd20eTzRo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2d4e4a-b8ac-40b8-7b63-08daac4de13b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 12:32:51.9764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cM1NFYrihTJB48ASWMh+RnZiJh6gbwH35GaZjBdm7pUhYSXkyFDqCvn3yf7tR07L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 04:30:58PM -0400, Steven Sistare wrote:
> On 10/11/2022 8:30 AM, Jason Gunthorpe wrote:
> > On Mon, Oct 10, 2022 at 04:54:50PM -0400, Steven Sistare wrote:
> >>> Do we have a solution to this?
> >>>
> >>> If not I would like to make a patch removing VFIO_DMA_UNMAP_FLAG_VADDR
> >>>
> >>> Aside from the approach to use the FD, another idea is to just use
> >>> fork.
> >>>
> >>> qemu would do something like
> >>>
> >>>  .. stop all container ioctl activity ..
> >>>  fork()
> >>>     ioctl(CHANGE_MM) // switch all maps to this mm
> >>>     .. signal parent.. 
> >>>     .. wait parent..
> >>>     exit(0)
> >>>  .. wait child ..
> >>>  exec()
> >>>  ioctl(CHANGE_MM) // switch all maps to this mm
> >>>  ..signal child..
> >>>  waitpid(childpid)
> >>>
> >>> This way the kernel is never left without a page provider for the
> >>> maps, the dummy mm_struct belonging to the fork will serve that role
> >>> for the gap.
> >>>
> >>> And the above is only required if we have mdevs, so we could imagine
> >>> userspace optimizing it away for, eg vfio-pci only cases.
> >>>
> >>> It is not as efficient as using a FD backing, but this is super easy
> >>> to implement in the kernel.
> >>
> >> I propose to avoid deadlock for mediated devices as follows.  Currently, an
> >> mdev calling vfio_pin_pages blocks in vfio_wait while VFIO_DMA_UNMAP_FLAG_VADDR
> >> is asserted.
> >>
> >>   * In vfio_wait, I will maintain a list of waiters, each list element
> >>     consisting of (task, mdev, close_flag=false).
> >>
> >>   * When the vfio device descriptor is closed, vfio_device_fops_release
> >>     will notify the vfio_iommu driver, which will find the mdev on the waiters
> >>     list, set elem->close_flag=true, and call wake_up_process for the task.
> > 
> > This alone is not sufficient, the mdev driver can continue to
> > establish new mappings until it's close_device function
> > returns. Killing only existing mappings is racy.
> > 
> > I think you are focusing on the one issue I pointed at, as I said, I'm
> > sure there are more ways than just close to abuse this functionality
> > to deadlock the kernel.
> > 
> > I continue to prefer we remove it completely and do something more
> > robust. I suggested two options.
> 
> It's not racy.  New pin requests also land in vfio_wait if any vaddr's have
> been invalidated in any vfio_dma in the iommu.  See
>   vfio_iommu_type1_pin_pages()
>     if (iommu->vaddr_invalid_count)
>       vfio_find_dma_valid()
>         vfio_wait()

I mean you can't do a one shot wakeup of only existing waiters, and
you can't corrupt the container to wake up waiters for other devices,
so I don't see how this can be made to work safely...

It also doesn't solve any flow that doesn't trigger file close, like a
process thread being stuck on the wait in the kernel. eg because a
trapped mmio triggered an access or something.

So it doesn't seem like a workable direction to me.

> However, I will investigate saving a reference to the file object in
> the vfio_dma (for mappings backed by a file) and using that to
> translate IOVA's.

It is certainly the best flow, but it may be difficult. Eg the memfd
work for KVM to do something similar is quite involved.

> I think that will be easier to use than fork/CHANGE_MM/exec, and may
> even be easier to use than VFIO_DMA_UNMAP_FLAG_VADDR.  To be
> continued.

Yes, certainly easier to use, I suggested CHANGE_MM because the kernel
implementation is very easy, I could send you something to test w/
iommufd in a few hours effort probably.

Anyhow, I think this conversation has convinced me there is no way to
fix VFIO_DMA_UNMAP_FLAG_VADDR. I'll send a patch reverting it due to
it being a security bug, basically.

Jason
