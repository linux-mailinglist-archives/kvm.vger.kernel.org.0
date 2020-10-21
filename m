Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA80294C09
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442098AbgJUL5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 07:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439711AbgJUL5M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 07:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603281430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/RxSo6Za9Zh17GRqA0yhWs2BuTTbXHz6xaIsxqoVi38=;
        b=bpMcpeJh2Z51oKskkQMqkBLNDXtql5c6sE0mb3U5ufV7aA3//xKaShabZyMR/eNCnnz/9c
        RRISNcDvYuV7JUVe2qeXr84fbu7S3CLLraAYLh6DL6o+bAGKujS0AHs6xnx+g03/fgEgRH
        hg9zEvTsIptgnaG5MM7d73qhDmhkufQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-o2c_7NLbN6WlqFcWgCO7pw-1; Wed, 21 Oct 2020 07:57:08 -0400
X-MC-Unique: o2c_7NLbN6WlqFcWgCO7pw-1
Received: by mail-wr1-f70.google.com with SMTP id 31so2355486wrg.12
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 04:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/RxSo6Za9Zh17GRqA0yhWs2BuTTbXHz6xaIsxqoVi38=;
        b=oXqrL/nNlUx5fs7kK/9YFbcZdf6DY74Vj+Cu6I90yW2PUkU41m+ensV2e6u6oK8eoE
         2GvJzyTYkbuUJlceS94Chit4fycKWm+kjWO7zdRpFmvLP9qa5BceSDqALePjWdSs+vvU
         ssjYe7x/q6Y5HSfCtSlNwCmFhTqRk6jnKDrW0afS1spUWrmtLwmiG87rZOVyhSnLDYV6
         kelDSF2NgaJKYwGi2nZtB3jmOh2SMF239VivIoMhd5bdcYFK/53oSInhKIUZt3cHx1AZ
         vV6cPCv1cyNMRUucMueG0KHykF5gdfOH3J0VNp5KdfzbGau2XAz6F5vlpBIkbmSeON/K
         nrLA==
X-Gm-Message-State: AOAM530Ilfvp7cw7AjMHTN55e86i6zqfBauwRZ80Zludx2VWRyzLELJO
        IzA9GTiTFkWaFHBBwBHrlT8pn6aSDluGcfKMuoWrkOETH+PTdxuZP0C7ExP8ayIniZkDh2V81jg
        +4MRFD+jCX9RW
X-Received: by 2002:adf:fd49:: with SMTP id h9mr4572867wrs.115.1603281427231;
        Wed, 21 Oct 2020 04:57:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeaI37j337V9Ikj6xAF4TEL4WvSaEgGS1E9R+Awg6FvjdxGLoUG3XxA2gCENMvzXR18kyq6Q==
X-Received: by 2002:adf:fd49:: with SMTP id h9mr4572844wrs.115.1603281426990;
        Wed, 21 Oct 2020 04:57:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c130sm3166716wma.17.2020.10.21.04.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 04:57:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
In-Reply-To: <20201020215613.8972-2-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com> <20201020215613.8972-2-sean.j.christopherson@intel.com>
Date:   Wed, 21 Oct 2020 13:57:05 +0200
Message-ID: <878sbz6bce.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Explicitly track the EPTP that is common to all vCPUs instead of
> grabbing vCPU0's EPTP when invoking Hyper-V's paravirt TLB flush.
> Tracking the EPTP will allow optimizing the checks when loading a new
> EPTP and will also allow dropping ept_pointer_match, e.g. by marking
> the common EPTP as invalid.
>
> This also technically fixes a bug where KVM could theoretically flush an
> invalid GPA if all vCPUs have an invalid root.  In practice, it's likely
> impossible to trigger a remote TLB flush in such a scenario.  In any
> case, the superfluous flush is completely benign.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 19 ++++++++-----------
>  arch/x86/kvm/vmx/vmx.h |  1 +
>  2 files changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bcc097bb8321..6d53bcc4a1a9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -486,6 +486,7 @@ static void check_ept_pointer_match(struct kvm *kvm)
>  		}
>  	}
>  
> +	to_kvm_vmx(kvm)->hv_tlb_eptp = tmp_eptp;

I was going to suggest you reset hv_tlb_eptp to INVALID_PAGE in case
this check fails (couple lines above) but this function is gone later in
the series and the replacement code in hv_remote_flush_tlb_with_range()
does exactly that.

>  	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
>  }
>  
> @@ -498,21 +499,18 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
>  			range->pages);
>  }
>  
> -static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
> -		struct kvm_vcpu *vcpu, struct kvm_tlb_range *range)
> +static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
>  {
> -	u64 ept_pointer = to_vmx(vcpu)->ept_pointer;
> -
>  	/*
>  	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
>  	 * of the base of EPT PML4 table, strip off EPT configuration
>  	 * information.
>  	 */
>  	if (range)
> -		return hyperv_flush_guest_mapping_range(ept_pointer & PAGE_MASK,
> +		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
>  				kvm_fill_hv_flush_list_func, (void *)range);
>  	else
> -		return hyperv_flush_guest_mapping(ept_pointer & PAGE_MASK);
> +		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
>  }
>  
>  static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> @@ -530,12 +528,11 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
>  			/* If ept_pointer is invalid pointer, bypass flush request. */
>  			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
> -				ret |= __hv_remote_flush_tlb_with_range(
> -					kvm, vcpu, range);
> +				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
> +							    range);
>  		}
> -	} else {
> -		ret = __hv_remote_flush_tlb_with_range(kvm,
> -				kvm_get_vcpu(kvm, 0), range);
> +	} else if (VALID_PAGE(to_kvm_vmx(kvm)->hv_tlb_eptp)) {
> +		ret = hv_remote_flush_eptp(to_kvm_vmx(kvm)->hv_tlb_eptp, range);

I assume Hyper-V will swallow IVALID_PAGE without complaining much but
it seems pointless to do anything in this case indeed.

>  	}
>  
>  	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 5961cb897125..3d557a065c01 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -301,6 +301,7 @@ struct kvm_vmx {
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
>  
> +	hpa_t hv_tlb_eptp;
>  	enum ept_pointers_status ept_pointers_match;
>  	spinlock_t ept_pointer_lock;
>  };

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

