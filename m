Return-Path: <kvm+bounces-58076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0595B8775C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:22:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B98D61766E3
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D421024166E;
	Fri, 19 Sep 2025 00:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Co6YmxRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9901F8723
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241302; cv=none; b=iMUlCP8XRYyRD0NI0hhoUpg/TXszsJGz/JHQ5ELAf2/Q8aMtmuFio/mJavCT8S3+50BDDSjJdFoo9nSyBIj0x3V1DWctZBymPrxAPzX1BNkA0QwxFbAepMQ1vWgPrBRrTCYTSEyQCqKfkDvixIN8im6ERO3W+iyDwZ5fy5sV16U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241302; c=relaxed/simple;
	bh=/XQgV9lw0lISZp958KTVvYPoycL/V0iemplIXqSLSwE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eRb33iJOdX6rAg0vHyfDa460QAJzaVU8/GAO6QIKypIf9oB7khafiyrMlvzxICr61v+xfLCTbuhsVLq68k6KH1UIHuRA5OrEPlgumgw1MejqvTb9Ckt4vtmVuGvoXcreCoGZkZB56eEgK0LbRb4e3XJTaUeHSLHD7BzktqtQHJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Co6YmxRO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7779219ccc2so1772035b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241301; x=1758846101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VT6pMOa7Bss0kSmnUFjjTDbwGWcOEihwse0RPF9AM0Y=;
        b=Co6YmxRO17XWkuLfGIGOHZ7J1p0ePfyrSXkyNe0UWxQmtAxUfpDILJX0lEg+yPq4GQ
         UZx9S86+qdGWpUJRxP4OwMeqT2zO2b4VOZMIhtI3KGF0LhLe5CJPbH8zwYrL5ZoP9zKB
         jbPOAlg/il5XQ096PrRoXKBJ16xCC456AmfcO1OZAr5ilw7ERbkr0inN/YHGoKtqs1kk
         L/VBSn5N+UyTVN4vO6QukHC+qdUVFg4NdCXzD4CnfRxSlR0/nSaJS21OxN88JGJKR7f7
         UtHKWY9W8SUZPj0ISJLBo0yMlJeb73ecZx/gtMyoGxvPLWnQ4AZbkxDSVMSfA54ZeJRD
         Fz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241301; x=1758846101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VT6pMOa7Bss0kSmnUFjjTDbwGWcOEihwse0RPF9AM0Y=;
        b=M7T7+BFBokn09oqHCSHgIm+tzpdXJWw0uccHLNoyj8fzBcxM93Jkngl8//JG3zJHqd
         DtCx30q+GxLURe6wCRJospsi23vMXzSeYdYAyuskelyI1CC2cPDd222bmoXrxblaIWUi
         i8WnatV9pq8WfahQdi4kWeyNPqXu601gMmLB1D4yyaTVzEEKLMgNdDJtZVFChlaEjKhA
         nt1sAnvnBi9GALG65Ra7vfu/FM80IorargQRnD+hzh5awoPYLy5rPXxLGucD9lCYtSwU
         wR7dHeG6w5ax3S3wvCXI4DUlHHn/0mAwtg5l8I0m4H3WpZzhcChwbzW0/B19kmfP8oL5
         WYKw==
X-Gm-Message-State: AOJu0YzXvBaQ72YhsoG3p1d+p09STK+ULAUI0oolNIqDl8CBGjBLPnYX
	OsBoP7go4I9g5hWPwXB2FA1BPAL0IT28DiMSImExgiND/Ba/6HGT5CgPFtgzrfmys1VvD5vXPdr
	L6sXS4w==
X-Google-Smtp-Source: AGHT+IGrCgRfUl52q+9Dm1SUPPCGRTzb2repp5WB05Y7Tt3MOB2S+vnmenaNajU41khUfolPBUODsZW1t3U=
X-Received: from pjl5.prod.google.com ([2002:a17:90b:2f85:b0:32e:2405:c7ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:914d:b0:27b:dcba:a8f3
 with SMTP id adf61e73a8af0-2925f76be25mr2050578637.15.1758241300709; Thu, 18
 Sep 2025 17:21:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:21:31 -0700
In-Reply-To: <20250919002136.1349663-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919002136.1349663-2-seanjc@google.com>
Subject: [PATCH v3 1/6] KVM: SVM: Move x2AVIC MSR interception helper to avic.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Move svm_set_x2apic_msr_interception() to avic.c as it's only relevant
when x2AVIC is enabled/supported and only called by AVIC code.  In
addition to scoping AVIC code to avic.c, this will allow burying the
global x2avic_enabled variable in avic.

Opportunistically rename the helper to explicitly scope it to "avic".

No functional change intended.

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
index 67f4eed01526..3bcb88b2e617 100644
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
index 5d39c0b17988..1e612bbfd36d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -699,7 +699,6 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write);
-void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 
-- 
2.51.0.470.ga7dc726c21-goog


