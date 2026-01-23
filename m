Return-Path: <kvm+bounces-69020-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UL79EUDzc2ny0AAAu9opvQ
	(envelope-from <kvm+bounces-69020-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:16:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBA17B122
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 502E0303B7C5
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9219F2D193F;
	Fri, 23 Jan 2026 22:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QgYxY8hn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A322C11C6
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206548; cv=none; b=N8sbiCvkM8FC6jJRWCmMoPLrL+BXFm3F+tl/Icz91z743EygPWvGD3o/XIGJIa++x+cslkXByzq5eFe0xXPTRc+wULSIvkojk9u97X0nZ08Dsh63r1j92Ft1FxVYQRttVHObLe4jgTZVopYEmG3mBCjfvhHtbkje5AHkP8JhUE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206548; c=relaxed/simple;
	bh=wfgo8+EpcOGxMCSLVCKL4bvA9++d8AxEC+VcuzfO8WA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EmrW7O9IzKRbbw+6jQmqO3RYQP9/1oEgDJIlHDszhFdbMNBPcoH19Zx7AcUiWfsESYhfWt1J9skisoamXROdKKi5edcyvwN+n8zD5nujnUzgpLi4kXN4ttjea0t1qFKgV9mG0QZLaC9b1v8MsQtVrKUNCh7pAFOa7fvTqqLL4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QgYxY8hn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6124a9fb86so3814128a12.3
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769206546; x=1769811346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IKoRiscRvqZSUVfirtAlpZBQ7vM24W6FKDPHYfN9E+0=;
        b=QgYxY8hnNWjXvhJN1+Os9uAXFBZLXh/oYF119Izqj9vd7DG9WA6N3bwb49hHW9M+N/
         YChbnCYMbp5BxQIjVLaC9yCnz5CGZN2F94dfIoS62Yvu4xcejU09rqLLWfJUyLCsdIoD
         JvRRI/fRN/BJHbAxJhvoRVHsDWSzzklvlhIlXzlS71sgSqCoWIt4CZV7lua3M9QnCmQE
         Yb4HkwOWgSgbd8ZTTa3cepHtQ8rjzPlhWA6MRtlbTKS0yBuJGn5kSGSZWUjTegxuC3Ti
         vW/4z1NG5azdtKdamBJmWx8oVRBxCllvXlz5pmElBnQ1qNRLUc/KuFP/PVZ/vOqDlJRG
         NnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769206546; x=1769811346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IKoRiscRvqZSUVfirtAlpZBQ7vM24W6FKDPHYfN9E+0=;
        b=DMzj9NRZwbjRW63gRmJGbCgPd9Izlu/qY/BfZJ7993EQ/fYNj29AiahgzDqOE977fX
         iltsu0VFVv+ZMaO4WkDIbHy8LRUS5d8vs/hOq2gvjAOXAjloL707wBhXpy/8siAh752f
         Pp7mHAMn0FrHCG5vY93ON3Kxv4QtJvWE2bwrGo6ULiXFqbEnczuJK74pk3kDE3FF6PaW
         5AmQMETdbphDuDmSG+ECdShsYS0puh+4beVjCJOkQdx7tT+Ra8VGP5nP+CLLvoriGi8s
         gSODB/5J/oNAHPbD5AWpzrvbdaJKYQwm4SQjoi9NCNmmHmG3oEX+1O/BrbaiUAfM8pmM
         lUeQ==
X-Gm-Message-State: AOJu0YzW2rXsO3C+77s73jM9roQlssMzEbZUdVsB8elwLspIHmdLnSHI
	YZnF/QDd3BheWC0celxQ2LvgsaryOG0l8yBviOiPw30/JzPuZIy5qKxTz4LNKghnVIuy+Zh5zFW
	Fim/2fQ==
X-Received: from pgbfy24.prod.google.com ([2002:a05:6a02:2a98:b0:c16:a39f:5b40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:610e:b0:38d:b865:3a2a
 with SMTP id adf61e73a8af0-38e6f7ce40fmr4498697637.40.1769206546472; Fri, 23
 Jan 2026 14:15:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:15:40 -0800
In-Reply-To: <20260123221542.2498217-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123221542.2498217-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123221542.2498217-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86: Finalize kvm_cpu_caps setup from {svm,vmx}_set_cpu_caps()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69020-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,amd.com:email,grsecurity.net:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9CBA17B122
X-Rspamd-Action: no action

Explicitly finalize kvm_cpu_caps as part of each vendor's setup flow to
fix a bug where clearing SHSTK and IBT due to lack of CET XFEATURE support
makes kvm-intel.ko unloadable when nested=1.  The late clearing results in
nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
ultimately leading to a mismatched VMCS config due to the reference config
having the CET bits set, but every CPU's "local" config having the bits
cleared.

Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
kvm_x86_vendor_init(), before calling into vendor code, and not referenced
between ops->hardware_setup() and their current/old location.

Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
Cc: stable@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Cc: John Allen <john.allen@amd.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 21 +++++++++++++++++++--
 arch/x86/kvm/cpuid.h   |  3 ++-
 arch/x86/kvm/svm/svm.c |  4 +++-
 arch/x86/kvm/vmx/vmx.c |  4 +++-
 arch/x86/kvm/x86.c     | 14 --------------
 arch/x86/kvm/x86.h     |  2 ++
 6 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 575244af9c9f..267e59b405c1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -826,7 +826,7 @@ do {									\
 /* DS is defined by ptrace-abi.h on 32-bit builds. */
 #undef DS
 
-void kvm_set_cpu_caps(void)
+void kvm_initialize_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
 
@@ -1289,7 +1289,24 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
 	}
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_cpu_caps);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_initialize_cpu_caps);
+
+void kvm_finalize_cpu_caps(void)
+{
+	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
+		kvm_caps.supported_xss = 0;
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+
+	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_finalize_cpu_caps);
 
 #undef F
 #undef SCATTERED_F
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d3f5ae15a7ca..3b0b4b1adb97 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -8,7 +8,8 @@
 #include <uapi/asm/kvm_para.h>
 
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
-void kvm_set_cpu_caps(void);
+void kvm_initialize_cpu_caps(void);
+void kvm_finalize_cpu_caps(void);
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7803d2781144..0c23fcaedcc5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5305,7 +5305,7 @@ static __init void svm_adjust_mmio_mask(void)
 
 static __init void svm_set_cpu_caps(void)
 {
-	kvm_set_cpu_caps();
+	kvm_initialize_cpu_caps();
 
 	kvm_caps.supported_perf_cap = 0;
 
@@ -5387,6 +5387,8 @@ static __init void svm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
+
+	kvm_finalize_cpu_caps();
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 27acafd03381..7d373e32ea9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8173,7 +8173,7 @@ static __init u64 vmx_get_perf_capabilities(void)
 
 static __init void vmx_set_cpu_caps(void)
 {
-	kvm_set_cpu_caps();
+	kvm_initialize_cpu_caps();
 
 	/* CPUID 0x1 */
 	if (nested)
@@ -8230,6 +8230,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 		kvm_cpu_cap_clear(X86_FEATURE_IBT);
 	}
+
+	kvm_finalize_cpu_caps();
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..36385e6aebfa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -220,7 +220,6 @@ static DEFINE_PER_CPU(struct kvm_user_return_msrs, user_return_msrs);
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define XFEATURE_MASK_CET_ALL	(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
 /*
  * Note, KVM supports exposing PT to the guest, but does not support context
  * switching PT via XSTATE (KVM's PT virtualization relies on perf; swapping
@@ -10138,19 +10137,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!tdp_enabled)
 		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
-	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-		kvm_caps.supported_xss = 0;
-
-	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
-	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
-		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
-
-	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
-		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
-		kvm_cpu_cap_clear(X86_FEATURE_IBT);
-		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
-	}
-
 	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 70e81f008030..9edfac5d5ffb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -483,6 +483,8 @@ extern struct kvm_host_values kvm_host;
 extern bool enable_pmu;
 extern bool enable_mediated_pmu;
 
+#define XFEATURE_MASK_CET_ALL	(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
+
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
  * features for which the current process doesn't (yet) have permission to use.
-- 
2.52.0.457.g6b5491de43-goog


