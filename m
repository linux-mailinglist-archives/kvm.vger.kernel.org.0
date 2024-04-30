Return-Path: <kvm+bounces-16267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DFD8B8095
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 21:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 695671C23454
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 19:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7C81BED6B;
	Tue, 30 Apr 2024 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jvgm67M5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DB71A0B1E
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 19:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505528; cv=none; b=bTHrCaOLyxelBcV4Mqrlukvizg60GGaVJJ6UCdqF0y36tNjpTL8n2d8lzIYSQl5qcEaAFfPqt6D0XPNBlO4146rlAqxqQxJoO6tag+JA2V/xWlj2ORHPo5MNYPJp7dq5mw0SOKGyR+iSnLFJpz+HD+HovQd21r8QBNw9DqW/l5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505528; c=relaxed/simple;
	bh=FEbQRNE7DhZ1nKpbUCJKYi/7wNlFoTDp0Qkei3Not9k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pFfZEgTyfnz0YKKaqcFtU/RF/LFEHlUqAtJxszQe0rHfRsuWsMBcbFE4h0x03ZF8lU3K90gEOn4WEuiMOgVR+do+2d+cK5cek9c+6bgWt9sq3n/At9drdM8yAM8zAaQiWmTdIpv4c+w0AcfXqrOScw3UXMFtijN/9qLQiygUir4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jvgm67M5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dbddee3694so109275a12.1
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 12:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714505527; x=1715110327; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PdYsGD+f0Q3EGFqlo7iVC6xHcnKlviVz/6wVcPE0mCU=;
        b=Jvgm67M5PDjKapp/eKhXa8U3s2PM3YlE3kX1dsvskJy5OGxyfQO7CBKEJs+icDG2wU
         phRwCkqt0tQmYrEln9xFOW01knweUKzhZA/WCm/SSv3fFR3zZRUBAY1z+qpvDxphOi9m
         bR6dqE/aRJsm2iflUgwt57qAEviyUcNnGFEBVRHC8D/UPcmv5Rd1tcGGvcKPSemUj7Cx
         Y5FyV4jvTazrTMNQv3f7giyJJ1ol4Bgfujs8jD9DUEQM9VPeVuqas/EiUUnNlkhynzZm
         ubYfko87YxYFkxltG1XKqKvdlNny41V0ajAE0srPDKRlJ4r3SqStOGkbOKtdsKnCZMMb
         HgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714505527; x=1715110327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PdYsGD+f0Q3EGFqlo7iVC6xHcnKlviVz/6wVcPE0mCU=;
        b=AKQdRJhUMXQNtAHhGu4QS8WPmnL5QXS0WAhUe7mnfS+/pHXTP4TbG/gZRX4UByq3NC
         rPu8WjSWIFNi99aB43o5seze4rLxeBJxLEV3P037RsQX+M7BUsUj2T4t1iUQv6bz2gRF
         3RZ0hmhxZ6AP3jxKDx3SofuTNbTd649KU2SFKNRL5uaqGYxusHD7m1qAELJTQ4zODJ+k
         YF960x5goUccgWI0GGz2YZKMBLhF4i2LSGjbYoTOb5TqBUXz654cbekLELQc060XguhH
         Ozvi3BEdxgVbuwbeQ3lKffqJX0Wnz7ucZ/v5TgqZDHx0Fh8FdmHAE0t3ZGB5UyZOEK5p
         bcxg==
X-Forwarded-Encrypted: i=1; AJvYcCVzeeKFPSSDsDknFKZ+miGjvfZqg2yKDj/jTPHV06CRPwoqnyXEMFa5wHhsBQWq79EzJ++TOGydfdruefXQPyDss6Uw
X-Gm-Message-State: AOJu0YyVbwPcQt7cuVK27IxxaV1nmGE0+L7XJ0ubiybPVLcevFXSW0ef
	StByuyWSzKwdSD8pz+mASBzx2TYpLeZh5+mJycnLBcGojj9+XRhQxZX+37sOuSdiwzGDF6NQVSk
	Eng==
X-Google-Smtp-Source: AGHT+IFxEJGJNoBZFDDOGsKBZH3KCgZUJ/MpHfYduLX06CrOeWsHzYm0K/UuUin+BCjJtD8xU9kINTkYCM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a8:b0:5f0:7fc6:83a7 with SMTP id
 by40-20020a056a0205a800b005f07fc683a7mr13378pgb.0.1714505525717; Tue, 30 Apr
 2024 12:32:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Apr 2024 12:31:56 -0700
