Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C0F1CEDE0
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 09:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgELHPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 03:15:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4777 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbgELHPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 03:15:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3561BED1A72B48253AD3;
        Tue, 12 May 2020 15:15:43 +0800 (CST)
Received: from opensource.huawei.com (10.175.100.98) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 12 May 2020 15:15:35 +0800
From:   Pan Nengyuan <pannengyuan@huawei.com>
To:     <pbonzini@redhat.com>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <zhang.zhanghailiang@huawei.com>, <euler.robot@huawei.com>,
        Pan Nengyuan <pannengyuan@huawei.com>
Subject: [PATCH] i386/kvm: fix a use-after-free when vcpu plug/unplug
Date:   Tue, 12 May 2020 09:39:33 -0400
Message-ID: <20200512133933.8696-1-pannengyuan@huawei.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.98]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we hotplug vcpus, cpu_update_state is added to vm_change_state_head
in kvm_arch_init_vcpu(). But it forgot to delete in kvm_arch_destroy_vcpu() after
unplug. Then it will cause a use-after-free access. This patch delete it in
kvm_arch_destroy_vcpu() to fix that.

Reproducer:
    virsh setvcpus vm1 4 --live
    virsh setvcpus vm1 2 --live
    virsh suspend vm1
    virsh resume vm1

The UAF stack:
==qemu-system-x86_64==28233==ERROR: AddressSanitizer: heap-use-after-free on address 0x62e00002e798 at pc 0x5573c6917d9e bp 0x7fff07139e50 sp 0x7fff07139e40
WRITE of size 1 at 0x62e00002e798 thread T0
    #0 0x5573c6917d9d in cpu_update_state /mnt/sdb/qemu/target/i386/kvm.c:742
    #1 0x5573c699121a in vm_state_notify /mnt/sdb/qemu/vl.c:1290
    #2 0x5573c636287e in vm_prepare_start /mnt/sdb/qemu/cpus.c:2144
    #3 0x5573c6362927 in vm_start /mnt/sdb/qemu/cpus.c:2150
    #4 0x5573c71e8304 in qmp_cont /mnt/sdb/qemu/monitor/qmp-cmds.c:173
    #5 0x5573c727cb1e in qmp_marshal_cont qapi/qapi-commands-misc.c:835
    #6 0x5573c7694c7a in do_qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.c:132
    #7 0x5573c7694c7a in qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.c:175
    #8 0x5573c71d9110 in monitor_qmp_dispatch /mnt/sdb/qemu/monitor/qmp.c:145
    #9 0x5573c71dad4f in monitor_qmp_bh_dispatcher /mnt/sdb/qemu/monitor/qmp.c:234

Reported-by: Euler Robot <euler.robot@huawei.com>
Signed-off-by: Pan Nengyuan <pannengyuan@huawei.com>
---
 target/i386/cpu.h | 1 +
 target/i386/kvm.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e818fc712a..afbd11b7a3 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1631,6 +1631,7 @@ struct X86CPU {
 
     CPUNegativeOffsetState neg;
     CPUX86State env;
+    VMChangeStateEntry *vmsentry;
 
     uint64_t ucode_rev;
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 4901c6dd74..ff2848357e 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1770,7 +1770,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
-    qemu_add_vm_change_state_handler(cpu_update_state, env);
+    cpu->vmsentry = qemu_add_vm_change_state_handler(cpu_update_state, env);
 
     c = cpuid_find_entry(&cpuid_data.cpuid, 1, 0);
     if (c) {
@@ -1883,6 +1883,9 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
         env->nested_state = NULL;
     }
 
+    qemu_del_vm_change_state_handler(cpu->vmsentry);
+    cpu->vmsentry = NULL;
+
     return 0;
 }
 
-- 
2.18.2

