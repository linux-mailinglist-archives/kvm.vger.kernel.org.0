Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963F3558C1C
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 02:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiFXAJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 20:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiFXAJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 20:09:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2237356FAB
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:09:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 128so1047080pfv.12
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kmIOcSZ0XyvR8utlTv5b37APzufzmKu6KXV604cAkks=;
        b=PFe18VaFhnS2ZT5vucNtUjtMrbL5fT+p1wHxfF79shjK8OTNjP53aakMa2b+zVXkuc
         CmA8KDew4qpMkvB6Yk5ZQ4WTjrLuHnFR6dyH+m8BPa6dHem6Em6vDpPKN/etuMv+GIPX
         jNlPai9N3MGMUF97DkaQORnNzm1lA7ZI7U2mny/9lnqMi4EZ99EHlf3CNPiiBeBypOVE
         Yapf26UfzsiC40UcMcnUwh4BOqyrrHAi/tg1RBSN7ThyTMI2f6qokY8M3DIs9fBGQ6YR
         vCu2CgQcMubPd4aHpb/Plffwgn5V7kQAPWkC38EyQoe/PfanOtJxDvYcHeyFV5t5dcvO
         ScjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kmIOcSZ0XyvR8utlTv5b37APzufzmKu6KXV604cAkks=;
        b=fJkGFiNIseqzpLxdPps9ViWpiBeYV32JTgul3cdQpzc+pmvGysWMigjuyULv6p5v89
         dAkyJ217S5+DuGmTP9ge/YS1WhXuM+HVkx2QQV7grWMX+hEy+BKXQduHMOjAc5vPkebr
         H+Irjpa9CCnWXfrhIs9nMMC5+GN2xuevCoKrzVtP/fcOhrr9oYHCZSPHgQYf1iqX6Olk
         hE8rVNaAIov0SRSIhl2cndUXQ+HHj9nMArcsx0brAusAofYVLysQCOHLwrtzzbhxODJe
         X5XwVy5q75WLXEsycPy0NYjIsHEDXT5xS4w9opaVidu6+4uJnWoMhfeHxsXLVs+X9OfJ
         TX+Q==
X-Gm-Message-State: AJIora/QS1OkHniD/vhbEF7p9qgba9v5GFtgfsi3cyi0YLrYa5rGCKn3
        1OdLjDejAG25wSjaYAQ7Brvcvw==
X-Google-Smtp-Source: AGRyM1vOU2JOxzyPmhn3SCTphsf1lpqO4zI/+wpXbPVC8mkQutvYrMGQoOaRm82CH9BNGfIrgKqQHg==
X-Received: by 2002:a63:371e:0:b0:40c:f411:6768 with SMTP id e30-20020a63371e000000b0040cf4116768mr9519656pga.471.1656029380480;
        Thu, 23 Jun 2022 17:09:40 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7888b000000b0052516db7123sm229410pfe.35.2022.06.23.17.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 17:09:39 -0700 (PDT)
Date:   Fri, 24 Jun 2022 00:09:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 01/10] KVM: VMX: Move
 CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of setup_vmcs_config()
Message-ID: <YrUAwPJTrYNT+zIt@google.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
 <20220622164432.194640-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622164432.194640-2-vkuznets@redhat.com>
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

On Wed, Jun 22, 2022, Vitaly Kuznetsov wrote:
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5e14e4c40007..24da9e93bdab 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2490,11 +2490,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
>  				&_cpu_based_exec_control) < 0)
>  		return -EIO;
> -#ifdef CONFIG_X86_64
> -	if (_cpu_based_exec_control & CPU_BASED_TPR_SHADOW)
> -		_cpu_based_exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
> -					   ~CPU_BASED_CR8_STORE_EXITING;

Eww, who does a double "~" with an "&"?

> -#endif
>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
>  		min2 = 0;
>  		opt2 = SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
> @@ -4285,6 +4280,12 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  {
>  	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
>  
> +#ifdef CONFIG_X86_64
> +	if (exec_control & CPU_BASED_TPR_SHADOW)
> +		exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
> +			~CPU_BASED_CR8_STORE_EXITING;

If you shove this done a few lines, then you can have a single set of #ifdefs,
and avoid restoring the controls a few lines later if it turns out KVM isn't
enabling the TPR shadow, e.g. (with fixup to use the more canonical ~(x | y)
pattern).

	if (!cpu_need_tpr_shadow(&vmx->vcpu))
		exec_control &= ~CPU_BASED_TPR_SHADOW;

#ifdef CONFIG_X86_64
	if (exec_control & CPU_BASED_TPR_SHADOW)
		exec_control &= ~(CPU_BASED_CR8_LOAD_EXITING |
				  CPU_BASED_CR8_STORE_EXITING);
	else
		exec_control |= CPU_BASED_CR8_STORE_EXITING |
				CPU_BASED_CR8_LOAD_EXITING;
#endif
