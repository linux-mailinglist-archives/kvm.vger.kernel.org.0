Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1AE70C3C6
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 18:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbjEVQ6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 12:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjEVQ6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 12:58:31 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6B2CD
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:58:28 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f3bb395e69so2347311e87.2
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1684774707; x=1687366707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2YEK8V1iE3jbtOgQJPrm5sjyneDPTQf/Y9Fy1jGbFiM=;
        b=StTE29ChmqjDJhM1WJ9dglLtItmG4CNQ8Wk9plhP/SVnwi+9Tj7ZKe6k+0JsKZbTG1
         4b/Fo/xTa1HdyKE4F6hVZcrx2I+ebsNWGbztPA8fbGrVzZnqN0XuSbqnOaxLhbpzgtRH
         gbtgIAPgCteSdRwxAyCXl3pw2sj7I0cjse/dIlyD2kZAxeCgCWtsRV3MWJlDnjvcr343
         uI0CWcjlbt86iqpXNJs/LbqPcz78iuJh0aMpZfa5j8NGMNTmTiLtfj/zl17sn4BGiBEM
         88KcBgiD/PvObg4cWTAb0nEYcwWqLvzZyLWlhrmVVXQLzCjdxsCYRIRi6XGmNvvtvN2p
         3l/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684774707; x=1687366707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YEK8V1iE3jbtOgQJPrm5sjyneDPTQf/Y9Fy1jGbFiM=;
        b=OOcAXmUb+nC9HQzpIU4MC4od26nQsz1qcNvO4cYO8Y3C6w5M3UCIRYwEaGAwCJhb20
         Wc8ocUrSxQuyxZ3J2QRZDgo2VnaZphYDvwD1Gj+YicsqPsX99UKBQRxg+FH/vLD5VBRS
         4Gdmgv2oW6FZq+dF5LO6LoFpMjgRFrFxKmBBtLuIKhejsPROmuXqLMuXRm9RA8rjnJTq
         gUcR32nTjw4IiyISbfW/1bgzXSyo30WbQh4xw0K8NGmL2N0aELMduR0Qjyi5PF4v2Y+/
         XuOrzsfwghY7aNLUXbQRUUV36Q3tlnuWJU2fei8CwQyvHwtzbW/J8800eJvtrz735ZJc
         fOqA==
X-Gm-Message-State: AC+VfDzWa5dedbhEMmcRZePX+LZp3uJURqJpegNr4thTIlOonHqagnSs
        GgZfp/qP9CUZkf7tHNlokJ5UJw==
X-Google-Smtp-Source: ACHHUZ7ZyV7FxI7/DAWVDlc0Ys5gHS/r8SpbvWBjBU+vvFTroKcyfO03UdK5ZinwlNt6zAAc9tHmNQ==
X-Received: by 2002:ac2:5298:0:b0:4f3:b1dc:b46b with SMTP id q24-20020ac25298000000b004f3b1dcb46bmr2958133lfm.1.1684774706638;
        Mon, 22 May 2023 09:58:26 -0700 (PDT)
Received: from jazctssd.c.googlers.com.com (138.58.228.35.bc.googleusercontent.com. [35.228.58.138])
        by smtp.gmail.com with ESMTPSA id q10-20020a19a40a000000b004edd2dc9a09sm1032844lfc.258.2023.05.22.09.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 09:58:26 -0700 (PDT)
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
To:     linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Cc:     dmy@semihalf.com, tn@semihalf.com, dbehr@google.com,
        dbehr@chromium.org, upstream@semihalf.com, dtor@google.com,
        jgg@ziepe.ca, kevin.tian@intel.com, cohuck@redhat.com,
        abhsahu@nvidia.com, yishaih@nvidia.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, libvir-list@redhat.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, mjrosato@linux.ibm.com,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Subject: [PATCH v4] vfio/pci: Propagate ACPI notifications to user-space via eventfd
Date:   Mon, 22 May 2023 16:58:11 +0000
Message-ID: <20230522165811.123417-1-jaz@semihalf.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To allow pass-through devices receiving ACPI notifications, permit to
register ACPI notify handler (via VFIO_DEVICE_SET_IRQS) for a given
device. The handler role is to receive and propagate such ACPI
notifications to the user-space through the user provided eventfd. This
allows VMM to receive and propagate them further to the VM, where the
actual driver for pass-through device resides and can react to device
specific notifications accordingly.

