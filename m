Return-Path: <kvm+bounces-45431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57BFAAA98FB
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D57631B61364
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 16:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EF517A31E;
	Mon,  5 May 2025 16:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F1sA/5qA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FAF25C83C
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462609; cv=none; b=h6tvUD12BCBIWxzqI8waD6F/V3nDnPqm9M1eMPvLUKHGQ1WBuv8YywNy6Pd3lADTq6dTLTrf7ALXbSz/TfQKxTc6GxJbwM7EsR0jid3TVRHHD46m3X50uM/ANaGoccLEI3sDWcvNkVjB41ShPtHoG7piUuVdkg9TnKlekP/DLgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462609; c=relaxed/simple;
	bh=H6VsQ3ag4QIbMJJwLIn5s+PQRj0m/of7xuBQfifzTNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eqyJObR6OSbMBRNFi5JZpLiFv3cYawVOano4GHPf44rOUbN+w5rEDilBvCnnEMMHyfNy/ji5c5PN5ZeOMECHYsnJ14DGNR1zeRKK6gj5sHTI3Q22S8vhc2OkE+v1RxVRSaZVQ+kfFvrtk74QsjlDkRO44L9o2ldjuhV14mJyOm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F1sA/5qA; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7394792f83cso3497661b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 09:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746462607; x=1747067407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VkzCOh0jkJV3D2UkVWO21Y95jmzysYfbX+jTMC9XHaA=;
        b=F1sA/5qAU1e56WUUig/6J1cMHXdEsAOgerGE3GF24kFXalPqSYSt5r7qH+1Apj6xHS
         RjK7MHdNBFAufVfssqZUQsF++gKzYF5bf0xnHjagGvTOjHR7flHbeRLX9DGy3HNUZ3cO
         nsvHRyVqdEHJC8HfzBsjMlJqT6002h/2x6uH7fjuSu2DwbKpOH4OS9jXuRVzOJHhj5JA
         gGDkWObmaFfJ4St4xzJ/8t0Ey+0186Fo2OLleVnFeOSyRQEVeP5InLAyACz7lRPhdURl
         adH7Z1oJJ9U656j686WH1p01rVnqvzUiNnLKolHFQgPpbyQf3UfvB10w+AFO6H1hebX0
         A7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462607; x=1747067407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkzCOh0jkJV3D2UkVWO21Y95jmzysYfbX+jTMC9XHaA=;
        b=Ckl/jltRhVFibvnMGG6v+16gLD6Bt5cMDBa1FCKPgP7dscQFqDNfPAw2TLgI5vobgp
         SV4HecshwAQg4n2kfJ9KCSnuBZn2+MJ+buOVAau9wZ+opQ4aXuD7Kv8H7IgHhOs23xwx
         a9eQZphVimhDalB4mwfyd1uW1jQKW4tae6jHMbiTLa33U6hlLJYdQaFxl49jWiKL/0Gc
         WZiljsvp100rgA67LcPg+Rhe+T+domjsnZOVagSdELZxQWS6Qzp4adHlaOkMlMWtr7Kx
         jgaKD4pXb6ZQGOQfVKLFykeBQ1Fkl3r2a7mPcQGwNYFx/7MFOOLslFMxtRY+Mx1TnusL
         c0iA==
X-Forwarded-Encrypted: i=1; AJvYcCUqVXqmRRVqZ00SqdXxu8lg8KfaPQ+43CyI562EAyZBRwRklX1rO2a/MPEeRc7252Y6xEo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp3dld7pUffRt3QjTquyp2tVAWtQV8HU9q1Jtb/z8wJo3URDGh
	C8T20Ht9MV6pEKvHYJodsAmTTLyCi2kbHfxGe7iJV3DV3kY/m6LOOxg+i3bGEN3tCqZt7SbM8Mg
	PJA==
X-Google-Smtp-Source: AGHT+IG56pQZFfDC0atRju7067QzQAi4LAHqfakmnwJ1czJMt2mWwK9DekzpfKSa8yYXzH9Paj6xHccuq+c=
X-Received: from pfgu9.prod.google.com ([2002:a05:6a00:989:b0:73c:25ef:3578])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1384:b0:740:596b:eaf4
 with SMTP id d2e1a72fcca58-740673f2464mr14271331b3a.16.1746462607289; Mon, 05
 May 2025 09:30:07 -0700 (PDT)
Date: Mon, 5 May 2025 09:30:05 -0700
In-Reply-To: <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z7OUZhyPHNtZvwGJ@Asmaa.> <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev> <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local> <aBKzPyqNTwogNLln@google.com>
 <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local> <aBOnzNCngyS_pQIW@google.com>
 <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local> <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
Message-ID: <aBjnjaK0wqnQBz8M@google.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
From: Sean Christopherson <seanjc@google.com>
To: David Kaplan <David.Kaplan@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Patrick Bellasi <derkling@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Patrick Bellasi <derkling@matbug.net>, 
	Brendan Jackman <jackmanb@google.com>, Michael Larabel <Michael@michaellarabel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, David Kaplan wrote:
