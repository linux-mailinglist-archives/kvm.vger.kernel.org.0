Return-Path: <kvm+bounces-9773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94641866E6A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47EB7286C6F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F905FBAA;
	Mon, 26 Feb 2024 08:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h1MAGBap"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB835FB8B;
	Mon, 26 Feb 2024 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937315; cv=fail; b=J3Rv1xtMJYcaXhbfhazN5WO2OFYgyy8Ejpb0U6Kdr0/Pd0DnMs/fd97PoFH6E0PPQbbB2MOWf3rms3XlnN9qWrkVV5HfYrR6x7TQydqfoP3133KIKOAtX6XrAcI2hN1kw9MYeihj/1A8OcTmk3itfRTxKJwC/umzvxsdYTFGyZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937315; c=relaxed/simple;
	bh=/aDe9D0KrhQ9o45UAq60HUpeCNPpDrJvU2jTKpVhH5Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcZZmaLvKipWk68ERuKhJ446y42Z7lunQBktKT1D13PUYPothwYTY0SDRna3MD2kC4Ndi2orOOuS9Y5tif8C/1RMHQbR/kgc6KhmQkwVSRD/Z7KKGnjDeVt0cCKNYO9xE8vuCCbWhfJ2HIszUgZPqlTMEPa9Zfp0a2g9xpGLisw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h1MAGBap; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWn+30LSngLB+RrHL11LP1eSEtrXXNz+gImce3cU/of58wNgb+M7VquP3mmYFtiVsOP8cH1H9biy+DrPwbMsl+kqmoVwLgV6ZwK3oGnxCnprQQla7RZVoo4cUz6nIh3tAAseN+dLT+c2HciGDuud3y0SPGJxoZhs1OvBwJlg6CnnuFXEVsnWMlasX6HgctmA17Ghu0o2UZ/IwtKCy/Pj9R/rfF9rXKW5VvvAHhCpV5C5lXc5w7nD2vf7eXLCpXKvxxNZ8o9cmXqQlKiayN77c5aajgEPKXzBEBBc0BEBiD4JY8eLMbsfJGvWad34T2EDo/lUOB8YkEUWGuoGvic/sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8AL+t2QJNpVp0VxAsyctdc0pObEmwJ1BDmSvC+b+1I=;
 b=h4Tj3Rv5I73z5iGHAqWCQJLFHPp8eJkqb1aITOhxADi7VdVcY6CwVJFqSulfrlPjNa6RVlf6UIapcFNBRPFT5P8r/lG6ejDGeA6saFHVkPdW5a/OMic7NznP1Gfgpxu2TM5awp3hSDn/xRA5/zSYBeruUXF5UGW6KrRo+V9ihls6suFNRyG3Z+eo9S02BprUSLMAl5zgdblhxljiovc8+JbbHMobKavj1tL8a/vA/U2poGN67MBm2gZl890+abuvBJzYDq7s444+DBcaxImjumGp9SJaEeano60XT2EYT9n0EI5v0kBMu+P2TS5HzTr9s8YI1nX2lArmmIDAFN1FZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8AL+t2QJNpVp0VxAsyctdc0pObEmwJ1BDmSvC+b+1I=;
 b=h1MAGBapESP8GC/8Owy2v5CWzDBfzbyXUyY1fOcHzTftfDFAzs1/drR7f/Q9Mc6DVpDa5h86SvwIJnLmpoYTU6JnPxA8fEd6mSmeu/ALyWxXaBHpRXHN3oN4j4mkmbcAwHwYSh9x0npFhaa/AEwhjWsYzjUjDARDTuZw7xw7yUc=
Received: from BL0PR0102CA0033.prod.exchangelabs.com (2603:10b6:207:18::46) by
 PH7PR12MB6979.namprd12.prod.outlook.com (2603:10b6:510:1b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 08:48:30 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:207:18:cafe::dc) by BL0PR0102CA0033.outlook.office365.com
 (2603:10b6:207:18::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 08:48:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 08:48:30 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 02:48:29 -0600
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Mon, 26 Feb 2024 02:48:26 -0600
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <tglx@linutronix.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
	<pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
	<michal.simek@amd.com>, <abhijit.gangurde@amd.com>, <srivatsa@csail.mit.edu>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v3 2/2] vfio/cdx: add interrupt support
