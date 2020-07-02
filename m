Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC84212566
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgGBN4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:56:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726500AbgGBN4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:56:18 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 984256462E39DFB8901B;
        Thu,  2 Jul 2020 21:56:15 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 21:56:07 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <liangpeng10@huawei.com>, <zhengxiang9@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v2 7/8] KVM: arm64: Sync dirty log parallel
Date:   Thu, 2 Jul 2020 21:55:55 +0800
Message-ID: <20200702135556.36896-8-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200702135556.36896-1-zhukeqian1@huawei.com>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Give userspace another selection to solve high-cost dirty log
sync, which called multi-core offload. Usersapce can enable
this policy through KVM_CAP_ARM_HW_DIRTY_LOG.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/arm.c              |  9 +++-
 arch/arm64/kvm/mmu.c              | 82 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/reset.c            |  2 +-
 4 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 69a5317c7049..05da819f9adc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -95,6 +95,9 @@ struct kvm_arch {
 	 * supported.
 	 */
 	bool return_nisv_io_abort_to_user;
+
+	/* Sync dirty log parallel when hw dirty log enabled */
+	bool sync_dirty_log_parallel;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9e3f765d5467..89614984831d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -82,6 +82,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	int i;
 	struct kvm_vcpu *vcpu;
 	bool enable_hw_dirty_log;
+	bool enable_sync_parallel;
 #endif
 
 	if (cap->flags)
@@ -94,10 +95,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 #ifdef CONFIG_ARM64_HW_AFDBM
 	case KVM_CAP_ARM_HW_DIRTY_LOG:
-		if (!arm_mmu_hw_dbm_supported() || (cap->args[0] & ~0x1))
+		if (!arm_mmu_hw_dbm_supported() || (cap->args[0] & ~0x3))
 			r = -EINVAL;
 
 		enable_hw_dirty_log = !!(cap->args[0] & 0x1);
+		enable_sync_parallel = !!(cap->args[0] & 0x2);
+		if (!enable_hw_dirty_log && enable_sync_parallel)
+			r = -EINVAL;
+
 		if (!!(kvm->arch.vtcr & VTCR_EL2_HD) != enable_hw_dirty_log) {
 			if (enable_hw_dirty_log)
 				kvm->arch.vtcr |= VTCR_EL2_HD;
@@ -119,6 +124,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			}
 		}
 
+		kvm->arch.sync_dirty_log_parallel = enable_sync_parallel;
+
 		r = 0;
 		break;
 #endif
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a48554accb0..be360e0fd20b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2548,15 +2548,55 @@ static void stage2_sync_dirty_log_range(struct kvm *kvm, phys_addr_t addr,
 
 	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
-		cond_resched_lock(&kvm->mmu_lock);
-		if (!READ_ONCE(kvm->arch.pgd))
-			break;
+		if (!kvm->arch.sync_dirty_log_parallel) {
+			cond_resched_lock(&kvm->mmu_lock);
+			if (!READ_ONCE(kvm->arch.pgd))
+				break;
+		}
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (stage2_pgd_present(kvm, *pgd))
 			stage2_sync_dirty_log_p4ds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
+static struct dirty_sync_task {
+	struct kvm *kvm;
+	struct kvm_memory_slot *memslot;
+	u32 cpu_cnt;
+	u16 cpu_idx_map[NR_CPUS];
+	u32 ite_npages;
+	u32 ite;
+	bool finished;
+} sync_task;
+
+static void stage2_sync_dirty_log_smp(void *task)
+{
+	struct dirty_sync_task *t = task;
+	struct kvm_memory_slot *memslot = t->memslot;
+	unsigned long ite_idx, base_page, end_page;
+	gfn_t base_gfn;
+
+	ite_idx = t->cpu_cnt * t->ite + t->cpu_idx_map[smp_processor_id()];
+
+	base_page = ite_idx * t->ite_npages;
+	if (base_page >= memslot->npages) {
+		t->finished = true;
+		trace_printk("stage2_sync_dirty_log_smp finished 1.\n");
+		return;
+	}
+
+	end_page = min(memslot->npages, base_page + t->ite_npages);
+	if (end_page == memslot->npages) {
+		t->finished = true;
+		trace_printk("stage2_sync_dirty_log_smp finished 2.\n");
+	}
+
+	base_gfn = memslot->base_gfn;
+	trace_printk("base_page 0x%lx, end_page 0x%lx.\n", base_page, end_page);
+	stage2_sync_dirty_log_range(t->kvm, (base_gfn + base_page) << PAGE_SHIFT,
+				    (base_gfn + end_page) << PAGE_SHIFT);
+}
+
 /**
  * kvm_mmu_sync_dirty_log() - synchronize dirty log from stage2 PTEs for
  * memory slot
@@ -2577,18 +2617,52 @@ void kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+	u32 ite_npages, cpu_cnt, this_cpu, cpu;
+	u16 cpu_idx;
 	int srcu_idx;
 
 	if (WARN_ON_ONCE(!memslot->dirty_bitmap))
 		return;
 
+	get_online_cpus();
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 
-	stage2_sync_dirty_log_range(kvm, start, end);
+	ite_npages = (1 << 17); /* 512MB max for per iteration and CPU */
+	cpu_cnt = num_online_cpus();
+
+	/* Use single CPU */
+	if (!kvm->arch.sync_dirty_log_parallel ||
+	    memslot->npages <= ite_npages ||
+	    unlikely(cpu_cnt == 1)) {
+		stage2_sync_dirty_log_range(kvm, start, end);
+		goto out_unlock;
+	}
 
+	/* Use many CPUs through IPI */
+	cpu_idx = 0;
+	this_cpu = smp_processor_id();
+	for_each_online_cpu(cpu) {
+		if (cpu != this_cpu)
+			sync_task.cpu_idx_map[cpu] = cpu_idx++;
+	}
+
+	sync_task.kvm = kvm;
+	sync_task.memslot = memslot;
+	sync_task.cpu_cnt = cpu_cnt - 1; /* Not include this CPU */
+	sync_task.ite_npages = ite_npages;
+
+	sync_task.ite = 0;
+	sync_task.finished = false;
+	do {
+		smp_call_function(stage2_sync_dirty_log_smp, &sync_task, 1);
+		sync_task.ite++;
+	} while (!sync_task.finished);
+
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	put_online_cpus();
 }
 
 /**
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index a3be703dd54b..4171d6c1d400 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -85,7 +85,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #ifdef CONFIG_ARM64_HW_AFDBM
 	case KVM_CAP_ARM_HW_DIRTY_LOG:
-		r = arm_mmu_hw_dbm_supported();
+		r = arm_mmu_hw_dbm_supported() ? 0x3 : 0x0;
 		break;
 #endif /* CONFIG_ARM64_HW_AFDBM */
 	default:
-- 
2.19.1

