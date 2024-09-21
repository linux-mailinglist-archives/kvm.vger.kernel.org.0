Return-Path: <kvm+bounces-27235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E49D97DBF2
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 09:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 300F62825F6
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 07:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC19152196;
	Sat, 21 Sep 2024 07:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RFwd8a1O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AFA38F9C;
	Sat, 21 Sep 2024 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726902897; cv=fail; b=gEk2aKRM3p9045mZqHvwO23sPhsGdSvT4k9Dj3kgl1RhmHea0f/MUVKhLr7eyg8R7orj3ef7JOzcYfLbE8fEh3O8zPJJiVSh9nzl7xgBylqkEWjmbL9jzlYSIs8Gt4HQajgshZlIYTul3UYf7NHbWZ0c1alW67AeCMBvCKGG7i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726902897; c=relaxed/simple;
	bh=VnV1OyqyXTwQqdk+FBBdE33M9YaexZNDuj+8lBELhMA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIavscgCLu1CfB8ozUZV6rTbnMXoc9SReMlpNNnU+LPHH3Cs8j/nkSDjRNHJXbqHEPr7+X6TbNGvBeRnqK+sug+EShRjR8NEUHRAMmBUh9isKGLxTxKIZraBegP/ox4Vx/4eFCshRS+O5a+wWut6rZ2FqKUd9jqiluPwfSF6PPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RFwd8a1O; arc=fail smtp.client-ip=40.107.244.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MfmD1gWrGjNvBzBk907uJ+OeAfOhCva/0d0GbJ2GMUaFh5tqd2INMmanzrQdzSQhI7OlHHhDQsF8oU8Xaf2sh80zLP2wmke0SnTa/RqicjXZsOHrO38H5oGGaryeIw8McKRaJVytNevQWUl6h01oXy20fIel2j8irH2Cae0m+vXRRKjc7fWesRjrDrR04INzNRKgyZh0we5fTJCvIWBT+9Bt6xM+TDBPPljhgoOEJngf57S0Lc2pqduESlPu6AKY0VJuV+Icjs0vEBUss4OBQO4BBJHR3LBh+7DI9d9LlIptvp+70nW97RKMaqTG8uUZrEUdCWcA7vIZ+6HVJYNN9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnbWkpHDVBS7jnH/pcHix5UU2gN6Oh2ugm+C4hF7HcI=;
 b=fTUsgmvdQ7kmDgohy7t1FMdURKuMe6A41JfHYkYoAuCvaty8ePM3UpMP9i/HWxaQIf0t1be/KpIGwSEmefPxDa8rkIHMPKmxMmDvZ93INIcZH+fJccA/2frgjEIykrQG+8wBoiwM7HLQd+BohQKt6ij05NDApqZHsdiqIXz+CEK/FyyNK7jR4fLh/rbqY4v85ySjY88UHTaQv9TZIHzqvbXORhMx66v1eNCOTgv04TtvOU532Y5z9rnjdLONXocxjgTcQLWOsLdBbm9HytveBMINL7ihxADvy+3ceqP8eL7cINVnKfMp+9wMDuPNpVP+opVFiy3RD0inxUAdWmjK2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnbWkpHDVBS7jnH/pcHix5UU2gN6Oh2ugm+C4hF7HcI=;
 b=RFwd8a1Ob7qltlndAK9D8yN4eYl/O37GRaNxz1OaPVrViRMUPyOrWirF8GScIvIDnPQLvdmXTFtkdSULopU9JDcC7P7GKFH2SWt2SUjIhApsZ6RwsgxnU53SGqzwQcqm2QE0xGEfckmnVhi8TObxFZfDjs5GaOzleMoU+sIPV0ILJgELlG0n6Q1M+7o/bBd6uAmN7mRX33I7Ge5RlQXAhKWFPa0j0Vy3lOWF0WY3imTYu3tlfb0NuW6YvWTTS1eRRV3Xe9gjIfzgPPmuT+RfD12gPMVjD0e07vs7mmAS6HWqAysyoumGogypBdeQ6H66z2j/q8ongCGzbBagun7DoQ==
