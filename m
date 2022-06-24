Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F52558C24
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 02:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiFXAMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 20:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFXAMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 20:12:22 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D475D103
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:12:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n10so699144plp.0
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7t5NX7+PWQirm0TfbCUOmSknXtu+ymL/PYjukdREVgg=;
        b=AjJ4YI9hzcHPMR3I7ooaCBJEv48bl8Q32Mo8hzpcUTLwAcJLwRSFxYtetfbhZ+Pbg4
         BMI9ERvL8I/Yk8tgKyNVZ0SFEC86KHhBUn6AXxsoTCDMhb/NRhDOdr9IYXh8m5VzF775
         2cs7djnBEBlsnSFUOF8gN7aqL9cK0ucyemA5qpYr+cd3nLKLY6Eb5RGDzEJGseA05MeL
         wHdA7K8/uVfMMzDdLLSTzT6GmXgTZMn4YH4cCNhxP7iYiqo9iEsnySr1uWTocJSEgXbW
         GFg7gsdItfriHRngsb9enc8dQyAb1J29KrhtE9hP1LKPPJqwqWi9CKFw9WaHXpsP4NiH
         hW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7t5NX7+PWQirm0TfbCUOmSknXtu+ymL/PYjukdREVgg=;
        b=vMWHnma8L7rczLe7eWjNhrzb80+qK3/jAPF+d/shqDr/FQrvlf4UmjIm0yBtoa/+wp
         WfYXiWDJ+XckRJ0a1AFh8ahZX7QMWAFF1G7uJ86RNO+rBrq550hcSQJjUW3Tg4poY7xU
         iu5YRdp4sJEH64Xnx42FkPwiECg8tlGltLD6gLQUz1a4STLSe/3wLrx86JcnrhVoAkJe
         +0G4dduPXMPfAZtHvPi71xPYibkifXwvuCNhG7aJbjkMlye+iurjSydZIbqrd3ukdZaT
         qLD7B1GjD+7/V85WX6kBtymd3LHpIRLvYlqsFZIEAq7e1s+pbZ+EOO1JrCXJlddKF5Zm
         6A3Q==
X-Gm-Message-State: AJIora9FImHiNCAVF4lGMNAYoWdNsrvwsG2plLlQ3QykK/+yhYcQONCW
        nwhIgX0xBL+so96AZjf29XN2Gg==
X-Google-Smtp-Source: AGRyM1s6jmuW56VoKuYkPF34C9mlc8YlBGh5LtOuEdtqsnHErPrqpLFl+cg1Zup/cnGDsRdzlYByfw==
X-Received: by 2002:a17:90b:4f8c:b0:1ec:d1bf:8c64 with SMTP id qe12-20020a17090b4f8c00b001ecd1bf8c64mr658357pjb.66.1656029541332;
        Thu, 23 Jun 2022 17:12:21 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a7-20020a1709027d8700b0016a4ca6516dsm348760plm.278.2022.06.23.17.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 17:12:20 -0700 (PDT)
Date:   Fri, 24 Jun 2022 00:12:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 02/10] KVM: VMX: Add missing CPU based VM
 execution controls to vmcs_config
Message-ID: <YrUBYTXRxBGYsd1a@google.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
 <20220622164432.194640-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622164432.194640-3-vkuznets@redhat.com>
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

Maybe say "dynamically enabled" or so instead of "missing"?

On Wed, Jun 22, 2022, Vitaly Kuznetsov wrote:
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 24da9e93bdab..01294a2fc1c1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2483,8 +2483,14 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      CPU_BASED_INVLPG_EXITING |
>  	      CPU_BASED_RDPMC_EXITING;
>  
> -	opt = CPU_BASED_TPR_SHADOW |
> +	opt = CPU_BASED_INTR_WINDOW_EXITING |
> +	      CPU_BASED_RDTSC_EXITING |
> +	      CPU_BASED_TPR_SHADOW |
> +	      CPU_BASED_NMI_WINDOW_EXITING |
> +	      CPU_BASED_USE_IO_BITMAPS |
> +	      CPU_BASED_MONITOR_TRAP_FLAG |
>  	      CPU_BASED_USE_MSR_BITMAPS |
> +	      CPU_BASED_PAUSE_EXITING |
>  	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
>  	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
> @@ -4280,6 +4286,13 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  {
>  	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
>  
> +	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
> +			  CPU_BASED_RDTSC_EXITING |
> +			  CPU_BASED_NMI_WINDOW_EXITING |
> +			  CPU_BASED_USE_IO_BITMAPS |
> +			  CPU_BASED_MONITOR_TRAP_FLAG |
> +			  CPU_BASED_PAUSE_EXITING);
> +
>  #ifdef CONFIG_X86_64
>  	if (exec_control & CPU_BASED_TPR_SHADOW)
>  		exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
> -- 
> 2.35.3
> 
