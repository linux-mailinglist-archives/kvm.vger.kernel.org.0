Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE4F158C8E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgBKKUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:20:04 -0500
Received: from mga12.intel.com ([192.55.52.136]:55698 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgBKKUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:20:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:20:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221888182"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:19:58 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 1/9] vfio/pci: export vfio_pci_device public and add vfio_pci_device_private
Date:   Tue, 11 Feb 2020 05:10:38 -0500
Message-Id: <20200211101038.20772-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(1) make vfio_pci_device public, so it is accessible from external code.
(2) add a private struct vfio_pci_device_private, which is only accessible
from internal code. It extends struct vfio_pci_device.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 256 +++++++++++++++-------------
 drivers/vfio/pci/vfio_pci_config.c  | 186 ++++++++++++--------
 drivers/vfio/pci/vfio_pci_igd.c     |  19 ++-
 drivers/vfio/pci/vfio_pci_intrs.c   | 186 +++++++++++---------
 drivers/vfio/pci/vfio_pci_nvlink2.c |  22 +--
 drivers/vfio/pci/vfio_pci_private.h |   7 +-
 drivers/vfio/pci/vfio_pci_rdwr.c    |  40 +++--
 include/linux/vfio.h                |   5 +
 8 files changed, 408 insertions(+), 313 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 02206162eaa9..f19e2dc498a4 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -112,8 +112,9 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 	struct resource *res;
 	int bar;
 	struct vfio_pci_dummy_resource *dummy_res;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
+	INIT_LIST_HEAD(&priv->dummy_resources_list);
 
 	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
 		res = vdev->pdev->resource + bar;
@@ -133,7 +134,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 			goto no_mmap;
 
 		if (resource_size(res) >= PAGE_SIZE) {
-			vdev->bar_mmap_supported[bar] = true;
+			priv->bar_mmap_supported[bar] = true;
 			continue;
 		}
 
@@ -158,8 +159,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 			}
 			dummy_res->index = bar;
 			list_add(&dummy_res->res_next,
-					&vdev->dummy_resources_list);
-			vdev->bar_mmap_supported[bar] = true;
+					&priv->dummy_resources_list);
+			priv->bar_mmap_supported[bar] = true;
 			continue;
 		}
 		/*
@@ -171,7 +172,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 		 * the BAR's location in a page.
 		 */
 no_mmap:
-		vdev->bar_mmap_supported[bar] = false;
+		priv->bar_mmap_supported[bar] = false;
 	}
 }
 
@@ -210,6 +211,7 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	u16 pmcsr;
 
 	if (!pdev->pm_cap)
@@ -217,7 +219,7 @@ static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 
 	pci_read_config_word(pdev, pdev->pm_cap + PCI_PM_CTRL, &pmcsr);
 
-	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
+	priv->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
 }
 
 /*
@@ -231,9 +233,10 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	bool needs_restore = false, needs_save = false;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int ret;
 
-	if (vdev->needs_pm_restore) {
+	if (priv->needs_pm_restore) {
 		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
 			pci_save_state(pdev);
 			needs_save = true;
@@ -248,9 +251,9 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	if (!ret) {
 		/* D3 might be unsupported via quirk, skip unless in D3 */
 		if (needs_save && pdev->current_state >= PCI_D3hot) {
-			vdev->pm_save = pci_store_saved_state(pdev);
+			priv->pm_save = pci_store_saved_state(pdev);
 		} else if (needs_restore) {
-			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
+			pci_load_and_free_saved_state(pdev, &priv->pm_save);
 			pci_restore_state(pdev);
 		}
 	}
@@ -261,6 +264,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int ret;
 	u16 cmd;
 	u8 msix_pos;
@@ -281,31 +285,31 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		return ret;
 	}
 
-	vdev->reset_works = !ret;
+	priv->reset_works = !ret;
 	pci_save_state(pdev);
-	vdev->pci_saved_state = pci_store_saved_state(pdev);
-	if (!vdev->pci_saved_state)
+	priv->pci_saved_state = pci_store_saved_state(pdev);
+	if (!priv->pci_saved_state)
 		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
 
 	if (likely(!nointxmask)) {
 		if (vfio_pci_nointx(pdev)) {
 			pci_info(pdev, "Masking broken INTx support\n");
-			vdev->nointx = true;
+			priv->nointx = true;
 			pci_intx(pdev, 0);
 		} else
-			vdev->pci_2_3 = pci_intx_mask_supported(pdev);
+			priv->pci_2_3 = pci_intx_mask_supported(pdev);
 	}
 
 	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-	if (vdev->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
+	if (priv->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
 		cmd &= ~PCI_COMMAND_INTX_DISABLE;
 		pci_write_config_word(pdev, PCI_COMMAND, cmd);
 	}
 
 	ret = vfio_config_init(vdev);
 	if (ret) {
-		kfree(vdev->pci_saved_state);
-		vdev->pci_saved_state = NULL;
+		kfree(priv->pci_saved_state);
+		priv->pci_saved_state = NULL;
 		pci_disable_device(pdev);
 		return ret;
 	}
@@ -318,14 +322,14 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		pci_read_config_word(pdev, msix_pos + PCI_MSIX_FLAGS, &flags);
 		pci_read_config_dword(pdev, msix_pos + PCI_MSIX_TABLE, &table);
 
-		vdev->msix_bar = table & PCI_MSIX_TABLE_BIR;
-		vdev->msix_offset = table & PCI_MSIX_TABLE_OFFSET;
-		vdev->msix_size = ((flags & PCI_MSIX_FLAGS_QSIZE) + 1) * 16;
+		priv->msix_bar = table & PCI_MSIX_TABLE_BIR;
+		priv->msix_offset = table & PCI_MSIX_TABLE_OFFSET;
+		priv->msix_size = ((flags & PCI_MSIX_FLAGS_QSIZE) + 1) * 16;
 	} else
-		vdev->msix_bar = 0xFF;
+		priv->msix_bar = 0xFF;
 
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
-		vdev->has_vga = true;
+		priv->has_vga = true;
 
 
 	if (vfio_pci_is_vga(pdev) &&
@@ -369,6 +373,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
 	int i, bar;
 
@@ -381,40 +386,40 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 	/* Device closed, don't need mutex here */
 	list_for_each_entry_safe(ioeventfd, ioeventfd_tmp,
-				 &vdev->ioeventfds_list, next) {
+				 &priv->ioeventfds_list, next) {
 		vfio_virqfd_disable(&ioeventfd->virqfd);
 		list_del(&ioeventfd->next);
 		kfree(ioeventfd);
 	}
-	vdev->ioeventfds_nr = 0;
+	priv->ioeventfds_nr = 0;
 
-	vdev->virq_disabled = false;
+	priv->virq_disabled = false;
 
 	for (i = 0; i < vdev->num_regions; i++)
-		vdev->region[i].ops->release(vdev, &vdev->region[i]);
+		priv->region[i].ops->release(vdev, &priv->region[i]);
 
 	vdev->num_regions = 0;
-	kfree(vdev->region);
-	vdev->region = NULL; /* don't krealloc a freed pointer */
+	kfree(priv->region);
+	priv->region = NULL; /* don't krealloc a freed pointer */
 
 	vfio_config_free(vdev);
 
 	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
-		if (!vdev->barmap[bar])
+		if (!priv->barmap[bar])
 			continue;
-		pci_iounmap(pdev, vdev->barmap[bar]);
+		pci_iounmap(pdev, priv->barmap[bar]);
 		pci_release_selected_regions(pdev, 1 << bar);
-		vdev->barmap[bar] = NULL;
+		priv->barmap[bar] = NULL;
 	}
 
 	list_for_each_entry_safe(dummy_res, tmp,
-				 &vdev->dummy_resources_list, res_next) {
+				 &priv->dummy_resources_list, res_next) {
 		list_del(&dummy_res->res_next);
 		release_resource(&dummy_res->resource);
 		kfree(dummy_res);
 	}
 
-	vdev->needs_reset = true;
+	priv->needs_reset = true;
 
 	/*
 	 * If we have saved state, restore it.  If we can reset the device,
@@ -422,10 +427,10 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	 * nothing, but saving and restoring current state without reset
 	 * is just busy work.
 	 */
