Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17767463BC5
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbhK3Qdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 11:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243846AbhK3Qdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 11:33:47 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F679C061574;
        Tue, 30 Nov 2021 08:30:27 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so89207439eda.12;
        Tue, 30 Nov 2021 08:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DsOmc2w83jCCkTXB0HfUYzD8fzPF4maqoG8bwemsFe0=;
        b=lFtV6fWeCTpRcm2a4AhNpgWYrWDfsAzdKy4YtOAaANNrMnJV1NLNnh3wp7w9gerQ1Q
         j5M3hm8t+QFiGcar3EcHCckfTmMi42KOd3p5KAQF3tu4czTS5vd738EWM3uUwqsLY8vd
         OBlx42vvejYzVh8vESWOm5hnM2TvSa2CdvqQsADAfQXRb3/8/8vZmqMpL4Hr2q0biaNM
         QOeXZjJvnEiWhmmzMOPNysLY8Apjp0FdsZQ6FoEShzVy8Xj+nwhH57Kc6S09NoV10tMW
         TkTEu5TTu2lNfkSkSoILtELCmY49pSSwr4OgeaEA7MZmSjhn0TZX+uR0kwIPHNvoEb5o
         J7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DsOmc2w83jCCkTXB0HfUYzD8fzPF4maqoG8bwemsFe0=;
        b=d+PXk6zRnUkaxNjWJFzSvIFlWLfqlwuhRSGaqQ7s+bw4zXScOQjh9GPXuPEQWdCRHg
         Wl947hVd/sLbRMjGrosCiiqFkGRkcPR83Sjj3Ol9YsHvSM5INzgYowPPBBRmTfkHTU9V
         cV4egkujbE0E3FSZoxkmVy1rH5hlC8vsxIFO8sHgsXSTbZBlEzVIKJSVO2V6MNjU9kqz
         dhHG68nZYrgZFIko5n2Z+uREy751rk8+YwasjCIaWvaN7DowZhPTJ0vxTuMo0LDwDwL2
         DwW2jLlV3ubjh7m+8ejD8F1QcbJjnt8w+uZQOZlE4qOYtb5btGzcY83jybmCY4CrUHL0
         jOmw==
X-Gm-Message-State: AOAM530exYQQgyyrhCyYnvIsMu6WhctmcNpa9kTDZuRD7RsmWi0UFNIm
        E3XLvm5oA1ijfEHGeCdL9Zw=
X-Google-Smtp-Source: ABdhPJzDajCFfIB/lSvWEvM3dafZmgJCtC0I/KBdzagN9LMhqmokukLs3ifBB7smg58lNBRAtoVh7w==
X-Received: by 2002:a17:906:6a08:: with SMTP id qw8mr197371ejc.200.1638289826211;
        Tue, 30 Nov 2021 08:30:26 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id sc7sm10677827ejc.50.2021.11.30.08.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 08:30:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <edcdcf27-384c-6dd9-ec91-4b0e45c8cade@redhat.com>
Date:   Tue, 30 Nov 2021 17:30:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: VMX: Set failure code in prepare_vmcs02()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Oliver Upton <oupton@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Peter Shier <pshier@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20211130125337.GB24578@kili>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211130125337.GB24578@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 13:53, Dan Carpenter wrote:
> The error paths in the prepare_vmcs02() function are supposed to set
> *entry_failure_code but this path does not.  It leads to using an
> uninitialized variable in the caller.
> 
> Fixes: 71f7347025bf ("KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on VM-Entry")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 315fa456d368..f321300883f9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2594,8 +2594,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>   
>   	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>   	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> -				     vmcs12->guest_ia32_perf_global_ctrl)))
> +				     vmcs12->guest_ia32_perf_global_ctrl))) {
> +		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>   		return -EINVAL;
> +	}
>   
>   	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
>   	kvm_rip_write(vcpu, vmcs12->guest_rip);
> 

Yeah, I suppose that's the right thing to do (though it really shouldn't 
happen because the value is checked earlier in 
nested_vmx_check_guest_state).

Queued, thanks.

Paolo
