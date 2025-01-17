Return-Path: <kvm+bounces-35876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67522A15915
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F221D1883192
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C551AB51B;
	Fri, 17 Jan 2025 21:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eplXwJhN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C75C33062
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 21:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737149661; cv=none; b=oNMqCMutospum42SJYBrNfjYI9Oqb1QhWSOLPJC06GJWYW7X68d02eD3pd4wucYcJtdypEr6okhuJslfEmXcdZuia+mQhQO7Sd5bqpuf8yywHVGYSIZScDCXnQLgPZiU4tnma1uzI7beh0EYGIZdDUx0vdzksWBkV8F3jqpLXk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737149661; c=relaxed/simple;
	bh=k/7ffKZ7Kf94diYChATzI2DyIAbdxo51oTbL07RBoeY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QMPjz4jqQah2U+hFN6o3CS9rX2upeQ7208CBco1Jxtiwgw3Oy4f+g9bKITq4/xWFxDyhEOvTm5qSF29Xfi9Y7V6mwF6+Sn6QdKFNMP8G3H9I2GlC/okJwCenyvh9EuSHxkPaNbp4jaz+qf9sHQjmtVUbUsPiopA4khA1uFFbMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eplXwJhN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso5030144a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 13:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737149658; x=1737754458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H9/OR0qt3xGWmqY9a6MrXX86906jwKfUx1xrXz4V9ek=;
        b=eplXwJhNayiarVveuZTgC55Q8SO6uQPWffs0Ama95WumTkr9DGKAsyUPlwQdZwdTvj
         l+WsixpgaBVXZFzMbRt1BgbqdxHUe6crUP9gpRpCV9tUoAoDXZjrUzvqORHj/7xk7pJz
         C8sIKd/5YfvldBH2TGOz+48i7g3h4NjIU62Gvg66mhnuFOo9c85YhkPdtk3ic/z+IWNR
         iBGsJ49SRzuEPUSySRYtLrXkzOV9Zo58+mdveGXA6DdMZzKyNzyjMOqjoSq00GwBX77d
         vHERJ+te+Dk8eYVoTKgDhJXQ4mVww33RYfH3h6G0AbTNdRbQO/Tagnec3atcURqyg4M1
         gUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737149658; x=1737754458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H9/OR0qt3xGWmqY9a6MrXX86906jwKfUx1xrXz4V9ek=;
        b=Nzrtyjk1M2evTNBrGj8sJGg8FfHJK6JssTWr2Wwr4/Zz3skCZlS2XUvAI3KL3YBoRD
         s22rkzQHeS4ie5UUm8hubly1CHwYRcYcxxbfc0kDJzUyS0Lc1ZMRQEQLsU6osZA4GVu5
         tco1h7XXg91GuWDmT6ZJGWiUdwMXjHCA+Bp/nbo+F2PMK7HUW7f6i5DcO02e3TzDhSKN
         o1/6ncqbSBhWVRaPbfyFW7Vju5bk5XC4KwZjYcnJTfcc5vzooGPzlcXsVwIwhdAsNY7j
         cVe8sLstqo+Rmnxsa5S/Q62kpo9Wiw3O84qV811yv5eglrAnqu/HgqsAzRhEFRc6yBpB
         jrRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6+Ty0YbjEMQf7UkE7NifEpiE5zlJZANJX0lH//AppkFKiidc5eyJqNNA8vuY9Pgrjvkc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ/yApDnxSeFn8OgX90Up19SBvDEz4WMu7D8fp+DZisd67RLDy
	xsIoVrnT4v8PwDSnS2b0CC02695MAgK9S+YHljizDMDcUzP92O+7Al08cDjEjriF0ODjFr1Y5G6
	mFQ==
