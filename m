Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A7A7996AF
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 09:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245493AbjIIHKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 03:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245393AbjIIHKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 03:10:03 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BEF1BF9
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 00:09:59 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RjPCs3s5NzMlBG;
        Sat,  9 Sep 2023 15:06:33 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 9 Sep
 2023 15:09:56 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <kvm@vger.kernel.org>, <kwankhede@nvidia.com>, <kraxel@redhat.com>,
        <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH 2/3] vfio/mtty: Fix the null-ptr-deref bug in mtty_dev_init()
Date:   Sat, 9 Sep 2023 15:09:51 +0800
Message-ID: <20230909070952.80081-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230909070952.80081-1-ruanjinjie@huawei.com>
References: <20230909070952.80081-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject fault while probing mtty.ko, if kstrdup() fails in
kobject_set_name_varg() in dev_set_name(), the strchr()
in kobject_add() of device_add() will cause null-ptr-deref below.
So check the err of dev_set_name().

 general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 CPU: 1 PID: 9430 Comm: modprobe Tainted: G        W          6.5.0-g32bf43e4efdb #50
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 RIP: 0010:strchr+0x17/0xa0
 Code: 48 89 34 24 e8 fa 59 ad fd 48 8b 34 24 eb 9a 0f 1f 40 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 fa 53 48 c1 ea 03 48 83 ec 10 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0 75 51 0f b6 07 89
 RSP: 0018:ffff8881095e76a0 EFLAGS: 00010286
 RAX: dffffc0000000000 RBX: ffffffffa0274710 RCX: 1ffffffff404e8e2
 RDX: 0000000000000000 RSI: 0000000000000025 RDI: 0000000000000000
 RBP: 0000000000000000 R08: ffff88810021eb28 R09: ffff888103f13bd8
 R10: ffffed1021cdf94a R11: ffff88810e6fca53 R12: ffff8881095e7748
 R13: 0000000000000cc0 R14: ffff888103f13bd8 R15: ffffffffa0274710
 FS:  00007f5dfa57c540(0000) GS:ffff88811a080000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ffd59a4ecf8 CR3: 00000001065bb004 CR4: 0000000000170ee0
 Call Trace:
  <TASK>
  ? __die_body+0x1b/0x60
  ? die_addr+0x43/0x70
  ? exc_general_protection+0x121/0x210
  ? asm_exc_general_protection+0x22/0x30
  ? strchr+0x17/0xa0
  kvasprintf_const+0x1c/0x120
  kobject_set_name_vargs+0x41/0x110
  ? kobject_add_internal+0x860/0x860
  ? kasan_unpoison+0x23/0x50
  kobject_add+0xec/0x1f0
  ? _raw_spin_unlock_irqrestore+0x42/0x80
  ? kobject_add_internal+0x860/0x860
  ? mutex_unlock+0x80/0xd0
  ? kobject_put+0x5c/0x310
  ? get_device_parent.isra.0+0x1a2/0x430
  ? kobject_put+0x5c/0x310
  device_add+0x2ca/0x1440
  ? __fw_devlink_link_to_suppliers+0x180/0x180
  ? __hrtimer_init+0x38/0x200
  ? pm_runtime_init+0x2df/0x3d0
  mtty_dev_init+0x12b/0x1000 [mtty]
  ? 0xffffffffa02a8000
  do_one_initcall+0x87/0x2e0
  ? efi_enabled.constprop.0+0x50/0x50
  ? _raw_spin_unlock_irqrestore+0x42/0x80
  ? __kmem_cache_alloc_node+0x342/0x550
  ? do_init_module+0x4b/0x750
  ? kasan_unpoison+0x23/0x50
  do_init_module+0x24d/0x750
  load_module+0x4e60/0x68d0
  ? module_frob_arch_sections+0x20/0x20
  ? update_cfs_group+0x10c/0x2a0
  ? __wake_up_common+0x10b/0x5d0
  ? kernel_read_file+0x3ca/0x510
  ? __x64_sys_fsconfig+0x650/0x650
  ? __schedule+0xa0b/0x2a60
  ? init_module_from_file+0xd2/0x130
  init_module_from_file+0xd2/0x130
  ? __ia32_sys_init_module+0xa0/0xa0
  ? _raw_spin_lock_irqsave+0xe0/0xe0
  ? ptrace_stop+0x487/0x790
  idempotent_init_module+0x32d/0x6a0
  ? init_module_from_file+0x130/0x130
  ? __fget_light+0x57/0x500
  __x64_sys_finit_module+0xbb/0x130
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x7f5df9f1b839
 Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffd59a51dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
 RAX: ffffffffffffffda RBX: 0000557c13e2de40 RCX: 00007f5df9f1b839
 RDX: 0000000000000000 RSI: 0000557c12e1bc2e RDI: 0000000000000003
 RBP: 0000557c12e1bc2e R08: 0000000000000000 R09: 0000557c13e2de40
 R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000557c13e2df90 R14: 0000000000040000 R15: 0000557c13e2de40
  </TASK>
 Modules linked in: mtty(+) mdev vfio_iommu_type1 vfio [last unloaded: mtty]
 Dumping ftrace buffer:
    (ftrace buffer empty)
 ---[ end trace 0000000000000000 ]---
 RIP: 0010:strchr+0x17/0xa0
 Code: 48 89 34 24 e8 fa 59 ad fd 48 8b 34 24 eb 9a 0f 1f 40 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 fa 53 48 c1 ea 03 48 83 ec 10 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0 75 51 0f b6 07 89
 RSP: 0018:ffff8881095e76a0 EFLAGS: 00010286
 RAX: dffffc0000000000 RBX: ffffffffa0274710 RCX: 1ffffffff404e8e2
 RDX: 0000000000000000 RSI: 0000000000000025 RDI: 0000000000000000
 RBP: 0000000000000000 R08: ffff88810021eb28 R09: ffff888103f13bd8
 R10: ffffed1021cdf94a R11: ffff88810e6fca53 R12: ffff8881095e7748
 R13: 0000000000000cc0 R14: ffff888103f13bd8 R15: ffffffffa0274710
 FS:  00007f5dfa57c540(0000) GS:ffff88811a080000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ffd59a4ecf8 CR3: 00000001065bb004 CR4: 0000000000170ee0
 Kernel panic - not syncing: Fatal exception
 Dumping ftrace buffer:
    (ftrace buffer empty)
 Kernel Offset: disabled
 Rebooting in 1 seconds..

Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 samples/vfio-mdev/mtty.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 5af00387c519..2e403099e3e5 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1330,7 +1330,9 @@ static int __init mtty_dev_init(void)
 
 	mtty_dev.dev.class = mtty_dev.vd_class;
 	mtty_dev.dev.release = mtty_device_release;
-	dev_set_name(&mtty_dev.dev, "%s", MTTY_NAME);
+	ret = dev_set_name(&mtty_dev.dev, "%s", MTTY_NAME);
+	if (ret)
+		goto err_put;
 
 	ret = device_register(&mtty_dev.dev);
 	if (ret)
-- 
2.34.1

