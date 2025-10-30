Return-Path: <kvm+bounces-61445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE3FC1DE80
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 01:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93D1318992F4
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 00:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783DA1E231E;
	Thu, 30 Oct 2025 00:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3HaNJSak"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306FF33987
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 00:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761784060; cv=none; b=ivJA4gZ27kqIYNoQjLj1225qm+3XpZRD5BpLeHH/Z06gjDqyi0iNN0FI3dqF7ApcAMJNoBtZFkxQDt4bgob480g9k5pY5Gns7ocf/k9xtzEfdlKiNv1ddFxjerCEtIPb8EUXUzTkxiGi8W3DG7c66WQYhCXRnv+xr9K3MgZUDNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761784060; c=relaxed/simple;
	bh=Hf/MeIW7YjXvi//SWxTi96+AVToLJLr69t0MZf6+BTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=odLIaC9IWf2IgQANsdgG5qukeoY0y6KP+CE4iI8vNTYRNH3ercvNWjgymy+F7rDIkANciO1sFiQLeUC72XxhpuUp5IoOm4cD5odk/OWj4QP7+IboZZAYg/2IpvXP2afr+QP08SsSf468fHsY9125K0O1u9xieLG4jElN1vOLKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3HaNJSak; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so758962a91.2
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 17:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761784058; x=1762388858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3pb+pOqPvCbdk7yY1/oPc2Vg876VEx0lGo+S+YG6G3k=;
        b=3HaNJSakCMBvOKM+4+E13VxRkqvxfrzLjCQsTxTT1mikeFcJeiafs0hwCW0R4XLLxe
         CWuyEYCnSuRC5Z6Y+fn1Uk3XLO1cdf5C/eH5Bu1tjlkN01qOKQgljP2Wf12K2jHbDq8F
         TzpxlfBUljwe16otPgIUVNrodf61M0kIa90i1Z5WDbDm4+MxCgVk5Wbfw8mZS07YLDLV
         ctvKDWKmgWVGpxi7v0b7y/7mFibXnHg5i+5lPA0eHC+OGZc0IAejWlfgHJo3Y5ycm7GM
         sXAx4Ue6YdmcJJxxofD8Dm5fpKUTb4HvmoKCVD1+/UVIaFkgZQhGFyzj/I1Ydfs682Zw
         ipqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761784058; x=1762388858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3pb+pOqPvCbdk7yY1/oPc2Vg876VEx0lGo+S+YG6G3k=;
        b=PdOpbxNxmnGO8T6BsUACM0XnvEPFmH/lBWg+PWqBHeqJUH2vgn7tC8t832rAo7AMy2
         dcdmzgmESi3S7WrhfQ3mldXpxjtpSG3nrTCv9XeWtOFBGxikSG6I9VLfk8OZ1b/S/hzU
         5Zk15+r99Ei/SFM31H7TSApZFE8MGDxlL+o7HmYrB/RcgkmGnntlXblpI4fVzCnMD95n
         3uZ2rj7AQiZHxolTH5jJKYe167ORExS+SXMcYM6vsI8JherZTFfSY4FsDVuwUsfQihNy
         LMcp7ba9INKC7avMh/1LGprUq/53tw8aRRIXhMw1jMfE9wwDMIdb4BT0UanYQZzjc9G4
         fhRA==
X-Forwarded-Encrypted: i=1; AJvYcCWfO1XzIV+MmIyOgeXFc0UDhQ2vhKt4OGZovpTLhfTuFQ2zs6GA+14UbU3GNpePMmNc370=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbmImqajMRetkBrJN6G/U56SQxHKI8QXSDU7MqH5kgu+Ru8Z03
	e1b+zTuAmsTPsf/gbpJKaMN+ceZZNrp1/S8QKMjQGIYVRd4MsTdKcbTTtu5K2zgcfAQG+6Q5Fkh
	6cwmkxA==
