Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5AA16AB64
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbfGPPHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:07:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44072 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728619AbfGPPHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:07:48 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6FD8436EF5574397A8B3;
        Tue, 16 Jul 2019 23:07:42 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 16 Jul 2019
 23:07:32 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
Subject: BUG: KASAN: slab-out-of-bounds in kvm_pmu_get_canonical_pmc+0x48/0x78
To:     <kvmarm@lists.cs.columbia.edu>
CC:     Marc Zyngier <marc.zyngier@arm.com>, <andrew.murray@arm.com>,
        <kasan-dev@googlegroups.com>, <kvm@vger.kernel.org>
Message-ID: <644e3455-ea6d-697a-e452-b58961341381@huawei.com>
Date:   Tue, 16 Jul 2019 23:05:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

Running the latest kernel with KASAN enabled, we will hit the following
KASAN BUG during guest's boot process.

I'm in commit 9637d517347e80ee2fe1c5d8ce45ba1b88d8b5cd.

Any problems in the chained PMU code? Or just a false positive?

---8<---

[  654.706268] 
==================================================================
[  654.706280] BUG: KASAN: slab-out-of-bounds in 
kvm_pmu_get_canonical_pmc+0x48/0x78
[  654.706286] Read of size 8 at addr ffff801d6c8fea38 by task 
qemu-kvm/23268

[  654.706296] CPU: 2 PID: 23268 Comm: qemu-kvm Not tainted 5.2.0+ #178
[  654.706301] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 
10/24/2018
[  654.706305] Call trace:
[  654.706311]  dump_backtrace+0x0/0x238
[  654.706317]  show_stack+0x24/0x30
[  654.706325]  dump_stack+0xe0/0x134
[  654.706332]  print_address_description+0x80/0x408
[  654.706338]  __kasan_report+0x164/0x1a0
[  654.706343]  kasan_report+0xc/0x18
[  654.706348]  __asan_load8+0x88/0xb0
[  654.706353]  kvm_pmu_get_canonical_pmc+0x48/0x78
[  654.706358]  kvm_pmu_stop_counter+0x28/0x118
[  654.706363]  kvm_pmu_vcpu_reset+0x60/0xa8
[  654.706369]  kvm_reset_vcpu+0x30/0x4d8
[  654.706376]  kvm_arch_vcpu_ioctl+0xa04/0xc18
[  654.706381]  kvm_vcpu_ioctl+0x17c/0xde8
[  654.706387]  do_vfs_ioctl+0x150/0xaf8
[  654.706392]  ksys_ioctl+0x84/0xb8
[  654.706397]  __arm64_sys_ioctl+0x4c/0x60
[  654.706403]  el0_svc_common.constprop.0+0xb4/0x208
[  654.706409]  el0_svc_handler+0x3c/0xa8
[  654.706414]  el0_svc+0x8/0xc

[  654.706422] Allocated by task 23268:
[  654.706429]  __kasan_kmalloc.isra.0+0xd0/0x180
[  654.706435]  kasan_slab_alloc+0x14/0x20
[  654.706440]  kmem_cache_alloc+0x17c/0x4a8
[  654.706445]  kvm_arch_vcpu_create+0xa0/0x130
[  654.706451]  kvm_vm_ioctl+0x844/0x1218
[  654.706456]  do_vfs_ioctl+0x150/0xaf8
[  654.706461]  ksys_ioctl+0x84/0xb8
[  654.706466]  __arm64_sys_ioctl+0x4c/0x60
[  654.706472]  el0_svc_common.constprop.0+0xb4/0x208
[  654.706478]  el0_svc_handler+0x3c/0xa8
[  654.706482]  el0_svc+0x8/0xc

[  654.706490] Freed by task 0:
[  654.706493] (stack is not available)

[  654.706501] The buggy address belongs to the object at ffff801d6c8fc010
  which belongs to the cache kvm_vcpu of size 10784
[  654.706507] The buggy address is located 8 bytes to the right of
  10784-byte region [ffff801d6c8fc010, ffff801d6c8fea30)
[  654.706510] The buggy address belongs to the page:
[  654.706516] page:ffff7e0075b23f00 refcount:1 mapcount:0 
mapping:ffff801db257e480 index:0x0 compound_mapcount: 0
[  654.706524] flags: 0xffffe0000010200(slab|head)
[  654.706532] raw: 0ffffe0000010200 ffff801db2586ee0 ffff801db2586ee0 
ffff801db257e480
[  654.706538] raw: 0000000000000000 0000000000010001 00000001ffffffff 
0000000000000000
[  654.706542] page dumped because: kasan: bad access detected

[  654.706549] Memory state around the buggy address:
[  654.706554]  ffff801d6c8fe900: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[  654.706560]  ffff801d6c8fe980: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[  654.706565] >ffff801d6c8fea00: 00 00 00 00 00 00 fc fc fc fc fc fc fc 
fc fc fc
[  654.706568]                                         ^
[  654.706573]  ffff801d6c8fea80: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[  654.706578]  ffff801d6c8feb00: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[  654.706582] 
==================================================================


Thanks,
zenghui

