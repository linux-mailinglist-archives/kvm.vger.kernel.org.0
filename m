Return-Path: <kvm+bounces-27039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF6597AE1D
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B24DC1F217FE
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 09:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F997175D5D;
	Tue, 17 Sep 2024 09:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PYO+6Vlt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DE1175548
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 09:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565974; cv=none; b=ghmvvEDQ2VveZOeeD4quj3MUANP71ZYZ6BWeowAE971VRPk98iBCmfxl0tcupmdpJ7fLRVUv0Lhpl64+hgC3AtFbwJDgygSMy2ZC8lgVTEnpQ9T7fmGSja+5fsEB85nFYeleYplxB/608jXR2T687EsNFCjZ8QeRTIK5g5T5Scs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565974; c=relaxed/simple;
	bh=DD7LKAAtg82s+28f/r6UEMp2lwsOQZEDcHe9oYbBG+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvdQsriVps5PhfsXiz+yO/iRVBKXO60XlXxfVb/YDQnIRdO9iF744bp9YpcxSSGvHUuvSAJVmU6OVePf5X2T8i1aqW7WVJco5Wc1gGP3t/6ofjUPblsUL9JmLJZ/aA2V6Al6G4g18EV//Zq5vB6/VNFyKhy/343YoT3oob5Qcj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PYO+6Vlt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726565971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJBF0n0Br65n2hjLZ9wmJHiD+OfAK3na6qQbL7dPnQQ=;
	b=PYO+6VltLLdY26Wsb05/tbyAomQvD/A/zHxNruB98yclDDjl2CbIS4Sz/f7hi6YHKbfUTi
	CiFXjZgNU8W2vNvxiqau5sp5Ev8+5fGDpCzvGINQCLfDjdTTONrkPCAm5ziyS+SE9uzJwe
	XJf5uohSRg6frrcPkXoBEZueymifIho=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-Bm8CA_JRN8av95K9V719Rw-1; Tue,
 17 Sep 2024 05:39:28 -0400
X-MC-Unique: Bm8CA_JRN8av95K9V719Rw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFED419560A3;
	Tue, 17 Sep 2024 09:39:26 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB43E30001A1;
	Tue, 17 Sep 2024 09:39:22 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	treding@nvidia.com,
	vbhadram@nvidia.com,
	jonathanh@nvidia.com,
	mperttunen@nvidia.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	clg@redhat.com,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com
Cc: msalter@redhat.com
Subject: [RFC PATCH v2 6/6] vfio/platform: Add tegra234-mgbe vfio platform reset module
Date: Tue, 17 Sep 2024 11:38:14 +0200
Message-ID: <20240917093851.990344-7-eric.auger@redhat.com>
In-Reply-To: <20240917093851.990344-1-eric.auger@redhat.com>
References: <20240917093851.990344-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

init and release callbacks take care of resources requested by
the reset code, ie. clocks and reset.

The actual reset function toggles the mac reset, disable mac
ihterrupts, stop DMA requests and do a SW reset.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/platform/reset/Kconfig           |   7 +
 drivers/vfio/platform/reset/Makefile          |   2 +
 .../reset/vfio_platform_tegra234_mgbe.c       | 234 ++++++++++++++++++
 3 files changed, 243 insertions(+)
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_tegra234_mgbe.c

diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index dcc08dc145a5..3113fae21ebf 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -14,6 +14,13 @@ config VFIO_PLATFORM_AMDXGBE_RESET
 
 	  If you don't know what to do here, say N.
 
+config VFIO_PLATFORM_TEGRA234_MGBE_RESET
+	tristate "VFIO support for NVidia tegra234 MGBE reset"
+	help
+	  Enables the VFIO platform driver to handle reset for NVidia tegra234 mgbe
+
+	  If you don't know what to do here, say N.
+
 config VFIO_PLATFORM_BCMFLEXRM_RESET
 	tristate "VFIO support for Broadcom FlexRM reset"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
index 7294c5ea122e..5ebef71f61a0 100644
--- a/drivers/vfio/platform/reset/Makefile
+++ b/drivers/vfio/platform/reset/Makefile
@@ -1,7 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
 vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o
+vfio-platform-tegra234-mgbe-y := vfio_platform_tegra234_mgbe.o
 
 obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
 obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
+obj-$(CONFIG_VFIO_PLATFORM_TEGRA234_MGBE_RESET) += vfio-platform-tegra234-mgbe.o
 obj-$(CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET) += vfio_platform_bcmflexrm.o
