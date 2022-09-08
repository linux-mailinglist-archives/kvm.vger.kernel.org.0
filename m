Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1280F5B2613
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiIHSp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiIHSpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:45:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440CE62A9F
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:45:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LF1XVYBQH/i+VsjsUSoNwipIcpfyOStyzSqnO77pjxTvvKHU6rxVTMl4oQ6a+lDm/JgOqtDL9NTP+tXZRA5ZY+gNshG6o7zGKYtcFLlsSdApHHRQaFcBtADBE3ABA4QZPgX2osCD3S+0P0czr/RDM0h7lcRWJKqcX+saYLs0GLXYnS/+9rKvzN3NmXXQb57gN7Khmunl6QAVSURlMv5kpD81uL3n3EvzSp2prsk9u5pJCRNG6TepCfpoceqahewlEd0VXohlKVMYcqh0pPCj2OnFDw8kzbT+rsIjtoOSHbWbRAXjTA0kIubfG1z9YwPFVgYCYYtbPeOWNpUBByeHEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mn24ea9oFkGehrK74yX4XvQBNzpO+59njrNsH/OO/dk=;
 b=U6dzfocnmeq9/y+/N1Ft9b4Bd1xZObcs4Kz3VxGKCs/0Kacoj9VJCcL0jb14J/vbdC7+qA2bWTwF/kdrf9PwoD/OV3fTMJbEOUIBE2i62z+UN3x3cKFnIAwAV0JJS1AmEED8xZoYKkSPZlQLHwDpLiHUGtSousZS9+4aSA7PZFW3wIj80E64RQOZ1sfZwQFyiQs0MKcX7YgcLhYT2BoxvmjTBY8gv7za+df9cup7P7+t1sMpUkZ8LKA3Uq05sIMSx47Yp5404w3tB0Oy9sOPiJaUmnGXGAMB3hFPpEwS6WW20dOW9+YNiI3umJVZ1qPTNOteXd4yNbY+NzwF+6j+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mn24ea9oFkGehrK74yX4XvQBNzpO+59njrNsH/OO/dk=;
 b=gyNzkMIXoTSP5YPDw9RTm1eVtkVi8H5JQ2fsSRN9mIveJYXj7/v4VNWI67oehhQvndSqjJiV+DiyMXONekspYaeB/pz88stWBxf6PdUxArBQ56yzJkL8QPpB5yBncZMc55ePJYcpm4+GObtqSmiFGEmC3gH7Ip08X0eF+w4S5xNNxwtETS+Xr9xpf9RuHc+i3Tx/CC7QFmWvaWTJaJEcMmsfbEjJ/IfntoK45VtrMLyQ7XsXOqqux8+cYD/u8kn0656GezrSf1fspaBf5pbyosMp01k9ZrCeRRKtvtMsIcTr/PoooMDc/KYATEFs5FgU6R5xmGddOutWp7XXsCjhRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 18:45:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 18:45:03 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
