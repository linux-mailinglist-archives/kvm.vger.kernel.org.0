Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84986B4CEB
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCJQ2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjCJQ1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:27:46 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13C310D773;
        Fri, 10 Mar 2023 08:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678465439; x=1710001439;
  h=from:to:cc:subject:date:message-id;
  bh=L//xlqufoDi3Y+BynOipec0y5DkvvSVKczMAsPP3L4Y=;
  b=fQsa6kLS1tLs/ZZKbX++U2LJsaJ0FEp7treqWHclua1TXzlLt8ZDdjps
   0OLq6Ci37wZAoacVzzszkqAUcnSnf6gh0492myKLbucQFR7OdK254Vxaa
   9x2u9v3+wZW9kZ7nygt9HOVN4YhN+ukO8WNEFfwcf2bwCg1eKkQDeBxRd
   j9s3qvZUFMN6J1woOLrl6C4R7FjLR79rJzzX/BMetHfsaIbc16q6Z8jSP
   +Pd1itzf2igs6TFoU1TOIv5TCu4ZfnOaURfcpJNA30w7bkWKxQeSiHf9r
   jGU/EOiJxFEKdvotqyIeTEIgDYydAxqdtNkOt75QMZ+tJESUkbKS8f//n
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="338318320"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="338318320"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 08:23:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="671138170"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="671138170"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 08:23:46 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: VMX: fix lockdep warning on posted intr wakeup
Date:   Fri, 10 Mar 2023 23:59:55 +0800
Message-Id: <20230310155955.29652-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use rcu list to break the possible circular locking dependency reported
by lockdep.

path 1, ``sysvec_kvm_posted_intr_wakeup_ipi()`` --> ``pi_wakeup_handler()``
         -->  ``kvm_vcpu_wake_up()`` --> ``try_to_wake_up()``,
         the lock sequence is
         &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) --> &p->pi_lock.

path 2, ``schedule()`` --> ``kvm_sched_out()`` --> ``vmx_vcpu_put()`` -->
        ``vmx_vcpu_pi_put()`` --> ``pi_enable_wakeup_handler()``,
         the lock sequence is
         &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu).

path 3, ``task_rq_lock()``,
        the lock sequence is &p->pi_lock --> &rq->__lock

lockdep report:
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

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 94c38bea60e7..e3ffc45c0a7b 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -90,7 +90,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
 		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-		list_del(&vmx->pi_wakeup_list);
+		list_del_rcu(&vmx->pi_wakeup_list);
 		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	}
 
@@ -153,7 +153,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	local_irq_save(flags);
 
 	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-	list_add_tail(&vmx->pi_wakeup_list,
+	list_add_tail_rcu(&vmx->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
@@ -219,16 +219,14 @@ void pi_wakeup_handler(void)
 {
 	int cpu = smp_processor_id();
 	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
-	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
 	struct vcpu_vmx *vmx;
 
-	raw_spin_lock(spinlock);
-	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
-
+	rcu_read_lock();
+	list_for_each_entry_rcu(vmx, wakeup_list, pi_wakeup_list) {
 		if (pi_test_on(&vmx->pi_desc))
 			kvm_vcpu_wake_up(&vmx->vcpu);
 	}
-	raw_spin_unlock(spinlock);
+	rcu_read_unlock();
 }
 
 void __init pi_init_cpu(int cpu)

base-commit: 89400df96a7570b651404bbc3b7afe627c52a192
-- 
2.17.1

