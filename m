Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7A3294CD9
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408511AbgJUMj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 08:39:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394282AbgJUMj2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 08:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603283966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c7EH/NJ6Fg/m8L/HBnnaHt/LKhGAw4sqP6ejYqOggwk=;
        b=NG1etoduHcNIeW34UfO2+wD+wtD2UHDfImhZ0dSyGioL2LLXcKDBbzOrX2oS8OE5DXj6Lw
        fp72OSCdWKaXTTGPmk3T9dUoODaMsc0cpicKUlMU2+MfTbhWbTZDe0BFBG1+uFRAVAyXCM
        cpkh8lmSJvYn6yUuaBh2pljDewSR/g8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-Lc9EdbC8PyW8-av8SDIOlw-1; Wed, 21 Oct 2020 08:39:24 -0400
X-MC-Unique: Lc9EdbC8PyW8-av8SDIOlw-1
Received: by mail-wr1-f70.google.com with SMTP id n14so2555746wrp.1
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 05:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c7EH/NJ6Fg/m8L/HBnnaHt/LKhGAw4sqP6ejYqOggwk=;
        b=kp+RBMN2lskMolG+tcT6Bd686fYwQUlJ5N7lx2r6M7vE3csXZT7YuNIMDDQP4EmcZV
         24rka1wx9nmudCtQeAGWc1BShfA8unCtTi3C+TdFshclFyNibiSU4b3ZZEvkQwvppxOE
         XzXDVHM46SVG8nDGSD4XfCJWZNC2QglJM0FU+9QFTyj3t37MTDxWYuABD3jnom/V19/5
         j/jiVkWoE+RB3Ggpn5i1btS8H6BCoKUWj53qLWKOF6TI8b7QjRuMR3XJpn85tsc75r8b
         bptyFwryfsZNHTd7hXtnSCXbfnwOwZwD+c6nu1KwSqLI64LVg2s1X5iBjj4NVdcYqC3c
         ZjOQ==
X-Gm-Message-State: AOAM532/66gldlVKqSe6D3EH1tKJIsbVaWSDh1Rw2YdOxWeRtYNYfDL4
        mzV78KFJz9Y4YxrcSPNLPldI3QSntDHlBTZs+tSG4UHvQqb9XGTuELSdPwrHtyo9wl9wPcrxnPy
        89uULdwwSHfrU
X-Received: by 2002:adf:80c8:: with SMTP id 66mr4650723wrl.415.1603283962840;
        Wed, 21 Oct 2020 05:39:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpiPbbJK4AX5vO6QZtccwjQuHYrMpWSENlh7dEYIreZ7TRkNyQ+Z5nk41eW0foiBgy0TF1oQ==
X-Received: by 2002:adf:80c8:: with SMTP id 66mr4650696wrl.415.1603283962631;
        Wed, 21 Oct 2020 05:39:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x64sm3593660wmg.33.2020.10.21.05.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 05:39:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
In-Reply-To: <20201020215613.8972-6-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com> <20201020215613.8972-6-sean.j.christopherson@intel.com>
Date:   Wed, 21 Oct 2020 14:39:20 +0200
Message-ID: <87wnzj4utj.fsf@vitty.brq.redhat.com>
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
>  arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
>  arch/x86/kvm/vmx/vmx.h |  7 -------
>  2 files changed, 8 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 52cb9eec1db3..4dfde8b64750 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -498,13 +498,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>  	struct kvm_vcpu *vcpu;
>  	int ret = 0, i;
> +	bool mismatch;
>  	u64 tmp_eptp;
>  
>  	spin_lock(&kvm_vmx->ept_pointer_lock);
>  
> -	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
> -		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
> -		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> +	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> +		mismatch = false;
>  
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
>  			tmp_eptp = to_vmx(vcpu)->ept_pointer;
> @@ -515,12 +515,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
>  				kvm_vmx->hv_tlb_eptp = tmp_eptp;
>  			else
> -				kvm_vmx->ept_pointers_match
> -					= EPT_POINTERS_MISMATCH;
> +				mismatch = true;
>  
>  			ret |= hv_remote_flush_eptp(tmp_eptp, range);
>  		}
> -	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> +		if (mismatch)
> +			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> +	} else {
>  		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
>  	}

Personally, I find double negations like 'mismatch = false' hard to read
:-). What if we write this all like 

if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
	kvm_vmx->hv_tlb_eptp = to_vmx(vcpu0)->ept_pointer;
	kvm_for_each_vcpu() {
		tmp_eptp = to_vmx(vcpu)->ept_pointer;
		if (!VALID_PAGE(tmp_eptp) || tmp_eptp != kvm_vmx->hv_tlb_eptp)
			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;

		if (VALID_PAGE(tmp_eptp))
			ret |= hv_remote_flush_eptp(tmp_eptp, range);
	}
} else {
	ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
}

(not tested and I've probably missed something)

>  
> @@ -3042,8 +3043,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
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
> index 3d557a065c01..e8d7d07b2020 100644
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

-- 
Vitaly

