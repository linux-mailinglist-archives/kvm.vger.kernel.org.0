Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57B3714F03
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjE2RsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 13:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjE2RsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 13:48:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9790D2
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 10:48:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3Sh7Xj6C5CaIioX+VU7asTfHS56MiA2HFxgCXuAwsNiM/V3RUZDwoxiOsCNbs7/dNqnsS5PTm2eYP84GLRx2thzsqATY8Rx1rz6L9mpVifNRPGVmD5zdZCGHEYQYnTmxIltLf3ZEpssnCFAl170xuQ84wFONMI+QDVm6hnMq479klNvQRtkMS7MiXdkU587gwzm02hUKBrMFbk4Q6tPOG61QzYGqokx8j1Tl6k8tmz9SmBzgv3Giv1fbfNil/KAjQTZEeL8wXPtYj0dpI4hTEfAvKnB3ar2+E4MSNjDBVO9h6+G3e9NwD9XOSemeh7nm+cG/21egdGgBrewNQv6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtwf9jeYdUem2+GTVA0exlY2b5qzUN+Eb4Cj+RSb2dw=;
 b=EMqwfAZHtDYC3NTgQmqrWOZfRRyB8wccUqhaXdgYMZ+GnlCirySsh3d2J3xttIi6lX/krW5NcM9ahx6ApNf5r+6P2abB5ZP1nSzsfccW94GYBOYWlalrsdQSrRv/zABhdtKk1Rtnhisyb1BzZJ0fITeRMIuIvmdXSbYBbgI54uWgA5uwQWPzt1AOA8boA8kIhjNZ/TfpCmZA0WVULN3db/ZvGR4fHJfMGG+wr1q8DDvzG4il9XYzbvZHcmm9snYo2dqi/zDQHX2B7IKAAhoA3x0zTgSIdUVMPvxfQeJm+sGHjjkMb8pRH4kM60Vl4fS2gOSz6pOaduodu9oiQkZz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtwf9jeYdUem2+GTVA0exlY2b5qzUN+Eb4Cj+RSb2dw=;
 b=AYZwTv0zWdX9kdRBhS/zH/NyIhoZXMYhCBPiu3/tJBqDwKr3IRpjf/TafRZIg5UPZPPNE8PspNHZwxQ4IXA1+2Tk8fizrQ2xk+pcsBRxLbA79HW2XZGCcKznPywW6UxHW6lU4nGTj+fwFq2/ISIn0P3gBIN9F0cLbEe2uA5CIMxQoGIaGJCCfE2iiXqpvZCroeZTyDS9Gwh7mXGdw3rfLh0NieBZnBK1238Q7sfgAf5QKlpFkIjPQXyExPwSrRcxKJCn1vGFQonxm/PF2holeMzbemy2FcCu6bqFJMYo8kSeCUQQll+up+vs+lmLaYUHGahiJYe//0HERlzMp5tzWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6178.namprd12.prod.outlook.com (2603:10b6:930:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 17:48:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Mon, 29 May 2023
 17:48:02 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH] vfio: Fixup kconfig ordering for VFIO_PCI_CORE
