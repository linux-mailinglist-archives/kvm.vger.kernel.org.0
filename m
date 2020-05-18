Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC181D6F3E
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 05:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgERDEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 23:04:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:25715 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgERDEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 23:04:39 -0400
IronPort-SDR: egluIFURTmoNkAcIJFaLKbYv/fLj1DeuA24/MvuwlwtBhmcBtLeRw3WGALJhV8+Yub7qOwgbyN
 pmuG9DlAiYXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 20:04:37 -0700
IronPort-SDR: Dc7ZD0Txewr9IXncTFuVfkfHwmH4yE52rq7GMqu7GdB9kXfQdTGHEJiDfzqXUA/gz6Qt5fSYhL
 FGEqfwinhJOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411106449"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 20:04:34 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 10/10] i40e/vf_migration: vendor defined irq_type to support dynamic bar map
Date:   Sun, 17 May 2020 22:54:41 -0400
Message-Id: <20200518025441.14604-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518024202.13996-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch gives an example implementation to support vendor defined
irq_type.

- on this vendor driver open, it registers an irq of type
  VFIO_IRQ_TYPE_REMAP_BAR_REGION, and reports to driver vfio-pci there's
  1 vendor irq.

- after userspace detects and enables the irq of type
  VFIO_IRQ_TYPE_REMAP_BAR_REGION, this vendor driver will setup a virqfd
  to monitor file write to the fd of this irq.

  (1) when migration starts
  (the device state is set to _SAVING & _RUNNING),
  a. this vendor driver will signal the irq VFIO_IRQ_TYPE_REMAP_BAR_REGION
  to ask userspace to remap pci bars. It packs the target bar number in
  the ctx count. i.e. 1 << bar_number. if there are multiple bars to remap,
  the numbers are or'ed.

  b. on receiving this eventfd signal, userspace will read the bar number,
  re-query the bar flags (like READ/WRITE/MMAP/SPARSE ranges), and remap
  the bar's subregions.

  c. vendor driver reports bar 0 to be trapped (not MMAP'd).

  d. after remapping completion, it writes 0 to the eventfd so that the
  vendor driver waiting for it would complete too.

  (2) as the bar 0 is remapped to be trapped, vendor driver is able to
  start tracking dirty pages in software way.

  (3) when migration stops, similar to what's done in migration start, the
  vendor driver would signal to remap the bar back to un-trapped (MMAP'd),
  but it would not wait for the userspace writing back for remapping
  completion.

- on releasing this vendor driver, it frees resources to vendor defined
irqs.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Shaopeng He <shaopeng.he@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |   2 +-
 .../ethernet/intel/i40e/i40e_vf_migration.c   | 322 +++++++++++++++++-
 .../ethernet/intel/i40e/i40e_vf_migration.h   |  26 ++
 3 files changed, 346 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 31780d9a59f1..6a52a197c4d8 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -266,7 +266,7 @@ config I40E_DCB
 
 config I40E_VF_MIGRATION
 	tristate "XL710 Family VF live migration support -- loadable modules only"
-	depends on I40E && VFIO_PCI && m
+	depends on I40E && VFIO_PCI && VFIO_VIRQFD && m
 	help
 	  Say m if you want to enable live migration of
 	  Virtual Functions of Intel(R) Ethernet Controller XL710
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
index 107a291909b3..188829efaa19 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
@@ -19,6 +19,266 @@
 #define DRIVER_AUTHOR   "Intel Corporation"
 #define TEST_DIRTY_IOVA_PFN 0
 
+static int i40e_vf_remap_bars(struct i40e_vf_migration *i40e_vf_dev, bool wait)
+{
+	int bar_num = 0;
+
+	if (!i40e_vf_dev->remap_irq_ctx.init)
+		return -ENODEV;
+
+	/* set cnt to 2 as it will enter wait_handler too times.
+	 * one from this eventfd_signal,
+	 * one from userspace ack back
+	 */
+	atomic_set(&i40e_vf_dev->remap_irq_ctx.cnt, 2);
+	eventfd_signal(i40e_vf_dev->remap_irq_ctx.trigger, 1 << bar_num);
+
+	if (!wait)
+		return 0;
+
+	/* the wait cannot be executed in vcpu threads, as the eventfd write
+	 * from userspace we are waiting for is waiting on the lock vcpu
+	 * threads hold
+	 */
+	wait_event_killable(i40e_vf_dev->remap_irq_ctx.waitq,
+			    !atomic_read(&i40e_vf_dev->remap_irq_ctx.cnt));
+
+	return 0;
+}
+
+static int i40e_vf_remap_bar_wait_handler(void *opaque, void *unused)
+{
+	struct i40e_vf_migration *i40e_vf_dev = opaque;
+
+	atomic_dec_if_positive(&i40e_vf_dev->remap_irq_ctx.cnt);
+	wake_up(&i40e_vf_dev->remap_irq_ctx.waitq);
+	return 0;
+}
+
+static void i40e_vf_disable_remap_bars_irq(struct i40e_vf_migration *vf_dev)
+{
+	if (!vf_dev->remap_irq_ctx.init)
+		return;
+
+	if (vf_dev->remap_irq_ctx.sync)
+		vfio_virqfd_disable(&vf_dev->remap_irq_ctx.sync);
+
+	atomic_set(&vf_dev->remap_irq_ctx.cnt, 0);
+	wake_up(&vf_dev->remap_irq_ctx.waitq);
+
+	eventfd_ctx_put(vf_dev->remap_irq_ctx.trigger);
+	vf_dev->remap_irq_ctx.trigger = NULL;
+	vf_dev->remap_irq_ctx.init = false;
+}
+
+static int i40e_vf_enable_remap_bars_irq(struct i40e_vf_migration *vf_dev,
+					 struct eventfd_ctx *ctx, int32_t fd)
+{
+	int ret;
+
+	if (vf_dev->remap_irq_ctx.init)
+		return -EEXIST;
+
+	ret = vfio_virqfd_enable((void *)vf_dev,
+				 i40e_vf_remap_bar_wait_handler, NULL, ctx,
+				 &vf_dev->remap_irq_ctx.sync, fd);
+	if (ret) {
+		eventfd_ctx_put(ctx);
+		return ret;
+	}
+
+	init_waitqueue_head(&vf_dev->remap_irq_ctx.waitq);
+	atomic_set(&vf_dev->remap_irq_ctx.cnt, 0);
+	vf_dev->remap_irq_ctx.init = true;
+	vf_dev->remap_irq_ctx.trigger = ctx;
+	return 0;
+}
+
+static int i40e_vf_set_irq_remap_bars(struct i40e_vf_migration *i40e_vf_dev,
+				      u32 flags, unsigned int index,
+				      unsigned int start, unsigned int count,
+				      void *data)
+{
+	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+	case VFIO_IRQ_SET_ACTION_MASK:
+	case VFIO_IRQ_SET_ACTION_UNMASK:
+		/* XXX Need masking support exported */
+		return 0;
+	case VFIO_IRQ_SET_ACTION_TRIGGER:
+		break;
+	default:
+		return 0;
+	}
+
+	if (start != 0 || count > 1)
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		if (!count) {
+			i40e_vf_disable_remap_bars_irq(i40e_vf_dev);
+			return 0;
+		}
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		return -EINVAL;
+	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int fd;
+
+		if (!count || !data)
+			return -EINVAL;
+
+		fd = *(int32_t *)data;
+		if (fd == -1) {
+			i40e_vf_disable_remap_bars_irq(i40e_vf_dev);
+		} else if (fd >= 0) {
+			struct eventfd_ctx *efdctx;
+
+			efdctx = eventfd_ctx_fdget(fd);
+			if (IS_ERR(efdctx))
+				return PTR_ERR(efdctx);
+
+			i40e_vf_disable_remap_bars_irq(i40e_vf_dev);
+
+			return i40e_vf_enable_remap_bars_irq(i40e_vf_dev,
+							     efdctx, fd);
+		}
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static const struct i40e_vf_irqops i40e_vf_irqops_remap_bars = {
+	.set_irqs = i40e_vf_set_irq_remap_bars,
+};
+
+static long i40e_vf_set_irqs(void *device_data,
+			     unsigned int cmd, unsigned long arg)
+{
+	struct vfio_irq_set hdr;
+	int index, ret;
+	u8 *data = NULL;
+	size_t data_size = 0;
+	unsigned long minsz;
+	struct i40e_vf_migration *i40e_vf_dev =
+		vfio_pci_vendor_data(device_data);
+
+	minsz = offsetofend(struct vfio_irq_set, count);
+	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (hdr.argsz < minsz ||
+	    hdr.index >= VFIO_PCI_NUM_IRQS + i40e_vf_dev->num_irqs)
+		return -EINVAL;
+	if (hdr.index < VFIO_PCI_NUM_IRQS)
+		goto default_handle;
+
+	index = hdr.index - VFIO_PCI_NUM_IRQS;
+
+	ret = vfio_set_irqs_validate_and_prepare(&hdr,
+						 i40e_vf_dev->irqs[index].count,
+						 VFIO_PCI_NUM_IRQS +
+						 i40e_vf_dev->num_irqs,
+						 &data_size);
+	if (ret)
+		return ret;
+
+	if (data_size) {
+		data = memdup_user((void __user *)(arg + minsz), data_size);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+	}
+
+	ret = i40e_vf_dev->irqs[index].ops->set_irqs(i40e_vf_dev,
+						     hdr.flags, hdr.index,
+						     hdr.start, hdr.count,
+						     data);
+	kfree(data);
+	return ret;
+
+default_handle:
+	return vfio_pci_ioctl(device_data, cmd, arg);
+}
+
+static long i40e_vf_get_irq_info(void *device_data,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	struct vfio_irq_info info;
+	int index, ret;
+	unsigned long minsz;
+	struct vfio_irq_info_cap_type cap_type = {
+		.header.id = VFIO_IRQ_INFO_CAP_TYPE,
+		.header.version = 1
+	};
+	struct i40e_vf_migration *i40e_vf_dev =
+		vfio_pci_vendor_data(device_data);
+
+	minsz = offsetofend(struct vfio_irq_info, count);
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz ||
+	    info.index >= VFIO_PCI_NUM_IRQS + i40e_vf_dev->num_irqs)
+		return -EINVAL;
+	if (info.index < VFIO_PCI_NUM_IRQS)
+		goto default_handle;
+
+	index = info.index - VFIO_PCI_NUM_IRQS;
+	info.flags = i40e_vf_dev->irqs[index].flags;
+	cap_type.type = i40e_vf_dev->irqs[index].type;
+	cap_type.subtype = i40e_vf_dev->irqs[index].subtype;
+
+	ret = vfio_info_add_capability(&caps, &cap_type.header,
+				       sizeof(cap_type));
+	if (ret)
+		return ret;
+
+	if (caps.size) {
+		info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
+		if (info.argsz < sizeof(info) + caps.size) {
+			info.argsz = sizeof(info) + caps.size;
+			info.cap_offset = 0;
+		} else {
+			vfio_info_cap_shift(&caps, sizeof(info));
+			if (copy_to_user((void __user *)arg + sizeof(info),
+					 caps.buf, caps.size)) {
+				kfree(caps.buf);
+				return -EFAULT;
+			}
+			info.cap_offset = sizeof(info);
+			if (offsetofend(struct vfio_irq_info, cap_offset) >
+					minsz)
+				minsz = offsetofend(struct vfio_irq_info,
+						    cap_offset);
+		}
+		kfree(caps.buf);
+	}
+	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+
+default_handle:
+	return vfio_pci_ioctl(device_data, cmd, arg);
+}
+
+static int i40e_vf_register_irq(struct i40e_vf_migration *i40e_vf_dev,
+				unsigned int type, unsigned int subtype,
+				u32 flags, const struct i40e_vf_irqops *ops)
+{
+	struct i40e_vf_irq *irqs;
+
+	irqs = krealloc(i40e_vf_dev->irqs,
+			(i40e_vf_dev->num_irqs + 1) * sizeof(*irqs),
+			GFP_KERNEL);
+	if (!irqs)
+		return -ENOMEM;
+
+	i40e_vf_dev->irqs = irqs;
+	i40e_vf_dev->irqs[i40e_vf_dev->num_irqs].type = type;
+	i40e_vf_dev->irqs[i40e_vf_dev->num_irqs].subtype = subtype;
+	i40e_vf_dev->irqs[i40e_vf_dev->num_irqs].count = 1;
+	i40e_vf_dev->irqs[i40e_vf_dev->num_irqs].flags = flags;
+	i40e_vf_dev->irqs[i40e_vf_dev->num_irqs].ops = ops;
+	i40e_vf_dev->num_irqs++;
+	return 0;
+}
 static int i40e_vf_iommu_notifier(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
@@ -100,6 +360,12 @@ static int i40e_vf_prepare_dirty_track(struct i40e_vf_migration *i40e_vf_dev)
 		goto out_group;
 	}
 
+	/* wait for bar 0 is remapped to read-write */
+	ret = i40e_vf_remap_bars(i40e_vf_dev, true);
+	if (ret) {
+		pr_err("failed to remap BAR 0\n");
+		goto out_group;
+	}
 	i40e_vf_dev->in_dirty_track = true;
 	return 0;
 
@@ -121,6 +387,8 @@ static void i40e_vf_stop_dirty_track(struct i40e_vf_migration *i40e_vf_dev)
 				 &i40e_vf_dev->iommu_notifier);
 	vfio_group_put_external_user(i40e_vf_dev->vfio_group);
 	i40e_vf_dev->in_dirty_track = false;
