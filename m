Return-Path: <kvm+bounces-48057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41372AC8539
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08EDA1655E3
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E949258CD7;
	Thu, 29 May 2025 23:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lsLcAcMB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC6D266B5C
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562055; cv=none; b=n6m+a3wjUfnxGCuILoaVtmW+tvEp7Lzd9LajoY69LljB++NjVgYL9osRidf/meZgrT0VMA6XdtzY+ljD5MvQ7c8NFu2eTi6d5y7ZmtfoAsApQ7h1NCMLb4ilfE/vynVph5vcpky6x5A+izdMy8dz/xJT+U4/E4200+EgAwtePwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562055; c=relaxed/simple;
	bh=++Ox5d+DXiCY42PnE8lmaGXv0oH4mN+WmEJPpvVyn14=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=riWBHp0tOaRjzeS4f85w7Urhsd/zC0MWllJAbjxae8GPRhXXbM2gKwBZHM9FWhQuqbIp6NAhvIV5I1P+TSY9cyXHblucip39P1p0ju5L5fF8Zgzza2Wtl3KCc1aIWU1MZ0urkv+P8Ue5BLtDkC5E8ER1hnRcADT2pbaEwr3Nw54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lsLcAcMB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311b6d25278so1455045a91.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562053; x=1749166853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GxDEH2I3zlAqvCgosNWe3M4dcdToh1WoWvh1SBj+HqY=;
        b=lsLcAcMBv8W5G345XF04wCXTMnmLUqmEIzh72+kN8PFE6FQGBfrK2/rxFEnG8u5Mwq
         niwv/AQq1K/GiQU75fn+3Cb8YbPHE9CewQjwiWd/8VK8JnWNCLmTcRRfejnSmOSEXhdK
         pGpXMBlTBgRb80Vv5vAcjjN9e3B+XeS+9U/vndopSlE/8zX2ffEXh6KySyCB15ytrTZq
         IS9M5Z6bpH2CCF4MBJnKe7jWfrjnfVfonGZZw7/BZz85YbRaLZ4t5SuXiNagNG1zy94l
         3asXMEH1FM2/Cp15sgd0VAV8YvsUDiMVVkoHChoNS8lpxfBv7tTsmOpgFo8dzmzx6Mb8
         RbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562053; x=1749166853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GxDEH2I3zlAqvCgosNWe3M4dcdToh1WoWvh1SBj+HqY=;
        b=ZGVeRpBhJo2GcHK3uZnT5auyr8iYrZ/HiBxbX71DX37A7uSYJ6a3Ls09S8Yhvkpd7S
         xV3wkmQAusWOt6OmvE4sRkekm0tff/b/F0fYu6H5gpZFzagQNaAs3ujiMe/AfP0CXPCd
         VGgoD40DzrxkH7Mu+qk9yfaM1bBd9Nx82m8yt5/QZY5XwSPXKRxrgvOpcnlDODJx0KqH
         s1frlAbcFUJfJCp3HNMSKOWXmPOOjmM4PA8c84kdjKK7J/2lT6pCrlB+Cr8V0bdGfX0z
         I6HWa1Tv7sLJ35Bt5uD13h7k3op7zh78yMi1ydojsPlNqU3r53pmA3nJZuCIwKR7OGnc
         qlqw==
X-Gm-Message-State: AOJu0Yz7h+J0FNoKOM6ITI+atsssMKop7RKHd2jgHQVWp26ElKnmMD5S
	H62o4yBnV35UOr7fqwBDGVBEFKoqCGQBD6o8/x/p7FuARPo3mtHwULu2cSvWK7UGUoAqgy8GxHr
	ILBQCTA==
X-Google-Smtp-Source: AGHT+IFMMaWfKh45B1kec3L3aN0Q9ZzH6mNMeDqxBwlJYzUDz/YDra+mEZJ0TLYD5rwMsIShwj6cIab0VZU=
X-Received: from pjbsn11.prod.google.com ([2002:a17:90b:2e8b:b0:311:1a09:11ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cb:b0:312:26d9:d59c
 with SMTP id 98e67ed59e1d1-31241e8e674mr1666711a91.22.1748562053215; Thu, 29
 May 2025 16:40:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:06 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-22-seanjc@google.com>
Subject: [PATCH 21/28] KVM: SVM: Merge "after set CPUID" intercept recalc helpers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Merge svm_recalc_intercepts_after_set_cpuid() and
svm_recalc_instruction_intercepts() such that the "after set CPUID" helper
simply invokes the type-specific helpers (MSRs vs. instructions), i.e.
make svm_recalc_intercepts_after_set_cpuid() a single entry point for all
intercept updates that need to be performed after a CPUID change.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12fbfbf9acad..2ebac30a337a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1079,9 +1079,10 @@ void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 }
 
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
-static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
-					      struct vcpu_svm *svm)
+static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	/*
 	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
 	 * roots, or if INVPCID is disabled in the guest to inject #UD.
@@ -1100,11 +1101,6 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 		else
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
 	}
-}
-
-static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
@@ -1121,7 +1117,11 @@ static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 	}
+}
 
+static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	svm_recalc_instruction_intercepts(vcpu);
 	svm_recalc_msr_intercepts(vcpu);
 }
 
@@ -1247,8 +1247,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
-	svm_recalc_instruction_intercepts(vcpu, svm);
-
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -4513,8 +4511,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (guest_cpuid_is_intel_compatible(vcpu))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
-	svm_recalc_instruction_intercepts(vcpu, svm);
-
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
 
-- 
2.49.0.1204.g71687c7c1d-goog