Date:   Mon, 29 May 2023 14:47:59 -0300
Message-Id: <0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0122.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: a6231cd4-5ef5-410f-8dae-08db606cd98d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZOxhQU4RqyG6Xh1/NABGlj5OAJLDL2BWxNDqiBJd4zzgpo0lFXcHqy0HP+AKVNgT6n8+HErjgHNzWQi8gEglIT7UgY8IAdkDByqtYnq6KA5ck1OWU41XoC3bdcpq8d6VllcXLxpeg3Tqcz48wryYm7fr8jQu6+HV0xZzrTSnL8nNHaSBQI7KgbTqPF05Z6Y/zKgEfK/Kg3SIsz7xvFgheKvUeVIDvCvUjDlDpdlP31z9svHvUFJexDQPdxmU8qji3XdyduVjY82s4TSPEQOlyuPxdFjrBmsiBS9tetWU88jvNdy2bx532MYo0ykRK+uXDMTfPMLNivZSxE4ZKIOOkhpbFybCaBVegpxFj0CeWwK5Jj5bdix2pOB/ORaIC7djpKpPmdz/x/Iq/23V/xgvKIq4KwtwOfdDN734evyhrEylJFiGJc3WGA5n8yPLFWMGc4+mlcJkVmuZ7EzMGttciPhKv/3UD0ORcbmFT+cnYIobKGxbZ3/g3xeZSLD67LapOBTgDlqAww/DaJ4r4t6qFq9lJc6BquAHknBxIIbRZ0NRtpzRVP05/RM2z/2zdeGv4gYTa+vWe7nq2ClHppzKqCyEkgBUAgyVXrnQXlhMQ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(6486002)(86362001)(41300700001)(6636002)(6666004)(316002)(66556008)(36756003)(66476007)(66946007)(2616005)(5660300002)(186003)(2906002)(6512007)(6506007)(26005)(38100700002)(83380400001)(8936002)(478600001)(110136005)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ijpC2ZEr2n8wMe2tn4uhaIxI8Qe4IcsbFbJN2SQURx9vgVoh4zLC/Ztv7rbi?=
 =?us-ascii?Q?P9mQz2czxsdYi5Ac0JROJoaCweE1/P65vDdNmx8yJ2S2mEqanQG1TXiU3YT9?=
 =?us-ascii?Q?i/uOcKFFUM7gk+pmlvO0MnXcCX3WHq6yJbvcqjiCCj+UlthRJzq1ANiATWFr?=
 =?us-ascii?Q?K64Iv3hIcUorU6UvRF5FTTMjNqoB3Hgb2F8prIJDW1egn1ANK/r5ZEfn3IVx?=
 =?us-ascii?Q?BH0Cy7qcKyHGqbtOKuv3h4MNxIQDwuZBaTulBtl/J74bLwF8nkA8QyNKzm/D?=
 =?us-ascii?Q?QvSczgwANbP9yYt8s3IbjzNR3rlJi1pve+YuPyPdMr6FOYGvkXRAWIqsFpti?=
 =?us-ascii?Q?3u83+QizkyvbNCUJryKuyFKPg6vO6j7kLXjgsjxjza9M6TKcL1AlENin6V9x?=
 =?us-ascii?Q?8j/EQgQVuDLM3AEsv+OXxviDndhZi7irel8I97arzq9ssj7Ms9daK5kqNKh5?=
 =?us-ascii?Q?rsv59gcgtSKelyTux58X4qKXPS6bqaaD9AnwMmtjNIeft5CYWPDhVwBVsvQN?=
 =?us-ascii?Q?saED8u3GBA1ZJYJzDKpFLAkYJEa88JZKIntIQ7M/qAozka0C7ms+etmmmxKa?=
 =?us-ascii?Q?CQFXlK66GbVdGBIdIWX7XuSIsM1GYYiGxO81eUkzNIZRHYK2u3zFF7pUr5Rv?=
 =?us-ascii?Q?ZpluWFM6+8IZRer0G08y/m8MFS5xOOGW2XfHM00yQ22Zl6DkXXiJgDhQ0Z8d?=
 =?us-ascii?Q?7Wt8DpkAMl/fIaqVW3SuUHeO8cFZgfCXWxqMGaYVVfzxE4SHpFZgSDzcXVoh?=
 =?us-ascii?Q?9KZsepgaXpJR2/kMKWVFIXn/rpCFvxosQS0yd4Qfp46cXycfqhPCi0sD/IUo?=
 =?us-ascii?Q?vSSBySnorxECqsX1fSotDhZjODaylKINmX5l6pybV5H6dmfWnMlXQJVXhN7c?=
 =?us-ascii?Q?O9JYfCC6bzUDR/M/xJF8SD+1cRzp7meMnY4hpK/Tx6Kd6jY28s+lJwzrK0I3?=
 =?us-ascii?Q?iWl1aRwPHGsmyRhQisniJRshGKEBfB/uUm9xZOgHBqBNrdvpqXN5/Q1tLTGO?=
 =?us-ascii?Q?gCeoekN3hhSiZJgoWDiG1yolH+mda/IxUamPrUYFAeqMz9wnZ27NR0VQXbUz?=
 =?us-ascii?Q?/Evmd6CAPXOGHgZmxlW7jDltCHm1qbxu3p+XYz9xqFAHh1thh07oBO1RDE8F?=
 =?us-ascii?Q?4Z1Kgmdui9mx9YhOMD1Cl0KWJZtkmM3yFTeNed34UB13TRoABdqMcCFPZ6YZ?=
 =?us-ascii?Q?c7Q0QeiL3OrMBpfihtxG+gFep14TyyGRih7oF8iu7prNJS/AFF9eLs7cG4Cf?=
 =?us-ascii?Q?EhkdgwN/PODzp61q5vLPWB9eg3rkiVO5R7P9fG5xZcGJ881o8wIqRI/pjf8v?=
 =?us-ascii?Q?hcItBbc772GCSYZS4VeF/VvJvcF91A4XYvwr82z8EPAMjqDTsENzobFGuyAU?=
 =?us-ascii?Q?u0YoQtWQDpKGQgffUoAKOQPubnY2KRRmuHGmTNMxkPfVTiUOeVWszCTfqf5w?=
 =?us-ascii?Q?qazBZSmK9AMHsgLoHemUopu9QkCYvHvL5ws6m/kHSYofK8m7r1kEU/QyGfgG?=
 =?us-ascii?Q?SUeQz4lF6oJyfWpuX+S08FXSxaM3oY8eP3hD7D3GY4bLCzyhIuIZTAUHLtzQ?=
 =?us-ascii?Q?EBI96Pg5nkFtuGPlnBCJv+B0imYvFqpxgDMGXwFH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6231cd4-5ef5-410f-8dae-08db606cd98d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 17:48:02.8707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhXUktwwpUez50A/Fngq4a++E2DJuuNY2HqWUAQX9nRwv/m/SyoZsXnOFkrEfRZk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6178
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make VFIO_PCI_CORE the top level menu choice and make it directly
selectable by the user.