The eventfd usage ensures VMM and device isolation: it allows to use a
dedicated channel associated with the device for such events, such that
the VMM has direct access.

Since the eventfd counter is used as ACPI notification value
placeholder, the eventfd signaling needs to be serialized in order to
not end up with notification values being coalesced. Therefore ACPI
notification values are buffered and signalized one by one, when the
previous notification value has been consumed.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
---
Changelog v3..v4
Address Alex Williamson feedback:
- Instead of introducing new ioctl used for eventfd registration, take
  advantage of VFIO_DEVICE_SET_IRQS which already supports virtual IRQs
  for things like error notification and device release requests.
- Introduced mechanism preventing creation of large queues.
Other:
- Move the implementation into the newly introduced VFIO_ACPI_NOTIFY
  helper module. It is actually not bound to VFIO_PCI but VFIO_PCI
  enables it whenever ACPI support is enabled. This change is introduced
  since ACPI notifications are not limited to PCI devices, making it PCI
  independent will allow to re-use it also for other VFIO_* like
  supports: e.g. VFIO_PLATFORM in the future if needed. Moving it out of
  drivers/vfio/pci/ was also suggested offline.
- s/notify_val_next/node
- v3: https://patchwork.kernel.org/project/kvm/patch/20230502132700.654528-1-jaszczyk@google.com/

Changelog v2..v3:
- Fix compilation warnings when building with "W=1"

Changelog v1..v2:
- The v2 implementation is actually completely different then v1:
  instead of using acpi netlink events for propagating ACPI
  notifications to the user space take advantage of eventfd, which can
  provide better VMM and device isolation: it allows to use a dedicated
  channel associated with the device for such events, such that the VMM
  has direct access.
- Using eventfd counter as notification value placeholder was suggested
  in v1 and requires additional serialization logic introduced in v2.
- Since the vfio-pci supports non-ACPI platforms address !CONFIG_ACPI
  case.
- v1 discussion: https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-jaz@semihalf.com/
---
---
 drivers/vfio/Kconfig              |   5 +
 drivers/vfio/Makefile             |   1 +
 drivers/vfio/pci/Kconfig          |   1 +
 drivers/vfio/pci/vfio_pci_core.c  |   9 ++
 drivers/vfio/pci/vfio_pci_intrs.c |  73 ++++++++++
 drivers/vfio/vfio_acpi_notify.c   | 219 ++++++++++++++++++++++++++++++
 include/linux/vfio_acpi_notify.h  |  40 ++++++
 include/linux/vfio_pci_core.h     |   1 +
 include/uapi/linux/vfio.h         |   1 +
 9 files changed, 350 insertions(+)
 create mode 100644 drivers/vfio/vfio_acpi_notify.c
 create mode 100644 include/linux/vfio_acpi_notify.h

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 89e06c981e43..7822b0d8e7b1 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -12,6 +12,11 @@ menuconfig VFIO
 	  If you don't know what to do here, say N.
 
 if VFIO
+config VFIO_ACPI_NOTIFY
+	tristate
+	depends on ACPI
+	default n
+
 config VFIO_CONTAINER
 	bool "Support for the VFIO container /dev/vfio/vfio"
 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 70e7dcb302ef..129c121b503d 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
 obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
+obj-$(CONFIG_VFIO_ACPI_NOTIFY) += vfio_acpi_notify.o
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738..5d229dbd074c 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -14,6 +14,7 @@ config VFIO_PCI_INTX
 config VFIO_PCI
 	tristate "Generic VFIO support for any PCI device"
 	select VFIO_PCI_CORE
+	select VFIO_ACPI_NOTIFY if ACPI
 	help
 	  Support for the generic PCI VFIO bus driver which can connect any
 	  PCI device to the VFIO framework.
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..b42299396d81 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,6 +27,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#include <linux/vfio_acpi_notify.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -683,6 +684,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
 
 	if (vdev->sriov_pf_core_dev) {
 		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
@@ -705,6 +707,11 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		vdev->req_trigger = NULL;
 	}
 	mutex_unlock(&vdev->igate);
