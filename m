Return-Path: <kvm+bounces-13772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B71A89A7A5
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E426A1F22D73
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD3F364DC;
	Fri,  5 Apr 2024 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JMun0koC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C629B374F5
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361372; cv=none; b=ulRnikLeT64xia7KR7tSi69NUZrwZPo2sAadIy3dfWcwCSOU4eBQPkCEtOYaYylhetzx4PLtmNdFC5DF4lYoYHbpEX7qdFNdrdgEcqamn2pnVF8fIZKYetehQrow3uoPswQa+v2dzNl1MvyqovZ0FeEIVZDAmfcZN/Gsn/7LR/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361372; c=relaxed/simple;
	bh=8lScNtViHEsyfm2JCHUZapYQ1CBggYo9daCone+eouU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SZ2h4Qeyi62dun/Sa+IyC3/9izrWKcZM2vkjZm9MWsK4Vw7VrsvlLC/fUis+iYtf2gK3zJkBNzXuoHG7zEuNonRCNSzzzzP2WA9GmSncJzf4YjpOQsGjkHq8ghswN1gqgb9/oUSyTmCFOKPEAc+VIsPHJTnWMNG7ZwnHTIEIuKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JMun0koC; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1864214a12.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712361370; x=1712966170; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4r+RoLEjqU5HCVgTykkvgt8C73/zrEV4zkUK1D/uSqA=;
        b=JMun0koCqDkQPhTnkp6I1SPQCFzxwOWaNnzUwUmdLavH1PAr4gXP2TXExbRYZErwiM
         du/aPi6/wrBL5y7nIUQYFhdKXk9go3E1y+1/r0vh0P/HxRbw5ITCTF4Eb2909mNX0a/M
         jnkLMwYkZ5oT0aS7O+eEzkku/GZLVoA6zXln8L6P/jypNYj7LBt1huHyJj7s3ss2EgAh
         oaJ/dw4/EkB9F9wbxWx/S1yCHoOZVFDqucI9hTdXOlcifFq1aSdvZAhTWMBDX+k+LHr4
         tL50lq1g9h8aGfzTJJG13nQOTB6yW/TqbuDNxJjhFd52B0/zKqcexxp/5fYymPhpUT45
         ouuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712361370; x=1712966170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4r+RoLEjqU5HCVgTykkvgt8C73/zrEV4zkUK1D/uSqA=;
        b=V6Tvn+p+3KF2F/e0LBexXM0xn8CF6ZWLHFRFHUDXMbwGtGm5aOo/R3epa07ra6uaqx
         /Jjt3yr3rMxzOWEoGeMvXbYEjTxnC7wQyVuwF1T7Mg9ayuw9/4gRvqTUvGhE+I0CwJMo
         kLLXAqwMIgUjNByBLy+uKyA8Z+JaBoY/FUdtnJ5q1w18DE4KCQCN+lnkqzvsVkKhQ1F5
         lnOtMYKjM2Prtq3NzgyzrrmSnbAkFIT1krek5tc+SbHFYCBogPVVokkICMbRTTyaiEYX
         iay/ptl4rNhKCqScLjM4nf75QDI6Y+peoUjaZ8CCRrxWJ+9v1R6yVRkkfVuyKh2gHsV8
         CR5g==
X-Gm-Message-State: AOJu0YxtJJo+pGY0H8jua0HY6vmPsJ9NSHaNRuyuPbXQAqZkU6/9HpPi
	6f+39GiKNfDVSD4MygkuOLfVp1mFCkKXLn8Mn5gxdBxJvO9PolzDXYdMUpAPaJ7iLbp5NsVjAeI
	yKg==
X-Google-Smtp-Source: AGHT+IFUv4Qi4W+CY+cd4Q+YVTMoq2UI1X46jcY5pyYF/waoENQ2hrc55fo9CuZwfUzQglgS5ZSBR3X37bg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ce14:0:b0:5dc:9e39:dbc7 with SMTP id
 y20-20020a63ce14000000b005dc9e39dbc7mr12081pgf.6.1712361369977; Fri, 05 Apr
 2024 16:56:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 16:55:54 -0700