Received: from CH0PR03CA0365.namprd03.prod.outlook.com (2603:10b6:610:119::13)
 by DS0PR12MB8198.namprd12.prod.outlook.com (2603:10b6:8:f2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sat, 21 Sep
 2024 07:14:51 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::bf) by CH0PR03CA0365.outlook.office365.com
 (2603:10b6:610:119::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Sat, 21 Sep 2024 07:14:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sat, 21 Sep 2024 07:14:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 21 Sep
 2024 00:14:45 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 21 Sep
 2024 00:14:45 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sat, 21 Sep 2024 00:14:44 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<clg@redhat.com>, <qemu-devel@nongnu.org>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 1/1] vfio: support CXL device in VFIO stub
Date: Sat, 21 Sep 2024 00:14:40 -0700
Message-ID: <20240921071440.1915876-2-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240921071440.1915876-1-zhiw@nvidia.com>
References: <20240921071440.1915876-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|DS0PR12MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b61300-b2ba-41e7-c497-08dcda0d158d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cgJT6ntUGEWQW+JOYe9PTxoPvN/3uACJ7OxVoC11uBUeeePEi9XtZAe4Hjpi?=
 =?us-ascii?Q?gOU6f3TljLBxJri7V6S6pXzZfz4nDoUNV4f7acMQvTug5r0G0KGP7FSXOV/E?=
 =?us-ascii?Q?a8AuKnqs8C8PmCMkUQIr31DJ14SfA0QBVx+kbyONblx6qQaotzwCZK+vKcOi?=
 =?us-ascii?Q?JF+a5vw9DcnM8Vz2+oDhdJ46v9rLKJLVS535x6dBV9vqXkP+ByXjXjYUXh7Q?=
 =?us-ascii?Q?lSO6NtgS1N56gVfDzxIqhrD8RZ6vF8YYYjRHoKPda46uYTGb1bGCx3oIggEd?=
 =?us-ascii?Q?j9UiP2Z60oZm41F5Ma2pBNsAbcxa+YZX95xkEa89P6uuGa1ZVX1ph82Dv7oH?=
 =?us-ascii?Q?EcMr18BHjkPMlM+68F1HZNrV1tLOnC+V8ZFD8KQQYEtoWOWHDb1jH8zmfn+F?=
 =?us-ascii?Q?+feNLlb405EeLmXRicttrTNrRxqEAMc12mgco37kmOslZ3oB+8rYzdGd/45P?=
 =?us-ascii?Q?5DGIcqh0Yk8fYOLEEtyZihnLiHpbOqy8sTusuTRTqAcq3qO5jjYWTVwzHPM7?=
 =?us-ascii?Q?Ukv/uW2WZDerptH+/HJyt8cPruEW1yeTFqonKTJQlKh/0FpLd0Wp+K/wrWD8?=
 =?us-ascii?Q?G6pn8vFAFeEjceWxc0SNxBgUSc2xlwz++nhncYXs0r7hD4/azOXl/v3DgdJN?=
 =?us-ascii?Q?KyF51e+oHqP+7BoffB3GAd8Rjf0nn1FnGYX6qmaxE4CzqS/booPArw8lVSUG?=
 =?us-ascii?Q?hQ1V9Q90Re7Q9rEho8lSm9XX/arMtV9UjRhZzc1Pg9QdHeOBxxUSsRJsrxrv?=
 =?us-ascii?Q?cnxWxmuC6ererGhUIeWQy2UFP3d0rT5iwN58iMkTJ4T5rgG8kCEEGvZ+VYiw?=
 =?us-ascii?Q?LdKoLDoaY7YfOqUegHALoG6tWv+DW6pXwiC+VBXqUjNJJ9+yihxd4qT8alVe?=
 =?us-ascii?Q?oiMHRfcyTPHQkhrvwuDI2JMkpZMD/sxZylwOLbWTGUZ+/QM7GRr8VF1nCHS0?=
 =?us-ascii?Q?8wRIadAXiP9OhG7hGwZQAOXPO8FtACUUwP78J2zuYTju53nIhz2VpNcjWTeP?=
 =?us-ascii?Q?ZxfIBmOdoZlesnkAEvGQmJ51DLvYF8Qt4MhkUHxnBGCWKNAjoDOcUYBNZkf0?=
 =?us-ascii?Q?hJYobvYwfAtkwfDUDTQCqt998DminpTHKeEAPbw86C4I2+rK+euMSE9JuwvD?=
 =?us-ascii?Q?x+Ygtdf40hF6M5ABq1tWEZOVtCleMo6lvkQn7ljklXLSaAfeJi2EyOPjZoV1?=
 =?us-ascii?Q?62nX9fm/q/Yh/FS4fm/iHKEoMinzj+EQozRKfI77MJelagh9HWVvw4oHh1EQ?=
 =?us-ascii?Q?YrKvqGlZkHxTvKFI4vGtxTQ7ypweFc60/7GCMSC2J5MTQHUpVEvG3J+9cYl2?=
 =?us-ascii?Q?1u/fPjph/TVCRCimi+9LHHZ5o8UzZNNcDmWm+atIl/N4vMJIwZ2uOSutmT1s?=
 =?us-ascii?Q?Zt9QjVzBP27G1KtuzGCleIZSceFP?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2024 07:14:50.9247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b61300-b2ba-41e7-c497-08dcda0d158d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8198

