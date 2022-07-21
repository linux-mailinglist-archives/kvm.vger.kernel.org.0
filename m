Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C45457D694
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 00:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiGUWLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 18:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiGUWLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 18:11:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5BD951DB
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:11:34 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d7so3062539plr.9
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1OMkxya64oLFn01YsoSOjcmTybRrudoA8KE9EVfRHwc=;
        b=oyjmQuK5WI+t2c0GxZAPtBvzMNHu/Z/KeDL9GqgRO3tmBPVIsqiXHcAibWz5jnjVWL
         XdSIEmIEAlYVAjQDGDO19Tnqv5BMW8ji9yOLZoHJfIOSzCmpLPkNJpKBYvW+KKZbLZfj
         4Je0qcSW9wunx/X4pvh/U3ikvMn09tDDCxysGI3/Pm278rJAnhsuEr6dkNYR7de7INVb
         UBQkxo0qK1U7/lEY1qNYC9FGWsGvALnp9ZViAnZdayortTCazYsEBMhGlVBjIspAKLmV
         h1PaocP2AT97MfQgVENxuRgteEFmH3f0Z+gcuQBEX79k1hXzArapWLYOSHyZ8xmub+CE
         Eiyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1OMkxya64oLFn01YsoSOjcmTybRrudoA8KE9EVfRHwc=;
        b=A6MusjfxZgekItSlu2rTf7LWWfj3wSSfmQdBPv70UmermrliY9sQvjQRXdFlzOia8K
         IaJpd/zlmfxUg8snWCWrT0OK9EzVUjrDKUEVkqZySyQ8eEEEpxDlBrxStphLALpo3wqL
         AKVPpewNdNKmoVM6+wi1iKdlWUnfybYDnBqxkexJiCSJcYPpY/w+WRzDCF9qlQb4nZA4
         QZsPOQFsmzwuM8oqVvLeyzCAba1HNZd0zH0GZQIaVfm2kJkN1uaBA2FgLxmA7m0oG+W9
         dGppo1Rzmuc7Mv/GVufJfsw1ws9zH5guwprheRroHo/bDxO73axYpme8C9pz+dP28vQX
         ZTJQ==
X-Gm-Message-State: AJIora8sHIlrzCcUfu/cBAeVMvTH5sxVU+hbIGHL0o2C7OpjTl+3shCN
        u4M/OR1qTnDP/wXhYxUuEGs/3Q==
X-Google-Smtp-Source: AGRyM1vdVDnduCGLxaZMNPAxjPjZtL6lwRvJ+nfzfaHSzgHs35NneYTo/hgnZfsMZFkbs0URFmWrJg==
X-Received: by 2002:a17:90b:1d0d:b0:1ef:afd1:9f25 with SMTP id on13-20020a17090b1d0d00b001efafd19f25mr13381230pjb.200.1658441493539;
        Thu, 21 Jul 2022 15:11:33 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a6-20020a170902ecc600b0016be527753bsm2227073plh.264.2022.07.21.15.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 15:11:33 -0700 (PDT)
Date:   Thu, 21 Jul 2022 22:11:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/25] KVM: VMX: Tweak the special handling of
 SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
Message-ID: <YtnPEem7q1i+4VBN@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-15-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-15-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> SECONDARY_EXEC_ENCLS_EXITING is conditionally added to the 'optional'
> checklist in setup_vmcs_config() but there's little value in doing so.
> First, as the control is optional, we can always check for its
> presence, no harm done. Second, the only real value cpu_has_sgx() check
> gives is that on the CPUs which support SECONDARY_EXEC_ENCLS_EXITING but
> don't support SGX, the control is not getting enabled. It's highly unlikely
> such CPUs exist but it's possible that some hypervisors expose broken vCPU
> models.

It's not just broken vCPU models, SGX can be "soft-disabled" on bare metal, e.g. if
software writes MCE control MSRs or there's an uncorrectable #MC (may not be the
case on all platforms).  This is architectural behavior and needs to be handled in
KVM.  Obviously if SGX gets disabled after KVM is loaded then we're out of luck, but
having the ENCL-exiting control without SGX being enabled is 100% valid.

As for why KVM bothers with the check, it's to work around a suspected hardware
or XuCode bug (I'm still a bit shocked that's public now :-) ) where SGX got
_hard_ disabled across S3 on some CPUs and made the fields magically disappear.
The workaround was to soft-disable SGX in BIOS so that KVM wouldn't attempt to
enable the ENCLS-exiting control

> Preserve cpu_has_sgx() check but filter the result of adjust_vmx_controls()
> instead of the input.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ce54f13d8da1..566be73c6509 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2528,9 +2528,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			SECONDARY_EXEC_PT_CONCEAL_VMX |
>  			SECONDARY_EXEC_ENABLE_VMFUNC |
>  			SECONDARY_EXEC_BUS_LOCK_DETECTION |
> -			SECONDARY_EXEC_NOTIFY_VM_EXITING;
> -		if (cpu_has_sgx())
> -			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
> +			SECONDARY_EXEC_NOTIFY_VM_EXITING |
> +			SECONDARY_EXEC_ENCLS_EXITING;
> +
>  		if (adjust_vmx_controls(min2, opt2,
>  					MSR_IA32_VMX_PROCBASED_CTLS2,
>  					&_cpu_based_2nd_exec_control) < 0)
> @@ -2577,6 +2577,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  		vmx_cap->vpid = 0;
>  	}
>  
> +	if (!cpu_has_sgx())
> +		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
> +
>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
>  		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
>  
> -- 
> 2.35.3
> 
