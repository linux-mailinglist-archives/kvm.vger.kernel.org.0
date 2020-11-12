Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88A62B035A
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 12:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgKLLC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 06:02:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728072AbgKLLCd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 06:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NcIMPyL9mGz4n6YVC9juTRB0o5T1y5G8g0JjGU5cgUQ=;
        b=flTjkoI7yfCwgX+eI5kP1RKXiskcgDSW7b0wNMD7c2YJ545AH0uWadxPjCB7ydIEV5GNxT
        Y7r4409x0gL3IX/ebCi1GXnEgZipcVC4NtrDKXh4Z4VWN2cgw7sVZo5MiqT97wbHRDjQ3b
        nOLjSvWChFuBu7o9CMR5rDK+eWX0jbw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-Va1gRfSuNE6pvjjCOL3Mqw-1; Thu, 12 Nov 2020 06:02:29 -0500
X-MC-Unique: Va1gRfSuNE6pvjjCOL3Mqw-1
Received: by mail-wm1-f70.google.com with SMTP id y187so2007534wmy.3
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 03:02:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NcIMPyL9mGz4n6YVC9juTRB0o5T1y5G8g0JjGU5cgUQ=;
        b=J2Aa2IKOcD5AjjIJ1IUzd2e9mIKPkp79wEwxINnh9E+VtHKl4YViuOPOTE8XC5o/65
         P8Xf+Eayd8Glr9nthd2J4QCe3eywoJkFZrPcLeu4yT8ELN+9xbRqPbnrdZyZc2loPS25
         CYy4aXmnnZ45+CF3fwrSXxOfvt8VKeJO4VPi8EFevepTROq5HAu/7GiOuWq7uXQ3VNdV
         6499Whaq1aRWE1h+Wim3N6oKmMC73pPINjGG2lQBMYVvCWrKNUi4ua1dLxYIwIx9wU3C
         fSLPxsrpEL3IhmEQEFf5acgo6us8+i1oqZZBXp7SehShdJLeSjdVqzUyZxaYEvP9/o0X
         kFhQ==
X-Gm-Message-State: AOAM533JtlIwY0zqWHDk6kJkJVlBpn2Z3Q8NPj2mZ/YyIFr4vYJrKhGu
        V5BCPzAMmwQXJVs80Z9HkZEU0VRnJ+0vbaCeEfvaaphIp2gXu0wYH7oDC4WNNqtnJtc7ALWorT7
        ptwGOhtdXbyKz
X-Received: by 2002:a1c:b387:: with SMTP id c129mr9476082wmf.66.1605178947634;
        Thu, 12 Nov 2020 03:02:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr+2XcCmi8ZKSIyXeapb4Ki0blI0GdSAbuh4uJxAIzwTY+DcvESdCuFLEy9Ta4DoLJ+k+n0A==
X-Received: by 2002:a1c:b387:: with SMTP id c129mr9476043wmf.66.1605178947334;
        Thu, 12 Nov 2020 03:02:27 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f5sm6555805wrg.32.2020.11.12.03.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:02:26 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/11] KVM: VMX: Track root HPA instead of EPTP for
 paravirt Hyper-V TLB flush