To support CXL device passthrough, vfio-cxl-core is introduced. This
is the QEMU part.

Get the CXL caps from the vfio-cxl-core. Trap and emulate the HDM
decoder registers. Map the HDM decdoers when the guest commits a HDM
decoder.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 hw/vfio/common.c              |   3 +
 hw/vfio/pci.c                 | 134 ++++++++++++++++++++++++++++++++++
 hw/vfio/pci.h                 |  10 +++
 include/hw/pci/pci.h          |   2 +
 include/hw/vfio/vfio-common.h |   1 +
 linux-headers/linux/vfio.h    |  14 ++++
 6 files changed, 164 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 9aac21abb7..6dea606f62 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -237,6 +237,9 @@ void vfio_region_write(void *opaque, hwaddr addr,
         break;
     }
 
+    if (region->notify_change)
+        region->notify_change(opaque, addr, data, size);
+
     if (pwrite(vbasedev->fd, &buf, size, region->fd_offset + addr) != size) {
         error_report("%s(%s:region%d+0x%"HWADDR_PRIx", 0x%"PRIx64
                      ",%d) failed: %m",
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index a205c6b113..431a588252 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -23,6 +23,7 @@
 #include <sys/ioctl.h>
 
 #include "hw/hw.h"
+#include "hw/cxl/cxl_component.h"
 #include "hw/pci/msi.h"
 #include "hw/pci/msix.h"
 #include "hw/pci/pci_bridge.h"
@@ -2743,6 +2744,72 @@ int vfio_populate_vga(VFIOPCIDevice *vdev, Error **errp)
     return 0;
 }
 
+static bool read_region(VFIORegion *region, uint32_t *val, uint64_t offset)
+{
+    VFIODevice *vbasedev = region->vbasedev;
+
+    if (pread(vbasedev->fd, val, 4, region->fd_offset + offset) != 4) {
+        error_report("%s(%s, 0x%lx, 0x%x, 0x%x) failed: %m",
+                     __func__,vbasedev->name, offset, *val, 4);
+        return false;
+    }
+    return true;
+}
+
+static void vfio_cxl_hdm_regs_changed(void *opaque, hwaddr addr,
+                                      uint64_t data, unsigned size)
+{
+    VFIORegion *region = opaque;
+    VFIODevice *vbasedev = region->vbasedev;
+    VFIOPCIDevice *vdev = container_of(vbasedev, VFIOPCIDevice, vbasedev);
+    VFIOCXL *cxl = &vdev->cxl;
+    MemoryRegion *address_space_mem = pci_get_bus(&vdev->pdev)->address_space_mem;
+    uint64_t offset, reg_offset, index;
+    uint32_t cur_val, write_val;
+
+    if (size != 4 || (addr & 0x3))
+        error_report("hdm_regs_changed: unsupported size or unaligned addr!\n");
+
+    offset = addr - cxl->hdm_regs_offset;
+    index = (offset - 0x10) / 0x20;
+    reg_offset = offset - 0x20 * index;
+
+    if (reg_offset != 0x20)
+        return;
+
+#define READ_REGION(val, offset) do { \
+    if (!read_region(region, val, offset)) \
+        return; \
+    } while(0)
+
+    write_val = (uint32_t)data;
+    READ_REGION(&cur_val, cxl->hdm_regs_offset + 0x20 * index + reg_offset);
+
+    if (!(cur_val & (1 << 10)) && (write_val & (1 << 9))) {
+        memory_region_transaction_begin();
+        memory_region_del_subregion(address_space_mem, cxl->region.mem);
+        memory_region_transaction_commit();
+    } else if (cur_val & (1 << 10) && !(write_val & (1 << 9))) {
+        /* commit -> not commit */
+        uint32_t base_hi, base_lo;
+        uint64_t base;
+
+        /* locked */
+        if (cur_val & (1 << 8))
+            return;
+
+        READ_REGION(&base_lo, cxl->hdm_regs_offset +  0x20 * index + 0x10);
+        READ_REGION(&base_hi, cxl->hdm_regs_offset +  0x20 * index + 0x14);
+
+        base = ((uint64_t)base_hi << 32) | (uint64_t)(base_lo >> 28);
+
+        memory_region_transaction_begin();
+        memory_region_add_subregion_overlap(address_space_mem,
+                                            base, cxl->region.mem, 0);
+        memory_region_transaction_commit();
+    }
+}
+
 static void vfio_populate_device(VFIOPCIDevice *vdev, Error **errp)
 {
     VFIODevice *vbasedev = &vdev->vbasedev;
@@ -2780,6 +2847,11 @@ static void vfio_populate_device(VFIOPCIDevice *vdev, Error **errp)
         }
 
         QLIST_INIT(&vdev->bars[i].quirks);
