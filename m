Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76608493B08
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 14:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354718AbiASNYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 08:24:37 -0500
Received: from mx315.baidu.com ([180.101.52.204]:35294 "EHLO
        njjs-sys-mailin04.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1350184AbiASNYb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 08:24:31 -0500
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2022 08:24:30 EST
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin04.njjs.baidu.com (Postfix) with ESMTP id 8FCFB11800042;
        Wed, 19 Jan 2022 21:14:21 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 6EB4DD9932;
        Wed, 19 Jan 2022 21:14:21 +0800 (CST)
From:   Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     lirongqing@baidu.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] KVM: X86: Introduce vfio_intr_stat per-vm debugfs file
Date:   Wed, 19 Jan 2022 21:14:21 +0800
Message-Id: <1642598061-29454-1-git-send-email-yuanzhaoxiong@baidu.com>
X-Mailer: git-send-email 1.7.1
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
diff with v0: modifying the code format.

 arch/x86/kvm/debugfs.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 9240b3b..be16bfe 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -10,6 +10,11 @@
 #include "mmu.h"
 #include "mmu/mmu_internal.h"
 
+#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#include <linux/kvm_irqfd.h>
+#include <asm/irq_remapping.h>
+#endif
+
 static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
@@ -181,9 +186,94 @@ static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
 	.release	= kvm_mmu_rmaps_stat_release,
 };
 
+#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
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
+			!irq_remapping_cap(IRQ_POSTING_CAP)) {
+		return 0;
+	}
+
+	seq_printf(m, "%12s %12s %12s %12s\n",
+			"guest_irq", "host_irq", "vector", "vcpu");
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
+				hlist_empty(&irq_rt->map[guest_irq])) {
+			pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
+					guest_irq, irq_rt->nr_rt_entries);
+			continue;
+		}
+
+		hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
+			if (e->type != KVM_IRQ_ROUTING_MSI)
+				continue;
+
+			kvm_set_msi_irq(kvm, e, &irq);
+			if (kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
+				seq_printf(m, "%12u %12u %12u %12u\n",
+						guest_irq, host_irq, irq.vector, vcpu->vcpu_id);
+			}
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
+#endif
+
 int kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
 	debugfs_create_file("mmu_rmaps_stat", 0644, kvm->debugfs_dentry, kvm,
 			    &mmu_rmaps_stat_fops);
+
+#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+	debugfs_create_file("vfio_intr_stat", 0444, kvm->debugfs_dentry, kvm,
+			    &vfio_intr_stat_fops);
+#endif
 	return 0;
 }
-- 
1.8.3.1

