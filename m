Return-Path: <kvm+bounces-51883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BDC2AFE0D3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 09:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E78D4540D0B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF9626E6E1;
	Wed,  9 Jul 2025 07:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AQx3t1PB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED964270574
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 07:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752044705; cv=none; b=OCC9K55hSAbjB2hGFxYbJK+fYfRLeSEwJDBadoHUzVh42XxJOvoNwBT4E0gEJbLlOfXPf/kLL43rPuwGmkTh126J57s42zio0ewL7x9gFKpz0Ne5v2vabtqQztKTPxL9xfMLEzXaH2Phz6+K+AnV6HPJgvQcjEEZPPz4bK9GEz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752044705; c=relaxed/simple;
	bh=8acnn84F2EPwPo/2bUKI9y8xzYUhx0M85P0qcx2e/FM=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=q+I9mkZUWQ19BQybBBfN9RtuJstXkAyFVBnYLUfowEzG1glaM3iaK6cjhWj2N0nBXMlBKZ8786Pcn9pYirR5iZF1hd3yilK4u5rZ8K4F9uJKU8w7tHM7y80dPVQvmhKNxu8mDHCj2Cg0E5Pib4z222yJeGeueRMaBmhQaY7Zu3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AQx3t1PB; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-7111ff9f2d4so67342017b3.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 00:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752044703; x=1752649503; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8hUdo8ARlQkzGI2qXgVk3yoTg5wBj9RNjVmfVyEYsuY=;
        b=AQx3t1PBdqBcHVVibM34HQUd7PMnwcfc377Cuue613zxiv6KGDFvFYiefSSc5Aanon
         yZ8UeafT+Ic3HW50/nEVdwtenrRULjtZcTkPbFA+JoqAiBCaUJ1Oo6eb7XDD+uXYMTqP
         dHqCjElSGxIGHtF/H3S9z3lcimsNih9EuI75DbVYQYQEQnw1MbnsTR9MH8rd2ZZ3zaVp
         b9lj7STUCTJlBixoWp3tHBPRhfJTA+3yL/ZXht4PeEJ7bazmh6Dt/8NXh99KBzfu+FXB
         4mL0//2/GuvienP3HZvZtnCuEeP2B7OuJEBAgwKuNw6QudM6PwDKALrzJnpoNFPGmICg
         yFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752044703; x=1752649503;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8hUdo8ARlQkzGI2qXgVk3yoTg5wBj9RNjVmfVyEYsuY=;
        b=GfDwrdxqSwpC4wQ3Pxb2nU3NlqPRt6oKQY5qjW7Z+QU71dtgEDWASuPWbP/BVdFtgM
         d2UVQhz+rgNVnQ17Y+SJ7mKgM8Qp1tUcrTSJy6bWd1peTI0ZQMj0gtW7Fc9Eo08c4/lg
         aj/RVvk4RAUpPkAgSz/nfS47pVIRmIk4cbCQ2a1l4SF/r2ZZgA+v+bMojAoIl9hW7qch
         9ooDV41fAU+3nxWz6ZxbsF/8f5QKgX6YUGAzFYeB/FbFNFGa389DNsKxm+M+84gyA9Fs
         F1/Vha4IEpwVEhTe5VSOLhOjxbgamULjn68jEgispRjeHsq/ODv5jCrdywb3JpkV4Nc1
         /7kA==
X-Forwarded-Encrypted: i=1; AJvYcCVCPiJEv9dYtEVHHRiXCZCGSfJ6XbNEFxU73oys4Q0L4V9bLuiJ06rz94MtwnHaOJyxEDg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3P4QR4mySByrxzdcs08h0HAJbAkGlVTZ49Hju9vVA4AcD/tDY
	kptJ/OoEcmBWnJBfspxuezJ6Hbr4qYUtMrANAgluGcdTjSt4btGD3oIa2SYZi7Zf3vSBKyhGvmM
	dkKlpGCx4UKrW8w==
