Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBF11F534F
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgFJLeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgFJLeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:34:19 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B90B20734;
        Wed, 10 Jun 2020 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591788858;
        bh=msEjGp4qDF0WnQuD0W2AqRNSO4fEbHNst04epMYw4SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVelB2gG7s+PLGA+OiCsRQrUNglUkbwyybmHuupmwXszMqnXz9rIu+ZMqUnhBJ3gx
         oF2Q9vwhz2dfvEWPVGhH3fi9IBN9sj/LZINfNY0dz5b1WxM0+kwBr5eEVDjp4xac9Y
         DXGVDewR2e2QnQmseoZ9EqHrtAp78fsaGdDL4GYQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiyzo-001lrp-UX; Wed, 10 Jun 2020 12:34:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>, kernel-team@android.com
Subject: [PATCH v2 4/4] KVM: arm64: Remove host_cpu_context member from vcpu structure
Date:   Wed, 10 Jun 2020 12:34:06 +0100
Message-Id: <20200610113406.1493170-5-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610113406.1493170-1-maz@kernel.org>
References: <20200610113406.1493170-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ascull@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For very long, we have kept this pointer back to the per-cpu
host state, despite having working per-cpu accessors at EL2
for some time now.

Recent investigations have shown that this pointer is easy
to abuse in preemptible context, which is a sure sign that
it would better be gone. Not to mention that a per-cpu
pointer is faster to access at all times.

Reported-by: Andrew Scull <ascull@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com
Reviewed-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 3 ---
 arch/arm64/kvm/hyp/debug-sr.c     | 4 ++--
 arch/arm64/kvm/hyp/switch.c       | 6 +++---
 arch/arm64/kvm/hyp/sysreg-sr.c    | 6 ++++--
 arch/arm64/kvm/pmu.c              | 8 ++------
 6 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 59029e90b557..ada1faa92211 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -284,9 +284,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	/* Pointer to host CPU context */
-	struct kvm_cpu_context *host_cpu_context;
-
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14b747266607..6ddaa23ef346 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -340,10 +340,8 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
-	kvm_host_data_t *cpu_data;
 
 	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
-	cpu_data = this_cpu_ptr(&kvm_host_data);
 
 	/*
 	 * We might get preempted before the vCPU actually runs, but
@@ -355,7 +353,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	vcpu->cpu = cpu;
-	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
 
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 0fc9872a1467..e95af204fec7 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -185,7 +185,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
@@ -207,7 +207,7 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d60c2ef0fe8c..1853c1788e0c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -532,7 +532,7 @@ static bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	    !esr_is_ptrauth_trap(kvm_vcpu_get_hsr(vcpu)))
 		return false;
 
-	ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	__ptrauth_save_key(ctxt->sys_regs, APIA);
 	__ptrauth_save_key(ctxt->sys_regs, APIB);
 	__ptrauth_save_key(ctxt->sys_regs, APDA);
@@ -703,7 +703,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
 
-	host_ctxt = vcpu->arch.host_cpu_context;
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
@@ -808,7 +808,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	vcpu = kern_hyp_va(vcpu);
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 6d2df9fe0b5d..143d7b7358f2 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -265,12 +265,13 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
 
 	if (!has_vhe())
 		return;
 
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	__sysreg_save_user_state(host_ctxt);
 
 	/*
@@ -301,12 +302,13 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
 
 	if (!has_vhe())
 		return;
 
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	deactivate_traps_vhe_put();
 
 	__sysreg_save_el1_state(guest_ctxt);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index e71d00bb5271..b5ae3a5d509e 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -163,15 +163,13 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
  */
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
 	struct kvm_host_data *host;
 	u32 events_guest, events_host;
 
 	if (!has_vhe())
 		return;
 
-	host_ctxt = vcpu->arch.host_cpu_context;
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	host = this_cpu_ptr(&kvm_host_data);
 	events_guest = host->pmu_events.events_guest;
 	events_host = host->pmu_events.events_host;
 
@@ -184,15 +182,13 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
 	struct kvm_host_data *host;
 	u32 events_guest, events_host;
 
 	if (!has_vhe())
 		return;
 
-	host_ctxt = vcpu->arch.host_cpu_context;
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	host = this_cpu_ptr(&kvm_host_data);
 	events_guest = host->pmu_events.events_guest;
 	events_host = host->pmu_events.events_host;
 
-- 
2.26.2

