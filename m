Return-Path: <kvm+bounces-45858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6173AAFB79
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 117A41C22894
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076B622B8B6;
	Thu,  8 May 2025 13:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WEVtiQVx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C70F84D13
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711328; cv=none; b=i4MMDG6C7pLhrHAw2Ii4cb4hsezzF0+ArH0NyPj+yoYAoIIno5/zx4VSlpcm4dgQ9uJ/AFrZPdG4w7cqj3HY/UJ5o6gnncSGsmpO7SVFEf2v1Vtt2X+8TgJksTUDRkzXIla7fGZ90FwrL2p46EdN6+5Lf4UMpdYwMVvKsT73ZTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711328; c=relaxed/simple;
	bh=So4f+jJaLPqD+D7bvApVfhV4eSpPtqn3tyyYtKpK7mc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CB/B2bKqL+uCvtUMDVIDn17jSqvCuxNhrjpuSz/A3Cryc62Mjg5BMr2hgXcYRqAIPrKK6umGNoNj9uOPSh4mNhXOzW8ppVqTIlFmPV6mI8645aLAAu4/z1A41Q8lCWMFsXhTQwJCdgHIcMtpk+pZBxnZ+PyLkPjwi52pkzIgAhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WEVtiQVx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22e7e0a86a0so11643625ad.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746711325; x=1747316125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=umXRL51odZ+U28adyG5IqbnLQh785NI+zLPkHmpwwsU=;
        b=WEVtiQVx5EGc2ArbBqlRweIG7s6180by/wZtX6eQz2K4kLwqCxUGQnghG3l+eitmdn
         yTJ4onq7O2aH3mtMKJsGgXPO7xuy/nONg8IiYgoxsSeBJMz9vqcLyx8zru4lucChgYAv
         TrGcJSA/PuaH4hAV1hp8m9un/50SD30TM8z1XRMhO2lO/JnoWHRuUMjkHqDrDrIwb6L1
         1wK3VOpqMz5/aeFIISAR3jb5utDaZ0JRL5L6T5w/OAvwauMO6s0Hajzc/RAQMLawnrdQ
         axovyqMRTNSnFUz5kApbko+nm2jLwm53IlyXrgS19yDcA/WPpG++ryf4Ca1xvZnac20j
         0q0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711325; x=1747316125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=umXRL51odZ+U28adyG5IqbnLQh785NI+zLPkHmpwwsU=;
        b=rLmH7KyzVErBlYz1KVcGwcn31Qn0TOliwsrqvE3bk/r9UPDxcauX0PhgWl5xB+jk6+
         gy7rD/v5gzJdaEacFWgTmIt13p87J3pL9X3JFr3e59WHiHVWzGItLsI4/g+f6rcoq9y3
         xApwmWmaIBj3UfRIH3ametKdPA4bNgU1kcFmsQhWxOAlFcP27WIfXJdQ9f2lHaycomFn
         Mb29XPRhVtXzzh69TfONz5s8mq7HnnCC8kgeLnwKjqgSttag4r9FzAYSPM+Y0bqZFe9P
         D0GKw2j2/17dsLRfFPcd2AFo2U7WI6fDBvZS7k0hKj3FMgmHp/uiot3aXeH3c5rPdzr9
         sPkA==
X-Gm-Message-State: AOJu0YzXdT80lbZ5xWckuAw5uJ8OSbNXWNyHqdyAUvNh9HOdFTde7guk
	wAQ8JWOJm/HirTtO+z4/VKU2/RghOhXCHtIUNqBwjAT7MsTmKevJk+cWK6nILqA04uQA9OBXjKJ
	7wA==
