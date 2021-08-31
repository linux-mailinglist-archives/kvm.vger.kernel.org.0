Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414C93FC0A7
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 04:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbhHaCCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 22:02:03 -0400
Received: from smtp181.sjtu.edu.cn ([202.120.2.181]:41160 "EHLO
        smtp181.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbhHaCCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 22:02:03 -0400
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp181.sjtu.edu.cn (Postfix) with ESMTPS id C915E1008B3AD;
        Tue, 31 Aug 2021 10:01:06 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 28CC2228C9242;
        Tue, 31 Aug 2021 10:00:48 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 16Zggdo9Kzq8; Tue, 31 Aug 2021 10:00:47 +0800 (CST)
Received: from sky.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
        (Authenticated sender: skyele@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 0B851228C9235;
        Tue, 31 Aug 2021 10:00:24 +0800 (CST)
From:   Tianqiang Xu <skyele@sjtu.edu.cn>
To:     x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        kvm@vger.kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Tianqiang Xu <skyele@sjtu.edu.cn>
Subject: [PATCH 3/4] KVM host implementation
Date:   Tue, 31 Aug 2021 09:59:18 +0800
Message-Id: <20210831015919.13006-3-skyele@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831015919.13006-1-skyele@sjtu.edu.cn>
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host OS sets 'is_idle' field of kvm_steal_time to 1 if
cpu_rq(this_cpu)->nr_running is 1 before a vCPU being scheduled out.
On this condition, there is no other task on this pCPU to run.
Thus, is_idle == 1 means the pCPU where the preempted vCPU most
recently run is idle.

Host OS invokes get_cpu_nr_running() to get the value of
cpu_rq(this_cpu)->nr_running.

--
Authors: Tianqiang Xu, Dingji Li, Zeyu Mi
	 Shanghai Jiao Tong University

Signed-off-by: Tianqiang Xu <skyele@sjtu.edu.cn>
---
 arch/x86/include/asm/qspinlock.h |  1 -
 arch/x86/kvm/x86.c               | 88 +++++++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index c32f2eb6186c..1832dd8308ca 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -61,7 +61,6 @@ static inline bool vcpu_is_preempted(long cpu)
 {
 	return pv_vcpu_is_preempted(cpu);
 }
-#endif
 
 #define pcpu_is_idle pcpu_is_idle
 static inline bool pcpu_is_idle(long cpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..1fb1ab3d6fca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3181,6 +3181,72 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 
+static void kvm_steal_time_set_is_idle(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_map map;
+	struct kvm_steal_time *st;
+
+	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	if (vcpu->arch.st.is_idle)
+		return;
+
+	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
+			&vcpu->arch.st.cache, true))
+		return;
+
+	st = map.hva +
+		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+
+	st->is_idle = vcpu->arch.st.is_idle = KVM_PCPU_IS_IDLE;
+
+	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+}
+
+static void kvm_steal_time_clear_is_idle(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_map map;
+	struct kvm_steal_time *st;
+
+	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	if (vcpu->arch.st.is_idle)
+		return;
+
+	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
+			&vcpu->arch.st.cache, false))
+		return;
+
+	st = map.hva +
+		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+
+	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH))
+		xchg(&st->is_idle, 0);
+	else
+		st->is_idle = 0;
+
+	vcpu->arch.st.is_idle = 0;
+
+	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+}
+
+
+static DEFINE_PER_CPU(struct kvm_vcpu *, this_cpu_pre_run_vcpu);
+
+static void vcpu_load_update_pre_vcpu_callback(struct kvm_vcpu *new_vcpu, struct kvm_steal_time *st)
+{
+	struct kvm_vcpu *old_vcpu = __this_cpu_read(this_cpu_pre_run_vcpu);
+
+	if (!old_vcpu)
+		return;
+	if (old_vcpu != new_vcpu)
+		kvm_steal_time_clear_is_idle(old_vcpu);
+	else
+		st->is_idle = new_vcpu->arch.st.is_idle = KVM_PCPU_IS_IDLE;
+}
+
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm_host_map map;
@@ -3219,6 +3285,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.st.preempted = 0;
 
+	vcpu_load_update_pre_vcpu_callback(vcpu, st);
+
 	if (st->version & 1)
 		st->version += 1;  /* first time write, random junk */
 
@@ -4290,6 +4358,8 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
 }
 
+extern int get_cpu_nr_running(int cpu);
+
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
@@ -4304,8 +4374,14 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (kvm_xen_msr_enabled(vcpu->kvm))
 		kvm_xen_runstate_set_preempted(vcpu);
-	else
+	else {
 		kvm_steal_time_set_preempted(vcpu);
+
+		if (get_cpu_nr_running(smp_processor_id()) <= 1)
+			kvm_steal_time_set_is_idle(vcpu);
+		else
+			kvm_steal_time_clear_is_idle(vcpu);
+	}
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
@@ -9693,6 +9769,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	preempt_enable();
 
+	__this_cpu_write(this_cpu_pre_run_vcpu, vcpu);
+
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/*
@@ -11253,6 +11331,14 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	int cpu;
+	struct kvm_vcpu *vcpu;
+
+	for_each_possible_cpu(cpu) {
+		vcpu = per_cpu(this_cpu_pre_run_vcpu, cpu);
+		if (vcpu && vcpu->kvm == kvm)
+			per_cpu(this_cpu_pre_run_vcpu, cpu) = NULL;
+	}
+
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
-- 
2.26.0

