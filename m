Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A067996AE
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 09:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbjIIHKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 03:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245393AbjIIHKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 03:10:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B430E1FC0
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 00:09:57 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RjPDf0zWdzVjjv;
        Sat,  9 Sep 2023 15:07:14 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 9 Sep
 2023 15:09:55 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <kvm@vger.kernel.org>, <kwankhede@nvidia.com>, <kraxel@redhat.com>,
        <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH 1/3] vfio/mdpy: Fix the null-ptr-deref bug in mdpy_dev_init()
Date:   Sat, 9 Sep 2023 15:09:50 +0800
Message-ID: <20230909070952.80081-2-ruanjinjie@huawei.com>
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

Inject fault while probing mdpy.ko, if kstrdup() fails in
kobject_set_name_varg() in dev_set_name(), the strchr()
in kobject_add() of device_add() will cause null-ptr-deref below.
So check the err of dev_set_name().

[  108.095977] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
[  108.097756] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[  108.098983] CPU: 1 PID: 8948 Comm: modprobe Not tainted 6.5.0-g32bf43e4efdb #50
[  108.100455] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  108.102384] RIP: 0010:strchr+0x17/0xa0
[  108.103156] Code: 48 89 34 24 e8 fa 59 ad fd 48 8b 34 24 eb 9a 0f 1f 40 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 fa 53 48 c1 ea 03 48 83 ec 10 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0 75 51 0f b6 07 89
[  108.106140] RSP: 0018:ffff88811035f6a0 EFLAGS: 00010286
[  108.107012] RAX: dffffc0000000000 RBX: ffffffffa02696e0 RCX: 1ffffffff404d2dc
[  108.108177] RDX: 0000000000000000 RSI: 0000000000000025 RDI: 0000000000000000
[  108.109336] RBP: 0000000000000000 R08: ffff88810021eb28 R09: ffff8881055b6a28
[  108.110498] R10: ffffed1020d5f1ca R11: ffff888106af8e53 R12: ffff88811035f748
[  108.111663] R13: 0000000000000cc0 R14: ffff8881055b6a28 R15: ffffffffa02696e0
[  108.112865] FS:  00007f0264601540(0000) GS:ffff88811a080000(0000) knlGS:0000000000000000
[  108.114493] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  108.115685] CR2: 00007fff2f084578 CR3: 000000010b50a003 CR4: 0000000000170ee0
[  108.117127] Call Trace:
[  108.117681]  <TASK>
[  108.118087]  ? __die_body+0x1b/0x60
[  108.118810]  ? die_addr+0x43/0x70
[  108.119558]  ? exc_general_protection+0x121/0x210
[  108.120634]  ? asm_exc_general_protection+0x22/0x30
[  108.121748]  ? strchr+0x17/0xa0
[  108.122411]  kvasprintf_const+0x1c/0x120
[  108.123237]  kobject_set_name_vargs+0x41/0x110
[  108.124169]  ? kobject_add_internal+0x860/0x860
[  108.125169]  ? kasan_unpoison+0x23/0x50
[  108.125994]  kobject_add+0xec/0x1f0
[  108.126741]  ? _raw_spin_unlock_irqrestore+0x42/0x80
[  108.127847]  ? kobject_add_internal+0x860/0x860
[  108.128786]  ? mutex_unlock+0x80/0xd0
[  108.129629]  ? kobject_put+0x5c/0x310
[  108.130410]  ? get_device_parent.isra.0+0x1a2/0x430
[  108.131517]  ? kobject_put+0x5c/0x310
[  108.132281]  device_add+0x2ca/0x1440
[  108.133039]  ? __fw_devlink_link_to_suppliers+0x180/0x180
[  108.134198]  ? __hrtimer_init+0x38/0x200
[  108.135080]  ? pm_runtime_init+0x2df/0x3d0
[  108.136050]  mdpy_dev_init+0xfb/0x1000 [mdpy]
[  108.136974]  ? 0xffffffffa0298000
[  108.137680]  do_one_initcall+0x87/0x2e0
[  108.138600]  ? efi_enabled.constprop.0+0x50/0x50
[  108.139591]  ? _raw_spin_unlock_irqrestore+0x42/0x80
[  108.140646]  ? __kmem_cache_alloc_node+0x342/0x550
[  108.141626]  ? do_init_module+0x4b/0x750
[  108.142552]  ? kasan_unpoison+0x23/0x50
[  108.143350]  do_init_module+0x24d/0x750
[  108.144163]  load_module+0x4e60/0x68d0
[  108.145060]  ? module_frob_arch_sections+0x20/0x20
[  108.146028]  ? update_cfs_group+0x10c/0x2a0
[  108.146926]  ? __wake_up_common+0x10b/0x5d0
[  108.147807]  ? kernel_read_file+0x3ca/0x510
[  108.148680]  ? __x64_sys_fsconfig+0x650/0x650
[  108.149621]  ? __schedule+0xa0b/0x2a60
[  108.150424]  ? init_module_from_file+0xd2/0x130
[  108.151452]  init_module_from_file+0xd2/0x130
[  108.152360]  ? __ia32_sys_init_module+0xa0/0xa0
[  108.153360]  ? _raw_spin_lock_irqsave+0xe0/0xe0
[  108.154289]  ? ptrace_stop+0x487/0x790
[  108.155123]  idempotent_init_module+0x32d/0x6a0
[  108.156045]  ? init_module_from_file+0x130/0x130
[  108.156999]  ? __fget_light+0x57/0x500
[  108.157809]  __x64_sys_finit_module+0xbb/0x130
[  108.158744]  do_syscall_64+0x35/0x80
[  108.159547]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  108.160601] RIP: 0033:0x7f0263f1b839
[  108.161337] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
[  108.165113] RSP: 002b:00007fff2f087658 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  108.166645] RAX: ffffffffffffffda RBX: 000055d2140cddc0 RCX: 00007f0263f1b839
[  108.168184] RDX: 0000000000000000 RSI: 000055d21321bc2e RDI: 0000000000000003
[  108.169609] RBP: 000055d21321bc2e R08: 0000000000000000 R09: 000055d2140cddc0
[  108.171054] R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
[  108.172505] R13: 000055d2140cdf70 R14: 0000000000040000 R15: 000055d2140cddc0
[  108.173986]  </TASK>
[  108.174480] Modules linked in: mdpy(+) mdev vfio_iommu_type1 vfio [last unloaded: mdpy]
[  108.176116] Dumping ftrace buffer:
[  108.176863]    (ftrace buffer empty)
[  108.177711] ---[ end trace 0000000000000000 ]---
[  108.178837] RIP: 0010:strchr+0x17/0xa0
[  108.179821] Code: 48 89 34 24 e8 fa 59 ad fd 48 8b 34 24 eb 9a 0f 1f 40 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 fa 53 48 c1 ea 03 48 83 ec 10 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0 75 51 0f b6 07 89
[  108.183586] RSP: 0018:ffff88811035f6a0 EFLAGS: 00010286
[  108.184680] RAX: dffffc0000000000 RBX: ffffffffa02696e0 RCX: 1ffffffff404d2dc
[  108.186200] RDX: 0000000000000000 RSI: 0000000000000025 RDI: 0000000000000000
[  108.187735] RBP: 0000000000000000 R08: ffff88810021eb28 R09: ffff8881055b6a28
[  108.189175] R10: ffffed1020d5f1ca R11: ffff888106af8e53 R12: ffff88811035f748
[  108.190694] R13: 0000000000000cc0 R14: ffff8881055b6a28 R15: ffffffffa02696e0
[  108.192270] FS:  00007f0264601540(0000) GS:ffff88811a080000(0000) knlGS:0000000000000000
[  108.193968] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  108.195151] CR2: 00007fff2f084578 CR3: 000000010b50a003 CR4: 0000000000170ee0
[  108.196658] Kernel panic - not syncing: Fatal exception
[  108.197907] Dumping ftrace buffer:
[  108.198488]    (ftrace buffer empty)
[  108.199105] Kernel Offset: disabled
[  108.199691] Rebooting in 1 seconds..

Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 samples/vfio-mdev/mdpy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 064e1c0a7aa8..f6b79f1f0a67 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -717,7 +717,9 @@ static int __init mdpy_dev_init(void)
 	}
 	mdpy_dev.class = mdpy_class;
 	mdpy_dev.release = mdpy_device_release;
-	dev_set_name(&mdpy_dev, "%s", MDPY_NAME);
+	ret = dev_set_name(&mdpy_dev, "%s", MDPY_NAME);
+	if (ret)
+		goto err_put;
 
 	ret = device_register(&mdpy_dev);
 	if (ret)
-- 
2.34.1