X-Google-Smtp-Source: AGHT+IGujTTizBC2NO5GtsoKrNA2DFFypxeWr+gCQllfmd13bBZQH9bmWcxSzOrS7mlhLhKrB6brjIgvzMA=
X-Received: from plrr12.prod.google.com ([2002:a17:902:c60c:b0:223:225b:3d83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fa7:b0:220:d257:cdbd
 with SMTP id d9443c01a7336-22e8a7fe95cmr50782475ad.48.1746711325460; Thu, 08
 May 2025 06:35:25 -0700 (PDT)
Date: Thu, 8 May 2025 06:35:22 -0700
In-Reply-To: <aBvmxjxUrXEBa3sc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250416002546.3300893-1-mlevitsk@redhat.com> <20250416002546.3300893-4-mlevitsk@redhat.com>
 <aAgpD_5BI6ZcCN29@google.com> <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
 <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com> <aBvmxjxUrXEBa3sc@google.com>
Message-ID: <aByzGilzBiTa-43C@google.com>
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
 while in the guest mode
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="MlINIt/uc2Bhy9cL"


--MlINIt/uc2Bhy9cL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2025, Sean Christopherson wrote:
> On Thu, May 01, 2025, mlevitsk@redhat.com wrote:
> > Any ideas on how to solve this then? Since currently its the common code that
> > reads the current value of the MSR_IA32_DEBUGCTLMSR and it doesn't leave any
> > indication about if it changed I can do either
> > 
> > 1. store old value as well, something like 'vcpu->arch.host_debugctl_old' Ugly IMHO.
> > 
> > 2. add DEBUG_CTL to the set of the 'dirty' registers, e.g add new bit for kvm_register_mark_dirty
> > It looks a bit overkill to me
> > 
> > 3. Add new x86 callback for something like .sync_debugctl(). I vote for this option.
> > 
> > What do you think/prefer?
> 
> I was going to say #3 as well, but I think I have a better idea.
> 
> DR6 has a similar problem; the guest's value needs to be loaded into hardware,
> but only somewhat rarely, and more importantly, never on a fastpath reentry.
> 
> Forced immediate exits also have a similar need: some control logic in common x86
> needs instruct kvm_x86_ops.vcpu_run() to do something.
> 
> Unless I've misread the DEBUGCTLMSR situation, in all cases, common x86 only needs
> to a single flag to tell vendor code to do something.  The payload for that action
> is already available.
> 
> So rather than add a bunch of kvm_x86_ops hooks that are only called immediately
> before kvm_x86_ops.vcpu_run(), expand @req_immediate_exit into a bitmap of flags
> to communicate what works needs to be done, without having to resort to a field
> in kvm_vcpu_arch that isn't actually persistent.
> 
> The attached patches are relatively lightly tested, but the DR6 tests from the
> recent bug[*] pass, so hopefully they're correct?
> 
> The downside with this approach is that it would be difficult to backport to LTS
> kernels, but given how long this has been a problem, I'm not super concerned about
> optimizing for backports.
> 
> If they look ok, feel free to include them in the next version.  Or I can post
> them separately if you want.

And of course I forgot to attach the patches...

--MlINIt/uc2Bhy9cL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-Convert-vcpu_run-s-immediate-exit-param-into.patch"

From edaa5525a228bc8711c4cefca391b436e6b18803 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 7 May 2025 13:46:03 -0700
Subject: [PATCH 1/2] KVM: x86: Convert vcpu_run()'s immediate exit param into
 a generic bitmap

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/svm/svm.c          |  4 ++--
 arch/x86/kvm/vmx/main.c         |  6 +++---
 arch/x86/kvm/vmx/tdx.c          |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/vmx/x86_ops.h      |  4 ++--
 arch/x86/kvm/x86.c              | 11 ++++++++---
 7 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c27f213ea55..62137a777f33 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1673,6 +1673,10 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+enum kvm_x86_run_flags {
+	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+};
+
 struct kvm_x86_ops {
 	const char *name;
 
@@ -1754,7 +1758,7 @@ struct kvm_x86_ops {
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
 	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu,
-						  bool force_immediate_exit);
+						  u64 run_flags);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f8c571cbe7c..79b14fe4e3d8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4311,9 +4311,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	guest_state_exit_irqoff();
 }
 
-static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
-					  bool force_immediate_exit)
+static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..fef3e3803707 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -175,12 +175,12 @@ static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return vmx_vcpu_pre_run(vcpu);
 }
 
-static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
 	if (is_td_vcpu(vcpu))
-		return tdx_vcpu_run(vcpu, force_immediate_exit);
+		return tdx_vcpu_run(vcpu, run_flags);
 
-	return vmx_vcpu_run(vcpu, force_immediate_exit);
+	return vmx_vcpu_run(vcpu, run_flags);
 }
 
 static int vt_handle_exit(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..7dbfad28debc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1020,8 +1020,9 @@ static void tdx_load_host_xsave_state(struct kvm_vcpu *vcpu)
 				DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI | \
 				DEBUGCTLMSR_FREEZE_IN_SMM)
 
-fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	struct vcpu_vt *vt = to_vt(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ff00ae9f05a..e66f5ffa8716 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7317,8 +7317,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b4596f651232..0b4f5c5558d0 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -21,7 +21,7 @@ void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
 int vmx_vcpu_create(struct kvm_vcpu *vcpu);
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
-fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags);
 void vmx_vcpu_free(struct kvm_vcpu *vcpu);
 void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
@@ -133,7 +133,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
-fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75c0a934556d..d2ad83621595 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10777,6 +10777,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
+	u64 run_flags;
 
 	bool req_immediate_exit = false;
 
@@ -11021,8 +11022,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
-	if (req_immediate_exit)
+	run_flags = 0;
+	if (req_immediate_exit) {
+		run_flags |= KVM_RUN_FORCE_IMMEDIATE_EXIT;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	}
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -11059,8 +11063,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
-		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu,
-						       req_immediate_exit);
+		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu, run_flags);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -11072,6 +11075,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		run_flags = 0;
+
 		/* Note, VM-Exits that go down the "slow" path are accounted below. */
 		++vcpu->stat.exits;
 	}

base-commit: 94da2b969670d100730b5537f20523e49e989920
-- 
2.49.0.1015.ga840276032-goog


--MlINIt/uc2Bhy9cL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-Drop-kvm_x86_ops.set_dr6-in-favor-of-a-new-K.patch"

From fdb106317c1a743f79014157c13728ea021ad0b1 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 7 May 2025 14:00:39 -0700
Subject: [PATCH 2/2] KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new
 KVM_RUN flag

Instruct vendor code to load the guest's DR6 into hardware via a new
KVM_RUN flag, and remove kvm_x86_ops.set_dr6(), whose sole purpose was to
load vcpu->arch.dr6 into hardware when DR6 can be read/written directly
by the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             | 10 ++++++----
 arch/x86/kvm/vmx/main.c            |  9 ---------
 arch/x86/kvm/vmx/vmx.c             |  9 +++------
 arch/x86/kvm/x86.c                 |  2 +-
 6 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..9e0c37ea267e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -49,7 +49,6 @@ KVM_X86_OP(set_idt)
 KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
-KVM_X86_OP(set_dr6)
 KVM_X86_OP(set_dr7)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 62137a777f33..18be7835fb73 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1675,6 +1675,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 
 enum kvm_x86_run_flags {
 	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
 };
 
 struct kvm_x86_ops {
@@ -1727,7 +1728,6 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
-	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 79b14fe4e3d8..ffa10c448efa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4360,10 +4360,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
 
 	/*
-	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
-	 * of a #DB.
+	 * Run with all-zero DR6 unless the guest can write DR6 freely, so that
+	 * KVM can get the exact cause of a #DB.  Note, loading guest DR6 from
+	 * KVM's snapshot is only necessary when DR accesses won't exit.
 	 */
-	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
+	if (unlikely(run_flags & KVM_RUN_LOAD_GUEST_DR6))
+		svm_set_dr6(vcpu, vcpu->arch.dr6);
+	else if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
 
 	clgi();
@@ -5171,7 +5174,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
-	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fef3e3803707..c85cbce6d2f6 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -489,14 +489,6 @@ static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 	vmx_set_gdt(vcpu, dt);
 }
 
-static void vt_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	if (is_td_vcpu(vcpu))
-		return;
-
-	vmx_set_dr6(vcpu, val);
-}
-
 static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	if (is_td_vcpu(vcpu))
@@ -943,7 +935,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_idt = vt_op(set_idt),
 	.get_gdt = vt_op(get_gdt),
 	.set_gdt = vt_op(set_gdt),
-	.set_dr6 = vt_op(set_dr6),
 	.set_dr7 = vt_op(set_dr7),
 	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
 	.cache_reg = vt_op(cache_reg),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e66f5ffa8716..49bf58ca9ffd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5604,12 +5604,6 @@ void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	set_debugreg(DR6_RESERVED, 6);
 }
 
-void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	lockdep_assert_irqs_disabled();
-	set_debugreg(vcpu->arch.dr6, 6);
-}
-
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
@@ -7364,6 +7358,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
+	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
+		set_debugreg(vcpu->arch.dr6, 6);
+
 	/*
 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2ad83621595..d8ae62f49bd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11044,7 +11044,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
-			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
+			run_flags |= KVM_RUN_LOAD_GUEST_DR6;
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 	}
-- 
2.49.0.1015.ga840276032-goog


--MlINIt/uc2Bhy9cL--

