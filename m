Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A002B031B
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 11:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKLKu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 05:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgKLKu1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 05:50:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/JmsB7JD7RPmYJY86UP4YLiPDKA3badfcgXEWwnIMCQ=;
        b=I2mY0C/YZFNq6/AXwLW3tuANsXHVEF5da4AE3Pw7DjbOdKGjo1NgCVXC5kvUkWcHSrWg0H
        U6i+1U+X/mwkF368gX27dVpoP5wdA4zif2xKEnYwdQzrAoYZ+Yrl08+cgDIC2ueFNItV2D
        eIrEaQKA3nNR+CUelM9wR3wfMQGvF5Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-a7c6zTbcORO0EKR_9DO5aQ-1; Thu, 12 Nov 2020 05:50:24 -0500
X-MC-Unique: a7c6zTbcORO0EKR_9DO5aQ-1
Received: by mail-wr1-f72.google.com with SMTP id y2so1761598wrl.3
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 02:50:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/JmsB7JD7RPmYJY86UP4YLiPDKA3badfcgXEWwnIMCQ=;
        b=ReesmTur4Fw6AZLkc0Yv+AF0Ec9ph57g7nzDMEYMOFmMYCtM+SOSY5oZC2XA98X8YW
         LU/9rcRo5QK77MlKs5yV5n4i8OEYCwmL6Ow1cAOZc3tCwTftxsdcO3IOg86JUJwDJbDS
         WKu1S9zeDYrpQzZ0e8dXcXK9Tq2d8Nj/EsQ7a1cJAi9gxVc4HTALXmDZCwv/KuQhOtgT
         N1hnXjXghubCXv/z5vjFb5nTQH88U2q32lTj4Vu8prpdnhOpmgSeSvFAnulKcOQtr1vB
         cw1ZbKFwOEwJXJI54G7r49Oe2SCZikL6oKvzJfF0T+XXxCX8FfxFlxCnLfRqo4TkCNCj
         1+mA==
X-Gm-Message-State: AOAM532Lg4U2a7pqKzTV0sie3wSeDvpTawsQKgnGxQcyeyBI/WpNL1B/
        Mo5sFJfVj99xZSuP1DI+1/5aEwnD2MpBkPadwZ26a6u1buoyYkZWl7Kp7oQ+xUPvPnz0ZK7c2OK
        Eagyet5Qb8pL0
X-Received: by 2002:a1c:7e87:: with SMTP id z129mr8961458wmc.176.1605178223199;
        Thu, 12 Nov 2020 02:50:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwf6MCjw3eRcl3Qw7TR3ZPVrXSwKUTnqQmOouX8P/LemzqJIDVcVaZyUFZEAeLave7l1xnrOQ==
X-Received: by 2002:a1c:7e87:: with SMTP id z129mr8961440wmc.176.1605178222953;
        Thu, 12 Nov 2020 02:50:22 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b17sm6143235wru.12.2020.11.12.02.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:50:22 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/11] KVM: VMX: Invalidate hv_tlb_eptp to denote an
 EPTP mismatch
In-Reply-To: <20201027212346.23409-7-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-7-sean.j.christopherson@intel.com>
Date:   Thu, 12 Nov 2020 11:50:21 +0100
Message-ID: <875z6azw5u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Drop the dedicated 'ept_pointers_match' field in favor of stuffing
> 'hv_tlb_eptp' with INVALID_PAGE to mark it as invalid, i.e. to denote
> that there is at least one EPTP mismatch.  Use a local variable to
> track whether or not a mismatch is detected so that hv_tlb_eptp can be
> used to skip redundant flushes.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++------------
>  arch/x86/kvm/vmx/vmx.h |  7 -------
>  2 files changed, 23 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 17b228c4ba19..25a714cda662 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -500,32 +500,44 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  {
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>  	struct kvm_vcpu *vcpu;
> -	int ret = 0, i;
> +	int ret = 0, i, nr_unique_valid_eptps;
>  	u64 tmp_eptp;
>  
>  	spin_lock(&kvm_vmx->ept_pointer_lock);
>  
> -	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
> -		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
> -		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> +	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> +		nr_unique_valid_eptps = 0;
>  
> +		/*
> +		 * Flush all valid EPTPs, and see if all vCPUs have converged
> +		 * on a common EPTP, in which case future flushes can skip the
> +		 * loop and flush the common EPTP.
> +		 */
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
>  			tmp_eptp = to_vmx(vcpu)->ept_pointer;
>  			if (!VALID_PAGE(tmp_eptp) ||
>  			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
>  				continue;
>  
> -			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
> +			/*
> +			 * Set the tracked EPTP to the first valid EPTP.  Keep
> +			 * this EPTP for the entirety of the loop even if more
> +			 * EPTPs are encountered as a low effort optimization
> +			 * to avoid flushing the same (first) EPTP again.
> +			 */
> +			if (++nr_unique_valid_eptps == 1)
>  				kvm_vmx->hv_tlb_eptp = tmp_eptp;
> -			else
> -				kvm_vmx->ept_pointers_match
> -					= EPT_POINTERS_MISMATCH;
>  
>  			ret |= hv_remote_flush_eptp(tmp_eptp, range);
>  		}
> -		if (kvm_vmx->ept_pointers_match == EPT_POINTERS_MISMATCH)
> +
> +		/*
> +		 * The optimized flush of a single EPTP can't be used if there
> +		 * are multiple valid EPTPs (obviously).
> +		 */
> +		if (nr_unique_valid_eptps > 1)
>  			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> -	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> +	} else {
>  		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
>  	}
>  
> @@ -3060,8 +3072,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  		if (kvm_x86_ops.tlb_remote_flush) {
>  			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  			to_vmx(vcpu)->ept_pointer = eptp;
> -			to_kvm_vmx(kvm)->ept_pointers_match
> -				= EPT_POINTERS_CHECK;
> +			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
>  			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  		}
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9a25e83f8b96..cecc2a641e19 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -288,12 +288,6 @@ struct vcpu_vmx {
>  	} shadow_msr_intercept;
>  };
>  
> -enum ept_pointers_status {
> -	EPT_POINTERS_CHECK = 0,
> -	EPT_POINTERS_MATCH = 1,
> -	EPT_POINTERS_MISMATCH = 2
> -};
> -
>  struct kvm_vmx {
>  	struct kvm kvm;
>  
> @@ -302,7 +296,6 @@ struct kvm_vmx {
>  	gpa_t ept_identity_map_addr;
>  
>  	hpa_t hv_tlb_eptp;
> -	enum ept_pointers_status ept_pointers_match;
>  	spinlock_t ept_pointer_lock;
>  };

This looks really neat and straighforward now, thanks!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

