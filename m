Return-Path: <kvm+bounces-60139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 874E7BE45A9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 49EC95619FA
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 15:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E5234F476;
	Thu, 16 Oct 2025 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nfVI2lZE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750CD314D28
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760629810; cv=none; b=u6TRv8v8DpcAwUNpNo/fff0Fe4jsD1G0UUeI7nRacvrjjJhdzrxEcH+DsWyibw5dmqrD8ydRhZIhgr3wTi4mWhrUn1f0Kd2jVYgeFHG936SiNtZ89MDw7ebG8HUiv7YOku29+6rjte8x71QRVAIdoiENrZmZT74D6aCmwaGdclM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760629810; c=relaxed/simple;
	bh=ExmP7JW6L2M8fe/dlRfNdqFZ5JWDvA824rXlJ3x2Z/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XfcVYnw+3dudUuAfhE1CsaR/73kOJsJKvPsL8wb1DfyQlTnfPzHWdJiY047y4NuetIQU+NNg7oBH5umeTHLx54xq8jP0CWGMj4bGjqNrR9JY8VYl13x4MQQyMA2whbnRAL4viki/FOA2DphhwotW8SCCp3bfGWB4gacM8c8b5rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nfVI2lZE; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b57cf8dba28so895509a12.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 08:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760629808; x=1761234608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v2KnvP2YaZFVVi1EKHrbJGZVnySCwYiJLXRUCGwZnk4=;
        b=nfVI2lZEphSBecb9K6bJaScsFj4tpRBiimdwr33NU5qnVYCXm4feB8eor5wEFk502a
         5WH7cMoe2VP+WMbiJUyukAS7Rtxib4BHva3G9Ux5by9Bgvops8FyGXRQK/EiMZmwG/Wc
         Nf3ISrpWWBRpBPmtWy5UnPn21ZcB1wouydwYKK36nBf02bl4vMtCaFVy8WEZA14a0K51
         4XsX8T5g6tQe+HuLdm9/jbHHR4bjWwd3MsCQgJSR1WapVbtJlnuPhzG1bhc3qkoc55eV
         iKfdR9hYj4HXbCeCayz3oOodHGD3MfBmYiGr74jgz6l+JEMEHSO8AI4eVxoc5+DpPvN2
         oWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760629808; x=1761234608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v2KnvP2YaZFVVi1EKHrbJGZVnySCwYiJLXRUCGwZnk4=;
        b=QKlHWs4BzjEOmlotv6mR1YegBFdqjnx8nbt1MZW51dvxEeEZ/PnbZd4sWbUx2ZVOmZ
         +7diYp4h432k5OwHYsradjiHyIuDfB5Q/zk5IA9am1yto5AkkoSnt+nUkJ+MqpY20sWO
         owRZbsHPArbDumCUdAxGnmn8ExqpS84tDUrctZOP0qaPasPIvOyUwKBHmcWifvCvo6t1
         LgAsRKD/yGU3zTPDZEgSK3IbTH7oVio1+ilufQkVA5BlARlQbxKFDNC42fWQNH45IQEh
         LUcAo2OvQq4zp+iCK+ytN9L5OECdvkg/Q6rUexTMmVKM5kk7SqGw9nX9W3I3ff4/2hFD
         aTUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4m7EUyz0ppf2osO1sG2LvDSidPzvVECBSItdCkoS+yYZtNxKw+lkdh33m7qQKvMciDZk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5T3xkZextx6BBj9CfDVowwIevXZuZuAOmjZ0UWzP0uF2T6A8J
	WuKEAH/Su87/Vwvqm4fR2KJVkgp6AtkzKSOn6SqERc0asttSpG08hWvy4b/LgtadVqMAyPzzlt+
	ZlyVigw==