X-Google-Smtp-Source: AGHT+IGhf9r4bLr1k6QPl1cqyMxelMemoCDQRPt30Om6bklIqMV3ZY7rz1PygJxjONxbtVJ1np2pV6AsiU4=
X-Received: from pjbov6.prod.google.com ([2002:a17:90b:2586:b0:2f2:e97a:e77f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c888:b0:2f4:43ce:dcea
 with SMTP id 98e67ed59e1d1-2f782d2e551mr5645961a91.25.1737149658666; Fri, 17
 Jan 2025 13:34:18 -0800 (PST)
Date: Fri, 17 Jan 2025 13:34:17 -0800
In-Reply-To: <20250106155652.484001-1-kentaishiguro@sslab.ics.keio.ac.jp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250106155652.484001-1-kentaishiguro@sslab.ics.keio.ac.jp>
Message-ID: <Z4rM2abMZvurfFDO@google.com>
Subject: Re: [RFC] Para-virtualized TLB flush for PV-waiting vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 07, 2025, Kenta Ishiguro wrote:
> Signed-off-by: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
> ---
>  arch/x86/include/uapi/asm/kvm_para.h |  1 +
>  arch/x86/kernel/kvm.c                | 13 +++++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index a1efa7907a0b..db26e167a707 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -70,6 +70,7 @@ struct kvm_steal_time {
>  
>  #define KVM_VCPU_PREEMPTED          (1 << 0)
>  #define KVM_VCPU_FLUSH_TLB          (1 << 1)
> +#define KVM_VCPU_IN_PVWAIT          (1 << 2)
>  
>  #define KVM_CLOCK_PAIRING_WALLCLOCK 0
>  struct kvm_clock_pairing {
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 21e9e4845354..f17057b7d263 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -668,7 +668,8 @@ static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
>  		 */
>  		src = &per_cpu(steal_time, cpu);
>  		state = READ_ONCE(src->preempted);
> -		if ((state & KVM_VCPU_PREEMPTED)) {
> +		if ((state & KVM_VCPU_PREEMPTED) ||
> +		    (state & KVM_VCPU_IN_PVWAIT)) {
>  			if (try_cmpxchg(&src->preempted, &state,
>  					state | KVM_VCPU_FLUSH_TLB))

This is unsafe.  KVM_VCPU_PREEMPTED relies on it being set and cleared by the host
to ensure either the host observes KVM_VCPU_FLUSH_TLB before the vCPU enters the
guest, i.e. before the vCPU can possibly consume stale TLB entries.

If the host is already in the process of re-entering the guest on the waiting
vCPU, e.g. because it received a kick, then there will be no KVM_REQ_STEAL_UPDATE
in the host and so the host won't process KVM_VCPU_FLUSH_TLB.

I also see no reason to limit this to kvm_wait(); the logic you are relying on is
really just "let KVM do the flushes if the vCPU is in the host".  There's a balance
to be had, e.g. toggling a flag on every entry+exit would get expensive, but
toggling at kvm_arch_vcpu_put() and then letting kvm_arch_vcpu_load() request
a steal_time update seems pretty straightforward.

E.g. this will also elide IPIs if the vCPU happens to be in host userspace doing
emulation of some kind, or if the vCPU is blocking.

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..e3a6e6ecf70b 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -70,6 +70,7 @@ struct kvm_steal_time {
 
 #define KVM_VCPU_PREEMPTED          (1 << 0)
 #define KVM_VCPU_FLUSH_TLB          (1 << 1)
+#define KVM_VCPU_IN_HOST           (1 << 2)
 
 #define KVM_CLOCK_PAIRING_WALLCLOCK 0
 struct kvm_clock_pairing {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index acdd72e89bb0..5e3dc209e86c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5018,8 +5018,11 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
        struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
        struct kvm_steal_time __user *st;
        struct kvm_memslots *slots;
-       static const u8 preempted = KVM_VCPU_PREEMPTED;
        gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+       u8 preempted = KVM_VCPU_IN_HOST;
+
+       if (vcpu->preempted)
+               preempted |= KVM_VCPU_PREEMPTED;
 
        /*
         * The vCPU can be marked preempted if and only if the VM-Exit was on
@@ -5037,7 +5040,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
        if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
                return;
 
-       if (vcpu->arch.st.preempted)
+       if (vcpu->arch.st.preempted == preempted)
                return;
 
        /* This happens on process exit */
@@ -5055,7 +5058,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
        BUILD_BUG_ON(sizeof(st->preempted) != sizeof(preempted));
 
        if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
-               vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+               vcpu->arch.st.preempted = preempted;
 
        mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
@@ -5064,7 +5067,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
        int idx;
 
-       if (vcpu->preempted) {
+       if (vcpu->preempted || !kvm_xen_msr_enabled(vcpu->kvm)) {
                /*
                 * Assume protected guests are in-kernel.  Inefficient yielding
                 * due to false positives is preferable to never yielding due

>  				__cpumask_clear_cpu(cpu, flushmask);
> @@ -1045,6 +1046,9 @@ static void kvm_kick_cpu(int cpu)
>  
>  static void kvm_wait(u8 *ptr, u8 val)
>  {
> +	u8 state;
> +	struct kvm_steal_time *src;
> +
>  	if (in_nmi())
>  		return;
>  
> @@ -1054,8 +1058,13 @@ static void kvm_wait(u8 *ptr, u8 val)
>  	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
>  	 */
>  	if (irqs_disabled()) {
> -		if (READ_ONCE(*ptr) == val)
> +		if (READ_ONCE(*ptr) == val) {
> +			src = this_cpu_ptr(&steal_time);
> +			state = READ_ONCE(src->preempted);
> +			try_cmpxchg(&src->preempted, &state,
> +				    state | KVM_VCPU_IN_PVWAIT);
>  			halt();
> +		}
>  	} else {
>  		local_irq_disable();
>  
> -- 
> 2.25.1
> 