diff --git a/drivers/vfio/platform/reset/vfio_platform_tegra234_mgbe.c b/drivers/vfio/platform/reset/vfio_platform_tegra234_mgbe.c
new file mode 100644
index 000000000000..8e889e5d04f3
--- /dev/null
+++ b/drivers/vfio/platform/reset/vfio_platform_tegra234_mgbe.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VFIO platform driver specialized for NVidia tegra234-mgbe reset
+ * Code is inspired from dwxgmac2_dma.c and dwmac-tegra.c code
+ *
+ * Copyright (c) 2024 Red Hat, Inc.  All rights reserved.
+ *     Author: Eric Auger <eric.auger@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/reset.h>
+#include <linux/iopoll.h>
+#include <linux/clk.h>
+
+#include "../vfio_platform_private.h"
+
+static const char *const mgbe_clks[] = {
+	"rx-pcs", "tx", "tx-pcs", "mac-divider", "mac", "mgbe", "ptp-ref", "mac"
+};
+
+struct tegra_mgbe {
+	struct clk_bulk_data *clks;
+	struct reset_control *mac_rst;
+	void __iomem *mac;
+};
+
+#define XGMAC_TX_CONFIG                 0x00000000
+#define XGMAC_CONFIG_TE                 BIT(0)
+#define XGMAC_RX_CONFIG                 0x00000004
+#define XGMAC_CONFIG_RE                 BIT(0)
+#define XGMAC_DMA_MODE			0x00003000
+#define XGMAC_SWR			BIT(0)
+
+#define XGMAC_DMA_CH_INT_EN(x)		(0x00003138 + (0x80 * (x)))
+#define XGMAC_TIE			BIT(0)
+#define XGMAC_RIE			BIT(6)
+#define XGMAC_RBUE			BIT(7)
+#define XGMAC_DMA_INT_DEFAULT_RX	(XGMAC_RBUE | XGMAC_RIE)
+#define XGMAC_DMA_INT_DEFAULT_TX	(XGMAC_TIE)
+
+#define XGMAC_DMA_CH_STATUS(x)		(0x00003160 + (0x80 * (x)))
+#define XGMAC_DMA_CH_RX_CONTROL(x)      (0x00003108 + (0x80 * (x)))
+#define XGMAC_RXST                      BIT(0)
+#define XGMAC_DMA_CH_TX_CONTROL(x)      (0x00003104 + (0x80 * (x)))
+#define XGMAC_TXST                      BIT(0)
+
+#define XGMAC_INT_STATUS                0x000000b0
+#define XGMAC_INT_EN                    0x000000b4
+
+#define MGBE_WRAP_COMMON_INTR_ENABLE 0x8704
+
+static int
+toggle_reset(struct device *dev, const char *rst_str, struct reset_control *rst)
+{
+	int ret;
+
+	ret = reset_control_assert(rst);
+	if (ret < 0)
+		dev_err(dev, "Failed to assert %s reset %d\n",
+			rst_str, ret);
+	usleep_range(2000, 4000);
+
+	ret = reset_control_deassert(rst);
+	if (ret < 0)
+		dev_err(dev, "Failed to deassert %s reset %d\n", rst_str, ret);
+	usleep_range(2000, 4000);
+	return ret;
+}
+
+static void stop_dma(void __iomem *mac, uint channel)
+{
+	u32 value;
+
+	/* DMA Stop RX */
+	value = readl(mac + XGMAC_DMA_CH_RX_CONTROL(channel));
+	value &= ~XGMAC_RXST;
+	writel(value, mac + XGMAC_DMA_CH_RX_CONTROL(channel));
+
+	value = readl(mac + XGMAC_RX_CONFIG);
+	value &= ~XGMAC_CONFIG_RE;
+	writel(value, mac + XGMAC_RX_CONFIG);
+
+	usleep_range(10, 15);
+
+	/* DMA Stop TX */
+	value = readl(mac + XGMAC_DMA_CH_TX_CONTROL(channel));
+	value &= ~XGMAC_RXST;
+	writel(value, mac + XGMAC_DMA_CH_TX_CONTROL(channel));
+
+	value = readl(mac + XGMAC_TX_CONFIG);
+	value &= ~XGMAC_CONFIG_TE;
+	writel(value, mac + XGMAC_TX_CONFIG);
+
+	usleep_range(10, 15);
+}
+
+static int dma_sw_reset(void __iomem *mac)
+{
+	u32 value;
+
+	value = readl(mac + XGMAC_DMA_MODE);
+	writel(value | XGMAC_SWR, mac + XGMAC_DMA_MODE);
+	return readl_poll_timeout(mac + XGMAC_DMA_MODE, value,
+				  !(value & XGMAC_SWR), 0, 100000);
+}
+
+static void disable_dma_irq(void __iomem *mac, u32 channel)
+{
+	u32 intr_en, intr_status;
+
+	intr_en = readl(mac + XGMAC_DMA_CH_INT_EN(channel));
+
+	intr_en &= ~XGMAC_DMA_INT_DEFAULT_RX;
+	intr_en &= ~XGMAC_DMA_INT_DEFAULT_TX;
+	writel(intr_en, mac + XGMAC_DMA_CH_INT_EN(channel));
+	usleep_range(10, 15);
+
+	intr_status = readl(mac + XGMAC_DMA_CH_STATUS(channel));
+	writel(0, mac + XGMAC_DMA_CH_STATUS(channel));
+}
+
+static int prepare_enable_clocks(struct device *dev, struct clk_bulk_data **clocks)
+{
+	struct clk_bulk_data *clks;
+	int ret;
+
+	clks = kcalloc(ARRAY_SIZE(mgbe_clks), sizeof(*clks), GFP_KERNEL);
+	if (!clks)
+		return -ENOMEM;
+
+	for (int i = 0; i <  ARRAY_SIZE(mgbe_clks); i++)
+		clks[i].id = mgbe_clks[i];
+
+	ret = devm_clk_bulk_get(dev, ARRAY_SIZE(mgbe_clks), clks);
+	if (ret < 0) {
+		dev_err(dev, "Failed to get clocks %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(mgbe_clks), clks);
+	if (ret < 0) {
+		dev_err(dev, "Failed to prepare_enable clocks %d\n", ret);
+		return ret;
+	}
+	*clocks = clks;
+	return ret;
+}
+
+static int vfio_platform_tegra234_mgbe_init(struct vfio_platform_device *vpdev)
+{
+	struct tegra_mgbe *mgbe;
+	struct vfio_platform_region *mac_regs;
+	struct vfio_device *vdev = &vpdev->vdev;
+	struct device *dev = vdev->dev;
+	int ret = 0;
+
+	mac_regs = vfio_platform_get_region(vpdev, "mac");
+	if (!mac_regs)
+		return -EINVAL;
+
+	mgbe = devm_kmalloc(dev, sizeof(struct tegra_mgbe), GFP_KERNEL);
+	if (!mgbe)
+		return -ENOMEM;
+
+	ret = prepare_enable_clocks(dev, &mgbe->clks);
+	if (ret)
+		return ret;
+
+	mgbe->mac_rst = devm_reset_control_get(dev, "mac");
+	if (IS_ERR(mgbe->mac_rst)) {
+		dev_err(dev, "Failed to get mac reset %ld\n", PTR_ERR(mgbe->mac_rst));
+		ret = PTR_ERR(mgbe->mac_rst);
+		return ret;
+	}
+
+	mac_regs->ioaddr = ioremap(mac_regs->addr, mac_regs->size);
+	if (!mac_regs->ioaddr)
+		return -ENOMEM;
+
+	mgbe->mac = mac_regs->ioaddr;
+	vpdev->reset_opaque = mgbe;
+	return ret;
+}
+
+static void vfio_platform_tegra234_mgbe_release(struct vfio_platform_device *vpdev)
+{
+	struct tegra_mgbe *mgbe = vpdev->reset_opaque;
+
+	/* iounmap is done in vfio_platform_common */
+	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	vpdev->reset_opaque = NULL;
+}
+
+static int vfio_platform_tegra234_mgbe_reset(struct vfio_platform_device *vpdev)
+{
+	struct tegra_mgbe *mgbe = vpdev->reset_opaque;
+	struct vfio_device *vdev = &vpdev->vdev;
+	struct device *dev = vdev->dev;
+	int ret;
+
+	if (!mgbe)
+		return -ENODEV;
+
+	toggle_reset(dev, "mac", mgbe->mac_rst);
+
+	for (int i = 0; i < 10; i++)
+		disable_dma_irq(mgbe->mac, i);
+
+	writel(0, mgbe->mac + MGBE_WRAP_COMMON_INTR_ENABLE);
+
+	for (int i = 0; i < 10; i++)
+		stop_dma(mgbe->mac, i);
+
+	ret = dma_sw_reset(mgbe->mac);
+	if (ret)
+		dev_err(dev, "Failed to reset the DMA %d\n", ret);
+
+	return ret;
+}
+
+static const struct vfio_platform_of_reset_ops
+vfio_platform_tegra234_mgbe_of_reset_ops = {
+	.reset = vfio_platform_tegra234_mgbe_reset,
+	.init = vfio_platform_tegra234_mgbe_init,
+	.release = vfio_platform_tegra234_mgbe_release,
+};
+
+module_vfio_reset_handler("nvidia,tegra234-mgbe", vfio_platform_tegra234_mgbe_of_reset_ops);
+
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Eric Auger <eric.auger@redhat.com>");
+MODULE_DESCRIPTION("Reset support for NVidia tegra234 mgbe vfio platform device");
-- 
2.41.0


