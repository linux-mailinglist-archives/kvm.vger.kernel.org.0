Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8470F3319A9
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhCHVt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232051AbhCHVts (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:49:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yH1qUWM54OHmJwyCpqsZnQPoKLi/478uyIL1lGR3/CE=;
        b=X28ipagwvqIzWxa3TKqi1Idy2qOY547h1xtoEKxHhp225tdEWn4XTEr1n/8qpnIuF9zPuX
        LT+dMmU8nvOeAKQkTz5TeyvgQ8fGlTGbwefh7tIygBbxJX5jlNAbDbVLNWn7lOf+FmLRqa
        Vgv+mN4lAxezuVYqIOU0QNqsEkgf3R0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-1L4UkiF3O_uqkEfajM7MaQ-1; Mon, 08 Mar 2021 16:49:45 -0500
X-MC-Unique: 1L4UkiF3O_uqkEfajM7MaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EF811009E44;
        Mon,  8 Mar 2021 21:49:44 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 444151A8A6;
        Mon,  8 Mar 2021 21:49:43 +0000 (UTC)
Subject: [PATCH v1 13/14] vfio: Remove extern from declarations across vfio
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:49:42 -0700
Message-ID: <161524018283.3480.13909145183028051928.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanup disrecommended usage and docs.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 Documentation/driver-api/vfio-mediated-device.rst |   19 ++-
 Documentation/driver-api/vfio.rst                 |    4 -
 drivers/s390/cio/vfio_ccw_cp.h                    |   13 +-
 drivers/s390/cio/vfio_ccw_private.h               |   14 +-
 drivers/s390/crypto/vfio_ap_private.h             |    2 
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h         |    7 +
 drivers/vfio/pci/vfio_pci_private.h               |   66 +++++------
 drivers/vfio/platform/vfio_platform_private.h     |   31 +++--
 include/linux/vfio.h                              |  122 ++++++++++-----------
 9 files changed, 130 insertions(+), 148 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..7685ef582f7a 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -115,12 +115,11 @@ to register and unregister itself with the core driver:
 
 * Register::
 
-    extern int  mdev_register_driver(struct mdev_driver *drv,
-				   struct module *owner);
+    int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
 
 * Unregister::
 
-    extern void mdev_unregister_driver(struct mdev_driver *drv);
+    void mdev_unregister_driver(struct mdev_driver *drv);
 
 The mediated bus driver is responsible for adding mediated devices to the VFIO
 group when devices are bound to the driver and removing mediated devices from
@@ -162,13 +161,13 @@ The callbacks in the mdev_parent_ops structure are as follows:
 A driver should use the mdev_parent_ops structure in the function call to
 register itself with the mdev core driver::
 
-	extern int  mdev_register_device(struct device *dev,
-	                                 const struct mdev_parent_ops *ops);
+	int  mdev_register_device(struct device *dev,
+				  const struct mdev_parent_ops *ops);
 
 However, the mdev_parent_ops structure is not required in the function call
 that a driver should use to unregister itself with the mdev core driver::
 
-	extern void mdev_unregister_device(struct device *dev);
+	void mdev_unregister_device(struct device *dev);
 
 
 Mediated Device Management Interface Through sysfs
@@ -293,11 +292,11 @@ Translation APIs for Mediated Devices
 The following APIs are provided for translating user pfn to host pfn in a VFIO
 driver::
 
-	extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
-				  int npage, int prot, unsigned long *phys_pfn);
+	int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
+			   int npage, int prot, unsigned long *phys_pfn);
 
-	extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
-				    int npage);
+	int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
+			     int npage);
 
 These functions call back into the back-end IOMMU module by using the pin_pages
 and unpin_pages callbacks of the struct vfio_iommu_driver_ops[4]. Currently
diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index 03e978eb8ec7..e6ba42ca6346 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -252,11 +252,11 @@ into VFIO core.  When devices are bound and unbound to the driver,
 the driver should call vfio_add_group_dev() and vfio_del_group_dev()
 respectively::
 
