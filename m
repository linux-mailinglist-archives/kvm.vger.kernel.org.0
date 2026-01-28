Return-Path: <kvm+bounces-69307-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oPx7GdFpeWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69307-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 264B09BFFE
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 468F4302C652
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EA926560A;
	Wed, 28 Jan 2026 01:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jg+/PQQs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7704258CE7
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564596; cv=none; b=ncoPHUV7j/1uoaqYw3lmdeR0NS4wIR5C6xpEJU/nxs5cn++K1gpcomb8qGIaPiIRufLbWvtxQlT5zbvWtgiBk4TBDKqESSPuE3rfq65tEK98QPX2rDpwzcZXs+hM1w4Oz6D0fek7EVragWrEBUmLejKms511JhQebP/SaLoWBWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564596; c=relaxed/simple;
	bh=eavUFYdilWC4NDM0QmP02+ef9dX8BH7Zs1ktMcFbyJM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IVGecd8K/E1kJ52gGaJxLyeyxggEl7G2MiGn8s2jf/rXxI4f2NmSnnYKBvkiavrrdE+kQCz0ewt0abJNsX1ULxMGyGUTEqSttnezGQQciNzqcvGl+wvIi8dxyFswBN+K2aqE8tlR6yugO97QaIf02ppamxyolMUZmkczTc8KQ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jg+/PQQs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a76f2d7744so60407975ad.3
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769564594; x=1770169394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dycno8xrJTeHUt9FVeo8HJWayzqn06ym8ZC4RBKnLqw=;
        b=Jg+/PQQsPFcksCp4Sxk9n/l7dLzMp0V6YM3xC+1AsMm94qmCcp8bYOTTqZWicOp7Bp
         YgPk9ujK0hbU6bsvh5E9mv8j8PVceJwBVJ/0j/UYLq1St1QQySZVzBnrCpXVNNjV97/L
         gm3dPVemUkR/djAjWfZD+thEBsy4xhYUaTwNFARYZqDeiP7FYJCHshE51xYSB8l79p0Q
         txXRuzznAJoqhT6J/l013ZODKMv6PFcUq0wXl5PP4tAJq+YCXOCYuNnAWwWJ+rOVFzRv
         PKlxJLa4WW6I/RKmm8DyShBYSRCt1/tGwWYCSit9Ur/mbrxNE9LTwPuL+kC2Cg6YvCmn
         vFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769564594; x=1770169394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dycno8xrJTeHUt9FVeo8HJWayzqn06ym8ZC4RBKnLqw=;
        b=TAtBFu58+YxBDvfNOPhTzWfFIi2zZ/fLSgWr2YF5PpKLUg2UBL9o6abiK7vtnH9DJi
         cIlmtRqGqiqiYs9XgAdeLfmZ5gq9dS1fVIgmK1ovx/YMHts0/uWWXKJcZMflfLitC4kU
         HdfnzNK56sZE6v3cChTYlqx4GXphprL/Momp+YmNVq54P0tFxRYjYCeJqR2umaot3yyh
         9BYV1ykr10ZU1X9q8BgfRs10H3t86h3g7bez4i1zV/jH3lFfH3uFQkfuPnEhPYKxOVR0
         XS+oY54vYPoyO6VxgJ+Ta+GA0dbLUlYM6+r1j32tLeRyFqpo2vMFwy+lPm+UXDcxy7Oy
         K5EA==
X-Gm-Message-State: AOJu0YzPHUJvj+mBtZKZubZAC8Y9USeT2nDWL9VzsjobJjklbcJ3WXuM
	UwzN63I1f8bh3xLZhj0HLGMmzaulO15vWRlW2Nu9PL0/+BrX+GCt1aFfc6AMjy1pqZG1SdtlLxc
	9NnBC5A==
X-Received: from plbmj14.prod.google.com ([2002:a17:903:2b8e:b0:2a0:de6a:ac6c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2291:b0:2a1:5f23:7ddf
 with SMTP id d9443c01a7336-2a870d452d6mr30868615ad.6.1769564594217; Tue, 27
 Jan 2026 17:43:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 17:43:08 -0800
In-Reply-To: <20260128014310.3255561-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128014310.3255561-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260128014310.3255561-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: x86: Explicitly configure supported XSS from {svm,vmx}_set_cpu_caps()
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69307-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:email,intel.com:email,grsecurity.net:email];
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
X-Rspamd-Queue-Id: 264B09BFFE
X-Rspamd-Action: no action

Explicitly configure KVM's supported XSS as part of each vendor's setup
flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
VMX is enabled, i.e. when nested=1.  The late clearing results in
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
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     | 30 +++++++++++++++++-------------
 arch/x86/kvm/x86.h     |  2 ++
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7803d2781144..c00a696dacfc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5387,6 +5387,8 @@ static __init void svm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
+
+	kvm_setup_xss_caps();
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 27acafd03381..9f85c3829890 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8230,6 +8230,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 		kvm_cpu_cap_clear(X86_FEATURE_IBT);
 	}
+
+	kvm_setup_xss_caps();
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..cac1d6a67b49 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9965,6 +9965,23 @@ static struct notifier_block pvclock_gtod_notifier = {
 };
 #endif
 
+void kvm_setup_xss_caps(void)
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
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
+
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
@@ -10138,19 +10155,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
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
index 70e81f008030..94d4f07aaaa0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -483,6 +483,8 @@ extern struct kvm_host_values kvm_host;
 extern bool enable_pmu;
 extern bool enable_mediated_pmu;
 
+void kvm_setup_xss_caps(void);
+
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
  * features for which the current process doesn't (yet) have permission to use.
-- 
2.52.0.457.g6b5491de43-goog


