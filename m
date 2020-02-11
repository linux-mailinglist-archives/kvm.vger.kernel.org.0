Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83D8158C96
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgBKKVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:21:52 -0500
Received: from mga18.intel.com ([134.134.136.126]:16413 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbgBKKVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:21:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:21:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221888480"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:21:49 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 4/9] vfio/pci: macros to generate module_init and module_exit for vendor modules
Date:   Tue, 11 Feb 2020 05:12:25 -0500
Message-Id: <20200211101225.20948-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vendor modules call macro module_vfio_pci_register_vendor_handler to
generate module_init and module_exit.
It is necessary to ensure that vendor modules always call
vfio_pci_register_vendor_driver() on driver loading and
vfio_pci_unregister_vendor_driver on driver unloading,
because
(1) at compiling time, there's only a dependency of vendor modules on
vfio_pci.
(2) at runtime,
- vendor modules add refs of vfio_pci on a successful calling of
  vfio_pci_register_vendor_driver() and deref of vfio_pci on a
  successful calling of vfio_pci_unregister_vendor_driver().
- vfio_pci only adds refs of vendor module on a successful probe of vendor
  driver.
  vfio_pci derefs vendor module when unbinding from a device.

So, after vfio_pci is unbound from a device, the vendor module to that
device is free to get unloaded. However, if that vendor module does not
call vfio_pci_unregister_vendor_driver() in its module_exit, vfio_pci may
hold a stale pointer to vendor module.

That's how module_vfio_pci_register_vendor_handler helps.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/vfio.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 43b2222da2bf..71a03471b208 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -222,4 +222,31 @@ extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
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

