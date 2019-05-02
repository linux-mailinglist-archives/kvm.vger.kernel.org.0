Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED2A11872
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 13:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfEBLtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 07:49:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726580AbfEBLtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 07:49:07 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D57D38763B;
        Thu,  2 May 2019 11:49:06 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C2BD17DDF;
        Thu,  2 May 2019 11:48:56 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Paul E . McKenney " <paulmck@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liang Cunming <cunming.liang@intel.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Fam Zheng <fam@euphon.net>, Amnon Ilan <ailan@redhat.com>,
        John Ferlan <jferlan@redhat.com>
Subject: [PATCH v2 06/10] nvme/core: add mdev interfaces
Date:   Thu,  2 May 2019 14:47:57 +0300
Message-Id: <20190502114801.23116-7-mlevitsk@redhat.com>
In-Reply-To: <20190502114801.23116-1-mlevitsk@redhat.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 02 May 2019 11:49:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds infrastructure for a nvme-mdev
to attach to the core driver, to be able to
know which nvme controllers are present and which
namespaces they have.

It also adds an interface to nvme device drivers
which expose the its queues in a controlled manner
to the nvme mdev core driver. A driver must opt-in
for this using a new flag NVME_F_MDEV_SUPPORTED

If the mdev device driver also sets the
NVME_F_MDEV_DMA_SUPPORTED, the mdev core will
dma map all the guest memory into the nvme device,
so that nvme device driver can use dma addresses as passed
from the mdev core driver

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/nvme/host/core.c | 125 ++++++++++++++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h |  54 +++++++++++++++--
 2 files changed, 172 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 22db0c51a0bf..3c1b91089631 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -89,11 +89,111 @@ static dev_t nvme_chr_devt;
 static struct class *nvme_class;
 static struct class *nvme_subsys_class;
 
+static void nvme_ns_remove(struct nvme_ns *ns);
 static int nvme_revalidate_disk(struct gendisk *disk);
 static void nvme_put_subsystem(struct nvme_subsystem *subsys);
 static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
 					   unsigned nsid);
 
