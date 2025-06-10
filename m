Return-Path: <kvm+bounces-48921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C1BEAD469C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 156BA189DCC1
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8E3298255;
	Tue, 10 Jun 2025 23:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hen0PwyX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5830428DB62
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 23:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749597621; cv=none; b=HWVXwq5s35bCuYCeT/omJSXw3bEhjKtZH0jaPlWibzGBQPWZFVDsytek7DY02XBoTxZc2nclCc1BUP21QNO+8xr0153CQ5eonM3bDHptO5Dxshzs20Etmrl2yBVrwc1fQNzgWgbnR2LbwXFgimAnFpalPY/T3O7ZB5O8hwMU3pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749597621; c=relaxed/simple;
	bh=lXPkeIDdbhFAfpOJJ2C/Lh95pW+2tzzpPk+8BOhZXcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IkMpPsw/S6MII6nJ+u1A8oUWlUWsOn9lri0VL0sz3QiljQT+uiZQvvYsoWSn9zll3QwOZYXfY+zjokEWEBpWDAgVxqKtp6XPeF4hh2l1QpOW62NWkeCiHFfbHt+kI3PzSbCregEekX0VCu8i+MX8NELg6acLQQxLVOc0BnLwskI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hen0PwyX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31171a736b2so10020311a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749597620; x=1750202420; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/+XzMzGMwW1mTSC7isLrm0UkjItZs/9XrzbKK280m3s=;
        b=Hen0PwyXf8bK84Em2C0TUTEpevtA44Byd/WHtHXgRzDfXcYqOMVto35W7Peeko5rd5
         IO0In1fzwBC/aQDBZBz9HKeGI7UnHBNJdNm7Lq0ImvpLgL8AJLMBJ7fLES4oWhFz9oRM
         yR9ToBy+FIiR4UdjkWUjhB7Lch56BPvPWgGIHBnAuZmwgjY6svQPRndKsisfN1nE1vMI
         irrv+jfKxeyJWC4oDgIZ2cYPiK45ZtsONLZuvs7jk8TZGkDNbRI118Fpsu27Euey5C/e
         iAiGlvLwJlZ4e0PYleeJQiWUO4lPK0+2zpieB5DF+27funxNydN0vk3O8mHQ/1/TSYHd
         DTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749597620; x=1750202420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/+XzMzGMwW1mTSC7isLrm0UkjItZs/9XrzbKK280m3s=;
        b=XvvIPd/IL2ZQ1FcXuzjsOe9mvKSC5pXdMHSZd+FhUMJdk5BLeYe8mg3UwgEocv2lv4
         jC45ocZAuMqbkonrm9CX+5eHAMikhgaOrdrmGFU/eSjY721SzeMhugqMD1yWRL3WwzRI
         YHjzhoGBa5wQ8CEHEA/LmKV55PUilrU+QDIWxrPnZHJld12QTlmHp5xEyFalGe+yh+nT
         6y7xxx/w9Oq48Vx0h85wYjtxU5zSwp1VAJbY0vwcSL6vW0psuiLC8np1aFdF2jiOO4H1
         MjHknvTZF10iHX5IOjDT2TdRUImIhd7i3X0hKsblzbgg4kT9xJqlG43nmZ5a0YftWYOb
         wfZg==
X-Gm-Message-State: AOJu0Yw5vomwrc1EpTTdT8c6RZ8ln4mMs1MTEJfp4AtLL7QmQBuyDgK1
	o1dH3hKSiekV1k1WxQTULdx0x9KjxU0yOZTugAsdsYKsb6BJH+ZwfSBGGCGk4FuXHavrki4sXSs
	8V1jwuw==
X-Google-Smtp-Source: AGHT+IGjBSpF+t9nRnBE2yjDswB3i2/tgdFb8nESgCpkvF6L+lDEma6Rbjm27J6NcdvQSxbgv2QO3ChvtY4=
X-Received: from pjk13.prod.google.com ([2002:a17:90b:558d:b0:311:b3fb:9f74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53cf:b0:311:df4b:4b91
 with SMTP id 98e67ed59e1d1-313af14a46emr1906302a91.7.1749597619931; Tue, 10
 Jun 2025 16:20:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 16:20:06 -0700
In-Reply-To: <20250610232010.162191-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610232010.162191-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610232010.162191-5-seanjc@google.com>
Subject: [PATCH v6 4/8] KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM
 is supported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Let the guest set DEBUGCTL.RTM_DEBUG if RTM is supported according to the
guest CPUID model, as debug support is supposed to be available if RTM is
supported, and there are no known downsides to letting the guest debug RTM
aborts.

Note, there are no known bug reports related to RTM_DEBUG, the primary
motivation is to reduce the probability of breaking existing guests when a
future change adds a missing consistency check on vmcs12.GUEST_DEBUGCTL
(KVM currently lets L2 run with whatever hardware supports; whoops).

Note #2, KVM already emulates DR6.RTM, and doesn't restrict access to
DR7.RTM.

Fixes: 83c529151ab0 ("KVM: x86: expose Intel cpu new features (HLE, RTM) to guest")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/kvm/vmx/vmx.c           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e7d2f460fcc6..1229396a059f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -419,6 +419,7 @@
 #define DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI	(1UL << 12)
 #define DEBUGCTLMSR_FREEZE_IN_SMM_BIT	14
 #define DEBUGCTLMSR_FREEZE_IN_SMM	(1UL << DEBUGCTLMSR_FREEZE_IN_SMM_BIT)
+#define DEBUGCTLMSR_RTM_DEBUG		BIT(15)
 
 #define MSR_PEBS_FRONTEND		0x000003f7
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 49bf58ca9ffd..ab5c742db140 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2184,6 +2184,10 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
+	if (boot_cpu_has(X86_FEATURE_RTM) &&
+	    (host_initiated || guest_cpu_cap_has(vcpu, X86_FEATURE_RTM)))
+		debugctl |= DEBUGCTLMSR_RTM_DEBUG;
+
 	return debugctl;
 }
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