In-Reply-To: <20240430193157.419425-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430193157.419425-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430193157.419425-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fold the guts of kvm_arch_sched_in() into kvm_arch_vcpu_load(), keying
off the recently added @sched_in as appropriate.

Note, there is a very slight functional change, as PLE shrink updates will
now happen after blasting WBINVD, but that is quite uninteresting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  4 +---
 arch/x86/kvm/svm/svm.c             | 13 ++++---------
 arch/x86/kvm/vmx/main.c            |  2 --
 arch/x86/kvm/vmx/vmx.c             | 11 ++++-------
 arch/x86/kvm/vmx/x86_ops.h         |  3 +--
 arch/x86/kvm/x86.c                 | 19 +++++++++++--------
 7 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5187fcf4b610..910d06cdb86b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -103,7 +103,6 @@ KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP(sched_in)
 KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
 KVM_X86_OP_OPTIONAL(vcpu_blocking)
 KVM_X86_OP_OPTIONAL(vcpu_unblocking)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01c69840647e..9fd1ec82303d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1624,7 +1624,7 @@ struct kvm_x86_ops {
 	void (*vcpu_reset)(struct kvm_vcpu *vcpu, bool init_event);
 
 	void (*prepare_switch_to_guest)(struct kvm_vcpu *vcpu);
-	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
+	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu, bool sched_in);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
@@ -1746,8 +1746,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
-
 	/*
 	 * Size of the CPU's dirty log buffer, i.e. VMX's PML buffer.  A zero
 	 * value indicates CPU dirty logging is unsupported or disabled.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a..6d9763dc4fed 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1539,11 +1539,14 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 	to_svm(vcpu)->guest_state_loaded = false;
 }
 
-static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
+	if (sched_in && !kvm_pause_in_guest(vcpu->kvm))
+		shrink_ple_window(vcpu);
+
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
 
@@ -4548,12 +4551,6 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		vcpu->arch.at_instruction_boundary = true;
 }
 
-static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-	if (!kvm_pause_in_guest(vcpu->kvm))
-		shrink_ple_window(vcpu);
-}
-
 static void svm_setup_mce(struct kvm_vcpu *vcpu)
 {
 	/* [63:9] are reserved. */
@@ -5013,8 +5010,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
 
-	.sched_in = svm_sched_in,
-
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_interrupt = svm_deliver_interrupt,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7c546ad3e4c9..4fee9a8cc5a1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -121,8 +121,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.sched_in = vmx_sched_in,
-
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cb36db7b6140..ccea594187c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1505,10 +1505,13 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (sched_in && !kvm_pause_in_guest(vcpu->kvm))
+		shrink_ple_window(vcpu);
+
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
@@ -8093,12 +8096,6 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
-void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-	if (!kvm_pause_in_guest(vcpu->kvm))
-		shrink_ple_window(vcpu);
-}
-
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 502704596c83..b7104a5f623e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -23,7 +23,7 @@ int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 void vmx_vcpu_free(struct kvm_vcpu *vcpu);
 void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
-void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in);
 void vmx_vcpu_put(struct kvm_vcpu *vcpu);
 int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath);
 void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
@@ -112,7 +112,6 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_request_immediate_exit(struct kvm_vcpu *vcpu);
-void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu);
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_X86_64
 int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 925cadb18b55..9b0a21f2e56e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5005,6 +5005,16 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (sched_in) {
+		vcpu->arch.l1tf_flush_l1d = true;
+		if (pmu->version && unlikely(pmu->event_count)) {
+			pmu->need_cleanup = true;
+			kvm_make_request(KVM_REQ_PMU, vcpu);
+		}
+	}
+
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
 		if (static_call(kvm_x86_has_wbinvd_exit)())
@@ -5014,7 +5024,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 					wbinvd_ipi, NULL, 1);
 	}
 
-	static_call(kvm_x86_vcpu_load)(vcpu, cpu);
+	static_call(kvm_x86_vcpu_load)(vcpu, cpu, sched_in);
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
@@ -12569,14 +12579,7 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	vcpu->arch.l1tf_flush_l1d = true;
-	if (pmu->version && unlikely(pmu->event_count)) {
-		pmu->need_cleanup = true;
-		kvm_make_request(KVM_REQ_PMU, vcpu);
-	}
-	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
-- 
2.45.0.rc0.197.gbae5840b3b-goog