X-Google-Smtp-Source: AGHT+IGEfiidPbWbXfAEZ47CmcdUs9ZPOOEtK0ixwyyLTU/yNC0ka1UYfmzV8mQy6TonmuKtwlqV6SEZTjJqyg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:a92c:694f:82fe:62a])
 (user=suleiman job=sendgmr) by 2002:a25:d344:0:b0:e7d:6afc:71da with SMTP id
 3f1490d57ef6-e8b6e10d3a8mr709276.2.1752044702827; Wed, 09 Jul 2025 00:05:02
 -0700 (PDT)
Date: Wed,  9 Jul 2025 16:04:49 +0900
In-Reply-To: <20250709070450.473297-1-suleiman@google.com>
Message-Id: <20250709070450.473297-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709070450.473297-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v6 2/3] KVM: x86: Include host suspended duration in steal time
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce MSR_KVM_SUSPEND_STEAL which controls whether or not a guest
wants the duration of host suspend to be included in steal time.

This lets guests subtract the duration during which the host was
suspended from the runtime of tasks that were running over the suspend,
in order to prevent cases where host suspend causes long runtimes in
guest tasks, even though their effective runtime was much shorter.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 Documentation/virt/kvm/x86/cpuid.rst |  4 ++
 Documentation/virt/kvm/x86/msr.rst   | 15 ++++++
 arch/x86/include/asm/kvm_host.h      |  3 ++
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kvm/cpuid.c                 |  4 +-
 arch/x86/kvm/x86.c                   | 80 ++++++++++++++++++++++++++--
 6 files changed, 102 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/x86/cpuid.rst b/Documentation/virt/kvm/x86/cpuid.rst
index bda3e3e737d71f..71b42b6499733b 100644
--- a/Documentation/virt/kvm/x86/cpuid.rst
+++ b/Documentation/virt/kvm/x86/cpuid.rst
@@ -103,6 +103,10 @@ KVM_FEATURE_HC_MAP_GPA_RANGE       16          guest checks this feature bit bef
 KVM_FEATURE_MIGRATION_CONTROL      17          guest checks this feature bit before
                                                using MSR_KVM_MIGRATION_CONTROL
 
+KVM_FEATURE_SUSPEND_STEAL          18          guest checks this feature bit
+                                               before using
+                                               MSR_KVM_SUSPEND_STEAL.
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 3aecf2a70e7b43..8c31b3994e733d 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -296,6 +296,12 @@ data:
 		the amount of time in which this vCPU did not run, in
 		nanoseconds. Time during which the vcpu is idle, will not be
 		reported as steal time.
+		If the guest set the enable bit in MSR_KVM_SUSPEND_STEAL,
+		steal time includes the duration during which the host is
+		suspended. The case where the host suspends during a VM
+		migration might not be accounted if VCPUs aren't entered
+		post-resume. A workaround would be for the VMM to ensure that
+		the guest is entered with KVM_RUN after resuming from suspend.
 
 	preempted:
 		indicate the vCPU who owns this struct is running or
@@ -388,3 +394,12 @@ data:
         guest is communicating page encryption status to the host using the
         ``KVM_HC_MAP_GPA_RANGE`` hypercall, it can set bit 0 in this MSR to
         allow live migration of the guest.
+
+MSR_KVM_SUSPEND_STEAL:
+	0x4b564d09
+
+data:
+	This MSR is available if KVM_FEATURE_SUSPEND_STEAL is present in
+	CPUID. Bit 0 controls whether the host should include the duration it
+	has been suspended in steal time (1), or not (0).
+
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c465bdd6d088a..b35099260aa625 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -932,6 +932,8 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
+		u64 suspend_ts;
+		atomic64_t suspend_ns;
 		struct gfn_to_hva_cache cache;
 	} st;
 
@@ -1028,6 +1030,7 @@ struct kvm_vcpu_arch {
 	} pv_eoi;
 
 	u64 msr_kvm_poll_control;
