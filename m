Return-Path: <kvm+bounces-32590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 583939DAE71
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF8D516702E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15AD42036EC;
	Wed, 27 Nov 2024 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DtUtjS9K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6672036E3
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738793; cv=none; b=ftAk3iN3Tm3tX6XiRLe69//SVA/jFXmvfGkGupRpq4ukIXFjR00e0e4YNVe2fne1cOdmLKjkuGk0EeAZGzqiCMXCADmaYQPvZfrLluQz5flbANdkWCDl/iJ1mwdenN52LJwTzKsgYHTxvGWKcXBhQeU2KM0GMIhEMDZSDkSIwiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738793; c=relaxed/simple;
	bh=DS66OSxCm+Ha7a9RcBVdqCMxeY2q+bsAiaZNWMf5dq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r7BpVlSIltMEZanjTyER0kkKnKmZgn0O90mRPOPBAa1+A/86UX0xCS2JSUDz7iy7+wUyUhb8tETILIJSQDCzVOg8filSxbN2ggAULRKntNq6yvOSyqU0Mwhh/HSTe1Wzu2mjo54HFV17sSzN+h+vhUwO99QFIaDJX6lyeMMbIQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DtUtjS9K; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72467c300a6so806978b3a.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738791; x=1733343591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ElA2tagihpZxHbytD6B3cmgQ2WMQN1TY7NZSTas0rUU=;
        b=DtUtjS9K9SkusfJF40Kn9pl0sJ9tQwwPPdKGSPPOTeFz8eDH2YfqVg8wChbwosw5Od
         KwNo9mnqInRsAa95LjY6jY75wPkNY3SCwYqW+HDfieFlpPOdfPqQ/NzJAOTua03hpNHt
         SMA2rnxLLpV+x6PK7K79HtxEDraU87TIuwFXa5KEQxVPEz1mt4BbT3r5cX7mQq9GgPw5
         F8v3PTmD0A7BhdZUy/kRN3sqkmF8Gq0wbqkuQbTQvEHaJN1e4e336HZn8K3ZAcCHAwO4
         STEWadyW60HRPH3Fb1+df/lGctDUMBPhHNO+3jhJSuuEaq/5EmlBnonfrk98QwIGWLnA
         H6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738791; x=1733343591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ElA2tagihpZxHbytD6B3cmgQ2WMQN1TY7NZSTas0rUU=;
        b=eOizegahgpY3ISBKBR2nHYN61dsz2qBMv9FX1KMzNeBF8VeQo0D9slvw9l7/+tNq3X
         gPc4G8lmSU95i38CRHy6JcskYLI42M1ML5z3eC7xIxdUJPx9CQDntI72v8O6PmGjO6qw
         Ud7VxvD92/3VbvQ2NV0lkJYg6NQI0Dk9qzuK7syYUNsA4+m+QRAm48z49JS3i6pt/kH5
         SS9WSxQOxf6feXlm21tl+PJDArp5Ws4WkqpVRn4qOtRxfptzVeZg8rCpfouGnf8/ozXC
         yDkSfcUQIUM1DYv0MFgW7Ke3oKSAuxttRQqEb2kAeDoeXeeZpVfo8LJqNRUCURpRqaCr
         YwwA==
X-Gm-Message-State: AOJu0YxRO8fbRb9x9vghJSMDutgmkQSWTKvB/X5Z8gZd8kl9Mb9Bvl7d
	AFSGEaNZgdpzOH7C4G764AB7pcnoJU5l7C1AVtrNI+W6SELgLYDxBtTCW/V3cta/LwYA/TXBqFK
	vQfb2VTr3FdpWGe/j0alg455x2EZRnJzJVapZujXmIzKRMXwuWOoJ8wUwiQiTgyGGjSNnuqe47E
	Hk/GJwDq5w2jPsH/QZblRiB71GtEQelRVnP4RfA1ha7tl03+AlAQ==
