Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7312B02B1
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 11:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgKLK1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 05:27:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727227AbgKLK1T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 05:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605176837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXviuxk2g2luW7gT8Z4OXHxjhf58cXr2ylFfxf2m04M=;
        b=CKvNp0w3x7u5oFYadTNLSfJoa/pZrMexgBnMYZXpFuJbhXrrascUlioySEbxZW6XLak66F
        0d/mdvvIFj8yu8gUyjaEpEJSLnHWujXtAsaTNK8yLzm/vOC7QqC5JogbhUxQ+M+nMtAXmG
        2wVrTEAvNgwT7eUWQr5EDc3Qxl6Pp2g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-8PbXVgFRMpKIwXtCsyBCFQ-1; Thu, 12 Nov 2020 05:27:14 -0500
X-MC-Unique: 8PbXVgFRMpKIwXtCsyBCFQ-1
Received: by mail-wr1-f71.google.com with SMTP id h8so1730725wrt.9
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 02:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aXviuxk2g2luW7gT8Z4OXHxjhf58cXr2ylFfxf2m04M=;
        b=WWQJ35ovA/76C3rijndqCNgdoC6HBEdDEg9fj6XZwmCA32gV2aGmCYSnhB2FL5Rp+G
         4PBde5/tZ+ixSlXOOEmfnBNFK4BJXGb3ItnH0ERjhqfL2bo70Op0q6vtTLk4BR5uo2c9
         3lwCF+pBOYF03sP/Vc3blrXumnpyNDOWNxXtjFN1NLfU/hyqXjzNfKlUpi9c6hbBors9
         e7oKGej1mSTvEwCAI4oy/p81WQ82iOMhlhVKA5hKbN8sp8hHE3n7KVr2vVOZBC999mWV
         yiSuGOt/Vy3uvXyFS+D8mi7Wh2etAUMu4FU6pcpSd0OAXky0q/3tOnWOXjn9Z7DgTOLR
         IXVQ==
X-Gm-Message-State: AOAM533CArwfptb5ZIgJbqzusC9UxZHyAv7aZybb4cmykZkg6dZsJyrg
        Z8R0URgXqwp1omELYyOwu0fr4Vt6WuxZCcqMaGgrgOeL9VbdLvUsz3tBstAnZG/Vo3ByIo+jME+
        gnMGIkBBzPBVX
X-Received: by 2002:adf:8366:: with SMTP id 93mr34308596wrd.321.1605176833493;
        Thu, 12 Nov 2020 02:27:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynlQ3DyJ1PTaMmRIZXzM5mczKefoSq8TcT5rbFvm2qHtIqAQU+nQnA3GmegdweWwjwveJImw==
X-Received: by 2002:adf:8366:: with SMTP id 93mr34308577wrd.321.1605176833321;
        Thu, 12 Nov 2020 02:27:13 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c2sm6514659wrf.68.2020.11.12.02.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:27:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] KVM: VMX: Track common EPTP for Hyper-V's
 paravirt TLB flush
In-Reply-To: <20201027212346.23409-3-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-3-sean.j.christopherson@intel.com>
Date:   Thu, 12 Nov 2020 11:27:11 +0100
Message-ID: <87eekyzx8g.fsf@vitty.brq.redhat.com>
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
>  arch/x86/kvm/vmx/vmx.c | 20 +++++++++-----------
>  arch/x86/kvm/vmx/vmx.h |  1 +
>  2 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 273a3206cef7..ebc87df4da4d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -483,12 +483,14 @@ static void check_ept_pointer_match(struct kvm *kvm)
>  		if (!VALID_PAGE(tmp_eptp)) {
>  			tmp_eptp = to_vmx(vcpu)->ept_pointer;
>  		} else if (tmp_eptp != to_vmx(vcpu)->ept_pointer) {
> +			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
>  			to_kvm_vmx(kvm)->ept_pointers_match
>  				= EPT_POINTERS_MISMATCH;
>  			return;
>  		}
>  	}
>  
> +	to_kvm_vmx(kvm)->hv_tlb_eptp = tmp_eptp;
>  	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
>  }
>  
> @@ -501,21 +503,18 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
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
> @@ -533,12 +532,11 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
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
>  	}
>  
>  	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index a2d143276603..9a25e83f8b96 100644
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

