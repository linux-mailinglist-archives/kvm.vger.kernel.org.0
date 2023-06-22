Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7304173A224
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjFVNqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 09:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjFVNqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 09:46:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287281721;
        Thu, 22 Jun 2023 06:46:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZfGhtR3rwqvwPoyJpIfP7tBcZN5hoAHSjO/Q5r676W1XFfdZacN7bcV9pwOhOj4r7/P/CHsRz3OIJgaHxNnf0RwPko+iiNf63sTEqrlNbNBENCnZni8x0wGoYD1rBW6olO29E1eUFnGbKYB+RLI+IFUME2+5qwyC7dae0OZ4u7CcgqXnH5f42X9iSuBzxEjGuZ/MU3CE+heRU1bKiYqbQ7buWaKDtv25kIqIj2UtXQwiAE7aFrR6Zy9eTQvwnWv3BtXSGpkOQ64NcYPFQcYhAr2QKcl/oCWbDcjNJJEntTcrAfvFrYEvscB5xKuOtqfYlg+4g1FJqF6LBG9Kanyhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yw5dB/WzbQq/mx6KegG3p7E0nCv7b0h3gCuxeTabGdU=;
 b=HcDv9GdIpbqmgrHPidDfoBIHdOlrA1mXSpTrZWzMxDQW2gYSBJ06y9rf24lYIoTwJqAfFPhEYXAJndcOuiC7Z+h3U3w0LVMi+5VkVjwylUHd3ZpC5jrDzbbc4l2TOtNKs3h5ged83vRWXJi3AaArIoepI2Aca5UVbEM3svKaZvIaKpjUd9zhvsFbrmLjD40V2Zt9nz9uQLJarzZ1TlGG/d1tOiBwcoDFHkAzCOSNLk8IILnLD9PGpbUP/FSYi7bAuAbAfwfYr7Xz98bIfo9WYolL461yXcA1B0mhZoctX2ViYQwIVZQZzF12KcrzuWdE+uTmfLSa6znF3ZuzL8sHvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yw5dB/WzbQq/mx6KegG3p7E0nCv7b0h3gCuxeTabGdU=;
 b=RE5SoEPkDJDsRHzzUGk2mUxRpujqZkS+/bacs6oS/HiUvWzn7vA8eZM5ukwUbLGJJDGqVtZlhAiYrTcF1PU30Ai8OsYM4QSUuJB2UO2nFjnBZvp5bZwHLLmsau7zJEBe23k1yAQ3HMMN1z/GPuZ+rHs650jprrrZiw+XA6FocshO0vI99ofkEuYeRrVAYBvRvGajiDOnWECGvctgiyitdWDhOy0siXkNZBEKErM+0WP035DvMoZniQQ7eVp0k0b495ByVZkc3vDt5+0NtQD9ahFSesze5TJVlCY76U+jMSZ7MLliR5o3psCBcepdwUEqQgfJ/GUJVxYC4TzeK0aNuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6450.namprd12.prod.outlook.com (2603:10b6:208:3b9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 13:46:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 13:46:28 +0000
Date:   Thu, 22 Jun 2023 10:46:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, joro@8bytes.org, robin.murphy@arm.com,
        yi.l.liu@intel.com, alex.williamson@redhat.com,
        nicolinc@nvidia.com, baolu.lu@linux.intel.com,
        eric.auger@redhat.com, pandoh@google.com, kumaranand@google.com,
        jon.grimm@amd.com, santosh.shukla@amd.com, vasant.hegde@amd.com,
        jay.chen@amd.com, joseph.chung@amd.com
Subject: Re: [RFC PATCH 00/21] iommu/amd: Introduce support for HW
 accelerated vIOMMU w/ nested page table
Message-ID: <ZJRQseaYkTJGHNsk@nvidia.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
X-ClientProxiedBy: YT4P288CA0013.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fc184bf-acb1-4e6e-43e2-08db732713f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ODDlvRaPUm0y7ZfslN/eRjjHgt8cmOHIutpwYt8FLYrCYuMsjEJqiE/ljg7NAsMOnGaSCP7FkpLBt2mvFnErf9p/77rz2ZGNQiV244Alks5DEkoMoxZL7Goo6pFu4t8MoQuKU2lgZ69DdU07ueBTXBj84bci5wH3MttKRfiy3S7wVpbij5VllRX2I7b4ki3B+gfTznJ/72ekh3SaKIStXVRU2/WSM9RIJ32lNMXR2g3EfrTtsKth5SWspiCllQS1dmfhegHdXZGvr56RRXPyfXTn+QUUYHtYdY5iJkvxUjxujUZAOpUlN/+M0zSy8kHVYkRH1k6I8fqsQMkncYq7r/vHL/YMKNPe1rNVQ6e7odrDzGjijUz3CCXvCaj9rPiVXvwWOhUA3NAcD2n3Sy0fBcTyh0cUcVsrPgts09H4pk7ELE2V0DFcZZjQCigA8B9M5enPn1ZR3u5V43ZFmx9isODWHbMX9EpRNkKe3ZuH9ouoz+9vKbpEcsLBb4CUML1N9dK8NByM3lebnHeK5H4Xrx9d0N6v77guKGVLn2uCc17VyHbPmTTlamZezOnP5hHf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(6486002)(478600001)(6666004)(6512007)(26005)(2906002)(66946007)(186003)(8676002)(66476007)(316002)(6916009)(4326008)(8936002)(5660300002)(66556008)(7416002)(41300700001)(38100700002)(6506007)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHPcMxsKZRnAi3LRfvmIi1lGBkgLijW98bSFZk/Bd40oBhshWVhcLBXW92CN?=
 =?us-ascii?Q?4sd1Vv2mep+rfhB7OSYGKLX7w4C8IJdIIV4077bKpU+mHMb+D1qBo81TAuxn?=
 =?us-ascii?Q?XuEfHe6jQYEQ2oriuLAwoW4tyOUz8B7fRSEssF3AW5Z53eWp2xi0PiFnCuSA?=
 =?us-ascii?Q?2s6S9w0ysJhOg5lCB8LBeUypcMo3oF1YkcM3+oWOwJn/TzYWId27pADvP/YH?=
 =?us-ascii?Q?LPpNDjd6+Z9VYir9XEcTTyBvrIgT5Ao3btXfzGpp6khHAWx9FX/RLfNuO+7t?=
 =?us-ascii?Q?NMKM1v2E6MhA0iE/7m6FxygCXii/7gfcZYGuhfwXANNdysUA60gbu4IC4Kic?=
 =?us-ascii?Q?lxZjM7z0XxiYRWYH2AyHcjrPCfIob/ja6s5Wpnm1g8U8i0OVm+bWiBTCV6i/?=
 =?us-ascii?Q?eTtF4tTnKQKJGqFNaUPfQPKE0lZBgKA/PcLZy7skh5fWwwXs9Kan1tloUjmZ?=
 =?us-ascii?Q?clKjsGw9r3jT7uKJf9rtlH8iFu3x+J4gPMl5rPpe/O1VnneNvYs5tv3A9KsC?=
 =?us-ascii?Q?00mwjpZjR+Jw0dbJPA5377D4XLFlp3gaxXJiO1Q8vMtBiMq58kqT8tg7UWzC?=
 =?us-ascii?Q?B0VzlFujbQj0nXzLAsc/LpxX9Y5ji88uJFdv2+v7Oy4f09FiI0uqddDO7gUe?=
 =?us-ascii?Q?y3Afpzn+Vi9MjZ6fx4LruVd+tHlbOj/h7VhfVUtXgRYp4rOSCROu/fd6305d?=
 =?us-ascii?Q?doSnwcpA1XCQqAe/DSwdA3cRPzFxOdzKXFTvqOAgBV8J898JruuU2UhRhYOl?=
 =?us-ascii?Q?ecK6kBZH8JKRY4WvpHOWrEBBs/uzZJWp/N9J/kJq1Jesq//wdPOz5SdN8cvD?=
 =?us-ascii?Q?Fz5ZElXSsAGMQXDTjux1MqjqHDRrQjF86W21heHse6yz9WkojckJV9xFg9QN?=
 =?us-ascii?Q?S6b97JdxK11C1Dm4tq4BrwsXgH8wfl0YEvY6tF9kiJ4tvsDaAkpsJQgRgpDG?=
 =?us-ascii?Q?7mw7eM1lBL5rgAhPGEg4OZXXlG420RnMoczyRqHp6iFkos3U4qonUq4kLBbX?=
 =?us-ascii?Q?a1LB3FMM1hp3DPTtqPA5szu637s1dibuxrFHkB7oSQF57xc0JfPXuRBFKCnt?=
 =?us-ascii?Q?dkPmE2omVJjljLsSJshRTIglEdNk93tdRfxZiKVEDXK9mm61wXZ5G/nusg/Z?=
 =?us-ascii?Q?TSO7dJpycmCrVrnSg3TzQlreLL48QZ4SRZcnBdYN4l85h918e95s3GdYzezG?=
 =?us-ascii?Q?XmwqyPwgPCWVMDgzXMw/KOTr/nAjAxePfSIze+zL4yDUqcJ6bWILNTw6rEGG?=
 =?us-ascii?Q?pJODGhOFJzQmpjKhFEIUnDp+1tPsbJTl0RWjvdztVXE2FClkah9CngWem86H?=
 =?us-ascii?Q?oMo3+kd5c8nYKZ6bHXTCIRglSeqHKh6mLSgT7X4HswaP4uUr5Oh9KiVecGrD?=
 =?us-ascii?Q?o06NE6NwUpGcUP/wIgQra6iV7D7gUCHPoCRwl9EzOapY5dQ7XFx+DkgiX5wV?=
 =?us-ascii?Q?aBUODXcOu0Cg5z49xHmcQEUrj8JxwvmLNS5WE/KjAtGS1CCOpYlwMdY3dSv5?=
 =?us-ascii?Q?QjzIUV/dstoks1CVgR/Yp32tKF6BTG5E78xBP2f7zo1YIzCwHbaMfxSbcD6Y?=
 =?us-ascii?Q?D53kUVLqsSZ99xxg9MzAIqdg/5R5/Fn2TY65ILVH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc184bf-acb1-4e6e-43e2-08db732713f9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 13:46:28.4062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIWiboctYfS3E3Zte1fcWAZXCVg1xVDmnCXMyoMR7ZbSmATzR9moNuAtXyOseh/+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6450
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 06:54:47PM -0500, Suravee Suthikulpanit wrote:

> Since the IOMMU hardware virtualizes the guest command buffer, this allows
> IOMMU operations to be accelerated such as invalidation of guest pages
> (i.e. stage1) when the command is issued by the guest kernel without
> intervention from the hypervisor.

This is similar to what we are doing on ARM as well.
 
> This series is implemented on top of the IOMMUFD framework. It leverages
> the exisiting APIs and ioctls for providing guest iommu information
> (i.e. struct iommu_hw_info_amd), and allowing guest to provide guest page
> table information (i.e. struct iommu_hwpt_amd_v2) for setting up user
> domain.
> 
> Please see the [4],[5], and [6] for more detail on the AMD HW-vIOMMU.
> 
> NOTES
> -----
> This series is organized into two parts:
>   * Part1: Preparing IOMMU driver for HW-vIOMMU support (Patch 1-8).
> 
>   * Part2: Introducing HW-vIOMMU support (Patch 9-21).
> 
>   * Patch 12 and 21 extends the existing IOMMUFD ioctls to support
>     additional opterations, which can be categorized into:
>     - Ioctls to init/destroy AMD HW-vIOMMU instance
>     - Ioctls to attach/detach guest devices to the AMD HW-vIOMMU instance.
>     - Ioctls to attach/detach guest domains to the AMD HW-vIOMMU instance.
>     - Ioctls to trap certain AMD HW-vIOMMU MMIO register accesses.
>     - Ioctls to trap AMD HW-vIOMMU command buffer initialization.

No one else seems to need this kind of stuff, why is AMD different?

Emulation and mediation to create the vIOMMU is supposed to be in the
VMM side, not in the kernel. I don't want to see different models by
vendor.

Even stuff like setting up the gcr3 should not be it's own ioctls,
that is now how we are modeling things at all.

I think you need to take smaller steps in line with the other
drivers so we can all progress through this step by step together.

To start focus only on user space page tables and kernel mediated
invalidation and fit into the same model as everyone else. This is
approx the same patches and uAPI you see for ARM and Intel. AFAICT
AMD's HW is very similar to ARM's, so you should be aligning to the
ARM design.

Then maybe we can argue if a kernel vIOMMU emulation/mediation is
appropriate or not, but this series is just too much as is.

I also want to see the AMD driver align with the new APIs for
PASID/etc before we start shovling more stuff into it. This is going
to be part of the iommufd contract as well, I'm very unhappy to see
drivers pick and choosing what part of the contract they implement.

Regards,
Jason
