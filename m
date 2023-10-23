Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455137D3E9C
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjJWSIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjJWSI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:08:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8729D79
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:08:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwsBOryFwG8wT4Q6ENuiizIV2G5/Dr4UYNgKANMHRxNLqqnj9Ihgq4LYagIBFML9UrlCWm9KGJZNIatRBwwPU5qGhySdbjq2O3c5+l1mrkz2Fs6dH2oVQJn6aGi6/rk0a3xmlH0sAqEgOKszbUtDDezvnJSzoZXIVyw+lz1v6e6j3olS3V3CczsKj/DyGboew2VlHohPBdDEeqAqWYXAhapnoXXQ1Mo8JEkPGRoWvJXa4K8ZwdNORYAW9OfOyGK4tveWVB3kVJdmwOdo82aGyF8O1dWUR5IasMpXo/06x2PnMwp+uufDAAZ4oyCfQ73v5MgVsA0oLYsczwm2QOpR6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fHW6JnBr2ZBLupMcczf9Tler4kK0xJ/mzv0BiqDyIc=;
 b=PbTtfQd9ZBfYniEUMGgO8gxSo8yIqbQRyZcEabvItPjDNQSJs/03aKRrCw6/OpUSs4dK8+lPwbNRwd2iUQdy/s4y5JtqECLZmJKmL0EXAZyq+NphD42D9FMpLA491UUaDXhM0vwBqVOMNPc09MEG9oB2/wSXnNJdd1qaIDIrfgjBkrg9P/HErENOyAyJ/rBVVfZV5URosbjjZDOOo/popzqXsROsYVQMgssPV8PABRkR9aDScNYLlt733DPNWpxT1b7JtEP9fpVJD6NBlq38UFbnjOKFFuVA7qc1yHmjByCd6ccsiwIaL1uKU4gGcykoHCyk4plbP6OKKcZ0ryAbTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fHW6JnBr2ZBLupMcczf9Tler4kK0xJ/mzv0BiqDyIc=;
 b=ViLfDsUZHBz3/j4Ck4T3DqdM8C2Rc6zrN4WT4cnCFylUPC3QBt+in4QHdcjSeX8cGSPj+o7n/YyKHcFCtQvIQ21KIR8PVvnPFaigHoTLwH/h52XYvPzuViACH16SmKb7R6dQum5A1Z2OA+XDmTItzHvn4TR8FCZOyTrTPm1HOy6H30+BeXIzYPRxvh1Y9aHpyjEABK7q69Z5w3ZrakhOf6PAi8hsj6j8DI74Kp1JodVFYvr0s6LDEtTepOrQLMAnZaRml4P/m8XDwzFKaRDXASKfSL90qnz0hiHaOzs6c7GeNz4OMI46kaz8/XtbsMTGZwkxJmjXdxY0i+zn1PLULg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 18:08:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 18:08:22 +0000
Date:   Mon, 23 Oct 2023 15:08:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Message-ID: <20231023180821.GF3952@nvidia.com>
References: <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
 <20231023121013.GQ3952@nvidia.com>
 <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
 <7067efd0-e872-4ff6-b53b-d41bbbe1ea1e@oracle.com>
 <20231023161627.GA3952@nvidia.com>
 <f511e068-802b-4be2-8cbd-ae67f27078e7@oracle.com>
 <20231023163411.GC3952@nvidia.com>
 <5069116b-11c4-40ea-bfa2-91313ee4fbe2@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069116b-11c4-40ea-bfa2-91313ee4fbe2@oracle.com>
