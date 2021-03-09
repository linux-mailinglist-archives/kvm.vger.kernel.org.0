Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C88A3320C4
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCIIfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:35:00 -0500
Received: from mail-eopbgr690044.outbound.protection.outlook.com ([40.107.69.44]:62646
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230423AbhCIIet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fok+swWHigMNYe5NMDRxV+07PLgnGBD/sO/chj0ORagLP1jAsMW6yhO2+O/sNOARVOA5cHxpbEzg68dn6tYyz6XrsM1Lt18mQYc3t4RA2UFhS4g6wgFVZM9jJo1EDbGAqsEmGlFYc0sSk6MKyYScl+lcC9CyRaV2MyGmJ4tPjPsgfCrjszLoAWdFAn+v80NvmOjLuOJYV8i1fOgfFDbeSc1U8RIqaHAHvK3FR/vKPXsVauhIpeRYdWcrZ9xYuIzv07YxcZloC84Q/jRLFuXMztdoFCo6lfW+3gFOpHLpQt2Ab6GGKs7YVOiZqeigh1Dnsp6kHiq2oHOZgwVxX4dEqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9KtQWql1FKBYN5QGXII2v3gvk8qDoRjBpk/llyvrrw=;
 b=Cb+l2p2UqOnn7yMTQRnZ0y2j9ZqhefCQKuZwKtz/SIMBYEoVPurVlZqJ9+KINCyfoQhNNIrCG4Hu1mRLf/kNTMOX0gynqggh/ZC11a92cd3RpFvVbjnqhO/PV3NFXJQmH8qY2/NPHqpjQDJJ6WM2i8qnSftMNoRT3Dzax6L4yc7stjhVUnW2RvMZPC0KzbEQfeS6fMxFrhLqu2HTFjop8CJoAU9POgAZkd90Mus3f+7G6m3F1C1a089K+SowEiB2Oi+OwL/Lz9g9NG6Bfdzd5P5RNpbzPYQ2dbfZroIzlg0ZraDXilGAPBrKwlz3bp2JEqTTX4QnB3EAkScxepfcVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9KtQWql1FKBYN5QGXII2v3gvk8qDoRjBpk/llyvrrw=;
 b=TB4ig42CdXC9ROuFV4l4NkQeqwvxhBjodFG8ENT3WWJENP3xfQ3G5vFpxOICZpV4eD3hkTaCOIke81Zz5jMlebAaCbxqooU5NyuqtYIGAFdM2gx/1f8S80lAh9buEZl8O1LsFOW9gIX2maeT/VBAlpUvGa/w5dd27S4/KLtV8sB/qPCd0BoJoP1RBolQ6pL/Z/8G5YQyehmQaU4zvLniWN6gpffbHbxg98qDhQYEcgX4l1i5l1uW3j2DRN3Ek6yn39N7DrEeiN29N7ATLB9NGwgxpGYWGmHKWDWQXrrzqVxrOzRuq/kTGEdSmzt4QSo+2fPCdx/hOC6x3yVS9No7aA==
Received: from DS7PR05CA0022.namprd05.prod.outlook.com (2603:10b6:5:3b9::27)
 by BYAPR12MB3541.namprd12.prod.outlook.com (2603:10b6:a03:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 9 Mar
 2021 08:34:46 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::77) by DS7PR05CA0022.outlook.office365.com
 (2603:10b6:5:3b9::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:45 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:45 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:39 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <aik@ozlabs.ru>, <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 7/9] vfio/pci_core: split nvlink2 to nvlink2gpu and npu2
Date:   Tue, 9 Mar 2021 08:33:55 +0000
Message-ID: <20210309083357.65467-8-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f37aadff-4063-4bcb-988f-08d8e2d631a8
X-MS-TrafficTypeDiagnostic: BYAPR12MB3541:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3541857B148B73FAE693F92DDE929@BYAPR12MB3541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJXvtTBtEIUQ6V/ujbMGy/1th455geuHAAnLNZpggkpU7lhCpAA7Zk+vu//dTVPT+z12YZYz2gQWlA3MD+V7YRHgaxioOATmx9MzJ9SLocYHO+6CyxJaO0TjNr5glQSQ8W/6TIBETA9R/g0CgJxqySQ3I4bCAR9hn6bOOxS6K0pMRdbXlpB+HuhmYK0ra99QOSbLlpY3uHxJpuGDo4bWYOYiSavjI7o+taGVoYSFeKQzguNvZcCPe2VtIrNUNEnJrKOg0ChcQ+7kKRrK/3yxpD3BTuFzjKkhWeCYJB+2Y6o/HgQojrkQ0kJJWClqOId+HaB9pMkzVbSWZ/6pnlq8sP/XxNtVuqQat2Jr9aNx51i/Hhlgt3lw4FKNY/S+tMWDtdCJJvTxttH3+o1kk7UJ5vDz4viK8VjbL4YPxGds9h78SQXUiqP5r1E5CCGh8gTm9f3Ar4+VvXc8vlS0wUO1LEOZl9xwRRJIdEIOGqsx3UvPAfeM9hKaG5RoDAQn4dZDJybvSCAq4P+DtMqs0QAEyGLmJrQDYobpUOGu3wqkeH6wrgoUBvdzFhETYLNEDIXArmrbUT0rdvBy6VODbmWMlVzusrz0QVVg+PbDMTdhermVIehXX0PrQLYPB2fq7d656JXM3Cfdtk/7Di18Ssso1NSP1ih1mROaoLDYjRV5xw5xUCBWuAyK3CPlRkRjh2SJ
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(5660300002)(70206006)(47076005)(478600001)(82310400003)(26005)(86362001)(2616005)(2906002)(36756003)(34020700004)(356005)(6666004)(83380400001)(54906003)(186003)(110136005)(336012)(107886003)(70586007)(8676002)(4326008)(30864003)(316002)(82740400003)(36906005)(36860700001)(426003)(1076003)(7636003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:45.5517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f37aadff-4063-4bcb-988f-08d8e2d631a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3541
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation for moving vendor specific code from
vfio_pci_core to vendor specific vfio_pci drivers. The next step will be
creating a dedicated module to NVIDIA NVLINK2 devices with P9 extensions
and a dedicated module for Power9 NPU NVLink2 HBAs.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Makefile                     |   2 +-
 drivers/vfio/pci/npu2_trace.h                 |  50 ++++
 .../vfio/pci/{trace.h => nvlink2gpu_trace.h}  |  27 +--
 drivers/vfio/pci/vfio_pci_core.c              |   2 +-
 drivers/vfio/pci/vfio_pci_core.h              |   4 +-
 drivers/vfio/pci/vfio_pci_npu2.c              | 222 ++++++++++++++++++
 ...io_pci_nvlink2.c => vfio_pci_nvlink2gpu.c} | 201 +---------------
 7 files changed, 280 insertions(+), 228 deletions(-)
 create mode 100644 drivers/vfio/pci/npu2_trace.h
 rename drivers/vfio/pci/{trace.h => nvlink2gpu_trace.h} (72%)
 create mode 100644 drivers/vfio/pci/vfio_pci_npu2.c
 rename drivers/vfio/pci/{vfio_pci_nvlink2.c => vfio_pci_nvlink2gpu.c} (59%)

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 16e7d77d63ce..f539f32c9296 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2gpu.o vfio_pci_npu2.o
 vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
 
 vfio-pci-y := vfio_pci.o
diff --git a/drivers/vfio/pci/npu2_trace.h b/drivers/vfio/pci/npu2_trace.h
new file mode 100644
index 000000000000..c8a1110132dc
--- /dev/null
+++ b/drivers/vfio/pci/npu2_trace.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * VFIO PCI mmap/mmap_fault tracepoints
+ *
+ * Copyright (C) 2018 IBM Corp.  All rights reserved.
+ *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vfio_pci
+
+#if !defined(_TRACE_VFIO_PCI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VFIO_PCI_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(vfio_pci_npu2_mmap,
+	TP_PROTO(struct pci_dev *pdev, unsigned long hpa, unsigned long ua,
+			unsigned long size, int ret),
+	TP_ARGS(pdev, hpa, ua, size, ret),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(unsigned long, hpa)
+		__field(unsigned long, ua)
+		__field(unsigned long, size)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->name = dev_name(&pdev->dev),
+		__entry->hpa = hpa;
+		__entry->ua = ua;
+		__entry->size = size;
+		__entry->ret = ret;
+	),
+
+	TP_printk("%s: %lx -> %lx size=%lx ret=%d", __entry->name, __entry->hpa,
+			__entry->ua, __entry->size, __entry->ret)
+);
+
+#endif /* _TRACE_VFIO_PCI_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../drivers/vfio/pci
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE npu2_trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/drivers/vfio/pci/trace.h b/drivers/vfio/pci/nvlink2gpu_trace.h
similarity index 72%
rename from drivers/vfio/pci/trace.h
rename to drivers/vfio/pci/nvlink2gpu_trace.h
index b2aa986ab9ed..2392b9d4c6c9 100644
--- a/drivers/vfio/pci/trace.h
+++ b/drivers/vfio/pci/nvlink2gpu_trace.h
@@ -62,37 +62,12 @@ TRACE_EVENT(vfio_pci_nvgpu_mmap,
 			__entry->ua, __entry->size, __entry->ret)
 );
 
