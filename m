Return-Path: <kvm+bounces-14275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32FC38A1CD2
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDAA9B2A275
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B097F1A38ED;
	Thu, 11 Apr 2024 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LE+b+I4d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7003A3E474
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712853098; cv=none; b=XqHZx0lA0Yv9y1G5HjAfrBsKcN0WF+HdNka75ITnLVE59drWBu6srqlJJNsM7Tp4uLpsVieRkMJSnCHEK7wky46wQrf/V7xGA05ZtG2BPTCBEFMAWwnijFavYmAmC9NiZ0pnypvw0dMGE6ULEopXU0lmi+t7ohtD6IIVuvLJtww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712853098; c=relaxed/simple;
	bh=4j9laXHAzm+DplQ6oWDejgL8l/oTxGEhgcgHFx7limM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Mt0aTDUDT2XdjFuQ9s7MZv+BMea93wgXYRbNsYzOSClENKGbuEMm30N4lyqAAhOdc5FlChWW+/5G2wqO/nvzrEqOvjBItPv1fZfPyp7XlqZsKLQOh3uYc3vDaTHDCZTdWvympfPbgVRnmqJ7y3EIKwiKJ4V0d1qBc16K1oDzAac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LE+b+I4d; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ee128aa957so44755b3a.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 09:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712853097; x=1713457897; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SOT4OXJzQmFlPNQvb/vL42zv6TrN8MRbfAFxsZzUsH0=;
        b=LE+b+I4dC6KaqqBjlqd0hwpAu0j/xCCFotLxquTRfh9VGnC6FhRgDHMo1sY4kPvgkz
         d/qWjem5tpv5xSkmc7Zj4VM8Q3ZPpASoap/vlkZxh2Mmw/nTcPoVIAK0aYgSQbfon9EF
         LFlK8YHa26+FrGfmFubLgbfuPyqXuLWZGmP7ga6LF8oryMuX72Yfep8i9WmVJQy7z4Wp
         7JR67JuFhZMmeUFTYTbzoRFReFO/udMT22djVGPjzQir+0QVBxpkRgW8htFm8tMlZcc7
         bcYUXx+B5hQ2VQ48zZLNEL2xi48K3hNRMVI/+3dGsx9PU/sw1YGhhwuemnAWXVYWxA0q
         Npzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712853097; x=1713457897;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SOT4OXJzQmFlPNQvb/vL42zv6TrN8MRbfAFxsZzUsH0=;
        b=htpwaeAgimPD4ANeY8MyFHgbmBuZLcbkeCxO53D967YNFIX4uzN+FindFY5f6FZ7sp
         gTVA8GQHmxAV6lJahcjWFhTWowgeIF9cdgyzqEKQlY9QwAPkTctqd6DG76szjFAsje2U
         Hwqt142ExYgImX3UZEkFFm4QLKNhNqOPPTOkWez0HRKYfN6rGBHnIl8ChGclu/aqiQYO
         9P0rVp+nvsrqNzrfg1OHkQGx+pcsmVZY34/S6PzCsAX6k7Ue9/G90xyduTwNK8WwJBdA
         dQh7hI/AJ6j85fgyIFD7v60O42/DbLiuCjx2fOWf7NVrhareVCmcB7u3ejimRVYRpfxV
         c3iw==
X-Forwarded-Encrypted: i=1; AJvYcCUsjOgODdTQsdlvYv71ucNf71fNqm/+YNDd0lCpuWd/weerrzvrOOYf0VgfhgQQPYk3CqZymUZk0oOey20iyHeNZoUH
X-Gm-Message-State: AOJu0Yy2d0QbZ6YozRVetpV89NbAMuieadgM2j5JGzEsrR5XAtvDWAwG
	ue/ob1Sh0PvnCxz2FLs33RIxaqSOu6xRUCO7+csFjZL6ej01qSaDPKSQe8SCASLF0/hditnRmnf
	lkA==