-	if (pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state)) {
+	if (pci_load_and_free_saved_state(pdev, &priv->pci_saved_state)) {
 		pci_info(pdev, "%s: Couldn't reload saved state\n", __func__);
 
-		if (!vdev->reset_works)
+		if (!priv->reset_works)
 			goto out;
 
 		pci_save_state(pdev);
@@ -444,10 +449,10 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	 * We can not use the "try" reset interface here, which will
 	 * overwrite the previously restored configuration information.
 	 */
-	if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
+	if (priv->reset_works && pci_cfg_access_trylock(pdev)) {
 		if (device_trylock(&pdev->dev)) {
 			if (!__pci_reset_function_locked(pdev))
-				vdev->needs_reset = false;
+				priv->needs_reset = false;
 			device_unlock(&pdev->dev);
 		}
 		pci_cfg_access_unlock(pdev);
@@ -466,15 +471,16 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 static void vfio_pci_release(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
-	mutex_lock(&vdev->reflck->lock);
+	mutex_lock(&priv->reflck->lock);
 
-	if (!(--vdev->refcnt)) {
+	if (!(--priv->refcnt)) {
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
 	}
 
-	mutex_unlock(&vdev->reflck->lock);
+	mutex_unlock(&priv->reflck->lock);
 
 	module_put(THIS_MODULE);
 }
@@ -482,23 +488,24 @@ static void vfio_pci_release(void *device_data)
 static int vfio_pci_open(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int ret = 0;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	mutex_lock(&vdev->reflck->lock);
+	mutex_lock(&priv->reflck->lock);
 
-	if (!vdev->refcnt) {
+	if (!priv->refcnt) {
 		ret = vfio_pci_enable(vdev);
 		if (ret)
 			goto error;
 
 		vfio_spapr_pci_eeh_open(vdev->pdev);
 	}
-	vdev->refcnt++;
+	priv->refcnt++;
 error:
-	mutex_unlock(&vdev->reflck->lock);
+	mutex_unlock(&priv->reflck->lock);
 	if (ret)
 		module_put(THIS_MODULE);
 	return ret;
@@ -506,11 +513,13 @@ static int vfio_pci_open(void *device_data)
 
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
 		u8 pin;
 
 		if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) ||
-		    vdev->nointx || vdev->pdev->is_virtfn)
+		    priv->nointx || vdev->pdev->is_virtfn)
 			return 0;
 
 		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
@@ -668,20 +677,21 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 				 size_t size, u32 flags, void *data)
 {
 	struct vfio_pci_region *region;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
-	region = krealloc(vdev->region,
+	region = krealloc(priv->region,
 			  (vdev->num_regions + 1) * sizeof(*region),
 			  GFP_KERNEL);
 	if (!region)
 		return -ENOMEM;
 
-	vdev->region = region;
-	vdev->region[vdev->num_regions].type = type;
-	vdev->region[vdev->num_regions].subtype = subtype;
-	vdev->region[vdev->num_regions].ops = ops;
-	vdev->region[vdev->num_regions].size = size;
-	vdev->region[vdev->num_regions].flags = flags;
-	vdev->region[vdev->num_regions].data = data;
+	priv->region = region;
+	priv->region[vdev->num_regions].type = type;
+	priv->region[vdev->num_regions].subtype = subtype;
+	priv->region[vdev->num_regions].ops = ops;
+	priv->region[vdev->num_regions].size = size;
+	priv->region[vdev->num_regions].flags = flags;
+	priv->region[vdev->num_regions].data = data;
 
 	vdev->num_regions++;
 
@@ -693,6 +703,7 @@ static long vfio_pci_ioctl(void *device_data,
 {
 	struct vfio_pci_device *vdev = device_data;
 	unsigned long minsz;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
 		struct vfio_device_info info;
@@ -707,7 +718,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 		info.flags = VFIO_DEVICE_FLAGS_PCI;
 
-		if (vdev->reset_works)
+		if (priv->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
 		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
@@ -747,9 +758,9 @@ static long vfio_pci_ioctl(void *device_data,
 
 			info.flags = VFIO_REGION_INFO_FLAG_READ |
 				     VFIO_REGION_INFO_FLAG_WRITE;
-			if (vdev->bar_mmap_supported[info.index]) {
+			if (priv->bar_mmap_supported[info.index]) {
 				info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
-				if (info.index == vdev->msix_bar) {
+				if (info.index == priv->msix_bar) {
 					ret = msix_mmappable_cap(vdev, &caps);
 					if (ret)
 						return ret;
@@ -797,7 +808,7 @@ static long vfio_pci_ioctl(void *device_data,
 			break;
 		}
 		case VFIO_PCI_VGA_REGION_INDEX:
-			if (!vdev->has_vga)
+			if (!priv->has_vga)
 				return -EINVAL;
 
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
@@ -822,20 +833,20 @@ static long vfio_pci_ioctl(void *device_data,
 			i = info.index - VFIO_PCI_NUM_REGIONS;
 
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = vdev->region[i].size;
-			info.flags = vdev->region[i].flags;
+			info.size = priv->region[i].size;
+			info.flags = priv->region[i].flags;
 
-			cap_type.type = vdev->region[i].type;
-			cap_type.subtype = vdev->region[i].subtype;
+			cap_type.type = priv->region[i].type;
+			cap_type.subtype = priv->region[i].subtype;
 
 			ret = vfio_info_add_capability(&caps, &cap_type.header,
 						       sizeof(cap_type));
 			if (ret)
 				return ret;
 
-			if (vdev->region[i].ops->add_capability) {
-				ret = vdev->region[i].ops->add_capability(vdev,
-						&vdev->region[i], &caps);
+			if (priv->region[i].ops->add_capability) {
+				ret = priv->region[i].ops->add_capability(vdev,
+						&priv->region[i], &caps);
 				if (ret)
 					return ret;
 			}
@@ -925,18 +936,18 @@ static long vfio_pci_ioctl(void *device_data,
 				return PTR_ERR(data);
 		}
 
-		mutex_lock(&vdev->igate);
+		mutex_lock(&priv->igate);
 
 		ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
 					      hdr.start, hdr.count, data);
 
-		mutex_unlock(&vdev->igate);
+		mutex_unlock(&priv->igate);
 		kfree(data);
 
 		return ret;
 
 	} else if (cmd == VFIO_DEVICE_RESET) {
-		return vdev->reset_works ?
+		return priv->reset_works ?
 			pci_try_reset_function(vdev->pdev) : -EINVAL;
 
 	} else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
@@ -1147,6 +1158,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
@@ -1167,7 +1179,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
 	default:
 		index -= VFIO_PCI_NUM_REGIONS;
-		return vdev->region[index].ops->rw(vdev, buf,
+		return priv->region[index].ops->rw(vdev, buf,
 						   count, ppos, iswrite);
 	}
 
@@ -1195,6 +1207,7 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
@@ -1208,7 +1221,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 		return -EINVAL;
 	if (index >= VFIO_PCI_NUM_REGIONS) {
 		int regnum = index - VFIO_PCI_NUM_REGIONS;
-		struct vfio_pci_region *region = vdev->region + regnum;
+		struct vfio_pci_region *region = priv->region + regnum;
 
 		if (region && region->ops && region->ops->mmap &&
 		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
@@ -1217,7 +1230,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	}
 	if (index >= VFIO_PCI_ROM_REGION_INDEX)
 		return -EINVAL;
-	if (!vdev->bar_mmap_supported[index])
+	if (!priv->bar_mmap_supported[index])
 		return -EINVAL;
 
 	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
@@ -1233,14 +1246,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	 * Even though we don't make use of the barmap for the mmap,
 	 * we need to request the region and the barmap tracks that.
 	 */
-	if (!vdev->barmap[index]) {
+	if (!priv->barmap[index]) {
 		ret = pci_request_selected_regions(pdev,
 						   1 << index, "vfio-pci");
 		if (ret)
 			return ret;
 
-		vdev->barmap[index] = pci_iomap(pdev, index, 0);
-		if (!vdev->barmap[index]) {
+		priv->barmap[index] = pci_iomap(pdev, index, 0);
+		if (!priv->barmap[index]) {
 			pci_release_selected_regions(pdev, 1 << index);
 			return -ENOMEM;
 		}
@@ -1258,21 +1271,22 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
-	mutex_lock(&vdev->igate);
+	mutex_lock(&priv->igate);
 
-	if (vdev->req_trigger) {
+	if (priv->req_trigger) {
 		if (!(count % 10))
 			pci_notice_ratelimited(pdev,
 				"Relaying device request to user (#%u)\n",
 				count);
-		eventfd_signal(vdev->req_trigger, 1);
+		eventfd_signal(priv->req_trigger, 1);
 	} else if (count == 0) {
 		pci_warn(pdev,
 			"No device request channel registered, blocked until released by user\n");
 	}
 
-	mutex_unlock(&vdev->igate);
+	mutex_unlock(&priv->igate);
 }
 
 static const struct vfio_device_ops vfio_pci_ops = {
@@ -1291,7 +1305,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device_private *priv;
 	struct iommu_group *group;
 	int ret;
 
@@ -1315,41 +1329,42 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!group)
 		return -EINVAL;
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
 		vfio_iommu_group_put(group, &pdev->dev);
 		return -ENOMEM;
 	}
 
-	vdev->pdev = pdev;
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	mutex_init(&vdev->igate);
-	spin_lock_init(&vdev->irqlock);
-	mutex_init(&vdev->ioeventfds_lock);
-	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	priv->vdev.pdev = pdev;
+	priv->vdev.irq_type = VFIO_PCI_NUM_IRQS;
+	mutex_init(&priv->igate);
+	spin_lock_init(&priv->irqlock);
+	mutex_init(&priv->ioeventfds_lock);
+	INIT_LIST_HEAD(&priv->ioeventfds_list);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, &priv->vdev);
 	if (ret) {
 		vfio_iommu_group_put(group, &pdev->dev);
-		kfree(vdev);
+		kfree(priv);
 		return ret;
 	}
 
-	ret = vfio_pci_reflck_attach(vdev);
+	ret = vfio_pci_reflck_attach(&priv->vdev);
 	if (ret) {
 		vfio_del_group_dev(&pdev->dev);
 		vfio_iommu_group_put(group, &pdev->dev);
-		kfree(vdev);
+		kfree(priv);
 		return ret;
 	}
 
 	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
+		vga_client_register(pdev, &priv->vdev, NULL,
+				    vfio_pci_set_vga_decode);
 		vga_set_legacy_decoding(pdev,
-					vfio_pci_set_vga_decode(vdev, false));
+				vfio_pci_set_vga_decode(&priv->vdev, false));
 	}
 
-	vfio_pci_probe_power_state(vdev);
+	vfio_pci_probe_power_state(&priv->vdev);
 
 	if (!disable_idle_d3) {
 		/*
@@ -1361,8 +1376,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		 * be able to get to D3.  Therefore first do a D0 transition
 		 * before going to D3.
 		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
+		vfio_pci_set_power_state(&priv->vdev, PCI_D0);
+		vfio_pci_set_power_state(&priv->vdev, PCI_D3hot);
 	}
 
 	return ret;
@@ -1371,22 +1386,25 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_device *vdev;
+	struct vfio_pci_device_private *priv;
 
 	vdev = vfio_del_group_dev(&pdev->dev);
 	if (!vdev)
 		return;
 
-	vfio_pci_reflck_put(vdev->reflck);
+	priv = VDEV_TO_PRIV(vdev);
+
+	vfio_pci_reflck_put(priv->reflck);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
-	kfree(vdev->region);
-	mutex_destroy(&vdev->ioeventfds_lock);
+	kfree(priv->region);
+	mutex_destroy(&priv->ioeventfds_lock);
 
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
-	kfree(vdev->pm_save);
-	kfree(vdev);
+	kfree(priv->pm_save);
+	kfree(priv);
 
 	if (vfio_pci_is_vga(pdev)) {
 		vga_client_register(pdev, NULL, NULL, NULL);
@@ -1401,6 +1419,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 {
 	struct vfio_pci_device *vdev;
 	struct vfio_device *device;
+	struct vfio_pci_device_private *priv;
 
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (device == NULL)
@@ -1411,13 +1430,14 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 		vfio_device_put(device);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
+	priv = VDEV_TO_PRIV(vdev);
 
-	mutex_lock(&vdev->igate);
+	mutex_lock(&priv->igate);
 
-	if (vdev->err_trigger)
-		eventfd_signal(vdev->err_trigger, 1);
+	if (priv->err_trigger)
+		eventfd_signal(priv->err_trigger, 1);
 
-	mutex_unlock(&vdev->igate);
+	mutex_unlock(&priv->igate);
 
 	vfio_device_put(device);
 
@@ -1462,6 +1482,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	struct vfio_pci_reflck **preflck = data;
 	struct vfio_device *device;
 	struct vfio_pci_device *vdev;
+	struct vfio_pci_device_private *priv;
 
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
@@ -1473,10 +1494,11 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	}
 
 	vdev = vfio_device_data(device);
+	priv = VDEV_TO_PRIV(vdev);
 
-	if (vdev->reflck) {
-		vfio_pci_reflck_get(vdev->reflck);
-		*preflck = vdev->reflck;
+	if (priv->reflck) {
+		vfio_pci_reflck_get(priv->reflck);
+		*preflck = priv->reflck;
 		vfio_device_put(device);
 		return 1;
 	}
@@ -1488,17 +1510,18 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 {
 	bool slot = !pci_probe_reset_slot(vdev->pdev->slot);
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	mutex_lock(&reflck_lock);
 
 	if (pci_is_root_bus(vdev->pdev->bus) ||
 	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
-					  &vdev->reflck, slot) <= 0)
-		vdev->reflck = vfio_pci_reflck_alloc();
+					  &priv->reflck, slot) <= 0)
+		priv->reflck = vfio_pci_reflck_alloc();
 
 	mutex_unlock(&reflck_lock);
 
-	return PTR_ERR_OR_ZERO(vdev->reflck);
+	return PTR_ERR_OR_ZERO(priv->reflck);
 }
 
 static void vfio_pci_reflck_release(struct kref *kref)
@@ -1527,6 +1550,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 	struct vfio_devices *devs = data;
 	struct vfio_device *device;
 	struct vfio_pci_device *vdev;
+	struct vfio_pci_device_private *priv;
 
 	if (devs->cur_index == devs->max_index)
 		return -ENOSPC;
@@ -1541,9 +1565,10 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 	}
 
 	vdev = vfio_device_data(device);
+	priv = VDEV_TO_PRIV(vdev);
 
 	/* Fault if the device is not unused */
-	if (vdev->refcnt) {
+	if (priv->refcnt) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
@@ -1559,7 +1584,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
  *  - At least one of the affected devices is marked dirty via
  *    needs_reset (such as by lack of FLR support)
  * Then attempt to perform that bus or slot reset.  Callers are required
- * to hold vdev->reflck->lock, protecting the bus/slot reset group from
+ * to hold priv->reflck->lock, protecting the bus/slot reset group from
  * concurrent opens.  A vfio_device reference is acquired for each device
  * to prevent unbinds during the reset operation.
  *
@@ -1574,6 +1599,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	int i = 0, ret = -EINVAL;
 	bool slot = false;
 	struct vfio_pci_device *tmp;
+	struct vfio_pci_device_private *priv;
 
 	if (!pci_probe_reset_slot(vdev->pdev->slot))
 		slot = true;
@@ -1597,7 +1623,8 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	/* Does at least one need a reset? */
 	for (i = 0; i < devs.cur_index; i++) {
 		tmp = vfio_device_data(devs.devices[i]);
-		if (tmp->needs_reset) {
+		priv = VDEV_TO_PRIV(tmp);
+		if (priv->needs_reset) {
 			ret = pci_reset_bus(vdev->pdev);
 			break;
 		}
@@ -1606,6 +1633,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 put_devs:
 	for (i = 0; i < devs.cur_index; i++) {
 		tmp = vfio_device_data(devs.devices[i]);
+		priv = VDEV_TO_PRIV(tmp);
 
 		/*
 		 * If reset was successful, affected devices no longer need
@@ -1615,7 +1643,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 		 * the power state.
 		 */
 		if (!ret) {
-			tmp->needs_reset = false;
+			priv->needs_reset = false;
 
 			if (tmp != vdev && !disable_idle_d3)
 				vfio_pci_set_power_state(tmp, PCI_D3hot);
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index f0891bd8444c..f67d38e24faa 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -176,8 +176,9 @@ static int vfio_default_config_read(struct vfio_pci_device *vdev, int pos,
 				    int offset, __le32 *val)
 {
 	__le32 virt = 0;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
-	memcpy(val, vdev->vconfig + pos, count);
+	memcpy(val, priv->vconfig + pos, count);
 
 	memcpy(&virt, perm->virt + offset, count);
 
@@ -202,6 +203,7 @@ static int vfio_default_config_write(struct vfio_pci_device *vdev, int pos,
 				     int offset, __le32 val)
 {
 	__le32 virt = 0, write = 0;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	memcpy(&write, perm->write + offset, count);
 
@@ -214,12 +216,12 @@ static int vfio_default_config_write(struct vfio_pci_device *vdev, int pos,
 	if (write & virt) {
 		__le32 virt_val = 0;
 
-		memcpy(&virt_val, vdev->vconfig + pos, count);
+		memcpy(&virt_val, priv->vconfig + pos, count);
 
 		virt_val &= ~(write & virt);
 		virt_val |= (val & (write & virt));
 
-		memcpy(vdev->vconfig + pos, &virt_val, count);
+		memcpy(priv->vconfig + pos, &virt_val, count);
 	}
 
 	/* Non-virtualzed and writable bits go to hardware */
@@ -249,6 +251,7 @@ static int vfio_direct_config_read(struct vfio_pci_device *vdev, int pos,
 				   int offset, __le32 *val)
 {
 	int ret;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	ret = vfio_user_config_read(vdev->pdev, pos, val, count);
 	if (ret)
@@ -256,13 +259,13 @@ static int vfio_direct_config_read(struct vfio_pci_device *vdev, int pos,
 
 	if (pos >= PCI_CFG_SPACE_SIZE) { /* Extended cap header mangling */
 		if (offset < 4)
-			memcpy(val, vdev->vconfig + pos, count);
+			memcpy(val, priv->vconfig + pos, count);
 	} else if (pos >= PCI_STD_HEADER_SIZEOF) { /* Std cap mangling */
 		if (offset == PCI_CAP_LIST_ID && count > 1)
-			memcpy(val, vdev->vconfig + pos,
+			memcpy(val, priv->vconfig + pos,
 			       min(PCI_CAP_FLAGS, count));
 		else if (offset == PCI_CAP_LIST_NEXT)
-			memcpy(val, vdev->vconfig + pos, 1);
+			memcpy(val, priv->vconfig + pos, 1);
 	}
 
 	return count;
@@ -300,7 +303,9 @@ static int vfio_virt_config_write(struct vfio_pci_device *vdev, int pos,
 				  int count, struct perm_bits *perm,
 				  int offset, __le32 val)
 {
-	memcpy(vdev->vconfig + pos, &val, count);
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
+	memcpy(priv->vconfig + pos, &val, count);
 	return count;
 }
 
@@ -308,7 +313,9 @@ static int vfio_virt_config_read(struct vfio_pci_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 *val)
 {
-	memcpy(val, vdev->vconfig + pos, count);
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
+	memcpy(val, priv->vconfig + pos, count);
 	return count;
 }
 
@@ -402,7 +409,9 @@ static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
 static void vfio_bar_restore(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	u32 *rbar = vdev->rbar;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
+	u32 *rbar = priv->rbar;
 	u16 cmd;
 	int i;
 
@@ -416,7 +425,7 @@ static void vfio_bar_restore(struct vfio_pci_device *vdev)
 
 	pci_user_write_config_dword(pdev, PCI_ROM_ADDRESS, *rbar);
 
-	if (vdev->nointx) {
+	if (priv->nointx) {
 		pci_user_read_config_word(pdev, PCI_COMMAND, &cmd);
 		cmd |= PCI_COMMAND_INTX_DISABLE;
 		pci_user_write_config_word(pdev, PCI_COMMAND, cmd);
@@ -449,11 +458,12 @@ static __le32 vfio_generate_bar_flags(struct pci_dev *pdev, int bar)
 static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int i;
 	__le32 *bar;
 	u64 mask;
 
-	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
+	bar = (__le32 *)&priv->vconfig[PCI_BASE_ADDRESS_0];
 
 	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
 		if (!pci_resource_start(pdev, i)) {
@@ -473,7 +483,7 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 		}
 	}
 
-	bar = (__le32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
+	bar = (__le32 *)&priv->vconfig[PCI_ROM_ADDRESS];
 
 	/*
 	 * NB. REGION_INFO will have reported zero size if we weren't able
@@ -492,13 +502,15 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 	} else
 		*bar = 0;
 
-	vdev->bardirty = false;
+	priv->bardirty = false;
 }
 
 static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 				  int count, struct perm_bits *perm,
 				  int offset, __le32 *val)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	if (is_bar(offset)) /* pos == offset for basic config */
 		vfio_bar_fixup(vdev);
 
@@ -506,7 +518,8 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 
 	/* Mask in virtual memory enable for SR-IOV devices */
 	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
-		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
+		u16 cmd = le16_to_cpu(*(__le16 *)
+				&priv->vconfig[PCI_COMMAND]);
 		u32 tmp_val = le32_to_cpu(*val);
 
 		tmp_val |= cmd & PCI_COMMAND_MEMORY;
@@ -521,11 +534,12 @@ static bool vfio_need_bar_restore(struct vfio_pci_device *vdev)
 {
 	int i = 0, pos = PCI_BASE_ADDRESS_0, ret;
 	u32 bar;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	for (; pos <= PCI_BASE_ADDRESS_5; i++, pos += 4) {
-		if (vdev->rbar[i]) {
+		if (priv->rbar[i]) {
 			ret = pci_user_read_config_dword(vdev->pdev, pos, &bar);
-			if (ret || vdev->rbar[i] != bar)
+			if (ret || priv->rbar[i] != bar)
 				return true;
 		}
 	}
@@ -538,11 +552,12 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 				   int offset, __le32 val)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	__le16 *virt_cmd;
 	u16 new_cmd = 0;
 	int ret;
 
-	virt_cmd = (__le16 *)&vdev->vconfig[PCI_COMMAND];
+	virt_cmd = (__le16 *)&priv->vconfig[PCI_COMMAND];
 
 	if (offset == PCI_COMMAND) {
 		bool phys_mem, virt_mem, new_mem, phys_io, virt_io, new_io;
@@ -598,17 +613,17 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 		virt_intx_disable = !!(le16_to_cpu(*virt_cmd) &
 				       PCI_COMMAND_INTX_DISABLE);
 
-		if (virt_intx_disable && !vdev->virq_disabled) {
-			vdev->virq_disabled = true;
+		if (virt_intx_disable && !priv->virq_disabled) {
+			priv->virq_disabled = true;
 			vfio_pci_intx_mask(vdev);
-		} else if (!virt_intx_disable && vdev->virq_disabled) {
-			vdev->virq_disabled = false;
+		} else if (!virt_intx_disable && priv->virq_disabled) {
+			priv->virq_disabled = false;
 			vfio_pci_intx_unmask(vdev);
 		}
 	}
 
 	if (is_bar(offset))
-		vdev->bardirty = true;
+		priv->bardirty = true;
 
 	return count;
 }
@@ -721,8 +736,11 @@ static int vfio_vpd_config_write(struct vfio_pci_device *vdev, int pos,
 				 int offset, __le32 val)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	__le16 *paddr = (__le16 *)(vdev->vconfig + pos - offset + PCI_VPD_ADDR);
-	__le32 *pdata = (__le32 *)(vdev->vconfig + pos - offset + PCI_VPD_DATA);
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	__le16 *paddr = (__le16 *)(priv->vconfig + pos - offset +
+			PCI_VPD_ADDR);
+	__le32 *pdata = (__le32 *)(priv->vconfig + pos - offset +
+			PCI_VPD_DATA);
 	u16 addr;
 	u32 data;
 
@@ -802,7 +820,8 @@ static int vfio_exp_config_write(struct vfio_pci_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
-	__le16 *ctrl = (__le16 *)(vdev->vconfig + pos -
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	__le16 *ctrl = (__le16 *)(priv->vconfig + pos -
 				  offset + PCI_EXP_DEVCTL);
 	int readrq = le16_to_cpu(*ctrl) & PCI_EXP_DEVCTL_READRQ;
 
@@ -883,7 +902,8 @@ static int vfio_af_config_write(struct vfio_pci_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
 {
-	u8 *ctrl = vdev->vconfig + pos - offset + PCI_AF_CTRL;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	u8 *ctrl = priv->vconfig + pos - offset + PCI_AF_CTRL;
 
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
 	if (count < 0)
@@ -1040,13 +1060,15 @@ static int vfio_find_cap_start(struct vfio_pci_device *vdev, int pos)
 	u8 cap;
 	int base = (pos >= PCI_CFG_SPACE_SIZE) ? PCI_CFG_SPACE_SIZE :
 						 PCI_STD_HEADER_SIZEOF;
-	cap = vdev->pci_config_map[pos];
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
+	cap = priv->pci_config_map[pos];
 
 	if (cap == PCI_CAP_ID_BASIC)
 		return 0;
 
 	/* XXX Can we have to abutting capabilities of the same type? */
-	while (pos - 1 >= base && vdev->pci_config_map[pos - 1] == cap)
+	while (pos - 1 >= base && priv->pci_config_map[pos - 1] == cap)
 		pos--;
 
 	return pos;
@@ -1056,6 +1078,8 @@ static int vfio_msi_config_read(struct vfio_pci_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 *val)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	/* Update max available queue size from msi_qmax */
 	if (offset <= PCI_MSI_FLAGS && offset + count >= PCI_MSI_FLAGS) {
 		__le16 *flags;
@@ -1063,10 +1087,10 @@ static int vfio_msi_config_read(struct vfio_pci_device *vdev, int pos,
 
 		start = vfio_find_cap_start(vdev, pos);
 
-		flags = (__le16 *)&vdev->vconfig[start];
+		flags = (__le16 *)&priv->vconfig[start];
 
 		*flags &= cpu_to_le16(~PCI_MSI_FLAGS_QMASK);
-		*flags |= cpu_to_le16(vdev->msi_qmax << 1);
+		*flags |= cpu_to_le16(priv->msi_qmax << 1);
 	}
 
 	return vfio_default_config_read(vdev, pos, count, perm, offset, val);
@@ -1076,6 +1100,8 @@ static int vfio_msi_config_write(struct vfio_pci_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
 	if (count < 0)
 		return count;
@@ -1088,7 +1114,7 @@ static int vfio_msi_config_write(struct vfio_pci_device *vdev, int pos,
 
 		start = vfio_find_cap_start(vdev, pos);
 
-		pflags = (__le16 *)&vdev->vconfig[start + PCI_MSI_FLAGS];
+		pflags = (__le16 *)&priv->vconfig[start + PCI_MSI_FLAGS];
 
 		flags = le16_to_cpu(*pflags);
 
@@ -1097,9 +1123,9 @@ static int vfio_msi_config_write(struct vfio_pci_device *vdev, int pos,
 			flags &= ~PCI_MSI_FLAGS_ENABLE;
 
 		/* Check queue size */
-		if ((flags & PCI_MSI_FLAGS_QSIZE) >> 4 > vdev->msi_qmax) {
+		if ((flags & PCI_MSI_FLAGS_QSIZE) >> 4 > priv->msi_qmax) {
 			flags &= ~PCI_MSI_FLAGS_QSIZE;
-			flags |= vdev->msi_qmax << 4;
+			flags |= priv->msi_qmax << 4;
 		}
 
 		/* Write back to virt and to hardware */
@@ -1155,6 +1181,7 @@ static int init_pci_cap_msi_perm(struct perm_bits *perm, int len, u16 flags)
 static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int len, ret;
 	u16 flags;
 
@@ -1168,16 +1195,16 @@ static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
 	if (flags & PCI_MSI_FLAGS_MASKBIT)
 		len += 10;
 
-	if (vdev->msi_perm)
+	if (priv->msi_perm)
 		return len;
 
-	vdev->msi_perm = kmalloc(sizeof(struct perm_bits), GFP_KERNEL);
-	if (!vdev->msi_perm)
+	priv->msi_perm = kmalloc(sizeof(struct perm_bits), GFP_KERNEL);
+	if (!priv->msi_perm)
 		return -ENOMEM;
 
-	ret = init_pci_cap_msi_perm(vdev->msi_perm, len, flags);
+	ret = init_pci_cap_msi_perm(priv->msi_perm, len, flags);
 	if (ret) {
-		kfree(vdev->msi_perm);
+		kfree(priv->msi_perm);
 		return ret;
 	}
 
@@ -1229,6 +1256,7 @@ static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
 static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	u32 dword;
 	u16 word;
 	u8 byte;
@@ -1247,7 +1275,7 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 				/* Test for extended capabilities */
 				pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE,
 						      &dword);
-				vdev->extended_caps = (dword != 0);
+				priv->extended_caps = (dword != 0);
 			}
 			return PCI_CAP_PCIX_SIZEOF_V2;
 		} else
@@ -1263,7 +1291,7 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 		if (pdev->cfg_size > PCI_CFG_SPACE_SIZE) {
 			/* Test for extended capabilities */
 			pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
-			vdev->extended_caps = (dword != 0);
+			priv->extended_caps = (dword != 0);
 		}
 
 		/* length based on version and type */
@@ -1380,6 +1408,7 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret = 0;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	/*
 	 * We try to read physical config space in the largest chunks
@@ -1390,7 +1419,7 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 		int filled;
 
 		if (size >= 4 && !(offset % 4)) {
-			__le32 *dwordp = (__le32 *)&vdev->vconfig[offset];
+			__le32 *dwordp = (__le32 *)&priv->vconfig[offset];
 			u32 dword;
 
 			ret = pci_read_config_dword(pdev, offset, &dword);
@@ -1399,7 +1428,7 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 			*dwordp = cpu_to_le32(dword);
 			filled = 4;
 		} else if (size >= 2 && !(offset % 2)) {
-			__le16 *wordp = (__le16 *)&vdev->vconfig[offset];
+			__le16 *wordp = (__le16 *)&priv->vconfig[offset];
 			u16 word;
 
 			ret = pci_read_config_word(pdev, offset, &word);
@@ -1408,7 +1437,7 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 			*wordp = cpu_to_le16(word);
 			filled = 2;
 		} else {
-			u8 *byte = &vdev->vconfig[offset];
+			u8 *byte = &priv->vconfig[offset];
 			ret = pci_read_config_byte(pdev, offset, byte);
 			if (ret)
 				return ret;
@@ -1425,7 +1454,8 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 static int vfio_cap_init(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	u8 *map = vdev->pci_config_map;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	u8 *map = priv->pci_config_map;
 	u16 status;
 	u8 pos, *prev, cap;
 	int loops, ret, caps = 0;
@@ -1443,7 +1473,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 		return ret;
 
 	/* Mark the previous position in case we want to skip a capability */
-	prev = &vdev->vconfig[PCI_CAPABILITY_LIST];
+	prev = &priv->vconfig[PCI_CAPABILITY_LIST];
 
 	/* We can bound our loop, capabilities are dword aligned */
 	loops = (PCI_CFG_SPACE_SIZE - PCI_STD_HEADER_SIZEOF) / PCI_CAP_SIZEOF;
@@ -1493,14 +1523,14 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 		if (ret)
 			return ret;
 
-		prev = &vdev->vconfig[pos + PCI_CAP_LIST_NEXT];
+		prev = &priv->vconfig[pos + PCI_CAP_LIST_NEXT];
 		pos = next;
 		caps++;
 	}
 
 	/* If we didn't fill any capabilities, clear the status flag */
 	if (!caps) {
-		__le16 *vstatus = (__le16 *)&vdev->vconfig[PCI_STATUS];
+		__le16 *vstatus = (__le16 *)&priv->vconfig[PCI_STATUS];
 		*vstatus &= ~cpu_to_le16(PCI_STATUS_CAP_LIST);
 	}
 
@@ -1510,12 +1540,13 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 static int vfio_ecap_init(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	u8 *map = vdev->pci_config_map;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	u8 *map = priv->pci_config_map;
 	u16 epos;
 	__le32 *prev = NULL;
 	int loops, ret, ecaps = 0;
 
-	if (!vdev->extended_caps)
+	if (!priv->extended_caps)
 		return 0;
 
 	epos = PCI_CFG_SPACE_SIZE;
@@ -1590,17 +1621,17 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 		 * ecaps are absent, hope users check all the way to next.
 		 */
 		if (hidden)
-			*(__le32 *)&vdev->vconfig[epos] &=
+			*(__le32 *)&priv->vconfig[epos] &=
 				cpu_to_le32((0xffcU << 20));
 		else
 			ecaps++;
 
-		prev = (__le32 *)&vdev->vconfig[epos];
+		prev = (__le32 *)&priv->vconfig[epos];
 		epos = PCI_EXT_CAP_NEXT(header);
 	}
 
 	if (!ecaps)
-		*(u32 *)&vdev->vconfig[PCI_CFG_SPACE_SIZE] = 0;
+		*(u32 *)&priv->vconfig[PCI_CFG_SPACE_SIZE] = 0;
 
 	return 0;
 }
@@ -1630,6 +1661,7 @@ static const struct pci_device_id known_bogus_vf_intx_pin[] = {
 int vfio_config_init(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	u8 *map, *vconfig;
 	int ret;
 
@@ -1649,8 +1681,8 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 		return -ENOMEM;
 	}
 
-	vdev->pci_config_map = map;
-	vdev->vconfig = vconfig;
+	priv->pci_config_map = map;
+	priv->vconfig = vconfig;
 
 	memset(map, PCI_CAP_ID_BASIC, PCI_STD_HEADER_SIZEOF);
 	memset(map + PCI_STD_HEADER_SIZEOF, PCI_CAP_ID_INVALID,
@@ -1660,7 +1692,7 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	if (ret)
 		goto out;
 
-	vdev->bardirty = true;
+	priv->bardirty = true;
 
 	/*
 	 * XXX can we just pci_load_saved_state/pci_restore_state?
@@ -1668,13 +1700,13 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	 */
 
 	/* For restore after reset */
-	vdev->rbar[0] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_0]);
-	vdev->rbar[1] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_1]);
-	vdev->rbar[2] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_2]);
-	vdev->rbar[3] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_3]);
-	vdev->rbar[4] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_4]);
-	vdev->rbar[5] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_5]);
-	vdev->rbar[6] = le32_to_cpu(*(__le32 *)&vconfig[PCI_ROM_ADDRESS]);
+	priv->rbar[0] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_0]);
+	priv->rbar[1] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_1]);
+	priv->rbar[2] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_2]);
+	priv->rbar[3] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_3]);
+	priv->rbar[4] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_4]);
+	priv->rbar[5] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_5]);
+	priv->rbar[6] = le32_to_cpu(*(__le32 *)&vconfig[PCI_ROM_ADDRESS]);
 
 	if (pdev->is_virtfn) {
 		*(__le16 *)&vconfig[PCI_VENDOR_ID] = cpu_to_le16(pdev->vendor);
@@ -1699,7 +1731,7 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
 	}
 
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || priv->nointx)
 		vconfig[PCI_INTERRUPT_PIN] = 0;
 
 	ret = vfio_cap_init(vdev);
@@ -1714,20 +1746,22 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 
 out:
 	kfree(map);
-	vdev->pci_config_map = NULL;
+	priv->pci_config_map = NULL;
 	kfree(vconfig);
-	vdev->vconfig = NULL;
+	priv->vconfig = NULL;
 	return pcibios_err_to_errno(ret);
 }
 
 void vfio_config_free(struct vfio_pci_device *vdev)
 {
-	kfree(vdev->vconfig);
-	vdev->vconfig = NULL;
-	kfree(vdev->pci_config_map);
-	vdev->pci_config_map = NULL;
-	kfree(vdev->msi_perm);
-	vdev->msi_perm = NULL;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
+	kfree(priv->vconfig);
+	priv->vconfig = NULL;
+	kfree(priv->pci_config_map);
+	priv->pci_config_map = NULL;
+	kfree(priv->msi_perm);
+	priv->msi_perm = NULL;
 }
 
 /*
@@ -1737,10 +1771,11 @@ void vfio_config_free(struct vfio_pci_device *vdev)
 static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_device *vdev,
 					   loff_t pos)
 {
-	u8 cap = vdev->pci_config_map[pos];
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	u8 cap = priv->pci_config_map[pos];
 	size_t i;
 
-	for (i = 1; (pos + i) % 4 && vdev->pci_config_map[pos + i] == cap; i++)
+	for (i = 1; (pos + i) % 4 && priv->pci_config_map[pos + i] == cap; i++)
 		/* nop */;
 
 	return i;
@@ -1750,6 +1785,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 				 size_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	struct perm_bits *perm;
 	__le32 val = 0;
 	int cap_start = 0, offset;
@@ -1774,7 +1810,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 
 	ret = count;
 
-	cap_id = vdev->pci_config_map[*ppos];
+	cap_id = priv->pci_config_map[*ppos];
 
 	if (cap_id == PCI_CAP_ID_INVALID) {
 		perm = &unassigned_perms;
@@ -1794,7 +1830,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 			perm = &cap_perms[cap_id];
 
 			if (cap_id == PCI_CAP_ID_MSI)
-				perm = vdev->msi_perm;
+				perm = priv->msi_perm;
 
 			if (cap_id > PCI_CAP_ID_BASIC)
 				cap_start = vfio_find_cap_start(vdev, *ppos);
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 53d97f459252..def84168b035 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -25,13 +25,14 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
 			      size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
-	void *base = vdev->region[i].data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	void *base = priv->region[i].data;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 
-	if (pos >= vdev->region[i].size || iswrite)
+	if (pos >= priv->region[i].size || iswrite)
 		return -EINVAL;
 
-	count = min(count, (size_t)(vdev->region[i].size - pos));
+	count = min(count, (size_t)(priv->region[i].size - pos));
 
 	if (copy_to_user(buf, base + pos, count))
 		return -EFAULT;
@@ -54,7 +55,8 @@ static const struct vfio_pci_regops vfio_pci_igd_regops = {
 
 static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 {
-	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	__le32 *dwordp = (__le32 *)(priv->vconfig + OPREGION_PCI_ADDR);
 	u32 addr, size;
 	void *base;
 	int ret;
@@ -101,7 +103,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 
 	/* Fill vconfig with the hw value and virtualize register */
 	*dwordp = cpu_to_le32(addr);
-	memset(vdev->pci_config_map + OPREGION_PCI_ADDR,
+	memset(priv->pci_config_map + OPREGION_PCI_ADDR,
 	       PCI_CAP_ID_INVALID_VIRT, 4);
 
 	return ret;
@@ -112,15 +114,16 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 				  bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
-	struct pci_dev *pdev = vdev->region[i].data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	struct pci_dev *pdev = priv->region[i].data;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	size_t size;
 	int ret;
 
-	if (pos >= vdev->region[i].size || iswrite)
+	if (pos >= priv->region[i].size || iswrite)
 		return -EINVAL;
 
-	size = count = min(count, (size_t)(vdev->region[i].size - pos));
+	size = count = min(count, (size_t)(priv->region[i].size - pos));
 
 	if ((pos & 1) && size) {
 		u8 val;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3fa3f728fb39..f6fd6ab575ed 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -28,17 +28,19 @@
 static void vfio_send_intx_eventfd(void *opaque, void *unused)
 {
 	struct vfio_pci_device *vdev = opaque;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
-	if (likely(is_intx(vdev) && !vdev->virq_disabled))
-		eventfd_signal(vdev->ctx[0].trigger, 1);
+	if (likely(is_intx(vdev) && !priv->virq_disabled))
+		eventfd_signal(priv->ctx[0].trigger, 1);
 }
 
 void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	unsigned long flags;
 
-	spin_lock_irqsave(&vdev->irqlock, flags);
+	spin_lock_irqsave(&priv->irqlock, flags);
 
 	/*
 	 * Masking can come from interrupt, ioctl, or config space
@@ -47,22 +49,22 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
 	 * try to have the physical bit follow the virtual bit.
 	 */
 	if (unlikely(!is_intx(vdev))) {
-		if (vdev->pci_2_3)
+		if (priv->pci_2_3)
 			pci_intx(pdev, 0);
-	} else if (!vdev->ctx[0].masked) {
+	} else if (!priv->ctx[0].masked) {
 		/*
 		 * Can't use check_and_mask here because we always want to
 		 * mask, not just when something is pending.
 		 */
-		if (vdev->pci_2_3)
+		if (priv->pci_2_3)
 			pci_intx(pdev, 0);
 		else
 			disable_irq_nosync(pdev->irq);
 
-		vdev->ctx[0].masked = true;
+		priv->ctx[0].masked = true;
 	}
 
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	spin_unlock_irqrestore(&priv->irqlock, flags);
 }
 
 /*
@@ -75,34 +77,35 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_device *vdev = opaque;
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&vdev->irqlock, flags);
+	spin_lock_irqsave(&priv->irqlock, flags);
 
 	/*
 	 * Unmasking comes from ioctl or config, so again, have the
 	 * physical bit follow the virtual even when not using INTx.
 	 */
 	if (unlikely(!is_intx(vdev))) {
-		if (vdev->pci_2_3)
+		if (priv->pci_2_3)
 			pci_intx(pdev, 1);
-	} else if (vdev->ctx[0].masked && !vdev->virq_disabled) {
+	} else if (priv->ctx[0].masked && !priv->virq_disabled) {
 		/*
 		 * A pending interrupt here would immediately trigger,
 		 * but we can avoid that overhead by just re-sending
 		 * the interrupt to the user.
 		 */
-		if (vdev->pci_2_3) {
+		if (priv->pci_2_3) {
 			if (!pci_check_and_unmask_intx(pdev))
 				ret = 1;
 		} else
 			enable_irq(pdev->irq);
 
-		vdev->ctx[0].masked = (ret > 0);
+		priv->ctx[0].masked = (ret > 0);
 	}
 
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	spin_unlock_irqrestore(&priv->irqlock, flags);
 
 	return ret;
 }
@@ -116,22 +119,23 @@ void vfio_pci_intx_unmask(struct vfio_pci_device *vdev)
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
 	struct vfio_pci_device *vdev = dev_id;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	unsigned long flags;
 	int ret = IRQ_NONE;
 
-	spin_lock_irqsave(&vdev->irqlock, flags);
+	spin_lock_irqsave(&priv->irqlock, flags);
 
-	if (!vdev->pci_2_3) {
+	if (!priv->pci_2_3) {
 		disable_irq_nosync(vdev->pdev->irq);
-		vdev->ctx[0].masked = true;
+		priv->ctx[0].masked = true;
 		ret = IRQ_HANDLED;
-	} else if (!vdev->ctx[0].masked &&  /* may be shared */
+	} else if (!priv->ctx[0].masked &&  /* may be shared */
 		   pci_check_and_mask_intx(vdev->pdev)) {
-		vdev->ctx[0].masked = true;
+		priv->ctx[0].masked = true;
 		ret = IRQ_HANDLED;
 	}
 
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	spin_unlock_irqrestore(&priv->irqlock, flags);
 
 	if (ret == IRQ_HANDLED)
 		vfio_send_intx_eventfd(vdev, NULL);
@@ -141,17 +145,19 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 
 static int vfio_intx_enable(struct vfio_pci_device *vdev)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
-	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
-	if (!vdev->ctx)
+	priv->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
+	if (!priv->ctx)
 		return -ENOMEM;
 
-	vdev->num_ctx = 1;
+	priv->num_ctx = 1;
 
 	/*
 	 * If the virtual interrupt is masked, restore it.  Devices
@@ -159,9 +165,9 @@ static int vfio_intx_enable(struct vfio_pci_device *vdev)
 	 * here, non-PCI-2.3 devices will have to wait until the
 	 * interrupt is enabled.
 	 */
-	vdev->ctx[0].masked = vdev->virq_disabled;
-	if (vdev->pci_2_3)
-		pci_intx(vdev->pdev, !vdev->ctx[0].masked);
+	priv->ctx[0].masked = priv->virq_disabled;
+	if (priv->pci_2_3)
+		pci_intx(vdev->pdev, !priv->ctx[0].masked);
 
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
@@ -171,42 +177,43 @@ static int vfio_intx_enable(struct vfio_pci_device *vdev)
 static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	unsigned long irqflags = IRQF_SHARED;
 	struct eventfd_ctx *trigger;
 	unsigned long flags;
 	int ret;
 
-	if (vdev->ctx[0].trigger) {
+	if (priv->ctx[0].trigger) {
 		free_irq(pdev->irq, vdev);
-		kfree(vdev->ctx[0].name);
-		eventfd_ctx_put(vdev->ctx[0].trigger);
-		vdev->ctx[0].trigger = NULL;
+		kfree(priv->ctx[0].name);
+		eventfd_ctx_put(priv->ctx[0].trigger);
+		priv->ctx[0].trigger = NULL;
 	}
 
 	if (fd < 0) /* Disable only */
 		return 0;
 
-	vdev->ctx[0].name = kasprintf(GFP_KERNEL, "vfio-intx(%s)",
+	priv->ctx[0].name = kasprintf(GFP_KERNEL, "vfio-intx(%s)",
 				      pci_name(pdev));
-	if (!vdev->ctx[0].name)
+	if (!priv->ctx[0].name)
 		return -ENOMEM;
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(vdev->ctx[0].name);
+		kfree(priv->ctx[0].name);
 		return PTR_ERR(trigger);
 	}
 
-	vdev->ctx[0].trigger = trigger;
+	priv->ctx[0].trigger = trigger;
 
-	if (!vdev->pci_2_3)
+	if (!priv->pci_2_3)
 		irqflags = 0;
 
 	ret = request_irq(pdev->irq, vfio_intx_handler,
-			  irqflags, vdev->ctx[0].name, vdev);
+			  irqflags, priv->ctx[0].name, vdev);
 	if (ret) {
-		vdev->ctx[0].trigger = NULL;
-		kfree(vdev->ctx[0].name);
+		priv->ctx[0].trigger = NULL;
+		kfree(priv->ctx[0].name);
 		eventfd_ctx_put(trigger);
 		return ret;
 	}
@@ -215,22 +222,24 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 	 * INTx disable will stick across the new irq setup,
 	 * disable_irq won't.
 	 */
-	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && vdev->ctx[0].masked)
+	spin_lock_irqsave(&priv->irqlock, flags);
+	if (!priv->pci_2_3 && priv->ctx[0].masked)
 		disable_irq_nosync(pdev->irq);
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	spin_unlock_irqrestore(&priv->irqlock, flags);
 
 	return 0;
 }
 
 static void vfio_intx_disable(struct vfio_pci_device *vdev)
 {
-	vfio_virqfd_disable(&vdev->ctx[0].unmask);
-	vfio_virqfd_disable(&vdev->ctx[0].mask);
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
+	vfio_virqfd_disable(&priv->ctx[0].unmask);
+	vfio_virqfd_disable(&priv->ctx[0].mask);
 	vfio_intx_set_signal(vdev, -1);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
-	kfree(vdev->ctx);
+	priv->num_ctx = 0;
+	kfree(priv->ctx);
 }
 
 /*
@@ -247,14 +256,15 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
 	int ret;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
-	if (!vdev->ctx)
+	priv->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
+	if (!priv->ctx)
 		return -ENOMEM;
 
 	/* return the number of supported vectors if we can't get all: */
@@ -262,11 +272,11 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 	if (ret < nvec) {
 		if (ret > 0)
 			pci_free_irq_vectors(pdev);
-		kfree(vdev->ctx);
+		kfree(priv->ctx);
 		return ret;
 	}
 
-	vdev->num_ctx = nvec;
+	priv->num_ctx = nvec;
 	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
 				VFIO_PCI_MSI_IRQ_INDEX;
 
@@ -275,7 +285,7 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 		 * Compute the virtual hardware field for max msi vectors -
 		 * it is the log base 2 of the number of vectors.
 		 */
-		vdev->msi_qmax = fls(nvec * 2 - 1) - 1;
+		priv->msi_qmax = fls(nvec * 2 - 1) - 1;
 	}
 
 	return 0;
@@ -285,34 +295,35 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 				      int vector, int fd, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	struct eventfd_ctx *trigger;
 	int irq, ret;
 
-	if (vector < 0 || vector >= vdev->num_ctx)
+	if (vector < 0 || vector >= priv->num_ctx)
 		return -EINVAL;
 
 	irq = pci_irq_vector(pdev, vector);
 
-	if (vdev->ctx[vector].trigger) {
-		free_irq(irq, vdev->ctx[vector].trigger);
-		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
-		kfree(vdev->ctx[vector].name);
-		eventfd_ctx_put(vdev->ctx[vector].trigger);
-		vdev->ctx[vector].trigger = NULL;
+	if (priv->ctx[vector].trigger) {
+		free_irq(irq, priv->ctx[vector].trigger);
+		irq_bypass_unregister_producer(&priv->ctx[vector].producer);
+		kfree(priv->ctx[vector].name);
+		eventfd_ctx_put(priv->ctx[vector].trigger);
+		priv->ctx[vector].trigger = NULL;
 	}
 
 	if (fd < 0)
 		return 0;
 
-	vdev->ctx[vector].name = kasprintf(GFP_KERNEL, "vfio-msi%s[%d](%s)",
+	priv->ctx[vector].name = kasprintf(GFP_KERNEL, "vfio-msi%s[%d](%s)",
 					   msix ? "x" : "", vector,
 					   pci_name(pdev));
-	if (!vdev->ctx[vector].name)
+	if (!priv->ctx[vector].name)
 		return -ENOMEM;
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(vdev->ctx[vector].name);
+		kfree(priv->ctx[vector].name);
 		return PTR_ERR(trigger);
 	}
 
@@ -331,22 +342,22 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	}
 
 	ret = request_irq(irq, vfio_msihandler, 0,
-			  vdev->ctx[vector].name, trigger);
+			  priv->ctx[vector].name, trigger);
 	if (ret) {
-		kfree(vdev->ctx[vector].name);
+		kfree(priv->ctx[vector].name);
 		eventfd_ctx_put(trigger);
 		return ret;
 	}
 
-	vdev->ctx[vector].producer.token = trigger;
-	vdev->ctx[vector].producer.irq = irq;
-	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
+	priv->ctx[vector].producer.token = trigger;
+	priv->ctx[vector].producer.irq = irq;
+	ret = irq_bypass_register_producer(&priv->ctx[vector].producer);
 	if (unlikely(ret))
 		dev_info(&pdev->dev,
 		"irq bypass producer (token %p) registration fails: %d\n",
-		vdev->ctx[vector].producer.token, ret);
+		priv->ctx[vector].producer.token, ret);
 
-	vdev->ctx[vector].trigger = trigger;
+	priv->ctx[vector].trigger = trigger;
 
 	return 0;
 }
@@ -354,9 +365,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
 			      unsigned count, int32_t *fds, bool msix)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int i, j, ret = 0;
 
-	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
+	if (start >= priv->num_ctx || start + count > priv->num_ctx)
 		return -EINVAL;
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
@@ -375,14 +387,15 @@ static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
 static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int i;
 
-	for (i = 0; i < vdev->num_ctx; i++) {
-		vfio_virqfd_disable(&vdev->ctx[i].unmask);
-		vfio_virqfd_disable(&vdev->ctx[i].mask);
+	for (i = 0; i < priv->num_ctx; i++) {
+		vfio_virqfd_disable(&priv->ctx[i].unmask);
+		vfio_virqfd_disable(&priv->ctx[i].mask);
 	}
 
-	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
+	vfio_msi_set_block(vdev, 0, priv->num_ctx, NULL, msix);
 
 	pci_free_irq_vectors(pdev);
 
@@ -390,12 +403,12 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 	 * Both disable paths above use pci_intx_for_msi() to clear DisINTx
 	 * via their shutdown paths.  Restore for NoINTx devices.
 	 */
-	if (vdev->nointx)
+	if (priv->nointx)
 		pci_intx(pdev, 0);
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
-	kfree(vdev->ctx);
+	priv->num_ctx = 0;
+	kfree(priv->ctx);
 }
 
 /*
@@ -405,6 +418,8 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
 
@@ -420,9 +435,9 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 			return vfio_virqfd_enable((void *) vdev,
 						  vfio_pci_intx_unmask_handler,
 						  vfio_send_intx_eventfd, NULL,
-						  &vdev->ctx[0].unmask, fd);
+						  &priv->ctx[0].unmask, fd);
 
-		vfio_virqfd_disable(&vdev->ctx[0].unmask);
+		vfio_virqfd_disable(&priv->ctx[0].unmask);
 	}
 
 	return 0;
@@ -497,6 +512,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
 {
 	int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_msi_disable(vdev, msix);
@@ -525,18 +541,18 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
 		return ret;
 	}
 
-	if (!irq_is(vdev, index) || start + count > vdev->num_ctx)
+	if (!irq_is(vdev, index) || start + count > priv->num_ctx)
 		return -EINVAL;
 
 	for (i = start; i < start + count; i++) {
-		if (!vdev->ctx[i].trigger)
+		if (!priv->ctx[i].trigger)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-			eventfd_signal(vdev->ctx[i].trigger, 1);
+			eventfd_signal(priv->ctx[i].trigger, 1);
 		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 			uint8_t *bools = data;
 			if (bools[i - start])
-				eventfd_signal(vdev->ctx[i].trigger, 1);
+				eventfd_signal(priv->ctx[i].trigger, 1);
 		}
 	}
 	return 0;
@@ -601,10 +617,12 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->err_trigger,
+	return vfio_pci_set_ctx_trigger_single(&priv->err_trigger,
 					       count, flags, data);
 }
 
@@ -612,10 +630,12 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->req_trigger,
+	return vfio_pci_set_ctx_trigger_single(&priv->req_trigger,
 					       count, flags, data);
 }
 
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index f2983f0f84be..bd2bb99cbf0b 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -43,16 +43,17 @@ static size_t vfio_pci_nvgpu_rw(struct vfio_pci_device *vdev,
 		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
-	struct vfio_pci_nvgpu_data *data = vdev->region[i].data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	struct vfio_pci_nvgpu_data *data = priv->region[i].data;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	loff_t posaligned = pos & PAGE_MASK, posoff = pos & ~PAGE_MASK;
 	size_t sizealigned;
 	void __iomem *ptr;
 
-	if (pos >= vdev->region[i].size)
+	if (pos >= priv->region[i].size)
 		return -EINVAL;
 
-	count = min(count, (size_t)(vdev->region[i].size - pos));
+	count = min(count, (size_t)(priv->region[i].size - pos));
 
 	/*
 	 * We map only a bit of GPU RAM for a short time instead of mapping it
@@ -115,7 +116,7 @@ static vm_fault_t vfio_pci_nvgpu_mmap_fault(struct vm_fault *vmf)
 {
 	vm_fault_t ret;
 	struct vm_area_struct *vma = vmf->vma;
-	struct vfio_pci_region *region = vma->vm_private_data;
+	struct vfio_pci_region *region = vma->vm_priv_data;
 	struct vfio_pci_nvgpu_data *data = region->data;
 	unsigned long vmf_off = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 	unsigned long nv2pg = data->gpu_hpa >> PAGE_SHIFT;
@@ -146,7 +147,7 @@ static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *vdev,
 	if (vma->vm_end - vma->vm_start > data->size)
 		return -EINVAL;
 
-	vma->vm_private_data = region;
+	vma->vm_priv_data = region;
 	vma->vm_flags |= VM_PFNMAP;
 	vma->vm_ops = &vfio_pci_nvgpu_mmap_vmops;
 
@@ -193,9 +194,7 @@ static int vfio_pci_nvgpu_group_notifier(struct notifier_block *nb,
 		unsigned long action, void *opaque)
 {
 	struct kvm *kvm = opaque;
-	struct vfio_pci_nvgpu_data *data = container_of(nb,
-			struct vfio_pci_nvgpu_data,
-			group_notifier);
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 
 	if (action == VFIO_GROUP_NOTIFY_SET_KVM && kvm &&
 			pnv_npu2_map_lpar_dev(data->gpdev,
@@ -306,13 +305,14 @@ static size_t vfio_pci_npu2_rw(struct vfio_pci_device *vdev,
 		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
-	struct vfio_pci_npu2_data *data = vdev->region[i].data;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
+	struct vfio_pci_npu2_data *data = priv->region[i].data;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 
-	if (pos >= vdev->region[i].size)
+	if (pos >= priv->region[i].size)
 		return -EINVAL;
 
-	count = min(count, (size_t)(vdev->region[i].size - pos));
+	count = min(count, (size_t)(priv->region[i].size - pos));
 
 	if (iswrite) {
 		if (copy_from_user(data->base + pos, buf, count))
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index ee6ee91718a4..df665fa8be52 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -84,8 +84,8 @@ struct vfio_pci_reflck {
 	struct mutex		lock;
 };
 
-struct vfio_pci_device {
-	struct pci_dev		*pdev;
+struct vfio_pci_device_private {
+	struct vfio_pci_device	vdev;
 	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
 	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
 	u8			*pci_config_map;
@@ -95,8 +95,6 @@ struct vfio_pci_device {
 	struct mutex		igate;
 	struct vfio_pci_irq_ctx	*ctx;
 	int			num_ctx;
-	int			irq_type;
-	int			num_regions;
 	struct vfio_pci_region	*region;
 	u8			msi_qmax;
 	u8			msix_bar;
@@ -123,6 +121,7 @@ struct vfio_pci_device {
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
 };
+#define VDEV_TO_PRIV(p) container_of((p), struct vfio_pci_device_private, vdev)
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
 #define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 0120d8324a40..a0ef1de4f74a 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -132,10 +132,11 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int ret;
 	void __iomem *io;
 
-	if (vdev->barmap[bar])
+	if (priv->barmap[bar])
 		return 0;
 
 	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
@@ -148,7 +149,7 @@ static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 		return -ENOMEM;
 	}
 
-	vdev->barmap[bar] = io;
+	priv->barmap[bar] = io;
 
 	return 0;
 }
@@ -157,6 +158,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	size_t x_start = 0, x_end = 0;
@@ -192,12 +194,12 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 		if (ret)
 			return ret;
 
-		io = vdev->barmap[bar];
+		io = priv->barmap[bar];
 	}
 
-	if (bar == vdev->msix_bar) {
-		x_start = vdev->msix_offset;
-		x_end = vdev->msix_offset + vdev->msix_size;
+	if (bar == priv->msix_bar) {
+		x_start = priv->msix_offset;
+		x_end = priv->msix_offset + priv->msix_size;
 	}
 
 	done = do_io_rw(io, buf, pos, count, x_start, x_end, iswrite);
@@ -214,6 +216,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)
 {
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	int ret;
 	loff_t off, pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	void __iomem *iomem = NULL;
@@ -221,7 +224,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 	bool is_ioport;
 	ssize_t done;
 
-	if (!vdev->has_vga)
+	if (!priv->has_vga)
 		return -EINVAL;
 
 	if (pos > 0xbfffful)
@@ -302,6 +305,7 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 			uint64_t data, int count, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
 	loff_t pos = offset & VFIO_PCI_OFFSET_MASK;
 	int ret, bar = VFIO_PCI_OFFSET_TO_INDEX(offset);
 	struct vfio_pci_ioeventfd *ioeventfd;
@@ -314,9 +318,9 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 		return -EINVAL;
 
 	/* Disallow ioeventfds working around MSI-X table writes */
-	if (bar == vdev->msix_bar &&
-	    !(pos + count <= vdev->msix_offset ||
-	      pos >= vdev->msix_offset + vdev->msix_size))
+	if (bar == priv->msix_bar &&
+	    !(pos + count <= priv->msix_offset ||
+	      pos >= priv->msix_offset + priv->msix_size))
 		return -EINVAL;
 
 #ifndef iowrite64
@@ -328,15 +332,15 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 	if (ret)
 		return ret;
 
-	mutex_lock(&vdev->ioeventfds_lock);
+	mutex_lock(&priv->ioeventfds_lock);
 
-	list_for_each_entry(ioeventfd, &vdev->ioeventfds_list, next) {
+	list_for_each_entry(ioeventfd, &priv->ioeventfds_list, next) {
 		if (ioeventfd->pos == pos && ioeventfd->bar == bar &&
 		    ioeventfd->data == data && ioeventfd->count == count) {
 			if (fd == -1) {
 				vfio_virqfd_disable(&ioeventfd->virqfd);
 				list_del(&ioeventfd->next);
-				vdev->ioeventfds_nr--;
+				priv->ioeventfds_nr--;
 				kfree(ioeventfd);
 				ret = 0;
 			} else
@@ -351,7 +355,7 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 		goto out_unlock;
 	}
 
-	if (vdev->ioeventfds_nr >= VFIO_PCI_IOEVENTFD_MAX) {
+	if (priv->ioeventfds_nr >= VFIO_PCI_IOEVENTFD_MAX) {
 		ret = -ENOSPC;
 		goto out_unlock;
 	}
@@ -362,7 +366,7 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 		goto out_unlock;
 	}
 
-	ioeventfd->addr = vdev->barmap[bar] + pos;
+	ioeventfd->addr = priv->barmap[bar] + pos;
 	ioeventfd->data = data;
 	ioeventfd->pos = pos;
 	ioeventfd->bar = bar;
@@ -375,11 +379,11 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 		goto out_unlock;
 	}
 
-	list_add(&ioeventfd->next, &vdev->ioeventfds_list);
-	vdev->ioeventfds_nr++;
+	list_add(&ioeventfd->next, &priv->ioeventfds_list);
+	priv->ioeventfds_nr++;
 
 out_unlock:
-	mutex_unlock(&vdev->ioeventfds_lock);
+	mutex_unlock(&priv->ioeventfds_lock);
 
 	return ret;
 }
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..70a2b8fb6179 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -195,4 +195,9 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+struct vfio_pci_device {
+	struct pci_dev			*pdev;
+	int				num_regions;
+	int				irq_type;
+};
 #endif /* VFIO_H */
-- 
2.17.1

