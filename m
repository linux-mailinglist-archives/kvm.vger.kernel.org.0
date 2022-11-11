Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E040B625E75
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 16:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbiKKPgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 10:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiKKPgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 10:36:07 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3832DF60;
        Fri, 11 Nov 2022 07:36:02 -0800 (PST)
Received: from kwepemi100025.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N82lX0PG6zJnZL;
        Fri, 11 Nov 2022 23:32:56 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 kwepemi100025.china.huawei.com (7.221.188.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 23:35:58 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <stefanha@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <sgarzare@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>, <linux-kernel@vger.kernel.org>,
        <xiehong@huawei.com>, <parav@nvidia.com>, <kvm@vger.kernel.org>,
        <lingshan.zhu@intel.com>, <lulu@redhat.com>,
        Longpeng <longpeng2@huawei.com>
Subject: [RFC] vdpa: clear the device when opening/releasing it
Date:   Fri, 11 Nov 2022 23:35:55 +0800
Message-ID: <20221111153555.1295-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi100025.china.huawei.com (7.221.188.158)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

We should do some deeply cleanup when opening or releasing the device,
e.g trigger FLR if it is PCIe device.

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vdpa/alibaba/eni_vdpa.c    | 2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c    | 2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c   | 2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c | 2 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c  | 2 +-
 drivers/vhost/vdpa.c               | 4 ++--
 drivers/virtio/virtio_vdpa.c       | 2 +-
 include/linux/vdpa.h               | 7 ++++---
 9 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/alibaba/eni_vdpa.c b/drivers/vdpa/alibaba/eni_vdpa.c
index 5a09a09cca70..07215b174dd6 100644
--- a/drivers/vdpa/alibaba/eni_vdpa.c
+++ b/drivers/vdpa/alibaba/eni_vdpa.c
@@ -226,7 +226,7 @@ static void eni_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
 		eni_vdpa_free_irq(eni_vdpa);
 }
 
-static int eni_vdpa_reset(struct vdpa_device *vdpa)
+static int eni_vdpa_reset(struct vdpa_device *vdpa, bool clear)
 {
 	struct eni_vdpa *eni_vdpa = vdpa_to_eni(vdpa);
 	struct virtio_pci_legacy_device *ldev = &eni_vdpa->ldev;
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f9c0044c6442..b9a6ac18f358 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -496,7 +496,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 	ifcvf_set_status(vf, status);
 }
 
-static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
+static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev, bool clear)
 {
 	struct ifcvf_adapter *adapter;
 	struct ifcvf_hw *vf;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 90913365def4..6f06f9c464a3 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2560,7 +2560,7 @@ static void init_group_to_asid_map(struct mlx5_vdpa_dev *mvdev)
 		mvdev->group2asid[i] = 0;
 }
 
-static int mlx5_vdpa_reset(struct vdpa_device *vdev)
+static int mlx5_vdpa_reset(struct vdpa_device *vdev, bool clear)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index b071f0d842fb..7438a89ce939 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -504,7 +504,7 @@ static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
 	spin_unlock(&vdpasim->lock);
 }
 
-static int vdpasim_reset(struct vdpa_device *vdpa)
+static int vdpasim_reset(struct vdpa_device *vdpa, bool clear)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 35dceee3ed56..e5fee28233c0 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -691,7 +691,7 @@ static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
 	/* Now we only support read-only configuration space */
 }
 
-static int vduse_vdpa_reset(struct vdpa_device *vdpa)
+static int vduse_vdpa_reset(struct vdpa_device *vdpa, bool clear)
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
 	int ret = vduse_dev_set_status(dev, 0);
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index d35fac5cde11..3db25b622a57 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -226,7 +226,7 @@ static void vp_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
 	vp_modern_set_status(mdev, status);
 }
 
-static int vp_vdpa_reset(struct vdpa_device *vdpa)
+static int vp_vdpa_reset(struct vdpa_device *vdpa, bool clear)
 {
 	struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
 	struct virtio_pci_modern_device *mdev = vp_vdpa_to_mdev(vp_vdpa);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 166044642fd5..fdda08cd7e7a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -212,7 +212,7 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
 
 	v->in_batch = 0;
 
-	return vdpa_reset(vdpa);
+	return vdpa_reset(vdpa, true);
 }
 
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
@@ -269,7 +269,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 			vhost_vdpa_unsetup_vq_irq(v, i);
 
 	if (status == 0) {
-		ret = vdpa_reset(vdpa);
+		ret = vdpa_reset(vdpa, false);
 		if (ret)
 			return ret;
 	} else
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 9670cc79371d..8f6ae689547e 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -99,7 +99,7 @@ static void virtio_vdpa_reset(struct virtio_device *vdev)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
-	vdpa_reset(vdpa);
+	vdpa_reset(vdpa, false);
 }
 
 static bool virtio_vdpa_notify(struct virtqueue *vq)
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 6d0f5e4e82c2..a0b917743b66 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -218,6 +218,7 @@ struct vdpa_map_file {
  *				@status: virtio device status
  * @reset:			Reset device
  *				@vdev: vdpa device
+ *				@clear: need device/function level clear or not, e.g pcie_flr.
  *				Returns integer: success (0) or error (< 0)
  * @suspend:			Suspend or resume the device (optional)
  *				@vdev: vdpa device
@@ -322,7 +323,7 @@ struct vdpa_config_ops {
 	u32 (*get_vendor_id)(struct vdpa_device *vdev);
 	u8 (*get_status)(struct vdpa_device *vdev);
 	void (*set_status)(struct vdpa_device *vdev, u8 status);
-	int (*reset)(struct vdpa_device *vdev);
+	int (*reset)(struct vdpa_device *vdev, bool clear);
 	int (*suspend)(struct vdpa_device *vdev);
 	size_t (*get_config_size)(struct vdpa_device *vdev);
 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
@@ -427,14 +428,14 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
 	return vdev->dma_dev;
 }
 
-static inline int vdpa_reset(struct vdpa_device *vdev)
+static inline int vdpa_reset(struct vdpa_device *vdev, bool clear)
 {
 	const struct vdpa_config_ops *ops = vdev->config;
 	int ret;
 
 	down_write(&vdev->cf_lock);
 	vdev->features_valid = false;
-	ret = ops->reset(vdev);
+	ret = ops->reset(vdev, clear);
 	up_write(&vdev->cf_lock);
 	return ret;
 }
-- 
2.23.0

