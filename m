Return-Path: <kvm+bounces-50515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4995AE6BB7
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 17:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5EF01884CE0
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725422561D4;
	Tue, 24 Jun 2025 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GDyvaqSK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3143B3074B6
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750779855; cv=none; b=Ft8Nu/Rl8dt+SYengabanI6dnQLBZuUn35uRI3wOx6wCCc1BAeh8sU0DtGOiIYj7qG0GPsqOKXAmYpbdVUMDUiB2uK/0eTX/IUyFha+dR5O+mltYNn5u85gyDYdhf7p/7Lmy90VjgbiHdlISyhwGESjoljfCmxIYQX4iVqVq49I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750779855; c=relaxed/simple;
	bh=GnVRZMcxsfo36v0rXfqthwJ8QHDF3AOpfJy8ji+OFnw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mfA5byTzYyWn+aiQ8fYPbX21snna5iFMhx2TWticD+lR1nTsqzzXbtNYYhnl/78aWMotwooUzUc4lBjf+HXOQY6Zr9sr3jdHaCbtmvUq3AaKhj0dqzsfKBMav/+TvuDjpq8bTYrmVQ8tF4LQtpre9n93gWcxJwR+QCn1ehRAi58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GDyvaqSK; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31df10dfadso435960a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 08:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750779853; x=1751384653; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M32rdd63dk2gWs5pdkKPTYIbq2vkcSl+gMb+cObpj7E=;
        b=GDyvaqSK+Phb7Eehch2uZn/mUDF4eZ3Iid67xN19U6bGbPdbKJD2R5G3QgyG/rov8O
         nW9d8Hro11UuVvV+LZGrPR3ua7mdNgS83i7h7ZtAfEryWVUC6O3gccDWj30vtkUCGsLi
         z7gmfJ9ysUatKHktbciWkp9nyhbVH/KK442GsloX1iHKMvrnZwtpLT+N5oXu9vVAbSa1
         D0c3X6QPJ2xF7UoiQY/hDzSGBLV5XQkWHmX+K32sS1Azv1qgpi3a0vpBO5LPpcLpFMMR
         RGby4WzmDdbaxfZxbvRv9oOTFdMdXa/ZR+qcDF6UO50Ri+u7U8Pn0IQxly00mQcw/smV
         bumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750779853; x=1751384653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M32rdd63dk2gWs5pdkKPTYIbq2vkcSl+gMb+cObpj7E=;
        b=HLyDAuOlj2nHWX9RKAzCjEKjA6XqeQ9d6gjSufZA8LCEgWIgBoEFxTdvKyW0848xQX
         6YjP8kVEbSqgGyANwohYvIPDNMSOmI1TTBenIB2ToPW035VB5axUZ72sQCbRKhB+jH7u
         q2GLPj5HQFlX6Aljm1bIkiGhC0Xk0wKvcl96yrowiHZMzJuATbL0zYR2xtoRh2FQbzsL
         5CQqW8TM1wP2CKGFVUKvI38Z2bd8rKLblBFbQiCkFtotQTbQQA+V+urANttypXm6skyT
         +pFWv6iOVC0vepqKy/EiMUHFUELW5HfRYLgktnm44WHveTm/2YceaZp5aK1KItJG5aXE
         6wvw==
X-Forwarded-Encrypted: i=1; AJvYcCVdjhQbirSiF3B0gjsNmAqAwlYpnDX8M3S9HgcCUYN5TP6yVfplv9Zepbu22ejcGcVzXE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAqllmwcqbOpehOOhgYhTaxxuyw6kj/Lfl0e8dkU46iQRuF4R6
	9KWeqrvA2+VlL2dH6LkpU9oHk2fJkyeUbOkbg25KUdzREVmpZfpT/KSoKDX4diZO9efj7qfoYxk
	F6LJH6A==
