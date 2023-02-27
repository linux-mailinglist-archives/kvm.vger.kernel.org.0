Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C811D6A4A2B
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjB0Sqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjB0Sql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:46:41 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB9279B7;
        Mon, 27 Feb 2023 10:46:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hs4t3/DjsLdpYe8AXhHOZCTLYiGnZuOw9nkPKxdF5p6HUr9zDiynTCtIGwO7sX5T43YRQ7OuJNz5bxfyf9HfyAs6ehctMDgJi1I6V9gkBABX6TlOirLDYGlIjwCQjJFBOa9kgVo/j5cc8Yzqd5fsR01E2ywrKaeu6uaAmmC4IyuTRHAVMp3BpT6IqXzhluny4rMXaiQt7i47mUr124RGzNPCIukaKD7x7P1Ea5hXufqghlHNegGgj6GSHmPM/M2Lr1gMjzbq2d18jMOll2y3K9VfwVdJaji6ze+QugSRY+LIRFaOIPWX0iNqfNXviCcIgLsduFJHWjlOLJ9Ku2r8Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgFW4NM1IJ3rZ5wgyb0Rzfr2nfNMh7aqvIUYlL+JsXE=;
 b=MC3X3cqwNFX+Mgg713g9XiW336h3PW5VV6wqe3KXJ5kFkAR0unbAwnDttrZJmK/yK45oHyssrzcLGYBdV3CjeTu3OAdqLXq3o3YWuBeTF6PTPPQnFhGqYFb48DIGwh8Pfvr90DokA4zKIxFcUPsZOV6RU0YrdDfoJWpcG1s+UjGdNbR7t8xb/UrLhHfWDIaOOydeCb3qmuycqbJ1LlLiYULXOEzinw1kxki5+bweoGhjDZ4XjA0s3YdsI2WbZon+KKO5m7PylTHN9oMKzhBYCurCduX0ZdXPLx8EDY6LA9kEjHmJMSjy9CUCbuN8lSjtxNsrjvKAKuN5SOszAJsybA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgFW4NM1IJ3rZ5wgyb0Rzfr2nfNMh7aqvIUYlL+JsXE=;
 b=m3O4pjJ0R8m4mJ3OZL2NHmuv61od4ETrwMOP5UuNb3kL30+ta0k/wULVTRO3UevazyqpqzPDVeiEZKsH5xYa8XQHcynThnyo//bRTir/NRR5Y8Swb+mCJFe55EC8GkRvPN8qxSH9mAIcrBoFXa6P18Ynus2pwrUBPJuB9c3V97OjYqcQU4c9njQhn1wHCsEzf8F6BWpoGOunDLgsCgPiIObKgZHbax2jknvpWvmSIEF64y3XkMyJhPwErLAdY9wjnX1Pz8noUT0XOnb19qD7lmuCIOt0h8+aJFfXVGHa6Megv0QF1MFsb3dS8SRKD9OrF4/x3+frodDIM5HUEtgxOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6257.namprd12.prod.outlook.com (2603:10b6:208:3e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 18:46:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:46:38 +0000