+	/* just nottify userspace to remap bar0 without waiting */
+	i40e_vf_remap_bars(i40e_vf_dev, false);
 }
 
 static size_t i40e_vf_set_device_state(struct i40e_vf_migration *i40e_vf_dev,
@@ -134,6 +402,8 @@ static size_t i40e_vf_set_device_state(struct i40e_vf_migration *i40e_vf_dev,
 
 	switch (state) {
 	case VFIO_DEVICE_STATE_RUNNING:
+		if (mig_ctl->device_state & VFIO_DEVICE_STATE_SAVING)
+			i40e_vf_stop_dirty_track(i40e_vf_dev);
 		break;
 	case VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING:
 		ret = i40e_vf_prepare_dirty_track(i40e_vf_dev);
@@ -360,7 +630,25 @@ static long i40e_vf_get_region_info(void *device_data,
 		-EFAULT : 0;
 
 default_handle:
-	return vfio_pci_ioctl(device_data, cmd, arg);
+	ret = vfio_pci_ioctl(device_data, cmd, arg);
+	if (ret)
+		return ret;
+
+	if (info.index == VFIO_PCI_BAR0_REGION_INDEX) {
+		if (!i40e_vf_dev->in_dirty_track)
+			return ret;
+
+		/* read default handler's data back*/
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+					VFIO_REGION_INFO_FLAG_WRITE;
+		/* update customized region info*/
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+	}
+	return ret;
 }
 
 static int i40e_vf_open(void *device_data)
@@ -392,10 +680,20 @@ static int i40e_vf_open(void *device_data)
 		if (ret)
 			goto error;
 
+		ret = i40e_vf_register_irq(i40e_vf_dev,
+					   VFIO_IRQ_TYPE_REMAP_BAR_REGION,
+					   VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION,
+					   VFIO_IRQ_INFO_MASKABLE |
+					   VFIO_IRQ_INFO_EVENTFD,
+					   &i40e_vf_irqops_remap_bars);
+		if (ret)
+			goto error;
+
 		i40e_vf_dev->mig_ctl = mig_ctl;
 		vfio_pci_set_vendor_regions(device_data,
 					    i40e_vf_dev->num_regions);
-		vfio_pci_set_vendor_irqs(device_data, 0);
+		vfio_pci_set_vendor_irqs(device_data,
+					 i40e_vf_dev->num_irqs);
 	}
 
 	ret = vfio_pci_open(device_data);
@@ -413,6 +711,9 @@ static int i40e_vf_open(void *device_data)
 		i40e_vf_dev->regions = NULL;
 		vfio_pci_set_vendor_regions(device_data, 0);
 		vfio_pci_set_vendor_irqs(device_data, 0);
+		i40e_vf_dev->irqs = NULL;
+		i40e_vf_dev->num_irqs = 0;
+		kfree(i40e_vf_dev->irqs);
 	}
 	module_put(THIS_MODULE);
 	mutex_unlock(&i40e_vf_dev->reflock);
@@ -436,7 +737,16 @@ void i40e_vf_release(void *device_data)
 		kfree(i40e_vf_dev->regions);
 		i40e_vf_dev->regions = NULL;
 		vfio_pci_set_vendor_regions(device_data, 0);
+
 		vfio_pci_set_vendor_irqs(device_data, 0);
+		for (i = 0; i < i40e_vf_dev->num_irqs; i++)
+			i40e_vf_dev->irqs[i].ops->set_irqs(i40e_vf_dev,
+					VFIO_IRQ_SET_DATA_NONE |
+					VFIO_IRQ_SET_ACTION_TRIGGER,
+					i, 0, 0, NULL);
+		kfree(i40e_vf_dev->irqs);
+		i40e_vf_dev->irqs = NULL;
+		i40e_vf_dev->num_irqs = 0;
 	}
 	vfio_pci_release(device_data);
 	mutex_unlock(&i40e_vf_dev->reflock);