+
+        if (vbasedev->flags & VFIO_DEVICE_FLAGS_CXL &&
+            i == vdev->cxl.hdm_regs_bar_index) {
+            vdev->bars[i].region.notify_change = vfio_cxl_hdm_regs_changed;
+        }
     }
 
     ret = vfio_get_region_info(vbasedev,
@@ -2974,6 +3046,62 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
     vdev->req_enabled = false;
 }
 
+static int vfio_cxl_setup(VFIOPCIDevice *vdev)
+{
+    VFIODevice *vbasedev = &vdev->vbasedev;
+    struct VFIOCXL *cxl = &vdev->cxl;
+    struct vfio_device_info_cap_cxl *cap;
+    g_autofree struct vfio_device_info *info = NULL;
+    struct vfio_info_cap_header *hdr;
+    struct vfio_region_info *region_info;
+    int ret;
+
+    if (!(vbasedev->flags & VFIO_DEVICE_FLAGS_CXL))
+        return 0;
+
+    info = vfio_get_device_info(vbasedev->fd);
+    if (!info) {
+        return -ENODEV;
+    }
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_CXL);
+    if (!hdr) {
+        return -ENODEV;
+    }
+
+    cap = (void *)hdr;
+
+    cxl->hdm_count = cap->hdm_count;
+    cxl->hdm_regs_bar_index = cap->hdm_regs_bar_index;
+    cxl->hdm_regs_size = cap->hdm_regs_size;
+    cxl->hdm_regs_offset = cap->hdm_regs_offset;
+    cxl->dpa_size = cap->dpa_size;
+
+    ret = vfio_get_dev_region_info(vbasedev,
+            VFIO_REGION_TYPE_PCI_VENDOR_TYPE | PCI_VENDOR_ID_CXL,
+            VFIO_REGION_SUBTYPE_CXL, &region_info);
+    if (ret) {
+        error_report("does not support requested CXL feature");
+        return ret;
+    }
+
+    ret = vfio_region_setup(OBJECT(vdev), vbasedev, &cxl->region,
+            region_info->index, "cxl region");
+    if (ret) {
+        error_report("fail to setup CXL region");
+        return ret;
+    }
+
+    g_free(region_info);
+
+    if (vfio_region_mmap(&cxl->region)) {
+        error_report("Failed to mmap %s cxl region",
+                     vdev->vbasedev.name);
+        return -EFAULT;
+    }
+    return 0;
+}
+
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = VFIO_PCI(pdev);
@@ -3083,6 +3211,12 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
         goto error;
     }
 
