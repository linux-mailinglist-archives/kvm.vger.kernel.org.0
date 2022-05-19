Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB1952DC33
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243503AbiESR74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 13:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243482AbiESR7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 13:59:51 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10613D02B1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 10:59:51 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a9so3705332pgv.12
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 10:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZG6+lov3cxhj/3dSakUHhK2uNdevz22kJZXDGdoSRa0=;
        b=HvGK5AoIKlR1DmUqXH/3JrsgrNgbI6CxqpjF7swr+ovrKu9ZKjE7XFxxmYv5z3A4vQ
         zFvQc+wGmpLaOyrkIJfRysB6FfJmuK3rzqDDq5QwJ8NqQicHM1NYueDGQHY29Zvh8kHv
         72G71y5GU883B6GtWgxh3517kplrz9FUDcsN/S9p18ysjhsmBWGWVLC6+jrce5mXeS6T
         hJn8crK4Rfll/pVc0Gv4CF49L5PbbjNKLks6UUXq/cSzeSqtlzT/NQv9bHnwLI+Udrs2
         SiGoXwNhhOVN26ONktooTtWmXg4Z+AJ3q26Zn8cOCnchPiM8WqoZ8sfHvLkx6kvoibLf
         jBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZG6+lov3cxhj/3dSakUHhK2uNdevz22kJZXDGdoSRa0=;
        b=NLq8+uGpAK1sTpItTfuJkU3kp0b3B02hsnesfWWqL5URl14cxsCfHWxU6XwJvvyCIx
         0pXL6kviND9Po3jl6nhT5lQLt3xNoxYZewLGnaLQGzrfIHx8mcam6rdqD/uxOVoOr13R
         C1JOMSUa3sDJ/NTVY2ublc2oc9bNmv7DDtKmU73DxJJ3LSakO+YjtwocYh1QAbA/UxvW
         +hO2ZiqfchX98PlT9UIEZrbJnBUlJT34zgU8z/ZTUuEH6UfB7COkL431DQmxyExtTfAC
         brvPSr7R4BN6SH5K9i8L831HSkR9/bW6Q4NVCvx0OUhkvLmO2EYhAOihAMmsYDP0I9qV
         8Qug==
X-Gm-Message-State: AOAM530HHwZ+TxPBVAb/YzR11CuqY8S0XSff6oqoU3MqnnnHaueBlm69
        K89+bfvbLMj3hTY4XfDNGtuoJA==
X-Google-Smtp-Source: ABdhPJwJrgaenuQoJ3gtMljcMqROuGtxxtaXevg8lRhJyXVzkZRsV/Svi9mn3qMabsx3sZ23y479Zg==
X-Received: by 2002:a65:554d:0:b0:3c6:3f22:72cd with SMTP id t13-20020a65554d000000b003c63f2272cdmr4900212pgr.283.1652983190330;
        Thu, 19 May 2022 10:59:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x7-20020a170902b40700b0015e8d4eb254sm4009372plr.158.2022.05.19.10.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 10:59:49 -0700 (PDT)
Date:   Thu, 19 May 2022 17:59:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Read BNDCFGS if not from_vmentry
Message-ID: <YoaFknp7Swj0DdRw@google.com>
References: <20220421091331.11196-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421091331.11196-1-lei4.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022, Lei Wang wrote:
> In the migration case, if nested state is set after MSR state, the value
> needs to come from the current MSR value.
> 
> Signed-off-by: Lei Wang <lei4.wang@intel.com>
> Reported-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f18744f7ff82..58a1fa7defc9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3381,7 +3381,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
>  		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
>  	if (kvm_mpx_supported() &&
> -		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> +	    (!from_vmentry ||

Gah, my bad, this isn't correct either.  The minor issue is that it should check
vmx->nested.nested_run_pending, not just from_vmentry.  If nested state is restored
and a VM-Entry is pending, then the MSRs that were saved+restore were L1's MSRs,
not L2's MSRs.

That won't cause problems because the consumption correctly checks nested_run_pending,
it's just confusing and an unnecessary VMREAD.

But that's a moot point because vmcs01 will not hold the correct value in the SMM
case.  Luckily, BNDCFGS is easy to handle because it's unconditionally saved on
VM-Exit, which means that vmcs12 is guaranteed to hold the correct value for both
SMM and state restore (without pending entry) because the pseudo-VM-Exit for both
will always save vmcs02's value into vmcs12.

GUEST_IA32_DEBUGCTL is a much bigger pain because it's conditionally saved on
exit.   I think the least awful approach would be to save L2's value into
vmcs01_debugctl prior to the forced exit in vmx_enter_smm(), but that will require
more changes to the state restore flow.  Grr.

I'll send patches for both BNDCFGS and IA32_DEBUGCTL, and will take a careful look
at the PKS stuff too.  I'm guessing it should follow the BNDCFGS logic.

Sorry for the runaround.