@@ -448,6 +758,10 @@ static long i40e_vf_ioctl(void *device_data,
 {
 	if (cmd == VFIO_DEVICE_GET_REGION_INFO)
 		return i40e_vf_get_region_info(device_data, cmd, arg);
+	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
+		return i40e_vf_get_irq_info(device_data, cmd, arg);
+	else if (cmd == VFIO_DEVICE_SET_IRQS)
+		return i40e_vf_set_irqs(device_data, cmd, arg);
 
 	return vfio_pci_ioctl(device_data, cmd, arg);
 }
@@ -487,8 +801,10 @@ static ssize_t i40e_vf_write(void *device_data, const char __user *buf,
 	int num_vdev_regions = vfio_pci_num_regions(device_data);
 	int num_vendor_region = i40e_vf_dev->num_regions;
 
-	if (index == VFIO_PCI_BAR0_REGION_INDEX)
+	if (index == VFIO_PCI_BAR0_REGION_INDEX) {
+		pr_debug("vfio bar 0 write\n");
 		;// scan dirty pages
+	}
 
 	if (index < VFIO_PCI_NUM_REGIONS + num_vdev_regions)
 		return vfio_pci_write(device_data, buf, count, ppos);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
index 918ba275d5b5..2c4d9ebee4ac 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
@@ -46,6 +46,14 @@ struct pci_sriov {
 	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
 };
 
+struct i40e_vf_remap_irq_ctx {
+	struct eventfd_ctx	*trigger;
+	struct virqfd		*sync;
+	atomic_t		cnt;
+	wait_queue_head_t	waitq;
+	bool			init;
+};
+
 struct i40e_vf_migration {
 	__u32				vf_vendor;
 	__u32				vf_device;
@@ -58,11 +66,14 @@ struct i40e_vf_migration {
 
 	struct vfio_device_migration_info *mig_ctl;
 	bool				in_dirty_track;
+	struct i40e_vf_remap_irq_ctx  remap_irq_ctx;
 
 	struct i40e_vf_region		*regions;
 	int				num_regions;
 	struct notifier_block		iommu_notifier;
 	struct vfio_group		*vfio_group;
+	struct i40e_vf_irq		*irqs;
+	int				num_irqs;
 
 };
 
@@ -89,5 +100,20 @@ struct i40e_vf_region {
 	void				*data;
 };
 
+struct i40e_vf_irqops {
+	int (*set_irqs)(struct i40e_vf_migration *i40e_vf_dev,
+			u32 flags, unsigned int index,
+			unsigned int start, unsigned int count,
+			void *data);
+};
+
+struct i40e_vf_irq {
+	u32	type;
+	u32	subtype;
+	u32	flags;
+	u32	count;
+	const struct i40e_vf_irqops *ops;
+};
+
 #endif /* I40E_MIG_H */
 
-- 
2.17.1

