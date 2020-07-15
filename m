Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9238E220651
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 09:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgGOHfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 03:35:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33218 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729038AbgGOHfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 03:35:54 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D798D686B4C2E6A3B5EA;
        Wed, 15 Jul 2020 15:35:50 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 15 Jul 2020 15:35:45 +0800
From:   Zeng Tao <prime.zeng@hisilicon.com>
To:     <alex.williamson@redhat.com>, <cai@lca.pw>
CC:     Zeng Tao <prime.zeng@hisilicon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Peter Xu <peterx@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Denis Efremov <efremov@linux.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] vfio/pci: fix racy on error and request eventfd ctx
Date:   Wed, 15 Jul 2020 15:34:41 +0800
Message-ID: <1594798484-20501-1-git-send-email-prime.zeng@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_pci_release call will free and clear the error and request
eventfd ctx while these ctx could be in use at the same time in the
function like vfio_pci_request, and it's expected to protect them under
the vdev->igate mutex, which is missing in vfio_pci_release.

This issue is introduced since commit 1518ac272e78 ("vfio/pci: fix memory
leaks of eventfd ctx"),and since commit 5c5866c593bb ("vfio/pci: Clear
error and request eventfd ctx after releasing"), it's very easily to
trigger the kernel panic like this:

[ 9513.904346] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
[ 9513.913091] Mem abort info:
[ 9513.915871]   ESR = 0x96000006
[ 9513.918912]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 9513.924198]   SET = 0, FnV = 0
[ 9513.927238]   EA = 0, S1PTW = 0
[ 9513.930364] Data abort info:
[ 9513.933231]   ISV = 0, ISS = 0x00000006
[ 9513.937048]   CM = 0, WnR = 0
[ 9513.940003] user pgtable: 4k pages, 48-bit VAs, pgdp=0000007ec7d12000
[ 9513.946414] [0000000000000008] pgd=0000007ec7d13003, p4d=0000007ec7d13003, pud=0000007ec728c003, pmd=0000000000000000
[ 9513.956975] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[ 9513.962521] Modules linked in: vfio_pci vfio_virqfd vfio_iommu_type1 vfio hclge hns3 hnae3 [last unloaded: vfio_pci]
[ 9513.972998] CPU: 4 PID: 1327 Comm: bash Tainted: G        W         5.8.0-rc4+ #3
[ 9513.980443] Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 CS V3.B270.01 05/08/2020
[ 9513.989274] pstate: 80400089 (Nzcv daIf +PAN -UAO BTYPE=--)
[ 9513.994827] pc : _raw_spin_lock_irqsave+0x48/0x88
[ 9513.999515] lr : eventfd_signal+0x6c/0x1b0
[ 9514.003591] sp : ffff800038a0b960
[ 9514.006889] x29: ffff800038a0b960 x28: ffff007ef7f4da10
[ 9514.012175] x27: ffff207eefbbfc80 x26: ffffbb7903457000
[ 9514.017462] x25: ffffbb7912191000 x24: ffff007ef7f4d400
[ 9514.022747] x23: ffff20be6e0e4c00 x22: 0000000000000008
[ 9514.028033] x21: 0000000000000000 x20: 0000000000000000
[ 9514.033321] x19: 0000000000000008 x18: 0000000000000000
[ 9514.038606] x17: 0000000000000000 x16: ffffbb7910029328
[ 9514.043893] x15: 0000000000000000 x14: 0000000000000001
[ 9514.049179] x13: 0000000000000000 x12: 0000000000000002
[ 9514.054466] x11: 0000000000000000 x10: 0000000000000a00
[ 9514.059752] x9 : ffff800038a0b840 x8 : ffff007ef7f4de60
[ 9514.065038] x7 : ffff007fffc96690 x6 : fffffe01faffb748
[ 9514.070324] x5 : 0000000000000000 x4 : 0000000000000000
[ 9514.075609] x3 : 0000000000000000 x2 : 0000000000000001
[ 9514.080895] x1 : ffff007ef7f4d400 x0 : 0000000000000000
[ 9514.086181] Call trace:
[ 9514.088618]  _raw_spin_lock_irqsave+0x48/0x88
[ 9514.092954]  eventfd_signal+0x6c/0x1b0
[ 9514.096691]  vfio_pci_request+0x84/0xd0 [vfio_pci]
[ 9514.101464]  vfio_del_group_dev+0x150/0x290 [vfio]
[ 9514.106234]  vfio_pci_remove+0x30/0x128 [vfio_pci]
[ 9514.111007]  pci_device_remove+0x48/0x108
[ 9514.115001]  device_release_driver_internal+0x100/0x1b8
[ 9514.120200]  device_release_driver+0x28/0x38
[ 9514.124452]  pci_stop_bus_device+0x68/0xa8
[ 9514.128528]  pci_stop_and_remove_bus_device+0x20/0x38
[ 9514.133557]  pci_iov_remove_virtfn+0xb4/0x128
[ 9514.137893]  sriov_disable+0x3c/0x108
[ 9514.141538]  pci_disable_sriov+0x28/0x38
[ 9514.145445]  hns3_pci_sriov_configure+0x48/0xb8 [hns3]
[ 9514.150558]  sriov_numvfs_store+0x110/0x198
[ 9514.154724]  dev_attr_store+0x44/0x60
[ 9514.158373]  sysfs_kf_write+0x5c/0x78
[ 9514.162018]  kernfs_fop_write+0x104/0x210
[ 9514.166010]  __vfs_write+0x48/0x90
[ 9514.169395]  vfs_write+0xbc/0x1c0
[ 9514.172694]  ksys_write+0x74/0x100
[ 9514.176079]  __arm64_sys_write+0x24/0x30
[ 9514.179987]  el0_svc_common.constprop.4+0x110/0x200
[ 9514.184842]  do_el0_svc+0x34/0x98
[ 9514.188144]  el0_svc+0x14/0x40
[ 9514.191185]  el0_sync_handler+0xb0/0x2d0
[ 9514.195088]  el0_sync+0x140/0x180
[ 9514.198389] Code: b9001020 d2800000 52800022 f9800271 (885ffe61)
[ 9514.204455] ---[ end trace 648de00c8406465f ]---
[ 9514.212308] note: bash[1327] exited with preempt_count 1

Cc: Qian Cai <cai@lca.pw>
Cc: Alex Williamson <alex.williamson@redhat.com>
Fixes: 1518ac272e78 ("vfio/pci: fix memory leaks of eventfd ctx")
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
---
 drivers/vfio/pci/vfio_pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f634c81..de881a6 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -521,14 +521,19 @@ static void vfio_pci_release(void *device_data)
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+		mutex_lock(&vdev->igate);
 		if (vdev->err_trigger) {
 			eventfd_ctx_put(vdev->err_trigger);
 			vdev->err_trigger = NULL;
 		}
+		mutex_unlock(&vdev->igate);
+
+		mutex_lock(&vdev->igate);
 		if (vdev->req_trigger) {
 			eventfd_ctx_put(vdev->req_trigger);
 			vdev->req_trigger = NULL;
 		}
+		mutex_unlock(&vdev->igate);
 	}
 
 	mutex_unlock(&vdev->reflck->lock);
-- 
2.8.1

