Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AA773E1F3
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjFZOUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjFZOTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:19:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD0F198D
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 07:18:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/TozsJTqcMKGsqujNHpGxTPRZHb3yePPWF1HhrIUSS94qOuAfaxTK3WjNoZ74Bg9hQlZ+IpvJwNMEPHwM+q0UyCWtX/YGyfXHbUi3x47eCP1Bi0Y6EBWUssprWpda6rVvzyZ9/vf2z+E6L4RlZgN18zoNLSPaTIC5cEyEV5hqBnjxh0eD2FBZL8oeIcSdhdOwMF7NwfbGUXMge/nLjQ68CJHSl9wHQbHMLDhXgSR9iKOqeOO+gHqzn0IK/iDgNLeN7OQCnLiK2a/VQfYbMYEVkC0zCmhZpjTDoPmwAbnJHJJslx4zKhsWoXog0+ilZiZ0G1rF5BokpulwN6opLvYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KGhPXdVOkbm0mOyta4z7HMQab09++hiBaq9j0vDfbQ=;
 b=ZtPqkaKc621Ov31WkLAHluqZo9XHcI9qHpuzIZCYBo1c6hX/VFlr6yTPUtgeAz3lvvg/0vX3OvhMa26ZeKOxnsGBxWNX0NHoHJojgYoUOl2MOMbtWe2sjZoY9xYGELLMSSZEDcIxyWD4LceL4lpMEdKCE5lvebvxglx1yQ/01r6rcHb/53GJu0hue+9o7TitaPe4W0F24tySFZlv08LNvkI0Y7ti3lW2NBN+xzqiGWBtAc2A5mkT6IPvt77lwK1bWuXZd426ma3iXNT5AQ4IeFXn9S5WpJhPW47dCW0c1Umrm/jim+ugoDdL++50aSD/kAhqeCqF1nbZqbdw29/qKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KGhPXdVOkbm0mOyta4z7HMQab09++hiBaq9j0vDfbQ=;
 b=S1W7L9luKiOzKSNIo/uJx2vWb+Mk9T6VeyXar26J82bTSY/DWWAYeia//WaofuPA07YyX4GsMqXtecLPuxzOb83gvx3xjiJrH97xxmepl+awy80FcThZA3PzCaXErQhgueJQ+onGpneriSp8xcpooG2yUgEn4ZiNIQF2uR9xi3reMXRdUA8KI6SMzOzg+n1XEHFio94EcycNM6l+i5Y8s77NNiWBARXAcr3uTI2gBjWCQDHRBWOnPZduR7sN80slfAmB85tPYgwoFIQVqQe+9TX+Gc8w1KAw1trcvBT11lfWANMAFRuDM/FFlWpekTvo+GJhRLx/NuXjpETLAJCS0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB8596.namprd12.prod.outlook.com (2603:10b6:510:1b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Mon, 26 Jun
 2023 14:17:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 14:17:10 +0000
Date:   Mon, 26 Jun 2023 11:17:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>, kvm@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: [PATCH] vfio/mdev: Move the compat_class initialization to
 module init