Date:   Thu,  8 Sep 2022 15:45:01 -0300
Message-Id: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
In-Reply-To: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::45) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY5PR12MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 25115463-b4fc-4c63-b949-08da91ca3d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +P6QzaaWEzbnwRDMXYyYUrCUupSxiKQfczVjSXrDRKdfhEQWHDObRtqaCopGpOOBENKpZcMHKtuwFCAeMEg04DUANce4fBYFL9KQsQdV6PJKbKVl7fH0ZMFfx8eMmsHYHib05qB52S5I6oTscnO8R5b0759nbbUo7tbnzqvAoXUk71FJ/BCmkvtcmzxG7vG+AsyIcvHPeZS4m+0+QnF+d5+MX1M01auWwqiqyGG1jgSXu7JyudAs/WRBAF5hFkp1Pp66mZKxVbKp/Dd+4b9beNvIwmy3ygqdKhk+rnDwXm2u+Mn2CdGqKmhTH+C0i4M9HjA5E+x9h2seEdVeS5SvL3meLGzaspCUIFSd5AzaoQn8/+03toy9FDB28+R2v+ZxpsNK7E0njMjGVa/xvkQ9jrEFxXpn9/Czed6vPB8IS9y2FV0F/Hi+Lty0KVI5AcJ6CdrXXI713GPP7GtDQKgn+OkUJJYG0QBrwmlsMzzfgaYdna14ocepJ/Zvp0AIdqm8AlyS8HXiHUiw0e7Qy/N0YA0HvvXeHoK/d5yPEVTiLKrrla9mcACJpot2E/ykLS6DfvyN8M0Su4yOryfeRwNSNxwSill097de9p5kET2d83mN081WkVHakob7UFp4HS5mpejpsj/ssmK4hOo4hbUKrA2Qi14+zQDcj6tmLvzRGaSb1JJczZIXOW6ioEL9dc0cchEyW/YIHtwmcJWbtBEBiwj2zron2bftnVjlNnBV/tgiR7AxFbwHLDHjC8Vuc5Ef
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(45080400002)(38100700002)(4326008)(66556008)(316002)(8676002)(66476007)(66946007)(110136005)(54906003)(41300700001)(8936002)(83380400001)(7416002)(5660300002)(2906002)(6512007)(186003)(2616005)(6506007)(478600001)(6486002)(36756003)(26005)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2HqcQfo7CyI4fCh5QfjelOmABx5XrUqunmE9H7XlITzQtFatcNSrj8ZukKwU?=
 =?us-ascii?Q?UPf9BFz3Z66P/YTex4NL/m6pJXYXtY4LRH0FLcE37dt3P7ixIfVLnN+xVG9R?=
 =?us-ascii?Q?jXeDKDgrRoL5/nCYHCHc7kr7liD02S3e5wHGNl74HeHlIk7s4UHRf1AcLx/4?=
 =?us-ascii?Q?dwUaf9Hb65piw2R5iIvAnmMIM/nf8jqx8CWylL3yFQktga8g0eG+rl9WunX+?=
 =?us-ascii?Q?yT7BMukSdn64B1tKN10tFAhPLz1c7QF1W2w0usBGKw0kRmAT+wY4t7/LVRUA?=
 =?us-ascii?Q?0mPXnyPRyXYcSjsOwl77MOzL0ePbV0NjEKRK/7cV7hcQ/WKJD2WPRxTK2TJw?=
 =?us-ascii?Q?VJriom2XbwLvGALUISW7DTmeuXI+ktKJlfuECJFA1jUhBWiEDBiKoIKIv7VK?=
 =?us-ascii?Q?Chge29+mDNculfjijlNo8dsnLYtqNMzf8tiQDUyugFAIcBtJ4DcLCrdqzm9H?=
 =?us-ascii?Q?0cl+A69LIYERZQko32inSYcAQb0tS2sSGRpUh+3wv+8VEhT2STLwYw3NbG2y?=
 =?us-ascii?Q?fyDtp2TZFHlwdPG6uHz4la6t3nlOXcvs+AMnzurYYjJc4M1F1yyTBjOa/djj?=
 =?us-ascii?Q?dC4sPLMyshJa/SRSy9jmtHuuRBYONoTmfZkMUmMMWoVrzEElAZGB3bs3i0BC?=
 =?us-ascii?Q?3qWbf62I+ExppJMqKQlJ+MpIqln5h6nCMM4nWtQJTWwRYuUIM6fzqN76LDgZ?=
 =?us-ascii?Q?cKRKKCTOyMnkI74KMP7EoNpThrO6CdAck4WNXtWRmSO6TYJH6EIwqByusqnz?=
 =?us-ascii?Q?K7UuKChuReALu9LhriyyXZQ/sufR6maBf8RLLOGFVLCGyTRor5Ruc/PtQt4c?=
 =?us-ascii?Q?ubUKmjtqnwuyONhAKuNB4RPppyp7LNWKTaYpPTxnWyxtkNarAppyflW0EJvW?=
 =?us-ascii?Q?OdnmIPAE1Kc8+hcBREuLsAmFxVsixe4QdS8IN+kCXKHmcuMbGo6lNcV9HOu2?=
 =?us-ascii?Q?DIBTPwM47FsmvbOuj2Vd8PVu3W1hCRq7PZ+5ibq4Bc5Vp8VRXZgtkBW+p1Hu?=
 =?us-ascii?Q?sSXDFfVhntxFkgeCKBDSrW5qyyXruz1Bu6RBBAFqnh+H+5KZS229njfubdNh?=
 =?us-ascii?Q?FATQZ4cCgVYzFngDQLfb4v26NH2/wRNsajRSUzwlzAKNU86CNTAPwPxqdXJV?=
 =?us-ascii?Q?HzDeu2Vzfcl7wO8SmNhMjBZlt1+v8DUW6vmkMYsWYlsc5cKbPxKTCQBPsn0Q?=
 =?us-ascii?Q?noi2ZHVcKlav5m+ZFodf1dkUy2+eL/PYOWIzme/dDF8rsTpHpB/T/j1KctHK?=
 =?us-ascii?Q?9zRYlQEahO+oFFCAPQ/eVUwOMAPIf2McGGuZa2WOLJdhJDQ6BvYQioR6z8R/?=
 =?us-ascii?Q?siCZIHqcfIyvjGNcr57k95MQBxfAmwPcNeXfoIFcQArmJLp3VPuq4thjpRui?=
 =?us-ascii?Q?EyvqGjtTsWsCJIZUvGYVRPCxTr6KYDKhC1ju/21lBNvPdv4BDHfQYocyJZhU?=
 =?us-ascii?Q?rNtBDo8DXK8he+Hp+xD+ylqdvjNkieJ1fuTP4w95QUH3sDz7sQ8yx5cI717s?=
 =?us-ascii?Q?jiPA2x+gw6OWEt5OKoUfHE4kzTCVfIuCKIw0PYEAnaGwHbOadkbLil9mjRur?=
 =?us-ascii?Q?NEE/zN+bEu+oywdKG0V75/Q+H8Hdw/r1nfWSGXX0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25115463-b4fc-4c63-b949-08da91ca3d35
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:45:02.8322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzX2VojJl61buPHX26mFEWZ5aIsiXBJcsaVeXoO6Eym0tyaMFPKjmXZ4ldRXWy2b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

