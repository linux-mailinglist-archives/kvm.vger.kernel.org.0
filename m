Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153E51B45A5
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgDVM7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:59:09 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:59722 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbgDVM7I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 08:59:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0TwK9pmk_1587560293;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TwK9pmk_1587560293)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Apr 2020 20:58:14 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@linux.alibaba.com
Subject: [PATCH v2 3/7] KVM: PPC: Remove redundant kvm_run from vcpu_arch
Date:   Wed, 22 Apr 2020 20:58:06 +0800
Message-Id: <20200422125810.34847-4-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'kvm_run' field already exists in the 'vcpu' structure, which
is the same structure as the 'kvm_run' in the 'vcpu_arch' and
should be deleted.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/powerpc/include/asm/kvm_host.h | 1 -
 arch/powerpc/kvm/book3s_hv.c        | 6 ++----
 arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1dc63101ffe1..2745ff8faa01 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -795,7 +795,6 @@ struct kvm_vcpu_arch {
 	struct mmio_hpte_cache_entry *pgfault_cache;
 
 	struct task_struct *run_task;
-	struct kvm_run *kvm_run;
 
 	spinlock_t vpa_update_lock;
 	struct kvmppc_vpa vpa;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 93493f0cbfe8..413ea2dcb10c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2934,7 +2934,7 @@ static void post_guest_process(struct kvmppc_vcore *vc, bool is_master)
 
 		ret = RESUME_GUEST;
 		if (vcpu->arch.trap)
-			ret = kvmppc_handle_exit_hv(vcpu->arch.kvm_run, vcpu,
+			ret = kvmppc_handle_exit_hv(vcpu->run, vcpu,
 						    vcpu->arch.run_task);
 
 		vcpu->arch.ret = ret;
@@ -3920,7 +3920,6 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	spin_lock(&vc->lock);
 	vcpu->arch.ceded = 0;
 	vcpu->arch.run_task = current;
-	vcpu->arch.kvm_run = kvm_run;
 	vcpu->arch.stolen_logged = vcore_stolen_time(vc, mftb());
 	vcpu->arch.state = KVMPPC_VCPU_RUNNABLE;
 	vcpu->arch.busy_preempt = TB_NIL;
@@ -3973,7 +3972,7 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 			if (signal_pending(v->arch.run_task)) {
 				kvmppc_remove_runnable(vc, v);
 				v->stat.signal_exits++;
-				v->arch.kvm_run->exit_reason = KVM_EXIT_INTR;
+				v->run->exit_reason = KVM_EXIT_INTR;
 				v->arch.ret = -EINTR;
 				wake_up(&v->arch.cpu_run);
 			}
@@ -4049,7 +4048,6 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
 	vc = vcpu->arch.vcore;
 	vcpu->arch.ceded = 0;
 	vcpu->arch.run_task = current;
-	vcpu->arch.kvm_run = kvm_run;
 	vcpu->arch.stolen_logged = vcore_stolen_time(vc, mftb());
 	vcpu->arch.state = KVMPPC_VCPU_RUNNABLE;
 	vcpu->arch.busy_preempt = TB_NIL;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index dc97e5be76f6..5a3987f3ebf3 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -290,8 +290,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			r = RESUME_HOST;
 			break;
 		}
-		r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu, hdec_exp,
-					  lpcr);
+		r = kvmhv_run_single_vcpu(vcpu->run, vcpu, hdec_exp, lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
-- 
2.17.1

