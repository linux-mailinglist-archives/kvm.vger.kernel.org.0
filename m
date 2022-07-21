Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2C257D703
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 00:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiGUWjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 18:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiGUWjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 18:39:07 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40589B5A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:39:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y24so3112592plh.7
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5BvfHq2lTZErkasii1jgE6YW7HKwD3mAVcfjh5S1rsM=;
        b=R4NfdldE60aDy0LaVigIzFGzrv9FvyVjY36WsCw3NgLlRL3Uy5ipBhxl2Vq+W80DA3
         PPVFe4z3/5l2B1k8uDGbaNQCOlGWo7OM/s7Xjg7wVmhiELTkbOKCdC0UlNVWpX2mzwKT
         eTxJ55HksOL4M8nUvvycwfdxn+PQTyvRjKskr48TvvAjgMVza3GXUjpIUilBeIBzV7GE
         8aUgsNvdb4WDvS1pboXbkLMMgVrzvD80IQ5gIvXhBNOiZmnXCibA1hFsR264RFirAnoe
         8VBvQD4ZS06lDWqYKJNs7C9mN3iesY36NyX/5mqkCT/sGy3KeMvN7oShMpLvzyZWI9XK
         9k/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5BvfHq2lTZErkasii1jgE6YW7HKwD3mAVcfjh5S1rsM=;
        b=6KVhQSET4K+VqOe1tO6iVFPpHg2ERlMtd0o4Mx9zn2i/FiM6pAHwzMIpVf+c/XQ1tP
         wni4dMJiefs2tyNeFGGmdyleuiWDQEK+R1F3Na14llDC6cI9kW9f3NJCCegRV+aX07i9
         fAYfGQtQSl7Pi/Nq2Np4U2Ic4JWcffogzwgZuFwOljrFXR1PyJTXjna3q+rsXNUWZoTZ
         CrwvwA67/YxaNHpfTNIXp2GdOVbV7OTfAq6i/MV31sGKWK/FXnydtvAjFvbVIpgDRjsz
         L/eTXv9oXt1ZlROW1L5XM0RQnGaxbUrcr/7nGoAWLCTcUX9QJFanr3JMsRiXeBOgSuww
         g7+w==
X-Gm-Message-State: AJIora+ZbhAdRiNoZbUj7sYj7NV7DWTqDHnB9sc97rLHzVlzWO2Fkc3m
        RJsRZKiZqMbO9Cw8dp2qQQMQUw==
X-Google-Smtp-Source: AGRyM1uqv3JCAjossSLSzKvL74YCZI1slQMOmoZChvzDYH12nTlipPQo+jB6YFPR7eexWjJuLfcr/Q==
X-Received: by 2002:a17:90b:3a8b:b0:1f0:127:360d with SMTP id om11-20020a17090b3a8b00b001f00127360dmr685727pjb.64.1658443145559;
        Thu, 21 Jul 2022 15:39:05 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090a644e00b001f217ec21efsm4070309pjm.13.2022.07.21.15.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 15:39:04 -0700 (PDT)
Date:   Thu, 21 Jul 2022 22:39:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 18/25] KVM: VMX: Add missing CPU based VM execution
 controls to vmcs_config
Message-ID: <YtnVhIzxkkxM3cTk@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-19-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-19-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> As a preparation to reusing the result of setup_vmcs_config() in
> nested VMX MSR setup, add the CPU based VM execution controls which KVM
> doesn't use but supports for nVMX to KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL
> and filter them out in vmx_exec_control().
> 
> No functional change intended.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 ++++++
>  arch/x86/kvm/vmx/vmx.h | 6 +++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2fb89bdcbbd8..9771c771c8f5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4240,6 +4240,12 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  {
>  	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
>  
> +	/* Not used by KVM but supported for nesting. */

And then for this one, clarify that these _are_ enabled in vmcs02.  It doesn't
really matter, I was just surprised by the "SAVE_PAT" in the previous patch because
for a second I thought we were leaking host state :-)

	/*
	 * Not used by KVM, but fully supported for nesting, i.e. are allowed in
	 * vmcs12 and propagated to vmcs02 when set in vmcs12.
	 */

> +	exec_control &= ~(CPU_BASED_RDTSC_EXITING |
> +			  CPU_BASED_USE_IO_BITMAPS |
> +			  CPU_BASED_MONITOR_TRAP_FLAG |
> +			  CPU_BASED_PAUSE_EXITING);
> +
>  	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
>  	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
>  			  CPU_BASED_NMI_WINDOW_EXITING);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index e9c392398f1b..758f80c41beb 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -539,9 +539,13 @@ static inline u8 vmx_get_rvi(void)
>  #endif
>  
>  #define KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL			\
> -	(CPU_BASED_TPR_SHADOW |					\
> +	(CPU_BASED_RDTSC_EXITING |				\
> +	CPU_BASED_TPR_SHADOW |					\
> +	CPU_BASED_USE_IO_BITMAPS |				\
> +	CPU_BASED_MONITOR_TRAP_FLAG |				\
>  	CPU_BASED_USE_MSR_BITMAPS |				\
>  	CPU_BASED_NMI_WINDOW_EXITING |				\
> +	CPU_BASED_PAUSE_EXITING |				\
>  	CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |			\
>  	CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
>  
> -- 
> 2.35.3
> 
