Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F39C5F8494
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 11:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiJHJUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Oct 2022 05:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJHJUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Oct 2022 05:20:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD5C193CD
        for <kvm@vger.kernel.org>; Sat,  8 Oct 2022 02:20:01 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ml0241vwFzkXvx;
        Sat,  8 Oct 2022 17:17:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 17:19:59 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <baolu.lu@linux.intel.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] [PATCH] Revert 'vfio: Delete container_q'
Date:   Sat, 8 Oct 2022 17:50:31 +0800
Message-ID: <1665222631-202970-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

We find a issue on ARM64 platform with HNS3 VF SRIOV enabled (VFIO
passthrough in qemu):
kill the qemu thread, then echo 0 > sriov_numvfs to disable sriov
immediately, sometimes we will see following warnings:

[  284.102752] ------------[ cut here ]------------
[  284.113278] iommu driver failed to attach the default/blocking domain
[  284.113294] WARNING: CPU: 14 PID: 12393 at drivers/iommu/iommu.c:1959
__iommu_group_set_core_domain+0x44/0x54
[  284.130298] Modules linked in: hisi_zip kp_ktools(O) hisi_qm uacce vfio_iommu_type1
vfio_pci vfio_pci_core vfio_virqfd vfio hns3_cae(O) ip6table_filter ip6_tables
iptable_filter arm_spe_pmu hns_roce_hw_v2 hisi_uncore_hha_pmu hisi_uncore_ddrc_pmu
hisi_uncore_l3c_pmu spi_dw_mmio hisi_uncore_pmu fuse hclge crct10dif_ce sbsa_gwdt
hisi_sas_v3_hw hns3 hnae3 hisi_sas_main xhci_pci hisi_dma xhci_pci_renesas libsas
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: uacce]
[  284.172994] CPU: 14 PID: 12393 Comm: qemu-system-aar Kdump: loaded Tainted: G
O      5.19.0-rc4+ #1
[  284.183380] Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD, BIOS 2280-V2 CS
V5.B221.01 12/09/2021
[  284.193515] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  284.200721] pc : __iommu_group_set_core_domain+0x44/0x54
[  284.206286] lr : __iommu_group_set_core_domain+0x44/0x54
[  284.211843] sp : ffff80001d99bbc0
[  284.215406] x29: ffff80001d99bbc0 x28: ffff002097cb6000 x27: ffff0020aa704c98
[  284.222780] x26: ffff0020aa704c80 x25: ffff0020868c70b0 x24: ffff0020aa705600
[  284.230152] x23: ffff00208405c3e0 x22: ffff0020868c7020 x21: ffff80001d99bc58
[  284.237523] x20: ffff002086c4b858 x19: ffff002086c4b800 x18: 0000000000000030
[  284.244889] x17: 0000000000000004 x16: 0000000000000000 x15: ffffffffffffffff
[  284.252253] x14: 0000000000000000 x13: 6e69616d6f642067 x12: 6e696b636f6c622f
[  284.259617] x11: fffffffffff26c30 x10: fffffffffff26be8 x9 : ffffba21e09dc1f0
[  284.266979] x8 : ffff202f8f7c0000 x7 : ffff202f8fa80000 x6 : 0000000000006d20
[  284.274340] x5 : ffff0027dfbe69b0 x4 : 0000000000000000 x3 : 0000000000000027
[  284.281697] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff002097cb6000
[  284.289051] Call trace:
[  284.291732]  __iommu_group_set_core_domain+0x44/0x54
[  284.296924]  iommu_detach_group+0x34/0x50
[  284.301161]  vfio_iommu_type1_detach_group+0xe4/0x610 [vfio_iommu_type1]
[  284.308085]  __vfio_group_unset_container+0x4c/0x1b0 [vfio]
[  284.313882]  vfio_group_fops_release+0x54/0xac [vfio]
[  284.319155]  __fput+0x78/0x220
[  284.322434]  ____fput+0x1c/0x30
[  284.325790]  task_work_run+0x88/0xc0
[  284.329573]  do_exit+0x310/0x970
[  284.333004]  do_group_exit+0x40/0xac
[  284.336771]  __wake_up_parent+0x0/0x3c
[  284.340706]  invoke_syscall+0x50/0x120
[  284.344634]  el0_svc_common.constprop.0+0x188/0x190
[  284.349683]  do_el0_svc+0x38/0xc4
[  284.353169]  el0_svc+0x2c/0xb4
[  284.356390]  el0t_64_sync_handler+0x1ac/0x1b0
[  284.360905]  el0t_64_sync+0x19c/0x1a0
[  284.364729] ---[ end trace 0000000000000000 ]---

We find it is caused by commit (dc15f82f5329 ("vfio: Delete container_q")).

If killing the qemu thread, the function call relationship is as follows:

kill qemu ->  vfio_instance_finalize -> syscall VFIO_GROUP_UNSET_CONTAINER ->
vfio_group_unset_container -> vfio_iommu_type1_detach_group ->
__iommu_group_set_core_domain -> arm_smmu_attach_dev (it refers to iommu_fwspec and arm_smmu_master)

If echo 0 > sriov_numvfs, the function call relationship is as follows:

echo 0 > sriov_numvfs  -> pci_disable_sriov -> device_del -> iommu_bus_notifier (BUS_NOTIFY_REMOVED_DEVICE) -> iommu_release_device ->
arm_smmu_release_device (it will kfree arm_smmu_master including iommu_fwspec)

After removing container_q, arm_smmu_release_dev() caused by disabling
sriov may occur before arm_smmuv3_attach_dev() called by echo 0 > sriov_numvfs,
and arm_smmu_attach_dev() may refer to freed iommu_fwspec, so it causes
above warnings.

Revert the patch to avoid the issue.

Fixes: dc15f82f5329 ("vfio: Delete container_q")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/vfio/vfio_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c3..890fdf9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -73,6 +73,7 @@ struct vfio_group {
 	struct mutex			device_lock;
 	struct list_head		vfio_next;
 	struct list_head		container_next;
+	wait_queue_head_t               container_q;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
 	struct rw_semaphore		group_rwsem;
@@ -367,6 +368,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	init_rwsem(&group->group_rwsem);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
+	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
 	/* put in vfio_group_release() */
 	iommu_group_ref_get(iommu_group);
@@ -699,6 +701,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	group->dev_counter--;
 	mutex_unlock(&group->device_lock);
 
+	if (list_empty(&group->device_list))
+		wait_event(group->container_q, !group->container);
+
 	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
 		iommu_group_remove_device(device->dev);
 
@@ -946,6 +951,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 		iommu_group_release_dma_owner(group->iommu_group);
 
 	group->container = NULL;
+	wake_up(&group->container_q);
 	group->container_users = 0;
 	list_del(&group->container_next);
 
-- 
2.8.1

