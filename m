Return-Path: <kvm+bounces-69308-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CL3rA9ppeWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69308-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 509AF9C006
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8E8E8300BE9B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A4026E16C;
	Wed, 28 Jan 2026 01:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4TVi2q01"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91175262FF8
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564597; cv=none; b=V1/fygVsh5Cdumu69TChDXwHj2A6meUw4DwbqxuJjaSvOVxG78OefxEepz5F4C8jqtkPQ/3cvUPS0KAQtqRvAxLldGmemCAO94zFsb45a3LQroNYIHZ1VRNz+ygech+wMGvbrepRjlsKmwQd5BTndBVzV+ApwSwvHOjyFwkecJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564597; c=relaxed/simple;
	bh=gjNPSqmL0Tbn8NDFbPUIQp/fE+kR/OlsEcl9q9Y4XdU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EGOEOYiTcBKgNNGTKGK15OmYuMYBGfkd9EHBekbPxq2kBVjb93KIW4dc2ekU7cIvYM9+amQ4UKBhQ9Gr4H7ht9D0GXzletV11dcNngMO4MCqvpNbqYCKREHN1+R+r4fRI5Q5ZcAVkLpZqJeW7K0kgU3h8Z59drfIfR17/z6wkCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4TVi2q01; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c337375d953so3997834a12.3
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769564596; x=1770169396; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4DtlW/gC7gteJd+CFkna93VzdyPdpEl+ULoZd8O0aTU=;
        b=4TVi2q01ibw3AppQkC2naOJRq24+WuBTUqehM7HQyLyI+WT6DKiHr5z1stQDGK9/HJ
         e7p5+3KdIrvl5c3KbQu2VeMy9GCCKedlccNqkNK1sCE+LLr7PU0js+lyVsQin18bl142
         tCNmvfCz11RyplfsaHVVADP9VgS5LQUclCM7Tpg/mFTRqBp8SoHKv9iB3tdoVkXqOgHd
         P02btg8rvRY3dqZlFPspYUXxXql0fMshGX9fZhOLptfU60ydJ7FZ0iBgDAPP2SIhpsix
         r1H7NI+bGV/3P/e+eISDOc67v7y12Iegk9aWDsYKOmqTsSsDcWCOM8r+QF7u//FqGNMS
         9laA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769564596; x=1770169396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4DtlW/gC7gteJd+CFkna93VzdyPdpEl+ULoZd8O0aTU=;
        b=WlPDxEiXaiB2T/6zAfqEMiQJajwYp86N1E3EXRwcV70pvQ8/6lw6F4kqNlvuYfcADb
         D/Q3XeBvMZiHM4JwJJSFIAYrzh9qshQh72L1K5TURnxvdqYMJGduuQpIQpdG8i39pjLS
         MB0NCc+XvGRv5UraCuInwOm4oV0sljBCuFHFwUUbY0scLa33T5ovIhXoSxRmvvWhM0OZ
         7LhEvV8RktKqBwmLoX5b43OW5cm8I5zPALX9TlD71rycJOudef8yPBGFhGO3R7kBzc+P
         fXVoKU0JZwsM4VnR0Gd2cJz4bG8KuMhBmmKVyRlJoZq3IQHZTtWFIXOctBg5QMdyiXWq
         z1+w==
X-Gm-Message-State: AOJu0Yz70AklzLLc+404ZiXZX1B3ed7cqlwrzubC0WctdT7L7G61jMzB
	7DumtNDM+Y4AJ8wm7zh/f2vY4Yd7IT4g8l0aaiAJdTHCWAskaD3De1BnfJHHdKAE0MkQ880tZBv
	YqKjD/w==
X-Received: from pgah16.prod.google.com ([2002:a05:6a02:4e90:b0:c1e:18e8:e532])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:498:b0:38d:e6f8:fd96
 with SMTP id adf61e73a8af0-38ec6428c3dmr3264203637.60.1769564595826; Tue, 27
 Jan 2026 17:43:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 17:43:09 -0800
In-Reply-To: <20260128014310.3255561-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128014310.3255561-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260128014310.3255561-3-seanjc@google.com>
Subject: [PATCH v2 2/3] KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69308-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
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
X-Rspamd-Queue-Id: 509AF9C006
X-Rspamd-Action: no action

Add a flag to track when KVM is actively configuring its CPU caps, and
WARN if a cap is set or cleared if KVM isn't in its configuration stage.
Modifying CPU caps after {svm,vmx}_set_cpu_caps() can be fatal to KVM, as
vendor setup code expects the CPU caps to be frozen at that point, e.g.
will do additional configuration based on the caps.

Rename kvm_set_cpu_caps() to kvm_initialize_cpu_caps() to pair with the
new "finalize", and to make it more obvious that KVM's CPU caps aren't
fully configured within the function.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 10 ++++++++--
 arch/x86/kvm/cpuid.h   | 12 +++++++++++-
 arch/x86/kvm/svm/svm.c |  4 +++-
 arch/x86/kvm/vmx/vmx.c |  4 +++-
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 575244af9c9f..7fe4e58a6ebf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -36,6 +36,9 @@
 u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_cpu_caps);
 
+bool kvm_is_configuring_cpu_caps __read_mostly;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_is_configuring_cpu_caps);
+
 struct cpuid_xstate_sizes {
 	u32 eax;
 	u32 ebx;
@@ -826,10 +829,13 @@ do {									\
 /* DS is defined by ptrace-abi.h on 32-bit builds. */
 #undef DS
 
-void kvm_set_cpu_caps(void)
+void kvm_initialize_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
 
+	WARN_ON_ONCE(kvm_is_configuring_cpu_caps);
+	kvm_is_configuring_cpu_caps = true;
+
 	BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
 		     sizeof(boot_cpu_data.x86_capability));
 
@@ -1289,7 +1295,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
 	}
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_cpu_caps);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_initialize_cpu_caps);
 
 #undef F
 #undef SCATTERED_F
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d3f5ae15a7ca..039b8e6f40ba 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -8,7 +8,15 @@
 #include <uapi/asm/kvm_para.h>
 
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
-void kvm_set_cpu_caps(void);
+extern bool kvm_is_configuring_cpu_caps __read_mostly;
+
+void kvm_initialize_cpu_caps(void);
+
+static inline void kvm_finalize_cpu_caps(void)
+{
+	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
+	kvm_is_configuring_cpu_caps = false;
+}
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
@@ -188,6 +196,7 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
+	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
 }
 
@@ -195,6 +204,7 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
+	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c00a696dacfc..5f0136dbdde6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5305,7 +5305,7 @@ static __init void svm_adjust_mmio_mask(void)
 
 static __init void svm_set_cpu_caps(void)
 {
-	kvm_set_cpu_caps();
+	kvm_initialize_cpu_caps();
 
 	kvm_caps.supported_perf_cap = 0;
 
@@ -5389,6 +5389,8 @@ static __init void svm_set_cpu_caps(void)
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
 
 	kvm_setup_xss_caps();
+
+	kvm_finalize_cpu_caps();
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9f85c3829890..93ec1e6181e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8173,7 +8173,7 @@ static __init u64 vmx_get_perf_capabilities(void)
 
 static __init void vmx_set_cpu_caps(void)
 {
-	kvm_set_cpu_caps();
+	kvm_initialize_cpu_caps();
 
 	/* CPUID 0x1 */
 	if (nested)
@@ -8232,6 +8232,8 @@ static __init void vmx_set_cpu_caps(void)
 	}
 
 	kvm_setup_xss_caps();
+
+	kvm_finalize_cpu_caps();
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
-- 
2.52.0.457.g6b5491de43-goog