+
+	if (adev) {
+		vfio_acpi_notify_cleanup(vdev->acpi_notification, adev);
+		vdev->acpi_notification = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 
@@ -761,6 +768,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 			return 1;
 	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
+	} else if (irq_type == VFIO_PCI_ACPI_NTFY_IRQ_INDEX) {
+		return 1;
 	}
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index bffb0741518b..e28f70c213ca 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -10,6 +10,7 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
+#include <linux/acpi.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/eventfd.h>
@@ -19,6 +20,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/vfio_acpi_notify.h>
 
 #include "vfio_pci_priv.h"
 
@@ -667,6 +669,63 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 					       count, flags, data);
 }
 
+static int
+vfio_pci_set_acpi_ntfy_trigger(struct vfio_pci_core_device *vdev,
+			       unsigned int index, unsigned int start,
+			       unsigned int count, uint32_t flags, void *data)
+{
+	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
+
+	if (index != VFIO_PCI_ACPI_NTFY_IRQ_INDEX || start != 0 || count > 1)
+		return -EINVAL;
+
+	if (!vdev->acpi_notification)
+		return -EINVAL;
+
+	/*
+	 * Disable notifications: flags = (DATA_NONE|ACTION_TRIGGER), count = 0
+	 * Enable loopback testing: (DATA_BOOL|ACTION_TRIGGER)
+	 */
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		if (!count) {
+			vfio_acpi_notify_cleanup(vdev->acpi_notification, adev);
+			vdev->acpi_notification = NULL;
+			return 0;
+		}
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		u32 notification_val;
+
+		if (!count)
+			return -EINVAL;
+
+		notification_val = *(u32 *)data;
+		vfio_acpi_notify(NULL, notification_val, vdev->acpi_notification);
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int
+vfio_pci_set_acpi_ntfy_eventfd_trigger(struct vfio_pci_core_device *vdev,
+				       unsigned int index, unsigned int start,
+				       unsigned int count, uint32_t flags, void *data)
+{
+	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
+	int32_t fd;
+
+	if (index != VFIO_PCI_ACPI_NTFY_IRQ_INDEX || start != 0 || count != 1)
+		return -EINVAL;
+
+	if (!adev)
+		return -ENODEV;
+
+	fd = *(int32_t *)data;
+
+	return vfio_register_acpi_notify_handler(&vdev->acpi_notification, adev, fd);
+}
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -716,6 +775,20 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_ACPI_NTFY_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
+			case VFIO_IRQ_SET_DATA_BOOL:
+			case VFIO_IRQ_SET_DATA_NONE:
+				func = vfio_pci_set_acpi_ntfy_trigger;
+				break;
+			case VFIO_IRQ_SET_DATA_EVENTFD:
+				func = vfio_pci_set_acpi_ntfy_eventfd_trigger;
+				break;
+			}
+		}
+		break;
 	}
 
 	if (!func)
