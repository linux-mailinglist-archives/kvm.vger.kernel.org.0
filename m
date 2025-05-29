Return-Path: <kvm+bounces-48044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6DDAC851F
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89AAD162BAB
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1886225E448;
	Thu, 29 May 2025 23:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gB3vfWW9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD6125D8E1
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562032; cv=none; b=SEySDHGsuGnjxjp+1moY109S2bsIoGpe31UBTNur6d5vnN/kRaIpFWspRXkpWASoT06XpzdARMa4n9HHxdiLyImgUGkx+bP4mV7OTLOacHawcil/sL0wPWd7sDMwM8AGVVictIJjirLefsoYaj4khe/sk3Mbdc8POvJOjuF/r8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562032; c=relaxed/simple;
	bh=CZQUzcUodrOJcCl34tZfdycjNX0vOg9GOFdxG/R2Lu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=soEjw4KHONTShnLY657+8sGyhHSF2tm/EuGLu8bJincK+hQ5XjsjvoVMfg3rmckzxP9TdBOIZLOU/0bqvY/bHMNSfwYJeKeuQTEeWyMNmS6Lm733bBtxPzoejPS3k2keH+inoFwFmSjY44qdSREp15nz6edqf/guVzR8K6Mab8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gB3vfWW9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310e7c24158so1256056a91.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562030; x=1749166830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=roVsqny12kLSO8K5pNSxGFwPWa1vbDEGw9mZJH1mvBE=;
        b=gB3vfWW9TC6987lZYmG6RA6ANeUL4tmCjMSUXZulTIhuEA8eVGC25j1k6wULVu5hcW
         txu64QUIG3XMIjJ36P5WJSvKN6BFz0yGh7rSVJGLsknJzs3i3Ib0ulII8qiuVb+LT5IS
         bMN1XGR9E1E/zJCcv2A6fq8sqdapScJuzXfH6ykavHIhAHubNe06YeEt8/ITmP+6bpZg
         dMThaxcWuwYjFF+1oZBW00THmC35x/UuftwgPrGZpB7N8UYhrQwI9oxHVVfUMpS3gmIx
         E1gAZvTS4aPBtRgfaFcDWydteBgTjayugksHb16jdkwZlrlnxVc+wkNreg7v5yJVs+1w
         nXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562030; x=1749166830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=roVsqny12kLSO8K5pNSxGFwPWa1vbDEGw9mZJH1mvBE=;
        b=p2lQql9iwh3GIspOUWCxy853vORcXzmCjugUu1pA8cuoTPp4FieGRDlLx6/UxeZ+og
         EyD4ffD8tCvtp0qFe1478bRLIUKZSCidDxIml2M/o76eqHJgczNISpqoTmf3UWkYsl/x
         bXH56dQMEQdVLcndvKVtx80f33hIATwmMhXBTItURim9CpYZTHdg8fHh5ehceoIlTdMH
         oOITaQF1LlPs6V2oDBxyEwv+P8twg7PT5P13HpJdZX6UjeZpsSpiv4wIu8FDrQUeAmmC
         9jjBNSjpVQ1pEvVoddo2joxl5uJbPqAW0kXyGioi/tv84ZBNUaXyER/D+UWYalEHFB2W
         N7KA==
X-Gm-Message-State: AOJu0Yx3wp22f6NwLJW/pWlStqZkD+XV5Sm4jLuPwTxCtNz/A58lvfxz
	IX/KnbOj1CcyrI+5Fu0vjURrbMgNdH2HuJQ0/D0f2zGi3zpDUr/LP/O8BBTf//pn7N+EKi5D+xm
	jqhj0vw==
