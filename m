Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D28483AA7
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 03:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiADCpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 21:45:19 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:45714 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbiADCpS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jan 2022 21:45:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V0np1PC_1641264315;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0V0np1PC_1641264315)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Jan 2022 10:45:16 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: eventfd: Fix false positive RCU usage warning
Date:   Tue,  4 Jan 2022 10:45:15 +0800
Message-Id: <ab1358b84c60e6c942c270e3fe1a32bfa3177f3c.1641264282.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following false positive warning:
[   20.995979] =============================
[   20.996878] WARNING: suspicious RCU usage
[   20.997792] 5.16.0-rc4+ #57 Not tainted
[   20.998651] -----------------------------
[   20.999544] arch/x86/kvm/../../../virt/kvm/eventfd.c:484 RCU-list traversed in non-reader section!!
[   21.001490]
[   21.001490] other info that might help us debug this:
[   21.001490]
[   21.003240]
[   21.003240] rcu_scheduler_active = 2, debug_locks = 1
[   21.004662] 3 locks held by fc_vcpu 0/330:
[   21.005573]  #0: ffff8884835fc0b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x88/0x6f0 [kvm]
[   21.007617]  #1: ffffc90004c0bb68 (&kvm->srcu){....}-{0:0}, at: vcpu_enter_guest+0x600/0x1860 [kvm]
[   21.009627]  #2: ffffc90004c0c1d0 (&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x36/0x180 [kvm]
[   21.011732]
[   21.011732] stack backtrace:
[   21.012733] CPU: 26 PID: 330 Comm: fc_vcpu 0 Not tainted 5.16.0-rc4+
[   21.014189] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   21.016565] Call Trace:
[   21.017105]  <TASK>
[   21.017591]  dump_stack_lvl+0x44/0x57
[   21.018467]  kvm_notify_acked_gsi+0x6b/0x70 [kvm]
[   21.019533]  kvm_notify_acked_irq+0x8d/0x180 [kvm]
[   21.020616]  kvm_ioapic_update_eoi+0x92/0x240 [kvm]
[   21.021736]  kvm_apic_set_eoi_accelerated+0x2a/0xe0 [kvm]
[   21.022968]  handle_apic_eoi_induced+0x3d/0x60 [kvm_intel]
[   21.024168]  vmx_handle_exit+0x19c/0x6a0 [kvm_intel]
[   21.025255]  vcpu_enter_guest+0x66e/0x1860 [kvm]
[   21.026303]  ? lock_acquire+0x27f/0x300
[   21.027166]  ? lock_is_held_type+0xdf/0x130
[   21.028090]  ? kvm_arch_vcpu_ioctl_run+0x438/0x7f0 [kvm]
[   21.029286]  ? kvm_arch_vcpu_ioctl_run+0x11a/0x7f0 [kvm]
[   21.030485]  kvm_arch_vcpu_ioctl_run+0x438/0x7f0 [kvm]
[   21.031647]  kvm_vcpu_ioctl+0x38a/0x6f0 [kvm]
[   21.032647]  ? __fget_files+0x156/0x220
[   21.033522]  __x64_sys_ioctl+0x89/0xc0
[   21.034360]  ? syscall_trace_enter.isra.18+0xea/0x260
[   21.035478]  do_syscall_64+0x3a/0x90
[   21.036259]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Since srcu read lock is held, it's a false positive warning.
Use hlist_for_each_entry_srcu() instead of hlist_for_each_entry_rcu()
as it also checkes if the right lock is held.

Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 virt/kvm/eventfd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2ad013b8bde9..59b1dd4a549e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -463,8 +463,8 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-					 link)
+		hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
+					  link, srcu_read_lock_held(&kvm->irq_srcu))
 			if (kian->gsi == gsi) {
 				srcu_read_unlock(&kvm->irq_srcu, idx);
 				return true;
@@ -480,8 +480,8 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 {
 	struct kvm_irq_ack_notifier *kian;
 
-	hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-				 link)
+	hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
+				  link, srcu_read_lock_held(&kvm->irq_srcu))
 		if (kian->gsi == gsi)
 			kian->irq_acked(kian);
 }
-- 
2.31.1

