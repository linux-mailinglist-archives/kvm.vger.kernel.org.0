Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F8A7D1E29
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 18:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjJUQO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Oct 2023 12:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjJUQOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Oct 2023 12:14:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AB71A4
        for <kvm@vger.kernel.org>; Sat, 21 Oct 2023 09:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWKtHPEaKOaPRrjjFY+A/GJxSBhHHFqcXFLS9yhkwIiRXcH2E7gN8mjCovkA9gEgKrtineCP8sa/qMxu3F4yEbzReCA6fm4lyASrAc8WxoaSk6xB6+ALjl1b+xB5NPrcODus61jUykaT/wmJBDjhT8mC+RitoVb52N1x3bfz7b48xOYiQdbh3MxXPvZQ7PRQ6aujtU+F6PbF5TToJjvg/Pdr8qk87lzKV5nWNh5xJcKdjYfJ8cGzi40YfOfdcWRMBVPI+qf3w/nOccpfCok+r4YDhwYnA8AeiJQXmoVNU6wFtBTfTdYiFjicfqCqg0caj0ljb4H4X4svFWyVk2OofA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AifksHZbC6yoLStWy8lFOKn+/UAy7r3NYw7wAxHjFUI=;
 b=T/tBbkHEwzwoK/qc+QHL3xMWgboutfzoovVVSVBi6aBq5g8ka6sz4qcZYzXy8bRY1NcncF5r4/eMw4sHnh7kMZdVRSQgwlIU1neyIRjJ89U6Zg0EFrPER7oZ2/xiO79LTl9Fmfndv1Fa5lfzsle/zCGXJ90bdpli2AHF3QaWSjuur3UdT8BhTvCxTEz6dylkktkJb/8prBv5MP+pmWM7f6rYe88Iab/ArslpiVzgtLr7qieWQZxX33f1KpzV2E9R/FUZ2xO4oQaReVaqSFJVvfV4HWpVUa7Zqg1vmKkBlh7MEPbIWB6EuK86Yb1WDipWxl5QSpcvnS21IflnMkqyCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AifksHZbC6yoLStWy8lFOKn+/UAy7r3NYw7wAxHjFUI=;
 b=hWl28P77SnlUHhKG7gzhCydJl8pjnYcEaYjLHz+0nZbeiF8yLy+UJfo73NlgXQhaX0alRVHV2Iz/N3ngdE+iKB7lgN9Fnc8jtyFyttbYrILD4xDLq5s+dojJPCDftMH0ryBrtTsX1mpNsgewD95tVKwZ4Ql6cPVsEZcLE7OZDIc1yV81kRoR10vXzTmfC6bZngRkK3yu5cBqNtAy+r0u3Sj9lafRKHczs+49dfAYq/jLns1VgMoh8SzEqb5bv2U10gWnaeGBwDMFF8Fcns9Q5sLmfNzgUHbmImUv2zOSigWEftmSuNbMHdk09oJ1Kqouvvjl7PNL9ICqdvkFf9ccJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5386.namprd12.prod.outlook.com (2603:10b6:610:d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Sat, 21 Oct
 2023 16:14:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Sat, 21 Oct 2023
 16:14:45 +0000
Date:   Sat, 21 Oct 2023 13:14:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Message-ID: <20231021161443.GI3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
 <20231019235933.GB3952@nvidia.com>
 <a8c478f1-209e-46b0-9b91-7cd8afccd7ca@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8c478f1-209e-46b0-9b91-7cd8afccd7ca@oracle.com>
X-ClientProxiedBy: SA1P222CA0186.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5386:EE_
X-MS-Office365-Filtering-Correlation-Id: 819728a0-1e24-4aba-0c02-08dbd250d722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w+Uy3DlKMpjlVaoXZgxYvd7EpyqpZACpcgVyCGHvvTHGhVBufutRKb6I7Zta31SBkOzIUh07/pNCB+MDKVIsnjpmio7nbwmz7mLjRPAmJ/kMy/NfuiQ6Mgg09HFHmCu81jyi5jnoN/RlggPW/F69kqTzyyT4Cx1b2Q0HJO9BSIM8LkCY3zWIbyNukrI8VXRhrTDHg6N4w0x2ZycXgteH19o3h9LYzEitUuWfqgzh81ZayVoF2YeJPb4T16IeLSuSBSL+Bv6nc+TFkYCY0H4RBnZw80JDAf3clmGc4h7zLyI4MBziHtl41RKW4X9d7TWu2EjDDAWubbrDDUyOokIGK7rSzZp2frZrakmT++ANVjEU7HuV1vH4KIl8WXZizADCTPEp1c8QWj1/GKwIhJTGTdx2sjjKFEKkTorVwozZOIN+Ryj4Hb9Z/YGbR9gCIkCyRE7CbJ0kwULXrJIP6p/wn3auq5MPnPq05eDXtq2jmc1xWV+vB9sCiD37KdduX3Klp/qx6O9EajpioIMOmFNvW7CIHQn8FRNjZonbaoN7uwpSBsRrcScpc4D4KVdZQnPw/pcdggn6amHCQ7D1fy5BvE7LpNZC1fMQGKrzpCqfmt8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(396003)(366004)(376002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6506007)(53546011)(2906002)(7416002)(478600001)(6486002)(8676002)(4326008)(8936002)(41300700001)(66476007)(66946007)(66556008)(6916009)(316002)(54906003)(5660300002)(83380400001)(38100700002)(36756003)(33656002)(26005)(1076003)(2616005)(86362001)(6512007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kNimJvMz+qqlRWyRgvLiIVqlMQ/UAm6qPaliNNHJmi2SUubZTlhmHHMibDLP?=
 =?us-ascii?Q?6o07hgOU/OMAenMYXWf7BgDl9Y+fZxVdU/4UTbWq3hZg7mwBzg6Me/rbw5EC?=
 =?us-ascii?Q?E/04zNbdxkGYpa2CGfaNmxWi0xY2HzI8iXEMK4F2U8SwESqHIBDBlkuy+v2O?=
 =?us-ascii?Q?qVRSqjBQJsvcgVe0ANr9w2CpcjC5+cCnJDfbRGTA4rVj2hD6/5pKHHE4E/WM?=
 =?us-ascii?Q?+BbqGNjhRgbdzbSotCffBQUjQfBRXhbS23dN8Kk5UBMD+TxZcYCocno+7IXY?=
 =?us-ascii?Q?I71SqZD87tUuVAQFh+xv/4edLQjI87//rlRHZH6blnhMxqlKDJV9fvDh/HoO?=
 =?us-ascii?Q?tma9ydNcDso7VJhhd5LJYYIyq9C1Weemejw8Buhol3JPzaR8qQbcVFGE/UNJ?=
 =?us-ascii?Q?Ht0YmBE686O3QBVOu5NCVYQlGWxhyrLCOwMafCx0Mz4D5QS7ZpRQ8R+kQkwv?=
 =?us-ascii?Q?8VZmi0RQXAyQbAvgjEQewa4CmvJXioLUjjUC1poSycl+JoScvKJfGiQhl7FQ?=
 =?us-ascii?Q?hkGKEAdrIshS+afW6WgTEwEJgvmj/a3Zlnpwr4iI1jlFEIKq8o5/2kza6GVY?=
 =?us-ascii?Q?OcQUSp4fibssC8itWzDCl0B4NDCONbdRIokzXjPCuvO332cFPyZwYR2+SVfJ?=
 =?us-ascii?Q?7mxG08zgxvP8gJIn6CgNXVRTYR4sVldRLc9VBS5XPEjsYYztAkWBGn1+b0yy?=
 =?us-ascii?Q?4oJFSwXWx/TxSBXOcjHXtywWRyWI8hCW+cSt/4SxyU4tNiHKSCPgulR7Cu3i?=
 =?us-ascii?Q?jEQZX42OwCaavRRYnxn7tyHM173Lc3R2qq+MReiQ/UHyBxcutJYAZrGoeHcd?=
 =?us-ascii?Q?hKneEJE+AjZ6FQfBHF5rNXsPaFbdzyvExJIOZIdeeIwbObcniQDZRZmZSD2N?=
 =?us-ascii?Q?t8QnPK8DxQcNO3eAC7T2CSJFsuuCQ+69QR3INA5NkzO5RZr2zzLHcVHiZKiP?=
 =?us-ascii?Q?qkG25EvyONXCAc9CBDVM3dPw2QA51NyhE/dW7LI+izOqy2x02tm4d7BPIneV?=
 =?us-ascii?Q?9jLx2mAhdlympXXaTj1zJ9vhDz8ghgQ//nM8bI2/RcgbP2d/qnbA1M2fBtAb?=
 =?us-ascii?Q?/zg4mJKxoqvvv9MYbEy3fyf9rF6DttSQS86FQLKMxeB6ftWGDrRElnarl38z?=
 =?us-ascii?Q?8hdHWECd8IXxuouLkIYTTm0aTMLJumuX3Edeu1FMJzLS1ezJKTv5J0sFtGlq?=
 =?us-ascii?Q?RLZSyb1mPcVxL85niOhg1RRf7Ou5/G/bvDhdeoMWAZjhXlR3B6sgTyA7T+fi?=
 =?us-ascii?Q?P0ABFS1x3QmOAAOyocXciD2/av2JSmqaFBPyqg0Td7cOL36erW5+XqzFiOkM?=
 =?us-ascii?Q?54fGvUvUFNfUXVMUeg+EDJhm/bGC4gi/IPNJK/Orp7jQHxrOSDG8rlHejthC?=
 =?us-ascii?Q?KJvfIYLmIT1Ctoi+LFUsYNdZ24EY02iqju9wyS9zp9Yk79U4N0qoG9jmc+Sy?=
 =?us-ascii?Q?5KMy/HVc4HjMhROLI09YivX6XwomPXCAhD21ZAO4/xkbI+qGbBRo4ZeQz8IA?=
 =?us-ascii?Q?ZpCohTQRY5J7vTRhmbekeUHTMUeC+4LMLBtZLxozSpP8IYsGE74Xs9fcDWHr?=
 =?us-ascii?Q?zCKxMp+fy31OxI81WZA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819728a0-1e24-4aba-0c02-08dbd250d722
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2023 16:14:45.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VkHxoZ1jdhBAm/sk452YU8KZZM3wIdw+6RW8wasNVwpM+xE/TygrBCasgjxp0HnD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5386
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 03:43:57PM +0100, Joao Martins wrote:
> On 20/10/2023 00:59, Jason Gunthorpe wrote:
> > On Thu, Oct 19, 2023 at 12:58:29PM +0100, Joao Martins wrote:
> >> AMD has no such behaviour, though that driver per your earlier suggestion might
> >> need to wait until -rc1 for some of the refactorings get merged. Hopefully we
> >> don't need to wait for the last 3 series of AMD Driver refactoring (?) to be
> >> done as that looks to be more SVA related; Unless there's something more
> >> specific you are looking for prior to introducing AMD's domain_alloc_user().
> > 
> > I don't think we need to wait, it just needs to go on the cleaning list.
> >
> 
> I am not sure I followed. This suggests an post-merge cleanups, which goes in
> different direction of your original comment? But maybe I am just not parsing it
> right (sorry, just confused)

Yes post merge for the weirdo alloc flow

> >>> for themselves; so more and more I need to work on something like
> >>> iommufd_log_perf tool under tools/testing that is similar to the gup_perf to make all
> >>> performance work obvious and 'standardized'
> > 
> > We have a mlx5 vfio driver in rdma-core and I have been thinking it
> > would be a nice basis for building an iommufd tester/benchmarker as it
> > has a wide set of "easilly" triggered functionality.
>
> Oh woah, that's quite awesome; I'll take a closer look; I thought rdma-core
> support for mlx5-vfio was to do direct usage of the firmware interface, but it
> appears to be for regular RDMA apps as well. I do use some RDMA to exercise
> iommu dirty tracking; but it's more like a rudimentary test inside the guest,
> not something self-contained.

I can't remember anymore how much is supported, but supporting more is
not hard work. With a simple QP/CQ you can do all sorts of interesting
DMA.

Yishai would remember if QP/CQ got fully wired up

Jason