X-Google-Smtp-Source: AGHT+IGdjls82m2XHZdA1FRueklQHT9m/tP1w/S9yYVAUBWeUwpPLhZmP4/N6M5uOVVUdUX9HhQHnPXsWOo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3a0f:b0:6ed:344:9faa with SMTP id
 fj15-20020a056a003a0f00b006ed03449faamr524pfb.1.1712853096532; Thu, 11 Apr
 2024 09:31:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 11 Apr 2024 09:31:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240411163130.1809713-1-seanjc@google.com>
Subject: [RFC PATCH] KVM: x86: Advertise PCID based on hardware support (with
 an asterisk)
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Michael Kelley <mhklinux@outlook.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Andrew Cooper <andrew.cooper3@citrix.com>, Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"

Force set a synthetic feature, GUEST_PCID, if PCID can be safely used in
virtual machines, even if the kernel itself disables PCID support, and
advertise PCID support in KVM if GUEST_PCID is set.

When running on a CPU that is affected by Intel's "Global INVLPG" erratum,
which does NOT affect VMX non-root mode, it is safe to virtualize PCID for
KVM guests, even though it is not safe for the kernel itself to enable PCID.
Ditto for if the kernel disables PCID because CR4.PGE isn't supported.

Use a synthetic bit instead of having KVM check raw CPUID so that KVM
honors disabling PCID via the "nopcid" kernel parameter, and to guard
against PCID being disabled due to a erratum that DOES affect guests.

Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Tagged RFC because I'm 50/50 on whether or not this is worth doing.  On one
hand, it's a relatively small patch.  On the other hand, we can simply wait for
the ucode fix to roll out (the !PGE case doesn't seem like sufficient motivation
to carry this code).

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 7 +++++++
 arch/x86/mm/init.c                 | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index a38f8f9ba657..97006581278c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -227,6 +227,7 @@
 #define X86_FEATURE_FLEXPRIORITY	( 8*32+ 1) /* Intel FlexPriority */
 #define X86_FEATURE_EPT			( 8*32+ 2) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID		( 8*32+ 3) /* Intel Virtual Processor ID */
+#define X86_FEATURE_GUEST_PCID          ( 8*32+ 4) /* "" PCID is safe to expose to KVM guests */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2f1dd059ea79..4ae4b7291b5a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -628,6 +628,13 @@ void kvm_set_cpu_caps(void)
 	/* KVM emulates x2apic in software irrespective of host support. */
 	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
 
+	/*
+	 * On some CPUs, PCID can be used in virtual machines, even if it's
+	 * disabled in the host kernel.
+	 */
+	if (boot_cpu_has(X86_FEATURE_GUEST_PCID))
+		kvm_cpu_cap_set(X86_FEATURE_PCID);
+
 	kvm_cpu_cap_mask(CPUID_1_EDX,
 		F(FPU) | F(VME) | F(DE) | F(PSE) |
 		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 679893ea5e68..9b85beee06dc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -287,6 +287,14 @@ static void setup_pcid(void)
 	if (!boot_cpu_has(X86_FEATURE_PCID))
 		return;
 
+	/*
+	 * PCID is supported in hardware and can be safely exposed to virtual
+	 * machines, even if the kernel doesn't utilize PCID itself, e.g. due
+	 * to lack of PGE support, or because of Intel's errata (which doesn't
+	 * impact VMX non-root mode, a.k.a. guest mode).
+	 */
+	setup_force_cpu_cap(X86_FEATURE_GUEST_PCID);
+
 	if (x86_match_cpu(invlpg_miss_ids)) {
 		pr_info("Incomplete global flushes, disabling PCID");
 		setup_clear_cpu_cap(X86_FEATURE_PCID);

base-commit: f10f3621ad80f008c218dbbc13a05c893766a7d2
-- 
2.44.0.683.g7961c838ac-goog


