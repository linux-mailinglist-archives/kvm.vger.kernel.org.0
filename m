Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4781D6F32
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 05:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgERDAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 23:00:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:18994 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgERDAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 23:00:11 -0400
IronPort-SDR: E8nF6okch5IVhBiQVkGQdu2E20vAdSKlISqyXjlWY9db1dCi9g38DnsrgsBSj+gVBctlpMlkPK
 iB4dacBwArdQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 20:00:10 -0700
IronPort-SDR: p0H95gVRAi/oYZb5SAEN6kreT+i2s9dECYuTiMr3NwRKY3i2tL8seL7w1i7MENDt7BPCfEZ2W/
 OckX267ut7OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411105271"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 20:00:07 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 05/10] vfio/pci: export vfio_pci_get_barmap
Date:   Sun, 17 May 2020 22:50:16 -0400
Message-Id: <20200518025016.14317-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518024202.13996-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows vendor driver to read/write to bars directly which is useful
in security checking condition.

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 10 ++++++++++
 include/linux/vfio.h             |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a87992892a9f..e4085311ab28 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -153,6 +153,16 @@ static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 	return 0;
 }
 
+void __iomem *vfio_pci_get_barmap(void *device_data, int bar)
+{
+	int ret;
+	struct vfio_pci_device *vdev = device_data;
+
+	ret = vfio_pci_setup_barmap(vdev, bar);
+	return ret ? ERR_PTR(ret) : vdev->barmap[bar];
+}
+EXPORT_SYMBOL_GPL(vfio_pci_get_barmap);
+
 ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 6310c53f9d36..0c786fec4602 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -234,6 +234,7 @@ extern void *vfio_pci_vendor_data(void *device_data);
 extern int vfio_pci_set_vendor_regions(void *device_data,
 				       int num_vendor_regions);
 extern int vfio_pci_set_vendor_irqs(void *device_data, int num_vendor_irqs);
+extern void __iomem *vfio_pci_get_barmap(void *device_data, int bar);
 
 struct vfio_pci_vendor_driver_ops {
 	char			*name;
-- 
2.17.1

