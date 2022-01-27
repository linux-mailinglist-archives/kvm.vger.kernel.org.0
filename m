Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C219849DB06
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 07:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiA0Gyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 01:54:52 -0500
Received: from out0-136.mail.aliyun.com ([140.205.0.136]:51346 "EHLO
        out0-136.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiA0Gyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 01:54:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047213;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---.MiyL62r_1643266489;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MiyL62r_1643266489)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jan 2022 14:54:50 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: eventfd: Fix false positive RCU usage warning
Date:   Thu, 27 Jan 2022 14:54:49 +0800
Message-Id: <f98bac4f5052bad2c26df9ad50f7019e40434512.1643265976.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <ab1358b84c60e6c942c270e3fe1a32bfa3177f3c.1641264282.git.houwenlong93@linux.alibaba.com>
References: <ab1358b84c60e6c942c270e3fe1a32bfa3177f3c.1641264282.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

Fix the following false positive warning:
 =============================
 WARNING: suspicious RCU usage
 5.16.0-rc4+ #57 Not tainted
 -----------------------------
 arch/x86/kvm/../../../virt/kvm/eventfd.c:484 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 3 locks held by fc_vcpu 0/330:
  #0: ffff8884835fc0b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x88/0x6f0 [kvm]
  #1: ffffc90004c0bb68 (&kvm->srcu){....}-{0:0}, at: vcpu_enter_guest+0x600/0x1860 [kvm]
  #2: ffffc90004c0c1d0 (&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x36/0x180 [kvm]

 stack backtrace:
 CPU: 26 PID: 330 Comm: fc_vcpu 0 Not tainted 5.16.0-rc4+
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x44/0x57
  kvm_notify_acked_gsi+0x6b/0x70 [kvm]
  kvm_notify_acked_irq+0x8d/0x180 [kvm]
  kvm_ioapic_update_eoi+0x92/0x240 [kvm]
  kvm_apic_set_eoi_accelerated+0x2a/0xe0 [kvm]
  handle_apic_eoi_induced+0x3d/0x60 [kvm_intel]
  vmx_handle_exit+0x19c/0x6a0 [kvm_intel]
  vcpu_enter_guest+0x66e/0x1860 [kvm]
  kvm_arch_vcpu_ioctl_run+0x438/0x7f0 [kvm]
  kvm_vcpu_ioctl+0x38a/0x6f0 [kvm]
  __x64_sys_ioctl+0x89/0xc0
  do_syscall_64+0x3a/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Since kvm_unregister_irq_ack_notifier() does synchronize_srcu(&kvm->irq_srcu),
i.e. kvm->irq_ack_notifier_list is protected by kvm->irq_srcu. And
kvm->irq_srcu SRCU read lock is held in kvm_notify_acked_irq(), it's
a false positive warning. Use hlist_for_each_entry_srcu() instead of
hlist_for_each_entry_rcu() as it also checkes if the right lock is held.

Reviewed-by: Sean Christopherson <seanjc@google.com>
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

