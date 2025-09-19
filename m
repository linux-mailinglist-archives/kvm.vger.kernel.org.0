Return-Path: <kvm+bounces-58215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D44A6B8B6D3
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EAC11896019
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8132D7DC4;
	Fri, 19 Sep 2025 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VE9FRNwG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985912D5C6A
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319182; cv=none; b=J+gauuMlX2u5BbP5qVM5vCyE9efSDtvPkHwwUqh/evQXy0x0vKqvVsO/HWvKiDtZVd79OIno0rD1ERoWIYmeeIt4LsVrqjVxaN6uNJR+M8fG7rJqx/Zu2yY1wGJvUBIlQeuto2TKKQx0ZRbA/YRb3S/MXZbMe2WzPfGoS29nKOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319182; c=relaxed/simple;
	bh=RQ3PokgNbV0Gv5M6U1JqSc97qKGLjGcBZwVmjOv2IRc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OhquFm83Q/p028TlBW4QkaprbqWbPR/HJgrJlHX7nJCsAxO+Aofwe6Yh43FOKi+D7RalAJ+QowUeJh0V856myg38FFwwQZZTdTHOzHXEusMIJDK90DdGaQWQbEhxOzf2ukLwSc0H5NYdu+53ZXHyXgNTEcaN6VxEGM9uX/JHpvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VE9FRNwG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5533921eb2so71883a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758319180; x=1758923980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yYqPxABoTPaNJDx6SWRPJOKUCrdf44wD0jsJ09XZDvs=;
        b=VE9FRNwGR8xaJCEpYidZJBxOHhg25QZGnP1i5I19DLO2RFix3VyL/vK2JBc2Zfwp13
         cOsw+VuA19BOvLLAkfCVWXwQE8lFlrAuJ7q1iX81lP3u6akNQpKrgClN05B4fIzSjdIj
         DGS00kAWsA59wdxHyBFDyEz5scuKcHveclhBM/D0VYKPxUIln39IO33UXfQC7iYmvSam
         ICow+leC+VZw8r2c9d65F7cZvfMXrLWbkL6FgPjnp6xFGd4o93wYO9sSIWIfHNPiMLqP
         qPpJqBD5ivXGlvMPC872Kq8catSM4TIyyKZ81hUOu0R50U2t+FVp/n409DqdIe5CwaYM
         gWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319180; x=1758923980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yYqPxABoTPaNJDx6SWRPJOKUCrdf44wD0jsJ09XZDvs=;
        b=K2aR86Fv+BKAYUw65XP+AvpE6foQ1YVQRTRvuLrbo5ZcJk+zRHDymqTccvnAkB2r/W
         yAt2FIi38Jb0K69LeU8j2LYwrXf521F2XBm80VXPCtMdlaKBpYkdMsyZryB1EZxxGnUu
         TcaTQYDL7SH6Hm4x0TF2T5tG3tgTQ5+OrwWXjjLQmsQ8FzWHriFRMr/gY/PUWmc6SK+u
         gTKxWrwDSJiOSlRM2aEHvD+FSwiqo/WKg7nW9Ut/EPicwFvHvb/yK1bPQMbu4qWe4bGN
         6t2x5GtEnQUQR6zbGnXlwo9wk828mUPzktcjzEim2G4xbmGoJSQZ3CZPgs+48MT9pM5L
         j3PQ==
X-Gm-Message-State: AOJu0YyTvHu0M+cAU4+bHGKUyqFvX94W7tU7f7GBSK5wF4UpHmRbmuZ5
	r8+GUWtRc9tlVRmpYjW50C14Frqtr/gngqQvgoV+Uql8mLCL8vAODn8d9w0j9HmOuJpci8W9sSf
	n3UQoCw==
X-Google-Smtp-Source: AGHT+IF2GlzRRlLPwu2AdlmtuTXRSfA9YHC6dIIJ4HCfrMGqAiiiXwzbataF3vV8lfAxzPEwdCI4IJ88lhs=
X-Received: from pjm8.prod.google.com ([2002:a17:90b:2fc8:b0:32d:df7e:6696])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a20:b0:249:467e:ba6d
 with SMTP id adf61e73a8af0-2925c275613mr7377439637.6.1758319180002; Fri, 19
 Sep 2025 14:59:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:59:29 -0700
In-Reply-To: <20250919215934.1590410-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919215934.1590410-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919215934.1590410-3-seanjc@google.com>
Subject: [PATCH v4 2/7] KVM: SVM: Move x2AVIC MSR interception helper to avic.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Move svm_set_x2apic_msr_interception() to avic.c as it's only relevant
when x2AVIC is enabled/supported and only called by AVIC code.  In
addition to scoping AVIC code to avic.c, this will allow burying the
global x2avic_enabled variable in avic.

Opportunistically rename the helper to explicitly scope it to "avic".

No functional change intended.

Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 57 ++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c  | 49 -----------------------------------
 arch/x86/kvm/svm/svm.h  |  1 -
 3 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a34c5c3b164e..478a18208a76 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -79,6 +79,57 @@ static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 bool x2avic_enabled;
 
