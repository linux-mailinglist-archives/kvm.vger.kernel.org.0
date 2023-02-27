Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D836A4A45
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjB0SsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjB0SsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:48:14 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA81C1A4B1;
        Mon, 27 Feb 2023 10:48:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaDrGyXP99VN7KU7qRqMHqAjszP7MvsvkE2m+Giy5+Jpm9Y+5t1k1iFs8u8XdhWlwmGFJZ+xBdhVP8nWX0DUL+KS9rPnwPVWeERfA460jqE5qC54tYcLdC3LsZosuNM1KnBBlRSI+6zx09v2lkV4U0lZhqzIgUcRBTgipumfDmEAvFWtb1UA+RTDUrhT4kUhtinxbwcttp2lTrsipQOJtPasOOSdw5xV993Nw1p0JMxVLHEHfB+AfWfhylRr0BkkOsGD6NKAIhkFI2/YNXhjqLOnjZC5etIggb6LIq1w2aFFxUfpywxJkU7gMyU85K+EGW/V0/n+tvtoNwi/Vq/TuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wsvlAO7sL6zR5fPrJDaQKhMG0IXKapYwaDWS5K4CEM=;
 b=Y/jVxpcR8WakZOzOqk7fBMSIMgi0Y7dAJFfzA6GshJtQMiQY2EQd052+ilFuGrf0AMws2OBmxMxcR7GnCuBDNfPMyE9UucKfUNkGQ17HjwJDPXm/HKBujNxZhLEcdZwLaOxtVrGcdT1/zmiHV3Kw4gpDj6iMiFlQ/a1PdaXzBfdBaZnirOqDl9JTkfjRUWDr8U6dZaLsKmwB78yBCFxIiKBPQZQCSJG0g1jnziByZhVwnOptzVQTrXqub+aAmJ+NzEYMgr1ulTxZ5pVyfV0P6Vu11++dr3d6sax5jIh7te/cVOLKpMtZzR5zXupbWBN4lmha2u+UphF2j1R6absroQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wsvlAO7sL6zR5fPrJDaQKhMG0IXKapYwaDWS5K4CEM=;
 b=XJPhaCiB2o5nd9SGjeLwU/mvvhOWKXBKK3vZwXTqM28BAM+k/y4snWkQ3DAe3XEeoiI9a8Hx6PVjBDtLJHnB7TGKkO+wpGma3NE1JYd2atAmqiQPLRZjuW56ELT10/TsZ4T9NpUvWrcwgHnW1vifRx2ev78yIZ96IcK7PlxjbQVUcsc+u0AA8bV4FmLUgOrj2IzKW38n22JvAQXblVg6C3l9n6U+reDTeyK6C6Vhe4FObO4qh/j6FGyY4OmS6Obo8YEWgWvLthI3UhKQ0Y9vkR6BpOOigHyKMCxUsmD3L1t8n4na50zqZGKrvk7WYSDGN3ar87ZxyXzueBmLbvib0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Mon, 27 Feb
 2023 18:48:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:48:10 +0000
Date:   Mon, 27 Feb 2023 14:48:09 -0400
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
Subject: Re: [PATCH v5 07/19] vfio: Block device access via device fd until
 device is opened
