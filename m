Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D000C57192F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiGLL43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiGLL4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:56:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 932BEB6557
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657626928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TxYc8FmcSZX19QdaoX57VBf+h6VrEjjyMH8mCeM7LKM=;
        b=at4t0fxrVcrDWImFkn11ltQok9OQEwNSh1+4Kk3UhLn5QD+D9i2cBQzcpQJwEOLB/v4Lt+
        tEBtWiPH2VP3fNHjcIJlKn1khyXZ1IG841pcg+ZafLBtITC+FgsGtPufJeyJG8Nkc2k2py
        ng7fE62aSVbi2v1uNX+Uuw3V9apKH8s=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-VOISIltjPOehy-RBqc8Evg-1; Tue, 12 Jul 2022 07:55:27 -0400
X-MC-Unique: VOISIltjPOehy-RBqc8Evg-1
Received: by mail-qt1-f198.google.com with SMTP id b12-20020ac87fcc000000b0031eb197d53eso5105715qtk.7
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TxYc8FmcSZX19QdaoX57VBf+h6VrEjjyMH8mCeM7LKM=;
        b=CFISP5wATz6lmcXe9V3u8fCfjmxpdiq36XHH/yaDkHj4gqNT405pmB1XpzGRDTeDK/
         vyhVz5cqr6T6ixX+Ph0zUyFBGOOmTddOzjqZ3BAhYi9vImVX5HxSqnwS53A4SwuXwGO1
         2bw2TaO2xDYtqRokDYi7UGXlon7kxGSawSVKW5MjJ8szBDrZjksptASsW1W4hrl5bUos
         Vi/YHYArDqT0eTWHvBVld8Ei6B7CuBJnQS3KLsKK3VcVIjyxL+wtfOpEba6ZcPnA9qTi
         wmMCzZO16zwzrAvFl20F4zTtLnpyNksBj3749o7YBbEIZcjsewGgB/Eww84N2dAzYt+Z
         VYhg==
X-Gm-Message-State: AJIora8yGa/pFrlFo88ghUSy/KTyKKBpXwe05rU3wvsMiFe7WGw1ulG2
        vs+UnudfPyNdxahALSjTOutBjJXcWrY6s810YUTKdUV95+/gP8nG7u983Z2G+sykS917jnRqtii
        i9rL8xBqVOexo
X-Received: by 2002:ac8:5f84:0:b0:31e:bbb6:3f58 with SMTP id j4-20020ac85f84000000b0031ebbb63f58mr3828190qta.504.1657626926674;
        Tue, 12 Jul 2022 04:55:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t+PsQiRk3OobSIYFRNy3K14uwIRMOmE8I5n5Xc9II1g3oU04c4BSzhmLcj83GEUunset6W0w==
X-Received: by 2002:ac8:5f84:0:b0:31e:bbb6:3f58 with SMTP id j4-20020ac85f84000000b0031ebbb63f58mr3828179qta.504.1657626926452;
        Tue, 12 Jul 2022 04:55:26 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bp39-20020a05620a45a700b006af10bd3635sm8390385qkb.57.2022.07.12.04.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:55:25 -0700 (PDT)
Message-ID: <4cfe01772c1d89cdae5d3bf895f49b22b7086559.camel@redhat.com>
Subject: Re: [PATCH v3 13/25] KVM: VMX: Check
 CPU_BASED_{INTR,NMI}_WINDOW_EXITING in setup_vmcs_config()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 14:55:22 +0300
In-Reply-To: <20220708144223.610080-14-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-14-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> CPU_BASED_{INTR,NMI}_WINDOW_EXITING controls are toggled dynamically by
> vmx_enable_{irq,nmi}_window, handle_interrupt_window(), handle_nmi_window()
> but setup_vmcs_config() doesn't check their existence. Add the check and
> filter the controls out in vmx_exec_control().
> 
> Note: KVM explicitly supports CPUs without VIRTUAL_NMIS and all these CPUs
> are supposedly lacking NMI_WINDOW_EXITING too. Adjust cpu_has_virtual_nmis()
> accordingly.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/capabilities.h | 3 ++-
>  arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 069d8d298e1d..07e7492fe72a 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -82,7 +82,8 @@ static inline bool cpu_has_vmx_basic_inout(void)
>  
>  static inline bool cpu_has_virtual_nmis(void)
>  {
> -       return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
> +       return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
> +               vmcs_config.cpu_based_exec_ctrl & CPU_BASED_NMI_WINDOW_EXITING;
>  }

Oh, a bit offtopic, I see how VMX handles the case of no support of vNMI,
VMX has no IRET intercept, and so it cheats by using regular interrupt window
and assuming that NMI hanlder will not enable normal interrupts....
Oh well....

>  
>  static inline bool cpu_has_vmx_preemption_timer(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1aaec4d19e1b..ce54f13d8da1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2487,10 +2487,12 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>               CPU_BASED_MWAIT_EXITING |
>               CPU_BASED_MONITOR_EXITING |
>               CPU_BASED_INVLPG_EXITING |
> -             CPU_BASED_RDPMC_EXITING;
> +             CPU_BASED_RDPMC_EXITING |
> +             CPU_BASED_INTR_WINDOW_EXITING;
>  
>         opt = CPU_BASED_TPR_SHADOW |
>               CPU_BASED_USE_MSR_BITMAPS |
> +             CPU_BASED_NMI_WINDOW_EXITING |
>               CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
>               CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
>         if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
> @@ -4299,6 +4301,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  {
>         u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
>  
> +       /* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
> +       exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
> +                         CPU_BASED_NMI_WINDOW_EXITING);
> +
>         if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
>                 exec_control &= ~CPU_BASED_MOV_DR_EXITING;
>  

Also makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


