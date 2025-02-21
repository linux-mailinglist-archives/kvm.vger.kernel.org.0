Return-Path: <kvm+bounces-38833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F540A3EC49
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 06:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A93023AD84C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 05:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E797E1FCFDC;
	Fri, 21 Feb 2025 05:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ek1+WTmp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A61FCD1A
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 05:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740116629; cv=none; b=bW6WKRoqn8KyLaNCo6lgyz9qe3csAFfU4yKZWX895TaDpsjerdYNUfGcqEtCoXoTVpALn6fGRoDCBrbWUbyyQMbZpbtYvsOOpFNdzPr+JUNEPHx9PnMDsLPK1CIu4FzVttama0nCIy9Ts2XrfubmP2fLaPbvHyKlfTJKwFDuzOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740116629; c=relaxed/simple;
	bh=9td+5QAFlDQ4gS9R+li+mHECumkPC5BadWWw5yxsMOg=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=OOF1/FaSYDEr1YEBPH/7HFNHIVGiAEysIWicx+ez4S8c7HlXd6vsBoPHAj16hhjU7zLsjfftWf8jJGZc8EWPsLaihKJKh/Hqo9iMGUj/G+MppHXhomGH7EWq2FjxDiRD86aC9HjUzHTf0UmkcE2CW6r35XUOLu2TwsIyMLGXw18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ek1+WTmp; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6fb44dbccbaso17796527b3.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 21:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740116626; x=1740721426; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nSP5h6VjVASnPaTv8FDkwmXUQfe0K3qH38hMzi1K7BE=;
        b=ek1+WTmpSxjjdNW+oiLG9PA+gcJm/TjUca6AF910W0mY20rYG7QiXptOJf7uuew6ML
         1WqdijCyJ4SJ3t6IbRtJtWZTZBldW4mkhz3JulsEpFOOdaAdNU8Ep7m1ROox3dqJ+as8
         LZ5fMiijaLexV/aABjdUjOju/uqf9KC9oW17j8tGR9pmZ+URKsJQxYjpOqUJpKUmXZp6
         7md1cfNHcUm2M93QO5XnPMd6geWuv1z0f6xw/WlND/iM2jTKS2GiAg1h2NX0S4zVDdOm
         2PL3JRnRHEWMzG9FbLMW6So4D95hWwOTpo31CfWtpF2cwJld6UWovQLC8FdULZ7zjOCg
         3zOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740116626; x=1740721426;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nSP5h6VjVASnPaTv8FDkwmXUQfe0K3qH38hMzi1K7BE=;
        b=F2irYEkukQD9d97gNHophP05wC9QfnJblUZClOWYkC2GAa9PIoNF6Q77CiPWdLoUum
         bQ7K0vrQXuNeU6Z+AoP/Ee7QTuL+hEhC6D75yTsrTC22IFc5lWAB9uVjgoFM+39qL++K
         qV1oeEwvJ5i0pB3kJpz1AyN1bparxzSNs6b4ya5vXWa3n/Svh4RjoSw0LWVnpzbiDmqP
         3Cw2f26t90PR1OYJp/qr6P3zfavMekaCymyq7S6RyE1k9yG3IPoFchxYZAA/4tHIB3tz
         odb7fGcFkkrvj3tiuxwdrLtlaie35AkoDMUINF32OpKRLvWt9ch4DFI7qS/acUjprRTK
         760A==
X-Forwarded-Encrypted: i=1; AJvYcCUalwe3s2FUy7aXy5aJorSAihB4RFyMqr4vbJ6NbjPjsX5PfNnbcVTjr92K4k6subbmsTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9eAq+2CiEDSVvdx4DgjVIarDDmh/LP5p0oLEsbqLx3pMESD20
	qdoehvYw7/vDHQzH6Z/G7VnymfbYMezkuQA5qZ5nBKqUThKssiCw0kvbqGtDuEw+qD2vFLrjE4L
	94o+e8tlBrg==
X-Google-Smtp-Source: AGHT+IH41sWcdZJzGHIKN+Pi59JJZfBB57XJubRsl3TsNOq0mHwvuiN0Jgu/0NLERFKNmalTV7pevEwHAss34w==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:62aa:45ca:6f53:8c2a])
 (user=suleiman job=sendgmr) by 2002:a0d:d383:0:b0:6eb:ac7:b4bc with SMTP id
 00721157ae682-6fbcc1f8586mr2147317b3.2.1740116626397; Thu, 20 Feb 2025
 21:43:46 -0800 (PST)
Date: Fri, 21 Feb 2025 14:39:27 +0900
In-Reply-To: <20250221053927.486476-1-suleiman@google.com>
Message-Id: <20250221053927.486476-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221053927.486476-1-suleiman@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Subject: [PATCH v4 2/2] KVM: x86: Include host suspended time in steal time
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling.

To mitigate this issue, the time that the host was suspended is included
in steal time, which lets the guest can subtract the duration from the
tasks' runtime.

