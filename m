Return-Path: <kvm+bounces-46619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B83AB7AC5
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:54:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CE6A4C54E1
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9552248191;
	Thu, 15 May 2025 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QC1+JnJm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104FF2153D8
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747270448; cv=none; b=lnirSk3nTMrXMK2w0rfypxqhoeTD0W0gaengKQbImzaAteByM1RPNprBdxUmf7psIap1odrZyCmWRq9loeZiyujeTqTik/GQ3q9gu6XT1WWX98pKMhbJd0Kc1zBlTJ+vkvGg0XUgLrFDWxJq+a4gJWODvg6tBNcJI6z6QwqWbKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747270448; c=relaxed/simple;
	bh=u5oZXevbnX/9z6vBr1WwMKfk8rjr07ZF+bDdG85zww4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0BxkrVrU8vRwXJsDSINiuJkMa9HireMlLYs3YfrB6HthfD7O6QNUFlj1l164bUfKy2aYjnVE/wvWpu5v5oDFQ8S7uLTgL4I2GMywpmqw6DuKhjlgylrN29Sv45dGHmr3/z65sxO9MqUZM4yklR/OhlFqmyqpRo775BxvftYq9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QC1+JnJm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747270445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=loRzoyFqEoIxiJn3hBOOoS35PfoCjxFXDtOnBEiQYdY=;
	b=QC1+JnJm8Yn/tLOiwvsnJtg76VPNJyM560+yDYxec0T5kx4wsuzjvF8rJMHc+tTb5hyw1m
	FpmCkpl742P+/jFmXTk0RHaUJ5xA1zqauJmuHFo4Boa83SZTd16Kwo25TyJkEFuNzYWkGn
	fQXpKOYGEq1+/qA4aqYqoPhpnwX7CcM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-VH07epknPuauxmmqMCATFA-1; Wed,
 14 May 2025 20:54:02 -0400
X-MC-Unique: VH07epknPuauxmmqMCATFA-1
X-Mimecast-MFC-AGG-ID: VH07epknPuauxmmqMCATFA_1747270441
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0B99180034E;
	Thu, 15 May 2025 00:53:59 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F89319560AD;
	Thu, 15 May 2025 00:53:57 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 1/4] KVM: x86: Convert vcpu_run()'s immediate exit param into a generic bitmap
Date: Wed, 14 May 2025 20:53:50 -0400
Message-ID: <20250515005353.952707-2-mlevitsk@redhat.com>
In-Reply-To: <20250515005353.952707-1-mlevitsk@redhat.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Sean Christopherson <seanjc@google.com>

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
index ed9b65785a24..c04f73cf062f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1670,6 +1670,10 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+enum kvm_x86_run_flags {
+	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+};
+
 struct kvm_x86_ops {
 	const char *name;
 
@@ -1751,7 +1755,7 @@ struct kvm_x86_ops {
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
 	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu,
-						  bool force_immediate_exit);
+						  u64 run_flags);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc1c721ba067..c8b8a9947057 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4259,9 +4259,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
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
index 94d5d907d37b..a8e80d66e77a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -176,12 +176,12 @@ static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
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
index ef2d7208dd20..609563da270c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7324,8 +7324,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 6bf8be570b2e..e1dfacd6b41f 100644
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
@@ -132,7 +132,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
-fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 844e81ee1d96..25de78cdab42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10752,6 +10752,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
+	u64 run_flags;
 
 	bool req_immediate_exit = false;
 
@@ -10996,8 +10997,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
@@ -11034,8 +11038,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
-		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu,
-						       req_immediate_exit);
+		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu, run_flags);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -11047,6 +11050,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		run_flags = 0;
+
 		/* Note, VM-Exits that go down the "slow" path are accounted below. */
 		++vcpu->stat.exits;
 	}
-- 
2.46.0


