Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498584AD928
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353394AbiBHNQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376385AbiBHM75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:59:57 -0500
X-Greylist: delayed 1150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 04:59:47 PST
Received: from bddwd-sys-mailin04.bddwd.baidu.com (mx402.baidu.com [124.64.201.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21509C03FEC0;
        Tue,  8 Feb 2022 04:59:47 -0800 (PST)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by bddwd-sys-mailin04.bddwd.baidu.com (Postfix) with ESMTP id 8B65B13D80030;
        Tue,  8 Feb 2022 20:40:20 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 7F6B3D9932;
        Tue,  8 Feb 2022 20:40:20 +0800 (CST)
From:   Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     lirongqing@baidu.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: X86: Introduce vfio_intr_stat per-vm debugfs file
Date:   Tue,  8 Feb 2022 20:40:20 +0800
Message-Id: <1644324020-17639-1-git-send-email-yuanzhaoxiong@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use this file to export correspondence between guest_irq, host_irq,
vector and vcpu belonging to VFIO passthrough devices.

An example output of this looks like (a vm with VFIO passthrough
devices):
   guest_irq     host_irq       vector         vcpu
          24          201           37            8
          25          202           35           25
          26          203           35           20
   ......

When a VM has VFIO passthrough devices, the correspondence between
guest_irq, host_irq, vector and vcpu may need to be known especially
in AMD platform with avic disabled. The AMD avic is disabled, and
the passthrough devices may cause vcpu vm exit twice for a interrupt.
One extrernal interrupt caused by vfio host irq, other ipi to inject
a interrupt to vm.

If the system administrator known these information, set vfio host
irq affinity to Pcpu which the correspondece guest irq affinited vcpu,
to avoid extra vm exit.

Co-developed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
---
v1: https://lore.kernel.org/lkml/1642593015-28729-1-git-send-email-yuanzhaoxiong@baidu.com/
v1->v2: 
- remove the HAVE_KVM_IRQ_BYPASS conditional judgment
- Modifying code format and remove unnecessary curly braces

 arch/x86/kvm/debugfs.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 9240b3b..fef9014 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -6,6 +6,8 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/debugfs.h>
+#include <linux/kvm_irqfd.h>
+#include <asm/irq_remapping.h>
 #include "lapic.h"
 #include "mmu.h"
 #include "mmu/mmu_internal.h"
@@ -181,9 +183,85 @@ static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
 	.release	= kvm_mmu_rmaps_stat_release,
 };
 
+static int kvm_vfio_intr_stat_show(struct seq_file *m, void *v)
+{
+	struct kvm_kernel_irq_routing_entry *e;
+	struct kvm_irq_routing_table *irq_rt;
+	unsigned int host_irq, guest_irq;
+	struct kvm_kernel_irqfd *irqfd;
+	struct kvm *kvm = m->private;
+	struct kvm_lapic_irq irq;
+	struct kvm_vcpu *vcpu;
+	int idx;
+
+	if (!kvm_arch_has_assigned_device(kvm) ||
+	    !irq_remapping_cap(IRQ_POSTING_CAP))
+		return 0;
+
+	seq_printf(m, "%12s %12s %12s %12s\n",
+		   "guest_irq", "host_irq", "vector", "vcpu");
+
+	spin_lock_irq(&kvm->irqfds.lock);
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
+
+	list_for_each_entry(irqfd, &kvm->irqfds.items, list) {
+		if (!irqfd->producer)
+			continue;
+
+		host_irq = irqfd->producer->irq;
+		guest_irq = irqfd->gsi;
+
+		if (guest_irq >= irq_rt->nr_rt_entries ||
+		    hlist_empty(&irq_rt->map[guest_irq]))
+			continue;
+
+		hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
+			if (e->type != KVM_IRQ_ROUTING_MSI)
+				continue;
+
+			kvm_set_msi_irq(kvm, e, &irq);
+			if (kvm_intr_is_single_vcpu(kvm, &irq, &vcpu))
+				seq_printf(m, "%12u %12u %12u %12u\n",
+					   guest_irq, host_irq, irq.vector, vcpu->vcpu_id);
+		}
+	}
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+	spin_unlock_irq(&kvm->irqfds.lock);
+	return 0;
+}
+
+static int kvm_vfio_intr_stat_open(struct inode *inode, struct file *file)
+{
+	struct kvm *kvm = inode->i_private;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	return single_open(file, kvm_vfio_intr_stat_show, kvm);
+}
+
+static int kvm_vfio_intr_stat_release(struct inode *inode, struct file *file)
+{
+	struct kvm *kvm = inode->i_private;
+
+	kvm_put_kvm(kvm);
+	return single_release(inode, file);
+}
+
+static const struct file_operations vfio_intr_stat_fops = {
+	.open    = kvm_vfio_intr_stat_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = kvm_vfio_intr_stat_release,
+};
+
 int kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
 	debugfs_create_file("mmu_rmaps_stat", 0644, kvm->debugfs_dentry, kvm,
 			    &mmu_rmaps_stat_fops);
+
+	debugfs_create_file("vfio_intr_stat", 0444, kvm->debugfs_dentry, kvm,
+			    &vfio_intr_stat_fops);
 	return 0;
 }
-- 
1.8.3.1

