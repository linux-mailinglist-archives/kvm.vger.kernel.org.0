Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BDC5973BC
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbiHQQHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240655AbiHQQHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478809F1BC
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTFmXJDkyEzg+eRkFanfaYgWffouKjkqe8UKefyqEEF/lWfBYoBCT0qWp9IqSzzVI1EiJs4NNyAh5w5BSqA6N0l0Z0r+11glHgbD5JKjkxO7ly+A2Sgp37T5NI7MDf6/DF4bbHlVnnpcR8o+W7Y8msccd1MCjO8ohKolCHwcdlUidp37plEYTmRn0EZeG+N9UyPTziR44kaMpCWZE785mK4M92TPr7wO9NGtg+f/ZFAWWIajaRd9Uj3FkDcaVDPOsk7wC4qAw5b+FR36fFWsq2dAjKRxwIKWO43Ogt/ieLHrgjK43wp/7iD86DdFrv1Br98FOWOn/CzVt8vdSRvoqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9BqQ8hDve7ZM/mPzQnh9blZhGcnenAyMwG6vqm2Oyo=;
 b=HE43ZKU9fh2B0AqtizCQRAJNnfVGN1ptE9ujlj1CpnQnS7TrLazMe9Yw4JveBLnHj/OGXAe8aqP16YPWk0KDbmx9UwXahELn7grt297ZQIJMh8coQmxBIGFGa73rQoms0G4DYPFtuFaECtK3J2hdVWswXH17BA6rFcCD1ThZSZecHLy+5XuCoi/Xh2BVRNjE88or2phj9Xj7VOIDZ54sxPiEN0u/FmAThvCYx5AbGwClC91QUWpZJ7wXjMZvsnKbvnvyY3h6PNoBdL+/4wkQLI6Tlj2S43PcomI7iNdSTWX9Tb1HzIufE2fJwc0MIGM29FiILlULbFazoczxvQ157g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9BqQ8hDve7ZM/mPzQnh9blZhGcnenAyMwG6vqm2Oyo=;
 b=ENRzqmXU6wnjjkoxDAYGDtPdY0HuS+WiW2CESN5ut5fO7X960pifCoRWzl14Ax9Ft5+O7628KH9jxvPnnR8Rms82eUdf82g7LoM60MfyTZohithkHSwd3lQmB+dGAGxJZ75zEzSE73WYQeTCJ9X6vayCjL7vRUYHJRBAgY4LwVTeh6zOb4NnfWyS7OCkn9poWAmOMs9QDeKVhbRHA4YVbsIFNIC59teR+PLo99gM8mjBgHKZL89k4bE1jDkeaUrutFNcTke+7eohFrpO4lUMZkN76IIW+jqV95s2/ck8d3ecr/OhCnFPSOnCGyM112tPlLNPmcGUyua02g4hUUjFuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:28 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 0/8] Break up ioctl dispatch functions to one function per ioctl