This makes a sub menu with all the different PCI driver choices and causes
VFIO_PCI to be enabled by default if the user selects "VFIO support for
PCI devices"

Remove the duplicated 'depends on' from variant drivers and enclose all
the different sub driver choices (including S390 which was wrongly missing
a depends) in a single if block. This makes all the dependencies more
robust.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/Kconfig           | 17 ++++++++++++-----
 drivers/vfio/pci/hisilicon/Kconfig |  1 -
 drivers/vfio/pci/mlx5/Kconfig      |  1 -
 3 files changed, 12 insertions(+), 7 deletions(-)

Slightly different than as discussed as this seem more robust at the cost of
adding another menu layer.

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738c3..5e9868d5ff1569 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,9 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 if PCI && MMU
-config VFIO_PCI_CORE
-	tristate
-	select VFIO_VIRQFD
-	select IRQ_BYPASS_MANAGER
 
 config VFIO_PCI_MMAP
 	def_bool y if !S390
@@ -11,9 +7,19 @@ config VFIO_PCI_MMAP
 config VFIO_PCI_INTX
 	def_bool y if !S390
 
+config VFIO_PCI_CORE
+	tristate "VFIO support for PCI devices"
+	select VFIO_VIRQFD
+	select IRQ_BYPASS_MANAGER
+	help
+	  Base support for VFIO drivers that support PCI devices. At least one
+	  of the implementation drivers must be selected.
+
+if VFIO_PCI_CORE
+
 config VFIO_PCI
 	tristate "Generic VFIO support for any PCI device"
-	select VFIO_PCI_CORE
+	default y
 	help
 	  Support for the generic PCI VFIO bus driver which can connect any
 	  PCI device to the VFIO framework.
@@ -60,3 +66,4 @@ source "drivers/vfio/pci/mlx5/Kconfig"
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
 endif
+endif
diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
index 5daa0f45d2f99b..86826513765062 100644
--- a/drivers/vfio/pci/hisilicon/Kconfig
+++ b/drivers/vfio/pci/hisilicon/Kconfig
@@ -2,7 +2,6 @@
 config HISI_ACC_VFIO_PCI
 	tristate "VFIO PCI support for HiSilicon ACC devices"
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
-	depends on VFIO_PCI_CORE
 	depends on PCI_MSI
 	depends on CRYPTO_DEV_HISI_QM
 	depends on CRYPTO_DEV_HISI_HPRE
diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
index 29ba9c504a7560..d36b18d3e21fe7 100644
--- a/drivers/vfio/pci/mlx5/Kconfig
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -2,7 +2,6 @@
 config MLX5_VFIO_PCI
 	tristate "VFIO support for MLX5 PCI devices"
 	depends on MLX5_CORE
-	depends on VFIO_PCI_CORE
 	help
 	  This provides migration support for MLX5 devices using the VFIO
 	  framework.

base-commit: 8c1ee346da583718fb0a7791a1f84bdafb103caf
-- 
2.40.1