+
+static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
+					     bool intercept)
+{
+	static const u32 x2avic_passthrough_msrs[] = {
+		X2APIC_MSR(APIC_ID),
+		X2APIC_MSR(APIC_LVR),
+		X2APIC_MSR(APIC_TASKPRI),
+		X2APIC_MSR(APIC_ARBPRI),
+		X2APIC_MSR(APIC_PROCPRI),
+		X2APIC_MSR(APIC_EOI),
+		X2APIC_MSR(APIC_RRR),
+		X2APIC_MSR(APIC_LDR),
+		X2APIC_MSR(APIC_DFR),
+		X2APIC_MSR(APIC_SPIV),
+		X2APIC_MSR(APIC_ISR),
+		X2APIC_MSR(APIC_TMR),
+		X2APIC_MSR(APIC_IRR),
+		X2APIC_MSR(APIC_ESR),
+		X2APIC_MSR(APIC_ICR),
+		X2APIC_MSR(APIC_ICR2),
+
+		/*
+		 * Note!  Always intercept LVTT, as TSC-deadline timer mode
+		 * isn't virtualized by hardware, and the CPU will generate a
+		 * #GP instead of a #VMEXIT.
+		 */
+		X2APIC_MSR(APIC_LVTTHMR),
+		X2APIC_MSR(APIC_LVTPC),
+		X2APIC_MSR(APIC_LVT0),
+		X2APIC_MSR(APIC_LVT1),
+		X2APIC_MSR(APIC_LVTERR),
+		X2APIC_MSR(APIC_TMICT),
+		X2APIC_MSR(APIC_TMCCT),
+		X2APIC_MSR(APIC_TDCR),
+	};
+	int i;
+
+	if (intercept == svm->x2avic_msrs_intercepted)
+		return;
+
+	if (!x2avic_enabled)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(x2avic_passthrough_msrs); i++)
+		svm_set_intercept_for_msr(&svm->vcpu, x2avic_passthrough_msrs[i],
+					  MSR_TYPE_RW, intercept);
+
+	svm->x2avic_msrs_intercepted = intercept;
+}
+
 static void avic_activate_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -99,7 +150,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
 		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
 		/* Disabling MSR intercept for x2APIC registers */
-		svm_set_x2apic_msr_interception(svm, false);
+		avic_set_x2apic_msr_interception(svm, false);
 	} else {
 		/*
 		 * Flush the TLB, the guest may have inserted a non-APIC
@@ -110,7 +161,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 		/* For xAVIC and hybrid-xAVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
-		svm_set_x2apic_msr_interception(svm, true);
+		avic_set_x2apic_msr_interception(svm, true);
 	}
 }
 
@@ -130,7 +181,7 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
 		return;
 
 	/* Enabling MSR intercept for x2APIC registers */
-	svm_set_x2apic_msr_interception(svm, true);
+	avic_set_x2apic_msr_interception(svm, true);
 }
 
 /* Note:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8117d79036bb..a70d3c0d65da 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -736,55 +736,6 @@ static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 		svm_set_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW, intercept);
 }
 
-void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
-{
-	static const u32 x2avic_passthrough_msrs[] = {
-		X2APIC_MSR(APIC_ID),
-		X2APIC_MSR(APIC_LVR),
-		X2APIC_MSR(APIC_TASKPRI),
-		X2APIC_MSR(APIC_ARBPRI),
-		X2APIC_MSR(APIC_PROCPRI),
-		X2APIC_MSR(APIC_EOI),
-		X2APIC_MSR(APIC_RRR),
-		X2APIC_MSR(APIC_LDR),
-		X2APIC_MSR(APIC_DFR),
-		X2APIC_MSR(APIC_SPIV),
-		X2APIC_MSR(APIC_ISR),
-		X2APIC_MSR(APIC_TMR),
-		X2APIC_MSR(APIC_IRR),
-		X2APIC_MSR(APIC_ESR),
-		X2APIC_MSR(APIC_ICR),
-		X2APIC_MSR(APIC_ICR2),
-
-		/*
-		 * Note!  Always intercept LVTT, as TSC-deadline timer mode
-		 * isn't virtualized by hardware, and the CPU will generate a
-		 * #GP instead of a #VMEXIT.
-		 */
-		X2APIC_MSR(APIC_LVTTHMR),
-		X2APIC_MSR(APIC_LVTPC),
-		X2APIC_MSR(APIC_LVT0),
-		X2APIC_MSR(APIC_LVT1),
-		X2APIC_MSR(APIC_LVTERR),
-		X2APIC_MSR(APIC_TMICT),
-		X2APIC_MSR(APIC_TMCCT),
-		X2APIC_MSR(APIC_TDCR),
-	};
-	int i;
-
-	if (intercept == svm->x2avic_msrs_intercepted)
-		return;
-
-	if (!x2avic_enabled)
-		return;
-
-	for (i = 0; i < ARRAY_SIZE(x2avic_passthrough_msrs); i++)
-		svm_set_intercept_for_msr(&svm->vcpu, x2avic_passthrough_msrs[i],
-					  MSR_TYPE_RW, intercept);
-
-	svm->x2avic_msrs_intercepted = intercept;
-}
-
 void svm_vcpu_free_msrpm(void *msrpm)
 {
 	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1652a868c578..37a7f5059a11 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -701,7 +701,6 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write);
-void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 
-- 
2.51.0.470.ga7dc726c21-goog


