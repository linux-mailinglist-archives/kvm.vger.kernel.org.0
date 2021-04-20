Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13486365EAE
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 19:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhDTRfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 13:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbhDTRfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 13:35:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516C9C06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 10:35:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id h15so8366788pfv.2
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 10:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a2W73sd2yxxQCYocYMHbjauS8qK/S4n/8biF3Czb61s=;
        b=ZTi8lQXkohwqmC29GwhjbmJ3fgfts/2hlLHrYeTeE2kijr6ZJ+QQJDcFiJX+jPLpNq
         EJsRWvS6QTzszfjhsNAXWgjhRDkVfH2BbvAVkT7/yv6jLOpeuXDhNwLCjXCQEuJoAYit
         /ZZDd/CHpTDVOlK8f/ePcQja/8jQcY3D6IjYSbo681irVgRXAWTDnyrEfcfRrpAdpxVL
         s6FiO8dybvTzmpFiakDC9JDn5tiLs3KZTg1zdP2cR7eO1Z6LDm5K2BGn4AkSMOqsj7U4
         WwAbCaP2t2Ezu6uIq+dQI+hWx7CCrUKh7RnyvKGkgnWejQTXEGER5xSdAGhEMM/EEiYk
         Dxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a2W73sd2yxxQCYocYMHbjauS8qK/S4n/8biF3Czb61s=;
        b=YDMWDt43LIBdHJUGat2wNp8B/g2mREzkgXAT3+VQ+J0omVanXrvENF/YsBeYEWADKS
         jKX5mMKFrPt88FJfdTUkSgzU+thZX73aaXSpWKQ5XBnMBqPePI4AJ1LRmtRauR2Df4jc
         kCx9giXB+WGsEcV2sTZFdUdr4LgSREZXJafkgQXIcbuUfJyStcS0fMMLDQFE84IfJrPg
         ql4BNNiiyMKQp2nutdo5sbpTjAl4TbZGKFZZDVXT3YySsuEVv1oCytF95c4TKyU6dgQj
         vebj3oXHrvNG11HSNe0JP2szZR29aB24mcuZjFEw8HA1iNiUk29NJJpr3pcPTQuwXluZ
         prKQ==
X-Gm-Message-State: AOAM533pDQUmMJ5uEH4zBlYQhXTozMF7bzxH2JeAR3xCLnTU5t6zm0XX
        +5W8OSQmmuSh2fN27ULY5uw+jw==
X-Google-Smtp-Source: ABdhPJzKwujVdehN88nuh23ZlSgAVSv2ghf+hC00oBN27+FxwNqz+KtAuBVKJmbeej78ZyLlfpChbw==
X-Received: by 2002:a63:4c63:: with SMTP id m35mr17575043pgl.105.1618940105773;
        Tue, 20 Apr 2021 10:35:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j7sm15514487pfd.129.2021.04.20.10.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 10:35:05 -0700 (PDT)
Date:   Tue, 20 Apr 2021 17:35:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <YH8QxRhX4iJFS6+D@google.com>
References: <20210409064345.31497-1-weijiang.yang@intel.com>
 <20210409064345.31497-2-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409064345.31497-2-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021, Yang Weijiang wrote:
> These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
> read/write them and after they're changed. If CET guest entry-load bit is not
> set by L1 guest, migrate them to L2 manaully.
> 
> Opportunistically remove one blank line in previous patch.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/cpuid.c      |  1 -
>  arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h    |  3 +++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d191de769093..8692f53b8cd0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -143,7 +143,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  		}
>  		vcpu->arch.guest_supported_xss =
>  			(((u64)best->edx << 32) | best->ecx) & supported_xss;
> -
>  	} else {
>  		vcpu->arch.guest_supported_xss = 0;
>  	}
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9728efd529a1..87beb1c034e1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2516,6 +2516,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  
>  	set_cr4_guest_host_mask(vmx);
> +
> +	if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
> +	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> +		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> +		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
> +	}
>  }
>  
>  /*
> @@ -2556,6 +2563,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> +
> +	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
> +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))) {
> +		vmcs_writel(GUEST_SSP, vmx->nested.vmcs01_guest_ssp);
> +		vmcs_writel(GUEST_S_CET, vmx->nested.vmcs01_guest_s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE,
> +			    vmx->nested.vmcs01_guest_ssp_tbl);
> +	}
> +
>  	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>  
>  	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
> @@ -3375,6 +3391,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	if (kvm_mpx_supported() &&
>  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (kvm_cet_supported() && !vmx->nested.nested_run_pending) {

This needs to be:

	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)))

otherwise the vmcs01_* members will be stale when emulating VM-Enter with
vcmc12.vm_entry_controls.LOAD_CET_STATE=0.

> +		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
> +		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
> +		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	}