X-Google-Smtp-Source: AGHT+IHPrL3Xo8+4yQdLuZFUtegruqN+C4g+WVMuBwMhykTZtCocVln+NPRgmmVZPFtY/OBQpUKsLErufyiOOOmj
X-Received: from pfwz6.prod.google.com ([2002:a05:6a00:1d86:b0:724:f73b:3c65])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ac8e:b0:725:3ff5:76bc with SMTP id d2e1a72fcca58-7253ff5773dmr439441b3a.7.1732738790946;
 Wed, 27 Nov 2024 12:19:50 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:18 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-5-aaronlewis@google.com>
Subject: [PATCH 04/15] KVM: SVM: Track MSRPM as "unsigned long", not "u32"
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Use "unsigned long" instead of "u32" to track MSRPM to match the
bitmap API.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++++---------
 arch/x86/kvm/svm/svm.h | 12 ++++++------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f534cdbba0585..5dd621f78e474 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -276,8 +276,8 @@ u32 svm_msrpm_offset(u32 msr)
 		offset  = (msr - msrpm_ranges[i]) / 4; /* 4 msrs per u8 */
 		offset += (i * MSRS_RANGE_SIZE);       /* add range offset */
 
-		/* Now we have the u8 offset - but need the u32 offset */
-		return offset / 4;
+		/* Now we have the u8 offset - but need the ulong offset */
+		return offset / sizeof(unsigned long);
 	}
 
 	/* MSR not in any range */
@@ -799,9 +799,9 @@ static bool valid_msr_intercept(u32 index)
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	u8 bit_write;
+	unsigned long *msrpm;
 	unsigned long tmp;
 	u32 offset;
-	u32 *msrpm;
 
 	/*
 	 * For non-nested case:
@@ -824,7 +824,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return test_bit(bit_write, &tmp);
 }
 
-static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
+static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, unsigned long *msrpm,
 					u32 msr, int read, int write)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -861,18 +861,18 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	svm->nested.force_msr_bitmap_recalc = true;
 }
 
-void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+void set_msr_interception(struct kvm_vcpu *vcpu, unsigned long *msrpm, u32 msr,
 			  int read, int write)
 {
 	set_shadow_msr_intercept(vcpu, msr, read, write);
 	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
 }
 
-u32 *svm_vcpu_alloc_msrpm(void)
+unsigned long *svm_vcpu_alloc_msrpm(void)
 {
 	unsigned int order = get_order(MSRPM_SIZE);
 	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, order);
-	u32 *msrpm;
+	unsigned long *msrpm;
 
 	if (!pages)
 		return NULL;
@@ -883,7 +883,7 @@ u32 *svm_vcpu_alloc_msrpm(void)
 	return msrpm;
 }
 
-void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
+void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
 {
 	int i;
 
@@ -917,7 +917,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	svm->x2avic_msrs_intercepted = intercept;
 }
 
-void svm_vcpu_free_msrpm(u32 *msrpm)
+void svm_vcpu_free_msrpm(unsigned long *msrpm)
 {
 	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb191..d73b184675641 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -185,7 +185,7 @@ struct svm_nested_state {
 	u64 last_vmcb12_gpa;
 
 	/* These are the merged vectors */
-	u32 *msrpm;
+	unsigned long *msrpm;
 
 	/* A VMRUN has started but has not yet been performed, so
 	 * we cannot inject a nested vmexit yet.  */
@@ -266,7 +266,7 @@ struct vcpu_svm {
 	 */
 	u64 virt_spec_ctrl;
 
-	u32 *msrpm;
+	unsigned long *msrpm;
 
 	ulong nmi_iret_rip;
 
@@ -596,9 +596,9 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
 extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
-u32 *svm_vcpu_alloc_msrpm(void);
-void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
-void svm_vcpu_free_msrpm(u32 *msrpm);
+unsigned long *svm_vcpu_alloc_msrpm(void);
+void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm);
+void svm_vcpu_free_msrpm(unsigned long *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
@@ -612,7 +612,7 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
-void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+void set_msr_interception(struct kvm_vcpu *vcpu, unsigned long *msrpm, u32 msr,
 			  int read, int write);
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
-- 
2.47.0.338.g60cca15819-goog