+	u64 msr_kvm_suspend_steal;
 
 	/* pv related host specific info */
 	struct {
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b10..678ebc3d7eeb55 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -36,6 +36,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_SUSPEND_STEAL	18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -58,6 +59,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_SUSPEND_STEAL	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b2d006756e02a6..983867f243cafc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1614,8 +1614,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
-		if (sched_info_on())
+		if (sched_info_on()) {
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
+			entry->eax |= (1 << KVM_FEATURE_SUSPEND_STEAL);
+		}
 
 		entry->ebx = 0;
 		entry->ecx = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e66bab1a1f56e2..691f46b5e50f27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3753,6 +3753,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	if (unlikely(atomic64_read(&vcpu->arch.st.suspend_ns)))
+		steal += atomic64_xchg(&vcpu->arch.st.suspend_ns, 0);
 	unsafe_put_user(steal, &st->steal, out);
 
 	version += 1;
@@ -4058,6 +4060,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_SUSPEND_STEAL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_SUSPEND_STEAL) ||
+		    !guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
+			return 1;
+
+		if (!(data & KVM_MSR_ENABLED))
+			return 1;
+
+		vcpu->arch.msr_kvm_suspend_steal = data;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -4404,6 +4417,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_SUSPEND_STEAL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_SUSPEND_STEAL))
+			return 1;
+		msr_info->data = vcpu->arch.msr_kvm_suspend_steal;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -7006,13 +7024,52 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
+	bool kick_vcpus = false;
 
-	/*
-	 * Ignore the return, marking the guest paused only "fails" if the vCPU
-	 * isn't using kvmclock; continuing on is correct and desirable.
-	 */
-	kvm_for_each_vcpu(i, vcpu, kvm)
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.msr_kvm_suspend_steal & KVM_MSR_ENABLED) {
+			kick_vcpus = true;
+			WRITE_ONCE(vcpu->arch.st.suspend_ts,
+				   ktime_get_boottime_ns());
+		}
+		/*
+		 * Ignore the return, marking the guest paused only "fails" if
+		 * the vCPU isn't using kvmclock; continuing on is correct and
+		 * desirable.
+		 */
 		(void)kvm_set_guest_paused(vcpu);
+	}
+
+	if (kick_vcpus)
+		kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
+
+	return NOTIFY_DONE;
+}
+
+static int
+kvm_arch_resume_notifier(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u64 suspend_ns = ktime_get_boottime_ns() -
+				 vcpu->arch.st.suspend_ts;
+
+		WRITE_ONCE(vcpu->arch.st.suspend_ts, 0);
+
+		/*
+		 * Only accumulate the suspend time if suspend steal-time is
+		 * enabled, but always clear suspend_ts and kick the vCPU as
+		 * the vCPU could have disabled suspend steal-time after the
+		 * suspend notifier grabbed suspend_ts.
+		 */
+		if (vcpu->arch.msr_kvm_suspend_steal & KVM_MSR_ENABLED)
+			atomic64_add(suspend_ns, &vcpu->arch.st.suspend_ns);
+
+		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
 
 	return NOTIFY_DONE;
 }
@@ -7023,6 +7080,9 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		return kvm_arch_suspend_notifier(kvm);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return kvm_arch_resume_notifier(kvm);
 	}
 
 	return NOTIFY_DONE;
@@ -11212,6 +11272,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * During host SUSPEND/RESUME tasks get frozen after SUSPEND notifiers
+	 * run, and thawed before RESUME notifiers, i.e. vCPUs can be actively
+	 * running when KVM sees the system as suspended.  Block the vCPU if
+	 * KVM sees the vCPU as suspended to ensure the suspend steal time is
+	 * accounted before the guest can run, and to the correct guest task.
+	 */
+	if (READ_ONCE(vcpu->arch.st.suspend_ts))
+		return false;
+
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
 }
-- 
2.50.0.727.gbf7dc18ff4-goog


