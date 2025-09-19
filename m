Return-Path: <kvm+bounces-58162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03946B8A8D8
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF667C68FF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B0C321272;
	Fri, 19 Sep 2025 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ej8Vhxqx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4219D261B95
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758299010; cv=none; b=pe1+Yvc0SCSK2qBXS1I7DsiabKPbf+7XOVZ0wFdNUyxbiKWIQaQ5ANZjWRe/g5PFPx2AnWyG4DWPxHniS28H3k0lOWQNeAE/le4sJkJTSjRT/3kky5r+4ep/rBN2L8+YPQslBzOLwunyFX2FUANoSuk0CccdhM/8ePVp3QgxROQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758299010; c=relaxed/simple;
	bh=o+JmEvBu7MRG0FR5BBM6u6yNDcuq0zrETHuEcnSo6ZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=szsU2mZzt1oVYIIQAEABmp4Ub/5mjmlOwJbZhE4tzHqnZcoV8qdb5BOILgVBqWGbBhtj0vtuHxr8Qsly36cyr04+n0Zrxii10WuE3dowZgh565sbIrqdiWWpaG/08RgODKtWlAqffUa4NBjUXbkwZ7n1oEzCA8aCO9WFlCXLFYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ej8Vhxqx; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77e4aeb8a58so948408b3a.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 09:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758299007; x=1758903807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4CkjkLFnbWsqOFWSnZjaXIU/dPJiCCdZNrv4DrVKug=;
        b=ej8VhxqxadIwoMx99laEWgVPlsjmrxDg7eEjV3GTRM7woVVSPi/8r7zmfebJL+5zqh
         0W5BedG7XCBcM17ODUSuBMvEwcLX9YkPKjOVTVcNN5SM6mF69iMd1Vc2jyjux5hLPQ4i
         mpPMtj4jdjFNa27kyxvhTzSB403HhLx3uRjRPCs7/h2zMIIpSKcdhRIr9yn/EKJgvtVn
         EddKEZiYjjCKuqyvmCjU5Yl3kthuc0SXSIO1Q8CRoi3xG4RJuh1xunxzU6+6S5TbwuFg
         HsTQEflEXqYYFVKI+JFaT/wG1DaZpBmujc/3SsVeD6SJ6ZEvWLPC2HNJ8qxMMeJ286cO
         lvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758299007; x=1758903807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4CkjkLFnbWsqOFWSnZjaXIU/dPJiCCdZNrv4DrVKug=;
        b=OfE5mXtFwYpYFYhXv5bDMjL51vqGOYYis5ls1WZqfSVlwKFlf7bBhJKqStC4iXrwnR
         Xui5ZvdNVWAj92UgKL8S8C+VQyfhBPahUl/9809D+0+hixin+ekZ+WjaqQ4Fh4KCheY2
         u1uACwndwAjiGU6wqFLAuWRjmv9mmxxfKeollO0miYhoihmitaBwLagr6qATTLKqRBpf
         GSAJyc8u2/NZc7IzbKkD15bNFmEyn4jknujJZ2vToYtjB0fKnXz6HVTDKOeWSkGM8h+S
         OJ9fh3hrla0GXgnB8IayhT7WGmklyyYoumXEth5zg3K1op/ILSjbZLfztdw6NCocbToO
         DfbQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9WsJOexgFO9JkuSlnzsG//DWBjCzwgekvET57R0kvsl3VaBsuNGEiTndcaAslyO/CRiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUH/TQI2IASe1xSWEpCPKBf17oQ+zLEZ/GsukxQGFNVsJqhTTh
	asA049Zyg7TtHBGW6k7QOcrNJ36YPYLjDMigPo7RptNBYRSKjKZbeuQ4P812bsTYys3PAxX02T2
	egRA+Dw==