default domains created a situation where the device is always connected
to a domain of some kind. When the device is idle it is connected to one
of the two pre-existing domains in the group, blocking_domain or
default_domain. In this way we have a continuous assertion of what state
the transation is in.

When this is all destructed then we need to remove all the devices from
their domains via the ops->release_device() call before the domain can be
freed. This is the bug recognized in commit 9ac8545199a1 ("iommu: Fix
use-after-free in iommu_release_device").

However, we must also stop any concurrent access to the iommu driver for
this device before we destroy it. This is done by:

 1) Drivers only using the iommu API while they have a device driver
    attached to the device. This directly prevents release from happening.

 2) Removing the device from the group list so any lingering group
    references no longer refer to the device. This is done by
    iommu_group_remove_device()

Since iommu_group_remove_device() has been moved this breaks #2 and
triggers an WARN when VFIO races group activities with the release of the
device:

   iommu driver failed to attach the default/blocking domain
   WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
   Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6>
   CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
   Hardware name: IBM 3931 A01 782 (LPAR)
   Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
	      R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
   Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
	      00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
	      00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
	      00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
   Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
			  000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
			 #000000095bb10d24: af000000            mc      0,0
			 >000000095bb10d28: b904002a            lgr     %r2,%r10
			  000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
			  000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
			  000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
			  000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
   Call Trace:
    [<000000095bb10d28>] iommu_detach_group+0x70/0x80
   ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
    [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
    [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
    [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
   pci 0004:00:00.0: Removing from iommu group 4
    [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
    [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
    [<000000095be6c072>] system_call+0x82/0xb0
   Last Breaking-Event-Address:
    [<000000095be4bf80>] __warn_printk+0x60/0x68

So, put things in the right order:
 - Remove the device from the group's list
 - Release the device from the iommu driver to drop all domain references
 - Free the domains

This is done by splitting out the kobject_put(), which triggers
iommu_group_release(), from the rest of iommu_group_remove_device() and
placing it after release is called.

Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 780fb70715770d..c451bf715182ac 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -90,6 +90,7 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 static struct iommu_group *iommu_group_get_for_dev(struct device *dev);
 static ssize_t iommu_group_store_type(struct iommu_group *group,
 				      const char *buf, size_t count);
+static void __iommu_group_remove_device(struct device *dev);
 
 #define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
 struct iommu_group_attribute iommu_group_attr_##_name =		\
@@ -330,6 +331,7 @@ int iommu_probe_device(struct device *dev)
 
 void iommu_release_device(struct device *dev)
 {
+	struct iommu_group *group = dev->iommu_group;
 	const struct iommu_ops *ops;
 
 	if (!dev->iommu)
@@ -337,11 +339,20 @@ void iommu_release_device(struct device *dev)
 
 	iommu_device_unlink(dev->iommu->iommu_dev, dev);
 
+	__iommu_group_remove_device(dev);
 	ops = dev_iommu_ops(dev);
 	if (ops->release_device)
 		ops->release_device(dev);
 
-	iommu_group_remove_device(dev);
+	/*
+	 * This will eventually call iommu_group_release() which will free the
+	 * iommu_domains. Up until the release_device() above the iommu_domains
+	 * may still have been associated with the device, and we cannot free
+	 * them until the have been detached. release_device() is expected to
+	 * detach all domains connected to the dev.
+	 */
+	kobject_put(group->devices_kobj);
+
 	module_put(ops->owner);
 	dev_iommu_free(dev);
 }
@@ -939,14 +950,7 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_group_add_device);
 
-/**
- * iommu_group_remove_device - remove a device from it's current group
- * @dev: device to be removed
- *
- * This function is called by an iommu driver to remove the device from
- * it's current group.  This decrements the iommu group reference count.
- */
-void iommu_group_remove_device(struct device *dev)
+static void __iommu_group_remove_device(struct device *dev)
 {
 	struct iommu_group *group = dev->iommu_group;
 	struct group_device *tmp_device, *device = NULL;
@@ -977,6 +981,20 @@ void iommu_group_remove_device(struct device *dev)
 	kfree(device->name);
 	kfree(device);
 	dev->iommu_group = NULL;
+}
+
+/**
+ * iommu_group_remove_device - remove a device from it's current group
+ * @dev: device to be removed
+ *
+ * This function is called by an iommu driver to remove the device from
+ * it's current group.  This decrements the iommu group reference count.
+ */
+void iommu_group_remove_device(struct device *dev)
+{
+	struct iommu_group *group = dev->iommu_group;
+
+	__iommu_group_remove_device(dev);
 	kobject_put(group->devices_kobj);
 }
 EXPORT_SYMBOL_GPL(iommu_group_remove_device);
-- 
2.37.3