Message-ID: <ZJmd5ZXQFshE6F+0@nvidia.com>
References: <20230626133642.2939168-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626133642.2939168-1-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0310.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB8596:EE_
X-MS-Office365-Filtering-Correlation-Id: e64aea56-6ff8-4277-f4a5-08db765007f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L++FvPl8ZuqSlTjkHnLyoaxgKMPEdqoNS+1Gl8aTVfufFjbeNbiMsCwdpN7UG4h4lVVli+zMG0fZpumumJEjvjTiwMmecy6ScSYBPyj8sZ9FTats84YPdaS3NSRDI7y98CQxQleZp3FAKTno+b985IDrW2ZaIbh/8yI5mjqw3NQeH4JbZ396eRGZlh8XivMBFlrIu6QpxAz13jgIUDSgH6XXln+sqOncPlh56vrygPBbYQex694wwawCy4e3cmL6r3cjUl7SF0ZEUiOYaNlcIymk0Cm5VZcx0geq6HuZC+gxAgweChTzSbrvWMp/yHZLEya4Q6W7eHlFMwymBqInA+DoErPQQ5J3kdc634kP+R8Ghk05i60lA56Gy4U5eeM5pw275PEUmC/F/IIVg47wXTwoTtDQmbqNnfuYu1anQK1sQk6QxOAjAQhLXmbzXwLPgee0qvyPahWgqXZNWlTw62bnOJ4/DdnkVHR6yJluZ/hj3jfUNW6/EZroFHn+CxRAEF4NUnyq1Wd1HpTT+KoKObl370b9xpF5EisUCpiHvwCaNRx+mm/UqY62e95trqN0Fx7vGCBWlWfm3h5XN/h5gsuiZP5IrdvDat5HXZL1dUo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(38100700002)(83380400001)(36756003)(86362001)(478600001)(2616005)(54906003)(6486002)(41300700001)(66476007)(66946007)(316002)(66556008)(8936002)(8676002)(6916009)(6506007)(6512007)(4326008)(26005)(186003)(2906002)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8zFNZnDtYmnG6sz8LOBHmXZduT+0Mi9jS0tQJI2ioDtUjgGbXysp4X8ot+fV?=
 =?us-ascii?Q?EsHf6y6yVOlxUneLI279spYQO8BFN4QzI2XnRz7mymwfId3jMp7aWDaaYQhA?=
 =?us-ascii?Q?D/XXwnfLAzGq2Ud7H4RlXmvUjYk24jdeG3dcu0XbuK8W7xoougLp9CY4I1mU?=
 =?us-ascii?Q?lobKrZOCFk90yls9Sj47kFdUk3h0YD7ClrA/w48LDeuKZhGPo4As4fkGww5G?=
 =?us-ascii?Q?NOn80LXwZ8XGxVHkJs3xTpIBaxO5Xk/5hSD09m6MeZw0iCAqjPxUwR9Z17Ue?=
 =?us-ascii?Q?MsDC9+YYpmY1mTme87amIW6+XcyydHA2gBapyaxbswjS3HZHlB4oz75c2vE2?=
 =?us-ascii?Q?2EfYaMfMsxXRn0beuStPa2MbCMqoStpiplegSdlgvIvAPJOrBuqid4sANkTg?=
 =?us-ascii?Q?xitZhJZ/qoXmqvPDVvZYdFPGgpWzpAZEXko2VkwbSIKZ8JP4SCDZWS8CCe7i?=
 =?us-ascii?Q?kX/4fbTBuZIkvlpZzjh/YiSCo76RehpEYT2dEX3D+BPWL7F4lEjNT16SUIa0?=
 =?us-ascii?Q?css2vgEdQdyC9nJUPXyhSSZPH3Nx9irQwQETy4YKDb7KmoLbjerBRnxos1Ar?=
 =?us-ascii?Q?0IR/L9K1NgrlytE6JkiKczv9aw5nRnUsWidJu6kfqgn7flmsDyA+PykXEwwY?=
 =?us-ascii?Q?1wJ7w4va7d6P94vxdTkYM2enKlJABt4xVxfB65LrPKtxSXS5vBlWXJsW8tbn?=
 =?us-ascii?Q?juDC8uqvqYxFBEsKts3Ee/bB8XdlL3DezeNNiX0gcjoP4O6N/vyrO/64B4Qb?=
 =?us-ascii?Q?nR2zbZBpDN9IHJkeSloa4WNSifDaC5hGozZLQSfs7SPHtV0BsSe7q7YR9l+o?=
 =?us-ascii?Q?RKk93Y/8j8vYscwmCcUyNCIx9n2DMdGTlteMmoNq3mlVKMicd4ncNanYvAmV?=
 =?us-ascii?Q?hL60lb7inQFTCBSZqTaw7jaXxUtVSBKbTSQu9jhpOgnxtnx8YQTlSVDrLqCc?=
 =?us-ascii?Q?qSaTmOjAqIEXI38Eag+royg97UZD1aErDVwE1HxzK4ny39pBVEm1qkKbv716?=
 =?us-ascii?Q?IBS/Hby7f1xLRVr5pu4jB/6Kbs52wkOng7BIQZp7e1kG8TiHcBlDLyUTC4H4?=
 =?us-ascii?Q?ucxcbOQdS5hsAViEgDicRvqiPqkPGpiakSyh7g79QqVcGsYcEJqFpsSLsDzj?=
 =?us-ascii?Q?ZGWgMfspCgGj/bSz8ylBldVF53IyBnLkVVjkk4i7zOFUFODnAFi0lkRKj+DB?=
 =?us-ascii?Q?WRl6z9YC4JX4jgDtXHAdhCkUh9Zh6jaOCvLIgcXwsuXbGpOWuY2dgL8ICpUU?=
 =?us-ascii?Q?t7bDjxjxPCL0AInPJmB5KXy9uPAKglztLHSPJp1eP+SH81CP3rLEQbuHh7fR?=
 =?us-ascii?Q?YQhF1vZBFWZfg7FvkmunGscc7ifA6kzuj3j500hYuu9uEINu1CK3ctpH4mSc?=
 =?us-ascii?Q?gxyVD32I368kFcNbpfFMuI/K1ZZwNqDN6HCA81ZWkAwtoCNxo9L8MSdxXaam?=
 =?us-ascii?Q?8lStI++vYX9QSxr0NoGwwCy/gaPFg151WuK0ZAHvtigIp+bk0ae39Vh5rIXA?=
 =?us-ascii?Q?YgYfNCqcwqEIOvYxFckBCHeTPWBH8kmoAXEUV5MWBPtUagTtRZsXdjyxxTd0?=
 =?us-ascii?Q?NSjbBheUIg8t8U8GkiZxvnSs+oAMiOf3gM5zvBZ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64aea56-6ff8-4277-f4a5-08db765007f7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 14:17:10.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VEOxV6A0UL4RZPF2u6LBzvdYxJat10xGOZXy1h3OUDakBVauiivQi4QdKMZgOH1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8596
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 03:36:42PM +0200, Eric Farman wrote:
> The pointer to mdev_bus_compat_class is statically defined at the top
> of mdev_core, and was originally (commit 7b96953bc640 ("vfio: Mediated
> device Core driver") serialized by the parent_list_lock. The blamed
> commit removed this mutex, leaving the pointer initialization
> unserialized. As a result, the creation of multiple MDEVs in parallel
> (such as during boot) can encounter errors during the creation of the
> sysfs entries, such as:
> 
>   [    8.337509] sysfs: cannot create duplicate filename '/class/mdev_bus'
>   [    8.337514] vfio_ccw 0.0.01d8: MDEV: Registered
>   [    8.337516] CPU: 13 PID: 946 Comm: driverctl Not tainted 6.4.0-rc7 #20
>   [    8.337522] Hardware name: IBM 3906 M05 780 (LPAR)
>   [    8.337525] Call Trace:
>   [    8.337528]  [<0000000162b0145a>] dump_stack_lvl+0x62/0x80
>   [    8.337540]  [<00000001622aeb30>] sysfs_warn_dup+0x78/0x88
>   [    8.337549]  [<00000001622aeca6>] sysfs_create_dir_ns+0xe6/0xf8
>   [    8.337552]  [<0000000162b04504>] kobject_add_internal+0xf4/0x340
>   [    8.337557]  [<0000000162b04d48>] kobject_add+0x78/0xd0
>   [    8.337561]  [<0000000162b04e0a>] kobject_create_and_add+0x6a/0xb8
>   [    8.337565]  [<00000001627a110e>] class_compat_register+0x5e/0x90
>   [    8.337572]  [<000003ff7fd815da>] mdev_register_parent+0x102/0x130 [mdev]
>   [    8.337581]  [<000003ff7fdc7f2c>] vfio_ccw_sch_probe+0xe4/0x178 [vfio_ccw]
>   [    8.337588]  [<0000000162a7833c>] css_probe+0x44/0x80
>   [    8.337599]  [<000000016279f4da>] really_probe+0xd2/0x460
>   [    8.337603]  [<000000016279fa08>] driver_probe_device+0x40/0xf0
>   [    8.337606]  [<000000016279fb78>] __device_attach_driver+0xc0/0x140
>   [    8.337610]  [<000000016279cbe0>] bus_for_each_drv+0x90/0xd8
>   [    8.337618]  [<00000001627a00b0>] __device_attach+0x110/0x190
>   [    8.337621]  [<000000016279c7c8>] bus_rescan_devices_helper+0x60/0xb0
>   [    8.337626]  [<000000016279cd48>] drivers_probe_store+0x48/0x80
>   [    8.337632]  [<00000001622ac9b0>] kernfs_fop_write_iter+0x138/0x1f0
>   [    8.337635]  [<00000001621e5e14>] vfs_write+0x1ac/0x2f8
>   [    8.337645]  [<00000001621e61d8>] ksys_write+0x70/0x100
>   [    8.337650]  [<0000000162b2bdc4>] __do_syscall+0x1d4/0x200
>   [    8.337656]  [<0000000162b3c828>] system_call+0x70/0x98
>   [    8.337664] kobject: kobject_add_internal failed for mdev_bus with -EEXIST, don't try to register things with the same name in the same directory.
>   [    8.337668] kobject: kobject_create_and_add: kobject_add error: -17
>   [    8.337674] vfio_ccw: probe of 0.0.01d9 failed with error -12
>   [    8.342941] vfio_ccw_mdev aeb9ca91-10c6-42bc-a168-320023570aea: Adding to iommu group 2
> 
> Move the initialization of the mdev_bus_compat_class pointer to the
> init path, to match the cleanup in module exit. This way the code
> in mdev_register_parent() can simply link the new parent to it,
> rather than determining whether initialization is required first.
> 
> Fixes: 89345d5177aa ("vfio/mdev: embedd struct mdev_parent in the parent data structure")
> Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
