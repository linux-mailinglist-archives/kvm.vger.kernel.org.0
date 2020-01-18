Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6EF1419E3
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 22:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgARVgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 16:36:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56510 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726957AbgARVgC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jan 2020 16:36:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579383360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=quqtKIHTlB5QifzCxljH/QqdSUU+QQieu+F7UDnpOZs=;
        b=T8YEELDYTcLOMaljuWRT3M/c0T5rYPijlLmuzI2PMeMO4qf5JpB9tczk894IgMQ4HrFpSz
        /WXxbYvlChzakJOM3BS4od2rH7hl+oL6tANgo0XCHHPLDf9LjIccI9tcH59Z4x8b08k/mq
        kZ+oRS0NGlByOMg2DKq1qZd/1r5NyL8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-hrpXVVk7N1e0qLIANdw0zw-1; Sat, 18 Jan 2020 16:35:58 -0500
X-MC-Unique: hrpXVVk7N1e0qLIANdw0zw-1
Received: by mail-wr1-f70.google.com with SMTP id v17so12075232wrm.17
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 13:35:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=quqtKIHTlB5QifzCxljH/QqdSUU+QQieu+F7UDnpOZs=;
        b=aMtLJtbrEepzZAnBb9I1FJDV0vKhsWXg2H8TYEuHETcPcQlqzQTnf11TFpStNOwm5f
         n+fstKypwZZuIUJG+7BZd2w27tcneVwtJiD85t3ZgvKjVZSA0L/tRubtFSN6z0VIo0fI
         vXv4S1yDajZMpKlP5Lku1HuJsOBgC6YfrLDTUVlAGMNtfOeuw6AnnjUvv5oM+rw5TqUU
         h7JyhYLSIVoUKPZ5OLZMrXWphlUu4au9DJjNnbQzIekcV14w168w+ghQlSw5XygrvpbP
         uq44t9RB+5ZsLbPJTkGFqaXXR8WCTQQFXnpKAgCsT9PL8SSpTzznYKyeeiTHEEbQ6gE1
         DX9w==
X-Gm-Message-State: APjAAAXR+M0AJcSHloMX2Cltekdo7Ls4fBWV3ajZw5hmGs+Wcqi5C9iT
        hZnmowSW1o7+ktuw29sJUDLpSpz6b7zgw4RgH/M6hYe6Bany3dBeTHLbWTG5V+QznWnKzd+Vdnm
        vsffzinnfAuO4
X-Received: by 2002:a05:600c:21c6:: with SMTP id x6mr11328060wmj.177.1579383357443;
        Sat, 18 Jan 2020 13:35:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqzT26+Tbo9J6ZT/xLphLdMhs97YWJyyCV0D+609KsbC3sxSS84zqpaPyC2DaSSFtVsrWtMfZQ==
X-Received: by 2002:a05:600c:21c6:: with SMTP id x6mr11328047wmj.177.1579383357207;
        Sat, 18 Jan 2020 13:35:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id n14sm15689206wmi.26.2020.01.18.13.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:35:56 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: WARN on failure to set IA32_PERF_GLOBAL_CTRL
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191214003358.169496-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <10805886-6032-bb80-3511-2c5f0bd91572@redhat.com>
Date:   Sat, 18 Jan 2020 22:35:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191214003358.169496-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/19 01:33, Oliver Upton wrote:
> Writes to MSR_CORE_PERF_GLOBAL_CONTROL should never fail if the VM-exit
> and VM-entry controls are exposed to L1. Promote the checks to perform a
> full WARN if kvm_set_msr() fails and remove the now unused macro
> SET_MSR_OR_WARN().
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..fb502c62ee94 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -28,16 +28,6 @@ module_param(nested_early_check, bool, S_IRUGO);
>  	failed;								\
>  })
>  
> -#define SET_MSR_OR_WARN(vcpu, idx, data)				\
> -({									\
> -	bool failed = kvm_set_msr(vcpu, idx, data);			\
> -	if (failed)							\
> -		pr_warn_ratelimited(					\
> -				"%s cannot write MSR (0x%x, 0x%llx)\n",	\
> -				__func__, idx, data);			\
> -	failed;								\
> -})
> -
>  /*
>   * Hyper-V requires all of these, so mark them as supported even though
>   * they are just treated the same as all-context.
> @@ -2550,8 +2540,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
>  
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
> -	    SET_MSR_OR_WARN(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> -			    vmcs12->guest_ia32_perf_global_ctrl))
> +	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> +				     vmcs12->guest_ia32_perf_global_ctrl)))
>  		return -EINVAL;
>  
>  	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
> @@ -3999,8 +3989,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  		vcpu->arch.pat = vmcs12->host_ia32_pat;
>  	}
>  	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> -		SET_MSR_OR_WARN(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> -				vmcs12->host_ia32_perf_global_ctrl);
> +		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> +					 vmcs12->host_ia32_perf_global_ctrl));
>  
>  	/* Set L1 segment info according to Intel SDM
>  	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
> 

Queued, thanks.

Paolo

