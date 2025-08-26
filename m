Return-Path: <kvm+bounces-55799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3B9B374D1
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3207C1B27641
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 22:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9A4288502;
	Tue, 26 Aug 2025 22:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQpjTnDU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A141F2382
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 22:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756246625; cv=none; b=gf9Gc8MrhHxyGj4gXAhkKcDypG48w9aJSH4k/WKHgz9VnAWhWZ5AGGX9Rds2NdwFSkiQSFvztwRbVN/ij2oLe98Cn90kZHmQEFiTB7UeGg98i6Ro0q2Fj+36Q4LXSR8Vq8aJnx8xhCXRyPAYKI99C/tFnwJ2/5HxZKv6mkhe/0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756246625; c=relaxed/simple;
	bh=dkRSR9yZaCnIUCxE/Pgdphs1W8URLyyPWrcuAKR2zC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qu4ttafXDU2HXYD8po6sjchVRNtxZlXUkDsDvxdUP1yl+cEwOIAx7+05RCr5lYU9rqBqlRVJrjndJTyv8sqGghyZjmjQkub0Ezjr6OPNoSYhKgmzMSzSykL6mvtGqIKugQJGPgYka37ZgrwNnKuixaQ5akqWEiv4MnUsZarfEdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQpjTnDU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4716f9dad2so9350850a12.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 15:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756246623; x=1756851423; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hf+sOaWz6yQxPEq8o5h2X+bhucVHOfGy49sr09fK5G4=;
        b=rQpjTnDUnXuP/eLF9Rc4QbA63kFi7ZCGPN4p2ZD114Wak3skjOMhtEJ2unj6r5HIUr
         QmxqxxrI41bh8QCALDSMd89UZ5EQbTYMFBNL/bW6RW+pAvUEnh+o4e2UPrI+UvhHunto
         Hm4gASn+dFfql9CEFFY4LaujvhqXEmbcVWE6E/YHDey5hdJ2lMdohusajiJE9p4MwWur
         dy2vfQbYkO/EWCOxyGKpM8RlIEl9p5wHEFK5y7NFlzNkXIamkLgNyL/e5q+plXH/dSF5
         zCLGzU/ZP5AuzAFxycsUa8+J/COPxB7gqdyHPxdc8j7ypx0CGnVA8rTfxZEq0OZFM+b3
         IEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756246623; x=1756851423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hf+sOaWz6yQxPEq8o5h2X+bhucVHOfGy49sr09fK5G4=;
        b=dUC7xFtgub2ZyF/Uo9JwRQQVX8m4/VkIpmOtcpV8fCKnr1YUQziXJUl3dZk+OzWqEU
         wVS7BwcSz+T/1A3+Gi3d8+LbbDiLWzQ4cQNvrYK0pLboSw5w2Zeak9zgo/Zlrh2kIC1L
         ef8JoE0DtzXuBQ11QSsTmJw3aywHTg1yZnIsh2xW5MeGCFgU+ZDm55SAzBtuhxuWG+wf
         s1sDd6w7M8DRNqW5dJrhWzCCOV8aoeV0YU2DOsYbSWIHue+q+2WrujG7aXjKiRUjCm/M
         L31ReHaoU6OlGiFVKOAUebp/d09t4kptvV0cPOcSNgq7dVfvl/IeG0M1r0o0cnlANDMi
         8Yyg==
X-Forwarded-Encrypted: i=1; AJvYcCVxxCN4w39ELsykgda6vxlz1vZ3/9CjfXDhWePTXNsSVl1E5TGSK+kjYbq3CJYUdtbEQJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPcyBPkLi8GuiJWsrbVbWAP1oYzPnrPRAE3zSzBpD6ugA/GH5O
	ASr/D3Scu2i0JlYuaV+CuphRV+Ko4T42v+3/Z4tXc+Hqk8zWrOjW9iYhuAzd+MQKN6eXRdpKqL/
	18TNUlg==
X-Google-Smtp-Source: AGHT+IFd2nZLGsKTjSAp4ps46TIxZ2hwPxdGjLuatk+HBTF+Ar5n/37PnMCKYCg4jfWAvsVgpFeVA+wo7o0=
X-Received: from pjz3.prod.google.com ([2002:a17:90b:56c3:b0:324:ed49:6c92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:210c:b0:23f:f7ae:6e1c
 with SMTP id adf61e73a8af0-24340d00d45mr23557012637.25.1756246623098; Tue, 26
 Aug 2025 15:17:03 -0700 (PDT)
Date: Tue, 26 Aug 2025 15:17:01 -0700
In-Reply-To: <c45a7c91-e393-4f71-8b22-aef6486aaa9e@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821223630.984383-1-xin@zytor.com> <20250821223630.984383-7-xin@zytor.com>
 <2dd8c323-7654-4a28-86f1-d743b70d10b1@zytor.com> <aK340-6yIE_qujUm@google.com>
 <c45a7c91-e393-4f71-8b22-aef6486aaa9e@zytor.com>
Message-ID: <aK4yXT9y5YHeEWkb@google.com>
Subject: Re: [PATCH v6 06/20] KVM: VMX: Set FRED MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 26, 2025, Xin Li wrote:
> 
> > > Hi Sean,
> > > 
> > > I'd like to bring up an issue concerning MSR_IA32_PL0_SSP.
> > > 
> > > The FRED spec claims:
> > > 
> > > The FRED SSP MSRs are supported by any processor that enumerates
> > > CPUID.(EAX=7,ECX=1):EAX.FRED[bit 17] as 1. If such a processor does not
> > > support CET, FRED transitions will not use the MSRs (because shadow stacks
> > > are not enabled), but the MSRs would still be accessible using MSR-access
> > > instructions (e.g., RDMSR, WRMSR).
> > > 
> > > It means KVM needs to handle MSR_IA32_PL0_SSP even when FRED is supported
> > > but CET is not.  And this can be broken down into two subtasks:
> > > 
> > > 1) Allow such a guest to access MSR_IA32_PL0_SSP w/o triggering #GP.  And
> > > this behavior is already implemented in patch 8 of this series.
> > > 
> > > 2) Save and restore MSR_IA32_PL0_SSP in both KVM and Qemu for such a guest.
> > 
> > What novel work needs to be done in KVM?  For QEMU, I assume it's just adding an
> > "or FRED" somewhere.  For KVM, I'm missing what additional work would be required
> > that wouldn't be naturally covered by patch 8 (assuming patch 8 is bug-free).
> 
> Extra patches:
> 
> 1) A patch to save/restore guest MSR_IA32_PL0_SSP (i.e., FRED SSP0), as
> what we have done for RSP0, following is the patch on top of the patch
> saving/restoring RSP0:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 449a5e02c7de..0bf684342a71 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1294,8 +1294,13 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> 
>  	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> 
> -	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)) {
>  		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
> +
> +		/* XSAVES/XRSTORS do not cover SSP MSRs */

Eww.  I'm with Andrew, fix the SDM.  This is silly.

> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +			wrmsrns(MSR_IA32_FRED_SSP0, vmx->msr_guest_fred_ssp0);

FWIW, if we can't get an SDM change, don't bother with RDMSR/WRMSRNS, just
configure KVM to intercept accesses.  Then in kvm_set_msr_common(), pivot on
X86_FEATURE_SHSTK, e.g.

	case MSR_IA32_U_CET:
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
			WARN_ON_ONCE(msr != MSR_IA32_FRED_SSP0);
			vcpu->arch.fred_rsp0_fallback = data;
			break;
		}

		kvm_set_xstate_msr(vcpu, msr_info);
		break;

and

	case MSR_IA32_U_CET:
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
			WARN_ON_ONCE(msr_info->index != MSR_IA32_FRED_SSP0);
			vcpu->arch.fred_rsp0_fallback = msr_info->data;
			break;
		}

		kvm_get_xstate_msr(vcpu, msr_info);
		break;

