Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E425F672AFA
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 23:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjARWAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 17:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjARWAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 17:00:41 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DAD5EFAC
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 14:00:39 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pIGU0-00Gq54-8E; Wed, 18 Jan 2023 23:00:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=Y3dFWQwq6UgEMLNkrbJe3RaM2Z8p6GyQyWZz1d7mok8=; b=dpB7It7E92TZI
        3FkAc1soaMnvoJ5tNUWvX7qI+mirXQMPF053m2qVE7cx2IEGnSFMU95c68nvZrzmhXxoEmD7SAbun
        ejBj4BCOE8IipOcw+ptLiwsOf0l+N8gzEp94XOmj8B2YQhrdQsdaUZoRDdSSD+/sPic+cIFUggSyg
        w99+r+E0JpYJi/UhWMhUdTa7Q4znafr9kY7MOUNfCD4FVbO4NSxjjQfwc6c0sFzvamLuJRqKYvmmh
        K+mnz3up/qnGGmf3KpZ9QFyUDs047TuwM8hu5tDqY3RpKzuBEXhTVFL9w9Kdx9yX4EP3F3GucZYWz
        tbUSTXcUn3y4JGeDaPitg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pIGTz-0007NM-JL; Wed, 18 Jan 2023 23:00:35 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pIGTs-0005fO-F8; Wed, 18 Jan 2023 23:00:28 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] Revert "KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregister_coalesced_mmio"
Date:   Wed, 18 Jan 2023 23:00:03 +0100
Message-Id: <20230118220003.1239032-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The commit states:

    If kvm_io_bus_unregister_dev() return -ENOMEM, we already call
    kvm_iodevice_destructor() inside this function to delete
    'struct kvm_coalesced_mmio_dev *dev' from list and free the dev,
    but kvm_iodevice_destructor() is called again, it will lead the
    above issue.

    Let's check the the return value of kvm_io_bus_unregister_dev(),
    only call kvm_iodevice_destructor() if the return value is 0.

This is not entirely correct. kvm_io_bus_unregister_dev() never invokes
kvm_iodevice_destructor() on the device that was passed for
unregistering. Thus, calling kvm_iodevice_destructor() iff
kvm_io_bus_unregister_dev() returns 0 does not fix a use-after-free,
but introduces a memory leak.

It seems that the actual fix for the use-after-free(s) was
commit 5d3c4c79384a ("KVM: Stop looking for coalesced MMIO zones if the
bus is destroyed"), which made into 5.10.37 (mainline 5.13-rc1). Now,
syzkaller's report from the reverted commit indicates an earlier kernel
version 5.10.0, while the memory leak was introduced in 5.10.52
(5.14-rc2).

Currently, running

    ioctl(vm, KVM_REGISTER_COALESCED_MMIO, &zone);
    // fail the upcoming kmalloc() in kvm_io_bus_unregister_dev()
    ioctl(vm, KVM_UNREGISTER_COALESCED_MMIO, &zone);

results in

[  200.212348] kvm: failed to shrink bus, removing it completely
unreferenced object 0xffff88810e7fa300 (size 64):
  comm "a.out", pid 972, jiffies 4294867275 (age 20.499s)
  hex dump (first 32 bytes):
    58 e3 fd 00 00 c9 ff ff 58 e3 fd 00 00 c9 ff ff  X.......X.......
    c0 66 65 c0 ff ff ff ff 00 40 fd 00 00 c9 ff ff  .fe......@......
  backtrace:
    [<00000000a9f977ff>] kmalloc_trace+0x26/0x60
    [<0000000072e1256d>] kvm_vm_ioctl_register_coalesced_mmio+0x8b/0x420 [kvm]
    [<00000000cc4b12dc>] kvm_vm_ioctl+0x1415/0x2050 [kvm]
    [<000000004e08022f>] __x64_sys_ioctl+0x126/0x190
    [<0000000044a4fad3>] do_syscall_64+0x55/0x80
    [<00000000d7073b12>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

This reverts commit 23fa2e46a5556f787ce2ea1a315d3ab93cced204.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 virt/kvm/coalesced_mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f..f08f5e82460b 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -186,6 +186,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
 			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
+			kvm_iodevice_destructor(&dev->dev);
 
 			/*
 			 * On failure, unregister destroys all devices on the
@@ -195,7 +196,6 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 			 */
 			if (r)
 				break;
-			kvm_iodevice_destructor(&dev->dev);
 		}
 	}
 
-- 
2.39.0

