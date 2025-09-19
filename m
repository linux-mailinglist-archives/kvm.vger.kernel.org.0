Return-Path: <kvm+bounces-58201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD83B8B5FE
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 199297B431C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C112D640D;
	Fri, 19 Sep 2025 21:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="otaenuYN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37CD2D5935
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758317895; cv=none; b=ZkHHFemAg5aGT5U5bL7NNl7/O0oakUb4C9Y58AhGbJB89LOmMfP7tXOHMThNuOkNL1UqAPgTmnF6SKure8FFad0DyMAn5Zzc89UlTwHfXT+lNYA3EqNDDR1kK5DR4ZZl+L/8jnBJNTIPsjpdkTOrduSu0LNFbaYz5hgMnN1vVo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758317895; c=relaxed/simple;
	bh=lpaODm+/qpQpSIj093kiNaPlC2hsLBik3eGt3+YmRrU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejhJaMBTpTSt0u+VcvM6IdKPfwiKw/OPm2sPzJArGOi5HSyKZmQKLpD2FA+178z3Mwgl1/a0XAiwem8eRxL9xwHNfBvTMyAXKnq8/gKAM0cx3TNvDrGuRHTGWhR0Kd+1QRW41JQKb2QgGFcjlN+6JGZfjWaDfulz0tvlg96DJjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=otaenuYN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32edda89a37so2521897a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758317893; x=1758922693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Jl7pB47FGDGa3Hbf+CZa/QyTGuMzziA/0mliixnM26c=;
        b=otaenuYNsRktSQW+A54ZtyqqVwRUR0qjWKHEad0bhfdU5GpLDFH9GQZyJkEk0FGD9l
         RDhMys1ShfgiufiKtXzw99t1uxJkOXkZc5zq8uaWbjsr9J70iiZCBYZF1dbWXhJpdVju
         t0ZVzyI1CAEewdgrIrPJN4+Ay5byK4AXxx+r7eeWtLF7GdXAdJLqBa2cGO8BRNynHkmJ
         dXrkil/nIGv98RJV0VgKyYoIragTWST9Byw3CVLuuEGzRz6j9FXR4NMPxeSR/4UGnUve
         FEBRf74MfBgFoLQgME1oLsmSA49rXRucjnhxdmslpVtNXBoOg3z30uc2T4zuTaSbCnCx
         QydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758317893; x=1758922693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jl7pB47FGDGa3Hbf+CZa/QyTGuMzziA/0mliixnM26c=;
        b=WuyTd3Z1K3nipAUbJU6KkvsXsD7krIMnP3gSBkebbysLd9rKlG6EK5vYqPlbH61jRW
         XIrUn82I6ID45wmdmZ10u0D76zoSQ3QzWXTT212ywEcTMeLLbNX6KIZIq0UDSYiijrWk
         syRtYpwMIi0CGO4FDgS/V3kIdYTLU7/WvcUF6IyytYZ/DwasoKwTn9cla5yJRPdEuIsX
         UvLMuOw3nyrPjEulSwjZlQ9OUnCbV96xbfMXY9b2eCq/UbRSWWNO96e1qmGEL6XEgK53
         Qb/duaI+EvmHmbbVtp2grbY28Qhv+5gHNQMn1tSwTNuAkjWvRNkMZeJpmzbd/5ymuM4G
         pdEg==
X-Gm-Message-State: AOJu0YyVINB2doD86aymVdGfcags02pGKTw38OMU23O9Zj2s1Xv0xLHJ
	yCRekjL/z45Ft3U6qJz+JivQ0ZtuPh+47C8rt6xRl6mAR0M2H3kbQ4oVCHxYsJims32rZxkvhlB
	F/loAlQ==
X-Google-Smtp-Source: AGHT+IGVAWhnXKqq0Z1N62VySttB4ZbzHclc+0yjo3TJnUapsWsPTkSZWzMSC+3O14y37r5/UbcN03xv6LY=
X-Received: from pjbsi17.prod.google.com ([2002:a17:90b:5291:b0:32e:d644:b829])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c4:b0:32d:d8de:191e
 with SMTP id 98e67ed59e1d1-33097fed9c5mr5921652a91.10.1758317893197; Fri, 19
 Sep 2025 14:38:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:38:06 -0700