Date:   Wed, 17 Aug 2022 13:07:17 -0300
Message-Id: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0066.prod.exchangelabs.com
 (2603:10b6:208:25::43) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a83d36bd-8bc4-451b-53ad-08da806a9455
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Mv2uSE0fqtfHCwXQOo1B4iJ4cnm9w84bIPmFieZ7Ro7NwWpezdjKFbb9EdWjJj5+OqUD8FjS0qvODaBwiPQYfMn+CbpFNUYkDQ8ydgmQDF2ABgxcJ4QRNNqy8mosH61ku2rY366hbYpS7ONBIc0e7QSfWf0AYI0QbFAzNTuzbgLB9JIzp1ewACaDSjgYnRs4rX7AEqBXVelhng44EhOUl7fKIYhheG1xt+LQqGfQEIat61kZsPggFH9l1gzFSngP7q30PTt7LIqMhmaUx6G2ZgXP4KtEnToJ6ZXJr/cVefcn0SCqwmPFd4vkUMVKL9QfgxzSuE6qpuOylThMfLBQIGRbmu0QB1apkTnCIhJUA5cdJvziWUnJkJjRjE/h7Uij/AdC9iUYNpCnnGrHUduYbFybytWXE3t4yYKCaEoiFm1gp/qoOd/C98D2X04YeshOyUH9oZ3fgGOfdsJRZjCA9QwYZR99X3TC/1ccebnKEY9+F+L6YshW8zbnJ7osJqVJEKmnhmpX57jo1PbkUDgvztLaVUYUQDE/5ST+myQMO77EXpgQgNGF5m2xo4hLR9M5Zv/B9CGH91RcOM0UFpE1Pc0c0z9zLU/0/dKCfqHI9iII8/NcY/YRwkrK0XAnLoBSrazfwzWC9cPCVdUFMlxAxGoy9x7FukTpytaXQ4AW7sS1ERKMASuqkatRt9fPt++peFuV5vXs45iSQGZ2hsjfxPI4tL8X9tU/aN1eEaagzDVOHsIY6me3aHg11cJBp/yuxcIvkU55LWl3EeSeJ/xHB4X965M45DWtd3ardTEj6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6666004)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ix7AFyq75z/2tcW2iae8WWVrh47Jb7KSNRhFdPYer3S9BAaKJlO2HEZmtaK0?=
 =?us-ascii?Q?7xYTH4l2XKLI93v7ctZS/bX5vk4fLQCCglquMNyFulA25p7TFmr1Rkp+AnqG?=
 =?us-ascii?Q?hvC+zUa1LRTVtyaKm02uxdlRnCUZPfYemOJ64u4of97KBpgSRFAjayGr/okg?=
 =?us-ascii?Q?k0U+SLXVYU+oGsL2wbmld35+iRR0+K3fliPOOSmRNrwwvCGhzsrbx07Sz74C?=
 =?us-ascii?Q?dmJKMe25X1zKS1tCpqiPOIh0kTKMSG97RBHwTrNjTiY7NDVnAv5FyUmJz9ir?=
 =?us-ascii?Q?/6wNGu+J1Bwva/t85wkTmRXs6v7UP7Iw+Fd01JMXh5PUwvzB7WFspG0bhCuT?=
 =?us-ascii?Q?PMAj3l6fb9gQqKk0Gs7DUt+o4KnAmEYzHyL6vWzr1alJSwsyHaZoOcYLSwtK?=
 =?us-ascii?Q?7scpv6Del9tGIHEmLeGY41MsIKb7QbjiOXOEHhlR+3Z/3tzOhZRsVaiAgRbs?=
 =?us-ascii?Q?lzknblpqdEWr5zLTv5g4Jpr/grkbbswLtu1ecX9z/Yrl8lFqQYV28T35USGi?=
 =?us-ascii?Q?JmNNv9G7ZHzmYibDkQF+Vj2EoZyMQr5t8YxUKvJFECofx6MX8zXG2jymkLw9?=
 =?us-ascii?Q?5dK6qS/7JpUd1qcp75RRiPjpg8BcQNUYT80sK5HygCrofPr/HFQyF0LpFY4v?=
 =?us-ascii?Q?f03jS6XCUhe3idfWxAjmmFwb2fnBUvwKToFgZaa+NPOD2VNQE7krZFnRnDBb?=
 =?us-ascii?Q?ybjTp9uP3iovFhzBGh3ZEtsaVGruYrk9g7voxsG031q5qwCe52Gc94NR4id5?=
 =?us-ascii?Q?53EIEOR9DcBM9ypGA2ehX7Og/G+m+OBwWtCY+rwQgNscKKPsZlPvZapR8MXf?=
 =?us-ascii?Q?LS+OAZXpE1g7Gcblr20VXU39kSuUHmIO5x/a4eYyXLvbedIIVttqKUqQgPSy?=
 =?us-ascii?Q?7IvccDBvREAt7DUiwu2jPwb0VfsLPTJIAkGG8X815BZr6p5mDX/YsluRbA5G?=
 =?us-ascii?Q?DXklhFYcx8vckVLKy7uaIuiDphw2wNA2H3aYVqm3IirnqmsAx1tYtIKCuyFm?=
 =?us-ascii?Q?MbFdQ+XQK0xwfj1GSXe8HRGbzHOcMySovsQ1+y/HB7TezDRLgogFQBuRh5NZ?=
 =?us-ascii?Q?fZYVNlvoYFRy6Cf8OQWIgP5nwS5Q38qLdwffVyS2hExneWy0REIQ0/3h156b?=
 =?us-ascii?Q?i6eJskxmmTPLQOpIhAf5MrIdFxDZgOGgGtlKrySayrOumF6bhc2h66cF5ZN/?=
 =?us-ascii?Q?0Vq9fUN3Q7bizqQqYvxhM3qwNHmVL4sOJKsmlol5gMDg6KocM22BBUUXpERT?=
 =?us-ascii?Q?Ocm9SeXDzncxkpQk66BYJAUsyBEsg9UWPOm59T+8XyLyGsvzmkN5OvSHBZXp?=
 =?us-ascii?Q?/7XNxkZiB5/+szi8D+YrthgxN8PnU4UcfD4yCWW6ebUL0Bkgp27c84m/yQem?=
 =?us-ascii?Q?lHzt8V9hEPQFC1mN7XwAbEi/g1spyhRERl0spQmOEaKt9tTPicNlHClPHqrz?=
 =?us-ascii?Q?T7cgHwthAXrI6EqSWPBJw5RfxTjHb0P1/QAxLKnk2rZTPzYpPk6EVLYK9a+m?=
 =?us-ascii?Q?Ah/O17NSv9GxzhA5dnD2nM22JMJW47givFtAHRLCWgAjSbv2klOdJmMiCI+m?=
 =?us-ascii?Q?ZJgYRAohg2Vnh73yovwctE4EZSu16L8CKmFiyZ9Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a83d36bd-8bc4-451b-53ad-08da806a9455
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:27.0323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTL10bFyVapm0qJqLF5nfDeL8SGN8BaQ9rNehq4T/gVABle8dZwY/xmGD7x2AxvO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0216
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move ioctl dispatch functions for the group FD and PCI to follow a common
pattern:

 - One function per ioctl
 - Function name has 'ioctl' in it
 - Function takes in a __user pointer of the correct type

