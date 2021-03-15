Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CF533BF8F
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 16:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhCOPQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 11:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhCOPPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 11:15:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A46C06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 08:15:32 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so2105480pjb.0
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 08:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=29tlbpBidLiX7cZGeLgeOwEsi9aLcqGPG2CxmfByAsQ=;
        b=G70Yi+HZ7xQs8CVYSesF7lAmPjStzjs1y2vz86ytp/moWZPMOjyu5kDS2vRMASm7TC
         eYkptyylr9YmpYCXc541zduhUa5bjGaDikfNvXgW25K/aivRZmB3DxnwTgEyEM5+SNcG
         4y2RYGB60pM6GWjqf8yyr1JodFbkJZBROVT+PNIPtRN1iFin52czM+TWVuKISmfa5KZU
         kN4FWw3MA1dFnVAdFpXnaPaA0gYhmSnhQqoec3l38kyI7WxlVJq6gKB4YstXw20q9npo
         og7Soan1r30+kXGpZXXShyJOdwelsknDbjsfxtnd/1GokjN46GBlgD5/2c5Q1r7cOz4n
         XjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=29tlbpBidLiX7cZGeLgeOwEsi9aLcqGPG2CxmfByAsQ=;
        b=JJ5aQS9M6eUTX1HGOJn3o5i3k9+ms2689rGtEMOWURFmczPNEggXfbwSAJ3jJUXhw2
         oM0qduhvHWxd7b7fCttGJZlqIT+IzGF34qXZbw4TEQAjjVwDcnoW+Eb3kz9wNgRzX8TT
         9mGB3cOCOG0R/OhdW2yr3a4ZLWMVz8nFUSSl8yICNg7U3jldojVSOyHznDuKRTCuUxjb
         DCqNb7fXLpZGI+SBbS3cfdYI4dreE4ykGb96FP3fD8+aQvV6qB1p2dH25QsW+D0+/ouO
         ZLUUdkQChvPLxIlSSycwBWc9hEVxAghBBQc41z2ychrIMswh6UnyyEAz4YWUCs/8wRuO
         supA==
X-Gm-Message-State: AOAM533LiYZr4o6G9/z3p9/pmJJZ3MQONuoF0WW7GDJUZmroTIsgyVtg
        zqFAWsE6T98QWr5DqpzZvLBJSQ==
X-Google-Smtp-Source: ABdhPJw0Wp2wjRR9CitnPrjcB1f6eX+nzwALcNAzjhks9pfylM6xEeSY/z9JaS56JUgekOlamOBRbA==
X-Received: by 2002:a17:902:c154:b029:e5:e7cf:9627 with SMTP id 20-20020a170902c154b02900e5e7cf9627mr11785530plj.68.1615821331929;
        Mon, 15 Mar 2021 08:15:31 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:3d60:4c70:d756:da57])
        by smtp.gmail.com with ESMTPSA id h14sm11725077pjc.37.2021.03.15.08.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:15:31 -0700 (PDT)
Date:   Mon, 15 Mar 2021 08:15:24 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: hyper-v: Track Hyper-V TSC page status
Message-ID: <YE96DDyEZ3zVgb8p@google.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315143706.859293-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021, Vitaly Kuznetsov wrote:
> Create an infrastructure for tracking Hyper-V TSC page status, i.e. if it
> was updated from guest/host side or if we've failed to set it up (because
> e.g. guest wrote some garbage to HV_X64_MSR_REFERENCE_TSC) and there's no
> need to retry.
> 
> Also, in a hypothetical situation when we are in 'always catchup' mode for
> TSC we can now avoid contending 'hv->hv_lock' on every guest enter by
> setting the state to HV_TSC_PAGE_BROKEN after compute_tsc_page_parameters()
> returns false.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index eefb85b86fe8..2a8d078b16cb 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1087,7 +1087,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
>  	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
>  	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
>  
> -	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
> +	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN)
>  		return;
>  
>  	mutex_lock(&hv->hv_lock);

...

> @@ -1133,6 +1133,12 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
>  	hv->tsc_ref.tsc_sequence = tsc_seq;
>  	kvm_write_guest(kvm, gfn_to_gpa(gfn),
>  			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
> +
> +	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
> +	goto out_unlock;
> +
> +out_err:
> +	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
>  out_unlock:
>  	mutex_unlock(&hv->hv_lock);
>  }
> @@ -1193,8 +1199,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  	}
>  	case HV_X64_MSR_REFERENCE_TSC:
>  		hv->hv_tsc_page = data;
> -		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE)
> +		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE) {
> +			if (!host)
> +				hv->hv_tsc_page_status = HV_TSC_PAGE_GUEST_CHANGED;
> +			else
> +				hv->hv_tsc_page_status = HV_TSC_PAGE_HOST_CHANGED;

Writing the status without taking hv->hv_lock could cause the update to be lost,
e.g. if a different vCPU fails kvm_hv_setup_tsc_page() at the same time, its
write to set status to HV_TSC_PAGE_BROKEN would race with this write.

>  			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> +		}
>  		break;
>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>  		return kvm_hv_msr_set_crash_data(kvm,
> -- 
> 2.30.2
> 