In-Reply-To: <20250919213806.1582673-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919213806.1582673-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919213806.1582673-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: SVM: Re-load current, not host, TSC_AUX on
 #VMEXIT from SEV-ES guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Prior to running an SEV-ES guest, set TSC_AUX in the host save area to the
current value in hardware, as tracked by the user return infrastructure,
instead of always loading the host's desired value for the CPU.  If the
pCPU is also running a non-SEV-ES vCPU, loading the host's value on #VMEXIT
could clobber the other vCPU's value, e.g. if the SEV-ES vCPU preempted
the non-SEV-ES vCPU, in which case KVM expects the other vCPU's TSC_AUX
value to be resident in hardware.

Note, unlike TDX, which blindly _zeroes_ TSC_AUX on TD-Exit, SEV-ES CPUs
can load an arbitrary value.  Stuff the current value in the host save
area instead of refreshing the user return cache so that KVM doesn't need
to track whether or not the vCPU actually enterred the guest and thus
loaded TSC_AUX from the host save area.

Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
Cc: stable@vger.kernel.org
Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
[sean: handle the SEV-ES case in sev_es_prepare_switch_to_guest()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 14 +++++++++++++-
 arch/x86/kvm/svm/svm.c | 26 +++++++-------------------
 arch/x86/kvm/svm/svm.h |  4 +++-
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cce48fff2e6c..95767b9d0d55 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4664,7 +4664,9 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm,
+				    struct sev_es_save_area *hostsa,
+				    int tsc_aux_uret_slot)
 {
 	struct kvm *kvm = svm->vcpu.kvm;
 
@@ -4712,6 +4714,16 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
 		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
 		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
 	}
+
+	/*
+	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
+	 * available, i.e. TSC_AUX is loaded on #VMEXIT from the host save area.
+	 * Set the save area to the current hardware value, i.e. the current
+	 * user return value, so that the correct value is restored on #VMEXIT.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_V_TSC_AUX) &&
+	    !WARN_ON_ONCE(tsc_aux_uret_slot < 0))
+		hostsa->tsc_aux = kvm_get_user_return_msr(tsc_aux_uret_slot);
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 67f4eed01526..662cf680faf7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -577,18 +577,6 @@ static int svm_enable_virtualization_cpu(void)
 
 	amd_pmu_enable_virt();
 
-	/*
-	 * If TSC_AUX virtualization is supported, TSC_AUX becomes a swap type
-	 * "B" field (see sev_es_prepare_switch_to_guest()) for SEV-ES guests.
-	 * Since Linux does not change the value of TSC_AUX once set, prime the
-	 * TSC_AUX field now to avoid a RDMSR on every vCPU run.
-	 */
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
-		u32 __maybe_unused msr_hi;
-
-		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
-	}
-
 	return 0;
 }
 
@@ -1400,16 +1388,17 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 */
 	vmsave(sd->save_area_pa);
 	if (sev_es_guest(vcpu->kvm))
-		sev_es_prepare_switch_to_guest(svm, sev_es_host_save_area(sd));
+		sev_es_prepare_switch_to_guest(svm, sev_es_host_save_area(sd),
+					       tsc_aux_uret_slot);
 
 	if (tsc_scaling)
 		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
 	/*
-	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
-	 * available. The user return MSR support is not required in this case
-	 * because TSC_AUX is restored on #VMEXIT from the host save area
-	 * (which has been initialized in svm_enable_virtualization_cpu()).
+	 * TSC_AUX is always virtualized (context switched by hardware) for
+	 * SEV-ES guests when the feature is available.  For non-SEV-ES guests,
+	 * context switch TSC_AUX via the user_return MSR infrastructure (not
+	 * all CPUs support TSC_AUX virtualization).
 	 */
 	if (likely(tsc_aux_uret_slot >= 0) &&
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
@@ -3004,8 +2993,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
 		 * feature is available. The user return MSR support is not
 		 * required in this case because TSC_AUX is restored on #VMEXIT
-		 * from the host save area (which has been initialized in
-		 * svm_enable_virtualization_cpu()).
+		 * from the host save area.
 		 */
 		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
 			break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d39c0b17988..4fda677e8ab3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -831,7 +831,9 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm,
+				    struct sev_es_save_area *hostsa,
+				    int tsc_aux_uret_slot);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 #ifdef CONFIG_KVM_AMD_SEV
-- 
2.51.0.470.ga7dc726c21-goog


