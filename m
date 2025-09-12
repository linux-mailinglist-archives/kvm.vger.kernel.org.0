Return-Path: <kvm+bounces-57451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC4EB55A08
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ADB4AC6D1B
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A462D061D;
	Fri, 12 Sep 2025 23:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pnuhhq+d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF9C29BDBC
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719420; cv=none; b=EYeJzXZPzGOGWNA4Lo9FdJ+khJKoTsdDy7AEqRulEfGlpla7eFWuLRR13qMuwHVP7YkLxdOQOjKWZiEkrdsMBmgij2eWrPAM071eFKQUiWMc4C4ZCHS66LLlut6g+WmIWmXWGzmJfoJFqQFCyPEw2dIKv2BhpfzLlCKxVkwJKbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719420; c=relaxed/simple;
	bh=tDtb6e36U1RgnYsYAJL/llcn1rOU/XJ+a6g/XspMzJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p9nG/GZ+zBcDLIUQ2AJZEsvswSxbt/xe1s0TFfW5zQZeN7FZV0rlPH8nJKLo5QPaouJZLUSTS0v99ryX2sTg+jbRdsk1WPTRUKxCP6NCkwicBDRGEig2lNqjcr8JTWO9psj7i4xmoozTecHStciCVMNPAMVYUB0FxlbRjF/byZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pnuhhq+d; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32d85208e3aso3307221a91.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719418; x=1758324218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bOB6PMzdos0m9DY8NnoO+hTec7qvi6LO9WIPoeRpOTU=;
        b=pnuhhq+d0CJK/8+DBDpvgyd4TMldMFNQFlUSxzNX10ghP9dqS3r1E5+wMHi6EAJ3G1
         i4ZqaM5as43pC5jr7z9Q/nT4uvmIJfj1KIugm+7ZhIioGUDbcMKeTFMU/6Z7iwWlgg7n
         WXG+POdXXUjwhxSObxSrRp5OChOYlLMeDALNaj1S2dHj0RiRmq4ccJH/8bAKlzZmLLrB
         LWqmPZ1oQSS0K+wtZedKf4Dt4synd/UYwUwjTcOiiwJu2+POkQge/HMA8Iz3xEo0xGOy
         koWPNQfAspe8P4IMSCXbggU8mLCx+morRCc/ysIsAXEklCQyqMTBtSo6ryRuLHax8jLc
         /WEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719418; x=1758324218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOB6PMzdos0m9DY8NnoO+hTec7qvi6LO9WIPoeRpOTU=;
        b=ZgUb2fyE7ekrNkYevdGvLaImaTerJIHYmpGxbwZ1RWdu4Bo8N4EOZTqZpYMIdqH0oA
         5DOl4ATVYNnREhgwPolpvGx3mjGoJBOtSeEIXbcYn5k78UfPGl0MXcZzclj+MXy7Ha2Y
         kreuZ8wPhAE/anc+zzLWiCeg1Kbzgs0zwRpTz1hkPVMLM7/7AOq2EbCj1PX8X2Y53jmb
         5Rhz//OzfLLTFKwTPF3asGiN/Iwch8rJZtUwFnUzEm7pVb91Xie+Inmbed57teg2wbE9
         FD9GEV4luIo2fHsLJnaBIWxEi6YdgBynpZA1D94VbsnxAJ6/TO7Ze+ogCaAY6ottG5z8
         cBnw==
X-Gm-Message-State: AOJu0YyU1z6vNwqunIWPlPcbIZJPxCtHyJmCRe9AI9qhbJkTYxtJWJrf
	uI5tSuJX7/vn5uf/O4c305sWJynBc9IE9Qh9ftbwLI6LjJF8qryeqNxu5/8KH4q1A6hRlN4lUav
	uPWdInQ==
X-Google-Smtp-Source: AGHT+IGHJ98Z8UORppHkGQhWL9lJ0tt/CZzti4qasW9DOcRHrkUwEpSYwwio4pFVSdwtqIjRnwHW6lWan6c=
X-Received: from pjbpx10.prod.google.com ([2002:a17:90b:270a:b0:327:be52:966d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:32d:a721:8cc7
 with SMTP id 98e67ed59e1d1-32de4f90629mr5198540a91.35.1757719418603; Fri, 12
 Sep 2025 16:23:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:46 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-9-seanjc@google.com>
Subject: [PATCH v15 08/41] KVM: x86: Initialize kvm_caps.supported_xss
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
XSAVES is supported. host_xss contains the host supported xstate feature
bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
enabled XSS feature bits, the resulting value represents the supervisor
xstates that are available to guest and are backed by host FPU framework
for swapping {guest,host} XSAVE-managed registers/MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: relocate and enhance comment about PT / XSS[8] ]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 519d58b82f7f..c5e38d6943fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -217,6 +217,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+/*
+ * Note, KVM supports exposing PT to the guest, but does not support context
+ * switching PT via XSTATE (KVM's PT virtualization relies on perf; swapping
+ * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
+ * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
+ */
+#define KVM_SUPPORTED_XSS     0
+
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
@@ -3986,11 +3994,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XSS:
 		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return KVM_MSR_RET_UNSUPPORTED;
-		/*
-		 * KVM supports exposing PT to the guest, but does not support
-		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
-		 * XSAVES/XRSTORS to save/restore PT MSRs.
-		 */
+
 		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
 		if (vcpu->arch.ia32_xss == data)
@@ -9818,14 +9822,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
+		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
+	}
+
 	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
 	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrq_safe(MSR_EFER, &kvm_host.efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
-
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-- 
2.51.0.384.g4c02a37b29-goog


