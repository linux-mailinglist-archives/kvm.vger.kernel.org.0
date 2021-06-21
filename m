Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB1B3AF003
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 18:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhFUQqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 12:46:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233102AbhFUQmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 12:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624293588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZVDqd8sbpAlkwfGCO+rADwqCgjhskAYCWvX7EQkZ1W4=;
        b=cNVgn/zxlSERqfjoTOH/DWSa/sGGXkslbYCsOvqtUaiA6U8IkhCxMvd8sFDGijLA/LBchW
        rps2LZzNTBbsX5/r5vuHY20hyjhz3jOeSfEcFCxYU6Z6K5sDHSSEq8FYs29rzVv49DrlqZ
        UmuC6Wwxw/HUMx1gpPCW3d+sJTVbu0Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-4au-PxKxOySZhX95UJODxg-1; Mon, 21 Jun 2021 12:39:47 -0400
X-MC-Unique: 4au-PxKxOySZhX95UJODxg-1
Received: by mail-wm1-f71.google.com with SMTP id h14-20020a05600c350eb02901dfc071c176so210123wmq.3
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 09:39:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVDqd8sbpAlkwfGCO+rADwqCgjhskAYCWvX7EQkZ1W4=;
        b=hy79CJcz0KDrm0ioj/EJ7NJpUHNe/Hn5LPFtnzFLg+OeRxdUYGYG6fJGUOL1/cOxXF
         OGfvFCK6vIODSy31Qd6Wnrw132SbXCy+pC363FJzCWgVdXLnfUXN6kL6mVNClY4ffRd7
         iTGigzCd0Ctp6TJDt5fpY6fjvmuzxGR1v+9pBXB8qsQXTzuCr3fD6sYpQXX18VCOk0t8
         H0YH+yncfsf5axjRi3Tz/XVAGBWq7QlJx6enTo1fkZa+9jTdq0yfxiK5/zsBrfIcAOw7
         am1yciGnuwhoF7yd1I3jXEhLWXkvghIEAoANo+EK7RTKURrTRBymK9Se+YyF26hIolKJ
         VXtA==
X-Gm-Message-State: AOAM530EDSNKVFMFSTD4cxOHSNAt7/FmL3HHfBNvEAF2R+FRBx09zBRk
        0yAr+XQEkF+HE78dv0olFJ9mAg7U01bDhTnGiipRTsmWoWe1PGd0/8LiL2Eyu5/KW8vUgOJ0slD
        SLW0BwxosJ/3s1YBWus0EdY6XkaJHJQIE7Uy+tgG53EFbh2hmKyzJzo6MXXf/pyoD
X-Received: by 2002:a5d:6b0e:: with SMTP id v14mr29402623wrw.297.1624293585591;
        Mon, 21 Jun 2021 09:39:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgFknzWpsZ6M5ad3wQ9Yr9eI3AibkvtKsyabXUQVpK1bDBijTT8hq5XE+dQRsHWX9FQki9nA==
X-Received: by 2002:a5d:6b0e:: with SMTP id v14mr29402607wrw.297.1624293585420;
        Mon, 21 Jun 2021 09:39:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z4sm10212616wrs.56.2021.06.21.09.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 09:39:44 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Skip #PF(RSVD) intercepts when emulating
 smaller maxphyaddr
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20210618235941.1041604-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0489dfe0-f897-16fb-c7e6-f419a47a6c31@redhat.com>
Date:   Mon, 21 Jun 2021 18:39:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210618235941.1041604-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/21 01:59, Jim Mattson wrote:
> As part of smaller maxphyaddr emulation, kvm needs to intercept
> present page faults to see if it needs to add the RSVD flag (bit 3) to
> the error code. However, there is no need to intercept page faults
> that already have the RSVD flag set. When setting up the page fault
> intercept, add the RSVD flag into the #PF error code mask field (but
> not the #PF error code match field) to skip the intercept when the
> RSVD flag is already set.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++---------
>   1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 68a72c80bd3f..1fc28d8b72c7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -747,16 +747,21 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
>   	if (is_guest_mode(vcpu))
>   		eb |= get_vmcs12(vcpu)->exception_bitmap;
>           else {
> -		/*
> -		 * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
> -		 * between guest and host.  In that case we only care about present
> -		 * faults.  For vmcs02, however, PFEC_MASK and PFEC_MATCH are set in
> -		 * prepare_vmcs02_rare.
> -		 */
> -		bool selective_pf_trap = enable_ept && (eb & (1u << PF_VECTOR));
> -		int mask = selective_pf_trap ? PFERR_PRESENT_MASK : 0;
> +		int mask = 0, match = 0;
> +
> +		if (enable_ept && (eb & (1u << PF_VECTOR))) {
> +			/*
> +			 * If EPT is enabled, #PF is currently only intercepted
> +			 * if MAXPHYADDR is smaller on the guest than on the
> +			 * host.  In that case we only care about present,
> +			 * non-reserved faults.  For vmcs02, however, PFEC_MASK
> +			 * and PFEC_MATCH are set in prepare_vmcs02_rare.
> +			 */
> +			mask = PFERR_PRESENT_MASK | PFERR_RSVD_MASK;
> +			match = PFERR_PRESENT_MASK;
> +		}
>   		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, mask);
> -		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, mask);
> +		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, match);
>   	}
>   
>   	vmcs_write32(EXCEPTION_BITMAP, eb);
> 

Queued, thanks.

Paolo

