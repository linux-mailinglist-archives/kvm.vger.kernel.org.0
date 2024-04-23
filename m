Return-Path: <kvm+bounces-15637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF808AE37C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 13:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16B931F2293D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 11:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8277762E8;
	Tue, 23 Apr 2024 11:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XPKMCGdR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096B37E58E;
	Tue, 23 Apr 2024 11:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870642; cv=fail; b=ieR0IHepAJAiVqirRY6SmQxWzjhnvABqH1qTficGxmcE4MnbIH246xX9h3M6Lp8lyJxJIltrI0WpgCmrwk84M99+aAKaxuNVdw/n+9QqMRkCGwWTIbzWxm6O/6ctxwHVVZZiwEojlDKBrvomy/Fj4QsvBjKCeME6g9eEx16xTN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870642; c=relaxed/simple;
	bh=n/B1GV9a4SW4nQVpQ9Suuasiv1k+8YQsgE7FfdWLd5g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DeZnedlKtcakZIkbJ5QWVw+vTbbVqyDGBYhriOufXTZeQwfK9iSQMawksJCztwUaRIjy9HmApT+Ipwz3vyUEulKr0TCB3J3+dYU7J1Oar6PgL5cgtJaHER0RgE8HGnuZE8H8m06HZmgU9d3Qi4UkslKW31fl68tQCMCdUE6nM0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XPKMCGdR; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcvspbO9FSK+VF/IM+/fxtXKfX9a9qw2VUKFhz6AlZHg71ceCo0Q44LemhgYqq8Pqgfv6LctBaTtlWHwQH38jYQJFR+i7IhrIhebxA/gucgtg0xAsQmXNmrUikwyCWXqO/QqdGiwMzlBCIKzieyQOfYTAQiDQNVaOH8BtD/Mw/MqvAkw3W7qcIBBOfE7nPjr7X0ysKMP7b/xguYLDJ1KvFnDPLW+vieCNr8jqFWpxaveBbARNcv70nIfaxm/EOF2zsJP+7HMnFNvLngq8l0r4hMOYRoyZjk6eqnpyP9lo/tOFHhwCLcNQ3S0zCJNyCbpuQQA83NFHZRdTEgtl+j3cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLYh0CmTNYNfFTxXqVx7GDQorcmkIpyncGPDrx/nyDI=;
 b=IFEd7AKvNoM5rxC0rGobpIyVDrq0pb7umQC5jhpAujaP2dgVFw3ypuv4oyQ9NL7R9tbV+MpNBQ5yen9fAg62/opCc7OSLQqFaez+x+o23vrMqtbHNfgeqZ4USvu3iG832xPxJxtYOeXJtrT0fHzmllpKTmC3ym/tBMcFBH+Doyp4JqnGLiG/Y6NULV4rdcAxeel/E8UxVnrv++Kx24qLBWs5J+Baz2hbJku5rboeIKc8x3+Ye1srY2ciFeV7GvcCpNL/5vBc5luuY8MGPBVmW9ZFyNSRI61w0bM6Xg00nkrVvyphvK3hV5Dtnu6aPbbeqdhLLsgaNH6jJn1IbCh/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLYh0CmTNYNfFTxXqVx7GDQorcmkIpyncGPDrx/nyDI=;
 b=XPKMCGdRVKaOD1LXd5aBsrV1125sb4RyQFltI2LZWEkkkEm3AYDUIBYwFrvgRZFa6TYYX6FKgSMy8ZBZsEXUguIPrV4SKFpMm+g8H6kMCF1GUDGMZxBoaa5frdIk51z15/oU63Rr4kgWAi9Q5knbBRoMSuyHcCNPUwwtMu6B/YY=
Received: from BL1PR13CA0070.namprd13.prod.outlook.com (2603:10b6:208:2b8::15)
 by PH7PR12MB7378.namprd12.prod.outlook.com (2603:10b6:510:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.49; Tue, 23 Apr
 2024 11:10:36 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:2b8:cafe::b) by BL1PR13CA0070.outlook.office365.com
 (2603:10b6:208:2b8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21 via Frontend
 Transport; Tue, 23 Apr 2024 11:10:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Tue, 23 Apr 2024 11:10:36 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 06:10:33 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 04:10:32 -0700
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 23 Apr 2024 06:10:29 -0500
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <tglx@linutronix.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
	<pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
	<michal.simek@amd.com>, <abhijit.gangurde@amd.com>, <srivatsa@csail.mit.edu>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v6 2/2] vfio/cdx: add interrupt support
