Return-Path: <kvm+bounces-10865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A10B8714C1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 05:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FD502849C3
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 04:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799F141AAB;
	Tue,  5 Mar 2024 04:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cyHpQIHp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99763EA97;
	Tue,  5 Mar 2024 04:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709613072; cv=fail; b=I5Z8i/cQszPWLlR8v9i+GBHRXavXKeKdrD+EsHUsB1Gsz3tdMO86y5SXC1vc3GfWG3TTe5PibSP1/ER8GMjZnoQ95Xon35AC6alzlBWBk4hXE+eec7qg9cKw0CANL4QyiKeeNFoKr7XF8OXSDj1H4gSCdsJpw0E7TpRS3TQd9l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709613072; c=relaxed/simple;
	bh=GeqZ+CzhvRV3ujdkzaY6DJEi75vskcONLrQtPUYdmzw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+7xTJMzgx+p2COOBMDUfe6b6VEIrSTLaaKqTZsdGyP94JhnY4O3vovKhs6Pf99ns7R2H4mtaCPdi6xhfHwUXU2QywsCvWD2tmnbjvaYNl7SyXINFua30zH8ScyBxfSsKr/HvObVbFHwCg0whH0KqW2GcG/Nay115BZ9N9cqiZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cyHpQIHp; arc=fail smtp.client-ip=40.107.212.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MG8lul5gLiWX0nvicSenTj6veSnX3rYPr8H17uq9/5aUfaFT0bbZWNQlRYG/G7w14JweO4Q1NWVsyyB+lWw/WHYgq/UkVMPkrCSAv2Ci0xHsRsEieJwpAY/4b+PmPrvItMnW+WyNrUFhwrgBK03i6FxEfl7oAy3fMyxhHzCmboux2VWLJa2E/VbimQoXL/Plmq/+CjRMS/50D2YCfKUzUJS1Wj0Ezrxz60Gq4iawT2Po02DRRf8XocsyawKloI7auZ0CN9SJtKNOGec3ZHwNz2CuGpM1ekmHgKrFIuLDvC9yEsobu0Rx5ksJwMVqncXibT3v7qhd9T2eqvXNO44dyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+p0eQX2c1v1+QJIvP3CpUBcPzbZuZCBhMeLnWbCEmuk=;
 b=gPvFprZO4IRxc5Cdv5UwljGP6f3pLP2ilKO+8BX/42amUtusxSsDYPvNZm43hmcfKPSeD1+KC17yhVznADYz8ulX3rj6lhsfnIfZiuqPPKlpjW/AZmmwaYywAeDT+GYINh5UqbTO6Mu5K+9q0cPYZ0VslHms2iHhk24FlHEnbB4SqUnwa70+a3MhMwtq4h6fR4G872/4DaubjMfnuvCXmz8ouOBlVHYLQl2eDkq5eWhrjWl8HnoSndm6QLeyvAIAeDn4rmXJ8jM8CfmRG1vplbdh90GQBJq6Vi+wrDIfHdKYst/2fKyIVrcs3jVcPP8FTgDvgrIzP5vkQkJiCYK/3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+p0eQX2c1v1+QJIvP3CpUBcPzbZuZCBhMeLnWbCEmuk=;
 b=cyHpQIHpPYDEHx9IT0lCQIe2Zofg3SizAUCZwi1E49ioFPnoURD8kHF+MkRsd0lAIgkzZQ1iOg6KyIqv2b5OCKUUCm1N3NlNXSSNxmTevMK+YDolHQ61TvDilXLYQCSi9Bi1k2Gf9d3nLk7nwPOCI+GRtyn6dyxlhPJLuNr8Hs8=
Received: from CH2PR07CA0012.namprd07.prod.outlook.com (2603:10b6:610:20::25)
 by SA1PR12MB7295.namprd12.prod.outlook.com (2603:10b6:806:2b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Tue, 5 Mar
 2024 04:31:04 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:20:cafe::ee) by CH2PR07CA0012.outlook.office365.com
 (2603:10b6:610:20::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39 via Frontend
 Transport; Tue, 5 Mar 2024 04:31:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7362.11 via Frontend Transport; Tue, 5 Mar 2024 04:31:04 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 4 Mar
 2024 22:31:00 -0600
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Mon, 4 Mar 2024 22:30:51 -0600
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <tglx@linutronix.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
	<pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
	<michal.simek@amd.com>, <abhijit.gangurde@amd.com>, <srivatsa@csail.mit.edu>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v4 2/2] vfio/cdx: add interrupt support
Date: Tue, 5 Mar 2024 10:00:40 +0530
Message-ID: <20240305043040.224127-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240305043040.224127-1-nipun.gupta@amd.com>
References: <20240305043040.224127-1-nipun.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|SA1PR12MB7295:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ed90d7-e5c2-477b-8c12-08dc3ccd11ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dE768ydYDfypnKMaZB7ux1fzNKhXiqRMidtfV5Z6vX+sTeijY7OrJRT3vN/YDjTHY+hMQOveaTrli4KW8SEBuLR5+mQP7W6DGtsvxYSPnMttlIpRmqv3SmbEP87IUF7yeoJcwvNw9Y5v6Ocw3iJPNVPK1txxZTutQ+hO76bubHaXkgKxedysDdEjH8TMr4s2dKmIEY/gxSNnHiwXqYeLB+vQfwo5EyoNBz8+U21muPu/KzsDbDwmxQ3oJZaE+hoUNtt6QezPUq+YJCPopgVOUY7IX/opk2ltW1beIGJ4DDHvaNgnVuq+LwFbbEsDcUO8+PplXPnQh3icryGqpYZlUk/Y6ynJ/IRIzPBafuf9pvAf4oieqHDcHhRXDCc4nRL53lxABxfT04P1ve3s9Z2BaMpaO93tUSoBaN0797QgX02CZdwhHr0AO7yNtjKKKn65Npvi6/+Avv9wq71Wdpjk4+RtPQlplDuPkdWSuP4ViXhQHg1oblcqqM4onrLCWmRpIJEuUj6MqIo2hmWdQ4bRkMjZkRGo0lMv+QaQr3eINXeE6k1WOD1oDcnpHszNZPZ02VC9Dh8SNOUE3u+WCnZEiL8PGMHOCvrE36JlizecJcCP7JjI/hlQibiY2NtKKto9NpzmRozq5iC+hefGIn3esTPvEK4ZBJNwanABNzw8zZLA5qhuKG8b86UJH9uTQ/cNhN1tkiqZIJZZTr4qCG9fGw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 04:31:04.2699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ed90d7-e5c2-477b-8c12-08dc3ccd11ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7295

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

Changes v3->v4:
- Added VFIO_IRQ_INFO_NORESIZE flag 

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
index 9cff8d75789e..f0861a38ae10 100644
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


