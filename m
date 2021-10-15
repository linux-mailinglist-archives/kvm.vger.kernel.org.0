Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E13442EFD9
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhJOLnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:43:08 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:17792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235398AbhJOLnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:43:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBfT3nW8CY+WejToH5sLj3cKdMbA2k90oiTRb8WAsOqtjajLBvLWENitGR4RlZo93Yj1R/Tjeflt/nDo0lf+HvRcAmZ6q8U8gaJs2doWDt88fXfEjsLtNXukBJcmbfNYsDc8KyszpVLIbxCAFL5HNGry9OARxzIj78DFtKceJJarhYrRxzAjxCFW2k83R8j1JKxXV+uhDVRYteMv4ra43f4AFVw676TLs+Pq+ve279s9CEq0orgD+FKWa9/HU2n6E2q2uydozGTf+FVQx26Dvj04qHJBMcN5kDT0KozfY6rCpGK3GwYQHGTVEQ6U9XQPhIT2bOQvkBPYMbCIlbaW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9g5FMABlujW27UUJ74JJH74eoojesz1v8n6j0XAJIY=;
 b=IUbA03BnXTI0U2p+z2kACm1v9OJ092Jj7Ha36iiafLZNERIfHf/JMkIkoUrcuu8NQmkgOwd8Ppp6TCSnAFR8IMns4PEA36x0x1/HCi0LidlujHbpF7sDHX0hCP2mZ4G3i2b/KLZTEFRW8oq0C5gYQpydAoL9IHr1FbQTh0RpEf9zgAyxe7mhXHSvtJQhkm9f0ZzsjlGqqbXc3jK9BfBK89QSl+nal/WZLFCa/br/awkaRDq9EUwsgBi6RiG+8RQ0QoYHkI7NIfOJlYwTpY4S/nASj9msD887yRP9cXIXS2gg8pR5lCzdf9BQq/BvGR7cACpd6IdpaUadGtaUtEn3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9g5FMABlujW27UUJ74JJH74eoojesz1v8n6j0XAJIY=;
 b=PHVrIgyJsSa5bvdcO0pAtwMRsfEWNcnuHou0Pt1E+NkICibBK7NdiwyUWTrrkqshsdkVE6LUUyevsMGJIAo12CH0sO5LRxyaSY7PomH2x1Zmm+5johv/ZHBwzY8EVrfwEgONxQW+n9aUAXZkhQyhFGorqWmIcLZreewLiQQxs8Z/N1EzWr+n0m0REs+W+OKGpQIu46Rcon01cb3CY+TKrHn447Km3eWS29GI/rdx5tdsGRhbquyQvnt9SiRQElJZA0/r1Jh3b0JWnfaA3IuRw7fS36aKBaBZc+BZzDwktlAo4V4AFF1Zr9QaF1Fg4qCGv/bF/y6QxVZlcwBypsHgEw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:40:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:40:56 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v3 0/5] Update vfio_group to use the modern cdev lifecycle
