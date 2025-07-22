Return-Path: <kvm+bounces-53077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2850CB0D170
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C4BA544E4D
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6743929188C;
	Tue, 22 Jul 2025 05:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zEmZgSqg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC528FFE6
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 05:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753163450; cv=none; b=mSw8U3CTgcfthGOaCFUZt2eVBZ1HULH7C8+y3WqjGsnZy0cImhcEiYW4TdztQIiIRCD05EM4Hx4jjslxmYvLJiyvak5uiZ/e3PUBi9H0lRTSXzaIQw/JReVhZBxOCeuR72qV2GzmgsQmoF/eUkCubsqpkuo7SKLDYYXGM2dcziE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753163450; c=relaxed/simple;
	bh=rZeBNVhCb6ccSjimPPljnNXPjv5gKEiGcujaRLsgPoQ=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=AMu0FPQNJsESGTHHRIkQPMm2u7+r9WQPYlFh822vxO8YGREYLNANIFBg9vxjM4UJfzl5R2WHlIdCpbDNgkN5ugPmNLJiXbFy6VfRr+aejqbzj0WK9IwXp1qHQE6vDI5NQsSX9fVmarOw8E4iQ0kGkrJ6IODrVPHlpnXHFChOqPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zEmZgSqg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e819e8eb985so6396880276.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 22:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753163448; x=1753768248; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CwznA19PRum1QeHsT62Slfw8h/DfNulA6Z3eT71J628=;
        b=zEmZgSqgQamufEPvVf+Ti00rePAojpjL0hW1/VcHXKlPKJndr1Xqcz8nhf4FxcELhB
         Uc8azNDHf+MjeqKvWDyl0ICHsUcGDmS8wdnyaZQm8qV3P5CHpvhD2HwQ2mFV+NlzHPiL
         tf9eH2SYItncj+2niedI+nKtAVnbvW8ChiwfTYRHreASXoEyfNAdNrCJEmoLevH553GT
         tHIWVWB6NeR/CJYhXNaGSUne83NAIPz/esFv0EbiJLTFKhuQG6A9sD+SzR6evGt6z2uu
         7ERImAWloGJKGqALCuAJLMecAWyUTXOxmQtaykO/rXXAWNvjy1Nmh3UtFlMMhV0DXHZD
         LvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753163448; x=1753768248;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwznA19PRum1QeHsT62Slfw8h/DfNulA6Z3eT71J628=;
        b=WUldGcRcrDMmSaTYMJNvv+TNmfSFWeMis73j37NY3mTBJZWrLzTNe4BDZHo6BssMb6
         vgqvL7CeDskl0wTraTqY3zC4gXZfFefZT3Cn9FWt1MpsuwKZCYj3PG11jS2Y+mgyrYxH
         N7ES3sXZtw51x9JRrLZ67d3ksfPqXMp48UFj3FDCvAxToymm/Sh0uR/G0aHX2EoRMPgS
         U8xcjEr9adeh3dIptUX03Fa5y/1HrD2d6f2wo3hz6II6V3yAfB9nMT5KbLTL9wvhmSyW
         os9iuFMseVFGvSieoEsW3/t+XHjXAJ15E+8hrmGgDkC/CgeZBtILOuNg97G67bOEtXj3
         xGTw==
X-Forwarded-Encrypted: i=1; AJvYcCV/HKdkGtvD7Q/EMOzrpBY3Q4n74CstQsADpnj0oKenLldy2yJhKwy7IYrFJ1NaKfVjauw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVlhA2VMwejijl1hL+dVVZ7XVZJqjfYqAn7KokwGc+knfysXFo
	gZ7Wr8x7AmWWw2R00EYV/j5LwyGE1GnrZ650+xLSVVm6iKj12NiFiNe6rsA/iP3xKye3FL3BiXL
	k/C1M6xZ5Lg/o4w==
X-Google-Smtp-Source: AGHT+IF8le2uYW9nAUBEYPBsA2ijEf5SGga5Xt7Pm5nTyIxPwSjfwaM+fxxRiBZ3N59mAkkk8JpMMZaW274ezw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:eafa:b5d9:dc1:d7b1])
 (user=suleiman job=sendgmr) by 2002:a25:6f45:0:b0:e82:e80:9cbb with SMTP id
 3f1490d57ef6-e8bc23f57c1mr5879276.3.1753163447313; Mon, 21 Jul 2025 22:50:47
 -0700 (PDT)
Date: Tue, 22 Jul 2025 14:50:29 +0900
In-Reply-To: <20250722055030.3126772-1-suleiman@google.com>
Message-Id: <20250722055030.3126772-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722055030.3126772-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v8 2/3] KVM: x86: Include host suspended duration in steal time
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
 Documentation/virt/kvm/x86/msr.rst   | 14 +++++
 arch/x86/include/asm/kvm_host.h      |  3 ++
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kvm/cpuid.c                 |  4 +-
 arch/x86/kvm/x86.c                   | 80 ++++++++++++++++++++++++++--
 6 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/x86/cpuid.rst b/Documentation/virt/kvm/x86/cpuid.rst
index bda3e3e737d7..71b42b649973 100644
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
index 3aecf2a70e7b..7c33f9ee11f5 100644
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
@@ -388,3 +394,11 @@ data:
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
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e57d51e9f2be..eeb63852f062 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -933,6 +933,8 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
+		u64 suspend_ts;
+		atomic64_t suspend_ns;
 		struct gfn_to_hva_cache cache;
 	} st;
 
@@ -1029,6 +1031,7 @@ struct kvm_vcpu_arch {
 	} pv_eoi;
 
 	u64 msr_kvm_poll_control;
+	u64 msr_kvm_suspend_steal;
 
 	/* pv related host specific info */
 	struct {
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..678ebc3d7eeb 100644
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
index f84bc0569c9c..2ba85f208f87 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1621,8 +1621,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index 422c7fcc5d83..655fc85ab942 100644
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
@@ -7027,13 +7045,52 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
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
@@ -7044,6 +7101,9 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		return kvm_arch_suspend_notifier(kvm);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return kvm_arch_resume_notifier(kvm);
 	}
 
 	return NOTIFY_DONE;
@@ -11233,6 +11293,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
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


