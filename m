Return-Path: <kvm+bounces-48907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 470ABAD4654
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B075F1885A0F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6357260582;
	Tue, 10 Jun 2025 22:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yZbxzrb0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B092E62C0
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596302; cv=none; b=IWiGWR6r8aPY23WL7iV104VDgH7fgZxmNkQvHDdxZTp869JYM68Rz8hASUOedGrgvh22wAv+OEuhe1x/P5+z5OQAULDVvdIhQIfLg+rXTuEY43vC6bS+/GdzuDfGj4a8AefLfBU0J+W0BlWqLqb4c1hteu8k6C3CED4j+f0otDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596302; c=relaxed/simple;
	bh=f/EAWvczmGlis0EJoXnBgZhe5pWyfnEdUlP3dM2tmoI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b+z7BvDVW4OEpxnIAjn/wgOIXQiRIgU68vxB4Ue21B9/2Zw3z5/TYFcb0AlY+p/xmvFeq6G3gGrhw9WaY3iwUQf8LJ3wHe2FvuwYcxCKAYOsPVzO3MaeSta1N4NIYZ7sThLxTHsZ9hOQ5Lvfk5RRVC1LYYSekGWEt0xaASput0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yZbxzrb0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312df02acf5so190122a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596300; x=1750201100; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3aERknNfpUpnNzDb0X+4tA2Uq/yHJSwlZpcjPIafQX0=;
        b=yZbxzrb0adQtaSiov8OAj4ZH0bk7vrG2GiPM5mvtug6hiviaIj0t+51NVnU1VcoP2c
         zF72wdWL5Lv32ogv50+7gKbnEj2czJyHT2ZMYa7be+MJAoEQ5CuAmxTHrzcSEtNgjpZe
         BHY2aJuFQmKSfsd690Ph69LWHUc/Mpntc42iJc7VohL9HiA/Gs2DtgE+UsgpJRLuM95C
         m9WvD39M64ocFbnvZg9jlzvEe7oFx/qSYWuwmS3wuC8pUsszFJWEV4GBWtviACiwpwUX
         8Q7r9FoCx7QURzEs3LU/qCs4xfqckRZzQWyUppOV8WaZepUmu0z0oo2w0n38BwlEwND/
         /7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596300; x=1750201100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3aERknNfpUpnNzDb0X+4tA2Uq/yHJSwlZpcjPIafQX0=;
        b=EigvupDqG9c4q9FKVjz/mDrQ1MCJHTQw1UE0VulB4AYll6ScZSH5Utx3XkSaSn8yhO
         Zgg8fNzJdxxExh8Jug7YCBsITOWnfFbZS7LAfnA3wvHh+77K4JHDrpvEIFq4gSQ4bvyC
         xYIA7y1LocLSSAoW5mB90sPOSJSm3Iy7nxKipmRRCLpszI5RuKY85/bP1P7W1Z1Rtgwj
         X+P2oroDxfLyALzNxnlQYTl/ujfer3IQew6FyNjymNcdjEcBEkpfHvzNSGYLRLLIlW79
         g/kOOX844ll9gqrKj8iNQ/1QiYm3qcoT98/J+4fFBKaBBon3XLZuFc7G0hbKrj9eL0de
         nD+w==
X-Gm-Message-State: AOJu0Yw6DU2V4twcSlQvXg4Uy5hODcZFYheJRTFESoewz4VeLjuJpJSB
	SdvIJyQ6t7eAuWxKlj5zc/2VKB5Se22kOMwgwAjbroSV+4LeFM9is2ALWhnnq0wvo65UB1HTZ75
	2EGb96A==
X-Google-Smtp-Source: AGHT+IGlzYkxdQ3jNmoKIUKmRdKv/2EfCT350E/6eTwy54a2Ok9AGh8+muDwBdz1XTmZyCV98h6a07IqxRU=
X-Received: from pjbsz14.prod.google.com ([2002:a17:90b:2d4e:b0:311:d264:6f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dcc:b0:30e:6a9d:d78b
 with SMTP id 98e67ed59e1d1-313af941543mr1391860a91.12.1749596299766; Tue, 10
 Jun 2025 15:58:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:28 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-24-seanjc@google.com>
Subject: [PATCH v2 23/32] KVM: SVM: Merge "after set CPUID" intercept recalc helpers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
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
index be2e6914e9d9..59088f68c557 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1075,9 +1075,10 @@ void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
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
@@ -1096,11 +1097,6 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
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
@@ -1117,7 +1113,11 @@ static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 	}
+}
 
+static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	svm_recalc_instruction_intercepts(vcpu);
 	svm_recalc_msr_intercepts(vcpu);
 }
 
@@ -1243,8 +1243,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
-	svm_recalc_instruction_intercepts(vcpu, svm);
-
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -4509,8 +4507,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (guest_cpuid_is_intel_compatible(vcpu))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
-	svm_recalc_instruction_intercepts(vcpu, svm);
-
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