-TRACE_EVENT(vfio_pci_npu2_mmap,
-	TP_PROTO(struct pci_dev *pdev, unsigned long hpa, unsigned long ua,
-			unsigned long size, int ret),
-	TP_ARGS(pdev, hpa, ua, size, ret),
-
-	TP_STRUCT__entry(
-		__field(const char *, name)
-		__field(unsigned long, hpa)
-		__field(unsigned long, ua)
-		__field(unsigned long, size)
-		__field(int, ret)
-	),
-
-	TP_fast_assign(
-		__entry->name = dev_name(&pdev->dev),
-		__entry->hpa = hpa;
-		__entry->ua = ua;
-		__entry->size = size;
-		__entry->ret = ret;
-	),
-
-	TP_printk("%s: %lx -> %lx size=%lx ret=%d", __entry->name, __entry->hpa,
-			__entry->ua, __entry->size, __entry->ret)
-);
-
 #endif /* _TRACE_VFIO_PCI_H */
 
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH ../../drivers/vfio/pci
 #undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE trace
+#define TRACE_INCLUDE_FILE nvlink2gpu_trace
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ba5dd4321487..4de8e352df9c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -356,7 +356,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
 	    IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
-		ret = vfio_pci_nvdia_v100_nvlink2_init(vdev);
+		ret = vfio_pci_nvidia_v100_nvlink2_init(vdev);
 		if (ret && ret != -ENODEV) {
 			pci_warn(pdev, "Failed to setup NVIDIA NV2 RAM region\n");
 			goto disable_exit;
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 60b42df6c519..8989443c3086 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -205,10 +205,10 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 }
 #endif
 #ifdef CONFIG_VFIO_PCI_NVLINK2
-extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_core_device *vdev);
+extern int vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device *vdev);
 extern int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev);
 #else
-static inline int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
+static inline int vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
 }
diff --git a/drivers/vfio/pci/vfio_pci_npu2.c b/drivers/vfio/pci/vfio_pci_npu2.c
new file mode 100644
index 000000000000..717745256ab3
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_npu2.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VFIO PCI driver for POWER9 NPU support (NVLink2 host bus adapter).
+ *
+ * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights reserved.
+ *
+ * Copyright (C) 2018 IBM Corp.  All rights reserved.
+ *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
+ *
+ * Register an on-GPU RAM region for cacheable access.
+ *
+ * Derived from original vfio_pci_igd.c:
+ * Copyright (C) 2016 Red Hat, Inc.  All rights reserved.
+ *	Author: Alex Williamson <alex.williamson@redhat.com>
+ */
+
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/sched/mm.h>
+#include <linux/mmu_context.h>
+#include <asm/kvm_ppc.h>
+
+#include "vfio_pci_core.h"
+
+#define CREATE_TRACE_POINTS
+#include "npu2_trace.h"
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_npu2_mmap);
+
+struct vfio_pci_npu2_data {
+	void *base; /* ATSD register virtual address, for emulated access */
+	unsigned long mmio_atsd; /* ATSD physical address */
+	unsigned long gpu_tgt; /* TGT address of corresponding GPU RAM */
+	unsigned int link_speed; /* The link speed from DT's ibm,nvlink-speed */
+};
+
+static size_t vfio_pci_npu2_rw(struct vfio_pci_core_device *vdev,
+		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	struct vfio_pci_npu2_data *data = vdev->region[i].data;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (pos >= vdev->region[i].size)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+
+	if (iswrite) {
+		if (copy_from_user(data->base + pos, buf, count))
+			return -EFAULT;
+	} else {
+		if (copy_to_user(buf, data->base + pos, count))
+			return -EFAULT;
+	}
+	*ppos += count;
+
+	return count;
+}
+
+static int vfio_pci_npu2_mmap(struct vfio_pci_core_device *vdev,
+		struct vfio_pci_region *region, struct vm_area_struct *vma)
+{
+	int ret;
+	struct vfio_pci_npu2_data *data = region->data;
+	unsigned long req_len = vma->vm_end - vma->vm_start;
+
+	if (req_len != PAGE_SIZE)
+		return -EINVAL;
+
+	vma->vm_flags |= VM_PFNMAP;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	ret = remap_pfn_range(vma, vma->vm_start, data->mmio_atsd >> PAGE_SHIFT,
+			req_len, vma->vm_page_prot);
+	trace_vfio_pci_npu2_mmap(vdev->pdev, data->mmio_atsd, vma->vm_start,
+			vma->vm_end - vma->vm_start, ret);
+
+	return ret;
+}
+
+static void vfio_pci_npu2_release(struct vfio_pci_core_device *vdev,
+		struct vfio_pci_region *region)
+{
+	struct vfio_pci_npu2_data *data = region->data;
+
+	memunmap(data->base);
+	kfree(data);
+}
+
+static int vfio_pci_npu2_add_capability(struct vfio_pci_core_device *vdev,
+		struct vfio_pci_region *region, struct vfio_info_cap *caps)
+{
+	struct vfio_pci_npu2_data *data = region->data;
+	struct vfio_region_info_cap_nvlink2_ssatgt captgt = {
+		.header.id = VFIO_REGION_INFO_CAP_NVLINK2_SSATGT,
+		.header.version = 1,
+		.tgt = data->gpu_tgt
+	};
+	struct vfio_region_info_cap_nvlink2_lnkspd capspd = {
+		.header.id = VFIO_REGION_INFO_CAP_NVLINK2_LNKSPD,
+		.header.version = 1,
+		.link_speed = data->link_speed
+	};
+	int ret;
+
+	ret = vfio_info_add_capability(caps, &captgt.header, sizeof(captgt));
+	if (ret)
+		return ret;
+
+	return vfio_info_add_capability(caps, &capspd.header, sizeof(capspd));
+}
+
+static const struct vfio_pci_regops vfio_pci_npu2_regops = {
+	.rw = vfio_pci_npu2_rw,
+	.mmap = vfio_pci_npu2_mmap,
+	.release = vfio_pci_npu2_release,
+	.add_capability = vfio_pci_npu2_add_capability,
+};
+
+int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
+{
+	int ret;
+	struct vfio_pci_npu2_data *data;
+	struct device_node *nvlink_dn;
+	u32 nvlink_index = 0, mem_phandle = 0;
+	struct pci_dev *npdev = vdev->pdev;
+	struct device_node *npu_node = pci_device_to_OF_node(npdev);
+	struct pci_controller *hose = pci_bus_to_host(npdev->bus);
+	u64 mmio_atsd = 0;
+	u64 tgt = 0;
+	u32 link_speed = 0xff;
+
+	/*
+	 * PCI config space does not tell us about NVLink presense but
+	 * platform does, use this.
+	 */
+	if (!pnv_pci_get_gpu_dev(vdev->pdev))
+		return -ENODEV;
+
+	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
+		return -ENODEV;
+
+	/*
+	 * NPU2 normally has 8 ATSD registers (for concurrency) and 6 links
+	 * so we can allocate one register per link, using nvlink index as
+	 * a key.
+	 * There is always at least one ATSD register so as long as at least
+	 * NVLink bridge #0 is passed to the guest, ATSD will be available.
+	 */
+	nvlink_dn = of_parse_phandle(npdev->dev.of_node, "ibm,nvlink", 0);
+	if (WARN_ON(of_property_read_u32(nvlink_dn, "ibm,npu-link-index",
+			&nvlink_index)))
+		return -ENODEV;
+
+	if (of_property_read_u64_index(hose->dn, "ibm,mmio-atsd", nvlink_index,
+			&mmio_atsd)) {
+		if (of_property_read_u64_index(hose->dn, "ibm,mmio-atsd", 0,
+				&mmio_atsd)) {
+			dev_warn(&vdev->pdev->dev, "No available ATSD found\n");
+			mmio_atsd = 0;
+		} else {
+			dev_warn(&vdev->pdev->dev,
+				 "Using fallback ibm,mmio-atsd[0] for ATSD.\n");
+		}
+	}
+
+	if (of_property_read_u64(npu_node, "ibm,device-tgt-addr", &tgt)) {
+		dev_warn(&vdev->pdev->dev, "No ibm,device-tgt-addr found\n");
+		return -EFAULT;
+	}
+
+	if (of_property_read_u32(npu_node, "ibm,nvlink-speed", &link_speed)) {
+		dev_warn(&vdev->pdev->dev, "No ibm,nvlink-speed found\n");
+		return -EFAULT;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->mmio_atsd = mmio_atsd;
+	data->gpu_tgt = tgt;
+	data->link_speed = link_speed;
+	if (data->mmio_atsd) {
+		data->base = memremap(data->mmio_atsd, SZ_64K, MEMREMAP_WT);
+		if (!data->base) {
+			ret = -ENOMEM;
+			goto free_exit;
+		}
+	}
+
+	/*
+	 * We want to expose the capability even if this specific NVLink
+	 * did not get its own ATSD register because capabilities
+	 * belong to VFIO regions and normally there will be ATSD register
+	 * assigned to the NVLink bridge.
+	 */
+	ret = vfio_pci_register_dev_region(vdev,
+			PCI_VENDOR_ID_IBM |
+			VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
+			VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD,
+			&vfio_pci_npu2_regops,
+			data->mmio_atsd ? PAGE_SIZE : 0,
+			VFIO_REGION_INFO_FLAG_READ |
+			VFIO_REGION_INFO_FLAG_WRITE |
+			VFIO_REGION_INFO_FLAG_MMAP,
+			data);
+	if (ret)
+		goto free_exit;
+
+	return 0;
+
+free_exit:
+	if (data->base)
+		memunmap(data->base);
+	kfree(data);
+
+	return ret;
+}
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2gpu.c
similarity index 59%
rename from drivers/vfio/pci/vfio_pci_nvlink2.c
rename to drivers/vfio/pci/vfio_pci_nvlink2gpu.c
index 8ef2c62a9d27..6dce1e78ee82 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2gpu.c
@@ -19,14 +19,14 @@
 #include <linux/sched/mm.h>
 #include <linux/mmu_context.h>
 #include <asm/kvm_ppc.h>
+
 #include "vfio_pci_core.h"
 
 #define CREATE_TRACE_POINTS
-#include "trace.h"
+#include "nvlink2gpu_trace.h"
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_npu2_mmap);
 
 struct vfio_pci_nvgpu_data {
 	unsigned long gpu_hpa; /* GPU RAM physical address */
@@ -207,7 +207,7 @@ static int vfio_pci_nvgpu_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
+int vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
 {
 	int ret;
 	u64 reg[2];
@@ -293,198 +293,3 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
 
 	return ret;
 }
-
-/*
- * IBM NPU2 bridge
- */
-struct vfio_pci_npu2_data {
-	void *base; /* ATSD register virtual address, for emulated access */
-	unsigned long mmio_atsd; /* ATSD physical address */
-	unsigned long gpu_tgt; /* TGT address of corresponding GPU RAM */
-	unsigned int link_speed; /* The link speed from DT's ibm,nvlink-speed */
-};
-
-static size_t vfio_pci_npu2_rw(struct vfio_pci_core_device *vdev,
-		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
-{
-	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
-	struct vfio_pci_npu2_data *data = vdev->region[i].data;
-	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-
-	if (pos >= vdev->region[i].size)
-		return -EINVAL;
-
-	count = min(count, (size_t)(vdev->region[i].size - pos));
-
-	if (iswrite) {
-		if (copy_from_user(data->base + pos, buf, count))
-			return -EFAULT;
-	} else {
-		if (copy_to_user(buf, data->base + pos, count))
-			return -EFAULT;
-	}
-	*ppos += count;
-
-	return count;
-}
-
-static int vfio_pci_npu2_mmap(struct vfio_pci_core_device *vdev,
-		struct vfio_pci_region *region, struct vm_area_struct *vma)
-{
-	int ret;
-	struct vfio_pci_npu2_data *data = region->data;
-	unsigned long req_len = vma->vm_end - vma->vm_start;
-
-	if (req_len != PAGE_SIZE)
-		return -EINVAL;
-
-	vma->vm_flags |= VM_PFNMAP;
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	ret = remap_pfn_range(vma, vma->vm_start, data->mmio_atsd >> PAGE_SHIFT,
-			req_len, vma->vm_page_prot);
-	trace_vfio_pci_npu2_mmap(vdev->pdev, data->mmio_atsd, vma->vm_start,
-			vma->vm_end - vma->vm_start, ret);
-
-	return ret;
-}
-
-static void vfio_pci_npu2_release(struct vfio_pci_core_device *vdev,
-		struct vfio_pci_region *region)
-{
-	struct vfio_pci_npu2_data *data = region->data;
-
-	memunmap(data->base);
-	kfree(data);
-}
-
-static int vfio_pci_npu2_add_capability(struct vfio_pci_core_device *vdev,
-		struct vfio_pci_region *region, struct vfio_info_cap *caps)
-{
-	struct vfio_pci_npu2_data *data = region->data;
-	struct vfio_region_info_cap_nvlink2_ssatgt captgt = {
-		.header.id = VFIO_REGION_INFO_CAP_NVLINK2_SSATGT,
-		.header.version = 1,
-		.tgt = data->gpu_tgt
-	};
-	struct vfio_region_info_cap_nvlink2_lnkspd capspd = {
-		.header.id = VFIO_REGION_INFO_CAP_NVLINK2_LNKSPD,
-		.header.version = 1,
-		.link_speed = data->link_speed
-	};
-	int ret;
-
-	ret = vfio_info_add_capability(caps, &captgt.header, sizeof(captgt));
-	if (ret)
-		return ret;
-
-	return vfio_info_add_capability(caps, &capspd.header, sizeof(capspd));
-}
-
-static const struct vfio_pci_regops vfio_pci_npu2_regops = {
-	.rw = vfio_pci_npu2_rw,
-	.mmap = vfio_pci_npu2_mmap,
-	.release = vfio_pci_npu2_release,
-	.add_capability = vfio_pci_npu2_add_capability,
-};
-
-int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
-{
-	int ret;
-	struct vfio_pci_npu2_data *data;
-	struct device_node *nvlink_dn;
-	u32 nvlink_index = 0, mem_phandle = 0;
-	struct pci_dev *npdev = vdev->pdev;
-	struct device_node *npu_node = pci_device_to_OF_node(npdev);
-	struct pci_controller *hose = pci_bus_to_host(npdev->bus);
-	u64 mmio_atsd = 0;
-	u64 tgt = 0;
-	u32 link_speed = 0xff;
-
-	/*
-	 * PCI config space does not tell us about NVLink presense but
-	 * platform does, use this.
-	 */
-	if (!pnv_pci_get_gpu_dev(vdev->pdev))
-		return -ENODEV;
-
-	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
-		return -ENODEV;
-
-	/*
-	 * NPU2 normally has 8 ATSD registers (for concurrency) and 6 links
-	 * so we can allocate one register per link, using nvlink index as
-	 * a key.
-	 * There is always at least one ATSD register so as long as at least
-	 * NVLink bridge #0 is passed to the guest, ATSD will be available.
-	 */
-	nvlink_dn = of_parse_phandle(npdev->dev.of_node, "ibm,nvlink", 0);
-	if (WARN_ON(of_property_read_u32(nvlink_dn, "ibm,npu-link-index",
-			&nvlink_index)))
-		return -ENODEV;
-
-	if (of_property_read_u64_index(hose->dn, "ibm,mmio-atsd", nvlink_index,
-			&mmio_atsd)) {
-		if (of_property_read_u64_index(hose->dn, "ibm,mmio-atsd", 0,
-				&mmio_atsd)) {
-			dev_warn(&vdev->pdev->dev, "No available ATSD found\n");
-			mmio_atsd = 0;
-		} else {
-			dev_warn(&vdev->pdev->dev,
-				 "Using fallback ibm,mmio-atsd[0] for ATSD.\n");
-		}
-	}
-
-	if (of_property_read_u64(npu_node, "ibm,device-tgt-addr", &tgt)) {
-		dev_warn(&vdev->pdev->dev, "No ibm,device-tgt-addr found\n");
-		return -EFAULT;
-	}
-
-	if (of_property_read_u32(npu_node, "ibm,nvlink-speed", &link_speed)) {
-		dev_warn(&vdev->pdev->dev, "No ibm,nvlink-speed found\n");
-		return -EFAULT;
-	}
-
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->mmio_atsd = mmio_atsd;
-	data->gpu_tgt = tgt;
-	data->link_speed = link_speed;
-	if (data->mmio_atsd) {
-		data->base = memremap(data->mmio_atsd, SZ_64K, MEMREMAP_WT);
-		if (!data->base) {
-			ret = -ENOMEM;
-			goto free_exit;
-		}
-	}
-
-	/*
-	 * We want to expose the capability even if this specific NVLink
-	 * did not get its own ATSD register because capabilities
-	 * belong to VFIO regions and normally there will be ATSD register
-	 * assigned to the NVLink bridge.
-	 */
-	ret = vfio_pci_register_dev_region(vdev,
-			PCI_VENDOR_ID_IBM |
-			VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
-			VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD,
-			&vfio_pci_npu2_regops,
-			data->mmio_atsd ? PAGE_SIZE : 0,
-			VFIO_REGION_INFO_FLAG_READ |
-			VFIO_REGION_INFO_FLAG_WRITE |
-			VFIO_REGION_INFO_FLAG_MMAP,
-			data);
-	if (ret)
-		goto free_exit;
-
-	return 0;
-
-free_exit:
-	if (data->base)
-		memunmap(data->base);
-	kfree(data);
-
-	return ret;
-}
-- 
2.25.4

