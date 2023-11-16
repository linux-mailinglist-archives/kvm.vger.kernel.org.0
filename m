Return-Path: <kvm+bounces-1884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6A37EE106
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 14:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3025928101C
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 13:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6312D30645;
	Thu, 16 Nov 2023 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2KK5l3lB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AEF1A3;
	Thu, 16 Nov 2023 05:03:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrdZIPkME8tpdBVWz0drvLZvAkuzSMeoiiYVUJTsfMGN+RW/LQ7JajmEdah9/3QcozL1PfUzbXIzNiElrwPZF7AXpIwKHhH9nPe5dUF4VuXW/H7B4asf/KWccgxWle3vGrDhdRdcN2KajiD9ZDKRH5TbrrJkBvBoSDUX9VQ/7pcvw4Q1K9d8xf1Sn5BfnBZ8GXuLpHHSvhDZjbtbmdoEFT1uCaYayX+JS0esEHBV6t5ZDU3FLp0gt2odz+7o1q4cPfXH7+ej1QKp45nIz3xCfbtVhvlmrMh6J1DM3tK4Wxsy2SvaFQQMA7WzcZPAAO+cM29yWZnT9wm/1AdlB2hqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsr2l/gOVLTwkfyzaq2zc3FZKe0ulpqyK0EhmAq0dmI=;
 b=l4mOc+bKgTB64XVIgAYVuzlAQFEK2ZGj4VrVypAVYxurdEs0pA5M1nLI6mGlVBFwY8/ULVcp2JzqGS+aKVBUmApSy024YgcuDg1NysHVVyrPppS0EB7/H7AhMLi2n/1DWvyPNBbL9tfMHk5yCiqXJA5BJ6HfVH4kxgGH34WCwbNYss1kri7Xg7wHV4Xmk1B4Fp2Dm5I49av72Mi9FtOx951Fml3N0RVsIAtf7Yhp/J7vDUWqnlLQxT+ZbgDGn1aVK9BmzV9KaYziVlrgTN4vmG4ImikSgXQ2sWWC0ahinTV3ThEvs0H4pz+AouUGhkuecMF0J6EVLf+VBPloxaCUww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsr2l/gOVLTwkfyzaq2zc3FZKe0ulpqyK0EhmAq0dmI=;
 b=2KK5l3lBjdjiChOmW+qMZpudnBWJKCGJ79X99WdOOJOP+r8xU/KTDHVqA4JSGuoJyn0MGNIb0OpJUepUriKVNkd5i+oS9xT8T4kPA0VKhkeHzu0Y77kV9gn9jMWcvrjmlgkdaZUp+hzt1KTSwimZhzCjqH42rtYcP/4fVnTNz1M=
Received: from BL1PR13CA0014.namprd13.prod.outlook.com (2603:10b6:208:256::19)
 by PH8PR12MB7326.namprd12.prod.outlook.com (2603:10b6:510:216::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Thu, 16 Nov
 2023 13:03:33 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:256:cafe::ac) by BL1PR13CA0014.outlook.office365.com
 (2603:10b6:208:256::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17 via Frontend
 Transport; Thu, 16 Nov 2023 13:03:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.19 via Frontend Transport; Thu, 16 Nov 2023 13:03:33 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 07:03:32 -0600
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.32 via Frontend
 Transport; Thu, 16 Nov 2023 07:03:28 -0600
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <tglx@linutronix.de>, <maz@kernel.org>,
	<git@amd.com>, <harpreet.anand@amd.com>, <pieter.jansen-van-vuuren@amd.com>,
	<nikhil.agarwal@amd.com>, <michal.simek@amd.com>, <abhijit.gangurde@amd.com>,
	<srivatsa@csail.mit.edu>, Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v2] vfio/cdx: add interrupt support
Date: Thu, 16 Nov 2023 18:33:19 +0530
Message-ID: <20231116130319.245376-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|PH8PR12MB7326:EE_
X-MS-Office365-Filtering-Correlation-Id: 84b46be2-377c-4435-4eb4-08dbe6a47032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Tj7pC14Dsh/n5/sVA6jq9Wgb/u0yjlUvAsuKHP+fqIZAb/HGzGsE3gyMrgQp66Jt1upxKfWsAQlibPZnskBdw2+cJS61/yiwtvZvGeQrAVgXj4CvFth+Zrs7Ary8SDdHQL8T7DcdVtB80QXuvacEq93XXqmjBMFhQtSGkXByMrS3T8FpRAo2LIMR1BNjLmkBUmWwxdF9FapIu7DsTegM9KsxUrysJAO0iV9T9f25ok4ebUj2FFdrgOWzrffAqR+y6XHbavFhS5tEiOSwZzmN+O74cUXJqktJONMSovODMDwRATmfgc73IjZKtjNFZbxK/saxP+hAjQd4ImhXy/VByrOoxY1evfBO2zQ0DgHhaNnXMX00QiJmLYgPhlFwGtUXCFegO8Xzd4DgE3dXD/ZGIy4dWtZeNDe0tdIC87+zCKvXRmbDjT5FJYJIHChqOh6dHnpBquY4FvjVISmJpkhZrzRWWbPohwvLIE/fDc/1Z+H+GM54R4xCIIzTz3RTFhenELo1GhlpqqqEACmOznCk5JZDY3ErrUqjBnKzv8TgVNVtL1IjOib6spziAdPrAf215nK2222ZYKBwV2Xki/hRsUPKHCCUOHkjS2LVonhoisSvJZ3UWB4OIlmd2kPGVWAkXR9agNHB88YqNPcxgIeYUQYAFPQKJKkSFwitGDk13L+LrPzcenRRoY9nFWih7cHpqxJaaV6CpciPW0H2z8nUlnp7eSEjP4jwdF/PeqQqukRpMIKszZ7b+lKZqe69qjpD14YAMWvD/ece1KE0m+Idqg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(39860400002)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(82310400011)(36840700001)(40470700004)(46966006)(316002)(54906003)(36756003)(110136005)(70206006)(70586007)(26005)(1076003)(336012)(426003)(2616005)(966005)(478600001)(40460700003)(6666004)(36860700001)(86362001)(5660300002)(47076005)(82740400003)(356005)(81166007)(2906002)(83380400001)(40480700001)(8936002)(41300700001)(44832011)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 13:03:33.4114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b46be2-377c-4435-4eb4-08dbe6a47032
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7326

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
https://lore.kernel.org/lkml/20231116125609.245206-1-nipun.gupta@amd.com/

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
index 000000000000..2ee959fbca0c
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
+	eventfd_signal(trigger, 1);
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
+	ret = cdx_msi_domain_alloc_irqs(dev, nvec);
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
+	cdx_msi_domain_free_irqs(dev, MSI_DEFAULT_DOMAIN);
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
+			eventfd_signal(vdev->cdx_irqs[i].trigger, 1);
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