X-ClientProxiedBy: SA1PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5205:EE_
X-MS-Office365-Filtering-Correlation-Id: e9cc13dc-09a1-4b35-07c6-08dbd3f30b43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XyrKNNTz/amPtZ2JfBisbTLrM12VOy0Q6//tLK3oz1zfrvUsPX8O/iKcgClenxyDXKxIruRPQmbx/TI5ycH3zUuxtCNq0d8hlAzxyCGG2zpGWmU2izCP5RedccZtJMaQvvHKrk1cXkV+q7z2EPzdYXx+zLnw0PDPeGlLiCPgoccIc/si7IyD3pdkkZmp44nrq2ckSkxr5a5IgihwdtKspYq44ShYMjbqkqAWsOQHl7eHSMnooRrLaUhSSPeWr5uR4BcfQ75f9rTewCEMekZflnTqbepsCeECcwFHtlkM+7ot28uaYnAS9Fwr9UWVwV/mu55cD1BQ7llAYuOyz2AXh2InF+INnQsQTvAZhW2vgsaHZD+hyRfG00FaQ1b8fFcYODAIOmN0hmr1p9OiyGprWgMJ5DrRPqBsX/xEJi+eycoLm2MO48R2GA27Bw32ush25CzAFEFgukrv/6r1LZypCBoKCPjJiX9dNTG3FgBVzyxTh2XEnCwozky3NxsEQXjLTnwby4IREnmjBCA5A+gBdYnyWv/ARs7VEI+THXsJO7eRqGW6gL0VjyaXvA1hry5jH+dxoBHSGehGYNTe2TLIqXbbt3h6Zn0UMTjCUqxkiOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(39860400002)(366004)(376002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(26005)(2616005)(1076003)(38100700002)(6512007)(478600001)(6486002)(53546011)(6506007)(83380400001)(33656002)(36756003)(2906002)(66556008)(86362001)(66476007)(316002)(66946007)(6916009)(54906003)(41300700001)(5660300002)(7416002)(8676002)(8936002)(4326008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qvJxXQIhDnVMxAXxViG3t1Mb0D5aWScWnMKUVKOB27s4uS/DHkqe3JK63r4+?=
 =?us-ascii?Q?oXyX8u50Uhz3kDHrp3lDf7gNUagVz2CXDOlP3687ungxj5+HjLT08ST488fy?=
 =?us-ascii?Q?2/LcWdUgGrOE1bbSvjhpqruXeAdY2oAxyunPGEojdoFQlwQJpODfEhp+pcoi?=
 =?us-ascii?Q?dCnuA3/w7+crupXOhuKQlIoJkMfn09LSz8t2MfmRegd+IJrJoNm2P4cIpTuh?=
 =?us-ascii?Q?uM8SPCjyuKYfnd77KlF3N3QPkFzAcYyPWl5kUdAmMegzbgwX5E+y+ilM2Ixg?=
 =?us-ascii?Q?hOryLWTHdUmEDx8FVxBfVvV94QFSxkfY8WHWFlADRD5lBX/UGG3cul5oJIZ3?=
 =?us-ascii?Q?mViJq5Qgji/Qak7X+pSgD4LMV/+RgxkYn/MaH4gfZJWwVs2GRGAmaO40pLSp?=
 =?us-ascii?Q?pwUjejPksvjHOvKMGm1Xh14A7NRnkdfqTkDarMVSmEW9lJXQ/FAKrcD5yF3u?=
 =?us-ascii?Q?XDJSFDVE17QWmfiYtKspw7vXgI0A/g7ImPZv4MWrg+zFjFOwTFQojon8/3DW?=
 =?us-ascii?Q?hpIfYPc1cPtJ5vT10bDL0VugCQAV9Bi5Inzie/MEPk2GqNLibVCniBtvshUV?=
 =?us-ascii?Q?xaFq3daT38yrMJD3DFM6j00rqLvzqpFjMeZGGws8RnU566xkSYadGer6Z9pa?=
 =?us-ascii?Q?OkqTkVZIjldwA0cqQvxdgCq0TEpYSYz5vkrZKj+zIx+7BhdllZzOQCJ3dx0h?=
 =?us-ascii?Q?C6nLOBtlYPo59L7tl8IuypZeHsgK9HhdWED5SC7ff6TFrbuJ2P9VNW3sgPZe?=
 =?us-ascii?Q?fsEy4XnQ77c65dH2ITMGqVfNRucTGLwR/0HRhGi82H2nMiWuHJJHUc2FijBz?=
 =?us-ascii?Q?9PCKHjIA5YpjBMW+v7IdVphBcL2iL9xqQu7da0XRGP2lW+gm+mzIEK5N2udM?=
 =?us-ascii?Q?/lS+mk9wBX00kntfNoBJHenEIGaHl7FbYRQYfP2Jcru6s5IpLBboidszdgSE?=
 =?us-ascii?Q?t4E0vjmMzszztKabeKjlYizaMaIuF6zjzWzHkYw0iI3pQCm4je4JjrkLwbU8?=
 =?us-ascii?Q?OCnsr78bOGzj6bTjFRqPUiDCAkU5vG+Fdq6bUKu5BpuSCIh1pWAhCZubJs4l?=
 =?us-ascii?Q?7tUloT3RmSnsug46FgeosCyMcS95RBP9pEtXn0snw87+109bvKpkGGpt/6Pj?=
 =?us-ascii?Q?thIdrHiiPbHCXWYGNvVLW04PEFgC5yrRs0kXbue2qGCvAljBGWskMQkTQhNa?=
 =?us-ascii?Q?KaKZZwJuwhzJieb5rGQrFAEaoAC7hOBX6HJsXTBaqDKFzK14+Pfp8tVNQylx?=
 =?us-ascii?Q?mUcEuHb+lwudR1dLR0pFKDpJEDr3klzMwvhHs2FkLmoPONWBMxS8LWHJyizT?=
 =?us-ascii?Q?nk1MFkZVSDC/iIi0VeO+hUCHt5CEu4tlP8mvvP5azvq/gkiJdODtlVTbqovK?=
 =?us-ascii?Q?hSvbPt4IEPoSzS0Ah1nQEGmc6xpi1OkgeljbDqQ4HuoNTcSeSkWstpFKu6Ya?=
 =?us-ascii?Q?ipb3/Jg0jeUIV2mfM7w7JOZpDkyBVqXvKBWaHFWFPJsrw4nnl0DFqcJRQeS2?=
 =?us-ascii?Q?Aex31jIVSIp3cvTE38EDd1OVug92pif7zmrAxQo0n3OUH4fIy2MPLJdUCqF1?=
 =?us-ascii?Q?rIcGaP+rWqMtfghU16vVaNRlClGIsmUVvoUGBSjt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9cc13dc-09a1-4b35-07c6-08dbd3f30b43
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:08:22.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5kgADGo30souBOed5EnbmRb4fCYlKFzYB6PRK7MBl9TQZ+GTLhdnUi8tO7RITcD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 06:55:56PM +0100, Joao Martins wrote:
> On 23/10/2023 17:34, Jason Gunthorpe wrote:
> > On Mon, Oct 23, 2023 at 05:31:22PM +0100, Joao Martins wrote:
> >>> Write it like this:
> >>>
> >>> int iommufd_check_iova_range(struct iommufd_ioas *ioas,
> >>> 			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
> >>> {
> >>> 	size_t iommu_pgsize = ioas->iopt.iova_alignment;
> >>> 	u64 last_iova;
> >>>
> >>> 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
> >>> 		return -EOVERFLOW;
> >>>
> >>> 	if (bitmap->iova > ULONG_MAX || last_iova > ULONG_MAX)
> >>> 		return -EOVERFLOW;
> >>>
> >>> 	if ((bitmap->iova & (iommu_pgsize - 1)) ||
> >>> 	    ((last_iova + 1) & (iommu_pgsize - 1)))
> >>> 		return -EINVAL;
> >>> 	return 0;
> >>> }
> >>>
> >>> And if 0 should really be rejected then check iova == last_iova
> >>
> >> It should; Perhaps extending the above and replicate that second the ::page_size
> >> alignment check is important as it's what's used by the bitmap e.g.
> > 
> > That makes sense, much clearer what it is trying to do that way
> 
> In regards to clearity, I am still checking if bitmap::page_size being 0 or not,
> to avoid being so implicitly in the last check i.e. (bitmap->iova &
> (bitmap->page_size - 1)) being an and to 0xfffffffff.

I think you have to check explicitly, iova/last_iova could also be
zero..

Jason