X-Google-Smtp-Source: AGHT+IFsIJ9fZX8xD6w4IgrFqpCt5VcYPGzLRJ5JTAJQke9Nrf+zY87uqxGcHBF8BSu++yAI3dtr5opWMlY=
X-Received: from pjbqx3.prod.google.com ([2002:a17:90b:3e43:b0:32b:61c4:e48b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3293:b0:250:9175:96e3
 with SMTP id adf61e73a8af0-2926e08bb46mr5515672637.30.1758299007601; Fri, 19
 Sep 2025 09:23:27 -0700 (PDT)
Date: Fri, 19 Sep 2025 09:23:26 -0700
In-Reply-To: <20250919131535.GA73646@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com>
 <9da5eb48ccf403e1173484195d3d7d96978125b7.1758166596.git.houwenlong.hwl@antgroup.com>
 <9991df11-fe7c-41e1-9890-f0c38adc8137@amd.com> <20250919131535.GA73646@k08j02272.eu95sqa>
Message-ID: <aM2Dfu0n-JyYttaH@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Use cached value as restore value of
 TSC_AUX for SEV-ES guest
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 19, 2025, Hou Wenlong wrote:
> On Thu, Sep 18, 2025 at 01:47:06PM -0500, Tom Lendacky wrote:
> > On 9/17/25 22:38, Hou Wenlong wrote:
> > > The commit 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support
> > > for virtualized TSC_AUX") assumes that TSC_AUX is not changed by Linux
> > > post-boot, so it always restores the initial host value on #VMEXIT.
> > > However, this is not true in KVM, as it can be modified by user return
> > > MSR support for normal guests. If an SEV-ES guest always restores the
> > > initial host value on #VMEXIT, this may result in the cached value in
> > > user return MSR being different from the hardware value if the previous
> > > vCPU was a non-SEV-ES guest that had called kvm_set_user_return_msr().
> > > Consequently, this may pose a problem when switching back to that vCPU,
> > > as kvm_set_user_return_msr() would not update the hardware value because
> > > the cached value matches the target value. Unlike the TDX case, the
> > > SEV-ES guest has the ability to set the restore value in the host save
> > > area, and the cached value in the user return MSR is always the current
> > > hardware value. Therefore, the cached value could be used directly
> > > without RDMSR in svm_prepare_switch_to_guest(), making this change
> > > minimal.
> > 
> > I'm not sure I follow. If Linux never changes the value of TSC_AUX once it
> > has set it, then how can it ever be different? Have you seen this issue?
> > 
> > Thanks,
> > Tom
> >
> Hi, Tom.
> 
> IIUD, the normal guest still uses the user return MSR to load the guest
> TSC_AUX value into the hardware when TSC_AUX virtualization is
> supported.  However, the user return MSR only restores the host value
> when returning to userspace, rather than when the vCPU is scheduled out.
> This may lead to an issue during vCPU switching on a single pCPU, which
> appears as follows:
> 
>        normal vCPU -> SEV-ES vCPU -> normal vCPU
> 
> When the normal vCPU switches to the SEV-ES vCPU, the hardware TSC_AUX
> value remains as the guest value set in kvm_set_user_return_msr() by the
> normal vCPU.  After the #VMEXIT from the SEV-ES vCPU, the hardware value
> becomes the host value. However, the cached TSC_AUX value in the user
> return MSR remains the guest value of previous normal vCPU. Therefore,
> when switching back to that normal vCPU, kvm_set_user_return_msr() does
> not perform a WRMSR to load the guest value into the hardware, because
> the cached value matches the target value. As a result, during the
> execution of the normal vCPU, the normal vCPU would get an incorrect
> TSC_AUX value for RDTSCP/RDPID.
> 
> I didn't find the available description of TSC_AUX virtualization in
> APM; all my analysis is based on the current KVM code.

I'm guessing TSC_AUX virtualization works like SEV-ES, where hardware context
switches the MSR on VMRUN/#VMEXIT.

> Am I missing something?

Nope, I don't think so.  I also found the changelog a bit confusing though.  I
would say omit the details about Linux not changing the value, and instead focus
on the need to re-load the current hardware value.  That should be intuitive for
all readers, and is correct regradless of what/whose value is currently in hardware.

I also think we should handle setting hostsa->tsc_aux in
sev_es_prepare_switch_to_guest().  That obviously requires duplicating some of
logic related to SEV-ES and TSC_AUX, but I think I prefer that to splitting the
handling of the host save area.

How's this look? (compile tested only)

--
Subject: [PATCH] KVM: SVM: Re-load current, not host, TSC_AUX on #VMEXIT from
 SEV-ES guest

Prior to running an SEV-ES guest, set TSC_AUX in the host save area to the
current value in hardware, as tracked by the user return infrastructure,
instead of always loading the host's desired value for the CPU.  If the
pCPU is also running a non-SEV-ES vCPU, loading the hosts value on #VMEXIT
could clobber the other vCPU's value, e.g. if the SEV-ES vCPU preempted
the non-SEV-ES vCPU.

Note, unlike TDX, which blindly _zeroes_ TSC_AUX on exit, SEV-ES CPUs
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

base-commit: 60e396349c19320485a249005256d1fafee60290
--