Date: Mon, 26 Feb 2024 14:18:13 +0530
Message-ID: <20240226084813.101432-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240226084813.101432-1-nipun.gupta@amd.com>
References: <20240226084813.101432-1-nipun.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: nipun.gupta@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|PH7PR12MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: 44813053-139b-4841-d313-08dc36a7b510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XItRmogRP+wf79UouS3tIKYKYN0AvdEFsf5fhmrJMvJbjQClq8Zu6KEHgDozBCqmxOVmLB7Qsk1KvRq9UouIK0cCM3LFSK7O1mfogexSnOvV6Yp767PdsCNu9zEpphmqkPiOnbPr4fqhHIOGBmYAIQhiWvytDUMHpfxxE6PV65kJN/PsH4ZMXyz1GZH8tOa8Q1DaZ8Be6o7YxsphSMmm2E6H82FKYEt9K7w1PPlNz65XqopnEiKS5rgpCQGR1CeV0ytnFEZwpY+PjPllazFTCfmrSfg26FPBUocUCl3mNzEEtHjcWb+YJNoR/Ys11WHBZAYyYM9GIp0kyajavDTe0UaLMiOOytK1MN9k+aiTRbN36Iq42p2vcm4io/6V9aKpQMpW+aFoq5gd5CtyaG4qUOqdeiVji2E0gCy6HW3ZFikHRLj8jItgND58tR4Qz5O4hAnq+dkugxvhpmhjJthrwEgPMybn5DQPxDmtDxmsNgIJyCdXQX9DPs9hBIInJsNogT8LjBXFO/8e8apOjFrVhfjEt4QBBqL1IaAAOeLQxxU9q+nOFIIQseKXXr0fulU5hQKrT5FfFooBduwthp/qxEz02Tfcu4g4wYrJmG/FoEeQ/ognPejBxhhwxwxKFDDS6zTL6B4t2RIG4R1NVvj92ttneGC7busgRVm2Yl9g5hNehkK1bPErN1a7zU9Wn1R4Rx5SMyVNU+p8t6dIDqJn4jjd4s+t0jhokG7rY3LB1zalhNDA/fWyVEPWXJPZdXfT
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 08:48:30.4672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44813053-139b-4841-d313-08dc36a7b510
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6979

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

This patch depends on CDX MSI support patch:
https://lore.kernel.org/lkml/20240226082816.100872-1-nipun.gupta@amd.com/

Changes v2->v3:
- Use generic MSI alloc/free APIs instead of CDX MSI APIs
- Rebased on Linux 6.8-rc6

Changes v1->v2:
- Rebased on Linux 6.7-rc1

 drivers/vfio/cdx/Makefile  |   2 +-
 drivers/vfio/cdx/intr.c    | 211 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/cdx/main.c    |  60 ++++++++++-
 drivers/vfio/cdx/private.h |  18 ++++
 4 files changed, 289 insertions(+), 2 deletions(-)
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
index 000000000000..4637b57d0242
--- /dev/null
+++ b/drivers/vfio/cdx/intr.c
@@ -0,0 +1,211 @@
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
+	vdev->irq_count = nvec;
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
+	if (vector < 0 || vector >= vdev->irq_count)
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
+	if (start >= vdev->irq_count || start + count > vdev->irq_count)
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
+	vfio_cdx_msi_set_block(vdev, 0, vdev->irq_count, NULL);
+
+	if (!vdev->config_msi)
+		return;
+
+	msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
+	cdx_disable_msi(cdx_dev);
+	kfree(vdev->cdx_irqs);
+
+	vdev->cdx_irqs = NULL;
+	vdev->irq_count = 0;
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
+		if (flags & VFIO_IRQ_SET_DATA_NONE)
+			eventfd_signal(vdev->cdx_irqs[i].trigger);
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
+	vfio_cdx_set_msi_trigger(vdev, 1, 0, 0, VFIO_IRQ_SET_DATA_NONE, NULL);
+}
diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index 9cff8d75789e..eb1c5879150b 100644
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
@@ -152,6 +153,59 @@ static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
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
+	info.flags = VFIO_IRQ_INFO_EVENTFD;
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
@@ -164,6 +218,10 @@ static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
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
index 8e9d25913728..7a8477ae4652 100644
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
@@ -25,6 +33,16 @@ struct vfio_cdx_device {
 	struct vfio_cdx_region	*regions;
 	u32			flags;
 #define BME_SUPPORT BIT(0)
+	struct vfio_cdx_irq	*cdx_irqs;
+	u32			irq_count;
+	u32			config_msi;
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


