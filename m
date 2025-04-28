Return-Path: <kvm+bounces-44619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBEFEA9FD51
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F09A1A87B9B
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 22:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E3E2135C7;
	Mon, 28 Apr 2025 22:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F7Ddex0h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C12C210184
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745881140; cv=none; b=fx280ck5i5DjbrR2hqAL9QGkodbEzo/3girKU+gzzLHGmMYa3FQSRmy9Ldk3LDmlmVG4GT1qM2MWV7Chj/bJUNBjkIWy7rAXvUElK/0omYExjaa8LzEfrIbetSkub6eKUZldXcBp4rwJagNmJJadulfmuqyeMd7PhVHX6BShZAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745881140; c=relaxed/simple;
	bh=RIX4Kwt34hcbslmf4nvbrtcvGmHfBuA915iIyWV1G0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SGoluSb4Y8j5EQNK5ONe1nj9/NF6EPWyI1FIjRiq+Y/5+sXXuC2pTrN1JNa/McFDW2hNEj+c6Fc4rPhjUkhm9QLcOx/Z4M45MiHGHP2/DCR6CxfUxjwmPRm6w9/DVyg+EICnMKs+qaPIWaEdFhwhkICD8gauSsV6qh+lIryPx48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F7Ddex0h; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-224364f2492so38985265ad.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 15:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745881137; x=1746485937; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+a7zPclX7FI9TXPBv9nI9R812htaSbFg8fCv5xqaUYY=;
        b=F7Ddex0hQiKUMiAxhsJFm7H12p26P3xlm7iJaMkG8ql4AiD/wIQQ043l8wYY3AVnwj
         r7oBercWEnrxKE8Lm+CjPK7ijEoQrgPORm9J+iNkDF+7CrXTS8Ny2Kr2ogFk+bGiqmIP
         UCW97/5GKY/FFCtl+w5Sin25JjGfFyjVEruSpja/ayIQcbYQ3F9CuuQ9fVB0dUJvQzqm
         tqvzht3M/lLJ53HhPFxx93LtIBgRO8MH50elTksYj8gaJX70hwCi4ZPQmdOeitT1QXtI
         4GsMRirCY7oYUUTXsvOw9sMtx0A//5fu0VIWFe9999W/Pvat7tHmeDiNsKwOSRzvFy3+
         FBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745881137; x=1746485937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+a7zPclX7FI9TXPBv9nI9R812htaSbFg8fCv5xqaUYY=;
        b=G1vajxE4RGRcWiG+3Lmrl7G7pYXD/LNQbSUGRU6rCj3pOsuIfvttsPa5WtgNpJnX8S
         d2IRfYT8AB8E2EW4KtW5Wj7VvSBBA+kgMp0gU1oPgFfOkNd+TJQtCkFuOkXOF7cdHA6N
         mQJ3bwEphrcraMCdnp+A1/4CaU9gVN46pROwtFmYQQecQTXHdBhMbTMd7ni6QqJ7vPeU
         7BFz6m6vSb0CMD20FT7JMwIp05+3yt1ZDtB0OQWNHHNRQ3JYt+a3Clicp0RBYNhi489M
         WwCgkaqsBRxViZYd8J1aMz/RjxZiI+3QfPPpTJ+uwLee1nIOTW6RTLSVIcH5YnXjbMLL
         OqKA==
X-Forwarded-Encrypted: i=1; AJvYcCXEAeizlDiKSbJnUKjXdTq6OmVEDg/cTDmAfeDa86FwqAbHqMW2dMaM8D54WLhPJFGRaH8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDdN63+Ck9cti3IJShPHhG7+c96BzwUXkWb5eJgXYbq8efunhf
	7qIS7LARgG/uWIk3vzO2n5bVINXvXatYiAxViFL7NZJDVuINu86ZuBcMEQ2O/SVvqytuBs7wULO
	VoA==