+    ret = vfio_cxl_setup(vdev);
+    if (ret) {
+        vfio_put_group(group);
+        goto error;
+    }
+
     vfio_populate_device(vdev, &err);
     if (err) {
         error_propagate(errp, err);
diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
index a2771b9ff3..6c5f5c1ea5 100644
--- a/hw/vfio/pci.h
+++ b/hw/vfio/pci.h
@@ -118,6 +118,15 @@ typedef struct VFIOMSIXInfo {
 #define TYPE_VFIO_PCI "vfio-pci"
 OBJECT_DECLARE_SIMPLE_TYPE(VFIOPCIDevice, VFIO_PCI)
 
+typedef struct VFIOCXL {
+    uint8_t hdm_count;
+    uint8_t hdm_regs_bar_index;
+    uint64_t hdm_regs_size;
+    uint64_t hdm_regs_offset;
+    uint64_t dpa_size;
+    VFIORegion region;
+} VFIOCXL;
+
 struct VFIOPCIDevice {
     PCIDevice pdev;
     VFIODevice vbasedev;
@@ -177,6 +186,7 @@ struct VFIOPCIDevice {
     bool clear_parent_atomics_on_exit;
     VFIODisplay *dpy;
     Notifier irqchip_change_notifier;
+    VFIOCXL cxl;
 };
 
 /* Use uin32_t for vendor & device so PCI_ANY_ID expands and cannot match hw */
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index b70a0b95ff..fbf5786d00 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -117,6 +117,8 @@ extern bool pci_available;
 #define PCI_DEVICE_ID_REDHAT_UFS         0x0013
 #define PCI_DEVICE_ID_REDHAT_QXL         0x0100
 
+#define PCI_VENDOR_ID_CXL                0x1e98
+
 #define FMT_PCIBUS                      PRIx64
 
 typedef uint64_t pcibus_t;
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index da43d27352..1c998c3ed6 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -56,6 +56,7 @@ typedef struct VFIORegion {
     uint32_t nr_mmaps;
     VFIOMmap *mmaps;
     uint8_t nr; /* cache the region number for debug */
+    void (*notify_change)(void *, hwaddr, uint64_t, unsigned);
 } VFIORegion;
 
 typedef struct VFIOMigration {
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 16db89071e..22fb50ed34 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -214,6 +214,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
 #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
 #define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
+#define VFIO_DEVICE_FLAGS_CXL	(1 << 9)	/* vfio-cdx device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
@@ -255,6 +256,16 @@ struct vfio_device_info_cap_pci_atomic_comp {
 	__u32 reserved;
 };
 
+#define VFIO_DEVICE_INFO_CAP_CXL               6
+struct vfio_device_info_cap_cxl {
+	struct vfio_info_cap_header header;
+	__u8 hdm_count;
+	__u8 hdm_regs_bar_index;
+	__u64 hdm_regs_size;
+	__u64 hdm_regs_offset;
+	__u64 dpa_size;
+};
+
 /**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
@@ -371,6 +382,9 @@ struct vfio_region_info_cap_type {
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+/* sub-types for VFIO CXL region */
+#define VFIO_REGION_SUBTYPE_CXL                 (1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
-- 
2.34.1


