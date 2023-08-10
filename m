Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8A67780D5
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 20:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbjHJSz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 14:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjHJSz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 14:55:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211BB26BC
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 11:55:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIIPvGzyWYN24NFhgMWggsM9JaRiDbJA7fupdBk8q6k5vWChIjEj+P7Drrot+wiFYvphf8O82jyXL8dWa8Pnmu5nwOkA3FAP4Ta+7HBv0k25rvAzWPnKGfbvO+HR086bifxcYsifH36pVvhFkBzTR8dWfGAhvsgFntM0GPdqvB0Ik5DhQneOyHZZhQVQWOOI7k3Kkawn2rzduGe3Ivgb01Z8JW1r3/MXa+vpbK7ix6pI5bw9YQSdwrKMtlHxUfq3FBXifnxc6iDe6y52a/thwJZfgXUGSNFZGmqGqBiJzwxttiqzi9n+PzmEEqHBCjszuX7/7hLwWZe1A9sfJsCf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4dwVfH/l2HsACtR9tXV1+ky5EViZofhGo9Mi6jESr0=;
 b=UqPdCBYSCatBKo4UjGjY9La5sZKMRNj47dBcOExyzEIRha4xmROzmQ5ph99NF0IjsnGqis/lPItssDf25zD2sOtsL7RD46bQin0G7JOylr4upwU7FDedHLy1fuDt2bBfs0NrX/J2KsA7X0+Gz2IlPoQ0DEmHKNlUI7/iqfDUAVLgqt3mMV6IbBYQJzuo9KDrzjjMIXLJufbyR/Rl/XzWge2P+963PTiAWBFbc7EDQSOKUQfux3LvFJesWDswzOrl0L8lMYFkgrmjJKF3OGo8Me66zeDwLUH4GZHpQFPQFGtAuje7S2yTyXY5HEbiHDhuYCRxfHih18/lEItQ+eWPEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4dwVfH/l2HsACtR9tXV1+ky5EViZofhGo9Mi6jESr0=;
 b=a4SEvWOH7CUv06dl9XCF1Z+awx0zcJ/Me/UKuc40x4iUzyBJgi3hEDhDDYNAAWvtUP8yOIgWsUwwusL5r6g66X9X66cBKkQvglARO35cVb92+KpsiFXCuceIUNigc276t7Ms+HuAQCRPIWN3d6CdcG5l3n0piqvHFUYYZonz5sASszek5JOG1ggpKzMhc66usKSXrEL3bSBIT3zYSPSEi99EMf18ZVF+P7c7c9NtNcfHroCi6s1EduK8chF0xQrqtbAFlJcoSPxvtIm86sp6tB4eb1KjTA1WbRWMqVMX0DdHuhSdFDNTPhQa4B1DN8fASV4uqfzC7TrI3u2EkqWuCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL0PR12MB4897.namprd12.prod.outlook.com (2603:10b6:208:17e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 18:55:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 18:55:24 +0000
Date:   Thu, 10 Aug 2023 15:55:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Message-ID: <ZNUymqfxICNh0pUO@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
 <ZGdipWrnZNI/C7mF@nvidia.com>
 <29dc2b4c-691f-fe34-f198-f1fde229fdb0@oracle.com>
 <ZGd5uvINBChBll31@nvidia.com>
 <69511eee-69b5-2a83-b7b9-f4a2664e15e8@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69511eee-69b5-2a83-b7b9-f4a2664e15e8@oracle.com>
X-ClientProxiedBy: YT4PR01CA0132.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL0PR12MB4897:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c7f050-9be0-4589-d316-08db99d35ad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whQb29O+/MM2Dutv1X29LJHo31Q/EF3BbD9qJ78LQozRqkhK00J/2aLrH5lXg8ovuOSZHgzvRtFG4aR/Z79/4eKE6AUQjB4tTgdjnyZzP8KT5LC7Jf/xyc6chblbxSqlsQfgdMH9l2Baut9C3hFoYqtMMGzSM5sdPK10/z3FciHxXdx93cMowo2WJmd2zrfRzIhhMtpwfZWj4c/icxfHq9Dk9g3Bd+FSUt/xgZuL2fVc2YxclbUFJKGk5MBx3VIpH5I6oq5bOOz807wZmlgTaO8XP483Fze25hWpg7GiwhFDNLJn3YuITdzmQuoF4DHPhexCbrBLmplxH8FVGFd9a7wrEamxF/Qcb01AY2f2hMunnhWirKY0LpmAvK+2o/4+69EBADee4NyLFOj3srkzICPR776EJUZTg2lZerqk5fFJx+iGb9s9IGGeIGbI87S+7PzaC9g7j48NY8lRn3XVTgpfXVtgcQ6fqNZo2Vhu9RWe53MHQhbMgUcF+svNXmZApa3kwWvSPdE8VhK49fE7T4LNZ/1NYgq/JC3ml2dgnuEhuV/IvHAnyUUj9e1CQ/D7gkMyB6yCKFf1aAkZob2NdyvuTMNIDie1tBFyDu2UPjHiNSfT9dptXjFXENKzRc7aAvAg/MAueI6NohNukYQFoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(396003)(366004)(186006)(1800799006)(451199021)(4326008)(6916009)(316002)(478600001)(54906003)(7416002)(5660300002)(41300700001)(6506007)(26005)(86362001)(66946007)(36756003)(6512007)(66556008)(66476007)(8936002)(6486002)(8676002)(38100700002)(2616005)(2906002)(53546011)(83380400001)(21314003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1H/s4rvgjjRLI/RTnHQBdhwlo2dZeqZt8DtCCnDXGHzyM6FSCJVk5ZGJiyxM?=
 =?us-ascii?Q?UPCFzqRhT8LLfvuIulwwpMjX3BN57zLQz5VMYYQV4nf+6nzJ5z2HZyytSGHt?=
 =?us-ascii?Q?SaG2LqU0lxcFoykmnMBuvz83zu7nK5s0zGozM5c7fUUfN17ljYoLjJuh/Y4v?=
 =?us-ascii?Q?LjlW9SGo7bkes9YEUKh5nwPwTMv1AkM0TYlFKowXwPvPEWklJJqQdlnk2BzI?=
 =?us-ascii?Q?VL0GyTxdufA+2bBMk8pQiMy2Agsy7Gf1TqiTAh4BBhRHEDu7FUyRLDIV535u?=
 =?us-ascii?Q?SsqTp3ozP/nhhobiOl5o/kjmJ7+4LZllykjU5pVFIaEkd+VXjiXBytYywoyn?=
 =?us-ascii?Q?UDqf4piKphTapz3a4oAzpsDA6OuN8CwDZ1DiFrZN9Rf8TrzyqNZizdgC13D+?=
 =?us-ascii?Q?TJBYe/B5WpGiJVBEOsEwl+7tf1uzi/e+pBhKbZFjejVhXOUCGad+rLfDy6Ft?=
 =?us-ascii?Q?yqyHyY7biPp4JdzibxObFAYLIFfUWRLAsspKrL2fumFNiEuDxMzy2XWoFg7a?=
 =?us-ascii?Q?taD4kEkSrFPRbLZtNvhGpe10tDcMHPbCCIgL4L1GBa5ZAdAjAPhdpV8XoGJZ?=
 =?us-ascii?Q?BgY96YPBTuXqyvwwSNcUzHeVcM9CY645ELESAOaq+QXR4po9HwGpzlfZ7VGT?=
 =?us-ascii?Q?MobbG/1hZuJcX0RDgfJeMVEyvwG3jTazxM7PW5P3D7X6oC/WRRTmBMX7A5/S?=
 =?us-ascii?Q?BMqkAo1F1NRKz5SE5i6VSG5h9alzZ0f+sro9AfjV9UNNwFJCF2C8Ju6g07Si?=
 =?us-ascii?Q?HiiDZkKjuBORrRt7r/gulI0ne3kTxklniUkHE62Pd97rsy2tSbNA+9rTxlit?=
 =?us-ascii?Q?pvnx1s0Pfab4c/aNOIgyf4vfLrHyewtddlHVvtw+zWMMvBMSANd29KhqOt35?=
 =?us-ascii?Q?sk4X+2eldGS0XBAP3OhlNQ0egjifmSuEhsRJhF3bBLdZLXa+q+ONoo6PeOUg?=
 =?us-ascii?Q?o/e/JNRX2xxHzfOC2rhypzZk/zc5XAkXHVqpK39wnRTgEb/qp98l0wDCFokN?=
 =?us-ascii?Q?oZ+9ZBz8gR7c69KcPbazKZnbwMCW1LwoJo416M000BKWufHkTR6FPZAUVZP6?=
 =?us-ascii?Q?S2ect0l5ZvSCNTimT/LxJjH6JixKL/7kzY87aKKSPZ827xkanoQsjm+mrJWI?=
 =?us-ascii?Q?20aUHkC8zwccq+lokqGmfZISCjNwPWF28lkyZfcfrt2NNpXDAe3ZVS+r/1le?=
 =?us-ascii?Q?bxCeQKuiGKsV0xiNcCZVs+2F99xP1wRjqd92qB9grgIciAhY/pA9DOrLe2iF?=
 =?us-ascii?Q?LqL3pEzYJO+PX/MCoto0LEnHPByJO+zB+5/8B8Y0jeIO9zD/sDZ2qwL3+PXM?=
 =?us-ascii?Q?gBlmbGgbiv4Slw9Zq0AYTmdPiTcpnVpqHjvy3JfTTkOd2l2U0KpBRZd9SIfC?=
 =?us-ascii?Q?W7tEeADHq67k8MtO3Hm8GGKFRRYLQjFbUn8yf4FMYfVmICZiDf/5aNB2b1un?=
 =?us-ascii?Q?xvjCHKbkVLi3LlD4W01QXMTqd+yNvW7tyyjUjJTc3juUTKDKPeKC8vfOQC5A?=
 =?us-ascii?Q?Ct/LAzeGDSik8arwHk2csaNQ0QgTZJEt9PmSRuT92Kx5osieUH3VZWlfGVW/?=
 =?us-ascii?Q?FDhWutl7+i7+Cpk+selLibMRFK2UbuKdIdcNLFWN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c7f050-9be0-4589-d316-08db99d35ad3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 18:55:24.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcHEkOT2h/yUhwNcxz8nIihU84ADeb0kmT4YhbS0tZBFxPGW+vaS0oqAXjlgklZM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4897
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 07:23:11PM +0100, Joao Martins wrote:
> On 19/05/2023 14:29, Jason Gunthorpe wrote:
> > On Fri, May 19, 2023 at 12:56:19PM +0100, Joao Martins wrote:
> >> On 19/05/2023 12:51, Jason Gunthorpe wrote:
> >>> On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:
> >>>> In practice it is done as soon after the domain is created but I understand what
> >>>> you mean that both should be together; I have this implemented like that as my
> >>>> first take as a domain_alloc passed flags, but I was a little undecided because
> >>>> we are adding another domain_alloc() op for the user-managed pagetable and after
> >>>> having another one we would end up with 3 ways of creating iommu domain -- but
> >>>> maybe that's not an issue
> >>>
> >>> It should ride on the same user domain alloc op as some generic flags,
> >>
> >> OK, I suppose that makes sense specially with this being tied in HWPT_ALLOC
> >> where all this new user domain alloc does.
> > 
> > Yes, it should be easy.
> > 
> > Then do what Robin said and make the domain ops NULL if the user
> > didn't ask for dirty tracking and then attach can fail if there are
> > domain incompatibility's.
> > 
> > Since alloc_user (or whatever it settles into) will have the struct
> > device * argument this should be easy enough with out getting mixed
> > with the struct bus cleanup.
> 
> Taking a step back, the iommu domain ops are a shared global pointer in all
> iommu domains AFAIU at least in all three iommu implementations I was targetting
> with this -- init-ed from iommu_ops::domain_default_ops. Not something we can
> "just" clear part of it as that's the same global pointer shared with every
> other domain. We would have to duplicate for every vendor two domain ops: one
> with dirty and another without dirty tracking; though the general sentiment
> behind clearing makes sense

Yes, the "domain_default_ops" is basically a transitional hack to
help migrate to narrowly defined per-usage domain ops.

eg things like blocking and identity should not have mapping ops.

Things that don't support dirty tracking should not have dirty
tracking ops in the first place.

So the simplest version of this is that by default all domain
allocations do not support dirty tracking. This ensures maximum
cross-instance/device domain re-use.

If userspace would like to use dirty tracking it signals it to
iommufd, probably using the user domain alloc path.

The driver, if it supports it, returns a dirty capable domain with
matching dirty enabled ops.

A dirty capable domain can only be attached to a device/instance that
is compatible and continues to provide dirty tracking.

This allows HW that has special restrictions to be properly supported.
eg maybe HW can only support dirty on a specific page table
format. It can select that format during alloc.

> This is a bit simpler and as a bonus it avoids getting dependent on the
> domain_alloc_user() nesting infra and no core iommu domain changes;

We have to start tackling some of this and not just bodging on top of
bodges :\

I think the domain_alloc_user patches are in good enough shape you can
rely on them.

Return the IOMMU_CAP_DIRTY as generic data in the new GET_INFO
Accept some generic flag in the alloc_hwpt requesting dirty
Pass generic flags down to the driver.
Reject set flags and drivers that don't implement alloc_domain_user.

Driver returns a domain with the right ops 'XXX_domain_ops_dirty_paging'.
Driver refuses to attach the dirty enabled domain to places that do
dirty tracking.

Jason