Date: Tue, 23 Apr 2024 16:40:21 +0530
Message-ID: <20240423111021.1686144-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240423111021.1686144-1-nipun.gupta@amd.com>
References: <20240423111021.1686144-1-nipun.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|PH7PR12MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: e294d7a4-2380-4a73-ee7c-08dc63860080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SSKvBwZZv85UKS1+5JWelTAo8luM5Cpqsfk+brUosjnPIzS655cLumoYzlhP?=
 =?us-ascii?Q?Rir4AquJNG1w+6z1rZB06z4FHJ2zLTj9zntdN+f655k/71o7bQSaUIbj5kJ4?=
 =?us-ascii?Q?i6shT8U4yE2hA1O/z6sArZAMmtM/APb+H1Y9sAviwKttx7p6pSI+0KO+5zWn?=
 =?us-ascii?Q?X4n24AC0FygNs4Q86HzHtwi6S2BCQuKSJu/zB+x2zsWw3N9y8lkd6HbdFgJn?=
 =?us-ascii?Q?C14MhMKFwmfpi+4FoPpDcdDqtOoK//bIvTp4mPcH8IN7hYDXf/kcRs46L3uH?=
 =?us-ascii?Q?gPEd0Si9vrWmEHa5ioHtKZVS8mgGQBFLK7hZ6b/WzBJCG12j74N5we0SaQpg?=
 =?us-ascii?Q?vDwnwhLBakW6BWvZDmtCb44nYlWAysoh8LyJkh/xbeR2QsKUg9yXHJdPiR5b?=
 =?us-ascii?Q?sHEGh6J6Ee5TqFqgQqxIUxiZ2jv+Zp0afiMj/a6exu9sW0N5RBJqAnSbUPpW?=
 =?us-ascii?Q?Qohyw/iCh86u8bg7ixmIi1emX2fBg5Yg9T7FdaZ7zcx+Ch78sugDEk+QghF/?=
 =?us-ascii?Q?wNgR+l3TdPRFiMtsT7ovI+mszMoDtGcCL2f9/Tv1Z2l6maKjpTSnSJRuNRdk?=
 =?us-ascii?Q?yCWQnsXxXZ4VOJnpk/5QVGawS67vutnAvDFH7YsO95iMeeqObUbwsoCKp3dt?=
 =?us-ascii?Q?48KSoS3pMzzTQl8rW7U6mc08e30S/tKeBPBcCnyPXJM4PyfOUHcbUO3EKqJ+?=
 =?us-ascii?Q?VxCdjxNEx0QulxBYM8XYuS6iXU66N3+8eowN56geTvq0gqSE64P2ii2DMZIV?=
 =?us-ascii?Q?h1tdInJB9Y8yVXU16qPMxHp7ZAmAeUcbI7qGlLoqOaEhYNV1AJTAgdB32ffY?=
 =?us-ascii?Q?HKezoxcnZ2tECfRRbVLDkagvlCxnUmotiAEMkDPC8KXDo8ci+WP1e23BqFVU?=
 =?us-ascii?Q?14gI6FXDJpkN8B0R7nUI8Z9egkri4ypLqR4yycOCvWqYo2WzgxMaw8WKd882?=
 =?us-ascii?Q?G9+/KHlJZOwgPQGcQcgV0P4dM4vsn0kMZdEInA2mAl7Z4oz+HyqP9O5TCLro?=
 =?us-ascii?Q?dn2pBYzpRX0Bpr6ujYOgh345DnTWCOIjMjXpkrYYaBApuDUi6UN+ArMvR7jV?=
 =?us-ascii?Q?GX8Ll60R2rFia0B3Av7x5doMMvhUL4TIvdrIzoW50iQWD7O2WzCRRvypwIAe?=
 =?us-ascii?Q?GEVWxqTIUKzVxumde8WcecpRGi/D8uJ5S7Fxggk3RtKPFASQMvOotSm69Iay?=
 =?us-ascii?Q?7tbxJJSRGdw11e1wWcVLXG8osvoLHLaecdaTDz4vEeYmqS2wvyxUsRQp2MID?=
 =?us-ascii?Q?jH5ojNDdxOLmNtOeuljjgBBXbpc+ZFR+PAGISzz+TX72nfjZ/lEXYluUoZXt?=
 =?us-ascii?Q?Fnx5j7Mi81nJre3LwF1MJL9ZNgw1eR/kMt1n5nJT6LXcFVwSHZWiMhpjRNx7?=
 =?us-ascii?Q?7Gu1P0kq+zzET6REzVC5UaT20LJY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 11:10:36.4516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e294d7a4-2380-4a73-ee7c-08dc63860080
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7378

