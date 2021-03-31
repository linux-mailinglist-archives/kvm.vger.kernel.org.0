Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0983E348C8F
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhCYJQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:16:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:37019 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCYJQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 05:16:33 -0400
IronPort-SDR: sw/+6bNSX4mAQ1rPiVVZOfjw/MhYNag6bXun6ll9WLiZCVPM07koFe0OrXHS+Zkd9MF4B0u2uW
 bbIU0h9mKpjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="170241098"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="170241098"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 02:16:33 -0700
IronPort-SDR: NTFIndnYFO+inBmHE2s+rW7KAAK4EHsWZKzk6en68eLnL58eOfu8v5vDvHmWnWdYqfJxzoLUtl
 JWfipT+1Bvow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="514538517"
Received: from cfl-host.sh.intel.com ([10.239.158.118])
  by fmsmga001.fm.intel.com with ESMTP; 25 Mar 2021 02:16:31 -0700
From:   Fred Gao <fred.gao@intel.com>
To:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc:     Fred Gao <fred.gao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Swee Yee Fonn <swee.yee.fonn@intel.com>
Subject: [PATCH v5] vfio/pci: Add support for opregion v2.1+
Date:   Fri, 26 Mar 2021 01:09:53 +0800
Message-Id: <20210325170953.24549-1-fred.gao@intel.com>
X-Mailer: git-send-email 2.24.1.1.gb6d4d82bd5
In-Reply-To: <20210302130220.9349-1-fred.gao@intel.com>
References: <20210302130220.9349-1-fred.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before opregion version 2.0 VBT data is stored in opregion mailbox #4,
but when VBT data exceeds 6KB size and cannot be within mailbox #4
then from opregion v2.0+, Extended VBT region, next to opregion is
used to hold the VBT data, so the total size will be opregion size plus
extended VBT region size.

Since opregion v2.0 with physical host VBT address would not be
practically available for end user and guest can not directly access
host physical address, so it is not supported.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Swee Yee Fonn <swee.yee.fonn@intel.com>
Signed-off-by: Fred Gao <fred.gao@intel.com>
---
 drivers/vfio/pci/vfio_pci_igd.c | 53 +++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index e66dfb0178ed..228df565e9bc 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -21,6 +21,10 @@
 #define OPREGION_SIZE		(8 * 1024)
 #define OPREGION_PCI_ADDR	0xfc
 
+#define OPREGION_RVDA		0x3ba
+#define OPREGION_RVDS		0x3c2
+#define OPREGION_VERSION	0x16
+
 static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
 			      size_t count, loff_t *ppos, bool iswrite)
 {
@@ -58,6 +62,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 	u32 addr, size;
 	void *base;
 	int ret;
+	u16 version;
 
 	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
 	if (ret)
@@ -83,6 +88,54 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 
 	size *= 1024; /* In KB */
 
+	/*
+	 * Support opregion v2.1+
+	 * When VBT data exceeds 6KB size and cannot be within mailbox #4, then
+	 * the Extended VBT region next to opregion is used to hold the VBT data.
+	 * RVDA (Relative Address of VBT Data from Opregion Base) and RVDS
+	 * (Raw VBT Data Size) from opregion structure member are used to hold the
+	 * address from region base and size of VBT data. RVDA/RVDS are not
+	 * defined before opregion 2.0.
+	 *
+	 * opregion 2.1+: RVDA is unsigned, relative offset from
+	 * opregion base, and should point to the end of opregion.
+	 * otherwise, exposing to userspace to allow read access to everything between
+	 * the OpRegion and VBT is not safe.
+	 * RVDS is defined as size in bytes.
+	 *
+	 * opregion 2.0: rvda is the physical VBT address.
+	 * Since rvda is HPA it cannot be directly used in guest.
+	 * And it should not be practically available for end user,so it is not supported.
+	 */
+	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
+	if (version >= 0x0200) {
+		u64 rvda;
+		u32 rvds;
+
+		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
+		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
+		if (rvda && rvds) {
+			/* no support for opregion v2.0 with physical VBT address */
+			if (version == 0x0200) {
+				memunmap(base);
+				pci_err(vdev->pdev,
+					"IGD assignment does not support opregion v2.0 with an extended VBT region\n");
+				return -EINVAL;
+			}
+
+			if (rvda != size) {
+				memunmap(base);
+				pci_err(vdev->pdev,
+					"Extended VBT does not follow opregion on version 0x%04x\n",
+					version);
+				return -EINVAL;
+			}
+
+			/* region size for opregion v2.0+: opregion and VBT size. */
+			size += rvds;
+		}
+	}
+
 	if (size != OPREGION_SIZE) {
 		memunmap(base);
 		base = memremap(addr, size, MEMREMAP_WB);
-- 
2.24.1.1.gb6d4d82bd5

