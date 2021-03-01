Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EF932891B
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 18:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbhCARu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 12:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238717AbhCARrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 12:47:37 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C4FC061793
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 09:46:27 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id a23so2255808pga.8
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 09:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d6E6zqEbjqh+dwazTT0oLku5dnRE/qNGLB3SDKN9dOw=;
        b=V3umcLnJr+393bucClK75f1l/HHDLkirK5dzlN9sgGKsRZMDmC6Me94xVCuoN4NqNp
         qcTL3MjWoKS5pDN7p6Efq6YHyYdSOutxT01s6V1iHqoxv3fl3DBPZ1yhDBuXs3TuxpIq
         x44r9Aw4XSYNCd/1ff8nPZOpl4BSU001+B8uUpS3H9hKKPntWDWv/vQlCMRTQYDxtHqr
         1Qgx4hpd6s4+llVp9TFvA6VrVfN8/d6BUhmnB1NLcGkvxMKa7r22sonNJUtVo9JNbzeo
         SMzTkVuFMlExynASWBJI4bPMPzEpV+Lhcx5au3cj1WGYQSO418KYkVnrAwqbmnuURQLo
         dT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d6E6zqEbjqh+dwazTT0oLku5dnRE/qNGLB3SDKN9dOw=;
        b=LQNcqXJR0KHATD+l1v1xo9n/iSyC1W3idrXEJ9bSJe9MraTUeoxA677wNd6vB0/bvP
         ZfGHxYHXzt/W/sColYsbAhxAv8QcR/Gmwebx2eD28EeoRXhk/r+yegmfBT4OLQUwZvDc
         rYGJgieguz/u/D/B8tasldYN7GhuqEluZh5ScGRmL9dakr9m4KZbCFGGquIe3Bv1Od4n
         2KWHgyl4FaB9e8qRGf14Dx2UEIbIyjuT9mG5RJKRf0muT3eQv2vwXvtt2z0k8w7QfS9a
         XQz2LcoLE1Ecand8bLp2gnkgSqqSPQb8CCzmKvO4bzDCFHOCxfQg4lIlFuYQ2wo/zTVU
         28jw==
X-Gm-Message-State: AOAM532Yw3RxZu3YNJi0do78om04fcZYvZr6oTgYjuFgLgr2pfhml5IO
        GXxJt7EfHBpm0mIv5qtSpAMQ6w==
X-Google-Smtp-Source: ABdhPJxwUl3cOs7feycakrWn32IxbWrdJjJSqGzoDLlyubX5TOmfjlzvs4DgizGVyGqux61oa7xILw==
X-Received: by 2002:a62:7797:0:b029:1ed:7b10:84c2 with SMTP id s145-20020a6277970000b02901ed7b1084c2mr15949057pfc.47.1614620786279;
        Mon, 01 Mar 2021 09:46:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id b1sm19387523pfp.145.2021.03.01.09.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:46:25 -0800 (PST)
Date:   Mon, 1 Mar 2021 09:46:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <YD0oa99pgXqlS07h@google.com>
References: <20210225030951.17099-1-weijiang.yang@intel.com>
 <20210225030951.17099-2-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225030951.17099-2-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Vitaly

On Thu, Feb 25, 2021, Yang Weijiang wrote:
> These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
> read/write them and after they're changed. If CET guest entry-load bit is not
> set by L1 guest, migrate them to L2 manaully.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> 
> change in v2:
>  - Per Sean's review feedback, change CET guest states as rarely-updated fields.
>    And also migrate L1's CET states to L2 if the entry-load bit is not set.
>  - Opportunistically removed one blank line.
> ---
>  arch/x86/kvm/cpuid.c      |  1 -
>  arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h    |  3 +++
>  3 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 46087bca9418..afc97122c05c 100644
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
> index 9728efd529a1..1703b8874fad 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2516,6 +2516,12 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  
>  	set_cr4_guest_host_mask(vmx);
> +
> +	if (kvm_cet_supported()) {

This needs to be conditioned on CET coming from vmcs12, it's on the loading of
host state on VM-Exit that is unconditional (if CET is supported).

	if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {

I also assume these should be guarded by one of the eVMCS fields, though a quick
search of the public docs didn't provide a hit on the CET fields.

Vitaly, any idea if these will be GUEST_GRP2 or something else?

> +		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> +		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
> +	}
>  }
