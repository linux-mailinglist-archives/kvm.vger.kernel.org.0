Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5753F14E710
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 03:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgAaCVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 21:21:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:65435 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgAaCVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 21:21:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 18:20:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="262395581"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 18:20:58 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 4/9] vfio/pci: macros to generate module_init and module_exit for vendor modules
Date:   Thu, 30 Jan 2020 21:11:40 -0500
Message-Id: <20200131021140.27774-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131020803.27519-1-yan.y.zhao@intel.com>
References: <20200131020803.27519-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vendor modules call macro module_vfio_pci_register_vendor_handler to
generate module_init and module_exit.
It is a must to ensure that vendor modules always call
vfio_pci_register_vendor_driver() on driver loading and
vfio_pci_unregister_vendor_driver on driver unloading,
because
(1) at compiling time, there's only a dependency of vendor modules on
vfio_pci.
(2) at runtime,
- vendor modules trigger module ref inc of vfio_pci when
  vfio_pci_register_vendor_driver() succeeds and module ref dec of vfio_pci
  when vfio_pci_unregister_vendor_driver() succeeds.
- vfio_pci adds refs of vendor module on a successful probe of vendor
  driver.
  vfio_pci derefs vendor module when unbinding from a device.

After vfio_pci is unbound from a device, the vendor module to that
device is free to get unloaded. However, if that vendor module does not
call vfio_pci_unregister_vendor_driver() before its module_exit, vfio_pc
may hold a stale pointer to vendor module and would be able to get unloaded
for the ref increased in vfio_pci_register_vendor_driver();

That's how module_vfio_pci_register_vendor_handler helps.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/vfio.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 69519cf1fd4f..386d1b19da3d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -226,4 +226,31 @@ extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
 extern void vfio_pci_request(void *device_data, unsigned int count);
 extern int vfio_pci_open(void *device_data);
 extern void vfio_pci_release(void *device_data);
+
+#define vfio_pci_register_vendor_driver(__name, __probe, __remove,	\
+					__device_ops)			\
+static struct vfio_pci_vendor_driver_ops  __ops ## _node = {		\
+	.owner		= THIS_MODULE,					\
+	.name		= __name,					\
+	.probe		= __probe,					\
+	.remove		= __remove,					\
+	.device_ops	= __device_ops,					\
+};									\
+__vfio_pci_register_vendor_driver(&__ops ## _node)
+
+#define module_vfio_pci_register_vendor_handler(name, probe, remove,	\
+						device_ops)		\
+static int __init device_ops ## _module_init(void)			\
+{									\
+	vfio_pci_register_vendor_driver(name, probe, remove,		\
+					device_ops);			\
+	return 0;							\
+};									\
+static void __exit device_ops ## _module_exit(void)			\
+{									\
+	vfio_pci_unregister_vendor_driver(device_ops);			\
+};									\
+module_init(device_ops ## _module_init);				\
+module_exit(device_ops ## _module_exit)
+
 #endif /* VFIO_H */
-- 
2.17.1

