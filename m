Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960517CF7E1
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 14:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345513AbjJSMCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 08:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345495AbjJSMB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 08:01:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F0512D
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 05:01:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irHiMdJcWo5pH9zKsP+dmPeI9eDfdYTYCc73sCdnNucUcEpXATE9jS+KuTyVhayvczkyTdw6SqnzZERnZcnOM2Vmjo2jTW2JvZWGCOzFD8CX+8KCR9GlM2qDxZhPloPj0DXLwmSBisODpQkpkK4qWVnPuk88sjfOzYNbv9iOjdHNoGo63VrID07lUxomh77PzviGX9/3iqVoAemllNfW9w+JbnACcwOORcSDttBBNmw5CbuS6DAT/rZxD/F7dlZBsAhWw3VCNcZrpH+ADdtlSOCW8v0HB91xLmZOlu7qkIm6LgSc0GSib2Yhlsgt3fB2bVmMNwYzX/z5Hl14bNNUQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkn//RGN4tj4swM+7+raI/HFHkSU1LmwzrlcMkMbyok=;
 b=m+sWz6TpPMaNHCPd8n7iOSozb9RnOl3Un8/WLC2a/FacA+6PJGY9kzX6ICQOVgkpq55rMH50Z8N12v8D/Wz7U1DdLJu7c8Afhnj2KWlPX5Z7X6dN7BA/89oF364N+X2uYYBYSAApr5Edr4I5Ex/OLpXJGauM/NblRq+SzlYxaNUrAR8qo0dHL0jTGG0as8RhA7zHIS+uWFEMMqStQcphYwBybhwWQuj78uFCvt5JPHAJoXoeUkzqMRdkqT0bALTFvLxKIetOxTuNvvYOMfTdZVq1OApQl8bNQdzAQSF+aqm9+z1BQcQEkE8l8yZ7A2CcZgjVqEfEZLCe+EbzQ7qDRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkn//RGN4tj4swM+7+raI/HFHkSU1LmwzrlcMkMbyok=;
 b=bcMVuweIQWh32wZzGKAutgu9BXw9iFz9Nd6sB0h787wn1Zt7+Mc5d+RW1p+A+EuoJQ201uRm+sAXe6WpjvbXxLwJ75XHdxTxtJCmD6AnvCHwD6njm7GflYGsU4YdxOI/YY2koDuCqcFYeSSJHgk5zJcfq71SfOvqsCzCx9A53Bu5cveECJ7daLKig+zUawJ3/meW264XokICcVBPsMPV55MlCGMH35WeZPkQR6irZYLvRrhtRdZAnIPl0W+8pKuRm4lYWsPNj6kG2dJEHpB8s0RFoDJd/dU797f4cB9yaoGrPT9x36ehsfpsAoqu2up7yYmYTN34Swj6a9XIeaMDFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB9321.namprd12.prod.outlook.com (2603:10b6:8:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.41; Thu, 19 Oct
 2023 12:01:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Thu, 19 Oct 2023
 12:01:55 +0000
Date:   Thu, 19 Oct 2023 09:01:52 -0300
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
Subject: Re: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Message-ID: <20231019120152.GR3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-8-joao.m.martins@oracle.com>
 <20231018223915.GL3952@nvidia.com>
 <47f6f1bd-bc06-4efc-a5a7-f76c6b58b61f@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47f6f1bd-bc06-4efc-a5a7-f76c6b58b61f@oracle.com>
X-ClientProxiedBy: BYAPR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB9321:EE_
X-MS-Office365-Filtering-Correlation-Id: 59320254-fee1-4ebb-241d-08dbd09b3033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /qVE6NqJgvgKPnmu5M/Oqc/6e2LsY4wrPPkJWCO/d4kAW63HGAwf36C5oeEcAZDEZilyC1m+HHiLrHFbQoLWqZjOdEIjseYRPK2xv5wKVwD+UTfaugpxVC5brUeA37xhM0gLv54/xz7YxsNmlsri32U4RsotKDfFWTzlr8XU930tEFw56zvMRj6tuWijlC2uI0+ziab4uYVyZqB4ju9v2puePekmsr4LRO7ThAWVfl4wJJstDN3FUJOO73WIAdyDZgKOU+smZgMZCGJuWsrXCQQ8R62EK0IiM+6KmKmTIAoSIocZkUUEAIkhLmovQrHLCL8HM/M6+033agDozRlVFJw0yR+3D4B8FDfLhzIZEhU7FFYNKh05ldOSdgRBPfZbTIJloWyZteGoD0HChAZs06HSU2d+kS3M+LUEfvBO5N81525BHi0JSgrO2T8DBFzTg+VJ1e3AWSw7To5YVSoYjDCFW0WsBIk7hVJD5qUnkDlwgyEC1Ku8PSYu97yXhxdZgQ6H/3yeFRrYLIwdlfdirjJlL9PpVbkakeKM4ddveG7lttBQZa1QlXA8KFA72b+zOsIvEW4Y9K4ZXK1f1V7Y23q6cfxI1Y5NkjpEGL0GKmU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(86362001)(66476007)(66946007)(66556008)(54906003)(316002)(6916009)(6666004)(8676002)(6486002)(478600001)(8936002)(33656002)(5660300002)(36756003)(41300700001)(2906002)(4326008)(7416002)(6506007)(38100700002)(2616005)(53546011)(6512007)(1076003)(26005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VcgerjQn7nHToMEhLSh2ZIjFr5nNqkE0A8or/udhalV+5dDhM4O3fBUlSdKP?=
 =?us-ascii?Q?Tv8OqFqUKtvxqRgaalKgqmF3ULtpk2VmehB/K2M4hvqvoOWM8TOLfalhCudq?=
 =?us-ascii?Q?UdCeGxWkEPiLU+shSF6p/BewW6vnolmtINSctT5BzLlOfHJrEhsgSkKE0FnY?=
 =?us-ascii?Q?UsC7wrWiPSk7YJy6CKG5+0F5lV/qGxjcq27mCXh9UO0OsxY4bbL2SfDYUgUe?=
 =?us-ascii?Q?d4r63COd0hPI41ZMuYm8f/dYdszsGLTz5b8/+Bz0UQERtTUbW1COzNDDRkdf?=
 =?us-ascii?Q?lnadMILlDbeVrExumTXe8u9QrdtaeSSHdsSbcbt9Vbi0KqWmqfmktKRxHzVL?=
 =?us-ascii?Q?PRLOmDAjAKxURd/IDPkgIOjvCiQNKBH9t5aN8tBKe113tf3JFqs/MBibk90i?=
 =?us-ascii?Q?sazJwg/b2/4JggIgyb9jDagCxg+uOdiMPtZ9B+/sC+mLyPq/rbmsqpv8gvyZ?=
 =?us-ascii?Q?1XxHx+kSXtVm86acCtEErIC13Om3t4jaUtgMdKF+fCUlqB3Miip6MPWlcPR4?=
 =?us-ascii?Q?tECZZCfONmpVmq7C9Zi1sEMphS1Ht2qDmZvx8VxNj8N0oADFQiPVeh05KDn1?=
 =?us-ascii?Q?WUaa61MUHtKM1GhNzrlstR8i7NRbaIdmuMLDjhalR7oceSbPX2q3YXOBRdSz?=
 =?us-ascii?Q?fcfXwJsmgCx8wZ/EDKeMTBuXDEHPKiyb1qBYo5ash/p+6y536+l5YPcMb24g?=
 =?us-ascii?Q?8wvzl1K5KHcQ9U4sjnj6jUH+hNZmq3M21gEItNSx+963OK/E1Kjb62akoDN9?=
 =?us-ascii?Q?VrbtqmeBlFS/3/O5QBfvsOy5Y/fW5XT6EOIWIWfmcdKdKfhRRoj4U5Kgx+Bu?=
 =?us-ascii?Q?vpj6Maxm2ApZfj/8ieTbaRA1lx0l0ao3tOjg1EgzePk0hFUbDTWnx0k9NwQP?=
 =?us-ascii?Q?99yrO71SkXj8vzTBTMfnMUxuleRZrH5GPX2vs8/lOfRtHLcrJWqHsMJQwcfA?=
 =?us-ascii?Q?ucpwmXMJ/XeYz3vIJeHwMKt+EjMIHNDl2NOq75Omwjc04s3OWp7W6+zMbSzi?=
 =?us-ascii?Q?/Qo90L2ZVEHuBNTNDAX3RFHm6ajdfTqoOWKSHcGbHvjrrg3c/1U/PNz1MzUt?=
 =?us-ascii?Q?dOZtB0kgmkCzEmV1FVJXDWyxzc3+BxYfP4EXO4gis1FOs/rBRcn93cP7wFSt?=
 =?us-ascii?Q?+boH5o8Do0kqLt8iq/YlJutx8yLy6AMk+lSNG2EpnUASfORvQBGG+/Fx+IlB?=
 =?us-ascii?Q?RTYhAukO8UYO2X8hO/M8NwYzz8Vq9RobjHUZH+JlbK6MikynQ8pE0hiC0bZb?=
 =?us-ascii?Q?heyikIsJC+sqoEiVv0yua5hbwcCQAZBBQRExEErCZm1ZzyIgxZFSQTxXp7E1?=
 =?us-ascii?Q?D5ize0pFcizd+coDWg4vFeStqv+JGJD6uUvuzoIIddi3Q5B0TS/N14YuZQsJ?=
 =?us-ascii?Q?65si3qr8uRPI1o4DdKHysQCO0Sr8enZdpnGJ63YtXzNg09+X+8tG6QFMQJtN?=
 =?us-ascii?Q?A3fs7BLYd/V2B2ydcCxttSPfCNHS8wYPeUeoftAj+UrBuAPFLqFn4vYm85cB?=
 =?us-ascii?Q?GxiJcZLUet04tNTUB0xdBJiUTLy1A6Wd/xgogK7fYY4s8n0wWtT6lsDD+wXw?=
 =?us-ascii?Q?sSCNbQy/qXM2JZTzvqpQBjREq2LcwuOlHNJL4fHY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59320254-fee1-4ebb-241d-08dbd09b3033
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 12:01:55.1396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcJ/sBNxKCl+jpNaG/AwEZysCE1SwSyf4or3qhiVhStMkUUj9J65/gal+c7B/9tG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9321
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 12:43:19AM +0100, Joao Martins wrote:
> On 18/10/2023 23:39, Jason Gunthorpe wrote:
> > On Wed, Oct 18, 2023 at 09:27:04PM +0100, Joao Martins wrote:
> > 
> >> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
> >> +			     struct iommu_hwpt_get_dirty_iova *bitmap)
> >> +{
> >> +	unsigned long pgshift, npages;
> >> +	size_t iommu_pgsize;
> >> +	int rc = -EINVAL;
> >> +
> >> +	pgshift = __ffs(bitmap->page_size);
> >> +	npages = bitmap->length >> pgshift;
> > 
> > npages = bitmap->length / bitmap->page_size;
> > 
> > ? (if page_size is a bitmask it is badly named)
> > 
> 
> It was a way to avoid the divide by zero, but
> I can switch to the above, and check for bitmap->page_size
> being non-zero. should be less obscure

Why would we ge so far along with a 0 page size? Reject that when
bitmap is created??

> >> +static int __iommu_read_and_clear_dirty(struct iova_bitmap *bitmap,
> >> +					unsigned long iova, size_t length,
> >> +					void *opaque)
> >> +{
> >> +	struct iopt_area *area;
> >> +	struct iopt_area_contig_iter iter;
> >> +	struct iova_bitmap_fn_arg *arg = opaque;
> >> +	struct iommu_domain *domain = arg->domain;
> >> +	struct iommu_dirty_bitmap *dirty = arg->dirty;
> >> +	const struct iommu_dirty_ops *ops = domain->dirty_ops;
> >> +	unsigned long last_iova = iova + length - 1;
> >> +	int ret = -EINVAL;
> >> +
> >> +	iopt_for_each_contig_area(&iter, area, arg->iopt, iova, last_iova) {
> >> +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> >> +
> >> +		ret = ops->read_and_clear_dirty(domain, iter.cur_iova,
> >> +						last - iter.cur_iova + 1,
> >> +						0, dirty);
> > 
> > This seems like a lot of stuff going on with ret..
> 
> All to have a single return exit point, given no different cleanup is required.
> Thought it was the general best way (when possible)

Mm, at least I'm not a believer of single exit point :)

Jason
