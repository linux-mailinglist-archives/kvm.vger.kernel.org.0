Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C47A7A839E
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbjITNkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 09:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbjITNka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 09:40:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C8DAD;
        Wed, 20 Sep 2023 06:40:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=It6bw/zkU9vlJNYsalCWA6JxGNg3JjU0NoJrCvGrDTFnLrlBsSmaQj52TLEruyVodKoM0cMDfg5SS4IfnnaJ2K6b27C2q2HPi+Dj6PWhFd1Z9e4Rc4vyy6ARGPblSPJdxtGb+6eggAGT7bpvWDFtoPXFHmu/xNnpnCGbajFGT75huvCdiTmsV63KBEREvL839P8eX8Bs9IBmSN5G+If3BAKIFbHl35NuAIIyaJk8rJ6NomBSK4QkPD0YoiC/mu1hGNthqFQYV+5PNgeGl/iqzyTMmg1mIt7TKcIiRoceGp3MWmQfbBaxIlQ3YQyDB16t7jGVM6NzVkEOtxcZKSNW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUPLXcJW6bE+8EoNOLkVqNhZWsLM03IIB05Ua42cJHs=;
 b=Ry60+NpDXUKDwuproGZz7ViqziknbbA5ON9Ati7+jROUbzUjgrH7CB0wUDkDHJaMzpGv7hgutoQ00XE/GX+5eGJGQpcfsoOjgpfon1wi/6kIh8C0PM3dTekXqyf5A8L8w5CKSU6uY05VZ4ppg/D7W4OCdWJ5hiedUMgfvQeBTuuwanbEA4RchHsE/g+RWph5PVwt8TPe8ejS+Ldd4TZIOOqHLdj3T8swdI8RgkH/QlOy9/Jbu7cTCtdLPr0fjuG+cPkn977mZnK/k9U0GCxYjKu8Zq2Z2ruf8668AaeqRlQCAcowv6jrWBGA7WxeBe1No4KRBBCN5cnu8lT2G7U5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUPLXcJW6bE+8EoNOLkVqNhZWsLM03IIB05Ua42cJHs=;
 b=5sukoBeWCxmwgBZUUayzvgap9SrqKG6GpbpVLne2FYZIepggyTaSXq5+A5UHbH5nwVGSeznCETK90dFYZgBOO9JVaJtTG/kgcl2qTecpFUYNJLe60t6Axuzvnua5Q0MLzey0+dUbULSqpT2bEixm43tfuY/8JR+T9CBmdJo0i+E=
Received: from BYAPR05CA0079.namprd05.prod.outlook.com (2603:10b6:a03:e0::20)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Wed, 20 Sep
 2023 13:40:15 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:a03:e0:cafe::54) by BYAPR05CA0079.outlook.office365.com
 (2603:10b6:a03:e0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28 via Frontend
 Transport; Wed, 20 Sep 2023 13:40:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Wed, 20 Sep 2023 13:40:14 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 20 Sep
 2023 08:40:13 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 20 Sep
 2023 08:40:12 -0500
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 20 Sep 2023 08:40:09 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <alex.williamson@redhat.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
        <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
        <michal.simek@amd.com>, <abhijit.gangurde@amd.com>,
        <srivatsa@csail.mit.edu>, Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH] vfio/cdx: add interrupt support
Date:   Wed, 20 Sep 2023 19:09:51 +0530
Message-ID: <20230920133951.16953-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|DM6PR12MB4451:EE_
X-MS-Office365-Filtering-Correlation-Id: 883ca8aa-5a35-407b-9338-08dbb9df1ed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f00jWe/CLJYAxKSvOvOBc6syc8LFH3v2F7hA3ybRapDrICHj73IdYbdwvSIU9GBndUFY9sKPQGZDkUIOTGxQgAcAXAtsKLGB3S6j7vgBcTPHatQGeycTeDXNBh66S3uMrNNASXWeUxvsSRyjVC3yqPOGloegBMOz9ETIsTCyV1jVlRaYnezQwU9SQ9KZom8WMrFcKXZhLeTfCqd/DnKzNCZ5wTH6Y5QO2FfNWWlblq+AyTzkbGoSy3DEEXFMFTlS75ULN8ilU9OoDcJW7ufneJ8wdyVc7a7H75wwA5OdltTG2GaGNeF5ja8qxMLbjmMv3dLXCw9/tRJO++IXb/k0mKPosMCjKbXvhwFJM2ufWqSn1irggDr/sF4A3ZL3wSZ7GHgJXkbyJnxVaWnFyfr4whMOwG6HfpbxzlHofmCubWchB3mhxCADdftolKJTdHbkSFrA+JJLibFfWCg2neBBk35Lvyig7k1tlwpXF5rgHmZrxQwFsnel3kf+UCdx1y8jG5CdS7H0aC1VIcMglpCY+qUjCT7uinmisjD6UuScxRo5kK24JPXN2X7ts8xpA1CxedEvGMEgaTvfQNCNSenPGBT73a6+9p9i/L8QAOQaqyjicuJ5eXMW1o02uRd1r7el6E2tAprumhAYwP+U3sagbs7Sp9RgWrFZkQ5E8axvoH22VAeDWxpsdEqs4FH1qLnp+SJk+6KvtsKqtoNfEODoTuWSazlFCpO3voHjparNrzmd3LFPY99RxJ+wRNpXJGRnojjNvzWuTsp2BPDvI3mjUA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199024)(186009)(82310400011)(1800799009)(36840700001)(46966006)(40470700004)(40460700003)(36756003)(40480700001)(82740400003)(356005)(81166007)(86362001)(36860700001)(26005)(1076003)(47076005)(110136005)(336012)(426003)(478600001)(966005)(6666004)(44832011)(2906002)(5660300002)(8676002)(8936002)(4326008)(41300700001)(316002)(70586007)(70206006)(2616005)(54906003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 13:40:14.7169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 883ca8aa-5a35-407b-9338-08dbb9df1ed0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4451
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
https://lore.kernel.org/all/20230911135259.14046-1-nipun.gupta@amd.com/

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
index de56686581ae..77d5803efb1d 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -50,6 +50,7 @@ static void vfio_cdx_close_device(struct vfio_device *core_vdev)
 
 	kfree(vdev->regions);
 	cdx_dev_reset(core_vdev->dev);
+	vfio_cdx_irqs_cleanup(vdev);
 }
 
 static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
@@ -69,7 +70,7 @@ static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
 	info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
 	info.num_regions = cdx_dev->res_count;
-	info.num_irqs = 0;
+	info.num_irqs = 1;
 
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
@@ -98,6 +99,59 @@ static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
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
+	info.count = cdx_dev->num_msi ? 1 : 0;
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
@@ -110,6 +164,10 @@ static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
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
index 8bdc117ea88e..e813db37df5b 100644
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
@@ -23,6 +31,16 @@ struct vfio_cdx_region {
 struct vfio_cdx_device {
 	struct vfio_device	vdev;
 	struct vfio_cdx_region	*regions;
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
2.17.1