Message-ID: <Y/z66bBSQk+qb3N7@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-8-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:208:a8::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 639c0b49-5ed9-43ee-9049-08db18f32c35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQNKJmSNkwXZ7VxX+hMEqptSb7o8HdDWj9zJ8dRTmVxbzuZ1yNwth2qppPPIrxS4JrVIKtZ+9jNaQyG14K4JJrs/meTmtJUm4DO/p63y1lKVXT1SXGWZ4ZhjlG3Xp3PXVAvbcJNtUS+VxENAfZ0ZXkCetOZr11hgxicACV4Zp1PRV2fvuHDpasziQOycvS4PLWSOi5OP0HvK1/FhOjawlCgAXrgSTJmIpqNWaFkgieM3v1XuqhXsgLc/tsuQPLJ5D5AYtcnwWFhOeM/oqdW/HH/CEOrSjkx30ZfJJmkjqyFPo8YV21CfHefot/wZ+ajtiW+QpHKrrK0yFcC+OI235WqY1FayYpizhPxSe1omOzHQP9egaB5akk/wTVa6iZg4oD0dtTCOUx/F0t1/z4LQV/W3UN1ucbMhQGZ645nW1+X56UbQwp/NfxI+A3eakvQ4TWlySefmb9O5VQNVf7nAXOwulyWlBx5nJu8Q3VVjM7DY4AvNSLseDk2+DSI5ykqernKO3sVR3fBlJDiGEZKXrejDQAlxytx4SkkupUekrsnkyRNlT1KL2lBFjSB/3d1X7szVVS96v7vvWwtJydmRChRY5PccjnPrQ//03vueJFePK7AjgG3Vj3h5F5RtvP07PvWHbVdugyxgVDEffiAjjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199018)(6486002)(316002)(7416002)(8936002)(5660300002)(66556008)(6506007)(478600001)(6916009)(26005)(186003)(2616005)(6512007)(2906002)(38100700002)(41300700001)(8676002)(86362001)(83380400001)(36756003)(4326008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4MM7MzzYF9gGoCXNcG4SYBZAmM8lC3sW3rI5loiA8IGiZaxUPOs3hY0Efz0c?=
 =?us-ascii?Q?6rfXAFQHg+KolaloGM9b+Y9OmGSNKr9406knWaSdrQ4YkQUJleSwSVLIb7f0?=
 =?us-ascii?Q?LVNsvmrb0zYatIrniSc30Anc+S5rQOwncXguBNbfiGcK3CXY10H6RfGp5yDO?=
 =?us-ascii?Q?5qyRQaxpso4xkgUWR+82cQGhG0I1XPxjrJRgHAxktE4wWr6n4+BbjjSNvtj0?=
 =?us-ascii?Q?aOvNwUuD40jXzvx8ptbmDGWHVFEb59yD+bhbqQBQ7raTaTrAYPBf/vvm4G85?=
 =?us-ascii?Q?Eehb6EZeSDwNGhBZHtIkXWvXuj+u8P39YDOFKgHKIR1avDUFkkSnNU1Erzm5?=
 =?us-ascii?Q?7Z+zCNyHYx5AnPYrIKtZdu9wYqDIJAHmXojy6RLBWcLvSGAQnuFaHfnxffBh?=
 =?us-ascii?Q?0y5ddiiEZsLBQ6F3oqFOIsYQb+D6L4Fdxb8/3KnU+nceFhDYDZqL6M0PvOfM?=
 =?us-ascii?Q?gQrzId4tZn2Uiu92d/xsohKR4gq6h1IjItAb14EJV2JAUpN0MY9k0g9DMoDf?=
 =?us-ascii?Q?3QvVmNbh2oCdB4/iSa2VzzCJLbgCNVlF5CFuykcJqMQE0HZNcQfYqGpSYR8l?=
 =?us-ascii?Q?oMkoTWd62BYiwFHy9+fpL3Y2JlsS1MjFjTcbWdABLLhK/bFgQyT97VctU6Cl?=
 =?us-ascii?Q?z52mf0cxW00gdeHFO7kqQSSLfgbOp2ildHtTD/pZuoZEI23bwkTqgzVa6yru?=
 =?us-ascii?Q?v/J979FjSIxQCjjBy3oY81gv7cQCJoKAizb+otELzoi179GN/HrsCq5g7fYN?=
 =?us-ascii?Q?9EQfXfqt09WY8Er76Avh+c0TaVmo5+QLfzL04918wQi8QGIp+02xDefhB35j?=
 =?us-ascii?Q?pGnO44x0o5dQKyxw/vAUhLhqRhktaPsEF0bQWAQZI/AJWqoP3UXzWWJ4LvdY?=
 =?us-ascii?Q?5G4gm/X6a3DsWqaDNidkRvxHLVvjeOjozBjvX6NpPtwUqihvJNjgftGKhDUC?=
 =?us-ascii?Q?XrNwr+tgTQDC/VmzYaSZEo2JhXYLCNkOAU0Th70F/pOk+JdmtlL9GX62kEWo?=
 =?us-ascii?Q?onFBOFXjtnic230TIYeN4bDsug4VZuNa8gzBw4fTvq2m871S1K6gKJARBnE1?=
 =?us-ascii?Q?fksdtRDL2SBRKGSX6Jjq3oqO4Rna8tf9jjbvULXaHKJUzthaM69Cgz8A1EQX?=
 =?us-ascii?Q?E+7HkoJMhv+7roqIRK2JsuECs5o5f+NmEJsvffUN+AQOz78ZCl3HAFRGoekh?=
 =?us-ascii?Q?481SbXXln7Y0wMmDbb5Xjnph9kNqm9NfCvYp53fJYXyYuFpZQzJW3MVAdTPH?=
 =?us-ascii?Q?mXeDUn/hrcsLnMc4s7Q8zdYN2SoQd8meD6fHPHigrUgxzQmqarmvaqOhPAQq?=
 =?us-ascii?Q?rw0uUTVjvGRuVH9mkf4oXE+fGeep5RTLBh8TWtQbZXTV5WK7Jmu4rI5PLSHa?=
 =?us-ascii?Q?mn9pa5pHOo3+fp8Sof+w4xfadx/xVCUeRXdL6RLGbH9QnnLBKkDF5hjzm0Eg?=
 =?us-ascii?Q?nAusVRdypchCnO+b46moB3ylEq/DZ2z6KDghMQ6F0nsTG5fNBaihbBsqK07u?=
 =?us-ascii?Q?97LHLgrUjtra+onaHzatOPDH4ejDELgAjP+ojxCVViQwv1Mn1YNjVyamOUTG?=
 =?us-ascii?Q?GO6AGpBsF6CDQDWoQxcZyxpyIFq9h1yXlDijj9oY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639c0b49-5ed9-43ee-9049-08db18f32c35
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:48:10.2759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IS9f8BfmbYT/DuBL7TOxLplkL7bDe8NOxfPWDP8gBy5NiNee2ehFAknN/Uc8bOow
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:23AM -0800, Yi Liu wrote:
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device()
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
> 
> The reason for the inbetween state is that userspace only gets a FD but
> doesn't gain access permission until binding the FD to an iommufd. So in
> the blocked state, only the bind operation is allowed. Completing bind
> will allow user to further access the device.
> 
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
> 
> Following this lockless scheme, it can safely handle the device FD
> unbound->bound but it cannot handle bound->unbound. To allow this we'd
> need to add a lock on all the vfio ioctls which seems costly. So once
> device FD is bound, it remains bound until the FD is closed.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/group.c     |  6 ++++++
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
>  3 files changed, 23 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