Date:   Fri, 15 Oct 2021 08:40:49 -0300
Message-Id: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:208:15e::48) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR17CA0035.namprd17.prod.outlook.com (2603:10b6:208:15e::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 11:40:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLa2-00FJU4-45; Fri, 15 Oct 2021 08:40:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7a985bc-29f6-462c-ec5c-08d98fd0a6bb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5208CF1C26FC3528FDD953D4C2B99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +oiv3EKVs0Br0K1edbNViRC5LzPcoM3w4FThPZsExZSZeGgyxpqgyDOwrq72ml6simYCzxtL/fUu00+tmKrqdf1dPOOlJLPO1mvpwZUwiYPLMXr2clbytYo/Osx0lIjnJUYoKHvzhMsYLMcDa0rxFGfBGEmtX1c2vDkM7t4YwaqwCErg8gtLwtVE+eM2Q9/Kww0QqQddV6tapiDFt1tWAWAaW63EE+dfxZ09kShEq8VVh6BVEcmzOpb7s3hWjbqvHITvUQw53DXMfEkS1wg7m4TSxeul4yCOvvMYWV8tPEr+3umo3+jSJ32SxHNuswFpOs9L3tvY7s7eiz2zTTlaqrDOP9hxC8So9JnQl1nGCC4Bq6YqNrvfNhBpZcmSiEhSP4bH9NYf79+QncOvBOWJ2eRhCCFUVTHQHkW8kGzfIuuGL4XLGdPWQjYWDUbZpz25citmMMiL8ZL8ovCBwdvBaVyEpCnSt7weX2VCK+GBpVj7zgITEXXhWs8A6YHlKFIYA489v/eynE3/Zvk7DaGCSQyra6YI+5Hh10C8w12b9W3yO4WHcdS5gINi61ltGLhpWsIg3TvjZcfU0EDYmbu/khjtqLbpwGytQZnXAa7x6dA7pujQOoYmi47y5qLZAcUoXXFPTWQHn57IDvzLIoDgcL0XCz9jy8BnaqfrfL9zdHhcFl6YfMlxeOsQX5xFJVDN+4lD662vmB/cPE2fVKBFKEIxo5pk+pWWTXVxoOU/bII1xd43UnE9YwUF/4qLJB+mxOtgdPVrrN7v4yINrS9/RA9vbpQh1W7kZyn31cJevMGu3xcdX/DZUEdQXYWJQMoy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(38100700002)(5660300002)(8676002)(66476007)(966005)(2616005)(83380400001)(4326008)(2906002)(426003)(36756003)(508600001)(6666004)(86362001)(186003)(316002)(110136005)(26005)(9746002)(9786002)(8936002)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EcKuPlb1Uo44zJZWGGnenqUBG6h4EAxRBNs3XsNvepzqvbnK7sOMi3mJQupD?=
 =?us-ascii?Q?13iZgGLWDVdUxsnuOHijjEZAXkhHcJsg24aSDcxjsMSAbW+YNj+HFN5esneW?=
 =?us-ascii?Q?ayhij9zlWJp88fEWEH/czliwaP6Zr1gpdt7E/rfmKSWWhICgPLEd2ETzL+uO?=
 =?us-ascii?Q?moaHWYRFHXPIEX4Vc6G1909Iqup8L0qVrnQOs82rrr4sLCRUyGNxGnbdW8EW?=
 =?us-ascii?Q?6rj32sn4xScM+Er4XHRFrwodQH4uSlfvyXcw571ebEe0LQ8hK6HG7gLDpNDY?=
 =?us-ascii?Q?m7kdSM/Fmv6jV8sIFlYnWzcl3MWduicGiBrwDZx6etZKAdZKpaa/f0d5+8AT?=
 =?us-ascii?Q?myudRa1qWgcP60riOkkBTpLwel7ZiDeL224/9jR3xplyYhbxLlwbLjbUXBtz?=
 =?us-ascii?Q?8ZhSl95zv7+YCK5lr7qS0AbtRzKNRR+ML91NAbZF6lVZKJ/lJdbW2qUJ2JqT?=
 =?us-ascii?Q?YZEwScqSx5f0muAMW7hwrYMPBWCWPC1PhnW4k1jGVLv34KRhpxV6FPcIp8Wd?=
 =?us-ascii?Q?ORikNYJHO2oB24ihMAeIuyh9+CZTPFYjjz8Kmwqn/Jl+Dhb8nnZWbjX4Slnd?=
 =?us-ascii?Q?yDHoxaI2hLbbbkagf49XNRGsbraTpz2/4hWHS7ypPkzHZsYiU9UWc6k0OFHS?=
 =?us-ascii?Q?5+13Cn65PSpAnCiwTw5Yu5O7XdypmWTN8np8mNnbSV2KVNLMIUlIERQuld/8?=
 =?us-ascii?Q?M6thlh1V5VFzRMFHyRJRKWt9V83QgOSk+6ZMO3K87rFcVN39L64hMywEK5jr?=
 =?us-ascii?Q?qt1/GxrHjLquA6AhgxSQ1HqoVi3nHOfULkMLsquMbNqFRiCAe68DnK45/Hqs?=
 =?us-ascii?Q?F3CAmCr1FXZCKMSfilCuT0jVRWpCyp4uVCkdZBw4JBGFKDM5k3N3slddV/cZ?=
 =?us-ascii?Q?tlN/H0MEPrOEr+siWeq7Glug8w8zgTfhVa0k9UqYL31VeeYw4iz83N8VQjSK?=
 =?us-ascii?Q?aIrJIZPOVQ2Zcx2dTdovjFJuP1nir7AQ4w7/yQnR/WCxkwu0tmanx6zRnCio?=
 =?us-ascii?Q?cwTvmb9NVllFaLWelCg7+WK2tM+cCEaXniI5TTwFaBXvPEWBxJeNd1ahexuY?=
 =?us-ascii?Q?5R0yhO7N61pkJ7J+k8gbXNexzzTGgEKX35T5f3q5GVBZ33GaSAscPqXRgILU?=
 =?us-ascii?Q?5XisQjaQR2Agc12RLv0NLUzX8UxiBEFdDxXMyvtmoKQVkYRZY3VkUvu61K/Y?=
 =?us-ascii?Q?CWxBXy3aE3tMlUvHh32BL+rfLsy7SLwavMWiZXs+O890OLqFtYJsEUFnaf/s?=
 =?us-ascii?Q?ZMaGgUY4yxhp5KU+gYsabSCQCG1S2Vk/h+EmRZXxqxTH4NC/RELel7wK5U/H?=
 =?us-ascii?Q?WXnu8MllVQDzxgK9BPyxQijq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a985bc-29f6-462c-ec5c-08d98fd0a6bb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:40:56.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dNkVDf+OEW5wnVQhXWqcgmee4zvGtUofpHyMrVpJqUgKBSF8hqtvdXuRGSS9pZy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These days drivers with state should use cdev_device_add() and
cdev_device_del() to manage the cdev and sysfs lifetime. This simple
pattern ties all the state (vfio, dev, and cdev) together in one memory
structure and uses container_of() to navigate between the layers.

This is a followup to the discussion here:

https://lore.kernel.org/kvm/20210921155705.GN327412@nvidia.com/

This builds on Christoph's work to revise how the vfio_group works and is
against the latest VFIO tree.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_group_cdev

v3:
 - Streamline vfio_group_find_or_alloc()
 - Remove vfio_group_try_get() and just opencode the refcount_inc_not_zero
v2: https://lore.kernel.org/r/0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com
 - Remove comment before iommu_group_unregister_notifier()
 - Add comment explaining what the WARN_ONs vfio_group_put() do
 - Fix error logic around vfio_create_group() in patch 3
 - Add horizontal whitespace
 - Clarify comment is refering to group->users
v1: https://lore.kernel.org/r/0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com

Cc: Liu Yi L <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (5):
  vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
  vfio: Do not open code the group list search in vfio_create_group()
  vfio: Don't leak a group reference if the group already exists
  vfio: Use a refcount_t instead of a kref in the vfio_group
  vfio: Use cdev_device_add() instead of device_create()

 drivers/vfio/vfio.c | 381 +++++++++++++++++---------------------------
 1 file changed, 149 insertions(+), 232 deletions(-)


base-commit: d9a0cd510c3383b61db6f70a84e0c3487f836a63
-- 
2.33.0

