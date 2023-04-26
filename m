Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A8F6EF626
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241242AbjDZORx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjDZORw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:17:52 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0627423C
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 07:17:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRpZ/zqVqE5JYil9JA0rgjocM3Sxpc6rCELKPHh/AuYKC9VwrcaSqRoRNb4SfQCP583YvRtFatNfF/njwqZP2/VY07l4kxUTGJetg/ZER+ZAh48G5AW7oy+BrlnhkjvNMGcYVnmnh5g2gcySS3ZfGUXq2HIMR0r/+NvmtrLXDfaF4IeVTvd4i3XSabP90vDXpSZYJSkA1mfxMo/XVNLwkjQRMGygHgN9sPLK82JvP0wbTvuTfU7w11FKO4M1g0CokCJ9Hi2OpLQiT67UMIVsNbAgBvDo4u4Sq2eoAM8ZNTKIUIwLDCoUL4pYjL38ZRXEFJoyaWxdhUunN+aZBkE+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKMLIYDPbRAaJdN7Re+GZsAaSyThne81KloxG3WFJ00=;
 b=RqmRRSRFSCUSPytg8NgqEEiZMNxaVnYxYFVuE/IDJm5DsTBy0lhtUnmQtmK0a8h5jmSDbReQhirVzoLkWVJR36S+jbiUx62zsS1q4NwSArcNgcJ/UA9d2qemIqfYxHe+mPU0aRmHwdBMD9yE+ZcyU0uN7c9R5FlnsoNaJs3B3pf/VRpo+sxRlot7S+8IowpvNs9fMeJA+WuMABna+gQJ/0/NCSwDzqYsHW0urD6TOUuWcW/spw4yOPUzf9/GGhncC9Fv3CXWJqKtUXJQyVbhABIaV+tRgtn93t6mhP0AD9o7+JqLDGroAlnoIl5XU2RpqATN/0gLvKgx0L48uFBS/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKMLIYDPbRAaJdN7Re+GZsAaSyThne81KloxG3WFJ00=;
 b=URKYCZWfItJmR/Odc6P+3MABo0uq+/63B+ZcRJyHjKyKdjXOeK5/ssmjpH10qz5b/Fjv/tsZ2YcwqwqtbbtCZV+bnHmXK0GsrTa36C5zlORgHpL038htZILX8m1/c5io+MimZLuniV6fRtpuR9NTBCwuOLmYYmyZHTnoyk2l8M78xloZColuBEnBgqCOXZzER2+wEfYP0DWEeSlCmaKk2gPEaqPG4F8lPtzN2gVbpWOYprLHgGbThzhJStFjhprgEMVYf+aYNwI37GdVPPQNGAFvfl+UV9833mAi7lZRjnm7q8vtG4Slt5Oc2AxqdE+PhD7/YKRA7Ua3bP9iFfOLMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4279.namprd12.prod.outlook.com (2603:10b6:610:af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 14:17:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 14:17:48 +0000
Date:   Wed, 26 Apr 2023 11:17:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEkyicpaAJJ+pIXg@nvidia.com>
References: <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com>
 <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com>
 <ZEkRnIPjeLNxbkj8@nvidia.com>
 <5ff0d72b-a7b8-c8a9-60e5-396e7a1ef363@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ff0d72b-a7b8-c8a9-60e5-396e7a1ef363@arm.com>
X-ClientProxiedBy: BYAPR07CA0064.namprd07.prod.outlook.com
 (2603:10b6:a03:60::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: df8ca7dd-bcff-48fa-a4db-08db4661031a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CsgiEj03w6yuMEKWbYuW8BOH8hS6jad/uMUxc22IJR0fOSGjNQ2RB7sNs+0lU4ztvzKL5q0FTa+0VJa5X1SzOVZ47+saLtfM9UW0PtTe4rRylFOOmchPka5vkuLGkNzOTl51MGCLQNn8W4+pKV/ncd7g4E+F6mQod49sRhc9aRULuvy1NTX0+9jlfX8cnDv1Qt2X++wgL1nd72LQhKw3vLZlLY1UehkKCafDGoiiUd2wKVLX2vwQjgf/dyC5ZTtrs0CLuIrz/oXZrsmyTwbxHTaIiaqy8HszYU+I6dEoR3k/T+ZFgkxshHqL3JjszdzxIasP1lcAibrjxrE4gwTUQbBgZvNkvml/oaOwYCqAMHm62yoZQr4s7b7kG3Y5KBHbEGSSXdOAl27VZkhOAqvylV7Q2GfhcTqEgXtMWtCQIs4xHLqtIv6zM1L8+vfDasB7aa6MpeYl8PYaFBiM/ngJXtBC/8XOOLfAQaDGy/dmn8n4JI7Cz0O/OBtRWdMZjBDRmPbPMU8EwLUkRlVfiaiNItHcxUWPyhaT0Hm6AIVLFXCXROkhUvJegSUWHViedx5nMv0PHCJ4tH7MYlqQvEHy/2EJgbxZ/2X+bLO0Lyt9oVQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199021)(2616005)(4326008)(66556008)(66946007)(316002)(6916009)(186003)(66476007)(83380400001)(6666004)(6486002)(54906003)(478600001)(41300700001)(8676002)(8936002)(38100700002)(5660300002)(26005)(6512007)(6506007)(2906002)(86362001)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dgLh7L5jwadnR9q1qaimbQjxrTAg3UU4Lc9c6h3FSRy/MANh3ryUiwGkfFqi?=
 =?us-ascii?Q?L+ZHLMVBH+t3IXL4+SL0KP3hiSTVe+cCPsfxnxyLmKpHF1JLCPKXUCEGxo9E?=
 =?us-ascii?Q?oZBvm3HfO0QTFbepUPF3WkBMQznOPwUTdM93wtMVYopypILavEBUZACh1r7/?=
 =?us-ascii?Q?5dG0Iwxi1dXTVpTQ22rtt0YCMOQSWszxCTBBZOuB2RazOUqXShIOd1CkGrs9?=
 =?us-ascii?Q?5wZCJmdyZmr76Onexa3PXB+V6T7Q91jXvWTo5gGPyWZzHiNnuO4pQQ5BiyNx?=
 =?us-ascii?Q?aqG7cvzCmsQkaCKy/U/mnCxmphZxstq5AXhVgxn/MLqEiavST+8GCLrV5Zo1?=
 =?us-ascii?Q?Z0F80QMGuvOGI1rSImxO7I10XrMCP+woEnM7gtO1ddpjVqM6RK8LpUIN4Y0x?=
 =?us-ascii?Q?CODQH1q0XfuJwi3i/WhSvkXXwViqEHKawM/ufmiv2XbAUyy37fb52fxTrySO?=
 =?us-ascii?Q?+Vne/6RgoOlaa99qnPw190PPbSLx8FE+9gSXDcp9KhCUHSaeT9etmcPBcs45?=
 =?us-ascii?Q?sAUCGCp6MQ03Pt0+ELT+XQqG5VKZSKXNgjgKXirET7hS1BqhF4t18mGiq9dw?=
 =?us-ascii?Q?PQX9lmc8x0/6qHL98CF0R76A31H1MCvLs9QEQnS3Nr6FlTgUg095+mexDzRH?=
 =?us-ascii?Q?DL5arhnEs+pimx1mnRW9DiHCQkvY4g9EW4TMrL3kBPI7VR5xo9U1jfIqQK+X?=
 =?us-ascii?Q?ayy+1AMCasi5TJ4VAhOz0C31YroeqUxQhym+JGkQpXVRt+Zf0wXMb9FZ4xIQ?=
 =?us-ascii?Q?TzoJxOplHh3rF1R0RmPIaztaX+3qpvlW4pAXoZB0DpCoKd9RvbnATH/J8R3J?=
 =?us-ascii?Q?xvJhyVQVmXWRFXefqrsxUV0bqu+h5rB0gSW5ekIzhwAkPgUYrL24Dkpb7AqS?=
 =?us-ascii?Q?QmW5Aqtph9n4ImL9em7LZEdFAW8xh7kS++XDDz3rPFDggESCgfbVEIfA3xP/?=
 =?us-ascii?Q?gV/SWmPxthlE+8iDGTazhAA0RLTggJwpanvo5GOLcvEbXFVJ00r9skILWSaB?=
 =?us-ascii?Q?Voj5b0ECpRkvlBcDf7q142qG1uAlARMojmpbEhRMwhMHglDmewOrwkTJPMKG?=
 =?us-ascii?Q?70p2u8XTrxTFxwhPJDh14E8D2Q+RWH27Q+ANVqjqns362HXFddbL1vSu2ih8?=
 =?us-ascii?Q?lX+buqWGpIGOoTOJtbyRDt7yiyKdJg2NKB2icXMZqW/FTkpEROSdlPBA5kx0?=
 =?us-ascii?Q?EbIsOSZv6Njg0rw0uQbuOBmToPQYnx8rl12IaDE6wq26G+SIeNHuVyohWUwc?=
 =?us-ascii?Q?CB0k1iTdMhKZJ7JG4SpB6PpE50+pO8CFPXKwmA19UcFmJ1LbPjVE4VIzbkK3?=
 =?us-ascii?Q?jxmcdsBxiw6YPzwh8BjQgXnhkjV11MvWy57v2CFIrzDSwO5+9Bps0jzsEpyG?=
 =?us-ascii?Q?hS/FDEJVxpenkBP/dX5ai1z0Bvz5Ru/utyRii2460lwtf2Hjnk+jSoaSSkea?=
 =?us-ascii?Q?xULX3U6kJynSKCNphB5rWzzSWcjldg1K6poAWifn+deO/Sey3HdHbrjQRI21?=
 =?us-ascii?Q?tEQqhMttp6i95lwZGgWVY71HZW6JwhMwyBmMuN+I086rYGeypqmq0YWvHB19?=
 =?us-ascii?Q?hO3jeivyHaIjCQrvGUwaHi4Lk2W8EKVwD0KPQ1U1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df8ca7dd-bcff-48fa-a4db-08db4661031a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 14:17:48.2841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvLS4x2sHRzlBzI/8b3dcXKF/EQpF3zzU0FUi4oUDF3jrLOcM2j6j5Q0KmQJm9RO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4279
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023 at 02:53:53PM +0100, Robin Murphy wrote:

> Give QEMU a way to tell IOMMUFD to associate that 0x08080000 address with a
> given device as an MSI target. IOMMUFD then ensures that the S2 mapping
> exists from that IPA to the device's real ITS (I vaguely remember Eric had a
> patch to pre-populate an MSI cookie with specific pages, which may have been
> heading along those lines). 

This isn't the main problem - already for most cases iommufd makes it
so the ITS page is at 0x8000000. We can fix qemu to also use
0x8000000 in the ACPI - it already hardwires this for the RMRR part.

We can even make the kernel return the value so it isn't hardwired,
easy stuff..

> QEMU will presumably also need a way to pass the VA down to IOMMUFD when it
> sees the guest programming the MSI (possibly it could pass the IPA at the
> same time so we don't need a distinct step to set up S2 beforehand?) - once
> the underlying physical MSI configuration comes back from the PCI layer,
> that VA just needs to be dropped in to replace the original msi_msg address.

This is the main problem. What ioctl passes the VA, and how does it plumb
down into the irq_chip..

This is where everyone gets scared, I think. There is a thick mass of
IRQ plumbing and locking between those two points

And then it only solves MSI, not the bigger picture..

> TBH at that point it may be easier to just not have a cookie in the S2
> domain at all when nesting is enabled, and just let IOMMUFD make the ITS
> mappings directly for itself.

Yes, I'd like to get there so replace can work.

Jason
