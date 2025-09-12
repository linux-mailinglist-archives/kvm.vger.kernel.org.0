Return-Path: <kvm+bounces-57459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B37FB55A24
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B060B62DF7
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FEE2D8791;
	Fri, 12 Sep 2025 23:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a/mfwBDh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D366F2D7DF7
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719435; cv=none; b=uWD0zBE0/jrOY4vs2kCrhe0HHbCECNuBiUzykIEjOYncvKaKOPZgVT1FOJBB3UFL8IkdgvQ6B2/BFeSB51mH5LurEgM+h4/BMZ43IHEAygTneewq30jFVAf1E4WiL/0VynOE/AxVRnIFP047tvnzszUpje5skVEzNgDW4jm8liA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719435; c=relaxed/simple;
	bh=tG3ovMwAMHbfeh5vSjhWEPZM8u9oO+88uWP+MXoRHk0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T/AhTlT8mByGrmpGJRfmGJ/+notSyaAdSHD8XObvq9lzhrba6+WebJwhvqFrnHkz1h2w68zEb9WhNIAwA/Dx8sNXULGRwU2XmunQL6fqDWvBpgxtJNtW3sGIXNw66u79lev+SlRDiJiVblOBJ6RTAYZX7OrIHXsnuYp3px0LflQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a/mfwBDh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-25d449089e8so22393275ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719433; x=1758324233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l+XAFKOcKNHNNNkiV3oGUHueNV9uJIbVnDYwxKtJwHg=;
        b=a/mfwBDhct2C0hSUky4cLJAOkgieuUEf0E4fYMtGe3HdxQOK8qTQo32+rFviNRFhAl
         OGkJ141bQT4JUli4jkDb6bNo/gzr77Esg19yxZewDzp4PxTPGxZ7LwfBNRAOaOFsr383
         1O8/NbyBVuXsZ7JmzrOF5BdStSxLKP4JLHMpa+KZbl/1+VycHgNKkOrp/K+msPTAaCc/
         o8Q3zTdUjmLAcvPBmMia0V7RHM7JuupWBvdsnSW3GeWHuhr50tw5Nrur1ic08wZhJA4s
         ksN1eF76pevU2xEd+7vkSKbOK47Xruw2eBoN5vPs/uZMIw9eHebmY6yPSxgnOcb62x1e
         SPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719433; x=1758324233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+XAFKOcKNHNNNkiV3oGUHueNV9uJIbVnDYwxKtJwHg=;
        b=wbgx06qBX5fU0s0XnA3jkjy+Buiyph545FQJSoW5EauRpuPpWIq1hZY7xSRHMMvLRE
         BgdS1q6uQmjq2y2cbxJQddSP5p1BXJz/WkBQBJUnTSVIaqEPAQzNnpYEumEd3p75OdSs
         2y/rTrdxLjl+L28DirPpjmqIgRY1T8D5Grb7CK37PycFKE6ABp6yJ1QgGyPQDHWi/TaJ
         pvRCoeaLhRhd7SZIG/NwVsQ/MMR2tIY0jDsXXhibnmGstIWq3zKKHw7FC/vLCqgD5W/6
         BmrT7Rzle6NykLteZXBXU0/rsorwL6EWf9UTd/ZSznZCYlS2OARH6jqm7M5gSwU/wr00
         IFWg==
X-Gm-Message-State: AOJu0YzI5WwUcLb99T/8kBM5Pr2x0rimMJ9+X1XrF2jziumw5gu14CrH
	TJ8ml68XebLL8C6sERajo5YC9DsyI3Sr95qJ19W0n9tFM0sJw41iqm9jXib6wE5rQh+ctHJd/Rb
	dWSXxQA==
X-Google-Smtp-Source: AGHT+IHAP92S8i+ghTT8MEtIwBOjslwrWY+WhIQ0oS3JzmmNNOIpAnQkBypJ1PCU0TwOkGVo/klbGRc7Ao8=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:321:c441:a0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c410:b0:246:24d:2394
 with SMTP id d9443c01a7336-25d2528bf9fmr44876615ad.8.1757719433341; Fri, 12
 Sep 2025 16:23:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:54 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-17-seanjc@google.com>
Subject: [PATCH v15 16/41] KVM: VMX: Set up interception for CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Enable/disable CET MSRs interception per associated feature configuration.

Pass through CET MSRs that are managed by XSAVE, as they cannot be
intercepted without also intercepting XSAVE. However, intercepting XSAVE
would likely cause unacceptable performance overhead.
MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.

Note, this MSR design introduced an architectural limitation of SHSTK and
IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
to guest from architectural perspective since IBT relies on subset of SHSTK
relevant MSRs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4fc1dbba2eb0..adf5af30e537 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4101,6 +4101,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
+	bool intercept;
+
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
@@ -4146,6 +4148,23 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, intercept);
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
+			    !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
+	}
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.51.0.384.g4c02a37b29-goog