Support the following ioctls for CDX devices:
- VFIO_DEVICE_GET_IRQ_INFO
- VFIO_DEVICE_SET_IRQS

This allows user to set an eventfd for cdx device interrupts and
trigger this interrupt eventfd from userspace.
All CDX device interrupts are MSIs. The MSIs are allocated from the
CDX-MSI domain.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
---

Changes v5->v6:
- add support for DATA_BOOL
- rename irq_count to msi_count
- fix sending irq_index as 0 in vfio_cdx_set_msi_trigger()
- fix return value in vfio_cdx_ioctl_get_irq_info() when
  msi are not supported on a CDX device
- reorder data fields in vfio_cdx_region to avoid holes

Changes v4->v5:
- Rebased on 6.9-rc1

Changes v3->v4:
- Added VFIO_IRQ_INFO_NORESIZE flag

Changes v2->v3:
- Use generic MSI alloc/free APIs instead of CDX MSI APIs
- Rebased on Linux 6.8-rc6

Changes v1->v2:
- Rebased on Linux 6.7-rc1

 drivers/vfio/cdx/Makefile  |   2 +-
 drivers/vfio/cdx/intr.c    | 217 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/cdx/main.c    |  63 ++++++++++-
 drivers/vfio/cdx/private.h |  18 +++
 4 files changed, 298 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/cdx/intr.c

diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
index cd4a2e6fe609..df92b320122a 100644
--- a/drivers/vfio/cdx/Makefile
+++ b/drivers/vfio/cdx/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
 