X-Google-Smtp-Source: AGHT+IHw0Q1cB0c2rxsbdffWQZxibrTpjac52FFvxOlEejicYYcYrgWG25Kr2IKDVURCZYJCIQnozj9yj04=
X-Received: from pjbnw2.prod.google.com ([2002:a17:90b:2542:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7cc:b0:311:a314:c2dc
 with SMTP id 98e67ed59e1d1-31241637a87mr2114979a91.14.1748562030009; Thu, 29
 May 2025 16:40:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:53 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-9-seanjc@google.com>
Subject: [PATCH 08/28] KVM: nSVM: Use dedicated array of MSRPM offsets to
 merge L0 and L1 bitmaps
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Use a dedicated array of MSRPM offsets to merge L0 and L1 bitmaps, i.e. to
merge KVM's vmcb01 bitmap with L1's vmcb12 bitmap.  This will eventually
allow for the removal of direct_access_msrs, as the only path where
tracking the offsets is truly justified is the merge for nested SVM, where
merging in chunks is an easy way to batch uaccess reads/writes.

Opportunistically omit the x2APIC MSRs from the merge-specific array
instead of filtering them out at runtime.

Note, disabling interception of XSS, EFER, PAT, GHCB, and TSC_AUX is
mutually exclusive with nested virtualization, as KVM passes through the
MSRs only for SEV-ES guests, and KVM doesn't support nested virtualization
for SEV+ guests.  Defer removing those MSRs to a future cleanup in order
to make this refactoring as benign as possible.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 72 +++++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.c    |  4 +++
 arch/x86/kvm/svm/svm.h    |  2 ++
 3 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 89a77f0f1cc8..e53020939e60 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -184,6 +184,64 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	}
 }
 
+static int nested_svm_msrpm_merge_offsets[9] __ro_after_init;
+static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
+
+int __init nested_svm_init_msrpm_merge_offsets(void)
+{
+	const u32 merge_msrs[] = {
+		MSR_STAR,
+		MSR_IA32_SYSENTER_CS,
+		MSR_IA32_SYSENTER_EIP,
+		MSR_IA32_SYSENTER_ESP,
+	#ifdef CONFIG_X86_64
+		MSR_GS_BASE,
+		MSR_FS_BASE,
+		MSR_KERNEL_GS_BASE,
+		MSR_LSTAR,
+		MSR_CSTAR,
+		MSR_SYSCALL_MASK,
+	#endif
+		MSR_IA32_SPEC_CTRL,
+		MSR_IA32_PRED_CMD,
+		MSR_IA32_FLUSH_CMD,
+		MSR_IA32_LASTBRANCHFROMIP,
+		MSR_IA32_LASTBRANCHTOIP,
+		MSR_IA32_LASTINTFROMIP,
+		MSR_IA32_LASTINTTOIP,
+
+		MSR_IA32_XSS,
+		MSR_EFER,
+		MSR_IA32_CR_PAT,
+		MSR_AMD64_SEV_ES_GHCB,
+		MSR_TSC_AUX,
+	};
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(merge_msrs); i++) {
+		u32 offset = svm_msrpm_offset(merge_msrs[i]);
+
+		if (WARN_ON(offset == MSR_INVALID))
+			return -EIO;
+
+		for (j = 0; j < nested_svm_nr_msrpm_merge_offsets; j++) {
+			if (nested_svm_msrpm_merge_offsets[j] == offset)
+				break;
+		}
+
+		if (j < nested_svm_nr_msrpm_merge_offsets)
+			continue;
+
+		if (WARN_ON(j >= ARRAY_SIZE(nested_svm_msrpm_merge_offsets)))
+			return -EIO;
+
+		nested_svm_msrpm_merge_offsets[j] = offset;
+		nested_svm_nr_msrpm_merge_offsets++;
+	}
+
+	return 0;
+}
+
 /*
  * Merge L0's (KVM) and L1's (Nested VMCB) MSR permission bitmaps. The function
  * is optimized in that it only merges the parts where KVM MSR permission bitmap
@@ -216,19 +274,11 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return true;
 
-	for (i = 0; i < MSRPM_OFFSETS; i++) {
-		u32 value, p;
+	for (i = 0; i < nested_svm_nr_msrpm_merge_offsets; i++) {
+		const int p = nested_svm_msrpm_merge_offsets[i];
+		u32 value;
 		u64 offset;
 
-		if (msrpm_offsets[i] == 0xffffffff)
-			break;
-
-		p      = msrpm_offsets[i];
-
-		/* x2apic msrs are intercepted always for the nested guest */
-		if (is_x2apic_msrpm_offset(p))
-			continue;
-
 		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
 
 		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1c70293400bc..84dd1f220986 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5689,6 +5689,10 @@ static int __init svm_init(void)
 	if (!kvm_is_svm_supported())
 		return -EOPNOTSUPP;
 
+	r = nested_svm_init_msrpm_merge_offsets();
+	if (r)
+		return r;
+
 	r = kvm_x86_vendor_init(&svm_init_ops);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 909b9af6b3c1..0a8041d70994 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -686,6 +686,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
+int __init nested_svm_init_msrpm_merge_offsets(void);
+
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
 			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
 void svm_leave_nested(struct kvm_vcpu *vcpu);
-- 
2.49.0.1204.g71687c7c1d-goog