-	extern struct vfio_device *vfio_add_group_dev(struct device *dev,
+	struct vfio_device *vfio_add_group_dev(struct device *dev,
 					const struct vfio_device_ops *ops,
 					void *device_data);
 
-	extern void *vfio_del_group_dev(struct device *dev);
+	void *vfio_del_group_dev(struct device *dev);
 
 vfio_add_group_dev() indicates to the core to begin tracking the
 iommu_group of the specified dev and register the dev as owned by
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index ba31240ce965..1ea81c4fe630 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -42,12 +42,11 @@ struct channel_program {
 	struct ccw1 *guest_cp;
 };
 
-extern int cp_init(struct channel_program *cp, struct device *mdev,
-		   union orb *orb);
-extern void cp_free(struct channel_program *cp);
-extern int cp_prefetch(struct channel_program *cp);
-extern union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
-extern void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
-extern bool cp_iova_pinned(struct channel_program *cp, u64 iova);
+int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb);
+void cp_free(struct channel_program *cp);
+int cp_prefetch(struct channel_program *cp);
+union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
+void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
+bool cp_iova_pinned(struct channel_program *cp, u64 iova);
 
 #endif
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index b2c762eb42b9..01dff317e063 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -116,10 +116,10 @@ struct vfio_ccw_private {
 	struct work_struct	crw_work;
 } __aligned(8);
 
-extern int vfio_ccw_mdev_reg(struct subchannel *sch);
-extern void vfio_ccw_mdev_unreg(struct subchannel *sch);
+int vfio_ccw_mdev_reg(struct subchannel *sch);
+void vfio_ccw_mdev_unreg(struct subchannel *sch);
 
-extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
+int vfio_ccw_sch_quiesce(struct subchannel *sch);
 
 /*
  * States of the device statemachine.
@@ -150,7 +150,7 @@ enum vfio_ccw_event {
  * Action called through jumptable.
  */
 typedef void (fsm_func_t)(struct vfio_ccw_private *, enum vfio_ccw_event);
-extern fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS];
+fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS];
 
 static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
 				     int event)
@@ -159,12 +159,12 @@ static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
 	vfio_ccw_jumptable[private->state][event](private, event);
 }
 
-extern struct workqueue_struct *vfio_ccw_work_q;
+struct workqueue_struct *vfio_ccw_work_q;
 
 
 /* s390 debug feature, similar to base cio */
-extern debug_info_t *vfio_ccw_debug_msg_id;
-extern debug_info_t *vfio_ccw_debug_trace_id;
+debug_info_t *vfio_ccw_debug_msg_id;
+debug_info_t *vfio_ccw_debug_trace_id;
 
 #define VFIO_CCW_TRACE_EVENT(imp, txt) \
 		debug_text_event(vfio_ccw_debug_trace_id, imp, txt)
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 28e9d9989768..d71a38dd4300 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -45,7 +45,7 @@ struct ap_matrix_dev {
 	struct ap_driver  *vfio_ap_drv;
 };
 
