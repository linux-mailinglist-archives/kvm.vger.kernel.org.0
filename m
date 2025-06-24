Return-Path: <kvm+bounces-50518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B02B3AE6C67
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 754795A51BB
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FF82E2F16;
	Tue, 24 Jun 2025 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UgYA6gHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C9F2E2F05
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750782440; cv=none; b=bxwhgYsrUsLXbxle0JBdXJ/2biLrmw3ISJj9tw3VJ1rVfCHddNNyXscqRwD/Jic6NftoB5jV0g8Eu+Pygsj4yelrdqOgB2Bso6I9QVPXtRRZFRiP5tfB75svetNhYnLXHCRDBmzWQByI6NrqgLuOk6knDLsR9aQ8ySx1BdwRQ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750782440; c=relaxed/simple;
	bh=/a7bnevcq/hUsrT2G8I/opotGB7bYgVoeR0Zj6Jliig=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TM+4Zv9vPyk7zblDCqv3I2ANR/n/QTBj+SfD7+jnddvq5wSHvx/9PWMNFFGJTnn6dkDWyBFopG/BfvRWarRhBw5ZZV7PdwFHaiZC1MakQMiOzHYvMo4A0nx2xXtZA6Rkw3V+DPIlUh8xylWCtoP/GrjFEJ8+nhN+OUbcCK+HKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UgYA6gHt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234b133b428so5016075ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750782438; x=1751387238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3XU9PZOS8h3qM8j/vYtr6Tu7O46DilgXxn9Be95y+uI=;
        b=UgYA6gHtgJ/5BcJrVh3FNY4ECZ/iX8v3Kcf+cWcGRv0o8F222hlEWS8Kq7vKXtrimM
         9SIL1RPaDcK4IN+CY218eReV9EcMMKf3hPaQJey90wCj+TUvwkpU/bvC4jn3ntrIeobf
         DfCkIqz3veKiEote527YdYI9/AhtayYJ55+OsXSJlYahWx0vru+DFcIEu0IB2SGAlNXQ
         e1FIY5bKXHNS2rerO8KW65dp6ltQ+uYY0LpHDgR5b9yMrxtqjMX/x7JFX8kQM2pmZ6DT
         oPkK0zOG2yHzO1JKbyVlGiG6YAJarZN6HtzR7qQ/vk76zqxJYRGaJr7h2b3pDz1wATUC
         bYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750782438; x=1751387238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XU9PZOS8h3qM8j/vYtr6Tu7O46DilgXxn9Be95y+uI=;
        b=bPgAFDwf6NVBVExiO+Tn1R8Pqo5V3HczArjHfFEdU0OuGV9JUBfjeDR1EQcuEbeuuw
         3h9jwve6hZUaIVWlxjdv7Y+9aRSIdqvAOCeBj/uyFuu+5Jv59i5z91RaXfaznrvPgCTB
         ghLVey7lEwY9fT+dWQcXCDz+XfGbNpGLn5wrjJBpV1aGJxSM7PPK1W8tiLAYUXVvNpvq
         2ekhVONLEtrYIS0s0q5BWazW045eaoUtgD1e5dWLzQbM4OGerplAXgH+PCNnFxQYbLuD
         gsXfz2HDe6c1wPFOtD6AJiQrmxnLJuUwV6sV9qhSIe7ESW2gg+aOHlnC6DXIK2iwlYns
         HsOA==
X-Forwarded-Encrypted: i=1; AJvYcCVAO0Z0cC3gdd4Mc206RsDfFHajb99izma21WoUw/zaNgvpUcfeqzpAcPHBORt2xUpQFmA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/+Wdu34kdt4UNCpX/c58L0CIqoUoN6Qs1f68fZX7RlDROsk5M
	/NF4is4RpmE4nc3fRCuq6vHZsanUM7IGcRAPdG5M5oiTsdKBsaGGhBdtPnjQghhIw5JsA35hYpa
	odqQ/xg==
