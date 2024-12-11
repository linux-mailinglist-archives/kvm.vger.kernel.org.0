Return-Path: <kvm+bounces-33465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8179EC188
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29945188099E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D2E1802AB;
	Wed, 11 Dec 2024 01:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JkUZx97k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326AA7080E
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 01:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880790; cv=none; b=JSiVPLef9coitP+9WNOdgXLhQpZZPBFQL/OM15A7HybTS0LkiIH7o5EN13FjXCzaAFqGLXB/7kOnNmLpYqz9d/boc7bvXD3Uh+YfSGDUK/dJj1+80NJ0Zrtdb48X8CeRVF2DNevCU8DL7md0E4hhUahcBd3aYW9E9WWmet1v914=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880790; c=relaxed/simple;
	bh=rWELINKVO9cwROYYGiGuNHuCfbRf7w0n47dt3Cv4zOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fXym48UeM2Hrr1WlHGcvWiLhrCtbFRqg5GTH3qlUnup11rvvOJLsWsViLuvv3LRk+2hVLQsZ7fpxD9opVtrkDQBvO4Y/bJzwIKSq+hJUZ8BtFNChHvl8vUtW4HIGkmE8m8SnSZ1Pbbn1M9iuOrCHBPYehmm2w65a/U5HMMSqwMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JkUZx97k; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-725eff499c0so2137097b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 17:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733880786; x=1734485586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+sXSf0fbdvo1bwXJdt6IwevPFQA/6DmNdkDt/p5c+pE=;
        b=JkUZx97kZtRYqcfW9zMcg7WX+fGauVz8M3M4ca3GIJiOHQKmtoKTRVyoyTFGYHsfw9
         NvwMkEBoTyMhph+V1fKJLyTOLyUnQ5RJJ//MO60pfRyW/BVxReCfpz+8keDbBQeI7oqV
         RS2nzJklgCiiCZB1P8NSUlmNpMSbsBzFK0lafi7vYYcKc1JheY1jjIhS67L+4OlNHQH0
         PHuVKw4LdtM+3sjgmRFDt5nNYl21PLHf7OCIFN65AswMtpFo46Aj1inMHyCvT+Cwz/zo
         16BQgFMNBpWKVVBdoLr6M88R/X3FrtSWY+8epbtAj5rmlT6pWFq88nMji7M8e8WGv1l/
         nTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733880786; x=1734485586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sXSf0fbdvo1bwXJdt6IwevPFQA/6DmNdkDt/p5c+pE=;
        b=fnoxxE7VKxKkgZT/EXQW2kcCj/XWnIHPGCBfOQv2WNl5IVX1HkyBIHhgyhWApd//Km
         HOGzoMaX/ivVw36Yl/34pmLiTAdJbZ1LObpmHBtzT/glhHgxW3po9RP4vk0DtG1fJHil
         ORMvFynq1iyZfMmP8clnsAr0WEROh/wZVHaHrSF17wDkDm+JXXRMrPzEYln9G4nZ/2Cv
         um5nfQpgBdwTuUDIb86alszbFllhVBeMptXM11FRjP6OK5d7mNPWYxLSpfWRe1Outzjm
         gMXWpeTlQTSp9y4nemc6sjejJDSr9BGncUrrYOLMeUBvqN5ZwFv8hKUiPMA1IeBCUA1t
         XgkA==
X-Gm-Message-State: AOJu0Yw+SZNBJcI7jTgsR9EkFqxBmAYm00YqIsHYyYZ5TyYE2KoVGXhk
	G3WE/TUBojJCNqD6BEJ3oxwtpVIJUg4uuLAtcnMMJQ81m8J8dcPbyn1fGP2cpFl0yjUT2/7Enu/
	amw==
X-Google-Smtp-Source: AGHT+IG3GZ4W/TYyWjLl5icoqMTXvacs+JQ1e4JM35OpRnI2r7Sy8DjpZ8xr1wEe56qgzdazQgSnYS3T5iE=
X-Received: from pgbeu11.prod.google.com ([2002:a05:6a02:478b:b0:7fd:4497:f282])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6f04:b0:1e0:d867:c880
 with SMTP id adf61e73a8af0-1e1c13ee2eemr2083297637.42.1733880786547; Tue, 10
 Dec 2024 17:33:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Dec 2024 17:32:58 -0800
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241211013302.1347853-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: x86: Cache CPUID.0xD XSTATE offsets+sizes during
 module init
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Snapshot the output of CPUID.0xD.[1..n] during kvm.ko initiliaization to
avoid the overead of CPUID during runtime.  The offset, size, and metadata
for CPUID.0xD.[1..n] sub-leaves does not depend on XCR0 or XSS values, i.e.
is constant for a given CPU, and thus can be cached during module load.

On Intel's Emerald Rapids, CPUID is *wildly* expensive, to the point where
recomputing XSAVE offsets and sizes results in a 4x increase in latency of
nested VM-Enter and VM-Exit (nested transitions can trigger
xstate_required_size() multiple times per transition), relative to using
cached values.  The issue is easily visible by running `perf top` while
triggering nested transitions: kvm_update_cpuid_runtime() shows up at a
whopping 50%.