At least PCI has grown its single ioctl function to over 500 lines and
needs splitting. Group is split up in the same style to make some coming
patches more understandable.

This is based on the "Remove private items from linux/vfio_pci_core.h"
series as it has a minor conflict with it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (8):
  vfio-pci: Fix vfio_pci_ioeventfd() to return int
  vfio-pci: Break up vfio_pci_core_ioctl() into one function per ioctl
  vfio-pci: Re-indent what was vfio_pci_core_ioctl()
  vfio-pci: Replace 'void __user *' with proper types in the ioctl
    functions
  vfio: Fold VFIO_GROUP_GET_DEVICE_FD into vfio_group_get_device_fd()
  vfio: Fold VFIO_GROUP_SET_CONTAINER into vfio_group_set_container()
  vfio: Follow the naming pattern for vfio_group_ioctl_unset_container()
  vfio: Split VFIO_GROUP_GET_STATUS into a function

 drivers/vfio/pci/vfio_pci_core.c | 800 ++++++++++++++++---------------
 drivers/vfio/pci/vfio_pci_priv.h |   4 +-
 drivers/vfio/pci/vfio_pci_rdwr.c |   4 +-
 drivers/vfio/vfio_main.c         | 134 +++---
 4 files changed, 480 insertions(+), 462 deletions(-)


base-commit: 05fe7731dbd13f719c8be83e9ad6d6a7b119d301
-- 
2.37.2