X-Google-Smtp-Source: AGHT+IFV0P3ZB/DP8ghmvs2Dp/i/ZHiBdp7WzvPKc/jhvZS3BGK8g6s0wf/z7wxYbHC1JNe2QocFSvwlZlk=
X-Received: from plbg10.prod.google.com ([2002:a17:902:d1ca:b0:235:160a:76e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da86:b0:235:e8da:8d1
 with SMTP id d9443c01a7336-2381ddd1cb6mr4789835ad.8.1750782437942; Tue, 24
 Jun 2025 09:27:17 -0700 (PDT)
Date: Tue, 24 Jun 2025 09:27:16 -0700
In-Reply-To: <20250328171205.2029296-9-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <20250328171205.2029296-9-xin@zytor.com>
Message-ID: <aFrR5Nk1Ge3_ApWy@google.com>
Subject: Re: [PATCH v4 08/19] KVM: VMX: Add support for FRED context save/restore
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, andrew.cooper3@citrix.com, luto@kernel.org, 
	peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 28, 2025, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Handle FRED MSR access requests, allowing FRED context to be set/get
> from both host and guest.
> 
> During VM save/restore and live migration, FRED context needs to be
> saved/restored, which requires FRED MSRs to be accessed from userspace,
> e.g., Qemu.
> 
> Note, handling of MSR_IA32_FRED_SSP0, i.e., MSR_IA32_PL0_SSP, is not
> added yet, which is done in the KVM CET patch set.
> 
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> ---
> 
> Changes since v2:
> * Add a helper to convert FRED MSR index to VMCS field encoding to
>   make the code more compact (Chao Gao).
> * Get rid of the "host_initiated" check because userspace has to set
>   CPUID before MSRs (Chao Gao & Sean Christopherson).
> * Address a few cleanup comments (Sean Christopherson).
> 
> Changes since v1:
> * Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
> * Fail host requested FRED MSRs access if KVM cannot virtualize FRED
>   (Chao Gao).
> * Handle the case FRED MSRs are valid but KVM cannot virtualize FRED
>   (Chao Gao).
> * Add sanity checks when writing to FRED MSRs.
> ---
>  arch/x86/kvm/vmx/vmx.c | 48 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c     | 28 ++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1fd32aa255f9..ae9712624413 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1426,6 +1426,24 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
>  	preempt_enable();
>  	vmx->msr_guest_kernel_gs_base = data;
>  }
> +
> +static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx)
> +{
> +	preempt_disable();
> +	if (vmx->guest_state_loaded)
> +		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
> +	preempt_enable();
> +	return vmx->msr_guest_fred_rsp0;
> +}
> +
> +static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
> +{
> +	preempt_disable();
> +	if (vmx->guest_state_loaded)
> +		wrmsrns(MSR_IA32_FRED_RSP0, data);
> +	preempt_enable();
> +	vmx->msr_guest_fred_rsp0 = data;
> +}
>  #endif

Maybe add helpers to deal with the preemption stuff?  Oh, never mind, FRED
uses WRMSRNS.  Hmm, actually, can't these all be non-serializing?  KVM is
progating *guest* values to hardware, so a VM-Enter is guaranteed before the
CPU value can be consumed.

#ifdef CONFIG_X86_64
static u64 vmx_read_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 *cache)
{
	preempt_disable();
	if (vmx->guest_state_loaded)
		*cache = read_msr(msr);
	preempt_enable();
	return *cache;
}

static u64 vmx_write_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 data,
				    u64 *cache)
{
	preempt_disable();
	if (vmx->guest_state_loaded)
		wrmsrns(MSR_KERNEL_GS_BASE, data);
	preempt_enable();
	*cache = data;
}

static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
{
	return vmx_read_guest_host_msr(vmx, MSR_KERNEL_GS_BASE,
				       &vmx->msr_guest_kernel_gs_base);
}

static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
{
	vmx_write_guest_host_msr(vmx, MSR_KERNEL_GS_BASE, data,
				 &vmx->msr_guest_kernel_gs_base);
}

static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx)
{
	return vmx_read_guest_host_msr(vmx, MSR_IA32_FRED_RSP0,
				       &vmx->msr_guest_fred_rsp0);
}

static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
{
	return vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_RSP0, data,
				        &vmx->msr_guest_fred_rsp0);
}
#endif

>  static void grow_ple_window(struct kvm_vcpu *vcpu)
> @@ -2039,6 +2057,24 @@ int vmx_get_feature_msr(u32 msr, u64 *data)
>  	}
>  }
>  
> +#ifdef CONFIG_X86_64
> +static u32 fred_msr_vmcs_fields[] = {

This should be const.

> +	GUEST_IA32_FRED_RSP1,
> +	GUEST_IA32_FRED_RSP2,
> +	GUEST_IA32_FRED_RSP3,
> +	GUEST_IA32_FRED_STKLVLS,
> +	GUEST_IA32_FRED_SSP1,
> +	GUEST_IA32_FRED_SSP2,
> +	GUEST_IA32_FRED_SSP3,
> +	GUEST_IA32_FRED_CONFIG,
> +};

