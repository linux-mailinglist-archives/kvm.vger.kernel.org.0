Return-Path: <kvm+bounces-50775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 705D8AE9346
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D7761C20398
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58175136358;
	Thu, 26 Jun 2025 00:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RZAC4igl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6B921348
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896752; cv=none; b=Uu+ObE+R4o7BbCOAIFbbe8bTV2g5ZSr89L5Ni0mUNk/BUoEagP5r1oOU82jYApm0m+dEHRe8nOJkb+lQxCoQbaoKQXYGFMmIQuvu2qoJ4OObZU/KeScULlmxArAMB3Pex0QjdrgRRZUkPv+Krwq8cFD+x+E+9KPQQhQtZ8FXaJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896752; c=relaxed/simple;
	bh=2XyDfFWH/0eDwvNxvoMEhqm8qOkWL90TlQT4lYrrQX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=thQT9Azzw9chafA1RAUO0HNpf6oZl1znKH7OiMXnJWgdFfCURn1oQbhbWlTiy15lQqgmDlIAlKtAfbk13QmkjxXy/B002zncl4Bp/ODQLDh8ShD44W1IZu2Gef9PznLYSFN28yWJSRmomEREltVDaJdq5MYxtmbMZnh7hFu5QL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RZAC4igl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e671316so335678a91.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 17:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750896750; x=1751501550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XIDgjwUm8CjgtXg9AIcmlFZZ7eZmoPHxzXcxCBew1V0=;
        b=RZAC4iglHDc5wFi5q3yqGFjPakn8kr1A7dPSAmqa1fhRxDppBSuhFxdmXgCipNd2SD
         s5+bMK70UA0lJZxbmumw0gRV/Qpuj6DLs8plH4pE8X7VjGEfrji88BuGbyyOl0E8e0WH
         ZSFE888OtxweQHNUd+l18qw6qPJW95DJNjnM7F0TAJrJ2O2nZGURWBKeZYGImrRWlJgz
         qyryiiE5sVAxg3ojccoa29ePlbd+lvAVkVd5mkUlrwPeFtvRJxJALJmfIUmw9iFwjQrv
         Bfqim8qncHG8l9BOjMKKLQpgrDaCK6cDXsU5mb0ukcseGpM9mDa5MTkbWRHCiCjfoKuf
         GXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750896750; x=1751501550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIDgjwUm8CjgtXg9AIcmlFZZ7eZmoPHxzXcxCBew1V0=;
        b=dCIxhxRueqBnaYLct2u6dX72M+N3fDOzSsxNhMjrlyMKZK0d2ICShRnkArKL72VRT5
         z0xi8d6fZdbmFVmJb7DfjPF4gZamZ4ZEnGwfK1hT3iujm3jA8jokIq0I8s0S+AtaZmSz
         /BcCwP47WH634JSdPcclpE+rmLud9Tlg0R30QqFbcvqRVXsfRMFHqoQCWgU6PfOykyIC
         mh/3OkxW4uaPGYFvuZVzbiJdSBLReQYvFGGyC/P7V1S93EZowq7D4DLfyxSaJYhgV2Mb
         qFSevi04H9O4DLYTlvf7Yq7qU3R14R1JPoMJ56EeLetlrpfkq9JlL9/IwK2TB2h/YfO/
         DwkA==
X-Gm-Message-State: AOJu0YxE3/o+kCQSwzhrM3/AWAKyLN/D1/PN0tQx+fYqtQV51TVUCt2t
	KKFt7tqCbGugoYYxWn0HcchVQIoJf6bdWmKsVXXPk58xI+6qTdaDYa5gq4vbg3GsVGOWc6TWddC
	8+NxAaw==
X-Google-Smtp-Source: AGHT+IFxqzI3I7qPfHhdkJFEVHE7dAj1xtEraHFWyog88QsjEjNsPNLon63KPUv4mv/v10Bg3S343op+M7c=
X-Received: from pjvf13.prod.google.com ([2002:a17:90a:da8d:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5345:b0:311:1617:5bc4
 with SMTP id 98e67ed59e1d1-316ed3a99d5mr1851989a91.12.1750896750459; Wed, 25
 Jun 2025 17:12:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 25 Jun 2025 17:12:21 -0700
In-Reply-To: <20250626001225.744268-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626001225.744268-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626001225.744268-2-seanjc@google.com>
Subject: [PATCH v5 1/5] KVM: x86: Replace growing set of *_in_guest bools with
 a u64
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

Store each "disabled exit" boolean in a single bit rather than a byte.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250530185239.2335185-2-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              |  9 +--------
 arch/x86/kvm/x86.h              | 13 +++++++++----
 5 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bf26dfb5416d..6fdeeb5870b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1407,10 +1407,7 @@ struct kvm_arch {
 
 	gpa_t wall_clock;
 
-	bool mwait_in_guest;
-	bool hlt_in_guest;
-	bool pause_in_guest;
-	bool cstate_in_guest;
+	u64 disabled_exits;
 
 	s64 kvmclock_offset;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab11d1d0ec51..5ad54640314f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5015,7 +5015,7 @@ static int svm_vm_init(struct kvm *kvm)
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
-		kvm->arch.pause_in_guest = true;
+		kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
 
 	if (enable_apicv) {
 		int ret = avic_vm_init(kvm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 65949882afa9..702486e7511c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7519,7 +7519,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 int vmx_vm_init(struct kvm *kvm)
 {
 	if (!ple_gap)
-		kvm->arch.pause_in_guest = true;
+		kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
 
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2806f7104295..2d893993262b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6481,14 +6481,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
 			pr_warn_once(SMT_RSB_MSG);
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+		kvm_disable_exits(kvm, cap->args[0]);
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index db4e6a90e83d..31ae58b765f3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -521,24 +521,29 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 	    __rem;						\
 	 })
 
+static inline void kvm_disable_exits(struct kvm *kvm, u64 mask)
+{
+	kvm->arch.disabled_exits |= mask;
+}
+
 static inline bool kvm_mwait_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.mwait_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_MWAIT;
 }
 
 static inline bool kvm_hlt_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.hlt_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_HLT;
 }
 
 static inline bool kvm_pause_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.pause_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_PAUSE;
 }
 
 static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.cstate_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_CSTATE;
 }
 
 static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
-- 
2.50.0.727.gbf7dc18ff4-goog


