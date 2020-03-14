Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC81185753
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 02:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgCOBgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 21:36:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24556 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727237AbgCOBgX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Mar 2020 21:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584236182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6C3WExn7s+xj+iSv2VKzXJvMQvMfExOgXpF/HdM+nvg=;
        b=UnBFkpLruBDqtzOk9yN5HLWGvOe2LJLLV+/bEnO+Af5yZQPRdV714EoOK3Auz+4knNykZb
        S0RAnXlaPrRNQtxt0SI2roEWo+H+hUtNEfA+QbIWJIUVFXHU4ud86qHJz6GBoGO4mniVSK
        EUWEpStFYNheQjC2R0/PL3a9Bs7iKTk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-QsPolEt5Mc68xqaoi-Wx4A-1; Sat, 14 Mar 2020 05:32:31 -0400
X-MC-Unique: QsPolEt5Mc68xqaoi-Wx4A-1
Received: by mail-wr1-f69.google.com with SMTP id t4so2738996wrv.9
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 02:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6C3WExn7s+xj+iSv2VKzXJvMQvMfExOgXpF/HdM+nvg=;
        b=cP4givvV8CEc2vTu1ZgPwDh/cJdwz27aytmFRi4qooPTUxhXjVAkzruQOen0xjhMP9
         hi9dSKmx95TTYwFcw1SxhwWDLA6yMPbyBkLJk4FnYnPvvIwXGq0AXQ1eQzYbN9Oy0agK
         U8uK8xeLrzpUDEn/AF0pqmb7LVlOIvgAa0H2+J0J1E6g/LEg+DKInjy13jdzxWoG0Lcu
         cyHbz9n01QTDgLjYHnGuqqtbF5b9A6bFY6yu7VrWtwfxh7Hm3eu6H1ORqhEghuwagvsW
         yBftPe1+bPpgOLSJUAizYL5yUtxjaVSO7kcOjrajKVV3aFea8C+pbH9BYbmYfvPnDFqo
         MWQw==
X-Gm-Message-State: ANhLgQ3cw8uJwYEatD7z9NnOqpq4OAnpB/JeLnrjNg/p+78yeV5TeZxO
        TCERqfHHWrfYn27pKTq86Ihia2f7YXAVXqXosiPX/3D8g7fGSyYBNuMLQ809YGC3ZWiGP6OfWJ4
        gGguJYx3zXVCk
X-Received: by 2002:adf:d4d1:: with SMTP id w17mr23696441wrk.206.1584178349763;
        Sat, 14 Mar 2020 02:32:29 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsPmKZzpKZ83gTWVwn+FLz5ACaVlHI/Tl1KtX0Nw1x+AfeobYV5T7TZwv62Nyh+1yh2nTWf5A==
X-Received: by 2002:adf:d4d1:: with SMTP id w17mr23696423wrk.206.1584178349535;
        Sat, 14 Mar 2020 02:32:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id a199sm11539997wme.29.2020.03.14.02.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 02:32:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Condition ENCLS-exiting enabling on CPU support
 for SGX1
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Toni Spets <toni.spets@iki.fi>
References: <20200312180416.6679-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <62c80927-b174-398b-b340-c66560811172@redhat.com>
Date:   Sat, 14 Mar 2020 10:32:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312180416.6679-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/20 19:04, Sean Christopherson wrote:
> Enable ENCLS-exiting (and thus set vmcs.ENCLS_EXITING_BITMAP) only if
> the CPU supports SGX1.  Per Intel's SDM, all ENCLS leafs #UD if SGX1
> is not supported[*], i.e. intercepting ENCLS to inject a #UD is
> unnecessary.
> 
> Avoiding ENCLS-exiting even when it is reported as supported by the CPU
> works around a reported issue where SGX is "hard" disabled after an S3
> suspend/resume cycle, i.e. CPUID.0x7.SGX=0 and the VMCS field/control
> are enumerated as unsupported.  While the root cause of the S3 issue is
> unknown, it's definitely _not_ a KVM (or kernel) bug, i.e. this is a
> workaround for what is most likely a hardware or firmware issue.  As a
> bonus side effect, KVM saves a VMWRITE when first preparing vmcs01 and
> vmcs02.
> 
> Query CPUID directly instead of going through cpu_data() or cpu_has() to
> ensure KVM is trapping ENCLS when it's supported in hardware, e.g. even
> if X86_FEATURE_SGX1 (which doesn't yet exist in upstream) were disabled
> by the kernel/user.
> 
> Note, SGX must be disabled in BIOS to take advantage of this workaround
> 
> [*] The additional ENCLS CPUID check on SGX1 exists so that SGX can be
>     globally "soft" disabled post-reset, e.g. if #MC bits in MCi_CTL are
>     cleared.  Soft disabled meaning disabling SGX without clearing the
>     primary CPUID bit (in leaf 0x7) and without poking into non-SGX
>     CPU paths, e.g. for the VMCS controls.
> 
> Fixes: 0b665d304028 ("KVM: vmx: Inject #UD for SGX ENCLS instruction in guest")
> Reported-by: Toni Spets <toni.spets@iki.fi>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> This seems somewhat premature given that we don't yet know if the observed
> behavior is a logic bug, a one off manufacturing defect, firmware specific,
> etc...  On the other hand, the change is arguably an optimization
> irrespective of using it as a workaround.
> 
>  arch/x86/kvm/vmx/vmx.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40b1e6138cd5..50cab98382e7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2338,6 +2338,11 @@ static void hardware_disable(void)
>  	kvm_cpu_vmxoff();
>  }
>  
> +static bool cpu_has_sgx(void)
> +{
> +	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
> +}
> +
>  static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>  				      u32 msr, u32 *result)
>  {
> @@ -2418,8 +2423,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
>  			SECONDARY_EXEC_PT_USE_GPA |
>  			SECONDARY_EXEC_PT_CONCEAL_VMX |
> -			SECONDARY_EXEC_ENABLE_VMFUNC |
> -			SECONDARY_EXEC_ENCLS_EXITING;
> +			SECONDARY_EXEC_ENABLE_VMFUNC;
> +		if (cpu_has_sgx())
> +			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>  		if (adjust_vmx_controls(min2, opt2,
>  					MSR_IA32_VMX_PROCBASED_CTLS2,
>  					&_cpu_based_2nd_exec_control) < 0)
> 

Queued, thanks.

Paolo