diff --git a/drivers/vfio/vfio_acpi_notify.c b/drivers/vfio/vfio_acpi_notify.c
new file mode 100644
index 000000000000..8ef4db4b43b3
--- /dev/null
+++ b/drivers/vfio/vfio_acpi_notify.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VFIO ACPI notification propagation
+ *
+ * Author: Grzegorz Jaszczyk <jaz@semihalf.com>
+ */
+#include <linux/vfio_acpi_notify.h>
+
+#define DRIVER_AUTHOR "Grzegorz Jaszczyk <jaz@semihalf.com>"
+#define DRIVER_DESC "ACPI notification propagation helper module for VFIO based devices"
+
+#define NOTIFICATION_QUEUE_SIZE 20
+
+struct notification_queue {
+	int notification_val;
+	struct list_head node;
+};
+
+static int vfio_eventfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
+				   int sync, void *key)
+{
+	struct vfio_acpi_notification *acpi_notify =
+		container_of(wait, struct vfio_acpi_notification, wait);
+	__poll_t flags = key_to_poll(key);
+
+	/*
+	 * eventfd_read signalize EPOLLOUT at the end of its function - this
+	 * means previous eventfd with its notification value was consumed so
+	 * the next notification can be signalized now if pending - schedule
+	 * proper work.
+	 */
+	if (flags & EPOLLOUT) {
+		mutex_unlock(&acpi_notify->notification_lock);
+		schedule_work(&acpi_notify->acpi_notification_work);
+	}
+
+	return 0;
+}
+
+static void vfio_ptable_queue_proc(struct file *file,
+				       wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct vfio_acpi_notification *acpi_notify =
+		container_of(pt, struct vfio_acpi_notification, pt);
+
+	add_wait_queue(wqh, &acpi_notify->wait);
+}
+
+static void acpi_notification_work_fn(struct work_struct *work)
+{
+	struct vfio_acpi_notification *acpi_notify;
+	struct notification_queue *entry;
+
+	acpi_notify = container_of(work, struct vfio_acpi_notification,
+				   acpi_notification_work);
+
+	mutex_lock(&acpi_notify->notification_list_lock);
+	if (list_empty(&acpi_notify->notification_list) || !acpi_notify->acpi_notify_trigger)
+		goto out;
+
+	/*
+	 * If the previous eventfd was not yet consumed by user-space lets hold
+	 * on and exit. The notification function will be rescheduled when
+	 * signaling eventfd will be possible (when the EPOLLOUT will be
+	 * signalized and unlocks notify_events).
+	 */
+	if (!mutex_trylock(&acpi_notify->notification_lock))
+		goto out;
+
+	entry = list_first_entry(&acpi_notify->notification_list,
+				 struct notification_queue, node);
+
+	list_del(&entry->node);
+	acpi_notify->notification_queue_count--;
+	mutex_unlock(&acpi_notify->notification_list_lock);
+
+	eventfd_signal(acpi_notify->acpi_notify_trigger, entry->notification_val);
+
+	kfree(entry);
+
+	return;
+out:
+	mutex_unlock(&acpi_notify->notification_list_lock);
+}
+
+void vfio_acpi_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct vfio_acpi_notification *acpi_notify = (struct vfio_acpi_notification *)data;
+	struct notification_queue *entry;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	entry->notification_val = event;
+	INIT_LIST_HEAD(&entry->node);
+
+	mutex_lock(&acpi_notify->notification_list_lock);
+	if (acpi_notify->notification_queue_count > NOTIFICATION_QUEUE_SIZE) {
+		struct notification_queue *oldest_entry;
+
+		oldest_entry = list_first_entry(&acpi_notify->notification_list,
+						struct notification_queue,
+						node);
+		list_del(&oldest_entry->node);
+		acpi_notify->notification_queue_count--;
+		kfree(oldest_entry);
+
+	}
+	list_add_tail(&entry->node, &acpi_notify->notification_list);
+	acpi_notify->notification_queue_count++;
+	mutex_unlock(&acpi_notify->notification_list_lock);
+
+	schedule_work(&acpi_notify->acpi_notification_work);
+}
+EXPORT_SYMBOL_GPL(vfio_acpi_notify);
+
+void vfio_acpi_notify_cleanup(struct vfio_acpi_notification *acpi_notify,
+			      struct acpi_device *adev)
+{
+	struct notification_queue *entry, *entry_tmp;
+	u64 cnt;
+
+	if (!acpi_notify || !acpi_notify->acpi_notify_trigger)
+		return;
+
+	acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+				   vfio_acpi_notify);
+
+	eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
+				      &acpi_notify->wait, &cnt);
+
+	flush_work(&acpi_notify->acpi_notification_work);
+
+	mutex_lock(&acpi_notify->notification_list_lock);
+	list_for_each_entry_safe(entry, entry_tmp,
+				 &acpi_notify->notification_list,
+				 node) {
+		list_del(&entry->node);
+		kfree(entry);
+	}
+	mutex_unlock(&acpi_notify->notification_list_lock);
+
+	eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
+
+	kfree(acpi_notify);
+}
+EXPORT_SYMBOL_GPL(vfio_acpi_notify_cleanup);
+
+int vfio_register_acpi_notify_handler(struct vfio_acpi_notification **acpi_notify_ptr,
+					  struct acpi_device *adev, int32_t fd)
+{
+	struct vfio_acpi_notification *acpi_notify = *acpi_notify_ptr;
+	struct file *acpi_notify_trigger_file;
+	struct eventfd_ctx *efdctx;
+	acpi_status status;
+
+	if (fd < -1)
+		return -EINVAL;
+	else if (fd == -1)
+		vfio_acpi_notify_cleanup(acpi_notify, adev);
+
+	if (acpi_notify && acpi_notify->acpi_notify_trigger)
+		return -EBUSY;
+
+	efdctx = eventfd_ctx_fdget(fd);
+	if (IS_ERR(efdctx))
+		return PTR_ERR(efdctx);
+
+	acpi_notify = kzalloc(sizeof(*acpi_notify), GFP_KERNEL);
+	if (!acpi_notify)
+		return -ENOMEM;
+
+	*acpi_notify_ptr = acpi_notify;
+
+	INIT_WORK(&acpi_notify->acpi_notification_work, acpi_notification_work_fn);
+	INIT_LIST_HEAD(&acpi_notify->notification_list);
+
+	acpi_notify->acpi_notify_trigger = efdctx;
+
+	mutex_init(&acpi_notify->notification_lock);
+
+	/*
+	 * Install custom wake-up handler to be notified whenever underlying
+	 * eventfd is consumed by the user-space.
+	 */
+	init_waitqueue_func_entry(&acpi_notify->wait, vfio_eventfd_wakeup);
+	init_poll_funcptr(&acpi_notify->pt, vfio_ptable_queue_proc);
+
+	acpi_notify_trigger_file = eventfd_fget(fd);
+	vfs_poll(acpi_notify_trigger_file, &acpi_notify->pt);
+
+	status = acpi_install_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+					vfio_acpi_notify, (void *)acpi_notify);
+	if (ACPI_FAILURE(status)) {
+		u64 cnt;
+
+		dev_err(&adev->dev, "Failed to install notify handler: %s",
+			acpi_format_exception(status));
+
+		eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
+					      &acpi_notify->wait, &cnt);
+
+		flush_work(&acpi_notify->acpi_notification_work);
+
+		eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
+
+		kfree(acpi_notify);
+
+		return -ENODEV;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_register_acpi_notify_handler);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/vfio_acpi_notify.h b/include/linux/vfio_acpi_notify.h
new file mode 100644
index 000000000000..2722ad24d8e3
--- /dev/null
+++ b/include/linux/vfio_acpi_notify.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * VFIO ACPI notification replication
+ *
+ * Author: Grzegorz Jaszczyk <jaz@semihalf.com>
+ */
+#include <linux/acpi.h>
+#include <linux/eventfd.h>
+#include <linux/poll.h>
+
+struct vfio_acpi_notification {
+	struct eventfd_ctx	*acpi_notify_trigger;
+	struct work_struct	acpi_notification_work;
+	struct list_head	notification_list;
+	struct mutex		notification_list_lock;
+	struct mutex		notification_lock;
+	int			notification_queue_count;
+	poll_table		pt;
+	wait_queue_entry_t	wait;
+};
+
+#if IS_ENABLED(CONFIG_ACPI)
+void vfio_acpi_notify(acpi_handle handle, u32 event, void *data);
+int vfio_register_acpi_notify_handler(struct vfio_acpi_notification **acpi_notify,
+				      struct acpi_device *adev, int32_t fd);
+void vfio_acpi_notify_cleanup(struct vfio_acpi_notification *acpi_notify,
+			      struct acpi_device *adev);
+#else
+static inline void vfio_acpi_notify(acpi_handle handle, u32 event, void *data) {}
+static inline int
+vfio_register_acpi_notify_handler(struct vfio_acpi_notification **acpi_notify,
+				  struct acpi_device *adev, int32_t fd)
+{
+	return -ENODEV;
+}
+
+static inline void
+vfio_acpi_notify_cleanup(struct vfio_acpi_notification *acpi_notify,
+			 struct acpi_device *adev) {}
+#endif /* CONFIG_ACPI */
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 367fd79226a3..a4491b3d8064 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -96,6 +96,7 @@ struct vfio_pci_core_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	struct vfio_acpi_notification	*acpi_notification;
 };
 
 /* Will be exported for vfio pci drivers usage */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..b2619fd16cc4 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -625,6 +625,7 @@ enum {
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_REQ_IRQ_INDEX,
+	VFIO_PCI_ACPI_NTFY_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
-- 
2.40.1.698.g37aff9b760-goog

