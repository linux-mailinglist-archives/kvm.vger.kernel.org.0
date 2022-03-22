Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC42B4E4409
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239005AbiCVQQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 12:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239001AbiCVQQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 12:16:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B342A5A0AA
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 09:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVCoRM0vV0qY2eKxOX5qvSv56AeICWbXm9CAtYPNUvPmXqpOTjDJJPEe2zvMxkYNZs7GXR+VpFKp9otzfaFFPgcrnNKVzxq16dfTA2geoKoenGHK8jyU1muKaGZcJzVWXoCSTGtg4ULRifmCetXvIPvFat65zeJrl2YD9cBW3HEEoNaJXI3rPYsPllEtKb/GkLcD071IE+6annjE4vkOpGS9fufoNjOVbxn2uVf7NoOI4CyxtBAX3mgdSOcoUitIl7eXC2AwP7lEbrZ+jXeTcYTZjXBKCLi2zX56NaQQc2jZeNh+OnZbHCH9v+lL2N9aDO05ddMoFLuCof9o3XeXoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FC3HHRzRvyGDVTzsQhhINZ7ms3nXfiV4Y+ijmAQHC9Q=;
 b=IszzBkY31xVNR0K6ol2b/dLejzWWmXurp1QMd73rGQHi7d65Qht9JiJlDrjDBzVGukn5/SWozKjQyCwkuuCMYFuB60JxDnYtK8u6vWZhGb0JtIWTxSQkXTNOdxHWeNPT1+EBPxrdtoC09sioTG2DMAc/hf6+xzdxxqH7wkudU0gj83mENraCwdmSwDrLA0Y9vo6deun6GQKARVkr3h5XUM1Nn638c5ZPqbD9H4ELVXyhfeusIzRMcrKE0EOKImifJw5XAsVrKEhEPqn0mIofL87qkPefvjCyESMkURBX1CeIGfdubhcu2iCTCfdXQAWYVFqKn0obEiEwVsjETSOU2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FC3HHRzRvyGDVTzsQhhINZ7ms3nXfiV4Y+ijmAQHC9Q=;
 b=YLKngu/ORaNsD5y78LvaJTtoNMGL7LvMUEAA8DlhCvD9zuL8myRH2QNYnSS+TdzTGtSCdV8qF1xAHVHSMUul/N5B2ve4/haiGMer4OpNIyJvsY2tiGcKB0YAEqEPqei8pGH7E2ai/IurC+UglF3BQPUdv0wI6cqMqgQMjwJChm596l/I3iwQPkfxxs/WuTXUHJGrm7QnKPFApQVZlHafNqLfXKsgGJNPeo6IHvw6da1vHjCKs5NotIeHy1ADG4TrXcJoQ6bB5uqXRPFbUfP7/bVPONsHGI6SlzEXFmpYZrA6AeVqzyUmpwylbXTgIKxv1pWOHMz2Uu/bJffzksXpcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5210.namprd12.prod.outlook.com (2603:10b6:408:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Tue, 22 Mar
 2022 16:15:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 16:15:23 +0000
Date:   Tue, 22 Mar 2022 13:15:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220322161521.GJ11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <20220322092923.5bc79861.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322092923.5bc79861.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:208:2d::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dcc6652-08f0-42f7-a462-08da0c1f2ad9
X-MS-TrafficTypeDiagnostic: BN9PR12MB5210:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5210B0EFE9DB1B7F840DC7DEC2179@BN9PR12MB5210.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raFWrlVuylupIXXnWD/iwTqMumGPXUCkcYaf/0yO9Q1TgPI/GcJ1OXybx31tl7CyUhgb7QbtNcv1JTa14T1qMIYlhdN3R278gppolrEq40GRd/37R+ZNgaCeWVX0zpcjKup+XWP3Q0qz4t/OMD38J00ML00XKXyqGmaXfGcTzFbKg60Vpk5BIfGYRrqskhv8vEZSR11HSzUps/TDTsLqr0Ccc4y+nIQSOyIyNZkgHmicIcHq8AbQAiJ5NIaC6J4ygQjf5gvltsbvFUjCplqIcD1dB/Hs6hthRmZDGew+57HF9E7Ad6IhuuaXTPSzjGSrbuPSQQ1JtvKbuHklaX94CZQ+OxCe9knB2i8vB/B43Q9uzVOTKFSFsLSkfqHVhE5orcX2ZXtXbzVXIU0u0FjqsheMTLpFWMXLDfd87zcCM7DNV9T4GrWL6Bpsj9MYe06ZFPflpE1t8BDHOlGgNaoowfkkZpZRLon/p/J2Y7JKvpbGQ6+hqaW/ydlPgyHX/Pgvn7Sxd1+o/QIWKVE/GDIA/irhV16e9sdbTlGJ3Q6dQ+mEr+emjD7g9+cYKV8SP8s/y6nq4zktZg8PGdl5Uw5DMfYo1ZME3HFy/jZh5nUvS48RMJ6uYMP8xPb5kUHQ4mLnxBhPB0GBiQhr7JzWma5DXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(316002)(83380400001)(4326008)(8676002)(508600001)(36756003)(7416002)(6486002)(5660300002)(66556008)(38100700002)(6506007)(6916009)(6512007)(86362001)(2616005)(8936002)(1076003)(186003)(26005)(66946007)(2906002)(33656002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gew5ImYd8ledNPWiUS2hUtJHRJQPslxrCfLCrxgLIwgPat9ZdyqEvKPa4rw9?=
 =?us-ascii?Q?LsKJJ3zDG1Li97UWx0BbPzodcGgPLYtP+beO2aLdNgdrkOckdl3DTeXujQRT?=
 =?us-ascii?Q?L+XjzB68J8o5GttMOAlI0+6OpiWatN8MJH0IWsgeuRSzbax6SODBQwA7ENSK?=
 =?us-ascii?Q?MGIhsAKhyGMomvpST8k69EntwXpugOMqJVzvFrSlmJqxY8F8Zo0GhQBfNLRw?=
 =?us-ascii?Q?5HGf7AbNE/gV4szQ5MpxWljlOpgnejYht2YVR/o7rnqgVvpQUMwrYMRwBS5P?=
 =?us-ascii?Q?VHDrFmgZ63PdD9b/UTr7v+H690OXan3ZIka1E4HQD/Im9Aq6ZtW2hS1OFtUm?=
 =?us-ascii?Q?d36TMSRSOXJizwIgYV/px7mhTIcNLW04CgMe7NUP4WXvhMIIvDjbteRR941Y?=
 =?us-ascii?Q?mhRjeu1Vt0PNI1H7I3URY+LflHzqLmsvxr+sy/eo8KaSJlYylJRPahTUZw0N?=
 =?us-ascii?Q?pMz8GqEl1wmjPFEXW+FvLzOFvX1Y/KbJiD1yraukEkxrL9w4tD6dAOJivUA8?=
 =?us-ascii?Q?4HG0pSQ9xXJEUZirf3R2zsrr64poBxpJB3gAc0lfi6XPKwNqfXvNksUdvfQj?=
 =?us-ascii?Q?1OpknZvXLfpeHSJ0QcwZoX6iBMCig3l2VAcqmAUc7eYAgR4L2oSvhJmZWhP+?=
 =?us-ascii?Q?nNPzpuI6MfsWm04ybGjU9K5HQi3k0vdM1C1x8kzE3QB8MBeB2a3Stml3r/ny?=
 =?us-ascii?Q?zj2tey4lLEuLvLMjCZ0AqJVJqQzCfp/OVs7CHCjjSB96wLrfRnuc8cB1Kq1T?=
 =?us-ascii?Q?6WLGJsvR+GvgkkBdS6rwt+/f28okc0dQXhFrbq5wxu08USA5iTDTpEGc/FA7?=
 =?us-ascii?Q?PE4GIseRAnzpmrjeaR7lKkm0rmTBigBKJm3e6WM/a3eiMk3qoYeVNUubawh+?=
 =?us-ascii?Q?PCpHUAvBP9H6Bno1F3UOhdgmWmrZGU2uWjHKM0vJXP+G1TBdxIs9vRzu1FyM?=
 =?us-ascii?Q?0ZFNVhOSeO6YEoFpq+jfFvxj/cV1Tr+Sx6anMXGSXgO/VrQHkVeou05jvNjU?=
 =?us-ascii?Q?jIXM1l3vOahX869ut5JkciCLFpvcHf0BfiIqgbSFBTQMHWzZAQR+xsR/4JSw?=
 =?us-ascii?Q?LWQ0P+KyJy/LWsIc4j0qi7D3GMCVY7JA59so9oamPTaWUQDUovHvRdqQbOTi?=
 =?us-ascii?Q?nucQqhhrdVDD0zqN6wgRJIHm9OZGD2YOL1SAB30hiLVx5EgiTm7+THlgdw9o?=
 =?us-ascii?Q?Ca3QhP1gIoA21Wg1d6PnfB+hc8+tSl4NEDNRzRBi9Y1dWsrUmVVKbUcFByRK?=
 =?us-ascii?Q?/Sgvp7f9E7YNEKHIPOrOaI1jxFvDJ7eeSKdu7uFMeXlQRzZVZEelgtnnFgi0?=
 =?us-ascii?Q?UqtXdmtllC7k2rw3xbPw2EgWFpzBv3MFfTiK+Ke0EZHlb2kEIzXUJpvziCSA?=
 =?us-ascii?Q?u1RZGUPooilGlwyuWkOAWZLR7KRLSyDKtvbqgB16ZQfCH8tKamUZw+oRNho/?=
 =?us-ascii?Q?CAHI9j6jdrNKS+Z1XBwOwId+QZxZpjWv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dcc6652-08f0-42f7-a462-08da0c1f2ad9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 16:15:23.0178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDYXUtRTBJjZTXsGYa6ew1Cy+OwPSswfjr5jj6JnNw1Q6CJkJy4JTJPBenovN9Tg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5210
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 09:29:23AM -0600, Alex Williamson wrote:

> I'm still picking my way through the series, but the later compat
> interface doesn't mention this difference as an outstanding issue.
> Doesn't this difference need to be accounted in how libvirt manages VM
> resource limits?  

AFACIT, no, but it should be checked.

> AIUI libvirt uses some form of prlimit(2) to set process locked
> memory limits.

Yes, and ulimit does work fully. prlimit adjusts the value:

int do_prlimit(struct task_struct *tsk, unsigned int resource,
		struct rlimit *new_rlim, struct rlimit *old_rlim)
{
	rlim = tsk->signal->rlim + resource;
[..]
		if (new_rlim)
			*rlim = *new_rlim;

Which vfio reads back here:

drivers/vfio/vfio_iommu_type1.c:        unsigned long pfn, limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
drivers/vfio/vfio_iommu_type1.c:        unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;

And iommufd does the same read back:

	lock_limit =
		task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
	npages = pages->npinned - pages->last_npinned;
	do {
		cur_pages = atomic_long_read(&pages->source_user->locked_vm);
		new_pages = cur_pages + npages;
		if (new_pages > lock_limit)
			return -ENOMEM;
	} while (atomic_long_cmpxchg(&pages->source_user->locked_vm, cur_pages,
				     new_pages) != cur_pages);

So it does work essentially the same.

The difference is more subtle, iouring/etc puts the charge in the user
so it is additive with things like iouring and additively spans all
the users processes.

However vfio is accounting only per-process and only for itself - no
other subsystem uses locked as the charge variable for DMA pins.

The user visible difference will be that a limit X that worked with
VFIO may start to fail after a kernel upgrade as the charge accounting
is now cross user and additive with things like iommufd.

This whole area is a bit peculiar (eg mlock itself works differently),
IMHO, but with most of the places doing pins voting to use
user->locked_vm as the charge it seems the right path in today's
kernel.

Ceratinly having qemu concurrently using three different subsystems
(vfio, rdma, iouring) issuing FOLL_LONGTERM and all accounting for
RLIMIT_MEMLOCK differently cannot be sane or correct.

I plan to fix RDMA like this as well so at least we can have
consistency within qemu.

Thanks,
Jason