X-Google-Smtp-Source: AGHT+IH+SfS3H07KD30gqI39C/zkty01bEP0F1Wk+9kBOmQVQSo2Qb7FnwIMu4DP7UAU1L8+qEGmSbEJAxI=
X-Received: from pjtz19.prod.google.com ([2002:a17:90a:cb13:b0:33b:cf89:6fe6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d64f:b0:33d:a0fd:2572
 with SMTP id 98e67ed59e1d1-3404c45abb7mr1241592a91.22.1761784058598; Wed, 29
 Oct 2025 17:27:38 -0700 (PDT)
Date: Wed, 29 Oct 2025 17:27:37 -0700
In-Reply-To: <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com> <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
Message-ID: <aQKw-a73mo1nLiJw@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Pawan Gupta wrote:
> When a system is only affected by MMIO Stale Data, VERW mitigation is
> currently handled differently than other data sampling attacks like
> MDS/TAA/RFDS, that do the VERW in asm. This is because for MMIO Stale Data,
> VERW is needed only when the guest can access host MMIO, this was tricky to
> check in asm.
> 
> Refactoring done by:
> 
>   83ebe7157483 ("KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps
>   MMIO into the guest")
> 
> now makes it easier to execute VERW conditionally in asm based on
> VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO.
> 
> Unify MMIO Stale Data mitigation with other VERW-based mitigations and only
> have single VERW callsite in __vmx_vcpu_run(). Remove the now unnecessary
> call to x86_clear_cpu_buffer() in vmx_vcpu_enter_exit().
> 
> This also untangles L1D Flush and MMIO Stale Data mitigation. Earlier, an
> L1D Flush would skip the VERW for MMIO Stale Data. Now, both the
> mitigations are independent of each other. Although, this has little
> practical implication since there are no CPUs that are affected by L1TF and
> are *only* affected by MMIO Stale Data (i.e. not affected by MDS/TAA/RFDS).
> But, this makes the code cleaner and easier to maintain.

Heh, and largely makes our discussion on the L1TF cleanup moot :-)

> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 451be757b3d1b2fec6b2b79157f26dd43bc368b8..303935882a9f8d1d8f81a499cdce1fdc8dad62f0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -903,9 +903,16 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
>  	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
>  		flags |= VMX_RUN_SAVE_SPEC_CTRL;
>  
> -	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
> -	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> -		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> +	/*
> +	 * When affected by MMIO Stale Data only (and not other data sampling
> +	 * attacks) only clear for MMIO-capable guests.
> +	 */
> +	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
> +		if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> +			flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> +	} else {
> +		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> +	}

This is quire confusing and subtle.  E.g. it requires the reader to know that
cpu_buf_vm_clear_mmio_only is mutually exlusive with X86_FEATURE_CLEAR_CPU_BUF,
and that VMX_RUN_CLEAR_CPU_BUFFERS is ignored if X86_FEATURE_CLEAR_CPU_BUF=n.

At least, I think that's how it works :-)

Isn't the above equivalent to this when all is said and done?

	if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) ||
	    (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
	     kvm_vcpu_can_access_host_mmio(&vmx->vcpu)))
		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;

>  
>  	return flags;
>  }
> @@ -7320,21 +7327,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  
>  	guest_state_enter_irqoff();
>  
> -	/*
> -	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
> -	 * mitigation for MDS is done late in VMentry and is still
> -	 * executed in spite of L1D Flush. This is because an extra VERW
> -	 * should not matter much after the big hammer L1D Flush.
> -	 *
> -	 * cpu_buf_vm_clear is used when system is not vulnerable to MDS/TAA,
> -	 * and is affected by MMIO Stale Data. In such cases mitigation in only
> -	 * needed against an MMIO capable guest.
> -	 */
>  	if (static_branch_unlikely(&vmx_l1d_should_flush))
>  		vmx_l1d_flush(vcpu);
> -	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
> -		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
> -		x86_clear_cpu_buffers();
>  
>  	vmx_disable_fb_clear(vmx);