X-Google-Smtp-Source: AGHT+IFGxYfwSsZkUcYhXBV21YEOmorZdegtgwciywIpoQfeWnjVwbihghEXQZ41KIvgyIxlUzsULhHNz6I=
X-Received: from pjbqd7.prod.google.com ([2002:a17:90b:3cc7:b0:32d:69b3:b7b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e291:b0:32d:b925:74ea
 with SMTP id adf61e73a8af0-334a8515117mr598099637.11.1760629807662; Thu, 16
 Oct 2025 08:50:07 -0700 (PDT)
Date: Thu, 16 Oct 2025 08:50:06 -0700
In-Reply-To: <20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com>
Message-ID: <aPEULoJUUadbb3nn@google.com>
Subject: Re: [PATCH v2] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Brendan Jackman wrote:
> Currently the tracking of the need to flush L1D for L1TF is tracked by
> two bits: one per-CPU and one per-vCPU.
> 
> The per-vCPU bit is always set when the vCPU shows up on a core, so
> there is no interesting state that's truly per-vCPU. Indeed, this is a
> requirement, since L1D is a part of the physical CPU.
> 
> So simplify this by combining the two bits.
> 
> The vCPU bit was being written from preemption-enabled regions. For
> those cases, use raw_cpu_write() (via a variant of the setter function)
> to avoid DEBUG_PREEMPT failures. If the vCPU is getting migrated, the
> CPU that gets its bit set in these paths is not important; vcpu_load()
> must always set it on the destination CPU before the guest is resumed.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

...

> @@ -78,6 +79,11 @@ static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void)
>  	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
>  }
>  
> +static __always_inline void kvm_set_cpu_l1tf_flush_l1d_raw(void)
> +{
> +	raw_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
> +}

TL;DR: I'll post a v3 with a slightly tweaked version of this patch at the end.

Rather than add a "raw" variant, I would rather have a wrapper in arch/x86/kvm/x86.h
that disables preemption, with a comment explaining why it's ok to enable preemption
after setting the per-CPU flag.  Without such a comment, choosing between the two
variants looks entirely random

Alternatively, all writes could be raw, but that
feels wrong/weird, and in practice disabling preemption in the relevant paths is a
complete non-issue.

<me rummages around>

Gah, I followed a tangential thought about the "cost" of disabling/enabling preemtion
and ended up with a 4-patch series.  All of this code really should be conditioned
on CONFIG_CPU_MITIGATIONS=y.  With that, the wrapper can be:

static __always_inline void kvm_request_l1tf_flush_l1d(void)
{
#if IS_ENABLED(CONFIG_CPU_MITIGATIONS) && IS_ENABLED(CONFIG_KVM_INTEL)
	/*
	 * Temporarily disable preemption (if necessary) as the tracking is
	 * per-CPU.  If the current vCPU task is migrated to a different CPU
	 * before the next VM-Entry, then kvm_arch_vcpu_load() will pend a
	 * flush on the new CPU.
	 */
	guard(preempt)();
	kvm_set_cpu_l1tf_flush_l1d();
#endif
}

and kvm_set_cpu_l1tf_flush_l1d() and irq_cpustat_t.kvm_cpu_l1tf_flush_l1d can
likewise be gated on CONFIG_CPU_MITIGATIONS && CONFIG_KVM_INTEL.


> +
>  static __always_inline void kvm_clear_cpu_l1tf_flush_l1d(void)
>  {
>  	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 0);
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 48598d017d6f3f07263a2ffffe670be2658eb9cb..fcdc65ab13d8383018577aacf19e832e6c4ceb0b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1055,9 +1055,6 @@ struct kvm_vcpu_arch {
>  	/* be preempted when it's in kernel-mode(cpl=0) */
>  	bool preempted_in_kernel;
>  
> -	/* Flush the L1 Data cache for L1TF mitigation on VMENTER */
> -	bool l1tf_flush_l1d;
> -
>  	/* Host CPU on which VM-entry was most recently attempted */
>  	int last_vmentry_cpu;
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 667d66cf76d5e52c22f9517914307244ae868eea..8c0dce401a42d977756ca82d249bb33c858b9c9f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4859,7 +4859,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  	 */
>  	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
>  
> -	vcpu->arch.l1tf_flush_l1d = true;
> +	kvm_set_cpu_l1tf_flush_l1d();

This is wrong, kvm_handle_page_fault() runs with preemption enabled.