As measured via RDTSC from L2 (using KVM-Unit-Test's CPUID VM-Exit test
and a slightly modified L1 KVM to handle CPUID in the fastpath), a nested
roundtrip to emulate CPUID on Skylake (SKX), Icelake (ICX), and Emerald
Rapids (EMR) takes:

  SKX 11650
  ICX 22350
  EMR 28850

Using cached values, the latency drops to:

  SKX 6850
  ICX 9000
  EMR 7900

The underlying issue is that CPUID itself is slow on ICX, and comically
slow on EMR.  The problem is exacerbated on CPUs which support XSAVES
and/or XSAVEC, as KVM invokes xstate_required_size() twice on each
runtime CPUID update, and because there are more supported XSAVE features
(CPUID for supported XSAVE feature sub-leafs is significantly slower).

 SKX:
  CPUID.0xD.2  = 348 cycles
  CPUID.0xD.3  = 400 cycles
  CPUID.0xD.4  = 276 cycles
  CPUID.0xD.5  = 236 cycles
  <other sub-leaves are similar>

 EMR:
  CPUID.0xD.2  = 1138 cycles
  CPUID.0xD.3  = 1362 cycles
  CPUID.0xD.4  = 1068 cycles
  CPUID.0xD.5  = 910 cycles
  CPUID.0xD.6  = 914 cycles
  CPUID.0xD.7  = 1350 cycles
  CPUID.0xD.8  = 734 cycles
  CPUID.0xD.9  = 766 cycles
  CPUID.0xD.10 = 732 cycles
  CPUID.0xD.11 = 718 cycles
  CPUID.0xD.12 = 734 cycles
  CPUID.0xD.13 = 1700 cycles
  CPUID.0xD.14 = 1126 cycles
  CPUID.0xD.15 = 898 cycles
  CPUID.0xD.16 = 716 cycles
  CPUID.0xD.17 = 748 cycles
  CPUID.0xD.18 = 776 cycles

Note, updating runtime CPUID information multiple times per nested
transition is itself a flaw, especially since CPUID is a mandotory
intercept on both Intel and AMD.  E.g. KVM doesn't need to ensure emulated
CPUID state is up-to-date while running L2.  That flaw will be fixed in a
future patch, as deferring runtime CPUID updates is more subtle than it
appears at first glance, the benefits aren't super critical to have once
the XSAVE issue is resolved, and caching CPUID output is desirable even if
KVM's updates are deferred.

Cc: Jim Mattson <jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 31 ++++++++++++++++++++++++++-----
 arch/x86/kvm/cpuid.h |  1 +
 arch/x86/kvm/x86.c   |  2 ++
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 572dfa7e206e..edef30359c19 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -36,6 +36,26 @@
 u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_cpu_caps);
 
+struct cpuid_xstate_sizes {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+};
+
+static struct cpuid_xstate_sizes xstate_sizes[XFEATURE_MAX] __ro_after_init;
+
+void __init kvm_init_xstate_sizes(void)
+{
+	u32 ign;
+	int i;
+
+	for (i = XFEATURE_YMM; i < ARRAY_SIZE(xstate_sizes); i++) {
+		struct cpuid_xstate_sizes *xs = &xstate_sizes[i];
+
+		cpuid_count(0xD, i, &xs->eax, &xs->ebx, &xs->ecx, &ign);
+	}
+}
+
 u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
 	int feature_bit = 0;
@@ -44,14 +64,15 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	xstate_bv &= XFEATURE_MASK_EXTEND;
 	while (xstate_bv) {
 		if (xstate_bv & 0x1) {
-		        u32 eax, ebx, ecx, edx, offset;
-		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
+			struct cpuid_xstate_sizes *xs = &xstate_sizes[feature_bit];
+			u32 offset;
+
 			/* ECX[1]: 64B alignment in compacted form */
 			if (compacted)
-				offset = (ecx & 0x2) ? ALIGN(ret, 64) : ret;
+				offset = (xs->ecx & 0x2) ? ALIGN(ret, 64) : ret;
 			else
-				offset = ebx;
-			ret = max(ret, offset + eax);
+				offset = xs->ebx;
+			ret = max(ret, offset + xs->eax);
 		}
 
 		xstate_bv >>= 1;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3d69a0ef8268..67d80aa72d50 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -31,6 +31,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool exact_only);
 
+void __init kvm_init_xstate_sizes(void);
 u32 xstate_required_size(u64 xstate_bv, bool compacted);
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc4563fb07d1..320764e5f798 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13982,6 +13982,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
 
 static int __init kvm_x86_init(void)
 {
+	kvm_init_xstate_sizes();
+
 	kvm_mmu_x86_module_init();
 	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
 	return 0;
-- 
2.47.0.338.g60cca15819-goog