I think it also makes sense to add a static_assert() here, more so to help
readers follow along than anything else.

static_assert(MSR_IA32_FRED_CONFIG - MSR_IA32_FRED_RSP1 ==
	      ARRAY_SIZE(fred_msr_vmcs_fields) - 1);

> +
> +static u32 fred_msr_to_vmcs(u32 msr)
> +{
> +	return fred_msr_vmcs_fields[msr - MSR_IA32_FRED_RSP1];
> +}
> +#endif
> +
>  /*
>   * Reads an msr value (of 'msr_info->index') into 'msr_info->data'.
>   * Returns 0 on success, non-0 otherwise.
> @@ -2061,6 +2097,12 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_KERNEL_GS_BASE:
>  		msr_info->data = vmx_read_guest_kernel_gs_base(vmx);
>  		break;
> +	case MSR_IA32_FRED_RSP0:
> +		msr_info->data = vmx_read_guest_fred_rsp0(vmx);
> +		break;
> +	case MSR_IA32_FRED_RSP1 ... MSR_IA32_FRED_CONFIG:
> +		msr_info->data = vmcs_read64(fred_msr_to_vmcs(msr_info->index));
> +		break;
>  #endif
>  	case MSR_EFER:
>  		return kvm_get_msr_common(vcpu, msr_info);
> @@ -2268,6 +2310,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			vmx_update_exception_bitmap(vcpu);
>  		}
>  		break;
> +	case MSR_IA32_FRED_RSP0:
> +		vmx_write_guest_fred_rsp0(vmx, data);
> +		break;
> +	case MSR_IA32_FRED_RSP1 ... MSR_IA32_FRED_CONFIG:
> +		vmcs_write64(fred_msr_to_vmcs(msr_index), data);
> +		break;
>  #endif
>  	case MSR_IA32_SYSENTER_CS:
>  		if (is_guest_mode(vcpu))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c841817a914a..007577143337 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -318,6 +318,9 @@ static const u32 msrs_to_save_base[] = {
>  	MSR_STAR,
>  #ifdef CONFIG_X86_64
>  	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
> +	MSR_IA32_FRED_RSP0, MSR_IA32_FRED_RSP1, MSR_IA32_FRED_RSP2,
> +	MSR_IA32_FRED_RSP3, MSR_IA32_FRED_STKLVLS, MSR_IA32_FRED_SSP1,
> +	MSR_IA32_FRED_SSP2, MSR_IA32_FRED_SSP3, MSR_IA32_FRED_CONFIG,
>  #endif
>  	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
>  	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
> @@ -1849,6 +1852,23 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  
>  		data = (u32)data;
>  		break;
> +	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> +			return 1;

Yeesh, this is a bit of a no-win situation.  Having to re-check the MSR index is
no fun, but the amount of overlap between MSRs is significant, i.e. I see why you
bundled everything together.  Ugh, and MSR_IA32_FRED_STKLVLS is buried smack dab
in the middle of everything.

> +
> +		/* Bit 11, bits 5:4, and bit 2 of the IA32_FRED_CONFIG must be zero */

Eh, the comment isn't helping much.  If we want to add more documentation, add
#defines.  But I think we can documented the reserved behavior while also tidying
up the code a bit.

After much fiddling, how about this?

	case MSR_IA32_FRED_STKLVLS:
		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
			return 1;
		break;			

	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
	case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_CONFIG: {
		u64 reserved_bits;

		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
			return 1;

		if (is_noncanonical_msr_address(data, vcpu))
			return 1;

		switch (index) {
		case MSR_IA32_FRED_CONFIG:
			reserved_bits = BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2);
			break;
		case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
			reserved_bits = GENMASK_ULL(5, 0);
			break;
		case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_SSP3:
			reserved_bits = GENMASK_ULL(2, 0);
			break;
		default:
			WARN_ON_ONCE(1);
			return 1;
		}
		if (data & reserved_bits)
			return 1;
		break;
	}

> @@ -1893,6 +1913,10 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  		break;
> +	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> +			return 1;
> +		break;
>  	}
>  
>  	msr.index = index;
> @@ -7455,6 +7479,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>  		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
>  			return;
>  		break;
> +	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
> +			return;
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.48.1
> 

