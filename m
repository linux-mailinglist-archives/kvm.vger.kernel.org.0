Return-Path: <kvm+bounces-52263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6EDB03502
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 162C83AFBC8
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 03:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6961F099C;
	Mon, 14 Jul 2025 03:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F8cihbEj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DD41F7580
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 03:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752464241; cv=none; b=gOIsz5mxcKwpXSQ8ARLx9WqxAYm5GJ62On6Or4+S4TMwy8dMGpc8fgJgJ37BauTWO0MU1WR5hQ+NxlZJboTtIt66cGhKVfeUC+8MJ+zRs6vKy00M2x+6HGuRL2/K3vDqxdNs9MykLbAd6PpWaQvHArzzFsDKUwARQfu3++UwujI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752464241; c=relaxed/simple;
	bh=bQh6lNTZFxebjSpM1cDa2wcwFwoS/xV7qOP5vuezGjc=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=Cq7stM04lgzE29BPm9nUBXFFxmVVQlUB93zW3Q81aZHq+afCTLdCs3khm9Tuc/RUnRxmALMVbhn5hQJHXBcWAWNUmk7Rgn8byNOwe16NV1+ObwomjqOTlT7TNP5yB4n1eyO1GJNinLYKfpsM7n8Deje+XiyoBGPziGstrhpMXyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F8cihbEj; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e812e1573ecso4354699276.2
        for <kvm@vger.kernel.org>; Sun, 13 Jul 2025 20:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752464239; x=1753069039; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t62AOuxhdPL2QOkp9lsjeQTVTW6/wnmvAqRNuUhfa18=;
        b=F8cihbEj/+EHfQ2bTRBbAi7kA91F7D0loGBWSUrBvbPF7l1igenpVcVTYCJJnZEGhb
         qO9f1F7aJ48WeWsxppuyAHsREcI/hVHI9l16e824MX2oR6V1HQwWHeqAjglLHNdpGBYt
         kIxw/U8Rl/3WX29fh2Vn/rHpCwolvUuzCKwB258sIjZKZvfa3kG3Vdq/Zwx+OqtIPDL3
         07h/cBzLzqjp84UmKUoIGcbM6N13xksGKXGPNJZNLal/n8M7QAmsM9XW8z/6Cu+C/lhO
         n6fHml2+ThhM0nAZYAUmsc10Q1MFVJMRf9+7aPmwPJLDnI7SDg3WJdZcyHqtXOtqWTYU
         AoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752464239; x=1753069039;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t62AOuxhdPL2QOkp9lsjeQTVTW6/wnmvAqRNuUhfa18=;
        b=ABYiQQ15cIk4RhIDR9O+Ivxgk83JgwPdckx53RRSI+Ka4BM964mdWWoXL+IRLB+4Nd
         BcgF42RnXFzIGFdUm5GwZadLbmXc8AxahMdYOLzc2SbIDW8MTYYkJiUukdQGewy+XD6Z
         f0lzMy/mGIfWhD34XKlr1Ok/jElAJGr2qe1UIgm+Z9tGTe8jrJ3QpjEU2oFhpdo0nE3u
         PLnrkm5pQyDFBrgRTcK95Al/72kUg6PJCkNKJZbgJKKDnkHXsWp4IYOVcJ/riLnKwYSQ
         kHm7gwZgd34nMtO1ic22N9EzQGslFfmtykz7fur6XW5rau4aaMSIRbtyAO4AaX11Lm7P
         XXdA==
X-Forwarded-Encrypted: i=1; AJvYcCUrp2tg6p+ZnA9d4+vZ+Cjq8K/YOrZ7W5YuLo/x4FcdWg+fJ/sXDz2qIJ3S3zTvuT9fogI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuFlPqQepnxEOLmlbBioVdxedlWw/XVE3O2XpzcjVqJ1AW8Vzt
	6fhUFIT746O8bDIbedpfjLa8eI18uivbwYw7D9HTKZY8p9SXohKoAaocGxSep3CFndwx/Skz02p
	J0XoY4FaSUE5/hg==
X-Google-Smtp-Source: AGHT+IEy0cYHEfq24aMv4LtmBYySF/u3vZZaiTjH0mJ/mH40FuntnizKzhahMzHk6OD8VcWQug97V1xgogNOag==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:4f90:1ee3:198b:1fe4])
 (user=suleiman job=sendgmr) by 2002:a25:dd41:0:b0:e85:fa6e:f58b with SMTP id
 3f1490d57ef6-e8b8744f0f1mr2731276.9.1752464238272; Sun, 13 Jul 2025 20:37:18
 -0700 (PDT)
Date: Mon, 14 Jul 2025 12:36:48 +0900
In-Reply-To: <20250714033649.4024311-1-suleiman@google.com>
Message-Id: <20250714033649.4024311-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714033649.4024311-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v7 2/3] KVM: x86: Include host suspended duration in steal time
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
index 3650a513ba19..015cf86b4e63 100644
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
index b2d006756e02..983867f243ca 100644
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
index 6539af701016..1535f653f942 100644
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
@@ -7010,13 +7028,52 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
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
@@ -7027,6 +7084,9 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		return kvm_arch_suspend_notifier(kvm);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return kvm_arch_resume_notifier(kvm);
 	}
 
 	return NOTIFY_DONE;
@@ -11216,6 +11276,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
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


