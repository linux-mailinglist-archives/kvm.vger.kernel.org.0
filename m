Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B0E38D250
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhEVAUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:20:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:24108 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhEVAUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:20:44 -0400
IronPort-SDR: hm9HCTDqIBeDvNqHD+FUXrRIZka0ro3BfpXV1f7quv/jgFNhR80wLeZHw+A22guLY4OL4hNwRC
 4Lo/cQ13kDPw==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="181210488"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="181210488"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:19 -0700
IronPort-SDR: DnWxC3uEvh++a+mt4AeZTukx2h2qeH/QP/9ZlhvjTjrCsx7cpYdnIKVux4DyC3oIWDINQuMiCv
 UOfmjP6GTZ7g==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="434499957"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:18 -0700
Subject: [PATCH v6 02/20] dmaengine: idxd: add external module driver support
 for dsa_bus_type
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:17 -0700
Message-ID: <162164275795.261970.6600777460965468381.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to allow an external driver to be registered to the
dsa_bus_type and also auto-loaded.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/idxd.h  |    6 ++++++
 drivers/dma/idxd/init.c  |    2 ++
 drivers/dma/idxd/sysfs.c |    6 ++++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 0970d0e67976..22afaf7ee637 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -483,11 +483,17 @@ static inline int idxd_wq_refcount(struct idxd_wq *wq)
 	return wq->client_count;
 };
 
+#define MODULE_ALIAS_IDXD_DEVICE(type) MODULE_ALIAS("idxd:t" __stringify(type) "*")
+#define IDXD_DEVICES_MODALIAS_FMT "idxd:t%d"
+
 int __must_check __idxd_driver_register(struct idxd_device_driver *idxd_drv,
 					struct module *module, const char *mod_name);
 #define idxd_driver_register(driver) \
 	__idxd_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
 
+#define module_idxd_driver(driver) \
+	module_driver(driver, idxd_driver_register, idxd_driver_unregister)
+
 void idxd_driver_unregister(struct idxd_device_driver *idxd_drv);
 
 int idxd_register_bus_type(void);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 30d3ab0c4051..bed9169152f9 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -843,8 +843,10 @@ int __idxd_driver_register(struct idxd_device_driver *idxd_drv, struct module *o
 
 	return driver_register(drv);
 }
+EXPORT_SYMBOL_GPL(__idxd_driver_register);
 
 void idxd_driver_unregister(struct idxd_device_driver *idxd_drv)
 {
 	driver_unregister(&idxd_drv->drv);
 }
+EXPORT_SYMBOL_GPL(idxd_driver_unregister);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index ff2f1c97ed74..4fcb8833a4df 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -53,11 +53,17 @@ static int idxd_config_bus_remove(struct device *dev)
 	return 0;
 }
 
+static int idxd_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	return add_uevent_var(env, "MODALIAS=" IDXD_DEVICES_MODALIAS_FMT, 0);
+}
+
 struct bus_type dsa_bus_type = {
 	.name = "dsa",
 	.match = idxd_config_bus_match,
 	.probe = idxd_config_bus_probe,
 	.remove = idxd_config_bus_remove,
+	.uevent = idxd_bus_uevent,
 };
 
 #define DRIVER_ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) \