Date:   Mon, 27 Feb 2023 14:46:37 -0400
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
Subject: Re: [PATCH v5 01/19] vfio: Allocate per device file structure
Message-ID: <Y/z6jdYGA5tQqo44@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-2-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:208:23d::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: 74721866-daab-4f42-5a98-08db18f2f555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBGkK2LOxFxdO4per8pvaVeKWWFmrvBhjXnL/Q/ZB2Fa3CdCUi8sv4ybw5RKuvsmVD6g9RES1h7iLo0STxuNMs2eiuvv06JjxNwyDD8BWl3o3/vqIFH9rh01D2x6bhhpuYVBPa06Z+dOvTGcyRgViXi5VgM2TROaQrVbJM1z+diA7cAyWqnK5sVY/ATrrbGmSDlUWdmvLOX+bNcoKfca7sdoORiYlmSVR3s7evROBzwzvfszPr2wNst4Oydll4WysE4vF6LubLOYzng9x1NXkUJLagqSAWFXfOZk9xkYdQWO7WvlQyK9NUVjGIC9vzoBRd527QZz1HVaqGtW0Oui+HVqkjlM2Sxpxa9EYXiwb9Am2iwe/BhXQRGalN+l5Qa3Phb+2+Rpmwvu7awhzouz5DcBZLc5oPrvJoLjqkq3CMethObS6HYUq6bo6pAoMYzSt8s3wDpnVW+GVE9skT9IaKIlU3337r+eR8KriBLCJBWn9vhbMPbLSYJPqC2x3m7WiTfCq+d9LMZjZGUWcpRdLJsjfqjc9DTIvcWQdyav7oaLgB6Z9IXQsqIlo/vFncaG/bAfIblIfdBx346HfR76t5HzwTMAnzESZvfqFhdCdEEPReoYnqvDEdU0sgmXcO+tDHO03uLitO9p9wKoEP103A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199018)(4326008)(6916009)(66476007)(66556008)(66946007)(83380400001)(41300700001)(316002)(36756003)(6512007)(8676002)(8936002)(38100700002)(7416002)(5660300002)(86362001)(26005)(186003)(478600001)(2906002)(2616005)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nAagY6GyOSQm/whnAS38UHlRBnCxF4zu9LW7acIkolfIsmkqEKs+DqSeYxM6?=
 =?us-ascii?Q?QoxmAjn7o9yQIxuNqxurRRaOsHGBoc9Mp2XfhCfh0gY3pyiJNNEYCfTbK0lq?=
 =?us-ascii?Q?UjhphyxfqvyylgTkwHkLbagsR+CB7u/e1PXxSol36zEJQz6irJf+YuC+ArCP?=
 =?us-ascii?Q?h29EbZoMG2WgNUaX7KleWKhcyKhDK8/6RWWya5c7r7h5/Ie2wwemV6xteOMk?=
 =?us-ascii?Q?9FCopquwwcKoFbK/iZHOJOcFARk0bW9+FJWsR8ajRdOmITAcd6xATiZJU61B?=
 =?us-ascii?Q?jfabpIaMo11dXZbE/ZGSqGXVYEIwgsrWAFo4NuCVO4YpD7gGhWLF9J7XGcxv?=
 =?us-ascii?Q?iud1RQdY8M0pi6uXr5TnpI4qFC4fdOWsVMCtgiWn01SzYfzahht5nl2ca22u?=
 =?us-ascii?Q?KCJL8B9qaf0aJn2xPnn1fO1NGfbzNwy2aYjXIqlr+16tvjum7Qa0BSuoHwSf?=
 =?us-ascii?Q?eZBCeAftuoil6YDRd2Yt4vbXwCUliw/BeyvNlNw/hmSr/0uK48rnduKjQp4t?=
 =?us-ascii?Q?FsrdYmrUbJSxrmLLZbBi0gR/NvSpCClh7kwMP92sSCvnaQvZ1hDyvRUUUldv?=
 =?us-ascii?Q?k0Tv/6HeqIIQFI+zcJMh7mlXJZhI0uGI/xzeXdjVzqlV37CWHK3He00CX7/x?=
 =?us-ascii?Q?ujjVE8a6lZ/zJljdwu/W8w7cESS13TIRQRYPIV3rMG4MRYpoVDvpvpttmokh?=
 =?us-ascii?Q?LRnL74BcGUJnC9xJ9kC6oFBuX3I97yOLMlKX4PjxwtSKXf/hiqyBGSbifto0?=
 =?us-ascii?Q?zLqILx5FwNv6EzrjXgUbqPnSEI/1xcIaw6kX0mWPASFyXfw3Ok+ywutCjEoN?=
 =?us-ascii?Q?zQdksp1jXhz54IyEDjj+0i63qb+G6EF9rgZl3b7Up1bx5u0akNfAkKLeiLsh?=
 =?us-ascii?Q?zk+rznLR1cKlp26aM5NP5kRFFZMrzrw0vU2LzIORVz3ImH9Y5M1556J/t0Aa?=
 =?us-ascii?Q?+4rlHMpXGdJAmqYvtEhaEbacWxmUcNIf2lJvuNPWCwCd+2mUjuAuXX26YCZe?=
 =?us-ascii?Q?qDhzrSKpn+fvEXHBAhxf8/UHvYTq2yHDx0xGXTSPrJQaqOOM6L4v34letmux?=
 =?us-ascii?Q?794i1Q8g9psEjO8rOohxt7+POshDWBAkxIX69ZPsRVzvFolow9s+Y5OM6Ua5?=
 =?us-ascii?Q?nY5EHnItv6TgMzHRt8t8OC2/vXpNWmweNJ9qCYTmAeDxPSHKdRWMFWMNLEKm?=
 =?us-ascii?Q?sQKBqzwC6DW/s9TFNorf7JIF3ix1NdAlazMk2CsdVm62YqOJ9PM6ETlPwhrw?=
 =?us-ascii?Q?a5d4BC7U1QGW8UzE+46ftuVCy7Z9JMOhMWzUZbnT3xVVOXk4jFtzkbNpgMUs?=
 =?us-ascii?Q?xxEQNZeiJX3JCclHN6g9M0bkDDoNqn08i+uR5rkfw0it1a9HlGyXf8zYCrVK?=
 =?us-ascii?Q?nbOgHEpU8c/2Z/3Lu8AkvxCYFjF2i4xP+iQ0pfJgPSFXJpDqpolFRnv9T2Kp?=
 =?us-ascii?Q?PAvml/4bcXg2lq1V1Q0yxJL/MVMPpJxwKz3ticOLlis9CZ2ntY+vX4yYAPaU?=
 =?us-ascii?Q?m5+S5F1ESRkVeykjQGZIFSuF8ILIbybi4F5nuRbfp8GIVVk/xiB/jaNGZpJE?=
 =?us-ascii?Q?yxmhev53LBRw5yu9/jHYdWkP6evtkWa6EYRme04P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74721866-daab-4f42-5a98-08db18f2f555
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:46:38.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bR3oBov28QxpycpviUc/DCvadTMf4HnQHdowLCAGMY0/ESio0HEs+2szD639NHSw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6257
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:17AM -0800, Yi Liu wrote:
> This is preparation for adding vfio device cdev support. vfio device
> cdev requires:
> 1) a per device file memory to store the kvm pointer set by KVM. It will
>    be propagated to vfio_device:kvm after the device cdev file is bound
>    to an iommufd
> 2) a mechanism to block device access through device cdev fd before it
>    is bound to an iommufd
> 
> To address above requirements, this adds a per device file structure
> named vfio_device_file. For now, it's only a wrapper of struct vfio_device
> pointer. Other fields will be added to this per file structure in future
> commits.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/group.c     | 13 +++++++++++--
>  drivers/vfio/vfio.h      |  6 ++++++
>  drivers/vfio/vfio_main.c | 31 ++++++++++++++++++++++++++-----
>  3 files changed, 43 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
