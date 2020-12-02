Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0672CB87E
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 10:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbgLBJSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 04:18:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:4848 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387658AbgLBJSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 04:18:05 -0500
IronPort-SDR: ClIbe/tXNcNINUlmnbTYoDSQDyqFewgGXtjJYgvhc8L2uYlf77ojbb5l23hFJDJbxREqeiUqB/
 BFvEfZZTmD7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="173082426"
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="173082426"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 01:17:22 -0800
IronPort-SDR: 1PkSdBBPN4QhBoDrBUwcsM0XvfJYNIjRheEQurMBt/wBCoP0zIuEj19MI391l2UOXk24ITR4pA
 6Iu0R19cvrJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="365205218"
Received: from cfl-host.sh.intel.com ([10.239.158.59])
  by fmsmga004.fm.intel.com with ESMTP; 02 Dec 2020 01:17:20 -0800
From:   Fred Gao <fred.gao@intel.com>
To:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc:     Fred Gao <fred.gao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Swee Yee Fonn <swee.yee.fonn@intel.com>
Subject: [PATCH v1] vfio/pci: Add support for opregion v2.0+
Date:   Thu,  3 Dec 2020 01:12:49 +0800
Message-Id: <20201202171249.17083-1-fred.gao@intel.com>
X-Mailer: git-send-email 2.24.1.1.gb6d4d82bd5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When VBT data exceeds 6KB size and cannot be within mailbox #4 starting
from opregion v2.0+, Extended VBT region, next to opregion, is used to
hold the VBT data, so the total size will be opregion size plus
extended VBT region size.

For opregion 2.1+: since rvda is relative offset from opregion base,
rvda as extended VBT start offset should be same as opregion size.

For opregion 2.0: the only difference between opregion 2.0 and 2.1 is
rvda addressing mode besides the version. since rvda is physical host
VBT address and cannot be directly used in guest, it is faked into
opregion 2.1's relative offset.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Swee Yee Fonn <swee.yee.fonn@intel.com>
Signed-off-by: Fred Gao <fred.gao@intel.com>
---
 drivers/vfio/pci/vfio_pci_igd.c | 44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 53d97f459252..78919a289914 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -21,6 +21,17 @@
 #define OPREGION_SIZE		(8 * 1024)
 #define OPREGION_PCI_ADDR	0xfc
 
+/*
+ * opregion 2.0: rvda is the physical VBT address.
+ *
+ * opregion 2.1+: rvda is unsigned, relative offset from
+ * opregion base, and should never point within opregion.
+ */
+#define OPREGION_RDVA		0x3ba
+#define OPREGION_RDVS		0x3c2
+#define OPREGION_VERSION	22
+
+
 static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
 			      size_t count, loff_t *ppos, bool iswrite)
 {
@@ -58,6 +69,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 	u32 addr, size;
 	void *base;
 	int ret;
+	u16 version;
 
 	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
 	if (ret)
@@ -83,6 +95,38 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 
 	size *= 1024; /* In KB */
 
+	/* Support opregion v2.0+ */
+	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
+	if (version >= 0x0200) {
+		u64 rvda;
+		u32 rvds;
+
+		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RDVA));
+		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RDVS));
+		if (rvda && rvds) {
+			u32 offset;
+
+			if (version == 0x0200)
+				offset = (rvda - (u64)addr);
+			else
+				offset = rvda;
+
+			pci_WARN(vdev->pdev, offset != size,
+				"Extended VBT does not follow opregion !\n"
+				"opregion version 0x%x:offset 0x%x\n", version, offset);
+
+			if (version == 0x0200) {
+				/* opregion version v2.0 faked to v2.1 */
+				*(__le16 *)(base + OPREGION_VERSION) =
+					cpu_to_le16(0x0201);
+				/* rvda faked to relative offset */
+				(*(__le64 *)(base + OPREGION_RDVA)) =
+					cpu_to_le64((rvda - (u64)addr));
+			}
+			size = offset + rvds;
+		}
+	}
+
 	if (size != OPREGION_SIZE) {
 		memunmap(base);
 		base = memremap(addr, size, MEMREMAP_WB);
-- 
2.24.1.1.gb6d4d82bd5