In-Reply-To: <20201027212346.23409-12-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-12-sean.j.christopherson@intel.com>
Date:   Thu, 12 Nov 2020 12:02:25 +0100
Message-ID: <87wnyqyh1a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Track the address of the top-level EPT struct, a.k.a. the root HPA,
> instead of the EPTP itself for Hyper-V's paravirt TLB flush.  The
> paravirt API takes only the address, not the full EPTP, and in theory
> tracking the EPTP could lead to false negatives, e.g. if the HPA matched
> but the attributes in the EPTP do not.  In practice, such a mismatch is
> extremely unlikely, if not flat out impossible, given how KVM generates
> the EPTP.
>
> Opportunsitically rename the related fields to use the 'root'
> nomenclature, and to prefix them with 'hv_' to connect them to Hyper-V's
> paravirt TLB flushing.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 83 ++++++++++++++++++++----------------------
>  arch/x86/kvm/vmx/vmx.h |  6 +--
>  2 files changed, 42 insertions(+), 47 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40a67dd45c8c..330d42ac5e02 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -481,18 +481,14 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
>  			range->pages);
>  }
>  
> -static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
> +static inline int hv_remote_flush_root_ept(hpa_t root_ept,
> +					   struct kvm_tlb_range *range)
>  {
> -	/*
> -	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
> -	 * of the base of EPT PML4 table, strip off EPT configuration
> -	 * information.
> -	 */
>  	if (range)
> -		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
> +		return hyperv_flush_guest_mapping_range(root_ept,
>  				kvm_fill_hv_flush_list_func, (void *)range);
>  	else
> -		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
> +		return hyperv_flush_guest_mapping(root_ept);
>  }
>  
>  static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> @@ -500,56 +496,55 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  {
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>  	struct kvm_vcpu *vcpu;
> -	int ret = 0, i, nr_unique_valid_eptps;
> -	u64 tmp_eptp;
> +	int ret = 0, i, nr_unique_valid_roots;
> +	hpa_t root;
>  
> -	spin_lock(&kvm_vmx->ept_pointer_lock);
> +	spin_lock(&kvm_vmx->hv_root_ept_lock);
>  
> -	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> -		nr_unique_valid_eptps = 0;
> +	if (!VALID_PAGE(kvm_vmx->hv_root_ept)) {
> +		nr_unique_valid_roots = 0;
>  
>  		/*
> -		 * Flush all valid EPTPs, and see if all vCPUs have converged
> -		 * on a common EPTP, in which case future flushes can skip the
> -		 * loop and flush the common EPTP.
> +		 * Flush all valid roots, and see if all vCPUs have converged
> +		 * on a common root, in which case future flushes can skip the
> +		 * loop and flush the common root.
>  		 */
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
> -			tmp_eptp = to_vmx(vcpu)->ept_pointer;
> -			if (!VALID_PAGE(tmp_eptp) ||
> -			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
> +			root = to_vmx(vcpu)->hv_root_ept;
> +			if (!VALID_PAGE(root) || root == kvm_vmx->hv_root_ept)
>  				continue;
>  
>  			/*
> -			 * Set the tracked EPTP to the first valid EPTP.  Keep
> -			 * this EPTP for the entirety of the loop even if more
> -			 * EPTPs are encountered as a low effort optimization
> -			 * to avoid flushing the same (first) EPTP again.
> +			 * Set the tracked root to the first valid root.  Keep
> +			 * this root for the entirety of the loop even if more
> +			 * roots are encountered as a low effort optimization
> +			 * to avoid flushing the same (first) root again.
>  			 */
> -			if (++nr_unique_valid_eptps == 1)
> -				kvm_vmx->hv_tlb_eptp = tmp_eptp;
> +			if (++nr_unique_valid_roots == 1)
> +				kvm_vmx->hv_root_ept = root;
>  
>  			if (!ret)
> -				ret = hv_remote_flush_eptp(tmp_eptp, range);
> +				ret = hv_remote_flush_root_ept(root, range);
>  
>  			/*
> -			 * Stop processing EPTPs if a failure occurred and
> -			 * there is already a detected EPTP mismatch.
> +			 * Stop processing roots if a failure occurred and
> +			 * multiple valid roots have already been detected.
>  			 */
> -			if (ret && nr_unique_valid_eptps > 1)
> +			if (ret && nr_unique_valid_roots > 1)
>  				break;
>  		}
>  
>  		/*
> -		 * The optimized flush of a single EPTP can't be used if there
> -		 * are multiple valid EPTPs (obviously).
> +		 * The optimized flush of a single root can't be used if there
> +		 * are multiple valid roots (obviously).
>  		 */
> -		if (nr_unique_valid_eptps > 1)
> -			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> +		if (nr_unique_valid_roots > 1)
> +			kvm_vmx->hv_root_ept = INVALID_PAGE;
>  	} else {
> -		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
> +		ret = hv_remote_flush_root_ept(kvm_vmx->hv_root_ept, range);
>  	}
>  
> -	spin_unlock(&kvm_vmx->ept_pointer_lock);
> +	spin_unlock(&kvm_vmx->hv_root_ept_lock);
>  	return ret;
>  }
>  static int hv_remote_flush_tlb(struct kvm *kvm)
> @@ -584,17 +579,17 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
>  
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
> -static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
> +static void hv_track_root_ept(struct kvm_vcpu *vcpu, hpa_t root_ept)
>  {
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
>  
>  	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
> -		spin_lock(&kvm_vmx->ept_pointer_lock);
> -		to_vmx(vcpu)->ept_pointer = eptp;
> -		if (eptp != kvm_vmx->hv_tlb_eptp)
> -			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> -		spin_unlock(&kvm_vmx->ept_pointer_lock);
> +		spin_lock(&kvm_vmx->hv_root_ept_lock);
> +		to_vmx(vcpu)->hv_root_ept = root_ept;
> +		if (root_ept != kvm_vmx->hv_root_ept)
> +			kvm_vmx->hv_root_ept = INVALID_PAGE;
> +		spin_unlock(&kvm_vmx->hv_root_ept_lock);
>  	}
>  #endif
>  }
> @@ -3092,7 +3087,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  		eptp = construct_eptp(vcpu, root_hpa, root_level);
>  		vmcs_write64(EPT_POINTER, eptp);
>  
> -		hv_load_mmu_eptp(vcpu, eptp);
> +		hv_track_root_ept(vcpu, root_hpa);
>  
>  		if (!enable_unrestricted_guest && !is_paging(vcpu))
>  			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> @@ -6964,7 +6959,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  	vmx->pi_desc.sn = 1;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> -	vmx->ept_pointer = INVALID_PAGE;
> +	vmx->hv_root_ept = INVALID_PAGE;
>  #endif
>  	return 0;
>  
> @@ -6983,7 +6978,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  static int vmx_vm_init(struct kvm *kvm)
>  {
>  #if IS_ENABLED(CONFIG_HYPERV)
> -	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
> +	spin_lock_init(&to_kvm_vmx(kvm)->hv_root_ept_lock);
>  #endif
>  
>  	if (!ple_gap)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2bd86d8b2f4b..5c98d16a0c6f 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -277,7 +277,7 @@ struct vcpu_vmx {
>  	u64 msr_ia32_feature_control;
>  	u64 msr_ia32_feature_control_valid_bits;
>  #if IS_ENABLED(CONFIG_HYPERV)
> -	u64 ept_pointer;
> +	u64 hv_root_ept;
>  #endif
>  
>  	struct pt_desc pt_desc;
> @@ -298,8 +298,8 @@ struct kvm_vmx {
>  	gpa_t ept_identity_map_addr;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> -	hpa_t hv_tlb_eptp;
> -	spinlock_t ept_pointer_lock;
> +	hpa_t hv_root_ept;
> +	spinlock_t hv_root_ept_lock;
>  #endif
>  };

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

