Return-Path: <kvm+bounces-41568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54799A6A85C
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 534A74880C7
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3875822538F;
	Thu, 20 Mar 2025 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d49p8fAW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ED1224223
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480428; cv=none; b=ApMFUnT4e+44wjKlV4IfpPjqQOkllgDCuyyPzg6vKRLwUC09vczLCqkFqIg+1BphbojEJMnj7k+vzcV5zyhrXHvQ4VufPJR+YasQUXPzTtiigjgu7hB7acyfqrMPL44gPp3i/SFYykBnCv5a/Coltqb9YKDBb13v3mSw4T6d3Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480428; c=relaxed/simple;
	bh=xYOJlqw5etD2Iq7EXs2+mhhOT8KTP4OQ36+fvxqow4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dwVYeFAjPl06xHtpFlc/Ksq+reko8LbwTkFW8u+z+yBWawd1gPc+P6Z1JJYYmpzKr0+H0goSKp7oYzCd9/2tqDgiur/JfhZQYD1EW4ouSYu7x1yvRWOZf+GeTF1E7jiR4eNmFzb/qw6+LPfGRf58zxSPFInkZVJUDZEQyc9GyCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d49p8fAW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2264e5b2b7cso10653045ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 07:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742480426; x=1743085226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xwl6R4UUQEICiZbEUz7U/9zbGoGjTM+0BWyTsj6cJLQ=;
        b=d49p8fAWvHaLpLV9jIBbXxpBLrPKHUugLYRDDdpwOdkCNE4LRfBdkEb8P8rrJBUIzz
         Mgq8gpoBco8v5cGco4VX0iYZ98ESJZTYkHRYAB4GJ7LU8lLaUhwRvhfCQMfW3ThhBNAL
         x7gNSJo+bnt0lNOF1P7gpD3r4uizIguzmIMjEYTe0c/K6fCq2LNNKzmxNQ1GRUGyHwIf
         oJxnYl+d9C/lihFDTlpB/OR+Js5E0ZMH6Nwh9PfvXwmimKNSIC1L+pvRDzHzTbWq8LLY
         6ilczLPSKAot4hESOrWLKSImLQNz1S2vuC6/Fq0e9sUHC1vFvTO3EyeJll7QGx1vGNiN
         w0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742480426; x=1743085226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xwl6R4UUQEICiZbEUz7U/9zbGoGjTM+0BWyTsj6cJLQ=;
        b=rtWMXmeP+U5aEYxeI3RqTsUT1cSwmXjBR8RzPXQJvT330scXaXnhg7Ajp16Ms4NmoI
         p1DmvQ0vN/YR/gL+Xw0aGPM2gLEnbIm3/LwXeJ9CcEM3f7Po8pkzpeKpKaGt4XBdEmqd
         fhR0ODI7raFI0FVvVo5KycUAH4NQvHavXdlqquPmvLXlbrXeyi3aZKURquC1iDJ/qkha
         1hgbd+UPs71rjf2XKO1QSgaeavZTKUW1sFLCYXbzxzrKk4wfVUdYHGMBDBPW5JPTtbkk
         P3Frm5P+H3Cu7TBA7oO7ReImtNUBHgPYUV8L0Uw9TYQXJ7w9B2m3ngqaT3ORzrF1Qke+
         972Q==
X-Gm-Message-State: AOJu0Yy4+XsARRP/YzPff7hcPIDanxKEZEFQMFCnsaKGajepeLVVKl8f
	nC0UGTTZeJRx6TB+W1EVlnhoTa1Gcy38zmVaBQb7a6dzsGloyZgLoApfiZhty9m507f0dydZ7mT
	C1w==
X-Google-Smtp-Source: AGHT+IFbi+MpaDJkuXF334mY8DbtKjRRtZOG3mJv7uihGv7QorWRefXzGfNReUq2gJZ504SwPNc35gRMsS0=
X-Received: from plsa10.prod.google.com ([2002:a17:902:b58a:b0:226:4240:2027])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a2c:b0:223:5c33:56a2
 with SMTP id d9443c01a7336-2265edf7ffemr63911585ad.28.1742480426260; Thu, 20
 Mar 2025 07:20:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Mar 2025 07:20:20 -0700
In-Reply-To: <20250320142022.766201-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250320142022.766201-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: VMX: Don't send UNBLOCK when starting device
 assignment without APICv
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

When starting device assignment, i.e. potential IRQ bypass, don't blast
KVM_REQ_UNBLOCK if APICv is disabled/unsupported.  There is no need to
wake vCPUs if they can never use VT-d posted IRQs (sending UNBLOCK guards
against races being vCPUs blocking and devices starting IRQ bypass).

Opportunistically use kvm_arch_has_irq_bypass() for all relevant checks in
the VMX Posted Interrupt code so that all checks in KVM x86 incorporate
the same information (once AMD/AVIC is given similar treatment).

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 7 +++----
 arch/x86/kvm/x86.c             | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..16121d29dfd9 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -134,9 +134,8 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 static bool vmx_can_use_vtd_pi(struct kvm *kvm)
 {
-	return irqchip_in_kernel(kvm) && enable_apicv &&
-		kvm_arch_has_assigned_device(kvm) &&
-		irq_remapping_cap(IRQ_POSTING_CAP);
+	return irqchip_in_kernel(kvm) && kvm_arch_has_irq_bypass() &&
+	       kvm_arch_has_assigned_device(kvm);
 }
 
 /*
@@ -254,7 +253,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
  */
 void vmx_pi_start_assignment(struct kvm *kvm)
 {
-	if (!irq_remapping_cap(IRQ_POSTING_CAP))
+	if (!kvm_arch_has_irq_bypass())
 		return;
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69c20a68a3f0..f76d655dc9a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13554,6 +13554,7 @@ bool kvm_arch_has_irq_bypass(void)
 {
 	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
 }
+EXPORT_SYMBOL_GPL(kvm_arch_has_irq_bypass);
 
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
-- 
2.49.0.395.g12beb8f557-goog