-vfio-cdx-objs := main.o
+vfio-cdx-objs := main.o intr.o
diff --git a/drivers/vfio/cdx/intr.c b/drivers/vfio/cdx/intr.c
new file mode 100644
index 000000000000..986fa2a45fa4
--- /dev/null
+++ b/drivers/vfio/cdx/intr.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/vfio.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/eventfd.h>
+#include <linux/msi.h>
+#include <linux/interrupt.h>
+
+#include "linux/cdx/cdx_bus.h"
+#include "private.h"
+
+static irqreturn_t vfio_cdx_msihandler(int irq_no, void *arg)
+{
+	struct eventfd_ctx *trigger = arg;
+
+	eventfd_signal(trigger);
+	return IRQ_HANDLED;
+}
+
+static int vfio_cdx_msi_enable(struct vfio_cdx_device *vdev, int nvec)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
+	struct device *dev = vdev->vdev.dev;
+	int msi_idx, ret;
+
+	vdev->cdx_irqs = kcalloc(nvec, sizeof(struct vfio_cdx_irq), GFP_KERNEL);
+	if (!vdev->cdx_irqs)
+		return -ENOMEM;
+
+	ret = cdx_enable_msi(cdx_dev);
+	if (ret) {
+		kfree(vdev->cdx_irqs);
+		return ret;
+	}
+
+	/* Allocate cdx MSIs */
+	ret = msi_domain_alloc_irqs(dev, MSI_DEFAULT_DOMAIN, nvec);
+	if (ret) {
+		cdx_disable_msi(cdx_dev);
+		kfree(vdev->cdx_irqs);
+		return ret;
+	}
+
+	for (msi_idx = 0; msi_idx < nvec; msi_idx++)
+		vdev->cdx_irqs[msi_idx].irq_no = msi_get_virq(dev, msi_idx);
+
+	vdev->msi_count = nvec;
+	vdev->config_msi = 1;
+
+	return 0;
+}
+
+static int vfio_cdx_msi_set_vector_signal(struct vfio_cdx_device *vdev,
+					  int vector, int fd)
+{
+	struct eventfd_ctx *trigger;
+	int irq_no, ret;
+
+	if (vector < 0 || vector >= vdev->msi_count)
+		return -EINVAL;
+
+	irq_no = vdev->cdx_irqs[vector].irq_no;
+
+	if (vdev->cdx_irqs[vector].trigger) {
+		free_irq(irq_no, vdev->cdx_irqs[vector].trigger);
+		kfree(vdev->cdx_irqs[vector].name);
+		eventfd_ctx_put(vdev->cdx_irqs[vector].trigger);
+		vdev->cdx_irqs[vector].trigger = NULL;
+	}
+
+	if (fd < 0)
+		return 0;
+
+	vdev->cdx_irqs[vector].name = kasprintf(GFP_KERNEL, "vfio-msi[%d](%s)",
+						vector, dev_name(vdev->vdev.dev));
+	if (!vdev->cdx_irqs[vector].name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		kfree(vdev->cdx_irqs[vector].name);
+		return PTR_ERR(trigger);
+	}
+
+	ret = request_irq(irq_no, vfio_cdx_msihandler, 0,
+			  vdev->cdx_irqs[vector].name, trigger);
+	if (ret) {
+		kfree(vdev->cdx_irqs[vector].name);
+		eventfd_ctx_put(trigger);
+		return ret;
+	}
+
+	vdev->cdx_irqs[vector].trigger = trigger;
+
+	return 0;
+}
+
+static int vfio_cdx_msi_set_block(struct vfio_cdx_device *vdev,
+				  unsigned int start, unsigned int count,
+				  int32_t *fds)
+{
+	int i, j, ret = 0;
+
+	if (start >= vdev->msi_count || start + count > vdev->msi_count)
+		return -EINVAL;
+
+	for (i = 0, j = start; i < count && !ret; i++, j++) {
+		int fd = fds ? fds[i] : -1;
+
+		ret = vfio_cdx_msi_set_vector_signal(vdev, j, fd);
+	}
+
+	if (ret) {
+		for (--j; j >= (int)start; j--)
+			vfio_cdx_msi_set_vector_signal(vdev, j, -1);
+	}
+
+	return ret;
+}
+
+static void vfio_cdx_msi_disable(struct vfio_cdx_device *vdev)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
+	struct device *dev = vdev->vdev.dev;
+
+	vfio_cdx_msi_set_block(vdev, 0, vdev->msi_count, NULL);
+
+	if (!vdev->config_msi)
+		return;
+
+	msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
+	cdx_disable_msi(cdx_dev);
+	kfree(vdev->cdx_irqs);
+
+	vdev->cdx_irqs = NULL;
+	vdev->msi_count = 0;
+	vdev->config_msi = 0;
+}
+
+static int vfio_cdx_set_msi_trigger(struct vfio_cdx_device *vdev,
+				    unsigned int index, unsigned int start,
+				    unsigned int count, u32 flags,
+				    void *data)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
+	int i;
+
+	if (start + count > cdx_dev->num_msi)
+		return -EINVAL;
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		vfio_cdx_msi_disable(vdev);
+		return 0;
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		s32 *fds = data;
+		int ret;
+
+		if (vdev->config_msi)
+			return vfio_cdx_msi_set_block(vdev, start, count,
+						  fds);
+		ret = vfio_cdx_msi_enable(vdev, cdx_dev->num_msi);
+		if (ret)
+			return ret;
+
+		ret = vfio_cdx_msi_set_block(vdev, start, count, fds);
+		if (ret)
+			vfio_cdx_msi_disable(vdev);
+
+		return ret;
+	}
+
+	for (i = start; i < start + count; i++) {
+		if (!vdev->cdx_irqs[i].trigger)
+			continue;
+		if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			eventfd_signal(vdev->cdx_irqs[i].trigger);
+		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+			u8 *bools = data;
+
+			if (bools[i - start])
+				eventfd_signal(vdev->cdx_irqs[i].trigger);
+		}
+	}
+
+	return 0;
+}
+
+int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
+			    u32 flags, unsigned int index,
+			    unsigned int start, unsigned int count,
+			    void *data)
+{
+	if (flags & VFIO_IRQ_SET_ACTION_TRIGGER)
+		return vfio_cdx_set_msi_trigger(vdev, index, start,
+			  count, flags, data);
+	else
+		return -EINVAL;
+}
+
+/* Free All IRQs for the given device */
+void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
+{
+	/*
+	 * Device does not support any interrupt or the interrupts
+	 * were not configured
+	 */
+	if (!vdev->cdx_irqs)
+		return;
+
+	vfio_cdx_set_msi_trigger(vdev, 0, 0, 0, VFIO_IRQ_SET_DATA_NONE, NULL);
+}
diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index 9cff8d75789e..67465fad5b4b 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -61,6 +61,7 @@ static void vfio_cdx_close_device(struct vfio_device *core_vdev)
 
 	kfree(vdev->regions);
 	cdx_dev_reset(core_vdev->dev);