-extern struct ap_matrix_dev *matrix_dev;
+struct ap_matrix_dev *matrix_dev;
 
 /**
  * The AP matrix is comprised of three bit masks identifying the adapters,
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index a97ee691ed47..1c6f93b849e2 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -45,10 +45,9 @@ struct vfio_fsl_mc_device {
 	struct vfio_fsl_mc_irq      *mc_irqs;
 };
 
-extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
-			       u32 flags, unsigned int index,
-			       unsigned int start, unsigned int count,
-			       void *data);
+int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev, u32 flags,
+			       unsigned int index, unsigned int start,
+			       unsigned int count, void *data);
 
 void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev);
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index ba37f4eeefd0..49a60585cf9c 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -149,49 +149,45 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
-extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
+void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
+void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
 
-extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
-				   uint32_t flags, unsigned index,
-				   unsigned start, unsigned count, void *data);
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
+			    uint32_t flags, unsigned index,
+			    unsigned start, unsigned count, void *data);
 
-extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
-				  char __user *buf, size_t count,
-				  loff_t *ppos, bool iswrite);
+ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev, char __user *buf,
+			   size_t count, loff_t *ppos, bool iswrite);
 
-extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
-			       size_t count, loff_t *ppos, bool iswrite);
+ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite);
 
-extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
-			       size_t count, loff_t *ppos, bool iswrite);
+ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite);
 
-extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
-			       uint64_t data, int count, int fd);
+long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
+			uint64_t data, int count, int fd);
 
-extern int vfio_pci_init_perm_bits(void);
-extern void vfio_pci_uninit_perm_bits(void);
+int vfio_pci_init_perm_bits(void);
+void vfio_pci_uninit_perm_bits(void);
 
-extern int vfio_config_init(struct vfio_pci_device *vdev);
-extern void vfio_config_free(struct vfio_pci_device *vdev);
+int vfio_config_init(struct vfio_pci_device *vdev);
+void vfio_config_free(struct vfio_pci_device *vdev);
 
-extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
-					unsigned int type, unsigned int subtype,
-					const struct vfio_pci_regops *ops,
-					size_t size, u32 flags, void *data);
+int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
+				 unsigned int type, unsigned int subtype,
+				 const struct vfio_pci_regops *ops,
+				 size_t size, u32 flags, void *data);
 
-extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
-				    pci_power_t state);
+int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state);
 
-extern bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev);
-extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device
-						    *vdev);
-extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev);
-extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev,
-					       u16 cmd);
+bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev);
+void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev);
+u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev);
+void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd);
 
 #ifdef CONFIG_VFIO_PCI_IGD
-extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
+int vfio_pci_igd_init(struct vfio_pci_device *vdev);
 #else
 static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
 {
@@ -199,8 +195,8 @@ static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
 }
 #endif
 #ifdef CONFIG_VFIO_PCI_NVLINK2
-extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev);
-extern int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev);
+int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev);
+int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev);
 #else
 static inline int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
 {
@@ -214,8 +210,8 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 #endif
 
 #ifdef CONFIG_S390
-extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
-				       struct vfio_info_cap *caps);
+int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
+				struct vfio_info_cap *caps);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 					      struct vfio_info_cap *caps)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 289089910643..2aa12d41f9c6 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -78,22 +78,21 @@ struct vfio_platform_reset_node {
 	vfio_platform_reset_fn_t of_reset;
 };
 
-extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
-				      struct device *dev);
-extern struct vfio_platform_device *vfio_platform_remove_common
-				     (struct device *dev);
-
-extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
-extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
-
-extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
-					uint32_t flags, unsigned index,
-					unsigned start, unsigned count,
-					void *data);
-
-extern void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
-extern void vfio_platform_unregister_reset(const char *compat,
-					   vfio_platform_reset_fn_t fn);
+int vfio_platform_probe_common(struct vfio_platform_device *vdev,
+			       struct device *dev);
+struct vfio_platform_device *vfio_platform_remove_common(struct device *dev);
+
+int vfio_platform_irq_init(struct vfio_platform_device *vdev);
+void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
+
+int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
+				 uint32_t flags, unsigned index,
+				 unsigned start, unsigned count,
+				 void *data);
+
+void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
+void vfio_platform_unregister_reset(const char *compat,
+				    vfio_platform_reset_fn_t fn);
 #define vfio_platform_register_reset(__compat, __reset)		\
 static struct vfio_platform_reset_node __reset ## _node = {	\
 	.owner = THIS_MODULE,					\
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index c3ff36a7fa6f..27a63c1ce219 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -47,25 +47,25 @@ struct vfio_device_ops {
 	int	(*vma_to_pfn)(struct vm_area_struct *vma, unsigned long *pfn);
 };
 
-extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
-extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
+struct iommu_group *vfio_iommu_group_get(struct device *dev);
+void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
-extern struct vfio_device *vfio_add_group_dev(struct device *dev,
+struct vfio_device *vfio_add_group_dev(struct device *dev,
 					const struct vfio_device_ops *ops,
 					void *device_data);
 
-extern void *vfio_del_group_dev(struct device *dev);
-extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
-extern void vfio_device_put(struct vfio_device *device);
-extern void *vfio_device_data(struct vfio_device *device);
-extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
-					    loff_t start, loff_t len);
-extern struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);
-extern int vfio_vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn);
-extern int vfio_device_register_notifier(struct vfio_device *device,
-					 struct notifier_block *nb);
-extern void vfio_device_unregister_notifier(struct vfio_device *device,
-					    struct notifier_block *nb);
+void *vfio_del_group_dev(struct device *dev);
+struct vfio_device *vfio_device_get_from_dev(struct device *dev);
+void vfio_device_put(struct vfio_device *device);
+void *vfio_device_data(struct vfio_device *device);
+void vfio_device_unmap_mapping_range(struct vfio_device *device,
+				     loff_t start, loff_t len);
+struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);
+int vfio_vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn);
+int vfio_device_register_notifier(struct vfio_device *device,
+				  struct notifier_block *nb);
+void vfio_device_unregister_notifier(struct vfio_device *device,
+				     struct notifier_block *nb);
 enum vfio_device_notify_type {
 	VFIO_DEVICE_RELEASE = 0,
 };
@@ -116,41 +116,37 @@ struct vfio_iommu_driver_ops {
 				  enum vfio_iommu_notify_type event);
 };
 
-extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
+int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 
-extern void vfio_unregister_iommu_driver(
-				const struct vfio_iommu_driver_ops *ops);
+void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 
 /*
  * External user API
  */
-extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
-extern void vfio_group_put_external_user(struct vfio_group *group);
-extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
-								*dev);
-extern bool vfio_external_group_match_file(struct vfio_group *group,
-					   struct file *filep);
-extern int vfio_external_user_iommu_id(struct vfio_group *group);
-extern long vfio_external_check_extension(struct vfio_group *group,
-					  unsigned long arg);
+struct vfio_group *vfio_group_get_external_user(struct file *filep);
+void vfio_group_put_external_user(struct vfio_group *group);
+struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev);
+bool vfio_external_group_match_file(struct vfio_group *group,
+				    struct file *filep);
+int vfio_external_user_iommu_id(struct vfio_group *group);
+long vfio_external_check_extension(struct vfio_group *group, unsigned long arg);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
-			  int npage, int prot, unsigned long *phys_pfn);
-extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
-			    int npage);
+int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
+		   int npage, int prot, unsigned long *phys_pfn);
+int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage);
 
-extern int vfio_group_pin_pages(struct vfio_group *group,
-				unsigned long *user_iova_pfn, int npage,
-				int prot, unsigned long *phys_pfn);
-extern int vfio_group_unpin_pages(struct vfio_group *group,
-				  unsigned long *user_iova_pfn, int npage);
+int vfio_group_pin_pages(struct vfio_group *group,
+			 unsigned long *user_iova_pfn, int npage,
+			 int prot, unsigned long *phys_pfn);
+int vfio_group_unpin_pages(struct vfio_group *group,
+			   unsigned long *user_iova_pfn, int npage);
 
-extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
-		       void *data, size_t len, bool write);
+int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
+		void *data, size_t len, bool write);
 
-extern struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group);
+struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group);
 
 /* each type has independent events */
 enum vfio_notify_type {
@@ -164,16 +160,14 @@ enum vfio_notify_type {
 /* events for VFIO_GROUP_NOTIFY */
 #define VFIO_GROUP_NOTIFY_SET_KVM	BIT(0)
 
-extern int vfio_register_notifier(struct device *dev,
-				  enum vfio_notify_type type,
-				  unsigned long *required_events,
-				  struct notifier_block *nb);
-extern int vfio_unregister_notifier(struct device *dev,
-				    enum vfio_notify_type type,
-				    struct notifier_block *nb);
+int vfio_register_notifier(struct device *dev, enum vfio_notify_type type,
+			   unsigned long *required_events,
+			   struct notifier_block *nb);
+int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
+			     struct notifier_block *nb);
 
 struct kvm;
-extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
+void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 
 /*
  * Sub-module helpers
@@ -182,25 +176,22 @@ struct vfio_info_cap {
 	struct vfio_info_cap_header *buf;
 	size_t size;
 };
-extern struct vfio_info_cap_header *vfio_info_cap_add(
-		struct vfio_info_cap *caps, size_t size, u16 id, u16 version);
-extern void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
+struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
+					size_t size, u16 id, u16 version);
+void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
 
-extern int vfio_info_add_capability(struct vfio_info_cap *caps,
-				    struct vfio_info_cap_header *cap,
-				    size_t size);
+int vfio_info_add_capability(struct vfio_info_cap *caps,
+			     struct vfio_info_cap_header *cap, size_t size);
 
-extern int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
-					      int num_irqs, int max_irq_type,
-					      size_t *data_size);
+int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
+				       int max_irq_type, size_t *data_size);
 
 struct pci_dev;
 #if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
-extern void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
-extern void vfio_spapr_pci_eeh_release(struct pci_dev *pdev);
-extern long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
-				       unsigned int cmd,
-				       unsigned long arg);
+void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
+void vfio_spapr_pci_eeh_release(struct pci_dev *pdev);
+long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
+				unsigned int cmd, unsigned long arg);
 #else
 static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
 {
@@ -234,10 +225,9 @@ struct virqfd {
 	struct virqfd		**pvirqfd;
 };
 
-extern int vfio_virqfd_enable(void *opaque,
-			      int (*handler)(void *, void *),
-			      void (*thread)(void *, void *),
-			      void *data, struct virqfd **pvirqfd, int fd);
-extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
+int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
+		       void (*thread)(void *, void *), void *data,
+		       struct virqfd **pvirqfd, int fd);
+void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */

