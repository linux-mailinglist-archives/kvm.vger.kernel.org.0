Return-Path: <kvm+bounces-19284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D83D902DF9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 226611C21AAE
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 01:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B7FA945;
	Tue, 11 Jun 2024 01:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lfpWBALP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FC6EDF
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 01:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718069653; cv=none; b=lXcsOJndvPETRga2lcSGkFUAVVRN1iNahX2Fw489oQsxmUqdCmqDAG7TxstekmoiqF3LVFwnx9I+J7g/lDiVmR1WcybU2KVgYdSkUUsXyl2/Deag+YLt3SBxMEeWYnTIsg5FiDaba8RaTDPKPJ9nI5cBZk2hWKXPu+7xYjaN07w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718069653; c=relaxed/simple;
	bh=rb7uB0KSLonwOCypbMgQCXHkOIQyUrxXAXZTMWGn8N8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UuUYT2K0d7AqYTLqq9AJ9fA+0XKpVc6CuN1LwtCp9P5C4m0rlEPRx2XK2+vNPuWSR+RC/Toze3Sytvcuquae8JjVyB7cwWmrCZy3kmp43WXWvpq4FJcrkTssul4shPUGT4UfrLj3WSQ8F/dcSfrDAA9i69qfPwELu21BX6TXj/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lfpWBALP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6cdc904ae4aso4063414a12.2
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 18:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718069651; x=1718674451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x5baEhBF9sOr8kVhYoFhuMjx/1QvP9In6UP3EAvA/gw=;
        b=lfpWBALPKKbJ0nvNnAafLHdtC3vkR9fjFuZirGDnppApei9avDemevenEJYvBPxMqs
         OVWiPFirV4+Ksvnr4DsWrSF2edU+8V4Xwu5gLTQzlxEV1XssXK5m1DFJDjomNzY3Fruw
         g1IVBakk5NynOgXOcaPXylBCvyjgdxBM8Ylbc0lon+eKUoqO75k/FyXMbs0H52bAABlT
         zS09UbVOj4RYIibkRpKW0qwhh6e5SoLYxYGBtw2NAGiuO08MLonNo7id/RffQ+ndDPBd
         XgoD0FAF2jpi21U261nzLvUNhGv/RbZDM8xZTQgNblCKO8waWPOEDME0kVXPob6tcr0y
         rxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718069651; x=1718674451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x5baEhBF9sOr8kVhYoFhuMjx/1QvP9In6UP3EAvA/gw=;
        b=O/uDBh7AMj+tp7vwzWbXANImXjrYlFtuXp0Gj5rLuG14L0Xb9CzNUcaxqac2Mn9TGM
         6mrRcfiFZFohTvAG73KUDI7FYLU3PUbk6v8YehWeYc5f35rU+jEqoNt933Nl/sKFnlo2
         O7kLGtzYoSmsSFI1uP+DjjwmiRLw1mCAUn2b/SPykIpg9ych/MJ9usolKEDb3oDCoEqG
         UBe+deWOVmy05exu4Gi5pab+8FwphFSTOUUijocGe/Mnk54ljzrFwMcMiTV8DbJGp8xM
         Gz7Ti9PKBHvzmIdMYDrnXcVC6g6zPI3fZRxPjT64ZPO8EhHZTJDgOxY7vf3yueuQNzfl
         Y7Cw==
X-Gm-Message-State: AOJu0YxBYJeN9CwIcSc/dw1jh1dY1yN5BWUYTD8xbWr6kXyj7bPKGVTM
	rYHJ6yAKkwFkJahx2YnIvcorxFSrFstjmCDK/9G7FRy8lTG7Voz25n81Q7lm1ILI0RX36Ue3nhv
	2zw==
X-Google-Smtp-Source: AGHT+IFMaS9Am3bSlTU0F3mWYL1AS7eAnC4jgCiDVFw71uqftz9MC4EnYM40IdvQeCJizG9IRIDTSD2POts=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e54c:b0:1f6:21e5:c6e5 with SMTP id
 d9443c01a7336-1f6d02e0820mr8602725ad.5.1718069651014; Mon, 10 Jun 2024
 18:34:11 -0700 (PDT)
Date: Mon, 10 Jun 2024 18:34:09 -0700
In-Reply-To: <20240410143446.797262-10-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240410143446.797262-1-chao.gao@intel.com> <20240410143446.797262-10-chao.gao@intel.com>
Message-ID: <ZmepkZfLIvj_st5W@google.com>
Subject: Re: [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com, 
	Zhang Chen <chen.zhang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 10, 2024, Chao Gao wrote:
> From: Zhang Chen <chen.zhang@intel.com>
> 
> Allow guest to report if the short BHB-clearing sequence is in use.
> 
> KVM will deploy BHI_DIS_S for the guest if the short BHB-clearing
> sequence is in use and the processor doesn't enumerate BHI_NO.
> 
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cc260b14f8df..c5ceaebd954b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1956,8 +1956,8 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
>  }
>  
>  #define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
> -#define MITI_ENUM_VALID_BITS		0ULL
> -#define MITI_CTRL_VALID_BITS		0ULL
> +#define MITI_ENUM_VALID_BITS		MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT
> +#define MITI_CTRL_VALID_BITS		MITI_CTRL_BHB_CLEAR_SEQ_S_USED
>  
>  static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  {
> @@ -2204,7 +2204,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	struct vmx_uret_msr *msr;
>  	int ret = 0;
>  	u32 msr_index = msr_info->index;
> -	u64 data = msr_info->data;
> +	u64 data = msr_info->data, spec_ctrl_mask = 0;
>  	u32 index;
>  
>  	switch (msr_index) {
> @@ -2508,6 +2508,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data & ~MITI_CTRL_VALID_BITS)
>  			return 1;
>  
> +		if (data & MITI_CTRL_BHB_CLEAR_SEQ_S_USED &&
> +		    kvm_cpu_cap_has(X86_FEATURE_BHI_CTRL) &&
> +		    !(host_arch_capabilities & ARCH_CAP_BHI_NO))
> +			spec_ctrl_mask |= SPEC_CTRL_BHI_DIS_S;
> +
> +		/*
> +		 * Intercept IA32_SPEC_CTRL to disallow guest from changing
> +		 * certain bits if "virtualize IA32_SPEC_CTRL" isn't supported
> +		 * e.g., in nested case.
> +		 */
> +		if (spec_ctrl_mask && !cpu_has_spec_ctrl_shadow())
> +			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
> +
> +		/*
> +		 * KVM_CAP_FORCE_SPEC_CTRL takes precedence over
> +		 * MSR_VIRTUAL_MITIGATION_CTRL.
> +		 */
> +		spec_ctrl_mask &= ~vmx->vcpu.kvm->arch.force_spec_ctrl_mask;
> +
> +		vmx->force_spec_ctrl_mask = vmx->vcpu.kvm->arch.force_spec_ctrl_mask |
> +					    spec_ctrl_mask;
> +		vmx->force_spec_ctrl_value = vmx->vcpu.kvm->arch.force_spec_ctrl_value |
> +					    spec_ctrl_mask;
> +		vmx_set_spec_ctrl(&vmx->vcpu, vmx->spec_ctrl_shadow);
> +
>  		vmx->msr_virtual_mitigation_ctrl = data;
>  		break;

I continue find all of this unpalatable.  The guest tells KVM what software
mitigations the guest is using, and then KVM is supposed to translate that into
some hardware functionality?  And merge that with userspace's own overrides?

Blech.

With KVM_CAP_FORCE_SPEC_CTRL, I don't see any reason for KVM to support the
Intel-defined virtual MSRs.  If the userspace VMM wants to play nice with the
Intel-defined stuff, then userspace can advertise the MSRs and use an MSR filter
to intercept and "emulate" the MSRs.  They should be set-and-forget MSRs, so
there's no need for KVM to handle them for performance reasons.

That way KVM doesn't need to deal with the the virtual MSRs, userspace can make
an informed decision when deciding how to set KVM_CAP_FORCE_SPEC_CTRL, and as a
bonus, rollouts for new mitigation thingies should be faster as updating userspace
is typically easier than updating the kernel/KVM.