+	vfio_cdx_irqs_cleanup(vdev);
 }
 
 static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
@@ -123,7 +124,7 @@ static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
 	info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
 	info.num_regions = cdx_dev->res_count;
-	info.num_irqs = 0;
+	info.num_irqs = cdx_dev->num_msi ? 1 : 0;
 
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
@@ -152,6 +153,62 @@ static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
+static int vfio_cdx_ioctl_get_irq_info(struct vfio_cdx_device *vdev,
+				       struct vfio_irq_info __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
+	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
+	struct vfio_irq_info info;
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	if (info.index >= 1)
+		return -EINVAL;
+
+	if (!cdx_dev->num_msi)
+		return -EINVAL;
+
+	info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_NORESIZE;
+	info.count = cdx_dev->num_msi;
+
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
+}
+
+static int vfio_cdx_ioctl_set_irqs(struct vfio_cdx_device *vdev,
+				   struct vfio_irq_set __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
+	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
+	struct vfio_irq_set hdr;
+	size_t data_size = 0;
+	u8 *data = NULL;
+	int ret = 0;
+
+	if (copy_from_user(&hdr, arg, minsz))
+		return -EFAULT;
+
+	ret = vfio_set_irqs_validate_and_prepare(&hdr, cdx_dev->num_msi,
+						 1, &data_size);
+	if (ret)
+		return ret;
+
+	if (data_size) {
+		data = memdup_user(arg->data, data_size);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+	}
+
+	ret = vfio_cdx_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
+				      hdr.start, hdr.count, data);
+	kfree(data);
+
+	return ret;
+}
+
 static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
@@ -164,6 +221,10 @@ static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
 		return vfio_cdx_ioctl_get_info(vdev, uarg);
 	case VFIO_DEVICE_GET_REGION_INFO:
 		return vfio_cdx_ioctl_get_region_info(vdev, uarg);
+	case VFIO_DEVICE_GET_IRQ_INFO:
+		return vfio_cdx_ioctl_get_irq_info(vdev, uarg);
+	case VFIO_DEVICE_SET_IRQS:
+		return vfio_cdx_ioctl_set_irqs(vdev, uarg);
 	case VFIO_DEVICE_RESET:
 		return cdx_dev_reset(core_vdev->dev);
 	default:
diff --git a/drivers/vfio/cdx/private.h b/drivers/vfio/cdx/private.h
index 8e9d25913728..dc56729b3114 100644
--- a/drivers/vfio/cdx/private.h
+++ b/drivers/vfio/cdx/private.h
@@ -13,6 +13,14 @@ static inline u64 vfio_cdx_index_to_offset(u32 index)
 	return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
 }
 
+struct vfio_cdx_irq {
+	u32			flags;
+	u32			count;
+	int			irq_no;
+	struct eventfd_ctx	*trigger;
+	char			*name;
+};
+
 struct vfio_cdx_region {
 	u32			flags;
 	u32			type;
@@ -23,8 +31,18 @@ struct vfio_cdx_region {
 struct vfio_cdx_device {
 	struct vfio_device	vdev;
 	struct vfio_cdx_region	*regions;
+	struct vfio_cdx_irq	*cdx_irqs;
 	u32			flags;
 #define BME_SUPPORT BIT(0)
+	u32			msi_count;
+	u8			config_msi;
 };
 
+int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
+			    u32 flags, unsigned int index,
+			    unsigned int start, unsigned int count,
+			    void *data);
+
+void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev);
+
 #endif /* VFIO_CDX_PRIVATE_H */
-- 
2.34.1


