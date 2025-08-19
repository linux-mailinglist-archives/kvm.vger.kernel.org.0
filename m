Return-Path: <kvm+bounces-55079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5206B2D07E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6240D566A0D
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95256311977;
	Tue, 19 Aug 2025 23:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o5cr8Y8a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E24F274FCB
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755647335; cv=none; b=kjDuLYAm7aZy1fokhFOv+fl0sZm5BAc2T2xhn8dRj7KU6DArD77coNMWYwmDgYjayNnUruca8gCZfBqHhBtWC6Z8d+EIIomy/WC01dtQy24Dt04TKbuBJ5o6s7uFZ4g2BD+n5uS9NkjOXwDKZzBSoTXpOgLYf9cQhLoM0987dOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755647335; c=relaxed/simple;
	bh=twOwK2WrMvvYRZdg1YXAvXtBMzKrKLhmH7ohC2epAFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nqYIM4aF74oypSnQhbDyc51/02P9JKN9sVwYw1gbkNxfyB2LVP7LT99zkoOD7nQvj6ZAb4GS7VibzpGSGCHazeTDSWB7GDEf3PpZXNL93HhEeQftttC6nlszldubRVaOxxbj2wh9KdeJhzCLdHhdtrTWfSKz7dObag5rx0J8bYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o5cr8Y8a; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174b2582so10799074a12.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755647333; x=1756252133; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ij5DACOGoAwmy0AYvRq4D0pO+0Fvo5ANXQA3bigBH6g=;
        b=o5cr8Y8acbh+aXc8piT6Gj4A7WQPm1rKd0akPfqo+DTqlxeS+4fytVW93TstwZ32tG
         RudCXiJWjUOhbGLdmqw6MLsSDxhOF55EdnfBv8TykyAk0JZe2tC6X6p8bgQsbnXCLuyk
         nvJg7m84gXTQMaxbNGZyOYvNqGyWOxVmtwJlGwmkebq7+4q+mG5jDF09YssdBx41kHyf
         JKVeXODIIhhGA0LpjQ+5U2sPjK530svTaBt+luQcWhGL4YXfvoTcrhu0Feh7izV+PXIv
         1oZR0NW2+d2wnWIIoZ30R9CDeQr2Y9b2BACx/MLDIf6e4073x/rPOEljrm1/rV2Ddmwz
         8x3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647333; x=1756252133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ij5DACOGoAwmy0AYvRq4D0pO+0Fvo5ANXQA3bigBH6g=;
        b=CQdRoeQLPSMAzRf6THbICqiOTaM+K+zv+MR5yRVjT9icFFicFwZX7WjDZlaVhfRm/Z
         ZBvFuusWuf5wo5A4afKzpEWCf/IuaYkda5xzE+6FqVrMZL87qG3FTeC1//7tPrvxgk2z
         C9rosAXOernTP2yvRg1xEpxuwZsG0K4HXf/eZDLfKJNOUNIyFdh1+ypZS03j+1qdRX1n
         1MldcZcQPrlc/aKuTGGe4O2xosbApPF2zy2GKQk/V6mls9UCt8z3bgZm/TFUMvP2e9nE
         ELb0y17I0h0wrQnkj2Ouf6gDb3R4HExbwj5KoTCjbwvlCwervibi6cKEBTZcCxpslMdT
         aNIg==
X-Gm-Message-State: AOJu0Yx7J+lRQUjNT0CUWXr8aLkAjmXjDtT9tR/VfLwtUit0grfGoY/6
	BODdRLk+FSlpa8fLcSof2d+Zhhr6OwUpXsKS8d42zpoJbVVPCPIFavwuKxEFsy5qe8FymPyGpIS
	xl6VbnA==
X-Google-Smtp-Source: AGHT+IHA4xx30YG+v08EWU8ccyD5t2BPTbFqLPfGoQIR6NxJO+YK9vs+uA2AKxNs93apEGIUcNMDkCqZGzA=
X-Received: from pjbta11.prod.google.com ([2002:a17:90b:4ecb:b0:31f:a0:fad4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e710:b0:321:87fa:e1ec
 with SMTP id 98e67ed59e1d1-324e1488418mr1044517a91.34.1755647333624; Tue, 19
 Aug 2025 16:48:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Aug 2025 16:48:33 -0700
In-Reply-To: <20250819234833.3080255-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819234833.3080255-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819234833.3080255-9-seanjc@google.com>
Subject: [PATCH v11 8/8] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Vaishali Thakkar <vaishali.thakkar@suse.com>, Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Nikunj A Dadhania <nikunj@amd.com>

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests.

Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
passed to SNP guests in the SNP_LAUNCH_START command.  The default value
is the host TSC frequency.  The userspace can optionally change the TSC
frequency via the KVM_SET_TSC_KHZ ioctl before calling the
SNP_LAUNCH_START ioctl.

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
[sean: contain Secure TSC to sev.c]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..17f6c3fedeee 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7d1d34e45310..fb45a96e0159 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -146,6 +146,14 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
 	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
+static bool snp_is_secure_tsc_enabled(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+	       !WARN_ON_ONCE(!sev_snp_guest(kvm));
+}
+
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
 {
@@ -415,6 +423,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (data->flags)
 		return -EINVAL;
 
+	if (!snp_active)
+		valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
+
 	if (data->vmsa_features & ~valid_vmsa_features)
 		return -EINVAL;
 
@@ -2195,6 +2206,12 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_is_secure_tsc_enabled(kvm)) {
+		WARN_ON_ONCE(!kvm->arch.default_tsc_khz);
+		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -3085,6 +3102,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
@@ -4452,6 +4472,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID));
 
+	svm_set_intercept_for_msr(vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_R,
+				  !snp_is_secure_tsc_enabled(vcpu->kvm));
+
 	/*
 	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
 	 * the host/guest supports its use.
@@ -4591,6 +4614,9 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	svm->sev_es.vmsa = page_address(vmsa_page);
+
+	vcpu->arch.guest_tsc_protected = snp_is_secure_tsc_enabled(vcpu->kvm);
+
 	return 0;
 }
 
-- 
2.51.0.rc1.167.g924127e9c0-goog


