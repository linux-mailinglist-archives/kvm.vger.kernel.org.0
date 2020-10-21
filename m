Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB5B294C7C
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 14:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411806AbgJUMXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 08:23:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406859AbgJUMXW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 08:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603283000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WiRz+kFKIrNEgTelCpve6u1W10g3WBtsjsLl9b2ekkI=;
        b=M040F2ZAZMjKRdp218CiZOuwsGoKMTUgD2Wm/sOZ4xygCIJfb53qMBF4tiDiem6lbPxDDF
        c7eNaCt3qT0JrZnKs4OhTVDVi3I/dTCi1H9o7D7jjUHT4GwvqVoFMsRUiwkbVCGrvQRXgA
        Pp7IT5DSZljzuyRQwZNtmY3S1GMzeLA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-8y0-xYHcM7SNf0bJYZe6NA-1; Wed, 21 Oct 2020 08:23:16 -0400
X-MC-Unique: 8y0-xYHcM7SNf0bJYZe6NA-1
Received: by mail-wm1-f69.google.com with SMTP id g71so1395259wmg.2
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 05:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WiRz+kFKIrNEgTelCpve6u1W10g3WBtsjsLl9b2ekkI=;
        b=EdaNynJ4nncj5HUX5w7qPQKcpICs0Qu5mqQoJOz2kQwZzqRVBU+OjF48B/QOffw5ua
         xmOisABf6pth/QI0JRuX96uLU0JrxAah/IReDv9lGRA0odd6jt3JuW14836N5gF2ooGE
         Z84n+vnAippfFTJbZiay/l3vuIyvkgkkbYMoOtYqLHrDhJtBnV8XgSMNefTnLyKjtz9O
         VgdKKOcIxULOp7CBdC9JAS7H6Wy45JYL/Z5CxYK1Uf/I/4hrx5lZIW+enPOQx0rAyGGi
         H8UJEhkRtVrgRUw5nWikfnnp3aLUBAXREKv2CjlXGYdyqU/JG2TLdnUj3svVoYqOlqZb
         haYw==
X-Gm-Message-State: AOAM530Zrde3qpKJasRtjp5tEgFueT7SXUo7BP/0S2/cJGyiXS5DiLk+
        fCYHxCQnj46qx2M32CHo05E6zaElzXHg4CVUTq9r5BOQn2rvcQZ8+pl7hEVxrxedZTeD+mb7Aj3
        Sk6ZC+cQgdzhZ
X-Received: by 2002:a5d:6551:: with SMTP id z17mr4525006wrv.266.1603282995108;
        Wed, 21 Oct 2020 05:23:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtwSLm6YZu+DcgrnZ/h86D1ViOpkbDmwdo17WdmpNLiHxArp0j2/UErpXqPjrdxUTG7Scd+A==
X-Received: by 2002:a5d:6551:: with SMTP id z17mr4524981wrv.266.1603282994778;
        Wed, 21 Oct 2020 05:23:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t12sm3636565wrm.25.2020.10.21.05.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 05:23:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/10] KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
In-Reply-To: <20201020215613.8972-5-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com> <20201020215613.8972-5-sean.j.christopherson@intel.com>
Date:   Wed, 21 Oct 2020 14:23:13 +0200
Message-ID: <87zh4f4vke.fsf@vitty.brq.redhat.com>
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
>  arch/x86/kvm/vmx/vmx.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bba6d91f1fe1..52cb9eec1db3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -502,31 +502,23 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
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
>  	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
>  		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I have an unrelated question though. Does it make sense to call
hv_remote_flush_eptp() in case all EPTPs matches with ept_pointer_lock
spinlock held? Like if we had a match by the time of the call, does it
make a difference if the situation will change before or right after we
do the hypercall?

-- 
Vitaly

