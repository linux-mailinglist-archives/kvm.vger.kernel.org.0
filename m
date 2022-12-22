Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A434C654743
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 21:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiLVUhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 15:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiLVUg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 15:36:56 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E54721830
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 12:36:54 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p8SJA-002XCo-AE; Thu, 22 Dec 2022 21:36:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=ybVYRogi4wN7XWLi5sEjEUWzY38RyusmIkPA1IIauaI=; b=xHYrDXvUGvZAl
        Vg28sDc7N5EZLfDhSQvwryUl8kNpD2kGJTNtx7CSKBlOBiAqVC/oewTD6HcIhe87cVeyh/knZ+JY/
        PThwt1hkSiMANMm5TT4xWD6Sz/neyjDxTlHoOljxhquNXTu2aMS1B/Z1YgaVILr+TuK3JVicu8Ecs
        QtL0aA3MwcqEsTnRxN8gv4aT3CG8kMw1m15rzneOZLglOmeCPkdu/SH3fB3KBEI5IqvIyqxJfpC70
        GOAi5hpu3+GJcm6GzcZQ3m9mjidfbTB6nsX5lUY5+JI1ZBYzy31F7wE1z16Q+MKJp5CWAmdwllcsI
        PbQdijzTMZsSpezilLsEA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p8SJA-00009F-1K; Thu, 22 Dec 2022 21:36:52 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p8SIx-0007g4-B0; Thu, 22 Dec 2022 21:36:39 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 0/2] Use-after-free in kvm_xen_eventfd_update()
Date:   Thu, 22 Dec 2022 21:30:19 +0100
Message-Id: <20221222203021.1944101-1-mhal@rbox.co>
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

There is a use-after-free condition due to a race between
kvm_xen_eventfd_deassign() and kvm_xen_eventfd_update():

				mutex_lock(&kvm->lock)
				evtchnfd = idr_find(...)
				mutex_unlock(&kvm->lock)
mutex_lock(&kvm->lock)
evtchnfd = idr_remove(...)
mutex_unlock(&kvm->lock)
synchronize_srcu(&kvm->srcu)
kfree(evtchnfd)
				[evtchnfd is stale now]
				if (evtchnfd->type != data->u.evtchn.type)
					return -EINVAL;
				...

My understanding is that kvm_xen_eventfd_update() forgets to enter SRCU
critical section, and thus synchronize_srcu() in kvm_xen_eventfd_deassign()
does not really synchronize much, which results in prematurly kfree()ing
evtchnfd.

The condition is rather hard to hit (and I sure hope it is not purely
theoretical), but when I throw a mdelay() between the lines, e.g.

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d7af40240248..2b3495517c99 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -14,6 +14,7 @@
 #include <linux/eventfd.h>
 #include <linux/kvm_host.h>
 #include <linux/sched/stat.h>
+#include <linux/delay.h>

 #include <trace/events/kvm.h>
 #include <xen/interface/xen.h>
@@ -1836,6 +1837,8 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
        if (!evtchnfd)
                return -ENOENT;

+       mdelay(1);
+
        /* For an UPDATE, nothing may change except the priority/vcpu */
        if (evtchnfd->type != data->u.evtchn.type)
                return -EINVAL;

and race update/deassign IOCTLs, then KFENCE reports start popping out:

[  299.233021] ==================================================================
[  299.233043] BUG: KFENCE: use-after-free read in kvm_xen_hvm_set_attr+0x7cb/0x930 [kvm]
[  299.233566] Use-after-free read at 0x000000004c7839ea (in kfence-#134):
[  299.233581]  kvm_xen_hvm_set_attr+0x7cb/0x930 [kvm]
[  299.234094]  kvm_arch_vm_ioctl+0xcda/0xee0 [kvm]
[  299.234613]  kvm_vm_ioctl+0x703/0x1320 [kvm]
[  299.235074]  __x64_sys_ioctl+0xb8/0xf0
[  299.235091]  do_syscall_64+0x55/0x80
[  299.235105]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  299.235128] kfence-#134: 0x000000008893823b-0x00000000c2c2058a, size=24, cache=kmalloc-32

[  299.235143] allocated by task 941 on cpu 0 at 288.238587s:
[  299.235890]  __kmem_cache_alloc_node+0x357/0x420
[  299.235908]  kmalloc_trace+0x26/0x60
[  299.235921]  kvm_xen_hvm_set_attr+0x119/0x930 [kvm]
[  299.236425]  kvm_arch_vm_ioctl+0xcda/0xee0 [kvm]
[  299.236905]  kvm_vm_ioctl+0x703/0x1320 [kvm]
[  299.237380]  __x64_sys_ioctl+0xb8/0xf0
[  299.237394]  do_syscall_64+0x55/0x80
[  299.237407]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  299.237427] freed by task 941 on cpu 0 at 288.576296s:
[  299.238181]  kvm_xen_hvm_set_attr+0x784/0x930 [kvm]
[  299.238666]  kvm_arch_vm_ioctl+0xcda/0xee0 [kvm]
[  299.239094]  kvm_vm_ioctl+0x703/0x1320 [kvm]
[  299.239210]  __x64_sys_ioctl+0xb8/0xf0
[  299.239213]  do_syscall_64+0x55/0x80
[  299.239216]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  299.239222] CPU: 3 PID: 944 Comm: a.out Tainted: G    B              6.1.0+ #63
[  299.239227] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.1-1-1 04/01/2014
[  299.239230] ==================================================================

PATCH 1/2 proposes a fix.
PATCH 2/2 takes the opportunity to further simplify the code a bit.

Michal Luczaj (2):
  KVM: x86/xen: Fix use-after-free in kvm_xen_eventfd_update()
  KVM: x86/xen: Simplify eventfd IOCTLs

 arch/x86/kvm/xen.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

-- 
2.39.0

