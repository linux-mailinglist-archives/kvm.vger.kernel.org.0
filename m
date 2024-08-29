Return-Path: <kvm+bounces-25389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 770B5964B3C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 267F0286104
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F591B655E;
	Thu, 29 Aug 2024 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RWvrAfED"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B101B6544
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948024; cv=none; b=h/4rlEMDmJJUQpd5eFSDqVu3eJHCO2uDOVrsA1etYbrX0FxDkDOhxmFa8jLWK/Yh6tkCDnv65Opjm6T98kgdn1hZ+RzwkmUtI1aSXZPOcgCz/u6hfg3XK48qsN+e3tasnVD5jluHlpfHpK/OM7Z5ElFQ4OecFFfxXkzkVCKKEdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948024; c=relaxed/simple;
	bh=KCT/Im4Fvd9YLLTHIB3lZFem07rmpnb9pRKAFHkmiTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBjv0SzKsf+n2YLiB9Xmk8EsHzLfbPPCEDusUuWepXcZy2/0aaf5cJtVjx8Hs8LlNCBNIoKcTstonR1mDNleIoTakC6qZhux0DLyLw11y5z2xoDNIj5GDZuaIJkphHb2eOGJhJN0AwOrEY4t5zghEEv0Gx+7MZc+V4n9ShHyfdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RWvrAfED; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724948020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Yw/7hyVTVv1RznBSVo2rovLDwDqynFIB6TkY086V44=;
	b=RWvrAfEDozdZGtt1TJlObu3UXGC2FgDC2953Ogb5nk0+0LLiVfW/Fc9o2quRBzXxYwN+zi
	7hnoDi6afcO+iC/uYupMLIz3MVV2wj50lTtps8ke1eNNQZuZSo3AV5YX0jVNVF1FNmMlbN
	nbF73AN41+TGOH0I6zpXkUoJWVZaZG8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-oSfSuXTZNvm-Be-uwjs_XA-1; Thu,
 29 Aug 2024 12:13:36 -0400
X-MC-Unique: oSfSuXTZNvm-Be-uwjs_XA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED0051954B0A;
	Thu, 29 Aug 2024 16:13:34 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.81])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C1E7619560AA;
	Thu, 29 Aug 2024 16:13:30 +0000 (UTC)
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
Subject: [RFC PATCH 5/5] vfio/platform: Add tegra234-mgbe vfio platform reset module
Date: Thu, 29 Aug 2024 18:11:09 +0200
Message-ID: <20240829161302.607928-6-eric.auger@redhat.com>
In-Reply-To: <20240829161302.607928-1-eric.auger@redhat.com>
References: <20240829161302.607928-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

open and close callbacks take care of resources requested by
the reset code, ie. clocks and reset.

The actual reset function toggles the mac reset, disable mac
ihterrupts, stop DMA requests and do a SW reset.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/platform/reset/Kconfig           |   7 +
 drivers/vfio/platform/reset/Makefile          |   2 +
 .../reset/vfio_platform_tegra234_mgbe.c       | 245 ++++++++++++++++++
 3 files changed, 254 insertions(+)
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
index 000000000000..09b9e10be3ff
--- /dev/null
+++ b/drivers/vfio/platform/reset/vfio_platform_tegra234_mgbe.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VFIO platform driver specialized for NVidia tegra234-mgbe reset
+ * Code is inspired from dwxgmac2_dma.c code
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
+	ret = clk_bulk_get(dev, ARRAY_SIZE(mgbe_clks), clks);
+	if (ret < 0) {
+		dev_err(dev, "Failed to get clocks %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(mgbe_clks), clks);
+	if (ret < 0) {
+		dev_err(dev, "Failed to prepare_enable clocks %d\n", ret);
+		clk_bulk_put(ARRAY_SIZE(mgbe_clks), clks);
+		return ret;
+	}
+	*clocks = clks;
+	return ret;
+}
+
+static int vfio_platform_tegra234_mgbe_open(struct vfio_platform_device *vpdev)
+{
+	struct tegra_mgbe *mgbe;
+	struct vfio_platform_region *mac_regs;
+	struct vfio_device *vdev = &vpdev->vdev;
+	struct device *dev = vdev->dev;
+	int ret;
+
+	mac_regs = vfio_platform_get_region(vpdev, "mac");
+	if (!mac_regs)
+		return -EINVAL;
+
+	mac_regs->ioaddr = ioremap(mac_regs->addr, mac_regs->size);
+	if (!mac_regs->ioaddr)
+		return -ENOMEM;
+
+	mgbe = kmalloc(sizeof(struct tegra_mgbe), GFP_KERNEL);
+	if (!mgbe) {
+		ret = -ENOMEM;
+		goto iounmap;
+	}
+
+	mgbe->mac = mac_regs->ioaddr;
+
+	ret = prepare_enable_clocks(dev, &mgbe->clks);
+	if (ret)
+		goto res_err;
+
+	mgbe->mac_rst = reset_control_get_exclusive(dev, "mac");
+	if (IS_ERR(mgbe->mac_rst)) {
+		dev_err(dev, "Failed to get mac reset %ld\n", PTR_ERR(mgbe->mac_rst));
+		ret = PTR_ERR(mgbe->mac_rst);
+		goto res_err;
+	}
+	vpdev->reset_opaque = mgbe;
+	return 0;
+res_err:
+	kfree(mgbe);
+iounmap:
+	iounmap(mac_regs->ioaddr);
+
+	return ret;
+}
+
+static void vfio_platform_tegra234_mgbe_close(struct vfio_platform_device *vpdev)
+{
+	struct tegra_mgbe *mgbe = vpdev->reset_opaque;
+
+	/* iounmap is done in vfio_platform_common */
+	reset_control_put(mgbe->mac_rst);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	clk_bulk_put(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	kfree(mgbe->clks);
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
+static const struct vfio_platform_reset_ops
+vfio_platform_tegra234_mgbe_reset_ops = {
+	.reset = vfio_platform_tegra234_mgbe_reset,
+	.open = vfio_platform_tegra234_mgbe_open,
+	.close = vfio_platform_tegra234_mgbe_close,
+};
+
+module_vfio_reset_handler("nvidia,tegra234-mgbe", vfio_platform_tegra234_mgbe_reset_ops);
+
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Eric Auger <eric.auger@redhat.com>");
+MODULE_DESCRIPTION("Reset support for NVidia tegra234 mgbe vfio platform device");
-- 
2.41.0