> > On Thu, May 01, 2025 at 09:56:44AM -0700, Sean Christopherson wrote:
> > > Heh, I considered that, and even tried it this morning because I
> > > thought it wouldn't be as tricky as I first thought, but turns out,
> > > yeah, it's tricky.  The complication is that KVM needs to ensure
> > BP_SPEC_REDUCE=1 on all CPUs before any VM is created.
> > >
> > > I thought it wouldn't be _that_ tricky once I realized the 1=>0 case
> > > doesn't require ordering, e.g. running host code while other CPUs have
> > > BP_SPEC_REDUCE=1 is totally fine, KVM just needs to ensure no guest code is
> > executed with BP_SPEC_REDUCE=0.
> > > But guarding against all the possible edge cases is comically difficult.
> > >
> > > For giggles, I did get it working, but it's a rather absurd amount of
> > > complexity
> >
> > Thanks for taking the time to explain - that's, well, funky. :-\
> >
> > Btw, in talking about this, David had this other idea which sounds
> > interesting:
> >
> > How about we do a per-CPU var which holds down whether BP_SPEC_REDUCE is
> > enabled on the CPU?
> >
> > It'll toggle the MSR bit before VMRUN on the CPU when num VMs goes 0=>1. This
> > way you avoid the IPIs and you set the bit on time.
> 
> Almost.  My thought was that kvm_run could do something like:
> 
> If (!this_cpu_read(bp_spec_reduce_is_set)) {
>    wrmsrl to set BP_SEC_REDUCE
>    this_cpu_write(bp_spec_reduce_is_set, 1)
> }
> 
> That ensures the bit is set for your core before VMRUN.  And as noted below,
> you can clear the bit when the count drops to 0 but that one is safe from
> race conditions.

/facepalm

I keep inverting the scenario in my head.  I'm so used to KVM needing to ensure
it doesn't run with guest state that I keep forgetting that running with
BP_SPEC_REDUCE=1 is fine, just a bit slower.

With that in mind, the best blend of simplicity and performance is likely to hook
svm_prepare_switch_to_guest() and svm_prepare_host_switch().  switch_to_guest()
is called when KVM is about to do VMRUN, and host_switch() is called when the
vCPU is put, i.e. when the task is scheduled out or when KVM_RUN exits to
userspace.

The existing svm->guest_state_loaded guard avoids toggling the bit when KVM
handles a VM-Exit and re-enters the guest.  The kernel may run a non-trivial
amount of code with BP_SPEC_REDUCE, e.g. if #NPF triggers swap-in, an IRQ arrives
while handling the exit, etc., but that's all fine from a security perspective.

IIUC, per Boris[*] an IBPB is needed when toggling BP_SPEC_REDUCE on-demand:

 : You want to IBPB before clearing the MSR as otherwise host kernel will be
 : running with the mistrained gunk from the guest.

[*] https://lore.kernel.org/all/20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local

Assuming that's the case...

Compile-tested only.  If this looks/sounds sane, I'll test the mechanics and
write a changelog.

---
 arch/x86/include/asm/msr-index.h |  2 +-
 arch/x86/kvm/svm/svm.c           | 26 +++++++++++++++++++-------
 arch/x86/kvm/x86.h               |  1 +
 arch/x86/lib/msr.c               |  2 --
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e6134ef2263d..0cc9267b872e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -725,7 +725,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
-#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE	BIT(4)
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc1c721ba067..2d87ec216811 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -607,9 +607,6 @@ static void svm_disable_virtualization_cpu(void)
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
-
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -687,9 +684,6 @@ static int svm_enable_virtualization_cpu(void)
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
-
 	return 0;
 }
 
@@ -1550,12 +1544,25 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		wrmsrl(MSR_ZEN4_BP_CFG, kvm_host.zen4_bp_cfg |
+					MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE);
+
 	svm->guest_state_loaded = true;
 }
 
 static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 {
-	to_svm(vcpu)->guest_state_loaded = false;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!svm->guest_state_loaded)
+		return;
+
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+		indirect_branch_prediction_barrier();
+		rdmsrl(MSR_ZEN4_BP_CFG, kvm_host.zen4_bp_cfg);
+	}
+	svm->guest_state_loaded = false;
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -5364,6 +5371,11 @@ static __init int svm_hardware_setup(void)
 
 	init_msrpm_offsets();
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+		rdmsrl(MSR_ZEN4_BP_CFG, kvm_host.zen4_bp_cfg);
+		WARN_ON(kvm_host.zen4_bp_cfg & MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE);
+	}
+
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				     XFEATURE_MASK_BNDCSR);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 88a9475899c8..629eae9e4f59 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -51,6 +51,7 @@ struct kvm_host_values {
 	u64 xcr0;
 	u64 xss;
 	u64 arch_capabilities;
+	u64 zen4_bp_cfg;
 };
 
 void kvm_spurious_fault(void);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 5a18ecc04a6c..4bf4fad5b148 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -103,7 +103,6 @@ int msr_set_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, true);
 }
-EXPORT_SYMBOL_GPL(msr_set_bit);
 
 /**
  * msr_clear_bit - Clear @bit in a MSR @msr.
@@ -119,7 +118,6 @@ int msr_clear_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, false);
 }
-EXPORT_SYMBOL_GPL(msr_clear_bit);
 
 #ifdef CONFIG_TRACEPOINTS
 void do_trace_write_msr(unsigned int msr, u64 val, int failed)

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
-- 

