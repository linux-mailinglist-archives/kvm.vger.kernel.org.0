Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0826B7382
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 11:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCMKNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 06:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCMKNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 06:13:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5496C2CC7E;
        Mon, 13 Mar 2023 03:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678702428; x=1710238428;
  h=from:to:cc:subject:date:message-id;
  bh=w3YNGg63e5zdLi8OsUzZr9IzUvSuGuJCMGdkWaz9ByY=;
  b=eith7+sKDt6yODt40dpL9AQpPoClIS8o+8UwYFFxxL2QYW42pqOMIous
   o9+PoZOOMWD5rTQMXsDuYKGID1IXsevG0IU1j3zNW5fGccniL96YdGM13
   /BZE2ycdW2AzGXXF5yeqpby9y6tPoKxIE+a4bKmtlzgOv4hTtlaThisP6
   cQiAPXEzKVp78uMlQpU/aMRAtXP4IAzdbPQVkZNNdWvw+GJ6gZjJZDazQ
   A945Xdrd3XuJePzSuqZKFQBVPGioO2JzTjOPGIO3ha9SHWkPRdzuwlHeD
   /p3v9vvSK/L1w/aYAMfkWrSM6iUT3m9NYxln8v+MxDGfaCQ4vw5tPr4qH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="317497806"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="317497806"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 03:13:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="802400938"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="802400938"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 03:13:45 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2] KVM: VMX: fix lockdep warning on posted intr wakeup
Date:   Mon, 13 Mar 2023 17:47:53 +0800
Message-Id: <20230313094753.8345-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split a single per_cpu lock on wakeup_list into a sched_in lock and
a sched_out lock to break the possible circular locking dependency
reported by lockdep.

The lockdep complains about "possible circular locking dependency
detected".

Chain exists of:
   &p->pi_lock --> &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)

  Possible unsafe locking scenario:

        CPU0                CPU1
        ----                ----
   lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
                            lock(&rq->__lock);
                            lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
   lock(&p->pi_lock);

  *** DEADLOCK ***

path irq,
        sysvec_kvm_posted_intr_wakeup_ipi() --> pi_wakeup_handler()
        --> kvm_vcpu_wake_up() --> try_to_wake_up(),
        the lock order is
        &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) --> &p->pi_lock.

path sched_out,
        vcpu_block() --> schedule() --> kvm_sched_out() --> vmx_vcpu_put()
        --> vmx_vcpu_pi_put() --> pi_enable_wakeup_handler(),
        the lock order is
        &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu).

However, it is found out that path irq and sched_out are not racing
because: path irq is in interrupt context, path sched_out is in interrupt
disabled context, at the same pcpu as path irq.

Consider path sched_out is the very path that tells lockdep the lock
ordering: &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu),
it's desired for path irq not to hold the same per cpu lock as path
sched_out.

So, in the patch, a single wakeup_list lock is divided into a sched_in lock
and a sched_out lock.
- "path sched_out": add vcpu on pcpu (irq disabled)
              It takes sched_out lock.

- "path irq": read vcpu list on pcpu (irq context, running on the same pcpu
              as "path sched_out")
              It only takes sched_in lock.

- "path sched_in": delete vcpu on previous pCPU.
                  (irq disabled, running on the same or different pCPU
                  as "path irq")
                  It takes sched_in and sched_out lock as it can race
                  with the other two paths. (though in theory, it can
                  never race with "path sched_out")

The lock ordering after this patch are:
- &p->pi_lock --> &rq->__lock -->
  &per_cpu(wakeup_vcpus_on_cpu_lock_out, cpu)
- &per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu) -->
  &per_cpu(wakeup_vcpus_on_cpu_lock_out, cpu)
- &per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu) --> &p->pi_lock

Currently, &rq->__lock is not held in "path sched_in".
However, if in future "path sched_in" takes &p->pi_lock or &rq->__lock,
lockdep is able to detect and warn in that case.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: path sched_out and path irq does not race, path sched_in does not
take &rq->__lock]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
v2:
switch from rcu to two raw_spin_locks. as rcu may not let the irq
handler see list removal timely. (sean)

v1:
https://lore.kernel.org/all/20230310155955.29652-1-yan.y.zhao@intel.com/
---
 arch/x86/kvm/vmx/posted_intr.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 94c38bea60e7..92bbbfd161a0 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -23,13 +23,20 @@
  */
 static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
 /*
- * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
+ * Protect the per-CPU list with two per-CPU spinlocks to handle task migration.
+ * IRQs must be disabled when taking the two locks, otherwise deadlock will
+ * occur if a wakeup IRQ arrives and attempts to acquire the locks.
+ * ->sched_out() path before a vCPU blocking takes the "out lock", which will not
+ * be taken in the wakeup IRQ handler that running at the same pCPU as the
+ * ->sched_out() path.
  * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
  * ->sched_in() path will need to take the vCPU off the list of the _previous_
- * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
- * occur if a wakeup IRQ arrives and attempts to acquire the lock.
+ * CPU. It takes both "in lock" and "out lock" to take care of list racing of the
+ * _previous_ CPU.
  */
-static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
+static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock_in);
+static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock_out);
+
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
@@ -57,7 +64,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	struct pi_desc old, new;
 	unsigned long flags;
 	unsigned int dest;
-
 	/*
 	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST and
 	 * PI.SN up-to-date even if there is no assigned device or if APICv is
@@ -89,9 +95,11 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * current pCPU if the task was migrated.
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
-		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock_in, vcpu->cpu));
+		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock_out, vcpu->cpu));
 		list_del(&vmx->pi_wakeup_list);
-		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock_out, vcpu->cpu));
+		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock_in, vcpu->cpu));
 	}
 
 	dest = cpu_physical_id(cpu);
@@ -152,10 +160,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock_out, vcpu->cpu));
 	list_add_tail(&vmx->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
-	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock_out, vcpu->cpu));
 
 	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
 
@@ -219,12 +227,11 @@ void pi_wakeup_handler(void)
 {
 	int cpu = smp_processor_id();
 	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
-	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
+	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu);
 	struct vcpu_vmx *vmx;
 
 	raw_spin_lock(spinlock);
 	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
-
 		if (pi_test_on(&vmx->pi_desc))
 			kvm_vcpu_wake_up(&vmx->vcpu);
 	}
@@ -234,7 +241,8 @@ void pi_wakeup_handler(void)
 void __init pi_init_cpu(int cpu)
 {
 	INIT_LIST_HEAD(&per_cpu(wakeup_vcpus_on_cpu, cpu));
-	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu));
+	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock_out, cpu));
 }
 
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)

base-commit: 89400df96a7570b651404bbc3b7afe627c52a192
-- 
2.17.1