+#ifdef CONFIG_NVME_MDEV
+
+static struct nvme_mdev_driver *mdev_driver_interface;
+static DEFINE_MUTEX(mdev_ctrl_lock);
+static LIST_HEAD(mdev_ctrl_list);
+
+static bool nvme_ctrl_has_mdev(struct nvme_ctrl *ctrl)
+{
+	return  (ctrl->ops->flags & NVME_F_MDEV_SUPPORTED) != 0;
+}
+
+static void nvme_mdev_add_ctrl(struct nvme_ctrl *ctrl)
+{
+	if (nvme_ctrl_has_mdev(ctrl)) {
+		mutex_lock(&mdev_ctrl_lock);
+		list_add_tail(&ctrl->link, &mdev_ctrl_list);
+		mutex_unlock(&mdev_ctrl_lock);
+	}
+}
+
+static void nvme_mdev_remove_ctrl(struct nvme_ctrl *ctrl)
+{
+	if (nvme_ctrl_has_mdev(ctrl)) {
+		mutex_lock(&mdev_ctrl_lock);
+		list_del_init(&ctrl->link);
+		mutex_unlock(&mdev_ctrl_lock);
+	}
+}
+
+int nvme_core_register_mdev_driver(struct nvme_mdev_driver *driver_ops)
+{
+	struct nvme_ctrl *ctrl;
+
+	if (mdev_driver_interface)
+		return -EEXIST;
+
+	mdev_driver_interface = driver_ops;
+
+	mutex_lock(&mdev_ctrl_lock);
+	list_for_each_entry(ctrl, &mdev_ctrl_list, link)
+		mdev_driver_interface->nvme_ctrl_state_changed(ctrl);
+
+	mutex_unlock(&mdev_ctrl_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvme_core_register_mdev_driver);
+
+void nvme_core_unregister_mdev_driver(struct nvme_mdev_driver *driver_ops)
+{
+	if (WARN_ON(driver_ops != mdev_driver_interface))
+		return;
+	mdev_driver_interface = NULL;
+}
+EXPORT_SYMBOL_GPL(nvme_core_unregister_mdev_driver);
+
+static void nvme_mdev_ctrl_state_changed(struct nvme_ctrl *ctrl)
+{
+	if (!mdev_driver_interface || !nvme_ctrl_has_mdev(ctrl))
+		return;
+	if (!try_module_get(mdev_driver_interface->owner))
+		return;
+
+	mdev_driver_interface->nvme_ctrl_state_changed(ctrl);
+	module_put(mdev_driver_interface->owner);
+}
+
+static void nvme_mdev_ns_state_changed(struct nvme_ctrl *ctrl,
+				       struct nvme_ns *ns, bool removed)
+{
+	if (!mdev_driver_interface || !nvme_ctrl_has_mdev(ctrl))
+		return;
+	if (!try_module_get(mdev_driver_interface->owner))
+		return;
+
+	mdev_driver_interface->nvme_ns_state_changed(ctrl,
+			ns->head->ns_id, removed);
+	module_put(mdev_driver_interface->owner);
+}
+
+#else
+static void nvme_mdev_ctrl_state_changed(struct nvme_ctrl *ctrl)
+{
+}
+
+static void nvme_mdev_ns_state_changed(struct nvme_ctrl *ctrl,
+				       struct nvme_ns *ns, bool removed)
+{
+}
+
+static void nvme_mdev_add_ctrl(struct nvme_ctrl *ctrl)
+{
+}
+
+static void nvme_mdev_remove_ctrl(struct nvme_ctrl *ctrl)
+{
+}
+
+#endif
+
 static void nvme_set_queue_dying(struct nvme_ns *ns)
 {
 	/*
@@ -387,10 +487,13 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 
 	if (changed)
 		ctrl->state = new_state;
-
 	spin_unlock_irqrestore(&ctrl->lock, flags);
+
+	nvme_mdev_ctrl_state_changed(ctrl);
+
 	if (changed && ctrl->state == NVME_CTRL_LIVE)
 		nvme_kick_requeue_lists(ctrl);
+
 	return changed;
 }
 EXPORT_SYMBOL_GPL(nvme_change_ctrl_state);
@@ -426,10 +529,11 @@ static void nvme_free_ns(struct kref *kref)
 	kfree(ns);
 }
 
-static void nvme_put_ns(struct nvme_ns *ns)
+void nvme_put_ns(struct nvme_ns *ns)
 {
 	kref_put(&ns->kref, nvme_free_ns);
 }
+EXPORT_SYMBOL_GPL(nvme_put_ns);
 
 static inline void nvme_clear_nvme_request(struct request *req)
 {
@@ -1289,6 +1393,11 @@ static u32 nvme_passthru_start(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	return effects;
 }
 
+static void nvme_update_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
+{
+	nvme_mdev_ns_state_changed(ctrl, ns, false);
+}
+
 static void nvme_update_formats(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
@@ -1297,6 +1406,8 @@ static void nvme_update_formats(struct nvme_ctrl *ctrl)
 	list_for_each_entry(ns, &ctrl->namespaces, list)
 		if (ns->disk && nvme_revalidate_disk(ns->disk))
 			nvme_set_queue_dying(ns);
+		else
+			nvme_update_ns(ctrl, ns);
 	up_read(&ctrl->namespaces_rwsem);
 
 	nvme_remove_invalid_namespaces(ctrl, NVME_NSID_ALL);
@@ -3186,7 +3297,7 @@ static int ns_cmp(void *priv, struct list_head *a, struct list_head *b)
 	return nsa->head->ns_id - nsb->head->ns_id;
 }
 
-static struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned nsid)
+struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned int nsid)
 {
 	struct nvme_ns *ns, *ret = NULL;
 
@@ -3204,6 +3315,7 @@ static struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	up_read(&ctrl->namespaces_rwsem);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(nvme_find_get_ns);
 
 static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
 {
@@ -3336,6 +3448,8 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	if (test_and_set_bit(NVME_NS_REMOVING, &ns->flags))
 		return;
 
+	nvme_mdev_ns_state_changed(ns->ctrl, ns, true);
+
 	nvme_fault_inject_fini(ns);
 	if (ns->disk && ns->disk->flags & GENHD_FL_UP) {
 		del_gendisk(ns->disk);
@@ -3366,6 +3480,8 @@ static void nvme_validate_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	if (ns) {
 		if (ns->disk && revalidate_disk(ns->disk))
 			nvme_ns_remove(ns);
+		else
+			nvme_update_ns(ctrl, ns);
 		nvme_put_ns(ns);
 	} else
 		nvme_alloc_ns(ctrl, nsid);
@@ -3717,6 +3833,7 @@ static void nvme_free_ctrl(struct device *dev)
 		sysfs_remove_link(&subsys->dev.kobj, dev_name(ctrl->device));
 	}
 
+	nvme_mdev_remove_ctrl(ctrl);
 	ctrl->ops->free_ctrl(ctrl);
 
 	if (subsys)
@@ -3789,6 +3906,8 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 	dev_pm_qos_update_user_latency_tolerance(ctrl->device,
 		min(default_ps_max_latency_us, (unsigned long)S32_MAX));
 
+	nvme_mdev_add_ctrl(ctrl);
+
 	return 0;
 out_free_name:
 	kfree_const(ctrl->device->kobj.name);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index d040eb00e880..6ec14ce0d015 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -148,6 +148,7 @@ enum nvme_ctrl_state {
 };
 
 struct nvme_ctrl {
+	struct list_head link;
 	bool comp_seen;
 	enum nvme_ctrl_state state;
 	bool identified;
@@ -255,6 +256,23 @@ enum nvme_iopolicy {
 	NVME_IOPOLICY_RR,
 };
 
+#ifdef CONFIG_NVME_MDEV
+/* Interface to the host driver  */
+struct nvme_mdev_driver {
+	struct module *owner;
+
+	/* a controller state has changed*/
+	void (*nvme_ctrl_state_changed)(struct nvme_ctrl *ctrl);
+
+	/* NS is updated in some way (after format or so) */
+	void (*nvme_ns_state_changed)(struct nvme_ctrl *ctrl,
+				      u32 nsid, bool removed);
+};
+
+int nvme_core_register_mdev_driver(struct nvme_mdev_driver *driver_ops);
+void nvme_core_unregister_mdev_driver(struct nvme_mdev_driver *driver_ops);
+#endif
+
 struct nvme_subsystem {
 	int			instance;
 	struct device		dev;
@@ -280,7 +298,7 @@ struct nvme_subsystem {
 };
 
 /*
- * Container structure for uniqueue namespace identifiers.
+ * Container structure for unique namespace identifiers.
  */
 struct nvme_ns_ids {
 	u8	eui64[8];
@@ -356,13 +374,22 @@ struct nvme_ns {
 
 };
 
+struct nvme_ext_data_iter;
+struct nvme_ext_cmd_result {
+	u32 tag;
+	u16 status;
+};
+
 struct nvme_ctrl_ops {
 	const char *name;
 	struct module *module;
 	unsigned int flags;
-#define NVME_F_FABRICS			(1 << 0)
-#define NVME_F_METADATA_SUPPORTED	(1 << 1)
-#define NVME_F_PCI_P2PDMA		(1 << 2)
+#define NVME_F_FABRICS			BIT(0)
+#define NVME_F_METADATA_SUPPORTED	BIT(1)
+#define NVME_F_PCI_P2PDMA		BIT(2)
+#define NVME_F_MDEV_SUPPORTED		BIT(3)
+#define NVME_F_MDEV_DMA_SUPPORTED	BIT(4)
+
 	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
 	int (*reg_read64)(struct nvme_ctrl *ctrl, u32 off, u64 *val);
@@ -370,6 +397,23 @@ struct nvme_ctrl_ops {
 	void (*submit_async_event)(struct nvme_ctrl *ctrl);
 	void (*delete_ctrl)(struct nvme_ctrl *ctrl);
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
+
+#ifdef CONFIG_NVME_MDEV
+	int (*ext_queues_available)(struct nvme_ctrl *ctrl);
+	int (*ext_queue_alloc)(struct nvme_ctrl *ctrl, u16 *qid);
+	void (*ext_queue_free)(struct nvme_ctrl *ctrl, u16 qid);
+
+	int (*ext_queue_submit)(struct nvme_ctrl *ctrl,
+				u16 qid, u32 tag,
+				struct nvme_command *command,
+				struct nvme_ext_data_iter *iter);
+
+	bool (*ext_queue_full)(struct nvme_ctrl *ctrl, u16 qid);
+
+	int (*ext_queue_poll)(struct nvme_ctrl *ctrl, u16 qid,
+			      struct nvme_ext_cmd_result *results,
+			      unsigned int max_len);
+#endif
 };
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
@@ -431,6 +475,8 @@ void nvme_stop_ctrl(struct nvme_ctrl *ctrl);
 void nvme_put_ctrl(struct nvme_ctrl *ctrl);
 int nvme_init_identify(struct nvme_ctrl *ctrl);
 
+struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned int nsid);
+void nvme_put_ns(struct nvme_ns *ns);
 void nvme_remove_namespaces(struct nvme_ctrl *ctrl);
 
 int nvme_sec_submit(void *data, u16 spsp, u8 secp, void *buffer, size_t len,
-- 
2.17.2

