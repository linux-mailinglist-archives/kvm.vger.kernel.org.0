Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB38B2B0305
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 11:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgKLKru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 05:47:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgKLKrt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 05:47:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U58Dp7HKlOCi3zzkY5UzLsmwDbmNrCN0rpjOwlFDyTs=;
        b=aVu3E4Sua7jKe3lVxcrSzcrJkbnFwDRAu1k3RnhvOyhnqM1hj5e97OAbCB+iuCU2CLxavb
        rhr2SqfuBDMvWNxQWlPfVzDjEO3HFALuTXP6aucBRtRrlhQ/kGl798Wd/8CfopU34weqXG
        G3iLERo2xs9ZSVfF6m+A2+MUHn8OYhg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-3QJ0Y6g_M76IQcTwuoAm2g-1; Thu, 12 Nov 2020 05:47:44 -0500
X-MC-Unique: 3QJ0Y6g_M76IQcTwuoAm2g-1
Received: by mail-wm1-f72.google.com with SMTP id 3so1981506wms.9
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 02:47:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=U58Dp7HKlOCi3zzkY5UzLsmwDbmNrCN0rpjOwlFDyTs=;
        b=JN4+oJgB4E8aoOVqEsC2Im49sdAdvwmqrMsSxE7y+SVHZiRZdPkJzfSJ9bqp+qArhr
         YvIUImLuhb+l59rLsA90/1u5DtY03DXcF4Hd+CUCwA50LvqvBwYuLFhnxhvi/QnSke4l
         kHvjW2tnxWIwwL69Jh5zKegHlY06bFq1ddAScsk/Orn6+Fh40kZl/ucNdnHjagdwi25l
         iP9DVbt4UsjtPq5rV+p93X2fLiAgSYidknQ369NjPnbCi8vBu6qM5pR/H4FtEWQqJQZW
         XMuNjIsusAnMCfW46mQItglRWtC8VK3FMWloMW1o/Mdux23ELZdUjnL9/Sr7uCmwEv/N
         wAew==
X-Gm-Message-State: AOAM532hM8rTLyHubdgNG2SgW0KkwjCNKgTytdT9w6jM8X0x1KKnWS5y
        c1CyQ9tEsBHzA4w7vwJ9S+6UF3GYAL3dBWx+PaQ0/cEU4x5+U0q4CcWkrXTIt9iz6QSB050Q7NE
        VWqLtoTTSIrkO
X-Received: by 2002:a7b:c748:: with SMTP id w8mr9045668wmk.32.1605178063319;
        Thu, 12 Nov 2020 02:47:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGNECVrJaiU2hs4X3p6/OjOnbtXa1jH1DkI4ndBft2jyK4PGa2j96dI91jWN/T3OfkZc7pNQ==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr9045655wmk.32.1605178063127;
        Thu, 12 Nov 2020 02:47:43 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y11sm5623866wmj.36.2020.11.12.02.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:47:42 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP
 hasn't been flushed
In-Reply-To: <20201027212346.23409-6-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-6-sean.j.christopherson@intel.com>
Date:   Thu, 12 Nov 2020 11:47:41 +0100
Message-ID: <878sb6zwaa.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Combine the for-loops for Hyper-V TLB EPTP checking and flushing, and in
> doing so skip flushes for vCPUs whose EPTP matches the target EPTP.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f5e9e2f61e10..17b228c4ba19 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -505,33 +505,26 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  
>  	spin_lock(&kvm_vmx->ept_pointer_lock);
>  
> -	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK) {
> +	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
>  		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
>  		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
>  
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
>  			tmp_eptp = to_vmx(vcpu)->ept_pointer;
> -			if (!VALID_PAGE(tmp_eptp))
> +			if (!VALID_PAGE(tmp_eptp) ||
> +			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
>  				continue;
>  
> -			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> +			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
>  				kvm_vmx->hv_tlb_eptp = tmp_eptp;
> -			} else if (kvm_vmx->hv_tlb_eptp != tmp_eptp) {
> -				kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> +			else
>  				kvm_vmx->ept_pointers_match
>  					= EPT_POINTERS_MISMATCH;
> -				break;
> -			}
> -		}
> -	}
>  
> -	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
> -		kvm_for_each_vcpu(i, vcpu, kvm) {
> -			/* If ept_pointer is invalid pointer, bypass flush request. */
> -			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
> -				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
> -							    range);
> +			ret |= hv_remote_flush_eptp(tmp_eptp, range);
>  		}
> +		if (kvm_vmx->ept_pointers_match == EPT_POINTERS_MISMATCH)
> +			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
>  	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
>  		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
>  	}

It seems this patch makes EPT_POINTERS_MISMATCH an alias for
EPT_POINTERS_CHECK but this all is gone in the next patch, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