In order to implement this behavior, once the suspend notifier fires,
vCPUs trying to run block until the resume notifier finishes. This is
because the freezing of userspace tasks happens between these two points,
which means that vCPUs could otherwise run and get their suspend steal
time misaccounted, particularly if a vCPU would run after resume before
the resume notifier.
Incidentally, doing this also addresses a potential race with the
suspend notifier setting PVCLOCK_GUEST_STOPPED, which could then get
cleared before the suspend actually happened.

One potential caveat is that in the case of a suspend happening during
a VM migration, the suspend time might not be accounted.
A workaround would be for the VMM to ensure that the guest is entered
with KVM_RUN after resuming from suspend.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 Documentation/virt/kvm/x86/msr.rst | 10 ++++--
 arch/x86/include/asm/kvm_host.h    |  6 ++++
 arch/x86/kvm/x86.c                 | 51 ++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 3aecf2a70e7b43..48f2a8ca519548 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -294,8 +294,14 @@ data:
 
 	steal:
 		the amount of time in which this vCPU did not run, in
-		nanoseconds. Time during which the vcpu is idle, will not be
-		reported as steal time.
+		nanoseconds. This includes the time during which the host is
+		suspended. Time during which the vcpu is idle, might not be
+		reported as steal time. The case where the host suspends
+		during a VM migration might not be accounted if VCPUs aren't
+		entered post-resume, because KVM does not currently support
+		suspend/resuming the associated metadata. A workaround would
+		be for the VMM to ensure that the guest is entered with
+		KVM_RUN after resuming from suspend.
 
 	preempted:
 		indicate the vCPU who owns this struct is running or
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 452dd0204609af..007656ceac9a71 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -124,6 +124,7 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_WAIT_FOR_RESUME		KVM_ARCH_REQ(35)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -916,8 +917,13 @@ struct kvm_vcpu_arch {
 
 	struct {
 		u8 preempted;
+		bool host_suspended;
 		u64 msr_val;
 		u64 last_steal;
+		u64 last_suspend;
+		u64 suspend_ns;
+		u64 last_suspend_ns;
+		wait_queue_head_t resume_waitq;
 		struct gfn_to_hva_cache cache;
 	} st;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 06464ec0d1c8d2..f34edcf77cca0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3717,6 +3717,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	steal += vcpu->arch.st.suspend_ns - vcpu->arch.st.last_suspend_ns;
+	vcpu->arch.st.last_suspend_ns = vcpu->arch.st.suspend_ns;
 	unsafe_put_user(steal, &st->steal, out);
 
 	version += 1;
@@ -6930,6 +6932,19 @@ long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
 }
 #endif
 
+static void wait_for_resume(struct kvm_vcpu *vcpu)
+{
+	wait_event_interruptible(vcpu->arch.st.resume_waitq,
+	    vcpu->arch.st.host_suspended == 0);
+
+	/*
+	 * This might happen if we blocked here before the freezing of tasks
+	 * and we get woken up by the freezer.
+	 */
+	if (vcpu->arch.st.host_suspended)
+		kvm_make_request(KVM_REQ_WAIT_FOR_RESUME, vcpu);
+}
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 static int kvm_arch_suspend_notifier(struct kvm *kvm)
 {
@@ -6939,6 +6954,19 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu->arch.st.last_suspend = ktime_get_boottime_ns();
+		/*
+		 * Tasks get thawed before the resume notifier has been called
+		 * so we need to block vCPUs until the resume notifier has run.
+		 * Otherwise, suspend steal time might get applied too late,
+		 * and get accounted to the wrong guest task.
+		 * This also ensures that the guest paused bit set below
+		 * doesn't get checked and cleared before the host actually
+		 * suspends.
+		 */
+		vcpu->arch.st.host_suspended = 1;
+		kvm_make_request(KVM_REQ_WAIT_FOR_RESUME, vcpu);
+
 		if (!vcpu->arch.pv_time.active)
 			continue;
 
@@ -6954,12 +6982,32 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 	return ret ? NOTIFY_BAD : NOTIFY_DONE;
 }
 
+static int kvm_arch_resume_notifier(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu->arch.st.host_suspended = 0;
+		vcpu->arch.st.suspend_ns += ktime_get_boottime_ns() -
+		    vcpu->arch.st.last_suspend;
+		wake_up_interruptible(&vcpu->arch.st.resume_waitq);
+	}
+	mutex_unlock(&kvm->lock);
+
+	return NOTIFY_DONE;
+}
+
 int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 {
 	switch (state) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		return kvm_arch_suspend_notifier(kvm);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return kvm_arch_resume_notifier(kvm);
 	}
 
 	return NOTIFY_DONE;
@@ -10813,6 +10861,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 1;
 			goto out;
 		}
+		if (kvm_check_request(KVM_REQ_WAIT_FOR_RESUME, vcpu))
+			wait_for_resume(vcpu);
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
 		if (kvm_check_request(KVM_REQ_PMU, vcpu))
@@ -12341,6 +12391,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (r)
 		goto free_guest_fpu;
 
+	init_waitqueue_head(&vcpu->arch.st.resume_waitq);
 	kvm_xen_init_vcpu(vcpu);
 	vcpu_load(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
-- 
2.48.1.601.g30ceb7b040-goog