X-Google-Smtp-Source: AGHT+IGonx/FKvzf78PMDuuLP5ZT7EtOsQDlQhEQGU+CYP7qWJBCuuiOI3BtXUi4gssl10l5hEj/HjvszWA=
X-Received: from pfblh2.prod.google.com ([2002:a05:6a00:7102:b0:748:e071:298a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4325:b0:1f3:2e85:c052
 with SMTP id adf61e73a8af0-22026fa9d7dmr29631693637.35.1750779853025; Tue, 24
 Jun 2025 08:44:13 -0700 (PDT)
Date: Tue, 24 Jun 2025 08:44:11 -0700
In-Reply-To: <20250328171205.2029296-8-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <20250328171205.2029296-8-xin@zytor.com>
Message-ID: <aFrHy09b4x2C95nv@google.com>
Subject: Re: [PATCH v4 07/19] KVM: VMX: Save/restore guest FRED RSP0
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
> Save guest FRED RSP0 in vmx_prepare_switch_to_host() and restore it
> in vmx_prepare_switch_to_guest() because MSR_IA32_FRED_RSP0 is passed
> through to the guest, thus is volatile/unknown.
> 
> Note, host FRED RSP0 is restored in arch_exit_to_user_mode_prepare(),
> regardless of whether it is modified in KVM.
> 
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> ---
> 
> Changes in v3:
> * KVM only needs to save/restore guest FRED RSP0 now as host FRED RSP0
>   is restored in arch_exit_to_user_mode_prepare() (Sean Christopherson).
> 
> Changes in v2:
> * Don't use guest_cpuid_has() in vmx_prepare_switch_to_{host,guest}(),
>   which are called from IRQ-disabled context (Chao Gao).
> * Reset msr_guest_fred_rsp0 in __vmx_vcpu_reset() (Chao Gao).
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 +++++++++
>  arch/x86/kvm/vmx/vmx.h | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 236fe5428a74..1fd32aa255f9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1349,6 +1349,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	}
>  
>  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> +
> +	if (cpu_feature_enabled(X86_FEATURE_FRED) && guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))

For these paths, I'm leaning towards omitting the cpu_feature_enabled() check.
The guest_cpu_cap_has() check should suffice, this isn't a super hot path, and
the cost of the runtime check will likely be a single, well-predicted uop when
FRED is unsupported (e.g. a fused BT+Jcc).

Unlike the MSR interception toggling, the "extra" work is negligible (and it's
something confusing to check cpu_feature_enabled() instead of kvm_cpu_cap_has()).

> +		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
> +
>  #else
>  	savesegment(fs, fs_sel);
>  	savesegment(gs, gs_sel);
> @@ -1393,6 +1397,11 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
>  	invalidate_tss_limit();
>  #ifdef CONFIG_X86_64
>  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
> +
> +	if (cpu_feature_enabled(X86_FEATURE_FRED) && guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_FRED)) {
> +		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
> +		fred_sync_rsp0(vmx->msr_guest_fred_rsp0);

Can you add a comment here?  Passing the guest value to fred_sync_rsp0() surprised
me a bit.  The code and naming makes sense after looking at everything, but it's
quite different than the surrounding code, e.g. the MSR_KERNEL_GS_BASE, handling.
Something like this?

		/*
		 * Synchronize the current value in hardware to the kernel's
		 * local cache.  The desired host RSP0 will be set if/when the
		 * CPU exits to userspace (RSP0 is a per-task value).
		 */

> +	}
>  #endif
>  	load_fixmap_gdt(raw_smp_processor_id());
>  	vmx->guest_state_loaded = false;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index f48791cf6aa6..8e27b7cc700d 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -276,6 +276,7 @@ struct vcpu_vmx {
>  #ifdef CONFIG_X86_64
>  	u64		      msr_host_kernel_gs_base;
>  	u64		      msr_guest_kernel_gs_base;
> +	u64		      msr_guest_fred_rsp0;
>  #endif
>  
>  	u64		      spec_ctrl;
> -- 
> 2.48.1
> 