X-Google-Smtp-Source: AGHT+IEvZHozDkA4Ik3NDdiJwEua5M3JTELb7OyCHbNd5VAQvFbLEUkaY/6CDJLZt4RwobaUGj+GE5U6tdA=
X-Received: from plhl18.prod.google.com ([2002:a17:903:1212:b0:223:3ab:e4a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a05:b0:21f:3e2d:7d42
 with SMTP id d9443c01a7336-22dc6a08d51mr167921165ad.23.1745881137613; Mon, 28
 Apr 2025 15:58:57 -0700 (PDT)
Date: Mon, 28 Apr 2025 15:58:55 -0700
In-Reply-To: <20250321221444.2449974-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com> <20250321221444.2449974-2-jmattson@google.com>
Message-ID: <aBAIL6oGYJ7IV85X@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 21, 2025, Jim Mattson wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2b52eb77e29c..6431cd33f06a 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7684,6 +7684,7 @@ Valid bits in args[0] are::
>    #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
>    #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
>    #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> +  #define KVM_X86_DISABLE_EXITS_APERFMPERF       (1 << 4)

Might be pre-existing with C-states, but I think the documentation needs to call
out that userspace is responsible for enumerating APERFMPERF in guest CPUID.

And more importantly, KVM either needs to honor APERFMPERF in each vCPU's CPUID,
or the documentation needs to call out that KVM doesn't honor guest CPUID for 
APERF/MPERF MSRs.  I don't have a strong preference either way, but I'm leaning
toward having KVM honor CPUID so that if someone copy+pastes the KVM selftest   
code for the host enabling, it'll do the right thing.  On the other hand, KVM  
doesn't (and shouldn't) fully emulate the MSRs, so I'm a-ok if we ignore CPUID
entirely (but document it).

Ignoring CPUID entirely would also make it easier to document that KVM doesn't
upport loading/saving C-state or APERF/MPERF MSRs via load/store lists on VM-Enter
and VM-Exit.  E.g. we can simply say KVM doesn't emulate the MSRs in any capacity,
and that the capability disable the exit/interception, no more no less.

Heh, I guess maybe I've talked myself into having KVM ignore guest CPUID :-) 

> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ea44c1da5a7c..5b38d5c00788 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	48
> +#define MAX_DIRECT_ACCESS_MSRS	50

Ugh, I really need to get the MSR interception cleanup series posted.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b64ab350bcd..1b3cdca806b4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4535,6 +4535,9 @@ static u64 kvm_get_allowed_disable_exits(void)
>  {
>  	u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
>  
> +	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
> +		r |= KVM_X86_DISABLE_EXITS_APERFMPERF;
> +
>  	if (!mitigate_smt_rsb) {
>  		r |= KVM_X86_DISABLE_EXITS_HLT |
>  			KVM_X86_DISABLE_EXITS_CSTATE;
> @@ -6543,7 +6546,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  
>  		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
>  		    cpu_smt_possible() &&
> -		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
> +		    (cap->args[0] & ~(KVM_X86_DISABLE_EXITS_PAUSE |
> +				      KVM_X86_DISABLE_EXITS_APERFMPERF)))
>  			pr_warn_once(SMT_RSB_MSG);
>  
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> @@ -6554,6 +6558,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.hlt_in_guest = true;
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
>  			kvm->arch.cstate_in_guest = true;
> +		if (cap->args[0] & KVM_X86_DISABLE_EXITS_APERFMPERF)
> +			kvm->arch.aperfmperf_in_guest = true;

Rather that an ever-growing stream of a booleans, what about tracing the flags
as a u64 and providing a builder macro to generate the helper?  The latter is a
bit gratuitous, but this seems like the type of boilerplate that would be
embarassingly easy to screw up without anyone noticing.

Very lightly tested...

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 28 Apr 2025 11:35:47 -0700
Subject: [PATCH] KVM: x86: Consolidate DISABLE_EXITS_xxx handling into a
 single kvm_arch field

Replace the individual xxx_in_guest booleans with a single field to track
exits that have been disabled for a VM.  To further cut down on the amount
of boilerplate needed for each disabled exit, add a builder macro to
generate the accessor.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              | 25 ++++++++-----------------
 arch/x86/kvm/x86.h              | 28 +++++++++-------------------
 5 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c06f3d6e081..4b174499b29c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1389,10 +1389,7 @@ struct kvm_arch {
 
 	gpa_t wall_clock;
 
-	bool mwait_in_guest;
-	bool hlt_in_guest;
-	bool pause_in_guest;
-	bool cstate_in_guest;
+	u64 disabled_exits;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc1c721ba067..0f0c06be85d6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5053,7 +5053,7 @@ static int svm_vm_init(struct kvm *kvm)
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
-		kvm->arch.pause_in_guest = true;
+		kvm->arch.disabled_exits |= KVM_X86_DISABLE_EXITS_PAUSE;
 
 	if (enable_apicv) {
 		int ret = avic_vm_init(kvm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef2d7208dd20..109ade8fc47b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7613,7 +7613,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 int vmx_vm_init(struct kvm *kvm)
 {
 	if (!ple_gap)
-		kvm->arch.pause_in_guest = true;
+		kvm->arch.disabled_exits |= KVM_X86_DISABLE_EXITS_PAUSE;
 
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f6ce044b090a..3800d6cfecce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6591,27 +6591,18 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			break;
 
 		mutex_lock(&kvm->lock);
-		if (kvm->created_vcpus)
-			goto disable_exits_unlock;
-
+		if (!kvm->created_vcpus) {
 #define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
 		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."
 
-		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
-		    cpu_smt_possible() &&
-		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
-			pr_warn_once(SMT_RSB_MSG);
+			if (!mitigate_smt_rsb && cpu_smt_possible() &&
+			    boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
+			    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+				pr_warn_once(SMT_RSB_MSG);
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
-		r = 0;
-disable_exits_unlock:
+			kvm->arch.disabled_exits |= cap->args[0];
+			r = 0;
+		}
 		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 88a9475899c8..1675017eea88 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -481,25 +481,15 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 	    __rem;						\
 	 })
 
-static inline bool kvm_mwait_in_guest(struct kvm *kvm)
-{
-	return kvm->arch.mwait_in_guest;
-}
-
-static inline bool kvm_hlt_in_guest(struct kvm *kvm)
-{
-	return kvm->arch.hlt_in_guest;
-}
-
-static inline bool kvm_pause_in_guest(struct kvm *kvm)
-{
-	return kvm->arch.pause_in_guest;
-}
-
-static inline bool kvm_cstate_in_guest(struct kvm *kvm)
-{
-	return kvm->arch.cstate_in_guest;
-}
+#define BUILD_DISABLED_EXITS_HELPER(lname, uname)				\
+static inline bool kvm_##lname##_in_guest(struct kvm *kvm)			\
+{										\
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_##uname;	\
+}
+BUILD_DISABLED_EXITS_HELPER(hlt, HLT);
+BUILD_DISABLED_EXITS_HELPER(pause, PAUSE);
+BUILD_DISABLED_EXITS_HELPER(mwait, MWAIT);
+BUILD_DISABLED_EXITS_HELPER(cstate, CSTATE);
 
 static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
 {

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
--

