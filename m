Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4BF6A4ABB
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 20:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjB0TUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 14:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjB0TUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 14:20:49 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07BC22DDF;
        Mon, 27 Feb 2023 11:20:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG+Of298iEeMqUkpjlM7iMFgTWVwEivK0te7cc0Ku/GZUE88Nz6kuqJg0BRPj9AyJE7QSc5IzZhOl6QybHQuwMP77yQWu1Ophq8bRwlLw1+u9dxChtf+HYLQc4zmetBSM4ly0/YwjbYUVZqmKU9yXk/UYVIUd50jURTSd9UgDyJvHyRB3bHh1T468ocjt0ORUdk7xuFQUk1nS48GOVNPLYrcXHkuCo3ASh/ffK4T+gqcIgMCLm5mgPRjYXn1+hLxQS9YS4clDnMcW2Jqu+QMUvY18qV56fFNXuaeHq8R2njBhGzjlgBSLQsRUoVYOpE/K1NRdfxl7n+g/Hz+OZf/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3wjdlahP3UZzAgNF/BLprGVQJWt4gN/phwGhuH6qpI=;
 b=me3ww0LmIe2/RlPNqRqz4XmfI5hWr81HeOL9+yXOjfVEgmrkxxGBZlGwFgCfAJgPhx8eQR0zpsw0FBp+WNQ76RVAFx8RsFTkdwTW0mhCY6QZRLmrlBhTvM5h1jHvq7tO3advqxCSauHLR+4F9NdT2LHk5rFscgtz/S4cOZPEtrBMBxmWLPb2YlXQJkf6jrb1jpnZ4r9IXyVRYia23yJ1vzwOgiOTHf3gKRg86zHo5Yz9nqA0NQ9qG0ml/YLm34yFgwt+BURrP/nG4Toc+ItEBBhI739GKjPExk6XqCcweJ1QGcj3zLXHXZZtwDyVxoxBP8f6bZyNa2luUB9if7Hgfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3wjdlahP3UZzAgNF/BLprGVQJWt4gN/phwGhuH6qpI=;
 b=Q4dMjT4Y2ujaDWZXrqypQjus/DTGui5tzJUHpX+CE/6Ko787he6MK7Bv4Mq88j8sg3lk7Pb5foWPN3lWUsNHL2Bzv97SvLRMMwJ3AdXi603f/gkiwBnVld17b0efkAXBTxWl04GgXTR5Iklga4wzyypNNNdYseKFdJPFinvuHKXg4LioO277hexZhZ1YAuiwFvAU0psT2h4ySiHVw2o+q5xUIo8HN4trs+OoM9xLjUTAKSTVxitdNFeHwr/6GtqQp14zTt2KLCrW1K83/8IwC9LjM17TfTQXhZ43HonIu7VwdFeVciiJHOc1/QFCTKJoAfgooTpeFktfkfqiXHCqXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4892.namprd12.prod.outlook.com (2603:10b6:610:65::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 19:20:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 19:20:45 +0000
Date:   Mon, 27 Feb 2023 15:20:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 13/19] vfio: Add cdev_device_open_cnt to vfio_group
Message-ID: <Y/0Ciz1eZI+AoHJs@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-14-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-14-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR02CA0077.namprd02.prod.outlook.com
 (2603:10b6:208:51::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4892:EE_
X-MS-Office365-Filtering-Correlation-Id: 279db0b2-2601-4cd2-3b65-08db18f7b94d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eNJZmqS0acRqeafx+HQ31ShKJv5hEUqDjBfLKgHoARMtoqoK4dT1GXH3pYYXGPQPI7nLALxR2a9pc9y5BBckBHTNtTzUSub1AEnQpHNTieNrY3OyuON12NzBOAotbX1KEz3jFxqjWm8i3haVywgRNoydAX6EdPB15YBucSsAVUZQkFjJFUJru16kSZiFwezDuDYJ41ZIRRUP7DmhZR75TfnEzTuEwLSKy9PaZ2vd6ZouaDulIBhO6lguX9kh+qzcM2gQk+E3auDbQSskjtY9cU3vs5movjb6v/3OqYK/UG9VWxwY+6a5LPocLwCjZQErNyxvu3TJDDbd2W6WYSF1mQYSwkykGPb45M7DA7ZtItHSmGKRi9E10BZorVYF4gIVe0y0pSVTkXIZuIGjT1IqXYn+VN2DcVImrTo3YuYht5yyoRCZG3+3oVJUGoPRhF4mia42XP0Q/7BOYoxoZWpJAvGelhLYMUypRy9VGRtDJT2b/9virPHoIZrJ4Njs2IJTAf37mVsatf0EXYNcJOYlbysWH98RD4x7/erjCl4NL0l33cF4gpGJUJuVcEG0R6/JZv1WQ0O74EcqyoIpyjUImieot5I6b+KAI9Lz5fKH0/tgo9r+2I1N+fd53To3QGKl4vnIAyplnmrjA+S+4oBlgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199018)(6512007)(26005)(186003)(6506007)(86362001)(36756003)(38100700002)(2616005)(66556008)(66476007)(66946007)(4326008)(6916009)(8676002)(2906002)(8936002)(4744005)(5660300002)(7416002)(316002)(6486002)(41300700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?52mmR+F9qanbUqBArGVzuzCnmEHzkIWAo8tCglhawMhkFWWjUfBn00ccmS28?=
 =?us-ascii?Q?e9mtaGJIyhRWkIxg2YgDFdNV5+Q1a0Niz6wppV7wDJzCuV6QVE/N5xNxee82?=
 =?us-ascii?Q?kSu876Z2rq0pZPdnFJ7qpv1LIjuALvcsEpbsJC2BaSAVyvXbcAl8MozPotT4?=
 =?us-ascii?Q?+63Zaoi0NMGF3mCp9GOcddYVUZfo6CaxATxGSJcQzWA8np12YiNlZORQ2l8m?=
 =?us-ascii?Q?7DsZtKQ/zPs9B96h1zg3ld94KAC9VkDsrNTbIqyaXb/wtAGDrTeYoR7VqU8j?=
 =?us-ascii?Q?A1s+gJz/5xOwm9BQ3nucouDSQqhrPM1PUA5I3E9zB1gC6weToFtzfD2Aw268?=
 =?us-ascii?Q?tYqQYR3PnNgOFTt7wE7ajdfmTpO80+aSza97Yy5y11mujk1bmKfrzvqstTmx?=
 =?us-ascii?Q?jARZz8MCBuCl5+HGE7YQBUWOeg4yp+x61KJ9q3i5NvyxjdsLD8pnE5sZNxGG?=
 =?us-ascii?Q?/TGWX+HlWABYqW/WNeiYitRchsPCtWT5PMubwNZptkNpjBf7v3WD5rUG4tYN?=
 =?us-ascii?Q?DhLqGYSmVIrSZIqLNV4hFTZyHx6esDVSeuVKKOfrzpMgXjweHVE8jl4PgNSV?=
 =?us-ascii?Q?EuGQyIy2AULNewL+ikI1p/eYULsPzssiIMfU/YAvs/p2IBlnukJlZpDlj/Yq?=
 =?us-ascii?Q?0meVFKakuvKLoW8o+3YC8duosG0UArviUvoIQ2bfRUhEPjaOJ0HMVp5S3iCo?=
 =?us-ascii?Q?sx+7h+VI3NsP6LHcBtS5dGcI+4u68EFLBWh4BI6BOWMT5r9FaTgCkYuUskAs?=
 =?us-ascii?Q?irK6iwXGOtmQZAQcx51larOmB6KGshE6FH2wAMhWrlyghUqLL0OhHoE5ykpH?=
 =?us-ascii?Q?vjWKGJudCc28UjNxd8IaKoJjzg0axqWAKo69yGSLSC+BbhsCekDK+3xjX0Rs?=
 =?us-ascii?Q?y4oAdDzQeiQOgzbXr9DhVfNUwBvUKK/rSPOkyFMy9U27LvGioUN06WcqtBTi?=
 =?us-ascii?Q?lb9IpoBlub1N/aK1tkTSEOpA13VG2WBSdYxRftJDQq+2vw+HkrsKt1FUzncw?=
 =?us-ascii?Q?0ECyriDcfmKnZyn9lsofviQbjS8sSBA9Z289xXlDKH1AO+LQCaeBoYwLxlHx?=
 =?us-ascii?Q?xxZ/xuPhEkQ5RF4NPTAFTWhCnIAaVsT3zXPIpPKmfHe+4pn6pNSVKpxUjU6u?=
 =?us-ascii?Q?+VewqknDpENoaoW9HBKrI9pbS5P+ZbiSsNMgNtxF9dRY2HV4ey7D56G2JsKL?=
 =?us-ascii?Q?owt3nKVn22CYhALicCCuLb2xrxevE4PjhKiglZWXl5I9v+Lo4V5esm7PW7z+?=
 =?us-ascii?Q?5US4ECNNLVIo0N1JWPLVx4tLOGhpHtFLsKhUm+859ore//6RHZwddsffLu22?=
 =?us-ascii?Q?d0RADIq+CM6m8SOk7XgwFLvpQotyS9g6q03mZlay84CdpHf2z0n+mj1tKrBk?=
 =?us-ascii?Q?TPgxHb7q6m1wc+75VIDE1KwiMDfKP81f7EK6v9mdv0Xpv+V66ajjvzTcZT7t?=
 =?us-ascii?Q?KhEp+4XG9qJ9wLPkeeaoj+r3ZkL/2MBP+8iROj3rr4+qMeVSDeiJ7f+PJY3s?=
 =?us-ascii?Q?QiiL7pQKDhhLd+ntHmYa3smxLzUE6BjK7B8jRnfaLu99AV9PiHNhrWFL0U99?=
 =?us-ascii?Q?hejHsBsCqUIOrxcMWYVFot+M1jSsBON5MPymtux9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279db0b2-2601-4cd2-3b65-08db18f7b94d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 19:20:44.9610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btyi7uhIBObji80opyG4ot95cxGKMzLkxLaJfJkuCgV1msyj9y1/b9JNDQhnPgEU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4892
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:29AM -0800, Yi Liu wrote:
> for counting the devices that are opened via the cdev path. This count
> is increased and decreased by the cdev path. The group path checks it
> to achieve exclusion with the cdev path. With this, only one path (group
> path or cdev path) will claim DMA ownership. This avoids scenarios in
> which devices within the same group may be opened via different paths.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/group.c | 33 +++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h  |  3 +++
>  2 files changed, 36 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