In-Reply-To: <20240405235603.1173076-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405235603.1173076-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405235603.1173076-2-seanjc@google.com>
Subject: [PATCH 01/10] KVM: x86: Snapshot if a vCPU's vendor model is AMD vs.
 Intel compatible
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add kvm_vcpu_arch.is_amd_compatible to cache if a vCPU's vendor model is
compatible with AMD, i.e. if the vCPU vendor is AMD or Hygon, along with
helpers to check if a vCPU is compatible AMD vs. Intel.  To handle Intel
vs. AMD behavior related to masking the LVTPC entry, KVM will need to
check for vendor compatibility on every PMI injection, i.e. querying for
AMD will soon be a moderately hot path.

Note!  This subtly (or maybe not-so-subtly) makes "Intel compatible" KVM's
default behavior, both if userspace omits (or never sets) CPUID 0x0 and if
userspace sets a completely unknown vendor.  One could argue that KVM
should treat such vCPUs as not being compatible with Intel *or* AMD, but
that would add useless complexity to KVM.

KVM needs to do *something* in the face of vendor specific behavior, and
so unless KVM conjured up a magic third option, choosing to treat unknown
vendors as neither Intel nor AMD means that checks on AMD compatibility
would yield Intel behavior, and checks for Intel compatibility would yield
AMD behavior.  And that's far worse as it would effectively yield random
behavior depending on whether KVM checked for AMD vs. Intel vs. !AMD vs.
!Intel.  And practically speaking, all x86 CPUs follow either Intel or AMD
architecture, i.e. "supporting" an unknown third architecture adds no
value.

Deliberately don't convert any of the existing guest_cpuid_is_intel()
checks, as the Intel side of things is messier due to some flows explicitly
checking for exactly vendor==Intel, versus some flows assuming anything
that isn't "AMD compatible" gets Intel behavior.  The Intel code will be
cleaned up in the future.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  1 +
 arch/x86/kvm/cpuid.h            | 10 ++++++++++
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16e07a2eee19..6efd1497b026 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -855,6 +855,7 @@ struct kvm_vcpu_arch {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	struct kvm_hypervisor_cpuid kvm_cpuid;
+	bool is_amd_compatible;
 
 	/*
 	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index bfc0bfcb2bc6..77352a4abd87 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -376,6 +376,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_update_pv_runtime(vcpu);
 
+	vcpu->arch.is_amd_compatible = guest_cpuid_is_amd_or_hygon(vcpu);
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 856e3037e74f..23dbb9eb277c 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -120,6 +120,16 @@ static inline bool guest_cpuid_is_intel(struct kvm_vcpu *vcpu)
 	return best && is_guest_vendor_intel(best->ebx, best->ecx, best->edx);
 }
 
+static inline bool guest_cpuid_is_amd_compatible(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.is_amd_compatible;
+}
+
+static inline bool guest_cpuid_is_intel_compatible(struct kvm_vcpu *vcpu)
+{
+	return !guest_cpuid_is_amd_compatible(vcpu);
+}
+
 static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 992e651540e8..bf4de6d7e39c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4935,7 +4935,7 @@ static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				context->cpu_role.base.level, is_efer_nx(context),
 				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
 				is_cr4_pse(context),
-				guest_cpuid_is_amd_or_hygon(vcpu));
+				guest_cpuid_is_amd_compatible(vcpu));
 }
 
 static void __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47d9f03b7778..ebcc12d1e1de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3470,7 +3470,7 @@ static bool is_mci_status_msr(u32 msr)
 static bool can_set_mci_status(struct kvm_vcpu *vcpu)
 {
 	/* McStatusWrEn enabled? */
-	if (guest_cpuid_is_amd_or_hygon(vcpu))
+	if (guest_cpuid_is_amd_compatible(vcpu))
 		return !!(vcpu->arch.msr_hwcr & BIT_ULL(18));
 
 	return false;
-- 
2.44.0.478.gd926399ef9-goog


